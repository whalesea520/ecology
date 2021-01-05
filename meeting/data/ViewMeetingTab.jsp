
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String navName = "";
	//if(user.getLanguage() == 8){
	//	navName = SystemEnv.getHtmlLabelName(367,user.getLanguage())+" "+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
	//} else {
	//	navName = SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
	//}
	String meetingid = Util.null2String(request.getParameter("meetingid"));
	String needRefresh=Util.null2String(request.getParameter("needRefresh"));
	navName = SystemEnv.getHtmlLabelName(2103,user.getLanguage());
	String mtname = MeetingComInfo.getMeetingInfoname(meetingid);
	int repeatType = Util.getIntValue(MeetingComInfo.getMeetingInfoRepeatTypes(meetingid), 0);
	if(!"".equals(mtname)){
		navName = mtname.replace("\"","\\\"");;
	}
	RecordSet.executeProc("Meeting_SelectByID",meetingid);
	RecordSet.next();
	String requestid=RecordSet.getString("requestid");
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("meeting")%>",
        staticOnLoad:true,
        objName:"<%=navName %>"
    });
    var discussCount=0;
    function getIframeDocument(){
    	var _contentDocument = getIframeDocument2();
    	var _contentWindow = getIframeContentWindow();
    	if(!!_contentDocument){
    		jQuery("#nomal").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#discussDiv",_contentDocument).css("display","none");
				jQuery("#memberDiv",_contentDocument).css("display","none");
				jQuery("#dicisionDiv",_contentDocument).css("display","none");
				jQuery("#signDiv",_contentDocument).css("display","none");
				hideExportExcel();
			});
			
			jQuery("#agenda").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#discussDiv",_contentDocument).css("display","none");
				jQuery("#memberDiv",_contentDocument).css("display","none");
				jQuery("#dicisionDiv",_contentDocument).css("display","none");
				jQuery("#signDiv",_contentDocument).css("display","none");
				hideExportExcel();
			});
			
			jQuery("#service").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","");
				jQuery("#discussDiv",_contentDocument).css("display","none");
				jQuery("#memberDiv",_contentDocument).css("display","none");
				jQuery("#dicisionDiv",_contentDocument).css("display","none");
				jQuery("#signDiv",_contentDocument).css("display","none");
				hideExportExcel();
			});
			
			jQuery("#discuss").bind("click",function(){
				_contentWindow = getIframeContentWindow();
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#discussDiv",_contentDocument).css("display","");
				jQuery("#memberDiv",_contentDocument).css("display","none");
				jQuery("#dicisionDiv",_contentDocument).css("display","none");
				jQuery("#signDiv",_contentDocument).css("display","none");
				hideExportExcel();
				if(discussCount==0){
					discussCount++;
					_contentWindow.resetDiv();
				}
			});
			
			jQuery("#member").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#discussDiv",_contentDocument).css("display","none");
				jQuery("#memberDiv",_contentDocument).css("display","");
				jQuery("#dicisionDiv",_contentDocument).css("display","none");
				jQuery("#signDiv",_contentDocument).css("display","none");
				//显示导出按钮
				showExportExcel();
			});
			
			jQuery("#dicision").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#discussDiv",_contentDocument).css("display","none");
				jQuery("#memberDiv",_contentDocument).css("display","none");
				jQuery("#dicisionDiv",_contentDocument).css("display","");
				jQuery("#signDiv",_contentDocument).css("display","none");
				hideExportExcel();
			});
			
			jQuery("#sign").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#discussDiv",_contentDocument).css("display","none");
				jQuery("#memberDiv",_contentDocument).css("display","none");
				jQuery("#dicisionDiv",_contentDocument).css("display","none");
				jQuery("#signDiv",_contentDocument).css("display","");
				hideExportExcel();
			});
		
    	}else{
    		window.setTimeout(function(){
    			getIframeDocument();
    		},500);
    	}
    }
    
     getIframeDocument();
});

