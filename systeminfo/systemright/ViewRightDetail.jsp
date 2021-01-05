<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page"/>
<html>
<%
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("SystemRightDetail_SelectByID",id);
	RecordSet.next();
	String rightdetailname = Util.toScreen(RecordSet.getString("rightdetailname"),user.getLanguage()) ;
	String rightdetail = Util.toScreen(RecordSet.getString("rightdetail"),user.getLanguage()) ;
	String rightid = Util.null2String(RecordSet.getString("rightid")) ;
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function confirmdel() {
	return confirm("<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>") ;
}
</script>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport_wev8.gif"></TD>
      <TD align=left><SPAN id=BacoTitle class=titlename><%=SystemEnv.getHtmlLabelName(2121, user.getLanguage())%>: <%=SystemEnv.getHtmlLabelNames("385,361",user.getLanguage()) %></SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>
  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="RightDetailOperation.jsp">
    <input type="hidden" name="operation" value="deleterightdetail">
    <input type="hidden" name="delete_rightdetail_id" value="<%=id%>">
    <BUTTON class=btn id=btnEdit accessKey=E name=btnEdit onclick="editrightdetail()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%></BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleterightdetail()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addrightdetail()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></BUTTON>
    <br>
        
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1479, user.getLanguage())%></TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TD>
      <TD Class=Field><%=rightdetailname%></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(361, user.getLanguage())%></td>
      <td class=Field><%=rightdetail%></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelNames("33476,385",user.getLanguage()) %></td>
      <td class=Field><%=Util.toScreen(RightComInfo.getRightname(rightid,""+user.getLanguage()),user.getLanguage())%></td>
    </tr>
    </TBODY> 
  </TABLE>
      </FORM>
<script>
function deleterightdetail(){
	if(confirmdel()) {
		document.frmView.submit();
	}
}
function addrightdetail() {	
	location="AddRightDetail.jsp";
}
function editrightdetail() {	
	location="EditRightDetail.jsp?id=<%=id%>";
}
</script>
      </BODY>
      </HTML>
