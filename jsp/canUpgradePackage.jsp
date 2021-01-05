
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.weaver.update.GetPackageTimmer"%>
<%@ include file="/jsp/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%> 
<%@ page import="java.net.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.system.License"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.ldap.LdapUtil"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<HTML><head>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script>
function changeDate(obje,e){
    var typevalue=obje.value;
	if(obje.value==6){
	$("#"+e).css("display","");  
	}else{
	$("#"+e).css("display", "none"); 
	}
}
function changetab(val) {
	if(val=="1") {
		window.parent.document.getElementById("tabcontentframe").src="upgradeHistory.jsp";
	} else if(val=="2"){
		window.parent.document.getElementById("tabcontentframe").src="canUpgradePackage.jsp";
	}
}

</script>
</head>
<BODY>


<% 
String isconnect = Util.null2String(baseBean.getPropValue("ecologyupdate","isconnect"));
if(!"1".equals(isconnect)) {
	response.sendRedirect("/jsp/message.jsp");
}
String customer = Util.null2String(new License().getCId());
String url  = Util.null2String(baseBean.getPropValue("ecologyurl","url"));
url = url + "/weaver/weaver.upgrade.PackageDownload";

URL connecturl;  
try {  
	connecturl = new URL(url);  
    InputStream in = connecturl.openStream();  
    GetPackageTimmer timer = new GetPackageTimmer();
    timer.getPackcageInfo();
} catch (Exception e1) {
	connecturl = null;  
	response.sendRedirect("/jsp/message.jsp?errortype=1");
     
}  
if("".equals(customer)) {
	response.sendRedirect("/jsp/message.jsp?errortype=2");
	return;
}


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17530,user.getLanguage());
String needfav ="1";
String needhelp ="";



%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
rs.execute("update ecologypackageinfo  set status='1' where label in(select t1.label from ecologyuplist t1 ) and status='0'");


int lan = user.getLanguage();
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);

String content = Util.null2String(request.getParameter("content"));
rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(rs.next()){
	perpage =Util.getIntValue(rs.getString(36),-1);
}
if(perpage<=1 )	perpage=10;

String backfields = " * ";
String fromSql  = " from ecologypackageinfo t1 ";
String sqlWhere = " where t1.label is not null and status='0'";

String PageConstId = "upgradeList"; 
String tableString = "<table instanceid=\"designateTable\"   tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >"+
"	   <sql backfields=\"*\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\"label desc\"   sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
"			<head>";
tableString += 
    "	<col width=\"20%\"   text=\""+"补丁包名称"+"\" column=\"name\"  otherpara=\"column:id+column:type+column:downloadid\" transmethod=\"com.weaver.update.PackageUtil.getHref\"/>"+
	//"	<col width=\"20%\"   text=\""+"升级包类型"+"\" column=\"type\" transmethod=\"com.weaver.update.PackageUtil.changetype\" />"+
	"	<col width=\"5%\"   text=\""+"补丁包日期"+"\" column=\"lastDate\"  />"+
	"	<col width=\"20%\"   text=\""+"概述"+"\" column=\"description\"  />"+
	"	<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelNames("22045",user.getLanguage())+"\" column=\"id\"  transmethod=\"com.weaver.update.PackageUtil.getDetail\" />";
	
tableString +="</head>";
tableString+= "<operates>"+
		"<operate href=\"javascript:onDow();\" otherpara=\"column:type+column:downloadid\"  text=\""+SystemEnv.getHtmlLabelNames("258",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
		"<operate href=\"javascript:oShow();\" text=\""+SystemEnv.getHtmlLabelNames("22045",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
		"</operates>";
tableString +="</table>";
String sql = "select * from ecologypackageinfo t1 "+sqlWhere+" order by id";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form>
<TABLE width="100%" id="datatable">
 <tr>
     <td valign="top">  
     	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
        	<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
</TABLE>	
</form>
<!-- http://localhost:8089/weaver/weaver.upgrade.PackageDownload?packagetype=0&downloadid=1695541 -->
<form name="form2" action="<%=url %>" type="post"  onsubmit="CheckForm(this)">
<input type="hidden" name="id" id="idval"></input>
<input type="hidden" name="downloadid" id="downloadid"></input>
<input type="hidden" name="packagetype" id="packagetype"></input>
</form>
</BODY></HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script>
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

function clicksearch() {

	$("#content1").val("");
}
function resetCondtion()
{
	$("#upgradeHistory input[type=text]").val('');
	$("input[name='operatedatefrom']").val("");
	$("input[name='operatedateto']").val("");
	$("#operatedatefromspan").html("");
	$("#operatedatetospan").html("");
	try {
		$('#operatedateselect').selectbox("reset");
	} catch(e){
		$("select[name='operatedateselect']").val("0");
		$("select[name='operatedateselect']").text("<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>");
		$('#operatedateselect').trigger("change");
	}

	
}
function doRefresh()
{
	$("#upgradeHistory").submit(); 
}

function delLine(id){//弹出框调用，用于删除已经合并的行
	//$("#datatable input[id='checkboxId="+id+"']").closest("tr").remove();
}
var flage;
function openMessage(id,flage) {
	doOpen("/jsp/detail2.jsp?id="+id,"<%=SystemEnv.getHtmlLabelName(22045,user.getLanguage())%>");
	
}

var dWidth = 600;
var dHeight = 500;
function doOpen(url,title){
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  dWidth || 500;
	dialog.Height =  dWidth || 300;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}

function exportExcel() {
	document.getElementById("excels").src = "/jsp/upgradeHistoryExcel.jsp?sql=<%=xssUtil.put(sql)%>";
}

function onDow(id,para){
	$("#idval").val(id);
	//alert(para);
	var arr = para.split("+");
	if(arr[1] == "" ||arr[1]==undefined||arr[1] == "0") {
		top.Dialog.alert("没有附件，不能下载");
		return;
	}
	if(arr.length == 2) {
		$("#packagetype").val(arr[0]);
		$("#downloadid").val(arr[1]);
	}
	//getUrl();
	form2.submit();
}

function oShow(id) {
	openMessage(id,"detail");
}
function getUrl() {
	var url1 = "http://localhost:8089/weaver/weaver.upgrade.PackageDownload";
	$.ajax({
		url:url1,
		async:false,
	    error: function(XMLHttpRequest, textStatus, errorThrown){
	    	top.Dialog.alert("下载失败");
	    	return false;
	    },
	    dataType:"jsonp",
	    type:'get',
		success:function() {
			alert("121");
			form2.submit();
		}
	});
}



</script>
