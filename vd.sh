echo $1

ffmpeg -i $1"f.mp4" -vf transpose=3 -metadata:s:v:0 rotate=0 $1"fr".mp4
ffmpeg -i $1"r.mp4" -vf transpose=3 -metadata:s:v:0 rotate=0 $1"rr".mp4
ffmpeg -i $1"s.mp4" -vf transpose=3 -metadata:s:v:0 rotate=0 $1"sr".mp4

ffmpeg	-i $1"sr.mp4" -i $1"fr.mp4" -i $1"sr.mp4" -filter_complex "
		nullsrc=size=3240x1920 [base];
		[0:v] setpts=PTS-STARTPTS, scale=1080x1920 [left];
		[1:v] setpts=PTS-STARTPTS, scale=1080x1920 [center];
		[2:v] setpts=PTS-STARTPTS, scale=1080x1920 [right];
		[base][left] overlay=shortest=1 [tmp1];
		[tmp1][center] overlay=shortest=1:x=1080 [tmp2];
		[tmp2][right] overlay=shortest=1:x=2160
	" $1".mp4"
