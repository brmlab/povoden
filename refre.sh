#!/bin/sh
wget 'http://hydro.chmi.cz/hpps/popup_hpps_prfdyn.php?seq=307225' -O index.html
mkdir -p tmp/img/big
wget 'http://hydro.chmi.cz/hpps/tmp/img/big/307225_H.png' -O tmp/img/big/307225_H.png
wget 'http://hydro.chmi.cz/hpps/tmp/img/big/307225_Q.png' -O tmp/img/big/307225_Q.png
