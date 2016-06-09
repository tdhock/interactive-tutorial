HOCKING-handout.pdf: HOCKING-handout.tex
	rm -rf *.aux *.bbl
	pdflatex HOCKING-handout
	pdflatex HOCKING-handout
IntGraph.html: IntGraph.Rmd
	Rscript -e 'rmarkdown::render("IntGraph.Rmd")'
intreg.html: intreg.Rmd
	Rscript -e 'rmarkdown::render("intreg.Rmd")'
introduction-vocabulary.html: introduction-vocabulary.Rmd
	Rscript -e 'rmarkdown::render("introduction-vocabulary.Rmd")'
syllabus.pdf: syllabus.tex
	pdflatex syllabus
tutorial-prop.pdf: tutorial-prop.tex
	pdflatex tutorial-prop
README.pdf: README.tex
	pdflatex README
	pdflatex README
