
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	</HEAD>
	<%
		String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
		String name = Util.null2String(request.getParameter("name"));
		String description = Util.null2String(request.getParameter("description"));
		String sqlwhere = " where 1=1 ";
		int ishead = 0;
		if (!sqlwhere1.equals("")) {
			sqlwhere += sqlwhere1;
		}
		if (!name.equals("")) {
			sqlwhere += " and name like '%" + Util.fromScreen2(name, user.getLanguage()) + "%'";
		}
		if (!description.equals("")) {
			sqlwhere += " and description like '%" + Util.fromScreen2(description, user.getLanguage()) + "%'";
		}
	%>
	<BODY>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr style="height: 10px;">
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<FORM NAME=SearchForm STYLE="margin-bottom: 0" action="CustomerBizTypeBrowser.jsp" method=post>
									<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
									<DIV align=right style="display: none">
										<%
											RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
													+ ",javascript:SearchForm.submit(),_top} ";
											RCMenuHeight += RCMenuHeightStep;
										%>
										<BUTTON class=btnSearch accessKey=S type=submit>
											<U>S</U>-<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>
										<%
											RCMenu += "{" + SystemEnv.getHtmlLabelName(199, user.getLanguage())
													+ ",javascript:SearchForm.reset(),_top} ";
											RCMenuHeight += RCMenuHeightStep;
										%>
										<BUTTON class=btnReset accessKey=T type=reset>
											<U>T</U>-<%=SystemEnv.getHtmlLabelName(199, user.getLanguage())%></BUTTON>
										<%
											RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage())
													+ ",javascript:window.parent.close(),_top} ";
											RCMenuHeight += RCMenuHeightStep;
										%>
										<BUTTON class=btn accessKey=1 onclick="window.parent.close()">
											<U>1</U>-<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></BUTTON>
										<%
											RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage())
													+ ",javascript:SearchForm.btnclear.click(),_top} ";
											RCMenuHeight += RCMenuHeightStep;
										%>
										<BUTTON class=btn accessKey=2 id=btnclear>
											<U>2</U>-<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%></BUTTON>
									</DIV>
									<table width=100% class=ViewForm>
										<TR class=Spacing style="height: 1px;">
											<TD class=Line1 colspan=4></TD>
										</TR>
										<TR>
											<TD width=15%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TD>
											<TD width=35% class=field>
												<input class=InputStyle name=name value="<%=name%>">
											</TD>
											<TD width=15%><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TD>
											<TD width=35% class=field>
												<input class=InputStyle name=description value="<%=description%>">
											</TD>
										</TR>
										<tr style="height: 1px;">
											<td class=Line colspan=4></td>
										</tr>
										<TR class=Spacing style="height: 1px;">
											<TD class=Line1 colspan=4></TD>
										</TR>
									</table>
									<TABLE ID=BrowseTable width="100%" class=BroswerStyle cellspacing=1>
										<TR class=DataHeader>
											<TH width=30%><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
											<TH width=35%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TH>
											<TH width=35%><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TH>
										</tr>
										<TR class=Line style="height: 1px;">
											<TH colSpan=3></TH>
										</TR>
										<%
											int i = 0;
											sqlwhere = "select id,name,description from CRM_CustomerBizType " + sqlwhere
													+ " order by id asc";
											RecordSet.execute(sqlwhere);
											while (RecordSet.next()) {
												if (i == 0) {
													i = 1;
										%>
										<TR class=DataLight>
											<%
												} else {
														i = 0;
											%>
											<TR class=DataDark>
												<%
													}
												%>
												<TD><A HREF=#><%=RecordSet.getString(1)%></A></TD>
												<TD><%=RecordSet.getString(2)%></TD>
												<TD><%=RecordSet.getString(3)%></TD>

											</TR>
											<%
												}
											%>
										
									</TABLE>
								</FORM>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr style="height: 10px;">
				<td height="10" colspan="3"></td>
			</tr>
		</table>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:eq(0)").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"0",name:""};
	window.parent.close()
}
  
</script>
	</BODY>
</HTML>