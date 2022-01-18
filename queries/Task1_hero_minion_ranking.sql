WITH minion_rank AS (
	SELECT 
	bp.hero_dbf_id, 
	bmo.recruitment_round, 
	bmo.dbf_id, 
	COUNT(bmo.dbf_id) AS minion_count,
	RANK() OVER(PARTITION BY bp.hero_dbf_id, bmo.recruitment_round ORDER BY minion_count DESC) AS minion_ranking
	FROM  battlegrounds_minion_offered bmo  
	INNER JOIN (
		SELECT 
		bp.game_id, 
		bp.player_id, 
		bp.game_date, 
		bp.battlegrounds_rating, 
		bp.hero_dbf_id 
		FROM battlegrounds_player bp 
		WHERE bp.game_date BETWEEN to_date('2022-01-13','YYYY-MM-DD') - interval '4 days' AND to_date('2022-01-13','YYYY-MM-DD')
		AND bp.battlegrounds_rating >=5000 
		) AS bp
	ON bp.game_id = bmo.game_id 
	AND bp.player_id = bmo.player_id  
	WHERE bmo.game_date BETWEEN to_date('2022-01-13','YYYY-MM-DD') - interval '4 days' AND to_date('2022-01-13','YYYY-MM-DD')
	AND bmo.purchased = TRUE
	GROUP BY bp.hero_dbf_id, bmo.recruitment_round, bmo.dbf_id
	ORDER BY bp.hero_dbf_id, bmo.recruitment_round , minion_count DESC
) 
SELECT 
c.name AS hero, 
minion_rank.recruitment_round, 
c2.name AS minion, 
minion_rank.minion_count, 
minion_rank.minion_ranking
FROM minion_rank
INNER JOIN card c 
ON c.dbf_id = minion_rank.hero_dbf_id 
INNER JOIN card c2 
ON c2.dbf_id = minion_rank.dbf_id 
WHERE minion_rank.minion_ranking <= 10
ORDER BY minion_rank.hero_dbf_id, minion_rank.recruitment_round , minion_rank.minion_count DESC
;