
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ page import="java.util.*,weaver.sms.SMSSaveAndSend" %>
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />

<% if(!HrmUserVarify.checkUserRight("SmsManage:View",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>

</head>
<%
int timeSag = Util.getIntValue(request.getParameter("timeSag"),1);
String isdelete=Util.null2String(request.getParameter("delete"));
String deleteids=Util.null2String(request.getParameter("deleteids"));
String ip=Util.getIpAddr(request);
if(isdelete.equals("1")){ 
	String tempdeleteids = deleteids.substring(0,deleteids.lastIndexOf(","));
	RecordSet.executeSql("delete from SMS_Message where id in ("+tempdeleteids+")");
	String[] IDs=tempdeleteids.split(",");
    for(int i=0;i<IDs.length;i++){
    	String id=IDs[i];
    	if("".equals(id)) continue;
	    CommunicateLog.resetParameter();
	    CommunicateLog.insSysLogInfo(user,Util.getIntValue(id),"删除短信","永久删除短信","396","3",1,ip);
    }
}else if("resend".equals(isdelete)&& null != deleteids && !"".equals(deleteids)){
	SMSSaveAndSend sms=new SMSSaveAndSend();
	sms.reSend(deleteids);
	String[] IDs=deleteids.split(",");
	for(int i=0;i<IDs.length;i++){
    	String id=IDs[i];
    	if("".equals(id)) continue;
	    CommunicateLog.resetParameter();
	    CommunicateLog.insSysLogInfo(user,Util.getIntValue(id),"重发短信","重发短信","396","29",1,ip);
    }
}

    int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
    int perpage = Util.getPerpageLog();

    if (perpage <= 1) perpage = 10;

    String fromdate = Util.fromScreen(request.getParameter("fromdate"), user.getLanguage());
    String enddate = Util.fromScreen(request.getParameter("enddate"), user.getLanguage());
    String messagetype = Util.fromScreen(request.getParameter("messagetype"), user.getLanguage());
    String messagestatus=Util.fromScreen(request.getParameter("messagestatus"),user.getLanguage());
    String deleted=Util.null2String(request.getParameter("deleted"));
	String msg=Util.fromScreen(request.getParameter("msg"),user.getLanguage());
	
    int objType = Util.getIntValue(request.getParameter("objType"), 1);
	String objId = Util.null2String(request.getParameter("objId"));
	String objName = "";
	String subid = "";
	String departmentid = "";
	String userid = "";
	if(objType == 1){
		userid = objId;
		//objName = "<a href='javaScript:openhrm("+objId+");' onclick='pointerXY(event);'>"+resourceComInfo.getLastname(userid)+"</a>&nbsp";
	}else if(objType == 2){
		departmentid = objId;
		//objName = "<a href=\"javaScript:openFullWindowHaveBar('/hrm/company/HrmDepartmentDsp.jsp?id="+objId+"')\">"+departmentComInfo.getDepartmentname(departmentid)+"</a>&nbsp";
	}else if(objType == 3){
		subid = objId;
		//objName = "<a href=\"javaScript:openFullWindowHaveBar('/hrm/company/HrmSubCompanyDsp.jsp?id="+objId+"')\">"+subCompanyComInfo.getSubCompanyname(subid)+"</a>&nbsp";
	}

    String sqlwhere = " where 1=1 ";

	if(!deleted.equals("")){
		sqlwhere += " and s.isdelete="+deleted;
	}
    if (!"".equals(objId)) {
    	if(objType == 1){
			sqlwhere += " and h.id=" + objId;
    	}else if(objType == 2){
    		sqlwhere += " and h.departmentid=" + objId;
    	}else if(objType == 3){
    		sqlwhere += " and h.subcompanyid1=" + objId;
    	}
    }
    //时间处理
	if(timeSag > 0&&timeSag<6){
		String tempfromdate = TimeUtil.getDateByOption(""+timeSag,"0");
		String tempenddate = TimeUtil.getDateByOption(""+timeSag,"1");
		if(!tempfromdate.equals("")){
			sqlwhere += " and s.finishtime >= '" + tempfromdate + " 00:00:00'";
		}
		if(!tempenddate.equals("")){
			sqlwhere += " and s.finishtime <= '" + tempenddate + " 23:59:59'";
		}
	}else{
		if(timeSag==6){//指定时间
			if (!fromdate.equals("")) {
			    sqlwhere += " and s.finishtime>='" + fromdate + " 00:00:00'";
			}
			if (!enddate.equals("")) {
			    sqlwhere += " and s.finishtime<='" + enddate + " 23:59:59'";
			}
		}
	}

    if(!messagetype.equals("")){
        sqlwhere+=" and s.messagetype = '"+messagetype+"'";
    }
    if(!messagestatus.equals("")){
        sqlwhere+=" and s.messagestatus = '"+messagestatus+"'";
    }
    if(!"".equals(msg)){
    	sqlwhere+=" and s.message like '%"+msg+"%'";
    }
    //System.out.println("sqlwhere:"+sqlwhere);

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(16891, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
%>
<BODY>
<iframe id="iframeSmsManage" style="display: none"></iframe>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%    
    RCMenu += "{" + SystemEnv.getHtmlLabelName(2031, user.getLanguage()) + ",javascript:doDelete(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + SystemEnv.getHtmlLabelName(28343, user.getLanguage()) + ",javascript:exportXSL(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2031,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doDelete()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(16443,user.getLanguage())%></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<form id="weaverA" name="weaverA" method="post" action="SmsManage.jsp">
	<input type="hidden" name="delete" value="">
	<input type="hidden" name="deleteids" value="">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<wea:item><%=SystemEnv.getHtmlLabelName(18529,user.getLanguage())%></wea:item>
            <wea:item>
              	<input type="text" id="msg" name="msg" value="<%=msg %>" class="InputStyle">
            </wea:item>
            
			<wea:item><%=SystemEnv.getHtmlLabelName(18523,user.getLanguage())%></wea:item>
            <wea:item>
              <select class=saveHistory id=messagestatus  name=messagestatus style="width:100px;">
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value=0 <%if(messagestatus.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18525,user.getLanguage())%></option>
				<option value=1 <%if(messagestatus.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27564,user.getLanguage())%></option>
			 	<option value=3 <%if(messagestatus.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22397,user.getLanguage())%></option>
				<option value=2 <%if(messagestatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18966,user.getLanguage())%></option>
			 </select>
            </wea:item>

			<wea:item><%=SystemEnv.getHtmlLabelName(18527,user.getLanguage())%></wea:item>
			<wea:item>
			  <select class=saveHistory id=messagetype  name=messagetype style="width:100px;">
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value=2 <%if(messagetype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18528,user.getLanguage())%></option>
				<option value=1 <%if(messagetype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())%></option>
			 </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
			  <select class=saveHistory id=deleted  name=deleted style="width:100px;">
				<option value="" <%if(deleted.equals("")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value=0 <%if(deleted.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21269,user.getLanguage())%></option>
				<option value=1 <%if(deleted.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18967,user.getLanguage())%></option>
			 </select>
			</wea:item>
				<%
                  if(!user.getLogintype().equals("2")){
				%>
				<wea:item><%=SystemEnv.getHtmlLabelName(16975, user.getLanguage())%></wea:item>
				<wea:item>
						<div style="width:100px;float:left">
						<select name=objType id=objType style="width:55px;" onChange="onChangeType()">
							<option value="1" <%if (objType==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
							<option value="2" <%if (objType==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							<option value="3" <%if (objType==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
						</select>
						</div>
						<div style="float:left">
						<span id="subidSP" style="float:right;margin-right:100px;">
						<brow:browser viewType="0" name="subid" browserValue='<%=subid%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" 
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
						completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
						browserSpanValue='<%=subCompanyComInfo.getSubCompanyname(subid)%>'></brow:browser>
						</span>
						
						<span id="departmentidSP" style="float:right;margin-right:100px;">
						<brow:browser viewType="0" name="departmentid" browserValue='<%=departmentid%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
						completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
						browserSpanValue='<%=departmentComInfo.getDepartmentname(departmentid)%>'></brow:browser>
						</span>
						
						<span id="useridSP" style="float:right;margin-right:100px;">
						<brow:browser viewType="0" name="userid" browserValue='<%=userid%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=" 
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="150px"
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue='<%=resourceComInfo.getLastname(userid)%>'></brow:browser>
						</span>
						</div>
						<input type="hidden" name="objId" id="objId" value="<%="0".equals(objId)?"":objId%>">
				</wea:item>
				
				<%}%>
				<wea:item> <%=SystemEnv.getHtmlLabelName(18530,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
                          	<select name="timeSag" id="timeSag" onchange="changeTimeSag(this,'senddate');" style="width:100px;">
                          		<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                          		<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
                          		<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
                          		<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
                          		<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
                          		<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
                          		<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
                          	</select>
                          </span>
                          <span id="senddate"  style="<%=timeSag==6?"":"display:none;" %>">
                          	  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
							  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
							  <input type="hidden" name="fromdate" value=<%=fromdate%>>
							  －&nbsp;&nbsp;<BUTTON type=button class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
							  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
							  <input type="hidden" name="enddate" value=<%=enddate%>>
						 </span>
			</wea:item>
		</wea:group>
		<wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" onclick="doSubmit();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
	    </wea:group>
	</wea:layout>
</form>
</div>
<%
	String tableString = "";
	int perpagen=10;                       
	String backfields = "s.*";
	String fromSql  = " SMS_Message s left join hrmresource h on s.userid=h.id ";
	tableString =   " <table name=\"msgtable\" instanceid=\"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.SMS_SmsManage,user.getUID())+"\" >"+
					" <checkboxpopedom  id=\"checkbox\" popedompara=\"1\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCheckbox\"  />"+
					"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"s.id\"  sqlprimarykey=\"s.id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
					"       <head>"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16975,user.getLanguage())+"\" column=\"messageType\" orderkey=\"messageType\" otherpara=\"column:UserType+column:UserID+column:sendNumber+column:toUserType+column:toUserID\" transmethod=\"weaver.splitepage.transform.SptmForSms.getSend\"  />"+
					"           <col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(15525, user.getLanguage())+"\" column=\"messageType\" orderkey=\"messageType\" otherpara=\"column:toUserType+column:toUserID+column:recieveNumber+column:UserType+column:UserID\" transmethod=\"weaver.splitepage.transform.SptmForSms.getRecieve\" />"+
					"           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(18529,user.getLanguage())+"\" column=\"message\" orderkey=\"message\"  />"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18523, user.getLanguage())+"\" column=\"messageStatus\" orderkey=\"messageStatus\" otherpara=\""+user.getLanguage()+"+column:isdelete\" transmethod=\"weaver.splitepage.transform.SptmForSms.getPersonalViewMessageStatus\" />"+
					"			<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18527,user.getLanguage())+"\" column=\"messageType\" orderkey=\"messageType\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForSms.getMessageType\" />"+
					"           <col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(18530,user.getLanguage())+"\" column=\"finishtime\" orderkey=\"finishtime\"  />"+
				  "</head>";
tableString +=  "<operates>"+
				"		<popedom column=\"id\" otherpara=\"column:messageStatus\" transmethod=\"weaver.splitepage.transform.SptmForSms.getSmsOpt\"></popedom> "+
				"		<operate href=\"javascript:resendSms();\" text=\""+SystemEnv.getHtmlLabelName(22408,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:viewDetail();\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:delMsg();\" text=\""+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"</operates>";
tableString += "</table>";
	
	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.SMS_SmsManage%>"/>
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

</body>
<script language="javascript">
jQuery(document).ready(function(){
	jQuery("li.current",parent.document).removeClass("current");
	if(jQuery("#timeSag").val()=="0"){
		jQuery("#ALLli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="1"){
		jQuery("#TODAYli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="2"){
		jQuery("#WEEKli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="3"){
		jQuery("#MOUTHli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="4"){
		jQuery("#SEASONli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="5"){
		jQuery("#YEARli",parent.document).addClass("current");
	} else {
		jQuery("#ALLli",parent.document).addClass("current");
	}
});
function onChangeType(){
	thisvalue=jQuery("#objType").val();

	if (thisvalue == 1) {
		jQuery($GetEle("subidSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
	}
	else {
		jQuery("#objType").val(1);
		jQuery("#objType").trigger("change");
		jQuery($GetEle("subidSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
	}
	
	//jQuery("#objId").val("");
}
function doSubmit()
{
	thisvalue=jQuery("#objType").val();

	if (thisvalue == 1) {
		jQuery("#objId").val(jQuery($GetEle("userid")).val());
    }
	else if (thisvalue == 2) {
		jQuery("#objId").val(jQuery($GetEle("departmentid")).val());
	}
	else if (thisvalue == 3) {
		jQuery("#objId").val(jQuery($GetEle("subid")).val());
	}
	jQuery("#weaverA").submit();
}
function hiddenDel(){
    doSubmit();
}
function doDelete(){
	var deleteids = "";
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))
			deleteids = deleteids +$(this).attr("checkboxId")+",";
	});
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			$GetEle("delete").value = 1;
			$GetEle("deleteids").value = deleteids;
			jQuery("#weaverA").submit();
		});
	}
}

function childDelMsg(id){
	$GetEle("delete").value = 1;
	$GetEle("deleteids").value = id+",";
	jQuery("#weaverA").submit();
}

function changeTimeSag(obj,spanname){
	if($(obj).val()=="6"){
		$('#'+spanname).show();
	}else{
		$('#'+spanname).hide();
	}
}

var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function viewDetail(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(18529,user.getLanguage())%>";
	diag_vote.URL = "/sms/SmsViewTab.jsp?from=mrg&id="+id;
	diag_vote.show();
}

function delMsg(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
		$GetEle("delete").value = 1;
		$GetEle("deleteids").value = id+",";
		jQuery("#weaverA").submit();
    });
}

function resendSms(id){

	var str = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(22408,user.getLanguage())%>?";
 	window.top.Dialog.confirm(str,function(){
		 jQuery("input[name=delete]").val("resend");
         jQuery("input[name=deleteids]").val(id);
         document.forms[0].submit();
    });
}

function childResendSms(id){
		jQuery("input[name=delete]").val("resend");
         jQuery("input[name=deleteids]").val(id);
         document.forms[0].submit();
}

</script>

<script type="text/javascript">
//<!--
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function onShowDepartment(inputename,showname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedDepartmentIds=" + $G(inputename).value + "&selectedids=" + $G(inputename).value
			, $G(showname)
			, $G(inputename)
			, false
			, "/hrm/company/HrmDepartmentDsp.jsp?id=");
}

function onShowResource(inputename,showname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=" + $G(inputename).value;
	var spanobj =  $G(showname);
	var inputobj = $G(inputename);

	var id = window.showModalDialog(url, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			spanobj.innerHTML = "<A href='javaScript:openhrm(" + wuiUtil.getJsonValueByIndex(id, 0) + ")' onclick='pointerXY(event);' "
					+ ">"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = "";
			inputobj.value = "";
		}
	}
}

function onShowBranch(inputename,showname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G(inputename).value + "&selectedDepartmentIds=" + $G(inputename).value
			, $G(showname)
			, $G(inputename)
			, false
			, "/hrm/company/HrmSubCompanyDsp.jsp?id=");
}
//-->
</script>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


<script  language="javascript">
/**
*清空搜索条件
*/
function resetCondtionAVS(){
	//清空文本框
	jQuery("#advancedSearchDiv").find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery("#advancedSearchDiv").find(".Browser").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery("#advancedSearchDiv").find("select").val("0");
	jQuery("#advancedSearchDiv").find("select").trigger("change");
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
	
	//清空短信状态
	jQuery("#messagestatus").val("");
	jQuery("#messagestatus").trigger("change");
	//清空短信状态
	jQuery("#messagetype").val("");
	jQuery("#messagetype").trigger("change");
	
	//清空短信状态
	jQuery("#deleted").val("");
	jQuery("#deleted").trigger("change");
	
	jQuery("#advancedSearchDiv").find("select").selectbox('detach');
	jQuery("#advancedSearchDiv").find("select").selectbox('attach');
	
	$("#timeSag").val(0);
	$("#timeSag").selectbox('detach');
	$("#timeSag").selectbox('attach');
	changeTimeSag($('#timeSag'),'senddate');
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#msg").val(name);
	doSubmit();
}
function exportXSL()
{
	document.getElementById("iframeSmsManage").src = "SmsManageExcel.jsp?fromdate=<%=fromdate%>&enddate=<%=enddate%>&messagetype=<%=messagetype%>&messagestatus=<%=messagestatus%>&objType=<%=objType%>&objId=<%=objId%>";
}
jQuery(document).ready(function(){
	onChangeType();
});
</script>
