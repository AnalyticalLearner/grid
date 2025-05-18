# 🏙️ Digital City Simulation (Bash)

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Bash](https://img.shields.io/badge/Bash-5.x+-informational)
![Dependencies: None](https://img.shields.io/badge/Dependencies-None-brightgreen)
![Platform: POSIX](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20WSL-informational)
![Citizens Simulated](https://img.shields.io/badge/Citizens-Millions--Capable-success)

This is a **Bash-based simulation** of a growing digital city where each citizen is represented as a text file with a unique SSN (UUID). The city grows over simulated days through births and family creation, and ages and loses citizens through a progressive death system.

---

## 📁 City Structure

Upon running the simulation, a `city/` directory is created with the following subdirectories:

- `hospital/` – Where new citizens are born
- `sector1/` to `sector4/` – Where citizens live
- `church/` – Where citizens receive daily wisdom
- `town_hall/` – Contains `occupations` and `vital_records`
- `cemetary/` – Where deceased citizens are moved

---

## 👤 Citizens

Each citizen is a `.txt` file containing:

- Unique SSN
- Age
- (Eventually) Job
- (Optionally) Parents
- Church visit history
- Death record (if applicable)

---

## ⚙️ Features

- 🧬 **Citizen Generation**: 50–100 new citizens born each simulated day
- 🍼 **Family Creation**: 10–20 new family units formed daily, with children linked to parents
- 🧓 **Aging**: Each citizen's age increases daily
- 🪦 **Death Logic**: Probability-based aging death model, safest under age 60
- 🙏 **Church Visits**: Some citizens receive a Bible verse (random line from `church/bible`)
- 🧑‍🔧 **Job Assignment**: Citizens get occupations from a list every 5 days
- 📊 **Vital Records**: Daily stats logged to `town_hall/vital_records` and printed to screen

---

## 🚀 How to Run

1. **Ensure Bash is available** (Linux, macOS, or WSL on Windows)
2. Save the script as `city_simulation.sh`
3. Make it executable:
   ```bash
   chmod +x city_simulation.sh
```

---

# 🧰 City Query Tool (`city_query.sh`)

A command-line companion to the [Digital City Simulation](../city_sim.sh), this script lets you explore and analyze your city’s digital population. Use it to search citizens, gather statistics, and inspect citizen files after the simulation has been run.

---

## 🔍 Features

- View total and sector-based **population counts**
- Search citizens by **job title**
- Lookup individuals by **SSN or filename**
- Show **average age** and total population stats

---

## 🛠️ Commands

### `population`
Displays the number of living citizens in each sector and the total population.

`./city_query.sh population`

Shows total living population and average age across the city.
`./city_query.sh stats`

Finds and lists all citizens who have the specified job.
`./city_query.sh job Farmer`

Yesterday
Previous 7 Days
Previous 30 Days
PHP Script Optimization
Bash script directory creation
MCP Script Documentation
Sanitize script configuration
Script Optimization Suggestions
Upgrade plan
More access to the best models
You said:
I would like to build a digital simulation of a city in Bash. The citizens will be generated files which should be assigned a UID (within the file) which will serve as a social security number (SSN). The city (a directory) will have several sub directories as follows:
hospital, church, cemetary, town_hall, sector1, sector2, sector3, sector4

The citizens will be generated in the "hospital" directory, where they'll be assigned a SSN and then sent to a sector at random. In the "church" directory there will be a text file called bible. Periodically citizens will randomly be sent to the "church" directory where they will receive a sinlge line of text from the bible file.

Citizens will also be sent to the town_hall directory every XX number of days (or cycles) where they will receive a
"job" from a text file list called "occupations".

Two citizens can serve as parents to a third citizen at random. However, each child file should have a line within that states who the parents are.
ChatGPT said:
Updated saved memory
This is a fun and creative use of Bash! Here’s a basic structure you can use to start building your simulation. It sets up the directories, creates citizens as files with SSNs, moves them into sectors, and includes logic for visiting church and town hall.

1. Setup Script: setup_city.sh
#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)
mkdir -p "$CITY"/{hospital,church,cemetary,town_hall,${SECTORS[*]}}

# Sample data files
echo -e "Thou shalt not kill.\nHonor thy father and thy mother.\nLove thy neighbor." > "$CITY/church/bible"
echo -e "Baker\nEngineer\nCarpenter\nFarmer\nTeacher" > "$CITY/town_hall/occupations"
2. Citizen Generator: generate_citizen.sh
#!/bin/bash

CITY="city"
HOSPITAL="$CITY/hospital"
SECTORS=(sector1 sector2 sector3 sector4)
SSN=$(uuidgen)
NAME="citizen_${SSN:0:8}.txt"

echo "SSN: $SSN" > "$HOSPITAL/$NAME"

# Assign to a random sector
SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
mv "$HOSPITAL/$NAME" "$CITY/$SECTOR/"
3. Church Visit: visit_church.sh
#!/bin/bash

CITY="city"
CHURCH="$CITY/church"
SECTORS=(sector1 sector2 sector3 sector4)
BIBLE="$CHURCH/bible"

for SECTOR in "${SECTORS[@]}"; do
    for CITIZEN in "$CITY/$SECTOR"/*.txt; do
        if (( RANDOM % 5 == 0 )); then
            VERSE=$(shuf -n 1 "$BIBLE")
            echo "Visited Church: $VERSE" >> "$CITIZEN"
        fi
    done
done
4. Town Hall Visit: assign_jobs.sh
#!/bin/bash

CITY="city"
TOWN_HALL="$CITY/town_hall"
SECTORS=(sector1 sector2 sector3 sector4)
JOBS="$TOWN_HALL/occupations"

for SECTOR in "${SECTORS[@]}"; do
    for CITIZEN in "$CITY/$SECTOR"/*.txt; do
        if ! grep -q "Job:" "$CITIZEN"; then
            JOB=$(shuf -n 1 "$JOBS")
            echo "Job: $JOB" >> "$CITIZEN"
        fi
    done
done
5. Parenting Script: create_family.sh
#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)

ALL_CITIZENS=()
for SECTOR in "${SECTORS[@]}"; do
    for CITIZEN in "$CITY/$SECTOR"/*.txt; do
        ALL_CITIZENS+=("$CITIZEN")
    done
done

if (( ${#ALL_CITIZENS[@]} < 2 )); then
    echo "Not enough citizens to create a child."
    exit 1
fi

P1=${ALL_CITIZENS[$RANDOM % ${#ALL_CITIZENS[@]}]}
P2=${ALL_CITIZENS[$RANDOM % ${#ALL_CITIZENS[@]}]}

while [[ "$P1" == "$P2" ]]; do
    P2=${ALL_CITIZENS[$RANDOM % ${#ALL_CITIZENS[@]}]}
done

SSN=$(uuidgen)
CHILD_NAME="citizen_${SSN:0:8}.txt"
echo "SSN: $SSN" > "$CITY/hospital/$CHILD_NAME"
echo "Parents: $(basename "$P1"), $(basename "$P2")" >> "$CITY/hospital/$CHILD_NAME"

# Move to random sector
SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
mv "$CITY/hospital/$CHILD_NAME" "$CITY/$SECTOR/"
You can set up a simulation loop using a shell script to periodically invoke these behaviors.

Would you like a sample loop that runs these scripts on a time interval (e.g., simulating a "day")?

You said:
Let's create a simulation loop. If possible, can that loop as well as each script become a function within a larger single script?
ChatGPT said:
Yes, you can absolutely combine all the logic into one Bash script using functions to modularize the behavior. Below is a self-contained city simulation script that includes setup, citizen generation, church visits, job assignments, family creation, and a simulation loop.

✅ Full Script: city_simulation.sh
#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)
DAYS=30  # Number of simulation cycles

setup_city() {
    mkdir -p "$CITY"/{hospital,church,cemetary,town_hall,${SECTORS[*]}}
    echo -e "Thou shalt not kill.\nHonor thy father and thy mother.\nLove thy neighbor." > "$CITY/church/bible"
    echo -e "Baker\nEngineer\nCarpenter\nFarmer\nTeacher" > "$CITY/town_hall/occupations"
}

generate_citizen() {
    SSN=$(uuidgen)
    NAME="citizen_${SSN:0:8}.txt"
    echo "SSN: $SSN" > "$CITY/hospital/$NAME"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$NAME" "$CITY/$SECTOR/"
}

visit_church() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -e "$CITIZEN" ]] || continue
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
            [[ -e "$CITIZEN" ]] || continue
            if ! grep -q "Job:" "$CITIZEN"; then
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
            [[ -e "$CITIZEN" ]] && ALL_CITIZENS+=("$CITIZEN")
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
    echo "Parents: $(basename "$P1"), $(basename "$P2")" >> "$CITY/hospital/$CHILD"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$CHILD" "$CITY/$SECTOR/"
}

run_simulation() {
    for ((DAY=1; DAY<=DAYS; DAY++)); do
        echo "===== Day $DAY ====="
        
        # Generate a new citizen every day
        generate_citizen
        
        # Every 5 days, assign jobs to those without one
        (( DAY % 5 == 0 )) && assign_jobs
        
        # Random church visits
        visit_church

        # Every 3 days, randomly create a family
        (( DAY % 3 == 0 )) && create_family

        sleep 1
    done
}

# Start simulation
setup_city
run_simulation
✅ How to Run
Save it as city_simulation.sh

Give it execute permission:

chmod +x city_simulation.sh
Run:

./city_simulation.sh
This script simulates 30 days (can be adjusted) and modularly contains all the behaviors you described. Would you like to add logging, aging or death, or visual stats output as a next step?

You said:
Add a script to city_simulation.sh which facilitates death (removal) of scripts periodically.
ChatGPT said:
To simulate death in your digital city, we can introduce a function that periodically selects a few citizens at random and moves their files to the cemetary directory—symbolizing that they’ve “died.” This can be triggered every X days or with a given probability each cycle.

Here’s how to add a process_deaths function to your city_simulation.sh:

🔧 Add to the Main Script
Insert this function somewhere before the run_simulation() function:

process_deaths() {
    echo "Processing deaths..."
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -e "$CITIZEN" ]] || continue
            if (( RANDOM % 20 == 0 )); then  # 1-in-20 chance of death per citizen per day
                echo "Deceased: $(basename "$CITIZEN")"
                mv "$CITIZEN" "$CITY/cemetary/"
            fi
        done
    done
}
You can also include a timestamp or reason in their file to mark when or why they died, like this:

echo "Deceased on Day $DAY" >> "$CITY/cemetary/$(basename "$CITIZEN")"
🧠 Modify the Simulation Loop to Include Deaths
Inside your run_simulation() loop, add a call to process_deaths at the appropriate place:

run_simulation() {
    for ((DAY=1; DAY<=DAYS; DAY++)); do
        echo "===== Day $DAY ====="

        generate_citizen
        (( DAY % 5 == 0 )) && assign_jobs
        visit_church
        (( DAY % 3 == 0 )) && create_family

        process_deaths  # <== Deaths processed daily or based on logic

        sleep 1
    done
}
📝 Result
Every day, some citizens may die and be moved to the cemetary folder.

Their files are no longer accessible in the sectors, town_hall, or church.

You can later extend this to include "aging" or cause-specific deaths.

Would you like to implement aging or cap a citizen’s lifespan based on creation time or lines in the file?

You said:
Make the following correction to city_simulation.sh. All sector directories are subdirectories to City. 
ChatGPT said:
To correct your city_simulation.sh script so that all sector directories are properly nested under the main city directory, you'll need to ensure that:

The mkdir command correctly creates sectors as subdirectories of the city.

Any reference to the sector paths in the script uses the full path: "$CITY/$SECTOR"

✅ Here's the corrected portion of your script:
1. Fix the setup_city function:
Replace:

mkdir -p "$CITY"/{hospital,church,cemetary,town_hall,${SECTORS[*]}}
With:

mkdir -p "$CITY/hospital" "$CITY/church" "$CITY/cemetary" "$CITY/town_hall"
for SECTOR in "${SECTORS[@]}"; do
    mkdir -p "$CITY/$SECTOR"
done
2. Ensure all file moves and references use "$CITY/$SECTOR"
For example, in functions like generate_citizen, visit_church, assign_jobs, and create_family, make sure you're always using:

"$CITY/$SECTOR"
Instead of just:

"$SECTOR"
✅ Example Fix in generate_citizen():
generate_citizen() {
    SSN=$(uuidgen)
    NAME="citizen_${SSN:0:8}.txt"
    echo "SSN: $SSN" > "$CITY/hospital/$NAME"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$NAME" "$CITY/$SECTOR/"
}
Repeat this structure in all relevant places to ensure consistency.

Would you like me to consolidate the updated full script and share it with all the corrections applied?

You said:
yes, please update the full script.
ChatGPT said:
Here is the fully updated and corrected city_simulation.sh script, with:

All sector directories properly nested under the main city directory.

Citizens moving between those directories.

Added death processing (process_deaths) function.

✅ city_simulation.sh
#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)
DAYS=30  # Total number of simulation cycles ("days")

setup_city() {
    mkdir -p "$CITY/hospital" "$CITY/church" "$CITY/cemetary" "$CITY/town_hall"
    for SECTOR in "${SECTORS[@]}"; do
        mkdir -p "$CITY/$SECTOR"
    done

    echo -e "Thou shalt not kill.\nHonor thy father and thy mother.\nLove thy neighbor." > "$CITY/church/bible"
    echo -e "Baker\nEngineer\nCarpenter\nFarmer\nTeacher" > "$CITY/town_hall/occupations"
}

generate_citizen() {
    SSN=$(uuidgen)
    NAME="citizen_${SSN:0:8}.txt"
    echo "SSN: $SSN" > "$CITY/hospital/$NAME"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$NAME" "$CITY/$SECTOR/"
}

visit_church() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -e "$CITIZEN" ]] || continue
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
            [[ -e "$CITIZEN" ]] || continue
            if ! grep -q "Job:" "$CITIZEN"; then
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
            [[ -e "$CITIZEN" ]] && ALL_CITIZENS+=("$CITIZEN")
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
    echo "Parents: $(basename "$P1"), $(basename "$P2")" >> "$CITY/hospital/$CHILD"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$CHILD" "$CITY/$SECTOR/"
}

process_deaths() {
    echo "Processing deaths..."
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -e "$CITIZEN" ]] || continue
            if (( RANDOM % 20 == 0 )); then
                echo "Deceased on Day $DAY" >> "$CITIZEN"
                echo "Deceased: $(basename "$CITIZEN")"
                mv "$CITIZEN" "$CITY/cemetary/"
            fi
        done
    done
}

run_simulation() {
    for ((DAY=1; DAY<=DAYS; DAY++)); do
        echo -e "\n===== Day $DAY ====="

        generate_citizen
        (( DAY % 5 == 0 )) && assign_jobs
        visit_church
        (( DAY % 3 == 0 )) && create_family
        process_deaths

        sleep 1
    done
}

# Entry point
setup_city
run_simulation
✅ How to Use:
Save as city_simulation.sh

Make it executable:

chmod +x city_simulation.sh
Run:

./city_simulation.sh
Would you like to add logging or aging so that older citizens are more likely to die?

You said:
Can we create a log file that has stats for each day? The log file should be called "vital_records" and saved in the town_hall directory.
ChatGPT said:
Yes! You can easily create a daily log file called vital_records in the town_hall directory to track vital statistics each day. This log can include:

Total population

Number of new citizens

Number of deaths

Number of families created (optional)

Number of church visits (optional)

Job assignments (optional)

Below is an updated version of your city_simulation.sh with logging added.

✅ Updated city_simulation.sh With Logging to vital_records
#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)
DAYS=30
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

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$NAME" "$CITY/$SECTOR/"

    ((NEW_CITIZENS++))
}

visit_church() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -e "$CITIZEN" ]] || continue
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
            [[ -e "$CITIZEN" ]] || continue
            if ! grep -q "Job:" "$CITIZEN"; then
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
            [[ -e "$CITIZEN" ]] && ALL_CITIZENS+=("$CITIZEN")
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
    echo "Parents: $(basename "$P1"), $(basename "$P2")" >> "$CITY/hospital/$CHILD"

    SECTOR=${SECTORS[$RANDOM % ${#SECTORS[@]}]}
    mv "$CITY/hospital/$CHILD" "$CITY/$SECTOR/"

    ((FAMILIES++))
    ((NEW_CITIZENS++))
}

process_deaths() {
    for SECTOR in "${SECTORS[@]}"; do
        for CITIZEN in "$CITY/$SECTOR"/*.txt; do
            [[ -e "$CITIZEN" ]] || continue
            if (( RANDOM % 20 == 0 )); then
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

    # Reset daily counters
    NEW_CITIZENS=0
    DEATHS=0
    FAMILIES=0
}

run_simulation() {
    for ((DAY=1; DAY<=DAYS; DAY++)); do
        echo -e "\n===== Day $DAY ====="

        generate_citizen
        (( DAY % 5 == 0 )) && assign_jobs
        visit_church
        (( DAY % 3 == 0 )) && create_family
        process_deaths
        log_vitals

        sleep 1
    done
}

# Entry point
setup_city
run_simulation
🧾 Sample Output in city/town_hall/vital_records
===== Vital Records =====
Day 1
  Population: 1
  New Citizens: 1
  Deaths: 0
  Families Created: 0
-----------------------------
Day 2
  Population: 2
  New Citizens: 1
  Deaths: 0
  Families Created: 0
-----------------------------
...
Would you like to include citizen age tracking next (e.g., number of days alive) to simulate lifespan more realistically?

You said:
Yes! Let's include age tracking. Also I need to be able to see the stats on screen while the simulation is running.
ChatGPT said:
Great! Let's enhance your simulation with the following features:

✅ New Features Added
🧓 Age Tracking:

Each citizen file gets an Age: X line.

Age increments every day (cycle).

Older citizens are more likely to die.

📊 On-Screen Stats:

At the end of each simulation day, vital stats are printed to the terminal (in addition to being saved in vital_records).

🧠 Updated Full Script: city_simulation.sh
#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)
DAYS=30
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

            # Increase death chance with age
            DEATH_CHANCE=$(( (AGE > 60 ? 3 : (AGE > 30 ? 10 : 25)) ))
            if (( RANDOM % DEATH_CHANCE == 0 )); then
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

        generate_citizen
        (( DAY % 5 == 0 )) && assign_jobs
        visit_church
        (( DAY % 3 == 0 )) && create_family
        increment_ages
        process_deaths
        log_vitals

        sleep 1
    done
}

# Entry point
setup_city
run_simulation
🧪 Sample On-Screen Output
===== Day 12 =====
📊 Vital Stats for Day 12
Population: 28
New Citizens: 2
Deaths: 1
Families: 1
-----------------------------
Would you like to include a way to query a specific citizen’s full history (SSN, age, job, parents, visits, etc.) from the terminal?

You said:
I would like the occupations and the bible files to come from external sources, aka text files on the internet.
ChatGPT said:
Great idea! You can easily download external text files from the internet for the Bible and occupations list using curl or wget at the start of your simulation.

✅ Here's how to integrate external file sourcing:
🧾 1. Choose your external text file URLs:
For example:

Bible file (e.g., single-verse-per-line format or plain text):
https://raw.githubusercontent.com/dwyl/english-words/master/words.txt (for testing)

Occupations list:
https://raw.githubusercontent.com/dariusk/corpora/master/data/humans/occupations.json
(You could extract from the JSON.)

Or provide your own URLs to .txt files if preferred.

🛠 2. Update the setup_city function to fetch these files:
Replace the hardcoded Bible and occupations setup with download logic.

setup_city() {
    mkdir -p "$CITY/hospital" "$CITY/church" "$CITY/cemetary" "$CITY/town_hall"
    for SECTOR in "${SECTORS[@]}"; do
        mkdir -p "$CITY/$SECTOR"
    done

    # Download external files
    BIBLE_URL="https://raw.githubusercontent.com/dwyl/english-words/master/words.txt"  # Replace with a Bible-like file
    OCCUPATIONS_URL="https://raw.githubusercontent.com/dariusk/corpora/master/data/humans/occupations.json"

    echo "📥 Downloading bible and occupations..."
    curl -s "$BIBLE_URL" -o "$CITY/church/bible"
    curl -s "$OCCUPATIONS_URL" -o "$CITY/town_hall/occupations_raw.json"

    # Extract occupations from JSON to plain text list
    jq -r '.occupations[]' "$CITY/town_hall/occupations_raw.json" > "$CITY/town_hall/occupations"

    echo "===== Vital Records =====" > "$VITALS"
}
⚠️ Requires jq to parse JSON. You can install it via:

sudo apt install jq
✅ Bonus: If you'd rather use plain .txt sources
Use sources where each occupation or verse is already on its own line, and remove the jq part.

Example replacement for the JSON section:

OCCUPATIONS_URL="https://example.com/occupations.txt"
curl -s "$OCCUPATIONS_URL" -o "$CITY/town_hall/occupations"
Would you like me to recommend a better Bible .txt source or occupation list that doesn't require JSON parsing?

You said:
The population never seems to surpass 29 citizens. Why is that?
ChatGPT said:
Great observation. If your city population never grows beyond ~29, it's likely due to the balance between birth rate and death rate — and possibly some logic that unintentionally restricts growth.

Let’s break down the likely causes:

🔍 1. One Citizen Born per Day (Max)
In the current logic:

generate_citizen is called once per day.

create_family (which can also produce one child) only runs every 3rd day.

So on average:

~1.33 citizens/day are born.

💀 2. Deaths Increase with Age
As citizens age:

Their probability of death increases.

E.g., by day 30, the earliest citizens are already aged 30 — and older citizens have higher death odds:

DEATH_CHANCE=$(( (AGE > 60 ? 3 : (AGE > 30 ? 10 : 25)) ))
Meaning:

By day ~20–25, some older citizens start dying off as fast as new ones are born, especially with RANDOM % 10 giving a 10% chance of death per day for citizens over 30.

🧮 3. Cumulative Bottleneck
At a steady birth rate of 1.3/day, and deaths kicking in after age 30, your population will stabilize around a number where:

daily_births ≈ daily_deaths
That’s why you're seeing a population plateau around 29.

✅ Solutions to Allow Growth
You can increase the birth rate or reduce deaths. Here are options:

Option A: 🧒 Increase Family Creation Frequency
Make create_family happen daily or more often:

create_family  # call this daily, not every 3rd day
Or add a loop:

for _ in {1..3}; do create_family; done
Option B: ⏳ Delay Aging or Raise Death Threshold
Change:

DEATH_CHANCE=$(( (AGE > 60 ? 3 : (AGE > 30 ? 10 : 25)) ))
To:

DEATH_CHANCE=$(( (AGE > 90 ? 3 : (AGE > 60 ? 10 : (AGE > 40 ? 25 : 1000)) ))
This gives young citizens a very low chance of death, allowing more to accumulate.

Option C: 📈 Generate More Citizens Daily
Instead of one:

generate_citizen
Use a loop:

for _ in {1..3}; do generate_citizen; done
Would you like me to update your script with a growth-tuned version that targets a stable population of 100+?

You said:
Please, update the loop so the population can grow into the millions.
ChatGPT said:
To allow the population to grow into the millions, we need to address 3 core areas in the simulation loop:

✅ Strategy for High Growth:
💥 Scale up births – Create many more citizens per day.

🍼 More families – Let families form frequently.

💀 Fewer early deaths – Prevent young citizens from dying randomly.

🔧 Changes You’ll See:
Births: Up to 100 per day.

Families: 10–20 new families/day.

Deaths: Rare before age 80+.

🔄 Updated Core Simulation Loop
Replace your run_simulation() function with this:

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
🧓 Update process_deaths() to Slow Down Early Death
Modify the death logic like this:

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
⚠️ Tips for Massive Simulations:
Disable sleep or reduce it to 0.1 or lower.

Don’t use echo on every file; it slows things down.

If your file system can't handle millions of files per folder, consider:

Splitting sectors into subfolders (sector1/a-f, etc.)

Archiving old citizens over time

Would you like a companion script to query stats or search for citizens by SSN or job from the command line?

You said:
Thank you for the updates. Yes I would like to see a companion script.
ChatGPT said:
You're welcome! Here's a companion script that acts like a command-line tool to query, search, and summarize your digital city.

🔍 city_query.sh — Companion Script for City Simulation
This script allows you to:

✅ View the current population

🧑‍💼 Search citizens by job

🔎 Lookup a citizen by SSN or filename

📈 Show total citizens, average age, and other stats

📜 city_query.sh
#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)

show_population() {
    echo "📊 Current Population by Sector:"
    TOTAL=0
    for SECTOR in "${SECTORS[@]}"; do
        COUNT=$(find "$CITY/$SECTOR" -type f | wc -l)
        echo "  $SECTOR: $COUNT"
        TOTAL=$((TOTAL + COUNT))
    done
    echo "  Total: $TOTAL"
}

search_by_job() {
    JOB_QUERY="$1"
    echo "🔍 Citizens with job: $JOB_QUERY"
    for SECTOR in "${SECTORS[@]}"; do
        for FILE in "$CITY/$SECTOR"/*.txt; do
            [[ -f "$FILE" ]] || continue
            JOB_LINE=$(grep "^Job:" "$FILE" 2>/dev/null)
            if [[ "$JOB_LINE" == *"$JOB_QUERY"* ]]; then
                echo "  - $(basename "$FILE") in $SECTOR"
            fi
        done
    done
}

lookup_by_ssn_or_filename() {
    KEY="$1"
    echo "🔎 Looking up: $KEY"
    MATCHES=$(find "$CITY" -name "*$KEY*.txt")
    if [[ -z "$MATCHES" ]]; then
        echo "❌ No citizen found with ID: $KEY"
        return
    fi

    for FILE in $MATCHES; do
        echo -e "\n📄 File: $(basename "$FILE")"
        echo "  Path: $FILE"
        echo "----------------------------"
        cat "$FILE"
        echo "----------------------------"
    done
}

show_summary_stats() {
    echo "📈 Summary Stats:"
    TOTAL=0
    AGE_SUM=0

    for SECTOR in "${SECTORS[@]}"; do
        for FILE in "$CITY/$SECTOR"/*.txt; do
            [[ -f "$FILE" ]] || continue
            AGE=$(grep "^Age:" "$FILE" | cut -d' ' -f2)
            AGE_SUM=$((AGE_SUM + AGE))
            TOTAL=$((TOTAL + 1))
        done
    done

    if (( TOTAL > 0 )); then
        AVG=$((AGE_SUM / TOTAL))
        echo "  Total Citizens: $TOTAL"
        echo "  Average Age: $AVG"
    else
        echo "  No living citizens found."
    fi
}

# ===== ENTRY POINT =====
case "$1" in
    population)
        show_population
        ;;
    job)
        if [[ -z "$2" ]]; then
            echo "Usage: $0 job <JobTitle>"
            exit 1
        fi
        search_by_job "$2"
        ;;
    lookup)
        if [[ -z "$2" ]]; then
            echo "Usage: $0 lookup <SSN or filename part>"
            exit 1
        fi
        lookup_by_ssn_or_filename "$2"
        ;;
    stats)
        show_summary_stats
        ;;
    *)
        echo "City Query Tool"
        echo "Usage: $0 {population|job <title>|lookup <SSN>|stats}"
        exit 1
        ;;
esac
🧪 Usage Examples
./city_query.sh population
./city_query.sh job Farmer
./city_query.sh lookup 1a2b3c4d
./city_query.sh stats
✅ To Make It Executable:
chmod +x city_query.sh
Would you like this tool to also show historical stats from vital_records or track how a citizen moved between sectors?

You said:
Please create a GitHub formatted README.md file for the city_simulation script as I have modified it below.

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
ChatGPT said:
Here's a README.md formatted for GitHub, based on your city simulation Bash script as currently written:

# 🏙️ Digital City Simulation (Bash)

This is a **Bash-based simulation** of a growing digital city where each citizen is represented as a text file with a unique SSN (UUID). The city grows over simulated days through births and family creation, and ages and loses citizens through a progressive death system.

---

## 📁 City Structure

Upon running the simulation, a `city/` directory is created with the following subdirectories:

- `hospital/` – Where new citizens are born
- `sector1/` to `sector4/` – Where citizens live
- `church/` – Where citizens receive daily wisdom
- `town_hall/` – Contains `occupations` and `vital_records`
- `cemetary/` – Where deceased citizens are moved

---

## 👤 Citizens

Each citizen is a `.txt` file containing:

- Unique SSN
- Age
- (Eventually) Job
- (Optionally) Parents
- Church visit history
- Death record (if applicable)

---

## ⚙️ Features

- 🧬 **Citizen Generation**: 50–100 new citizens born each simulated day
- 🍼 **Family Creation**: 10–20 new family units formed daily, with children linked to parents
- 🧓 **Aging**: Each citizen's age increases daily
- 🪦 **Death Logic**: Probability-based aging death model, safest under age 60
- 🙏 **Church Visits**: Some citizens receive a Bible verse (random line from `church/bible`)
- 🧑‍🔧 **Job Assignment**: Citizens get occupations from a list every 5 days
- 📊 **Vital Records**: Daily stats logged to `town_hall/vital_records` and printed to screen

---

## 🚀 How to Run

1. **Ensure Bash is available** (Linux, macOS, or WSL on Windows)
2. Save the script as `city_simulation.sh`
3. Make it executable:
   ```bash
   chmod +x city_simulation.sh
Run the script:

./city_simulation.sh
Enter how many days you'd like to simulate when prompted.

📈 Sample Output
How many days would you like the simulation to run?  10

===== Day 1 =====
📊 Vital Stats for Day 1
Population: 122
New Citizens: 122
Deaths: 0
Families: 22
-----------------------------

===== Day 2 =====
📊 Vital Stats for Day 2
Population: 253
New Citizens: 131
Deaths: 0
Families: 24
-----------------------------
📑 Log File
All vital stats are saved in:

city/town_hall/vital_records
🛠️ Customization Tips
You can modify the following parts of the script to shape your city:

Bible and Occupations: Add or fetch custom bible and occupations files

Death Age Curve: Tweak the process_deaths() function

Growth Rate: Adjust citizen birth/family counts in run_simulation()

Sector Logic: Add more sectors or conditions for migration

📎 Optional Tools
A companion script (city_query.sh) is recommended to help:

Lookup citizens by SSN

Search by job title

View population stats

Summarize age/occupational distribution

Ask for this tool if you'd like it included.

📄 License
MIT License. Built for fun, education, and creative automation.


---

Would you like this README to include screenshots or animated examples (e.g., `asciinema` style)?
You said:
Please include one animated example.
ChatGPT said:
Here’s your updated README.md, now including a GIF-style animated terminal demo using asciinema + svg-term output.

⚠️ Note: The actual GIF or SVG will need to be recorded and hosted (e.g., in your GitHub repo or embedded via a URL). I’ll use a placeholder for now — you can replace it with your own.

# 🏙️ Digital City Simulation (Bash)

This is a **Bash-based simulation** of a growing digital city where each citizen is represented as a text file with a unique SSN (UUID). The city grows over simulated days through births and family creation, and ages and loses citizens through a progressive death system.

---

## 📁 City Structure

Upon running the simulation, a `city/` directory is created with the following subdirectories:

- `hospital/` – Where new citizens are born
- `sector1/` to `sector4/` – Where citizens live
- `church/` – Where citizens receive daily wisdom
- `town_hall/` – Contains `occupations` and `vital_records`
- `cemetary/` – Where deceased citizens are moved

---

## 👤 Citizens

Each citizen is a `.txt` file containing:

- Unique SSN
- Age
- (Eventually) Job
- (Optionally) Parents
- Church visit history
- Death record (if applicable)

---

## ⚙️ Features

- 🧬 **Citizen Generation**: 50–100 new citizens born each simulated day
- 🍼 **Family Creation**: 10–20 new family units formed daily, with children linked to parents
- 🧓 **Aging**: Each citizen's age increases daily
- 🪦 **Death Logic**: Probability-based aging death model, safest under age 60
- 🙏 **Church Visits**: Some citizens receive a Bible verse (random line from `church/bible`)
- 🧑‍🔧 **Job Assignment**: Citizens get occupations from a list every 5 days
- 📊 **Vital Records**: Daily stats logged to `town_hall/vital_records` and printed to screen

---

## 🚀 How to Run

1. **Ensure Bash is available** (Linux, macOS, or WSL on Windows)
2. Save the script as `city_simulation.sh`
3. Make it executable:
   ```bash
   chmod +x city_simulation.sh
Run the script:

./city_simulation.sh
Enter how many days you'd like to simulate when prompted.

📽️ Demo (Animated Terminal)
🎥 Recorded using asciinema and svg-term

City Simulation Demo

↑ Replace this URL with the actual link to your SVG or GIF demo

📑 Log File
All vital stats are saved in:

city/town_hall/vital_records
🛠️ Customization Tips
You can modify the following parts of the script to shape your city:

Bible and Occupations: Add or fetch custom bible and occupations files

Death Age Curve: Tweak the process_deaths() function

Growth Rate: Adjust citizen birth/family counts in run_simulation()

Sector Logic: Add more sectors or conditions for migration

📎 Optional Tools
A companion script (city_query.sh) is recommended to help:

Lookup citizens by SSN

Search by job title

View population stats

Summarize age/occupational distribution

Ask for this tool if you'd like it included.

📄 License
MIT License. Built for fun, education, and creative automation.


---

### ✅ To Add a Real Animation

1. Record with:
   ```bash
   asciinema rec demo.cast
Convert to SVG:

svg-term --in demo.cast --out city_simulation_demo.svg --window
Commit the SVG to your repo and replace the placeholder link in the README.

Would you like help creating or optimizing the actual recording?

You said:
write documentation for the city_query.sh script.
ChatGPT said:
Here’s a complete, GitHub-formatted README.md for your city_query.sh companion tool:

# 🧰 City Query Tool (`city_query.sh`)

This is a **command-line companion script** for the [Digital City Simulation](../city_simulation.sh), allowing you to explore and analyze your city’s population, jobs, and citizen records.

Use this tool **after running the simulation** to inspect the generated data in the `city/` directory.

---

## 📦 Features

- 🔍 Lookup any citizen by **SSN or filename**
- 🧑‍🔧 Search citizens by **occupation**
- 📊 Display **population counts** by sector
- 📈 Generate **summary statistics**, like average age

---

## 🖥️ Usage

Make the script executable:

```bash
chmod +x city_query.sh
Run it with:

./city_query.sh [command] [arguments]
🛠️ Commands
population
Displays the number of citizens currently living in each sector and the total population.

./city_query.sh population
Output:

📊 Current Population by Sector:
  sector1: 342
  sector2: 308
  sector3: 311
  sector4: 329
  Total: 1290
job <JobTitle>
Searches for all citizens with the specified job (case-insensitive).

./city_query.sh job Farmer
Output:

🔍 Citizens with job: Farmer
  - citizen_3f29b2a1.txt in sector2
  - citizen_7c93dd4e.txt in sector4
lookup <SSN or filename fragment>
Finds and displays a specific citizen file using a partial or full SSN or file name.

./city_query.sh lookup 5ab3
Output:

🔎 Looking up: 5ab3

📄 File: citizen_5ab3fce9.txt
  Path: city/sector3/citizen_5ab3fce9.txt
----------------------------
SSN: c2aa5ab3-fce9-4a72-8e4a-6f6cb3a9ad2f
Age: 34
Job: Engineer
Visited Church: Love thy neighbor.
----------------------------
stats
Shows a summary of city-wide statistics including:

Total living citizens

Average age

./city_query.sh stats
Output:

📈 Summary Stats:
  Total Citizens: 1543
  Average Age: 38
🔧 Requirements
The city/ folder must already exist (i.e., after running city_simulation.sh)

All expected subfolders and files (e.g., sector1/, town_hall/, etc.) must be present

🗃️ Integration Tip
Use this tool in combination with the simulation log at:

city/town_hall/vital_records
To analyze trends over time.

🧪 Example Workflow
./city_simulation.sh
# After running the simulation:

./city_query.sh population
./city_query.sh stats
./city_query.sh lookup 37e2
./city_query.sh job Carpenter
📄 License
MIT License — created as part of the Digital City Simulation project for creative and educational exploration.


---

Would you like me to generate a real example folder and output snapshot to use in the GitHub repo?
You said:
Turn this into a README, please.
ChatGPT said:
Sure! Here's the README.md for your city_query.sh script, formatted and ready for GitHub:

# 🧰 City Query Tool (`city_query.sh`)

A command-line companion to the [Digital City Simulation](../city_simulation.sh), this script lets you explore and analyze your city’s digital population. Use it to search citizens, gather statistics, and inspect citizen files after the simulation has been run.

---

## 🔍 Features

- View total and sector-based **population counts**
- Search citizens by **job title**
- Lookup individuals by **SSN or filename**
- Show **average age** and total population stats

---

## 🛠️ Commands
These commands can be run after the simulation completes.


### `population`
Displays the number of living citizens in each sector and the total population.
`./city_query.sh population`

### job <JobTitle>
Finds and lists all citizens who have the specified job.
`./city_query.sh job Farmer`

### lookup <SSN or filename part>
Finds and displays full details of a citizen file matching the SSN or filename fragment.
`./city_query.sh lookup 7a3f`

### stats
Shows total living population and average age across the city.
`./city_query.sh stats`

### Sample Output

```
$ ./city_query.sh population

📊 Current Population by Sector:
  sector1: 842
  sector2: 779
  sector3: 834
  sector4: 891
  Total: 3346
```
### Vital Records
Long-term simulation logs can be found in `city/town_hall/vital_records`. This file contains daily population summaries recorded during the simulation.


---
