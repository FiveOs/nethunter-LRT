#!/bin/sh


# HELP FUNCTIONS

isProgramInPath () {
	echo "Checking if $1 is installed"
    command -v $1 >/dev/null 2>&1 && echo "$1 FOUND" || { echo >&2 "We require $1 but it's not installed/in path.\nAborting."; exit 1; }
    echo "Checking if $1 is installed DONE\n"
}

deleteGitIgnore () { 
    rm -rf $1.gitignore
}

isEmpty () { 
    if find $1 -maxdepth 0 -empty | read v; then echo "Dir $1 is empty. Files are missing\nAborting."; exit 1; else echo "Dir $1 has files"; fi
}

isAdbConnected () {
    adbState=$(adb get-state)
    if [ "$adbState" = "device" ] || [ "$adbState" = "recovery" ] ; then echo "ADB device detected."; else echo "ADB DEVICE NOT DETECTED!!!\nAborting."; exit 1; fi
}

isAdbLatest(){
    # Remove periods from version numbers
    adbLatest="1033"
    adbVersion=`adb 2>&1 | awk -F '"' '/Android Debug Bridge version/' | cut -c30- | tr -d '.'`
    
    if [ "$adbVersion" -lt "$adbLatest" ]; then
        echo "You are using an older version of ADB. Please download the latest ADB."
        read -p "Continue..."
    else
        echo "You are using the latest version of ADB"
    fi    
}

opoModelCheck () {
    opo16="16gb"
    opo64="64gb"
    if [ -z "$1" ]
        then
            echo "No model supplied\nAborting."
            exit 1
        else
            if [ "$1" = "$opo16" ] || [ "$1" = "$opo64" ] ; then echo "Using $1 userData for flash"; else echo "Model argument found but invalid ($1), check the README!!!\nAborting."; exit 1; fi
            if [ "$1" = "$opo16" ] ; then fUserData="userdata.img"; fi
            if [ "$1" = "$opo64" ] ; then fUserData="userdata_64G.img"; fi
    fi

}

doCommonChecks () {

    isProgramInPath adb

    isAdbLatest

    isProgramInPath fastboot

    echo "Adb connection check"
    isAdbConnected
    echo "Adb connection check DONE\n"

}
