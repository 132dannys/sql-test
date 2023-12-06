-- TASK 1
-- Вывести в одну строку количество товаров, цена которых
-- меньше 100, цена которых лежит в диапазоне 100-200 и цена которых больше 200.
select
    count(case when products.cost < 100 then 1 end) as count_below_100,
    count(case when products.cost >= 100 and cost <= 200 then 1 end) as count_100_to_200,
    count(case when products.cost > 200 then 1 end) as count_above_200
from products;

-- TASK 2
-- Таблица CALENDAR состоит из двух столбцов CALENDAR_DATE(date) – дата IS_DAYOFF (bigint) –
-- признак выходного дня (0-рабочий 1-выходной). Таблица MESSAGE состоит из трех столбцов
-- DOCUMENT_ID (bigint) – идентификатор сообщения(ответа), DOCUMENT_DT (date) – дата отправки
-- сообщения (получения ответа), CHILD_DOCUMENT_ID (bigint) – идентификатор ответа на
-- сообщение. Сообщения и ответы на сообщения сохраняются в эту таблицу. Запрос должен
-- отображать идентификаторы сообщений, по которым не получен ответ в течении 5 рабочих дней
-- со дня отправки сообщения.
select
    M1.id
from
    message as M1
left join
    message as M2 on M1.id = M2.child_document_id
join
    calendar as C1 on M1.document_dt = C1.calendar_date and C1.is_dayoff = 0
left join
    calendar as C2 on M2.document_dt = C2.calendar_date and C2.is_dayoff = 0
where
    M2.id is null
    and (C2.calendar_date is null or C2.calendar_date > C1.calendar_date + interval '5' day);

-- TASK 3
-- Написать скрипты на создание таблиц из заданий 1 и 2
create procedure CreateProductsTable()
language plpgsql
as $$
begin
    create table if not exists
        Products (
            id integer primary key,
            cost numeric(18,2)
    );
end;
$$;

create procedure CreateCalendarTable()
language plpgsql
as $$
begin
    create table if not exists
        Calendar (
            calendar_date date primary key,
            is_dayoff int check (is_dayoff in (0, 1))
    );
end;
$$;

create procedure CreateMessageTable()
language plpgsql
as $$
begin
    create table if not exists
        Message (
            id integer primary key,
            document_dt date,
            child_document_id integer,
            foreign key (child_document_id) references Message(id)
    );
end;
$$;
-- TASK 4
-- Разработать скрипты (процедуры) для генерации тестовых данных. Входным параметром
-- процедуры должен быть параметр – необходимое количество строк с тестовыми данными
create procedure GenerateProductsTestData(num_records int)
language plpgsql
as $$
declare i int := 1;
begin
    while i <= num_records loop
        insert into products (cost) values (random() * 1000);
        i := i + 1;
        end loop;
end;
$$;

create procedure GenerateCalendarTestData(start_date date, end_date date)
language plpgsql
as $$
declare
    current date := start_date;
begin
    while current <= end_date loop
        insert into calendar (calendar_date, is_dayoff) values (
                                                                current,
                                                                case when extract(dow from current) in (0, 6) then 1 else 0 end
                                                               );
        current := current + 1;
        end loop;
end;
$$;

create procedure GenerateMessageTestData(num_records int)
language plpgsql
as $$
declare
    i int := 1;
begin
    while i <= num_records loop
        insert into message (id, document_dt, child_document_id) values (
                                                                     i,
                                                                     current_date - (i % 10),
                                                                     null
                                                                    );
        i := i + 1;
        end loop;
end;
$$;
