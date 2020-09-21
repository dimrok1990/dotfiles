#!/bin/sh
#
#    fet.sh
#  a fetch in pure POSIX shell
#

# supress errors
exec 2>/dev/null
set --
eq() {  # equals  |  [ a = b ] with globbing
	case $1 in
		# if the second argument matches the first, exit normally
		$2) return
		# if it doesn't match, reverse the output of `:`, which makes an error
	esac;! :
}

## DE
wm="$XDG_CURRENT_DESKTOP"
[ "$wm" ] || wm="$DESKTOP_SESSION"

## Distro
# freedesktop.org/software/systemd/man/os-release.html
# a common file that has variables about the distro
for os in /etc/os-release /usr/lib/os-release; do
	# some POSIX shells exit when trying to source a file that doesn't exist
	[ -f $os ] && . $os && break
done

if [ -e /proc/$$/comm ]; then
	## Terminal
	while [ ! "$term" ]; do
		# loop over lines in /proc/pid/status until it reaches PPid
		# then save that to a variable and exit the file
		while read -r line; do
			eq "$line" "PPid*" && ppid=${line##*:?} && break
		done < "/proc/${ppid:-$PPID}/status"

		# Make sure not to do an infinite loop
		[ "$pppid" = "$ppid" ] && break
		pppid="$ppid"

		# get name of binary
		read -r name < "/proc/$ppid/comm"

		case $name in
			*sh|"${0##*/}") ;;  # skip shells
			*[Ll]ogin*|*init*) break;;  # exit when the top is reached
			*) term="$name"  # anything else can be assumed to be the terminal
		esac
	done

	## WM/DE
	[ ! "$wm" ] &&
		# loop over all processes and check the binary name
		for i in /proc/*/comm; do
			read -r c < "$i"
			case $c in
				awesome|xmonad*|qtile|sway|i3|[bfo]*box|*wm*) wm="${c%%-*}"; break;;
			esac
		done

	## Memory
	# loop over lines in /proc/meminfo until it reaches MemTotal,
	# then convert the amount (second word) from KB to MB
	while read -r line; do
		eq "$line" "MemTotal*" && set -- $line && break
	done < /proc/meminfo
	mem="$(( $2 / 1000 ))MB"

	## Processor
	while read -r line; do
		case $line in
			vendor_id*) vendor="${line##*: } ";;
			model\ name*) cpu="${line##*: }"; break;;
		esac
	done < /proc/cpuinfo

	## Uptime
	# the simple math is shamefully stolen from aosync
	IFS=. read -r uptime _ < /proc/uptime
	d=$((uptime / 60 / 60 / 24))
	up=$(printf %02d:%02d $((uptime / 60 / 60 % 24)) $((uptime / 60 % 60)))
	[ "$d" -gt 0 ] && up="${d}d $up"

	## Kernel
	read -r _ _ version _ < /proc/version
	kernel="${version%%-*}"
	eq "$version" "*Microsoft*" && ID="fake $ID"

	## Motherboard // laptop
	read -r model < /sys/devices/virtual/dmi/id/product_name

	## Packages
	# clean environment, then make every file in the dir an argument,
	# then save the argument count to $pkgs
	set --
	[ -d /var/db/kiss/installed ] && set -- /var/db/kiss/installed/*
	[ -d /var/lib/pacman/local  ] && set -- /var/lib/pacman/local/[0-9a-z]*
	[ -d /var/lib/dpkg/info ] && set -- /var/lib/dpkg/info/*.list
	[ -d /var/db/xbps ] && set -- /var/db/xbps/.*
	[ -d /var/db/pkg  ] && set -- /var/db/pkg/*/*  # gentoo
	pkgs=${###0}

	read -r host < /proc/sys/kernel/hostname
elif [ -f /var/run/dmesg.boot ]; then
	# Both OpenBSD and FreeBSD use this file, however they're formatted differently
	read -r bsd < /var/run/dmesg.boot
	case $bsd in
	Open*)
		## OpenBSD cpu/mem/name
		while read -r line; do
			case $line in
				"real mem"*)
					# use the pre-formatted value which is in brackets
					mem=${line##*\(}
					mem=${mem%\)*}
				;;
				# set $cpu to everything before a comma and after the field name
				cpu0:*)
					cpu=${line#cpu0: }
					# Remove excess info after the actual CPU name
					cpu=${cpu%%,*}
					# Set the CPU Manufacturer to the first word of the cpu
					# variable [separated by '(' or ' ']
					vendor=${cpu%%[\( ]*}
					# We got all the info we want, stop reading
					break
				;;
				# First 2 words in the file are OpenBSD <version>
				*) [ "$ID" ] || { set -- $line; ID="$1 $2"; }
			esac
		done < /var/run/dmesg.boot
		[ -d /var/db/pkg ] && set -- /var/db/pkg/* && pkgs=$#
		read -r host < /etc/myname
		host=${host%.*}
	;;
	# Everything else, assume FreeBSD (first line is ---<<BOOT>> or something)
	*)
		# shellcheck source=/dev/null
		. /etc/rc.conf
		# shut shellcheck up without disabling the warning
		host=${hostname:-}

		while read -r line; do
			case $line in
				# Ignore useless lines at the top
				-*|'  '*) ;;
				*trademark*) ;;

				# os version
				FreeBSD*)
					# If the OS is already set, no need to set it again
					[ "$ID" ] && continue
					ID="${line%%-R*}"
				;;

				CPU:*)
					cpu=${cpu#CPU: }
					# Remove excess info from after the actual CPU name
					cpu=${line%\(*}
				;;
				*Origin=*)
					# CPU Manufacturer
					vendor=${line#*Origin=\"}
					vendor="${vendor%%\"*} "
				;;

				"real memory"*)
					# Get the pre-formatted amount which is inside brackets
					mem=${line##*\(}
					mem=${mem%\)*}
					# This appears to be the final thing we need from the file,
					# no need to read it more.
					break
			esac
		done < /var/run/dmesg.boot
	;;
	esac
elif v=/System/Library/CoreServices/SystemVersion.plist; [ -f "$v" ]; then
	## Macos
	# make sure this variable is empty as to not break the following loop
	temp=
	while read -r line; do
		case $line in
			# set a variable so the script knows it's on the correct line
			# (the line after this one is the important one)
			*ProductVersion*) temp=.;;
			*)
				# check if the script is reading the derired line, if not
				# don't do anything
				[ "$temp" ] || continue
				# Remove everything before and including the first '>'
				ID=${line#*>}
				# Remove the other side of the XML tag, and insert the actual OS name
				ID="MacOS ${ID%<*}"
				# We got the info we want, end the loop.
				break
		esac
	done < "$v"
fi

eq "$0" "*fetish" && printf 'Step on me daddy\n' && exit

# help i dont know if it's a capital consistently
eq "$wm" "*[Gg][Nn][Oo][Mm][Ee]*" && wm="foot DE"

## GTK
while read -r line; do
	eq "$line" "gtk-theme*" && gtk="${line##*=}" && break
done < "${XDG_CONFIG_HOME:=$HOME/.config}/gtk-3.0/settings.ini"

# Shorten $cpu and $vendor
# this is so messy due to so many inconsistencies in the model names
vendor="${vendor##*Authentic}"
vendor="${vendor##*Genuine}"
cpu="${cpu##*) }"
cpu="${cpu%% @*}"
cpu="${cpu%% CPU}"
cpu="${cpu##CPU }"
cpu="${cpu##*AMD }"
cpu="${cpu%% with*}"
cpu="${cpu% *-Core*}"

panes() {
f=3 b=4 g=9
for j in f b g; do
  for i in {0..16}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
d=$'\e[1m'
t=$'\e[0m'
v=$'\e[7m'

cat << EOF

 $f1███$d$g1▄$t  $f2███$d$g2▄$t  $f3███$d$g3▄$t  $f4███$d$g4▄$t  $f5███$d$g5▄$t  $f6███$d$g6▄$t  $f7███$d$g7▄$t
 $f1███$d$g1█$t  $f2███$d$g2█$t  $f3███$d$g3█$t  $f4███$d$g4█$t  $f5███$d$g5█$t  $f6███$d$g6█$t  $f7███$d$g7█$t
 $f1███$d$g1█$t  $f2███$d$g2█$t  $f3███$d$g3█$t  $f4███$d$g4█$t  $f5███$d$g5█$t  $f6███$d$g6█$t  $f7███$d$g7█$t
 $d$g1 ▀▀▀   $g2▀▀▀   $g3▀▀▀   $g4▀▀▀   $g5▀▀▀   $g6▀▀▀   $g7▀▀▀
EOF
}

print() {
	[ "$2" ] && printf '\033[9%sm%6s\033[0m%b%s\n' \
		"${accent:-4}" "$1" "${separator:- ~ }" "$2"
}

# default value
: "${info:=n user os sh wm up gtk cpu mem host kern pkgs term panes n}"

for i in $info; do
	case $i in
		n) echo;;
		os) print os "$ID";;
		sh) print sh "${SHELL##*/}";;
		wm) print wm "${wm##*/}";;
		up) print up "$up";;
		gtk) print gtk "${gtk# }";;
		cpu) print cpu "$vendor$cpu";;
		mem) print mem "$mem";;
		host) print host "$model";;
		kern) print kern "$kernel";;
		pkgs) print pkgs "$pkgs";;
		term) print term "$term";;
		user) printf '%7s@%s\n' "$USER" "$host";;
		panes) panes;;
	esac
done
