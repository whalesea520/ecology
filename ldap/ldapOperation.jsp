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
	if(!HrmUserVarify.checkUserRight("intergration:ldapsetting", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
	}
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

String ids=request.getParameter("arrayid");
if(method.equals("edit")){
	ids=request.getParameter("ids");
	String idss[]=ids.split(",");
	String departmentid=request.getParameter("departmentid");
	sql="select * from hrmdepartment  where id ="+departmentid;
	String subcompanyid1="";
	rs.executeSql(sql);
	if(rs.next()){
		subcompanyid1=rs.getString("subcompanyid1");
	}
	if("".equals(departmentid)&&"".equals(subcompanyid1)){
	   out.println("<script>alert('"+SystemEnv.getHtmlLabelName(83322,user.getLanguage())+"')</script>");
		return;
	}
	for(int i=0;i<idss.length;i++){
     
     sql="update hrmresource set departmentid="+departmentid +" ,subcompanyid1="+subcompanyid1+"  where id="+idss[i];
     RecordSet.executeSql(sql);	
  
	}
	  out.println("<script>alert('"+SystemEnv.getHtmlLabelName(83323,user.getLanguage())+"');window.location.href='ldapList.jsp'</script>");
}


//sql="select id,name,email,phone,mobliephone from addressbook where groupid="+groupid;



%>
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		
			
			
		
		    RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(725,user.getLanguage())
				+ ",javascript:query(),_self} ";
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
	if(weaver.departmentid.value==''){
		alert('<%=SystemEnv.getHtmlLabelName(83324, user.getLanguage())%>');
		return;
	}
	weaver.action="ldapOperation.jsp";
	document.getElementById('method').value='edit';
	weaver.submit();


}

</script>

		<form name="weaver" >
		
			<input type="hidden" name="arrayid" id="arrayid" value="">
			
				
			
			<input type="hidden" name="method" id="method" value="">
			
			
			<input type="hidden" name="ids" id="ids" value="<%=ids %>">
			
			<input type="hidden">
			<TABLE width=100% class=ViewForm>
				<TR class=Spacing>
					<TD class=Line1 colspan=4></TD>
				</TR>
				<TR>
					<TD width=15%>
						<%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%><!-- 姓名 -->
					</TD>
					<TD width=35% class=field>
						<%
						String idsarray[]=ids.split(",");
						String names="";
						for (int i=0;i<idsarray.length;i++){
							names=names+ResourceComInfo.getLastname(idsarray[i])+" ";
						}

						%>
						<%=names %>
					</TD>
					
				</TR>
			<TR>
					<TD class=Line colspan=4></TD>
				</TR>
				 <TR>
            <TD><%=SystemEnv.getHtmlLabelName(26355, user.getLanguage())+SystemEnv.getHtmlLabelName(15393, user.getLanguage())%><!-- 员工所属部门 --></TD>
            <TD class=Field>
			 <BUTTON class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
              <SPAN id=departmentspan>
                
               <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              </SPAN>
              <INPUT class=inputstyle id=departmentid type=hidden name=departmentid >
            </TD>
          </TR>
          <TR>
					<TD class=Line colspan=4></TD>
				</TR>
			</TABLE>

		
			
				
		</form>
	</BODY>
	<script language=vbs>


sub onShowDepartment()

	id = window.showModalDialog("/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceEdit:Edit&selectedids="&weaver.departmentid.value)
	issame = false 
 if (Not IsEmpty(id)) then
	if id(0)<>"" And id(1)<>"" then
	if id(0) = weaver.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	weaver.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.departmentid.value=""
	end if 
	end if
   
end sub


</script>
</HTML>
