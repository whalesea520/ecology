
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String operate=Util.null2String(request.getParameter("operate"));

String platformid = Util.null2String(request.getParameter("platformid"));
String permissiontype = Util.null2String(request.getParameter("permissiontype"));
String typevalue = Util.null2String(request.getParameter("typevalue"));
String seclevel = Util.null2String(request.getParameter("seclevel"));
String seclevelMax = Util.null2String(request.getParameter("seclevelMax"));
String op="";
String and="+";
if("save".equals(operate)){
	 if("5".equals(permissiontype)){//所有人,不要值
	 	String datasql="insert into wechat_share (platformid,permissiontype,seclevel,seclevelMax) "+
			 	"values ('"+platformid+"','"+permissiontype+"','"+seclevel+"','"+seclevelMax+"')";
		if(rs.executeSql(datasql)){
			op="close";
		};
	 }else{
		 if(typevalue!=null&&!"".equals(typevalue)){
		 	String[] typevalues=typevalue.split(",");
		 	for(int i=0;i<typevalues.length;i++){
		 		if(typevalues[i]==null||"".equals(typevalues[i])) continue;
			 	String datasql="insert into wechat_share (platformid,permissiontype,typevalue,seclevel,seclevelMax) "+
			 	"values ('"+platformid+"','"+permissiontype+"','"+typevalues[i]+"','"+seclevel+"','"+seclevelMax+"')";
		 		rs.executeSql(datasql);
		 	}
			op="close";
		 }
	 }
	 SysMaintenanceLog.resetParameter();
	 SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(platformid),"新增共享",permissiontype+and+seclevel+and+seclevelMax+and+typevalue,"214","1",0,Util.getIpAddr(request));
		
}
seclevel="".equals(seclevel)?"10":seclevel;
seclevelMax="".equals(seclevelMax)?"100":seclevelMax;

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

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name=frmmain method=post action="platformShareAdd.jsp">
<input type="hidden" name="operate" value="save">
<input type="hidden" name="platformid" value="<%=platformid %>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(19910,user.getLanguage()) %>'>
		      <wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage()) %></wea:item>
		      <wea:item>
			      	<select name="permissiontype" id="permissiontype" onchange="changepermit()"> 
				  		<option value="1" <%="1".equals(permissiontype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></option>
				  		<option value="2" <%="1".equals(permissiontype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %></option>
				  		<option value="3" <%="1".equals(permissiontype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %></option>
				  		<option value="4" <%="1".equals(permissiontype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage()) %></option>
				  		<option value="5" <%="1".equals(permissiontype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage()) %></option>
				  	</select>
			</wea:item>
			<wea:item attributes="{'samePair':'typetr'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage()) %></wea:item>
			<wea:item attributes="{'samePair':'typetr'}">
			  		<div id="div1" name="showdiv" style="display:none">
			  		 <!-- 分部 -->	
			  	     <brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>' name="typevalue1" browserValue=""
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue=""></brow:browser>
					</div>
					<div id="div2" name="showdiv" style="display:none">
					<!-- 部门 -->
					<brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>' name="typevalue2" browserValue=""
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  
								completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
								browserSpanValue=""></brow:browser>
					</div>
					<div id="div3" name="showdiv" style="display:none">
					<!-- 人力资源 -->
				    <brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>' name="typevalue3" browserValue=""
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  
								completeUrl="/data.jsp" linkUrl="/hrm/resource/HrmResource.jsp?id=" 
								browserSpanValue=""></brow:browser>
					</div>
					<div id="div4" name="showdiv" style="display:none">
					<!-- 角色 -->
					<brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>' name="typevalue4" browserValue=""
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  
								completeUrl="/data.jsp?type=65" linkUrl="" 
								browserSpanValue=""></brow:browser>
			  		</div>
			  	<input type="hidden" id="typevalue" name="typevalue" value="<%=typevalue%>">
			  </wea:item>
			  
			  <wea:item attributes="{'samePair':'leveltr'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage()) %></wea:item> 
		      <wea:item attributes="{'samePair':'leveltr'}">
		       	 <input type="text" id="seclevel" name="seclevel" value="<%=seclevel%>" style="width:50px" onchange='checkcount1("seclevel")'>
			  	 <SPAN id=seclevelimage></SPAN>
			  	 -
			  	 <input type="text" id="seclevelMax" name="seclevelMax" value="<%=seclevelMax%>" style="width:50px" onchange='checkcount1("seclevelMax")'>
			  	 <SPAN id=seclevelMaximage></SPAN>
		      </wea:item>
	        </wea:group>
	        </wea:layout>
			<!-- 操作 -->
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout type="2col">
			     <wea:group context="">
			    	<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
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

var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=op%>"=="close"){
	parentWin.closeDlgARfsh();
}

$(document).ready(function() {
       	changepermit();
});

function doBack(){
    
}

function changepermit(){
	var permissiontype=$('#permissiontype').val();
	$('#typevalueSpan').html("");
	$('#typevalue').val("");
	showEle('leveltr');
	$("div[name='showdiv']").hide();
	hideEle('typetr');
	if(permissiontype!=5){//排除所有人,没有浏览框
		showEle('typetr');
		$("#div"+permissiontype).show();
		if(permissiontype==3){
			hideEle('leveltr');
		}
	}
}


function doSubmit()
{
    var permissiontype=$('#permissiontype').val();
 	if(permissiontype!=5){
 		$('#typevalue').val($('#typevalue'+permissiontype).val())
 		if($('#typevalue').val()==""){
 			jQuery("#typevalueSpan").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
 			window.top.Dialog.alert ("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>") ;
 			return false;
 		};
 	}	 
	document.forms[0].submit();
}
 
</script>

</html>
