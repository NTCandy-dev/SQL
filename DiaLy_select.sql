CREATE DATABASE Diali
CREATE TABLE TINH (
    MaTinh CHAR(2) PRIMARY KEY,
    TenTinh NVARCHAR(30) NOT NULL,
    DienTich INT CHECK (DienTich > 0),
    DanSo INT CHECK (DanSo > 0),
    ThiXa NVARCHAR(30) DEFAULT 'Chờ cập nhật',
);

-- Tạo bảng NUOC
CREATE TABLE NUOC (
    MaNuoc CHAR(3) PRIMARY KEY,
    TenNuoc NVARCHAR(30) NOT NULL,
    ThuDo NVARCHAR(30)
);

-- Tạo bảng BIENGIOI
CREATE TABLE BIENGIOI (
    MaTinh CHAR(2),
    MaNuoc CHAR(3),
    PRIMARY KEY (MaTinh, MaNuoc),
    FOREIGN KEY (MaTinh) REFERENCES TINH(MaTinh),
    FOREIGN KEY (MaNuoc) REFERENCES NUOC(MaNuoc)
);
CREATE TABLE LANGGIENG (
    MaTinh CHAR(2),
    LG CHAR(2),
    PRIMARY KEY (MaTinh, LG),
    FOREIGN KEY (MaTinh) REFERENCES TINH(MaTinh)
);
INSERT INTO TINH(MaTinh, TenTinh,  DienTich,  DanSo,  ThiXa) VALUES ('AG',N'An Giang', 3493, 2100200,N' Long Xuyên')
INSERT INTO TINH(MaTinh, TenTinh,  DienTich,  DanSo,  ThiXa) VALUES ('BD', N'Bình Định', 4503, 1502600,N' Quy Nhơn')
INSERT INTO TINH(MaTinh, TenTinh,  DienTich,  DanSo,  ThiXa) VALUES ('CB',N'Cao Bằng', 8445, 594400,N' Cao Bằng')
INSERT INTO TINH(MaTinh, TenTinh,  DienTich,  DanSo,  ThiXa) VALUES ('CM',N' Cà Mau', 3211, 876100,N' Cà Mau')
INSERT INTO TINH(MaTinh, TenTinh,  DienTich,  DanSo,  ThiXa) VALUES ('LA',N' Long An', 4355, 1250500,N' Tân An')
INSERT INTO TINH(MaTinh, TenTinh,  DienTich,  DanSo,  ThiXa) VALUES ('VL',N' Vĩnh Long', 2154, 933600,N' Vĩnh Long')
INSERT INTO TINH(MaTinh, TenTinh,  DienTich,  DanSo,  ThiXa) VALUES ('SG',N' TP. Hồ Chí Minh', 2029, 6766453,N' Sài Gòn')

INSERT INTO NUOC(MaNuoc, TenNuoc, ThuDo) VALUES ('CPC',N'Campuchia',N'Phnongpenh')
INSERT INTO NUOC(MaNuoc, TenNuoc, ThuDo) VALUES ('LAO',N'Lào',N'Viêng Chăng')
INSERT INTO NUOC(MaNuoc, TenNuoc, ThuDo) VALUES ('TRQ',N'Trung Quốc',N'Bắc Kinh')

INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('AG','DT')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('AG','KG')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('AG','CT')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('BD','QN')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('CM','BL')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('LA','TG')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('LA','SG')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('VL','BT')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('SG','LA')
INSERT INTO LANGGIENG(MaTinh, LG) VALUES ('SG','DN')

INSERT INTO BIENGIOI(MaTinh, MaNuoc) VALUES ('AG','CPC')
INSERT INTO BIENGIOI(MaTinh, MaNuoc) VALUES ('LA','CPC')
INSERT INTO BIENGIOI(MaTinh, MaNuoc) VALUES ('CB','TRQ')

select *from TINH

--Phan 5.1--
create proc list_dientich	
@m float
as
    select TenTinh, DienTich
    from TINH
    where DienTich > @m;
    
exec list_dientich @m = 3000


--Phan 5.2--
create proc Chinh_suatinh
    @MATINH char(2),
    @TENTINH nvarchar(30),
    @DIENTICH int,
    @DANSO int,
    @THIXA nvarchar(30)
AS
    UPDATE TINH
    SET TenTinh = @TENTINH,
        DienTich = @DIENTICH,
        Danso = @DANSO,
        ThiXa = @THIXA
    WHERE MaTinh = @MATINH;
    exec Chinh_suatinh 'BD',N'Bình Dương',2694,1047, N'Bến Các'
    go
    
--Phần 5.3--

create proc list_matdo_danso
    @m float
as
    select TenTinh, Danso, DienTich, (Danso / DienTich) AS MatDo
    from TINH
    where (Danso / DienTich) > @m;
   
   exec list_matdo_danso @m = 200
   
--Phan 6.1--
create trigger check_manuoc on NUOC
instead of insert 
as declare 
	@Manuoc char(3), 
	@Tennuoc nvarchar(30), 
	@Thudo nvarchar(30);
select 
	@Manuoc=MaNuoc,
	@Tennuoc=TenNuoc,
	@Thudo=ThuDo
from inserted

if exists (select * from NUOC where MaNuoc = @Manuoc)
begin 
	print N'Trùng mã nước'
	return 
end
insert into NUOC values('VN',N'Việt Nam',N'Hà Nội')

--Phan 6.2--
Create trigger delete_biengioi
on NUOC
instead of delete
as
if ( select COUNT(*) from deleted
	join BIENGIOI on deleted.MaNuoc=BIENGIOI.MaNuoc)>0
begin
print N'Mã nước có biên giới'
return
end
--Phan 6.3--
create trigger check_matinh on TINH
instead of insert
as
  declare
        @Matinh char(2), 
        @Tentinh nvarchar(30), 
        @Dientich int,
        @Danso int,
        @Thixa nvarchar(30);

    select 
        @Matinh = MaTinh,
        @Tentinh = TenTinh,
        @Dientich = DienTich,
        @Danso = DanSo,
        @Thixa = ThiXa
    from inserted;

    if exists (select * from TINH where MaTinh = @Matinh)
        print N'Trùng mã tỉnh';
        return
    end
    insert into TINH VALUES ('BT',N'Bến Tre', 2394, 231331,N' Bến Tre');
