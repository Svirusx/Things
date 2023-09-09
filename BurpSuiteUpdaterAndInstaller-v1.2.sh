#!/bin/bash

#BurpSuite updater & installer script:
#Recommend: Install BurpSuite first with e.q. apt install burpsuite -y.
#Mainly made to update BurpSuite in Kali Linux but works too with Ubuntu maybe too in another distributions...

#Colors
RED='\033[1;31m'
BROWN='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'

printf "${GREEN}Burp Suite installer & updater v1.0 \n${BROWN}Checking latest version${NC} \n"

# Prompt the user for their password
sudo -v

burpVersion=$(curl -i -s -k -X $'GET' -H $'Host: portswigger.net' $'https://portswigger.net/burp/releases/community/latest' | grep 'location:' | cut -f1 -d "?" | cut -f3,4,5 -d'-' | sed 's/-/./g')

if [ ! -f ~/.BurpSuite/CurrentVersion.txt ]
then
mkdir ~/.BurpSuite
touch ~/.BurpSuite/CurrentVersion.txt
fi 

currentVersion=$(cat ~/.BurpSuite/CurrentVersion.txt)

printf "Current version: ${RED}$currentVersion${NC}\n"
printf "Latest version: ${RED}$burpVersion${NC}\n"
if [ "$currentVersion" != "$burpVersion" ] || [ ! -f "/usr/share/burpsuite/burpsuite.jar" ]
then

printf "${BROWN}Downloading $burpVersion version:${NC}\n"
[ -d /usr/share/burpsuite ] || sudo mkdir -p /usr/share/burpsuite

wget "https://portswigger.net/burp/releases/download?product=community&version=$burpVersion&type=Jar" -O /tmp/burpsuite
chmod +x /tmp/burpsuite
sudo mv /tmp/burpsuite /usr/share/burpsuite/burpsuite.jar
cat <<EOL | sudo tee /bin/burpsuite > /dev/null
#!/usr/bin/env sh
set -e
export JAVA_CMD=java
java -jar /usr/share/burpsuite/burpsuite.jar "\$@"
EOL
sudo chmod +x /bin/burpsuite

echo $burpVersion > ~/.BurpSuite/CurrentVersion.txt
printf "${GREEN}Burp Suite updated to $burpVersion version${NC}\n"
echo "Run burp suite by typing burpsuite in terminal, if you are on kali linux then typing burpsuite works too."
echo "You need to have java installed to use BurpSuite."
else
printf "${GREEN}You have latest BurpSuite Community Edition Installed.${NC}\n"
fi
