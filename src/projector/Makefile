all: metrunuionline.swf

metrunuionline.swf:
	printf '%s' 'Array(function(WIDTH, HEIGHT, LSO) {' > metrunuionline.as
	cat ../shared/metrunuionline.as >> metrunuionline.as
	printf '\n%s' '})[0].call(this, 800, 600, true);' >> metrunuionline.as
	makeswf \
		-c -1 \
		-v 6 \
		-s 800x600 \
		-r 24 \
		-b FFFFFF \
		-o metrunuionline.swf \
		metrunuionline.as
	rm metrunuionline.as metrunuionline.swf.*
