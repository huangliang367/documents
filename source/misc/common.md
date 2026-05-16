# 通用配置
=====================

## wsl间传文件
=====================

A电脑：

C:\Users\HuangLiang\.wslconfig
写入：
[wsl2]
networkingMode=mirrored
autoProxy=true
dnsTunneling=true
firewall=true

netsh advfirewall firewall add rule name="WSL_SSH_22" dir=in action=allow protocol=TCP localport=22