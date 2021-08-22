function latex2html() {
    if [ $# -ne 1 ]; then
        echo "Please specify one file"
        return
    fi
    #htlatex Example_1_2.tex "xhtml,mathml-" " -cmozhtf" "-cvalidate" > html_htlatex.log
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