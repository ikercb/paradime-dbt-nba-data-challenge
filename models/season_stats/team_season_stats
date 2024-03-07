WITH team_stats AS (
    SELECT 
        season,
        season_id,
        team_name,
        team_id,
        game_id,
        Team_MP,
        48 * (Team_Poss + Opp_Poss) / (2 * Team_MP / 5) AS Team_PACE,
        Team_Poss,
        Opp_Poss,
        Team_PTS
    FROM 
        {{ ref('team_game_advanced_stats') }} 
    WHERE 
        --  team_name LIKE '%Cavaliers%'
        --  AND 
        --  season = '2008-09'
        --  team_name LIKE '%Nuggets%'
        --  AND 
        --  season = '2022-23'
        --  AND
        game_type = 'Regular Season'
)

SELECT
    season,
    season_id,
    team_name,
    team_id,
    SUM(Team_MP) AS mp,
    COUNT(*) AS games,
    AVG(Team_PACE) AS pace,
    48 * (SUM(Team_Poss) + SUM(Opp_Poss)) / (2 * SUM(Team_MP) / 5) AS pace_2,
    SUM(Team_PTS) AS total_pts,
    AVG(Team_PTS) AS pts,
    SUM(Team_Poss) AS total_poss,
    SUM(Team_PTS) / SUM(Team_Poss) AS pts_poss
FROM 
    team_stats
GROUP BY 
    season,
    season_id,
    team_name,
    team_id
