----- ТАБЛИЦА J – Изделия (Job)
CREATE TABLE j (
    n_izd character(6) NOT NULL,
    name character(20),
    town character(20)
); 
 
COMMENT ON TABLE j IS 'Изделия'; 
COMMENT ON COLUMN j.n_izd IS 'номер изделия'; 
COMMENT ON COLUMN j.name IS 'название изделия'; 
COMMENT ON COLUMN j.town IS 'город изделия'; 
 
ALTER TABLE ONLY j ADD CONSTRAINT j_pkey PRIMARY KEY (n_izd); 
 
----- ТАБЛИЦА P – Детали (Piece)
CREATE TABLE p ( 
    n_det character(6) NOT NULL,
    name character(20),
    cvet character(20),
    ves integer,
    town character(20)
); 
 
COMMENT ON TABLE p IS 'Детали'; 
COMMENT ON COLUMN p.n_det IS 'номер детали'; 
COMMENT ON COLUMN p.name IS 'название детали'; 
COMMENT ON COLUMN p.cvet IS 'цвет детали'; 
COMMENT ON COLUMN p.ves IS 'вес детали'; 
COMMENT ON COLUMN p.town IS 'город детали'; 
 
ALTER TABLE ONLY p ADD CONSTRAINT p_pkey PRIMARY KEY (n_det);


----- ТАБЛИЦА S – Поставщики (Suppliers) 
CREATE TABLE s (
    n_post character(6) NOT NULL,
    name character(20),
    reiting integer,
    town character(20)
); 
 
COMMENT ON TABLE s IS 'Поставщики'; 
COMMENT ON COLUMN s.n_post IS 'номер поставщика'; 
COMMENT ON COLUMN s.name IS 'имя поставщика'; 
COMMENT ON COLUMN s.reiting IS 'ранг поставщика'; 
COMMENT ON COLUMN s.town IS 'город поставщика'; 
 
ALTER TABLE ONLY s ADD CONSTRAINT s_pkey PRIMARY KEY (n_post); 
 
----- ТАБЛИЦА SPJ1 – Поставки (Supply) 
CREATE TABLE spj1 ( 
    n_spj character(6) NOT NULL,
    n_post character(6) NOT NULL,
    n_det character(6) NOT NULL,
    n_izd character(6) NOT NULL,
    kol integer,
    date_post date NOT NULL,
    cost integer NOT NULL,
    CONSTRAINT poscost CHECK ((cost > 0)), 
    CONSTRAINT poskol CHECK ((kol > 0))
); 
 
COMMENT ON TABLE spj1 IS 'Поставки'; 
COMMENT ON COLUMN spj1.n_spj IS 'номер поставки'; 
COMMENT ON COLUMN spj1.n_post IS 'номер поставщика'; 
COMMENT ON COLUMN spj1.n_det IS 'номер детали';
COMMENT ON COLUMN spj1.n_izd IS 'номер изделия'; 
COMMENT ON COLUMN spj1.kol IS 'количество деталей'; 
COMMENT ON COLUMN spj1.date_post IS 'дата поставки'; 
COMMENT ON COLUMN spj1.cost IS 'цена за одну деталь'; 
ALTER TABLE ONLY spj1 ADD CONSTRAINT spj1_n_post_key UNIQUE (n_post,n_det,n_izd,date_post); 
ALTER TABLE ONLY spj1 ADD CONSTRAINT spj1_pkey PRIMARY KEY (n_spj); 
 
----- ТАБЛИЦА C – Заказчики (Client)
CREATE TABLE c ( 
    n_cl character(6) NOT NULL,
    name character(20),
    town character(10),
    discount integer
); 
 
COMMENT ON TABLE c IS 'Заказчики'; 
COMMENT ON COLUMN c.n_cl IS 'номер заказчика'; 
COMMENT ON COLUMN c.name IS 'имя заказчика '; 
COMMENT ON COLUMN c.town IS 'город заказчика'; 
COMMENT ON COLUMN c.discount IS 'скидка'; 
 
ALTER TABLE ONLY c ADD CONSTRAINT c_pkey PRIMARY KEY (n_cl); 
 
