
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="VotingReminiders" class="weaver.voting.VotingReminiders" scope="page"/> 
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page"/> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage());
String temptitlename = titlename;
String needfav ="1";
String needhelp ="";

//1 表示模板。 无提交，批准等操作
int istemplate = Util.getIntValue(Util.null2String(request.getParameter("istemplate")),0);
int viewResult = Util.getIntValue(Util.null2String(request.getParameter("viewResult")),0);
String nogoback=Util.null2String(request.getParameter("nogoback"));
String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String goedit=Util.fromScreen(request.getParameter("goedit"),user.getLanguage());
if("1".equals(goedit)){
%>
<script>
	location.href="/voting/VotingEdit.jsp?votingid=<%=votingid%>&istemplate=<%=istemplate%>&nogoback=1"	
	//return;
</script>
<%	
}

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);

boolean canDelete = HrmUserVarify.checkUserRight("voting:delete", user);
boolean canedit=false ;
boolean canapprove=false ;
boolean canOption = false;

boolean islight=true ;
String userid=user.getUID()+"";

boolean canresulet = false;
Set hasViewRightUserSet=VotingManager.getHasViewRightUserSet(votingid);
if(hasViewRightUserSet.contains(userid)){
	canresulet=true;
}
if("1".equals(userid)) canresulet = true;//td11778 hww

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

int votingtype = Util.getIntValue(RecordSet.getString("votingtype"));//调查类型
//是否展示 提交 菜单按钮。
boolean showSubmitButton = false;
String votingtypename = "";
RecordSet.executeSql("select * from voting_type where id ="+votingtype);
if(RecordSet.next()) {
	votingtypename = RecordSet.getString("typename");
	if(!"0".equals(RecordSet.getString("approver"))){//需要审批
		showSubmitButton = true;
	}
}

RecordSet.executeSql("select * from votingoption where votingid ="+votingid);
if(RecordSet.next()){
  canOption = true; 
}else{
   String isother = "";
   rs.executeSql("select * from votingQuestion where votingid ="+votingid);
   if(rs.next()) isother = rs.getString("isother");
   if("1".equals(isother)){
    canOption = true; 
   }
}

if(userid.equals(createrid) || userid.equals(approverid))
    canedit=true ;
if(userid.equals(approverid)) {
    canapprove=true ;   
}

if(canmaint){
    canedit=true ;
    canapprove=true ;
}

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
	
String sqlcreate2 = "select count(id) as recordid from votingmaintdetail where  approverid="+userid;
RecordSet.execute(sqlcreate2);
while(RecordSet.next()){
		int recordid = RecordSet.getInt("recordid");
		if(recordid>0){
		
		  	canapprove = true;
		  }   
	}
if(userid.equals(createrid)) cancreate=true ;
/***如果是通过流程审批调查，就屏蔽正常的审批开始**/
boolean approvertmp = false;
approvertmp = VotingReminiders.checkApproveVoting(votingid);

if(approvertmp) canapprove = false;
/***如果是通过流程审批调查，就屏蔽正常的审批结束**/


/***流程查看网上调查权限开始**/
String isfromwf = Util.null2String(request.getParameter("isfromworkflow"));
boolean wfviewtmp = false;

if("1".equals(isfromwf)) {
	wfviewtmp = VotingReminiders.checkViewWfVoting(votingid,userid);
	if(wfviewtmp) canresulet = false;
	if(wfviewtmp) canapprove = false;
	if(wfviewtmp) canDelete = false;
}
if(!canedit && !wfviewtmp){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}
//可维护则可查看结果
if(canmaint){
	canresulet=true;
}

rs.executeSql("select status from bill_VotingApprove,voting where votingname=voting.id and voting.id ="+votingid);
if(rs.next()){
	canapprove = false;
	wfviewtmp = true;
}

RecordSet.executeSql("select * from voting_type");
int vtype=0;
if(RecordSet.next()){
    vtype=Util.getIntValue(RecordSet.getString("votingtype"));
}
boolean iswfapprove=false;
//审批按钮 1.通过流程审批,批准操作通过流程触发
if(vtype > 0 && istemplate !=1){
	RecordSet.executeSql("select * from voting_type where id ="+vtype);
	if(RecordSet.next()) {
		int approvewfid = Util.getIntValue(RecordSet.getString("approver"),-1);
		if(approvewfid > 0) {
			 iswfapprove=true;
		}
	}
}
boolean hasapprove=false;
RecordSet.executeSql("select approverid  from VotingMaintDetail where createrid="+createrid);
if(RecordSet.next()) {
    hasapprove=true;
	if(!RecordSet.getString("approverid").equals(createrid)&&createrid.equals(userid))hasapprove=false;//当创建人不是调查的审批人的时候，并且查看自己的调查不应该有批准按钮
}

