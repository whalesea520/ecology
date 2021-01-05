
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util,weaver.wechat.bean.WeChatBean" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="MailAndMessage" class="weaver.workflow.request.MailAndMessage" scope="page"/>
<%
//获取用户信息,根据用户信息,获取有权限的公众平台
 int userid=user.getUID(); 
 String usertype=user.getLogintype();
 int dep=user.getUserDepartment();
 int subcom=user.getUserSubCompany1();
 String seclevel=user.getSeclevel();
 //微信提醒（QC:98106）
 String chats = "";
 int wfid = Util.getIntValue(request.getParameter("workflowid"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int reqid = Util.getIntValue(request.getParameter("reqid"), 0);
String actionid = Util.null2String(request.getParameter("actionid"));
int menuid = Util.getIntValue(request.getParameter("menuid"), 0);
String id_hrm="";  
String name_hrm=""; 
//获得当前节点操作人
if(reqid != 0 && wfid != 0 && nodeid != 0){
	String sql_1 = "select distinct id,lastname from HrmResource where id in (select userid from workflow_currentoperator where requestid="+reqid + " and nodeid="+nodeid+") and id <> " + userid;
	rs_1.executeSql(sql_1);

	while(rs_1.next()){ 
		id_hrm = id_hrm + rs_1.getString("id") + ","; 		 
		name_hrm = name_hrm + "<a href=\"javaScript:openFullWindowHaveBar(\'/hrm/resource/HrmResource.jsp?id=" + rs_1.getString("id") + "\')\">" + Util.toScreen(rs_1.getString("lastname"),user.getLanguage()) + "</a>, ";
	}
	if(!"".equals(id_hrm)){
		id_hrm = id_hrm.substring(0, id_hrm.length()-1);
	} 
}
//微信提醒（QC:98106）
 //1 分部、2 部门、3 人力资源、4 角色、5 所有人
 String sql="select publicid,name from wechat_platform  where state=0 and isdelete=0 and id in "+
 		"(SELECT DISTINCT platformid FROM wechat_share where ( (permissiontype=5  and seclevel<="+seclevel+" and seclevelMax>="+seclevel+") "+
 		" or (permissiontype=3 and typevalue="+userid+") "+
		" or (permissiontype=4 and typevalue in (select roleid from hrmrolemembers where resourceid="+userid+") and seclevel<="+seclevel+" and seclevelMax>="+seclevel+") "+
		" or (permissiontype=2 and typevalue="+dep+" and seclevel<="+seclevel+" and seclevelMax>="+seclevel+") "+
		" or (permissiontype=1 and typevalue="+subcom+" and seclevel<="+seclevel+" and seclevelMax>="+seclevel+"))) ";
//系统管理员获取所有可用账号
if(userid==1){
 	sql="select publicid,name from wechat_platform  where state=0 and isdelete=0 ";
 }
rs.executeSql(sql);
List<WeChatBean> list=new ArrayList<WeChatBean>();
WeChatBean wc=null;
while(rs.next()){
	wc=new WeChatBean();
	wc.setPublicid(rs.getString("publicid"));
	wc.setName(rs.getString("name"));
	list.add(wc);
}		
//外部传入的参数
//微信提醒(QC:98106)
if(wfid != 0 && nodeid != 0 && menuid > 0){
	chats = MailAndMessage.getChats(reqid, wfid, nodeid, user.getLanguage(), menuid);
}
//将短信内容中的“&nbsp;”替换为“ ”
if(!"".equals(chats)){
	chats = Util.replace(chats, "&nbsp;", " ", 0);
}

 
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="js/wechat_wev8.js"></script>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32642,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="communicate"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32642,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2083,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>


<FORM id=weaver name=weaver action="wechatOperate.jsp" method=post >
  <input type="hidden" id="userid" name="userid" value="<%=userid %>">
  <input type="hidden" id="usertype" name="usertype" value="<%=usertype %>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2Col">
				     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					      <wea:item><%=SystemEnv.getHtmlLabelName(32638,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage()) %></wea:item>
					      <wea:item>
					         <select id="publicid" name="publicid" size="20" style="width:150px;">
			               		<% if(list.size()>0){
			               			for(int i=0;i<list.size();i++){
			               				wc=list.get(i);
			               		%>
			               			<option value="<%=wc.getPublicid() %>" <%if(i==0){%>selected<%}%>><%=wc.getName() %></option>
			               		<%}}else{%>
			               		<option value=""></option>
			               		<%}%>
			               		<span id="publicidspan"></span>
			               	</select>
					      </wea:item>
					      
					      <wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage()) %></wea:item>
					      <wea:item>
					      		<!-- 人力资源 -->
				    			<brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(15525,user.getLanguage()) %>' name="hrmid" browserValue='<%=id_hrm%>'
								browserOnClick="showWechatHRm(event)" browserUrl=""
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2' 
								completeUrl="/data.jsp?type=wechatHrm" extraParams="{'publicid':'function(){return queryPublic()}'}" linkUrl="/hrm/resource/HrmResource.jsp?id=" 
								browserSpanValue='<%=name_hrm%>'></brow:browser>
					      </wea:item>
					       
							<%if(reqid>0){%>
								<input id="isNews" type=hidden name="isNews" value="0"> 
							<%}else{%>
							<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item>
					        <wea:item>
								 <select class="saveHistory" id="isNews"  name="isNews" onchange="changeType(this)" >
									<option value=0 selected><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></option>
									<option value=1 ><%=SystemEnv.getHtmlLabelName(81638, user.getLanguage())%></option>
								 </select>
					         </wea:item>
					        
							<%}%>
		
					      <wea:item attributes="{'samePair':'msgstr'}"><%=SystemEnv.getHtmlLabelName(345,user.getLanguage()) %></wea:item>
					      <wea:item attributes="{'samePair':'msgstr'}">
					         <!-- 微信提醒(QC:98106) -->
					         <TEXTAREA class=InputStyle style="width:95%;word-break:break-all" id="message" name="message" rows="5" onchange='checkinput("message","messageimage")'><%=chats%></TEXTAREA>
              				 <SPAN id=messageimage><%if("".equals(chats)){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
					      </wea:item>
					      
					      <wea:item attributes="{'samePair':'newstr','display':'none'}"><%=SystemEnv.getHtmlLabelName(81638,user.getLanguage()) %></wea:item>
					      <wea:item attributes="{'samePair':'newstr','display':'none'}">
						      	<brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(81638,user.getLanguage())%>' name="news" browserValue=""
								browserOnClick="" browserUrl="/wechat/bowser/news/newsBrowser.jsp?id="  width="40%"
								hasInput="false"  isSingle="true" hasBrowser = "true" isMustInput='2'  
								completeUrl="" linkUrl="/wechat/materialView.jsp?newsid=" 
								></brow:browser>
								
					      </wea:item>
					   </wea:group>
			</wea:layout>
 </td>
</tr>
</table>
</FORM>
<%if(actionid.equals("dialog")){%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" accessKey=S  id=btnclose value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWin()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%}%>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   
<script language="javascript">
var isSubmit=false;

$(document).ready(function() {
	 
});

function changeType(obj){
	if($(obj).val()==1){
		hideEle('msgstr');
		showEle('newstr');
	}else{
		hideEle('newstr');
		showEle('msgstr');
	}
}

	
function doSubmit(){
	rightMenu.style.visibility="hidden";
	if($('#publicid').val()==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32931,user.getLanguage())%>");
		return false;
	}else{
		if($('#isNews').val()==1){
			if($('#hrmid').val()==""||$('#news').val()==""){
				window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>") ;
				return false;
			}
		}else{
			if($('#hrmid').val()==""||$('#message').val()==""){
				window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>") ;
				return false;
			}
		}
	}
	//防止重复提交
	if(!isSubmit){
		isSubmit=true;
		$.post("wechatOperate.jsp", 
			{"userid":$('#userid').val(), "usertype": $('#usertype').val(),"hrmid":$('#hrmid').val(),
			"publicid":$('#publicid').val(),"message":encodeURIComponent($('#message').val()),"isNews":$('#isNews').val(),"news":$('#news').val()},
   			function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			 	if(data=="true"){
		 	 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>",closeWin);
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
			 	isSubmit=false;
  		});
	}
}

function closeWin(){
<%if(actionid.equals("dialog")){%>
	if(dialog){
		dialog.close();
   	}else{ 
   	 	window.parent.close();
   	}
<%}else{%>
	location.reload();
<%}%>
}

function resetForm(){
	$('#hrmid').val("");
	$('#hrmidspan').html("");
	$('#hrmidspanimg').html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
	$('#message').val("");
	$('#messageimage').html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
}

//自动补全,动态取值
function queryPublic(){
	return $('#publicid').val();
}
//弹出框,没有平台提示,不弹出选择
function showWechatHRm(eventObj){
	 
	if($('#publicid').val()==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32931,user.getLanguage())%>");
		return false;
	}
	//onShowHrmResource4Wechat('','publicid');
	var tmpids = jQuery("#hrmid").val();
	var publicidvalue = jQuery("#publicid").val();
	
	var	url = "/systeminfo/BrowserMain.jsp?url=/wechat/bowser/hrm/MutiResourceBrowser.jsp";
	var param=encodeURIComponent("resourceids="+tmpids+"&publicid="+publicidvalue);
	url=url+ "?" +param
	showModalDialogForBrowser(eventObj,url,'/hrm/resource/HrmResource.jsp?id=','hrmid',false,2,'',{name:'hrmid',hasInput:true,zDialog:true,arguments:'',dialogTitle:'<%=SystemEnv.getHtmlLabelName(15525,user.getLanguage()) %>'});
}

function showNews(){
	var param=encodeURIComponent("id="+$('#news').val());
	var ret=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/wechat/bowser/news/newsBrowser.jsp?"+param);
	if(ret){
		if(ret.id!="") {
			var ids =wuiUtil.getJsonValueByIndex(ret,0);
			var names =wuiUtil.getJsonValueByIndex(ret,1);
			$("#newsBtnSpan").html("<a href='javascript:previewNews("+ids+")' style='cursor:hand'>[<%=SystemEnv.getHtmlLabelName(81634, user.getLanguage())%>]-"+names+"</a>");
            $("#news").val(ids);
		}else{
			$("#newsBtnSpan").html('<IMG src="/images/BacoError.gif" align=absMiddle>');
            $("#news").val("");
		}
	}
}
function previewNews(id){
	 openNewsPreview('/wechat/materialView.jsp?newsid='+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>");
}

</script>
<SCRIPT language="javascript" defer="defer" src="/wechat/js/wechatNews_wev8.js"></script>
</HTML>
