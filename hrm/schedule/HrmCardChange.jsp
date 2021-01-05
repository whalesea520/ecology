<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
rs.executeSql(" select id , cardid from HrmValidateCardInfo ");
while ( rs.next() ) {
    String id = Util.null2String(rs.getString("id"));  
    String cardid = Util.null2String(rs.getString("cardid"));  

    if( cardid.length() == 10 ) {
        cardid = "" + Integer.parseInt( cardid.substring(6,10) ,16) ;
        rs.executeSql(" update HrmValidateCardInfo set cardid = '"+ cardid + "' where id = " + id );
    }
}

%>

It' OK !
