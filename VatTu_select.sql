create database Vattu

create table VATTU (
	MaVTu char(4) primary key,
	TenVT nvarchar(100),
	DVTinh nvarchar(10),
	PhanTram real,
)
INSERT INTO VATTU (MaVTu, TenVT, DVTinh, PhanTram) VALUES 
('C001',N'Cát',N'Khối', 10),
('D001',N'Đá',N'Xe', 10),
('G001',N'Gạch bông 1.5',N'Viên', 10),
('S001',N'Sắt',N'Kg', 10),
('SN01',N'Sơn nước',N'Thùng', 10),
('T001',N'Thép phi 18',N'Tấm', 10),
('T002',N'Tole 0.3 ly',N'Tấm', 10);

create table PXUAT (
	SoPX char(4) primary key,
	NgayXuat datetime,
	TenKH nvarchar(50),
)
INSERT INTO PXUAT (SoPX, NgayXuat, TenKH) VALUES 
('X001',09/01/2016,N'Nguyễn Văn Sanh'),
('X002',28/01/2016,N'Phạm Thoại Hoa');

create table TONKHO (
	NamThang char(6) primary key,
	MaVTu char(4),
	SLDau int,
	TongSLN int,
	TongSLX int,
	SLCuoi int
)
INSERT INTO TONKHO (NamThang, MaVTu, SLDau, TongSLN, TongSLX, SLCuoi) VALUES 
(201601,'G001',0,1300,500,800),
(201701,'S001',0,800,300,500),
(201801,'SN01',0,60,50,10),
(201901,'T001',0,1000,400, 600);

create table CTPXUAT (
	SoPX char(4),
	MaVTu char(4),
	SLXuat int,
	DGXuat int,
	primary key (SoPX, MaVTu),
)
INSERT INTO CTPXUAT (SoPX, MaVTu, SLXuat, DGXuat) VALUES 
('X001','G001',300,600),
('X001','SN01',50,132000),
('X002','G001',200,900),
('X002','S001',300,10500),
('X002','T001',400,17500);




--Phần 5.1--
create proc list_tonkho
    @NAMTHANG char(6)
as
    select *
    from TONKHO
    where NamThang = @NAMTHANG;

exec list_tonkho @NAMTHANG = '201801'


select * from PXUAT
--Phần 5.2--
create proc list_phieuxuat
    @m char(10)
as
    select *
    from PXUAT
    where SoPX = @m;
    
exec list_phieuxuat @m = 'X002';

--Phần 6.1--
create table CTPXUAT (
	SoPX char(4),
	MaVTu char(4),
	SLXuat int,
	DGXuat int,
	primary key (SoPX, MaVTu),
)
select * from CTPXUAT
create trigger Tg_CTPXuat_Them on CTPXuat
instead of insert
as
  declare
        @Sopx char(4), 
        @Mavtu char, 
        @Slxuat int,
        @Dgxuat int;

    select 
        @Sopx = SoPX, 
        @Mavtu = MaVTu, 
        @Slxuat = SLXuat,
        @Dgxuat = DGXuat;
    from inserted;
    
    if exists (select * from CTPXUAT where SoPX = @Sopx)
    begin
        print N'Trùng số PX';
        return
    end
    insert into CTPXUAT values ('X003','T002',100,16200);
--DROP TABLE IF EXISTS [dbo].[VATTU];--
--DROP TABLE VATTU;--
