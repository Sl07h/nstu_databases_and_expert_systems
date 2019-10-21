-- 14. Получить номера изделий, для которых выполнил поставки КАЖДЫЙ поставщик, 
-- поставлявший деталь P1
select t.n_izd
from spj t
where t.n_post in (
    -- поставщики детали P1
    select distinct d.n_post
    from spj d
    where d.n_det = 'P1'
)
group by t.n_izd
having count(distinct t.n_post) = (select count(distinct d.n_post)
                                    from spj d
                                    where d.n_post = 'P1')
order by t.n_izd