USE hotel_california;

/* Unlock event by add close-command-mark at the end of this line

DROP EVENT IF EXISTS eventDeleteReservation;
DELIMITER #
CREATE EVENT eventDeleteReservation
ON SCHEDULE EVERY 1 HOUR
DO BEGIN
    DELETE FROM reservation
    WHERE TIMESTAMPDIFF(HOUR, NOW(), checkInDate) < 36
    AND status = '0';
END#
DELIMITER ;


DROP EVENT IF EXISTS eventCancelReservation;
DELIMITER #
CREATE EVENT eventCancelReservation
ON SCHEDULE EVERY 1 HOUR
DO BEGIN
    SET @rentDay = DATEDIFF(checkOutDate, checkInDate);
    UPDATE reservation
    SET status = '2' AND totalCost = totalCost*(@rentDay - 1)/@rentDay
    WHERE status = '1'
    AND TIMESTAMPDIFF(HOUR, NOW(), checkInDate) < 24
    AND NOT EXISTS (
        SELECT *
        FROM invoice
        WHERE reservationID = reservation.ID
    );
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerReservationBU;
DELIMITER #
CREATE TRIGGER triggerReservationBU
BEFORE UPDATE ON reservation
FOR EACH ROW
BEGIN
    IF (OLD.status = '1' AND NEW.status = '2'
        AND TIMESTAMPDIFF(HOUR, NOW(), checkInDate) < 24)
    THEN BEGIN
        SET @rentDay = DATEDIFF(checkOutDate, checkInDate);
        SET NEW.totalCost = NEW.totalCost*(@rentDay - 1)/@rentDay;
    END;
    END IF;
END#
DELIMITER ;
/**/


DROP PROCEDURE IF EXISTS PhongDaThue;
DELIMITER #
CREATE PROCEDURE PhongDaThue (
    IN  customerID      CHAR(8),
    IN  phoneNumber     VARCHAR(15),
    IN  IDCardNumber    VARCHAR(12)
)
BEGIN
    SELECT r.ID AS "Mã phòng", r.branchID AS "Chi nhánh", r.sectorName AS "Khu",
        rT.name AS "Loại phòng", rT.area AS "Diện tích", rst.status AS "Tình trạng"
    FROM reservation rst
    JOIN rentedRoom rR ON rst.ID = rR.reservationID
    JOIN room r ON (rR.roomID = r.ID AND rR.branchID = r.branchID)
    JOIN roomType rT ON r.roomTypeID = rT.ID
    WHERE rst.customerID IN (
        SELECT ID
        FROM customer c
        WHERE c.IDCardNumber = IDCardNumber
        AND c.ID = customerID
        AND c.phoneNumber = phoneNumber
    );
END#
DELIMITER ;


-- DROP PROCEDURE IF EXISTS ThongKeThang;
-- DELIMITER #
-- CREATE PROCEDURE ThongKeThang (

-- )
-- BEGIN
--     SELECT branchID, SUM(totalCost), SUM(numberOfGuest) 
--     FROM rentedRoom a
--     LEFT JOIN reservation b ON a.reservationID = b.ID
--     GROUP BY (branchID);
-- END#
-- DELIMITER ;


DROP USER IF EXISTS 'sManager'@'localhost';
CREATE USER 'sManager'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
GRANT ALL PRIVILEGES ON hotel_california.* TO 'sManager'@'localhost';
FLUSH PRIVILEGES;
#SHOW GRANTS FOR 'sManager'@'localhost';
#2a
DROP PROCEDURE IF EXISTS getCustomerInfo;
DELIMITER $$
CREATE 
	PROCEDURE getCustomerInfo ()
    BEGIN
		SELECT ID,name,IDCardNumber,phoneNumber,email,username,point,type FROM customer;
	END $$
DELIMITER ;

#2b
DROP PROCEDURE IF EXISTS getCustomerInfoByName;
DELIMITER $$
CREATE 
	PROCEDURE getCustomerInfoByName (IN nameIn VARCHAR(100))
    BEGIN
		SELECT ID,IDCardNumber,name,phoneNumber,email,username,point,type 
        FROM customer
        WHERE LOWER(name) LIKE CONCAT("%",LOWER(nameIn),"%");
	END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS getCustomerReservation;
DELIMITER $$
CREATE 
	PROCEDURE getCustomerReservation (IN customerID CHAR(8))
    BEGIN
		SELECT ID,DATE_FORMAT(bookingDate,"%d/%m/%Y %H:%i") AS "bookingDate",
            numberOfGuest,DATE_FORMAT(checkInDate,"%d/%m/%Y %H:%i") AS "checkInDate",
            DATE_FORMAT(checkOutDate,"%d/%m/%Y %H:%i") AS "checkOutDate",status,totalCost
        FROM reservation AS r
        WHERE r.customerID = customerID AND r.checkInDate >= CURDATE();
	END $$
DELIMITER ;

#2c
DROP PROCEDURE IF EXISTS insertRoomType;
DELIMITER $$
CREATE 
	PROCEDURE insertRoomType 
    (
		roomTypeName 	VARCHAR(50),
        roomArea      	FLOAT,
        numberOfGuest   INT,
        description     VARCHAR(100)
	)
    BEGIN
		INSERT INTO roomType(name,area,numberOfGuest,description)
        VALUES (roomTypeName,roomArea,numberOfGuest,description);
        SELECT ID FROM roomType AS r WHERE r.name = roomTypeName;
	END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS insertBedInfo;
DELIMITER $$
CREATE 
	PROCEDURE insertBedInfo 
    (
		roomTypeID		INT,
		size            DECIMAL(2,1),
		quantity        INT
	)
    BEGIN
		INSERT INTO bedInfo(roomTypeID,size,quantity)
        VALUES (roomTypeID,size,quantity);
	END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS insertSupplyTypeInRoomType;
DELIMITER $$
CREATE 
	PROCEDURE insertSupplyTypeInRoomType 
    (
		nameSupplyType	VARCHAR(50),
		roomTypeID      INT,
		quantity        INT
	)
    BEGIN
		SELECT ID FROM supplyType WHERE name = nameSupplyType INTO @supplyTypeID;
		INSERT INTO supplyTypeInRoomType(supplyTypeID,roomTypeID,quantity)
        VALUES (@supplyTypeID,roomTypeID,quantity);
	END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS getSupplyType;
DELIMITER $$
CREATE 
	PROCEDURE getSupplyType()
    BEGIN
		SELECT * FROM supplyType;
	END $$
DELIMITER ;

-- Extra
/*
DROP PROCEDURE IF EXISTS getBranch;
DELIMITER $$
CREATE 
	PROCEDURE getBranch 
    (

	)
    BEGIN
		SELECT * 
        FROM branch
        LEFT JOIN branchImage
        ON branch.ID = branchImag
	END $$
DELIMITER ;
/**/