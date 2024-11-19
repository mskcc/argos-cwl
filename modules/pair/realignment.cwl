#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: realignment
requirements:
    MultipleInputFeatureRequirement: {}
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
    InlineJavascriptRequirement: {}
    StepInputExpressionRequirement: {}

inputs:
    bams:
        type: File[]
        secondaryFiles:
            - ^.bai
    normal_name: string
    tumor_name: string
    ref_fasta:
        type: File
        secondaryFiles:
          - .amb
          - .ann
          - .bwt
          - .pac
          - .sa
          - .fai
          - ^.dict
    intervals: string[]
    hapmap:
        type: File
        secondaryFiles:
            - .idx
    dbsnp:
        type: File
        secondaryFiles:
            - .idx
    indels_1000g:
        type: File
        secondaryFiles:
            - .idx
    snps_1000g:
        type: File
        secondaryFiles:
            - .idx
    covariates: string[]
    abra_ram_min: int
outputs:
    covint_list:
        type: File
        outputSource: combine_intervals/mergedfile
    covint_bed:
        type: File
        outputSource: list2bed/output_file
    qual_metrics:
        type: File[]
        outputSource: parallel_printreads/qual_metrics
    qual_pdf:
        type: File[]
        outputSource: parallel_printreads/qual_pdf
    outbams:
        type: File[]
        secondaryFiles:
            - ^.bai
        outputSource: parallel_printreads/out
steps:
    split_intervals:
      in:
        interval_list: intervals
      out: [ intervals, intervals_id]
      run:
          class: ExpressionTool
          id: split_intervals
          requirements:
              - class: InlineJavascriptRequirement
          inputs:
            interval_list: string[]
          outputs:
            intervals:
                type:
                    type: array
                    items:
                        type: array
                        items: string
            intervals_id: string[]
          expression: "${ var intervals = [];
            var intervals_id = [];
            var output_object = {};
            var interval_list = inputs.interval_list;
            while( interval_list.length > 0 ) {
                var interval_split = interval_list.splice(0, 10);
                intervals.push(interval_split);
                intervals_id.push(interval_split.join('_'));
            }
            output_object['intervals'] = intervals;
            output_object['intervals_id'] = intervals_id;
            return output_object;
          }"
    gatk_find_covered_intervals:
        run: ../../tools/gatk.FindCoveredIntervals/3.3-0/gatk.FindCoveredIntervals.cwl
        in:
            intervals_list: intervals
            reference_sequence: ref_fasta
            coverage_threshold:
                valueFrom: ${ return ["3"];}
            minBaseQuality:
                valueFrom: ${ return ["20"];}
            intervals: split_intervals/intervals
            input_file: bams
            out: split_intervals/intervals_id
        scatter: [intervals, out]
        scatterMethod: dotproduct
        out: [fci_list]
    combine_intervals:
        in:
            files: gatk_find_covered_intervals/fci_list
            normal_name: normal_name
            tumor_name: tumor_name
            output_filename:
                valueFrom: ${ return inputs.tumor_name + "." + inputs.normal_name + ".fci.list"; }
        out: [mergedfile]
        run:
            class: CommandLineTool
            baseCommand: ['cat']
            id: combine_intervals
            stdout: $(inputs.output_filename)

            requirements:
                InlineJavascriptRequirement: {}
                MultipleInputFeatureRequirement: {}

            inputs:
                files:
                    type: File[]
                    inputBinding:
                        position: 1
                output_filename: string
            outputs:
                mergedfile:
                    type: stdout
    list2bed:
        run: ../../tools/list2bed/1.0.1/list2bed.cwl
        in:
            input_file: combine_intervals/mergedfile
            output_filename:
                valueFrom: ${ return inputs.input_file.basename.replace(".list", ".bed"); }
        out: [output_file]
    abra:
        run: ../../tools/abra/2.17/abra.cwl
        in:
            abra_ram_min: abra_ram_min
            in: bams
            ref: ref_fasta
            out:
                valueFrom: ${ return inputs.in.map(function(x){ return x.basename.replace(".bam", ".abra.bam"); }); }
            targets: list2bed/output_file
        out: [outbams]
    index_bams:
        run: ../../tools/cmo-utils/1.9.15/cmo-index.cwl
        in:
            bam: abra/outbams
        scatter: [bam]
        scatterMethod: dotproduct
        out: [bam_indexed]
    gatk_base_recalibrator:
        run: ../../tools/gatk.BaseRecalibrator/3.3-0/gatk.BaseRecalibrator.cwl
        in:
            reference_sequence: ref_fasta
            input_file: index_bams/bam_indexed
            dbsnp: dbsnp
            hapmap: hapmap
            indels_1000g: indels_1000g
            snps_1000g: snps_1000g
            knownSites:
                valueFrom: ${return [inputs.dbsnp,inputs.hapmap, inputs.indels_1000g, inputs.snps_1000g]}
            covariate: covariates
            out:
                valueFrom: ${ return "recal.matrix"; }
            read_filter:
              valueFrom: ${ return ["BadCigar"]; }
        out: [recal_matrix]

    parallel_printreads:
        in:
            input_file: index_bams/bam_indexed
            reference_sequence: ref_fasta
            BQSR: gatk_base_recalibrator/recal_matrix
        out: [out,qual_metrics,qual_pdf]
        scatter: [input_file]
        scatterMethod: dotproduct
        run:
            class: Workflow
            id: parallel_printreads
            inputs:
                input_file: File
                reference_sequence: File
                BQSR: File
            outputs:
                out:
                    type: File
                    secondaryFiles:
                        - ^.bai
                    outputSource: gatk_print_reads/out_bam
                qual_metrics:
                    type: File
                    outputSource: quality_metrics/qual_file
                qual_pdf:
                    type: File
                    outputSource: quality_metrics/qual_hist
            steps:
                gatk_print_reads:
                    run: ../../tools/gatk.PrintReads/3.3-0/gatk.PrintReads.cwl
                    in:
                        reference_sequence: reference_sequence
                        BQSR: BQSR
                        input_file: input_file
                        num_cpu_threads_per_data_thread:
                            valueFrom: ${ return "5"; }
                        emit_original_quals:
                            valueFrom: ${ return true; }
                        baq:
                            valueFrom: ${ return ['RECALCULATE'];}
                        out:
                            valueFrom: ${ return inputs.input_file.basename.replace(".bam", ".printreads.bam");}
                    out: [out_bam]
                quality_metrics:
                    run: ../../tools/picard.CollectMultipleMetrics/2.9/picard.CollectMultipleMetrics.cwl
                    in:
                      I: gatk_print_reads/out_bam
                      REFERENCE_SEQUENCE: reference_sequence
                      PROGRAM:
                        valueFrom: ${return ["null","MeanQualityByCycle"]}
                      O:
                        valueFrom: ${ return inputs.I.basename.replace(".bam", ".qmetrics")}
                    out: [qual_file, qual_hist]
