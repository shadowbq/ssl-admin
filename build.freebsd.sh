#!/bin/sh -x

if [ "`uname`" != "FreeBSD" ]; then
	echo
	echo
	echo "The build script needs utilities which only reside on FreeBSD."
	echo "Please run this utility on a FreeBSD system."
	echo
	echo
	exit 1
fi

MAJVER=1
MINVER=1

### Get REVISION from SVN
svn update
REVISION=0
DIR=ssl-admin-$MAJVER.$MINVER.$REVISION


## Make directory - if it's there, delete it so we can start fresh.
if [ -d $DIR ]; then
	rm -rf $DIR
fi
mkdir $DIR

## Copy file over.
cp -r man1 man5 Makefile openssl.conf ssl-admin ssl-admin.conf $DIR
#mkdir $DIR/scripts && cp configure $DIR/scripts/
find $DIR -type d -name .svn | xargs rm -rf  

echo "Updating Makefile for FreeBSD..."
sed -i "" "s+VARETC+/usr/local/etc+g" $DIR/Makefile
sed -i "" "s+VARBIN+/usr/local/bin+g" $DIR/Makefile
sed -i "" "s+VARMAN+/usr/local/man+g" $DIR/Makefile
sed -i "" "s+SEDCMD+sed -i \"\"+g" $DIR/Makefile
echo "Creating distfile..."
tar -czf $DIR.tar.gz $DIR

### Update version number in the ports Makefile
mkdir -p diff_build/freebsd_port/
cp -R ports/* diff_build/freebsd_port/
echo
echo "Make certain you have a current copy of security/ssl-admin in your ports"
echo "tree, as it will be copied now.  If not, re-run this utility after updating"
echo "your tree to pull it in here."
echo
rm -rf diff_build/ssl-admin
cp -R /usr/ports/security/ssl-admin diff_build/ssl-admin
find diff_build -type d -name work | xargs rm -rf
sed -e "s+~~~VERSION~~~+$MAJVER.$MINVER.$REVISION+g" -e "s+~~~DATE~~~+`date`+" ports/Makefile > diff_build/freebsd_port/Makefile
find diff_build/ -type d -name .svn | xargs rm -rf  
echo "Making checksum file..."
cd diff_build/freebsd_port && make DISTDIR=../../ makesum
echo "Building diff now..."
cd ../
diff -urN ssl-admin freebsd_port > $MAJVER.$MINVER.$REVISION.patch



