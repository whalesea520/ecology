
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<div id="memberListDiv">
	<jsp:include page="AjaxMeetingMember.jsp" flush="true">
         <jsp:param name="meetingid" value="<%=meetingid%>" />
         <jsp:param name="canJueyi" value="<%=canJueyi%>" />
         <jsp:param name="isdecision" value="<%=isdecision%>" />
         <jsp:param name="othermembers" value="<%=othermembers%>" />
         <jsp:param name="othersremark" value="<%=othersremark%>" />
         <jsp:param name="ismanager" value="<%=ismanager%>" />
     </jsp:include>
</div>
<script language="javascript">
function onShowReCrm(recorderid,meetingid){
	//showDialog("/meeting/data/MeetingReCrm.jsp?recorderid="+recorderid+"&meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2108, user.getLanguage())%>", 600, 500);
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=ReCrm&recorderid="+recorderid+"&meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2108, user.getLanguage())%>", 600, 500);
}


function onShowReHrm(recorderid,meetingid){
	//showDialog("/meeting/data/MeetingReHrm.jsp?recorderid="+recorderid+"&meetingid="+meetingid,"会议参与回执", 400, 450);
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=ReHrm&recorderid="+recorderid+"&meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2108, user.getLanguage())%>", 600, 500);
}

function onShowReOthers(meetingid){
	//showDialog("/meeting/data/MeetingReOthers.jsp?meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(454, user.getLanguage())%>", 400, 450);
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=ReOthers&meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2103, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(430, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(454, user.getLanguage())%>", 600, 500);
}

function refashMemberList(){
	$.post("AjaxMeetingMember.jsp",{meetingid:<%=meetingid%>,canJueyi:<%=canJueyi%>,isdecision:<%=isdecision%>,othermembers:"<%=othermembers%>",ismanager:<%=ismanager%>},function(datas){
		 if(jQuery.trim(datas)!=""){
	        jQuery("#memberListDiv").html("");
			try{
			document.getElementById('memberListDiv').innerHTML = datas;
			jQuery("#memberListDiv").jNice();
			jQuery("#memberListDiv").find('.e8_btn_cancel').hover(function(){
				jQuery(this).addClass("e8_btn_cancel_btnHover");
			},function(){
				jQuery(this).removeClass("e8_btn_cancel_btnHover");
			});
			}catch(e){}
	      }
	});
}

</script>