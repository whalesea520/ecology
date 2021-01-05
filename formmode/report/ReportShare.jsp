
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportShareInfo" class="weaver.formmode.report.ReportShareInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
*{
	font: 12px Microsoft YaHei;
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 2px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
</style>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
//报表:权限设置
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<BODY> 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(this),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
int reportid = Util.getIntValue(request.getParameter("id"),0);

ReportShareInfo.setUser(user);
ReportShareInfo.setReportid(reportid);

Map allRightMap = ReportShareInfo.getAllRightList();			//所有权限
List addRightList = ReportShareInfo.getAddRightList();

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_Report a,modeTreeField b WHERE a.appid=b.id AND a.id="+reportid;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

%>
<FORM id=weaver name=weaver action="ModeCommonRightOperation.jsp" method=post>
	<input type=hidden name="method" value="addNew">
	<input type=hidden name=reportid value="<%=reportid %>">
	<input type=hidden name=mainids >
	<table class="e8_tblForm">
		<tr><td colspan="2" style="height:8px;"></td></tr>
		<TR>
			<td style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(26137,user.getLanguage())%></td><!-- 共享权限 -->
			<td align=right>
				<%if(operatelevel>1){%><!-- 全部选中 -->
					<input type="checkbox" name="chkPermissionAll0" onclick="chkAllClick(this,0)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
				<%} %>
				<%if(operatelevel>0){%><!-- 添加 -->
					<a href="ReportShareAdd.jsp?righttype=0&reportid=<%=reportid%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
				<%} %>
				<%if(operatelevel>1){%><!-- 删除 -->
					<a href="javascript:void(0);" onclick="javaScript:doDelShare(0);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>       
				<%} %>
			</td>
		</TR>
		<tr><td colspan="2" style="border-bottom:1px solid #e6e6e6;"></td></tr>
		<%
			Map datamap = null;
			for(int i=0 ;i < addRightList.size();i++){
				datamap = (Map)addRightList.get(i);
				String rightid = (String)datamap.get("rightId");
				String sharetypetext = (String)datamap.get("sharetypetext");
				String detailText = (String)datamap.get("detailText");
		%>
		<tr>
			<td class="e8_tblForm_label" width="20%"><input type="checkbox" name="rightid0" id="rightid0" value="<%=rightid %>"></td>
			<td class="e8_tblForm_field"><%=sharetypetext %> <%=detailText%></td>
		</tr>
		<%}%>
		<tr><td colspan="2" style="height:8px;"></td></tr>
	</TABLE>
</form>
<script language="javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
})

function onSave(){
	weaver.submit();
}

function chkAllClick(obj,types){
    var chks = document.getElementsByName("rightid"+types);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }    
}

function doback(){
	location.href = "/formmode/setup/reportinfoBase.jsp?id=<%=reportid%>";
}

function doDelShare(type){
	var mainids = "";
    var chks = document.getElementsByName("rightid"+type); 
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked)
        	mainids = mainids + "," + chk.value;
    }
    if(mainids == '') {
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22346,user.getLanguage())%>");
		return;
    }else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			weaver.method.value="delete";
	    	weaver.mainids.value=mainids;
	    	weaver.action="ReportShareOperation.jsp";
	    	weaver.submit();
		});
	}
}
function onSelectChange(obj1,obj2){
     var selectValue = obj1.value;
     if (selectValue!=99) obj2.style.display="";
     else  obj2.style.display="none";           
}
</script>
</BODY></HTML>