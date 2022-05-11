#!/usr/bin/bash 
# made by prince kumar 
# date 10 may 
trap exit_out SIGINT
trap exit_out SIGTERM
# make a function to exit out of program 
exit_out(){
    echo -e "\033[31;1m Program terminated "
}
#make a banner for the tools 
banner(){
	echo -e "\e[33;1m "
	echo "         .-~~~-.
  .- ~ ~-(       )_ _
 /                    ~ -.
|                          ',
 \                         .'
   ~- ._ ,. ,.,.,., ,.. -~
           '       '"
    echo -e "\e[32;1m MADE BY PRINCE"
}
# make a function to install all the requirements .. 
req(){
    if [[ -d "/data/data/com.termux/files/home" ]];then
    if [[ `command -v proot` ]];then
    echo ""
    else
    echo -e "\e[33;1m Installing some pkg"
    pkg install proot resolv-conf
    fi
    else
    if [[ `command -v wget` ]];then
    echo ""
    else
     echo -e "\e[33;1m Installing some pkg"
    apt install wget 
    fi
    fi
}
req
# make a help function 
help(){
    echo -e "\e[35;1m Cloud is a portforwoding tool using cloudflared"
}
# now start the cloudflare
start_cloud(){
    # remove the previous log file
    rm -rf .pk.txt > /dev/null 2>&1 
    # now ask the url 
    echo -ne "\e[34;1m [~] Enter the url: "
    read link
    echo -e "\e[0;1m Starting clodflare.. "
    #check fi it is termux or not ..
    if [[ `command -v termux-chroot` ]];then
    sleep 3 && termux-chroot ./cloudflare tunnel -url $link --logfile .pk.txt > /dev/null 2>&1 & #throw all the process in background .. 
    else
    sleep 3 && ./cloudflare tunnel -url $link --logfile .pk.txt > /dev/null 2>&1 & 
    fi
    # now extract the link from the logfile .. 
    
    sleep 6
    clear
    banner
    echo -ne "\e[37;1m Link: "
    grep -o 'https://[-a-z0-9]*\.trycloudflare.com' ".pk.txt"

    grep -o 'https://[-0-9a-z]*\.trycloudflare.com'
}
#make a function to download the cloudflared 
download(){
    wget --no-check-certificate $1 -O cloudflare
    chmod +x cloudflare 
}
#first check the platform of the machine 
check_platform(){
if [[ -e cloudflare ]];then
    echo -e "\e[36;1m[~] Cloudflared already installed ."
else
    echo -e "\e[32;1m Downloding coludflared"
    host=$(uname -m)
    if [[($host == "arm") || ($host == "Android")]];then
    download "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm"
    elif [[ $host == "aarch64" ]];then
    download "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
    elif [[ $host == "x86_64" ]];then
    download "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
    else 
    download "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386"
    fi
fi
}
check_platform
start_cloud

