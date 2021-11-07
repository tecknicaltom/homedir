#!/bin/bash
set -eu

INVENTORY=$(
curl -s 'https://www.preciseshooter.com/SuperSales.aspx?c=firearms' | grep -o '/Inventory.aspx?[^"]*' | while read link
do
	item_url="https://www.preciseshooter.com$link"
	echo $(curl -s "$item_url" | perl -ne '$below .= $& if(/\d+% BELOW[^<]*/); $price .= $1 if(/Price:.*(\$[\d,]+\.\d\d)/); $name .= $1 if(/<span><h1>([^<]*)/); END { print "$below - $price - $name\n"}') $item_url
done | grep BELOW )

echo "$INVENTORY" | sort -g | perl -pe 's/$/\n/; s/https/\nhttps/'
echo
echo "$INVENTORY" | perl -pe 's/.*? - //; s/\$(\d),/\$$1/; s/^\$//' | sort -gr | perl -pe 's/$/\n/; s/https/\nhttps/'
