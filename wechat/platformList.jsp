
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>


<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
if(!HrmUserVarify.checkUserRight("Wechat:Mgr", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//判断是否有分权
String detachable=Util.null2String(session.getAttribute("wechatdetachable")!=null?session.getAttribute("wechatdetachable").toString():"0");

String name=Util.null2String(request.getParameter("name"));
String publicid=Util.null2String(request.getParameter("publicid"));
String appid=Util.null2String(request.getParameter("appId"));
String state=Util.null2String(request.getParameter("state"));
String subcompany= Util.null2String(request.getParameter("subCompanyId"));
//分权模式下,默认获取有权限分部下所有的
if("1".equals(detachable)&&"".equals(subcompany)){//如果是分权,默认显示全部
	int[] subcomp=CheckSubCompanyRight.getSubComPathByUserRightId(userid,"Wechat:Mgr",0);
	for(int i=0;i<subcomp.length;i++){
		subcompany+="".equals(subcompany)?subcomp[i]+"":","+subcomp[i];
	}
}
 

String operate = Util.null2String(request.getParameter("operate"));
String platformIDs = Util.null2String(request.getParameter("platformIDs"));
if(null != platformIDs && !"".equals(platformIDs)){
	String ip=Util.getIpAddr(request);
	String temStr="";
	if("del".equals(operate)){//删除
		RecordSet.executeSql("select * from wechat_platform  where state=1 and id in ("+platformIDs+")");
		while(RecordSet.next()){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("id"),RecordSet.getString("publicid")+"-"+RecordSet.getString("name"),"微信公众平台管理-删除公众平台","214","3",0,ip);
		}
		temStr = "delete wechat_platform  where state=1 and id in ("+platformIDs+")";
	}else if("state".equals(operate)){
		String chagestate=Util.null2String(request.getParameter("chagestate"));
		temStr = "update wechat_platform set state='"+chagestate+"' where id in ("+platformIDs+")";
	}else if("def".equals(operate)){
		String def=Util.null2String(request.getParameter("chagestate"));
		if("1".equals(def)){//设置默认提醒
			//更新自身为默认提醒,取消其他的默认提醒
			temStr="update wechat_platform set defaultReminder=1 where id="+platformIDs;
			RecordSet.executeSql(temStr);
			temStr="update wechat_platform set defaultReminder=0 where id!="+platformIDs;
		}else{
			temStr = "update wechat_platform set defaultReminder=0 where id =" +platformIDs;
		}
	}
	if(!"".equals(temStr)){
		RecordSet.executeSql(temStr);
	}
}

String sqlwhere="where isdelete=0 ";
if(name!=null&&!"".equals(name)){
	sqlwhere+=" and name like '%"+name+"%' ";
}
if(publicid!=null&&!"".equals(publicid)){
	sqlwhere+=" and publicid like '%"+publicid+"%' ";
}
if(appid!=null&&!"".equals(appid)){
	sqlwhere+=" and appid like '%"+appid+"%' ";
}
if(state!=null&&!"".equals(state)){
	sqlwhere+=" and state = '"+state+"' ";
}
if(subcompany!=null&&!"".equals(subcompany)){
	sqlwhere+=" and subcompanyid in ("+subcompany+") ";
}
String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_PlatformList,user.getUID());

String backFields = " id,name, appid, appSecret, publicid, state,subcompanyid,defaultReminder";
String sqlFrom = " wechat_platform t1";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"platformTable\" tabletype=\"checkbox\">"+
			  " <checkboxpopedom  popedompara=\"column:state\" showmethod=\"weaver.wechat.WechatTransMethod.getPlatformCheck\"  />"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.wechat.WechatTransMethod.getPlatformName\" otherpara=\"column:id\"/>"+//公众平台+名称 
					  "<col width=\"15%\"  text=\"AppID\" column=\"appid\" orderkey=\"appid\" />"+
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(613,user.getLanguage())+"ID\"  column=\"publicid\" orderkey=\"publicid\" />"+//原始
					  ("1".equals(detachable)?"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\"  column=\"subcompanyid\" transmethod=\"weaver.wechat.WechatTransMethod.getSubCompany\"/>":"")+//所属机构
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"state\" orderkey=\"state\" transmethod=\"weaver.wechat.WechatTransMethod.getPlatformState\" otherpara=\""+user.getLanguage()+"+column:defaultReminder+"+userid+"\"/>"+//状态
			  "</head>";
