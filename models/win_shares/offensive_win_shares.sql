-- Computes player offensive win shares per season and per team.
WITH player_totals AS (
    SELECT 
        season,
        season_id,
        team_name,
        team_id,
        player_name,
        -- Points Produced in a season
        SUM(pts_prod) AS pts_prod,
        -- Offensive Possesions in a season
        SUM(tot_poss) AS tot_poss
    FROM 
        {{ ref('player_game_offensive_rating') }}
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
    p.pts_prod,
    p.tot_poss,
    -- Marginal offense: player contribution with respect to league average
    -- Marginal points per win
    -- OWS = (marginal offense) / (marginal points per win)
    ( p.pts_prod - 0.92 * l.pts_poss * p.tot_poss ) / ( 0.32 * l.pts * t.pace / l.pace ) AS ows
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
