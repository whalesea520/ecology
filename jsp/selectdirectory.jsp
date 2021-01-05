<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ page import="com.weaver.general.*,com.weaver.entity.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.License"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="ConfigInfo" class="com.weaver.function.ConfigInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%

if(ConfigInfo.getEcologypath() == null || "".equals(ConfigInfo.getEcologypath())) {
	String servletPath = request.getSession().getServletContext().getRealPath("/");
	ConfigInfo.setEcologypath(servletPath);
}
String errordir = Util.null2String((String)request.getAttribute("errordir"));
request.removeAttribute("errordir");
String titlename ="";
String emobilepath = "";//emobile地址
String emessagepath = "";//emessage地址
String upgradeBackup= Util.null2String(baseBean.getPropValue("ecologyupdate","upgradeBackup"));
String isconnect = Util.null2String(baseBean.getPropValue("ecologyupdate","isconnect"));
String issys = Util.null2String(baseBean.getPropValue("ecologyupdate","issysadmin"));
String customer = Util.null2String(new License().getCId());
String manager = Util.null2String(baseBean.getPropValue("ecologyupdate","manager"));
String remindtype =  Util.null2String(baseBean.getPropValue("ecologyupdate","remindtype"));
String beginTime = Util.null2String(baseBean.getPropValue("ecologyupdate","beginTime"));
emobilepath = Util.null2String(baseBean.getPropValue("ecologyupdate","emobilepath"));
emessagepath = Util.null2String(baseBean.getPropValue("ecologyupdate","emessagepath"));
String clusters = Util.null2String(baseBean.getPropValue("ecologyupdate","clusters"));
String isclusters = Util.null2String(baseBean.getPropValue("ecologyupdate","isclusters"));//集群设置
String isemobile = Util.null2String(baseBean.getPropValue("ecologyupdate","isemobile"));
String isemessage = Util.null2String(baseBean.getPropValue("ecologyupdate","isemessage"));

String versionecology = "";
RecordSet.executeSql("select companyname,cversion from license");
if (RecordSet.next())
{
	//customer=RecordSet.getString("companyname");
	versionecology=RecordSet.getString("cversion");
}

String backuptime = "";
String backuppath = "";

String backupPath = GCONSTUClient.getSysFileBackPath();
File f = new File(backupPath);
if(f.exists()) {
	File[] files = f.listFiles();
	//根据文件修改时间进行比较的内部类
	Arrays.sort(files,new Comparator<File>() {  
        public int compare(File f1, File f2) {  
            long diff = f1.lastModified() - f2.lastModified();  
            if (diff > 0) {  
                   return 1;  
            } else if (diff == 0) {  
                   return 0;  
            } else {  
                  return -1;  
            }  
        }  
    });
	
	if(files.length>0) {
		File backfile =  files[files.length-1];
		backuppath = backfile.getPath();
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(backfile.lastModified());
		SimpleDateFormat formatter; 
	    formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss"); 
	    backuptime = formatter.format(c.getTime()); 
		
	}
}

 %>
<html>
 <head>
	<title> E-cology升级程序</title>
	<script type="text/javascript" src="/js/jquery_wev8.js"></script>
	<link rel="stylesheet" href="/css/main_wev8.css" type="text/css">
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript" src="/js/updateclient/selectdirectory.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
<script type="text/javascript">
jQuery(document).ready(function(){
	 jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   jQuery(this).tzCheckbox({labels:['','']});
	  }
	 });

	 changesys($("#issysadmin"));
	 changeConnect($("#isconnect"));
	 changeclusters($("#isclusters"));
	 changeEmobile($("#isemobile"));
	 changeEmessage($("#isemessage"));

		//var remindtype1 = "<%=remindtype%>";
		//if(remindtype1.indexOf("0")>-1) {
		//	$("input[name='remindtype'][value='0']").attr("checked",'true');
		//} else if(remindtype1.indexOf("1")>-1) {
		//	$("input[name='remindtype'][value='1']").attr("checked",'true');
		//} else if(remindtype1.indexOf("2")>-1) {
		//	$("input[name='remindtype'][value='1']]").attr("checked",'true');
		//}
	});
