
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />

<HTML><HEAD>
<%
String fieldname = Util.null2String(request.getParameter("fieldname"));
int sourceid = Util.getIntValue(Util.null2String(request.getParameter("sourceid")),0);
int sourcefrom = Util.getIntValue(Util.null2String(request.getParameter("sourcefrom")),0);
int hrefid = Util.getIntValue(Util.null2String(request.getParameter("hrefid")),0);
int hreftype = Util.getIntValue(Util.null2String(request.getParameter("hreftype")),0);
int supnode = Util.getIntValue(Util.null2String(request.getParameter("supnode")),0);
String tablename = Util.null2String(request.getParameter("tablename"));
String fielddesc = Util.null2String(request.getParameter("fielddesc"));
//from 1当前节点模块字段，2链接目标关联字段,3上级关联字段,4链接目标地址字段,5节点图标字段
int from = Util.getIntValue(Util.null2String(request.getParameter("from")),0);
String titleid = Util.null2String(request.getParameter("titleid"));
String titleName = "";
if(titleid.equals("1")){
	titleName = SystemEnv.getHtmlLabelNames("18214,21027",user.getLanguage()); //请选择主键
}else if(titleid.equals("2")){
	titleName = SystemEnv.getHtmlLabelNames("18214,596",user.getLanguage());  //请选择上级
}else if(titleid.equals("3")){
	titleName = SystemEnv.getHtmlLabelNames("18214,606",user.getLanguage());   //请选择显示名
}else if(titleid.equals("4")){
	titleName = SystemEnv.getHtmlLabelNames("18214,30178,83842",user.getLanguage()); //请选择链接目标地址
}else if(titleid.equals("5")){
	titleName = SystemEnv.getHtmlLabelNames("18214,81443",user.getLanguage());   //请选择节点
}else if(titleid.equals("6")) {
	titleName = SystemEnv.getHtmlLabelNames("18214,30219",user.getLanguage());  //请选择本节点字段
}else if(titleid.equals("7")){
	titleName = SystemEnv.getHtmlLabelNames("18214,30220",user.getLanguage());  //请选择上级节点字段
}else if(titleid.equals("8")){
	titleName = SystemEnv.getHtmlLabelNames("18214,30222",user.getLanguage()); //请选择链接目标关联字段
}else{
	titleName = SystemEnv.getHtmlLabelName(18214,user.getLanguage());  //请选择
}



String params = "fieldname="+fieldname+"&sourceid="+sourceid+"&sourcefrom="+sourcefrom+"&hrefid="+hrefid+"&hreftype="+hreftype+"&supnode="+supnode+"&tablename="+tablename+"&fielddesc="+fielddesc+"&from="+from;



%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

</HEAD>
<BODY>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />  
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
    <style type="text/css">
    	.tablenameCheckLoading{
    		background: url('/images/messageimages/loading_wev8.gif') no-repeat;
    		padding-left: 18px;
    	}
		.tablenameCheckSuccess{
			background: url('/images/BacoCheck_wev8.gif') no-repeat;
			padding-left: 18px;
			background-position: left 2px;
		}
		.tablenameCheckError{
			background: url('/images/BacoCross_wev8.gif') no-repeat;
			padding-left: 18px;
			color: red;
			background-position: left 2px;
		}
	</style> 
 <script type="text/javascript">

  	  	var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}

		$(function(){
		    $('.e8_box').Tabs({
		        getLine:1,
		        mouldID:"<%= MouldIDConst.getID("workflow")%>",
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        objName:"<%=titleName%>"
		   	});
		}); 
	</script>
	<div class="e8_box demo2">
		  <div class="e8_boxhead">
		         <div class="div_e8_xtree" id="div_e8_xtree"></div>
	             <div class="e8_tablogo" id="e8_tablogo"></div>
			     <div class="e8_ultab">
					  <div class="e8_navtab" id="e8_navtab">
						 <span id="objName"></span>
					  </div>
			     	  <div>
				         <ul class="tab_menu"></ul>
	    		         <div id="rightBox" class="e8_rightBox"></div>
	                  </div>
	              </div>
	       </div> 
		   <div class="tab_box">
		        <div>
		            <iframe src="ModeFieldBrowserIframe.jsp?<%=params %>" onload="if(typeof(update)=='function'){update()}" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		        </div>
		   </div>
	</div> 
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0!important;">
		<div style="padding: 5px 0;">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
				</wea:item>
			</wea:group>
		</wea:layout>
		</div>
	</div>
</body>
</html>
<SCRIPT language="javascript">
jQuery(document).ready(function(){

})
jQuery(document).ready(function(){
	jQuery(window).resize();
}) 
</script>
