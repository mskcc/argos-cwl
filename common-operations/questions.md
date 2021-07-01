---
description: Some unanswered questions
---

# Questions

* ~~How would we submit an array of records through command line \(such as the pair variable in pair-workflow-sv.cwl or~~ [~~https://github.com/mskcc/argos-cwl/blob/master/modules/pair/maf-processing-pair.cwl~~](https://github.com/mskcc/argos-cwl/blob/master/modules/pair/maf-processing-pair.cwl)~~\)?~~ Nikhil solved this
* ~~How to submit a list/array through CWL toil-cwl-runner command line arguments? How to submit to~~ [~~`--bams`~~](running-cwl-in-command-line.md#example-run)~~? Maybe as a json/yaml-type formatted string?~~ The simplest solution is to rewrite the CWL
* The reference file isn't working for some reason when passed [here](running-cwl-in-command-line.md#example-run). Why?
* It's possible we can use `cwltool --make-template` to build input yamls for CWL we need, but some CWL's run into a parsing error. This likely needs a `cwltool`fix, so this is a harder task. See [https://github.com/common-workflow-language/cwltool/issues/1404](https://github.com/common-workflow-language/cwltool/issues/1404)
* How to connect Github readme files directly to Gitbook?



