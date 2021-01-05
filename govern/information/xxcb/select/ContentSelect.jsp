<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<%
String dataids = Util.null2String(request.getParameter("dataids"));
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
		        mouldID:"<%= MouldIDConst.getID("formmode")%>",
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        objName:"筛选"
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
		            <iframe src="ContentSelectIframe.jsp?dataids=<%=dataids %>" onload="if(typeof(update)=='function'){update()}" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		        </div>
		   </div>
	</div> 
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0!important;">
		<div style="padding: 5px 0;">
		
		<table width="100%" id="BrowseTable" >
			<COLGROUP>
			<col width="15%">
			<col width="35%">
    	<col width="15%">
    	<col width="35%">
    	</COLGROUP>

<%
String htmlStr = "<select id='kxSelect' onchange='kxChange(this.options[this.options.selectedIndex].value);'><option value=''></option>";

RecordSet.executeSql("select * from uf_xxcb_kxSet where state=0 order by px asc");
while(RecordSet.next()){

	htmlStr += "<option value='"+RecordSet.getString("id")+"'>"+RecordSet.getString("name")+"</option>";
	
}
htmlStr += "</select>";
%>

			<TR class=DataLight>
			 <TD style="word-break:break-all"><b>选择刊型:</b></TD>
			 <TD style="word-break:break-all" id="kx"><%=htmlStr %></TD>
			 <TD style="word-break:break-all"><b>子栏目:</b></TD>
			 <TD style="word-break:break-all" id="lm"></TD>
	    </TR>
  	</table>	

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

//刊型变更 获取栏目
function kxChange(kxid){
  
	//获取栏目信息
	var url = "/govern/information/xxcb/getLanmuInfo2.jsp?kxid="+kxid;
	//alert(url);
	jQuery.ajax({
		type:'get',
		url:url,
		dataType : "json",
		async:false,
		success:function do4Success (obj){ 
			jQuery("#lm").html(obj.htmlStr);

		}, 
			error:function (){ 
			top.Dialog.alert("Error");
			} 
	});
}
</script>
