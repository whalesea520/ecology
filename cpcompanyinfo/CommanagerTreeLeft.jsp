<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelNames("22089,2212",user.getLanguage())%></title>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"type="text/css" />
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/cpcompanyinfo/style/dhtmlxtree_wev8.css" type="text/css">
<script type="text/javascript" src="/cpcompanyinfo/js/dhtmlxcommon_wev8.js"></script>
<script type="text/javascript" src="/cpcompanyinfo/js/dhtmlxtree_wev8.js"></script>
</head>
<body>
		<%
			if(!HrmUserVarify.checkUserRight("License:manager", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
			}
		%>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>

    <div style="width:230px;height:530px;float:left;"  id="left_H">
       <div class="FontYahei FS13" style="background:url('/cpcompanyinfo/images/bbg_wev8.jpg') repeat-x;padding-top:1px;padding-left:10px;">
           <img src="/cpcompanyinfo/images/O_11_wev8.png" style="margin-right:10px;"/><span style="color:#ffffff"><%=SystemEnv.getHtmlLabelName(30953,user.getLanguage())%></span>
       </div>
       <div id="item" style="width:223px;padding-left:5px;border:1px solid #cccccc;background:#f8f8f8;">
       </div>
    </div>  
    
 <script type="text/javascript">

		$(document).ready(function(){
		    $(document).bind("contextmenu",function(e){
		        return false;
		    });
		});


		function doOnClick(nodeId){
			var url = "/cpcompanyinfo/Comcheckright.jsp?comid="+nodeId;
			if(nodeId.split("_")[0]==0){
				 url = "/cpcompanyinfo/CommanagerTreeRight.jsp?comid="+nodeId;
			}
		    window.open(url,"frm_right_right");
		}
		var tree;
		tree=new dhtmlXTreeObject("item","100%","100%","-1");
		tree.setSkin('dhx_skyblue');
		tree.setImagePath("/cpcompanyinfo/images/");
		tree.setOnClickHandler(doOnClick);
		tree.setXMLAutoLoading("/cpcompanyinfo/Comtree.jsp");
		tree.loadXML("/cpcompanyinfo/Comtree.jsp");
		
		jQuery(document).ready(function(){
				setBottom();
		});
		function setBottom(){
			var docH=$(document).height(); 
			$("#left_H").height(docH);
			$("#item").height(docH-30);
			
			//alert(docH+"--"+docHF);
			//left_H
			
		}
</script>
</body>
</html>