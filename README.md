# Setup LAMP Server

* CentOS6
* Apache 2.2
* MySQL Client 5.7
* PHP5.6

## Launch Server (if AWS)
Console GUI

EC2 > インスタンス作成 > AWS Market Place > CentOS 6 (x86_64) - with Updates HVM > 各種設定 > インスタンス作成

EC2 > Elastic IP > IP作成

Elastic IP > 該当IPのレコード > 右クリック > 関連付け

\> 作成 > インスタンスとPrivate IPを選択 > OK

## Setup LAMP Server

```
curl -fsSL https://raw.githubusercontent.com/Arahabica/SYNC_LAMP/fd7c6193d3c12a43a4815dc6ab333561201f34ec/setup_lamp.sh | sh
```

# Auto Recovery  (if AWS)

ref) http://aws.typepad.com/aws_japan/2015/03/ec2-auto-recovery-new-region.html

EC2のインスタンス一覧画面 > 対象インスタンスの行 > アラームステータスのベルをクリック

Send Notification > Create Topic > Topic Nameを適当につける > 通知先メールアドレスを入力
Take the Action > Recover this instance

登録したメールアドレスに確認メールが届いているので、処理をする


# Add webmaster user

webmaster can edit /var/www

* Replace **`YOUR_WEBMASTER_PASSWORD`**
```
P=YOUR_WEBMASTER_PASSWORD && curl -fsSL https://raw.githubusercontent.com/Arahabica/SYNC_LAMP/fd7c6193d3c12a43a4815dc6ab333561201f34ec/add_webmaster.sh | sed "s/WEBMASTER_PASSWORD/$P/g" | sh
```

# Sync Servers

Sync /var/www directory between multiple servers.

## Master Server

* Replace **`YOUR_SLAVE_PRIVATE_IP`**
```
IPS=YOUR_SLAVE_PRIVATE_IP1,YOUR_SLAVE_PRIVATE_IP2 && curl -fsSL https://raw.githubusercontent.com/Arahabica/SYNC_LAMP/5133f8c2f2505ab3445631ed56dd9db362ebea07/sync_master.sh | IPS=${IPS} sh
sudo bash reboot
```


## Slave Servers

### Set Security Group (if AWS)
EC2 > Security Group

Security Group 作成

TCP 873 VPCのIPレンジ(172.31.0.0/16など)

SlaveのEC2にこのSecurity Groupを割り当てる。


* Replace **`YOUR_MASTER_PRIVATE_IP`**, **`YOUR_MASTER_PUBLIC_KEY`**

```
IP=YOUR_MASTER_PRIVATE_IP && KEY="YOUR_MASTER_PUBLIC_KEY" && curl -fsSL https://raw.githubusercontent.com/Arahabica/SYNC_LAMP/a5fc217c488938a175a3b65e58dabe97a5e4b486/sync_slave.sh | IP=${IP} KEY="${KEY}" sh
```
