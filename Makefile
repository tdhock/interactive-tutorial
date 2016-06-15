IntGraph.html: IntGraph.Rmd
	Rscript -e 'rmarkdown::render("IntGraph.Rmd")'
syllabus.pdf: syllabus.tex
	pdflatex syllabus
tutorial-prop.pdf: tutorial-prop.tex
	pdflatex tutorial-prop
README.pdf: README.tex
	pdflatex README
	pdflatex README
