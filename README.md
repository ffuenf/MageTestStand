<a href="http://www.ffuenf.de" title="ffuenf - code • design • e-commerce"><img src="https://github.com/ffuenf/Ffuenf_Common/blob/master/skin/adminhtml/default/default/ffuenf/ffuenf.png" alt="ffuenf - code • design • e-commerce" /></a>

MageTestStand
=============
[![GitHub tag](https://img.shields.io/github/tag/ffuenf/MageTestStand.svg)][tag]
[![Build Status](https://img.shields.io/travis/ffuenf/MageTestStand.svg)][travis]
[![PayPal Donate](https://img.shields.io/badge/paypal-donate-blue.svg)][paypal_donate]
[tag]: https://github.com/ffuenf/MageTestStand
[travis]: https://travis-ci.org/ffuenf/MageTestStand
[paypal_donate]: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J2PQS2WLT2Y8W&item_name=Magento%20Extension%3a%20MageTestStand&item_number=MageTestStand&currency_code=EUR

This tool is used to build a minimal Magento environment that allows to run PHPUnit tests for a Magento module on Travis CI.

It uses following tools:
- [n98-magerun](https://github.com/netz98/n98-magerun) (to install a vanilla Magento instance for a given version number)
- [modman](https://github.com/colinmollenhour/modman) (to link your module to the Magento instance)
- [EcomDev_PHPUnit](https://github.com/ecomdev/EcomDev_PHPUnit)
- [PHPUnit](https://phpunit.de/)
- [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) with [ECG Magento Code Sniffer Coding Standard](https://github.com/magento-ecg/coding-standard)
- [Composer](https://getcomposer.org/)
- [aoepeople/composer-installers](https://github.com/AOEpeople/composer-installers) (minimal composer installer for Magento modules which acts as a replacement for '[magento-hackathon/magento-composer-installer](https://github.com/magento-hackathon/magento-composer-installer)')

Requirements
------------

- Main Database: defaults to 'mageteststand' (user 'root', blank password) This is the database Magento uses
- Test Database: main database name with '_test' appended: 'mageteststand_test' (host, username, password and port are the same as the main database) This is the dummy database EcomDev_PHPUnit will use. Although you can configure this to use the original database, some tests (including fixtures) will behave differently...
- You can override the default database credentials using following environment variables:
  - `MAGENTO_DB_HOST`
  - `MAGENTO_DB_PORT`
  - `MAGENTO_DB_USER`
  - `MAGENTO_DB_PASS`
  - `MAGENTO_DB_NAME`
- In case you want to allow EcomDev_PHPUnit to use the main database instead of the test database you can set following environment variable to 1. This might be required if you're planning on writing integration tests.
  - `MAGENTO_DB_ALLOWSAME`
- Environment variable `MAGENTO_VERSION` with valid Magento version for n98-magerun's install command

General usage
-------------

- Set the environment variable `MAGENTO_VERSION` to the desired version, e.g. magento-ce-1.9.1.0
- Set the environment variable `WORKSPACE` to the directory of the magento module
- checkout your magento module
- run `curl -sSL https://raw.githubusercontent.com/ffuenf/MageTestStand/master/setup.sh | bash` as the build step, this will do everything automatically in a temporary directory
- you can use the script contents as a build step for sure, but this way it's easier ;)

Travis CI configuration
-----------------------

Example .travis.yaml file (in the Magento module you want to test):

```yml
language: php
sudo: false
cache:
  apt: true
  directories:
  - "$HOME/.composer/cache"
  - "$HOME/.cache/bin"
  - "$HOME/.n98-magerun/modules"
  - "$HOME/.cache/magento"
php:
- 7.0
- 7.1
- 7.2
- 7.3
matrix:
  fast_finish: true
  allow_failures:
  - php: 7.3
  - php: 7.2
env:
  global:
  - APPNAME=NAMESPACE_EXTENSIONNAME
  matrix:
  - MAGENTO_VERSION=ce-1.9.4.0
  - MAGENTO_VERSION=ce-1.9.3.10
  - MAGENTO_VERSION=ce-1.9.2.4
  - MAGENTO_VERSION=ce-1.9.1.1
before_install:
- curl -sSL https://raw.githubusercontent.com/ffuenf/MageTestStand/master/before_install.sh
  | bash
script:
- curl -sSL https://raw.githubusercontent.com/ffuenf/MageTestStand/master/script.sh
  | bash
deploy:
  provider: releases
  file:
  - "${APPNAME}-${TRAVIS_TAG}.zip"
  - "${APPNAME}-${TRAVIS_TAG}.tar.gz"
  skip_cleanup: true
  on:
    branch: master
    tags: true
```

To use the official downloads of magento (which can only accessed for logged-in users as of Magento CE 1.9.0),
you may use [magedownload-cli](https://github.com/steverobbins/magedownload-cli/).
For this to work, you'll have to install the travis gem und encrypt your credentials with:

```
travis encrypt MAGEDOWNLOAD_ID='YOUR-ID' --add
travis encrypt MAGEDOWNLOAD_TOKEN='YOUR-SECRET-TOKEN' --add
```

Development
-----------
1. Fork the repository from GitHub.
2. Clone your fork to your local machine:

        $ git clone https://github.com/USER/MageTestStand

3. Create a git branch

        $ git checkout -b my_bug_fix

4. Make your changes/patches/fixes, committing appropriately
5. Push your changes to GitHub
6. Open a Pull Request

License and Author
------------------

- Author:: Fabrizio Branca (<mail@fabrizio-branca.de>)
- Author:: Achim Rosenhagen (<a.rosenhagen@ffuenf.de>)
- Copyright:: 2019, ffuenf

GNU GENERAL PUBLIC LICENSE Version 3

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
