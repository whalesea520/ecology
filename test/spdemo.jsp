
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

    String selectStyle = request.getParameter("selectStyle");
    String selectType  = request.getParameter("selectType");
    String pagesize = request.getParameter("txtPagesize");

    if (selectStyle==null)  selectStyle="splitpage_lightGray_wev8.css";
    if (selectType==null)  selectType="checkbox";
    if (pagesize==null)  pagesize="15";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>xmltable-dongping </title>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<body>
<%                                 

String backfields = "t1.requestid, t1.createdate, t1.createtime,t1.lastoperatedate, t1.lastoperatetime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t3.multiSubmit";
String fromSql  = "from workflow_requestbase t1,workflow_currentoperator t2 ,workflow_base t3 ";
String sqlWhere = "where t1.requestid = t2.requestid and t2.userid = 1 and t2.usertype=0 and  (t1.deleted = 0 or t1.deleted is null )   and t1.workflowid=t3.id  and t1.workflowid=t3.id ";                           
String tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\""+selectType+"\" pagesize=\""+pagesize+"\" >"+   
         "	        <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"t1.creater\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqldistinct=\"true\"/>"+
         "			<head>"+
         "				<col width=\"20%\"  text=\"列1\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" />"+ 
         "				<col width=\"10%\"  text=\"列2\" column=\"creater\" orderkey=\"t1.creater\"   />"+ 
         "				<col width=\"15%\"  text=\"列3\" column=\"workflowid\" orderkey=\"t1.workflowid\" />"+ 
         "				<col width=\"10%\"  text=\"列4\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" />"+
         "				<col width=\"25%\"  text=\"列5\" column=\"requestname\" orderkey=\"t1.requestname\" href =\"/workflow/request/ViewRequest.jsp\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" />"+
         "			  <col width=\"10%\"  text=\"列6\" column=\"createdate\" orderkey=\"t1.createdate\"  />"+
         "			  <col width=\"10%\"  text=\"列7\" column=\"status\" orderkey=\"t1.status\" />"+
         "			</head>"+   			
         "</table>";  
 %>
   <wea:SplitPageTag  tableInstanceId=""  tableString='<%=tableString%>'  mode="run" selectedstrs="" tableInfo="ok ,this info!" showExpExcel="true"/>

    <br>
    <form name="frmStyle" action="" method="post">
    <TABLE>
     <TR>
        <TD>选择类型</TD>
        <TD>
            <SELECT NAME="selectType">
                <OPTION value="none">none</OPTION>
               <OPTION selected value="checkbox">checkbox</OPTION>
               <OPTION value="radio">radio</OPTION>             
            </SELECT>
              
        </TD>

    	
        <TD>填写第显示条数</TD>
        <TD>
            <input value="<%=pagesize%>" type="input" name="txtPagesize" size="3">&nbsp;<input type=submit value="确定">              
        </TD>
    	<TD></TD>
    	
    </TR>
    <TR>
    	<TD> <INPUT TYPE=button ID=btnEmergency VALUE="checkbox id" onClick=alert(_xtable_CheckedCheckboxId())></TD>
        <TD><INPUT TYPE=button ID=btnEmergency VALUE="checkbox value" onClick=alert(_xtable_CheckedCheckboxValue())></TD>
    	<TD><INPUT TYPE=button ID=btnEmergency VALUE="Clean  checkbox" onClick=_xtable_CleanCheckedCheckbox()>   </TD>
        <TD> <INPUT TYPE=button ID=btnEmergency VALUE="radio    id"  onClick=alert(_xtable_CheckedRadioId())></TD>
    	<TD><INPUT TYPE=button ID=btnEmergency VALUE="radio  value"  onClick=alert(_xtable_CheckedRadioValue())></TD>
    	<TD><INPUT TYPE=button ID=btnEmergency VALUE="Clean   radio"  onClick=_xtable_CleanCheckedRadio()></TD>    	
    </TR>  
    </TABLE>
   </form>
</body>
</html>
