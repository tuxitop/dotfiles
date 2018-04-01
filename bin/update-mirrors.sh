if (( $UID )); then
    echo 'You must be root.' >&2
    exit 1
fi

if [ -x "$(hash reflector 2>/dev/null)" ]; then
    echo 'reflector not found. Please install reflector package'
    exit 1
fi

echo "backing up mirrorlist to /etc/pacman.d/mirrorlist.backup"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

if [ -f /etc/pacman.d/mirrorlist.pacnew ]; then
    echo "mirrorlist.pacnew exists, moving it over mirrorlist"
    mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
else
    echo "/etc/pacman.d/mirrorlist.pacnew does not exist. fetching mirrors from internet."
    curl -o /etc/pacman.d/mirrorlist.downloading https://www.archlinux.org/mirrorlist/all/
    mv /etc/pacman.d/mirrorlist.downloading /etc/pacman.d/mirrorlist
fi

reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

echo "adding archlinux.fr mirror to use delta packages"
sed -i '11i# This first mirror is unrated. This is the only mirror available for delta packages.\nServer = http://delta.archlinux.fr/$repo/os/$arch\n' /etc/pacman.d/mirrorlist
