
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String id = Util.null2String(request.getParameter("id"));
	String planid = Util.null2String(request.getParameter("planid"));
	int result = Util.getIntValue(request.getParameter("result"));
	
	String showpage = Util.null2String(request.getParameter("showpage"));

	String sql = "select lastname from HrmCareerApply where id ="+id;
	rs.executeSql(sql);
	rs.next();
	String name = Util.null2String(rs.getString("lastname"));

	String step = CareerApplyComInfo.getStep(id);
	String stepname = CareerApplyComInfo.getStepname(id);
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6134,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(356,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				//parentWin.planid = "<%=planid%>";
				parentWin.closeDialog();	
			}
		 	function doSave(){
		    	if(<%=result%>==0){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15740,user.getLanguage())%>",function(){
						document.frmMain.operation.value="delete";
						document.frmMain.submit() ;
					});
				}else if(<%=result%>==1){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15741,user.getLanguage())%>",function(){
						document.frmMain.operation.value="pass";
						document.frmMain.submit() ;
					});
				}else if(<%=result%>==2){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15742,user.getLanguage())%>",function(){
						document.frmMain.operation.value="backup";
						document.frmMain.submit() ;
					});
				}
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
			if(showpage.equals("1")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(showpage.equals("1")){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%if(showpage.equals("1")){%>
		<FORM id=weaver name=frmMain action="HrmInterviewManageOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(15730,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<%=name%><input class=inputstyle type=hidden name=resourceid value=<%=id%>>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15731,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<%=stepname%><input class=inputstyle type=hidden name=step value=<%=step%>>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15737,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
					        <%if(result==0){%><%=SystemEnv.getHtmlLabelName(15690,user.getLanguage())%><%}%>
							<%if(result==1){%><%=SystemEnv.getHtmlLabelName(15376,user.getLanguage())%><%}%>
							<%if(result==2){%><%=SystemEnv.getHtmlLabelName(15689,user.getLanguage())%><%}%>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15698,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="namespan" required="false">
							<textarea class=inputstyle rows=5 cols=40 name="remark" ></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type=hidden name=operation value="">
			<input class=inputstyle type=hidden name=planid value="<%=planid%>">
		</form>
		<%}else{
			String backFields = "a.id,a.resourceid,a.stepid,a.result,a.remark,a.assessor,a.assessdate";
			String sqlFrom = "from HrmInterviewAssess a";
			String sqlWhere = "where a.resourceid = "+id +" and a.stepid = "+step;
			String orderby = "" ;
			
			String operateString= "";
			String tableString=""+
				"<table pageId=\""+Constants.HRM_Z_054+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_054,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+                             
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15739,user.getLanguage())+"\"  column=\"assessor\" orderkey=\"assessor\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+ 
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15696,user.getLanguage())+"\" column=\"assessdate\" orderkey=\"assessdate\"/>"+
						"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15697,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=15699,1=154,2=15700]}\"/>"+
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15698,user.getLanguage())+"\" column=\"remark\" orderkey=\"remark\"/>"+
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		<%}%>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
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
