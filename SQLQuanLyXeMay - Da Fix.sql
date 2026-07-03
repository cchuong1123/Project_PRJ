

CREATE DATABASE QuanLySuaChuaXeMay;
GO

USE QuanLySuaChuaXeMay;
GO

-- XÓA BẢNG CŨ (nếu tồn tại) — theo thứ tự FK
IF OBJECT_ID('Invoices', 'U')     IS NOT NULL DROP TABLE Invoices;
IF OBJECT_ID('OrderParts', 'U')   IS NOT NULL DROP TABLE OrderParts;
IF OBJECT_ID('RepairOrders', 'U') IS NOT NULL DROP TABLE RepairOrders;
IF OBJECT_ID('Parts', 'U')        IS NOT NULL DROP TABLE Parts;
IF OBJECT_ID('Vehicles', 'U')     IS NOT NULL DROP TABLE Vehicles;
IF OBJECT_ID('Customers', 'U')    IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('Users', 'U')        IS NOT NULL DROP TABLE Users;
GO

DELETE FROM Invoices; DBCC CHECKIDENT ('Invoices', RESEED, 0);
DELETE FROM OrderParts;
DELETE FROM RepairOrders; DBCC CHECKIDENT ('RepairOrders', RESEED, 0);
DELETE FROM Parts; DBCC CHECKIDENT ('Parts', RESEED, 0);
DELETE FROM Vehicles; DBCC CHECKIDENT ('Vehicles', RESEED, 0);
DELETE FROM Customers; DBCC CHECKIDENT ('Customers', RESEED, 0);
DELETE FROM Users; DBCC CHECKIDENT ('Users', RESEED, 0);
GO


-- 1. BẢNG Users — Người dùng hệ thống
CREATE TABLE Users (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    Username     NVARCHAR(50)  NOT NULL UNIQUE,
    Password     NVARCHAR(255) NOT NULL,
    FullName     NVARCHAR(100) NOT NULL,
    Role         NVARCHAR(20)  NOT NULL CHECK (Role IN ('admin', 'staff', 'mechanic')),
    IsActive     BIT           NOT NULL DEFAULT 1,
	HireDate DATE NOT NULL DEFAULT GETDATE()
);
GO

-- 2. BẢNG Customers — Khách hàng
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName   NVARCHAR(100) NOT NULL,
    Phone      NVARCHAR(15)  NOT NULL UNIQUE,
    Address    NVARCHAR(255),
    Email      NVARCHAR(100)
);
GO

