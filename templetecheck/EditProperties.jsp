<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.templetecheck.*" %>
<HTML>
<HEAD>
</HEAD>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.getParentWindow(window);
dialog = parent.parent.getDialog(window);
}catch(e){}
 
</script>
<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	  return;
	}
	FileUtil fileUtil = new FileUtil();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = "";
	String needfav = "1";
	String needhelp = "";
	String menuTitle = "";

	
	String path = Util.null2String(request.getParameter("fpath"));//文件路径
	String from = Util.null2String(request.getParameter("from"));//判断是否来自新建页面
	String navename = "编辑Properties文件";
	if("add".equals(from)) {
		navename = "新建Properties文件";
	}


	File file = new File(fileUtil.getPath(path));
	boolean filexists = true;
	if(!file.exists()&&!"".equals(path)) {
		filexists = false;
	}
	
	//读取配置文件，过滤部分不能编辑的文件
	String exclude = "";
	boolean excludestatus = true;
	try {
		Properties pro = new Properties();
		FileInputStream in = new FileInputStream(fileUtil.getPath(GCONST.getRootPath()+"templetecheck"+File.separatorChar+"exclude"+File.separatorChar+"exclude.properties"));
		pro.load(in);
		exclude = pro.getProperty("exclude");
		in.close();
	} catch(Exception e) {
		filexists = false;
		e.printStackTrace();
	}
	String[] excludeArr = exclude.split(",");
	for(int i = 0; i < excludeArr.length;i++) {
		String excludepath = excludeArr[i];
		excludepath  = excludepath.replaceAll("\\\\","/");//替换一个分隔符  防止windows和linux的环境不一样，存在差异
		String temppath = path.replaceAll("\\\\","/");//替换一个分隔符  防止windows和linux的环境不一样，存在差异
		
		if(temppath.indexOf(excludepath)>=0) {
			excludestatus = false;
			break;
		}
	}
	
	
	String tpath  = path.replaceAll("\\\\","/");
	String fpath  = tpath.replaceAll(":","#");//路径分隔符“:”在传参的时候被过滤了，所以需要替换一下
	String backFields = "";

	String PageConstId = "proplist";
	String sourceparams = "fpath:"+fpath+"+excludestatus:"+excludestatus;
	String tableStringrule="";

	tableStringrule=""+
	       "<table instanceid=\"RULE_LIST\" pageId=\""+"proplist"+"\" "+
	      		" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" tabletype=\"checkbox\" datasource=\"weaver.templetecheck.PropertiesUtil.getPropList\" sourceparams=\""+sourceparams+"\">"+
	      	"<sql backfields=\"*\" sqlform=\"tmpTable\" sqlsortway=\"asc\"  sqlprimarykey=\"attrname\"/>"+
	       "<head>"+
	      			
	             "<col width=\"10%\"  text=\""+"属性名"+"\" column=\"attrname\" orderkey=\"attrname\" />"+
				 "<col width=\"10%\"  text=\""+"属性值"+"\" column=\"attrvalue\" orderkey=\"attrvalue\" />"+
	             "<col width=\"20%\"  text=\""+"说明(注释)"+"\" column=\"attrnotes\" orderkey=\"attrnotes\" />"+
	       "</head>"+
			"		<operates>"+
			"			<operate href=\"javascript:edit();\" text=\"编辑\" index=\"1\"/>"+
			"			<operate href=\"javascript:dodelete();\" text=\"删除\" index=\"2\"/>"+
	       "</operates></table>";

%>


