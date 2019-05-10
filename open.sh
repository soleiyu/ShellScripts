
echo $@

for x in "$@"
do
	xdg-open "$x" >&/dev/null
done

