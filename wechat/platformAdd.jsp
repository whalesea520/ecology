
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
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
//判断是否有分权
String detachable=Util.null2String(session.getAttribute("wechatdetachable")!=null?session.getAttribute("wechatdetachable").toString():"0");
String dialog = Util.null2String(request.getParameter("dialog"));
String operate=Util.null2String(request.getParameter("operate"));

String name = Util.null2String(request.getParameter("name"));
String publicid = Util.null2String(request.getParameter("publicid"));
String appId = Util.null2String(request.getParameter("appId"));
String appSecret = Util.null2String(request.getParameter("appSecret"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
if("1".equals(detachable)){
	subcompanyid=subcompanyid!=null&&!"".equals(subcompanyid)?subcompanyid:user.getUserSubCompany1()+"";
	subcompanyid="0".equals(subcompanyid)?"":subcompanyid;
}
String id="";
String op="open";
String idmsg="";
String appidmsg="";
if("save".equals(operate)||"saveDetail".equals(operate)){
	rs.executeSql("select 1 from wechat_platform where publicid='"+publicid+"'");
	if(!rs.next()){
		rs.executeSql("select 1 from wechat_platform where appId='"+appId+"'");
		if(!rs.next()){
			if(name!=null&&!"".equals(name)&&publicid!=null&&!"".equals(publicid)&&appId!=null&&!"".equals(appId)&&appSecret!=null&&!"".equals(appSecret)){
				subcompanyid=subcompanyid!=null&&!"".equals(subcompanyid)?subcompanyid:"";
				String datasql="insert into wechat_platform (name,publicid,appid,appSecret,state,subcompanyid) values ('"+name+"','"+publicid+"','"+appId+"','"+appSecret+"',1,'"+subcompanyid+"')";
				if(rs.executeSql(datasql)){
					SysMaintenanceLog.resetParameter();
					SysMaintenanceLog.insSysLogInfo(user,0,publicid+"-"+name,"微信公众平台管理-新增公众平台","214","1",0,Util.getIpAddr(request));
					 if("save".equals(operate)){
					 	op="close";
					 }else if("saveDetail".equals(operate)){
					 	rs.execute("select id from wechat_platform where publicid='"+publicid+"'");
					 	if(rs.next()){
						 	op="detail";
					 		id=rs.getString("id");
					 	}
					 }
				};
			}
		}else{
			appidmsg="AppID"+SystemEnv.getHtmlLabelName(24943,user.getLanguage());//原始ID已存在
		}
	}else{
		idmsg=SystemEnv.getHtmlLabelName(613,user.getLanguage())+"ID"+SystemEnv.getHtmlLabelName(24943,user.getLanguage());//原始ID已存在
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:saveData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" class="e8_btn_top" onclick="saveData()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name=weaverA method=post action="platformAdd.jsp">
<input type="hidden" id="operate" name="operate" value="save">
<input type="hidden" value="<%=dialog%>" name="dialog" id="dialog" />
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<div class="zDialog_div_content" style="overflow:auto;">
				  <wea:layout type="2Col">
				     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}" >
					      <wea:item><%=SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					      <wea:item>
					         <input type="text" id="name" name="name" value="<%=name%>"  class="InputStyle" onchange='checkinput("name","nameimage")'>
					         <SPAN id="nameimage">
				              	<%if("".equals(name)){%>
				              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				              	<%
				              	} %>
			              	</SPAN>
					      </wea:item>
					      
					      <wea:item><%=SystemEnv.getHtmlLabelName(613,user.getLanguage())%>ID</wea:item>
					      <wea:item>
					      	<input type="text" id="publicid" name="publicid" value="<%=publicid%>"  class="InputStyle" onchange='checkinput("publicid","publicidimage")'>
			              	<SPAN id=publicidimage style="color:red">
			              	<%if(!"".equals(idmsg)){%>
			              		<%=idmsg%>
			              	<%}else{
			              		if("".equals(publicid)){
			              	%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
			              	<%
			              		}
			              	} %>
			              	</SPAN>
			              	<SPAN>
			              		<a href='/wechat/images/publicid_wev8.png' target='_blank' title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>'<%=SystemEnv.getHtmlLabelName(613,user.getLanguage())%>ID'<%=SystemEnv.getHtmlLabelName(275,user.getLanguage())%>"><IMG src="images/remind_wev8.png" align=absMiddle ></a>
			              	</SPAN>
					     </wea:item>
					      
					      <wea:item>AppID</wea:item>
					      <wea:item>
					        <input type="text" id="appId" name="appId" value="<%=appId%>"  class="InputStyle" onchange='checkinput("appId","appIdimage")'>
						  	<SPAN id=appIdimage style="color:red">
							<%if(!"".equals(appidmsg)){%>
			             		<%=appidmsg%>
			              	<%}else{
			              		if("".equals(appId)){
			              	%>
			              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle >
			              	<%
			              		}
			              	} %>
							</SPAN>
							<SPAN>
			              		<a href='/wechat/images/app_wev8.png' target='_blank'  title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>'AppID'<%=SystemEnv.getHtmlLabelName(275,user.getLanguage())%>"><IMG src="images/remind_wev8.png" align=absMiddle ></a>
			              	</SPAN>
					      </wea:item>
					      
					      <wea:item>AppSecret</wea:item>
					      <wea:item>
					       	  <input type="text" id="appSecret" name="appSecret" value="<%=appSecret%>"  class="InputStyle" onchange='checkinput("appSecret","appSecretimage")'>
				              <SPAN id=appSecretimage>
				              <%if("".equals(appSecret)){%>
				              	<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				              	<%
				              	} %>
				              </SPAN>
				              <SPAN>
				              		<a href='/wechat/images/app_wev8.png' target='_blank' title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>'AppSecret'<%=SystemEnv.getHtmlLabelName(275,user.getLanguage())%>"><IMG src="images/remind_wev8.png" align=absMiddle ></a>
				              </SPAN>
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
				<div id="zDialog_div_bottom" class="zDialog_div_bottom">
					<wea:layout type="2Col">
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
			</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>

</body>
<script language="javascript">

$(document).ready(function() {
	resizeDialog(document);
});

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}
 
function btn_cancle(){
	dialog.close();
}

if("<%=op%>"=="close"){
	parentWin.closeDlgARfsh();
}else if("<%=op%>"=="detail"){
	parentWin.closeDlgARfsh();
	parentWin.editPlat("<%=id%>");
}

function saveData(){
	if (onCheckForm()){
		$('#operate').val("saveDetail");
		document.forms[0].submit();
	}
}

function doSubmit()
{
	if (onCheckForm()){
		$('#operate').val("save");
		document.forms[0].submit();
    }
}

function onCheckForm()
{
	if("<%=detachable%>"=="1"){
		if(!check_form(weaverA,'name,publicid,appId,appSecret,subcompanyid')){
			return false;
		}
	}else{
		if(!check_form(weaverA,'name,publicid,appId,appSecret')){
			return false;
		}
	}
	return true;
}

 
</script>

</html>
