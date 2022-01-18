select bcsm.game_id, bcsm.player_id,c.name, bcsm.dbf_id, bcsm.minion_entity_id, bcsm.combat_round, bp.hero, bp.hero_dbf_id,
bcsm.dbf_id - LAG(bcsm.dbf_id)
 	OVER (PARTITION BY bcsm.combat_round order by bcsm.dbf_id) AS difference_previous_year,
count(bcsm.dbf_id) over(partition by bcsm.combat_round) as minions_per_round
from  battlegrounds_combat_snapshot_minion bcsm  
inner join (select bp.game_id, bp.player_id, bp.game_date, bp.battlegrounds_rating, c.name as hero, bp.hero_dbf_id 
from battlegrounds_player bp 
inner join card c 
on c.dbf_id = bp.hero_dbf_id 
and bp.game_date = '2022-01-12'
and bp.battlegrounds_rating >=5000 ) as bp
on bp.game_id = bcsm.game_id 
inner join card c 
on c.dbf_id = bcsm.dbf_id 
where bp.player_id = bcsm.player_id  
and bcsm.game_date = '2022-01-12'
and bcsm.game_id = 2321829208
order by bcsm.game_id, bcsm.player_id, bcsm.combat_round
limit 100;
