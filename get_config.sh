#！/bin/sh  
MYPATH=$(pwd)
CONFIGFILE="com.conf"

IDS="ids"
if [ ! -f "${MYPATH}/${CONFIGFILE}" ]; then
    echo "Check configuration file \"${CONFIGFILE}\""
    exit
fi

getsection()
{
    ENDPRINT="ip\tusername\tpassword\t"
    CONFILE=$1
    SECTION=$2

    echo -e $ENDPRINT
    for loop in `echo -e $ENDPRINT|tr '\t' ' '`
    do
        awk -F '=' '/\['"$SECTION"'\]/{a=1}a==1&&$1~/'"$loop"'/{gsub(/[[:blank:]]*/,"",$2); printf("%s\t",$2); exit}' $CONFILE
    done
}

getitem()
{
    CONFILE=$1
    SECTION=$2
    ITEM=$3

    awk -F '=' '/\['"$SECTION"'\]/{a=1}a==1&&$1~/'"$ITEM"'/{gsub(/[[:blank:]]*/,"",$2); printf("%s\t",$2); exit}' $CONFILE
    
}

#echo "========================================================"

#profile=`sed -n '/ids/'p $CONFIGFILE | awk -F= '{print $2}' | sed 's/,/ /g'`
SECTIONS=`sed -n '/'$IDS'/p' $CONFIGFILE | awk -F= '{print $2}' | sed 's/,/ /g'`

for OneCom in $SECTIONS
do
    ITEMS="ip\tusername\tpassword\tpwd\t"
    i=0
    for ITEM in `echo -e $ITEMS|tr '\t' ' '`
    do

        a[i]=`getitem $CONFIGFILE $OneCom $ITEM`
        i=$((${i}+1))
        
    #USERNAME=`getitem $CONFIGFILE $OneCom username`
    #PASSWORD=`getitem $CONFIGFILE $OneCom password`
    #echo $IP $USERNAME $PASSWORD
    done
    for var1 in ${a[@]}
    do
        echo ${var1}
    done
    echo -e "\n"
done
#echo "========================================================"

