#!/bin/bash

eureka_api_apps="$GATEWAY_EUREKA_SERVER_URL/v2/apps"
instances=$(./discover-service.sh $eureka_api_apps)
if [ -n "$instances" ]; then
    echo "Instances found."
else
    echo "No instances found."
    exit 1
fi

IFS=',' read -r -a service_ids <<< "$GATEWAY_SERVICES"
upstream_conf_file=upstream.conf
location_conf_file=location.conf
upstream_conf_new="$upstream_conf_file.new"
location_conf_new="$location_conf_file.new"
paths=($upstream_conf_new $location_conf_new)
for path in "${paths[@]}";  do
    if [ -e "$path" ]; then
        rm "$path"
        echo "File '$path' removed."
    fi
done
for service_id in "${service_ids[@]}"; do
    upstream_paths=$(echo $instances | ./make-upstream.sh $service_id)
    echo "$upstream_paths"
    if [ $? -eq 0 ] && [ -n "$upstream_paths" ]; then 
      echo "$upstream_paths" >> "$upstream_conf_new"
      ./make-location.sh $service_id >> "$location_conf_new"
    fi
done

if [ -n "$GATEWAY_PROXY_CONFIG_DIR" ]; then
    mkdir -p $GATEWAY_PROXY_CONFIG_DIR
    mv $upstream_conf_new "$GATEWAY_PROXY_CONFIG_DIR/proxy/$upstream_conf_file"
    mv $location_conf_new "$GATEWAY_PROXY_CONFIG_DIR/proxy/$location_conf_file"
    nginx -t && nginx -s reload
fi
