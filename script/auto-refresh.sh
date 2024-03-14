#!/bin/bash

auto_fresh() {
    while true; do
        /script/refresh.sh
        echo 'Refresh Gateway configuration'
        sleep $GATEWAY_REFRESH_SEC
    done
}
auto_fresh
