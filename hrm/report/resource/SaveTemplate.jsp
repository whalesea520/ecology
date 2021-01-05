
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- added by wcd 2014-07-28 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%
	String method = Util.null2String(request.getParameter("method"));
%>
<HTML>
	<HEAD>
		<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</HEAD>
	<body scroll="no">
		<div class="zDialog_div_content">
			<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="" method=post>
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="demandnumspan" required="true">
								<input class=inputstyle name="templateName" value="" onblur='checkinput("templateName","demandnumspan")'>
							</wea:required>
						</wea:item>
					</wea:group>
				</wea:layout>
				<input type="hidden" name="method" value='<%=method%>'>
			</FORM>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" class=zd_btn_submit onclick="doSave();"  id=btnok value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
						<input type="button" class=zd_btn_cancle onclick="doCancel();"  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
					</wea:item>
				</wea:group>
			</wea:layout>
			<script type="text/javascript">
				jQuery(document).ready(function(){
					resizeDialog(document);
				});
			</script>
		</div>
		<script type="text/javascript">
			var name = "";
			function doSave(){
				name = $GetEle("templateName").value;
				var exist = ajaxSubmit(encodeURI(encodeURI("/js/hrm/getdata.jsp?cmd=checkHrmReportTemplateName&name="+name+"&author=<%=user.getUID()%>")));
				if(exist == "-1"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>");
				}else if(exist == "1"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18151,24943",user.getLanguage())%>");
				}else{
					doClose();
				}
			}
			
			function doCancel(){
				var dialog = parent.parent.getDialog(parent);
				dialog.close();
			}

			function doClose(){
				var parentWin = parent.parent.getParentWindow(parent);
				parentWin._name = name;
				parentWin._method = "<%=method%>";
				parentWin.procSave();
			}
		</script>
	</body>
</html>
