
USE guest;
DROP TABLE IF EXISTS ACCOUNT;

CREATE TABLE ACCOUNT
(
  AccountId INT PRIMARY KEY,
  Value INT
);

INSERT INTO ACCOUNT(AccountId, Value)
VALUES (1, 100), (2, 200), (3, 300), (4,400), (5,500);

DROP PROCEDURE IF EXISTS transfer;

DELIMITER $
CREATE PROCEDURE transfer(IN id1 INT, IN id2 INT, IN amount INT, OUT done BOOLEAN)
BEGIN
  DECLARE val1 INT;
  DECLARE val2 INT;

  select Value INTO val1
  from ACCOUNT WHERE AccountId = id1;

  select Value INTO val2
  from ACCOUNT WHERE AccountId = id2;

  START TRANSACTION;

  UPDATE ACCOUNT SET Value = Value - amount WHERE AccountId = id1;
  UPDATE ACCOUNT SET Value = Value + amount WHERE AccountId = id2;

  IF val1 IS NOT NULL AND val2 IS NOT NULL AND val1 >= amount AND id1 != id2 THEN
    COMMIT;
    SET done = TRUE;
  ELSE
    ROLLBACK;
    SET done = FALSE;
  END IF;
END $

DELIMITER ;
