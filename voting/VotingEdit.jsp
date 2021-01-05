
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
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
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid=user.getUID()+"";
String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String nogoback=Util.null2String(request.getParameter("nogoback"));

//1 表示模板。 
int istemplate = Util.getIntValue(Util.null2String(request.getParameter("istemplate")),0);

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean canedit=false ;

RecordSet.executeProc("Voting_SelectByID",votingid);
RecordSet.next();
String subject=RecordSet.getString("subject");
String detail=RecordSet.getString("detail");
String createrid=RecordSet.getString("createrid");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String approverid=RecordSet.getString("approverid");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String isanony=RecordSet.getString("isanony");
String docid=RecordSet.getString("docid");
String crmid=RecordSet.getString("crmid");
String projectid=RecordSet.getString("projid");
String requestid=RecordSet.getString("requestid");
String votingcount = RecordSet.getString("votingcount");
String status = RecordSet.getString("status");
String isSeeResult = RecordSet.getString("isSeeResult");//投票后是否可以查看结果
int votingtype = Util.getIntValue(RecordSet.getString("votingtype"));//调查类型



//描述
String descr = RecordSet.getString("descr");
//发布类型
String deploytype = RecordSet.getString("deploytype");
//自动弹出
String autoshowvote = RecordSet.getString("autoshowvote");
//调查时间是否控制
String votetimecontrol = RecordSet.getString("votetimecontrol");
//调查时间
String votetimecontroltime = RecordSet.getString("votetimecontroltime");
//强制调查
 String forcevote = RecordSet.getString("forcevote");
//调查提醒类型
 String remindtype = RecordSet.getString("remindtype");
//初始值
 if("".equals(remindtype) || remindtype == null){
 	remindtype = "1";
 }
//开始前 10 分钟提醒
 String remindtimebeforestart = RecordSet.getString("remindtimebeforestart");
//结束前 10 分钟提醒
 String remindtimebeforeend = RecordSet.getString("remindtimebeforeend");

//提交权限begin
 boolean cancreate = false;

 if(HrmUserVarify.checkUserRight("Voting:Maint", user)){
 	cancreate = true;
 }
 String sqlcreate = "select count(id) as recordid from votingmaintdetail where  createrid="+userid;
 RecordSet.execute(sqlcreate);
 while(RecordSet.next()){
 		int recordid = RecordSet.getInt("recordid");
 		if(recordid>0){
 		  	cancreate = true;
 		  }   
 }
 	
 if(userid.equals(createrid)) cancreate=true ;

if(userid.equals(createrid) || userid.equals(approverid))
    canedit=true ;
if(canmaint)
    canedit=true ;
if(!"".equals(userid)) canedit=true;
if(!canedit){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onFrmSubmit()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete()',_top} "  ;
        RCMenuHeight += RCMenuHeightStep ;
        
        RCMenu += "{"+SystemEnv.getHtmlLabelName(33832, user.getLanguage())+",javascript:doUpdate()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
				
				if(!"1".equals(nogoback)){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1)',_top} " ;
        	RCMenuHeight += RCMenuHeightStep ;
				}
    %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script type="text/javascript">

