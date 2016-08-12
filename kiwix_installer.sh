#!/bin/bash

# Kiwix Installer: Script to setup specific language wikipedia dump in local and
# serve it through kiwix_server.
# Copyright (C) 2016  Alagunambi Welkin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Configurations
kiwix_server_tar="kiwix-linux-x86_64.tar.bz2"
zim_zip="wikipedia_ta_all.zim" # Tamil
port="8080"
PROGNAME=$(basename $0)

function error_exit {
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	exit 1
}

# trap ctrl-c and call ctrl_c()
trap say_bye INT

function say_bye {
  echo -e "\nBye!.. Happy Hacking!!"
}

# Actual work starts from here.
# Downloading & extracting Kiwix server.
wget -c https://download.kiwix.org/bin/$kiwix_server_tar
tar xvf $kiwix_server_tar --skip-old-files
if [ "$?" = "0" ]; then
  echo "Server setup done!"
else
  error_exit "$LINENO: Kiwix server setup failed."
fi

# Download & indexing Wikpedia ZIM file
# You can find and replace your own language url
# from http://download.kiwix.org/portable/wikipedia
wget -c http://download.kiwix.org/zim/$zim_zip
./kiwix/bin/kiwix-install --buildIndex addcontent ./$zim_zip .
if [ "$?" = "0" ]; then
  echo "Wikipedia ZIM setup done!"
else
  error_exit "$LINENO: Wikipedia ZIM setup failed."
fi


# Starting http server
echo "Starting server at $port, please visit http://localhost:$port"
echo "Press ctrl+c to kill the script."
./kiwix/bin/kiwix-serve --library `pwd`/data/library/$zim_zip".xml" --port=$port
if [ "$?" != "0" ]; then
  error_exit "$LINENO: Server failed!."
fi

# Thank you!
