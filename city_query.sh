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
