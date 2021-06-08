#!/bin/bash
#marllus.com

#Take date
dateToday=$(date +%d%m%Y)
echo $dateToday

#move file to folder categories and rename with .md
cd _posts/agendados/
rm -rf logs_publicados
for i in `ls -1`
  do
	  dataArquivo=$(ls $i | sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\).*/\3\2\1/g')
	  if [ "$dateToday" = "$dataArquivo" ]; then
		  pasta=$(cat $i | grep categories | sed 's/^categories\:\ //g')
		  FILE=logs_publicados
        	  if [ ! -f "$FILE" ]; then
			  echo "Artigos publicados hoje:" > logs_publicados
			  cat $i | grep title | sed 's/^title\:\ /- /g' >> logs_publicados
        	  else
          		  cat $i | grep title | sed 's/^title\:\ /- /g' >> logs_publicados
        	  fi
		  echo "movendo $i para pasta $pasta"
		  mv $i ../$pasta/$i
	  fi
  done
