# dbt™ Data Modeling Challenge - NBA Edition

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Applied Techniques](#applied-techniques)
4. [Insights](#visualizations)
   - [Best Player Seasons](#best-player-seasons)
   - [MVPs](#player-playoff-games)
   - [All-NBA Teams](#all-nba-teams)
   - [Rookie of the Year](#rookie-of-the-year)
5. [Conclusions](#conclusions)

## Introduction

Imagine a world where the MVP, the Rookie of the Year or who belongs to the All-NBA Teams are awarded free from human bias. Is that even possible? Could we replace the subjective judgements of media panel and use advanced statistical metrics to crown the best?

This project pretends to answer exactly that. To review the main individual awards in the NBA and see what would happen if they were left to the hands of the data nerds. Would be find shocking surprises? Keep reading and you will find out!

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

Win Shares (WS) is chosen for the analysis because it offers a comprehensive evaluation by employing a wide range of box score statistics, allows for comparisons across eras, and it is easily understandable as it estimates a player's contribution to team wins.

The calculations follow the guide provided by [Basketball Reference](https://www.basketball-reference.com/about/ws.html?__hstc=205977932.6acc30b029dcfb715694e790b0d56291.1709472165077.1709472165077.1709472165077.1&__hssc=205977932.1.1709472165077&__hsfp=468305008).

## Visualizations
### Best Player Seasons

Who has played the best season in the recent times? Well, it seems the two best players in the GOAT debate are also on the top if we listen to the advanced statistical analysis. Michael Jordan dominates the list with multiple seasons. There is no doubt his peak was at another level.

Looking at the list of the best 30 season, there aren't big surprises. And many of the hard to forget seasons appear like Curry's 2015-16 or Dirk Nowitzki 2005-06.

![Best WS Seasons](https://github.com/ikercb/paradime-dbt-nba-data-challenge/blob/main/visualizations/best_ws_player_season.png)

### MVPs

Now, let's get into it. The MVP debate generates a ton of opinions every year, but only one player can be crown each season. Were all the MVPs deserved? Well, we all have our favourites and I'm sure there are few seasons when the decision was unanimous. 

If we look at the data, again we see that the data loves Michael Jordan. He won 6 MVPs, but according he led the league in Win Shares in 9 seasons! Should he have gotten a few more?

Lebron James also should have won one more if we relied on Win Shares and Derrick Rose wouldn't have any.

The analytics are specially cruel with some player as it considers that they shouldn't have one. Players like Giannis Antetokounmpo, Steve Nash or Kobe Bryant shockingly appear on this list.

![WS MVPs](https://github.com/ikercb/paradime-dbt-nba-data-challenge/blob/main/visualizations/ws_mvps.png)

You can find the full list with the winner and who should have won in the next table:

| WS MVP WINNER    | MVP WINNER           | SEASON   |
|----------------|----------------------|----------|
| Nikola Jokic   | Joel Embiid          | 2022-23  |
| Nikola Jokic   | Nikola Jokic         | 2021-22  |
| Nikola Jokic   | Nikola Jokic         | 2020-21  |
| James Harden   | Giannis Antetokounmpo| 2019-20  |
| James Harden   | Giannis Antetokounmpo| 2018-19  |
| James Harden   | James Harden         | 2017-18  |
| Stephen Curry  | Stephen Curry        | 2015-16  |
| James Harden   | Stephen Curry        | 2014-15  |
| Kevin Durant   | Kevin Durant         | 2013-14  |
| LeBron James   | LeBron James         | 2012-13  |
| LeBron James   | LeBron James         | 2011-12  |
| LeBron James   | Derrick Rose         | 2010-11  |
| LeBron James   | LeBron James         | 2009-10  |
| LeBron James   | LeBron James         | 2008-09  |
| Chris Paul     | Kobe Bryant          | 2007-08  |
| Dirk Nowitzki  | Dirk Nowitzki        | 2006-07  |
| Dirk Nowitzki  | Steve Nash           | 2005-06  |
| Kevin Garnett  | Steve Nash           | 2004-05  |
| Kevin Garnett  | Kevin Garnett        | 2003-04  |
| Tim Duncan     | Tim Duncan           | 2002-03  |
| Tim Duncan     | Tim Duncan           | 2001-02  |
| Shaquille O'Neal| Allen Iverson        | 2000-01  |
| Shaquille O'Neal| Shaquille O'Neal    | 1999-00  |
| Karl Malone    | Karl Malone          | 1998-99  |
| Karl Malone    | Michael Jordan       | 1997-98  |
| Michael Jordan | Karl Malone          | 1996-97  |
| Michael Jordan | Michael Jordan       | 1995-96  |
| David Robinson | David Robinson       | 1994-95  |
| David Robinson | Hakeem Olajuwon      | 1993-94  |
| Michael Jordan | Charles Barkley      | 1992-93  |
| Michael Jordan | Michael Jordan       | 1991-92  |
| Michael Jordan | Michael Jordan       | 1990-91  |
| Michael Jordan | Magic Johnson        | 1989-90  |
| Michael Jordan | Magic Johnson        | 1988-89  |
| Michael Jordan | Michael Jordan       | 1987-88  |
| Michael Jordan | Magic Johnson        | 1986-87  |
| Larry Bird     | Larry Bird           | 1985-86  |

### All-NBA Teams


### Rookie of the Year

So far, so good. Some surprises, but no scandals I would say. Until I decided to look at the ROY.

Just look at the last 10 years:

| WS ROY               | ROY                        | SEASON   |
|----------------------|----------------------------|----------|
| Walker Kessler       | Paolo Banchero             | 2022-23  |
| Scottie Barnes       | Scottie Barnes             | 2021-22  |
| Isaiah Stewart       | Lamelo Ball                | 2020-21  |
| Brandon Clarke       | Ja Morant                  | 2019-20  |
| Mitchell Robinson    | Luka Doncic                | 2018-19  |
| Ben Simmons          | Ben Simmons                | 2017-18  |
| Malcolm Brogdon      | Malcolm Brogdon            | 2016-17  |
| Karl-Anthony Towns   | Karl-Anthony Towns         | 2015-16  |
| Nikola Mirotic       | Andrew Wiggins             | 2014-15  |
| Mason Plumlee        | Michael Carter-Williams    | 2013-14  |

Isaiah Stewart over Lamelo Ball? Brandon Clarke over Ja Morant? Mitchell Robinson over Luka Doncic?????

Maybe I was too early to remove the professional jury from the decision process. Not sure that's a good idea anymore.

## Conclusions
This project successfully extracts significant insights from NBA data that NBA fans would find interesting, such as: 

- The dominance of teams like the Los Angeles Lakers and the San Antonio Spurs in playoff appearances
- The critical role of "role" players, as highlighted by the playoff games by player insights,
- The extraordinary achievements of players like LeBron James, Michael Jordan in the playoffs, and Wilt Chamberlain in the regular season. 
- The influence of universities like Kentucky in producing NBA talent.
