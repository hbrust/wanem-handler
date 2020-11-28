# wanem-handler

This script is build for using on a WANem appliance CLI. This script reads the configuration, changes it and optional after rollback time it will reset it to the old values.

This script is primarily for using it with cron daemon to make regulary changes in demonstration environments.

## Usage

Copy the script to your WANem appliance.
```
wget --no-check-certificate https://raw.githubusercontent.com/hbrust/wanem-handler/master/wanem-handler.sh
```

Make sure the execution bit for the script is set otherwise you can start it with prepending `/bin/bash` to the script.

The script has some arguments.

| Argument       | Description                  |
|----------------|------------------------------|
| -i=<br>--interface= | **[mandatory]**<br>define the interface for the tc rule |
| -dt=<br>--delay_time= | [optional]<br>defines new delay time |
| -jr=<br>--jitter_rate= | [only set with delay_time]<br>defines new jitter value |
| -dc=<br>--delay_correlation= | [only set with delay_time]<br>defines new delay correlation rate |
| -lr=<br>--loss_rate= | [optional]<br>defines new loss_rate       |
| -lc=<br>--loss_correlation= | [only set with loss_rate]<br>defines new loss correlation rate       |
| -cr=<br>--corruption_rate=  | [optional]<br>defines new corruption rate       |
| -rb=<br>--rollback-after= | [optional]<br>duration in Seconds, how long the new rule should stay. If not set, no rollback will be done (rule persistent)       |
