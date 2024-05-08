#! /bin/bash
apt-get update -q && apt-get dist-upgrade -qqy --no-install-recommends &&  apt-get autoremove -qy &&  apt-get clean -qy && apt-get autoclean -qy
[ -e /var/run/reboot-required ] && reboot

# 0 04 * * 4 /distrib/dataverse-docker/update.sh