----- ТАБЛИЦА Q – норма расхода деталей на одно изделие
CREATE TABLE q (
    n_q character(6) NOT NULL,
    n_izd character(6) NOT NULL,
    n_det character(6) NOT NULL,
    kol integer NOT NULL
); 
 
COMMENT ON TABLE q IS 'Норма расхода деталей на одно изделие'; 
COMMENT ON COLUMN q.n_q IS 'номер записи'; 
COMMENT ON COLUMN q.n_izd IS 'номер изделия'; 
COMMENT ON COLUMN q.n_det IS 'номер детали'; 
COMMENT ON COLUMN q.kol IS 'количество деталей для одного изделия'; 
 
ALTER TABLE ONLY q ADD CONSTRAINT q_n_izd_key UNIQUE (n_izd,n_det); 
ALTER TABLE ONLY q ADD CONSTRAINT q_pkey PRIMARY KEY (n_q);

----- ТАБЛИЦА W – Выпуск изделий (Working)
CREATE TABLE w (
    n_part character(6) NOT NULL,
    n_izd character(6) NOT NULL,
    date_part date,
    kol integer NOT NULL
); 
 
COMMENT ON TABLE w IS 'Выпуск изделий'; 
COMMENT ON COLUMN w.n_part IS 'номер партии'; 
COMMENT ON COLUMN w.n_izd IS 'номер изделия'; 
COMMENT ON COLUMN w.date_part IS 'дата изготовления партии'; 
COMMENT ON COLUMN w.kol IS 'количество изделий'; 
ALTER TABLE ONLY w ADD CONSTRAINT w_pkey PRIMARY KEY (n_part); 
 
----- ТАБЛИЦА E – Издержки на производство
CREATE TABLE e (
    n_exp character(6) NOT NULL,
    n_izd character(6) NOT NULL,
    date_begin date NOT NULL,
    cost integer NOT NULL
); 
 
COMMENT ON TABLE e IS 'Издержки на производство'; 
COMMENT ON COLUMN e.n_exp IS 'номер записи'; 
COMMENT ON COLUMN e.n_izd IS 'номер изделия'; 
COMMENT ON COLUMN e.date_begin IS 'действует с даты';
COMMENT ON COLUMN e.cost IS 'размер издержек на одно изделие'; 
 
ALTER TABLE ONLY e ADD CONSTRAINT e_n_izd_key UNIQUE (n_izd,date_begin); 
ALTER TABLE ONLY e ADD CONSTRAINT e_pkey PRIMARY KEY (n_exp); 
 
----- ТАБЛИЦА V – Рекомендованная цена
CREATE TABLE v ( 
    n_v character(6) NOT NULL, 
    n_izd character(6) NOT NULL,
    date_begin date NOT NULL,
    cost integer NOT NULL
);

COMMENT ON TABLE v IS 'Рекомендованная цена';
COMMENT ON COLUMN v.n_v IS 'номер цены';
COMMENT ON COLUMN v.n_izd IS 'номер изделия';
COMMENT ON COLUMN v.date_begin IS 'действует с даты';
COMMENT ON COLUMN v.cost IS 'размер';
 
ALTER TABLE ONLY v ADD CONSTRAINT n_n_izd_key UNIQUE 
(n_izd,date_begin); 
ALTER TABLE ONLY v ADD CONSTRAINT n_pkey PRIMARY KEY (n_v); 
 
----- ТАБЛИЦА R – Заказы
CREATE TABLE r (
    n_real character(10) NOT NULL,
    n_izd character(6) NOT NULL,
    n_cl character(6) NOT NULL,
    date_order date NOT NULL,
    date_pay date,
    date_ship date,
    kol integer NOT NULL,
    cost integer NOT NULL,
    CONSTRAINT «posRcost» CHECK ((cost > 0)), 
    CONSTRAINT «posRkol» CHECK ((kol > 0))
);
 
