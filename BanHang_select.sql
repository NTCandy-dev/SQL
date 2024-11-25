create database Banhang
CREATE TABLE NHACC (
    MaNhaCC CHAR(4) PRIMARY KEY,
    TenNhaCC NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    DienThoai VARCHAR(20)
);



CREATE TABLE DONDH (
    SoDH CHAR(4) PRIMARY KEY,
    NgayDH DATETIME NOT NULL,
    MaNhaCC CHAR(4),
    FOREIGN KEY (MaNhaCC) REFERENCES NHACC(MaNhaCC)
);


CREATE TABLE PNHAP (
    SoPN CHAR(4) PRIMARY KEY,
    NgayNhap DATETIME DEFAULT GETDATE() CHECK (NgayNhap < GETDATE()),
    SoDH CHAR(4),
    FOREIGN KEY (SoDH) REFERENCES DONDH(SoDH)
);


CREATE TABLE CTDONDH (
    SoDH CHAR(4),
    MaVTu CHAR(4),
    SlDat INT DEFAULT 100 CHECK (SlDat > 0),
    PRIMARY KEY (SoDH, MaVTu),
    FOREIGN KEY (SoDH) REFERENCES DONDH(SoDH)
);

INSERT INTO NHACC(MaNhaCC, TenNhaCC, DiaChi, DienThoai) VALUES ('A001',N' Hồng Phương',N' 323 Trần Hưng Đạo Quận 5', 0909628199)
INSERT INTO NHACC(MaNhaCC, TenNhaCC, DiaChi, DienThoai) VALUES ('A002',N' Minh Trung',N' 72 Lý Chính Thắng Quận 3 ',0838551344)
INSERT INTO NHACC(MaNhaCC, TenNhaCC, DiaChi, DienThoai) VALUES ('A003',N' Nhật Thắng',N' 16 Hưng Phú, Quận 8', 0838558766)
INSERT INTO NHACC(MaNhaCC, TenNhaCC, DiaChi, DienThoai) VALUES ('A012',N' Nguyệt Quế',N' 27 Hoàng Diệu, Quận 4', 0839800123)
INSERT INTO NHACC(MaNhaCC, TenNhaCC, DiaChi, DienThoai) VALUES ('B001',N' Thành Trung',N' 135 Nguyễn Văn Luông, Quận 6', 0838956477)
INSERT INTO NHACC(MaNhaCC, TenNhaCC, DiaChi, DienThoai) VALUES ('C001',N' Minh Thạch',N' 86 Lê Lợi, Quận 1', 0909628222)


INSERT INTO DONDH(SoDH, NgayDH, MaNhaCC) VALUES ('D001',05-01-2016,'A003')
INSERT INTO DONDH(SoDH, NgayDH, MaNhaCC) VALUES ('D002',17-01-2016,'A012')
INSERT INTO DONDH(SoDH, NgayDH, MaNhaCC) VALUES ('D003',20-01-2016,'C001')

INSERT INTO CTDONDH(SoDH, MaVTu, SlDat) VALUES ('D001','G001',1300)
INSERT INTO CTDONDH(SoDH, MaVTu, SlDat) VALUES ('D001','SN01',60)
INSERT INTO CTDONDH(SoDH, MaVTu, SlDat) VALUES ('D002','S001',1000)
INSERT INTO CTDONDH(SoDH, MaVTu, SlDat) VALUES ('D002','T001',1000)
INSERT INTO CTDONDH(SoDH, MaVTu, SlDat) VALUES ('D003','T003',100)

INSERT INTO PNHAP(SoPN, NgayNhap, SoDH) VALUES ('N001',07-01-2016,'D001')
INSERT INTO PNHAP(SoPN, NgayNhap, SoDH) VALUES ('N002',20-01-2016,'D002')
INSERT INTO PNHAP(SoPN, NgayNhap, SoDH) VALUES ('N003',22-01-2016,'D001')


select * from DONDH

--Phần 5.1--
create proc spud_DONDH_Them
    @SODH char(4),
    @NGAYDH datetime,
    @MANHACC char(4)
AS
    insert into DONDH (SoDH, NgayDH, MaNhaCC)
    values (@SODH, @NGAYDH, @MANHACC);
    
    exec spud_DONDH_Them @SODH = 'D004', @NGAYDH = '15-1-2016', @MANHACC = 'C011';


select * from CTDONDH 

--Phần 5.2--
create proc spud_CT_DONDH_Them
    @SODH char(4),
    @MAVTU char(4),
    @SLDAT int 
AS
    insert into CTDONDH (SoDH, MaVTu, SlDat)
    values (@SODH, @MAVTU, @SLDAT);
    
    exec spud_CT_DONDH_Them @SODH = 'D003', @MAVTU = 'J001', @SLDAT = 80;

--Phần 6.1--
select * from NHACC
create trigger check_manhacc on NHACC
instead of insert
as
  declare
        @ManhaCC char(4), 
        @TennhaCC nvarchar(100), 
        @Diachi nvarchar(200),
        @Dienthoai varchar(20);

    select 
        @ManhaCC = MaNhaCC,
        @TennhaCC = TenNhaCC,
        @Diachi= DiaChi,
        @Dienthoai = DienThoai
    from inserted;

    if exists (select * from NHACC where MaNhaCC = @ManhaCC)
    begin
        print N'Trùng mã nhà cung cấp';
        return
    end
    insert into NHACC values ('D002',N'Nhật Huy',N'Bến Tre, huyện Bình Đại',0902136189);
    
-- Phần 6.2--
create trigger check_sopn on PNHAP
instead of insert
as
  declare
        @Sopn char(4), 
        @Ngaynhap datetime, 
        @Sodh char(4);

    select 
        @Sopn = SoPN,
        @Ngaynhap = NgayNhap,
		@Sodh= SoDH
    from inserted;

    if exists (select * from PNHAP where SoPN = @Sopn)
    begin
        print N'Trùng số PN';
        return
    end
    insert into PNHAP values ('N004',12-7-2008,'D002');