select w1.*,
(
    select cost
    from e
    where e.date_begin <= w1.date_part and e.n_izd = w1.n_izd
    order by e.date_begin DESC
    limit 1
),
(
    select sum(kol)
    from w w2
    where w2.date_part <= w1.date_part and w2.n_izd = w1.n_izd
) 
from w w1





select n_det
from ( select n_post,n_det,max(cost) as max_cost
       from spj1
       group by  n_post,n_det
       having count(*)>1
     ) a 
where (
       select cost as first_cost
       from spj1
       where n_post = a.n_post and n_det = a.n_det
       order by date_post, cast(substr(n_spj, 2) as int)
       limit 1
) = max_cost
group by n_det
having count(*) > 1