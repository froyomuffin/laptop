#!/usr/bin/env sh

POWER_STATES=$(ioreg -l -w0 | grep 'BatteryPowered\|ExternalPowerConnected\|IsCharging' | awk -F '|' '{ print $NF }' | sed 's/ *//')
ACTIVE_POWER_STATES=$(echo "$POWER_STATES" | grep 'Yes')

CHARGING=$(echo "$ACTIVE_POWER_STATES" | grep 'IsCharging')
AC_CONNECTED=$(echo "$ACTIVE_POWER_STATES" | grep 'ExternalPowerConnected')

PERCENTAGE=$(ioreg -l -w0 | grep \"StateOfCharge | sed -E 's/.*"StateOfCharge"=([0-9]+),.*/\1/g') # Hardware battery level

if [[ $CHARGING != "" ]]; then
  ICON=""
elif [[ $AC_CONNECTED != "" ]]; then
  ICON="ﮣ"
else
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=""
      ;;
    [6-8][0-9]) ICON=""
      ;;
    [3-5][0-9]) ICON=""
      ;;
    [1-2][0-9]) ICON=""
      ;;
    *) ICON=""
  esac
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"
