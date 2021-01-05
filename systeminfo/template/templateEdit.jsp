
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageCominfo" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int templateId = Util.getIntValue(request.getParameter("id"));
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
int commonTemplet = Util.getIntValue(request.getParameter("commonTemplet"),0);
int userid = 0;
userid = user.getUID();
%>





<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<style>
input{width:340px} 
.colorPicker{vertical-align:middle;margin-left:4px;cursor:pointer}
</style>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>

<body>


<%
String canCustom = pm.getConfig().getString("portal.custom");
String uploadPath = "/TemplateFile/";

String templateName="",topBgColor="",toolbarBgColor="",leftbarBgColor="",leftbarBgImage="",leftbarBgImageH="",leftbarFontColor="";
String logo="", logoBottom="",topBgImage="",toolbarBgImage="";
String isOpen="",isShowMainMenu="";
String menubarBgColor = "";
String menubtnBgColor = "";
String menubtnBgColorActive = "";
String menubtnBgColorHover = "";
String menubtnBorderColorActive = "";
String menubtnBorderColorHover = "";
String menubtnFontColor = "";
String templateTitle = "";
int extendtempletid = 0;
String menuborderbg = "";
String menuInBoldBorderbg = "";
String menuBottomCusbg = "";
String defaultHp ="";
String sql = "SELECT * FROM SystemTemplate WHERE id="+templateId;



//System.out.println(sql);
rs.executeSql(sql);
if(rs.next()){
	templateName = rs.getString("templateName");
	logo = rs.getString("logo");
	logoBottom = rs.getString("logoBottom");
	topBgColor = rs.getString("topBgColor");
	topBgImage = rs.getString("topBgImage");
	toolbarBgColor = rs.getString("toolbarBgColor");
	toolbarBgImage = rs.getString("toolbarBgImage");
	leftbarBgColor = rs.getString("leftbarBgColor");
	leftbarBgImage = rs.getString("leftbarBgImage");
	leftbarBgImageH = rs.getString("leftbarBgImageH");
	leftbarFontColor = rs.getString("leftbarFontColor");
	//leftMenuBgColor = rs.getString("leftMenuBgColor");
	//leftMenuFontColor = rs.getString("leftMenuFontColor");
	isOpen = rs.getString("isOpen").equals("1") ? "1" : "0";
	isShowMainMenu = rs.getString("isShowMainMenu");
	//MainMenu
	menubarBgColor = rs.getString("menubarBgColor");
	menubtnBgColor = rs.getString("menubtnBgColor");
	menubtnBgColorActive = rs.getString("menubtnBgColorActive");
	menubtnBgColorHover = rs.getString("menubtnBgColorHover");
	menubtnBorderColorActive = rs.getString("menubtnBorderColorActive");
	menubtnBorderColorHover = rs.getString("menubtnBorderColorHover");
	menubtnFontColor = rs.getString("menubtnFontColor");
	menuborderbg = rs.getString("menuborderbg");
	menuInBoldBorderbg = rs.getString("menuInBoldBorderbg");
	menuBottomCusbg = rs.getString("menuBottomCusbg");

	templateTitle = rs.getString("templateTitle");

	extendtempletid = Util.getIntValue(rs.getString("extendtempletid"),0);
	defaultHp = rs.getString("defaultHp");
}
//System.out.println("commonTemplet:"+commonTemplet);
//System.out.println("extendtempletid:"+extendtempletid);
if(commonTemplet==1) extendtempletid=0;
if(extendtempletid!=0) {
	rsExtend.executeSql("select extendurl from extendHomepage  where id="+extendtempletid);
	
	if(rsExtend.next())	{	
		String strUrl=Util.null2String(rsExtend.getString("extendurl"))+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+extendtempletid;
		response.sendRedirect(strUrl);			
	    return ;
	}
}
%>


	
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%


RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:preview(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


if(userid==1 || templateId!=1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(event),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"...,javascript:saveAs(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(userid==1 && templateId==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16211,user.getLanguage())+",javascript:resetTemplate(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(templateId!=1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",templateList.jsp?subCompanyId="+subCompanyId+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;




%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="margin:0" name="frmMain" method="post" enctype="multipart/form-data" action="templateOperation.jsp">
<input id="operationType" name="operationType" type="hidden" value="edit"/>
<input name="id" type="hidden" value="<%=templateId%>"/>
<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" id="bgImage" name="bgImage" value=""/>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">

<TABLE class="Shadow">
	<tr>
		<td valign="top">
		
<!--=============================================================-->

<TABLE class=ViewForm>
<COLGROUP>
<COL width="30%">
<COL width="70%">
<TBODY>

<TR>
	<TD>
	<b><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></b>
	</TD>
	<TD class="tdExtend">
	<%   
		
		rsExtend.executeSql("select id,extendname,extendurl from extendHomepage order by extendname,id");
		while(rsExtend.next()){
			int id=Util.getIntValue(rsExtend.getString("id"));
			String extendname=Util.null2String(rsExtend.getString("extendname"));	
			String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
			if("/portal/plugin/homepage/webcustom".equals(extendurl)&&!"true".equals(canCustom)){
				continue;
			}
			
			String strChecked="";
			if(extendtempletid==id) strChecked=" checked ";
			
			if (id == 3) {
				out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">" + SystemEnv.getHtmlLabelName(28112,user.getLanguage()) + "</span>)&nbsp;&nbsp;");
				out.println("<input type='radio' onclick=\"chkExtendClick(this,'/systeminfo/template/templateEdit.jsp?id=" + templateId + "&subCompanyId=" + subCompanyId + "&commonTemplet=1')\" value=\"0\" name=\"extendtempletid\" style=\"width:18px\""  + ((extendtempletid==0) ? " checked " : "") + ">" + SystemEnv.getHtmlLabelName(20621,user.getLanguage()) + "(<span style=\"color:red;\">" + SystemEnv.getHtmlLabelName(31556,user.getLanguage()) + "</span>)&nbsp;&nbsp;");
			} else {
				out.println("<input type='radio' value="+id+" onclick=\"chkExtendClick(this,'"+extendurl+"/setting.jsp?templateId="+templateId+"&subCompanyId="+subCompanyId+"&extendtempletid="+id+"')\"   name='extendtempletid' style=\"width:18px\" "+strChecked+">"+extendname+"(<span style=\"color:red;\">" + SystemEnv.getHtmlLabelName(31556,user.getLanguage()) + "</span>)&nbsp;&nbsp;");								
			}
		}
	%>
	</TD>
</TR>
<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td class=Field>
	<input type="hidden" id="oldTemplateName" value="<%=templateName%>">
	<INPUT class=InputStyle maxLength=50 id="templateName" name="templateName" value="<%=templateName%>" onchange="checkinput('templateName','templateNameImage')">
	<SPAN id="templateNameImage"></SPAN>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<td><%=SystemEnv.getHtmlLabelName(18795,user.getLanguage())%></td>
<td class=Field>
	<INPUT class=InputStyle maxLength=50 id="templateTitle" name="templateTitle" value="<%=templateTitle%>">
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td style=""><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></td>
<td class=Field>
<select id='defaultHp' name='defaultHp'>
	<option value='-1'>&nbsp;</option>
	<%
	pm.setTofirstRow();
	while(pm.next()){
		if("1".equals(pm.getIsUse())&&!"-1".equals(pm.getSubcompanyid())){
			if(defaultHp.equals(pm.getId())){
				out.println("<option value='"+pm.getId()+"' selected>"+pm.getInfoname()+"</option>");
			}else{
				out.println("<option value='"+pm.getId()+"'>"+pm.getInfoname()+"</option>");
			}
		}
	
	} 
	%>
</select>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td>Logo <%=SystemEnv.getHtmlLabelName(22432,user.getLanguage())%></td>
<td class=Field>
	<input type="hidden" name="logoHidden" value="<%=logo%>">
	<%if(logo.equals("") || logo.equals("0")){%>
	<img src="/images/StyleGray/ecologyLogoA_wev8.jpg"/>
	<%}else{%>
	<img src="<%=uploadPath+logo%>">
	<br/><button class="btnDelete" accesskey="D" onclick="deleteBgImage('logo')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button><br/>
	<%}%>
	<br/>
	<input class="inputstyle" type="file" name="logo" value="">
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<td>Logo <%=SystemEnv.getHtmlLabelName(22433,user.getLanguage())%></td>
<td class=Field>
	<input type="hidden" name="logoHidden" value="<%=logo%>">
	<%if((logoBottom.equals("") || logoBottom.equals("0"))){
		if((logo.equals("")||logo.equals("0"))){
			%>
			<img src="/images/StyleGray/ecologyLogoB_wev8.jpg"/>
			<%
		}
	}else{%>
	<img src="<%=uploadPath+logoBottom%>">
	<br/><button class="btnDelete" accesskey="D" onclick="deleteBgImage('logoBottom')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button><br/>
		
	<%}%>
	<br/>
	<input class="inputstyle" type="file" name="logoBottom" value="">
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18152,user.getLanguage())%></td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><INPUT class=InputStyle maxLength=50 id="topBgColor" name="topBgColor" value="<%=topBgColor%>"></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('topBgColor');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="topBgColorTD" style="height:4px;background-color:<%=topBgColor%>;padding:0;"></td></tr>
	</table>
</td>
</tr>
<TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18153,user.getLanguage())%></td>
<td class=Field>
	<input type="hidden" name="topBgImageHidden" value="<%=topBgImage%>">
	<%if(topBgImage.equals("") || topBgImage.equals("0")){%>
		<input class="inputstyle" type="file" name="topBgImage" value="">
	<%}else{%>
		<img src="<%=uploadPath+topBgImage%>" >
		<br/><button class="btnDelete" accesskey="D" onclick="deleteBgImage('topBgImage')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button><br/>
		<input class="inputstyle" type="file" name="topBgImage" value="">
	<%}%>
</td>
</tr>
<TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18154,user.getLanguage())%></td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="toolbarBgColor" name="toolbarBgColor" value="<%=toolbarBgColor%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('toolbarBgColor');" class="colorPicker"></td>
	</tr>
	<tr style="height:4px;"><td id="toolbarBgColorTD" style="height:4px;background-color:<%=toolbarBgColor%>;padding:0;"></td></tr>
	</table>
