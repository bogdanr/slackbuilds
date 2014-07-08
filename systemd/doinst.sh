#!/bin/sh
if [[ -f etc/group ]]; then
  if ! grep ^systemd-journal: etc/group 1> /dev/null 2> /dev/null ; then
	echo "systemd-journal:x:60:" >> etc/group
  fi

  if ! grep ^systemd-timesync: etc/group 1> /dev/null 2> /dev/null ; then
	echo "systemd-timesync:x:61:" >> etc/group
  fi
fi

( cd lib64 ; ln -sf libudev.so.1.4.0 libudev.so.0 )

