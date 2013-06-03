HAML=haml
XMLLINT=xmllint

all: index.html doprava.html

get:
	curl 'http://vvv.chmi.cz/hydro/detail_stanice/307225.html' > data/307225.html
	wget 'http://vvv.chmi.cz/hydro/graph/big/307225_H.png' -O data/stav.png
	wget 'http://vvv.chmi.cz/hydro/graph/big/307225_Q.png' -O data/prutok.png

scrap: get
	xmllint --html --encode utf8 data/307225.html --output data/307225.html
	xmllint --html --xpath '//div[@class="box"]/div[@class="cont"]/p[2]/text()' data/307225.html > data/timestamp.html
	xmllint --html --xpath '//div[@class="box"]/div[@class="cont"]/table[2]//table[5]/tr[position()>1]' data/307225.html > data/table.html
#	xmllint --html --xpath '//div[@class="box"]/div[@class="cont"]/table[2]//table[3]//tr' data/307225.html | iconv -f cp1250 -t utf8 > data/legend.html
#	xmllint --html --xpath '//div[@class="box"]/div[@class="cont"]/table[2]//table[1]//tr' data/307225.html | iconv -f cp1250 -t utf8 > data/info.html

refresh: get scrap

%.html: %.haml
	$(HAML) $< $@

clean:
	rm -f *.html
