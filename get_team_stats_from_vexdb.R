# VEX ESB - VEX Event Scouting Buddy

library(tidyverse)
library(jsonlite)
library(purrr)

# set the display precision
options(digits=2)

# define query functions
get_vexdb_query_result <- function(query_url) {
  result <- fromJSON(query_url)$result
  return(result)
}

# Prototype the queries
get_rankings_query <- "https://api.vexdb.io/v1/get_rankings?team=3131V&season=Tower%20Takeover"
get_teams_query <- "https://api.vexdb.io/v1/get_teams?team=3131V"

# Get the team list and generate the query URLs
team_list <- read_csv("input/2020_north_florida_state_teams.csv")
teams <- team_list %>%
  rename(team = Team) %>%
  mutate(rankings_url = str_replace(get_rankings_query, "3131V", team)) %>%
  mutate(teams_url = str_replace(get_teams_query, "3131V", team))

# Get the data
all_match_rankings <- map_dfr(teams$rankings_url, get_vexdb_query_result)
all_team_names <- map_dfr(teams$teams_url, get_vexdb_query_result)

# Write out query results
write_csv(all_match_rankings, "output/all_match_rankings.csv")
write_csv(all_team_names, "output/all_team_names.csv")

# Summarize the stats by team
team_stats <- all_match_rankings %>%
  group_by(team) %>%
  summarise(match_count = n(),
            max_opr = max(opr),
            mean_opr = mean(opr),
            min_opr = min(opr),
            max_dpr = max(dpr),
            mean_dpr = mean(dpr),
            min_dpr = min(dpr),
            max_ccwm = max(ccwm),
            mean_ccwm = mean(ccwm),
            min_ccwm = min(ccwm)
  ) %>%
  left_join(all_team_names, by=c("team" = "number")) %>%
  arrange(team) %>%
  mutate(division = case_when(
    row_number() %% 2 == 1 ~ "odd",
    TRUE ~ "even"
  )) %>%
  arrange(desc(mean_ccwm)) %>%
  select(team, team_name, division, mean_ccwm, match_count, contains("ccwm"), contains("opr"), contains("dpr"))

# Create datasets for each divisions
odd_division <- team_stats %>%
  filter(division == "odd")

even_division <- team_stats %>%
  filter(division == "even")

# Output the report
write_csv(odd_division, "output/odd_division.csv")
write_csv(even_division, "output/even_division.csv")
write_csv(team_stats, "output/team_stats.csv")
View(team_stats)

# Compare divisions
team_stats %>%
  group_by(division) %>%
  summarise(total_mean_ccwm = sum(mean_ccwm), total_max_ccwm = sum(max_ccwm))
