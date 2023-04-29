#!/bin/sh
# previews font file (like fontpreview, but with more symbols)
# [just https://github.com/sdushantha/fontpreview with saner defaults for me]
#
# krzysckh 2023
# krzysckh.org

sxiv=sxiv

bgcolor="#ffffff"
fgcolor="#000000"
text="ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890\nż ź ć ń ł ś ą ó ę\n-> => () []"

while [ "$#" -gt 0 ]
do
  case "$1" in
    -b)
      bgcolor="$2"
      shift
      ;;
    -f)
      fgcolor="$2"
      shift
      ;;
    -s)
      sxiv="$2"
      shift
      ;;
    -h)
      echo "$0 -b color -f color -s color font.ttf"
      exit 1
      ;;
    -n)
      sxiv="cat"
      ;;
    *)
      fname="$1"
      ;;
  esac
  shift
done

convert -size 532x365 xc:"$bgcolor" \
  -verbose \
  -gravity center \
  -pointsize 38 \
  -font "$fname" \
  -fill "$fgcolor" \
  -annotate +0+0 "$text" \
  -flatten \
  /tmp/_fp.png >/dev/null

$sxiv /tmp/_fp.png
rm /tmp/_fp.png
