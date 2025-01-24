# H1: main title

## H2: big title

### H3: less big title

#### H4: Subtitle or something

##### H5: Little       title

###### H6: Is it a *title* ?

Another syntax for H1
=====================

...And for H2
---

## Paragraphs

A simple paragraph. Newlines inside paragraphs,\
are made using `\` then go newline. Or just do another paragraph.\
Newlines with double-space or `<br>` will be handled soon.

You can indeed use *italic*, **bold**, ***both***, inline code which will preserve spaces & `**special chars**`, ~underlines~ (this indeed is not true, as there is no underlines in markdown... but you can strike out as shown). [Links are also supported](https://www.perdu.com).

## Tables

| This is | an actual | Taabeeeeeuuuul |
|:--------|:---------:|---------------:|
| With | random | columns |
| just **to be     sure** | *that*          it | `works` |
| And | it | should |

## Code blocks

```
{

  learning: "Markdown",

  showing: "block code snippet with empty lines"

}
```

```js
const x = "Block code snippet in JS";
console.log(x);

// Another deliberately long line
array.reduce((acc, sum) => { (sum * 1524039 + x >= random_variable && document.getElementByID(`is-this-really-my-element-id`).innerText != 'Heeeeell yeah') ? console.log("Yeah, yeah, yeah") : alert("Whoever uses alerts anyway ?") })
```

## Lists

### Unordered

- I ain't got:
  * no home
  * ~no shoes~
    - Then *what have I got* ?
    - What I have got that **nobody can take away** ?

### Ordered

1. **Major scale modes**
  1. Ionian
  2. Dorian
  2. Phrygian
  4. Note: roman numbers are not fully handled yet.
    2. They would show `xxxxx` for 50th item yet
    2. As for 3 levels-deep alphabetical lists : they would i.e. show `}` for 27th item yet (GH would show "aa")
    2. (Who writes 50 items lists in markdown anyway ?)
2. **Minor melodic scale modes**
  - You can mix list styles
  - (Who knows these modes names anyway ?)

### Checkboxes

- You should open an issue if :
  - [ ] You do write 50 items lists in markdown
  - [x] You do know the names of minor melodic scale modes

## Quote blocks

> I love you babe, but I hate your dirty ways\
When I'm leaving this town I'm going away to stay
> > *See, see      rider*
> >
> > *See what you've done*
> > ...

## Links

Texte avant, [**premier**     lien](https://www.perdu.com), milieu, [deuxième\
lien](https://www.sonelec.com),    and [how it goes if the link text is soooooo long that it takes one or several lines ??](https://www.perdu.com)

---
