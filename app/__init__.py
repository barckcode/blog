from flask import Flask

# Internal modules
from .templates_vars import home_template_vars

def create_app():
    app = Flask(__name__)

    return app