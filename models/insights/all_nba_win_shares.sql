WITH add_position AS (
    SELECT 
        p.*,
        -- Classify every player in one position of Guard, Forward or Center
        -- If there are two available we pick the first one
        -- Example: Center-Forward is classified as Center
        CASE 
            WHEN i.position LIKE 'Guard%' THEN 'G'
            WHEN i.position LIKE 'Forward%' THEN 'F'
            WHEN i.position LIKE 'Center%' THEN 'C'
        END AS position
    FROM 
        {{ ref('win_shares') }} AS p
    LEFT JOIN 
        {{ source('NBA', 'COMMON_PLAYER_INFO') }} AS i
    ON 
        p.player_name = i.display_first_last
    -- Remove current season as it hasn't finished
    WHERE 
        TO_NUMBER(SUBSTRING(season, 1, 4)) < 2023

),
position_ranking AS (
    SELECT 
        *,
        -- Order players per position according to Win Shares
        -- We do one ordering per season
        ROW_NUMBER() OVER(PARTITION BY season, position ORDER BY ws DESC) AS position_rank
    FROM 
        add_position
),
ws_all_nba AS (
    SELECT 
        *,
        -- Set team number according to rank
        -- Each team contains 2 guards, 2 forwards and 1 center
        CASE
            WHEN position IN ('G' , 'F') THEN CEIL(position_rank / 2.0)
            ELSE position_rank
        END AS all_nba_team_number
    FROM 
        position_ranking
    WHERE
        -- Before 1988 there were only two All-NBA teams
        ( position_rank <= 6 AND position IN ('G', 'F') AND TO_NUMBER(SUBSTRING(season, 1, 4)) >= 1988 ) 
        OR 
        ( position_rank <= 4 AND position IN ('G', 'F') AND TO_NUMBER(SUBSTRING(season, 1, 4)) < 1988 ) 
        OR
        ( position_rank <= 3 AND position = 'C' AND TO_NUMBER(SUBSTRING(season, 1, 4)) >= 1988 ) 
        OR 
        ( position_rank <= 2 AND position = 'C' AND TO_NUMBER(SUBSTRING(season, 1, 4)) < 1988 ) 
)
SELECT 
    season,
    player_name,
    all_nba_team_number,
    position
FROM 
    ws_all_nba
ORDER BY 
    season DESC,
    all_nba_team_number,
    position
