#!/bin/sh
#
# minecraft on openbsd
# requires https://github.com/mindstorm38/portablemc
#
# how:
# - $ portablemc start <version> # to download files
# - set $v to <version>
# - $ mc.sh
# - hope it works
#
# for older versions it may require some tweaking because of lwjgl

#set -xe

v=$1
jarfiles="$HOME/.minecraft/versions/$v/$v.jar"

for i in `find $HOME/.minecraft -type f -name '*.jar' | grep -v versions \
          | grep -v lwjgl`; do
  jarfiles="$jarfiles:`echo $i | tr -d '\n'`"
done

for i in `find /usr/local/share/lwjgl3 -type f -name '*.jar'`; do
  jarfiles="$jarfiles:`echo $i | tr -d '\n'`"
done

portablemc start --dry $1

#portablemc login -m
uname=`jq '.microsoft.sessions | flatten | .[0] | .username' \
  $HOME/.minecraft/portablemc_auth.json | tr -d '"'`
auth_token=`jq '.microsoft.sessions | flatten | .[0] | .access_token' \
  $HOME/.minecraft/portablemc_auth.json | tr -d '"'`
uuid=`jq '.microsoft.sessions | flatten | .[0] | .uuid' \
  $HOME/.minecraft/portablemc_auth.json | tr -d '"'`

#echo $jarfiles | tr : '\n'

java \
  -Xmx2G \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+UseG1GC \
  -XX:G1NewSizePercent=20 \
  -XX:G1ReservePercent=20 \
  -XX:MaxGCPauseMillis=50 \
  -XX:G1HeapRegionSize=32M \
  -cp /usr/local/share/lwjgl3/lwjgl.jar:$jarfiles \
  net.minecraft.client.main.Main \
  --accessToken=$auth_token \
  --username=$uname \
  --version=$v \
  --uuid=$uuid \
  --gameDir $HOME/.minecraft \
  --assetsDir $HOME/.minecraft/assets \
  --assetIndex $v \
  --userType microsoft \
  --tweakClass optifine.OptiFineTweaker
