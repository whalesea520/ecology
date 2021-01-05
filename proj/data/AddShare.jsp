
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />

<%
String prjid = Util.null2String(request.getParameter("prjid"));

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

//4E8 项目权限等级(默认共享的值设置:项目成员0.5,项目经理2.5,项目经理上级3,项目管理员4;手动共享值设置:查看1,编辑2)
String ptype=Util.null2String( CommonShareManager.getPrjPermissionType(ProjID, user) );

if(ptype.equals("2.5")||ptype.equals("2")){
	canview=true;
	canedit=true;
	ismanager=true;
}else if (ptype.equals("3")){
	canview=true;
	canedit=true;
	ismanagers=true;
}else if (ptype.equals("4")){
	canview=true;
	canedit=true;
	isrole=true;
}else if (ptype.equals("0.5")){
	canview=true;
	ismember=true;
}else if (ptype.equals("1")){
	canview=true;
	isshare=true;
}
/**
String ViewSql="select * from PrjShareDetail where prjid="+prjid+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

if(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("usertype").equals("2")){
	 	iscustomer=RecordSetV.getString("sharelevel");
	 }else{
		 if(RecordSetV.getString("sharelevel").equals("2")){
			canedit=true;	
			ismanager=true;  
		 }else if (RecordSetV.getString("sharelevel").equals("3")){
			canedit=true;	
			ismanagers=true;
		 }else if (RecordSetV.getString("sharelevel").equals("4")){
			canedit=true;	
			isrole=true;
		 }else if (RecordSetV.getString("sharelevel").equals("5")){
			ismember=true;
		 }else if (RecordSetV.getString("sharelevel").equals("1")){
			isshare=true;
		 }	 
	 }
}
**/

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


RecordSet.executeProc("Prj_ProjectInfo_SelectByID",prjid);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

RecordSetShare.executeProc("Prj_ShareInfo_SbyRelateditemid",prjid);

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log=n&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;};
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/data/ViewProject.jsp?log=n&ProjID="+prjid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver action="/proj/data/ShareOperation.jsp" method="post">
<input type="hidden" name="method" value="add">
<input type="hidden" name="prjid" value="<%=prjid%>">


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


<%if(canedit){%>
		<TABLE class=ViewForm>
				<COLGROUP>
				<COL width="20%">
				<COL width="80%">
				<TBODY>
				<TR class=Spacing>
				<!--TR>
				<TR class=title-->
					<TH colSpan=2></TH>
				  </TR>
				  <TD class=field>

		<select class=inputstyle  name=sharetype onchange="onChangeSharetype()">
		  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
		  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
		  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
		</SELECT>
				  </TD>
				  <TD class=field>
		<button type="button" class=Browser style="display :none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
		<button type="button" class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
		<button type="button" class=Browser style="display :none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
		 <%if(user.getUserDepartment()!=0){%>
		 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
		<%}else{%>
		 <INPUT type=hidden name=relatedshareid value="">
		 <%}%>
		 <span id=showrelatedsharename name=showrelatedsharename >
			<%if(!Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage()).equals("")){%>
			<%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%>
			<%}else{%>
			<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
			<%}%>
			</span>
		<span id=showrolelevel name=showrolelevel style="visibility:hidden">
		&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
		<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
		<select class=inputstyle  name=rolelevel>
		  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
		  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
		  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
		</SELECT>
		</span>
		&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
		<span id=showseclevel name=showseclevel>
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
		<INPUT class=inputstyle maxLength=3 size=5 
					name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
		</span>
		<SPAN id=seclevelimage></SPAN>

				  </TD>		
	</TR>

	<TR style="height:1px;">
		<TD class=Line colSpan=2></TD>
	</TR>

	<TR>
		<TD class=field>			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT class=InputStyle  name="sharelevel">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		  </TD>	
	</TR>

	<TR style="height:1px;">
		<TD class=Line colSpan=2></TD>
	</TR>

				</TBODY>
			  </TABLE>
<%}%>

	  <TABLE class=ListStyle cellspacing="1" >
        <COLGROUP>
		<COL width="20%">
  		<COL width="60%">
  		<COL width="20%">
        <TBODY>

		<TR class=header > 
            <TD colspan=3><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></TD>
		</TR>
		<TR class=Line><TD colspan="3" style="padding:0;"></TD></TR>
		
