# Create the .tex and .m files in the Matlab2tex*/ directories.
matlab -batch "RebuildTexFiles"

# Compile the LaTeX documents.
latexmk  -output-directory=../../doc -output-format=pdf -aux-directory=artifacts Example*.tex HyEQ_Toolbox.tex

# Cleanup extra files.
rm ../../doc/*.fls
