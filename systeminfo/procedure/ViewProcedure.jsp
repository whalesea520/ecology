<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<%
	String id = Util.null2String(request.getParameter("id"));
	String procedurename = "";
	String proceduretable = "";
	String procedurescript = "";
	String proceduredesc = "";
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function confirmdel() {
	return confirm("确定删除选定的信息吗?") ;
}
</script>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 存储过程</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="ProcedureOperation.jsp">
    <input type="hidden" name="operation" value="deleteprocedure">
    <input type="hidden" name="delete_procedure_id" value="<%=id%>">
    <BUTTON class=btn id=btnEdit accessKey=E name=btnEdit onclick="editprocedure()"><U>E</U>-编辑</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteprocedure()"><U>D</U>-删除</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addprocedure()"><U>A</U>-添加</BUTTON>
    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
          <TR class=Section> 
    <TH colSpan=2>存储过程信息</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
<%
RecordSet.executeProc("ProcedureInfo_SelectByID",id);
if(RecordSet.next())  {
	procedurename = Util.toScreen(RecordSet.getString("procedurename"),user.getLanguage()) ;
	proceduretable = Util.toScreen(RecordSet.getString("proceduretabel"),user.getLanguage()) ;
	procedurescript = Util.toScreen(RecordSet.getString("procedurescript"),user.getLanguage()) ;
	proceduredesc = Util.toScreen(RecordSet.getString("proceduredesc"),user.getLanguage()) ;
}
%>
    <TR> 
      <TD>名称</TD>
      <TD Class=Field><%=procedurename%></TD>
    </TR>
    <tr> 
      <td>相关的表</td>
      <td class=Field><%=proceduretable%></td>
    </tr>
    <tr> 
      <td>脚本</td>
      <td class=Field><%=procedurescript%></td>
    </tr>
    <TR> 
      <TD>描叙</TD>
      <TD Class=Field><%=proceduredesc%></TD>
    </TR>
    </TBODY> 
	</TABLE>
      </FORM>
<script>
function deleteprocedure(){
	if(confirmdel()) {
		document.frmView.submit();
	}
}
function addprocedure() {	
	location="AddProcedure.jsp";
}
function editprocedure() {	
	location="EditProcedure.jsp?id=<%=id%>";
}
</script>
      </BODY>
      </HTML>
