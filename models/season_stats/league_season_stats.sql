-- Aggregate league stats per season
SELECT 
    season,
    season_id,
    AVG(pace) AS pace,
    AVG(pts) AS pts,
    AVG(pts_poss) AS pts_poss
FROM 
    {{ ref('team_season_stats') }} 
GROUP BY 
    season,
    season_id
