# H1: Main title

## H2: Big title

### H3: Less big title

#### H4: Subtitle or something

##### H5: Little       title

###### H6: Is it a *title* ?

Another syntax for H1,\
that allows newlines in a title
=====================

...The same,\
for a 2nd level heading
---

Here is a separator to... separate the example titles above from the real titles below:

---

## Paragraphs

A simple paragraph.\
Newlines inside paragraphs, are made using "\" then go newline. Or just do another paragraph.

You can use *italic*, **bold**, ***both***, `inline code` (which will preserve spaces & special chars), ~strikethrough~ and [links](https://github.com/ocgg/md_cli_renderer).\
These are also usable in titles, tables, quotes etc.

## Tables

First line | are headers | and they're bold
:--------|:---------:|---------------:
left-aligned column | centered | right-aligned
...

## Code blocks

```
Here whitespaces,     and **special chars**,\
are kept as is. Note also that long lines will not be word-wrapped in a code block.
```

```ruby
def show_syntax_highlighting
    # If specified, the language appears at the top right of that block.
    # Until I make something more user-friendly, you can change options passed
    # to bat in lib/blocks/codeblock.rb (i.e. theme, show line number etc.)
    msg = "bat is a really cool tool that can highlight code in the terminal"

    {msg:, link: "https://github.com/sharkdp/bat"}
end
```

## Lists

### Unordered (with Nina Simone)

- I ain't got:
  * no home
  * ~no shoes~
    - Then *what have I got* ?
    - What I have got that **nobody can take away** ?

### Ordered (with some music theory)

1. **Major scale modes**
   1. Ionian
   2. Dorian
      1) And so on.
      2) these alphabetic sublist works weirdly after "z" for now, but who writes lists that long anyway?
2. **Minor melodic scale modes**
   - You can mix list styles
   - (Who knows these modes names anyway?)

### Checkboxes

- You should open an issue if :
  - [ ] You do write 50 items lists in markdown
  - [x] You do know the names of minor melodic scale modes
  - [X] You find that unicode characters for checkboxes suck. I'll try to find something better.

## Quote blocks (with Big Bill Broonzy)

> I love you babe, but I hate your dirty ways\
When I'm leaving this town I'm going away to stay
> > *See, see rider*
> >
> > *See what you've done*
> > ...
