#!/bin/bash -e
# -----------------------------------------------------------------------------
#
# Package          : perfmark
# Version          : v0.27.0
# Source repo      : https://github.com/perfmark/perfmark
# Tested on        : UBI:9.3
# Language         : Java
# Travis-Check     : True
# Script License   : Apache License, Version 2 or later
# Maintainer       : Mayur Bhosure <Mayur.Bhosure2@ibm.com>
#
# Disclaimer       : This script has been tested in non-root mode on given
# ==========         platform using the mentioned version of the package.
#                    It may not work as expected with newer versions of the
#                    package and/or distribution. In such case, please
#                    contact "Maintainer" of this script.
#
# ---------------------------------------------------------------------------

PACKAGE_NAME=perfmark
PACKAGE_URL=https://github.com/perfmark/perfmark.git
PACKAGE_VERSION=${1:-v0.27.0}

yum install -y wget tar git 

#Install temurin java21
wget https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.5%2B11/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.5_11.tar.gz
tar -C /usr/local -zxf OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.5_11.tar.gz
export JAVA_HOME=/usr/local/jdk-21.0.5+11
export JAVA21_HOME=/usr/local/jdk-21.0.5+11
export PATH=$PATH:/usr/local/jdk-21.0.5+11/bin
ln -sf /usr/local/jdk-21.0.5+11/bin/java /usr/bin
rm -f OpenJDK17U-jdk_ppc64le_linux_hotspot_21.0.5_11.tar.gz



git clone $PACKAGE_URL
cd $PACKAGE_NAME
git checkout $PACKAGE_VERSION
./gradlew --gradle-version 8.10.2
if ! ./gradlew clean build ; then
     echo "------------------$PACKAGE_NAME:Build_fails---------------------"
     echo "$PACKAGE_VERSION $PACKAGE_NAME"
     echo "$PACKAGE_NAME  | $PACKAGE_VERSION | $OS_NAME | GitHub | Fail |  Build_Fails_"
     exit 2
fi

if ! ./gradlew test ; then
      echo "------------------$PACKAGE_NAME::Build_and_Test_fails-------------------------"
      echo "$PACKAGE_URL $PACKAGE_NAME"
      echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | GitHub  | Fail|  Build_and_Test_fails"
      exit 1
else
      echo "------------------$PACKAGE_NAME::Build_and_Test_success-------------------------"
      echo "$PACKAGE_URL $PACKAGE_NAME"
      echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | GitHub  | Pass |  Both_Build_and_Test_Success"
      exit 0
fi
