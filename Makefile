index.html: slides.md
	  pandoc -s -f markdown -t html5 -o "$@" "$<"

reveal:
	curl -LO https://github.com/hakimel/reveal.js/archive/master.zip
	bsdtar --strip-components=1 -xvf master.zip
	rm master.zip
	rm demo.html
