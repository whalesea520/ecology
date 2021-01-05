<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//add by wjy
    String temName = Util.null2String(request.getParameter("lastname"));
    String checkMessage = "";
    boolean isCheckHas = false;
    String tempSql = "";
    if(!temName.equals("")){
        tempSql = "select lastname from HrmCareerApply where lastname='"+temName+"'";
        rs.executeSql(tempSql);
        if(rs.next()){
            checkMessage = SystemEnv.getHtmlLabelName(83457, 7);
            isCheckHas = true;
        }
    }

    //end
%>
<HTML>
<HEAD>
<SCRIPT language="javascript">
function reUpdate(){
<%
    if(isCheckHas){
%>
    result=confirm("<%=checkMessage%>");
    if(result)
    parent.checkPass();
<%
    }else{
%>
    parent.checkPass();
<%
    }
%>
}
</script>
</HEAD>
<BODY onload="reUpdate()">
aaaa
</BODY>
</HTML>