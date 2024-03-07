# dbt™ Data Modeling Challenge - NBA Edition

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Applied Techniques](#applied-techniques)
4. [Visualizations](#visualizations)
   - [Team Playoff Appearances](#team-playoff-appearances)
   - [Player Playoff Games](#player-playoff-games)
   - [Top Playoff Scorers](#top-playoff-scorers)
   - [Top Regular Season Scorers](#top-regular-season-scorers)
   - [NBA Players by University](#nba-players-by-university)
5. [Conclusions](#conclusions)

## Introduction

Imagine a world where MVPs, Defensive Players of the Year, and Rookies of the Year are awarded based on undeniable performance data, free from bias and human error. In the quest for excellence, why leave awards to the subjective judgments of a jury when the unerring eye of advanced statistical metrics can crown the best with precision?

This project analyzes the jury's award decisions against statistical data to identify discrepancies and highlight the most underrated players of this era, aiming for a clearer and fairer assessment of player excellence.

## Data Sources
The analysis leverages three NBA datasets provided by Paradime under the *NBA_HISTORICAL.PUBLIC* schema:
- *GAMES*
- *PLAYER_GAME_LOGS*
- *COMMON_PLAYER_INFO*

Additionally, a dataset with NBA player awards was curated using the NBA API and loaded to the next Snowflace instance *IKERCAMARAVKVCU_ANALYTICS.ADDITIONAL_DATA.PLAYER_AWARDS*.

## Methodology
### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Sigma Computing](https://www.sigmacomputing.com/)** for data visualization.

### Applied Techniques
- SQL and dbt™ to transform _stg_player_game_logs_ into seasonal player statistics
- SQL and dbt™ to transform _stg_player_game_logs_ and _stg_common_player_info_ to understand
  playoff and regular season performance by individual players
- SQL and dbt™ to transform _stg_common_player_info_ for insights on NBA players' college backgrounds.
- SQL and dbt™ to transform _stg_team_stats_by_season_ for insights on NBA Teams' historical playoff performance.

## Visualizations
### Best Player Seasons
Visualization of the 30 best individual season according to Win Shares.

![Best WS Seasons](https://github.com/ikercb/paradime-dbt-nba-data-challenge/blob/main/visualizations/best_ws_player_season.png)

*Insights:*
Michel Jordan had the best season ever in the 1987-88, followed by Lebron James in the 2008-09.

### Player Playoff Games
Assessment of NBA players with the highest number of playoff game wins and their win percentages. The '*' next to NBA Player name indicates if they're 
a member of the [NBA Greatest 75 Team](https://www.nba.com/news/nba-75th-anniversary-team-announced)

![Player Playoff Games](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/assets/107123308/ffd6abf3-b8a8-411f-a0be-12402a5d1b45)

*Insights:* 
LeBron James has the most playoff wins of any player, but here's what's most interesting: 
Of the 25 players with the most playoff wins, only 12 of them are members of the [NBA Greatest 75 team](https://www.nba.com/news/nba-75th-anniversary-team-announced). 
There are several players listed that impact playoff wins and compliment their team's best players, but aren't known 
as on the the all time greats, such as: Derek Fisher, Robert Horry, Danny Green. 

### Top Playoff Scorers
Showcases players who achieved the the most points scored in any playoff season.

![Top Playoff Scorers](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/assets/107123308/db51f47a-5cfb-431c-9c7b-3a793a6b4352)

*Insights:* 
Michael Jordan, LeBron James, and Kobe Bryant are the only players having three seasons within the top 25 
highest most points scored in a playoff season.

### Top Regular Season Scorers
Highlights NBA players who scored the most in regular seasons.

![Top Regular Season Scorers](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/assets/107123308/774223ad-11f0-4202-817f-5a8c1daf3afc)

*Insights:* 
Wilt Chamberlain is one of the best regular season scorer of all time. In addition to having the most points scored 
in any regular season ever (4,029), he also has six season in the top 25. The only other player with 6 top 25 seasons is Michael Jordan.
In the chart above, notice that Wilt Chamberlain doesn't appear once in the top 25 playoff scorers of all time 👀.

### NBA Players by University
Displays which universities have produced the most NBA players.

![NBA Players by University](https://github.com/paradime-io/paradime-dbt-nba-data-challenge/assets/107123308/e21af17a-9cb8-491a-8e0d-b70eae118324)

*Insights:* 
Kentucky has produced the most NBA players in NBA history by a significant margin.... Go Wildcats! Also, this data is [slightly inaccurate](https://erudera.com/resources/colleges-with-most-nba-players/), but that's the NBA API's fault, not mine 🤣

## Conclusions
This project successfully extracts significant insights from NBA data that NBA fans would find interesting, such as: 

- The dominance of teams like the Los Angeles Lakers and the San Antonio Spurs in playoff appearances
- The critical role of "role" players, as highlighted by the playoff games by player insights,
- The extraordinary achievements of players like LeBron James, Michael Jordan in the playoffs, and Wilt Chamberlain in the regular season. 
- The influence of universities like Kentucky in producing NBA talent.
