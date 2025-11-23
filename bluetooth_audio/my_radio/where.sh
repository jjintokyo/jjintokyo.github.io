#!/bin/bash
if [ "$1" == "" ]; then where="libLC3plus.so"; else where="$1"; fi;
sudo find / -iname "$where*" -type f -exec ls -Shl {} +
