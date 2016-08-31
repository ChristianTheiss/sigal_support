#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
SOURCEDIR="/mnt/DATEN/Bilder/Archiv"
DESTDIR="/var/www/html"
WEBBASE="\/var\/www\/html"
TMPFILE=$DESTDIR/_index.html
DSTFILE=$DESTDIR/index.html

cat build_header.txt > $TMPFILE

for i in $(ls $SOURCEDIR | sort -r); do
	#check if it is a directory
	if [ ! -d "$SOURCEDIR/$i" ]; then
		continue;
	fi
	#check if it has to be build
	if [ ! -f "$SOURCEDIR/$i/_nosigal" ]; then
		sigal build --title "$i" --verbose "$SOURCEDIR/$i" "$DESTDIR/$i" 
	fi

	echo "        <a href=\"./$i/\">" >> $TMPFILE
	echo "          <div class=\"menu-img thumbnail\">" >> $TMPFILE
	echo -n "          <img src=\"" >> $TMPFILE
	find "$DESTDIR/$i" | grep -i "thumbnails/.*.jpg" | sort | head -1 | sed "s/^""$WEBBASE""//g" | tr -d '\n' >> $TMPFILE
	echo "\" class=\"album_thumb\" alt=\"$i\" title=\"$i\" />" >> $TMPFILE
	echo "            <span class=\"album_title\">$i</span>" >> $TMPFILE
	echo "          </div>" >> $TMPFILE
	echo "        </a>" >> $TMPFILE
done

cat build_footer.txt >> $TMPFILE

cp $TMPFILE $DSTFILE

IFS=$SAVEIFS

