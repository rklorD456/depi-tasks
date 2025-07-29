#!/bin/bash

sudo adduser mahmoud


sudo deluser --remove-home mahmoud

mkdir working-area
rmdir working-area

echo "hello my new user" >> file.txt
grep "hello" file.txt

cat file.txt

chmod 700 file.txt
chmod u-x file.txt

alias ll='ls -la'
ll
unalias ll

date
pwd

history 2

cp file.txt new-file.txt
mv new-file.txt file.txt
mkdir newone
cp -r newone/ newone1/
mv file.txt newone1/
rm -r newone newone1

ls
echo "✅ Script completed!"