COMMENT ON TABLE r IS 'Заказы'; 
COMMENT ON COLUMN r.n_real IS 'номер заказа'; 
COMMENT ON COLUMN r.n_izd IS 'номер изделия';
COMMENT ON COLUMN r.n_cl IS 'номер покупателя'; 
COMMENT ON COLUMN r.date_order IS 'дата заказа'; 
COMMENT ON COLUMN r.date_pay IS 'дата оплаты'; 
COMMENT ON COLUMN r.date_ship IS 'дата отправки заказа'; 
COMMENT ON COLUMN r.kol IS 'количество изделий'; 
COMMENT ON COLUMN r.cost IS 'отпускная цена изделия'; 
 
ALTER TABLE ONLY r ADD CONSTRAINT r_pkey PRIMARY KEY (n_real);

----- ВСТАВКА ДАННЫХ 
----- ТАБЛИЦА J – Изделия (Job) 
INSERT INTO j VALUES 
('J1','Жесткий диск','Париж'), 
('J2','Перфоратор','Рим'), 
('J3','Считыватель','Афины'), 
('J4','Принтер','Афины'), 
('J5','Флоппи-диск','Лондон'), 
('J6','Терминал','Осло'), 
('J7','Лента','Лондон'); 
 
----- ТАБЛИЦА P – Детали (Piece) 
INSERT INTO p VALUES 
('P1','Гайка','Красный',12,'Лондон'), 
('P2','Болт','Зеленый',17,'Париж '), 
('P3','Винт','Голубой',17,'Рим'), 
('P4','Винт','Красный',14,'Лондон'), 
('P5','Кулачок','Голубой',12,'Париж '), 
('P6','Блюм','Красный',19,'Лондон'); 
 
----- ТАБЛИЦА S – Поставщики (Suppliers) 
INSERT INTO s VALUES 
('S1','Смит ',20,'Лондон'), 
('S2','Джонс',10,'Париж '), 
('S3','Блейк',30,'Париж '), 
('S4','Кларк',20,'Лондон'), 
('S5','Адамс',30,'Афины '); 
 
