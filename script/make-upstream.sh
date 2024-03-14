#!/bin/sh

read line
app_name=$1
app_name_lower=$(echo $app_name | tr '[:upper:]' '[:lower:]')
service_path=$(echo $line | jq --arg app $app_name -r '.[] | select(.app == $app) | "  server \(.ipAddr):\(.port."$");"')
if [ -n "$service_path" ]; then
    echo upstream $app_name_lower {
    echo "$service_path"
    echo }
else
    exit 1;
fi
