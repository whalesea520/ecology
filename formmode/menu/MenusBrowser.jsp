
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page" />
<%
String pmenutype = Util.null2String(request.getParameter("menutype"));
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type="text/css" HREF="/css/Weaver_wev8.css">
	</HEAD>
	<%
	%>

	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";//取消
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";//清除
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<BODY>
		<FORM NAME="SearchForm" action="MenusBrowser.jsp" method=post>
			<table width="100%" height="100%" border="0" cellspacing="0"
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
										<TR class=Spacing style="height:1px;">
											<TD class=Line1 colspan=4></TD>
										</TR>
										<TR>
											<TD width=15%><%=SystemEnv.getHtmlLabelName(18773, user.getLanguage())%></TD><!-- 自定义菜单 -->
											<TD width=35%>
											</TD>
											<TD width=15%></TD>
											<TD width=35%></TD>
										</TR>
										<TR class=separator style="height:1px;">
											<TD class=Sep1 colspan=4 style="padding:0;"></TD>
										</TR>
									</table>
									<TABLE ID=BrowseTable class=BroswerStyle cellspacing="0"
										cellpadding="0" width="100%">
										<TR class=DataHeader>
											<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH><!-- 标识 -->
											<TH>
												<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%><!-- 名称 -->
											</TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%><!-- 描述 -->
											</TH>
											<TH>
												<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%><!-- 类型 -->
											</TH>
										</TR>
										<TR class=Line>
											<TH colSpan=4></TH>
										</TR>
										<%
										int index = 0;
										MenuCenterCominfo.setTofirstRow();
										while (MenuCenterCominfo.next())
										{
											
											String menuType = MenuCenterCominfo.getMenutype();
											String menuId = MenuCenterCominfo.getId();
											String menuName = MenuCenterCominfo.getMenuname();
											String menuDesc = MenuCenterCominfo.getMenuDesc();
											if(!"sys".equals(menuType)&&!"hp".equals(menuType))
											{
												if(!"".equals(pmenutype))
												{
													if(pmenutype.equals(menuType))
													{
														index++;
													}
													else
													{
														continue;
													}
												}
												else
													index++;
											}
											else
											{
												continue;
											}
									%>
									<TR class='<%if(index%2==0) out.println("DataDark"); else out.println("DataLight");%>'>
										<TD style="display: none"><A HREF=#><%=menuId%></A></TD>
										<TD valign="middle" width="15%">
											<%=menuName%>
										</TD>
										<TD valign="middle" width="55%">
											<%=menuDesc%>
										</TD>
										<TD valign="middle" width="15%">
											<%if("1".equals(menuType)){ %>
												<%=SystemEnv.getHtmlLabelName(23031,user.getLanguage())%><!-- 外部菜单 -->
											<%}else{ %>
												<%=SystemEnv.getHtmlLabelName(23032,user.getLanguage())%><!-- 内部菜单 -->
											<%} %>
										</TD>
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
					<td height="10" colspan="4"></td>
				</tr>
			</table>
		</FORM>
	</BODY>
</HTML>
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