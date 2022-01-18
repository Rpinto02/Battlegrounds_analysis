SELECT 
distinct (bcs.combat_round),
bcs.game_id, 
bcs.player_id, 
bcs.friendly_lineup,
bp.battlegrounds_rating 
FROM battlegrounds_combat_snapshot bcs 
INNER JOIN (
	SELECT 
	bp.game_id, 
	bp.player_id, 
	bp.battlegrounds_rating
	FROM battlegrounds_player bp 
	WHERE bp.game_date BETWEEN TO_DATE('2022-01-13','YYYY-MM-DD') - INTERVAL '4 days' AND TO_DATE('2022-01-13','YYYY-MM-DD')
	AND bp.final_placement = 1
	) AS bp
ON bp.game_id = bcs.game_id 
AND bp.player_id = bcs.player_id
WHERE bcs.game_date BETWEEN TO_DATE('2022-01-13','YYYY-MM-DD') - INTERVAL '4 days' AND TO_DATE('2022-01-13','YYYY-MM-DD')
and bcs.rounds_remaining = 0
ORDER BY bcs.game_id desc
limit 10
;


