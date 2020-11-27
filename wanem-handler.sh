#!/bin/bash

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -i=*|--interface=*)
        dev="${arg#*=}"
        shift
        ;;
        -lr=*|--loss_rate=*)
        loss_rate="${arg#*=}"
        shift
        ;;
        -lc=*|--loss_correlation=*)
        loss_corr="${arg#*=}"
        shift
        ;;
        -cr=*|--corruption_rate=*)
        corrupt_rate="${arg#*=}"
        shift
        ;;
        -cc=*|--corruption_correlation=*)
        corrupt_corr="${arg#*=}"
        shift
        ;;
        -d=*|--duration=*)
        duration="${arg#*=}"
        shift
    esac
done

# check for error
if [ -z "$dev" ]; then
  echo "DEFINE INTERFACE"
  echo "with argument -i=<dev>|--interface=<dev>"
  exit 1
fi

if [ -z "$loss_rate" ]; then
  loss_rate="0%"
fi

if [ -z "$loss_corr" ]; then
  loss_corr="0%"
fi

if [ -z "$corrupt_rate" ]; then
  corrupt_rate="0%"
fi

if [ -z "$corrupt_corr" ]; then
  corrupt_corr="0%"
fi

# get old config
rule_show=$( tc qdisc show dev ${dev} | cut -d  ":" -f2 )
rule_class=$( echo $rule_show | cut -d " " -f1 )
rule_old=$( echo $rule_show | cut -d " " -f2-100 )
if [[ $rule_old == bands* ]]; then
	rule_old=""
fi

# build new config
cmd="tc qdisc replace dev ${dev}"
new_rule="${rule_old} loss ${loss_rate} ${loss_corr} corrupt ${corrupt_rate} ${corrupt_corr}"
new_cmd="${cmd} ${rule_class} netem ${new_rule}"

# print out information
echo "Rule:  " $rule_old
echo "Class: " $rule_class
echo "CMD:   " $new_cmd

# execute CMD
$new_cmd

if [ ! -z "$duration" ];
  sleep $duration
  $new_cmd="${cmd} ${rule_class} ${rule_old}"
fi

exit 0
