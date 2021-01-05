
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.attendance.domain.HrmScheduleApplication" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="hrmScheduleApplicationManager" class="weaver.hrm.attendance.manager.HrmScheduleApplicationManager" scope="page" />

<% 
//和考勤流程设置的权限一致：考勤流程设置
	if(!HrmUserVarify.checkUserRight("HrmAttendanceProcess:setting", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
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
jQuery(document).ready(function(){
	reflashAdminTable();
	
});
function reflashAdminTable(){
	jQuery.ajax({
        type:"post",
        dataType: 'text',
        url: "ScheduleApplicationRuleTable.jsp?date="+new Date(),
        success: function(data){
				jQuery("#admintable").html(data);
				jQuery("body").jNice();
       },
		 error: function(err){
	 	  console.log(err);
		 }
	});
}
function jsAddAdminLine(obj)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;

	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("15880,579,68",user.getLanguage())%>";
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=ScheduleApplicationRuleSetting";

	dialog.Width = 600;
	dialog.Height = 355;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function doDel(){
	var ids = "";
	jQuery("#TabBirthShare").find("input[name='chkId']").each(function(){
		if(this.checked){
			if(ids!="")ids+=",";
			ids+=this.value;
		}
	});
	
	if(!ids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
	var idArr = ids.split(",");
	var ajaxNum = 0;
	for(var i=0;i<idArr.length;i++){
		ajaxNum++;
		jQuery.ajax({
			url:"ScheduleApplicationSettingOperation.jsp?isdialog=1&action=delete&id="+idArr[i],
			type:"post",
			async:true,
			complete:function(xhr,status){
				ajaxNum--;
				if(ajaxNum==0){
					reflashAdminTable();
				}
			}
		});
	}
});
}

function jsChkAll(obj) {
	jQuery("#admintable").find("input[name='chkId']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	});
}
</script>
</HEAD>
<%
	int ScheduleUnit = 0;
	double onedayworkhours =  8.0;
	String titlename = SystemEnv.getHtmlLabelName(128558,user.getLanguage());

	HrmScheduleApplication bean = hrmScheduleApplicationManager.get(hrmScheduleApplicationManager.getMapParam("type:0"));//只取请假流程的考勤应用设置
	String id = bean == null ? "0" : String.valueOf(bean.getId());
	bean = bean == null ? new HrmScheduleApplication() : bean;
	ScheduleUnit = bean.getUnit();
	onedayworkhours = bean.getOnedayworkhours();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name=resource id=resource action="ScheduleApplicationSettingOperation.jsp" method=post>
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="type" value="0">
<input type="hidden" name="action" value="save">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmAttendanceProcess:setting", user)){ %>
			<input type=button class="e8_btn_top" onclick="OnSubmit(this);" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
		<%} %>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("451,33425",user.getLanguage())%></wea:item>
		<wea:item>
		    <select class="inputstyle" name="ScheduleUnit" style="width:150">
				<option value="0" <% if(ScheduleUnit == 0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32499,user.getLanguage())%></option>
				<option value="1" <% if(ScheduleUnit == 1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(128559,user.getLanguage())%></option>
				<option value="2" <% if(ScheduleUnit == 2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27641,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("149,21551",user.getLanguage())%></wea:item>
		<wea:item>
             <input class=InputStyle  name="onedayworkhours" value="<%=onedayworkhours %>" onBlur='checknumber("onedayworkhours")' />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
		<wea:item>
		<br/>
		<%=SystemEnv.getHtmlLabelName(128668,user.getLanguage())%><br/><br/>
		<%=SystemEnv.getHtmlLabelName(128669,user.getLanguage())%><br/><br/>
		<%=SystemEnv.getHtmlLabelName(128670,user.getLanguage())%><br/><br/>
		<%=SystemEnv.getHtmlLabelName(128671,user.getLanguage())%><br/><br/>
		<%=SystemEnv.getHtmlLabelName(128672,user.getLanguage())%><br/><br/>
		<%=SystemEnv.getHtmlLabelName(382418,user.getLanguage())%><br/><br/>
		</wea:item>
	</wea:group>
	<wea:group attributes="{'samePair':'tr_schedulerule','groupOperDisplay':'none'}" context='<%=SystemEnv.getHtmlLabelNames("15880,579,68",user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input name="btnOnSave" class=addbtn type="button" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="jsAddAdminLine(this)">
			<input name="btnOnDel" class=delbtn type="button" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" onclick="doDel()">
		</wea:item>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}"><div id="admintable"></div></wea:item>
	</wea:group>
</wea:layout>
 </FORM>
 
<SCRIPT language="javascript">
	function OnSubmit(obj) {
		obj.disabled = true;
		document.resource.submit();
	}
	
</script>
</BODY>
</HTML>
