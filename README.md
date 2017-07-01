# Setup LAMP Server

# Add webmaster user

webmaster can edit /var/www

# Sync Servers

Sync /var/www directory between multiple servers.

## Master Server

* Replace **`YOUR_SLAVE_PRIVATE_IP`**
```
curl -fsSL https://raw.githubusercontent.com/Arahabica/SYNC_LAMP/5133f8c2f2505ab3445631ed56dd9db362ebea07/sync_master.sh | IPS=YOUR_SLAVE_PRIVATE_IP1,YOUR_SLAVE_PRIVATE_IP2 sh
```
## Slave Servers

* Replace **`YOUR_MASTER_PRIVATE_IP`**, **`YOUR_MASTER_PUBLIC_KEY`**

```
curl -fsSL https://gist.githubusercontent.com/Arahabica/ec9dd780691265485fb333144bba5c1b/raw/e0a2d7dcba194e2430c0b9a06264c861ee92d031/sync_slave.sh | IP=YOUR_MASTER_PRIVATE_IP KEY="YOUR_MASTER_PUBLIC_KEY" sh'
```