----- ТАБЛИЦА SPJ1 – Поставки (Supply) 
insert into SPJ1 (N_SPJ,N_POST,N_DET,N_IZD,KOL,DATE_POST,COST) 
values ('N1','S2','P3','J4',500,to_date('06-02-2011','dd-mm-yyyy'),15), 
('N2','S1','P1','J1',200,to_date('09-02-2011','dd-mm-yyyy'),7), 
('N3','S2','P3','J5',600,to_date('10-02-2011','dd-mm-yyyy'),15), 
('N4','S2','P3','J6',400,to_date('18-02-2011','dd-mm-yyyy'),16), 
('N5','S2','P3','J1',400,to_date('21-02-2011','dd-mm-yyyy'),15), 
('N6','S2','P3','J2',200,to_date('28-02-2011','dd-mm-yyyy'),15), 
('N7','S2','P3','J7',800,to_date('28-02-2011','dd-mm-yyyy'),16), 
('N8','S2','P3','J3',200,to_date('28-02-2011','dd-mm-yyyy'),15), 
('N9','S2','P5','J2',100,to_date('02-03-2011','dd-mm-yyyy'),9), 
('N10','S3','P4','J2',500,to_date('03-03-2011','dd-mm-yyyy'),4), 
('N11','S4','P6','J3',300,to_date('10-03-2011','dd-mm-yyyy'),13), 
('N12','S1','P1','J4',700,to_date('16-03-2011','dd-mm-yyyy'),7), 
('N13','S4','P6','J7',300,to_date('18-03-2011','dd-mm-yyyy'),13), 
('N14','S5','P2','J2',200,to_date('26-03-2011','dd-mm-yyyy'),6), 
('N15','S5','P5','J5',500,to_date('04-04-2011','dd-mm-yyyy'),9), 
('N16','S5','P5','J7',100,to_date('12-04-2011','dd-mm-yyyy'),10), 
('N17','S5','P6','J2',200,to_date('15-04-2011','dd-mm-yyyy'),14),
('N18','S5','P4','J4',800,to_date('04-05-2011','dd-mm-yyyy'),5), 
('N19','S5','P5','J4',400,to_date('10-05-2011','dd-mm-yyyy'),10), 
('N20','S5','P6','J4',500,to_date('16-05-2011','dd-mm-yyyy'),14), 
('N21','S3','P3','J1',100,to_date('19-05-2011','dd-mm-yyyy'),16), 
('N22','S3','P1','J1',300,to_date('21-05-2011','dd-mm-yyyy'),16), 
('N23','S1','P1','J1',200,to_date('22-05-2011','dd-mm-yyyy'),7), 
('N24','S1','P1','J4',700,to_date('26-05-2011','dd-mm-yyyy'),8), 
('N25','S5','P2','J4',100,to_date('31-05-2011','dd-mm-yyyy'),6), 
('N26','S2','P3','J1',400,to_date('02-06-2011','dd-mm-yyyy'),16), 
('N27','S2','P3','J2',200,to_date('06-06-2011','dd-mm-yyyy'),16), 
('N28','S2','P3','J4',500,to_date('17-06-2011','dd-mm-yyyy'),16), 
('N29','S2','P3','J5',750,to_date('25-06-2011','dd-mm-yyyy'),16), 
('N30','S5','P3','J3',200,to_date('01-07-2011','dd-mm-yyyy'),16), 
('N31','S2','P5','J2',300,to_date('06-07-2011','dd-mm-yyyy'),9), 
('N32','S3','P5','J2',500,to_date('08-07-2011','dd-mm-yyyy'),4), 
('N33','S5','P2','J2',200,to_date('19-07-2011','dd-mm-yyyy'),6), 
('N34','S3','P4','J2',200,to_date('25-07-2011','dd-mm-yyyy'),5), 
('N35','S5','P2','J4',100,to_date('26-07-2011','dd-mm-yyyy'),6), 
('N36','S5','P5','J5',600,to_date('27-07-2011','dd-mm-yyyy'),10),
('N37','S5','P1','J4',100,to_date('07-08-2011','dd-mm-yyyy'),9), 
('N38','S5','P3','J4',200,to_date('09-08-2011','dd-mm-yyyy'),14), 
('N39','S5','P4','J4',800,to_date('14-08-2011','dd-mm-yyyy'),5), 
('N40','S5','P5','J4',400,to_date('15-08-2011','dd-mm-yyyy'),11), 
('N41','S5','P6','J4',500,to_date('16-08-2011','dd-mm-yyyy'),13), 
('N42','S2','P3','J7',1000,to_date('04-10-2011','dd-mm-yyyy'),17),
('N43','S2','P5','J7',50,to_date('04-10-2011','dd-mm-yyyy'),10), 
('N44','S4','P6','J7',150,to_date('04-10-2011','dd-mm-yyyy'),12), 
('N45','S2','P3','J3',450,to_date('10-01-2012','dd-mm-yyyy'),18),
('N46','S5','P1','J4',100,to_date('20-01-2012','dd-mm-yyyy'),8), 
('N47','S4','P6','J7',700,to_date('17-02-2012','dd-mm-yyyy'),13), 
('N48','S5','P4','J2',200,to_date('05-03-2012','dd-mm-yyyy'),6), 
('N49','S2','P3','J6',700,to_date('02-04-2012','dd-mm-yyyy'),17), 
('N50','S5','P5','J7',400,to_date('04-04-2012','dd-mm-yyyy'),11), 
('N51','S5','P3','J4',200,to_date('29-04-2012','dd-mm-yyyy'),14),
('N52','S1','P2','J4',200,to_date('10-05-2012','dd-mm-yyyy'),8), 
('N53','S4','P6','J3',600,to_date('12-07-2012','dd-mm-yyyy'),13); 
 
----- ТАБЛИЦА C – Заказчики (Client) 
INSERT INTO c VALUES 
('C1','Купер','Лондон ',7), 
('C2','Росси','Рим ',3), 
('C3','Эспозито','Рим ',0), 
('C4','Перакис ','Афины',5), 
('C5','Свен ','Осло',10), 
('C6','Фишер','Берлин ',3); 
 
