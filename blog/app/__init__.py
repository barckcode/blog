from flask import Flask
from flask_share import Share

# Internal modules
from .templates_vars import home_template_vars
from .utils import post_markdown_data, post_markdown_metadata, last_posts, all_posts, all_categories, posts_by_category
from .database import get_data_of_table

def create_app():
    # App
    app = Flask(__name__)

    # Init social share component:
    share = Share()
    share.init_app(app)

    return app
