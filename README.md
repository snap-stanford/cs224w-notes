# cs224w-notes

CS224W course notes.

## Contributing

The notes are written in Markdown and are compiled into HTML using Jekyll. Please add your changes directly to the Markdown source code. This repo is configured without any extra Jekyll plugins so it can be compiled directly by GitHub Pages. Thus, any changes to the Markdown files will be automatically reflected in the live website.

To make any changes to this repo, first fork this repo. Make the changes you want and push them to your own forked copy of this repo. Finally, go back to the GitHub website to create a pull request to bring your changes into the `snap-stanford/cs224w-notes` repo.

If you want to test your changes locally before pushing your changes to the `master` branch, you can run Jekyll locally on your own machine. In order to install Jekyll, you can follow the instructions posted on their website (https://jekyllrb.com/docs/installation/). Then, do the following from the root of your cloned version of this repo:
1) Make whatever changes you want to the Markdown `.md` files.
2) `rm -r _site/`  # remove the existing compiled site
3) `jekyll serve`  # this creates a running server
4) Open your web browser to where the server is running and check the changes you made.

### Notes about writing math equations

- Start and end math equations with `$$` **for both inline and display equations**! To make a display equation, put one newline before the starting `$$` a newline after the ending `$$`.

- Avoid vertical bars `|` in any inline math equations (ie. within a paragraph of text). Otherwise, the GitHub Markdown compiler interprets it as a table cell element (see GitHub Markdown spec [here](https://github.github.com/gfm/)). Instead, use one of `\mid`, `\vert`, `\lvert`, or `\rvert` instead. For double bar lines, write `\|` instead of `||`.