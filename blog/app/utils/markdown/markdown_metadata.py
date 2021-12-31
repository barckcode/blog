from pathlib import Path
import markdown
import markdown.extensions.meta

"""
Function to extract the markdown metadata from the file
"""
def post_markdown_metadata(get_post):
    data_of_post = get_post.text
    md = markdown.Markdown(extensions = ['meta'], output_format='html5')
    html = md.convert(data_of_post)
    metadata = md.Meta

    return metadata
