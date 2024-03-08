-- Compare the ROY winners with the rookies that got the most win shares in each season.
WITH rookie_seasons AS (
    SELECT
        season,
        player_name,
        ws
    FROM 
        {{ ref('win_shares') }}
    -- Keep only the first season of each player
    QUALIFY ROW_NUMBER() OVER(
        PARTITION BY player_name
        ORDER BY season
    ) = 1
),
player_ws AS (
    SELECT
        season,
        player_name,
        ws
    FROM 
        rookie_seasons
    -- Keep only the rookie with the most win shares
    QUALIFY ROW_NUMBER() OVER(
        PARTITION BY season 
        ORDER BY ws DESC
    ) = 1
),
roys AS (
    SELECT 
        *
    FROM 
        {{ ref('player_awards') }}  
    WHERE 
        award LIKE 'NBA Rookie of the Year'
)
SELECT 
    w.player_name AS ws_roy,
    r.player_name AS roy,
    w.season
FROM  
    player_ws AS w
INNER JOIN 
    roys AS r
ON 
    w.season = r.season
ORDER BY 
    w.season DESC
