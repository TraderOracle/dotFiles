#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

temp=$(curl 'https://api.open-meteo.com/v1/forecast?latitude=32.8959&longitude=-97.0372&daily=sunrise,sunset,temperature_2m_max,temperature_2m_min&hourly=temperature_2m&current=temperature_2m,wind_speed_10m,wind_gusts_10m,apparent_temperature,precipitation&timezone=America%2FChicago&forecast_days=1&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch' | jq -r '"☀️\(.current.temperature_2m)° (\(.current.apparent_temperature)°) 💨 \(.current.wind_speed_10m) 🚦 High \(.daily.temperature_2m_max[0])° | Low \(.daily.temperature_2m_min[0])° 🌻 Rise: \(.daily.sunrise[0] | sub(".*T"; "") | sub(":00$"; "") | . + " AM") Set: \(.daily.sunset[0] | sub(".*T"; "") | sub(":00$"; "") | (. | split(":")[0] | tonumber - 12 | tostring) + ":" + (. | split(":")[1]) + " PM")"')

sketchybar --set weather label="$temp"