<%
if(RecordSetShare.first()){
   int i = 0 ;
  do{
	i ++ ;
		if(RecordSetShare.getInt("sharetype")==1)	{
				%>
						<%if (i%2 == 0) {%>
							 <TR  class=datalight>
						<%} else {%>
							 <TR  class=datadark>
						<%}%>						
						  <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
						  <TD class=Field>
							<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetShare.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%></a>
							<%
							if (RecordSetShare.getInt("sharelevel")==1) {
								out.println("/"+SystemEnv.getHtmlLabelName(367,user.getLanguage()));	
							} else if (RecordSetShare.getInt("sharelevel")==2) {
								out.println("/"+SystemEnv.getHtmlLabelName(93,user.getLanguage()));
							}							
							%>

						  </TD>
						  <TD class=Field>
				<%if(canedit){%>
							<a href="/proj/data/ShareOperation.jsp?method=delete&prjid=<%=prjid%>&id=<%=RecordSetShare.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
				<%}%>
						  </TD>
						</TR>
		<%}
		 else if(RecordSetShare.getInt("sharetype")==2)	{%>
				<%if (i%2 == 0) {%>
							 <TR  class=datalight>
						<%} else {%>
							 <TR  class=datadark>
						<%}%>
				  <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
				  <TD class=Field>
				<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSetShare.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>
				<%
							if (RecordSetShare.getInt("sharelevel")==1) {
								out.println("/"+SystemEnv.getHtmlLabelName(367,user.getLanguage()));	
							} else if (RecordSetShare.getInt("sharelevel")==2) {
								out.println("/"+SystemEnv.getHtmlLabelName(93,user.getLanguage()));
							}							
				%>
				  </TD>
				  <TD class=Field>
			<%if(canedit){%>
						<a href="/proj/data/ShareOperation.jsp?method=delete&prjid=<%=prjid%>&id=<%=RecordSetShare.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			<%}%>
					  </TD>
					</TR>   
			<%}
		else if(RecordSetShare.getInt("sharetype")==3)	{%>
					<%if (i%2 == 0) {%>
							 <TR  class=datalight>
						<%} else {%>
							 <TR  class=datadark>
						<%}%>
					  <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSetShare.getString("roleid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						<% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						<% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>
						<%
							if (RecordSetShare.getInt("sharelevel")==1) {
								out.println("/"+SystemEnv.getHtmlLabelName(367,user.getLanguage()));	
							} else if (RecordSetShare.getInt("sharelevel")==2) {
								out.println("/"+SystemEnv.getHtmlLabelName(93,user.getLanguage()));
							}							
						%>
					  </TD>
					  <TD class=Field>
			<%if(canedit){%>
						<a href="/proj/data/ShareOperation.jsp?method=delete&prjid=<%=prjid%>&id=<%=RecordSetShare.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			<%}%>
					  </TD>
					</TR>  
				<%}				
		else if(RecordSetShare.getInt("sharetype")==4)	{%>
					<%if (i%2 == 0) {%>
							 <TR  class=datalight>
						<%} else {%>
							 <TR  class=datadark>
						<%}%>
					  <TD class=Field><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
					  <TD class=Field>
						<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>
						<%
							if (RecordSetShare.getInt("sharelevel")==1) {
								out.println("/"+SystemEnv.getHtmlLabelName(367,user.getLanguage()));	
							} else if (RecordSetShare.getInt("sharelevel")==2) {
								out.println("/"+SystemEnv.getHtmlLabelName(93,user.getLanguage()));
							}							
						%>
					  </TD>
					  <TD class=Field>
			<%if(canedit){%>
						<a href="/proj/data/ShareOperation.jsp?method=delete&prjid=<%=prjid%>&id=<%=RecordSetShare.getString("id")%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			<%}%>
					  </TD>
					</TR>   
		<%}%>
  <%}while(RecordSetShare.next());
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
</form>
<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value
	document.weaver.relatedshareid.value=""
	
	if(thisvalue!=1)
		$("#showseclevel").show();
	else
		$("#showseclevel").hide();
	
	$("#showrelatedsharename").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");

	if(thisvalue==1){
 		$("button[name=showresource]").show();
		$("#showseclevel").hide();
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		$("#seclevelimage").empty();
		if($("input[name=seclevel]").val()==""){
			$("input[name=seclevel]").val(10);
		}
		//End TD33012
	}
	else{
		$("button[name=showresource]").hide();
	}
	if(thisvalue==2){
 		$("button[name=showdepartment]").show();
	}
	else{
		$("button[name=showdepartment]").hide();
	}
	if(thisvalue==3){
 		$("button[name=showrole]").show();
		$("#showrolelevel").css("visibility",'visible');
	}
	else{
		$("button[name=showrole]").hide();
		$("#showrolelevel").css("visibility",'hidden');
    }
	if(thisvalue==4){
		$("#showrelatedsharename").empty();
		document.weaver.relatedshareid.value="-1";
	}
}
</script>

<SCRIPT type="text/javascript">
function onShowDepartment(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$("input[name="+inputename+"]").val());
	if(datas){
		if(datas.id){
			$("#"+tdname).html(datas.name);
			$("input[name="+inputename+"]").val(datas.id);
		}else{
			$("#"+tdname).html("<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">");
			$("input[name="+inputename+"]").val("");
		}
	}
}

function onShowResource(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(datas){
		if(datas.id){
			$("#"+tdname).html(datas.name);
			$("input[name="+inputename+"]").val(datas.id);
		}else{
			$("#"+tdname).html("<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">");
			$("input[name="+inputename+"]").val("");
		}
	}
}

function onShowRole(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	if(datas){
		if(datas.id){
			$("#"+tdname).html(datas.name);
			$("input[name="+inputename+"]").val(datas.id);
		}else{
			$("#"+tdname).html("<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">");
			$("input[name="+inputename+"]").val("");
			
		}
	}
}

</SCRIPT>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'relatedshareid,seclevel'))		
		weaver.submit();
}
</script>
</BODY>
</HTML>
