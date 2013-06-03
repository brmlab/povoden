HAML=haml

all: index.html doprava.html

refresh:
	curl 'http://vvv.chmi.cz/hydro/detail_stanice/307225.html' | sed -n '153,302 p' > data/table.html
	wget 'http://vvv.chmi.cz/hydro/graph/big/307225_H.png' -O data/stav.png
	wget 'http://vvv.chmi.cz/hydro/graph/big/307225_Q.png' -O data/prutok.png

%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html
