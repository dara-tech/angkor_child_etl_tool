@echo off
echo ==================================================
echo Starting DB Exporter ETL Task at %date% %time%
echo ==================================================

:: Navigate to the dashboard directory
cd /d "d:\dev\ART\Export system\db-exporter-dashboard\scheduled-task"

:: Run the Node.js script and append output to a log file
node scheduled-etl.js >> etl-schedule.log 2>&1

echo ==================================================
echo DB Exporter ETL Task finished at %date% %time%
echo ==================================================
