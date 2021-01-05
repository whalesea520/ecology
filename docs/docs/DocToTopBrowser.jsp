
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>

<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int docid = Util.getIntValue(request.getParameter("docid"),0);
String istop = "";
String topstartdate = "";
String topenddate = "";

RecordSet.executeSql("select istop,topstartdate,topenddate from docdetail where id="+docid);
RecordSet.next();
istop = Util.null2String(RecordSet.getString("istop"));
topstartdate = Util.null2String(RecordSet.getString("topstartdate"));
topenddate = Util.null2String(RecordSet.getString("topenddate"));

String istopcheck = istop.equals("1")?"checked":"";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			try{
				parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(23784, user.getLanguage())%>");
			}catch(e){}
			function onClose(){
				 if(dialog){
			    	dialog.close()
			    }else{
				    window.parent.close();
				}
			}
			function doTop(obj){
				jQuery.ajax({
					url:"/docs/DocDetailLogOperate.jsp",
					type:"post",
					dataType:"json",
					data:{
						docid:"<%=docid%>",
						operation:"top",
						istop:jQuery("#istop").attr("checked")?"1":"0",
						topstartdate:jQuery("#topstartdate").val(),
						topenddate:jQuery("#topenddate").val()
					},
					beforeSend:function(){
						e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592, user.getLanguage())%>",true);
					},
					complete:function(){
						e8showAjaxTips("",false);
					},
					success:function(data){
						if(data.reistop=="1"){
							top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("23784,15242", user.getLanguage())%>");
							dialog.close();
						}else{
							top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("23784,498", user.getLanguage())%>");
						}
					}
				});
			}
		</script>
	</HEAD>
	<BODY style="background-color: #ffffff">
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<% 
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doTop(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div class="zDialog_div_content">
		<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="doTop(this)" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<form name="frmCenter"  id="frmCenter" action="javascript:void(0);" method="post">
		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(23784, user.getLanguage())%></wea:item>
				<wea:item>
					<input class=inputstyle type='checkbox' id='istop' name='istop' value="<%=istop %>" <%=istopcheck %> onclick="if(this.checked){this.value='1';}else{this.value='0';}">
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15030, user.getLanguage())%></wea:item><!-- 有效期 -->
				<wea:item>
					<BUTTON type="button" class=calendar id=SelectDate onclick="getLimitStartDate('topstartdatespan','topstartdate','topenddatespan','topenddate')"></BUTTON>
					<SPAN id=topstartdatespan><%=topstartdate %></SPAN>
					<input class=inputstyle type="hidden" id="topstartdate" name="topstartdate" value="<%=topstartdate %>">
					－&nbsp;
					<BUTTON type="button" class=calendar id=SelectDate onclick="getLimitEndDate('topstartdatespan','topstartdate','topenddatespan','topenddate')"></BUTTON>
					<SPAN id=topenddatespan><%=topenddate %></SPAN>
					<input class=inputstyle type="hidden" id="topenddate" name="topenddate" value="<%=topenddate %>">

							</wea:item>
			</wea:group>
		</wea:layout>
	</FORM>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="window.parent.close();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
