#!/bin/bash

sed -n '/COOKIE_DOMAIN/p' testfile/sedtest.txt
#sed '/\(^COOKIE_DOMAIN=\).*/ s//\1tele.dk/g' testfile/sedtest.txt
