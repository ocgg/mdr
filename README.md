# MD CLI RENDERER

It's a little app written in ruby that aims to render markdown files in a nice way, directly in the terminal.

I initially started to write it for [nuts](https://github.com/ocgg/nuts), a simple bash script to manage note-taking in markdown using `fzf`. Then I kept doing this in a separate repo, just to see if I could.

## Prerequisites

- ruby (only tested >= 3.3.4, should work down to 3.0)
- `tty-table` gem for table rendering
- `bat` for code blocks rendering
- Any modern terminal (tested on Kitty, Alacritty, gnome-terminal, ...) for RGB colors & link support

```bash
# With ruby installed
gem install tty-table

# Have bat installed with you OS package manager, i.e. :
sudo apt-get install bat # Ubuntu
sudo dnf install bat # Fedora
sudo pacman -S bat # Arch
# ...
```

## Usage

- Clone this repo
- Go to the clone directory
- `ruby main.rb path-to-your-markdown-file`

In the future there will be options, see "Terminal-specific features" below.

## Examples

Example markdown & screen captures soon

## Markdown features

This app (the name's still to be found) aims to render markdown the same way as GitHub would.\
"*The same way*" here means "*the closest vs cleanest possible way*", as the terminal is indeed not a browser.

Here is a list of supported markdown features. To see terminal-specific features, see below.

As for now, it **fully supports** (I think):

- [X] Titles/headings
- [X] Paragraphs
- [X] Unordered/checkbox/mixed lists
- [X] Italic/bold/stroke text
- [X] Code blocks & inline code
- [X] Code syntax highlighting (through `bat`)
- [X] Quotes
- [X] Separators/Horizontal lines

**Partial support** (to be fully supported in the future):

- [X] Newlines inside paragraphs/lists/quotes (works with `\` before newline only)
- [X] Ordered lists (nested lists have unexpected behavior when more than ~26-39 items)
- [X] Tables (dependency to tty-table will be removed in the future to handle that)
- [X] Links to url (link references not supported yet)

**Will support**:

- [ ] Images (if terminal supports them, else display link, or even draw a box with link)
- [ ] Footnotes (won't provide a link but will display nicely)
- [ ] Jump-to-section (same as footnotes)

**Don't know if it will ever be supported**:

- [ ] basic HTML (newlines, comments, strong, em, hr...)

## Terminal-specific features

**Done**:

- Nothing finished here

**Partially done**:

- [X] word-wrap, except in code blocks (not an opt yet)

**Todo**:

- [ ] Opt: clean window before print
- [ ] Opt: max width
- [ ] Opt: print in X columns (with max width or regarding to window size)
- [ ] Opt: layout: left/right/center
- [ ] Opt: left & right margins
