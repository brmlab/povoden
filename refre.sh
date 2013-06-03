#!/bin/sh
if make refresh ; then
  make clean
  make
  echo OK
else
  echo ERROR
fi
