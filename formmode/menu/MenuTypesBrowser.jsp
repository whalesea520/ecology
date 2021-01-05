
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo"
	scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo"
	scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo"
	scope="page" />

<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	</head>
	<%
		if (!HrmUserVarify.checkUserRight("homepage:styleMaint", user))
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}

		String type = Util.null2String(request.getParameter("type"));
		ArrayList idList = new ArrayList();
		ArrayList nameList = new ArrayList();
		ArrayList descList = new ArrayList();
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = "";
		String pageEdit = "";
		if ("element".equals(type))//元素样式:列表
		{
			titlename = SystemEnv.getHtmlLabelName(22913, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "ElementStyleEdit.jsp";

			esc.setTofirstRow();
			while (esc.next())
			{
				idList.add(esc.getId());
				nameList.add(esc.getTitle());
				descList.add(esc.getDesc());
			}
		}
		else if ("menuh".equals(type))//横向菜单样式:列表
		{
			titlename = SystemEnv.getHtmlLabelName(22914, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "MenuStyleEditH.jsp";

			mhsc.setTofirstRow();
			while (mhsc.next())
			{
				idList.add(mhsc.getId());
				nameList.add(mhsc.getTitle());
				descList.add(mhsc.getDesc());
			}
		}
		else if ("menuv".equals(type))//纵向菜单样式:列表
		{
			titlename = SystemEnv.getHtmlLabelName(22915, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320, user.getLanguage());
			pageEdit = "MenuStyleEditV.jsp";

			mvsc.setTofirstRow();
			while (mvsc.next())
			{
				idList.add(mvsc.getId());
				nameList.add(mvsc.getTitle());
				descList.add(mvsc.getDesc());
			}
		}
		String needfav = "1";
		String needhelp = "";
	%>

<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">
	</HEAD>

	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";//取消
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";//清除
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<BODY>
		<FORM NAME="SearchForm" action="javascript:void(0);" method=post>
			<input type="hidden" name="pagenum" value=''>

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
											<TD class=Line1 colspan=4></TD>
										</TR>
										<TR>
											<TD colspan=4><%=titlename %></TD>
										</TR>
										<TR class=separator>
											<TD class=Sep1 colspan=4></TD>
										</TR>
									</table>
									<TABLE ID=BrowseTable class=BroswerStyle cellspacing="0"
										cellpadding="0">
										<TR class=DataHeader>
											<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH><!-- 标识 -->
											<TH>
												<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TH><!-- 名称 -->
											<TH>
												<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TH><!-- 描述 -->
										</TR>
										<TR class=Line>
											<TH colSpan=3></TH>
										</TR>
										<%
											ArrayList cloneNameList = (ArrayList) nameList.clone();
											Collections.sort(cloneNameList);
											
											for (int i = 0; i < cloneNameList.size(); i++)
											{
												String stylename = (String) cloneNameList.get(i);
												int pos = nameList.indexOf(stylename);

												String styleid = (String) idList.get(pos);
												String styledesc = (String) descList.get(pos);
										%>
										<TR <%if((i+1)%2==0) out.println(" class='DataDark' "); else out.println(" class='DataLight' ");%>>
											<TD style="display: 'none'"><A HREF=#><%=styleid%></A></TD>
											<TD valign="middle" width="15%">
												<%=stylename%>
											</TD>
											<TD valign="middle" width="40%"><%=styledesc%></TD>
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
	</BODY>
</HTML>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
     
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>