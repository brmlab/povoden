HAML=haml
XMLLINT=xmllint --html --nowarning

# option #1
DATAURL=http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307225
IMGURL1=http://hydro.chmi.cz/hpps/tmp/img/big/307225_H.png
IMGURL2=http://hydro.chmi.cz/hpps/tmp/img/big/307225_Q.png
DATAPATH=//table[@class="stdstationtbl"]/./tr[3]//table/tr[position()>1]

# oprion #2
#DATAURL=http://vvv.chmi.cz/hydro/detail_stanice/307225.html
#IMGURL1=http://vvv.chmi.cz/hydro/graph/big/307225_H.png
#IMGURL2=http://vvv.chmi.cz/hydro/graph/big/307225_Q.png
#DATAPATH=//table[2]//tr[3]/td//table//tr[position()>1]

DOPRAVAURL=http://www.dpp.cz/povodne-aktualni-doprava/
DOPRAVATMP=/tmp/doprava.html
DOPRAVAXPATH1=string(//div[@id="content-container"]/div[@id="pole"]/div/div[2]//a[text()="zde"]/@href)
DOPRAVAXPATH2=//div[@id="content-container"]/div[@id="pole"]/div/div[2]//*[@class="img-c img-envelope"]/../preceding-sibling::*

all: index.html doprava.html pomoc.html kontakty.html

refresh:
	wget '$(IMGURL1)' -O data/stav.png
	wget '$(IMGURL2)' -O data/prutok.png
	wget '$(DATAURL)' -O - | $(XMLLINT) --encode utf8 - | $(XMLLINT) --xpath '$(DATAPATH)' - > data/table.html

refreshdpp: 
	wget http://www.dpp.cz/povodne-aktualni-doprava/ -O - | $(XMLLINT) --encode utf8 - > $(DOPRAVATMP)
	wget $$($(XMLLINT) --html --xpath  '$(DOPRAVAXPATH1)' $(DOPRAVATMP)) -O - | convert - data/doprava.png 
	$(XMLLINT) --xpath  '$(DOPRAVAXPATH2)' $(DOPRAVATMP) > data/doprava.html
	rm $(DOPRAVATMP)

%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html
