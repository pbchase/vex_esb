# VEX Event Scouting Buddy

VEX Event Scouting Buddy is a query tool to assist teams scouting for a VEX Robotics event.


## Prerequisites

- RStudio
- R


## Using Event Scouting Buddy

Event Scouting buddy uses a list of VEX Team numbers to describe the attendees of an event. To generate the scout data for your event, first create a new team list. The file must be a CSV file with a column named `Teams`. That column must contain team numbers, one per line. Additional columns will not interfere.

Then open `get_team_stats_from_vexdb.R` in RStudio and revise the that file to open your new event file. Select all of the lines and run them in RStudio. The results will open in a view Window.


## Contributing to this project

Future versions of this script will allow event URL and event IDs to drive the query. New output formats will also be added. Open an new issue to request or suggest a feature or offer assistance a contribution. 
