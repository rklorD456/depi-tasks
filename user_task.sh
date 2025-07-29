#!/bin/bash
shopt -s expand_aliases

echo "--- Starting Script ---"
echo


echo "Adding and removing user 'mahmoud'..."
sudo adduser mahmoud


sudo deluser --remove-home mahmoud

echo "Creating and removing a temporary directory..."
mkdir working-area
rmdir working-area

echo "-> 'working-area' created and removed."
echo


echo "hello my new user" >> file.txt
grep "hello" file.txt

cat file.txt

echo "Changing file permissions..."
chmod 700 file.txt
chmod u-x file.txt
echo "-> Permissions set."
echo

alias ll='ls -la'
ll
unalias ll

echo "Displaying current date and path..."
echo "Date: $(date)"
echo "Path: $(pwd)"
echo


history 2

cp file.txt new-file.txt
mv new-file.txt file.txt
mkdir newone
cp -r newone/ newone1/
mv file.txt newone1/
rm -r newone newone1

ls
echo "Script completed!"
