select j.town, count(*) as sent_orders
from r
join j on j.n_izd = r.n_izd
group by town




select AVG(sent_orders) as average
from (
    select j.town, count(*) as sent_orders
    from r
    join j on j.n_izd = r.n_izd
    group by town
) as t



-- select j.town, count(*) as sent_orders
-- from r
-- join j on j.n_izd = r.n_izd
-- where t.sent_orders < (
--     select AVG(sent_orders) as average
--     from (
--         select j.town, count(*) as sent_orders
--         from r
--         join j on j.n_izd = r.n_izd
--         group by town
--     ) as t
-- )
-- group by town



    select n_izd, sum(p.ves * spj1.kol) as sum_weight
    from spj1
    join p on p.n_det = spj1.n_det
    group by n_izd
having sum_weight < (
select AVG(sum_weight) as average
    from (
    select n_izd, sum(p.ves * spj1.kol) as sum_weight
    from spj1
    join p on p.n_det = spj1.n_det
    group by n_izd) as t)



select j.town, count(*)
from r
join j on j.n_izd = r.n_izd
group by town
having count(*) < (
select AVG(count) as average
    from (
    select j.town, count(*)
    from r
    join j on j.n_izd= r.n_izd
    group by town) as t)







select p.town, count(*)
from spj1
join p on p.n_det = spj1.n_det
group by town
having count(*) < (
select AVG(count) as average
    from (
    select p.town, count(*)
    from spj1
    join p on p.n_det = spj1.n_det
    group by town) as t)




select *
from (select c.town
from r
join c on c.n_cl = r.n_cl

group by town
having count(*) < (
select AVG(count) as average
    from (
    select c.town, count(*)
    from r
    join c on c.n_cl= r.n_cl
    group by town) as t)
) as u
cross join c as c2
left join r on c2.n_cl = r.n_cl
where date_pay is not null


select r.n_izd, c.town, sum(kol*cost)
from r
left join c on c.n_cl = r.n_cl
group by 1,2
order by 1,2



----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
select j.n_izd, u.town, a.kolvo
from (select c.town
      from r
      join c on c.n_cl = r.n_cl
      group by town
      having count(*) < ( select AVG(count) as average
                          from (
                          select c.town, count(*)
                          from r
                          join c on c.n_cl= r.n_cl
                          group by town) as t)
) as u
cross join j
left join (
           select r.n_izd, c.town, sum(kol*cost) as kolvo
           from r
           left join c on c.n_cl = r.n_cl
           group by 1,2
           order by 1,2
) a on a.n_izd = j.n_izd and a.town = u.town




 
select n_izd, sum(ves * kol) as sum_weight
from spj1
join p on p.n_det = spj1.n_det
group by n_izd
order by 1




select AVG(sum_weight) as average
from (
    select n_izd, sum(ves * kol) as sum_weight
    from spj1
    join p on p.n_det = spj1.n_det
    group by n_izd
    order by 1
) as t




select n_izd, sum(p.ves * spj1.kol) as sum_weight
from spj1
join p on p.n_det = spj1.n_det
group by n_izd
having sum(p.ves * spj1.kol)< (
    select AVG(sum_weight) as average
    from (
    select n_izd, sum(p.ves * spj1.kol) as sum_weight
    from spj1
    join p on p.n_det = spj1.n_det
    group by n_izd) as t)




select *
from (  select n_izd
        from spj1
        join p on p.n_det = spj1.n_det
        group by n_izd
        having sum(p.ves * spj1.kol) < (
            select AVG(sum_weight) as average
            from (
            select n_izd, sum(p.ves * spj1.kol) as sum_weight
            from spj1
            join p on p.n_det = spj1.n_det
            group by n_izd) as t)) as u
cross join p
left join (
        select j.n_izd, spj1.n_det, sum(kol*cost) as kolvo
        from j
        left join spj1 on j.n_izd = spj1.n_izd
        group by 1,2
        order by 1,2
) a on a.n_izd = u.n_izd and a.n_det = p.n_det




select a.n_izd, p.n_det, percent_rank() over (
    order by 1,2) * 100.0 as percent
from (  select n_izd
        from spj1
        join p on p.n_det = spj1.n_det
        group by n_izd
        having sum(p.ves * spj1.kol) >= (
            select AVG(sum_weight) as average
            from (
            select n_izd, sum(p.ves * spj1.kol) as sum_weight
            from spj1
            join p on p.n_det = spj1.n_det
            group by n_izd) as t)) as u
cross join p
left join (
        select j.n_izd, spj1.n_det, sum(kol*cost) as kolvo
        from j
        left join spj1 on j.n_izd = spj1.n_izd
        group by 1,2
        order by 1,2
) a on a.n_izd = u.n_izd and a.n_det = p.n_det
group by 1, 2
order by 1, 2




select a.n_izd, p.n_det, a.kolvo
from (  select n_izd
        from spj1
        join p on p.n_det = spj1.n_det
        group by n_izd
        having sum(p.ves * spj1.kol) >= (
            select AVG(sum_weight) as average
            from (
            select n_izd, sum(p.ves * spj1.kol) as sum_weight
            from spj1
            join p on p.n_det = spj1.n_det
            group by n_izd) as t)) as u
cross join p
left join (
        select j.n_izd, spj1.n_det, sum(kol*cost) as kolvo
        from j
        left join spj1 on j.n_izd = spj1.n_izd
        group by 1,2
        order by 1,2
) a on a.n_izd = u.n_izd and a.n_det = p.n_det
group by 1, 2
order by 1, 2


----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
select j.n_izd, u.town, coalesce(a.kolvo, 0)
from (select c.town
      from r
      join c on c.n_cl = r.n_cl
      group by town
      having count(*) < ( select AVG(count) as average
                          from (
                          select c.town, count(*)
                          from r
                          join c on c.n_cl= r.n_cl
                          group by town) as t)
) as u
cross join j
left join (
           select r.n_izd, c.town, sum(kol*cost) as kolvo
           from r
           left join c on c.n_cl = r.n_cl
           group by 1,2
           order by 1,2
) a on a.n_izd = j.n_izd and a.town = u.town







select u.n_izd, p.n_det, coalesce(round(a.s_izd_det * 100.0 / b.s_izd, 2), 0) as percent
from (  select n_izd
        from spj1
        join p on p.n_det = spj1.n_det
        group by n_izd
        having sum(p.ves * spj1.kol) >= (
            select AVG(sum_weight) as average
            from (
            select n_izd, sum(p.ves * spj1.kol) as sum_weight
            from spj1
            join p on p.n_det = spj1.n_det
            group by n_izd) as t)
      ) as u
cross join p
left join ( select n_izd, n_det, sum(kol*cost) as s_izd_det
            from spj1 
             group by 1,2
         ) a on a.n_izd = u.n_izd and a.n_det = p.n_det
left join ( select n_izd, sum(kol*cost) as s_izd
            from spj1
            group by 1
          ) b on b.n_izd = u.n_izd 

order by 1, 2