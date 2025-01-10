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

## TODO VITE

- cf bugfixes

## TODO NEXT

- H1 & h2 peuvent être sur 2 lignes avec /title\n=+/ ou /title\n-+/
- \&nbsp; à la place du dernier espace avant le dernier char d'un titre
- inline codeblock avec backticks dedans: ``inline_code(`with backticks`);``
- meilleurs tableaux

### MD features

- rendu de listes
  - ordonnée
  - checkboxes
- blockquotes
- links
- links variables
- Gérer les images avec des liens
- liens vers fichiers ?

## BUGFIXES

- inline styles: content_to_line à revoir & corriger

## TODO DANS LONGTEMPS

- inline style: checker ça: "**,,,**c. s**,,,** censé rendre ",,,c. s,,," en gras
- TESTS: ça devrait être facile à écrire.
- afficher les longues notes sur 2 colonnes si termwidth > 160
