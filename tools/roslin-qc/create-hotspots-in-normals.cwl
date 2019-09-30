#/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand: [create_hotspots_in_normal]
id: create-hotspots-in-normal

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 16000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-roslin-qc:0.6.1

doc: |
  None

inputs:

  fillout_file:
    type: File
    inputBinding:
      prefix: --fillout_file

  project_prefix:
    type: string
    inputBinding:
      prefix: --project_prefix

  pairing_file:
    type: File
    inputBinding:
      prefix: --pairing_file

outputs:
  hs_in_normals:
    type: File?
    outputBinding:
      glob: |
        ${
          return inputs.project_prefix + "_HotspotsInNormals.txt";
        }
