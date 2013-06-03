HAML=haml
XMLLINT=xmllint

# option #!
DATAURL=http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307225A
IMGURL1=http://hydro.chmi.cz/hpps/tmp/img/big/307225_H.png
IMGURL2=http://hydro.chmi.cz/hpps/tmp/img/big/307225_Q.png
DATAPATH=//table[@class="stdstationtbl"]/./tr[3]//table/tr[position()>1]

# oprion #2
#DATAURL=http://vvv.chmi.cz/hydro/detail_stanice/307225.html
#IMGURL1=http://vvv.chmi.cz/hydro/graph/big/307225_H.png
#IMGURL2=http://vvv.chmi.cz/hydro/graph/big/307225_Q.png
#DATAPATH=//table[2]//tr[3]/td//table//tr[position()>1]

all: index.html doprava.html pomoc.html

refresh:
	wget '$(IMGURL1)' -O data/stav.png
	wget '$(IMGURL2)' -O data/prutok.png
	wget '$(DATAURL)' -O - | $(XMLLINT) --html --encode utf8 - | $(XMLLINT) --html --xpath '$(DATAPATH)' - > data/table.html

%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html
