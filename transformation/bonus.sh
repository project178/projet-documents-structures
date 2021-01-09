#!/bin/bash
#brew install saxon
for book in input/*.odt; do
	path="${book%.odt}";
	mkdir "$path";
	unzip $book -d "$path";
	saxon -s:"$path/content.xml" -xsl:transformation.xsl -o:output/"${path#input/}.xml"
	rm -r "$path";
done;