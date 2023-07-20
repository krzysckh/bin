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

v="1.18"
jarfiles="$HOME/.minecraft/versions/$v/$v.jar"

for i in `find $HOME/.minecraft -type f -name '*.jar' | grep -v versions \
          | grep -v lwjgl`; do
  jarfiles="$jarfiles:`echo $i | tr -d '\n'`"
done

for i in `find /usr/local/share/lwjgl3 -type f -name '*.jar'`; do
  jarfiles="$jarfiles:`echo $i | tr -d '\n'`"
done

#portablemc login -m
auth_token=`jq '.microsoft.sessions | flatten | .[0] | .access_token' \
  $HOME/.minecraft/portablemc_auth.json | tr -d '"'`

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
  --version=$v

