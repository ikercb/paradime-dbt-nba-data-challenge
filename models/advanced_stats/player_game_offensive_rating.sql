WITH player_team_stats AS (
    SELECT 
        p.season,
        t.season_id,
        t.team_name,
        p.team_id,
        p.game_id,
        p.player_id,
        p.player_name,
        -- PLAYER STATS
        p.min AS mp,
        p.pts,
        p.fgm,
        p.fga,
        p.fg3m,
        p.ftm,
        p.fta,
        p.ast,
        p.oreb AS orb,
        p.tov,
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
compute_q_ast AS (
    SELECT
        *, 
        -- qAST estimates the percentage of shots made by a player following an assist from a teammate
        CASE
            WHEN MP = 0 THEN 0
            -- Fixing for those players that score a lot of points in a few minutes
            WHEN ((Team_FGM / Team_MP) * MP * 5 - FGM) <= 0 THEN ((MP / (Team_MP / 5)) * (1.14 * ((Team_AST - AST) / Team_FGM)))
            WHEN ((MP / (Team_MP / 5)) * (1.14 * ((Team_AST - AST) / Team_FGM))) + ((((Team_AST / Team_MP) * MP * 5 - AST) / ((Team_FGM / Team_MP) * MP * 5 - FGM)) * (1 - (MP / (Team_MP / 5))))  > 1 THEN 1
            ELSE ((MP / (Team_MP / 5)) * (1.14 * ((Team_AST - AST) / Team_FGM))) + ((((Team_AST / Team_MP) * MP * 5 - AST) / ((Team_FGM / Team_MP) * MP * 5 - FGM)) * (1 - (MP / (Team_MP / 5)))) 
        END AS qAST
        --pct_mins_played * 1.14 * ( (team_assists - assists) / team_field_goals_made ) + (1 - pct_mins_played ) * ( team_assists * pct_mins_played - assists ) / ( team_field_goals_made * pct_mins_played - field_goals_made ) AS q_ast
    FROM 
        player_team_stats
),
-- Scoring possesions (ScPoss) are broken down into four parts: field goals, free thrown, assists and offensive rebounds.
-- To the scoring possession we need to add the offensive possessions accounting for missed field goals and missed free throws plus the turnovers
total_possessions AS (
    SELECT 
        *,
        -- Avoid division by zero when a player didn't attempt any field goal.
        CASE 
            WHEN FGA = 0 THEN 0
            ELSE FGM * (1 - 0.5 * ((PTS - FTM) / (2 * FGA)) * qAST) 
        END AS FG_Part,
        0.5 * (((Team_PTS - Team_FTM) - (PTS - FTM)) / (2 * (Team_FGA - FGA))) * AST AS AST_Part,
        -- Avoid division by zero when a player didn't attempt any free throw.
        CASE 
            WHEN FTA = 0 THEN 0
            ELSE (1 - POW(1 - (FTM/FTA), 2)) * 0.4 * FTA 
        END AS FT_Part,
        ORB * Team_ORB_Weight * Team_Play_PCT AS ORB_Part,
        (FGA - FGM) * (1 - 1.07 * Team_ORB_PCT) AS FGxPoss,
        CASE
            WHEN FTA = 0 THEN 0
            ELSE POW(1 - (FTM / FTA), 2) * 0.4 * FTA 
        END AS FTxPoss
    FROM 
        compute_q_ast
),
points_produced AS (
    SELECT
        *,
        -- Compute scoring possessions adjusting by team offensive rebounding ability and team offensive ability.
        (FG_Part + AST_Part + FT_Part) * (1 - (Team_ORB / Team_Scoring_Poss) * Team_ORB_Weight * Team_Play_PCT) + ORB_Part AS ScPoss,
        -- The points produced are also broken down in field goals, assists and offensive rebounds
        CASE 
            WHEN FGA = 0 THEN 0
            ELSE 2 * (FGM + 0.5 * FG3M) * (1 - 0.5 * ((PTS - FTM) / (2 * FGA)) * qAST) 
        END AS PProd_FG_Part,
        2 * ((Team_FGM - FGM + 0.5 * (Team_FG3M - FG3M)) / (Team_FGM - FGM)) * 0.5 * (((Team_PTS - Team_FTM) - (PTS - FTM)) / (2 * (Team_FGA - FGA))) * AST AS PProd_AST_Part,
        ORB * Team_ORB_Weight * Team_Play_PCT * (Team_PTS / (Team_FGM + (1 - POW(1 - (Team_FTM / Team_FTA), 2)) * 0.4 * Team_FTA)) AS PProd_ORB_Part
    FROM 
        total_possessions
)
SELECT 
    season,
    season_id,
    team_name,
    team_id,
    game_id,
    player_id,
    player_name,
    ScPoss + FGxPoss + FTxPoss + TOV AS tot_poss,
    (PProd_FG_Part + PProd_AST_Part + FTM) * (1 - (Team_ORB / Team_Scoring_Poss) * Team_ORB_Weight * Team_Play_PCT) + PProd_ORB_Part AS pts_prod
FROM 
    points_produced
