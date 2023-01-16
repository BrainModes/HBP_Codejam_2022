import os
from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider

HTTP = HTTPRemoteProvider()
snake_dir = workflow.basedir


rule all:
	input:
		"sub01denoise.mif"


rule datadownload:
	input:
		HTTP.remote("https://openneuro.org/crn/datasets/ds002087/snapshots/1.0.0/files/sub-01:dwi:sub-01_run-1_dwi.nii.gz", keep_local=True)
	output:
		"sub-01_run-1_dwi.nii.gz"
	run:
		shell("mv {input} sub-01_run-1_dwi.nii.gz")


rule convert:
	input:
		"sub-01_run-1_dwi.nii.gz"
	output:
		"sub01.mif" 
	params:
		i = "sub-01_run-1_dwi.nii.gz",
		o = "sub01.mif"
	container:
		"docker://mrtrix3/mrtrix3"
	shell:
		"mrconvert {params.i} {params.o}"

rule denoise:
	input:
		"sub01.mif"
	output:
		"sub01denoise.mif" 
	params:
		i = "sub01.mif",
		o = "sub01denoise.mif"
	container:
		"docker://mrtrix3/mrtrix3"
	shell:
		"dwidenoise {params.i} {params.o}"
