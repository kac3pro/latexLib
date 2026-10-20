# LuaLaTeX + Biber (latexmk detects the biblatex backend automatically).
$pdf_mode = 4;
# Keep the PDF, SyncTeX, logs, and auxiliary files out of the source directory.
$out_dir = 'build';

# Use a compatible project-local Biber when supplied.
use Cwd qw(abs_path);
if (-x '.tools/biber') {
    $biber = '"' . abs_path('.tools/biber') . '" %O %S';
}
