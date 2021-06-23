from flask import render_template

# Internal modules
from app import create_app, home_template_vars, post_markdown_data, post_markdown_metadata, last_posts, all_posts, all_categories, posts_by_category

# Init APP
app = create_app()

# Data
home_data = home_template_vars()
records_data = last_posts()
all_records_data = all_posts()
all_categories = all_categories()


########## Router and Views ##########
@app.route('/')
def home_page():
    return render_template(
        'home.html.j2',
        title = home_data[0],
        presentation = home_data[1],
        records_data = records_data,
        categories = all_categories
    )


@app.route('/blog')
def blog_page():
    return render_template(
        'blog.html.j2',
        records_data = reversed(all_records_data),
        categories = all_categories
    )


@app.route('/blog/<path:post>')
def blog_post(post):
    path_of_post = "app/static/posts/" + post + ".md"

    post_data = post_markdown_data(path_of_post)
    post_metadata = post_markdown_metadata(path_of_post)

    return render_template(
        'layouts/post.html.j2',
        post_metadata = post_metadata,
        post_data = post_data,
    )


@app.route('/category/<path:category>')
def blog_category(category):
    posts = posts_by_category(category)

    return render_template(
        'blog.html.j2',
        records_data = reversed(posts),
        categories = all_categories,
    )


@app.route('/about')
def about_page():
    return render_template(
        'about.html.j2',
    )

#TEST
# print('*' * 20)
# print(all_records_data)
# print('*' * 20)