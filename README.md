# wanem-handler

This script is build for using on a WANem appliance CLI. This script reads the configuration, changes it and optional after rollback time it will reset it to the old values.

This script is primarily for using it with cron daemon to make regulary changes in demonstration environments.

## Usage

Make sure the execution bit for the script is set otherwise you can start it with prepending `/bin/bash` to the script.

The script has some arguments.

| Argument       | Description                  |
|----------------|------------------------------|
| -i=<br>--interface= | [mandatory]<br>define the interface for the tc rule |
| -dt=<br>--delay_time= | [optional]<b>defines new delay time |
| -jr=<br>--jitter_rate= | [only set with delay_time]<br>defines new jitter value |
| -dc=           | [only set with delay_time]                   |
| --delay_correlation=  | defines new delay correlation rate       |
| -lr=           | [optional]                   |
| --loss_rate=   | defines new loss_rate       |
| -lc=           | [only set with loss_rate]                   |
| --loss_correlation=  | defines new loss correlation rate       |
| -cr=           | [optional]                   |
| --corruption_rate=  | defines new corruption rate       |
| -rb=           | [optional]                   |
| --rollback-after=  | duriation in Seconds, how long the new rule should stay. If not set, no rollback will be done (rule persistent)       |
