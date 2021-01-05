
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.page.maint.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css"
			rel=stylesheet>
		<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/ui/ui.dialog_wev8.js"></script>
	</head>
	<body id="myBody">
		<FORM NAME="SearchForm" action="MenusBrowser.jsp" method=post>
			<table width="100%" height="100%" border="1" cellspacing="0"
				cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow height="100%" width="100%">
							<tr>
								<td valign="top">
									<table width=100% class=ViewForm>
										<TR class=Spacing>
											<TD class=Line1 colspan=3></TD>
										</TR>
										<TR>
											<TD width=15%><%=SystemEnv.getHtmlLabelName(17858, user.getLanguage())%></TD>
											<TD width=35%>
											</TD>
											<TD width=15%></TD>
											<TD width=35%></TD>
										</TR>
										<TR class=separator style="height:1px;">
											<TD class=Sep1 colspan=4></TD>
										</TR>
									</table>
									<TABLE ID=BrowseTable class=BroswerStyle cellspacing="0" width="100%"
										cellpadding="0">
										<TR class=DataHeader>
											<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>
											</TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>
											</TH>
										</TR>
										<TR class=Line>
											<TH colSpan=3></TH>
										</TR>

										<%
											rs.executeSql("select * from pagetemplate order by templatename");
											int index = 0;

											String dirTemplate = pc.getConfig().getString("template.beforelogin");
											while (rs.next())
											{
												index++;
										%>
										<TR class="<%=index % 2 == 0 ? "datadark" : "datalight"%>">
											<TD style="display: none"><A HREF=#><%=rs.getString("id")%></A></TD>
											<TD>
												<%=rs.getString("templatename")%>
											</TD>
											<TD><%="cus".equals(rs.getString("templatetype")) ? SystemEnv.getHtmlLabelName(19516, user.getLanguage()) : SystemEnv.getHtmlLabelName(468, user.getLanguage())%></TD>
										</TR>
										<%
											}
										%>
									</TABLE>
								</td>
							</tr>
						</TABLE>
					</td>
					<td></td>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
			</table>
		</FORM>
	</body>
</html>
<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>