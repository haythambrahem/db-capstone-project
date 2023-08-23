SELECT * FROM littlelemondb.bookings;

DELETE FROM littlelemondb.bookings;

INSERT INTO littlelemondb.bookings (BookingID, date, NumTable, CustomerID)
VALUES (1, '2022-10-10', 5, 1),
       (2, '2022-11-12', 3, 3),
       (3, '2022-10-11', 2, 2),
       (4, '2022-10-13', 2, 1);

DELIMITER //

CREATE PROCEDURE CheckBooking(IN bookingDate DATE, IN tableNumber INT)
BEGIN
    DECLARE bookingCount INT;
    
    -- Check if the table is already booked
    SELECT COUNT(*) INTO bookingCount
    FROM littlelemondb.bookings
    WHERE date = bookingDate AND NumTable = tableNumber;
    
    IF bookingCount > 0 THEN
        SELECT 'Table is already booked!' AS Result;
    ELSE
        SELECT 'Table is available.' AS Result;
    END IF;
END;
//

DELIMITER ;

DROP PROCEDURE IF EXISTS AddValidBooking;
call CheckBooking('2022-11-12',3)

DELIMITER //

CREATE PROCEDURE AddValidBooking(
    IN bookingDate DATE,
    IN tableNumber INT,
    IN customerID INT
)
BEGIN
    DECLARE bookingCount INT;
    
    START TRANSACTION;
    
    -- Check if the table is already booked
    SELECT COUNT(*) INTO bookingCount
    FROM littlelemondb.bookings
    WHERE date = bookingDate AND NumTable = tableNumber;
    
    IF bookingCount > 0 THEN
        -- Table is already booked, rollback the transaction
        ROLLBACK;
        SELECT 'Booking declined. Table is already booked.' AS Result;
    ELSE
        -- Table is available, insert the booking and commit the transaction
        INSERT INTO littlelemondb.bookings (date, NumTable, CustomerID)
        VALUES (bookingDate, tableNumber, customerID);
        COMMIT;
        SELECT 'Booking successful.' AS Result;
    END IF;
END;
//

DELIMITER ;

CALL AddValidBooking('2023-08-25', 4, 4); -- Replace with your desired booking date, table number, and customerID

DELIMITER //

CREATE PROCEDURE AddBooking(
    IN bookingID INT,
    IN customerID INT,
    IN bookingDate DATE,
    IN tableNumber INT
)
BEGIN
    INSERT INTO littlelemondb.bookings (BookingID, date, NumTable ,CustomerID)
    VALUES (bookingID, bookingDate, tableNumber, customerID);
    
    SELECT 'New Booking added!' AS Result;
END;
//

DELIMITER ;

CALL AddBooking(5, 4, '2023-08-25', 5); -- Replace with your desired parameter values

DELIMITER //

CREATE PROCEDURE UpdateBooking(
    IN bookingID INT,
    IN newBookingDate DATE
)
BEGIN
    UPDATE littlelemondb.bookings
    SET date = newBookingDate
    WHERE BookingID = bookingID;
    
    SELECT 'Booking updated successfully.' AS Result;
END;
//

DELIMITER ;
CALL UpdateBooking(4, '2022-08-26'); -- Replace with your desired parameter values

SELECT * FROM littlelemondb.bookings;
DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN bookingID INT
)
BEGIN
    DELETE FROM littlelemondb.bookings
    WHERE BookingID = bookingID;
    
    IF ROW_COUNT() > 0 THEN
        SELECT 'Booking cancelled successfully.' AS Result;
    ELSE
        SELECT 'No booking found with the given ID.' AS Result;
    END IF;
END;
//

DELIMITER ;


CALL CancelBooking(2); -- Replace with your desired booking ID

DROP PROCEDURE IF EXISTS CancelBooking;



