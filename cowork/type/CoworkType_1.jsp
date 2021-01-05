<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>

<HTML><HEAD>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CoworkTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="25%">
  <COL width="15%">
  <COL width="15%">
  <COL width="45%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>    
    <TH><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TH>
  </TR>
<%
    
    int needchange = 0;
    ConnStatement statement=new ConnStatement();
    String sql="select * from cowork_types ";
    boolean isoracle = (statement.getDBType()).equals("oracle");
    try {
        statement.setStatementSql(sql);
        statement.executeQuery();
		while(statement.next()){
			String id = statement.getString("id");
        	String typename = statement.getString("typename");
        	String departmentid = statement.getString("departmentid");
        	String managerid = "",members = "";
            if(isoracle){
				CLOB theclob = statement.getClob("managerid");
				String readline = "" ;
				StringBuffer clobStrBuff = new StringBuffer("") ;
				BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
				while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
				clobin.close() ;
				managerid=clobStrBuff.toString();
			}else{
				managerid=statement.getString("managerid");
			}
            if(isoracle){
				CLOB theclob = statement.getClob("members");
				String readline = "" ;
				StringBuffer clobStrBuff = new StringBuffer("") ;
				BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
				while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
				clobin.close() ;
				members=clobStrBuff.toString();
			}else{
				members=statement.getString("members");
			}			
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><a href="CoworkTypeEdit.jsp?id=<%=id%>"><%=typename%></a></TD>
    <TD><%=CoMainTypeComInfo.getCoMainTypename(departmentid)%>
    </TD>
    <TD><a href="CoworkTypeShareEdit.jsp?settype=manager&cotypeid=<%=id%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></TD>
    <TD><a href="CoworkTypeShareEdit.jsp?settype=members&cotypeid=<%=id%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></TD>
  </TR>

<%		}
    } finally {
    	statement.close();
    }%>
 </TBODY></TABLE>
 <BR>
			
			</td>
			</tr>
			</TABLE>
			
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
</BODY></HTML>
