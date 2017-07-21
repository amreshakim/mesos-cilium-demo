all: 	tar
	vagrant up
tar: 	clean
	tar czvf allfiles.tar.gz -C files .
clean:
	$(RM) allfiles.tar.gz
