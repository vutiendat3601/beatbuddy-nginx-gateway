#!/bin/sh

app_name=$1
app_name_lower=$(echo $app_name | tr '[:upper:]' '[:lower:]')

echo "location ~ ^/$app_name_lower(/|$)" {
echo  "  proxy_set_header Host \$host;"
echo  "  proxy_set_header X-Real-IP \$remote_addr;"
echo  "  proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;"
echo  "  proxy_set_header X-Forwarded-Proto \$scheme;"
echo  "  rewrite ^/$app_name_lower/(.*)$ /\$1 break;"
echo  "  proxy_pass http://$app_name_lower;"
echo }
