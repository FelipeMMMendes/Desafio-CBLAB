from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

# Função Python que será executada pela DAG
def say_hello():
    print("Hello, Airflow!")

# Definição da DAG
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
}

with DAG(
    dag_id="hello_airflow",
    default_args=default_args,
    description="Uma DAG simples para testar o Airflow",
    schedule_interval=None,  # DAG só roda manualmente
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    # Tarefa única que executa a função say_hello
    hello_task = PythonOperator(
        task_id="say_hello_task",
        python_callable=say_hello,
    )

# Definir a sequência das tarefas
hello_task
