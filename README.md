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

Imagine a world where the MVP, Rookie of the Year, or those who belong to the All-NBA Teams are awarded free from human bias.

But could we transfer the responsibility of choosing the MVP from the media panel? Who has time to watch all the games anyway?

This project aims to replace the subjective judgments of the media panel and use advanced statistical metrics to crown the best.

Would we find shocking surprises? Keep reading, and you will find out!

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

## Insights
### Best Player Seasons

Who has played the best season in recent times? Well, it seems the two best players in the GOAT debate are also at the top, according to advanced statistical analysis. Michael Jordan dominates the list, with multiple seasons in the top 10, leaving no doubt that his peak was on another level.

Looking at the list of the best 30 seasons, there aren't big surprises. Many big names are there, and many of the hard-to-forget seasons appear, like Curry's 2015-16.

![Best WS Seasons](https://github.com/ikercb/paradime-dbt-nba-data-challenge/blob/main/visualizations/best_ws_player_season.png)

### MVPs

Now, let's dive into it. The MVP debate generates a ton of opinions every year, but only one player can be crowned each season. Were all the MVPs deserved? Well, we all have our favorites, and I'm sure there are only a few seasons, if any, when the decision was unanimous.

If we look at the data, again, Michael Jordan is a favorite. He won 6 MVPs but led the league in Win Shares in 9 seasons! Should he have received a few more?

LeBron James also should have won one more if we relied on Win Shares, taking the award from Derrick Rose.

The analytics are especially cruel to some players as it considers that they shouldn't have won any MVP. Players like Giannis Antetokounmpo, Steve Nash, Magic Johnson, or Kobe Bryant shockingly appear on this list.

The data backs up my opinion that Jokić should have won his third MVP last season. It is a clear the tendency to give the award to a different player after one has won multiple in a row. Is that good?

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

I think this is important as a lot of contract money depends on who gets selected in the All-NBA teams. 

Comparing the actual selections with those using Win Shares, we can observe that many big names received more recognition than they deserved, as the advanced metric does not place them so frequently on the All-NBA teams. Kobe Bryant, for example, was elected 11 times to the first All-NBA team. According to Win Shares, he should have been selected only once. The affinity for big names is obviously present. There are many players where the total number of appearances, according to the Win Shares criteria, is somewhat lower than the actual selections.

| PLAYER NAME          | FIRST TEAMS WS | FIRST TEAMS | SECOND TEAMS WS | SECOND TEAMS | THIRD TEAMS WS | THIRD TEAMS |
|----------------------|----------------|-------------|-----------------|--------------|----------------|-------------|
| LeBron James         | 12             | 13          | 3               | 3            | 0              | 3           |
| Karl Malone          | 11             | 11          | 3               | 2            | 0              | 1           |
| Kobe Bryant          | 1              | 11          | 7               | 2            | 2              | 2           |
| Michael Jordan       | 10             | 10          | 0               | 0            | 0              | 0           |
| Tim Duncan           | 5              | 10          | 6               | 3            | 1              | 2           |
| Shaquille O'Neal     | 3              | 8           | 5               | 2            | 1              | 4           |
| Kevin Durant         | 6              | 6           | 3               | 4            | 1              | 0           |
| Magic Johnson        | 4              | 6           | 2               | 0            | 0              | 0           |
| James Harden         | 8              | 6           | 1               | 0            | 0              | 1           |
| Hakeem Olajuwon      | 4              | 6           | 2               | 3            | 4              | 3           |
| Charles Barkley      | 4              | 5           | 3               | 5            | 2              | 1           |
| Dwight Howard        | 2              | 5           | 3               | 1            | 0              | 2           |
| Jason Kidd           | 1              | 5           | 1               | 1            | 0              | 0           |
| Giannis Antetokounmpo| 4              | 5           | 2               | 2            | 1              | 0           |
| Luka Doncic          | 0              | 4           | 1               | 0            | 2              | 0           |
| Stephen Curry        | 2              | 4           | 5               | 4            | 2              | 1           |
| David Robinson       | 7              | 4           | 1               | 2            | 3              | 4           |
| Anthony Davis        | 3              | 4           | 1               | 0            | 2              | 0           |
| Chris Paul           | 8              | 4           | 4               | 5            | 1              | 2           |
| Dirk Nowitzki        | 6              | 4           | 2               | 5            | 3              | 3           |
| Kevin Garnett        | 4              | 4           | 4               | 3            | 2              | 2           |
| Kawhi Leonard        | 0              | 3           | 3               | 2            | 3              | 0           |
| Steve Nash           | 1              | 3           | 2               | 2            | 3              | 2           |
| Scottie Pippen       | 0              | 3           | 5               | 2            | 1              | 2           |
| Larry Bird           | 3              | 3           | 0               | 1            | 0              | 0           |
| Nikola Jokic         | 3              | 3           | 2               | 2            | 1              | 0           |

You can see the full list of deserving winners here. There are some good players, not necessarily big names, who would have deserved recognition, such as Andre Iguodala, Mike Conley, or Paul Millsap. These players could be the ones to spark a data revolution to gain more recognition.

### Rookie of the Year

So far, so good. Some surprises, but no shocks I would say. Until I decided to look at the ROY.

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

I think it is fun to consider a hypothetical world driven by analytics, though I understand this is more of a utopian vision because the buzz generated by debates around these awards is beneficial for the league.

In any case, advanced metrics have a keen eye. They can recognize talent and skill when they see it, and I think we can all agree on that.

With the exception of rookies. C'mon, Mitchell Robinson over Luka Doncic? 

While advanced statistical analysis helps mitigate some human biases, no metric is perfect and we're not at a point where we can base award decisions entirely on data. However, the future might see a more balanced voting system, where analytics have its own weight, especially as we gather more data and develop better metrics to measure player performance. Many journalists likely already consult these metrics when casting their votes, which is a victory for data nerds.
