#!/bin/bash -ex

command -v gs > /dev/null || {
  echo "gs(ghostscript) is not found">&2
  exit 1
}

command -v curl > /dev/null || {
  echo "curl is not found">&2
  exit 1
}

BASE=https://www.oreilly.co.jp/library/4873112699/
TMPDIR="$(mktemp -d)"

curl -s "$BASE" | grep -oP '(?<=f=")[^h\.].*.pdf(?=")' | sed "s_^_${BASE}_g" | while read i
do
  curl "$i" -o "$TMPDIR/$[cnt++].pdf"
done

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=gnu-make-book.pdf $(ls -tr "$TMPDIR"|sed "s_^_${TMPDIR}/_g")
rm -rf "$TMPDIR"
