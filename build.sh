#!/usr/bin/env sh
# This should be run from the $SPLUNK_HOME/etc/apps/splunktel_demo directory.

# Save for later
CURRENT_PWD=`pwd`

# Cleanup
rm $CURRENT_PWD/splunktel_demo.spl

echo "Creating Build Directory"
# Create a build directory that we can use
BUILD_DIR=.build/splunktel_demo
BUILD_DIR_PARENT=.build
mkdir -p $BUILD_DIR

echo "Copying splunktel_demo files to build directory"
cp -R * $BUILD_DIR
rm $BUILD_DIR/metadata/local.meta

echo "Packaging splunktel_demo.spl"
cd $BUILD_DIR_PARENT
tar --exclude "splunktel_demo/splunktel_demo.spl" --exclude "splunktel_demo/bin/gogen_real*" --exclude "splunktel_demo/.*" -czf "$CURRENT_PWD/splunktel_demo.spl" splunktel_demo 

echo "Cleaning up"
cd $CURRENT_PWD
rm -rf $BUILD_DIR

echo "Build Complete"
