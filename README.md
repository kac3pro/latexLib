# Personal LaTeX math library

Shared setup for LuaLaTeX documents using `unicode-math` and STIX Two.

| File | Purpose |
| --- | --- |
| `preamble.tex` | Complete shared setup: fonts, layout, general packages, diagrams, revision colours, bibliography resource/style, footnotes, links, and additional notation. Loads both custom packages. |
| `myMath.sty` | Custom math commands and their immediate dependencies. No page layout or font selection. |
| `myEnvs.sty` | Theorem, definition, remark, and exercise environments. |
| `mrnumber.dbx` | The biblatex data model for MathSciNet numbers. |
| `paper.tex` | Document class, preamble import, paper content, and metadata. |
| `refs.bib` | Bibliography entries. |
| `latex.json` | Editor snippets. |

## Use this repository for another paper

Keep the following files together at the project root:

```text
new-paper/
├── paper.tex               # Your document; choose any filename
├── refs.bib                # Your bibliography; this name is set in preamble.tex
├── preamble.tex
├── myMath.sty
├── myEnvs.sty
├── mrnumber.dbx
├── latexmkrc
├── .vscode/settings.json   # LaTeX Workshop build and preview configuration
└── .gitignore
```

`paper.tex` is an example paper and can be replaced with your own document.
`latex.json` and this README are optional for compilation. `build/`, generated
PDFs, and auxiliary files are not source files and do not need to be copied.
Install STIX Two Text and STIX Two Math on each machine as described under
[Fonts and notation](#fonts-and-notation).

The shared LaTeX files provide the document setup. `latexmkrc` is a configuration
file read by the **latexmk build program**, not by LaTeX. It selects LuaLaTeX,
the output folder, and an optional local Biber executable. latexmk then decides
when to run Biber and how many LaTeX passes are needed to resolve references.
The `.vscode/settings.json` file tells LaTeX Workshop to invoke that build and
where to find its output. `.gitignore` only controls what Git ignores; it does
not decide where the compiler writes files.

On each machine, install a TeX distribution with LuaLaTeX and the packages used
by the preamble, plus latexmk and a compatible Biber. For VS Code, install the
LaTeX Workshop extension and open the cloned project as a folder. A full TeX
installation is the simplest way to supply the package dependencies.

Commit the template files, including `.vscode/settings.json`, before cloning.
A clone contains committed files; it does not copy
untracked files or the ignored `.tools/biber` executable.

Start `paper.tex` with:

```tex
\documentclass[a4paper,10pt]{amsart}
\input{preamble.tex}

\begin{document}
\title{Paper title}
\author{Author name}
\maketitle

\section{Introduction}
Your paper goes here. % Cite an entry from refs.bib with \autocite{key}.

\printbibliography
\end{document}
```

Replace the entries in `refs.bib` with your references. Keep `\printbibliography`
where you want the bibliography to appear in the document.

## Build and output files

Build from the repository root with a TeX installation containing LuaLaTeX,
the packages loaded in `preamble.tex`, and Biber:

```sh
latexmk paper.tex
```

`latexmkrc` selects LuaLaTeX, runs Biber when needed, and repeats LaTeX until
citations and cross-references resolve. Auxiliary files stay in `build/`,
including `.aux`, `.bcf`, `.bbl`, `.fls`, and logs. The final PDF is placed beside
the main `.tex` file: for `paper.tex`, open `paper.pdf` at the project root.
When SyncTeX is enabled, `paper.synctex.gz` also stays beside the PDF so editor
navigation works. latexmk emulates the separate auxiliary directory for TeX Live.

The workspace settings in `.vscode/settings.json` configure LaTeX Workshop to
use this complete build and open the PDF from the project root. Use **Build LaTeX project**
in VS Code or `latexmk paper.tex` for a new paper. A single `lualatex` pass cannot produce a new
bibliography or resolve all citation links.

The bibliography backend is Biber. This checkout has a local Biber 2.21 binary
in `.tools/biber`, which `latexmkrc` uses automatically. `.tools/` is ignored by
Git; on another machine, install Biber through your TeX distribution or place a
compatible executable at `.tools/biber`.

To build without latexmk (with Biber on your `PATH`):

```sh
mkdir -p build
lualatex -output-directory=build paper.tex
biber --input-directory=build --output-directory=build paper
lualatex -output-directory=build paper.tex
lualatex -output-directory=build paper.tex
mv build/paper.pdf paper.pdf
```

With these manual commands, open `paper.pdf` at the project root.

## Fonts and notation

The preamble loads the installed font families `STIX Two Text` and
`STIX Two Math` by name. Fonts are not bundled with this repository.
Math stylistic sets 4, 10, and 11 are retained.

Download the static OpenType desktop fonts from the
[official STIX Two releases](https://github.com/stipub/stixfonts/releases/latest).
Install the regular, italic, bold, and bold italic faces of STIX Two Text,
plus STIX Two Math, using your operating system's font installer. See the
[STIX project website](https://www.stixfonts.org/) for installation information.
Alternatively, install the
[`stix2-otf` package](https://ctan.org/pkg/stix2-otf) through TeX Live or MiKTeX.

On Linux, downloaded `.otf` files can be installed in
`~/.local/share/fonts/`; run `fc-cache -f` afterward. If LuaLaTeX does not find
newly installed fonts, refresh its font database with `luaotfload-tool --update`.

LuaLaTeX and both font families are required; there is no pdfLaTeX or Latin
Modern fallback.

For another document, declare its class and load the preamble. The preamble
already selects `refs.bib` and defines the shared notation:

```tex
\documentclass[a4paper,10pt]{amsart}
\input{preamble.tex}

\begin{document}
\section{Example}
\begin{theorem}\label{thm:example}
  \(\abs{x} \ge 0\) for every \(x\in\R\).
\end{theorem}
See \cref{thm:example}.
\printbibliography
\end{document}
```

The theorem-like environments share a counter numbered within sections:
`theorem`, `observation`, `proposition`, `lemma`, `fact`, `corollary`,
`definition`, `example`, and `remark`. The environments `theorem*`, `question`,
and `notation` are unnumbered. `zadanie` has its own counter; `zadanie*` is
unnumbered.

Existing notation shortcuts are preserved, including overrides of `\a`, `\b`,
`\c`, `\d`, `\l`, `\H`, `\O`, `\text`, `\subset`, and `\supset`. These
replace some standard LaTeX meanings, so use Unicode text for accented letters.
The preamble also defines `\deff` and the two-argument column-vector command
`\vec{x}{y}`, which replaces LaTeX's usual vector accent.
