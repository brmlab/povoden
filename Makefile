HAML=haml

all: index.html doprava.html pomoc.html

refresh:
	curl 'http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307225' | sed -n '154,333 p' > data/table.html
	wget 'http://hydro.chmi.cz/hpps/tmp/img/big/307225_H.png' -O data/stav.png
	wget 'http://hydro.chmi.cz/hpps/tmp/img/big/307225_Q.png' -O data/prutok.png

%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html
