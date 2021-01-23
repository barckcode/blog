from flask import render_template
import markdown
import markdown.extensions.fenced_code


# Internal modules
from app import create_app


app = create_app()


@app.route('/')
def home_page():
    title = "Bienvenid@! 🖖🏾"
    presentation = "Quizá ya lo sepas. Pero aquí se habla de sistemas Linux, Docker, Kubernetes, IaC, Python y todo lo que tenga que ver con Infraestructura. Acompañame en este loco camino entre Devs y Ops 🤪"

    return render_template(
        'home.html.j2',
        title = title,
        presentation = presentation,
    )


@app.route('/blog')
def blog_page():
    texto = "Estas en la página de Blog"

    readme_file = open("app/static/posts/bash/bash_cheat_sheet.md", "r")
    md_template_string = markdown.markdown(
        readme_file.read(), extensions=["fenced_code"]
    )

    return render_template(
        'blog.html.j2',
        texto = texto,
        md_template_string = md_template_string,
    )


@app.route('/about')
def about_page():
    texto = "Estas en la página de About"
    return render_template(
        'about.html.j2',
        texto=texto,
    )
