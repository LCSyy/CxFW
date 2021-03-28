#!/bin/bash

QT_ROOT=...
QT_SDK=$QT_ROOT/5.15.2/mingw81_64
QIFW_DIR=$QT_ROOT/Tools/QtInstallerFramework/4.0/bin

# copy sdk files
mkdir -p ./.pack/sdk 
mkdir -p ./packages/sdk/data
cp -r ./bin/plugins ./.pack/sdk
$QIFW_DIR/archivegen -c 5 ./.pack/sdk.7z ./.pack/sdk
mv ./.pack/sdk.7z ./packages/sdk/data

# copy app files
mkdir -p ./.pack/apps
mkdir -p ./packages/apps/data
cp ./bin/Writer.exe ./.pack/apps
$QT_SDK/bin/windeployqt --qmldir $QT_SDK/qml ./.pack/apps/Writer.exe
cp -r ./bin/plugins ./.pack/apps
cp $QT_SDK/bin/libcrypto-1_1-x64.dll $QT_SDK/bin/libssl-1_1-x64.dll ./.pack/apps
$QIFW_DIR/archivegen -c 5 ./.pack/apps.7z ./.pack/apps
mv ./.pack/apps.7z ./packages/apps/data

$QIFW_DIR/binarycreator -c config/config.xml -p packages CxFwInstaller

rm -r ./.pack
rm -r ./packages/sdk/data/*
rm -r ./packages/apps/data/*
