"""Sphinx configuration of the QMapShack documentation. See CREATING_DOCS.md."""

project = "QMapShack"
copyright = "the QMapShack authors"
html_title = "QMapShack documentation"

extensions = ["myst_parser"]
source_suffix = {".md": "markdown"}
root_doc = "index"
exclude_patterns = ["html", "images", "shots", "tools", "CLAUDE.md", "CREATING_DOCS.md", "WRITING_DOCS.md"]

html_theme = "furo"
html_static_path = ["_static"]
html_js_files = ["qms-search.js"]
html_copy_source = False
html_show_sourcelink = False
html_permalinks_icon = "#"

myst_heading_anchors = 3

# WT changes: 
myst_enable_extensions = [
    "amsmath",
    "attrs_inline",
    "colon_fence",
    "deflist",
    "dollarmath",
    "fieldlist",
    "html_admonition",
    "html_image",
    # "linkify",
    "replacements",
    "smartquotes",
    "strikethrough",
    "substitution",
]