function changecustomer(obj) {
	 var cus = obj.value;
	 if(cus=="") {
	 	$("#cusmessage").show();
	 } else {
	 	$("#cusmessage").hide();
	 }
}
function changesys(obj){
	 var v  = $(obj).val();
	 if("0" == v) {
		 $(obj).parent().next("div").hide();
	 } else {
		 $(obj).parent().next("div").show();
	 }
}
function changeConnect(obj){
	var ischeck = $(obj).attr("checked");
	if(ischeck) {
		$("td[_samePair='remindset']").parent("tr").css("display","");
		$("td[_samePair='remindset']").parent("tr").prev().css("display","");
		//showGroup("remindset");
	} else {
		$("td[_samePair='remindset']").parent("tr").css("display","none");
		$("td[_samePair='remindset']").parent("tr").prev().css("display","none");
		//hideGroup("remindset");
	}
}
function changeclusters(obj) {
	var ischeck = $(obj).attr("checked");
	if(ischeck) {
		$("td[_samePair='clustersset']").parent("tr").css("display","");
		$("td[_samePair='clustersset']").parent("tr").prev().css("display","");
		//showGroup("remindset");
	} else {
		$("td[_samePair='clustersset']").parent("tr").css("display","none");
		$("td[_samePair='clustersset']").parent("tr").prev().css("display","none");
		//hideGroup("remindset");
	}
}

function changeEmobile(obj) {
	var ischeck = $(obj).attr("checked");
	if(ischeck) {
		$("td[_samePair='emobileset']").parent("tr").css("display","");
		$("td[_samePair='emobileset']").parent("tr").prev().css("display","");
		//showGroup("remindset");
	} else {
		$("td[_samePair='emobileset']").parent("tr").css("display","none");
		$("td[_samePair='emobileset']").parent("tr").prev().css("display","none");
		//hideGroup("remindset");
	}
}

function changeEmessage(obj) {
	var ischeck = $(obj).attr("checked");
	if(ischeck) {
		$("td[_samePair='emessageset']").parent("tr").css("display","");
		$("td[_samePair='emessagesset']").parent("tr").prev().css("display","");
		//showGroup("remindset");
	} else {
		$("td[_samePair='emessageset']").parent("tr").css("display","none");
		$("td[_samePair='emessageset']").parent("tr").prev().css("display","none");
		//hideGroup("remindset");
	}
}
</script>
 </head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="参数设置" />
</jsp:include>
<%
RCMenu += "{"+"保存"+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body style="height:100%;width:100%;">

<form>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="dosave()"/>
		</td>
	</tr>
</table>

<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>

