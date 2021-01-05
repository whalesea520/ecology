
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	//jQuery("#searchfrm").submit();
}
</script>
</HEAD>
<%
String sql_1 = "select hrmid from HrmInfoMaintenance where id =1 ";
rs.executeSql(sql_1);
rs.next();
String hrmid_1=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_2 = "select hrmid from HrmInfoMaintenance where id =2 ";
rs.executeSql(sql_2);
rs.next();
String hrmid_2=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_3 = "select hrmid from HrmInfoMaintenance where id =3 ";
rs.executeSql(sql_3);
rs.next();
String hrmid_3=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_4 = "select hrmid from HrmInfoMaintenance where id =4 ";
rs.executeSql(sql_4);
rs.next();
String hrmid_4=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_5 = "select hrmid from HrmInfoMaintenance where id =5 ";
rs.executeSql(sql_5);
rs.next();
String hrmid_5=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_6 = "select hrmid from HrmInfoMaintenance where id =6 ";
rs.executeSql(sql_6);
rs.next();
String hrmid_6=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_7 = "select hrmid from HrmInfoMaintenance where id =7 ";
rs.executeSql(sql_7);
rs.next();
String hrmid_7=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_8 = "select hrmid from HrmInfoMaintenance where id =8 ";
rs.executeSql(sql_8);
rs.next();
String hrmid_8=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_9 = "select hrmid from HrmInfoMaintenance where id =9 ";
rs.executeSql(sql_9);
rs.next();
String hrmid_9=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String sql_10 = "select hrmid from HrmInfoMaintenance where id =10 ";
rs.executeSql(sql_10);
rs.next();
String hrmid_10=Util.toScreen(rs.getString("hrmid"),user.getLanguage());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6137,user.getLanguage());

if(hrmid_1.equals("-1"))hrmid_1="";
if(hrmid_2.equals("-1"))hrmid_2="";
if(hrmid_3.equals("-1"))hrmid_3="";
	
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name=resource id=resource action="/hrm/employee/EmployeeMainOperation.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("OtherSettings:Add", user)){ %>
			<input type=button class="e8_btn_top" onclick="OnSubmit(this);" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
		<%} %>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" id="hrmid_1" name="hrmid_1" browserValue='<%=hrmid_1%>' 
      tempTitle='<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>'
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1"
      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
      browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(hrmid_1),user.getLanguage())%>'>
    	</brow:browser>
		</wea:item>
		<%if(software.equals("ALL") || software.equals("HRM")){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>：</wea:item>
    <wea:item>
			<brow:browser viewType="0" id="hrmid_2" name="hrmid_2" browserValue='<%=hrmid_2%>' 
        tempTitle='<%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>'
        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1"
        completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
        browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(hrmid_2),user.getLanguage())%>'>
     </brow:browser>
    </wea:item>
<%}%>
<%if(software.equals("ALL")){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15806,user.getLanguage())%>－<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>：</wea:item>
	  <wea:item>
			<brow:browser viewType="0" id="hrmid_3" name="hrmid_3" browserValue='<%=hrmid_3%>' 
      tempTitle='<%=SystemEnv.getHtmlLabelName(15806,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>'
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1"
      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
      browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(hrmid_3),user.getLanguage())%>'></brow:browser>
	  </wea:item>
<%}%>
	<wea:item attributes="{'colspan':'full'}">
	<%=SystemEnv.getHtmlLabelName(15168,user.getLanguage())%>：
	</wea:item>
	<wea:item attributes="{'colspan':'full'}">
	<%=SystemEnv.getHtmlLabelName(21744,user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'full'}">
	<%=SystemEnv.getHtmlLabelName(21745,user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'full'}">
	<%=SystemEnv.getHtmlLabelName(21746,user.getLanguage())%>
	</wea:item>
	<wea:item attributes="{'colspan':'full'}">
	<%=SystemEnv.getHtmlLabelName(21747,user.getLanguage())%>
	</wea:item>
	</wea:group>
</wea:layout>
 </FORM>
<script language=vbs>
sub onShowHrmid_1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_1span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_1.value=id(0)
	else 
	hrmid_1span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_1.value=""
	end if
	end if
end sub

sub onShowHrmid_2()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_2span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_2.value=id(0)
	else 
	hrmid_2span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_2.value=""
	end if
	end if
end sub

sub onShowHrmid_3()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_3span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_3.value=id(0)
	else 
	hrmid_3span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_3.value=""
	end if
	end if
end sub
sub onShowHrmid_4()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_4span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_4.value=id(0)
	else 
	hrmid_4span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_4.value=""
	end if
	end if
end sub
sub onShowHrmid_5()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_5span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_5.value=id(0)
	else 
	hrmid_5span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_5.value=""
	end if
	end if
end sub
sub onShowHrmid_6()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_6span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_6.value=id(0)
	else 
	hrmid_6span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_6.value=""
	end if
	end if
end sub
sub onShowHrmid_7()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_7span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_7.value=id(0)
	else 
	hrmid_7span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_7.value=""
	end if
	end if
end sub
sub onShowHrmid_8()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_8span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_8.value=id(0)
	else 
	hrmid_8span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_8.value=""
	end if
	end if
end sub
sub onShowHrmid_9()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_9span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_9.value=id(0)
	else 
	hrmid_9span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_9.value=""
	end if
	end if
end sub

sub onShowHrmid_10()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmid_10span.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.hrmid_10.value=id(0)
	else 
	hrmid_10span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.hrmid_10.value=""
	end if
	end if
end sub
</script>
<SCRIPT language="javascript">
	function OnSubmit(obj) {
		if (check_form(document.resource, "hrmid_1,hrmid_2,hrmid_3,hrmid_4,hrmid_5,hrmid_6,hrmid_7,hrmid_8,hrmid_9,hrmid_10")) {
			obj.disabled = true;
			document.resource.submit();
		}
	}
	
	function onShowResource(tdname,inputename){
		var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1");
		if(results){
		  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
		  	 jQuery($GetEle(tdname)).html("<a href='javascript:openhrm("+wuiUtil.getJsonValueByIndex(results,0)+")'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
		     jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
		  }else{
		     jQuery($GetEle(tdname)).html("");
		     jQuery("input[name='"+inputename+"']").val("");
		  }
		}
	}
</script>
</BODY>
</HTML>
