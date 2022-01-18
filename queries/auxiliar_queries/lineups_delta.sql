
select bcsm.game_id, bcsm.player_id,bcsm.friendly_lineup, bcsm.combat_round, bp.hero, bp.hero_dbf_id,
 lag(bcsm.friendly_lineup) over(order by bcsm.combat_round) as teste,
 json_extract_array_element_text(bcsm.friendly_lineup, 0) as first_position,
 json_array_length(bcsm.friendly_lineup) as len_array
from  battlegrounds_combat_snapshot bcsm  
inner join (select bp.game_id, bp.player_id, bp.game_date, bp.battlegrounds_rating, c.name as hero, bp.hero_dbf_id 
from battlegrounds_player bp 
inner join card c 
on c.dbf_id = bp.hero_dbf_id 
and bp.game_date between to_date('2022-01-13','YYYY-MM-DD') - interval '4 days' and to_date('2022-01-13','YYYY-MM-DD')
and bp.battlegrounds_rating >=5000 ) as bp
on bp.game_id = bcsm.game_id 
where bp.player_id = bcsm.player_id  
and bcsm.game_date between to_date('2022-01-13','YYYY-MM-DD') - interval '4 days' and to_date('2022-01-13','YYYY-MM-DD')
and bcsm.game_id = 2321829208
order by bcsm.game_id, bcsm.player_id, bcsm.combat_round
limit 20;