tableString +=  "<operates>"+
                "		<popedom column=\"id\" otherpara=\"column:state\" transmethod=\"weaver.wechat.WechatTransMethod.getPlatformOpt\"></popedom> "+
				"		<operate href=\"javascript:qiyong();\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:jinyong();\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
                "		<operate href=\"javascript:editPlat();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"		<operate href=\"javascript:delPlat();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
				"		<operate href=\"javascript:menu();\" text=\""+SystemEnv.getHtmlLabelName(23036,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage())+"\" target=\"_self\" index=\"4\"/>"+
				"		<operate href=\"javascript:eventList();\" text=\""+SystemEnv.getHtmlLabelName(32693,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage())+"\" target=\"_self\" index=\"5\"/>"+
				"		<operate href=\"javascript:used();\" text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\" target=\"_self\" index=\"6\"/>"+
				"		<operate href=\"javascript:setupself();\" text=\""+SystemEnv.getHtmlLabelName(18166,user.getLanguage())+"\" target=\"_self\" index=\"7\"/>"+
				"</operates>";
tableString += "</table>";
 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doAdd()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doDel()"/>
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
	<form id=weaverA name=weaverA method=post action="platformList.jsp">
	<input type="hidden" name="operate" value="">
	<input type="hidden" name="platformIDs" value="">
	<input type="hidden" name="chagestate" value="">
	<input type="hidden" name="subcompany" value="<%=subcompany %>">
		  	<wea:layout type="4col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
		      <wea:item><%=SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<input type="text" id="name" name="name" value="<%=name%>" class="InputStyle">
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		      <wea:item>
		       	  <select id="state"  name="state" style="width:80px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value=0 <%if(state.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
					<option value=1 <%if(state.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
				 </select>
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(613,user.getLanguage())%>ID</wea:item>
		      <wea:item>
		      	<input type="text" id="publicid" name="publicid" value="<%=publicid%>" class="InputStyle">
		      </wea:item>
		      
		      <wea:item>AppID</wea:item>
		      <wea:item>
		        <input type="text" id="appId" name="appId" value="<%=appid%>" class="InputStyle">
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
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_PlatformList%>"/>
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
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
	//doSubmit();
}

function refreshTable(){
	_table.reLoad();
}

function doAdd(){
	var subcompany="<%=subcompany %>";
	if(subcompany.indexOf(",")>-1){
		subcompany="";
	}
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformAddTab.jsp?dialog=1&subcompanyid="+subcompany;
	diag_vote.show();
	
}

function resetCondtionAVS(){
	jQuery("#name").val("");
	jQuery("#publicid").val("");
	jQuery("#appId").val("");
	jQuery("#state").val("");
	$("#state").selectbox('detach');
	$("#state").selectbox('attach');
}

function doSubmit()
{
	document.forms[0].submit();
}

function editPlat(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformTab.jsp?dialog=1&method=edit&id="+id;
	diag_vote.show();
}

function delPlat(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		jQuery("input[name=operate]").val("del");
        jQuery("input[name=platformIDs]").val(id);
        document.forms[0].submit();
	});
}

function doDel(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        jQuery("input[name=operate]").val("del");
	        jQuery("input[name=platformIDs]").val(deleteids.substr(0,deleteids.length-1));
	        document.forms[0].submit();
	    });
    }
}

function statePlat(id,state){
	if(state==1){
	   	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32690,user.getLanguage())%>",function(){//确定要禁用么
		     $.post("platformOperate.jsp", 
				{"operate":"state", "id": id,"state":1},
			   	function(data){
					var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
					 if(data=="true"){
					 	 _table.reLoad();
					 }else{
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
					 }
		   		});
	     });
	}else{
		$.post("platformOperate.jsp", 
			{"operate":"state", "id": id,"state":0},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else if(data=="false"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }else{
				 	window.top.Dialog.alert(data);
				 }
	   		});
	}
}

function qiyong(id){
	statePlat(id,0);
}

function jinyong(id){
	statePlat(id,1);
}

function menu(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 750;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformTab.jsp?dialog=1&method=menu&id="+id;
	diag_vote.show();
}

//事件
function eventList(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 750;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformTab.jsp?dialog=1&method=event&id="+id;
	diag_vote.show();
}

//可用范围
function used(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 750;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformTab.jsp?dialog=1&method=used&id="+id;
	diag_vote.show();
}


function setupself(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 750;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage())%>";
	diag_vote.URL = "/wechat/platformTab.jsp?dialog=1&method=setup&id="+id;
	diag_vote.show();
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
	$("#name").val(name);
	doSubmit();
} 
</script>

</html>
