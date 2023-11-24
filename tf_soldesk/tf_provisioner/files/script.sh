#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
sleep 1
done


yum update & yum install -y httpd
echo "<h1>Userdata EC@</h1>" >> /var/www/html/index.html
systemctl start httpd
systemctl enable httpd