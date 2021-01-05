<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<%
	String searchcon="";
	searchcon = Util.toScreen(request.getParameter("searchcon"),user.getLanguage(),"0");
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function CheckAll(checked) {
len = document.frmDelete.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.frmDelete.elements[i].name=='delete_procedure_id') {
document.frmDelete.elements[i].checked=(checked==true?true:false);
} } }


function unselectall()
{
    if(document.frmDelete.checkall0.checked){
	document.frmDelete.checkall0.checked =0;
    }
}
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
    <TD align=left width=55><IMG height=24 src="/images/hdDOCSearch_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 存储过程</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
    <FORM style="MARGIN-TOP: 0px" name=frmSearch method=post action="ManageProcedure.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit onclick="searchprocedure()"><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addprocedure()"><U>A</U>-添加</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteprocedure()"><U>D</U>-删除</BUTTON>
    <br>
	 
        <TABLE class=Form>
          <COLGROUP> <COL width="5%"> <COL width="32%"> <COL width=1> <COL width="10%"> <COL width="32%"> <TBODY> 
          <TR class=Section> 
            <TH colSpan=5>搜索条件</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
          <TR> 
            <TD>存储过程名称</TD>
            <TD Class=Field colspan=4> 
              <INPUT class=FieldxLong name=searchcon accessKey=Z value="<%=searchcon%>">
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
	  </form>
      <br>
	  <FORM style="MARGIN-TOP: 0px" name=frmDelete method=post action="ProcedureOperation.jsp">
	  <input type="hidden" name="operation" value="deleteprocedure">
        <TABLE class=Form>
          <COLGROUP> <COL width="10%"> <COL width="30%"> <COL width="30%"> <COL width="30%"><TBODY> 
          <TR class=Section> 
            <TH colSpan=5>搜索结果</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep2 colSpan=4></TD>
          </TR>
          <TR> 
            <Td Class=Field></Td>
            <Td Class=Field>标识</Td>
            <Td Class=Field>描叙</Td>
            <Td Class=Field>细节</Td>
          </TR>
<%
RecordSet.executeProc("ProcedureInfo_Select","%"+searchcon+"%");
while(RecordSet.next())
{
		String id = RecordSet.getString(1);
		String procedurename = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
%>
         <TR> 
            <TD><input type="checkbox" name="delete_procedure_id" value="<%=id%>" onClick=unselectall()></TD>
            <TD><%=id%></TD>
            <TD><%=procedurename%></TD>
            <TD><a href="ViewProcedure.jsp?id=<%=id%>"><img src="/images/iedit_wev8.gif" width="16" height="16" border="0"></a></TD>
          </TR>
    
<%
}
%>
		  <TR class=Separator> 
            <TD class=sep2 colSpan=4></TD>
          </TR>
          </TBODY> 
        </TABLE>
        <br>
        <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">全部选中
      </FORM>
<script>
function addprocedure() {	
	location="AddProcedure.jsp";
}
function searchprocedure() {
	document.frmSearch.submit();
}
function deleteprocedure() {
	if(confirmdel())
		document.frmDelete.submit();
}
</script>
      </BODY>
      </HTML>
