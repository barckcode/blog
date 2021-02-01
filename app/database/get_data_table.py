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

        return records

    except Error as e:
        query_error = f"Error reading data from MySQL {db_table} table: {e}"
        return query_error

    finally:
        if (connection.is_connected()):
            connection.close()
            cursor.close()
            print("MySQL connection is closed")
