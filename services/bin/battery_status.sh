#!/usr/bin/env sh

get_battery_symbol() {
    local percent=$1
    if (( percent >= 90 )); then
        echo "󰁹"
    elif (( percent >= 80 )); then
        echo "󰂂"
    elif (( percent >= 70 )); then
        echo "󰂁"
    elif (( percent >= 60 )); then
        echo "󰂀"
    elif (( percent >= 50 )); then
        echo "󰁿"
    elif (( percent >= 40 )); then
        echo "󰁾"
    elif (( percent >= 30 )); then
        echo "󰁼"
    elif (( percent >= 20 )); then
        echo "󰁼"
    elif (( percent >= 10 )); then
        echo "󰁻"
    else
        echo "󰁺"
    fi
}

OUT_FILE="/tmp/battery_status"

while true; do
    BATTERIES=$(upower -e | grep battery)

    if [[ -z "$BATTERIES" ]]; then
        echo "error=No batteries found" > "$OUT_FILE"
        sleep 60
        continue
    fi

    total_energy=0
    total_full=0
    total_rate=0

    any_discharging=false
    any_charging=false

    for bat in $BATTERIES; do
        info=$(upower -i "$bat")

        energy=$(echo "$info" | awk '/energy:/ {print $2}')
        energy_full=$(echo "$info" | awk '/energy-full:/ {print $2}')
        rate=$(echo "$info" | awk '/energy-rate:/ {print $2}')
        state=$(echo "$info" | awk '/state:/ {print $2}')

        total_energy=$(awk "BEGIN {print $total_energy + $energy}")
        total_full=$(awk "BEGIN {print $total_full + $energy_full}")
        total_rate=$(awk "BEGIN {print $total_rate + $rate}")

        [[ "$state" == "discharging" ]] && any_discharging=true
        [[ "$state" == "charging" ]] && any_charging=true
    done

    if $any_discharging; then
        overall_state="discharging"
    elif $any_charging; then
        overall_state="charging"
    else
        overall_state="unknown"
    fi

    percent=$(awk "BEGIN {printf \"%.1f\", ($total_energy / $total_full) * 100}")

    battery_symbol=$(get_battery_symbol "$percent")

    time_str="N/A"
    if [[ "$total_rate" != "0" && "$overall_state" == "discharging" ]]; then
        hours=$(awk "BEGIN {print $total_energy / $total_rate}")
        time_str=$(printf "%02dh %02dm" \
            "$(awk "BEGIN {print int($hours)}")" \
            "$(awk "BEGIN {print int(($hours - int($hours)) * 60)}")")
    elif [[ "$total_rate" != "0" && "$overall_state" == "charging" ]]; then
        remaining=$(awk "BEGIN {print $total_full - $total_energy}")
        hours=$(awk "BEGIN {print $remaining / $total_rate}")
        time_str=$(printf "%02dh %02dm" \
            "$(awk "BEGIN {print int($hours)}")" \
            "$(awk "BEGIN {print int(($hours - int($hours)) * 60)}")")
    fi

    {
        echo "timestamp=\"$(date +%s)\""
        echo "state=\"$overall_state\""
        echo "energy_wh=\"$total_energy\""
        echo "energy_full_wh=\"$total_full\""
        echo "power_w=\"$total_rate\""
        echo "percent=\"$percent\""
        echo "time=\"$time_str\""
        echo "symbol=\"$battery_symbol\""
    } > "${OUT_FILE}.tmp" && mv "${OUT_FILE}.tmp" "$OUT_FILE"

    sleep 30
done