<%@page import="java.util.UUID"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="java.util.*"%>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String guid1 = UUID.randomUUID().toString();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
RecordSet rs = new RecordSet();

int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int formid = 0;
int currentnodetype = 0;
boolean isNeverSubmit = false;//流程从未提交下去标志位

if(workflowid <= 0){
	rs.executeSql("select workflowid, currentnodetype from workflow_requestbase where requestid = "+requestid);
	if(rs.next()){
		workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
		currentnodetype = Util.getIntValue(rs.getString("currentnodetype"), 0);
	}
}
if(requestid > 0 && currentnodetype==0){
	rs.executeSql("select count(*) cnt from workflow_requestLog a where a.logtype <> '1' and a.requestid = "+requestid);
	if(rs.next() && rs.getInt("cnt") == 0){
		isNeverSubmit = true;
	}
}else{
	isNeverSubmit = true;
}

String meetingid="";
	rs.executeSql("select * from meeting where requestid="+requestid);
	if(rs.next()){
		meetingid=rs.getString("id");
	}
String address="";
String begindate="";
String begintime="";
String enddate="";
String endtime="";
String hrmmembers="";
String crmmembers="";
int repeattype=0;
String itemsfieldid="";
rs.executeSql("select id,fieldname from workflow_billfield where billid=(select formid from workflow_base where id="+workflowid+") and fieldname in ('address','begindate','begintime','enddate','endtime','repeatType','hrmmembers','crmmembers','items')");
while(rs.next()){
	if("address".equals(rs.getString("fieldname"))){
		address=Util.null2String(rs.getString("id"));
	}else if("begindate".equals(rs.getString("fieldname"))){
		begindate=Util.null2String(rs.getString("id"));
	}else if("begintime".equals(rs.getString("fieldname"))){
		begintime=Util.null2String(rs.getString("id"));
	}else if("enddate".equals(rs.getString("fieldname"))){
		enddate=Util.null2String(rs.getString("id"));
	}else if("endtime".equals(rs.getString("fieldname"))){
		endtime=Util.null2String(rs.getString("id"));
	}else if("hrmmembers".equals(rs.getString("fieldname"))){
		hrmmembers=Util.null2String(rs.getString("id"));
	}else if("crmmembers".equals(rs.getString("fieldname"))){
		crmmembers=Util.null2String(rs.getString("id"));
	}else if("repeatType".equals(rs.getString("fieldname"))){
		repeattype=Util.getIntValue(rs.getString("id"),0);
	}else if("items".equals(rs.getString("fieldname"))){
		itemsfieldid=Util.null2String(rs.getString("id"));
	}
}

%>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=11"></script>
<script language="javascript">

//人员冲突校验
function submitChkMbr(obj){
	var begindate="<%=begindate%>";
	var begintime="<%=begintime%>";
	var enddate="<%=enddate%>";
	var endtime="<%=endtime%>";
	var hrmmembers="<%=hrmmembers%>";
	var crmmembers="<%=crmmembers%>";
	var meetingid="<%=meetingid%>";
	 if(<%=meetingSetInfo.getMemberConflictChk()%> == 1){
	hrmmembers=jQuery("#field"+hrmmembers).length>0?jQuery("#field"+hrmmembers).val():"";
	crmmembers=jQuery("#field"+crmmembers).length>0?jQuery("#field"+crmmembers).val():"";
  		jQuery.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkMember",
  			{hrmids:hrmmembers,crmids:crmmembers,
  			begindate:jQuery("#field"+begindate).val(),begintime:jQuery("#field"+begintime).val(),
  			enddate:jQuery("#field"+enddate).val(),endtime:jQuery("#field"+endtime).val(),meetingid:meetingid},
  			function(datas){
				var dataObj=null;
				if(datas != ''){
					dataObj=eval("("+datas+")");
				}
				if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
					return submitChkService(obj);
				} else {
					<%if(meetingSetInfo.getMemberConflict() == 1){ %>
			            window.top.Dialog.confirm(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32873,user.getLanguage())%>?", function (){
			                return submitChkService(obj);
			            },null, null, 120);
		            <%} else if(meetingSetInfo.getMemberConflict() == 2) {%>
		            	Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32874,user.getLanguage())%>" ,null ,400 ,150);
		            <%}%>
				} 
			});
       } else {
       		return submitChkService(obj);
       }
}

meeting_doSubmit = function(obj){
	var address="<%=address%>";
	var begindate="<%=begindate%>";
	var begintime="<%=begintime%>";
	var enddate="<%=enddate%>";
	var endtime="<%=endtime%>";
	var repeattype="<%=repeattype%>";
	var meetingid="<%=meetingid%>";
	if(jQuery("#field"+address).length==0||jQuery("#field"+begindate).length==0||jQuery("#field"+begintime).length==0||jQuery("#field"+enddate).length==0||jQuery("#field"+endtime).length==0){
		 Dialog.alert("<%=SystemEnv.getHtmlLabelNames("81901,21695,2105,17023",user.getLanguage())%>");
		 return;
	}
	//周期会议不做冲突检测
	if(jQuery("#field"+repeattype).length>0&&jQuery("#field"+repeattype).val()>0){
	//周期会议 是否提交
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("33277,24355",user.getLanguage())%>", function (){
			return doSubmitE8(obj);
		});
	}else{
	 //会议室冲突校验
		if(<%=meetingSetInfo.getRoomConflictChk()%> == 1 ){
			jQuery.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkRoom",{
				address:jQuery("#field"+address).val(), begindate:jQuery("#field"+begindate).val(),begintime:jQuery("#field"+begintime).val(),enddate:jQuery("#field"+enddate).val(),endtime:jQuery("#field"+endtime).val(),meetingid:meetingid},
			    function(datas){
					if(datas != 0){
						<%if(meetingSetInfo.getRoomConflict() == 1){ %>
					        window.top.Dialog.confirm(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>", function (){
					        	return submitChkMbr(obj);
					    	});
					    <%} else if(meetingSetInfo.getRoomConflict() == 2) {%>
					        Dialog.alert(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(32875,user.getLanguage())%>。");
					    <%}%>
					} else {
						return submitChkMbr(obj);
					}
				});	
			} else {
				return submitChkMbr(obj);
			}
	}
}

//会议服务冲突校验
function submitChkService(obj){
	var begindate="<%=begindate%>";
	var begintime="<%=begintime%>";
	var enddate="<%=enddate%>";
	var endtime="<%=endtime%>";
	var meetingid="<%=meetingid%>";
      return doSubmitE8(obj);
}

jQuery(document).ready(function(){
});
</script>