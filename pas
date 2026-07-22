#!/bin/sh

a=$1
[ "$a" = "" ] && a=32

openssl rand -base64 $a