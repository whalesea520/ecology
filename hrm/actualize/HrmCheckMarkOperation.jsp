<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation")); 
String id = Util.null2String(request.getParameter("id"));  
String checkpeopleid = Util.null2String(request.getParameter("checkpeopleid")) ;
String checktypeid = Util.null2String(request.getParameter("checktypeid")) ;

char separator = Util.getSeparator() ;  
String para = "" ;
String sql = "" ;
double resultsum = 0;

sql = "delete from HrmCheckGrade where checkpeopleid = "+checkpeopleid;
rs.executeSql(sql);
if(operation.equalsIgnoreCase("AddCheck")){ 
    sql = "select checkitemid , checkitemproportion from HrmCheckKindItem where checktypeid="+checktypeid;
    rs.executeSql(sql) ;
    while(rs.next()){  
        String checkitemid = Util.null2String(rs.getString("checkitemid"));
        String result = Util.null2String(request.getParameter("result_"+checkitemid)).trim() ;
        String checkitemproportion = Util.null2String(rs.getString("checkitemproportion"));
        
        double resultdou = Util.getDoubleValue(result);
        double checkitemproportiondou = Util.getDoubleValue(checkitemproportion);

        resultsum +=  resultdou * checkitemproportiondou /100.00 ;
        rs.executeSql("insert into HrmCheckGrade (checkpeopleid,checkitemid,result,checkitemproportion) values ("+checkpeopleid+","+checkitemid+", "+(result.length()==0?"0.0":result)+","+checkitemproportion+")");
        
    }
    
    Calendar todaycal = Calendar.getInstance ();
    String lastmodifydate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                            Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                            Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;

    para = checkpeopleid + separator + resultsum + separator+ lastmodifydate ;
    rs.executeProc("HrmByCheckPeople_Update",para); 
  
    response.sendRedirect("/hrm/actualize/HrmCheckMark.jsp?isclose=1&id="+checkpeopleid);
   
} 
%>