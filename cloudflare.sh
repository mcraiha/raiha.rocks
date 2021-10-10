#!/bin/sh
DOTNET_CLI_TELEMETRY_OPTOUT=1
dotnet tool install -g Wyam.Tool
wyam --recipe Blog --theme CleanBlog
echo %date% %time% > output/buildinfo.txt