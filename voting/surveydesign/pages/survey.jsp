<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="surveyinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%request.setAttribute("getTempData","1") ;%>
<%@ include file="surveyData.jsp" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />	
<%
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17599, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	char flag = 2;
	boolean islight = true;
	String userid = user.getUID() + "";

	HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
	String belongtoids = user.getBelongtoids();
	String account_type = user.getAccount_type();
	String votingshareids=""+user.getUID();
	if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
	votingshareids+=","+belongtoids;	
	}
	
	//sql 和  votingid 为surveyData.jsp内的变量
	boolean hasPollRight=false;
	Set hasPollRightUserSet=VotingManager.getHasPollRightUserSet(votingid);
	String[] belongtoidarr=votingshareids.split(",");
		for(int i=0;i<belongtoidarr.length;i++){
			if(hasPollRightUserSet.contains(belongtoidarr[i])){
				hasPollRight=true;
				break;
			}
	}
	
	if (!hasPollRight) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	Object sessionObject = request.getSession().getAttribute("votingMap");
	Map<String,String> votingMap = null;
	if(sessionObject != null){
	    votingMap = (Map)sessionObject;
	}else{
	    votingMap = new HashMap<String,String>();
	}
    votingMap.put(votingid,"");
    request.getSession().setAttribute("votingMap",votingMap);
	
	
	RecordSet.executeProc("Voting_SelectByID", votingid);
	RecordSet.next();
	String subject = RecordSet.getString("subject");
	String approverid = RecordSet.getString("approverid");
	String begindate = RecordSet.getString("begindate");
	String begintime = RecordSet.getString("begintime");
	String enddate = RecordSet.getString("enddate");
	String endtime = RecordSet.getString("endtime");
	//强制调查
	String forcevote = RecordSet.getString("forcevote");
	//是否允许匿名提交,on 为允许
	String  isanony = RecordSet.getString("isanony");
	String requestid = RecordSet.getString("requestid");
	//是否需要刷新父窗口,为 1 时需要刷新
	String freshparent= Util.null2String(request.getParameter("freshparent"));

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
	if(!(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals(""))){
	RecordSet.executeProc("VotingResource_SelectByUser", votingid
			+ flag + userid);
	if (RecordSet.next()) {
		response.sendRedirect("/voting/VotingPollResult.jsp?votingid="
		+ votingid);
		return;
	}
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
        <script>
        	this.doOperatorSave = "1";  //在页面操作时，是否保存操作。供survey_wev8.js中的saveAsTemp方法判断是否后台执行保存操作
        </script>
  </head>
  
<body>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(615, user.getLanguage())
			+ ",javascript:doVotingSubmit(),_self} ";
	if(!"".equals(isanony) && isanony != null){//允许匿名提交
		RCMenu += "{" + SystemEnv.getHtmlLabelName(18611, user.getLanguage())+ SystemEnv.getHtmlLabelName(615, user.getLanguage())
		+ ",javascript:doAnonyVotingSubmit(),_self} ";
	}
	RCMenuHeight += RCMenuHeightStep;
	if("".equals(forcevote) || forcevote==null){//强制调查
		RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
		+ ",javascript:parentDialog.close();,_self} ";
	    RCMenuHeight += RCMenuHeightStep;
	}
	
	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

 <div class="survey_preview_content">   

    
    <form id='surveyform' name="surveyform">
        <input type='hidden' name='votingid' value='<%=votingid%>' >
        <input type='hidden' name='useranony' value='0' >
        <input type='hidden' name='freshparent' value='<%=freshparent %>' >
	    <div class="survey_body">
	           <div class="survey_title">

			    </div>
			    <div class="survey_countdown" style="display:none">
			       <span id="countdown_day" style="display:none" title="<%=SystemEnv.getHtmlLabelName(32751,user.getLanguage())%>"></span>  <span id="countdown_hour"  title="<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>"></span>
			        <span id="countdown_minute"  title="<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>"></span> <span id="countdown_second"  title="<%=SystemEnv.getHtmlLabelName(27954,user.getLanguage())%>"></span>
			        
			    </div>
			    <div class="survey_descr" style="display:none">
			          <div style="float:left">
				     &nbsp;&nbsp;<b><%=SystemEnv.getHtmlLabelName(19917,user.getLanguage())%> :&nbsp;</b>
				            	<%=Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())%>
				      &nbsp;&nbsp;<b><%=SystemEnv.getHtmlLabelName(24978,user.getLanguage())%> :&nbsp;</b>
				            	<%=begindate%> : <%=begintime %>
				      &nbsp;&nbsp;<b><%=SystemEnv.getHtmlLabelName(22326,user.getLanguage())%> :&nbsp;</b>
				            	<%=enddate%> : <%=endtime %>
				     </div>
				     <div style="float:right">
				          <input type="checkbox" name="" /> <b><%=SystemEnv.getHtmlLabelNames("18611,725",user.getLanguage())%></b>
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
</div>
 <div class='placeholder' style="height:80px">
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>" id="" class="e8_btn_cancel" onclick="doVotingSubmit();">
				<% if(!"".equals(isanony) && isanony != null){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(18611, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>" id="" class="e8_btn_cancel" onclick="doAnonyVotingSubmit();">
				<% } %>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<iframe id="downloadFrame" style="display: none"></iframe>
<script src="/voting/surveydesign/js/jquery_wev8.js"></script>
<script src="/voting/surveydesign/js/survey_wev8.js"></script> 
<script>
var votingId="<%=votingid%>";	
var interval = 1000; 
var showCountDownInterval;

jQuery(document).ready(function(){
	 jQuery(document.body).css("height","auto");
	 var pageitems=<%=pageitems%>;
     var viewset=<%=viewset%>;
	 var surveytitle="<%=surveytitle%>";
     survey.initSurvey(pageitems,viewset,surveytitle);
     //启动倒计时
     showCountDownInterval = window.setInterval(function(){showCountDown('2014/08/25 17:36');}, interval);
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

function doVotingSubmit(){
     window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("33703,725",user.getLanguage())%>?',function(){
         survey.submitsurvey();
     });
}

function doAnonyVotingSubmit(){
    
     window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("33703,725",user.getLanguage())%>?',function(){
         document.surveyform.useranony.value = "1";
         survey.submitsurvey();
     });
}

