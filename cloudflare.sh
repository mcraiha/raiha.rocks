#!/bin/sh
DOTNET_CLI_TELEMETRY_OPTOUT=1
curl -sSL https://dot.net/v1/dotnet-install.sh > dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh -c 2.1 -InstallDir ./dotnet2
export DOTNET_ROOT=/opt/buildhome/repo/dotnet2
echo $DOTNET_ROOT
./dotnet2/dotnet --info
./dotnet2/dotnet tool install -g Wyam.Tool
wyam --recipe Blog --theme CleanBlog
CURRENTDATE=`date +"%Y-%m-%d %T"`
echo $CURRENTDATE > output/buildinfo.txt