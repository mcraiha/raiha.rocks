#!/bin/sh
DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_ROOT=/opt/buildhome/.dotnet
dotnet --version
dotnet tool install -g Wyam.Tool
wyam --recipe Blog --theme CleanBlog
echo %date% %time% > output/buildinfo.txt