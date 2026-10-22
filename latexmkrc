# LuaLaTeX + Biber (latexmk detects the biblatex backend automatically).
$pdf_mode = 4;
# Keep logs and auxiliary files in build/, with the final PDF at the project root.
$aux_dir = 'build';
$out_dir = '.';
# TeX Live needs latexmk to emulate a separate auxiliary directory.
$emulate_aux = 1;

# Use a compatible project-local Biber when supplied.
use Cwd qw(abs_path);
if (-x '.tools/biber') {
    $biber = '"' . abs_path('.tools/biber') . '" %O %S';
}