function showExportExcel(){
	jQuery("input[name='exportMeetingMember']").css("display","");
}
function hideExportExcel(){
	jQuery("input[name='exportMeetingMember']").css("display","none");
}
</script>
<%
	boolean refresh=false;
	int meetingstatus = Util.getIntValue(RecordSet.getString("meetingstatus"));
	String url = "/meeting/data/ViewMeeting.jsp?tab=1";
	String userid=user.getUID()+"";
	String allUser=MeetingShareUtil.getAllUser(user);
	boolean canview=false;
	String Sql="";
	if(meetingstatus == 2){
		url = "/meeting/data/ProcessMeeting.jsp?tab=1";
		RecordSet.executeSql("Select * From Meeting_ShareDetail WHERE meetingid="+meetingid+" and userid in ("+allUser+") and sharelevel in (1,2,3,4)");
		if(RecordSet.next()) canview = true;
		if(!canview){
			/***检查通过审批流程查看会议***/
			RecordSet.executeSql("select userid from workflow_currentoperator where requestid = "+requestid+" and userid in ("+allUser+") ") ;
			if(RecordSet.next()){
				canview=true;
			}
		}
		if(!canview){
			if(RecordSet.getDBType().equals("oracle")){
				Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+")  ";
				String[] belongs=allUser.split(",");
				for(int i=0;i<belongs.length;i++){
					if("".equals(belongs[i])) continue;
					Sql+=" or ','|| hrmid01|| ',' like '%,"+belongs[i]+",%' ";
				}
				Sql+=")";
			}else if(RecordSet.getDBType().equals("db2")){
		        Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+") ";
		        String[] belongs=allUser.split(",");
				for(int i=0;i<belongs.length;i++){
					if("".equals(belongs[i])) continue;
					Sql+=" or concat(concat(',',hrmid01),',') like '%,"+belongs[i]+",%' ";
				}
				Sql+=")";
			}else{
				Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+") ";
				String[] belongs=allUser.split(",");
				for(int i=0;i<belongs.length;i++){
					if("".equals(belongs[i])) continue;
					Sql+=" or ','+hrmid01+',' like '%,"+belongs[i]+",%' ";
				}
				Sql+=")";
			}	
			RecordSet.executeSql(Sql);
			if(RecordSet.next()) {
				canview=true;
			}
		}
		if(!canview){
			//代理人在提醒流程和会议室报表中有查看会议的权限 MYQ 2007.12.10 开始
			RecordSet.executeSql("Select * From workflow_agentConditionSet Where workflowid=1 and agenttype=1 and agentuid in ("+allUser+")  and bagentuid in (select memberid from Meeting_Member2 where meetingid="+meetingid+")");
			if(RecordSet.next()) canview = true;
			//代理人在提醒流程和会议室报表中有查看会议的权限 MYQ 2007.12.10 结束
		}
		//标识会议已看
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("select status from Meeting_View_Status  WHERE meetingId = "+meetingid+" and userId in ("+allUser+") ");
		RecordSet.executeSql(stringBuffer.toString());
		if(RecordSet.next()){
			refresh=!"1".equals(RecordSet.getString("status"));
		}
	}else{
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("SELECT * From Meeting, Meeting_ShareDetail");
		stringBuffer.append(" WHERE Meeting.id = Meeting_ShareDetail.meetingId");
		stringBuffer.append(" AND Meeting.id = ");
		stringBuffer.append(meetingid);
		stringBuffer.append(" AND((Meeting_ShareDetail.userid in ("+allUser+") ");
		stringBuffer.append(" AND Meeting_ShareDetail.shareLevel in (1, 4))");
		stringBuffer.append(" OR (Meeting.meetingStatus = 4");
		stringBuffer.append(" AND Meeting_ShareDetail.userId in ("+allUser+")  ");
		stringBuffer.append("))");

		RecordSet.executeSql(stringBuffer.toString());
		if(RecordSet.next()){ 
			canview = true;
		}
		if(!canview){	
			/***检查是否会议室管理员****/
			RecordSet.executeSql("select resourceid from hrmrolemembers where roleid = 11 and resourceid in ("+allUser+") ") ;
			if(RecordSet.next()){
				canview=true;
			}
		}
		if(!canview){
			/***检查是否为决议执行人****/
			String hrmids = "";
			RecordSet.executeSql("select hrmid01 from meeting_decision where meetingid = " + meetingid) ;
			while(RecordSet.next()){
				hrmids = RecordSet.getString("hrmid01");
				if(hrmids.length() > 0){
					ArrayList arrHrmids01 = Util.TokenizerString(hrmids,",");
					for(Object id:arrHrmids01){//QC260016
						if(MeetingShareUtil.containUser(allUser, (String)id)){
							canview=true;
						}
					}
				}
			}
		}
		if(!canview){
			/***检查是否为决议检查人****/
			String hrmids = "";
			RecordSet.executeSql("select hrmid02 from meeting_decision where meetingid = " + meetingid) ;
			while(RecordSet.next()){
				hrmids = Util.null2String(RecordSet.getString("hrmid02"));
				if(hrmids.length() > 0){
					ArrayList arrHrmids02 = Util.TokenizerString(hrmids,",");
					for(Object id:arrHrmids02){//QC260016
						if(MeetingShareUtil.containUser(allUser, (String)id)){
							canview=true;
						}
					}
				}
			}
		}
		if(!canview&&!"".equals(requestid)){	
			/***检查通过审批流程查看会议***/
			RecordSet.executeSql("select userid from workflow_currentoperator where requestid = "+requestid+" and userid in ("+allUser+") ") ;
			if(RecordSet.next()){
				canview=true;
			}
		}
	}
	if(request.getQueryString() != null){
		url += "&"+request.getQueryString();
	}
	//判断权限
	
	if(!canview){
		out.println("<script>location.href =\"/notice/noright.jsp\";</script>");
		return;
	}
