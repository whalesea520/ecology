CREATE OR REPLACE FUNCTION SplitStr  
   (src VARCHAR2, delimiter varchar2)  
  RETURN mytable IS  
  psrc VARCHAR2(4000);  
  a mytable := mytable();  
  i NUMBER := 1;  
  j NUMBER := 1;  
BEGIN  
  psrc := RTrim(LTrim(src, delimiter), delimiter);  
  LOOP  
    i := InStr(psrc, delimiter, j);   
    IF i>0 THEN  
      a.extend;  
      a(a.Count) := Trim(SubStr(psrc, j, i-j));  
      j := i+1;  
    END IF;  
    EXIT WHEN i=0;  
  END LOOP;  
  IF j < Length(psrc) THEN  
    a.extend;  
    a(a.Count) := Trim(SubStr(psrc, j, Length(psrc)+1-j));  
  END IF;  
  RETURN a;  
END;
/