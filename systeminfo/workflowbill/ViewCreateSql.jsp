<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 工作流单据SQL</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>
 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=workflowbillViewSqlform method=post action="WorkflowbillOperation.jsp">

  <BUTTON class=btn id=btnBack accessKey=D name=btnBack onclick="backSubmit()"><U>D</U>-返回</BUTTON>
  <br>
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
    <TR class=Section>
      <TH colSpan=5>SQL语句</TH>
    </TR>
    <TR class=Separator>
      <TD class=sep1 colSpan=5></TD>
    </TR>

  <input type=hidden name=operation>
<%
    String tablename = "";
    String detailtablename = "";
    String tabStr = "&nbsp;&nbsp;&nbsp;&nbsp;";
    String sqlStr = "";
    int id = Util.getIntValue(request.getParameter("id"),0);
    String sql = "select * from workflow_bill where id = "+id;
	rs.executeSql(sql);
    if(rs.next()){
        tablename = rs.getString("tablename")+"";
        detailtablename = Util.null2String(rs.getString("detailtablename"));
    }
    if(detailtablename.trim().equals("")){
        detailtablename = tablename+"Detail";
    }
    sql = "select distinct workflow_billfield.*,HtmlLabelIndex.id as indexid,HtmlLabelIndex.indexdesc as indexdesc from workflow_billfield left join HtmlLabelIndex on HtmlLabelIndex.id = fieldlabel where viewtype=0 and billid = "+id+"order by workflow_billfield.dsporder";
    boolean isEmpty = true;
    sqlStr = "CREATE TABLE "+tablename+" ( <br>";
    sqlStr += tabStr+"id int IDENTITY,<br>";
    rs.executeSql(sql);
    String name = "";
    String dbtype = "";
    while(rs.next()){
        name = Util.null2String(rs.getString("fieldname"));
        dbtype = Util.null2String(rs.getString("fielddbtype"));
        sqlStr += tabStr+name+" "+dbtype+",<br>";
        isEmpty = false;
    }
    //sqlStr = sqlStr.substring(0,sqlStr.lastIndexOf(","));
    if(!isEmpty){
        sqlStr += tabStr+"requestid int) <br> GO";
    }else{
        sqlStr = "";
    }
%>
  <TR>
     <TD Class=Field bgcolor="#00ccbb"><%=sqlStr%></TD>
  </TR>
<%
    sql = "select distinct workflow_billfield.*,HtmlLabelIndex.id as indexid,HtmlLabelIndex.indexdesc as indexdesc from workflow_billfield left join HtmlLabelIndex on HtmlLabelIndex.id = fieldlabel where viewtype=1 and billid = "+id+"order by workflow_billfield.dsporder";
    isEmpty = true;
    sqlStr = "CREATE TABLE "+detailtablename+" ( <br>";
    sqlStr += tabStr+"id int,<br>";
    rs.executeSql(sql);
    while(rs.next()){
        name = Util.null2String(rs.getString("fieldname"));
        dbtype = Util.null2String(rs.getString("fielddbtype"));
        sqlStr += tabStr+name+" "+dbtype+",<br>";
        isEmpty = false;
    }
    if(!isEmpty){
        sqlStr = sqlStr.substring(0,sqlStr.lastIndexOf(","));
        sqlStr += ") <br> GO";
    }else{
        sqlStr = "";
    }
%>
  <TR>

     <TD Class=Field bgcolor="#00ccbb"><%=sqlStr%></TD>
  </TR>

<%
    sql = "select distinct workflow_billfield.*,HtmlLabelIndex.id as indexid,HtmlLabelIndex.indexdesc as indexdesc from workflow_billfield left join HtmlLabelIndex on HtmlLabelIndex.id = fieldlabel where viewtype=1 and billid = "+id+"order by workflow_billfield.dsporder";
    isEmpty = true;
    sqlStr = "CREATE PROCEDURE "+detailtablename+"_Insert <br>"+tabStr+"(@id_1 int,<br>";
    String sqlStr2 = "AS INSERT INTO "+detailtablename+"<br>"+tabStr+"(id,<br>";
    String sqlStr3 = "VALUES <br>"+tabStr+"(@id_1,<br>";
    rs.executeSql(sql);
    int i=2;
    while(rs.next()){
        name = Util.null2String(rs.getString("fieldname"));
        dbtype = Util.null2String(rs.getString("fielddbtype"));
        sqlStr += tabStr+"@"+name+"_"+i+" "+dbtype+",<br>";
        sqlStr2 += tabStr+name+",<br>";
        sqlStr3 += tabStr+"@"+name+"_"+i+",<br>";
        i++;
        isEmpty = false;
    }
    sqlStr += tabStr+"@flag int output,<br> "+tabStr+"@msg varchar(80) output)<br>";

    if(!isEmpty){
        sqlStr2 = sqlStr2.substring(0,sqlStr2.lastIndexOf(","))+")<br>";
        sqlStr3 = sqlStr3.substring(0,sqlStr3.lastIndexOf(","))+")<br>GO";
    }else{
        sqlStr=sqlStr2=sqlStr3="";
    }
%>
  <TR>

     <TD Class=Field bgcolor="#00ccbb"><%=sqlStr+sqlStr2+sqlStr3%></TD>
  </TR>

</body>
<script language=javascript>
  function backSubmit(){
    location = "ViewWorkflowbill.jsp?id=<%=id%>";
  }

</script>
</html>