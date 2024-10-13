create table Lophoc(
Malh char(5) primary key,
Tenlh nvarchar(30),
Cahoc nvarchar(20),
Siso int
)
insert into Lophoc values
(N'01TH1',N'Tin học 1',N'Sáng',80),
(N'01KT1',N'Kế toán 1',N'Chiều',75);

create  table test(
ten char(3)
)

create table Hocsinh (
Mahs char(4) primary key,
Ho nvarchar(40), 
Ten nvarchar(30),
Gioitinh nchar(10),
Ngaysinh datetime,
Noisinh nvarchar(40),
Malh char(5)
)
insert into Hocsinh values
(N'TH01',N'Nguyễn Thị',N'Hải',N'Nữ','1985-02-23',N'TP.HCM',N'01TH1'),
(N'TH02',N'Trần Văn',N'Chính',N'Nam','1986-12-24',N'TP.HCM',N'01TH1'),
(N'TH03',N'Lê Bạch',N'Yến',N'Nữ','1990-02-21',N'Hà Nội',N'01TH1'),
(N'KT01',N'Nguyễn Văn',N'Chinh',N'Nam','1988-12-31',N'Long An',N'01KT1'),
(N'KT02',N'Trần Thanh',N'Mai',N'Nữ','1987-08-12',N'Bến Tre',N'01KT1'),
(N'KT03',N'Trần Thu',N'Thủy',N'Nữ','1989-01-01',N'An Giang',N'01KT1');

create table Monhoc(
Mamh int primary key,
Tenmh nvarchar(40),
Sotiet int
) 
insert into Monhoc values
(01,N'Cơ sở dữ liệu',45),
(02,N'Lập trình căn bản',45),
(03,N'Kiểm toán',45),
(04,N'Kinh tế vi mô',60);

create table Bangdiem(
Mahs char(4),
Mamh int,
Diem float
)
insert into Bangdiem values
(N'TH01',01,2.0),
(N'TH01',02,7.5),
(N'TH02',01,5.0),
(N'TH02',02,9.5),
(N'TH03',01,5.0),
(N'TH03',02,3.0),
(N'KT01',03,4.0),
(N'KT01',04,8.0),
(N'KT02',03,7.5),
(N'KT02',04,3.0),
(N'KT03',03,6.0),
(N'KT03',04,9.5);


select *from Lophoc
select *from Monhoc
select *from Bangdiem
select *from Hocsinh

--Câu 1--
select * from Hocsinh

--Câu 2--
select Hocsinh.Mahs, Ho,Ten,Gioitinh,Ngaysinh,Noisinh, Lophoc.Tenlh
from Hocsinh
Join Lophoc on Hocsinh.Malh=Lophoc.Malh
where Hocsinh.Gioitinh = N'Nữ' and  Lophoc.Tenlh = N'Kế toán 1';

--Câu 3--
select Hocsinh.Mahs, Ho,Ten,Gioitinh,Ngaysinh,Noisinh, Lophoc.Cahoc
from  Hocsinh
Join Lophoc on Hocsinh.Malh=Lophoc.Malh
where Lophoc.Cahoc = N'Sáng';

--Câu 4--
select *
from Hocsinh
where Month(Ngaysinh) in(1,12);

--Câu 5--
select* 
from Hocsinh
where Noisinh not in ('Hà Nội', 'TP.HCM'); 

--Câu 6--
select Mahs,Ho,Ten,datediff(year, Ngaysinh ,getdate()) as Tuoi
from Hocsinh
where datediff(year, Ngaysinh,getdate()) < 22;

--Câu 7--
select Lophoc.Malh, Tenlh, Count(Hocsinh.Mahs) as Soluongsinhvien
from Hocsinh
join Lophoc on Hocsinh.Malh = Lophoc.Malh
Group by Lophoc.Malh, Lophoc.Tenlh;

--Câu 8--
select Lophoc.Malh, Tenlh,
	count(case when Hocsinh.Gioitinh = N'Nam' then 1 end) as Soluongnam,
	count(case when Hocsinh.Gioitinh = N'Nữ' then 1 end) as Soluongnu
	from Hocsinh
	Join Lophoc on Hocsinh.Malh = Lophoc.Malh
	group by Lophoc.Malh, Lophoc.Tenlh;

--Câu 9--
SELECT Mahs, Ho, Ten
FROM Hocsinh
WHERE Ho LIKE N'% Văn';

