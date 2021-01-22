from flask import render_template

# Internal modules
from app import create_app


app = create_app()


@app.route('/')
def home_page():
    title = "Bienvenid@! 🖖🏾"
    presentation = "Por ir directo al grano te aviso que aquí se habla de sistemas Linux, Docker, Kubernetes, IaC, Python y todo lo que tenga que ver con Infraestructura. Acompañame en este loco camino entre Devs y Ops 🤪"

    return render_template(
        'home.html.j2',
        title = title,
        presentation = presentation,
    )


@app.route('/blog')
def blog_page():
    texto = "Estas en la página de Blog"
    return render_template('blog.html.j2', texto=texto)


@app.route('/about')
def about_page():
    texto = "Estas en la página de About"
    return render_template('about.html.j2', texto=texto)
