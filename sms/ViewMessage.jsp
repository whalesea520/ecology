
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.splitepage.transform.SptmForSms" %>
<%@ page import="java.util.*,weaver.sms.SMSSaveAndSend" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
int timeSag = Util.getIntValue(request.getParameter("timeSag"),1);
String useridname=ResourceComInfo.getResourcename(userid+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String messagetype=Util.fromScreen(request.getParameter("messagetype"),user.getLanguage());
String messagestatus=Util.fromScreen(request.getParameter("messagestatus"),user.getLanguage());
String isDelete = Util.null2String(request.getParameter("isDelete"));
String msg=Util.fromScreen(request.getParameter("msg"),user.getLanguage());

String messageIDs = Util.null2String(request.getParameter("messageIDs"));
String ip=Util.getIpAddr(request);
if("true".equals(isDelete) && null != messageIDs && !"".equals(messageIDs)){    
    messageIDs = messageIDs.substring(0, messageIDs.length() - 1);
    //System.out.println(messageIDs);
    String temStr = "update SMS_Message set isdelete='1' where id in ("+messageIDs+") and userid="+userid;
    //System.out.println(temStr);
    RecordSet.executeSql(temStr);
    String[] IDs=messageIDs.split(",");
    for(int i=0;i<IDs.length;i++){
    	String id=IDs[i];
    	if("".equals(id)) continue;
	    CommunicateLog.resetParameter();
	    CommunicateLog.insSysLogInfo(user,Util.getIntValue(id),"删除短信","逻辑删除短信","396","3",1,ip);
    }
    
}else if("resend".equals(isDelete)&& null != messageIDs && !"".equals(messageIDs)){
	SMSSaveAndSend sms=new SMSSaveAndSend();
	sms.reSend(messageIDs);
	String[] IDs=messageIDs.split(",");
	for(int i=0;i<IDs.length;i++){
    	String id=IDs[i];
    	if("".equals(id)) continue;
	    CommunicateLog.resetParameter();
	    CommunicateLog.insSysLogInfo(user,Util.getIntValue(id),"重发短信","重发短信","396","29",1,ip);
    }
}

String sqlwhere=" where isdelete='0' ";
if(userid!=0){
	sqlwhere+=" and userid="+userid;
}

//时间处理
if(timeSag > 0&&timeSag<6){
	String tempfromdate = TimeUtil.getDateByOption(""+timeSag,"0");
	String tempenddate = TimeUtil.getDateByOption(""+timeSag,"1");
	if(!tempfromdate.equals("")){
		sqlwhere += " and finishtime >= '" + tempfromdate + " 00:00:00'";
	}
	if(!tempenddate.equals("")){
		sqlwhere += " and finishtime <= '" + tempenddate + " 23:59:59'";
	}
}else{
	if(timeSag==6){//指定时间
		if (!fromdate.equals("")) {
		    sqlwhere += " and finishtime>='" + fromdate + " 00:00:00'";
		}
		if (!enddate.equals("")) {
		    sqlwhere += " and finishtime<='" + enddate + " 23:59:59'";
		}
	}
}

if(!messagetype.equals("")){
	sqlwhere+=" and messagetype = '"+messagetype+"'";

}
if(!messagestatus.equals("")){
	sqlwhere+=" and messagestatus = '"+messagestatus+"'";
}
if(!"".equals(msg)){
   	sqlwhere+=" and message like '%"+msg+"%'";
}
 
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16443,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doDelete()"/>
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
<form id="weaverA" name="weaverA" method="post" action="ViewMessage.jsp">
<input type="hidden" name="isDelete" value="false">
<input type="hidden" name="messageIDs" value="">
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
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
	    </wea:group>
	</wea:layout>
</form>
</div>
	<%
	String tableString = "";
	int perpage=10;                       
	String backfields = "*";
	String fromSql  = " SMS_Message ";
	tableString =   " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.SMS_ViewMessage,user.getUID())+"\" >"+
					" <checkboxpopedom  id=\"checkbox\" popedompara=\"1\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCheckbox\"  />"+
					"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
					"       <head>"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16975,user.getLanguage())+"\" column=\"messageType\" orderkey=\"messageType\" otherpara=\"column:UserType+column:UserID+column:sendNumber+column:toUserType+column:toUserID\" transmethod=\"weaver.splitepage.transform.SptmForSms.getSend\"  />"+
					"           <col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(15525, user.getLanguage())+"\" column=\"messageType\" orderkey=\"messageType\" otherpara=\"column:toUserType+column:toUserID+column:recieveNumber+column:UserType+column:UserID\" transmethod=\"weaver.splitepage.transform.SptmForSms.getRecieve\" />"+
					"           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(18529,user.getLanguage())+"\" column=\"message\" orderkey=\"message\"  />"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18523, user.getLanguage())+"\" column=\"messageStatus\" orderkey=\"messageStatus\" otherpara=\""+user.getLanguage()+"+column:isdelete\" transmethod=\"weaver.splitepage.transform.SptmForSms.getPersonalViewMessageStatus\" />"+
					"			<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18527,user.getLanguage())+"\" column=\"messageType\" orderkey=\"messageType\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForSms.getMessageType\" />"+
					"			<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(18530,user.getLanguage())+"\" column=\"finishTime\" orderkey=\"finishTime\"  />"+
				  "</head>";
