from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

#definindo os default_args para a dag
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
}

#definindo a dag
with DAG(
    dag_id="etl_api_erp",
    default_args=default_args,
    description="Dag para consumir uma requisição API do ERP ",
    schedule_interval=None,  # DAG só roda manualmente
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    #montando a dag
    hello_task = PythonOperator(
        task_id="say_hello_task",
        python_callable=say_hello,
    )

#sequencia das tasks
hello_task
