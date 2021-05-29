#!/bin/bash
#marllus - 27/05/21

cat export.txt | cut -d',' -f1 | sort | uniq -c | sort -r | egrep '\ \/(tecnologia|poesia|sociedade|arte)' | head -4 | sed 's/^\ *//g' | cut -d' ' -f2 | sed 's/^\/.*\///g ; s/\.html//g' > ranking_posts
cat export.txt | cut -d',' -f1,2 | sort | uniq -c | sort -r | egrep '\ \/(tecnologia|poesia|sociedade|arte)' | head -4 | sed 's/^\ .//g' | cut -d',' -f2 | sed 's/^/-\ /g' > ranking_posts_name
sed -i '1 i\Há uma mudança nos artigos em destaque. Segue a lista em ordem decrescente dos mais vistos:' ranking_posts_name

#remove previous featured in posts
find _posts/ -name "*.md" | xargs -n 1 sed -i '/^featured:\ true/d ; /^hidden:\ true/d ; /^rating:\ [1-5]\{1\}/d'

#add new param in featured posts
#featured: true
#hidden: true
#rating: a
a=5
for i in `cat ranking_posts`
  do
	  find _posts/ -name "*$i*" | xargs -n 1 sed -i '3 i featured: true\nhidden: true\nrating: '$a''
  	  ((a--))
  done

