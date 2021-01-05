
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String usertype=user.getLogintype();
 
//进入页面,首先插入待绑列表中不存在的公众账号记录
String insertSql="INSERT into wechat_band(publicid,userid,usertype) "+
		" SELECT t1.publicid,"+userid+","+usertype+" FROM  wechat_platform t1 where  t1.state=0 and t1.isdelete=0  "+
		" and not exists (SELECT 1 from wechat_band t2 where t2.userid="+userid+" and t2.usertype="+usertype+" and t2.publicid=t1.publicid)";
rs.executeSql(insertSql);

//判断是否有分权
String detachable=Util.null2String(session.getAttribute("wechatdetachable")!=null?session.getAttribute("wechatdetachable").toString():"0");


String operate = Util.null2String(request.getParameter("operate"));
String IDS = Util.null2String(request.getParameter("IDS"));
if(null != IDS && !"".equals(IDS)){
	String ip=Util.getIpAddr(request);
	String temStr="";
	if("cancelBand".equals(operate)){//删除
		temStr = "update wechat_band set openid=null where id in ("+IDS+")";
		rs.executeSql(temStr);
		CommunicateLog.resetParameter();
	    CommunicateLog.insSysLogInfo(user,Util.getIntValue(IDS),"取消绑定","取消OA账号与微信账号绑定","399","3",1,ip);
	} 
}


String name=Util.null2String(request.getParameter("name"));
String state=Util.null2String(request.getParameter("state"));

String sqlwhere="where t1.state=0 and t1.publicid=t2.publicid and t2.userid="+userid+" and t2.usertype="+usertype;
if(name!=null&&!"".equals(name)){
	sqlwhere+=" and t1.name like '%"+name+"%' ";
}
if(state!=null&&!"".equals(state)){
	if("0".equals(state)){
		sqlwhere+=" and t2.openid is not null ";
	}else{
		sqlwhere+=" and t2.openid is null ";
	}
}


String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_BandList,user.getUID());

String backFields = " t2.id,t1.name, t1.subcompanyid,t2.openid ";
String sqlFrom = " wechat_platform t1,wechat_band t2 ";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"platformTable\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"t2.id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\"/>"+
					  ("1".equals(detachable)?"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\"  column=\"subcompanyid\" transmethod=\"weaver.wechat.WechatTransMethod.getSubCompany\"/>":"")+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"openid\" transmethod=\"weaver.wechat.WechatTransMethod.getBandState\" otherpara=\""+user.getLanguage()+"\"/>"+
			  "</head>";
tableString +=  "<operates>"+
                "		<popedom column=\"t2.id\" otherpara=\"column:openid\" transmethod=\"weaver.wechat.WechatTransMethod.getBandOpt\"></popedom> "+
				"		<operate href=\"javascript:bandOpenid();\" text=\""+SystemEnv.getHtmlLabelName(25436,user.getLanguage())+SystemEnv.getHtmlLabelName(28032,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:cancelBand();\" text=\""+SystemEnv.getHtmlLabelName(201,user.getLanguage())+SystemEnv.getHtmlLabelName(28032,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"</operates>";
tableString += "</table>"; 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32641,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<form id=weaverA name=weaverA method=post action="platformBandList.jsp">
	<input type="hidden" name="operate" value="">
	<input type="hidden" name="IDS" value="">
		  	<wea:layout type="4col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
		      <wea:item><%=SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<input type="text" id="name" name="name" value="<%=name%>" class="InputStyle">
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(104,user.getLanguage()) %></wea:item>
		      <wea:item>
		       	  <select class=saveHistory id="state"  name="state" style="width:100px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value=0 <%if(state.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32695,user.getLanguage()) %></option>
					<option value=1 <%if(state.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32628,user.getLanguage()) %></option>
				 </select>
		      </wea:item>
	      </wea:group>
		<!-- 操作 -->
	     <wea:group context="">
	    	<wea:item type="toolbar">
		        <input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		    </wea:item>
	    </wea:group>
	    </wea:layout>
 </form>
</div>


<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_BandList%>"/>
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
	</td>
</tr>
</table>

</body>
<script language="javascript">
 
var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	_table.reLoad();
	diag_vote.close();
}
 

function doSubmit()
{
	document.forms[0].submit();
}

function bandOpenid(id,str,obj){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 400;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.CancelEvent = closeDlgARfsh;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(25436,user.getLanguage())+SystemEnv.getHtmlLabelName(28032,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformBandTab.jsp?id="+id;
	diag_vote.show();
	
} 

function cancelBand(id){
	var str = "<%=SystemEnv.getHtmlLabelName(32701,user.getLanguage()) %>";
   	window.top.Dialog.confirm(str,function(){
      	jQuery("input[name=operate]").val("cancelBand");
        jQuery("input[name=IDS]").val(id);
        document.forms[0].submit();
   	}); 
}

  
function preDo(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$("#hoverBtnSpan").hoverBtn();
}
function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#name").val(name);
	doSubmit();
}  

function resetCondtionAVS(){
	$("#name").val("");
	$('#state').val("");
	$("#state").selectbox('detach');
	$("#state").selectbox('attach');
}         
         
</script>

</html>
