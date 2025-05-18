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
