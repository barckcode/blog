from pathlib import Path
import markdown
import markdown.extensions.meta

"""
Function to extract the markdown metadata from the file
"""
def post_markdown_metadata(path_of_post):
    post_file = Path(path_of_post)
    data_of_post = post_file.read_text(encoding='utf-8')
    md = markdown.Markdown(extensions = ['meta'], output_format='html5')
    html = md.convert(data_of_post)
    metadata = md.Meta

    return metadata