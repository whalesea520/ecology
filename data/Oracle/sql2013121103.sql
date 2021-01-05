ALTER TABLE MailResource ADD timingdate VARCHAR(30)
/

ALTER TABLE MailResource ADD timingdatestate INT
/

ALTER TABLE MailResource ADD needReceipt INT
/

ALTER TABLE MailAccount ADD receiveScope INT 
/

ALTER TABLE MailAccount ADD receiveDateScope VARCHAR(50)
/

ALTER TABLE MailResource ADD recallState CHAR(1) 
/

ALTER TABLE MailResource ADD receiveNeedReceipt CHAR(1) 
/

CREATE TABLE MailAutoRespond
(
  id          INTEGER,
  userId      INTEGER NULL,
  isAuto      CHAR (1) NULL,
  isContactReply CHAR(1) NULL,
  content     CLOB NULL
)
/