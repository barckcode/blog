from flask import render_template

# Internal modules
from app import create_app, home_template_vars, post_markdown_data, post_markdown_metadata, get_data_of_table

# Init APP
app = create_app()

# Data
home_data = home_template_vars()
records_data = get_data_of_table("linux_posts")

########## Router and Views ##########
@app.route('/')
def home_page():
    return render_template(
        'home.html.j2',
        title = home_data[0],
        presentation = home_data[1],
        records_data = records_data
    )


@app.route('/blog')
def blog_page():
    texto = "Estas en la página de Blog"

    return render_template(
        'blog.html.j2',
        texto = texto,
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


@app.route('/about')
def about_page():
    texto = "Estas en la página de About"
    return render_template(
        'about.html.j2',
        texto=texto,
    )

    # TEST
    # print('*' * 20)
    # print(md.Meta)
    # print('*' * 20)