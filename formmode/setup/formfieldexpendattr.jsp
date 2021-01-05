<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/formmode/pub.jsp"%>
<%
	String fieldid = request.getParameter("fieldid");
	String formid = request.getParameter("formid");
	String fieldtype = request.getParameter("fieldtype");
	String expendattr = "";
	rs.executeSql("select expendattr from ModeFormFieldExtend where fieldid="+fieldid+" and formid="+formid);
	if(rs.next()){
		expendattr = rs.getString(1);
	}
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
  </head>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:saveExpendattr(),_self} " ;//确定
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(31129,user.getLanguage())+",javascript:onCancel(),_self} " ;//取消
		RCMenuHeight += RCMenuHeightStep ;
	%>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
  <body scroll="no">
  	<form id="form0" name="form0" method="post" action="/formmode/setup/formfieldexpendattropt.jsp">
  	<input type="hidden" name="fieldid" value="<%=fieldid%>"/>
  	<input type="hidden" name="formid" value="<%=formid%>"/>
    <div class="e8_box demo2">
	<!-- <div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div> -->
	    <div class="tab_box">
        <div>
           	<div class="zDialog_div_content" style="overflow-x:hidden;">
			 	<textarea name="expendattr" id="expendattr" class="Inputstyle" style="width: 100%;height: 65%"><%=expendattr %></textarea>
				<%=SystemEnv.getHtmlLabelName(125776,user.getLanguage())%><br><!-- 说明： -->
			 	 <%if(!fieldtype.equals("256")&&!fieldtype.equals("257")){ %>
			 	  1）<%=SystemEnv.getHtmlLabelName(126506,user.getLanguage())%><br><!--sqlwhere用于自定义单选和自定义多选浏览框字段， 此功能是用于实现卡片上的自定义浏览框字段根据卡片上的其他字段值进行过滤数据。 -->
			 	      &nbsp;&nbsp;  &nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(126508,user.getLanguage())%><br><!--格式为：sqlwhere=objzdy=$obj1$ and $obj2$(其中objzdy为自定义浏览框关联表中的列，obj1,obj2为卡片上的字段)。-->
			 	  2）<%=SystemEnv.getHtmlLabelName(126509,user.getLanguage())%><br><!--sqlcondition用于自定义单选和自定义多选浏览框字段，此功能是用于实现卡片上某些字段的值作为自定义浏览框的查询条件默认搜索出相应的数据。-->
			 	         &nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(126512,user.getLanguage())%><br><!--格式为：sqlcondition=objzdy=$obj1$,$obj2$(其中objzdy为自定义浏览框关联表中的列，obj1,obj2为此卡片上的字段)。-->
			 	  <%}else{ %>
			 	  1）<%=SystemEnv.getHtmlLabelName(126510,user.getLanguage())%><br><!--treerootnode用于自定义树形单选和自定义树形多选。此功能是用于实现卡片上的自定义树形单选和多选字段取卡片上的其他字段值作为树形根节点主键值-->
			 	        &nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(126511,user.getLanguage())%><br> <!--从而达到动态过滤树形根节点。格式为：treerootnode=objzdy=$obj1$,$obj2$(其中objzdy为自定义浏览框关联表中的列，obj1,obj2为卡片上的其他字段)。-->     
					<%} %>
			</div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align: center;">
					<wea:layout needImportDefaultJsAndCss="false">
						<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
							<wea:item type="toolbar">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="saveExpendattr();">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
				    </wea:item>
						</wea:group>
					</wea:layout>
			</div>
	    </div>
	</div>
	</form>
  </body>
</html>
<script>
	var dialog = null;
	try{
		dialog = parent.getDialog(window);
	}catch(e){
	}
	jQuery(document).ready(function(){
		resizeDialog(document);
		document.getElementById('expendattr').focus();
	});
	function saveExpendattr(){
		var expendattr = document.getElementById("expendattr").value;
 		top.closeTopDialog(expendattr);
	}
	function onCancel(){
		dialog.closeByHand();
	}
	function onClear(){
		top.closeTopDialog("");
	}
</script>