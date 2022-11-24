#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.1
baseCommand: [mrconvert, -force]
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 1000
  DockerRequirement:
    dockerPull: mrtrix3/mrtrix3
inputs:
  mrtrix3_input:
    type: File
    inputBinding:
      position: 1
  mrtrix3_output:
    type: string
    inputBinding:
      position: 2
outputs:
  nifti_to_mif:
    type: File
    outputBinding:
      glob: sub01.mif





