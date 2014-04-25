#curl -O ftp://ftp.mutt.org/mutt/devel/mutt-1.5.23.tar.gz
tar xvzf mutt-1.5.23.tar.gz
cd mutt-1.5.23
CPPFLAGS=-I/opt/local/include/ LDFLAGS=-L/opt/local/lib/ ./configure --prefix=/usr/local --with-curses --with-regex --enable-locales-fix \
    --enable-pop --enable-imap --enable-smtp --enable-hcache --with-ssl
make
sudo make install
