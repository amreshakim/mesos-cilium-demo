all: 	tar
	vagrant up
tar: 	clean
	tar czvf allfiles.tar.gz -C files .
clean:
	rm allfiles.tar.gz