/***流程查看网上调查权限结束**/

titlename += "&nbsp;&nbsp;"+
             "<b>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</b>"+
		createdate+"&nbsp;&nbsp;"+createtime+"&nbsp;&nbsp;"+
             "<b>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</b>"+
		"<a href=\"javaScript:openhrm('"+createrid+"');\" onclick='pointerXY(event);'>"+
		Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())+
		"</A>&nbsp;&nbsp;"+
	     "<b>"+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(359,user.getLanguage())+":&nbsp;</b>"+
		approvedate+"&nbsp;&nbsp;"+approvetime+"&nbsp;&nbsp;"+
	     "<b>"+SystemEnv.getHtmlLabelName(439,user.getLanguage())+":&nbsp;</b>"+
		"<a href=\"javaScript:openhrm('"+approverid+"');\" onclick='pointerXY(event);'>"+
            	Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())+
		"</A>&nbsp;&nbsp;";
String descrtitle = "<b>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</b>"+
createdate+"&nbsp;&nbsp;"+createtime+"&nbsp;&nbsp;"+
     "<b>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</b>"+
"<a href=\"javaScript:openhrm('"+createrid+"');\" onclick='pointerXY(event);'>"+
Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())+
"</A>&nbsp;&nbsp;"+
 "<b>"+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(359,user.getLanguage())+":&nbsp;</b>"+
approvedate+"&nbsp;&nbsp;"+approvetime+"&nbsp;&nbsp;"+
 "<b>"+SystemEnv.getHtmlLabelName(439,user.getLanguage())+":&nbsp;</b>"+
"<a href=\"javaScript:openhrm('"+approverid+"');\" onclick='pointerXY(event);'>"+
    	Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())+
