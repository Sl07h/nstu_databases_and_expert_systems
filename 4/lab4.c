#include <sqlca.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 1. Выдать число деталей, которые поставлялись поставщиками, имеющими поставки
// с объемом от 600 до 700 деталей.
int problem1()
{
    printf("\n\nЗадание 1\n");
    printf("Вывести число деталей, которые поставлялись поставщиками, имеющими поставки с объемом от 600 до 700 деталей\n");
    exec sql begin declare section;
    int details_count;
    exec sql end declare section;

    /////////////////////////////////////////////////////////////////////////SQL
    exec sql begin work; // начало транзакции
    exec sql
    -- число деталей от этих поставщиков
    select count(distinct n_det) into :details_count
    from spj
    where n_post in (
        -- поставщики с объёмом поставок от 600 до 700 деталей
        select n_post
        from spj
        group by n_post
        having 600 <= sum(kol) and sum(kol) <= 700
    );
    /////////////////////////////////////////////////////////////////////////SQL

    if (sqlca.sqlcode < 0)
    {
        printf("Возникла ошибка. sqlca.sqlcode = %d\n", sqlca.sqlcode);
        exec sql rollback work; // отмена транзакции
        return -1;
    }
    else if (sqlca.sqlcode == 100)
    {
        printf("Данных нет.\n");
        exec sql commit work; // конец транзакции
        return 0;
    }
    else if (sqlca.sqlcode == 0)
    {
        printf("%d\n", details_count);
        exec sql commit work; // конец транзакции
        return 0;
    }
}


char *my_copy(char *str)
{
    char new_str[64];
    int i = 0;
    while (i<strlen(str) && str[i] != ' ')
    {
        new_str[i] = str[i];
        i++;
    }
    return new_str;
}

// 2. Поменять местами цвета самой тяжелой и самой легкой детали, т. е. деталям
// с наибольшим весом установить цвет детали с минимальным весом, а деталям с
// минимальным весом установить цвет детали с наибольшим весом. Если цветов несколько,
// брать первый по алфавиту из этих цветов. 
int problem2()
{
    printf("\n\nЗадание 2\n");
    printf("Поменять местами цвета самой тяжелой и самой легкой детали:\n");
    int status;
    exec sql begin declare section;
    char cvet[20];
    exec sql end declare section;
    /////////////////////////////////////////////////////////////////////////SQL
    exec sql begin work; // начало транзакции
    exec sql
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
    /////////////////////////////////////////////////////////////////////////SQL

    exec sql declare my_cursor2 cursor for
    select cvet
    from p
    where n_det = 'P6';

    exec sql open my_cursor2;
    exec sql fetch from my_cursor2 into :cvet; 
    // P6 не должно быть красным
    if (sqlca.sqlcode < 0)
    {
        printf("Возникла ошибка. sqlca.sqlcode = %d\n", sqlca.sqlcode);
        exec sql rollback work; // отмена транзакции
        return -1;
    }
    else if (sqlca.sqlcode == 100)
    {
        printf("Данных нет.\n");
        exec sql commit work; // конец транзакции
        return 0;
    }
    else if (sqlca.sqlcode == 0)
    {
        if (!strcmp(my_copy(cvet), "Красный"))
        {
            printf("Замена выполнена успешно.\n");
            exec sql commit work;
            return 0;
        }
        else
        {
            printf("Возникла ошибка.\nP6 должна была изменить цвет.\n");
            exec sql rollback work;
            return -1;
        }
    }
}




// 3. Найти поставщиков, имеющих поставки, вес которых составляет менее четверти
// наибольшего веса поставки этого поставщика. Вывести номер поставщика, вес поставки,
// четверть наибольшего веса поставки поставщика.
int problem3()
{
    printf("\n\nЗадание 3\n");
    printf("Поставщики, имеющие поставки, вес которых составляет менее четверти наибольшего веса поставки этого поставщика:\n");
    int status;
    exec sql begin declare section;
    int ves, quater_of_weight;
    char n_post[6];
    exec sql end declare section;

    /////////////////////////////////////////////////////////////////////////SQL
    exec sql begin work; // начало транзакции
    exec sql declare my_cursor3 cursor for
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
    /////////////////////////////////////////////////////////////////////////SQL

    exec sql open my_cursor3;

    if (sqlca.sqlcode < 0)
    {
        printf("Возникла ошибка. sqlca.sqlcode = %d\n", sqlca.sqlcode);
        exec sql rollback work; // отмена транзакции
        return -1;
    }
    else if (sqlca.sqlcode == 100)
    {
        printf("Данных нет.\n");
        exec sql commit work; // конец транзакции
        return 0;
    }
    else if (sqlca.sqlcode == 0)
    {
        printf("n_post\tves\tquater\n");
        printf("%s\t%d\t%d\n", n_post, ves, quater_of_weight);
        while (sqlca.sqlcode == 0) // основной цикл
        {
            exec sql fetch from my_cursor3 into :n_post, :ves, :quater_of_weight;
            if (sqlca.sqlcode != 100)
                printf("%s\t%d\t%d\n", n_post, ves, quater_of_weight);
        }
        exec sql commit work; // конец транзакции
        return 0;
    }
}


