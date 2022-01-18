with players_5k as
(select bcsm.player_id, dbf_id from battlegrounds_combat_snapshot_minion bcsm 
inner join battlegrounds_player bp 
on bp.player_id = bcsm.player_id 
where bp.battlegrounds_rating >= 5000
and bcsm.game_date between Current_timestamp - interval '4 days'
and Current_timestamp)
,
minion_count as (
select dbf_id, count(bcs.dbf_id) as minion_count
from players_5k bcs 
group by bcs.dbf_id
)
select c.name, minion_count.minion_count
from minion_count
inner join card c 
on c.dbf_id = minion_count.dbf_id
order by minion_count desc
limit 20
;