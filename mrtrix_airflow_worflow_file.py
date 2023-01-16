from airflow import DAG
import os
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
from airflow.operators.docker_operator import DockerOperator
from docker.types import Mount 
default_args = {
'owner'                 : 'airflow',
'description'           : 'Download MRI data and convert from nifti to mif using mrtrix3 mrconvert',
'depend_on_past'        : False,
'start_date'            : datetime(year=2022, month=11, day=1),
'email_on_failure'      : False,
'email_on_retry'        : False,
'retries'               : 1,
'retry_delay'           : timedelta(minutes=0.1)
}
with DAG('mrtrix_dag', default_args=default_args, schedule_interval="5 * * * *", catchup=False) as dag:
    t1 = BashOperator(
    task_id='download_mri_data',
    bash_command='wget https://openneuro.org/crn/datasets/ds002087/snapshots/1.0.0/files/sub-01:dwi:sub-01_run-1_dwi.nii.gz; mv sub-01\:dwi\:sub-01_run-1_dwi.nii.gz ~/Downloads'
)
    t2 = DockerOperator(
    task_id='docker_command',
    image='mrtrix3/mrtrix3',
    api_version='auto',
    auto_remove=True,
    command="mrconvert /bids_dataset/sub-01:dwi:sub-01_run-1_dwi.nii.gz /bids_dataset/sub01.mif",
    mounts=[
        Mount(
            source='/home/'+os.getlogin()+'/Downloads', 
            target='/bids_dataset', 
            type='bind'
        )
    ],
    docker_url="unix://var/run/docker.sock",
    network_mode="bridge"
)

t1 >> t2
