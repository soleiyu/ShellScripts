#! /bin/bash

echo $1
#cd $1*

rm dura
dr=0

ffprobe $1* -hide_banner -show_entries format >> dura
while read line ; do
	if [ `echo ${line} | grep 'duration'` ] ; then
		array=( `echo ${line} | tr -s '=' ' '`)
		array=( `echo ${array[1]} | tr -s '.' ' '`)
		dr=${array[0]}
		break
	fi
done < dura
echo $dr

div=`echo "scale=2; ($dr - 1)  / 100.0" | bc`
echo $div

echo resize
for num in `seq -f %03g 0 99`
do
	pos=`echo "scale=2; $div * $num + 1" | bc`
	echo pos$pos / $dr
	ffmpeg -ss "$pos" -t 1 -r 1 -i $1* -f image2 ss"$num".png >& /dev/null
	convert ss$num.png -resize 400x c$num.png
done

for ((i=0 ; i<10 ; i++))
do
	convert +append c0$i* l$i.png
	echo l$i
done

convert -append l* sums.png
echo s0

rm c*
rm l*
rm ss*

cp sums.png ../s$1.png
