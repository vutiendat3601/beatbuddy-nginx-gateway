#!/bin/sh

discovery_url=$1
json_resp=$(curl -sH 'Accept: application/json' $discovery_url)
instances=$(echo $json_resp | jq '[.applications.application[] | .instance[] ]')
echo $instances

