<%@page import="java.util.UUID"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
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
String module = Util.null2String(request.getParameter("module")).trim();
int formid = 0;
int currentnodetype = 0;
boolean isNeverSubmit = false;//流程从未提交下去标志位
String meetingid="";
rs.executeSql("select * from meeting where requestid="+requestid);
if(rs.next()){
	meetingid=rs.getString("id");
}
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
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=8"></script>
<script language="javascript">


function meeting_doSubmit_4Mobile_callBackFun(_obj,_callBackFunType){
	if(_callBackFunType==1){
		return dosubmit(_obj);
	}else if(_callBackFunType==2){
		return dosubnoback(_obj);
	}else if(_callBackFunType==3){
		return dosubback(_obj);
	}
}

jQuery(document).ready(function(){
	doSubmit_4Mobile = function(_obj,_callBackFunType){
		var begindate="<%=begindate%>";
		var begintime="<%=begintime%>";
		var enddate="<%=enddate%>";
		var endtime="<%=endtime%>";
		var address="<%=address%>";
		var meetingid="<%=meetingid%>";
		var repeattype="<%=repeattype%>";
		var RoomConflictChk=<%=meetingSetInfo.getRoomConflictChk()%>
		var RoomConflict=<%=meetingSetInfo.getRoomConflict()%>
		//周期会议不做冲突检测
		if($("#field"+repeattype).length>0&&$("#field"+repeattype).val()>0){
		//周期会议 是否提交
			if(confirm('<%=SystemEnv.getHtmlLabelNames("33277,24355",user.getLanguage())%>')){
				meeting_doSubmit_4Mobile_callBackFun(_obj,_callBackFunType);
			};
		}else{
		
			//会议起止时间校验
			var date1=$("#field"+begindate).val();
			var date2=$("#field"+enddate).val();
			var time1=$("#field"+begintime).val();
			var time2=$("#field"+endtime).val();
			var ss1 = date1.split("-",3);
			var ss2 = date2.split("-",3);
			date1 = ss1[1]+"/"+ss1[2]+"/"+ss1[0] + " " +time1;
			date2 = ss2[1]+"/"+ss2[2]+"/"+ss2[0] + " " +time2;
			var t1,t2;
			t1 = Date.parse(date1);
			t2 = Date.parse(date2);
			if(t1>t2){
				$.alert("开始时间不能大于结束时间！",promptWrod);
				return;
			}

			 if( RoomConflictChk== 1 ){
				var strData = "&address="+$("#field"+address).val()+"&begindate="+$("#field"+begindate).val()+"&begintime="+$("#field"+begintime).val()+"&enddate="+$("#field"+enddate).val()+"&endtime="+$("#field"+endtime).val()+"&meetingid="+meetingid+"&requestid=<%=requestid%>";
				jQuery.ajax({
					url : encodeURI("/meeting/data/ChkMeetingRoom.jsp?method=chkRoom"+strData),  
					async : false,
					type : "POST",
					data: "",
					dataType : "text",  
					cache: false,
					contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					success : function(datas) {
						if(datas.trim() != 0){
							if(RoomConflict == 1){
								if(confirm(datas.trim()+"\n会议起止时间内会议室使用冲突，是否继续申请？")){
									submitChkMbr(_obj,_callBackFunType);
								}
							} else if(RoomConflict == 2) {
								alert(datas.trim()+"\n会议室冲突不能提交",promptWrod);
								
							}
						}else{
							submitChkMbr(_obj,_callBackFunType);
						}
					}  
				});  
			}else{
				submitChkMbr(_obj,_callBackFunType);
			}
		}
	}
});

//人员冲突校验
function submitChkMbr(_obj,_callBackFunType){
	var begindate="<%=begindate%>";
	var begintime="<%=begintime%>";
	var enddate="<%=enddate%>";
	var endtime="<%=endtime%>";
	var hrmmembers="<%=hrmmembers%>";
	var crmmembers="<%=crmmembers%>";
	var meetingid="<%=meetingid%>";
	var MemberConflictChk=<%=meetingSetInfo.getMemberConflictChk()%>
	var MemberConflict=<%=meetingSetInfo.getMemberConflict()%>
		
	if(MemberConflictChk == 1){
		hrmmembers=$("#field"+hrmmembers).length>0?$("#field"+hrmmembers).val():"";
		crmmembers=$("#field"+crmmembers).length>0?$("#field"+crmmembers).val():"";
		
		var strData = "&memberconflict="+MemberConflict+"&begindate="+$("#field"+begindate).val()+"&begintime="+$("#field"+begintime).val()+"&enddate="+$("#field"+enddate).val()+"&endtime="+$("#field"+endtime).val()+"&hrmids="+hrmmembers+"&crmids="+crmmembers+"&meetingid="+meetingid+"&requestid=<%=requestid%>";
		jQuery.ajax({
			url : encodeURI("/meeting/data/ChkMeetingMember.jsp?userid=<%=user.getUID()%>"+strData),  
			async : false,
			type : "POST",
			data: "",
			dataType : "text",  
			cache: false,
			contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			success : function(datas) {
				datas=datas.trim();
				var dataObj=null;
				if(datas != ''){
					dataObj=eval("("+datas+")");
				}
				if(dataObj.id == "0"){
					//meeting_doSubmit_4Mobile_callBackFun(_obj,_callBackFunType);
					submitChkService(_obj,_callBackFunType);
				} else {
					if(MemberConflict == 1){
						if(confirm(dataObj.msg)){
							//meeting_doSubmit_4Mobile_callBackFun(_obj,_callBackFunType);
							submitChkService(_obj,_callBackFunType);
						}
					} else if(MemberConflict == 2) {
						alert(dataObj.msg);
					}
				}
				
			}
		});			
	}else{
		//meeting_doSubmit_4Mobile_callBackFun(_obj,_callBackFunType);
		submitChkService(_obj,_callBackFunType);
	}
}


//会议服务冲突校验
function submitChkService(_obj,_callBackFunType){
	var begindate="<%=begindate%>";
	var begintime="<%=begintime%>";
	var enddate="<%=enddate%>";
	var endtime="<%=endtime%>";
	var meetingid="<%=meetingid%>";
	meeting_doSubmit_4Mobile_callBackFun(_obj,_callBackFunType);
}

function closeDialog() {
	jQuery.close("selectionWindow");
}

</script>