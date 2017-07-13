#!/bin/bash

#*****************************************************************************
#
#Pentaho BDVM Scripts
#
#Copyright (C) 2002-2017 by Pentaho : http://www.pentaho.com
#
#*****************************************************************************
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with
#the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#
#*****************************************************************************

## This file will pull down the magic script and execute it. Create a launcher for this on the desktop and mark as executable.

BASEDIR=$(dirname $0)
# Is there another copy of this file already in place? kill it!
if [ -f $BASEDIR/magicScript.sh ]; then
rm -rf $BASEDIR/magicScript.sh
fi
/usr/bin/wget https://raw.githubusercontent.com/pentaho/pentaho-bigdatavm/master/magicScript.sh
chmod +x $BASEDIR/magicScript.sh
$BASEDIR/magicScript.sh
