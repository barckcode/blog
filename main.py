from flask import render_template

# Internal modules
from app import create_app


app = create_app()

@app.route('/')
def homepage():
    texto = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    return render_template('home.html.j2', texto=texto)
