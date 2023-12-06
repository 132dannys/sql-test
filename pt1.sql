-- TASK 1
-- Вывести информацию о всех автомобилях компании с указанием ID автомобиля,
-- регистрационного номера, максимальной грузоподъемности и наименованием брэнда.
-- Отсортировать по убыванию НАИМЕНОВАНИЯ брэнда
select cars.id, cars.brand_id, cars.registration_number, cars.weight, brands.name as brand
from cars
    join brands on cars.brand_id = brands.id
order by length(brands.name) desc;

-- TASK 2
-- Вывести информацию о количестве автомобилей компании по каждому брэнду
select brands.name AS brand, count(cars.id) as car_count
from brands
join cars on brands.id = cars.brand_id
group by brands.name;

-- TASK 3
-- Вывести все автомобили с гос. номером заканчивающимся на ‘7’
select * from cars where cars.registration_number like '%7';

-- TASK 4
-- Вывести все ID рейсов совершенных
-- A) вчера
-- B) в указанном диапазоне дат

select carlist.id from carlist where carlist.date::date = current_date - interval '1' day;
select carlist.id from carlist where carlist.date::date >= '2023-01-01' and carlist.date::date <= current_date;

-- TASK 5
-- Вывести ID рейсов совершенных водителями фамилией ‘Иванов’ на автомобиле брэнда Renault
select carlist.id from carlist
    join drivers on carlist.driver_id = drivers.id
    join cars on carlist.car_id = cars.id
    join brands on cars.brand_id = brands.id
where drivers.surname = 'Ivanov' and brands.name = 'Renault';

--TASK 6
-- Вывести информацию по водителям где в одном столбце должен быть указан ID водителя, а во
-- втором - ID водителя Фамилия Имя Отчество
select drivers.id as driver_id,
    concat(drivers.id, ' ', drivers.surname, ' ', drivers.name, ' ', drivers.patronymic) as driver_info
from drivers;

--TASK 7
-- Вывести информацию о том, когда каждый из водителей совершил свой первый рейс и крайний
-- рейс, на каком авто он при этом ездил.

select
    drivers.id as driver_id,
    drivers.surname,
    drivers.name,
    drivers.patronymic,
    min(carlist.date) as first_trip_date,
    max(carlist.date) as last_trip_date,
    min(cars.registration_number) as first_car,
    max(cars.registration_number) as last_car
from drivers
left join carlist on drivers.id = carlist.driver_id
left join cars on carlist.car_id = cars.id
group by drivers.id, drivers.surname, drivers.name, drivers.patronymic;
