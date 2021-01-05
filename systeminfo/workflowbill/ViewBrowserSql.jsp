<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bci" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<html>
<%
  String sid = request.getParameter("id");
  int id = Util.getIntValue(sid,0);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function backSubmit(){
    location = "ViewWorkflowbrowser.jsp?id=<%=id%>";
}
</script>
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
</DIV>
<DIV class=HdrProps>
</DIV>

<FORM style="MARGIN-TOP: 0px" name=workflowbillViewSqlform method=post action="WorkflowbillOperation.jsp">
  
  <BUTTON class=btn id=btnBack accessKey=B name=btnBack onclick="backSubmit()"><U>D</U>-返回</BUTTON>        
  <br>
  <TABLE class=Form>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=5>SQL语句</TH>
    </TR>
    <TR class=Separator> 
      <TD class=sep1 colSpan=5></TD>
    </TR>   
<%
/*  String sql = "select * from workflow_browserurl where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
    int labelid = Util.getIntValue(rs.getString("labelid"),0);
    String dbtype = rs.getString("fielddbtype");
    String url = rs.getString("browserurl");
    String table = rs.getString("tablename");
    String colum = rs.getString("columname");
    String keycolum = rs.getString("keycolumname");
    String linkurl = rs.getString("linkurl");
    String insertSql = "INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( "+labelid+",'"+dbtype+"','"+url+"','"+table+"','"+colum+"','"+keycolum+"','"+linkurl+"')";
*/
    while(bci.next()){
    int labelid = Util.getIntValue(bci.getBrowserlabelid(sid),0);    
    String dbtype = bci.getBrowserdbtype(sid);
    String url = bci.getBrowserurl(sid);
    String table = bci.getBrowsertablename(sid);
    String colum = bci.getBrowsercolumname(sid);
    String keycolum = bci.getBrowserkeycolumname(sid);
    String linkurl = bci.getLinkurl(sid);
    
    String insertSql = "INSERT INTO workflow_browserurl (labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( "+labelid+",'"+dbtype+"','"+url+"','"+table+"','"+colum+"','"+keycolum+"','"+linkurl+"')";
%>
    <TR> 
    
     <TD Class=Field><%=insertSql%></TD>            
    </TR>
<%break;
  }
%>    
    <input type=hidden name=id value="<%= id %>">           
  </TABLE>  
</FORM>  
</body>
</html>