-- Compare the MVP winners with those that got the most win shares in each season.
WITH player_ws AS (
    SELECT
        season,
        player_name,
        ws
    FROM 
        {{ ref('win_shares') }}
    -- Keep only the player with the most win shares
    QUALIFY ROW_NUMBER() OVER(
        PARTITION BY season 
        ORDER BY ws DESC
    ) = 1
),
mvps AS (
    SELECT 
        *
    FROM 
        {{ ref('player_awards') }}  
    WHERE 
        award = 'NBA Most Valuable Player'
)
SELECT 
    w.player_name AS ws_mvp,
    m.player_name AS mvp,
    w.season
FROM  
    player_ws AS w
INNER JOIN 
    mvps AS m 
ON 
    w.season = m.season
ORDER BY 
    w.season DESC
