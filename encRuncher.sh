echo $#

for x in "$@"
do
  org=${x%.*}
	nmov=$org".mov"
	nmp4=$org".mp4"
	echo $nmov " -> " $nmp4

	ffmpeg -i $nmov -b:v 25M -c:v h264_nvenc -vf transpose=1 $nmp4
done

echo DONE
