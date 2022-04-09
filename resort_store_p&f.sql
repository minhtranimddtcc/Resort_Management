USE hotel_california;

-- 2.1.1 PROCEDURE 1
DROP PROCEDURE IF EXISTS GoiDichVu;
DELIMITER #
CREATE PROCEDURE GoiDichVu (
    IN  customerID    CHAR(8)
)
BEGIN
    DECLARE currentDate DATETIME;
    SET currentDate = CURDATE();
    SELECT a.packetName AS 'Tên gói',
        b.numberOfGuest AS 'Số khách',
        a.startDate AS 'Ngày bắt đầu',
        CONVERT(DATE_ADD(startDate, INTERVAL 1 YEAR), DATETIME) AS 'Ngày hết hạn',
        GREATEST(
            LEAST(
                DATEDIFF(CONVERT(DATE_ADD(startDate, INTERVAL 1 YEAR), DATETIME), currentDate),
                numberOfDay - DATEDIFF(checkOutDate, checkInDate)
            ),
        0) AS 'Số ngày sử dụng còn lại'
    FROM servicePacketInvoice a
    LEFT JOIN servicePacket b
    ON a.packetName = b.name
    INNER JOIN reservation c
    ON (a.customerID, a.packetName) = (c.customerID, c.packetName)
    WHERE a.customerID = customerID;
END#
DELIMITER ;

-- 2.1.2 PROCEDURE 2
DROP PROCEDURE IF EXISTS ThongKeLuotKhach;
DELIMITER #
CREATE PROCEDURE ThongKeLuotKhach (
    IN  branchID     VARCHAR(5),
    IN  year         YEAR
)
BEGIN
    SELECT MONTH(checkInDate) AS "Tháng", IFNULL(SUM(numberOfGuest), 0) AS "Tổng số lượt khách"
    FROM reservation
    WHERE YEAR(checkInDate) = year
    AND ID IN (
        SELECT reservationID
        FROM rentedRoom rR
        WHERE rR.branchID = branchID
    )
    GROUP BY MONTH(checkInDate)
    ORDER BY MONTH(checkInDate) ASC;
END#
DELIMITER ;

-- 2.2.1 TRIGGER 1
-- 2.2.1.1 & 2.2.2 TRIGGER 1.1 & 2
DROP TRIGGER IF EXISTS triggerServicePacketInvoiceBI;
DELIMITER #
CREATE TRIGGER triggerServicePacketInvoiceBI
BEFORE INSERT ON servicePacketInvoice
FOR EACH ROW
BEGIN
    /* TRIGGER 2 */
    IF EXISTS (
       SELECT packetName
        FROM servicePacketInvoice
        WHERE packetName = NEW.packetName
        AND customerID = NEW.customerID
        AND DATEDIFF(NEW.startDate,startDate) < 365
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Warning: This packet is still within the expiry date!!!';
    END IF;
    
    /* TRIGGER 1.1 */
    SELECT price,numberOfDay FROM servicePacket WHERE name = NEW.packetName INTO @cost,@remainingDay;
    SELECT type FROM customer WHERE ID = NEW.customerID INTO @type;
	IF (@type = 3)
        THEN BEGIN
            SET @remainingDay = @remainingDay + 1;
            SET @cost = @cost * 0.85;
        END;
	ELSEIF (@type = 4)
		THEN BEGIN
            SET @remainingDay = @remainingDay + 2;
            SET @cost = @cost * 0.8;
        END;
	END IF;
    SET NEW.totalCost = @cost;
    SET NEW.remainingDay = @remainingDay;
END#
DELIMITER ;

-- 2.2.1.2 TRIGGER 1.2
DROP TRIGGER IF EXISTS triggerRentedRoomAI;
DELIMITER #
CREATE TRIGGER triggerRentedRoomAI
AFTER INSERT ON rentedRoom
FOR EACH ROW
BEGIN
	SELECT branchID,roomTypeID FROM room WHERE branchID = NEW.branchID AND ID = NEW.roomID INTO @branchID,@roomTypeID;
    SELECT rentFee FROM roomTypeOfBranch WHERE roomTypeID = @roomTypeID AND branchID = @branchID INTO @fee;
    SELECT customerID,packetName FROM reservation WHERE ID = NEW.reservationID INTO @customerID, @packetName;
    SELECT DATEDIFF(checkOutDate,checkInDate) FROM reservation WHERE ID = NEW.reservationID INTO @guestStay;
    SELECT type FROM customer WHERE ID = @customerID INTO @type;
    IF (@packetName != NULL) THEN SET @totalCost = 0;
	ELSEIF (@type = 1) THEN SET @totalCost = @fee;
	ELSEIF (@type = 2) THEN SET @totalCost = @fee * 0.9;
	ELSEIF (@type = 3) THEN SET @totalCost = @fee * 0.85;
	ELSE SET @totalCost = @fee * 0.8;
	END IF;
    UPDATE reservation
    SET totalCost = @totalCost * @guestStay
    WHERE ID = NEW.reservationID;
END#
DELIMITER ;

-- 2.2.1.3 TRIGGER 1.3
DROP TRIGGER IF EXISTS triggerReservationAU;
DELIMITER $$
CREATE TRIGGER triggerReservationAU
    AFTER UPDATE
    ON reservation FOR EACH ROW
BEGIN
    IF OLD.status = '0' AND NEW.status = '1' THEN
        UPDATE customer
        SET point = point + FLOOR(NEW.totalCost/1000)
        WHERE ID = NEW.customerID;
    END IF;
END$$    
DELIMITER ;

DROP TRIGGER IF EXISTS triggerReservationAI;
DELIMITER $$
CREATE TRIGGER triggerReservationAI
    AFTER INSERT
    ON reservation FOR EACH ROW
BEGIN
    IF NEW.status = '1' THEN
        UPDATE customer
        SET point = point + FLOOR(NEW.totalCost/1000)
        WHERE ID = NEW.customerID;
    END IF;
END$$    
DELIMITER ;

DROP TRIGGER IF EXISTS triggerServicePacketInvoiceAI;
DELIMITER $$
CREATE TRIGGER triggerServicePacketInvoiceAI
    AFTER INSERT
    ON servicePacketInvoice FOR EACH ROW
BEGIN
    UPDATE customer
    SET point = point + FLOOR(NEW.totalCost/1000)
    WHERE ID = NEW.customerID;
END$$    
DELIMITER ;


-- 2.2.1.4 TRIGGER 1.4
/**/
DROP TRIGGER IF EXISTS triggerCustomerBU;
DELIMITER $$
CREATE TRIGGER triggerCustomerBU
    BEFORE UPDATE
    ON customer FOR EACH ROW
BEGIN
    IF OLD.type = 1 AND NEW.point >= 50 THEN
        SET NEW.type = 2;
    END IF;
    IF OLD.type = 2 AND NEW.point >= 100 THEN
        SET NEW.type = 3;
    END IF;
    IF OLD.type = 3 AND NEW.point >= 1000 THEN
        SET NEW.type = 4;
    END IF;
END$$    
DELIMITER ;
/**/


-- Test PROCEDURE 1
CALL GoiDichVu("KH000001");


-- Test PROCEDURE 2
CALL ThongKeLuotKhach("CN1", "2021");

-- Test TRIGGER 1