-- 3. BẢNG Vehicles — Xe của khách
CREATE TABLE Vehicles (
    VehicleID       INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID      INT           NOT NULL,
    LicensePlate    NVARCHAR(20)  NOT NULL UNIQUE,
    Brand           NVARCHAR(50),
    Model           NVARCHAR(50),
    ManufactureYear INT,
    CONSTRAINT FK_Vehicles_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- 4. BẢNG Parts — Kho phụ tùng
CREATE TABLE Parts (
    PartID         INT IDENTITY(1,1) PRIMARY KEY,
    PartName       NVARCHAR(100)  NOT NULL,
    SKU            NVARCHAR(50)   NOT NULL UNIQUE,
    StockQty       INT            NOT NULL DEFAULT 0,
	ImportPrice    DECIMAL(10,2) NOT NULL DEFAULT 0,
    UnitPrice      DECIMAL(10,2)  NOT NULL DEFAULT 0,
    MinStock       INT            NOT NULL DEFAULT 5,  -- Ngưỡng cảnh báo hết hàng
    WarrantyMonths INT            DEFAULT 0            -- Số tháng bảo hành mặc định từ nhà sản xuất
);
GO

-- 5. BẢNG RepairOrders — Phiếu sửa chữa
CREATE TABLE RepairOrders (
    OrderID     INT IDENTITY(1,1) PRIMARY KEY,
	CreatedBy INT NOT NULL,
    VehicleID   INT            NOT NULL,
    MechanicID  INT            NOT NULL,  -- FK -> Users (thợ sửa)
    Status      NVARCHAR(30)   NOT NULL DEFAULT N'Tiếp nhận',
                -- Trạng thái: Tiếp nhận / Đang sửa / Chờ phụ tùng / Hoàn thành / Đã giao
    Description NVARCHAR(MAX),
    LaborCost   DECIMAL(10,2)  NOT NULL DEFAULT 0,
    CreatedAt   DATETIME       NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_RepairOrders_Vehicles  FOREIGN KEY (VehicleID)  REFERENCES Vehicles(VehicleID),
    CONSTRAINT FK_RepairOrders_Mechanic  FOREIGN KEY (MechanicID) REFERENCES Users(UserID),
	CONSTRAINT FK_RepairOrders_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

-- 6. BẢNG OrderParts — Phụ tùng sử dụng trong đơn sửa
CREATE TABLE OrderParts (
    OrderID         INT            NOT NULL,
    PartID          INT            NOT NULL,
    Quantity        INT            NOT NULL DEFAULT 1,
    UnitPrice       DECIMAL(10,2)  NOT NULL DEFAULT 0, 
    WarrantyEndDate DATE           NULL,  -- Hạn bảo hành thực tế chốt với khách
    PRIMARY KEY (OrderID, PartID),
    CONSTRAINT FK_OrderParts_Order FOREIGN KEY (OrderID) REFERENCES RepairOrders(OrderID),
    CONSTRAINT FK_OrderParts_Part  FOREIGN KEY (PartID)  REFERENCES Parts(PartID)
);
GO

-- 7. BẢNG Invoices — Hóa đơn thanh toán
CREATE TABLE Invoices (
    InvoiceID     INT IDENTITY(1,1) PRIMARY KEY,
    OrderID       INT            NOT NULL UNIQUE,  -- 1 đơn -> 1 hóa đơn
    TotalAmount   DECIMAL(10,2)  NOT NULL DEFAULT 0,
    PaymentMethod NVARCHAR(30) NOT NULL DEFAULT N'Tiền mặt',  -- Tiền mặt / Chuyển khoản
    PaidAt        DATETIME,
	CashierID      INT NULL,
    CONSTRAINT FK_Invoices_Order FOREIGN KEY (OrderID) REFERENCES RepairOrders(OrderID),
	CONSTRAINT FK_Invoices_Cashier FOREIGN KEY (CashierID) REFERENCES Users(UserID)
);
GO


INSERT INTO Users (Username, Password, FullName, Role, IsActive, HireDate) VALUES 
('admin', '123456', N'Nguyễn Huy Chương', 'admin', 1, '2024-01-15'),
('ketoan1', '123456', N'Nguyễn Thu Hà', 'staff', 1, '2025-05-25'),
('truongcon', '123456', N'Trịnh Xuân Trường', 'mechanic', 1, '2025-05-20'),
('hieuhehe', '123456', N'Bùi Trung Hiếu', 'mechanic', 1, '2025-08-15');
GO


INSERT INTO Customers (FullName, Phone, Address, Email) VALUES 
(N'Lê Trung Thắng', '0987654321', N'Khu Công nghệ cao Hoà Lạc, Thạch Thất, Hà Nội', 'thanglt@email.com'),
(N'Trần Thị Bình', '0912345678', N'Cầu Giấy, Hà Nội', 'binhtt@email.com'),
(N'Phạm Minh Đức', '0934567890', N'Nam Từ Liêm, Hà Nội', 'ducpm@email.com'),
(N'Nguyễn Văn An', '0901234567', N'Hà Đông, Hà Nội', 'annv@email.com'),
(N'Vũ Hoàng Toàn', '0977112233', N'Đống Đa, Hà Nội', 'toanvh@email.com'),
(N'Phan Văn Khải', '0988111222', N'Ba Đình, Hà Nội', 'khaipv@email.com'),
(N'Hoàng Thị Mai', '0977333444', N'Thanh Xuân, Hà Nội', 'maiht@email.com'),
(N'Đỗ Tùng Lâm', '0966555666', N'Hai Bà Trưng, Hà Nội', 'lamdt@email.com'),
(N'Bùi Thị Xuân', '0955777888', N'Hoàng Mai, Hà Nội', 'xuanbt@email.com');
GO

INSERT INTO Vehicles (CustomerID, LicensePlate, Brand, Model, ManufactureYear) VALUES 
(1, '29V5-999.99', 'Yamaha', 'Exciter 155', 2023),
(2, '43C1-111.11', 'Honda', 'SH 150i', 2022),
(3, '15E1-333.33', 'Honda', 'Vision', 2021),
(4, '29A1-123.45', 'Honda', 'Wave Alpha', 2019),
(5, '30H2-567.89', 'Yamaha', 'Grande', 2024),
(1, '29L1-456.78', 'Honda', 'Winner X', 2022);
GO

INSERT INTO Parts (PartName, SKU, StockQty, ImportPrice, UnitPrice, MinStock, WarrantyMonths) VALUES 
(N'Dầu nhớt Castrol Power1', 'OIL-CAS-01', 50, 80000, 120000, 10, 0),
(N'Bugi NGK Iridium', 'SPK-NGK-02', 30, 100000, 150000, 5, 0),
(N'Bình ắc quy Đồng Nai 12V', 'BAT-DN-12V', 15, 250000, 350000, 3, 6),
(N'Má phanh trước Honda SH', 'BRK-SH-FR', 20, 80000, 150000, 5, 0),
(N'Lốp xe Michelin Pilot', 'TIR-MIC-01', 10, 650000, 850000, 4, 12),
(N'Lọc gió Honda SH', 'AIR-SH-01', 40, 90000, 150000, 10, 0),
(N'Dây curoa Bando', 'BEL-BAN-01', 15, 250000, 380000, 5, 3),
(N'Bóng đèn pha LED Philips H4', 'LIG-PHI-H4', 25, 120000, 200000, 8, 6),
(N'Bộ nhông sên dĩa DID', 'CHN-DID-01', 10, 450000, 650000, 3, 6),
(N'Nước làm mát Liqui Moly', 'COL-LIQ-01', 30, 110000, 180000, 8, 0);
GO

INSERT INTO RepairOrders (CreatedBy, VehicleID, MechanicID, Status, Description, LaborCost, CreatedAt) VALUES 
(2, 1, 3, N'Đã giao',     N'Bảo dưỡng tổng thể, thay nhớt', 150000, DATEADD(day, -5, GETDATE())),
(2, 2, 4, N'Đã giao',     N'Thay ắc quy, kiểm tra điện',      50000, DATEADD(day, -4, GETDATE())),
(2, 3, 3, N'Hoàn thành',  N'Thay má phanh, lốp mòn',         100000, DATEADD(day, -3, GETDATE())),
(2, 4, 4, N'Đang sửa',    N'Xe kêu to ở bộ nồi',                  0, DATEADD(day, -2, GETDATE())),
(2, 5, 3, N'Chờ phụ tùng',N'Đứt dây curoa',                       0, DATEADD(day, -2, GETDATE())),
(2, 6, 4, N'Tiếp nhận',   N'Kiểm tra định kỳ',                    0, DATEADD(day, -1, GETDATE())),
(2, 1, 3, N'Đã giao',     N'Vá săm',                          30000, DATEADD(day, -1, GETDATE())),
(2, 2, 4, N'Đã giao',     N'Rửa xe, tra dầu',                 40000, DATEADD(day, -1, GETDATE())),
(2, 3, 3, N'Hoàn thành',  N'Thay bugi',                       20000, DATEADD(hour, -10, GETDATE())),
(2, 4, 4, N'Đang sửa',    N'Chỉnh cò, súc rửa chế',               0, DATEADD(hour, -8, GETDATE())),
(2, 5, 3, N'Tiếp nhận',   N'Xe không đề được',                    0, DATEADD(hour, -5, GETDATE())),
(2, 6, 4, N'Tiếp nhận',   N'Bảo dưỡng phuộc',                     0, DATEADD(hour, -4, GETDATE())),
(2, 1, 3, N'Hoàn thành',  N'Thay lốp sau',                    80000, DATEADD(hour, -2, GETDATE())),
(2, 2, 4, N'Đang sửa',    N'Sơn lại cản sau',                    0, DATEADD(hour, -1, GETDATE())),
(2, 3, 3, N'Tiếp nhận',   N'Thay nhớt định kỳ',                   0, GETDATE());
GO

INSERT INTO OrderParts (OrderID, PartID, Quantity, UnitPrice, WarrantyEndDate) VALUES 
(1, 1, 1, 120000, NULL),
(2, 3, 1, 350000, DATEADD(month, 6, GETDATE())),
(3, 4, 1, 150000, NULL),
(3, 5, 1, 850000, DATEADD(month, 12, GETDATE())),
(9, 2, 1, 150000, NULL),
(13, 5, 1, 850000, DATEADD(month, 12, GETDATE()));
GO

INSERT INTO Invoices (OrderID, TotalAmount, PaymentMethod, PaidAt, CashierID) VALUES 
(1, 270000, N'Tiền mặt',      DATEADD(day, -5, GETDATE()), 2),
(2, 400000, N'Chuyển khoản',  DATEADD(day, -4, GETDATE()), 2),
(7, 30000,  N'Tiền mặt',      DATEADD(day, -1, GETDATE()), 2),
(8, 40000,  N'Chuyển khoản',  DATEADD(day, -1, GETDATE()), 2);
GO
