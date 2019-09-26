TEMPDIR := $(shell mktemp -d -t tmp.XXX)

publish:
	echo 'publishing site!'
	cp -r ./_site/* $(TEMPDIR)
	cd $(TEMPDIR) && \
	ls -a  && \
	git init && \
	git add . && \
	git commit -m 'publish site' && \
	git remote add origin https://https://github.com/snap-stanford/cs224w-notes.git && \
	git push origin master:refs/heads/gh-pages --force