jQuery(document).ready(function(){

    checkinput("subject","subjectimage");
	/* 初始化 勾选*/
	
	<% if(!"".equals(remindtype)) { %>
        showRemindTime("<%=remindtype %>");
	<% }%>
	
	<% if(!"".equals(votetimecontrol)) { %>
        $("#votetimecontroldiv").css("display","");
        $("#votetimecontroltimeimg").css("display","none");
	<% }%>
	
	
	
	 $("#forcevote").click(function(){
	     if($("#forcevote").attr("checked") == true){
		     changeCheckboxStatus($("#autoshowvote"),true);
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

//编辑操作
function doUpdate(){
      
   var dlg=new window.top.Dialog();//定义Dialog对象
　　　dlg.Model=true;
     	dlg.maxiumnable=true;
　　　dlg.Width=1024;//定义长度
　　　dlg.Height=700;
     <%if(status.equals("0") && cancreate){ %>
       dlg.hideDraghandle = true;
       dlg.URL="/voting/surveydesign/pages/surveydesign.jsp?votingid=<%=votingid%>";  
     <%}else{ %>
       dlg.URL="/voting/surveydesign/pages/surveypreview.jsp?votingid=<%=votingid%>";    
     <%}%>
　　　dlg.Title="<%=SystemEnv.getHtmlLabelNames("15109,83723",user.getLanguage())%>";
　　　dlg.show();
}

function showRemindTime(obj)
{
	if("2" != obj && "3" != obj)
	{
		hideEle("remindTime", true);
	}
	else
	{
		showEle("remindTime");
	}
}

</script>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
		  <span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onFrmSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
		  <span title="<%=SystemEnv.getHtmlLabelName(33832, user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doUpdate()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(33832, user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelNames("82753",user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name=frmmain action="VotingOperation.jsp" method=post onsubmit="return check_form(this,'subject,creater,begindate')">
<input type=hidden name=method value="edit">
<input type=hidden name=votingid value="<%=votingid%>">
<input type=hidden name=votingcount value="<%=votingcount%>">
<input type=hidden name=status value="<%=status%>">
<input type=hidden name="createrid" value="<%=createrid%>">
<input type=hidden name="istemplate" value="<%=istemplate%>">


<wea:layout type="2col" >
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':''}">
	         //名称
	         <wea:item><%=SystemEnv.getHtmlLabelName(33439, user.getLanguage())%></wea:item>
	         <wea:item>
	              <wea:required id="subjectimage" required="true">
				 
				     <INPUT class=inputstyle type=text maxLength=60 size=25 value="<%=subject.replaceAll("\"","&quot;")%>" name=subject id=subject onchange='checkinput("subject","subjectimage")'>
			      </wea:required>
	         </wea:item>
	         //描述
	         <wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
	         <wea:item>
	              <input type="text" name="descr"  value="<%=descr.replaceAll("\"","&quot;")%>" maxLength=60>
	         </wea:item>
	         //开始日期
	         <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectBeginDate" onclick="onshowPlanDate('begindate','selectBeginDateSpan')"></BUTTON> 
              	<SPAN id=selectBeginDateSpan ><%=begindate%><%if("".equals(begindate)) {%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%} %></SPAN> 
              	<INPUT type="hidden" name="begindate" value="<%=begindate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectBeginTime" onclick="onShowTime(selectBeginTimeSpan,begintime)"></BUTTON>
              	<SPAN id="selectBeginTimeSpan"><%=begintime%></SPAN>
              	<INPUT type=hidden name="begintime" value="<%=begintime%>">
            </wea:item>
	         //结束日期
	         <wea:item><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<button type="button" class=Calendar id="selectEndDate" onclick="onshowVotingEndDate('enddate','endDateSpan')"></BUTTON> 
            	<SPAN id=endDateSpan><%=enddate%></SPAN> 
            	<INPUT type="hidden" name="enddate" value="<%=enddate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectEndTime" onclick="onShowTime(endTimeSpan,endtime)"></BUTTON>
              	<SPAN id="endTimeSpan"><%=endtime%></SPAN>
              	<INPUT type=hidden name="endtime" value="<%=endtime%>">
			</wea:item>
	         //	发布类型
	         <wea:item><%=SystemEnv.getHtmlLabelName(1993, user.getLanguage())%></wea:item>
	    	 <wea:item>
	    	    <select class=inputstyle name=deploytype  style="width:160px">
					<option value="0" <%if("0".equals(deploytype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32457, user.getLanguage())%></option>
			        <!--<option value="1" <%if("1".equals(deploytype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32458, user.getLanguage())%></option>
			        <option value="2" <%if("2".equals(deploytype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage()) + SystemEnv.getHtmlLabelName(15109, user.getLanguage())%></option>
				-->
				</select>
	    	 </wea:item>
	      
	         //调查类型
	         <wea:item><%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%></wea:item>
	    	 <wea:item>
	    	    <select class=inputstyle name=votingtype  style="width:160px">
					<option value=""></option>
			             <% 
				          RecordSet.executeSql("select * from voting_type");
				          while(RecordSet.next()) {
				        	  int votingtypeid = RecordSet.getInt("id");
				         %>
			               <option value="<%=votingtypeid%>" <%if(votingtype == votingtypeid){%>selected<%}%>><%=RecordSet.getString("typename")%></option>
			             <%}%>
				</select>
	    	 </wea:item>
	    </wea:group>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%>' attributes="{'groupDisplay':''}">
	         //允许匿名
	         <wea:item><%=SystemEnv.getHtmlLabelName(18576, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="isanony" id="isanony" <% if(!"".equals(isanony)){ %> checked <%} %> />
	         </wea:item>
	         //答卷不显示结果
	         <wea:item><%=SystemEnv.getHtmlLabelName(21723, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="isSeeResult" id="isSeeResult" <% if(!"".equals(isSeeResult)){ %> checked <%} %> />
	         </wea:item>
	         //强制调查
	         <wea:item><%=SystemEnv.getHtmlLabelName(23852, user.getLanguage()) + SystemEnv.getHtmlLabelName(15109, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" id="forcevote" name="forcevote" onclick="onForcevoteClick()" <% if(!"".equals(forcevote)){ %> checked <%} %> />
	         </wea:item>
	
	         <wea:item><%=SystemEnv.getHtmlLabelNames("125944",user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name=autoshowvote id="autoshowvote" <% if(!"".equals(autoshowvote)){ %> checked <%} %> />
	         </wea:item>

	         
	         //调查提醒
	         --><!--================ 调查提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15109,user.getLanguage()) + SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" value="1" name="remindtype" onclick=showRemindTime('1') <%if("1".equals(remindtype)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindtype" onclick=showRemindTime('2') <%if("2".equals(remindtype)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindtype" onclick=showRemindTime('3') <%if("3".equals(remindtype)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</wea:item>

		   <!--================ 调查提醒时间  ================-->
			<wea:item attributes="{'samePair':\"remindTime\"}">
				<%=SystemEnv.getHtmlLabelNames("26928,277",user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':\"remindTime\"}">
				<INPUT type="checkbox" name="remindbeforestart" id="remindbeforestart" <% if(!"".equals(remindtimebeforestart)){ %> checked <%} %> >
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" value="<%=remindtimebeforestart %>"  name="remindtimebeforestart" id="remindtimebeforestart" onchange="checkint('remindtimebeforestart')" size=5 value="">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					&nbsp&nbsp&nbsp
				 <INPUT type="checkbox" name="remindbeforeend" id="remindbeforeend"  <% if(!"".equals(remindtimebeforeend)){ %> checked <%} %> >

					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;"  value="<%=remindtimebeforeend %>" name="remindtimebeforeend" id="remindtimebeforeend"  onchange="checkint('remindtimebeforeend')" size=5 value="">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</wea:item>    	
	    </wea:group>

	</wea:layout>

</form>
<script language=javascript>
 function doDelete(){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
         $.post("/voting/VotingOperation.jsp?method=delete&votingids=<%=votingid%>",{},function(){
				 window.open('VotingList.jsp?istemplate=<%=istemplate%>','mainFrame','');
				 
				 var dialog = parent.parent.getDialog(parent);
				 dialog.close();
				 
		 })
   });
 }

function onForcevoteClick(){
		var forcevote=$G("forcevote")
		var autoshowvote=jQuery("#autoshowvote");
    if(forcevote.checked){
    	autoshowvote.trigger("checked",true);
    	autoshowvote.trigger("disabled",true);
    } else {
    	autoshowvote.trigger("disabled",false);
    }
}
jQuery(onForcevoteClick)

</script>
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
		document.frmmain.submit();
		enableAllmenu();
	}
}
//-->



</SCRIPT>
