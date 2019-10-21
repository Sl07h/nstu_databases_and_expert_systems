-- Базы данных
-- Л.Р. 2
-- Вариант 4


-- 1. Выбрать изделия, для которых поставляли детали поставщики,
-- поставлявшие зеленые детали.
select distinct t.n_izd
from spj t
where t.n_post in(
    select distinct n_post
    from spj
    join p on spj.n_det=p.n_det
    where p.cvet='Зеленый'
) order by 1



-- 2. Найти поставки такие, что поставщик, изделие и деталь размещены в 
-- одном и том же городе. Вывести номер поставщика, номер изделия, 
-- номер детали и город, где размещены изделие, поставщик и деталь.
select distinct spj.n_post, spj.n_izd, spj.n_det, s.town
from spj
join p on p.n_det=spj.n_det
join s on s.n_post=spj.n_post
join j on j.n_izd=spj.n_izd
where p.town=s.town
      and
      s.town=j.town
order by 1



-- 3. Получить список деталей, поставленных ТОЛЬКО первым по алфавиту поставщиком.
select distinct t.n_det
from spj t
where n_post = (
    select n_post
    from s
    order by name limit 1
)
except
select distinct z.n_det
from spj z
where n_post <> (
    select n_post
    from s
    order by name limit 1
)



-- 4. Вывести полный список деталей и для каждой детали определить,
-- сколько поставщиков с рейтингом меньше 30 поставляли эту деталь. 
-- Детали в списке должны быть ВСЕ. Список должен быть упорядочен 
-- по номеру детали.
Select p.n_det, temp.amount
From p
Left join (
    Select spj.n_det, count(distinct spj.n_post) amount
    From spj join s on spj.n_post = s.n_post
    Where s.reiting < 30
    Group by n_det
) temp
On p.n_det = temp.n_det
Order by 1



-- Cоставление запросов по модификации информации из таблиц базы данных
-- 1. Построить таблицу с упорядоченным списком городов таких, что в городе
--  размещается 1 поставщик и собирается 2 изделия, но не производится ни одна деталь.
create table town (town character(6));
insert into town (
    select town
    from s
    group by town
    having count(s.n_post) = 2

    intersect
    select town
    from j
    group by town
    having count(j.n_izd)  = 2

    except
    select town
    from p
    group by town
    having count(p.n_det)  > 0)
    order by town
)



-- 2. Всех поставщиков, имеющих в настоящее время наибольший рейтинг,
-- перевести в город, откуда поставщик сделал наибольшее число поставок.
-- Если таких городов больше одного, перевести в первый по алфавиту из этих городов.
update s set town = (
    select p.town from spj 
    join p on p.n_det = spj.n_det 
    where spj.n_post = s.n_post 
    group by (p.town) 
    order by count (*) desc, p.town
    limit 1 
) 
where s.reiting = (
    select max(t.reiting) 
    from s t
)