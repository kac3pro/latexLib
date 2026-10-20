# Personal LaTeX math library

Shared setup for LuaLaTeX documents using `unicode-math` and STIX Two.

| File | Purpose |
| --- | --- |
| `preamble.tex` | Complete shared setup: fonts, layout, general packages, diagrams, revision colours, bibliography resource/style, footnotes, links, and additional notation. Loads both custom packages. |
| `myMath.sty` | Custom math commands and their immediate dependencies. No page layout or font selection. |
| `myEnvs.sty` | Theorem, definition, remark, and exercise environments. |
| `mrnumber.dbx` | The biblatex data model for MathSciNet numbers. |
| `jung.tex` | Document class, preamble import, paper content, and metadata. |
| `refs.bib` | Bibliography entries. |
| `fonts/` | Local STIX Two text/math fonts and their licence. |
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
├── fonts/                  # The five STIX Two .otf files and OFL.txt
├── latexmkrc
├── .vscode/settings.json   # LaTeX Workshop build and preview configuration
└── .gitignore
```

`jung.tex` is an example paper and can be replaced with your own document.
`latex.json` and this README are optional for compilation. `build/`, generated
PDFs, and auxiliary files are not source files and do not need to be copied.
The font files can be omitted only when the same STIX Two fonts are installed
in the TeX distribution.

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

Commit the template files, including `.vscode/settings.json` and the font
licence, before cloning. A clone contains committed files; it does not copy
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
latexmk jung.tex
```

`latexmkrc` selects LuaLaTeX, runs Biber when needed, and repeats LaTeX until
citations and cross-references resolve. All generated files stay in `build/`,
including `jung.pdf`, `jung.synctex.gz`, `.aux`, `.bcf`, `.bbl`, and logs. For a
document called `paper.tex`, the PDF is `build/paper.pdf`.

The workspace settings in `.vscode/settings.json` configure LaTeX Workshop to
use this complete build and open the PDF from `build/`. Use **Build LaTeX project**
in VS Code or `latexmk paper.tex` for a new paper. A single `lualatex` pass cannot produce a new
bibliography or resolve all citation links.

The bibliography backend is Biber. This checkout has a local Biber 2.21 binary
in `.tools/biber`, which `latexmkrc` uses automatically. `.tools/` is ignored by
Git; on another machine, install Biber through your TeX distribution or place a
compatible executable at `.tools/biber`.

To build without latexmk (with Biber on your `PATH`):

```sh
mkdir -p build
lualatex -output-directory=build jung.tex
biber --input-directory=build --output-directory=build jung
lualatex -output-directory=build jung.tex
lualatex -output-directory=build jung.tex
```

With these manual commands, open `build/jung.pdf`.

## Fonts and notation

The font setup first looks for these files in `fonts/`:

```text
fonts/STIXTwoText-Regular.otf
fonts/STIXTwoText-Italic.otf
fonts/STIXTwoText-Bold.otf
fonts/STIXTwoText-BoldItalic.otf
fonts/STIXTwoMath-Regular.otf
```

The bundled fonts include their licence in `fonts/OFL.txt`. When local files
are absent, the setup uses the same STIX Two fonts from the TeX installation.
Math stylistic sets 4, 10, and 11 are retained. To use another location, define
`\STIXTwoTextPath` and/or `\STIXTwoMathPath` before loading the preamble;
include a trailing slash in each path. LuaLaTeX is required; there is no pdfLaTeX
or Latin Modern fallback.

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
