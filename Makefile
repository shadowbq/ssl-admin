# ssl-admin Makefile
# $Id$
 
ETCDIR?=VARETC
BINDIR?=VARBIN
MANDIR?=VARMAN

all:

install:

	[ -e "${ETCDIR}/ssl-admin" ] || mkdir -p ${ETCDIR}/ssl-admin
	sed s+~~~ETCDIR~~~+${ETCDIR}+g man1/ssl-admin.1 > ${MANDIR}/man1/ssl-admin.1
	sed s+~~~ETCDIR~~~+${ETCDIR}+g man5/ssl-admin.conf.5 > ${MANDIR}/man5/ssl-admin.conf.5
	install -c -g wheel -o root -m 0660 -S -v ssl-admin.conf ${ETCDIR}/ssl-admin/ssl-admin.conf.default
	install -c -g wheel -o root -m 0660 -S -v openssl.conf ${ETCDIR}/ssl-admin/openssl.conf.default
	[ -e "${ETCDIR}/ssl-admin/openssl.conf" ] || cp ${ETCDIR}/ssl-admin/openssl.conf.default ${ETCDIR}/ssl-admin/openssl.conf
	SEDCMD "s+~~~ETCDIR~~~+${ETCDIR}+g" ssl-admin
	install -c -g wheel -o root -m 0755 -S -v ssl-admin ${BINDIR}/ssl-admin
	chmod 0444 ${ETCDIR}/ssl-admin/*.conf.default
