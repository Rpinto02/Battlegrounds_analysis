select bcsm.dbf_id, count(bcsm.dbf_id) as minion_count, bcsm.combat_round, bp.hero_dbf_id

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
group by bp.hero_dbf_id, bcsm.dbf_id, bcsm.combat_round
order by hero_dbf_id, bcsm.combat_round, minion_count desc
limit 100;