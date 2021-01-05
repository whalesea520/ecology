
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String usertype=user.getLogintype();

int timeSag = Util.getIntValue(request.getParameter("timeSag"),1);
String state=Util.null2String(request.getParameter("state"));//发送状态
String msgtype=Util.null2String(request.getParameter("msgtype"));//消息类型,1发送 2接收

String fromdate = Util.fromScreen(request.getParameter("fromdate"), user.getLanguage());
String enddate = Util.fromScreen(request.getParameter("enddate"), user.getLanguage());

String msg=Util.null2String(request.getParameter("msg"));
String name=Util.null2String(request.getParameter("name"));
String touserid=Util.null2String(request.getParameter("touserid"));
String touserdept=Util.null2String(request.getParameter("touserdept"));
String tousersub=Util.null2String(request.getParameter("tousersub"));
    
String operate = Util.null2String(request.getParameter("operate"));
String IDS = Util.null2String(request.getParameter("IDS"));
if(null != IDS && !"".equals(IDS)){
	String ip=Util.getIpAddr(request);
	String temStr="";
	if("del".equals(operate)){//删除
		temStr = "update wechat_msg set isdelete='1' where id in ("+IDS+")";
		RecordSet.executeSql(temStr);
		String[] wxIDs=IDS.split(",");
	    for(int i=0;i<wxIDs.length;i++){
	    	String id=wxIDs[i];
	    	if("".equals(id)) continue;
		    CommunicateLog.resetParameter();
		    CommunicateLog.insSysLogInfo(user,Util.getIntValue(id),"删除微信","删除微信","398","3",1,ip);
	    }
	} 
}

String sqlwhere="where t2.isdelete=0 and  t2.msgtype=1 and userid="+userid+" and usertype="+usertype;
if(userid==1){
	//sqlwhere="where t2.isdelete=0 and msgtype=1 ";
}
if(!msg.equals("")){
	sqlwhere += " and msg like '%" + msg+"%'";
}
if(!name.equals("")){
	sqlwhere += " and t1.name like '%" + name+"%'";
}
if(!touserid.equals("")){
	sqlwhere += " and touserid=" + touserid;
}
if(!touserdept.equals("")){
	sqlwhere += (" AND ( exists (select 1 from HrmResource where t2.touserid = HrmResource.id and HrmResource.departmentid in( "+ touserdept +")) ) ");
} 
if(!tousersub.equals("")){
	sqlwhere +=(" AND ( exists (select 1 from HrmResource where t2.touserid = HrmResource.id and HrmResource.subcompanyid1 in("+ tousersub +")) ) ");
}
if(msgtype!=null&&!"".equals(msgtype)){
	sqlwhere+=" and t2.msgtype = '"+msgtype+"' ";
}
if(state!=null&&!"".equals(state)){
	sqlwhere+=" and t2.state = '"+state+"' ";
}
//时间处理
if(timeSag > 0&&timeSag<6){
	String tempfromdate = TimeUtil.getDateByOption(""+timeSag,"0");
	String tempenddate = TimeUtil.getDateByOption(""+timeSag,"1");
	if(!tempfromdate.equals("")){
		sqlwhere += " and t2.sendtime >= '" + tempfromdate + " 00:00:00'";
	}
	if(!tempenddate.equals("")){
		sqlwhere += " and t2.sendtime <= '" + tempenddate + " 23:59:59'";
	}
}else{
	if(timeSag==6){//指定时间
		if (!fromdate.equals("")) {
		    sqlwhere += " and t2.sendtime>='" + fromdate + " 00:00:00'";
		}
		if (!enddate.equals("")) {
		    sqlwhere += " and t2.sendtime<='" + enddate + " 23:59:59'";
		}
	}
}

    
String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_wechatList,user.getUID());

sqlwhere+=" and t1.publicid=t2.publicid ";
String backFields = " t1.name,t2.* ";
String sqlFrom = " wechat_platform t1, wechat_msg t2";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"wechatMsgTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"t2.id\" sqlsortway=\"desc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15525,user.getLanguage())+"\" column=\"touserid\" transmethod=\"weaver.wechat.WechatTransMethod.getHrmResources\" otherpara=\"column:tousertype\" orderkey=\"touserid\"/>"+
					  "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(345,user.getLanguage())+"\" column=\"msg\" transmethod=\"weaver.wechat.WechatTransMethod.getWechatMsgType\" otherpara=\""+user.getLanguage()+"+column:isNews\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"state\" transmethod=\"weaver.wechat.WechatTransMethod.getMsgState\" otherpara=\""+user.getLanguage()+"\" orderkey=\"t2.state\"/>"+
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18961,user.getLanguage())+"\"  column=\"sendtime\" orderkey=\"sendtime\"/>"+
			  "</head>";
tableString +=  "<operates>"+
				"		<operate href=\"javascript:viewDetail();\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:delMsg();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"</operates>";
