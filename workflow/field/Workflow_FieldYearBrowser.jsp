
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	</HEAD>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String needfav = "1";
	String needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(15933, user.getLanguage());

	//String userRights = shareRights.getUserRights("-1", user);//得到用户查看范围
	//if ("-100".equals(userRights)) {
	    //response.sendRedirect("/notice/noright.jsp");
		//return;
	//}
	String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
	String name = Util.null2String(request.getParameter("name"));
	String desc = Util.null2String(request.getParameter("desc"));
	String sqlwhere = " ";
	int ishead = 0;
	if(!sqlwhere1.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += sqlwhere1;
		}
	}
	
	/*
	String backfields = " yearId,yearName ";
	String fromSQL = " from Workflow_FieldYear a";
	String tableString = ""+
	"<table pageId=\"pageId\" pagesize=\"10\" tabletype=\"none\">"+
	"<sql backfields=\""+backfields+"\" showCountColumn=\"false\" sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlprimarykey=\"yearId\" sqlsortway=\"asc\" />"+
	"<head>"+							 
			 "<col width=\"100%\" text=\""+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"\" column=\"yearName\" transmethod=\"weaver.workflow.field.YearField.getYName\"/>"+
	"</head>"+
	"<operates>"+
    "		<operate href=\"javascript:selectData();\" otherpara=\"column:yearName\" text=\""+SystemEnv.getHtmlLabelName(33251,user.getLanguage())+"\" target=\"_self\"/>"+
	"		</operates>"+      
	"</table>";
	*/
%>
<BODY>

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>

		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnclose_onclick(),_top} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
						class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="mainDiv">
			<FORM id=frmMain name=frmMain action=Workflow_FieldYearBrowser.jsp method=post>
	
<%--
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context="">
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />

						</wea:item>
					</wea:group>
				</wea:layout>
--%>

				<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
					<TR class=DataHeader>
						<TH width=100%><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></TH>
					</TR>
					<%
					int i=0;
					RecordSet.executeSql("select yearId,yearName from Workflow_FieldYear a "+sqlwhere+" order by yearId asc");
					while(RecordSet.next()){
						String yearName = Util.null2String(RecordSet.getString("yearName"));
						if(i==0){
							i=1;
					%>
					<TR class=DataLight>
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark>
						<%
						}
						%>
						<TD style="padding-left: 12px;" onclick=selectData('<%=yearName%>','<%=yearName%>')><%=yearName%></TD>
					</TR>
					<%}%>
				</TABLE>
			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="zd_btn_submit" onclick="btnclear_onclick();" style="width: 50px!important;">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="btnclose_onclick();" style="width: 60px!important;">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<!-- end -->

<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}

	function selectData(id, name) {
		var returnjson = {id: id,name: name};
		if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){}
			dialog.close(returnjson);
		} else { 
	       	window.parent.returnValue = returnjson;
			window.parent.close();
	   	}
	}

	function btnclear_onclick() {
		selectData('', '');
	}

	function btnclose_onclick() {
		if(dialog){
			dialog.closeByHand();
		} else {
			window.parent.close();
	   	}
	}

	function afterDoWhenLoaded() {
		jQuery("#_xTable tr").click(BrowseTable_onclick);
	}

	function BrowseTable_onclick(e) {
	   var tds = jQuery(this).children('td');
	   if (tds.length < 2) {
	   		return;
	   }
	   var id = jQuery(tds.get(0)).find('input').val();
	   var name = jQuery(tds.get(1)).find('a').text();
	   selectData(id, name);
	}
</script>
</BODY>
</HTML>