</td>
</tr>
<TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18155,user.getLanguage())%></td>
<td class=Field>
	<input type="hidden" name="toolbarBgImageHidden" value="<%=toolbarBgImage%>">
	<%if(toolbarBgImage.equals("")){%>
		<img src="/images/StyleGray/toolbarBg_wev8.jpg" width="100" height="28"/>
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('toolbarBgImage')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="toolbarBgImage" value="">
	<%}else if(toolbarBgImage.equals("0")){%>
		<input class="inputstyle" type="file" name="toolbarBgImage" value="">
	<%}else{%>
		<img src="<%=uploadPath+toolbarBgImage%>">
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('toolbarBgImage')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="toolbarBgImage" value="">
	<%}%>
</td>
</tr>
<TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18156,user.getLanguage())%></td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="leftbarBgColor" name="leftbarBgColor" value="<%=leftbarBgColor%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('leftbarBgColor');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="leftbarBgColorTD" style="height:4px;background-color:<%=leftbarBgColor%>;padding:0;"></td></tr>
	</table>
</td>
</tr>
<TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18157,user.getLanguage())%></td>
<td class=Field>
	<input type="hidden" name="leftbarBgImageHidden" value="<%=leftbarBgImage%>">
	<%if(leftbarBgImage.equals("")){%>
		<img src="/images/StyleGray/leftbarBgImage_wev8.jpg" width="100" height="22"/>
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('leftbarBgImage')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="leftbarBgImage" value="">
	<%}else if(leftbarBgImage.equals("0")){%>
		<input class="inputstyle" type="file" name="leftbarBgImage" value="">
	<%}else{%>
		<img src="<%=uploadPath+leftbarBgImage%>">
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('leftbarBgImage')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="leftbarBgImage" value="">
	<%}%>
</td>
</tr>
<TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18157,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18158,user.getLanguage())%>)</td>
<td class=Field>
	<input type="hidden" name="leftbarBgImageHHidden" value="<%=leftbarBgImageH%>">
	<%if(leftbarBgImageH.equals("")){%>
		<img src="/images/StyleGray/leftbarBgImageH_wev8.gif" width="100" height="22"/>
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('leftbarBgImageH')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="leftbarBgImageH" value="">
	<%}else if(leftbarBgImageH.equals("0")){%>
		<input class="inputstyle" type="file" name="leftbarBgImageH" value="">
	<%}else{%>
		<img src="<%=uploadPath+leftbarBgImageH%>">
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('leftbarBgImageH')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="leftbarBgImageH" value="">
	<%}%>
