HAML=haml
XMLLINT=xmllint

DATAPATH=//table[@class="stdstationtbl"]/./tr[3]//table/tr[position()>1]

all: index.html doprava.html

refresh:
	wget 'http://hydro.chmi.cz/hpps/tmp/img/big/307225_H.png' -O data/stav.png
	wget 'http://hydro.chmi.cz/hpps/tmp/img/big/307225_Q.png' -O data/prutok.png
	$(XMLLINT) --html --encode utf8 http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307225 --output data/307225.html
	$(XMLLINT) --html --xpath '$(DATAPATH)' data/307225.html > data/table.html


%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html

fail:
	false
