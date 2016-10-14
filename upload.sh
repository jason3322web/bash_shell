#!/bin/bash
function help()
{
    echo ""
    echo "Usage: $0 <src_file> <dst_ip> <dst_dir>"
    return
}

function scp_()
{
src=$1
dst_dir=$2
ip=$3
user=$4
passwd=$5

/usr/bin/expect <<-EOF
spawn scp $src $user@$ip:$dst_dir
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*assword:" { send "$passwd\r" }
}
EOF
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    help
    exit
fi

src_file=$1
r2_ip=$2
r2_user=_rcpadmin
r2_passwd=RCP_owner
r2_dir=$3

r1_ip=10.56.16.51
r1_user=vagrant
r1_passwd=vagrant
r1_dir=/home/$r1_user/tmp

file_name=${src_file##*/}

#**copy the src file to mid_computer**#
scp_ $src_file $r1_dir $r1_ip $r1_user $r1_passwd

/usr/bin/expect <<-EOF
spawn ssh $r1_user@$r1_ip
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*assword:" { send "$r1_passwd\r" }
}
#expect "*$ "
#send "p=`date +%Y%m%d`_`date +%H%M%S`\r"
#expect "*$ "
#send "mkdir $p\r"
expect "*$ "
send "scp $r1_dir/$file_name $r2_user@$r2_ip:$r2_dir\r"
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*assword:" { send "$r2_passwd\r" }
}

expect "*$ "
send "date\r"
expect "*$ "
send "exit \r"
expect off
EOF

