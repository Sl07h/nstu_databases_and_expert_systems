--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- [+] 1. Задание

-- число деталей от этих поставщиков
select count(distinct n_det)
from spj
where n_post in (
    -- поставщики с объёмом поставок от 600 до 700 деталей
    select n_post
    from spj
    group by n_post
    having 600 <= sum(kol) and sum(kol) <= 700
);



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- [+] 2. Задание

-- проверка
select *
from p;


update p set cvet = (
        case when p.ves = (select max(ves) from p p5)
            then (select p3.cvet cvet1
            from p p3
            order by p3.ves, p3.cvet
            limit 1)
        else (select p4.cvet cvet2
            from p p4
            order by p4.ves DESC, p4.cvet
            limit 1)
        end)
where p.ves = (select min(ves) from p p1)
or p.ves = (select max(ves) from p p2);



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- [+] 3. Задание



-- вес поставок, которые легче самой тяжёлой поставки поставщика в 4 раза 
select distinct spj.n_post, kol*ves as p_weight, temp.quater
from spj
join p on p.n_det = spj.n_det
join (
    -- четверть максимальной поставки каждого поставщика
    select n_post, max(kol*ves) / 4 as quater
    from spj
    join p on p.n_det = spj.n_det
    group by n_post
) temp
on spj.n_post = temp.n_post
where kol*ves < temp.quater;



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- [+] 4. Задание

-- изделия, для которых не поставлялось ни одной из деталей,
-- поставляемых поставщиком S4
(
    -- все изделия
    select n_izd
    from j
)
except
(
    -- изделия с деталями от поставщика S4
    select distinct n_izd
    from spj
    where n_det in(
        select n_det
        from spj
        where n_post = 'S4'
    )
)
order by 1;




--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- [+] 5. Задание

-- полная информация о деталях от поставщиков только с максимальным рейтингом
select *
from p
where n_det in(
    -- детали от поставщиков только с максимальным рейтингом
    (
        -- детали от поставщиков с максимальным рейтингом
        select distinct n_det
        from spj
        where n_post in (
            select n_post
            from s
            where reiting = (
                select max(reiting) 
                from s)
        )
        order by 1
    )
    except
    (
        -- детали от остальных поставщиков
        select distinct n_det
        from spj
        where n_post not in (
            select n_post
            from s
            where reiting = (
                select max(reiting) 
                from s)
        )
        order by 1
    )
);