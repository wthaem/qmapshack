


# Style guide for the QMapShack documentation




:::{index} single: Style guide
:::


This style guide defines the terminology, formatting rules, structural conventions, and editorial standards for the QMapShack documentation.  

It's a revised version of a draft obtained with the help of Copilot.

It describes rules for Markdown pages using the Sphinx MyST Markdown extensions.  

For missing style details, consult the [Microsoft writing style guide][MSSTYLE].

Depart from this style guide when doing so improves the content.

## Purpose and scope

- Keep all pages consistent
- Give clear, user‑focused explanations  
- Support long‑term readability  
- Support future Sphinx‑based documentation
- All rules are suggestions. Use them wisely.

## Workflow

1. Follow the rules described on this page.
1. Use [Grammarly][GRAMMARLY] or [LanguageTool][LT] to check the grammar of your texts.
1. Use [Vale][VALE] to check style rules programmatically.

## General writing principles

### Tone and audience
- Write for end users, not developers.  
- Prefer clarity over technical completeness.  
- Use short, direct sentences.  
- Avoid jargon unless defined.

### Terminology
Use consistent terminology:

- **QMapShack**. Never use QMS.
- **Map window**, **workspace**, **project**, **track**, **route**, **waypoint**  
- **Menu**, **toolbar**, **dialog**, **panel**  
- **Elevation data**, **DEM**, **tiles**, **map sources**
- **Image**. Never use the word picture except for real world photographs.

Use a central terminology list and avoid synonyms.



## Format rules

### Markdown style
- Prefer GitHub Flavored Markdown for general content.  
- Use [MyST Markdown extensions][MYST] for:
    - index entries  
    - table of contents  
    - image captions
    - mathematical expressions  
    - admonitions 
- Use UTF-8 text format
- Avoid Markdown footnotes
- Don't use tabs
- Indent with 4 spaces

### Headings
- Use ATX headings only ATX headings start with one or more hashes `#`.  
- No Setext headings (underline-based style).  
- No trailing hashes.  
- No punctuation at the end of headings.  
- Add an empty line after each heading.  
- Use a consistent hierarchy without skipping levels:

    ```
    # Page title
    ## Section
    ### Subsection
    #### Optional deeper level
    ```
- Each page must begin with exactly one top‑level title.  
- Heading texts must be unique.  
- Don't use bold, italic, or other extra formatting inside headings.  
- Use sentence case for all headings.

### Paragraphs
- Use short paragraphs (2–4 sentences).  
- One idea per paragraph.  
- Avoid long text blocks.

### Lists
- Bullet lists for concepts, properties, options. Use only **"-"** or **"*"** as label (first character) of a list item.
- Numbered lists for procedures or workflows.

### UI elements
Use **bold** for UI components:

- **Menu → Submenu → Command**  
- **OK**, **Cancel**, **Apply**  
- **Workspace**, **Map Window**, **Elevation Profile**

Use *italic* only for emphasis or definitions.

Use sentence-style capitalization for menu entries and commands

### Code and filenames
Use backticks:

- Filenames: `qmapshack.exe` (must be ASCII-only and lower-case)
- Paths: `~/.local/share/qmapshack/`  
- Formats: `*.gpx`, `*.fit`, `*.img`  
- Commands: `routino-profile.xml`

Never use bold or italic for code.

User-replaced values are placeholders that the user replaces with values that are relevant for their situation. Use descriptive names for user-replaced values and follow this general format: <value_name>.

Ensure that user-replaced values have the following characteristics:

*    Surrounded by angle brackets (< >)
*    Separated by underscores (_) for multi-word values
*    Lowercase, unless the rest of the related text is uppercase or another capitalization scheme


### Emphasis

- Avoid typographic emphasis almost entirely. Meaning should come from wording, not from visual styling.
- **Bold** for UI elements.  
- *Italic* for emphasis or definitions.



## Images

