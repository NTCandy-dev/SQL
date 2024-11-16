create database VatTu

create table Vattu(
Mavtu char(4) primary key,
Tenvtu nvarchar(100),
Dvtinh nvarchar(10),
Phantram real 
);
insert into Vattu (Mavtu, Tenvtu, Dvtinh, Phantram) values
('C001',N'Cát',N'Khối', 10),
('D001',N'Đá',N'Xe', 10),
('G001',N'Gạch bông 1.5',N'Viên', 10),
('S001',N'Sắt',N'Kg', 10),
('SN01',N'Sơn nước',N'Thùng', 10),
('T001',N'Thép phi 18',N'Tấm', 10),
('T002',N'Tole 0.3 ly',N'Tấm', 10);

create table Pxuat(
Sopx char(4) primary key,
Ngayxuat datetime,
Tenkh nvarchar(50)
);
insert into Pxuat (Sopx, Ngayxuat, Tenkh) values
('X001',CONVERT(datetime,'09/01/2016',103),N'Nguyễn Văn Sanh'),
('X002',CONVERT(datetime,'28/01/2016',103),N'Phạm Thoại Hoa');

create table Tonkho(
Namthang char(6) primary key,
Mavtu char(4),
Sldau int,
Tongsln int,
Tongslx int,
Slcuoi int
foreign key (Mavtu) references Vattu (Mavtu)
);
insert into Tonkho (Namthang, Mavtu, Sldau, Tongsln, Tongslx, Slcuoi) values
(201601,'G001',0,1300,500,800),
(201701,'S001',0,800,300,500),
(201801,'SN01',0,60,50,10),
(201901,'T001',0,1000,400, 600);

create table Cptxuat(
Sopx char(4),
Mavtu char(4),
Slxuat int,
Dgxuat int,
primary key (Sopx, Mavtu),
);
insert into Cptxuat (Sopx, Mavtu, Slxuat, Dgxuat) values
('X001','G001',300,600),
('X001','SN01',50,132000),
('X002','G001',200,900),
('X002','S001',300,10500),
('X002','T001',400,17500);

-- Phan 5.1 --
create proc lietke
@NAMTHANG char(6)
as
	select * from Tonkho
	where Tonkho.Namthang = @NAMTHANG

exec lietke @NAMTHANG = 201701

-- Phan 5.2 --
create proc lietkesopx
@m char(4)
as 
	select * from Pxuat
	where Pxuat.Sopx = @m

exec lietkesopx @m = 'X003'

-- Phan 6.1 --
create trigger Tg_CTPXuat_Them on Cptxuat
instead of insert
as 
	begin
		declare
			@SOPX char(4),
			@MAVTU char(4),
			@SLXUAT int,
			@DGXUAT int
		select 
			@SOPX = Sopx,
			@MAVTU = Mavtu,
			@SLXUAT = Slxuat,
			@DGXUAT = Dgxuat
		from inserted
	if exists (select 1 from inserted, Cptxuat where @SOPX = Cptxuat.Sopx or @MAVTU = Cptxuat.Mavtu)
		begin
			print N'Trùng khóa chính'
			return;
		end
	else
		print N'Thỏa điều kiện khóa chính'
	insert into Cptxuat (Sopx, Mavtu, Slxuat, Dgxuat) values (@SOPX, @MAVTU, @SLXUAT, @DGXUAT)
	end

insert into Cptxuat values ('X003','R001',400,17500);

-- Phan 6.2 --
create trigger them_dg_va_slxuat on Cptxuat
after insert 
as
	begin
		declare
			@SOPX char(4),
			@MAVTU char(4),
			@SLXUAT int,
			@DGXUAT int
		select 
			@SOPX = Sopx,
			@MAVTU = Mavtu,
			@SLXUAT = Slxuat,
			@DGXUAT = Dgxuat
		from inserted
	if exists (select 1 from inserted where @SLXUAT < 0 or @DGXUAT < 0)
		begin 
			print N'Số lượng xuất và đơn giá xuất không thể nhỏ hơn 0'
			delete from Cptxuat where Sopx in (select @SOPX from inserted where @SLXUAT < 0 or @DGXUAT < 0)
		end
	else
		print N'Thỏa điều kiện số lượng xuất và đơn giá xuất';
	end

INSERT INTO Cptxuat VALUES ('X004', 'R002', 0, 17500);
select * from Cptxuat

