-- PHAN TAO BANG
DROP SCHEMA IF EXISTS hotel_california;
CREATE SCHEMA hotel_california DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_vi_0900_as_cs;
USE hotel_california;


/*** CREATE TABLE (tạo bảng với các thuộc tính) ***/
/* Phần của Đạt */
CREATE TABLE branch (
    ID              VARCHAR(5),
    province        VARCHAR(50),
    address         VARCHAR(200) UNIQUE NOT NULL,
    phoneNumber     VARCHAR(15) UNIQUE NOT NULL,
    email           VARCHAR(100) NOT NULL
);

CREATE TABLE branchImage (
    branchID        VARCHAR(5),
    imageURL        VARCHAR(100)
);

CREATE TABLE sector (
    branchID        VARCHAR(5),
    name            VARCHAR(50)
);

CREATE TABLE roomType (
    ID              INT,
    name            VARCHAR(50) UNIQUE NOT NULL,
    area            FLOAT NOT NULL,
    numberOfGuest   INT NOT NULL,
    description     VARCHAR(100),
    CHECK (numberOfGuest <= 10 AND numberOfGuest >= 1)
);

CREATE TABLE bedInfo (
    roomTypeID      INT,
    size            DECIMAL(2,1) NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    CHECK (1 <= quantity  AND quantity <= 10)
);

CREATE TABLE roomTypeOfBranch (
    roomTypeID      INT,
    branchID        VARCHAR(5),
    rentFee         INT NOT NULL        
);

CREATE TABLE room (
    branchID        VARCHAR(5),
    ID              CHAR(3),
    roomTypeID      INT NOT NULL,
    sectorName      VARCHAR(50) NOT NULL
);

