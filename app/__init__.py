from flask import Flask

# Internal modules
from .templates_vars import home_template_vars
from .utils import post_markdown_data, post_markdown_metadata

def create_app():
    app = Flask(__name__)

    return app