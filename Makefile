HAML=haml
XMLLINT=xmllint --html --nowarning

# option #1
VODAURL=http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307225
VODAIMG1=http://hydro.chmi.cz/hpps/tmp/img/big/307225_H.png
VODAIMG2=http://hydro.chmi.cz/hpps/tmp/img/big/307225_Q.png

VODAURL_MELNIK=http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307081
VODAIMG1_MELNIK=http://hydro.chmi.cz/hpps/tmp/img/big/307081_H.png
VODAIMG2_MELNIK=http://hydro.chmi.cz/hpps/tmp/img/big/307081_Q.png

VODAURL_USTI=http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307228
VODAIMG1_USTI=http://hydro.chmi.cz/hpps/tmp/img/big/307228_H.png
VODAIMG2_USTI=http://hydro.chmi.cz/hpps/tmp/img/big/307228_Q.png

VODAXPATH=//table[@class="stdstationtbl"]/./tr[3]//table/tr[position()>1]

# option #2
#VODAURL=http://vvv.chmi.cz/hydro/detail_stanice/307225.html
#VODAIMG1=http://vvv.chmi.cz/hydro/graph/big/307225_H.png
#VODAIMG2=http://vvv.chmi.cz/hydro/graph/big/307225_Q.png
#VODAXPATH=//table[2]//tr[3]/td//table//tr[position()>1]

DOPRAVAURL=http://www.dpp.cz/povodne-aktualni-doprava/
DOPRAVATMP=/tmp/doprava.html
DOPRAVAXPATH1=string(//div[@id="content-container"]/div[@id="pole"]/div/div[2]//a[starts-with(@title,"Stav dopravy k")]/@href)
DOPRAVAXPATH2=//div[@id="content-container"]/div[@id="pole"]/div/div[2]//*[@class="img-c img-envelope"]/../preceding-sibling::*

all: index.html doprava.html pomoc.html kontakty.html

refresh:
	wget '$(VODAIMG1)' -O data/stav_.png
	wget '$(VODAIMG2)' -O data/prutok_.png
	wget '$(VODAURL)' -O - | $(XMLLINT) --encode utf8 - | $(XMLLINT) --xpath '$(VODAXPATH)' - > data/table_.html
	mv data/stav_.png data/stav.png && mv data/prutok_.png data/prutok.png && mv data/table_.html data/table.html
	wget '$(VODAIMG1_MELNIK)' -O data/stav_melnik_.png
	wget '$(VODAIMG2_MELNIK)' -O data/prutok_melnik_.png
	wget '$(VODAURL_MELNIK)' -O - | $(XMLLINT) --encode utf8 - | $(XMLLINT) --xpath '$(VODAXPATH)' - > data/table_melnik_.html
	mv data/stav_melnik_.png data/stav_melnik.png && mv data/prutok_melnik_.png data/prutok_melnik.png && mv data/table_melnik_.html data/table_melnik.html
	wget '$(VODAIMG1_USTI)' -O data/stav_usti_.png
	wget '$(VODAIMG2_USTI)' -O data/prutok_usti_.png
	wget '$(VODAURL_USTI)' -O - | $(XMLLINT) --encode utf8 - | $(XMLLINT) --xpath '$(VODAXPATH)' - > data/table_usti_.html
	mv data/stav_usti_.png data/stav_usti.png && mv data/prutok_usti_.png data/prutok_usti.png && mv data/table_usti_.html data/table_usti.html

refreshdpp:
	wget $(DOPRAVAURL) -O - | $(XMLLINT) --encode utf8 - > $(DOPRAVATMP)
	wget $$($(XMLLINT) --html --xpath  '$(DOPRAVAXPATH1)' $(DOPRAVATMP)) -O - | convert - data/doprava_.png
	$(XMLLINT) --xpath  '$(DOPRAVAXPATH2)' $(DOPRAVATMP) > data/doprava_.html
	mv data/doprava_.png data/doprava.png && mv data/doprava_.html data/doprava.html
	rm $(DOPRAVATMP)

%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html
