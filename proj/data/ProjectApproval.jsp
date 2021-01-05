
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();
String usertype ="0";
if(logintype.equals("1"))
	usertype = "0";
else usertype = "1";

String sqlstr ="Select distinct t1.requestid,t1.requestname,t4.id,t4.name,t4.prjtype,t4.worktype,t4.status,t4.manager,t4.members from workflow_requestbase t1,workflow_currentoperator t2,bill_approveproj t3,Prj_ProjectInfo t4 WHERE t1.requestid = t3.requestid and t1.requestid = t2.requestid and t2.userid = "+userid+" and t2.usertype = "+usertype+" and t2.isremark in ('0','1','5','7','8','9') and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype = '1' and t3.approveid = t4.id";

RecordSet.execute(sqlstr);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16409,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
*/

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>




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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<TABLE class=liststyle cellspacing=1  >
	<colgroup>
	  <col width="20%">
	  <col width="20%">
	  <col width="10%">
	  <col width="15%">
	  <col width="15%">
	  <col width="10%">
	  <col width="10%">
  </colgroup>
  <TBODY>
  

  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(16573,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TH>

	<TH><%=SystemEnv.getHtmlLabelName(16409,user.getLanguage())%></TH>
  </TR>
    <TR class=Line><TD colspan="7" style="padding:0;"></TD></TR>
<%
     
boolean isLight = false;
int totalline=1;
String manager ="";
String members ="";
ArrayList Members_proj;
if(RecordSet.last()){
	do{
		manager = Util.null2String(RecordSet.getString("manager"));
		members = Util.null2String (RecordSet.getString("members"));
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
    <TD><a href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("id")%>" target=_fullwindow><%=RecordSet.getString("name")%></a></TD>
    <TD><%=ProjectTypeComInfo.getProjectTypename(RecordSet.getString("prjtype"))%></TD>
    <TD><%=WorkTypeComInfo.getWorkTypename(RecordSet.getString("worktype"))%></TD>

<%
    String ProjID= RecordSet.getString("id");
    /*项目状态*/
    String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
    RecordSet2.executeSql(sql_tatus);
    RecordSet2.next();
    String isactived=RecordSet2.getString("isactived");
    //isactived=0,为计划
    //isactived=1,为提交计划
    //isactived=2,为批准计划

    String status_prj=RecordSet.getString("status");
    //status_prj=5&&isactived=2,立项批准
    //status_prj=1,正常
    //status_prj=2,延期
    //status_prj=3,终止
    //status_prj=4,冻结

%>
      <TD class=Field>
      <%if(!isactived.equals("2")){%><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%><%}%>
      <%if((isactived.equals("2"))&&(status_prj.equals("5"))){%><%=SystemEnv.getHtmlLabelName(2243,user.getLanguage())%><%}%>
      <%if((isactived.equals("2"))&&(status_prj.equals("1"))){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
      <%if((isactived.equals("2"))&&(status_prj.equals("2"))){%><%=SystemEnv.getHtmlLabelName(2244,user.getLanguage())%><%}%>
      <%if((isactived.equals("2"))&&(status_prj.equals("3"))){%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%><%}%>
      <%if((isactived.equals("2"))&&(status_prj.equals("4"))){%><%=SystemEnv.getHtmlLabelName(1232,user.getLanguage())%><%}%>
      </TD>

	  <TD>
	   <a href="/hrm/resource/HrmResource.jsp?id=<%=manager%>">
		<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>
		</a>
	  </TD>
	  <TD>
		<%
			Members_proj = Util.TokenizerString(members,",");  
			for(int i=0;i<Members_proj.size();i++){
	    %>
		 <a href="/hrm/resource/HrmResource.jsp?id=<%=Members_proj.get(i)%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())%></a>&nbsp;
		<%}%>
	  </TD>

	  	<TD><a href="/workflow/request/ViewRequest.jsp?requestid=<%=RecordSet.getString("requestid")%>"><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></a></TD>
  </TR>
      
<%
	isLight = !isLight;
	
}while(RecordSet.previous());
}
%>  
 </TBODY>
 </TABLE>
	  

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

	  
<script>
function onReSearch(){
	location.href="/proj/search/Search.jsp";
}
</script>
<script>
function nextPage()
{
    document.all("pagenum").value = parseInt(document.all("pagenum").value) + 1 ;
	searchForm.submit();
	
}
function prevPage(){
   document.all("pagenum").value = parseInt(document.all("pagenum").value) - 1 ;
	searchForm.submit();
}


function search(){
	searchForm.submit();

}

</script>
</body>
</html>
