#!/bin/bash

## This file will pull down the magic script and execute it. Create a launcher for this on the desktop and mark as executable.

BASEDIR=$(dirname $0)
# Is there another copy of this file already in place? kill it!
if [ -f $BASEDIR/magicScript.sh ]; then
rm -rf $BASEDIR/magicScript.sh
fi
/usr/bin/wget https://raw.githubusercontent.com/pentaho/pentaho-bigdatavm/master/magicScript.sh
chmod +x $BASEDIR/magicScript.sh
$BASEDIR/magicScript.sh
