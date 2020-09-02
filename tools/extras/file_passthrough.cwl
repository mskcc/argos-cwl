cwlVersion: v1.0
class: ExpressionTool
id: file-passthrough
requirements:
  InlineJavascriptRequirement: {}

inputs:
    files:
        type:
            type: array
            items: File


outputs:
    output_files:
        type:
            type: array
            items: File

expression: |
    ${ var output_files = [];
        var input_files = inputs.files;
        for (var i = 0; i < input_files.length; i++) {
            output_files.push(input_files[i]);
        }
        return {
            'output_files': output_files
        };
    }
