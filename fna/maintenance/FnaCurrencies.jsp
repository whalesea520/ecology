
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	ArrayList thecurrencyids = new ArrayList() ;
	ArrayList defcurrencyids = new ArrayList() ;
	ArrayList exchangerages = new ArrayList() ;
	rs.executeProc("FnaCurrencyExchange_SByLast","");
	while(rs.next()) {
		thecurrencyids.add(Util.null2String(rs.getString("thecurrencyid"))) ;
		defcurrencyids.add(Util.null2String(rs.getString("defcurrencyid"))) ;
		exchangerages.add(Util.null2String(rs.getString("endexchangerage"))) ;
	}
	
	String cmd = Util.null2String(request.getParameter("cmd"));
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage());
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
							url:"FnaCurrenciesOperation.jsp?operation=deletecurrencies&id="+idArr[i],
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
			
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/fna/maintenance/FnaCurrencies.jsp";
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
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=fnaCurrencies&method=FnaCurrenciesAdd&isdialog=1","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(406,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=fnaCurrencies&method=FnaCurrenciesEdit&showpage=1&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(406,user.getLanguage())%>");
			}
			
			function showDetail(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=fnaCurrencies&method=FnaCurrenciesView&showpage=2&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(406,user.getLanguage())%>");
			}
		
			function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=39 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
		
			function showDetailLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=40 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
			
			function showAllLog(){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?sqlwhere=<%=xssUtil.put("where operateitem=39")%>","<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(HrmUserVarify.checkUserRight("FnaCurrenciesAdd:Add", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
		if(HrmUserVarify.checkUserRight("FnaCurrencies:Log", user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%
						if(HrmUserVarify.checkUserRight("FnaCurrenciesAdd:Add", user)){ 
					%>
							<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
					<%	} %>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			String backfields = " a.id,a.currencyname,a.currencydesc,a.activable,a.isdefault,c.defcurrencyid,d.currencyname as dcurrencyname,c.endexchangerage,c.fnayearperiodsid,(case when b.result is null then 0 else b.result end) as result "; 
			String fromSql  = " from FnaCurrency a left join (select a.thecurrencyid,COUNT(id) as result from FnaCurrencyExchange a group by a.thecurrencyid) b on a.id = b.thecurrencyid left join FnaCurrencyExchange c on a.id = c.thecurrencyid and    exists (select * from FnaCurrencyExchange where thecurrencyid = a.id and c.fnayearperiodsid=(select MAX(fnayearperiodsid) from FnaCurrencyExchange where thecurrencyid = a.id)) left join FnaCurrency d on c.defcurrencyid = d.id";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.id " ;
			String tableString = "";
	
			if(cmd.length() > 0){
				sqlWhere += " and a.activable = "+cmd;
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("FnaCurrenciesEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("FnaCurrenciesEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("FnaCurrencies:log", user)+":"+HrmUserVarify.checkUserRight("FnaCurrenciesEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("FnaCurrencies:log", user)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="     <operate href=\"javascript:showDetail()\" text=\""+SystemEnv.getHtmlLabelNames("588,17463",user.getLanguage())+"\" index=\"3\"/>";
 	       	operateString+="     <operate href=\"javascript:showDetailLog()\" text=\""+SystemEnv.getHtmlLabelNames("588,83",user.getLanguage())+"\" index=\"4\"/>";
			
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_034+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_034,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"false\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(406,user.getLanguage())+"\" column=\"currencyname\" orderkey=\"currencyname\" />"+
		    "		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"currencydesc\" orderkey=\"currencydesc\" />"+
			"		<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelNames("30902,588",user.getLanguage())+"\" column=\"currencyname\" orderkey=\"currencyname\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:clean}{cmd:append[+column:dcurrencyname+==null?null:+1 +column:dcurrencyname+ = +column:endexchangerage+ +column:currencyname+]}\"/>"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"activable\" orderkey=\"activable\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:style[0=color:red]}{cmd:array["+user.getLanguage()+";default=18096,1=18095]}\"/>"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(757,user.getLanguage())+"\" column=\"isdefault\" orderkey=\"isdefault\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:img[+column:isdefault+==1?/images/BacoCheck_wev8.gif:null]}\"/>"+
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
