<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.systeminfo.workflowbill.WorkFlowBillUtil" %>
<jsp:useBean id="bci" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<html>
<%
  WorkFlowBillUtil wf = new WorkFlowBillUtil();
  String sid = request.getParameter("id");
  int id = Util.getIntValue(sid,0);
  
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="/css/BacoSystem_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
    function editworkflowbrowser(){
        location = "EditWorkflowbrowser.jsp?id=<%=id%>";
    }
    function deleteworkflowbill(){ 
      if(confirm("do you sure to delete the workflow_bill?")){     
        document.workflowbrowserViewform.operation.value = "delete";      
        document.workflowbrowserViewform.submit();
      }
    }    
    function viewBrowserSQL(){
    	location = "ViewBrowserSql.jsp?id=<%=id%>";
    }
    
    function backSubmit(){
      location = "ManageWorkflowbrowser.jsp";
}
</script>
</head>
<body>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>详细信息: 工作流浏览框</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 </TBODY>
</TABLE>
</div>

<DIV class=HdrProps>
</DIV>
<FORM style="MARGIN-TOP: 0px" name=workflowbrowserViewform method=post action="WorkflowbrowserOperation.jsp">
  <BUTTON class=btn id=btnEdit accessKey=E name=btnEdit onclick="editworkflowbrowser()"><U>E</U>-编辑</BUTTON>
<%
 if(Util.getIntValue(user.getSeclevel(),0)>=20){
%>    
  <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteworkflowbill()"><U>D</U>-删除</BUTTON>        
    <input type=hidden name=operation>
    <input type=hidden name=id value="<%= id %>">
<%
  }
%>
  <BUTTON class=btn id=btnBack accessKey=B name=btnBack onclick="backSubmit()"><U>D</U>-返回</BUTTON> 
  <BUTTON class=btn id=btnEdit accessKey=S name=btnEdit onclick="viewBrowserSQL()"><U>E</U>-导出SQL</BUTTON>
  <br>
<%
/*  String sql = "select * from workflow_browserurl where id = "+id;  
  rs.executeSql(sql);
  while(rs.next()){
    int labelid = Util.getIntValue(rs.getString("labelid"),0);
    String label = wf.getLabelByLabelId(labelid);
    String dbtype = rs.getString("fielddbtype");
    String url = rs.getString("browserurl");
    String table = rs.getString("tablename");
    String colum = rs.getString("columname");
    String keycolum = rs.getString("keycolumname");
    String linkurl = rs.getString("linkurl");*/
        
  while(bci.next()){                      
    int labelid = Util.getIntValue(bci.getBrowserlabelid(sid),0);
    String label = wf.getLabelByLabelId(labelid);
    String dbtype = bci.getBrowserdbtype(sid);
    String url = bci.getBrowserurl(sid);
    String table = bci.getBrowsertablename(sid);
    String colum = bci.getBrowsercolumname(sid);
    String keycolum = bci.getBrowserkeycolumname(sid);
    String linkurl = bci.getLinkurl(sid);
%> 

  <TABLE class=Form>
     <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
     <TR class=Section> 
        <TH colSpan=5>浏览框信息</TH>
     </TR>
     <TR class=Separator> 
        <TD class=sep1 colSpan=5></TD>
     </TR>          
     <TR> 
        <TD>编号</TD>
        <TD Class=Field><%=id%></TD> 
        <input type=hidden name=id value="<%=id%>">       
     </TR>    
     <TR> 
        <TD>描述</TD>
        <TD Class=Field><%=label%></TD>                        
     </TR>    
     <TR> 
        <TD>描述id</TD>
        <TD Class=Field><%=labelid%></TD>                        
     </TR>    
     <TR> 
        <TD>数据库类型</TD>
        <TD Class=Field><%=dbtype%></TD>                
     </TR>    
     <TR> 
        <TD>URL</TD>
        <TD Class=Field><%=url%></TD>                
     </TR>    
     <TR> 
        <TD>对应表名</TD>
        <TD Class=Field><%=table%></TD>                
     </TR>    
     <TR> 
        <TD>表对应字段</TD>
        <TD Class=Field><%=colum%></TD>                
     </TR>    
     <TR> 
        <TD>表关键字段</TD>
        <TD Class=Field><%=keycolum%></TD>                
     </TR>    
     <TR> 
        <TD>链接URL</TD>
        <TD Class=Field><%=linkurl%></TD>               
     </TR>    
<%break;
	  }
%>

  </TABLE>
</body>
</html>
