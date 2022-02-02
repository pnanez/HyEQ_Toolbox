function latex2html() {
    if [ $# -ne 1 ]; then
        echo "Please specify one file"
        return
    fi
    
    # The htlatex command assumes the form
    #
    #    htlatex filename "options1" "option2" "options3" "options4"
    #
    # where "options1" is for the tex4ht.sty and *.4ht style files, 
    #       "option2" is for the tex4ht postprocessor, 
    #       "option3" is for the t4ht postprocessor, and 
    #       "option4" is for the LaTeX compiler.
    echo "Compiling $1"
    htlatex $1 "xhtml,mathml-" " -cmozhtf" "--interaction=nonstopmode" > html_htlatex.log
}

echo "Generating PDFs"
latex2html Example_1_2.tex
latex2html Example_1_3.tex 
latex2html Example_1_4.tex 
latex2html Example_1_5.tex 
latex2html Example_1_6.tex 
latex2html Example_1_7.tex 
latex2html Example_1_8.tex 
latex2html Example_4_0.tex 
latex2html Example_4_1.tex 
latex2html Example_4_2.tex
latex2html Example_4_3.tex
latex2html HyEQ_Toolbox_v204.tex
cat html_htlatex.log