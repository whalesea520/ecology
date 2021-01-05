<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	int groupid = Util.getIntValue(request.getParameter("groupid"));
	
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			var dialog = null;
			var dWidth = 500;
			var dHeight = 350;
			
			var id = "<%=groupid%>";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/group/HrmGroupShare.jsp?isdialog=1&groupid="+id;
			}
		
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			var parentDialog = parent.parent.getDialog(parent);
			var parentWin = parent.parent.getParentWindow(parent);
			
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmGroupShareAdd&groupid=<%=groupid%>","<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmGroupShareEdit&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(19910,user.getLanguage())%>");
			}
			
			function doDel(id){
				if(!id){
					id = _xtable_CheckedCheckboxId();
				}
				if(!id){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					var idArr = id.split(",");
					var ajaxNum = 0;
					for(var i=0;i<idArr.length;i++){
						ajaxNum++;
						jQuery.ajax({
							url:"HrmGroupShareOperation.jsp?isdialog=1&method=delete&groupid=<%=groupid%>&id="+idArr[i],
							type:"post",
							async:true,
							complete:function(xhr,status){
								ajaxNum--;
								if(ajaxNum==0){
									_table.reLoad();
								}
							}
						});
					}
				});
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="searchfrm" name="searchfrm" method="post" action="HrmGroupMembers.jsp">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="doAdd();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
<%
String backfields = " id,sharetype,userid,subcompanyid,departmentid,roleid,foralluser,crmid,jobtitleid,seclevel,seclevelto,rolelevel,sharelevel,jobtitlelevel,scopeid "; 
String fromSql  = " HrmGroupShare ";
String sqlWhere = " where groupid =  "+groupid;
String orderby = " id " ;
String tableString = "";

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getGroupShareOperate\" otherpara=\"true\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="</operates>";	
 
tableString =" <table pageId=\""+PageIdConst.Hrm_GroupShare+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_GroupShare,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getGroupShareCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" transmethod=\"weaver.hrm.HrmTransMethod.getGroupShareTypeName\"  otherpara=\""+user.getLanguage()+"\" />"+
    "				<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.hrm.HrmTransMethod.getGroupShareDetial\" otherpara=\""+user.getLanguage()+"\"  />"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" transmethod=\"weaver.hrm.HrmTransMethod.getSeclevel\" otherpara=\"column:seclevelto\"/>"+
    "			</head>"+
    " </table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</form>
	</BODY>
</HTML>
