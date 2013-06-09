.PHONY: clean refresh refreshdpp

HAML=haml
XMLLINT=xmllint --html --nowarning

# expand as needed
VODASTATIONS=307225 307081 307228

# option #1
VODAURL=http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=$(STATION)
VODAIMG1=http://hydro.chmi.cz/hpps/tmp/img/big/$(STATION)_H.png
VODAIMG2=http://hydro.chmi.cz/hpps/tmp/img/big/$(STATION)_Q.png
VODATMP=/tmp/voda.html
VODAXPATH=//table[@class="stdstationtbl"]/./tr[3]//table/tr[position()>1]
VODALEGENDXPATH=//table[@class="stdstationtbl"]/./tr[2]/td/table/./tr[1]/td/table/./tr
VODANAMESXPATH=//table[@class="stdstationtbl"]/./tr[1]//table/./tr[2]/td/text()

# option #2
#VODAURL=http://vvv.chmi.cz/hydro/detail_stanice/$(STATION).html
#VODAIMG1=http://vvv.chmi.cz/hydro/graph/big/$(STATION)_H.png
#VODAIMG2=http://vvv.chmi.cz/hydro/graph/big/$(STATION)_Q.png
#VODAXPATH=//table[2]//tr[3]/td//table//tr[position()>1]

DOPRAVAURL=http://www.dpp.cz/povodne-aktualni-doprava/
DOPRAVATMP=/tmp/doprava.html
DOPRAVAXPATH1=string((//div[@id="content-container"]/div[@id="pole"]/div/div[2]//a[starts-with(@title,"Stav dopravy k")]/@href)[last()])
DOPRAVAXPATH2=//div[@id="content-container"]/div[@id="pole"]/div/div[2]//*[@class="img-c img-envelope"]/../preceding-sibling::*
DOPRAVAXPATH3=//div[@id="pole"]//*[starts-with(text(),"Stav městské")]/following-sibling::*

CESTYURL=http://www.praha.eu/jnp/cz/home/magistrat/tiskovy_servis/tiskove_zpravy/prehled_uzavrenych_komunikaci.html
CESTYXPATH=string(//div[@id="content"]//a[text() = "Mapka"]/@href)

# function
get-doprava = \
echo ; echo Doprava ; \
wget $(DOPRAVAURL) -O - | $(XMLLINT) --encode utf8 - > $(DOPRAVATMP) ; \
wget $$($(XMLLINT) --html --xpath  '$(DOPRAVAXPATH1)' $(DOPRAVATMP)) -O - | convert -density 150 - data/doprava_.png && mogrify -resize 1200x1200 data/doprava_.png ; \
$(XMLLINT) --xpath  '$(DOPRAVAXPATH2)' $(DOPRAVATMP) > data/doprava_.html ; \
mv data/doprava_.png data/doprava.png && mv data/doprava_.html data/doprava.html ; \
rm $(DOPRAVATMP) ; \

get-doprava-noimg = \
echo ; echo Doprava ; \
wget $(DOPRAVAURL) -O - | $(XMLLINT) --encode utf8 - > $(DOPRAVATMP) ; \
$(XMLLINT) --xpath  '$(DOPRAVAXPATH3)' $(DOPRAVATMP) > data/doprava_.html ; \
echo "Doprava byla obnovena." | convert -background  none  -undercolor lightblue  -fill blue -pointsize 18   text:-  -trim +repage -bordercolor lightblue  -page 1200x95+500+10   -background lightblue  -flatten data/doprava_.png ; \
mv data/doprava_.png data/doprava.png && mv data/doprava_.html data/doprava.html ; \
rm $(DOPRAVATMP) ; \

get-cesty = \
echo ; echo Cesty ; \
wget $$($(XMLLINT) --xpath '$(CESTYXPATH)' $(CESTYURL)) -O - | convert -density 150 - data/cesty_.png && mogrify -resize 1500x1500 data/cesty_.png ; \
mv data/cesty_.png data/cesty.png ; \

get-voda = \
echo; echo *Station $(STATION)* ; \
wget '$(VODAIMG1)' -O data/stav_$(STATION).png_;  \
wget '$(VODAIMG2)' -O data/prutok_$(STATION).png_; \
wget '$(VODAURL)' -O - | $(XMLLINT) --encode utf8 - > $(VODATMP); \
$(XMLLINT) --xpath '$(VODAXPATH)' $(VODATMP) > data/table_$(STATION).html_; \
$(XMLLINT) --xpath '$(VODALEGENDXPATH)' $(VODATMP) > data/legend_$(STATION).html_; \
$(XMLLINT) --xpath '$(VODANAMESXPATH)' $(VODATMP) > data/name_$(STATION).html_; \
$(foreach FILE,stav_$(STATION).png prutok_$(STATION).png table_$(STATION).html name_$(STATION).html legend_$(STATION).html,mv -v data/$(FILE)_ data/$(FILE);) \
rm $(VODATMP);

all: index.html doprava.html pomoc.html kontakty.html cesty.html

refresh:
	$(foreach STATION,$(VODASTATIONS), $(call get-voda) )
	sed -i 's/@stations\s*=.*/@stations=[$(foreach STATION,$(VODASTATIONS), $(STATION)\, )]/' index.haml

refreshdpp:
	$(call get-doprava-noimg)

refreshcesty:
	$(call get-cesty)

%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html
