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
)

SELECT
    season,
    season_id,
    team_name,
    team_id,
    SUM(Team_MP) AS mp,
    AVG(Team_PACE) AS pace,
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