tableString +=  "<operates>"+
				"		<popedom column=\"id\" otherpara=\"column:messageStatus\" transmethod=\"weaver.splitepage.transform.SptmForSms.getSmsOpt\"></popedom> "+
				"		<operate href=\"javascript:resendSms();\" text=\""+SystemEnv.getHtmlLabelName(22408,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:viewDetail();\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:delMsg();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"</operates>";
tableString += "</table>";

	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.SMS_ViewMessage%>"/>
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

function doDelete(){
	var ids = "";
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))
			ids = ids +$(this).attr("checkboxId")+",";
	});
	if(ids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			
	        jQuery("input[name=isDelete]").val("true");
	        jQuery("input[name=messageIDs]").val(ids);
	        document.forms[0].submit();
	    });
	}	
}
function doSubmit()
{
	document.forms[0].submit();
}
function resetCondtion(){
	jQuery("#msg").val("");
	//清空短信状态
	jQuery("#messagestatus").val("");
	jQuery("#messagestatus").trigger("change");
	//清空短信状态
	jQuery("#messagetype").val("");
	jQuery("#messagetype").trigger("change");
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
	
	
	jQuery("#advancedSearchDiv").find("select").selectbox('detach');
	jQuery("#advancedSearchDiv").find("select").selectbox('attach');
	$("#timeSag").val(0);
	$("#timeSag").selectbox('detach');
	$("#timeSag").selectbox('attach');
	changeTimeSag($('#timeSag'),'senddate');
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
	diag_vote.URL = "/sms/SmsViewTab.jsp?from=view&id="+id;
	diag_vote.show();
}

function delMsg(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
 		jQuery("input[name=isDelete]").val("true");
        jQuery("input[name=messageIDs]").val(id+",");
        document.forms[0].submit();
    });
}

function childDelMsg(id){
	jQuery("input[name=isDelete]").val("true");
    jQuery("input[name=messageIDs]").val(id+",");
    document.forms[0].submit();
}

function resendSms(id){

	var str = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(22408,user.getLanguage())%>?";
 	window.top.Dialog.confirm(str,function(){
		 jQuery("input[name=isDelete]").val("resend");
         jQuery("input[name=messageIDs]").val(id);
         document.forms[0].submit();
    });
}

function childResendSms(id){
	jQuery("input[name=isDelete]").val("resend");
    jQuery("input[name=messageIDs]").val(id);
    document.forms[0].submit();
}
</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>


<script  language="javascript">

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

</script>
