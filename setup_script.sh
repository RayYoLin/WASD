#!/bin/bash

# Step 1: 新增資料夾 /mnt/sd
sudo mkdir -p /mnt/sd

# Step 2: 設定資料夾 /mnt/sd 權限 chmod +x
sudo chmod u+x /mnt/sd

# Step 3: 下載檔案 wrcmlog 放入 /usr/sbin
sudo wget -O /usr/sbin/wrcmlog https://github.com/RayYoLin/WASD/raw/main/wrcmlog

# Step 4: 設定 wrcmlog 權限 chmod +x
sudo chmod +x /usr/sbin/wrcmlog

# Step 5: 讓wrcmlog自動執行
rc_local_path="/etc/rc.local"
wrcmlog_path="/usr/sbin/wrcmlog"

# Define the content to be inserted
insert_content="/usr/sbin/wrcmlog"

# Define the file path
file_path="/etc/rc.local"

# Insert the content before the "exit 0" line using sed
sed -i "/exit 0/ i $insert_content" "$file_path"
echo "Inserted $insert_content before exit 0 in $file_path"

# Step 6: 更改 /etc/vsftpd.conf 將 local_root= 改為 local_root = /mnt/sd
sudo sed -i 's/^local_root=.*/local_root=\/mnt\/sd/' /etc/vsftpd.conf

# Step 7: 修改 /etc/network/interfaces
# 新的 IP 位址
new_address="192.168.3.128"

# 備份原始 /etc/network/interfaces 檔案
sudo cp /etc/network/interfaces /etc/network/interfaces.bak

# 修改 /etc/network/interfaces 檔案中 eth0 的 address
sudo sed -i.bak '/^iface eth0 inet static/ {n; s/address .*/address '"$new_address"'/}' /etc/network/interfaces

# 重新啟動網路介面使更改生效（請注意這一步可能會中斷連線，請謹慎執行）
reboot