CREATE OR REPLACE TYPE WM_CONCAT_IMPL_OLD
AUTHID CURRENT_USER AS OBJECT
(
  CURR_STR VARCHAR2(32767),
  STATIC FUNCTION ODCIAGGREGATEINITIALIZE(SCTX IN OUT WM_CONCAT_IMPL_OLD) RETURN NUMBER,
  MEMBER FUNCTION ODCIAGGREGATEITERATE(SELF IN OUT WM_CONCAT_IMPL_OLD,
               P1 IN VARCHAR2) RETURN NUMBER,
  MEMBER FUNCTION ODCIAGGREGATETERMINATE(SELF IN WM_CONCAT_IMPL_OLD,
                                 RETURNVALUE OUT VARCHAR2,
                                 FLAGS IN NUMBER)
                     RETURN NUMBER,
  MEMBER FUNCTION ODCIAGGREGATEMERGE(SELF IN OUT WM_CONCAT_IMPL_OLD,
                    SCTX2 IN  WM_CONCAT_IMPL_OLD) RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY WM_CONCAT_IMPL_OLD
IS
  STATIC FUNCTION ODCIAGGREGATEINITIALIZE(SCTX IN OUT WM_CONCAT_IMPL_OLD)
  RETURN NUMBER
  IS
  BEGIN
    SCTX := WM_CONCAT_IMPL_OLD(NULL) ;
    RETURN 0;
  END;


  MEMBER FUNCTION ODCIAGGREGATEITERATE(SELF IN OUT WM_CONCAT_IMPL_OLD,
          P1 IN VARCHAR2)
  RETURN NUMBER
  IS
  BEGIN
    IF(CURR_STR IS NOT NULL) THEN
      CURR_STR := CURR_STR || ',' || P1;
    ELSE
      CURR_STR := P1;
    END IF;
    RETURN 0;
  END;


  MEMBER FUNCTION ODCIAGGREGATETERMINATE(SELF IN WM_CONCAT_IMPL_OLD,
                                 RETURNVALUE OUT VARCHAR2,
                                 FLAGS IN NUMBER)
    RETURN NUMBER
  IS
  BEGIN
    RETURNVALUE := CURR_STR ;
    RETURN 0;
  END;


  MEMBER FUNCTION ODCIAGGREGATEMERGE(SELF IN OUT WM_CONCAT_IMPL_OLD,
                                   SCTX2 IN WM_CONCAT_IMPL_OLD)
  RETURN NUMBER
  IS
  BEGIN
    IF(SCTX2.CURR_STR IS NOT NULL) THEN
      SELF.CURR_STR := SELF.CURR_STR || ',' || SCTX2.CURR_STR ;
    END IF;
    RETURN 0;
  END;
END;
/
CREATE OR REPLACE FUNCTION WM_CONCAT_OLD(P1 VARCHAR2)
RETURN VARCHAR2 AGGREGATE USING  WM_CONCAT_IMPL_OLD;
/