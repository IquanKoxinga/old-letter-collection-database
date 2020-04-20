use collection;

CREATE INDEX idx_firstname
ON people (PEOPLE_FNAME);

CREATE INDEX idx_lastname
ON people (PEOPLE_LNAME);

create view jobsdetail as
SELECT  CONCAT(pl.PEOPLE_LNAME, ' ',pl.PEOPLE_FNAME) AS PEOPLE_NAME,
	    cp.COMPANY_TYPE,
        cp.COMPANY_name,
        lc.LOCATION_DESCRIPTION
FROM employment ep
    INNER JOIN PEOPLE pl ON (pl.PEOPLE_ID = ep.PEOPLE_ID) 
    INNER JOIN company cp ON (cp.company_ID = ep.company_ID) 
	inner join location lc on cp.LOCATION_ID = lc.location_id;
    
select * from jobsdetail;

create view letterbrief as
SELECT  l.letter_createdyear, CONCAT(pls.PEOPLE_LNAME, ' ',pls.PEOPLE_FNAME) AS sender_NAME, 
        CONCAT(plr.PEOPLE_LNAME, ' ',plr.PEOPLE_FNAME) AS receiver_NAME,
	    tp.topic_description        
FROM express ex
    INNER JOIN letter l ON (l.letter_id = ex.letter_ID) 
    INNER JOIN topic tp ON (ex.topic_ID = tp.TOPIC_ID) 
	inner join people pls on pls.PEOPLE_ID = l.SENDER_ID
    inner join people plr on plr.PEOPLE_ID = l.RECEIVER_ID;
    
DROP PROCEDURE GETCOMPANY;
DELIMITER //
CREATE procedure GETCOMPANY(
	IN COMPANYNAME VARCHAR(32)
)
BEGIN
	SELECT CP.COMPANY_NAME, CP.COMPANY_TYPE, PL.PEOPLE_FNAME, PL.PEOPLE_LNAME  
    FROM COMPANY CP
		INNER JOIN employment EMP ON EMP.COMPANY_ID = CP.COMPANY_ID
        INNER JOIN PEOPLE PL ON PL.PEOPLE_ID = EMP.PEOPLE_ID
    WHERE COMPANY_NAME LIKE COMPANYNAME;
END //

DELIMITER ;
CALL GETCOMPANY('%Donglai%');

DELIMITER $$
CREATE PROCEDURE GetLetterByCreatedtime (
IN Createdtime int)
BEGIN 
SELECT LETTER_TITLE, LETTER_CREATEDYEAR, LETTER_LINK
FROM LETTER
WHERE Createdtime = LETTER_CREATEDYEAR;
END $$
DELIMITER ;
CALL GetLetterByCreatedtime (1903);
