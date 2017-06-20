#!/bin/bash

###############################################################################
# 
# Welcome to the Magic Script. The script that does Magic!
#
# The goal of the project is to make install and configure the Pentaho VM
# with the extra goodies that will make.
#
# In order to launch it, the VM calls:
#
# $ source <( curl -s https://raw.githubusercontent.com/pentaho/pentaho-bigdatavm/master/magicScript.sh  )

#
# Author: Pedro Alves
# License: Whatever... Apache2 if I have to pick one
#
###############################################################################
# Executed from within the Pentaho VM:
#
# #


cat <<EOF

About to run the magic script (tm). The script that does magic!

EOF




BASEDIR=$(dirname $0)
cd $BASEDIR

TMPDIR=/home/demouser/magicScriptTmp/
WORKBOOKDIR=/home/demouser

WORKBOOK_GIT=https://github.com/pentaho/pentaho-bigdatavm.git
WORKBOOK_DIRNAME=pentaho-bigdatavm
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


echo -e '\n\nStep 4: Getting the workbook content the workbook content...'

# Cloning or  updating the version rep

# Do we have a temp dir? Wipe it out!

if [ -d $WORKBOOKDIR/$WORKBOOK_DIRNAME ]; then

	cd $WORKBOOKDIR/$WORKBOOK_DIRNAME 
	git checkout $WORKBOOK_VERSION >> $TMPDIR/step4.log 2>&1
	git pull >> $TMPDIR/step4.log 2>&1

else
	
	cd $WORKBOOKDIR
	git clone -b $WORKBOOK_VERSION https://github.com/pentaho/pentaho-bigdatavm.git >> $TMPDIR/step4.log 2>&1 
fi

sudo mv /home/demouser/pentaho-bigdatavm/content/evaluation /pentaho/evaluation
sudo chown -R demouser:demouser /pentaho
sudo ln -s /pentaho/evaluation /home/demouser/Desktop/Pentaho\ Evaluation

# Done

echo -e '\n\nDone! Enjoy!\n'
