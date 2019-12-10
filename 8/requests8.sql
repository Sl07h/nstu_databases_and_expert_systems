--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Запросы для 8 лабораторной работы по базам данных и экспертным системам
-- Состав бригады: Кожекин, Утюганов
-- Вариант 4

-- [+] 1. Задание

-- Получить информацию о выручке поставщиков, сделавших больше всего поставок
-- для указанного изделия
select distinct n_post,  sum(kol*cost) as revenue
from pmib6306.spj1
where n_post in (
    select n_post
    from pmib6306.spj1
    where n_izd = ?
    group by 1
    having count(kol) = (
        -- максимальное число поставленных деталей
        select count(kol) as deliveries
        from pmib6306.spj1
        where n_izd = ?
        group by n_post
        order by count(kol) desc
        limit 1
    )
)
group by n_post
order by 1;




-- [+] 2. Задание
-- Для заданного поставщика удвоить количество деталей в поставках за заданный
-- период

-- Просмотр
select *
from pmib6306.spj1
where n_post = ? and date_post between ? and ?

-- Удвоение числа деталей
update pmib6306.spj1
set kol = kol * 2
where n_post = ? and date_post between ? and ?;