- Use images sparingly.  
- Crop screenshots to relevant UI areas.  
- Avoid full-window screenshots unless necessary. 
- Use PNG format.  
- Store images in `doc/images` and never online.  
- Avoid version‑specific UI images unless required. 
- Use the form

    `![alt_text](../images/page_name/img_name.png "title_attribute")`

    for an inline image (an image within a paragraph), which is displayed in the flow of the text.
    
    Avoid empty fields.
    
    Use this form of an image in a Markdown page only if it's not a link target. Images defined in this form aren't included in the automatically created list of figures.    
- Use the form
    
    ~~~
    :::{image} ../images/page_name/img_name.png
    :alt: alt_text
    :width: 200px
    :height: 100px
    :align: left
    :::
    ~~~
    
    for block images (structurally similar to a paragraph). Images defined in this form aren't included in the automatically created list of figures.
- Use the form

    ~~~
    :::{figure} ../images/page_name/img_name.png
    :alt: alt_text
    :name: image_name
    :scale: 30%
    :align: center

       Caption text
    :::
    ~~~    
    
    for block images with a caption, numbering, and reference. 
    This directive defines an image as **figure**. It
    include i in the automatically created list of figures
    
- The `img_name` part must be ASCII‑only.  


:::{Hint}
These directives and all other directives and roles aren't defined in standard Markdown. A Markdown browser renders directives and roles as plain text. Build the documentation project with Sphinx and see the built result.
:::


## Tables

- Use tables for structured comparisons or parameter lists.  
- Keep tables simple and readable.  
- Avoid nested formatting inside tables.

**Examples:**

* Table without numbering:

    ~~~
    | Term | Meaning |
    |------|---------|
    | **Track** | Recorded polyline representing movement |
    | **Route** | Planned path computed by a routing engine |
    ~~~
* For a table with numbering and a caption use the form

    ~~~
    :::{table} My table
    :name: my-table
    :widths: auto
    :align: center


    | A | B |
    |---|---|
    | 1 | 2 |
    :::
    ~~~    

    This directive includes the tables in the automatically created list of tables.


## Index

Use MyST block directives:

```
:::{index}
single: Track
pair: Track ; Color
:::
```

or

```
:::{index}
pair: Track ; Editing
:::
```

Rules:

- Index only important, stable concepts.  
- Prefer `single:` entries. Use `pair:` only when grouping improves searchability.  
- Use sentence case for index terms.  
- Avoid formatting (no bold, italic, code).  
- Multi‑word terms should be indexed both as whole and by keyword:

    ```
    single: Elevation profile
    single: Profile ; Elevation
    ```

- Index UI elements only when central to workflows.
* Don't duplicate glossary entries
* Use index entries only for important, stable concepts
* Index only terms that users actively search for, such as core features, workflows, UI elements, and glossary terms.
* Avoid indexing trivial words, temporary features, or internal developer concepts.  
- Place index entries directly after the heading they belong to.



## Page structure

Every documentation page should follow this structure:

1. **Title**  
2. **Short introduction**  
3. **Prerequisites**  
4. **Step‑by‑step instructions**  
5. **Examples**  
6. **Notes / pitfalls**  
7. **Links to related pages**



## Navigation and cross referencing

### Table of contents
- Prefer automatic TOC generation.  
- Manual TOCs must follow heading hierarchy.

### Cross links
- Link related topics consistently.  
- Avoid linking the same term many times in one paragraph.  
- Prefer reference links `[text][ref "..."]` with definitions at the bottom of the page.  
- Avoid long inline `[...](...)` links.
- Use proper slugify rules for the fragment identifier part of a URL. Comment: a fragment identifier is the last part of a URL which is separated from the rest by using a hash sign `#`. Make use of [automatically generated MyST fragment identifiers][SLUGS].

## Menu and UI naming conventions

### Menu paths
Format: **Menu → Submenu → Command**

Example: **File → Import → GPX File**

