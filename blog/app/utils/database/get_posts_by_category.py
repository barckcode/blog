from app.database import get_data_of_table


def posts_by_category(category):

    query = "all_posts WHERE category = '" + category + "'"
    data_of_table = get_data_of_table(query)
    data_of_table[-1:-50000]

    return data_of_table
