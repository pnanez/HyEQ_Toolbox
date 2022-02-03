function latex2html() {
    if [ $# -ne 1 ]; then
        echo "Please specify one file"
        return
    fi
    
    echo "Compiling $1 to PDF"

    # See this StackOverflow answer for details about translating MATLAB code 
    # into HTML: 
    #   https://tex.stackexchange.com/questions/631906/include-matlab-code-listing-compiled-into-html-with-correct-colors
    # 
    make4ht -c config.cfg --output-dir ../../doc/html $1
}

echo "Generating HTML"
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
latex2html HyEQ_Toolbox.tex