### Capitalization
* Follow QMapShack UI labels.  
* For conceptual references, use **sentence case**.
* Use sentence-style capitalization for menu entries and commands

    This is the Windows UI sentence‑case rule for menu entries:

    - Capitalize only the first word.  
    - Capitalize proper nouns (Garmin, QMapShack, DEM).  
    - Avoid title case.  
    - Avoid all uppercase.  
    - Use an ellipsis **…** when a command opens a dialog.

    This requirement isn't yet completely and consistently implemented in QMapShack.

    Apply this rule to:

    - Menu bar entries  
    - Context menus  
    - Toolbar dropdowns  
    - Dialog titles  
    - Buttons and UI labels

### Ellipsis usage

Use an ellipsis **…** when a command opens another dialog or prompt before completing the action:

- **Save project as …**  
- **Preferences …**  
- **Create route …**

**Don't** use ellipsis for immediate actions:

- **Save project**  
- **Undo**  
- **Zoom in**

### Verb choice
Use **imperative verbs**:

- **Open project …**  
- **Export data …**  
- **Check for updates**

Avoid gerunds, nouns, passive forms.

#### Recommended verbs

- **Click**: activate GUI elements  
- **Select**: choose from lists  
- **Choose**: pick options in dialogs  
- **Press**: keyboard keys only

#### Examples
| Correct | Wrong |
|--|--|
| **Save project as …** | Save Project As… |
| **Create route …** | Create Route… |
| **Check for updates** | Check For Updates |
| **Garmin map manager …** | Garmin Map Manager… |
| **About QMapShack** | About QMapShack |

#### Buttons and labels

- Use **short, functional labels**.  
- Avoid unnecessary adjectives.  
- Prefer **single‑verb commands** (**Export data**, not **Perform data export**).  
- Keep related commands grouped and named consistently.
- Use bold: **OK**, **Cancel**, **Apply**, **Browse …**



## Image guidelines

Use images only when they:

- Clarify workflows  
- Show complex dialogs  
- Show visual concepts

Avoid images for:

- Simple menu paths  
- Text‑only explanations  
- Frequently changing UI

Image format:

- PNG  
- Crop to relevant area  
- Use consistent theme (light or dark)
- Use Mermaid diagrams if possible. Advantage: diagram data is saved in the Markdown page together with surrounding text.

Image names must be globally unique. To achieve this, add the page name as a prefix to the image name.

## Terminology consistency

Always use glossary terms:

- **Track**, not "path"  
- **Route**, not "planned track"  
- **Waypoint**, not "marker"  
- **Workspace**, not "left panel"

Use **sentence case** everywhere:

- Headings  
- Menu names  
- Button labels  
- Dialog titles  
- Documentation section titles

Avoid synonyms.



## Language rules

- Use clear, simple American English.  
- Prefer active voice:  
    - "QMapShack displays the track"  
    - not "The track is displayed by QMapShack"  
- Avoid unnecessary adjectives.  
- Use consistent spelling.

Preferred spellings:

- command-line  
- left-click  
- online, offline  
- GitHub  
- Markdown  
- Image 


## Versions and maintenance

### Version notes
Place version notes at the **top** of a page or section:

> *Applies to QMapShack ≥ 1.17*  
> *Deprecated in QMapShack 1.16*

### Deprecation
Mark deprecated features clearly.

### Change tracking
When updating a page, check:

- Table of contents (TOC)  
- index  
- cross‑links  
- related pages



## Sphinx compatibility future

To prepare for migration:

- Use consistent Markdown headings  
- Avoid HTML fragments  
- Keep images in structured folders  
- Use relative links  
- Use a central terminology glossary



## Contribution rules

### Pull requests

Use a pull request to submit changes.

### Review
At least one reviewer must check:

- Terminology consistency  
- Formatting compliance  
- UI correctness  
- Image quality

### Style guide compliance

Contributors must follow this guide. 

Reviewers can request changes.



## Appendix: Reviewer checklist for pull requests

