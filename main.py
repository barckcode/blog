from flask import render_template
import markdown
import markdown.extensions.fenced_code, markdown.extensions.meta

# Internal modules
from app import home_template_vars
from app import create_app

# Init APP
app = create_app()

# Data
home_data = home_template_vars()


########## Router and Views ##########
@app.route('/')
def home_page():
    return render_template(
        'home.html.j2',
        title = home_data[0],
        presentation = home_data[1],
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
    texto = "Estas en la página de Blog"

    path_of_post = "app/static/posts/" + post + ".md"

    readme_file = open(path_of_post, "r").read()
    md_template_string = markdown.markdown(
        readme_file, extensions=["fenced_code", "meta"]
    )

    # Test:
    md = markdown.Markdown(extensions = ['meta'])

    return render_template(
        'layouts/post.html.j2',
        data = md.Meta,
        md_template_string = md_template_string,
    )


@app.route('/about')
def about_page():
    texto = "Estas en la página de About"
    return render_template(
        'about.html.j2',
        texto=texto,
    )
