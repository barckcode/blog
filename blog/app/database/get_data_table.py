import os
import mysql.connector
from mysql.connector import Error


def get_data_of_table(db_table):
    try:
        connection = mysql.connector.connect(
            host = os.getenv("DB_HOST"),
            database = os.getenv("DB_DATABASE"),
            user = os.getenv("DB_USER"),
            password = os.getenv("DB_PASSWORD"),
        )

        sql_select_query = f"select * from {db_table}"
        cursor = connection.cursor()
        cursor.execute(sql_select_query)
        records = cursor.fetchall()
        print(f"Total number of rows in {db_table} is: {cursor.rowcount}")

        if (connection.is_connected()):
            connection.close()
            cursor.close()
            print("MySQL connection is closed")

        return records

    except Error as e:
        query_error = f"Error al conectarse a la base de datos"
        return query_error
