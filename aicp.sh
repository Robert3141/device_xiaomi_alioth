#!/bin/bash
# TODO change to your preferences
root_dir="/android/aicp"
log_dir="/android/logs"
out_dir="/android/builds"
build_gapps="yes"
build_vanilla="yes"

#directories
device_dir="$root_dir/device/xiaomi/alioth"
gapps_dir="$out_dir/alioth/GAPPs/Images"
vanilla_dir="$out_dir/alioth/GAPPs/Images"
logDate_dir="$log_dir/alioth/$(date +"%Y_%m_%d")"
logLoc="$logDate_dir/$(date +"%p_%I_%M").log"

#vars
vanilla="WITH_GAPPS := false"
gapps="WITH_GAPPS := true"

#set up
cd $root_dir
mkdir "$logDate_dir"&>/dev/null
source ./build/envsetup.sh
export WITH_GMS=true

# GAPPs
if [ "$build_gapps" == "yes" ]; then
    #sed -i "s/$vanilla/$gapps/" $file &>/dev/null
    export WITH_GAPPS=true
    export TARGET_GAPPS_ARCH=arm64
    logLoc="$logDate_dir/$(date +"%p_%I_%M").log"
    mkdir -p "$logData_dir"
    echo "building GAPPs... logging at $logLoc"
    gnome-terminal --tab --title="GAPPS build log (can be closed)" -- sh -c "sleep 3s && tail -f "$logLoc
    brunch aicp_alioth-userdebug > "$logLoc" || { echo "     build failed"; exit 1; }
    cd $root_dir
    rm -rf "$gapps_dir"&>/dev/null
    mkdir -p "$gapps_dir"
    cd out/target/product/alioth
    cp -v *.img "$gapps_dir"
    cd $root_dir
fi

# Vanilla
if [ "$build_vanilla" == "yes" ]; then
    #sed -i "s/$gapps/$vanilla/" $file &>/dev/null
    export WITH_GAPPS=false
    logLoc="$logDate_dir/$(date +"%p_%I_%M").log"
    mkdir -p "$logData_dir"
    echo "building Vanilla... logging at $logLoc"
    gnome-terminal --tab --title="Vanilla build log (can be closed)" -- sh -c "sleep 3s && tail -f "$logLoc
    brunch aicp_alioth-userdebug > "$logLoc" || { echo "     build failed"; exit 1; }
    cd $root_dir
    rm -rf "$vanilla_dir"&>/dev/null
    mkdir -p "$vanilla_dir"
    cd out/target/product/alioth
    cp -v *.img "$vanilla_dir"
    cd $root_dir
    #sed -i "s/$vanilla/$gapps/" $file &>/dev/null

#done
echo "-------DONE-------"
exit 0