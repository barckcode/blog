from flask import render_template

# Internal modules
from app import create_app

app = create_app()

@app.route('/')
def homepage():
    return render_template('home.html')
