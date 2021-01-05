
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String operation = Util.null2String(request.getParameter("operation"));
String inputid = ""+Util.getIntValue(request.getParameter("inputid"),0);
String crmid = ""+Util.getIntValue(request.getParameter("crmid"),0);
String contactid = ""+Util.getIntValue(request.getParameter("contactid"),0);
String sql = "" ;
String inpreptablename = "" ;
String itemfieldname = "" ;
String itemfield = "";
String inprepid = "" ;
String tocrmid = "" ;
String toinputid = "" ;
String tocontactid = "" ;
String itemfieldtype = "" ;
Calendar todaycal = Calendar.getInstance ();
String reportdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
String field = "" ;
String chiefid = "" ;
int fromcount = 0 ;
boolean sendok = false;
if(operation.equals("add")){
    sql = "select inprepid from T_ResearchTable where inputid="+inputid ;
    rs.executeSql(sql) ;
    if(rs.next()) inprepid = rs.getString("inprepid") ;
    sql = "select inpreptablename from T_SurveyItem where inprepid="+inprepid ;
    rs.executeSql(sql) ;
    if(rs.next()) inpreptablename = rs.getString("inpreptablename") ;
    
    sql = " select inputid,crmid,contacterid from "+inpreptablename+" where inputid="+inputid+" and crmid="+crmid+" and contacterid="+contactid ;
    rs.executeSql(sql) ;
    
    if(rs.next()){
        toinputid = rs.getString("inputid") ;
        tocrmid = rs.getString("crmid") ;
        tocontactid = rs.getString("contactid") ; 
        
    }
    if(toinputid.equals("") && tocrmid.equals("") && tocontactid.equals("")) {
        sql = " INSERT INTO "+inpreptablename+" (crmid,contacterid,inputid,"+
                  " reportdate) VALUES "+ "                                                 ("+crmid+","+contactid+","+inputid+",'"+reportdate+"')" ;
        rs1.executeSql(sql) ;
        
        
        sql = "select itemfieldname,itemfieldtype from T_fieldItem where inprepid="+inprepid ;
        
        rs1.executeSql(sql) ;
        while(rs1.next()) {
            itemfieldname = rs1.getString("itemfieldname") ;
            itemfieldtype = rs1.getString("itemfieldtype") ;
            
            if(itemfieldtype.equals("1"))
                 field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
            if(itemfieldtype.equals("6"))
                 field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
            
            if(itemfieldtype.equals("2"))
                 field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
            
            if(itemfieldtype.equals("3"))
                 field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
            
            if(itemfieldtype.equals("4"))
                 field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
            
            if(itemfieldtype.equals("5")){
                String[] fields = request.getParameterValues(itemfieldname) ;
                
                if( fields != null ) {
                    String tofield = "" ;
                    String toofield = "" ;
                    for(int i=0; i<fields.length;i++){
                        tofield = fields[i];
                        toofield = toofield + tofield + "," ;
                        field = Util.fromScreen2(toofield,7) ;
                        field = field.substring(0,field.length()-1);
                    }
                }
            }
                
            sql = " UPDATE "+inpreptablename+" SET "+itemfieldname+"= '"+field+"' WHERE inputid="+inputid+" and crmid="+crmid+" and contacterid="+contactid;
            sendok = rs2.executeSql(sql) ;
            
            
        }
        sql = " UPDATE T_InceptForm SET state=2 WHERE crmid ="+crmid+ " and contacterid="+contactid ;
        rs1.executeSql(sql);

        sql = " select fromcount from T_ResearchTable where inputid ="+inputid ; 
        rs1.executeSql(sql) ;
        if(rs1.next()) fromcount = Util.getIntValue(rs1.getString("fromcount"),0) ;
        fromcount = fromcount + 1 ;
        sql = " UPDATE T_ResearchTable SET fromcount="+""+fromcount+ " WHERE inputid ="+inputid ;
        rs1.executeSql(sql);
    }else{
        if(!toinputid.equals(inputid) && !tocrmid.equals(crmid) && !tocontactid.equals(contactid)){

            sql = " INSERT INTO "+inpreptablename+" (crmid,contacterid,inputid,"+
                      " reportdate) VALUES "+ "                                                 ("+crmid+","+contactid+","+inputid+",'"+reportdate+"')" ;
            rs1.executeSql(sql) ;
            
            sql = "select itemfieldname,itemfieldtype from T_fieldItem where inprepid="+inprepid ;
            rs1.executeSql(sql) ;
            while(rs1.next()) {
                itemfieldname = rs1.getString("itemfieldname") ;
                itemfieldtype = rs1.getString("itemfieldtype") ;
                if(itemfieldtype.equals("1"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                if(itemfieldtype.equals("6"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("2"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("3"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("4"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("5")){
                    String[] fields = request.getParameterValues(itemfieldname) ;
                    if( fields != null ) {
                        String tofield = "" ;
                        String toofield = "" ;
                        for(int i=0; i<fields.length;i++){
                            tofield = fields[i];
                            toofield = toofield + tofield + "," ;
                            field = Util.fromScreen2(toofield,7) ;
                            field = field.substring(0,field.length()-1);
                        }
                    }
                }
                    
                sql = " UPDATE "+inpreptablename+" SET "+itemfieldname+"= '"+field+"' WHERE inputid="+inputid+" and crmid="+crmid+" and contacterid="+contactid;
                sendok = rs2.executeSql(sql) ;
                
            }
            sql = " UPDATE T_InceptForm SET state=2 WHERE crmid ="+crmid+ " and contacterid="+contactid ;
            rs1.executeSql(sql);

            sql = " select fromcount from T_ResearchTable where inputid ="+inputid ; 
            rs1.executeSql(sql) ;
            if(rs1.next()) fromcount = Util.getIntValue(rs1.getString("fromcount"),0) ;
            fromcount = fromcount + 1 ;
            sql = " UPDATE T_ResearchTable SET fromcount="+""+fromcount+ " WHERE inputid ="+inputid ;
            rs1.executeSql(sql);
        }else{
            if( crmid.equals("0") && contactid.equals("0") ) {
                crmid = "1" ;
                sql = "select max(crmid) from " + inpreptablename + " where inputid="+inputid ;
                rs3.executeSql(sql) ;
                if( rs3.next() ) crmid = "" + ( Util.getIntValue(rs3.getString(1),0) + 1 ) ;
                sql = " INSERT INTO "+inpreptablename+" (crmid,contacterid,inputid,reportdate) VALUES ("+crmid+","+contactid+","+inputid+",'"+reportdate+"')" ;
                rs1.executeSql(sql) ;
            }

            sql = "select itemfieldname,itemfieldtype from T_fieldItem where inprepid="+inprepid ;
            rs3.executeSql(sql) ;
            while(rs3.next()) {
                itemfieldname = rs3.getString("itemfieldname") ;
                itemfieldtype = rs3.getString("itemfieldtype") ;
                if(itemfieldtype.equals("1"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                if(itemfieldtype.equals("6"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("2"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("3"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("4"))
                     field = Util.fromScreen2(request.getParameter(itemfieldname),7) ;
                
                if(itemfieldtype.equals("5")){
                    String[] fields = request.getParameterValues(itemfieldname) ;
                    if( fields != null ) {
                        String tofield = "" ;
                        String toofield = "" ;
                        for(int i=0; i<fields.length;i++){
                            tofield = fields[i];
                            toofield = toofield + tofield + "," ;
                            field = Util.fromScreen2(toofield,7) ;
                            field = field.substring(0,field.length()-1);
                        }
                    }
                }
                    
                sql = " UPDATE "+inpreptablename+" SET "+itemfieldname+"= '"+field+"' WHERE inputid="+inputid+" and crmid="+crmid+" and contacterid="+contactid;
                sendok = rs4.executeSql(sql) ;
                
            }
        }
    }
}
if(sendok){
    response.sendRedirect("/CRM/investigate/OkForm.htm");    
}else{
    response.sendRedirect("/CRM/investigate/BaulkForm.htm");
}    
%>