<wea:layout>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage()) %>">
	  <wea:item><%=SystemEnv.getHtmlLabelName(16803 ,user.getLanguage()) %></wea:item>
	  <wea:item><input name="customer" id="customer" disabled="disabled" value="<%=customer %>" onchange="changecustomer(this);"></input><span id="cusmessage" <%if(!"".equals(customer)){ %>style="display:none"<%} %>>请联系泛微工作人员，或者客户编号</span></wea:item>
	  <wea:item>ecology<%=SystemEnv.getHtmlLabelName(567 ,user.getLanguage()) %></wea:item>
	  <wea:item><%=versionecology %></wea:item>
	  <wea:item>ecology<%=SystemEnv.getHtmlLabelName(81 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18499 ,user.getLanguage()) %></wea:item>
	  <wea:item>
	  		    <input class=InputStyle   id="ecologyPath" name="ecologyPath" value="<%=ConfigInfo.getEcologypath() %>" disabled="disabled"/>
		        <span id="divecologyPath" style="color:red"></span>
	  </wea:item>
	  <wea:item>resin<%=SystemEnv.getHtmlLabelName(567 ,user.getLanguage()) %></wea:item>
	  <wea:item><%=ConfigInfo.getResinVersion() %></wea:item>
	  <wea:item>resin<%=SystemEnv.getHtmlLabelName(81 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18499 ,user.getLanguage()) %></wea:item>
	  <wea:item>
   	    	<input class=InputStyle    id="resinPath" value="<%=ConfigInfo.getResinpath() %>" disabled="disabled"/>
	    	<span id="divResinPath" style="color:red"></span>
	  </wea:item>

	  
	</wea:group>
	<wea:group context="EMobile设置">
		 <wea:item>已部署EMobile</wea:item>
		 <wea:item>
		 <input class="inputstyle" type=checkbox tzCheckbox='true' id="isemobile" onclick="changeEmobile(this)" name="isemobile" value="1" <%if(isemobile.equals("1"))out.println("checked"); %>>
		 </wea:item>
		<wea:item attributes="{\"samePair\":\"emobileset\"}">EMobile安装路径</wea:item>
		<wea:item attributes="{\"samePair\":\"emobileset\"}">
			<input class=InputStyle id="emobilepath" value="<%=emobilepath %>"/>
		    <span id="emobilepathspan" style="color:red"></span>
		</wea:item>
	</wea:group>
	<wea:group context="EMessage设置">
		 <wea:item>已部署EMessage</wea:item>
		 <wea:item>
		 <input class="inputstyle" type=checkbox tzCheckbox='true' id="isemessage" onclick="changeEmessage(this)" name="isemessage" value="1" <%if(isemessage.equals("1"))out.println("checked"); %>>
		 </wea:item>
		<wea:item attributes="{\"samePair\":\"emessageset\"}">EMessage安装路径</wea:item>
		<wea:item attributes="{\"samePair\":\"emessageset\"}">
			<input class=InputStyle id="emessagepath" value="<%=emessagepath %>"/>
		    <span id="emessagepathspan" style="color:red"></span>
		</wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(21946 ,user.getLanguage()) %>">
		 <wea:item>定时扫描（定时获取系统可升级的升级包）</wea:item>
		 <wea:item>
		 <input class="inputstyle" type=checkbox tzCheckbox='true' id="isconnect" onclick="changeConnect(this)" name="isconnect" value="1" <%if(isconnect.equals("1"))out.println("checked"); %>>
		 <input name="beginTime" type="hidden" value="<%=beginTime %>"></input>
		 </wea:item>
		<wea:item attributes="{\"samePair\":\"remindset\"}">被提醒人（提醒可升级的升级包信息以及下载地址）</wea:item>
		<wea:item attributes="{\"samePair\":\"remindset\"}">
			<span style="display:inline-block; float:left">
			<select id="issysadmin" name="issysadmin" onchange="changesys(this)">
			<option value="0" <% if(!"1".equals(issys)){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(16139 ,user.getLanguage()) %></option>
			<option value="1" <% if("1".equals(issys)){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(2168 ,user.getLanguage()) %></option>
			</select>
			
			</span>&nbsp;&nbsp;&nbsp;
			
		    <brow:browser viewType="0"  id="manager" name="manager" browserValue="<%=manager %>" 
		    browserOnClick=""
		    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
		    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
		    completeUrl="/data.jsp" width="165px"
		    browserSpanValue="<%=Util.toScreen(ResourceComInfo.getResourcename(manager),user.getLanguage())%>"></brow:browser>
		  
   
		</wea:item>
		<wea:item attributes="{\"samePair\":\"remindset\"}"><%=SystemEnv.getHtmlLabelName(18713 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{\"samePair\":\"remindset\"}">
		<input type="checkbox" name="remindtype" <% if(remindtype.indexOf("0")>-1){%>checked <%}%> value="0"><%=SystemEnv.getHtmlLabelName(23042 ,user.getLanguage()) %></input> 
		<input type="checkbox" name="remindtype" <% if(remindtype.indexOf("1")>-1){%>checked <%}%> value="1"><%=SystemEnv.getHtmlLabelName(17586 ,user.getLanguage()) %></input> 
		<input type="checkbox" name="remindtype" <% if(remindtype.indexOf("2")>-1){%>checked <%}%> value="2"><%=SystemEnv.getHtmlLabelName(18845 ,user.getLanguage()) %></input> 
		</wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(16483 ,user.getLanguage()) %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(15704 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18499 ,user.getLanguage()) %></wea:item>
	    <wea:item>
	  		    <input class=InputStyle id="upgradeBackup" value="<%=upgradeBackup %>"/>
		        <span id="divupgradeBackup" style="color:red"></span>
	    </wea:item>	
	</wea:group>
	<wea:group context="系统最新备份信息">
	<wea:item><%=SystemEnv.getHtmlLabelName(15704 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(83578 ,user.getLanguage()) %></wea:item>
	<wea:item><input class=InputStyle    id="resinPath" value="<%=backuppath %>" disabled="disabled"/></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15704 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(25130 ,user.getLanguage()) %></wea:item>
	<wea:item><input class=InputStyle    id="resinPath" value="<%=backuptime %>" disabled="disabled"/></wea:item>
	</wea:group>
	
</wea:layout>
</form>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>