<BODY style="overflow:hidden;">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{新建属性,javascript:add(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{批量删除,javascript:batchdelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="<%=navename %>" />
	</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="advancedSearch" class="advancedSearch" style='display:none;'>高级搜索</span>&nbsp;&nbsp;
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
	</table>
	<div id="tabDiv" >
	   <span style="font-size:14px;font-weight:bold;"></span> 
	</div>
	<div class="cornerMenuDiv"></div>
	<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'></div>

	<form name="frmAdd" method="post">
	<input name="from" value="<%=from%>" type="hidden"></input>
	<wea:layout>
		<wea:group context="文件路径">
		<wea:item>文件路径<span style="color:red">（编辑前请先备份文件）</span></wea:item>
		<wea:item>
		<wea:required id="pathimage" required="true" value="<%=tpath %>">
			<input class="Inputstyle" type="text" name="path" id="path" onchange='checkinput("path","pathimage")' value="<%=path%>"></input>
		</wea:required>
		 &nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" style="width:100%;max-width:120px!important;" class="e8_btn_top" value="显示文件内容" onclick="showcontent()"/>
		<input type="button" style="width:100%;max-width:120px!important;" class="e8_btn_top" value="新建属性" onclick="add()"/>
		</wea:item>
		</wea:group>
	<wea:group context="Properties属性列表">
	<wea:item attributes="{colspan:'full',id:'tableitem'}">
	<TABLE width="100%">
	    <tr>
	        <td valign="top">  
	        	<input type="hidden" name="pageId" id="pageId" value="proplist"/>
	           	<wea:SplitPageTag  tableString="<%=tableStringrule %>" isShowTopInfo="true" mode="run" />
	        </td>
	    </tr>
	</TABLE>
	</wea:item>
	</wea:group>
	</wea:layout>
	</form>
</div>
</BODY>
</HTML>


<script type="text/javascript">

	$(document).ready(function(){
		jQuery('#menu_content').perfectScrollbar();
		jQuery("#topTitle").topMenuTitle();	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		$("#tableitem").removeClass("fieldName");
		var filexists = "<%=filexists%>";
		if("false" == filexists) {
			top.Dialog.alert("文件不存在");
			return;
		}
		var excludestatus = "<%=excludestatus%>";
		if("false" == excludestatus) {
			top.Dialog.alert("该文件无编辑权限，请手动编辑");
			return;
		}
	});
	
	function btncancel_onclick() {
		if(dialog){
			dialog.closeByHand();
		}else{
			parentWin.closeDialog();
		}  
	}
	//删除属性
	function dodelete(attrname) {
		try {
			top.Dialog.confirm("确定删除？",function(){
				var path = $("#path").val();
				$.ajax({
					url : "EditPropertiesOperation.jsp",
					data :  {
						filepath : $("#path").val(),
						attrname : attrname,
						operate : "2",//删除
					},
					dateType : "json",
					success : function(res){
						var data = eval("("+res+")");
						if(data.status=="ok") {
							window.location.href="EditProperties.jsp?fpath="+path;
						} else { 
							return;
						}
					}
				});
			});
		} catch(e) {
			
		}
	}
	//编辑属性
	function edit(attrname) {
		var path = $("#path").val();
		showDialog("编辑属性","/templetecheck/EditAttrNode.jsp?operate=1&attrname="+attrname+"&fpath="+path,"800px","700px","500px");
		return;
	}
	
	//显示属性列表
	function showcontent() {
		var path = $("#path").val();
		if(""==path) {
			top.Dialog.alert("请输入文件路径");
			return;
		} else {
			if(path.indexOf(".properties") <= 0) {
				top.Dialog.alert("非Properties文件");
				return;
			}
			window.location.href="EditProperties.jsp?fpath="+path;
		}
	}
	//添加属性
	function add() {
		var path = $("#path").val();
		if(""==path) {
			top.Dialog.alert("请输入文件路径");
			return;
		} else {
			showDialog("新增属性","/templetecheck/EditAttrNode.jsp?operate=0"+"&fpath="+path,"800px","700px","500px");
			return;
		}
	}
	
	//批量删除属性
	function batchdelete() {
		var path = $("#path").val();
		if(""==path) {
			top.Dialog.alert("请输入文件路径");
			return;
		}
		var checkes = _xtable_CheckedCheckboxId();
		if(""==checkes) {
			top.Dialog.alert("请选择要删除的属性");
			return;
		}
		dodelete(checkes);
	}

</script>

<script type="text/javascript">
	
	function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = 600;
	 	Show_dialog.Height = 550;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	try {
	 		Show_dialog.show();
	 	} catch(e) {
	 	}
	 	
	}
 
 function onCancel(){
	if(dialog){
			dialog.close();
		}else{
	  	    window.parent.close();
	}  
}
function btncancel_onclick() {
		if(dialog){
			dialog.close();
		}else{
	  	    window.parent.close();
		}  
}
//屏蔽回车事件
$(document).keydown(function(event){
	  switch(event.keyCode){
	     case 13:return false; 
	     }
});
</script>