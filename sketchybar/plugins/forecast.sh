#!/usr/bin/env bash
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

temp=$(curl 'https://api.open-meteo.com/v1/forecast?latitude=33.349&longitude=-96.5486&daily=weather_code,temperature_2m_max,temperature_2m_min,rain_sum,showers_sum,wind_speed_10m_max,wind_gusts_10m_max&timezone=America%2FChicago&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch' | jq -r '"☀️\(.current.temperature_2m)° (\(.current.apparent_temperature)°) 💨 \(.current.wind_speed_10m) 🚦 High \(.daily.temperature_2m_max[0])° | Low \(.daily.temperature_2m_min[0])° 🌻 Rise: \(.daily.sunrise[0] | sub(".*T"; "") | sub(":00$"; "") | . + " AM") Set: \(.daily.sunset[0] | sub(".*T"; "") | sub(":00$"; "") | (. | split(":")[0] | tonumber - 12 | tostring) + ":" + (. | split(":")[1]) + " PM")"')


  case "$WTF_ICON" in
    0) ICON="☀️"
    ;;
    [1-3]|45|48) ICON="🌤"
    ;;
    51|53|55|56|57|66|67) ICON="🌨"
    ;;
    [71-77]|85|86) ICON="☃️"
    ;;
    [61-65][80-82]) ICON="☔️"
    ;;
    95|96|99) ICON="💦"
    ;;
    *) ICON="☀️"
  esac

sketchybar --set weather label="$temp"

 https://api.open-meteo.com/v1/forecast?latitude=33.349&longitude=-96.5486&daily=weather_code,temperature_2m_max,temperature_2m_min,rain_sum,showers_sum,wind_speed_10m_max,wind_gusts_10m_max&timezone=America%2FChicago&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch 
 
 
 echo {"latitude":33.346966,"longitude":-96.541145,"generationtime_ms":0.2658367156982422,"utc_offset_seconds":-18000,"timezone":"America/Chicago","timezone_abbreviation":"GMT-5","elevation":217.0,"daily_units":{"time":"iso8601","weather_code":"wmo code","temperature_2m_max":"°F","temperature_2m_min":"°F","rain_sum":"inch","showers_sum":"inch","wind_speed_10m_max":"mp/h","wind_gusts_10m_max":"mp/h"},"daily":{"weather_code":[95,51,81,51,80,3,1],"temperature_2m_max":[82.7,81.8,76.3,81.1,71.5,74.1,74.2],"temperature_2m_min":[71.0,68.9,66.8,62.2,60.2,57.3,53.8],"rain_sum":[0.004,0.031,0.244,0.000,0.000,0.000,0.000],"showers_sum":[0.000,0.000,0.319,0.012,0.150,0.000,0.000],"wind_speed_10m_max":[22.3,22.3,23.4,15.7,17.7,12.4,14.0],"wind_gusts_10m_max":[34.9,30.0,36.9,34.9,25.7,22.8,23.7]}} | jq -r '.daily | {weather_code,temp_max:.temperature_2m_max,temp_min:.temperature_2m_min,rain:.rain_sum} | 
  [range(0;.time|length)] | map({
    code:.weather_code[.],
    emoji:(if .weather_code[.] == 0 then "☀️" 
          elif .weather_code[.] == 1 then "🌤️" 
          elif .weather_code[.] == 2 then "⛅" 
          elif .weather_code[.] == 3 then "☁️" 
          elif .weather_code[.] == 45 or .weather_code[.] == 48 then "🌫️"
          elif .weather_code[.] == 51 then "🌦️"
          elif .weather_code[.] >= 53 and .weather_code[.] <= 57 then "🌧️" 
          elif .weather_code[.] >= 61 and .weather_code[.] <= 65 then "🌧️"
          elif .weather_code[.] >= 71 and .weather_code[.] <= 77 then "❄️"
          elif .weather_code[.] == 80 then "🌦️"
          elif .weather_code[.] == 81 or .weather_code[.] == 82 then "🌧️"
          elif .weather_code[.] == 85 or .weather_code[.] == 86 then "❄️"
          elif .weather_code[.] == 95 then "⛈️"
          elif .weather_code[.] >= 96 then "⛈️🌨️"
          else "❓" end),
    high:.temp_max[.],
    low:.temp_min[.],
    rain:.rain[.]
  }) | map("\(.date): \(.emoji) \(.high)°F/\(.low)°F, \(.rain)\" rain") | join(" | ")'


