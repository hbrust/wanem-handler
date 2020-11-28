#!/bin/bash

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -i=*|--interface=*)
        dev="${arg#*=}"
        shift
        ;;
        -dt=*|--delay_time=*)
        delay_time="${arg#*=}"
        shift
        ;;
        -jr=*|--jitter_rate=*)
        jitter="${arg#*=}"
        shift
        ;;
        -dc=*|--delay_correlation=*)
        delay_corr="${arg#*=}"
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

# get old config
rule_show=$( tc qdisc show dev ${dev} | cut -d  ":" -f2 )
rule_class=$( echo $rule_show | cut -d " " -f1 )
rule_old=$( echo $rule_show | cut -d " " -f2-100 )
if [[ $rule_old == bands* ]]; then
	rule_old=""
fi
rule_old_params=$rule_old


# set default
limit_param="1000"
delay_param="0 0 0"
loss_param="0 0"
corrupt_param="0"


# get old parameter
for param in $rule_old_params
do
  case $param in
    limit)
      shift
      limit_param=()
      next="limit_param"
      ;;
    delay)
      shift
      delay_param=()
      next="delay_param"
      ;;
    loss)
      shift
      loss_param=()
      next="loss_param"
      ;;
    corrupt)
      shift
      corrupt_param=()
      next="loss_param"
      ;;
    [0-9]*)
      eval "$next+=\"\$param \""
      ;;
    *)
      ;;
  esac
done
echo "Limit: "$limit_param
echo "Delay: "$delay_param
echo "Loss: "$loss_param
echo "Corr: "$corrupt_param


# build new config
base_cmd="tc qdisc replace dev ${dev}"

if [ ! -z $limit ]; then
  delay_cmd="limit ${limit}"
else
  delay_cmd="delay ${delay_param}"
fi

if [ ! -z $delay_time ]; then
  delay_cmd="delay ${delay_time} ${jitter} ${delay_corr}"
else
  delay_cmd="delay ${delay_param}"
fi

if [ ! -z $loss_rate ]; then
  loss_cmd="loss ${loss_rate} ${loss_corr}"
else
  loss_cmd="loss ${loss_param}"
fi

if [ ! -z $corrupt_time ]; then
  corrupt_cmd="corrupt ${corrupt_rate}"
else
  corrupt_cmd="corrupt ${corrupt_param}"
fi

new_rule="${delay_cmd} ${loss_cmd} ${corrupt_cmd}"
new_cmd="${base_cmd} ${rule_class} netem ${new_rule}"

# print out information
echo "Rule: " $new_rule
echo "Class: " $rule_class
echo "CMD:   " $new_cmd

# execute CMD
$new_cmd

if [ ! -z "$duration" ]; then
  sleep $duration
  $new_cmd="${base_cmd} ${rule_class} netem limit $limit_param delay $delay_param loss $loss_param corrupt $corrupt_param"
  echo "Rollback: " $new_cmd
  $new_cmd
fi

exit 0