%>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						<li class="current">
							<a id="nomal" href="#" onclick="return false;" >
							   <%=SystemEnv.getHtmlLabelName(24249, user.getLanguage())%>
							</a>
						</li>
						<li>
							<a id="agenda" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(31327, user.getLanguage())%>
							</a>
						</li>
						<li>
							<a id="service" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(2107, user.getLanguage())%>
							</a>
						</li>
						<%if(repeatType == 0) {%>
						<li id="memberLi" style="display:none">
							<a id="member" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(33148, user.getLanguage())%>
							</a>
						</li>
						<li id="signLi" style="display:none">
							<a id="sign" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelNames("2103,20032",user.getLanguage())%>
							</a>
						</li>
						<li id="dicisionLi" style="display:none">
							<a id="dicision" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(2194,user.getLanguage()) %>
							</a>
						</li>
						<li id="discussLi" style="display:none">
							<a id="discuss" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(15153, user.getLanguage())%>
							</a>
						</li>
						<%} %>
					</ul>
					<div id="rightBox" class="e8_rightBox">
					</div>
				</div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
	        </div>
	    </div>
	</div>
	   
</body>
</html>
<script type="text/javascript">
function doEdit(meetingid){
	var parentWin = parent.getParentWindow(window);
	//parentWin.diag_vote.close();
	parentWin.showDlg('<%=SystemEnv.getHtmlLabelNames("26473,34076",user.getLanguage())%>', "/meeting/data/EditMeetingTab.jsp?meetingid="+meetingid,parentWin.diag_vote,parentWin);
   //location.href="/meeting/data/EditMeetingTab.jsp?meetingid="+meetingid;
}

function doCopyEdit(meetingid){
	var parentWin = parent.getParentWindow(window);
	//parentWin.diag_vote.close();
	parentWin.showDlg('<%=SystemEnv.getHtmlLabelName(15008,user.getLanguage())%>', "/meeting/data/EditMeetingTab.jsp?meetingid="+meetingid,parentWin.diag_vote,parentWin);
   //location.href="/meeting/data/EditMeetingTab.jsp?meetingid="+meetingid;
}

function forbiddenPage(){
	$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.4;filter:alpha(opacity=40);BACKGROUND-COLOR:#fff;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;padding: 10px;padding-top: 6px;padding-bottom: 6px;border: 1px solid;\"></div>").html("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
}   

function releasePage(){  
    $(".datagrid-mask,.datagrid-mask-msg").hide();  
}


function closeWinAFrsh(){
	try{
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
	}catch(e){
		newwin = window.open("","_parent","");
    	newwin.close();
	}
}

function closeDialog(){
	try{
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDialog();
	}catch(e){
		newwin = window.open("","_parent","");
    	newwin.close();
	}

}

function dataRfsh(){
	try{
		var parentWin = parent.getParentWindow(window);
		parentWin.dataRfsh();
	}catch(e){}	
}

function hideDiscuss(){
	jQuery("#discussLi").css("display","none");
}

function showDiscuss(){
	jQuery("#discussLi").css("display","");
}

function hideMember(){
	jQuery("#memberLi").css("display","none");
}

function showMember(){
	jQuery("#memberLi").css("display","");
}

function hideSign(){
	jQuery("#signLi").css("display","none");
}

function showSign(){
	jQuery("#signLi").css("display","");
}

function hideDicision(){
	jQuery("#dicisionLi").css("display","none");
}

function showDicision(){
	jQuery("#dicisionLi").css("display","");
}

function selectDicision(){
	jQuery(".current").each(function(){
		jQuery(this).removeClass("current");
	});
	jQuery("#dicisionLi").addClass("current");
}
jQuery(document).ready(function(){
	if("<%=needRefresh%>"=="false"){
		if("<%=refresh%>"=="true"){
			dataRfsh();
		}
	}else{
		dataRfsh();
	}
	
});
</script>