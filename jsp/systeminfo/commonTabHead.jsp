
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
	User user = HrmUserVarify.getUser (request , response) ;
	String id = Util.null2String(request.getParameter("mouldID"));
	String mouldID = "";
	if(!id.equals("")){
		mouldID = MouldIDConst.getID(id);
	}
	String navName = Util.null2String(request.getParameter("navName"));
	boolean exceptHeight = Util.null2String(request.getParameter("exceptHeight")).equals("true");
	String _fromURL = Util.null2String(request.getParameter("_fromURL"));
	String isPersonalDoc = Util.null2String(request.getParameter("isPersonalDoc"));
	int docid =  Util.getIntValue(request.getParameter("docid"),-1);
	String docsubject = Util.null2String(request.getParameter("docsubject"));
	if(docid>0){
		DocManager.resetParameter();
		DocManager.setId(docid);
		DocManager.getDocInfoById();
		docsubject = DocManager.getDocsubject();
	}
	String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc"));
	String limitSec = Util.null2String(request.getParameter("limitSec"));
	String step = Util.null2String(request.getParameter("step"));
%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<style type="text/css">
	.magic-line{
		
		width:72px;
	}
</style>


<script type="text/javascript">
<%if("1".equals(limitSec)){ %>
 	 window.notExecute = true;
 <%}%>
jQuery(function(){
	try{
		//jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
	}catch(e){}
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:null,
        exceptHeight:<%=exceptHeight%>,
        objName:"<%=navName%>",
        mouldID:"<%= mouldID%>"
    });
    //$(".e8_rightBorder").html("&nbsp;〉");
    $(".e8_rightBorder").css("display","inline");
    //alert(typeof($(".tab_box > div")));
   
    var step = parseInt("<%=step%>");
    for(var i = 0; (step-1)>=0&& i < step;i++) {
    	  $(".reportBody").find(".signItem").eq(i+1).find(".discussitem").css("background","#FFEC8B");
    }
    var current  = step +1;
   
    $(".reportBody").find(".signItem").eq(current).find(".discussitem").css("background","#4F94CD");
 }); 
 
</script>
<div class="e8_box demo2">
	<div class="e8_boxhead" style="<%="1".equals(fromFlowDoc)?"display:none":"" %>">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
		<div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div><%--
			    <ul class="tab_menu" id="tabul">
					<li class="current">①选择升级包</li>
					<li>②备份数据库</li>
					<li>③备份文件</li>
					<li>④执行脚本</li>
					<li>⑤升级成功</li>
			    </ul>
		    	--%>
		    	<div class="wizard-steps" style="width:800px;margin-top:10px;">
			
				</div>
		    	<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box <%=_fromURL.equals("doc")?"_synergyBox":"" %>" style="overflow:auto;">
	   <div style="height:100%">