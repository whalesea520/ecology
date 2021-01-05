
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="../../js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="../../js/selectDateTime_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";

//1 表示模板。 
int istemplate = Util.getIntValue(Util.null2String(request.getParameter("istemplate")),0);

String userid=user.getUID()+"";
boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean cancreate=false ;
RecordSet.executeSql("select id from votingmaintdetail where createrid="+userid);
if(RecordSet.next())
    cancreate=true ;
if(canmaint)    cancreate=true ;
if(!"".equals(userid)) cancreate=true;

if(!cancreate){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}

//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String beginDate = currentdate;
String beginTime = "00:00";
String endDate = currentdate;
String endTime = "00:00";



%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onFrmSubmit()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

         RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1)',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33699,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onFrmSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelNames("82753",user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<form name=frmmain action="VotingOperation.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="30%"/>
		<col width="*"/>
	</colgroup>
	<tbody>
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
	</tbody>
</table>


<input type=hidden name=method value="add">
<input type=hidden name=votingcount value="0">
<input type=hidden name=status value="0">
<input type=hidden name="createrid" value="<%=userid%>">
<input type=hidden name="istemplate" value="<%=istemplate%>">

   <wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	         //名称
	         <wea:item><%=SystemEnv.getHtmlLabelName(33439, user.getLanguage())%></wea:item>
	         <wea:item>
	              <wea:required id="subjectimage" required="true">
				     <INPUT class=inputstyle type=text maxLength=60 size=25 name=subject id=subject onchange='checkinput("subject","subjectimage")'>
			      </wea:required>
	         </wea:item>
	         //描述
	         <wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
	         <wea:item>
	              <input type="text" name="descr"  maxLength=60>
	         </wea:item>
	         //开始日期
	         <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectBeginDate" onclick="onshowPlanDate('begindate','selectBeginDateSpan')"></BUTTON> 
              	<SPAN id=selectBeginDateSpan ><%=beginDate%><%if("".equals(beginDate)) {%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%} %></SPAN> 
              	<INPUT type="hidden" name="begindate" value="<%=beginDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectBeginTime" onclick="onShowTime(selectBeginTimeSpan,begintime)"></BUTTON>
              	<SPAN id="selectBeginTimeSpan"><%=beginTime%></SPAN>
              	<INPUT type=hidden name="begintime" value="<%=beginTime%>">
            </wea:item>
	         //结束日期
	         <wea:item><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectEndDate" onclick="onshowVotingEndDate('enddate','endDateSpan')"></BUTTON> 
            	<SPAN id=endDateSpan><%=endDate%></SPAN> 
            	<INPUT type="hidden" name="enddate" value="<%=endDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectEndTime" onclick="onShowTime(endTimeSpan,endtime)"></BUTTON>
              	<SPAN id="endTimeSpan"><%=endTime%></SPAN>
              	<INPUT type=hidden name="endtime" value="<%=endTime%>">
			</wea:item>
	         //	发布类型
	         <wea:item><%=SystemEnv.getHtmlLabelName(1993, user.getLanguage())%></wea:item>
	    	 <wea:item>
	    	    <select class=inputstyle name=deploytype  style="width:160px">
					<option value="0"><%=SystemEnv.getHtmlLabelName(32457, user.getLanguage())%></option><!--
			        <option value="1"><%=SystemEnv.getHtmlLabelName(32458, user.getLanguage())%></option>
			        <option value="2"><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage()) + SystemEnv.getHtmlLabelName(15109, user.getLanguage())%></option>
				--></select>
	    	 </wea:item>
	      
	         //调查类型
	         <wea:item><%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%></wea:item>
	    	 <wea:item>
	    	    <select class=inputstyle name=votingtype  style="width:160px">
					<option value=""></option>
			             <% 
				          RecordSet.executeSql("select * from voting_type");
				          while(RecordSet.next()) {
				         %>
			               <option value="<%=RecordSet.getString("id")%>"><%=RecordSet.getString("typename")%></option>
			             <%}%>
				</select>
	    	 </wea:item>
	    </wea:group>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%>'>
	         //允许匿名
	         <wea:item><%=SystemEnv.getHtmlLabelName(18576, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="isanony" id="isanony" />
	         </wea:item>
	         //答卷不显示结果
	         <wea:item><%=SystemEnv.getHtmlLabelName(21723, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="isSeeResult" />
	         </wea:item>
	         //强制调查
	         <wea:item><%=SystemEnv.getHtmlLabelName(23852, user.getLanguage()) + SystemEnv.getHtmlLabelName(15109, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" id="forcevote" name="forcevote" />
	         </wea:item>
	         //是否自动弹出调查
	         <wea:item><%=SystemEnv.getHtmlLabelNames("83963",user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="autoshowvote" id="autoshowvote" />
	         </wea:item>
	         
	         
	         //调查提醒
	         <!--================ 调查提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15109,user.getLanguage()) + SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="1" name="remindtype" onclick=showRemindTime(this) checked><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindtype" onclick=showRemindTime(this) ><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindtype" onclick=showRemindTime(this) ><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</wea:item>

		   <!--================ 调查提醒时间  ================-->
			<wea:item attributes="{'samePair':\"remindTime\"}">
				<%=SystemEnv.getHtmlLabelNames("26928,277",user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':\"remindTime\"}">
				<INPUT type="checkbox" name="remindbeforestart" id="remindbeforestart" >
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindtimebeforestart" id="remindtimebeforestart" onchange="checkint('remindtimebeforestart')" size=5 value="">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					&nbsp&nbsp&nbsp
				 <INPUT type="checkbox" name="remindbeforeend" id="remindbeforeend" >

					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" name="remindtimebeforeend" id="remindtimebeforeend"  onchange="checkint('remindtimebeforeend')" size=5 value="">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</wea:item>    	
	    </wea:group>

	</wea:layout>

</form>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--
function onFrmSubmit(){
	var begindate=jQuery("input[name='begindate']").val();
	var enddate=jQuery("input[name='enddate']").val();
	var begintime=jQuery("input[name='begintime']").val();
    var endtime=jQuery("input[name='endtime']").val();

	
    if(check_form(document.frmmain,"subject,creater,begindate")){
    
        	
		if(enddate !="" && begindate>enddate){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83964,user.getLanguage())%>");
		   return false;
		}
		
		if((begindate===enddate &&  begintime>=endtime)){
		      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83965,user.getLanguage())%>");
		      return false;
		}
    
        if(jQuery("#votetimecontrol").attr("checked") == true && jQuery("#votetimecontroltime").val() == ""){
	      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83966,user.getLanguage())%>");
	      return false;
	   }
	   
	   if(jQuery("#remindbeforestart").attr("checked") == true && jQuery("#remindtimebeforestart").val() == ""){
	     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83967,user.getLanguage())%>");
	     return false;
	   }
	   
	   if(jQuery("#remindbeforeend").attr("checked") == true && jQuery("#remindtimebeforeend").val() == ""){
	     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83968,user.getLanguage())%>");
	     return false;
	   }
	   
	   parentDialog.setDlgTitle("<%=SystemEnv.getHtmlLabelNames("17599,2121",user.getLanguage())%>");
	   
		document.frmmain.submit();
		enableAllmenu();
	}
}
//-->

jQuery(document).ready(function(){
	showRemindTime($GetEle("remindtype"));
	
	 $("#forcevote").click(function(){
	     if($("#forcevote").attr("checked") == true){
		     changeCheckboxStatus($("#autoshowvote"),true);
		 }else{
		     disOrEnableCheckbox($("#autoshowvote"),false);
		 }
     });
     
     
     $("#votetimecontrol").click(function(){
	     if($("#votetimecontrol").attr("checked") == true){
		     $("#votetimecontroldiv").css("display","");
		     $("#votetimecontroltime").val("");
		 }else{
		     $("#votetimecontroldiv").css('display','none');
		 }
     });
	
});


function votetimecontroltimeonchange(){
   checkint('votetimecontroltime');
   if(jQuery("#votetimecontroltime").val() != ""){
       jQuery("#votetimecontroltimeimg").css("display","none");
   }else{
       jQuery("#votetimecontroltimeimg").css("display","");
   }
   
}

function showRemindTime(obj)
{
	if("2" != obj.value && "3" != obj.value)
	{
		hideEle("remindTime", true);
		hideEle("reminddesc", true);
	}
	else
	{
		showEle("remindTime");
		showEle("reminddesc");
	}
}

function testopen(){
   alert(1);
}
</SCRIPT>
