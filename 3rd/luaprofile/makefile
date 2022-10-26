
all: macosx

macosx:
	clang -undefined dynamic_lookup --shared -Wall -DUSE_RDTSC -g -O2 \
		-o profile.so \
		imap.c profile.c

linux:
	gcc -shared -fPIC -Wall -g -O2 -DUSE_RDTSC \
		-I /root/lua-5.4.3/src \
		-o profile.so \
		imap.c profile.c icallpath.c

clean:
	rm -rf profile.so

.PHONY : all clean macosx linux