/* Phần của Đức */
CREATE TABLE supplyType (
    ID      CHAR(6),
    name    VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE supplyTypeInRoomType (
    supplyTypeID    CHAR(6),
    roomTypeID      INT,
    quantity        INT NOT NULL DEFAULT 1 
        CHECK (1 <= quantity AND quantity <= 20)
);
CREATE TABLE supply (
    branchID        VARCHAR(5),
    supplyTypeID    CHAR(6),
    ID              INT     #check
        CHECK (ID > 0),
    status       	VARCHAR(100) NOT NULL,
    roomID          CHAR(3)
);
CREATE TABLE supplier (
    ID          CHAR(7),
    name        VARCHAR(50) UNIQUE NOT NULL,
    email       VARCHAR(100) UNIQUE,
    address     VARCHAR(200) UNIQUE NOT NULL
);
CREATE TABLE provideSupply (
    supplierID      CHAR(7) NOT NULL,
    supplyTypeID    CHAR(6),
    branchID        VARCHAR(5)
);
CREATE TABLE customer (
    ID              CHAR(8),
    IDCardNumber    VARCHAR(12) UNIQUE NOT NULL,
    name            VARCHAR(150) NOT NULL,
    phoneNumber     VARCHAR(15) UNIQUE NOT NULL,
    email           VARCHAR(100) UNIQUE,
    username        VARCHAR(50) UNIQUE,
    password        VARCHAR(100),
    point           INT NOT NULL DEFAULT 0
        CHECK (point >= 0),
    type            INT NOT NULL DEFAULT 1
        CHECK (1 <= type AND type <= 4)
);
CREATE TABLE servicePacket (
    name            VARCHAR(50),
    numberOfDay    INT NOT NULL
        CHECK (1 <= numberOfDay AND numberOfDay <= 100),
    numberOfGuest   INT NOT NULL
        CHECK (1 <= numberOfGuest AND numberOfGuest <= 10),
    price           INT NOT NULL
);


/* Phần của Minh */
CREATE TABLE servicePacketInvoice (
	customerID      CHAR(8),
	packetName		VARCHAR(50),
	buyDate		    DATETIME,
	startDate       DATETIME NOT NULL,
	CHECK (startDate > buyDate),
    totalCost       INT NOT NULL DEFAULT 0,
    remainingDay    INT NOT NULL DEFAULT 0
);
CREATE TABLE reservation (
	ID              CHAR(16),
	bookingDate		DATETIME NOT NULL,
    numberOfGuest   INT NOT NULL,
	checkInDate		DATETIME NOT NULL,
	CHECK (checkInDate > bookingDate),
	checkOutDate    DATETIME NOT NULL,
	CHECK (checkOutDate > checkInDate),
    status          CHAR(1) NOT NULL DEFAULT '0',
    totalCost       INT NOT NULL DEFAULT 0,
    customerID      CHAR(8) NOT NULL,
    packetName      VARCHAR(50)
);
CREATE TABLE rentedRoom (
	reservationID   CHAR(16),
	branchID        VARCHAR(5),
	roomID          CHAR(3)
);
CREATE TABLE invoice (
	ID              CHAR(16),
	checkInTime     TIME NOT NULL,
    checkOutTime    TIME ,
	reservationID   CHAR(16) NOT NULL
);
CREATE TABLE enterprise (
	ID      CHAR(6),
	name    VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE service (
	ID              CHAR(6),
    type            CHAR(1) NOT NULL,
	numberOfGuest   INT,
    style           VARCHAR(50),
    enterpriseID    CHAR(6) NOT NULL
);

/* Phần của Sơn */
CREATE TABLE spa (
	ID	            CHAR(6), 
	type            VARCHAR(30)
);

CREATE TABLE souvenirType (
	ID	            CHAR(6), 
	type	        VARCHAR(30)
);

CREATE TABLE souvenirBrand (
	ID	            CHAR(6), 
	brandName	    VARCHAR(50)
);

CREATE TABLE lot (
	branchID	    VARCHAR(5),
    ID	            INT NOT NULL DEFAULT 1
        CHECK (1 <= ID AND ID <= 50),
    length          FLOAT NOT NULL,
    width           FLOAT NOT NULL,
    rentFee		    INT NOT NULL,
    description     VARCHAR(200),
	serviceID	    CHAR(6),
    shopName        VARCHAR(50),
    logoURL         VARCHAR(100)
);

CREATE TABLE shopImage (
	branchID	    VARCHAR(5),
	lotID		    INT,
    imageURL        VARCHAR(100)
);

CREATE TABLE timeFrame (
	branchID	    VARCHAR(5),
	lotID	        INT,
    startTime       TIME,
    endTime         TIME NOT NULL,
	CHECK (endTime > startTime)
);


/*** ALTER TABLE (thêm khóa cho bảng) ***/
/* Phần của Đạt */
ALTER TABLE branch ADD (
    PRIMARY KEY(ID)
);

ALTER TABLE branchImage ADD (
    PRIMARY KEY(branchID, imageURL),
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE sector ADD (
    PRIMARY KEY(branchID, name),
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE roomType ADD (
    PRIMARY KEY(ID)
);
ALTER TABLE roomType MODIFY
    ID      INT AUTO_INCREMENT
;

ALTER TABLE bedInfo ADD (
    PRIMARY KEY(roomTypeID, size),
    FOREIGN KEY(roomTypeID) REFERENCES roomType(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE roomTypeOfBranch ADD(
    PRIMARY KEY(roomTypeID, branchID),
    FOREIGN KEY(roomTypeID) REFERENCES roomType(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE room ADD (
    PRIMARY KEY(branchID, ID),
    FOREIGN KEY(branchID, sectorName) REFERENCES sector(branchID, name)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(roomTypeID) REFERENCES roomType(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


/* Phần của Đức */
ALTER TABLE supplyType ADD (
    PRIMARY KEY(ID)
);
ALTER TABLE supplyTypeInRoomType ADD (
    PRIMARY KEY (supplyTypeID, roomTypeID),
    FOREIGN KEY (supplyTypeID) REFERENCES supplyType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (roomTypeID) REFERENCES roomType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE supply ADD (
    PRIMARY KEY (branchID, supplyTypeID, ID),
    FOREIGN KEY (branchID) REFERENCES branch (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supplyTypeID) REFERENCES supplyType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (branchID, roomID) REFERENCES room (branchID, ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE supplier ADD (
    PRIMARY KEY (ID)
);
ALTER TABLE provideSupply ADD (
    PRIMARY KEY (supplyTypeID, branchID),
    FOREIGN KEY (supplierID) REFERENCES supplier (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supplyTypeID) REFERENCES supplyType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (branchID) REFERENCES branch (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE customer ADD (
    PRIMARY KEY (ID)
);
ALTER TABLE servicePacket ADD (
    PRIMARY KEY (name)
);

/* Phần của Minh */
ALTER TABLE servicePacketInvoice 
ADD (
	PRIMARY KEY (customerID, packetName, buyDate),
	FOREIGN KEY (customerID) REFERENCES customer (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (packetName) REFERENCES servicePacket (name)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE reservation 
ADD (	
	PRIMARY KEY (ID),
	FOREIGN KEY (customerID) REFERENCES customer (ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (packetName) REFERENCES servicePacket (name)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE rentedRoom 
ADD (	
	PRIMARY KEY (reservationID, branchID, roomID),
	FOREIGN KEY (reservationID) REFERENCES reservation (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (branchID, roomID) REFERENCES room (branchID, ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE invoice 
ADD (	
	PRIMARY KEY (ID),
	FOREIGN KEY (reservationID) REFERENCES reservation (ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE enterprise 
ADD (	
	PRIMARY KEY (ID)
);

ALTER TABLE service 
ADD (	
	PRIMARY KEY (ID),
    FOREIGN KEY (enterpriseID) REFERENCES enterprise (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


/* Phần của Sơn */
ALTER TABLE spa ADD (
    PRIMARY KEY(ID, type),
    FOREIGN KEY(ID) REFERENCES service (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE souvenirType ADD (
    PRIMARY KEY(ID, type),
    FOREIGN KEY(ID) REFERENCES service(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE souvenirBrand ADD (
    PRIMARY KEY(ID, brandName),
    FOREIGN KEY(ID) REFERENCES service(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE lot ADD (
    PRIMARY KEY(branchID, ID),
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(serviceID) REFERENCES service(ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

ALTER TABLE shopImage ADD (
    PRIMARY KEY(branchID, lotID, imageURL),
    FOREIGN KEY(branchID, lotID) REFERENCES lot (branchID, ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE timeFrame ADD (
    PRIMARY KEY(branchID, lotID, startTime),
    FOREIGN KEY(branchID, lotID) REFERENCES lot (branchID, ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);



-- TRIGGER BO SUNG DAM BAO CAC RANG BUOC CUA BANG (NEU CO).
CREATE TABLE tableID (
    name       VARCHAR(50),
    number     INT NOT NULL DEFAULT 1,
    PRIMARY KEY (name)
);

INSERT IGNORE INTO tableID(name)
VALUES
    ('branch'),
    ('supplyType'),
    ('supplier'),
    ('customer'),
    ('reservation'),
    ('enterprise'),
    ('serviceR'),
    ('serviceM'),
    ('serviceS'),
    ('serviceB')
;
INSERT IGNORE INTO tableID
VALUES ('invoice',5);

DROP TRIGGER IF EXISTS triggerBranchBI;
DELIMITER #
CREATE TRIGGER triggerBranchBI
BEFORE INSERT ON branch
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = 'branch'
    INTO @count;
    
    SET NEW.ID = CONCAT('CN', @count);

    UPDATE tableID
    SET number = number + 1
    WHERE name = 'branch';
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerSupplyTypeBI;
DELIMITER #
CREATE TRIGGER triggerSupplyTypeBI
BEFORE INSERT ON supplyType
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = "supplyType"
    INTO @count;

    SET NEW.ID = CONCAT('VT', LPAD(@count, 4, 0));

    UPDATE tableID
    SET number = number + 1
    WHERE name = "supplyType";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerSupplierBI;
DELIMITER #
CREATE TRIGGER triggerSupplierBI
BEFORE INSERT ON supplier
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = "supplier"
    INTO @count;

    SET NEW.ID = CONCAT('NCC', LPAD(@count, 4, 0));

    UPDATE tableID
    SET number = number + 1
    WHERE name = "supplier";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerProvideSupplyBI;
DELIMITER #
CREATE TRIGGER triggerProvideSupplyBI
BEFORE INSERT ON provideSupply
FOR EACH ROW
BEGIN
    SELECT supplierID, supplyTypeID
    FROM provideSupply pS
    WHERE pS.supplyTypeID = NEW.supplyTypeID
    AND ps.branchID = NEW.branchID
    INTO @supID, @typeID;
    
    SELECT name
    FROM supplier s
    WHERE NOT ISNULL(@supID)
    AND s.ID = @supID
    INTO @supName;

    SELECT name
    FROM supplyType sT
    WHERE NOT ISNULL(@typeID)
    AND sT.ID = @typeID
    INTO @typeName;

    IF NOT ISNULL(@supID) THEN
        SET @msg = CONCAT("Lưu ý: Chi nhánh mã ", NEW.branchID, " đã có ", @supName, " cung cấp ", @typeName, "!");
    END IF;
    IF NOT ISNULL(@supID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
    END IF;
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerCustomerBI;
DELIMITER #
CREATE TRIGGER triggerCustomerBI
BEFORE INSERT ON customer
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = "customer"
    INTO @count;

    SET NEW.ID = CONCAT('KH', LPAD(@count, 6, 0));

    UPDATE tableID
    SET number = number + 1
    WHERE name = "customer";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerRoomBD;
DELIMITER #
CREATE TRIGGER triggerRoomBD
BEFORE DELETE ON room
FOR EACH ROW
BEGIN
    UPDATE supply
    SET supply.roomID = NULL
    WHERE supply.roomID = OLD.ID
    AND supply.branchID = OLD.branchID;
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerReservationBI;
DELIMITER #
CREATE TRIGGER triggerReservationBI
BEFORE INSERT ON reservation
FOR EACH ROW
BEGIN
    SET @flag = FALSE;
	IF (NEW.packetName != NULL) 
		THEN BEGIN
			SELECT numberOfGuests FROM servicePacket WHERE name = NEW.packetName INTO @max_guestPacket;
            SELECT remainingDay FROM servicePacketInvoice WHERE packetName = NEW.packetName AND customerID = NEW.customerID INTO @remainingDay; 
            IF (@remainingDay = NULL 
                OR @remainingDay < DATEDIFF(NEW.checkOutDate,NEW.checkInDate)
                OR NEW.numberOfGuest > @max_guestPacket)
				THEN SET NEW.packetName = NULL;
			END IF;
		END;
	END IF;
    SELECT number FROM tableID WHERE name = "reservation" INTO @ID;
    SELECT CONCAT("DP", DATE_FORMAT(DATE(NEW.bookingDate), "%d%m%Y"), LPAD(@ID, 6, 0)) INTO @ID;
	SET NEW.ID = @ID;
    UPDATE tableID
        SET number = number + 1
        WHERE name = "reservation";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerEnterpriseBI;
DELIMITER #
CREATE TRIGGER triggerEnterpriseBI
BEFORE INSERT ON enterprise
FOR EACH ROW
BEGIN
    SELECT number FROM tableID WHERE name = "enterprise" INTO @count;
    SET NEW.ID = CONCAT('DN', LPAD(@count, 4, 0));
    UPDATE tableID SET number = number + 1 WHERE name = "enterprise";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerServiceBI;
DELIMITER #
CREATE TRIGGER triggerServiceBI
BEFORE INSERT ON service
FOR EACH ROW
BEGIN
    SELECT number FROM tableID WHERE name = CONCAT("service", NEW.type) INTO @count;
    SET NEW.ID = CONCAT('DV', NEW.type, LPAD(@count, 3, 0));
    UPDATE tableID SET number = number + 1 WHERE name = CONCAT("service", NEW.type);
END#
DELIMITER ;



-- INSERT
/*** INSERT INTO TABLE (sinh dữ liệu cho bảng) ***/
/* Phần của Đạt */
-- Chi nhánh
INSERT INTO branch(province, address, phoneNumber, email)
VALUES 
    ('TP. Hồ Chí Minh', '101 Nguyễn Hữu Cảnh, quận Bình Thạnh', '0901234000', 'DukeHaymich@gmail.com'),
    ('TP. Hồ Chí Minh', '102 Nguyễn Xí, quận Bình Thạnh', '0901234001', 'HaymichDuke@gmail.com'),
    ('TP. Hồ Chí Minh', '302 Kha Vạn Cân, quận Thủ Đức', '0901234002', 'Typn1911@gmail.com'),
    ('Bà Rịa - Vũng Tàu', '345 Thùy Vân, TP. Vũng Tàu', '0923145675', 'acefail@gmail.com'),
    ('Bà Rịa - Vũng Tàu', 'Hồ Tràm, huyện Xuyên Mộc', '0907563269', 'nevergonnagiveyouup@gmail.com'),
    ('Lâm Đồng', '46 Trần Hưng Đạo, TP. Đà Lạt', '0923178699', 'laudaitinhai@gmail.com');
-- Hình ảnh chi nhánh
INSERT INTO branchImage(branchID, imageURL)
VALUES
    ('CN1', '../img/branchlogo/branchno1.png'),
    ('CN2', '../img/branchlogo/branchno2.png'),
    ('CN3', '../img/branchlogo/branchno3.png'),
    ('CN4', '../img/branchlogo/branchno4.png'),
    ('CN5', '../img/branchlogo/branchno5.png'),
    ('CN6', '../img/branchlogo/branchno6.png');
-- Khu
INSERT INTO sector(branchID, name)
VALUES
    ('CN1', 'Ven sông'),
    ('CN1', 'Công viên'),
    ('CN2', 'Chợ'),
    ('CN2', 'Ven sông'),
    ('CN3', 'Ven hồ'),
    ('CN4', 'Công viên'),
    ('CN4', 'Ven biển'),
    ('CN4', 'Chợ'),
    ('CN4', 'Lưng núi'),
    ('CN5', 'Ven biển'),
    ('CN5', 'Rừng thông'),
    ('CN6', 'Ven hồ'),
    ('CN6', 'Rừng hoa'),
    ('CN6', 'Đồi');
-- Loại phòng
INSERT INTO roomType(name, area, numberOfGuest, description)
VALUES
    ('Đơn thường', 15, 1, 'Phòng dành cho những tấm thân cô đơn, lẻ loi'),
    ('Đôi thường', 20, 2, 'Tha hồ nghịch ong'),
    ('Gia đình thường', 30, 4, 'Phòng có thiết kế ấm cúng, thân thiện với môi trường và trẻ nhỏ'),
    ('Đơn thương nhân', 30, 1, 'Phù hợp cho các doanh nhân, sói già phố Wall'),
    ('Đôi thương nhân', 45, 2, 'Phòng cho các chuyến công tác hai người'),
    ('Đơn hoàng gia', 60, 1, 'Thiết kế hiện đại, tiện nghi đầy đủ, thể hiện đẳng cấp của khách'),
    ('Đôi hoàng gia', 80, 2, 'Xịn'),
    ('Gia đình hoàng gia', 120, 5, 'Quá xịn');
-- Thông tin giường
INSERT INTO bedInfo(roomTypeID, size, quantity)
VALUES
    (1, 2.0, 1),
    (2, 2.0, 2),
    (3, 2.5, 2),
    (4, 2.5, 1),
    (5, 2.5, 2),
    (6, 3.0, 1),
    (7, 3.0, 2),
    (8, 3.0, 3);
; 
-- Chi nhánh có loại phòng
INSERT INTO roomTypeOfBranch(roomTypeID, branchID, rentFee)
VALUES
    (1, 'CN1', 600),
    (2, 'CN1', 700),
    (3, 'CN1', 1000),
    (4, 'CN1', 800),
    (5, 'CN1', 1000),
    (6, 'CN1', 2000),
    (7, 'CN1', 2700),
    (8, 'CN1', 3500),

    (1, 'CN2', 500),
    (2, 'CN2', 600),
    (3, 'CN2', 800),
    (4, 'CN2', 700),
    (5, 'CN2', 800),
    (6, 'CN2', 1500),

    (1, 'CN3', 500),
    (2, 'CN3', 600),
    (3, 'CN3', 800),
    (4, 'CN3', 700),
    (5, 'CN3', 800),
    (6, 'CN3', 1500),

    (1, 'CN4', 700),
    (2, 'CN4', 800),
    (3, 'CN4', 1200),
    (4, 'CN4', 900),
    (5, 'CN4', 1200),
    (6, 'CN4', 2200),
    (7, 'CN4', 2800),
    (8, 'CN4', 3800),

    (1, 'CN5', 750),
    (2, 'CN5', 850),
    (3, 'CN5', 1250),
    (4, 'CN5', 950),
    (5, 'CN5', 1250),
    (6, 'CN5', 2250),
    (7, 'CN5', 2850),
    (8, 'CN5', 3900),

    (4, 'CN6', 1000),
    (5, 'CN6', 1400),
    (6, 'CN6', 2400),
    (7, 'CN6', 2900),
    (8, 'CN6', 4000)
;
-- Phòng
INSERT INTO room
VALUES
    ("CN1", "101", "1", "Ven sông"),
    ("CN1", "102", "1", "Ven sông"),
    ("CN1", "103", "2", "Ven sông"),
    ("CN1", "104", "2", "Ven sông"),
    ("CN1", "105", "3", "Ven sông"),
    ("CN1", "106", "3", "Ven sông"),
    ("CN1", "201", "2", "Ven sông"),
    ("CN1", "202", "2", "Ven sông"),
    ("CN1", "203", "3", "Ven sông"),
    ("CN1", "204", "4", "Ven sông"),
    ("CN1", "205", "4", "Ven sông"),
    ("CN1", "206", "5", "Ven sông"),
    ("CN1", "301", "6", "Ven sông"),
    ("CN1", "302", "7", "Ven sông"),
    ("CN1", "303", "8", "Ven sông"),
    ("CN1", "121", "1", "Công viên"),
    ("CN1", "122", "1", "Công viên"),
    ("CN1", "123", "2", "Công viên"),
    ("CN1", "124", "3", "Công viên"),
    ("CN1", "221", "1", "Công viên"),
    ("CN1", "222", "1", "Công viên"),
    ("CN1", "223", "2", "Công viên"),
    ("CN1", "224", "3", "Công viên"),

    ("CN2", "101", "1", "Ven sông"),
    ("CN2", "102", "1", "Ven sông"),
    ("CN2", "103", "2", "Ven sông"),
    ("CN2", "104", "2", "Ven sông"),
    ("CN2", "105", "3", "Ven sông"),
    ("CN2", "106", "3", "Ven sông"),
    ("CN2", "201", "2", "Ven sông"),
    ("CN2", "202", "2", "Ven sông"),
    ("CN2", "203", "3", "Ven sông"),
    ("CN2", "204", "4", "Ven sông"),
    ("CN2", "205", "4", "Ven sông"),
    ("CN2", "206", "5", "Ven sông"),
    ("CN2", "301", "5", "Ven sông"),
    ("CN2", "302", "6", "Ven sông"),
    ("CN2", "303", "6", "Ven sông"),
    ("CN2", "121", "1", "Chợ"),
    ("CN2", "122", "1", "Chợ"),
    ("CN2", "123", "2", "Chợ"),
    ("CN2", "124", "3", "Chợ"),
    ("CN2", "221", "1", "Chợ"),
    ("CN2", "222", "1", "Chợ"),
    ("CN2", "223", "2", "Chợ"),
    ("CN2", "224", "3", "Chợ"),

    ("CN3", "101", "1", "Ven hồ"),
    ("CN3", "102", "1", "Ven hồ"),
    ("CN3", "103", "1", "Ven hồ"),
    ("CN3", "104", "2", "Ven hồ"),
    ("CN3", "105", "2", "Ven hồ"),
    ("CN3", "106", "2", "Ven hồ"),
    ("CN3", "201", "1", "Ven hồ"),
    ("CN3", "202", "1", "Ven hồ"),
    ("CN3", "203", "2", "Ven hồ"),
    ("CN3", "204", "3", "Ven hồ"),
    ("CN3", "205", "3", "Ven hồ"),
    ("CN3", "206", "3", "Ven hồ"),
    ("CN3", "301", "2", "Ven hồ"),
    ("CN3", "302", "2", "Ven hồ"),
    ("CN3", "303", "3", "Ven hồ"),
    ("CN3", "304", "3", "Ven hồ"),
    ("CN3", "305", "4", "Ven hồ"),
    ("CN3", "306", "4", "Ven hồ"),
    ("CN3", "401", "4", "Ven hồ"),
    ("CN3", "402", "5", "Ven hồ"),
    ("CN3", "403", "5", "Ven hồ"),
    ("CN3", "404", "6", "Ven hồ"),
    ("CN3", "405", "6", "Ven hồ"),
    ("CN3", "406", "7", "Ven hồ")
;
/* Phần của Đức */
INSERT INTO supplyType (name)
VALUES
    /*01*/ ("Giường"),
    /*02*/ ("Chăn"),
    /*03*/ ("Drap"),
    /*04*/ ("Gối"),
    /*05*/ ("Nệm"),
    /*06*/ ("Khăn tắm"),
    /*07*/ ("Đôi dép"),
    /*08*/ ("Kem đánh răng"),
    /*09*/ ("Xà phòng"),
    /*10*/ ("Tủ quần áo"),
    /*11*/ ("Tủ đầu giường"),
    /*12*/ ("Bàn"),
    /*13*/ ("Ghế"),
    /*14*/ ("Ấm đun nước"),
    /*15*/ ("Tủ lạnh"),
    /*16*/ ("Máy lạnh"),
    /*17*/ ("Quạt"),
    /*18*/ ("Tivi")
;
INSERT INTO supplyTypeInRoomType
VALUES
    ("VT0001", "1", 1),
    ("VT0002", "1", 2),
    ("VT0003", "1", 1),
    ("VT0004", "1", 2),
    ("VT0005", "1", 1),
    ("VT0006", "1", 3),
    ("VT0007", "1", 2),
    ("VT0010", "1", 1),
    ("VT0011", "1", 1),
    ("VT0012", "1", 1),
    ("VT0013", "1", 1),
    ("VT0016", "1", 1),
    ("VT0017", "1", 1),
    ("VT0018", "1", 1),
    
    ("VT0001", "2", 2),
    ("VT0002", "2", 4),
    ("VT0003", "2", 2),
    ("VT0004", "2", 4),
    ("VT0005", "2", 2),
    ("VT0006", "2", 6),
    ("VT0007", "2", 4),
    ("VT0008", "2", 2),
    ("VT0009", "2", 2),
    ("VT0010", "2", 2),
    ("VT0011", "2", 2),
    ("VT0012", "2", 1),
    ("VT0013", "2", 2),
    ("VT0014", "2", 1),
    ("VT0015", "2", 1),
    ("VT0016", "2", 1),
    ("VT0017", "2", 2),
    ("VT0018", "2", 1)
;
INSERT INTO supply
VALUES
    ("CN1", "VT0001", 1, "OK", "101"),
    ("CN1", "VT0001", 2, "OK", "102"),
    ("CN1", "VT0001", 3, "OK", "102"),

    ("CN1", "VT0002", 1, "OK", "101"),
    ("CN1", "VT0002", 2, "OK", "101"),
    ("CN1", "VT0002", 3, "OK", "102"),
    ("CN1", "VT0002", 4, "OK", "102"),
    ("CN1", "VT0002", 5, "OK", "102"),
    ("CN1", "VT0002", 6, "OK", "102"),

    ("CN1", "VT0003", 1, "OK", "101"),
    ("CN1", "VT0003", 2, "OK", "102"),
    ("CN1", "VT0003", 3, "OK", "102"),

    ("CN1", "VT0004", 1, "OK", "101"),
    ("CN1", "VT0004", 2, "OK", "101"),
    ("CN1", "VT0004", 3, "OK", "102"),
    ("CN1", "VT0004", 4, "OK", "102"),
    ("CN1", "VT0004", 5, "OK", "102"),
    ("CN1", "VT0004", 6, "OK", "102"),

    ("CN1", "VT0005", 1, "OK", "101"),
    ("CN1", "VT0005", 2, "OK", "102"),
    ("CN1", "VT0005", 3, "OK", "102"),

    ("CN1", "VT0006", 1, "OK", "101"),
    ("CN1", "VT0006", 2, "OK", "101"),
    ("CN1", "VT0006", 3, "OK", "101"),
    ("CN1", "VT0006", 4, "OK", "102"),
    ("CN1", "VT0006", 5, "OK", "102"),
    ("CN1", "VT0006", 6, "OK", "102"),
    ("CN1", "VT0006", 7, "OK", "102"),
    ("CN1", "VT0006", 8, "OK", "102"),
    ("CN1", "VT0006", 9, "OK", "102"),

    ("CN1", "VT0007", 1, "OK", "101"),
    ("CN1", "VT0007", 2, "OK", "101"),
    ("CN1", "VT0007", 3, "OK", "102"),
    ("CN1", "VT0007", 4, "OK", "102"),
    ("CN1", "VT0007", 5, "OK", "102"),
    ("CN1", "VT0007", 6, "OK", "102"),

    ("CN1", "VT0008", 1, "OK", "102"),
    ("CN1", "VT0008", 2, "OK", "102"),

    ("CN1", "VT0009", 1, "OK", "102"),
    ("CN1", "VT0009", 2, "OK", "102"),

    ("CN1", "VT0010", 1, "OK", "101"),
    ("CN1", "VT0010", 2, "OK", "102"),
    ("CN1", "VT0010", 3, "OK", "102"),

    ("CN1", "VT0011", 1, "OK", "101"),
    ("CN1", "VT0011", 2, "OK", "102"),
    ("CN1", "VT0011", 3, "OK", "102"),

    ("CN1", "VT0012", 1, "OK", "101"),
    ("CN1", "VT0012", 2, "OK", "102"),

    ("CN1", "VT0013", 1, "OK", "101"),
    ("CN1", "VT0013", 2, "OK", "102"),
    ("CN1", "VT0013", 3, "OK", "102"),

    ("CN1", "VT0014", 1, "OK", "102"),

    ("CN1", "VT0015", 1, "OK", "102"),

    ("CN1", "VT0016", 1, "OK", "101"),
    ("CN1", "VT0016", 2, "OK", "102"),

    ("CN1", "VT0017", 1, "OK", "101"),
    ("CN1", "VT0017", 2, "OK", "102"),
    ("CN1", "VT0017", 3, "OK", "102"),

    ("CN1", "VT0018", 1, "OK", "101"),
    ("CN1", "VT0018", 2, "OK", "102")
;
INSERT INTO supplier
VALUES
    ("NCC0001", "Hòa Phát", "contactus@kymdan.com", "28 Bình Thới, Phường 14, Quận 11, Tp. Hồ Chí Minh"),
    ("NCC0002", "Senko", "cskh@thegioididong.com", "128 Trần Quang Khải, P. Tân Định, Q.1, TP.Hồ Chí Minh"),
    ("NCC0003", "Rita Võ", "info@ritavo.com", "327 Xa lộ Hà Nội, phường An Phú, Quận 2. TP. Hồ Chí Minh"),
    ("NCC0004", "Panasonic", "customer@vn.panasonic.com", "Lô J1-J2, Khu công nghiệp Thăng Long, xã Kim Chung, huyện Đông Anh, Tp. Hà Nội, Việt Nam"),
    ("NCC0005", "Toshiba", NULL, "Số 12, Đường 15, Khu phố 4, Phường Linh Trung, Tp. Thủ Đức, Tp. Hồ Chí Minh")
;
INSERT INTO provideSupply
VALUES
    ("NCC0001", "VT0010", "CN1"),
    ("NCC0001", "VT0011", "CN1"),
    ("NCC0001", "VT0012", "CN1"),
    ("NCC0001", "VT0013", "CN1"),
    ("NCC0002", "VT0017", "CN1"),
    ("NCC0003", "VT0001", "CN1"),
    ("NCC0003", "VT0002", "CN1"),
    ("NCC0003", "VT0003", "CN1"),
    ("NCC0003", "VT0004", "CN1"),
    ("NCC0004", "VT0014", "CN1"),
    ("NCC0004", "VT0016", "CN1"),
    ("NCC0004", "VT0018", "CN1"),
    ("NCC0005", "VT0015", "CN1")
;
INSERT INTO customer
VALUES
    ("KH000001", "0123456789", "Peter Pan", "0987654321", "pan@neverland.com", NULL, NULL, DEFAULT, DEFAULT),
    ("KH000002", "9999999999", "Duke Haymich", "0987999999", "duke@example.com", "dukeHaymich", "123456", 777, DEFAULT),
    ("KH000003", "1111111111", "John Doe", "0987777777", "johndoe@whoami.com", "johnIsMissing", "aaaaaa", 22, DEFAULT)
;
INSERT INTO servicePacket
VALUES
    ("Ưu đãi gia đình", 7, 8, 1000),
    ("VIP tháng", 31, 4, 3500),
    ("Hoàng gia", 100, 10, 8000)
;
/* Phần của Minh */

-- Hoá đơn gói dịch vụ
INSERT INTO servicePacketInvoice(customerID,packetName,buyDate,startDate)
VALUES 
	('KH000001','Ưu đãi gia đình','2021-03-15 9:15:17','2021-03-15 9:30:17'),
    ('KH000002','VIP tháng','2021-01-01 10:15:45','2021-01-01 10:45:45'),
    ('KH000003','Hoàng gia','2021-04-25 16:36:25','2021-04-25 17:06:25')
;

-- Đơn đặt phòng
INSERT INTO reservation (bookingDate,numberOfGuest,checkInDate,checkOutDate,customerID,packetName)
VALUES 
	('2021-01-01 20:15:17', 4,'2021-03-20 07:00:00','2021-3-25 16:30:00','KH000001',NULL),
    ('2021-01-05 08:30:20', 2,'2021-01-10 10:30:00','2021-01-12 19:00:00','KH000002','VIP tháng'),
    ('2021-02-19 10:20:46', 1,'2021-03-10 08:00:00','2021-03-14 18:00:00','KH000003',NULL),
	('2021-05-15 14:15:16', 5,'2021-05-30 17:00:00','2021-06-05 06:00:00','KH000001','Ưu đãi gia đình');

-- Phòng thuê
INSERT INTO rentedRoom(reservationID,branchID,roomID)
VALUES 
	('DP01012021000001',"CN1", "101"),
    ('DP05012021000002',"CN1", "101"),
    ('DP19022021000003',"CN1", "101"),
    ('DP15052021000004',"CN1", "101");

-- Hoá đơn
INSERT INTO invoice(ID,checkInTime,reservationID)
VALUES
	('HD20032021000001','07:00','DP01012021000001'),
    ('HD10012021000002','10:30','DP05012021000002'),
    ('HD10032021000003','08:00','DP19022021000003'),
    ('HD30052021000004','17:00','DP15052021000004');

-- Doanh nghiệp
INSERT INTO enterprise(name)
VALUES
	('Vincenzo'),
    ('Hydra'),
    ('Robotic'),
    ('Hustle');

-- Dịch vụ
INSERT INTO service(type,enterpriseID)
VALUES
	('R','DN0001'),
    ('S','DN0002'),
    ('M','DN0003'),
    ('B','DN0004'),
    ('S','DN0002'),
    ('S','DN0002'),
    ('S','DN0002'),
    ('M','DN0003'),
    ('M','DN0003'),
    ('M','DN0003')
;

/* Phần của Sơn */
-- Dịch vụ Spa
INSERT INTO spa(ID, type)
VALUES 
    ('DVS001', 'Hot Stone Massage'),
    ('DVS002', 'Pampering Facial'),
    ('DVS003', 'Scalp Massage'),
    ('DVS004', 'Deep Conditioning Treatment')
;

-- Loại hàng đồ lưu niệm
INSERT INTO souvenirType(ID,type)
VALUES 
    ('DVM001', 'Earth Model'),
    ('DVM002', 'Woodhouse Model'),
    ('DVM003', 'Superman Figure'),
    ('DVM004', 'Black Tea Healthy')
;

-- Thương hiệu đồ lưu niệm
INSERT INTO souvenirBrand(ID,brandName)
VALUES 
    ('DVM001', 'Model Maker'),
    ('DVM002', 'Woodware Maker'),
    ('DVM003', 'Figure Maker'),
    ('DVM004', 'Tea Maker')
;

-- Mặt bằng
INSERT INTO lot(branchID, ID, length, width, rentFee, description, serviceID, shopName, logoURL)
VALUES 
    ('CN1', 1, 20.0, 30.0, 10000, 'Price too good to ignore', 'DVM003', 'Model Shop Yolo', '../img/modelyolo.img'),
    ('CN1', 2, 40.0, 40.0, 30000, 'Near sea', 'DVR001', 'Restaurant Yolo', '../img/restaurantyolo.img'),
    ('CN2', 1, 35.0, 40.0, 20000, 'Too beautiful to ignore', 'DVS002', 'Spa Yolo', '../img/spayolo.img'),
    ('CN3', 1, 10.0, 20.0, 5000, 'Too cheap to ignore', 'DVM003', 'Model Shop Yolo 2', '../img/modelyolo2.img')
;

-- Hình ảnh cửa hàng
INSERT INTO shopImage(branchID, lotID, imageURL)
VALUES 
    ('CN1', 1, '../img/modelyolo_1.img'),
    ('CN1', 1, '../img/modelyolo_2.img'),
    ('CN2', 1, '../img/restaurantyolo_1.img'),
    ('CN3', 1, '../img/modelyolo2_1.img')
;

-- Khung giờ hoạt động cửa hàng
INSERT INTO timeFrame(branchID, lotID, startTime, endTime)
VALUES
    ('CN1',1,'07:00:00','12:00:00'),
    ('CN1',1,'13:00:00','16:00:00'),
    ('CN1',2,'5:00:00','19:00:00'),
    ('CN3',1,'6:00:00','12:00:00')
;


DROP TRIGGER IF EXISTS triggerInvoiceBI;
DELIMITER #
CREATE TRIGGER triggerInvoiceBI
BEFORE INSERT ON invoice
FOR EACH ROW
BEGIN
    SELECT number FROM tableID WHERE name = "invoice" INTO @ID;
    SELECT CONCAT("HD", DATE_FORMAT(CURDATE(), "%d%m%Y"), LPAD(@ID, 6, 0)) INTO @ID;
	SET NEW.ID = @ID;
    SET NEW.checkInTime = TIME_FORMAT(CURTIME(),'%H:%i');
    UPDATE tableID
        SET number = number + 1
        WHERE name = "invoice";
END#
DELIMITER ;





-- Extra Script

-- customer
INSERT INTO customer
VALUES
    ("KH000004", "2222222331", "Joker", "190011113", "iamjoker@gmail.com", "imjoker", 'whysoserious', 888, DEFAULT),
    ("KH000005", "8914109312", "Boi", "0919992223", "ohboi@gmail.com", "boiboiboi", "222333", 54, DEFAULT),
    ("KH000006", "8190381903", "Upin", "2467432822", "threetwoone@yahoo.com", "omgomg", "disney123", 1, DEFAULT),
    ("KH000007", "3824532623", "The Flash", "888888888", "toospeedy@hcmut.edu.vn", "flashsaleman", "richperson123", 1020, DEFAULT)
;
-- Đơn đặt phòng
INSERT INTO reservation (bookingDate,numberOfGuest,checkInDate,checkOutDate,customerID,packetName)
VALUES 
	('2021-01-01 20:15:17', 4,'2021-11-29 07:00:00','2021-12-29 16:30:00','KH000001',NULL),
    ('2021-01-05 08:30:20', 2,'2021-12-12 10:30:00','2022-01-12 19:00:00','KH000002','VIP tháng'),
    ('2021-02-19 10:20:46', 1,'2021-12-01 08:00:00','2022-03-14 18:00:00','KH000003',NULL),
	('2021-05-15 14:15:56', 5,'2021-11-28 17:00:00','2022-01-05 06:00:00','KH000001','Hoàng gia'),
	('2021-11-27 14:17:14', 3,'2021-11-28 17:00:00','2021-12-29 06:00:00','KH000002',NULL),
	('2021-11-27 08:05:18', 4,'2021-11-28 17:00:00','2021-11-29 12:00:00','KH000003',NULL),
	('2021-11-29 18:05:30', 1,'2021-11-29 23:59:00','2021-11-30 23:59:00','KH000004',NULL),
	('2021-11-29 18:06:00', 1,'2021-11-30 00:00:00','2021-11-30 23:59:00','KH000001',NULL),
	('2021-11-01 12:06:00', 1,'2021-11-30 00:30:00','2021-12-21 23:59:00','KH000005','VIP tháng'),
	('2021-10-31 13:06:00', 2,'2021-11-22 10:35:03','2022-02-27 23:59:00','KH000003','Ưu đãi gia đình'),
	('2021-11-26 04:15:16', 5,'2021-11-27 00:00:20','2022-06-22 06:00:00','KH000007','Hoàng gia'),
	('2021-11-29 09:26:00', 2,'2021-12-30 00:00:00','2022-01-30 21:00:00','KH000006',NULL);