--Câu 10--
select Hocsinh.Mahs, Concat(Hocsinh.Ho, ' ',Hocsinh.Ten) as Hoten
From Hocsinh
Join Bangdiem on Hocsinh.Mahs = Bangdiem.Mahs
Join Monhoc on Bangdiem.Mamh = Monhoc.Mamh
where Tenmh like N'Cơ sở dữ liệu';

--Câu 11--
SELECT Hocsinh.Mahs, CONCAT(Hocsinh.Ho, ' ', Hocsinh.Ten) AS Hoten
FROM Hocsinh
WHERE Hocsinh.Mahs NOT IN (
    SELECT Hocsinh.Mahs
    FROM Hocsinh
    JOIN Bangdiem ON Hocsinh.Mahs = Bangdiem.Mahs
    JOIN Monhoc ON Bangdiem.Mamh = Monhoc.Mamh
    WHERE Monhoc.Tenmh = N'Cơ sở dữ liệu'
);

--Câu 12--
SELECT H1.Mahs, CONCAT(H1.Ho, ' ', H1.Ten) AS Hoten
FROM Hocsinh H1
JOIN (
    SELECT day(Ngaysinh) as Ngay, month(ngaysinh) as Thang
    FROM Hocsinh
    GROUP BY DAY(Ngaysinh), MONTH(Ngaysinh)
    HAVING COUNT(*) > 1
) H2 ON DAY(H1.Ngaysinh) = H2.Ngay
    AND MONTH(H1.Ngaysinh) = H2.Thang;

--Câu 13--
select Hocsinh.Mahs,concat(Hocsinh.Ho, ' ',Hocsinh.Ten) as Hoten,  Bangdiem.Diem
from Hocsinh
join Bangdiem on Hocsinh.Mahs = Bangdiem.Mahs
where Bangdiem.Diem < 5;

--Câu 14--
select top 3 Hocsinh.Mahs,concat(Hocsinh.Ho, ' ',Hocsinh.Ten) as Hoten, Bangdiem.Diem
from Hocsinh
join Bangdiem on Hocsinh.Mahs = Bangdiem.Mahs
order by Bangdiem.Diem DESC;

--Câu 15--
select Lophoc.Malh, Tenlh, sum(Monhoc.Sotiet) as Tongsotiet
from Lophoc
Join Hocsinh on Lophoc.Malh = Hocsinh.Malh
Join Bangdiem on Hocsinh.Mahs = Bangdiem.Mahs
Join Monhoc on Bangdiem.Mamh = Monhoc.Mamh
where Lophoc.Tenlh like N'Tin học 1'
group by Lophoc.Malh, Lophoc.Tenlh;

--Câu 16--
select Hocsinh.Mahs, concat(Hocsinh.Ho, ' ', Hocsinh.Ten) as Hoten, Bangdiem.Diem,
case 
	when 
		Bangdiem.Diem < 5 then N'Rớt'
	else N'Đậu' 
end as  Danhgia
from Hocsinh
join Bangdiem on Hocsinh.Mahs = Bangdiem.Mahs

--Câu 17--
select Max(Bangdiem.Diem) as Diemcaonhat
from Bangdiem
join Monhoc on Bangdiem.Mamh = Monhoc.Mamh
where Monhoc.Tenmh like N'Cơ sở dữ liệu';
select * from Hocsinh

--Câu 18--
SELECT * INTO HocsinhNam
FROM Hocsinh
WHERE Gioitinh = N'Nam';

--Câu 19--
update Bangdiem
set Diem = Diem + 1.0
from Bangdiem
join Monhoc on Bangdiem.Mamh = Monhoc.Mamh
where Monhoc.Tenmh like N'Cơ sở dữ liệu'
and Bangdiem.Diem < 5

select * from Monhoc

--Câu 20--
insert into Monhoc(Mamh,Tenmh,Sotiet)
values(05,N'Lập trình web',90);

--Câu 21-- 
delete from Monhoc
where Tenmh like N'Lập trình web';

--Câu 22-- (chưa sửa) 
select Hocsinh.Mahs, concat(Hocsinh.Ho, ' ', Hocsinh.Ten) as Hoten, Bangdiem.Diem 
from Hocsinh
join Bangdiem on Hocsinh.Mahs = Bangdiem.Mahs
join Monhoc on Bangdiem.Mamh  = Monhoc.Mamh
where Monhoc.Tenmh like N'Cơ sở dữ liệu' or  
Monhoc.Tenmh like N'Lập trình căn bản' or  
Monhoc.Tenmh like N'Kiểm toán'or
Monhoc.Tenmh like N'Kinh tế vi mô'



--DROP TABLE IF EXISTS [dbo].[Hocsinh];--