tableString += "</table>";
        

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32640,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="doDelete()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<form id=weaverA name=weaverA method=post action="wechatList.jsp">
		<input type="hidden" name="operate" value="">
		<input type="hidden" name="IDS" value="">
		  	<wea:layout type="4col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
		      <wea:item><%=SystemEnv.getHtmlLabelName(2083,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<input type="text" id="msg" name="msg" value="<%=msg%>" class="InputStyle">
		      </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<input type="text" id="name" name="name" value="<%=name%>" class="InputStyle">
		      </wea:item>
					
		      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		      <wea:item>
		       	  <select id="state"  name="state" style="width:100px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value=1 <%if(state.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27564,user.getLanguage())%></option>
					<option value=2 <%if(state.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22397,user.getLanguage())%></option>
				 </select>
		      </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></wea:item>
		      <wea:item>
		      	 <brow:browser viewType="0" temptitle="" name="touserid" browserValue='<%=touserid %>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'   
								completeUrl="/data.jsp" linkUrl="/hrm/resource/HrmResource.jsp?id=" 
								browserSpanValue='<%=!"".equals(touserid)?ResourceComInfo.getLastname(touserid):""%>'></brow:browser>
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		      <wea:item>
					<brow:browser viewType="0" temptitle="" name="touserdept" browserValue='<%=touserdept %>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'   
								completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
								browserSpanValue='<%=!"".equals(touserdept)?DepartmentComInfo.getDepartmentName(touserdept):"" %>'></brow:browser>
		      </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		      <wea:item>
			  	     <brow:browser viewType="0" temptitle="" name="tousersub" browserValue='<%=tousersub %>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue='<%=!"".equals(tousersub)?SubCompanyComInfo.getSubCompanyname(tousersub):"" %>'></brow:browser>
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(18961,user.getLanguage())%></wea:item>
		      <wea:item>
                    	<span>
                          	<select name="timeSag" id="timeSag" onchange="changeTimeSag(this,'senddate');" style="width:100px;">
                          		<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                          		<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
                          		<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
                          		<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
                          		<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
                          		<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
                          		<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
                          	</select>
                          </span>
                          <span id="senddate"  style="<%=timeSag==6?"":"display:none;" %>">
                          	  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
							  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate, user.getLanguage())%></SPAN>
							  <input type="hidden" name="fromdate" value="<%=fromdate%>">
							   &nbsp;－&nbsp;
								<BUTTON class=calendar type=button id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
							  <SPAN id=enddatespan ><%=Util.toScreen(enddate, user.getLanguage())%></SPAN>
							  <input type="hidden" name="enddate" value="<%=enddate%>">
						 </span>
		      </wea:item>
	      </wea:group>
	      
		<!-- 操作 -->
	     <wea:group context="">
	    	<wea:item type="toolbar">
		        <input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		    </wea:item>
	    </wea:group>
	    </wea:layout>
 </form>
</div>

<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top"><input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_wechatList%>"/>
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
	</td>
</tr>
</table>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
	jQuery("li.current",parent.document).removeClass("current");
	if(jQuery("#timeSag").val()=="0"){
		jQuery("#ALLli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="1"){
		jQuery("#TODAYli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="2"){
		jQuery("#WEEKli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="3"){
		jQuery("#MOUTHli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="4"){
		jQuery("#SEASONli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="5"){
		jQuery("#YEARli",parent.document).addClass("current");
	} else {
		jQuery("#ALLli",parent.document).addClass("current");
	}
});

var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function doSubmit()
{
	if ($('#timeSag').val()==6&&!checkDateValid("fromdate", "enddate")) {
		alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
		return;
	}
	document.forms[0].submit();
}

function changeTimeSag(obj,spanname){
	if($(obj).val()=="6"){
		$('#'+spanname).show();
	}else{
		$('#'+spanname).hide();
	}
}

function checkDateValid(objStartName, objEndName) {
	var dateStart = document.all(objStartName).value;
	var dateEnd = document.all(objEndName).value;

	if ((dateStart == null || dateStart == "") || (dateEnd == null || dateEnd == ""))
		return true;

	var yearStart = dateStart.substring(0,4);
	var monthStart = dateStart.substring(5,7);
	var dayStart = dateStart.substring(8,10);
	var yearEnd = dateEnd.substring(0,4);
	var monthEnd = dateEnd.substring(5,7);
	var dayEnd = dateEnd.substring(8,10);
		
	if (yearStart > yearEnd)		
		return false;
	
	if (yearStart == yearEnd) {
		if (monthStart > monthEnd)
			return false;
		
		if (monthStart == monthEnd)
			if (dayStart > dayEnd)
				return false;
	}

	return true;
}

function delMsg(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
 	window.top.Dialog.confirm(str,function(){
       jQuery("input[name=operate]").val("del");
        jQuery("input[name=IDS]").val(id);
        document.forms[0].submit();
    });
}

function childDelMsg(id){
     jQuery("input[name=operate]").val("del");
     jQuery("input[name=IDS]").val(id);
     document.forms[0].submit();
}

function viewDetail(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%>";
	diag_vote.URL = "/wechat/wechatViewTab.jsp?id="+id;
	diag_vote.show();
	
}

function doDelete(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        jQuery("input[name=operate]").val("del");
	        jQuery("input[name=IDS]").val(deleteids.substr(0,deleteids.length-1));
	        document.forms[0].submit();
	    });
    }
    
}       

function resetCondtion(){
	$('#msg').val("");
	$('#name').val("");
	$('#state').val("");
	$("#state").selectbox('detach');
	$("#state").selectbox('attach');
	
	$('#touserid').val("");
	$('#touseridspan').html("");
	$('#touserdept').val("");
	$('#touserdeptspan').html("");
	$('#tousersub').val("");
	$('#tousersubspan').html("");
	$('#timeSag').val("0");
	
	
	$("#timeSag").selectbox('detach');
	$("#timeSag").selectbox('attach');
	
	changeTimeSag($('#timeSag'),'senddate')
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}
function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#msg").val(name);
	doSubmit();
}          
function previewNews(id){
	 openNewsPreview('/wechat/materialView.jsp?newsid='+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>");
}

</script>
<SCRIPT language="javascript" defer="defer" src="/wechat/js/wechatNews_wev8.js"></script>
</html>
