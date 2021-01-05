INSERT INTO workflow_billfield  ( billid , fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,viewtype ,detailtable ,fromUser ,textheight , dsporder ,childfieldid ,imgheight ,imgwidth ) VALUES ( 14 , 'cptspec' , 904 ,'varchar(50)' , '1' , 1 ,1 ,  '' , '1' ,null , 16 ,  null , null , null)
/
UPDATE workflow_billfield SET dsporder = 17 WHERE id = 329
/
UPDATE workflow_billfield SET dsporder = 18 WHERE id = 160
/
UPDATE workflow_billfield SET dsporder = 19 WHERE id = 161
/
Alter table bill_CptApplyDetail add( cptspec  varchar2(50))
/
CREATE OR REPLACE PROCEDURE bill_CptApplyDetail_Insert2 (cptapplyid 	integer, cpttype 	integer, cptid_1 	integer, number_2 	number , unitprice_3 	number, amount_4 	number, needdate_5 	Varchar2, purpose_6 	Varchar2 , cptdesc_7 	Varchar2 , capitalid_8 	integer,cptspec_9 	Varchar2, flag	out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO bill_CptApplyDetail ( cptapplyid, cpttype, cptid, number_n, unitprice, amount, needdate, purpose, cptdesc,capitalid,cptspec) VALUES ( cptapplyid, cpttype, cptid_1, number_2, unitprice_3, amount_4, needdate_5, purpose_6, cptdesc_7 , capitalid_8,cptspec_9); end;
/  
