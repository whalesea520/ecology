<!DOCTYPE html>
<html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.templetecheck.ConfigUtil" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<title>e-cology文件检测与维护工具</title>
	<link rel="stylesheet" href="/templetecheck/css/bootstrap.css">

	<script src="/templetecheck/js/jquery-1.10.2.js"></script>
	<script src="/templetecheck/js/bootstrap.js"></script>
	<%@ include file="main_init.jsp" %>
<%

String checklist = "";
int i=0;
ConfigUtil configUtil = new ConfigUtil();
LinkedHashMap<String,ArrayList<String>>  tabs = configUtil.getalltabs();
Iterator ite = tabs.entrySet().iterator();
String tishtml = "0";
String tabname = "";
checklist = checklist + "<li><span class='title'>检测流程模板</span></li>";
while(ite.hasNext()) {
	Map.Entry entry = (Entry)ite.next();
	String key  = (String)entry.getKey();
	ArrayList<String> value  = (ArrayList<String>)entry.getValue();
	String name = value.get(0);
	String ishtml  = value.get(1);
	if("0".equals(ishtml)) {
		tabname = "检测表单流程模板";
	} else if("1".equals(ishtml)) {
		//检查配置项的内容  从文件检测中移除
		tabname = "检测配置文件";
		continue;
	} else if("2".equals(ishtml)) {
		tabname = "检测web.xml";
	} else if("3".equals(ishtml)) {
		tabname ="其他";
	} else if("4".equals(ishtml)) {
		tabname = "检测移动引擎模板";
	} else if("5".equals(ishtml)) {
		tabname = "检测表单建模模板";
	} else if("6".equals(ishtml)) {
		tabname = "流程自定义页面查询";
	}
	
	if(tishtml.equals(ishtml)) {
		checklist = checklist + "<li><a href=\\\"javascript:checkfile('"+key+"','"+ishtml+"','"+name+"')\\\">"+name+"</a></li>";
	} else {
		checklist = checklist + "<li><span class='title'>"+tabname+":</span></li>"; 
		checklist = checklist + "<li><a href=\\\"javascript:checkfile('"+key+"','"+ishtml+"','"+name+"')\\\">"+name+"</a></li>";
	}
	tishtml = ishtml;
}
String showXmlMenu = Util.null2String(Prop.getPropValue("templeteCheckMenu", "showXmlMenu"));
String showPropertiesMenu = Util.null2String(Prop.getPropValue("templeteCheckMenu", "showPropertiesMenu"));
//添加check页面设置
checklist = checklist +"<li><span class='title'>检测项设置:</span></li>";
checklist= checklist+"<li><a href='javascript:checkconfig()'>文件检测项设置</a></li>";
%>
<script type="text/javascript">
	$(document).ready(function(){
		$("li[role='presentation']").bind("click",function(){
			$("li[role='presentation']").removeClass("active");
			$(this).addClass("active");
			$(".dropdown-menu").width($(this).css("width"));
		});
		
		$("#checklist").html("<%=checklist%>");
		$(".dropdown-menu").bind("mouseout",function(){
			//alert(0);
			var s = event.toElement || event.relatedTarget;
			if(!this.contains(s)) { $(this).parent().removeClass("open"); }
			
		});
	});
	//维护xml
	function editxml(type) {
		if(type=='1') {
			$("#iframe1").attr("src","/templetecheck/AddXml.jsp");
		} else {
			$("#iframe1").attr("src","/templetecheck/EditXml.jsp");
		}
	}
	
	//维护properties
	function editproperties(type) {
		if(type=='1') {
			$("#iframe1").attr("src","/templetecheck/AddProperties.jsp");
		} else {
			$("#iframe1").attr("src","/templetecheck/EditProperties.jsp");
		}
	}
	
	
	//配置文件信息维护
	function configmanager() {
		$("#iframe1").attr("src", "/templetecheck/ConfigManagerIframe.jsp");
	}

	//文件检测
	function checkfile(key, ishtml, navName) {
		var tmphref = "";
		//if("3"==ishtml) {//0--流程模板 1--KB包xml配置文件 2--web.xml 3.其他 4.Properties文件  5.xml文件
		//	tmphref = "matchrule.jsp";
		//} else  if("0"==ishtml) {
		//	tmphref = "matchruleHtml.jsp";
		//}  else {
		//	tmphref = "matchruleConfig.jsp";
		//}
		tmphref = "checkruleiframe.jsp" + "?tabtype=" + key + "&ishtml=" + ishtml + "&navName=" + navName;
		$("#iframe1").attr("src", tmphref);
	}

	function checkconfig() {
		$("#iframe1").attr("src", "/templetecheck/tabconfig.jsp");
	}
