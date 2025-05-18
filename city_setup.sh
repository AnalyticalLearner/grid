#!/bin/bash

CITY="city"
SECTORS=(sector1 sector2 sector3 sector4)
mkdir -p "$CITY"/{hospital,church,cemetary,town_hall,${SECTORS[*]}}
