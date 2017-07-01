# Setup LAMP Server

```
curl -fsSL https://gist.githubusercontent.com/Arahabica/ea12ebccb7cea5b0f85e310d4698506a/raw/aacde8ea47797779997d3824e6cf2c1ccdb09665/CentOS_LAMP_Setup.sh | sh
```
# Add webmaster user

webmaster can edit /var/www

```
P=YOUR_WEBMASTER_PASSWORD && curl -fsSL https://gist.githubusercontent.com/Arahabica/998bddd47de8cfd5f12a02ba6364ef57/raw/0d1a1bbd2fa63daadc456f611e5b9a7161019d43/set_webmaster_user.sh | sed "s/WEBMASTER_PASSWORD/$P/g" | sh
```

# Sync Servers

Sync /var/www directory between multiple servers.

## Master Server

* Replace **`YOUR_SLAVE_PRIVATE_IP`**
```
IPS=YOUR_SLAVE_PRIVATE_IP1,YOUR_SLAVE_PRIVATE_IP2 && curl -fsSL https://raw.githubusercontent.com/Arahabica/SYNC_LAMP/5133f8c2f2505ab3445631ed56dd9db362ebea07/sync_master.sh | IPS=${IPS} sh
```
## Slave Servers

* Replace **`YOUR_MASTER_PRIVATE_IP`**, **`YOUR_MASTER_PUBLIC_KEY`**

```
IP=YOUR_MASTER_PRIVATE_IP && KEY="YOUR_MASTER_PUBLIC_KEY" && curl -fsSL https://gist.githubusercontent.com/Arahabica/ec9dd780691265485fb333144bba5c1b/raw/e0a2d7dcba194e2430c0b9a06264c861ee92d031/sync_slave.sh | IP=${IP} KEY=${KEY} sh'
```