"</A>&nbsp;&nbsp; <b>"+SystemEnv.getHtmlLabelName(25005,user.getLanguage())+":</b> "+VotingManager.getStatus(status,user.getLanguage()+"");

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    	session.setAttribute("fav_pagename" , temptitlename ) ;
    	
    		if(status.equals("0") && cancreate){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location.href='/voting/VotingEdit.jsp?votingid="+votingid+"&istemplate="+istemplate+"',_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
			
        if(status.equals("0") && !wfviewtmp &&  cancreate && showSubmitButton && istemplate !=1){
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
         

        
		//即是创建人也是审批人
        if(!iswfapprove && status.equals("0") && approverid.equals(createrid) && istemplate !=1 && !showSubmitButton){
		     
		             RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doApprove(),_top} " ;
                     RCMenuHeight += RCMenuHeightStep ;
		
		}else if(!iswfapprove && status.equals("3") && (canapprove || canmaint) && istemplate !=1  && !showSubmitButton){
		              RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doApprove(),_top} " ;
                      RCMenuHeight += RCMenuHeightStep ;
		}else if(!iswfapprove && status.equals("0") && (hasapprove || canmaint) && istemplate !=1  && !showSubmitButton){
		              RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:doApprove(),_top} " ;
                      RCMenuHeight += RCMenuHeightStep ;
		}

        
        if(status.equals("1") && cancreate && istemplate !=1){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:doEnd(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
        
        //任意状态的都可删除，拥有权限是前提
        if(canDelete&&("0".equals(status)||"2".equals(status))){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
        }
        
        //
        if(!status.equals("0") && canresulet && istemplate !=1){
           RCMenu += "{"+SystemEnv.getHtmlLabelName(356,user.getLanguage())+",javascript:doResult(),_top} " ;
           RCMenuHeight += RCMenuHeightStep ;
        }
        
        if(cancreate && istemplate !=1){
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+SystemEnv.getHtmlLabelName(15109,user.getLanguage())+",javascript:copyVoting(),_top} " ;
		      RCMenuHeight += RCMenuHeightStep ;
		        
		      RCMenu += "{"+SystemEnv.getHtmlLabelName(19468,user.getLanguage())+",javascript:saveAsTemplate(),_top} " ;
		      RCMenuHeight += RCMenuHeightStep ;
        }
        
        RCMenu += "{"+SystemEnv.getHtmlLabelName(33832, user.getLanguage())+",javascript:doUpdate()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
        
        if(!"1".equals(nogoback)){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goback()',_top} " ;
	        RCMenuHeight += RCMenuHeightStep ;
	      }
    %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
		  <%if(status.equals("0") && cancreate){%>
		  <span title="<%=SystemEnv.getHtmlLabelName(26473, user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doEdit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(26473, user.getLanguage())%>"/>
			</span>
		  <%}%>  
		  <span title="<%=SystemEnv.getHtmlLabelName(33832, user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doUpdate()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(33832, user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name=frmmain action="VotingOperation.jsp" method=get onsubmit="return check_form(this,'subject,creater,begindate')">
<input type=hidden name=votingid value="<%=votingid%>">
<input type=hidden name=createrid value="<%=createrid%>">
<input type=hidden name="method" value="finish">
<input type=hidden name="istemplate" value="<%=istemplate%>">
<input type=hidden name="approverid" value="<%=approverid%>">
<div style="display:block;width:100%;height:100%"></div>
<wea:layout type="2col" >
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':''}">
	          <wea:item attributes="{'colspan':'full'}"><%=descrtitle%></wea:item>
	         //名称
	         <wea:item><%=SystemEnv.getHtmlLabelName(33439, user.getLanguage())%></wea:item>
	         <wea:item>
				     <%=subject%>
	         </wea:item>
	         //描述
	         <wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
	         <wea:item>
	              <%=descr%>
	         </wea:item>
	         //开始日期
	         <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<%=begindate%> <%=begintime%>
            </wea:item>
	         //结束日期
	         <wea:item><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
          	<wea:item>
          		<%=enddate%> <%=endtime%>
			</wea:item>
	         //	发布类型
	         <wea:item><%=SystemEnv.getHtmlLabelName(1993, user.getLanguage())%></wea:item>
	    	 <wea:item>
	    	   <%if("0".equals(deploytype)){%><%=SystemEnv.getHtmlLabelName(32457, user.getLanguage())%><%}%><!--
			   <%if("1".equals(deploytype)){%><%=SystemEnv.getHtmlLabelName(32458, user.getLanguage())%><%}%>
			   <%if("2".equals(deploytype)){%><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage()) + SystemEnv.getHtmlLabelName(15109, user.getLanguage())%><%}%>

	    	 --></wea:item>
	      
	         //调查类型
	         <wea:item><%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%></wea:item>
	    	 <wea:item>

			             <% 
				          RecordSet.executeSql("select * from voting_type");
				          while(RecordSet.next()) {
				        	  int votingtypeid = RecordSet.getInt("id");
				         %>
			               <%if(votingtype == votingtypeid){%><%=RecordSet.getString("typename")%><%}%>
			               
			             <%}%>
			 </wea:item>
	    </wea:group>
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%>' attributes="{'groupDisplay':''}">
	         //允许匿名
	         <wea:item><%=SystemEnv.getHtmlLabelName(18576, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="isanony" disabled id="isanony" <% if(!"".equals(isanony)){ %> checked <%} %> />
	         </wea:item>
	         //答卷不显示结果
	         <wea:item><%=SystemEnv.getHtmlLabelName(21723, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="isSeeResult" disabled id="isSeeResult" <% if(!"".equals(isSeeResult)){ %> checked <%} %> />
	         </wea:item>
	         //强制调查
	         <wea:item><%=SystemEnv.getHtmlLabelName(23852, user.getLanguage()) + SystemEnv.getHtmlLabelName(15109, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" id="forcevote" disabled name="forcevote" <% if(!"".equals(forcevote)){ %> checked <%} %>  />
	         </wea:item>
	         //是否自动弹出调查
	         <wea:item><%=SystemEnv.getHtmlLabelName(125944,user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="autoshowvote" disabled id="autoshowvote" <% if(!"".equals(autoshowvote)){ %> checked <%} %> />
	         </wea:item>
	         
	         //调查提醒
	        <!--================ 调查提醒方式  ================-->
			<wea:item><%=SystemEnv.getHtmlLabelName(15109,user.getLanguage()) + SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></wea:item>
			<wea:item>
				<INPUT type="radio" disabled value="1" name="remindType" onclick=showRemindTime(this) <%if("1".equals(remindtype)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" disabled value="2" name="remindType" onclick=showRemindTime(this) <%if("2".equals(remindtype)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" disabled value="3" name="remindType" onclick=showRemindTime(this) <%if("3".equals(remindtype)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</wea:item>

		   <!--================ 调查提醒时间  ================-->
			<wea:item attributes="{'samePair':\"remindTime\"}">
				<%=SystemEnv.getHtmlLabelNames("26928,277",user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':\"remindTime\"}">
				 
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;" value="<%=remindtimebeforestart %>"  name="remindtimebeforestart" id="remindtimebeforestart"   size=5  >
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					&nbsp&nbsp&nbsp
				  

					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" style="width:40px;"  value="<%=remindtimebeforeend %>" name="remindtimebeforeend" id="remindtimebeforeend"  size=5  >
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</wea:item>    	
	    </wea:group>

</wea:layout>


</form>
<form name="extraform" action="" method="POST" target="targetframe">
</form>
<iframe name="targetframe" style="display:none;"></iframe>

<script language=javascript>

function copyVoting(){
	document.extraform.action = "VotingCopyOperation.jsp?alertsuccess=1&istempatea=0&ids=<%=votingid%>";
	document.extraform.submit();
}


function saveAsTemplate(){
	document.extraform.action = "VotingCopyOperation.jsp?alertsuccess=1&istempatea=1&ids=<%=votingid%>";
	document.extraform.submit();
}	
	
function alertsuccess(tmptval){
	if(tmptval==0){
		alert("<%=SystemEnv.getHtmlLabelNames("77,15109,15242",user.getLanguage())%>");			
	} else {
		alert("<%=SystemEnv.getHtmlLabelNames("18418,15242",user.getLanguage())%>");		
	}
}	

function goback(){
  window.open('VotingList.jsp?istemplate=<%=istemplate%>&viewResult=<%=viewResult%>','mainFrame','') ;
}

jQuery(document).ready(function(){
	/* 初始化 勾选*/
	
	<% if(!"".equals(remindtype)) { %>
        showRemindTime("<%=remindtype %>");
	<% }%>
	
	<% if(!"".equals(remindtimebeforestart)) { %>
        changeCheckboxStatus($("#remindbeforestart"),"true");
	<% }%>
	
	<% if(!"".equals(remindtimebeforeend)) { %>
        changeCheckboxStatus($("#remindbeforeend"),"true");
	<% }%>
	
	<% if(!"".equals(votetimecontrol)) { %>
        $("#votetimecontroldiv").css("display","");
        $("#votetimecontroltimeimg").css("display","none");
	<% }%>
	
    
});


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

function doEnd(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(18899,user.getLanguage())%>")) {
		  frmmain.method.value="finish";
		  document.frmmain.submit();
		  enableAllmenu();
	}
}

function doEdit(){
	location.href="/voting/VotingEdit.jsp?votingid=<%=votingid%>&istemplate=<%=istemplate%>"	
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


//编辑操作
function doResult(){
      
   var dlg=new window.top.Dialog();//定义Dialog对象
　　dlg.Model=true;
   dlg.maxiumnable=true;
　 dlg.Width=1024;//定义长度
　　dlg.Height=700;
   dlg.URL="/voting/VotingPollResult.jsp?votingid=<%=votingid%>";    
　 dlg.Title="<%=SystemEnv.getHtmlLabelName(20042,user.getLanguage())%>";
　 dlg.show();
}


function doDelete(){

	 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
         $.post("/voting/VotingOperation.jsp?method=delete&votingids=<%=votingid%>",{},function(){
				 window.open('VotingList.jsp?istemplate=<%=istemplate%>','mainFrame','');
				 
				 var dialog = parent.parent.getDialog(parent);
				 dialog.close();
				 
		 })
   });
}
function doPreView(votingid){
	window.open("/voting/VotingPreView.jsp?votingid="+votingid, "", "toolbar,resizable,scrollbars,dependent,height=600,width=800,top=0,left=100") ; 
}

function doApprove(){
     $.ajax({
	    data: "",
	    type: "POST",
	    url: "/voting/VotingTypeOperation.jsp?method=canApprove&votingid=<%=votingid%>",
	    timeout: 20000,
	    success: function (rs) {
	       if(rs && rs.trim()=='1'){
	              frmmain.method.value="approve";
			      document.frmmain.submit();
			      enableAllmenu();
	       }else{
	            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84103,user.getLanguage())%>");
    			return false;
	       }
	    }, fail: function () {
	        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84103,user.getLanguage())%>");
    		return false;
	    }
	});
}

function doSubmit(obj){
    frmmain.method.value="submit";
    document.frmmain.submit();
    enableAllmenu();
}
</script>
</body>
</html>
