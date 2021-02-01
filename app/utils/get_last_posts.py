from app.database import get_data_of_table


def last_posts():

    data_of_table = get_data_of_table('all_posts')
    last_data_of_table = [data_of_table[-1], data_of_table[-2], data_of_table[-3]]

    return last_data_of_table