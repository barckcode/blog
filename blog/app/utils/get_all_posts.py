from app.database import get_data_of_table


def all_posts():

    data_of_table = get_data_of_table('all_posts')
    data_of_table[-1:-50000]

    return data_of_table