----- ТАБЛИЦА Q – Норма расхода деталей на одно изделие 
INSERT INTO q (N_IZD,N_DET,KOL,N_Q) VALUES 
('J4','P5',2,'Q1'), 
('J4','P2',1,'Q2'), 
('J4','P6',2,'Q3'), 
('J5','P3',4,'Q4'), 
('J5','P5',3,'Q5'), 
('J6','P3',6,'Q6'), 
('J7','P3',5,'Q7'), 
('J7','P6',3,'Q9'), 
('J7','P5',1,'Q8'), 
('J1','P1',3,'Q10'), 
('J1','P3',4,'Q11'), 
('J2','P2',5,'Q12'), 
('J2','P3',6,'Q13'), 
('J2','P4',9,'Q14'), 
('J2','P5',4,'Q15'), 
('J2','P6',2,'Q16'), 
('J3','P3',4,'Q17'), 
('J3','P6',3,'Q18'), 
('J4','P1',6,'Q19'), 
('J4','P3',1,'Q20'), 
('J4','P4',3,'Q21'); 
 
----- ТАБЛИЦА W – Выпуск изделий (Working) 
insert into W (N_PART,N_IZD,DATE_PART,KOL) 
values ('W1','J1',to_date('02-03-2011','dd-mm-yyyy'),40), 
('W2','J6',to_date('07-03-2011','dd-mm-yyyy'),35), 
('W3','J1',to_date('10-03-2011','dd-mm-yyyy'),20), 
('W4','J6',to_date('15-03-2011','dd-mm-yyyy'),30), 
('W5','J3',to_date('09-04-2011','dd-mm-yyyy'),25), 
('W6','J3',to_date('17-04-2011','dd-mm-yyyy'),20), 
('W7','J7',to_date('19-04-2011','dd-mm-yyyy'),75), 
('W8','J2',to_date('25-04-2011','dd-mm-yyyy'),20), 
('W9','J7',to_date('28-04-2011','dd-mm-yyyy'),25), 
('W10','J5',to_date('13-05-2011','dd-mm-yyyy'),40), 
('W11','J1',to_date('15-06-2011','dd-mm-yyyy'),30), 
('W12','J4',to_date('26-06-2011','dd-mm-yyyy'),40), 
('W13','J1',to_date('03-07-2011','dd-mm-yyyy'),60), 
('W14','J3',to_date('10-07-2011','dd-mm-yyyy'),40), 
('W15','J2',to_date('15-07-2011','dd-mm-yyyy'),10), 
('W16','J5',to_date('23-07-2011','dd-mm-yyyy'),75), 
('W17','J4',to_date('03-08-2011','dd-mm-yyyy'),60), 
('W18','J5',to_date('21-08-2011','dd-mm-yyyy'),50), 
('W19','J4',to_date('16-09-2011','dd-mm-yyyy'),100), 
('W20','J7',to_date('31-10-2011','dd-mm-yyyy'),50), 
('W21','J3',to_date('17-01-2012','dd-mm-yyyy'),10), 
('W22','J5',to_date('24-01-2012','dd-mm-yyyy'),130), 
('W23','J1',to_date('21-02-2012','dd-mm-yyyy'),25), 
('W24','J5',to_date('19-03-2012','dd-mm-yyyy'),40),
('W25','J6',to_date('12-04-2012','dd-mm-yyyy'),90), 
('W26','J7',to_date('27-04-2012','dd-mm-yyyy'),200), 
('W27','J2',to_date('06-05-2012','dd-mm-yyyy'),30), 
('W28','J4',to_date('18-05-2012','dd-mm-yyyy'),60), 
('W29','J3',to_date('01-08-2012','dd-mm-yyyy'),100), 
('W30','J1',to_date('20-08-2012','dd-mm-yyyy'),50), 
('W31','J6',to_date('25-08-2012','dd-mm-yyyy'),25); 
 
