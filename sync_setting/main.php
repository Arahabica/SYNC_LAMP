<?php
//const CONFIG_PATH = null;
$config_path = "/etc/lsyncd.conf";
const IPS_PATH = dirname(__FILE__) . '/ips';

function main($argv) {
  $i = 0;
  $ips = array();
  foreach($argv as $ip) {
    if ($i > 0) {
      $ips[] = str_replace('"','',$ip);
    }
    $i++;
  }
  $ips_csv = implode(",",$ips);
  $txt = file_get_contents(IPS_PATH);
  if ( $txt != $ips_csv) {
    file_put_contents(IPS_PATH, $ips_csv);
    echo $ips_csv;
    rewrite_config($ips);
  } else {
    echo "nothing change";
  }
}

function rewrite_config($ips) {
  $txt = <<< EOM
----
-- User configuration file for lsyncd.
--
-- Simple example for default rsync, but executing moves through on the target.
--
-- For more examples, see /usr/share/doc/lsyncd*/examples/
--
-- sync{default.rsyncssh, source="/var/www/html", host="localhost", targetdir="/tmp/htmlcopy/"}

settings {
        logfile    = "/var/log/lsyncd.log",
        statusFile = "/tmp/lsyncd.stat",
        statusInterval = 1,
        maxProcesses = 2,
        nodaemon     = false,
        insist       = 1,
}

EOM;

  foreach($ips as $ip) {

    $txt .= <<< EOM
sync{
        default.rsync,
        source="/var/www",
        target="${ip}::target",
        rsync = {
          _extra = {
            "-a",
            "--timeout=600",
            "--contimeout=12"
           }
        }
}

EOM;
  }
  if (!empty(CONFIG_PATH)) {
    file_put_contents($config_path, $txt);
    exec("service lsyncd restart");
  } else {
    echo $txt;
  }
}
main($argv);
?>
