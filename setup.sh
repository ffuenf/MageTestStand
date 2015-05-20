#!/bin/bash
set -e
set -x

function cleanup {
  if [ -z $SKIP_CLEANUP ]; then
    echo "Removing build directory ${BUILDENV}"
    rm -rf "${BUILDENV}"
  fi
}
 
trap cleanup EXIT

# check if this is a travis environment
if [ ! -z $TRAVIS_BUILD_DIR ] ; then
  WORKSPACE=$TRAVIS_BUILD_DIR
fi

if [ -z $WORKSPACE ] ; then
  echo "No workspace configured, please set your WORKSPACE environment"
  exit
fi
 
BUILDENV=`mktemp -d /tmp/mageteststand.XXXXXXXX`

echo "Using build directory ${BUILDENV}"
 
git clone -b testing https://github.com/ffuenf/MageTestStand "${BUILDENV}"

mkdir ${BUILDENV}/build/logs
mkdir ${BUILDENV}/tools
curl -s -L https://raw.githubusercontent.com/colinmollenhour/modman/master/modman -o ${BUILDENV}/tools/modman
chmod +x ${BUILDENV}/tools/modman
curl -s -L https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar -o ${BUILDENV}/tools/n98-magerun
chmod +x ${BUILDENV}/tools/n98-magerun
curl -s -L https://getcomposer.org/composer.phar -o ${BUILDENV}/tools/composer
chmod +x ${BUILDENV}/tools/composer
curl -s -L https://phar.phpunit.de/phploc.phar -o ${BUILDENV}/tools/phploc
chmod +x ${BUILDENV}/tools/phploc
curl -s -L https://scrutinizer-ci.com/ocular.phar -o ${BUILDENV}/tools/ocular
chmod +x ${BUILDENV}/tools/ocular

cp -rf "${WORKSPACE}" "${BUILDENV}/.modman/"
${BUILDENV}/install.sh

cd ${BUILDENV}/htdocs
${BUILDENV}/bin/phpunit --coverage-clover=${BUILDENV}/build/logs/clover.xml --colors -d display_errors=1

if [ ! -z $CODECLIMATE_REPO_TOKEN ] ; then
  echo "Exporting code coverage results to codeclimate"
  cd ${BUILDENV}
  vendor/codeclimate/php-test-reporter/composer/bin/test-reporter
fi

echo "Exporting code coverage results to scrutinizer-ci"
cd ${BUILDENV}/build/logs
if [ ! -z $SCRUTINIZER_ACCESS_TOKEN ] ; then
  php -f ${BUILDENV}/tools/ocular code-coverage:upload --access-token=${SCRUTINIZER_ACCESS_TOKEN} --format=php-clover clover.xml
else
  php -f ${BUILDENV}/tools/ocular code-coverage:upload --format=php-clover clover.xml
fi

echo "Done."