</td>
</tr>
<TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18159,user.getLanguage())%></td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="leftbarFontColor" name="leftbarFontColor" value="<%=leftbarFontColor%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('leftbarFontColor');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="leftbarFontColorTD" style="height:4px;background-color:<%=leftbarFontColor%>;padding:0;"></td></tr>
	</table>
</td>
</tr>
<TR><TD height="10"></TD></TR>
<!--
<tr>
<td>左菜单背景色</td>
<td class=Field><input type="text" class="InputStyle" maxlength="50" id="leftMenuBgColor" name="leftMenuBgColor" value="<%//=leftMenuBgColor%>"/><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('leftMenuBgColor');" class="colorPicker"></td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>

<tr>
<td>左菜单字体颜色</td>
<td class=Field><input type="text" class="InputStyle" maxlength="50" id="leftMenuFontColor" name="leftMenuFontColor" value="<%//=leftMenuFontColor%>"/><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('leftMenuFontColor');" class="colorPicker"></td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
-->
<TR class=Title><TH colSpan=2><%=SystemEnv.getHtmlLabelName(18160,user.getLanguage())%></TH></TR>
<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18161,user.getLanguage())%></td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="menubarBgColor" name="menubarBgColor" value="<%=menubarBgColor%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('menubarBgColor');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="menubarBgColorTD" style="height:4px;background-color:<%=menubarBgColor%>;padding:0;"></td></tr>
	</table>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(18162,user.getLanguage())%></td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="menubtnBgColor" name="menubtnBgColor" value="<%=menubtnBgColor%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('menubtnBgColor');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="menubtnBgColorTD" style="height:4px;background-color:<%=menubtnBgColor%>;padding:0;"></td></tr>
	</table>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18162,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%>)</td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="menubtnBgColorActive" name="menubtnBgColorActive" value="<%=menubtnBgColorActive%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('menubtnBgColorActive');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="menubtnBgColorActiveTD" style="padding:0;height:4px;background-color:<%=menubtnBgColorActive%>;"></td></tr>
	</table>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18162,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18158,user.getLanguage())%>)</td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="menubtnBgColorHover" name="menubtnBgColorHover" value="<%=menubtnBgColorHover%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('menubtnBgColorHover');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="menubtnBgColorHoverTD" style="padding:0;height:4px;background-color:<%=menubtnBgColorHover%>;"></td></tr>
	</table>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18163,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%>)</td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="menubtnBorderColorActive" name="menubtnBorderColorActive" value="<%=menubtnBorderColorActive%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('menubtnBorderColorActive');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="menubtnBorderColorActiveTD" style="height:4px;background-color:<%=menubtnBorderColorActive%>;"></td></tr>
	</table>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18163,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18158,user.getLanguage())%>)</td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="menubtnBorderColorHover" name="menubtnBorderColorHover" value="<%=menubtnBorderColorHover%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('menubtnBorderColorHover');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="menubtnBorderColorHoverTD" style="height:4px;background-color:<%=menubtnBorderColorHover%>;"></td></tr>
	</table>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18164,user.getLanguage())%></td>
<td class=Field>
	<table>
	<tr>
		<td rowspan="2"><input type="text" class="InputStyle" maxlength="50" id="menubtnFontColor" name="menubtnFontColor" value="<%=menubtnFontColor%>"/></td>
		<td><img src="/images/ColorPicker_wev8.gif" onclick="javascript:getColor('menubtnFontColor');" class="colorPicker"></td>
	</tr>
	<tr style="height:1px;"><td id="menubtnFontColorTD" style="height:4px;background-color:<%=menubtnFontColor%>;"></td></tr>
	</table>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(21139,user.getLanguage())%>(201*3)</td>
<td class=Field>
	<input type="hidden" name="menuborderbgHidden" value="<%=menuborderbg%>">
	<%if(menuborderbg.equals("")){%>
		<img src="/images/StyleGray/leftmenuBoxBg_wev8.jpg" width="201" height="3"/>
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('menuborderbg')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="menuborderbg" value="">
	<%}else if(menuborderbg.equals("0")){%>
		<input class="inputstyle" type="file" name="menuborderbg" value="">
	<%}else{%>
		<img src="<%=uploadPath+menuborderbg%>">
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('menuborderbg')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="menuborderbg" value="">
	<%}%>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(21140,user.getLanguage())%>(1*6)</td>
