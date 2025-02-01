box() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
    echo
    echo "$edge"
    echo "$msg"
    echo "$edge"
}
