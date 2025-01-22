# Md Cli Renderer

Restructurer l'app comme suit:

- Main class (= controller), le point d'entrée
- Main envoie le fichier brut au Parser qui stocke un array de Block 
- Les Blocks sont: paragraphe, list, title etc.

  - Chaque Block a un un contenu et ses propres variables d'instance
  - Chaque type de Block (Paragraph, List etc.) hérite de Block
  - Le contenu est un array de Text, ou un hash (dans le cas d'une liste: arborescence)
  - Le contenu est formaté dans la classe Block
  - Chaque Text a des styles (normal / bold, italic) et un contenu

- Main envoie les Blocks du Parser au Renderer qui:

  - Gère le rendu chaque type de Block
  - Incorpore les séquences d'échappement dans les Text
  - Retourne un array de string à Main

- Main affiche les lignes selon les options passées en ligne de commande

## REFACTOs

- text: utiliser String:partition au lieu de .match (lisibilité)
- tous les (?:.(?:\\\n)?)* (+ 2 espaces + `<br>`)

## TODO NEXT

- mettre dans une constante globale: WIDTH
- meilleurs tableaux
- Mieux gérer les retours à la ligne: \&nbsp; à la place du dernier espace avant le dernier char d'un titre, et pour inline code decoration, parenthèses, points, etc
- ignorer les commentaires `<!-- -->`
- wanted newlines avec soit `\`, soit 2 espaces, soit `<br>`
- ord list: tab de 3 espaces, pas 2
- lists: mêmes indentations du texte quel que soit le type de liste

### MD features

- links variables
- images (si supporté, sinon lien)
- liens vers fichiers ?
- footnotes
- contenu caché à dérouler (afficher mais comment ?)

## BUGFIXES

- doublons de séquence de NOSTYLE

## TODO DANS LONGTEMPS

- Checker si `bat` disponible (sinon utiliser l'autre truc natif, là)
- sur 2 colonnes, les links risquent de poser problème
- TESTS: ça devrait être facile à écrire.
- option pour afficher les longues notes sur 2 colonnes si termwidth > 160
- inline style: checker ça: "**,,,**c. s**,,,** censé rendre ",,,c. s,,," en gras