<td class=Field>
	<input type="hidden" name="menuInBoldBorderbgHidden" value="<%=menuInBoldBorderbg%>">
	<%if(menuInBoldBorderbg.equals("")){%>
		<img src="/images/StyleGray/leftmenuToggleHBg_wev8.jpg" width="6" height="1"/>
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('menuInBoldBorderbg')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="menuInBoldBorderbg" value="">
	<%}else if(menuInBoldBorderbg.equals("0")){%>
		<input class="inputstyle" type="file" name="menuInBoldBorderbg" value="">
	<%}else{%>
		<img src="<%=uploadPath+menuInBoldBorderbg%>">
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('menuInBoldBorderbg')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="menuInBoldBorderbg" value="">
	<%}%>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(21141,user.getLanguage())%>(1620*22)</td>
<%

//System.out.println("menuBottomCusbg:"+menuBottomCusbg);
%>
<td class=Field>
	<input type="hidden" name="menuBottomCusbgHidden" value="<%=menuBottomCusbg%>">
	<%if(menuBottomCusbg.equals("")){%>
		<img src="/images/StyleGray/thumbBoxBg_wev8.jpg" width="405" height="6"/>
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('menuBottomCusbg')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="menuBottomCusbg" value="">
	<%}else if(menuBottomCusbg.equals("0")){%>
		<input class="inputstyle" type="file" name="menuBottomCusbg" value="">
	<%}else{%>
		<img src="<%=uploadPath+menuBottomCusbg%>">
		<br/>
		<button class="btnDelete" accesskey="D" onclick="deleteBgImage('menuBottomCusbg')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
		<br/>
		<input class="inputstyle" type="file" name="menuBottomCusbg" value="">
	<%}%>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td style="color:red"><%=SystemEnv.getHtmlLabelName(18165,user.getLanguage())%></td>
<td class=Field><input style="width:20px" type="checkbox" name="isShowMainMenu" value="1" <%if(isShowMainMenu.equals("1")){out.println("checked");}%>/></td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
</TBODY>
</TABLE>
<!--=============================================================-->		
		
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

<script language="javascript">
function getColor(o) {
	var dialogObject = new Object() ;
	var colorValue = "";
	colorValue = window.showModalDialog("ColorPicker.jsp", dialogObject, "dialogWidth:330px; dialogHeight:300px; center:yes; help:no; resizable:no; status:no") ;
	document.getElementById(o).value = (colorValue=="") ? "" : colorValue ;
	document.getElementById(o+"TD").style.backgroundColor = colorValue;
}
function checkSubmit(event){
	event=$.event.fix(event);
	if(check_form(frmMain,"templateName")){
		document.frmMain.submit();
		event.target.disabled = true;
	}
}

function resetTemplate(){
	var str="<%=SystemEnv.getHtmlLabelName(18972,user.getLanguage())%>";
	if(confirm(str)){
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		document.getElementById("operationType").value = "resetTemplate";
		document.frmMain.submit();
	}
}

function saveAs(){
	if(check_form(frmMain,"templateName")){
		if(document.getElementById("templateName").value==document.getElementById("oldTemplateName").value){
			var str="<%=SystemEnv.getHtmlLabelName(18971,user.getLanguage())%>";
			if(confirm(str)){
				document.getElementById("operationType").value = "saveas";
				document.frmMain.submit();
				window.frames["rightMenuIframe"].event.srcElement.disabled = true;
			}
		}else{
			document.getElementById("operationType").value = "saveas";
			document.frmMain.submit();
			window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		}
	}
}

function del(){
	if(<%=isOpen%>=="1"){
		alert("<%=SystemEnv.getHtmlLabelName(18970,user.getLanguage())%>");
		return false;
	}else{
		if(isdel()){
			document.getElementById("operationType").value = "delete";
			document.frmMain.submit();
			window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		}
	}
}

function deleteBgImage(imgStr){
	if(isdel()){
		document.getElementById("operationType").value = "deleteBgImage";
		document.getElementById("bgImage").value = imgStr;
		document.frmMain.submit();
		this.disabled = true;
	}
}

function preview(){
	with(document.forms[0]){
		enctype = "application/x-www-form-urlencoded";
		target = "_blank";
		action = "templatePreview.jsp";
		submit();
		enctype = "multipart/form-data";
		target = "";
		action = "templateOperation.jsp";
	}
}

function chkExtendClick(obj,url){
	if(obj.checked){
		window.location=url;	
	}
}
</script>