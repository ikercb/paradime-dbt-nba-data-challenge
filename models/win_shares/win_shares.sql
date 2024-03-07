-- Adds up offensive and defensive win shares.
SELECT
    o.season,
    o.season_id,
    o.team_name,
    o.team_id,
    o.player_name,
    o.ows,
    d.dws,
    o.ows + d.dws AS ws
FROM 
    {{ ref('offensive_win_shares') }} AS o 
LEFT JOIN  
    {{ ref('defensive_win_shares') }} AS d 
ON 
    o.season_id = d.season_id
    AND 
    o.team_id = d.team_id 
    AND 
    o.player_name = d.player_name
