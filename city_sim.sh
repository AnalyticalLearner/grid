#!/bin/bash

read -p "How many days would you like the simulation to run?  " days

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)
DAYS="$days"
NEW_CITIZENS=0
DEATHS=0
FAMILIES=0
VITALS="$CITY/town_hall/vital_records"

setup_city() {
    mkdir -p "$CITY/hospital" "$CITY/church" "$CITY/cemetary" "$CITY/town_hall"
    for SECTOR in "${SECTORS[@]}"; do
        mkdir -p "$CITY/$SECTOR"
    done

    echo -e "Thou shalt not kill.\nHonor thy father and thy mother.\nLove thy neighbor." > "$CITY/church/bible"
    echo -e "Baker\nEngineer\nCarpenter\nFarmer\nTeacher" > "$CITY/town_hall/occupations"
    echo "===== Vital Records =====" > "$VITALS"
}

generate_citizen() {
    SSN=$(uuidgen)
    NAME="citizen_${SSN:0:8}.txt"
    echo "SSN: $SSN" > "$CITY/hospital/$NAME"
    echo "Age: 0" >> "$CITY/hospital/$NAME"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$NAME" "$CITY/$SECTOR/"

    ((NEW_CITIZENS++))
}

increment_ages() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -f "$CITIZEN" ]] || continue
            AGE_LINE=$(grep -n "^Age:" "$CITIZEN" | cut -d: -f1)
            AGE=$(grep "^Age:" "$CITIZEN" | cut -d' ' -f2)
            NEW_AGE=$((AGE + 1))
            sed -i "${AGE_LINE}s/.*/Age: $NEW_AGE/" "$CITIZEN"
        done
    done
}

visit_church() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -f "$CITIZEN" ]] || continue
            if (( RANDOM % 4 == 0 )); then
                VERSE=$(shuf -n 1 "$CITY/church/bible")
                echo "Visited Church: $VERSE" >> "$CITIZEN"
            fi
        done
    done
}

assign_jobs() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -f "$CITIZEN" ]] || continue
            if ! grep -q "^Job:" "$CITIZEN"; then
                JOB=$(shuf -n 1 "$CITY/town_hall/occupations")
                echo "Job: $JOB" >> "$CITIZEN"
            fi
        done
    done
}

create_family() {
    ALL_CITIZENS=()
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -f "$CITIZEN" ]] && ALL_CITIZENS+=("$CITIZEN")
        done
    done

    if (( ${#ALL_CITIZENS[@]} < 2 )); then
        return
    fi

    P1=${ALL_CITIZENS[$RANDOM % ${#ALL_CITIZENS[@]}]}
    P2=${ALL_CITIZENS[$RANDOM % ${#ALL_CITIZENS[@]}]}

    while [[ "$P1" == "$P2" ]]; do
        P2=${ALL_CITIZENS[$RANDOM % ${#ALL_CITIZENS[@]}]}
    done

    SSN=$(uuidgen)
    CHILD="citizen_${SSN:0:8}.txt"
    echo "SSN: $SSN" > "$CITY/hospital/$CHILD"
    echo "Age: 0" >> "$CITY/hospital/$CHILD"
    echo "Parents: $(basename "$P1"), $(basename "$P2")" >> "$CITY/hospital/$CHILD"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$CHILD" "$CITY/$SECTOR/"

    ((FAMILIES++))
    ((NEW_CITIZENS++))
}

process_deaths() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -f "$CITIZEN" ]] || continue
            AGE=$(grep "^Age:" "$CITIZEN" | cut -d' ' -f2)

            # Progressive death chance (much safer under 80)
            if (( AGE > 120 )); then
                CHANCE=2     # 50% chance
            elif (( AGE > 100 )); then
                CHANCE=5     # 20%
            elif (( AGE > 80 )); then
                CHANCE=10    # 10%
            elif (( AGE > 60 )); then
                CHANCE=20    # 5%
            else
                CHANCE=1000  # practically immortal under 60
            fi

            if (( RANDOM % CHANCE == 0 )); then
                echo "Deceased on Day $DAY" >> "$CITIZEN"
                mv "$CITIZEN" "$CITY/cemetary/"
                ((DEATHS++))
            fi
        done
    done
}


count_population() {
    local COUNT=0
    for SECTOR in "${SECTORS[@]}"; do
        COUNT=$(( COUNT + $(find "$CITY/$SECTOR" -type f | wc -l) ))
    done
    echo "$COUNT"
}

log_vitals() {
    POP=$(count_population)
    {
        echo "Day $DAY"
        echo "  Population: $POP"
        echo "  New Citizens: $NEW_CITIZENS"
        echo "  Deaths: $DEATHS"
        echo "  Families Created: $FAMILIES"
        echo "-----------------------------"
    } >> "$VITALS"

    # Print to screen
    echo -e "\n📊 Vital Stats for Day $DAY"
    echo "Population: $POP"
    echo "New Citizens: $NEW_CITIZENS"
    echo "Deaths: $DEATHS"
    echo "Families: $FAMILIES"
    echo "-----------------------------"

    # Reset daily counters
    NEW_CITIZENS=0
    DEATHS=0
    FAMILIES=0
}

run_simulation() {
    for ((DAY=1; DAY<=DAYS; DAY++)); do
        echo -e "\n===== Day $DAY ====="

        # Generate 50–100 new citizens daily
        NEW_BIRTHS=$((RANDOM % 50 + 50))
        for ((i=0; i<NEW_BIRTHS; i++)); do
            generate_citizen
        done

        # Families: 10–20 new per day
        NEW_FAMILIES=$((RANDOM % 10 + 10))
        for ((i=0; i<NEW_FAMILIES; i++)); do
            create_family
        done

        # Assign jobs every 5 days
        (( DAY % 5 == 0 )) && assign_jobs

        # Church visits
        visit_church

        # Age everyone
        increment_ages

        # Death processing (now tuned to kill fewer citizens)
        process_deaths

        # Log and display stats
        log_vitals

        sleep 0.2  # reduce or remove delay for large sims
    done
}


# Entry point
setup_city
run_simulation