### Structure
- Page layout follows standard structure  
- Heading levels correct  
- Paragraphs short and focused

### Terminology
- Glossary terms used  
- Menu paths correct  
- UI elements bold  
- Code formatting correct

### Format rules
- Lists used correctly  
- Images necessary, cropped, captioned  
- Tables simple and readable

### Content quality
- Clear  
- Exact  
- Complete  
- No redundancy

### Version handling
- Version notes present  
- Dependent pages updated  
- Deprecated features marked

### Sphinx compatibility
- Markdown consistent  
- No HTML fragments  
- Image paths correct

### Editorial standards
- User‑focused tone  
- Active voice  
- Simple American English  
- Style guide compliance

### Technical checks
- No broken links  
- Images render correctly  
- Filenames consistent and meaningful

### Reviewer decision
- **Approve**: pull request follows the style guide and improves documentation.    
- **Request changes**:  pull request needs corrections based on checklist items.
- **Reject**: pull request introduces wrong, outdated, or harmful content.



## Appendix: QMapShack menu


### File menu

- **New project…**  
- **Open project…**  
- **Open recent**  
- **Save project**  
- **Save project as…**  
- **Import data…**  
- **Export data…**  
- **Print…**  
- **Quit**



### View menu

- **Show map**  
- **Show elevation profile**  
- **Show workspace**  
- **Show toolbars**  
- **Reset layout**  
- **Zoom in**  
- **Zoom out**  
- **Full extent**



### Edit menu

- **Undo**  
- **Redo**  
- **Cut**  
- **Copy**  
- **Paste**  
- **Delete**  
- **Preferences…**



### Tools menu

- **Create route…**  
- **Create track…**  
- **Create waypoint…**  
- **Measure distance**  
- **Search map…**  
- **Check for updates**  
- **Garmin map manager…**  
- **DEM manager…**



### Map menu

- **Add map source…**  
- **Remove map source**  
- **Reload map sources**  
- **Configure map display…**  
- **Set map opacity…**



### Project menu

- **Add folder…**  
- **Add track…**  
- **Add route…**  
- **Add waypoint…**  
- **Add area…**  
- **Rename item…**  
- **Delete item**  
- **Export item…**



### GPS menu

- **Connect device…**  
- **Disconnect device**  
- **Transfer data to device…**  
- **Receive data from device…**



### Help menu

- **User manual**  
- **Keyboard shortcuts**  
- **Report a bug…**  
- **About QMapShack**


## Issues

This style guide leads to some conflicts between documentation rules and code rules:

* Capitalization of menu entries.
    * Documentation recommends sentence case
    * QMS code capitalizes each word
* Misspelled messages. Some examples found with Vale:
    * 'toolbar' rather than 'tool bar'
    * 'won't' instead of 'will not'
    * Keep one space between words in 'file.  Those'
    * Don't use internet slang abbreviations such as 'imo'
    * Use 'alphanumeric' rather than 'alphanumerical'
    * Try to avoid using first-person plural like 'we'.
    * Use 'click' or 'click in' instead of 'click on'
    * Avoid 'Track Point'
    * Use 'double-click' rather than 'double click'
    * Verify the word 'Aircrafts'
* Consider using the '…' symbol instead of '...'    
* Compose a list of feasible technical terms for use in code and documentation



---

{ref}`General Index <genindex>`        



[MSSTYLE]: https://learn.microsoft.com/en-us/style-guide/welcome "Microsoft writing style guide"
[MYST]:    https://mystmd.org "MyST: Community-driven tools for technical communication"
[SLUGS]:   https://myst-parser.readthedocs.io/en/latest/syntax/optional.html#syntax-header-anchors "Heading anchors"
[GRAMMARLY]: https://www.grammarly.com                                 "Grammarly"
[LT]:      https://languagetool.org/de                                 "LanguageTool"
[VALE]:    https://github.com/vale-cli/vale                            "Vale on GitHub"