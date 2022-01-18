WITH final_round AS (
	SELECT 
	bcs2.game_id, 
	bcs2.player_id, 
	MAX(bcs2.combat_round) AS final_round
	FROM battlegrounds_combat_snapshot bcs2
	WHERE bcs2.game_date BETWEEN TO_DATE('2022-01-13','YYYY-MM-DD') - INTERVAL '4 days' AND TO_DATE('2022-01-13','YYYY-MM-DD')
	GROUP BY bcs2.game_id, bcs2.player_id
	)
SELECT 
bcs.game_id, 
bcs.player_id, 
bcs.friendly_lineup,
final_round.final_round,
bp.battlegrounds_rating 
FROM battlegrounds_combat_snapshot bcs 
INNER JOIN (
	SELECT 
	bp.game_id, 
	bp.player_id, 
	bp.battlegrounds_rating,
	bp.game_date
	FROM battlegrounds_player bp 
	WHERE bp.game_date BETWEEN TO_DATE('2022-01-13','YYYY-MM-DD') - INTERVAL '4 days' AND TO_DATE('2022-01-13','YYYY-MM-DD')
	AND bp.final_placement = 1
	) AS bp
ON bp.game_id = bcs.game_id 
AND bp.player_id = bcs.player_id
and bp.game_date = bcs.game_date
INNER JOIN final_round
ON bcs.game_id = final_round.game_id
AND bcs.player_id = final_round.player_id
AND bcs.combat_round = final_round.final_round
WHERE bcs.game_date BETWEEN TO_DATE('2022-01-13','YYYY-MM-DD') - INTERVAL '4 days' AND TO_DATE('2022-01-13','YYYY-MM-DD')
ORDER BY bcs.game_id
limit 10;
