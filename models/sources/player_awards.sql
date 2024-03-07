WITH source AS (
    SELECT 
        *
    FROM 
        IKERCAMARAVKVCU_ANALYTICS.ADDITIONAL_DATA.PLAYER_AWARDS
)
SELECT 
    person_id AS player_id,
    CONCAT(first_name, ' ', last_name) AS player_name,
    description AS award,
    all_nba_team_number,
    season,
    month,
    week
FROM 
    source
-- Remove duplicated rows
QUALIFY ROW_NUMBER() OVER(
    PARTITION BY 
        season,
        award,
        all_nba_team_number,
        player_name
    ORDER BY 
        player_id
) = 1
