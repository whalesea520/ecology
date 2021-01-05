
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>

<%
String menutype = Util.null2String(request.getParameter("menutype"));
String msg = Util.null2String(request.getParameter("msg"));
String subCompanyId = "0";
if(menutype.equals("2")){
	subCompanyId = Util.null2o(request.getParameter("subCompanyId"));
}
//boolean hasRight =false;			//首页维护权限
boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  

//CheckSubCompanyRight cscr=new CheckSubCompanyRight();
//int opreateLevel=cscr.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",Util.getIntValue(subCompanyId));
//hasRight = HrmUserVarify.checkUserRight("homepage:Maint", user);

if(menutype.equals("1") && !HeadMenuhasRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
if(menutype.equals("2") && ((subCompanyId.equals("0") && !HeadMenuhasRight) || (!subCompanyId.equals("0")&& !SubMenuRight))){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if("1".equals(menutype)){
	titlename =SystemEnv.getHtmlLabelName(23021,user.getLanguage());
}else{
	titlename =SystemEnv.getHtmlLabelName(23022,user.getLanguage());
}

String needfav ="1";
String needhelp ="";    
%>

<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	<script type="text/javascript">
	  if("<%=msg%>"=="1")
	    alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");	
	</script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
  <%
  if(menutype.equals("2")){
	  if(SubMenuRight || HeadMenuhasRight ||1==user.getUID()){
		  RCMenu += "{"+SystemEnv.getHtmlLabelName(23033,user.getLanguage())+",javascript:onAdd(),_self} " ;
		  RCMenuHeight += RCMenuHeightStep ;
	  }
  }else{
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(23033,user.getLanguage())+",javascript:onAdd(),_self} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
  
  %>
  
  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0">
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
			<table class="Shadow">
				<colgroup>
				<col width="1">
				<col width="">
				<col width="10">
				<tr>
					<TD></TD>		
					<td valign="top">
						<TABLE class="ListStyle" cellspacing=1 valign="top" width="100%">
						<TR class="header">
							<TH><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%><!--名称--></TH>
							<TH><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></TH>
							<TH><%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%><!--类型--></TH>
							<%if(//1==user.getUID()&&
									menutype.equals("2")) {%>
							<TH><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!--操作--></TH>
							<%}%>
						</TR>					
						<%
						 
						int index=0;
						MenuCenterCominfo.setTofirstRow();						
						while(MenuCenterCominfo.next())
						{
							
							String id = MenuCenterCominfo.getId();
							if("hp".equals(id)){
								continue;
							}
							String menuname = MenuCenterCominfo.getMenuname();
							String mmenutype = MenuCenterCominfo.getMenutype();
							String _subCompanyId = MenuCenterCominfo.getSubCompanyId();
							if((subCompanyId.equals("0") && ("sys".equals(mmenutype) || !"0".equals(mmenutype))&& HeadMenuhasRight) || (!subCompanyId.equals("0") && SubMenuRight)){
								if(_subCompanyId.equals("")){
									_subCompanyId ="0";
								}
								if("1".equals(menutype))
								{
									if(!mmenutype.equals(menutype))
									{
										continue;
									}
								}
								else
								{
									
									if("1".equals(mmenutype)||(!subCompanyId.equals(_subCompanyId) && !"sys".equals(mmenutype)))
									{
										continue;
									}
									if(1!=user.getUID() && menutype.equals("2")&& subCompanyId.equals("0") && !HeadMenuhasRight){
										//if(!mmenutype.equals("sys")){
											continue;
										//}
									}
								}
								index++;
							%>			
							<TR class='<%if(index%2==0) out.println("DataDark"); else out.println("DataLight");%>'>
								<TD  valign="top" width="15%">
									<%
										String url="";
										if("hp".equals(id)){
											url="/homepage/maint/HomepageLocation.jsp";
										} else if("sys".equals(mmenutype)){
											url="/systeminfo/menuconfig/MenuMaintFrame.jsp?type="+id;
										} else {
											url="MenuEdit.jsp?id="+id+"&menutype="+menutype+"&subCompanyId="+subCompanyId;
										}
									%>
									<%if("sys".equals(mmenutype)){ 
										/*if(!HeadMenuhasRight){
											out.print(menuname);
										}else{*/
									%>	
									<a href="<%=url%>" target="_parent">					
										<%=menuname%>
									</a>
									<%}else{ %>
									<a href="<%=url%>">					
										<%=menuname%>
									</a>
									<%} %>
								</TD>
								<TD  valign="top" width="55%">
									<%=MenuCenterCominfo.getMenuDesc()%>
								</TD>
								<TD  valign="top" width="15%">
										<%
										if("sys".equals(mmenutype)) 
											out.println(SystemEnv.getHtmlLabelName(468,user.getLanguage()));
										else
											out.println(SystemEnv.getHtmlLabelName(19516,user.getLanguage()));
									%>
								</TD>
								<%if(//1==user.getUID()&&
										menutype.equals("2")) {%>
								<TD  valign="top" width="15%">
										<%
										if(!"sys".equals(mmenutype)&&SubMenuRight) 
										 out.println("<a href='javascript:onTran("+subCompanyId+","+id+")'>"+SystemEnv.getHtmlLabelName(80,user.getLanguage())+"</a>");	
										else{
											out.println(SystemEnv.getHtmlLabelName(80,user.getLanguage()));	
										}
										
									%>
								</TD>
								<%}%>
							</TR>					
						<%}}%>
						
						</TABLE>	
					</td>				
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
			</table>
	    </td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</TABLE>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--
	function onAdd(){
		window.location.href='/page/maint/menu/MenuAdd.jsp?menutype=<%=menutype %>&subCompanyId=<%=subCompanyId%>';
	}

</SCRIPT>

<SCRIPT LANGUAGE="VBSCRIPT">

	sub onTran(subid,menuid)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp")
		
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				'msgbox(id(0)+"_"+id(1))
				targetSubid=id(0)
				url="/page/maint/menu/MenuOperate.jsp?method=tran&srcSubid="&subid&"&tranMenuId="&menuid&"&targetSubid="&targetSubid&"&fromSubid=<%=subCompanyId%>&subCompanyId=<%=subCompanyId%>"
				window.location.replace(url)		
			end if
		end if
	end sub
</SCRIPT>