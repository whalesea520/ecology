
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>



</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
//判断是否有分权
String detachable=Util.null2String(session.getAttribute("wechatdetachable")!=null?session.getAttribute("wechatdetachable").toString():"0");
String dialog = Util.null2String(request.getParameter("dialog"));
String operate=Util.null2String(request.getParameter("operate"));

String name = Util.null2String(request.getParameter("name"));
String id = Util.null2String(request.getParameter("id"));
String appId = Util.null2String(request.getParameter("appId"));
String appSecret = Util.null2String(request.getParameter("appSecret"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String publicid=Util.null2String(request.getParameter("publicid"));
String state=Util.null2String(request.getParameter("state"));
String appidmsg="";
String op="";
if("1".equals(detachable)){
	subcompanyid=subcompanyid!=null&&!"".equals(subcompanyid)?subcompanyid:user.getUserSubCompany1()+"";
	subcompanyid="0".equals(subcompanyid)?"":subcompanyid;
}
if("save".equals(operate)){
	op="error";
	rs.executeSql("select 1 from wechat_platform where appId='"+appId+"' and id!="+id);
	if(!rs.next()){
		if(name!=null&&!"".equals(name)&&appId!=null&&!"".equals(appId)&&appSecret!=null&&!"".equals(appSecret)&&id!=null&&!"".equals(id)){
				subcompanyid=subcompanyid!=null&&!"".equals(subcompanyid)?subcompanyid:"";
				String datasql="update wechat_platform set name='"+name+"',appid='"+appId+"',appSecret='"+appSecret+
					"',subcompanyid='"+subcompanyid+"' where id='"+id+"'";
				if(rs.executeSql(datasql)){
					SysMaintenanceLog.resetParameter();
					SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),"修改基本信息","公众平台基本信息修改","214","2",0,Util.getIpAddr(request));
 					 op="success";
				}
			}
	}else{
		appidmsg="AppID"+SystemEnv.getHtmlLabelName(24943,user.getLanguage());//原始ID已存在
	}
}else{//进入编辑页面
	String datasql="select * from  wechat_platform where id='"+id+"'";
	rs.executeSql(datasql);
	if(rs.next()){
		name=rs.getString("name");
		id=rs.getString("id");
		appId=rs.getString("appid");
		appSecret=rs.getString("appSecret");
		subcompanyid =rs.getString("subcompanyid");
		publicid=rs.getString("publicid");
		state=rs.getString("state");
	}
}



String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32639,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if("1".equals(state)&&"1".equals(dialog)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id=weaverA name=weaverA method=post action="platformEdit.jsp">
<input type="hidden" name="operate" value="save">
<input type="hidden" name="state" value="<%=state %>">
<input type="hidden" name="publicid" value="<%=publicid %>">
<input type="hidden" name="id" value="<%=id %>">
<input type="hidden" value="<%=dialog%>" name="dialog" id="dialog" />
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right; ">
						<%if("1".equals(state)&&"1".equals(dialog)){%>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit()"/>
						<%}%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
					</td>
				</tr>
			</table>
			<div class="zDialog_div_content" style="overflow:auto;">
			 <wea:layout type="2col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				      <wea:item>
				         <input type="text" id="name" name="name" value="<%=name%>" class="InputStyle" onchange='checkinput("name","nameimage")'>
				         <SPAN id=nameimage></SPAN>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(613,user.getLanguage())%>ID</wea:item>
				      <wea:item>
				      	<input type="text" disabled value="<%=publicid%>" class="InputStyle">
				     </wea:item>
				      
				      <wea:item>AppID</wea:item>
				      <wea:item>
				        <input type="text" id="appId" name="appId" value="<%=appId%>" class="InputStyle" onchange='checkinput("appId","appIdimage")'>
					  	<SPAN id=appIdimage style="color:red"><%=appidmsg %></SPAN>
				      </wea:item>
				      
				      <wea:item>AppSecret</wea:item>
				      <wea:item>
				       	  <input type="text" id="appSecret" name="appSecret" value="<%=appSecret%>" class="InputStyle" onchange='checkinput("appSecret","appSecretimage")'>
			              <SPAN id=appSecretimage></SPAN>
				      </wea:item>
				      
				      <%if("1".equals(detachable)){ %>
		              <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
		              <wea:item>
		                <brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>' name="subcompanyid" browserValue='<%=subcompanyid %>'
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr=Wechat:Mgr&selectedids=" 
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid) %>'></brow:browser>
					 </wea:item>
				     <%} %>
			     </wea:group>
			</wea:layout>	
			</div>
		 
			<%
				if ("1".equals(dialog)) {
			%>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
					<!-- 操作 -->
				     <wea:group context="">
				    	<wea:item type="toolbar">
						  <input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
					    </wea:item>
				    </wea:group>
			    </wea:layout>
			</div>
			<%
				}
			%>
			</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>

</body>
<script language="javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
}catch(e){}

var op="<%=op%>";
$(document).ready(function() {
	resizeDialog(document);
	if(op!=''){
		if(op=="success"){
			parentWin.refreshTable();
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31439,user.getLanguage())%>") ;
		}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31825,user.getLanguage())%>") ;
		}
	}
}); 

function btn_cancle(){
	parentWin.closeDialog();
}
	

function doSubmit()
{
	if (onCheckForm()){
		document.forms[0].submit();
    }
}

function onCheckForm()
{
	if("<%=detachable%>"=="1"){
		if(!check_form(weaverA,'name,appId,appSecret,subcompanyid')){
			return false;
		}
	}else{
		if(!check_form(weaverA,'name,appId,appSecret')){
			return false;
		}
	}
	return true;
}

function preDo(){
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};
</script>

</html>