----- ТАБЛИЦА Е – Издержки на производство 
INSERT INTO e 
VALUES ('E1','J1',to_date('2011-01-01','YYYY-MM-DD'),80), 
('E2','J1',to_date('2011-05-01','YYYY-MM-DD'),85), 
('E3','J2',to_date('2011-05-01','YYYY-MM-DD'),220), 
('E4','J3',to_date('2011-03-01','YYYY-MM-DD'),100), 
('E5','J4',to_date('2011-06-01','YYYY-MM-DD'),130), 
('E6','J4',to_date('2011-09-01','YYYY-MM-DD'),140), 
('E7','J5',to_date('2011-05-01','YYYY-MM-DD'),85), 
('E8','J5',to_date('2011-07-01','YYYY-MM-DD'),90), 
('E9','J5',to_date('2011-08-01','YYYY-MM-DD'),95), 
('E10','J6',to_date('2011-03-01','YYYY-MM-DD'),95), 
('E11','J6',to_date('2011-07-01','YYYY-MM-DD'),105), 
('E12','J7',to_date('2011-04-01','YYYY-MM-DD'),130), 
('E13','J7',to_date('2011-08-01','YYYY-MM-DD'),135); 
 
----- ТАБЛИЦА V – Рекомендованная цена
insert into V (N_V,N_IZD,DATE_BEGIN,COST) 
values ('V1','J1',to_date('01-01-2011','dd-mm-yyyy'),280), 
('V2','J2',to_date('01-01-2011','dd-mm-yyyy'),420), 
('V3','J3',to_date('01-01-2011','dd-mm-yyyy'),300), 
('V4','J4',to_date('01-01-2011','dd-mm-yyyy'),330), 
('V5','J5',to_date('01-01-2011','dd-mm-yyyy'),290), 
('V6','J6',to_date('01-01-2011','dd-mm-yyyy'),295), 
('V7','J7',to_date('01-01-2011','dd-mm-yyyy'),330), 
('V8','J1',to_date('01-05-2011','dd-mm-yyyy'),300), 
('V9','J2',to_date('01-05-2011','dd-mm-yyyy'),440), 
('V10','J3',to_date('01-05-2011','dd-mm-yyyy'),295),
('V11','J4',to_date('01-05-2011','dd-mm-yyyy'),440), 
('V12','J5',to_date('01-05-2011','dd-mm-yyyy'),285), 
('V13','J6',to_date('01-05-2011','dd-mm-yyyy'),305), 
('V14','J7',to_date('01-05-2011','dd-mm-yyyy'),350), 
('V15','J1',to_date('01-11-2011','dd-mm-yyyy'),360), 
('V16','J2',to_date('01-11-2011','dd-mm-yyyy'),500), 
('V17','J3',to_date('01-11-2011','dd-mm-yyyy'),350), 
('V18','J4',to_date('01-11-2011','dd-mm-yyyy'),510), 
('V19','J5',to_date('01-11-2011','dd-mm-yyyy'),340), 
('V20','J6',to_date('01-11-2011','dd-mm-yyyy'),360), 
('V21','J7',to_date('01-11-2011','dd-mm-yyyy'),420); 
 
