# Creating the documentation

The sources are `doc/index.md` and `doc/pages/*.md`. `doc/html/` is generated and committed, so nobody
needs these tools to build QMapShack or read its help. F1 shows `doc/html/`.

Pictures are covered by [WRITING_DOCS.md](WRITING_DOCS.md).

## Setting up

You need Python 3.9 or newer, nothing else: no QMapShack build and no setup of your own. On Windows
install it from python.org, which brings the `py` launcher.

## Changing a page

1. Edit the page in `doc/pages/`. A new page also goes into the list in `doc/index.md`.
2. Generate the pages. Run this in the top folder of your QMapShack checkout.

   Linux and macOS:

   ```
   python3 doc/tools/generate_html.py
   ```

   Windows:

   ```
   py doc\tools\generate_html.py
   ```

   The first run creates `.doc-venv` in the checkout and installs the tools into it; that needs
   internet access. Any Sphinx warning fails the run and `doc/html/` stays as it was. The message
   names the file and line.

   In a QMapShack build tree, `cmake --build build --target doc` (or `ninja doc`) does the same.
3. Check the result: open `doc/html/index.html` in a browser, or press F1 in a QMapShack built from
   this checkout.
4. Commit the sources, the pictures and `doc/html/` in one pull request.

## Index entries

Put one above the section it belongs to. `Main; sub` gives a two-level entry:

````
```{index} single: Track; filter
```

## Track filters
````

## Links and pictures

Link to another page by its file: `[Concepts](concepts.md)`. A broken link fails the run.

A picture is `![](../images/<page>/<name>.png)`. It displays on GitHub too, unlike a `{figure}` block.

## A conflict in doc/html

Two pull requests can both change generated files, usually `searchindex.js`. Merge the sources, then
generate again and commit.

Linux and macOS:

```
git checkout --theirs -- doc/html
python3 doc/tools/generate_html.py
git add doc/html
```

Windows:

```
git checkout --theirs -- doc/html
py doc\tools\generate_html.py
git add doc/html
```

## Testing this branch

Build QMapShack from this branch and press F1. Check that:

- pages, pictures, the sidebar, search and Index work
- the help follows light and dark (`--color-scheme light|dark`, or switch the desktop scheme)

Report what you find in discussion #1209, with your OS and Qt version.
