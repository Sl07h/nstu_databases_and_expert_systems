
(
    select distinct n_post
    from spj
    where n_izd in (
        -- детали для изделий из Рима
        select n_izd
        from j
        where j.town = 'Рим'
    )
)
except
(
    select distinct n_post
    from spj
    where not n_izd in (
        -- детали для изделий из Рима
        select n_izd
        from j
        where j.town = 'Рим'
    )
)