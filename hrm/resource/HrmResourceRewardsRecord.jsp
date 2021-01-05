<%@ page import="weaver.general.Util,weaver.conn.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ include file="/hrm/header.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
AllManagers.getAll(resourceid);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
//added by hubo,20060113
if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());
boolean isSelf		=	false;
boolean isManager	=	false;
if (resourceid.equals(""+user.getUID()) ){
	isSelf = true;
}
while(AllManagers.next()){
	String tempmanagerid = AllManagers.getManagerID();
	if (tempmanagerid.equals(""+user.getUID())) {
		isManager = true;
	}
}
if(!(isSelf||isManager||HrmUserVarify.checkUserRight("HrmResource:RewardsRecord",user))) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16065,user.getLanguage());
String needfav ="1";
String needhelp ="";

String startdateselect = Util.null2String(request.getParameter("startdateselect"));
String enddateselect = Util.null2String(request.getParameter("enddateselect")); 
String checkname = Util.null2String(request.getParameter("checkname"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
String startdate = Util.null2String(request.getParameter("startdate"));
String startdateTo = Util.null2String(request.getParameter("startdateTo"));
String enddate = Util.null2String(request.getParameter("enddate"));
String enddateTo = Util.null2String(request.getParameter("enddateTo"));

if(!startdateselect.equals("") && !startdateselect.equals("0")&& !startdateselect.equals("6")){
	startdate = TimeUtil.getDateByOption(startdateselect,"0");
	startdateTo = TimeUtil.getDateByOption(startdateselect,"1");
}
if(!enddateselect.equals("") && !enddateselect.equals("0")&& !enddateselect.equals("6")){
	enddate = TimeUtil.getDateByOption(enddateselect,"0");
	enddateTo = TimeUtil.getDateByOption(enddateselect,"1");
}
if(enddate.length() == 0){
	enddate = currentdate;
}
String result = Util.null2String(request.getParameter("result"));
String qname = Util.null2String(request.getParameter("flowTitle"));

String sqlwhere = "";

%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function doEdit(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCheckMark&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6106,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCheckMark&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6106,user.getLanguage())%>";
	}
	dialog.Width = 800;
	dialog.Height = 503;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<BODY>
<% if(!isfromtab){%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="searchfrm" id="searchfrm" action="HrmResourceRewardsRecord.jsp" method="post" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item>		
			<%=SystemEnv.getHtmlLabelName(15653,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<input name="checkname" type="text" class="inputStyle" value="<%=checkname%>">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%>
		</wea:item>
		<wea:item>
 			<brow:browser viewType="0"  name="resourceids" browserValue='<%=resourceids %>' 
        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
        completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="165px"
        browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceids),user.getLanguage()) %>'>
        </brow:browser>
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
		<wea:item>
       <span>
      	<select name="startdateselect" id="startdateselect" onchange="changeDate(this,'spanStartdate');" style="width: 135px">
      		<option value="0" <%=startdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=startdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=startdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=startdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=startdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=startdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=startdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanStartdate style="<%=startdateselect.equals("6")?"":"display:none;" %>">
      		<BUTTON type="button" class=Calendar id=selectstartdate onclick="getstartDate()"></BUTTON>
       		<SPAN id=startdatespan ><%=startdate%></SPAN>－
       		<BUTTON type="button" class=Calendar id=selectstartdateTo onclick="getstartDateTo()"></BUTTON>
       		<SPAN id=startdateTospan ><%=startdateTo%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>">
       <input class=inputstyle type="hidden" id="startdateTo" name="startdateTo" value="<%=startdateTo%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		<wea:item>
       <span>
      	<select name="enddateselect" id="enddateselect" onchange="changeDate(this,'spanenddate');"  style="width: 135px">
      		<option value="0" <%=enddateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
      		<option value="1" <%=enddateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
      		<option value="2" <%=enddateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
      		<option value="3" <%=enddateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
      		<option value="4" <%=enddateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
      		<option value="5" <%=enddateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
      		<option value="6" <%=enddateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
      	</select>
       </span>
       <span id=spanenddate style="<%=enddateselect.equals("6")?"":"display:none;" %>">
  			<BUTTON type="button" class=Calendar id=selectenddate onclick="getendDate()"></BUTTON>
      	<SPAN id=enddatespan ><%=enddate%></SPAN>－
      	<BUTTON type="button" class=Calendar id=selectenddateTo onclick="getendDateTo()"></BUTTON>
      	<SPAN id=enddateTospan ><%=enddateTo%></SPAN>
       </span>
       <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
       <input class=inputstyle type="hidden" name="enddateTo" value="<%=enddateTo%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15657,user.getLanguage()) %></wea:item>
		<wea:item><input type="text" id="result" name="result" class="result" value=<%=result%>></wea:item>
		<wea:item>&nbsp;</wea:item>
		<wea:item>&nbsp;</wea:item>
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	  </wea:item>
	</wea:group>
</wea:layout>
</div>
</form>
<%
String backfields = " a.id, b.checkname, a.resourceid, b.startdate, b.enddate, a.result "; 
String fromSql  = " from HrmByCheckPeople a left join HrmCheckList b on a.checkid = b.id ";
String sqlWhere = " where a.checkercount="+resourceid;
String orderby = "b.startdate " ;
String tableString = "";

if(resourceids.length() > 0){
	sqlWhere += " and a.resourceid in ("+resourceids+") ";
}
if(!qname.equals("")){
	sqlWhere += " and checkname like '%"+qname+"%'";
}		

if (!"".equals(checkname)) {
	sqlWhere += " and checkname like '%"+checkname+"%'";
	}  	  	

if(startdate.length()>0){
	sqlWhere += " and b.startdate >= '"+startdate+"'";
}

if(startdateTo.length()>0){
	sqlWhere += " and b.startdate <= '"+startdateTo+"'";
}

if(enddate.length()>0){
	sqlWhere += " and b.enddate >= '"+enddate+"'";
}

if(enddateTo.length()>0){
	sqlWhere += " and b.enddate <= '"+enddateTo+"'";
}

if(result.length()>0){
	sqlWhere += " and a.result = '"+result+"'";
}
String operateString= "<operates width=\"20%\">";
	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"true\"></popedom> ";
	operateString+="     <operate href=\"javascript:doEdit();return false;\" text=\""+SystemEnv.getHtmlLabelName(6106,user.getLanguage())+"\" index=\"0\"/>";
	operateString+="</operates>";
tableString =" <table instanceid=\"hrmResourceRewardRecordTable\" tabletype=\"none\" pagesize=\""+ PageIdConst.getPageSize(PageIdConst.HRM_ResourceRewardRecord,user.getUID(),PageIdConst.HRM)+"\" pageId=\""+PageIdConst.HRM_ResourceRewardRecord+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqlisdistinct=\"false\"/>"+
	operateString+
    "			<head>"+
    "				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15653,user.getLanguage())+"\" column=\"checkname\" orderkey=\"checkname\" transmethod=\"weaver.hrm.common.plugin.PluginTagFormat.colFormat\" otherpara=\"HrmResourceRewardsRecord+"+"+column:id+\" />"+
    "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"startdate\" orderkey=\"startdate\"/>"+
    "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\"/>"+
    "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(15648,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastnames\" />"+
    "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(15657,user.getLanguage())+"\" column=\"result\" orderkey=\"result\"/>"+
    "			</head>"+
    " </table>";
%>
 <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceRewardRecord %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
