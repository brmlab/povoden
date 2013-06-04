.PHONY : clean refresh 

HAML=haml
XMLLINT=xmllint --html --nowarning

# expand as needed
VODASTATIONS=307225 307081 307228

# option #1
VODAURL=http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=$(STATION)
VODAIMG1=http://hydro.chmi.cz/hpps/tmp/img/big/$(STATION)_H.png
VODAIMG2=http://hydro.chmi.cz/hpps/tmp/img/big/$(STATION)_Q.png
VODAXPATH=//table[@class="stdstationtbl"]/./tr[3]//table/tr[position()>1]

# option #2
#VODAURL=http://vvv.chmi.cz/hydro/detail_stanice/$(STATION).html
#VODAIMG1=http://vvv.chmi.cz/hydro/graph/big/$(STATION)_H.png
#VODAIMG2=http://vvv.chmi.cz/hydro/graph/big/$(STATION)_Q.png
#VODAXPATH=//table[2]//tr[3]/td//table//tr[position()>1]

DOPRAVAURL=http://www.dpp.cz/povodne-aktualni-doprava/
DOPRAVATMP=/tmp/doprava.html
DOPRAVAXPATH1=string(//div[@id="content-container"]/div[@id="pole"]/div/div[2]//a[starts-with(@title,"Stav dopravy k")]/@href)
DOPRAVAXPATH2=//div[@id="content-container"]/div[@id="pole"]/div/div[2]//*[@class="img-c img-envelope"]/../preceding-sibling::*

# function
get-voda = \
echo Station $(STATION) \
wget '$(VODAIMG1)' -O data/stav_$(STATION).png_;  \
wget '$(VODAIMG2)' -O data/prutok_$(STATION).png_; \
wget '$(VODAURL)' -O - | $(XMLLINT) --encode utf8 - | $(XMLLINT) --xpath '$(VODAXPATH)' - > data/table_$(STATION).html_; \
$(foreach FILE,data/stav_$(STATION).png data/prutok_$(STATION).png data/table_$(STATION).html,mv -v $(FILE)_ $(FILE);)

all: index.html doprava.html pomoc.html kontakty.html

refresh:
	$(foreach STATION,$(VODASTATIONS), $(call get-voda) )
	sed -i 's/@stations\s*=.*/@stations=[$(foreach STATION,$(VODASTATIONS), $(STATION)\, )]/' index.haml

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
