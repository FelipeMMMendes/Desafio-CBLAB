from airflow import DAG
from airflow.decorators import task
from airflow.operators.python import PythonOperator
from datetime import datetime
from FileUtils import FilesUtils
import logging
import requests

#definindo os default_args para a dag
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
}

@task
def create_temp_dir():
    file_util = FilesUtils()
    
    path = file_util.create_tmp_dir()
    
    return path

#fingindo que esse é um END POINT da API     
API_END_POINT = "https://drive.google.com/uc?id=1IFoFg_2B1A7gHukyaP92QX6EAt2FTZNs"  

@task
def download_file(diretorio):
    
    # Baixar o arquivo da API
    response = requests.get(API_END_POINT)
    response.raise_for_status()  # Lança uma exceção para erros HTTP

    file_path = f"{diretorio}/arquivo_baixado.json"
    
    # Escrever o conteúdo do arquivo baixado
    with open(file_path, 'wb') as f:
        f.write(response.content)
    
    logging.info(f"Arquivo salvo em: {file_path}")

#definindo a dag
with DAG(
    dag_id="etl_api_erp",
    default_args=default_args,
    description="Dag para consumir uma requisição API do ERP ",
    schedule_interval=None,  # DAG só roda manualmente
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    
    create_dir_task = create_temp_dir()
    consome_api_task = download_file(create_dir_task)
    
#sequencia das tasks
create_dir_task >> consome_api_task
