

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#

doap:release:
- class: doap:Version
  doap:name: merge-insert-size-histograms
  doap:revision: 1.0.0
- class: doap:Version
  doap:name: cwl-wrapper
  doap:revision: 1.0.0

dct:creator:
- class: foaf:Organization
  foaf:name: Memorial Sloan Kettering Cancer Center
  foaf:member:
  - class: foaf:Person
    foaf:name: Allan Bolipata
    foaf:mbox: mailto:bolipatc@mskcc.org

cwlVersion: v1.0

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 8000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-roslin-qc:0.6.1

class: CommandLineTool
baseCommand: [merge_insert_size_histograms]
id: merge-insert-size-histograms
stdout: $(inputs.outfile_name)
inputs:
  files:
    type:
      type: array
      items:
        type: array
        items: File
    inputBinding:
      prefix: --files
  outfile_name:
    type: string
    inputBinding:
      prefix: --output
outputs:
  output:
    type: File
    outputBinding:
      glob: |-
        ${
          if (inputs.outfile_name)
            return inputs.outfile_name;
          return null;
         }