function showCountDown(enddatetime){ 
	var now = new Date(); 
	var endDate = new Date(enddatetime); 
	var countdown_leftTime=endDate.getTime()-now.getTime(); 
	var countdown_leftSecond = parseInt(countdown_leftTime/1000); 
	var countdown_year;
	var countdown_day;
	var countdown_hour;
	var countdown_minute;
	var countdown_second;
	if(countdown_leftSecond > 0){ 
		countdown_day = Math.floor(countdown_leftSecond/(60*60*24)); 
		countdown_hour = Math.floor((countdown_leftSecond-countdown_day*24*60*60)/3600); 
		countdown_minute = Math.floor((countdown_leftSecond-countdown_day*24*60*60-countdown_hour*3600)/60); 
		countdown_second = Math.floor(countdown_leftSecond-countdown_day*24*60*60-countdown_hour*3600-countdown_minute*60); 
		
		if(countdown_day !=0 ){
		   $("#countdown_day").html(countdown_day);
		   $("#countdown_day").css("display","");
		}else{
		   $("#countdown_day").css("display","none");
		}
		
		if(countdown_hour <10 ){
		   $("#countdown_hour").html("0"+countdown_hour);
		}else{
		   $("#countdown_hour").html(countdown_hour);
		}
		
	    if(countdown_minute <10 ){
		   $("#countdown_minute").html("0"+countdown_minute);
		}else{
		   $("#countdown_minute").html(countdown_minute);
		}
		
		$("#countdown_minute").css("display","");
	    if(countdown_second <10 ){
		   $("#countdown_second").html("0"+countdown_second);
		}else{
		   $("#countdown_second").html(countdown_second);
		}
		
	  
	}else if(countdown_leftSecond == 0){
		//cc = document.getElementById(divname); 
		//cc.innerHTML = "结束";
		window.clearInterval(showCountDownInterval);
		parentDialog.close();
	} 
}


   
    

           
</script>


</body>
</html>
