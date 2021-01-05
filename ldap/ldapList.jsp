<%@ page import="weaver.general.Util,weaver.file.*"%>
<%@ page import="weaver.conn.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo"
	class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmSearchComInfo"
	class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<HTML>
	<HEAD>
		<script type="text/javascript"
			src="../../js/jquery/jquery-1.4.2.min_wev8.js">

</script>

		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	</head>


	<%
	
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1515,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sql="";

String method=Util.null2String(request.getParameter("method"));
String deleteid=request.getParameter("id");

String id = "";
String name = "";
String adbm_q="";
String name_q = "";
String account_q = "";
String adsjgs_q ="" ;
String adgs_q ="";



if(method.equals("moredelete")){
	//String ids[]=request.getParameterValues("arrayid");
	String ids[]=request.getParameter("arrayid").split(",");
	for(int i=0;i<ids.length;i++){
      sql="delete from hrmresource  where id="+ids[i]; 
     RecordSet.executeSql(sql);	
  
	}
	  out.println("<script>alert('"+SystemEnv.getHtmlLabelName(20461, user.getLanguage())+"!')</script>");
}


//sql="select id,name,email,phone,mobliephone from addressbook where groupid="+groupid;



%>
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		
			
			
			RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(91, user.getLanguage())
				+ ",javascript:deletemore(),_self} ";
		    RCMenuHeight += RCMenuHeightStep;
		    
		    RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(527, user.getLanguage())
				+ ",javascript:query(),_self} ";
		    RCMenuHeight += RCMenuHeightStep;
		    
		    RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(83321, user.getLanguage())
				+ ",javascript:piliang(),_self} ";
		    RCMenuHeight += RCMenuHeightStep;
		  
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<script type="text/javascript">

function deletemore(){

var checked=0;
	document.getElementById("arrayid").value=_xtable_CheckedCheckboxId();
	if(document.getElementById("arrayid").value.length==0){
	        alert('<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())+ SystemEnv.getHtmlLabelName(413, user.getLanguage()) + "!"%>');
            return;
	}
	

	weaver.submit();


}
function query(){
	document.getElementById('method').value='query';
	weaver.submit();


}
function piliang(){
var checked=0;
	document.getElementById("arrayid").value=_xtable_CheckedCheckboxId();
	if(document.getElementById("arrayid").value.length==0){
	        alert('<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())+ SystemEnv.getHtmlLabelName(413, user.getLanguage()) + "!"%>');
            return;
	}
	
	weaver.action="ldapOperation.jsp"
	weaver.submit();


}
</script>

		<form name="weaver" >
		
			<input type="hidden" name="arrayid" id="arrayid" value="">
			
			<input type="hidden" name="method" id="method" value="moredelete">
			
		
	
			<input type="hidden">
			<TABLE width=100% class=ViewForm>
				<TR class=Spacing>
					<TD class=Line1 colspan=4></TD>
				</TR>
				<TR>
					<TD width=15%>
						<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>
					</TD>
					<TD width=35% class=field>
						<input class=InputStyle name=name_q value=<%=name_q %>>
					</TD>
					<TD width=15%>
						<%=SystemEnv.getHtmlLabelName(83594,user.getLanguage())%>
					</TD>
					<TD width=35% class=field>
						<input class=InputStyle name=account_q value=<%=account_q %>>
					</TD>
				</TR>
			<TR>
					<TD class=Line colspan=4></TD>
				</TR>
				
			</TABLE>

			<br />

		
			<br />
			<TABLE class=BroswerStyle cellspacing=1>
				<COLGROUP>
					<COL width="5%">
					<COL width="15%">
					<COL width="10%">
					<COL width="25%">
					<COL width="30%">
					<COL width="25%">
				<TR class=DataHeader>
				
				
					<td>
					<%					
					int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
					int perpage =10;
		            String backfields = "id,account,lastname,adsjgs,adbm,adgs";
		            String fromSql  = " from hrmresource";
		            String sqlWhere ="where account is not null and departmentid is  null";
		            if(method.equals("query")){
		                name_q =Util.null2String(request.getParameter("name_q"));
		            	account_q = Util.null2String(request.getParameter("account_q"));
		            	adsjgs_q =Util.null2String(request.getParameter("adsjgs_q")); 
		            	adgs_q =Util.null2String(request.getParameter("adgs_q"));	
		            	
		            	adbm_q =Util.null2String(request.getParameter("adbm_q"));	
		            	
		            	
		            	if(!name_q.equals("")){
		            		
		            		sqlWhere=sqlWhere+" and lastname like '%"+name_q+"%' ";
		            		
		            	}
		            	
		            	if(!account_q.equals("")){
		            		
		            		sqlWhere=sqlWhere+" and account like '%"+account_q+"%'";
		            		
		            	}
		            	if(!adsjgs_q.equals("")){
		            	
		            		sqlWhere=sqlWhere+" and adsjgs like '%"+adsjgs_q+"%'";
		            	
		            	}
		            	if(!adgs_q .equals("")){
		            	
		            		sqlWhere=sqlWhere+" and adgs like '%"+adgs_q+"%'";
		            	
		            	}
		            	if(!adbm_q .equals("")){
			            	
		            		sqlWhere=sqlWhere+" and adbm like '%"+adbm_q+"%'";
		            	
		            	}
		            }

		            String orderby = "id" ;
		            String tableString = "";
		            tableString =" <table instanceid=\"CarTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
		            						 
		                                     "		<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                                     "		<head>"+
		                                     
		                                     "			<col width=\"12%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/hrm/resource/HrmResourceBasicEdit.jsp?1=1\"/>"+
		                                  	 "		    <col width=\"28%\"   text=\""+SystemEnv.getHtmlLabelName(83594,user.getLanguage())+"\" column=\"account\" />"+
		                                   
		                                     "		</head>"+
		                                     "</table>";
		         %>
		         <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
					
					</td>
					
			

			</TABLE>
		</form>
	</BODY>
</HTML>
