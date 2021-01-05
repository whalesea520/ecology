
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />

<%
	String prjtypename = Util.null2String(request.getParameter("prjtypename"));
	String typeid = Util.null2String(request.getParameter("typeid"));
	String itemtype = Util.null2String(request.getParameter("itemtype"));
	//out.print(typeid);
	boolean canedit_share = HrmUserVarify.checkUserRight("EditProjectType:Edit",user);
	if(!canedit_share) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+"－"+SystemEnv.getHtmlLabelName(586,user.getLanguage())+":<a href='/proj/Maint/EditProjectType.jsp?id="+typeid+"'>"+Util.toScreen(prjtypename,user.getLanguage(),"0")+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/Maint/EditProjectType.jsp?id="+typeid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="/proj/data/TypeShareOperation.jsp"  method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="typeid" value="<%=typeid%>">
<input type="hidden" name="itemtype" value="<%=itemtype%>">
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


	  <TABLE class=viewform>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=title>
            <TH colSpan=2></TH>
          </TR>

        <TR>
          <TD class=field>
<select class=inputstyle  name=sharetype onChange="onChangeSharetype()">
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
</SELECT>
		  </TD>
          <TD class=field>
<button type="button" class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
<button type="button" class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
<button type="button" class=Browser style="display:none" onClick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
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
		</TR><TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
		<tr class="Header">
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<select class=inputstyle  name=sharelevel>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		  </TD>		
		</TR>
<TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
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
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

	if(thisvalue==1){
 		document.all("showresource").style.display='';
		document.all("showseclevel").style.display='none';
	}
	else{
		document.all("showresource").style.display='none';
	}
	if(thisvalue==2){
 		document.all("showdepartment").style.display='';
	}
	else{
		document.all("showdepartment").style.display='none';
	}
	if(thisvalue==3){
 		document.all("showrole").style.display='';
		document.all("showrolelevel").style.visibility='visible';
	}
	else{
		document.all("showrole").style.display='none';
		document.all("showrolelevel").style.visibility='hidden';
    }
	if(thisvalue==4){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value="-1"

	}
}
</script>

<script type="text/javascript">
function onShowDepartment(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+document.all(inputename).value)
		if(datas){
	        if(datas.id!= "0"&&datas.id){
				$("#"+tdname).html(datas.name);
				$("input[name="+inputename+"]").val(datas.id);
	        }
			else{
				$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				$("input[name="+inputename+"]").val("");
			}
		}
}
function onShowResource(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if(datas){
      if (datas.id){
		$("#"+tdname).html(datas.name);
		$("input[name="+inputename+"]").val(datas.id);
	  }else{
		$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		$("input[name="+inputename+"]").val("");
	  }
   }
}

function onShowRole(tdname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	if(datas){
	      if (datas.id){
			$("#"+tdname).html(datas.name);
			$("input[name="+inputename+"]").val(datas.id);
		  }else{
			$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			$("input[name="+inputename+"]").val("");
		  }
	   }
}
</script>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'itemtype,relatedshareid,sharetype,rolelevel,seclevel,sharelevel'))
		weaver.submit();
}
</script>
</BODY>
</HTML>
