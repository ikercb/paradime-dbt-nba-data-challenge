WITH games AS (
    SELECT 
        *
    FROM 
        {{ source('NBA', 'GAMES') }}
    WHERE 
        season_id IS NOT NULL
        AND 
        -- Keep only season when all the stats needed are recorded and regular season games
        TO_NUMBER(SUBSTRING(season, 1, 4)) > 1984
        AND 
        game_type = 'Regular Season'
),
add_opponent_stats AS (
    SELECT 
        t.season_id,
        t.season,
        t.team_id,
        t.team_name,
        t.game_id,
        t.game_type,
        -- TEAM STATS
        -- Fix minutes for those teams under 240
        CASE
            WHEN t.min < 240 THEN 240
            ELSE t.min
        END AS Team_MP,
        t.pts AS Team_PTS,
        t.fgm AS Team_FGM,
        t.fga AS Team_FGA,
        t.ftm AS Team_FTM,
        t.fta AS Team_FTA,
        t.fg3m AS Team_FG3M,
        t.ast AS Team_AST,
        t.dreb AS Team_DRB,
        t.oreb AS Team_ORB,
        t.tov AS Team_TOV,
        t.blk AS Team_BLK,
        t.stl AS Team_STL,
        t.pf AS Team_PF,
        -- OPPONENT STATS
        CASE
            WHEN o.min < 240 THEN 240
            ELSE o.min
        END AS Opp_MP,
        o.pts AS Opp_PTS,
        o.fgm AS Opp_FGM,
        o.fga AS Opp_FGA,
        o.ftm AS Opp_FTM,
        o.fta AS Opp_FTA,
        o.fg3m AS Opp_FG3M,
        o.ast AS Opp_AST,
        o.dreb AS Opp_DRB,
        o.oreb AS Opp_ORB,
        o.tov AS Opp_TOV
    FROM 
        games AS t 
    INNER JOIN 
        games AS o
    ON 
        t.game_id = o.game_id 
        AND 
        t.team_id <> o.team_id
),
first_step AS (
    SELECT 
        *,
        -- Estimate team scoring possessions
        Team_FGM + (1 - POW(1 - (Team_FTM / Team_FTA), 2)) * Team_FTA * 0.4 AS Team_Scoring_Poss,
        -- Estimate team posessions
        Team_FGA + 0.4 * Team_FTA - 1.07 * (Team_ORB / (Team_ORB + Opp_DRB)) * (Team_FGA - Team_FGM) + Team_TOV AS Team_Poss,
        -- Estimate opponent possessions
        Opp_FGA + 0.4 * Opp_FTA - 1.07 * (Opp_ORB / (Opp_ORB + Team_DRB)) * (Opp_FGA - Opp_FGM) + Opp_TOV AS Opp_Poss,
        -- Estimate total possessions in the game
        0.5 * ((Team_FGA + 0.4 * Team_FTA - 1.07 * (Team_ORB / (Team_ORB + Opp_DRB)) * (Team_FGA - Team_FGM) + Team_TOV) + (Opp_FGA + 0.4 * Opp_FTA - 1.07 * (Opp_ORB / (Opp_ORB + Team_DRB)) * (Opp_FGA - Opp_FGM) + Opp_TOV)) AS Poss,
        -- Compute percentage of offensive rebounds that the team captured
        Team_ORB / (Team_ORB + Opp_DRB) AS Team_ORB_PCT,
        -- Compute percentage of offensive rebounds that the opponent captured
        Opp_ORB / (Opp_ORB + Team_DRB) AS Opp_ORB_PCT,
        -- Opponent field goal percentage. Ratio between made and attempted
        OPP_FGM / Opp_FGA AS Opp_FG_PCT
    FROM 
        add_opponent_stats
),
second_step AS (
    SELECT
        *,
        -- Compute percentage of succesful scoring positions
        Team_Scoring_Poss / (Team_FGA + Team_FTA * 0.4 + Team_TOV) AS Team_Play_PCT,
        -- Compute team pace
        48 * (Team_Poss + Opp_Poss) / (2 * Team_MP / 5) AS PACE,
        -- Compute team defensive rating
        100 * (Opp_PTS / Team_Poss) AS Team_Def_Rating
    FROM 
        first_step
)
SELECT
    *,
    -- Compute weight of offensive rebounds in scoring possessions
    ((1 - Team_ORB_PCT) * Team_Play_PCT) / ((1 - Team_ORB_PCT) * Team_Play_PCT + Team_ORB_PCT * (1 - Team_Play_PCT)) AS Team_ORB_Weight
FROM 
    second_step
