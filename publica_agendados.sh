#!/bin/bash
#marllus.com

#Take date
dateToday=$(date +%d%m%Y)
echo $dateToday

#move file to folder categories and rename with .md
cd _posts/agendados/
for i in `ls -1`
  do
	  dataArquivo=$(ls $i | sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\).*/\3\2\1/g')
	  if [ "$dateToday" = "$dataArquivo" ]; then
		  pasta=$(cat $i | grep categories | sed 's/^categories\:\ //g')
		  echo "movendo $i para pasta $pasta"
		  mv $i ../$pasta/$i.md
	  fi
  done