</script>
</head>

<body style="width:100%;margin:0px auto;height:100%;">
<div id="tabdiv" style="width:100%;height:93%;">

  <!-- Nav tabs -->
  <div  style="background-color:#87CEFA;height:60px;">
  <ul class="nav nav-pills tabclass1" role="tablist">
  	<li role="presentation" style="width:400px;text-align:center;"><span style="line-height:60px;"><img src="image/title.png"></img>&nbsp;&nbsp;e-cology文件检测与维护</span></li>
    <li role="presentation" class="active">
	    <a class="dropdown-toggle" data-toggle="dropdown"role="button" aria-haspopup="true" aria-expanded="false">文件检测<span class="caret"></span></a>
	    <ul class="dropdown-menu" id="checklist" name="checklist">
	    </ul>
    </li>
    <%if(showXmlMenu.equals("1")){ %>
    <li role="presentation">
      <a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">XML文件维护<span class="caret"></span></a>
      <ul class="dropdown-menu">
        <li><a href="javascript:editxml(1)">新建XML文件</a></li>
        <li><a href="javascript:editxml(2)">编辑XML文件</a></li>
      </ul>
    </li>
    <%}%>
    <%if(showPropertiesMenu.equals("1")){ %>
    <li role="presentation">
    <a class="dropdown-toggle"  aria-controls="messages" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Properties文件维护<span class="caret"></span></a>
    <ul class="dropdown-menu">
      <li><a href="javascript:editproperties(1)">新建Properties文件</a></li>
      <li><a href="javascript:editproperties(2)">编辑Properties文件</a></li>
    </ul>
    </li>
    <%}%>
    <li role="presentation">
    	<a class="dropdown-toggle" aria-controls="messages" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">指定配置文件维护<span class="caret"></span></a>
    	<ul class="dropdown-menu">
	      <li><a href="javascript:checkfile('checkwebxml','1','检测web.xml文件')">检测web.xml配置</a></li>
	      <li><a href="javascript:checkfile('checkaction','1','检测action.xml文件')">检测action.xml配置</a></li>
	      <li><a href="javascript:checkfile('checkservice','1','检测services.xml文件')">检测services.xml配置</a></li>
	    </ul>
    </li>
      <li role="presentation">
    	<a id="configmanager" href="javascript:configmanager()" class="dropdown-toggle" aria-controls="messages" role="button" aria-haspopup="true" aria-expanded="false">配置文件信息维护</a>
    </li>
    
    <%--
    <li role="presentation" class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="settings" role="button" aria-haspopup="true" aria-expanded="false">Settings <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Separated link</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">One more separated link</a></li>
          </ul>
    </li>

  --%>
  	</ul>
  </div>

  <!-- Tab panes -->
  <div class="tab-content">
    <div role="tabpanel" class="tab-pane active" id="home" style="height:100%"><iframe id="iframe1" name="iframe1" src="/templetecheck/description.jsp"></iframe></div>
  </div>

</div>
<style>
body{
font-size:20px;
height:100%;
scrolling:none;
overflow-y:hidden;
}
html {
height:100%;
}
.tab-content{
height:100%;
}
.tabclass1>li{
 width:225px;
}
.tabclass1>li>a{
 line-height:40px;
 text-align:center;
}
.dropdown-menu {
	background-color:#87CEFA;
}
.tab-pane>iframe {
	width:100%;
	height:100%;
}
.title {
	font-size:16px;
	color:#8B8B83
}

</style>
</body>
</html>