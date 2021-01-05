<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingServiceUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("Meeting:Service", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

//初始化
String type=Util.null2String(request.getParameter("type"));
String itemname=Util.null2String(request.getParameter("itemname"));
String sqlwhere="where 1=1 ";
if(!"".equals(type)){
	sqlwhere+=" and type ='"+type+"'";
}
if(!"".equals(itemname)){
	sqlwhere+=" and itemname like '%"+itemname+"%'";
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2157,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delN(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
		 
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="delN()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span class="toggleLeft" id="toggleLeft" onclick="toggleLeft()" title="<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19652,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage()) %></span>
	<span id="hoverBtnSpan" class="hoverBtnSpan">
		<span id="ALL"  style="WIDTH: 100px;" class="selectedTitle" ><%=SystemEnv.getHtmlLabelName(16616,user.getLanguage())%></span>
	</span>
</div>

<div class="advancedSearchDiv" id="advancedSearchDiv">
<FORM id=weaverA name=weaverA action="MeetingServiceItemList.jsp" method=post  >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<!-- 名称 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></wea:item>
			<wea:item>
              <input class=inputstyle type="text" id="itemname" name="itemname"  style="width:60%" value="<%=itemname%>">
			</wea:item>
			<!-- 描述 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
            <wea:item>
            	<brow:browser viewType="0" name="type" browserValue='<%=type%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingServiceTypeBrowser.jsp" 
							hasInput="false"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="250px"
							completeUrl="" linkUrl="" 
							browserSpanValue='<%=MeetingServiceUtil.getMeetingServiceTypeName(Util.getIntValue(type))%>'></brow:browser>
            </wea:item>
		</wea:group>
		<wea:group context="">
	    	<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>

				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>

				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</FORM>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.MT_MeetingServiceItem%>"/>
	<%String orderby =" type ";
	String tableString = "";
	
	//System.out.println("["+sqlwhere+"]");                          
	String backfields = " s.*,t.name ";
	String fromSql  = " Meeting_Service_Item s join Meeting_Service_Type t on s.type=t.id ";
	tableString =   " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_MeetingServiceItem,user.getUID())+"\" >"+
					" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:isuse\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingServiceTypeCheckbox\"  />"+
					"       <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"s.id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
					"       <head>"+
					"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(1353, user.getLanguage())+"\" column=\"itemname\" orderkey=\"itemname\" otherpara=\"column:id+onEdit\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getClickMethod\"/>"+
					"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
					"       </head>";
	 
	tableString +=  "		<operates>"+
					"		<popedom column=\"s.id\" otherpara=\"column:isuse\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingServiceTypeOpt\"></popedom> "+
					"		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
					"		<operate href=\"javascript:onDelN();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
					"		</operates>";
	                 
	tableString +=  " </table>";
	//System.out.println(tableString);
	%>
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />


</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var diag_vote;

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	_table.reLoad();
	diag_vote.close();
}

function doSearchsubmit(){
	$('#weaverA').submit();
}

function add(){
	url = "/meeting/Maint/MeetingServiceEdit.jsp?method=item&id=";
	showDialog(url);
}

//删除
function onDelN(id){
	delN(id);
}

function delN(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") { 
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>") ;
	} else {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33475,user.getLanguage())%>", function (){
					doDeleteType(ids);	
			});
	}
}

function doDeleteType(ids){
	$.post("/meeting/Maint/MeetingServiceOperation.jsp",{method:"delItem",ids:ids},function(datas){
		_table.reLoad();
	});
}

function preDo(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='itemname']").val(name);
	doSearchsubmit();
}


function onEdit(id){
    url = "/meeting/Maint/MeetingServiceEdit.jsp?method=item&id="+id;
	showDialog(url);
}

function showDialog(url){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2157,user.getLanguage())%>";
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}

</script>
 
