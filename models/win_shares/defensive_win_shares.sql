-- Computes player offensive win shares per season.
WITH player_totals AS (
    SELECT 
        season,
        season_id,
        team_name,
        team_id,
        player_name,
        SUM(mp) AS mp,
        AVG(def_rating) AS def_rating
    FROM 
        {{ ref('player_game_defensive_rating') }}
    GROUP BY 
        season,
        season_id,
        team_name,
        team_id,
        player_name
)
SELECT  
    p.season,
    p.season_id,
    p.team_name,
    p.team_id,
    p.player_name,
    -- Marginal defense: player contribution with respect to league average
    -- Marginal points per win
    -- DWS = (marginal defense) / (marginal points per win)
    (p.mp / t.mp) * t.total_poss * (1.08 * l.pts_poss - p.def_rating / 100) / ( 0.32 * l.pts * t.pace / l.pace ) AS dws
FROM 
    player_totals AS p
LEFT JOIN 
    {{ ref('league_season_stats') }} AS l 
ON 
    p.season = l.season 
LEFT JOIN 
    {{ ref('team_season_stats') }} AS t
ON 
    p.season = t.season AND p.team_id = t.team_id
