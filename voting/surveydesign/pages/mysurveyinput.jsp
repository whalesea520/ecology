<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="surveyData.jsp" %>
<%@ include file="mysurveydata.jsp" %>
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
    <!-- <div class="survey-logo" style='height:30px'></div> -->
    
    <form id='surveyform'>
        <input type='hidden' name='votingid' value='<%=votingid%>' >
	    <div class="survey_body">
	           <div class="survey_title">
	           	<%=subject%>
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
                var pageitems=<%=pageitems%>;
                var viewset=<%=viewset%>;
				var userinputs=<%=userinputitems%>;
                survey.initSurvey(pageitems,viewset);
                survey.fillUserInput(userinputs);
                
                
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
