from app.database import get_data_of_table


def all_posts():

    data_of_table = get_data_of_table('all_posts')
    list_data_of_table = reversed(data_of_table)

    return list_data_of_table
