WITH player_team_stats AS (
    SELECT 
        p.season,
        t.season_id,
        t.team_name,
        p.team_id,
        p.game_id,
        p.player_id,
        p.player_name,
        -- PLAYER DEFENSIVE STATS
        p.min AS MP,
        p.dreb AS DRB,
        p.tov AS TOV,
        p.stl AS STL,
        p.blk AS BLK,
        p.pf AS PF,
        -- TEAM STATS
        t.* EXCLUDE(season, season_id, game_id, team_name, team_id)
    FROM 
        {{ source('NBA', 'PLAYER_GAME_LOGS') }} AS p
    INNER JOIN 
        {{ ref('team_game_advanced_stats') }} AS t
    ON 
        p.team_id = t.team_id
        AND 
        p.game_id = t.game_id
),
-- Forced Miss Weight
-- Measures how much a team contributes to causing opponents to miss shots
compute_fm_wt AS (
    SELECT
        *, 
        (Opp_FG_PCT * (1 - Opp_ORB_PCT)) / (Opp_FG_PCT * (1 - Opp_ORB_PCT) + (1 - Opp_FG_PCT) * Opp_ORB_PCT) AS FMwt
    FROM 
        player_team_stats
),
-- Stops are the number of opponent's interrupted actions.
-- It is broken down in an individual contribution and a team contribution.
compute_stops AS (
    SELECT 
        *,
        STL + BLK * FMwt * (1 - 1.07 * Opp_ORB_PCT) + DRB * (1 - FMwt) AS Stops1,
        (((Opp_FGA - Opp_FGM - Team_BLK) / Team_MP) * FMwt * (1 - 1.07 * Opp_ORB_PCT) + ((Opp_TOV - Team_STL) / Team_MP)) * MP + (PF / Team_PF) * 0.4 * Opp_FTA * POW(1 - (Opp_FTM / Opp_FTA), 2) AS Stops2
    FROM 
        compute_fm_wt
),
-- Defensive points per possession records how many points the opponent scores per offensive possession
points_per_poss AS (
    SELECT
        *,
        Stops1 + Stops2 AS Stops,
        Opp_PTS / (Opp_FGM + (1 - POW(1 - (Opp_FTM / Opp_FTA), 2)) * Opp_FTA * 0.4) AS D_Pts_per_ScPoss
    FROM 
        compute_stops
)
-- The individual defensive rating sets the team's defensive level as the base value and adds a part related to the player's contribution
SELECT 
    season,
    season_id,
    team_name,
    team_id,
    game_id,
    player_id,
    player_name,
    mp,
    CASE 
        WHEN MP = 0 THEN Team_Def_Rating
        ELSE Team_Def_Rating + 0.2 * (100 * D_Pts_per_ScPoss * (1 - ((Stops * Opp_MP) / (Team_Poss * MP))) - Team_Def_Rating) 
    END AS def_rating
FROM 
    points_per_poss
