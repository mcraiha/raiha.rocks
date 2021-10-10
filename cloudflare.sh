#!/bin/sh
DOTNET_CLI_TELEMETRY_OPTOUT=1
# curl -sSL https://dot.net/v1/dotnet-install.sh > dotnet-install.sh
# chmod +x dotnet-install.sh
# ./dotnet-install.sh -c 5.0 -InstallDir ./dotnet5
# export DOTNET_ROOT=/opt/buildhome/dotnet5
# echo $DOTNET_ROOT
#./dotnet5/dotnet --version
#./dotnet5/dotnet tool install -g Wyam.Tool
dotnet tool install -g Wyam.Tool
wyam --recipe Blog --theme CleanBlog
echo %date% %time% > output/buildinfo.txt