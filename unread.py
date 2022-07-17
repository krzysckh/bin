#!/usr/bin/env python3
# very inefficient way to get n of unread messages from a mail server
# lol

import imaplib as il
import sys

def usage():
    print("usage: unread.py user password server port")
    print("e.g. unread.py gigachad cool_pass mail.example.com 993")
    exit(1)

def getn(usr, passwd, srv, port):
    imap = il.IMAP4_SSL(srv, port)
    imap.login(usr, passwd)
    imap.select("INBOX")

    # _, res = imap.search(None, "INBOX", "(UNSEEN)")
    _, res = imap.uid('search', None, "UNSEEN")
    return len(res[0].split())

if len(sys.argv) != 5:
    usage()

print(getn(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])))

