#!/bin/bash
#
# $ source <( curl -s https://raw.githubusercontent.com/pentaho/pentaho-bigdatavm/master/magicScript.sh  )
#
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
# Executed from within the Pentaho VM:
#

cat <<EOF
About to run the magic script (tm). The script that does magic!
EOF

BASEDIR=$(dirname $0)
cd $BASEDIR

TMPDIR=/home/demouser/magicScriptTmp/
WORKBOOKDIR=/pentaho

WORKBOOK_GIT=https://github.com/pentaho/pentaho-bigdatavm.git
WORKBOOK_DIRNAME=evaluation
WORKBOOK_VERSION=master

# Do we have a temp dir? Wipe it out!
if [ -d $TMPDIR ]; then
	rm -rf $TMPDIR
fi

# and start!
mkdir -p $TMPDIR

echo -e '\n\nStep 1: Installing a few extra packages to the operating system...'

# Install some stuff we need
sudo apt-get update > $TMPDIR/step1.log 2>&1 && sudo apt-get install -y \
	evince medit wget unzip git >> $TMPDIR/step1.log 2>&1 

echo -e '\n\nStep 2: Downloading SQuirreL. This may take a few minutes...'

# Download squirrel

wget 'https://sourceforge.net/projects/squirrel-sql/files/1-stable/3.7.1-plainzip/squirrelsql-3.7.1-standard.zip/download' -O $TMPDIR/squirrelsql-3.7.1-standard.zip -o $TMPDIR/step2.log

echo -e '\n\nStep 3: Installing and configuring SQuirreL...'

# Install it
sudo unzip -o $TMPDIR/squirrelsql-3.7.1-standard.zip -d /opt >> $TMPDIR/step3.log 2>&1
sudo chmod +x /opt/squirrelsql-3.7.1-standard/*sh

cat << 'EOF' > /home/demouser/Desktop/SQuirreL.desktop
[Desktop Entry]
Name=SQuirreL
Type=Application
Exec=/opt/squirrelsql-3.7.1-standard/squirrel-sql.sh
Icon=/opt/squirrelsql-3.7.1-standard/icons/acorn.png
EOF

sudo chmod +x /home/demouser/Desktop/SQuirreL.desktop

echo -e '\n\nStep 4: Getting the workbook content...'

# Cloning or  updating the version repo

if [ -d $WORKBOOKDIR/$WORKBOOK_DIRNAME ]; then

	cd $WORKBOOKDIR/$WORKBOOK_DIRNAME 
	git checkout $WORKBOOK_VERSION >> $TMPDIR/step4.log 2>&1
	git pull >> $TMPDIR/step4.log 2>&1
else
	cd $WORKBOOKDIR
	git clone -b $WORKBOOK_VERSION https://github.com/pentaho/pentaho-bigdatavm.git >> $TMPDIR/step4.log 2>&1 
fi

#move the eval contents to /pentaho/evaluation to match workbook instructions
sudo mkdir /pentaho/evaluation
#sudo cp -R /home/demouser/pentaho-bigdatavm/content/evaluation/* /pentaho/evaluation/
sudo mv $WORKBOOKDIR/pentaho-bigdatavm/content/evaluation $WORKBOOKDIR
sudo mv $WORKBOOKDIR/pentaho-bigdatavm/content/workshop $WORKBOOKDIR
sudo rm -rf /pentaho/pentaho-bigdatavm
sudo chown -R demouser:demouser /pentaho
sudo ln -s /pentaho/evaluation /home/demouser/Desktop/Pentaho\ Evaluation

# Done

echo -e '\n\nDone! Enjoy!\n'