// 4. Выбрать изделия, для которых не поставлялось ни одной из деталей,
// поставляемых поставщиком S4. 
int problem4()
{
    printf("\n\nЗадание 4\n");
    printf("Изделия, для которых не поставлялось ни одной из деталей, поставляемых поставщиком S4:\n");
    int status;
    exec sql begin declare section;
    char n_izd[6];
    exec sql end declare section;

    /////////////////////////////////////////////////////////////////////////SQL
    exec sql begin work; // начало транзакции
    exec sql declare my_cursor4 cursor for
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
    /////////////////////////////////////////////////////////////////////////SQL

    exec sql open my_cursor4;
    exec sql fetch from my_cursor4 into :n_izd;
    
    if (sqlca.sqlcode < 0)
    {
        printf("Возникла ошибка. sqlca.sqlcode = %d\n", sqlca.sqlcode);
        exec sql rollback work; // отмена транзакции
        return -1;
    }
    else if (sqlca.sqlcode == 100)
    {
        printf("Данных нет.\n");
        exec sql commit work; // конец транзакции
        return 0;
    }
    else if (sqlca.sqlcode == 0)
    {
        printf("n_izd\n");
        printf("%s\n", n_izd);
        while (sqlca.sqlcode == 0) // основной цикл
        {
            exec sql fetch from my_cursor4 into :n_izd;
            if (sqlca.sqlcode != 100)
                printf("%s\n", n_izd);
        }
        exec sql commit work; // конец транзакции
        return 0;
    }
}


// 5. Выдать полную информацию о деталях, которые поставлялись
// ТОЛЬКО поставщиками с максимальным рейтингом.
int problem5()
{
    printf("\n\nЗадание 5:\n");
    printf("Детали, которые поставлялись только поставщиками с максимальным рейтингом:\n");
    int status;
    exec sql begin declare section;
    int ves;
    char n_det[6], name[20], cvet[20], town[20];
    exec sql end declare section;

    
    /////////////////////////////////////////////////////////////////////////SQL
    exec sql begin work; // начало транзакции
    exec sql declare my_cursor5 cursor for
    -- полная информация о деталях от поставщиков только с максимальным рейтингом
    select *
    from p
    where n_det in (
        -- детали от поставщиков только с максимальным рейтингом
        (
            -- детали от поставщиков с максимальным рейтингом
            select distinct n_det
            from spj
            where n_post in (
                select n_post
                from s
                order by
                    reiting DESC
                limit 1
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
                order by
                    reiting DESC
                limit 1
            )
            order by 1
        )
    );
    /////////////////////////////////////////////////////////////////////////SQL    

    exec sql open my_cursor5;

    exec sql fetch from my_cursor5 into :n_det, :name, :cvet, :ves, :town;
    if (sqlca.sqlcode < 0)
    {
        printf("Возникла ошибка. sqlca.sqlcode = %d\n", sqlca.sqlcode);
        exec sql rollback work; // отмена транзакции
        return -1;
    }
    else if (sqlca.sqlcode == 100)
    {
        printf("Данных нет.\n");
        exec sql commit work; // конец транзакции
        return 0;
    }
    else if (sqlca.sqlcode == 0)
    {
        printf("n_det   name\t\t  cvet         ves\t\ttown\n");
        printf("%s\t%s%s%d\t\t%s\n", n_det, name, cvet, ves, town);
        while (sqlca.sqlcode == 0) // основной цикл
        {
            exec sql fetch from my_cursor5 into :n_det, :name, :cvet, :ves, :town;
            if (sqlca.sqlcode != 100)
                printf("%s\t%s%s%d\t\t%s\n", n_det, name, cvet, ves, town);
        }
        exec sql commit work; // конец транзакции
        return 0;
    }
}



int main()
{
    // присоединяемся к БД students на fpm2.ami.nstu.ru
    exec sql connect to students @fpm2.ami.nstu.ru user "pmi-b6306" using "Jemlift5";
    if (sqlca.sqlcode < 0)
    {
        printf("Error: can't sign in\n");
        return -1;
    }

    // устанавливаем путь к схеме
    exec sql set search_path to pmib6306;

    if (problem1() < 0)
    {
        printf("Ошибка в решении задания 1\n");
        return -1;
    }
    if (problem2() < 0)
    {
        printf("Ошибка в решении задания 2\n");
        return -1;
    }
    if (problem3() < 0)
    {
        printf("Ошибка в решении задания 3\n");
        return -1;
    }
    if (problem4() < 0)
    {
        printf("Ошибка в решении задания 4\n");
        return -1;
    }
    if (problem5() < 0)
    {
        printf("Ошибка в решении задания 5\n");
        return -1;
    }

    exec sql disconnect;
    return 0;
}