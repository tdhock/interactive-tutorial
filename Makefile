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
