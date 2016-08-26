#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
SOURCEDIR="/mnt/DATEN/Bilder/Archiv"
DESTDIR="/var/www/html"
WEBBASE="\/var\/www\/html"

BUILDLOG="/var/www/buildlog.txt"

date > $BUILDLOG

cat build_header.txt > $DESTDIR/index.html

for i in $(ls $SOURCEDIR); do
	#check if it is a directory
	if [ ! -d "$SOURCEDIR/$i" ]; then
		continue;
	fi
	#check if it has to be build
	if [ ! -f "$SOURCEDIR/$i/_nosigal" ]; then
		date >> $BUILDLOG
		sigal build --title "$i" --verbose "$SOURCEDIR/$i" "$DESTDIR/$i" 
	fi

	echo "        <div class=\"menu-img thumbnail\">" >> $DESTDIR/index.html
	echo "          <a href=\"./$i/index.html\">" >> $DESTDIR/index.html
	echo -n "          <img src=\"" >> $DESTDIR/index.html
	find "$DESTDIR/$i" | grep -i "thumbnails/.*.jpg" | sort | head -1 | sed "s/^""$WEBBASE""//g" | tr -d '\n' >> $DESTDIR/index.html
	echo "\" class=\"albumb_thumb\" alt=\"$i\" title=\"$i\" /></a>" >> $DESTDIR/index.html
	echo "          <span class=\"album_title\">$i</span>" >> $DESTDIR/index.html
	echo "        </div>" >> $DESTDIR/index.html
done

cat build_footer.txt >> $DESTDIR/index.html

date >> $BUILDLOG

IFS=$SAVEIFS

