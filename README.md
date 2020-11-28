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
|---------------------|------------------------------|
| -i=<br>--interface= | **[mandatory]**<br>define the interface for the tc rule |
| -dt=<br>--delay_time= | [optional]<br>defines new delay time in Miliseconds (ms)|
| -jr=<br>--jitter_rate= | [only set with delay_time]<br>defines new jitter value in Milliseconds (ms) |
| -dc=<br>--delay_correlation= | [only set with delay_time]<br>defines new delay correlation rate in percent (%) |
| -lr=<br>--loss_rate= | [optional]<br>defines new loss_rate in percent (%)      |
| -lc=<br>--loss_correlation= | [only set with loss_rate]<br>defines new loss correlation rate in percent (%)       |
| -cr=<br>--corruption_rate=  | [optional]<br>defines new corruption rate in percent (%)     |
| -rb=<br>--rollback-after= | [optional]<br>duration in Seconds, how long the new rule should stay. If not set, no rollback will be done (rule persistent)       |
| --debug  | [optional]<br>print some debug outputs |

## Example

This is an example for crontab
```
# m  h  dom mon dow   command
*/1  *   *   *   *    /root/wanem-handler.sh -i=eth6 -lr=35 -lc=45 -cr=20 -rb=30
```

This crontab is executed
- every minute
- on intgerface `eth6`
- with parameters
  - loss-rate 35%
  - loss-correlation 45%
  - corruption rate 45%
- and will be rolled back to old values after 30 seconds
