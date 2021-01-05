
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String id = Util.null2String(request.getParameter("id"));
	rs.executeProc("FnaCurrency_SelectByID",id);
	rs.next();
	String currencyname = Util.toScreen(rs.getString("currencyname"),user.getLanguage());
	String currencydesc = Util.toScreen(rs.getString("currencydesc"),user.getLanguage());
	String activable = Util.null2String(rs.getString("activable"));
	String isdefault = Util.null2String(rs.getString("isdefault"));

	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	boolean canedit = HrmUserVarify.checkUserRight("FnaCurrenciesEdit:Edit", user);
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage())+" : "+ currencyname ;
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			var dialog = null;
			var dWidth = 600;
			var dHeight = 400;
			
			var id = "<%=id%>";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/fna/maintenance/FnaCurrenciesView.jsp?isdialog=1&id="+id;
			}
			
			var parentDialog = parent.parent.getDialog(parent);
			var parentWin = parent.parent.getParentWindow(parent);
			if("<%=isclose%>"=="1"){
				parentWin.id = "<%=id%>";
				parentWin.closeDialog();	
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
			
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=fnaCurrencies&method=FnaCurrencyExchangeAdd&isdialog=1&id=<%=id%>","<%=SystemEnv.getHtmlLabelNames("611,588,17463",user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=fnaCurrencies&method=FnaCurrencyExchangeEdit&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelNames("93,588,17463",user.getLanguage())%>");
			}
		
			function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=where operateitem=40 and relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
		
			var _cmd = "";
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
							url:"FnaCurrenciesOperation.jsp?isdialog=1&operation=deletecurrencyexchange&thecurrencyid=<%=id%>&id="+idArr[i],
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
					if(_cmd == "closeDialog"){
						closeDialog();
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			String backfields = " a.id,a.defcurrencyid,b.currencyname,a.thecurrencyid,a.fnayear,a.periodsid,a.fnayearperiodsid,a.avgexchangerate,a.endexchangerage ";
			String fromSql  = " from FnaCurrencyExchange a left join FnaCurrency b on a.defcurrencyid = b.id";
			String sqlWhere = " where thecurrencyid = "+id;
			String orderby = " a.fnayearperiodsid " ;
			
			String operateString= "<operates width=\"20%\">";
			operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			//operateString+="     <operate href=\"javascript:doLog();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
			operateString+="</operates>";
			String tableString =" <table pageId=\""+Constants.HRM_Z_034+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_034,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
			operateString+
			"	<head>"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(446,user.getLanguage())+"\" column=\"fnayear\" orderkey=\"fnayear\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\" - +column:periodsid\"/>"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("526,588",user.getLanguage())+"\" column=\"avgexchangerate\" orderkey=\"avgexchangerate\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:clean}+1 +column:currencyname+ = +column:avgexchangerate+ "+currencyname+"\"/>"+
			"		<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelNames("1460,588",user.getLanguage())+"\" column=\"endexchangerage\" orderkey=\"endexchangerage\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:clean}+1 +column:currencyname+ = +column:endexchangerage+ "+currencyname+"\"/>"+
			"	</head>"+
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
	</BODY>
</HTML>
