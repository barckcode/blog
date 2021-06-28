from flask import Flask
from flask_share import Share
import os


# Internal modules
from .templates_vars import home_template_vars
from .utils import post_markdown_data, post_markdown_metadata, last_posts, all_posts, all_categories, posts_by_category, ContactForm, send_message
from .database import get_data_of_table


def create_app():
    # App
    app = Flask(__name__)

    # Secret key for validate Forms
    app.secret_key = os.getenv("SECRET_KEY_FORM")

    # Init social share component:
    share = Share()
    share.init_app(app)

    return app
