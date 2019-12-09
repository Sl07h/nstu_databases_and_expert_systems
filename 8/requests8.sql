﻿--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Запросы для 8 лабораторной работы по базам данных и экспертным системам
-- Состав бригады: Кожекин, Утюганов
-- Вариант 4

-- [+] 1. Задание
-- Получить информацию о выручке поставщиков, сделавших больше всего поставок
-- для указанного изделия
-- Получить информацию о выручке поставщиков, сделавших больше всего поставок
-- для указанного изделия
select n_post, sum(t2.kol*t2.cost) as revenue
from pmib6306.spj1 t2
where t2.n_post = ( -- максимальное число поставленных деталей
                    select t1.n_post
                    from pmib6306.spj1 t1
                    where t1.n_izd = ?
                    group by t1.n_post
                    order by sum(t1.kol) desc
                    limit 1 )
group by t2.n_post




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