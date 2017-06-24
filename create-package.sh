#!/bin/bash

BASE=$1:/opt/web-migration

SOURCE_BASE=/Users/bala.kondameedi/Desktop/web-migration/web-migration-script/source
TARGET_BASE=/Users/bala.kondameedi/Desktop/web-migration/web-migration-script/target
EXPORT_DIR=/Users/bala.kondameedi/Desktop/web-migration/web-migration-script

# END Configuration

function replace_links
{
	pms=`cat page-mappings.txt`
	for pm in $pms; do
		params=(${pm//;/ })
		export FIND="${params[0]}"
		export REPLACE="${params[1]}"
	
		echo "Replacing $FIND with $REPLACE in $TARGET_BASE/jcr_root$targetdir/.content.xml..."
		ruby -p -i -e "gsub(ENV['FIND'], ENV['REPLACE'])" $TARGET_BASE/jcr_root$targetdir/.content.xml || exit 1
	done
	fms=`cat file-mappings.txt`
	for fm in $fms; do
		params=(${fm//;/ })
		export FIND="${params[0]}"
		export REPLACE="${params[1]}"
	
		echo "Replacing $FIND with $REPLACE in $TARGET_BASE/jcr_root$targetdir/.content.xml..."
		ruby -p -i -e "gsub(ENV['FIND'], ENV['REPLACE'])" $TARGET_BASE/jcr_root$targetdir/.content.xml || exit 1
	done
}

copy_wdir() { mkdir -p -- "$(dirname -- "$2")" && cp -- "$1" "$2" ; }

rm -rf $TARGET_BASE

lines=`cat page-mappings.txt`
for line in $lines; do
	params=(${line//;/ })
	sourcefile="${params[0]}"
	targetdir="${params[1]}"
	template="${params[2]}"
	
	echo "Creating directory $TARGET_BASE$targetdir..."
	mkdir -p $TARGET_BASE/jcr_root$targetdir || exit 1
	
	echo "Transforming XML $SOURCE_BASE$sourcefile with $template to $TARGET_BASE/jcr_root$targetdir/.content.xml..."
	xsltproc --output $TARGET_BASE/jcr_root$targetdir/.content.xml $template $SOURCE_BASE$sourcefile || exit 1
	
	replace_links
	
	echo "Successfully updated $TARGET_BASE/jcr_root$targetdir/.content.xml..."
done
echo "Page Mappings Complete!"

# END Configuration
lines=`cat file-mappings.txt`
for line in $lines; do
	params=(${line//;/ })
	sourcefile="${params[0]}"
	target="${params[1]}"
	
	filedir=$(dirname $TARGET_BASE/jcr_root$target | sed 's,^\(.*/\)\?\([^/]*\),\2,')
	echo "Creating directory $filedir..."
	mkdir -p $filedir || exit 1
	
	echo "Copying File $SOURCE_BASE$sourcefile to $TARGET_BASE/jcr_root$target..."
	cp $SOURCE_BASE$sourcefile $TARGET_BASE/jcr_root$target || exit 1
done
echo "File Mappings Complete!"

echo "Updating filter.xml..."
mkdir -p $TARGET_BASE/META-INF/vault || exit 1
cp filter.xml $TARGET_BASE/META-INF/vault || exit 1

echo "Updating properties.xml..."
today=$(date +%F)
cp properties.xml $TARGET_BASE/META-INF/vault || exit 1
sed -i -e "s/\${version}/$today/" $TARGET_BASE/META-INF/vault/properties.xml || exit 1

echo "Compressing package..."
cd $TARGET_BASE
zip -rv  "$EXPORT_DIR/percussion-content-$today.zip" . || exit 1

echo "Package saved to : $EXPORT_DIR/percussion-content-$today.zip"

echo "Package created successfully!!!"
