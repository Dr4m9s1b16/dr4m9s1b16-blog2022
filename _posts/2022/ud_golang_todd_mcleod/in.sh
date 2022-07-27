#/bin/bash

read -p "filename: " file
read -p "filepath 03/13_3: " fp
read -p "start loop: " sl
read -p "End loop: " el


for i in $( seq $sl $el )
do
  printf "![dockerengine]({{ site.baseurl }}/post_img/2022/$fp/$i.png)\n
" >> $file
done


$SHELL
