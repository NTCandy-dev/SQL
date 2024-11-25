create database Quanlysach
CREATE TABLE LOAISACH (
    MALOAI CHAR(2) PRIMARY KEY,
    TENLOAI NVARCHAR(20) NOT NULL
);


CREATE TABLE TACGIA (
    MATG CHAR(3) PRIMARY KEY,
    HOTEN NVARCHAR(40) NOT NULL,
    NGAYSINH SMALLDATETIME,
    GIOITINH NVARCHAR(10),
    DIACHI NVARCHAR(50),
    DIENTHOAI VARCHAR(20)
);


CREATE TABLE NHAXB (
    MANXB CHAR(3) PRIMARY KEY,
    TENNXB NVARCHAR(40) NOT NULL,
    DIACHI NVARCHAR(50),
    DIENTHOAI VARCHAR(20)
);



INSERT INTO LOAISACH (MALOAI, TENLOAI) VALUES 
('AV',N'Sách Anh Văn'),    
('TH',N'Sách Tin Học'),
('KT',N'Sách Kỹ Thuật'),
('TN',N'Sách Thiếu Nhi'),
('TK',N'Sách Tham Khảo');
INSERT INTO TACGIA(MATG, HOTEN, NGAYSINH, GIOITINH, DIACHI,DIENTHOAI) VALUES 
('T01',N'Lê Văn Bảo','08-08-1977',N'Nam',N'332 Nguyễn Đình Chiểu Q3 TTPHCM',0912134211),
('T02',N'Lý Thị Nga','10-15-1983',N'Nữ',N'1254 Sư Vạn Hạnh Q10 TTPHCM',012543887423),
('T03',N'Lý Minh Tài','12-09-1980',N'Nam',N'543 Biên Hòa Đồng Nai',0931218721),
('T04',N'Nguyễn Lâm','03-26-1975',N'Nam',N'731 Trần Hưng Đạo Q1 TTPHCM',0932348732),
('T05',N'Nguyễn Thị Bích','05-04-1982',N'Nữ',N'637 Nguyễn Văn Cừ Q5 TTPHCM',012157886312);
INSERT INTO NHAXB(MANXB, TENNXB, DIACHI, DIENTHOAI) VALUES 
('N01',N'NXB Giáo Dục',N'55 Lê Thánh Tôn Q1 TPHCM',0822516446),
('N02',N'NXB Trẻ',N'61 Huỳnh Mẫn Đạt Q.Phú Nhuận TPHCM',04998822244),
('N03',N'NXB TPHCM',N'104 Điện Biên Phủ Q1 TPHCM',08345612234);

CREATE TABLE SACH (
    MASACH CHAR(5) PRIMARY KEY,
    TENSACH NVARCHAR(100) NOT NULL,
    MATG CHAR(3),
	SOLUONG INT DEFAULT 3 CHECK (SOLUONG > 0),
	DONGIA float DEFAULT 70000 CHECK (DONGIA > 0),
    MANXB CHAR(3),
    NAMXB INT DEFAULT YEAR(GETDATE()) CHECK (NAMXB >= 2000),
    MALOAI CHAR(2),
    SOTRANG int,
    FOREIGN KEY (MALOAI) REFERENCES LOAISACH(MALOAI),
    FOREIGN KEY (MATG) REFERENCES TACGIA(MATG),
    FOREIGN KEY (MANXB) REFERENCES NHAXB(MANXB)
)
INSERT INTO SACH(MASACH, TENSACH, MATG, SOLUONG,DONGIA, MANXB,NAMXB,MALOAI,SOTRANG) VALUES
('AV02',N'Văn Phạm Tiếng Anh','T03',8,39000,'N02',2003,'AV',100),
('TH01',N'Tin Học Trình Độ A','T04',4,45000,'N03',2001,'TH',88),
('TH02',N'Tin Học Trình Độ B','T02',5,85000,'N03',2005,'TH',69),
('TK01',N'Tiếng Anh Nâng Cao','T01',7,69000,'N01',2006,'TK',46);

--phan 5.1--
create proc Chinhsua
@MANXB char(3),
@TenNXB nvarchar(40),
@DiaChi nvarchar(50),
@DienThoai nvarchar(20)
as 
	update NHXB 
	set 
		tenNXB = @TenNXB,
		Diachi = @DiaChi,
		Dienthoai = @DienThoai
	where 
		MaNXB = @MANXB 
		exec Chinhsua 'N02',N'Hotec',N'215 Nguyễn Văn Luông', N'85534576'
		go
		
--phan 5.2--
create proc Lietke
(@ID char(3))
as 
select NHAXB.MANXB, TENNXB, DIACHI, TENNXB, DIACHI, DIENTHOAI, TENSACH, SOLUONG, NAMXB, SOTRANG
from NHAXB, SACH
where NHAXB.MANXB = SACH.MANXB
AND NHAXB.MANXB = @ID
EXEC Lietke 'N01' 

select * from NHAXB
				
--phan 5.3--
create proc Lietkesach
(@idloai char(3))
as 
select * 
from SACH
where maloai = @idloai 
exec Lietkesach 'TH'

--Phan 6.1--
select * from TACGIA

create trigger check_matg on TACGIA
instead of insert 
as declare 
	@Matg char(3), 
	@Hoten nvarchar(40), 
	@Ngaysinh smalldatetime, 
	@Gioitinh nvarchar(10), 
	@Diachi nvarchar(50), 
	@Dienthoai nvarchar(20);
select 
	@Matg=MATG,
	@Hoten=HOTEN,
	@Ngaysinh=NGAYSINH,
	@Gioitinh=GIOITINH,
	@Diachi=DIACHI,
	@Dienthoai=DIENTHOAI
from inserted

if exists (select * from TACGIA where MATG = @Matg)
begin 
	print N'Trùng mã tác giả'
	return 
end

insert into TACGIA values('T06', N'Nguyễn Đặng Ngọc Huy','22-8-2005',N'Nam', N'447/Trần Liêm Sỉ Huyện cái tôi TTPHCM',09022512542)

--Phan 6.2--
create trigger check_manxb on NHAXB
instead of insert 
as declare @MANXB char(3), @TENNXB nvarchar(40), @DIACHI nvarchar(50), @DIENTHOAI varchar(20)
select 
	@MANXB=MANXB, 
	@TENNXB=TENNXB, 
	@DIACHI=DIACHI, 
	@DIENTHOAI=DIENTHOAI
from inserted 

if exists (select * from NHAXB where MANXB=@MANXB)
begin 
	print N'Trùng mã NXB'
	return
end

insert into NHAXB values('N01', N'NXB Khoa hoc', N'10 Nguyen Thi Minh Khai TPHCM', '0823461234')
--Phan 6.3--

create trigger check_masach on LOAISACH
instead of insert 
as declare @MALOAI char(2), @TENLOAI nvarchar(20)
select 
	@MALOAI = MALOAI,
	@TENLOAI = TENLOAI
from inserted

if exists (select * from LOAISACH where MALOAI = @MALOAI)
begin 
	print N'Trùng mã loại'
	return 
end

insert into LOAISACH values('NV',N'Sách Ngữ Văn')