----- ТАБЛИЦА R –Заказы 
insert into R (N_REAL,N_IZD,N_CL,DATE_ORDER,DATE_PAY,DATE_SHIP, KOL, COST) 
values 	('R1','J1','C1',to_date('10-02-2011','dd-mm-yyyy'),to_date('13-02-2011','ddmm-yyyy'),to_date('03-03-2011','dd-mm-yyyy'),15,275), 
('R2','J6','С2',to_date('01-03-2011','dd-mm-yyyy'),to_date('06-03-2011','dd-mmyyyy'),to_date('13-03-2011','dd-mm-yyyy'),30,300), 
('R3','J1','C3',to_date('05-03-2011','dd-mm-yyyy'),to_date('07-03-2011','dd-mmyyyy'),to_date('10-03-2011','dd-mm-yyyy'),30,280), 
('R4','J3','C2',to_date('03-04-2011','dd-mm-yyyy'),to_date('07-04-2011','dd-mmyyyy'),to_date('09-04-2011','dd-mm-yyyy'),25,300), 
('R5','J2','C5',to_date('22-04-2011','dd-mm-yyyy'),to_date('24-04-2011','dd-mmyyyy'),to_date('26-04-2011','dd-mm-yyyy'),15,400), 
('R6','J7','C5',to_date('08-05-2011','dd-mm-yyyy'),to_date('11-05-2011','dd-mmyyyy'),to_date('13-05-2011','dd-mm-yyyy'),70,325), 
('R7','J5','С2',to_date('15-05-2011','dd-mm-yyyy'),to_date('19-05-2011','dd-mmyyyy'),to_date('22-05-2011','dd-mm-yyyy'),40,290), 
('R8','J3','C4',to_date('20-05-2011','dd-mm-yyyy'),to_date('23-05-2011','dd-mmyyyy'),to_date('24-05-2011','dd-mm-yyyy'),15,290), 
('R9','J1','C6',to_date('09-06-2011','dd-mm-yyyy'),to_date('15-06-2011','dd-mmyyyy'),to_date('20-06-2011','dd-mm-yyyy'),45,285), 
('R10','J6','С2',to_date('15-06-2011','dd-mm-yyyy'),to_date('16-06-2011','dd-mmyyyy'),to_date('16-06-2011','dd-mm-yyyy'),20,300), 
('R11','J4','C3',to_date('19-06-2011','dd-mm-yyyy'),to_date('27-06-2011','dd-mmyyyy'),to_date('27-06-2011','dd-mm-yyyy'),30,445),
('R12','J1','C5',to_date('01-07-2011','dd-mm-yyyy'),to_date('03-07-2011','dd-mmyyyy'),to_date('05-07-2011','dd-mm-yyyy'),50,277), 
('R13','J5','С1',to_date('01-09-2011','dd-mm-yyyy'),to_date('04-09-2011','dd-mmyyyy'),to_date('04-09-2011','dd-mm-yyyy'),100,285), 
('R14','J4','C4',to_date('20-09-2011','dd-mm-yyyy'),to_date('21-09-2011','dd-mmyyyy'),to_date('21-09-2011','dd-mm-yyyy'),120,420), 
('R15','J3','C2',to_date('20-10-2011','dd-mm-yyyy'),to_date('23-10-2011','dd-mmyyyy'),to_date('24-10-2011','dd-mm-yyyy'),25,295), 
('R16','J7','C6',to_date('01-11-2011','dd-mm-yyyy'),to_date('03-11-2011','dd-mmyyyy'),to_date('06-11-2011','dd-mm-yyyy'),80,415), 
('R17','J1','C1',to_date('11-01-2012','dd-mm-yyyy'),to_date('13-01-2012','dd-mmyyyy'),to_date('15-01-2012','dd-mm-yyyy'),10,280), 
('R18','J6','С2',to_date('15-04-2012','dd-mm-yyyy'),to_date('22-04-2012','dd-mmyyyy'),to_date('23-04-2012','dd-mm-yyyy'),60,350), 
('R19','J4','C6',to_date('13-05-2012','dd-mm-yyyy'),to_date('15-05-2012','dd-mmyyyy'),to_date('20-05-2012','dd-mm-yyyy'),50,500), 
('R20','J2','C6',to_date('01-06-2012','dd-mm-yyyy'),to_date('05-06-2012','dd-mmyyyy'),null,30,490), 
('R21','J7','C2',to_date('20-06-2012','dd-mm-yyyy'),to_date('21-06-2012','dd-mmyyyy'),to_date('25-06-2012','dd-mm-yyyy'),150,415), 
('R22','J3','C4',to_date('10-08-2012','dd-mm-yyyy'),to_date('12-08-2012','dd-mmyyyy'),to_date('13-08-2012','dd-mm-yyyy'),60,330), 
('R23','J5','C3',to_date('15-08-2012','dd-mm-yyyy'),to_date('19-08-2012','dd-mmyyyy'),to_date('21-08-2012','dd-mm-yyyy'),120,350), 
('R24','J4','C3',to_date('20-08-2012','dd-mm-yyyy'),null,null,70,520), 
('R25','J3','C2',to_date('20-08-2012','dd-mm-yyyy'),to_date('22-08-2012','dd-mmyyyy'),to_date('26-08-2012','dd-mm-yyyy'),45,340), 
('R26','J1','C3',to_date('25-08-2012','dd-mm-yyyy'),to_date('27-08-2012','dd-mmyyyy'),null,50,290), 
('R27','J6','С2',to_date('15-09-2012','dd-mm-yyyy'),to_date('17-09-2012','dd-mmyyyy'),null,70,350); 
