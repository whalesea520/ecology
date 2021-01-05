
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<div id="topiclistdiv">
	<jsp:include page="AjaxMeetingTopic.jsp" flush="true">
         <jsp:param name="meetingstatus" value="<%=meetingstatus%>" />
         <jsp:param name="ismanager" value="<%=ismanager%>" />
         <jsp:param name="iscontacter" value="<%=iscontacter%>" />
         <jsp:param name="ismember" value="<%=ismember%>" />
         <jsp:param name="isdecision" value="<%=isdecision%>" />
         <jsp:param name="meetingid" value="<%=meetingid%>" />
         <jsp:param name="creater" value="<%=creater%>" />
         <jsp:param name="caller" value="<%=caller%>" />
         <jsp:param name="contacter" value="<%=contacter%>" />
     </jsp:include>
</div>
<script language="javascript">
function onShowTopicDoc(topicid){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 450;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2212, user.getLanguage())%>";
	diag_vote.URL = "/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp";
	diag_vote.option={"topicid":topicid};
	diag_vote.callback=saveTopic;
	diag_vote.show();
}
function saveTopic(results){
	diag_vote.close();
	var topicid=diag_vote.option.topicid;
	if(results){
	   if(results.id!=""){
			$.post("TopicDocOperation.jsp?method=add&meetingid=<%=meetingid%>&topicid="+topicid+"&docid="+results.id,{},function(datas){
					refashTopicList();
			});
	   }
	}
	
}

function onShowTopicDate(recorderid){
	//showDialog("/meeting/data/MeetingTopicDate.jsp?recorderid="+recorderid+"&meetingid=<%=meetingid%>","<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2169, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(277, user.getLanguage())%>", 600, 450);
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=TopicDate&recorderid="+recorderid+"&meetingid=<%=meetingid%>","<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2169, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(277, user.getLanguage())%>", 600, 450);
}


function deleteTopicDoc(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>", function (){
		$.post("TopicDocOperation.jsp?method=delete&meetingid=<%=meetingid%>&id="+id,{},function(datas){
			refashTopicList();
		});
	});
}

function onShowTopic(meetingid){
	//showDialog("/meeting/data/MeetingTopic.jsp?meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2210, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2169, user.getLanguage())%>", 800, 450);
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=Topic&meetingid="+meetingid,"<%=SystemEnv.getHtmlLabelName(2210, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2169, user.getLanguage())%>", 800, 450);
}

function refashTopicList(){
	$.post("AjaxMeetingTopic.jsp",{meetingstatus:<%=meetingstatus%>,ismanager:<%=ismanager%>,iscontacter:<%=iscontacter%>,ismember:<%=ismember%>,isdecision:<%=isdecision%>,meetingid:<%=meetingid%>,creater:<%=creater%>,caller:<%=caller%>,contacter:<%=contacter%>},function(datas){
		 if(jQuery.trim(datas)!=""){
	        jQuery("#topiclistdiv").html("");
			try{
			document.getElementById('topiclistdiv').innerHTML = datas;
			jQuery("#topiclistdiv").jNice();
			jQuery(".e8_btn_cancel").hover(function(){
				jQuery(this).addClass("e8_btn_cancel_btnHover");
			},function(){
				jQuery(this).removeClass("e8_btn_cancel_btnHover");
			});
			}catch(e){}
	      }
	});
}

</script>