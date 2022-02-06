from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash_operator import BashOperator

#Better to use a Environment Variable here
DBT_PROJECT_DIR = '/usr/local/airflow/dbt'


dag = DAG(
    "dbt_dag",
    start_date=datetime(2021, 1, 1),
    description="Invoke dbt using the BashOperator",
    schedule_interval='@monthly',
    catchup=False,
)

with dag:
    #In case we need to load csv or any raw files into DB, not recommended for big files
    dbt_seed = BashOperator(
        task_id="dbt_seed",
        bash_command=f"dbt seed --profiles-dir {DBT_PROJECT_DIR} --project-dir {DBT_PROJECT_DIR}"
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"dbt run --profiles-dir {DBT_PROJECT_DIR} --project-dir {DBT_PROJECT_DIR}"
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"dbt test --profiles-dir {DBT_PROJECT_DIR} --project-dir {DBT_PROJECT_DIR}"
    )

    dbt_seed >> dbt_run >> dbt_test
