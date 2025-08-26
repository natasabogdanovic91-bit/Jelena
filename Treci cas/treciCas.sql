--INSERT INTO student (ime, prezime, godina_upisa) VALUES ('Pera', 'Peric', 2020); --dodavanje vrednosti u tabelu
--INSERT INTO student (ime, prezime, godina_upisa) VALUES ('Mika', 'Mikic', 2021);
--INSERT INTO student (ime, prezime, godina_upisa) VALUES ('Zika', 'Zikic', 2022);
--INSERT INTO student (ime, prezime, godina_upisa) VALUES ('Ana', 'Anic', 2020);
--INSERT INTO student (ime, prezime, godina_upisa) VALUES ('Ana', 'Mikic', 2021);

select * from student; --prikaz cele tabele

select ime, godina_upisa from student; --prikaz odredjenih kolona

select count(*) from student; --prebrojavanje koliko ima redova(unosa) u tabeli

select * from student where godina_upisa=2021; --prikaz redova gde je godina_upisa 2021

select * from student where ime = 'Ana' and godina_upisa=2021;

select * from student where ime = 'Ana' or godina_upisa=2021;

select id, ime from student where ime = 'Ana' and godina_upisa=2021;

select count(*) from student;

delete from student where id > 10;

select * from student;

update student set ime = 'Nikola' where id = 8;

update student set godina_upisa = 2018 where id = 1;
update student set godina_upisa = 2019 where id = 2;
update student set godina_upisa = 2022 where id = 6;

select * from ispit;

insert into ispit (predmet, profesor, datum) values 
('uvod u programiranje', 'Marko Markovic', '10-06-2025'), 
('matematika', 'Mila Milic', '15-06-2025'),
('fizika', 'Milica Milica', '13-06-2025'),
('matematika 2', 'Mila Milic', '10-06-2025');


create table polaganje (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	student_id INTEGER,
	ispit_id INTEGER,
	ocena INTEGER,
	FOREIGN KEY (student_id) REFERENCES student(id),
	FOREIGN KEY (ispit_id) REFERENCES ispit(id)
);

select * from polaganje;

INSERT into polaganje (student_id, ispit_id, ocena)
VALUES (1, 1, 9), (1, 3, 10), (2, 2, 9), (5, 4, 8), (2, 3, 8);

select s.ime, s.prezime, i.predmet, i.profesor, p.ocena
from polaganje p
join student s on p.student_id = s.id
join ispit i on p.ispit_id = i.id;


select i.predmet, i.profesor, s.ime, s.prezime, count(*) as broj_polaganja
from polaganje p
join ispit i on p.ispit_id = i.id
join student s on p.student_id = s.id
GROUP by i.profesor
order by broj_polaganja DESC;

select i.predmet, s.ime, avg(p.ocena) as prosecna_ocena
from polaganje p
join ispit i on p.ispit_id = i.id
join student s on p.student_id = s.id
group by s.ime;

select * from student where ime like 'M%l%';

select * from student where godina_upisa between 2022 and 2053;
select * from student where godina_upisa >= 2022 and godina_upisa <=2053;

select * from student where ime in ('Pera', 'Milica');
select * from student where godina_upisa in (2020, 2022);

select * from student where id < 8 order by prezime, ime;

select DISTINCT godina_upisa from student where ime like 'M%' order by godina_upisa desc;

--studenti koji imaju prosecnu ocenu vecu od 8
select s.ime, s.prezime, avg(p.ocena) as prosecna_ocena
from student s
join polaganje p on s.id = p.student_id
GROUP by s.id
HAVING avg(p.ocena) >= 8;

--studenti koji su polagali neki ispit
select s.ime, s.prezime, i.predmet, i.profesor
from student s
join polaganje p on p.student_id = s.id
join ispit i on i.id = p.ispit_id
where predmet = 'matematika 2';

select ispit_id
from polaganje
where student_id in (select id from student where ime='Zika' and prezime='Zikic');

--ispiti koje nije polagao Zika Zikic
select predmet, profesor
from ispit
where id not in (select ispit_id
from polaganje
where student_id in (select id from student where ime='Zika' and prezime='Zikic'));

