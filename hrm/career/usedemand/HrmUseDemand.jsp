
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-06-09 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6131,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String jobtitle = Util.null2String(request.getParameter("jobtitle"));
	String deptname = Util.null2String(request.getParameter("deptname"));
	String demandkind = Util.null2String(request.getParameter("demandkind"));
	int status = Util.getIntValue(request.getParameter("status"),-1);
	
	String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
		function onBtnSearchClick(){
			jQuery("#searchfrm").submit();
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
						url:"UseDemandOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
		
		var dialog = null;
		var _status = "";
		function closeDialog(){
			if(dialog)
				dialog.close();
			window.location.href="/hrm/career/usedemand/HrmUseDemand.jsp?status="+_status;
		}
		
		function openDialog(id){
			if(dialog==null){
				dialog = new window.top.Dialog();
			}
			dialog.currentWindow = window;
			if(id==null){
				id="";
			}
			var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmUseDemandAdd&isdialog=1&status=<%=status%>";
			if(!!id){
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6131,user.getLanguage())%>";
				url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmUseDemandEdit&isdialog=1&status=<%=status%>&id="+id;
			}else{
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6131,user.getLanguage())%>";
			}
			dialog.Width = 400;
			dialog.Height = 420;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.show();
		}
		
		function onLog(id){
			if(dialog==null){
				dialog = new window.top.Dialog();
			}
			dialog.currentWindow = window;
			var url = "";
			if(id && id!=""){
				url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=69 and relatedid=")%>&relatedid="+id;
			}else{
				url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=69")%>";
			}
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
			dialog.Width = jQuery(window).width();
			dialog.Height = jQuery(window).height();
			dialog.Drag = true;
			dialog.maxiumnable = true;
			dialog.URL = url;
			dialog.show();
		}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(HrmUserVarify.checkUserRight("HrmUseDemandDelete:Delete", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<%	
							}
							if(HrmUserVarify.checkUserRight("HrmUseDemandDelete:Delete", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%	} %>
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>"/>
						<input type="hidden" name="status" value="<%=status%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(20379,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="jobtitle" browserValue="" 
					                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
					                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					                completeUrl="/data.jsp?type=hrmjobtitles" width="80%" browserSpanValue="">
					        	</brow:browser>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="deptname" browserValue="" 
					                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
					                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					                completeUrl="/data.jsp?type=4" width="80%" browserSpanValue="">
						        </brow:browser>
							</span>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backfields = " a.id, a.demandjobtitle,j.jobtitlename, a.demanddep,d.departmentname, a.demandnum, a.demandkind,c.subcompanyname, a.demandregdate, a.refermandid, a.status, a.referdate"; 
			String fromSql  = " from HrmUseDemand a left join HrmJobTitles j on a.demandjobtitle = j.id left join HrmDepartment d on a.demanddep = d.id left join HrmSubCompany c on d.subcompanyid1 = c.id ";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.demandregdate " ;
			String tableString = "";
			
			if(!qname.equals("")){
				sqlWhere += " and (j.jobtitlename like '%"+qname+"%' or d.departmentname like '%"+qname+"%' or c.subcompanyname like '%"+qname+"%')";
			}		
			if (!"".equals(jobtitle)) {
				sqlWhere += " and a.demandjobtitle = "+jobtitle;
			}
			if (!"".equals(deptname)) {  
				sqlWhere += " and a.demanddep = "+deptname;
			}
			if(-1 != status){
				sqlWhere += " and a.status = "+status;
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmUseDemandEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmUseDemandDelete:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmUseDemand:log", user)+"\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_051+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_051,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"true\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\""+(-1 == status ? 12 : 15)+"%\" text=\""+SystemEnv.getHtmlLabelName(20379,user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\" />"+
		    "		<col width=\""+(-1 == status ? 12 : 15)+"%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentname\" orderkey=\"departmentname\" />"+
		    "		<col width=\""+(-1 == status ? 12 : 15)+"%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyname\" orderkey=\"subcompanyname\" />"+
		    "		<col width=\""+(-1 == status ? 10 : 10)+"%\" text=\""+SystemEnv.getHtmlLabelName(17905,user.getLanguage())+SystemEnv.getHtmlLabelName(1859,user.getLanguage())+"\" column=\"demandnum\" orderkey=\"demandnum\" />"+
		    "		<col width=\""+(-1 == status ? 12 : 15)+"%\" text=\""+SystemEnv.getHtmlLabelName(6153,user.getLanguage())+"\" column=\"demandregdate\" orderkey=\"demandregdate\" />"+
		    "		<col width=\""+(-1 == status ? 12 : 25)+"%\" text=\""+SystemEnv.getHtmlLabelName(616,user.getLanguage())+"\" column=\"refermandid\" orderkey=\"refermandid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />";
		    if(-1 == status){
		    	tableString += "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+"+;0=15746,1=15747,2=15748,3=15749,4=15750]}\" />";
		    }
		    tableString += "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
	</BODY>
</HTML>
