<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ include file="surveyinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="surveyData.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17599, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	char flag = 2;
	boolean islight = true;
	String userid = user.getUID() + "";
	//sql 和  votingid 为surveyData.jsp内的变量
	
	RecordSet.executeProc("Voting_SelectByID", votingid);
	RecordSet.next();
	String subject = RecordSet.getString("subject");
	String detail = RecordSet.getString("detail");
	String createrid = RecordSet.getString("createrid");
	String createdate = RecordSet.getString("createdate");
	String createtime = RecordSet.getString("createtime");
	String approverid = RecordSet.getString("approverid");
	String approvedate = RecordSet.getString("approvedate");
	String approvetime = RecordSet.getString("approvetime");
	String begindate = RecordSet.getString("begindate");
	String begintime = RecordSet.getString("begintime");
	String enddate = RecordSet.getString("enddate");
	String endtime = RecordSet.getString("endtime");
	String isanony = RecordSet.getString("isanony");
	String docid = RecordSet.getString("docid");
	String crmid = RecordSet.getString("crmid");
	String projectid = RecordSet.getString("projid");
	String requestid = RecordSet.getString("requestid");
	String votingcount = RecordSet.getString("votingcount");
	String status = RecordSet.getString("status");
	String isSeeResult = RecordSet.getString("isSeeResult");
	int tempnum = -1;
	if (Util.getIntValue(requestid) > 0) {
		RecordSet
		.executeSql("select min(requestid) requestid from workflow_currentoperator where userid="
				+ userid);
		RecordSet.next();
		tempnum = Util.getIntValue(String.valueOf(session
		.getAttribute("slinkwfnum")));
		tempnum++;
		session.setAttribute("resrequestid" + tempnum, requestid);
		session.setAttribute("desrequestid", RecordSet
		.getString("requestid"));
		session.setAttribute("slinkwfnum", "" + tempnum);
		session.setAttribute("haslinkworkflow", "1");
	}
	/*检查是否已经参与投票*/
	RecordSet.executeProc("VotingResource_SelectByUser", votingid
			+ flag + userid);
	if (RecordSet.next()) {
		response.sendRedirect("/voting/VotingPollResult.jsp?votingid="
		+ votingid);
		return;
	}
%>
<html>
  <head>
        <link rel="stylesheet" href="/voting/surveydesign/css/survey_wev8.css">
        <link rel="stylesheet" type="text/css" href="/voting/surveydesign/css/surverydesign.css"/>
        
        <style>
        	.image_div_show img,.survey_question img{
        		cursor:pointer;
        	}
        </style>
</head>
  
<body>
 <input type='hidden' name='ispreview'>	
 <div class="survey_preview_content">   
    
    <form id='surveyform'>
        <input type='hidden' name='votingid' value='<%=votingid%>' >
        <!-- <div class="survey-logo" style='height:30px'></div> -->
	    
	    <div class="survey_body">
			    <div class="survey_title">
			    </div>
			    <div class="survey_descr" style="display:none">
			          <div style="float:left">
				     &nbsp;&nbsp;<b><%=SystemEnv.getHtmlLabelName(17599, user.getLanguage())%> :&nbsp;</b>
				            	<%=Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())%>
				      &nbsp;&nbsp;<b><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%> :&nbsp;</b>
				            	<%=begindate%> : <%=begintime %>
				      &nbsp;&nbsp;<b><%=SystemEnv.getHtmlLabelName(22326, user.getLanguage())%> :&nbsp;</b>
				            	<%=enddate%> : <%=endtime %>
				     </div>
				     <div style="float:right">
				          <input type="checkbox" name="" /> <b><%=SystemEnv.getHtmlLabelName(18611, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%></b>
				     </div>     
			    </div>
	
	           <div class="survey_content">
	
	                  <div class="survey_question clone" style='display:none;'>
	                          <div class="survey_quesname">
	                                    <span class="survey_quesnamedes"></span>   <span class="require" style="display: inline;color: red;">*</span><label class="rules"></label>
	                          </div>
	                          <div class="survey_options">
	                                
	                          </div>
	                  </div>
	           </div>
			 
	    </div>
    </form>
    <div class='placeholder' style="height:80px">
	                  
	</div>

</div>
<iframe id="downloadFrame" style="display: none"></iframe>

     <script src="/voting/surveydesign/js/jquery_wev8.js"></script>
     <script src="/voting/surveydesign/js/survey_wev8.js"></script> 
     
     <script>
				var votingId="<%=votingid%>";	
				jQuery(document).ready(function(){
					jQuery(document.body).css("height","auto");
	        var pageitems=<%=pageitems%>;
					var viewset=<%=viewset%>;
					var surveytitle="<%=surveytitle%>";
					survey.initSurvey(pageitems,viewset,surveytitle);
                jQuery(".voting_image_show .image_div_show img,.survey_question img").click(function(){
                	var _wi = window.top.document.documentElement.clientWidth;
                	var _hi = window.top.document.documentElement.clientHeight;
                	var _html = "<div class='mengbanLayer' style='position: fixed; z-index: 99999; left: 0px; top: 0px; right: 0px; bottom: 0px; width: " + _wi + "px; height: " + _hi + "px; display: block;background-color:#0a0000;opacity:0.6;filter:alpha(opacity=60);'></div>"
          				+ "<div class='chatImgPagWrap' style='position: fixed; z-index: 99999; left: 0px; top: 0px; right: 0px; bottom: 0px; display: block; width: " + _wi + "px; height: " + _hi + "px;'>"
          	 				+ "<table style='width:100%;height:100%'><tr><td style='width:100%;height:100%;text-align:center;vertical-align:middle;'>"
          	 					+ "<div style='display:inline-block;position:relative'>" 
          							+ "<div class='chatImgClose' style='background-color:#5bb4d8;border-radius:50%;color:#fff;font-size:25px;height:30px;line-height:25px;position:absolute;right:-12px;top:-12px;text-align:center;width:30px;cursor:pointer'>x</div>"
          	 						+ "<img src='" + jQuery(this).attr("src") + "'/></div></td></tr></table>"
          	 			+ "</div>";
                	window.top.jQuery("body").append(_html).find(".chatImgPagWrap .chatImgClose").hover(function(){
                		jQuery(this).css("background-color","#de553f");
                	},function(){
                		jQuery(this).css("background-color","#5bb4d8");
                	}).click(function(){
                		window.top.jQuery(".chatImgPagWrap,.mengbanLayer").remove();
                	}); 			
	               // window.top.jQuery("body").append(_html).find(".chatImgPagWrap,.mengbanLayer").click(function(){
	               // 	window.top.jQuery(".chatImgPagWrap,.mengbanLayer").remove();
	               // });
	                
					
                });
                
                window.document.onkeydown = function(event){
		         	if(event && event.keyCode && event.keyCode == 27){
		         		window.top.jQuery(".chatImgPagWrap,.mengbanLayer").remove();
		         	}
		         }
                
         });
         
         
     </script>
</body>
</html>
