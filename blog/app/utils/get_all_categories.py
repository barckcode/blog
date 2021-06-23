from app.database import get_data_of_table


def all_categories():

    data_of_table = get_data_of_table('categories')

    return data_of_table
