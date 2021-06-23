import markdown
import markdown.extensions.fenced_code, markdown.extensions.meta

"""
Function to extract the markdown information from the file
"""
def post_markdown_data(path_of_post):
    readme_file = open(path_of_post, "r").read()
    md_template_string = markdown.markdown(
        readme_file, extensions=["fenced_code", "meta"]
    )

    return md_template_string
