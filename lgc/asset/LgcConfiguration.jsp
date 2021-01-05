<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ConfigurationComInfo" class="weaver.lgc.asset.ConfigurationComInfo" scope="page"/>
<jsp:useBean id="ConfigurationList" class="weaver.lgc.asset.ConfigurationList" scope="page" />
<jsp:useBean id="AssetRelationTypeComInfo" class="weaver.lgc.maintenance.AssetRelationTypeComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;

String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetid = paraid ;
String assetname = Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage());
String assetmark = Util.toScreen(AssetComInfo.getAssetMark(assetid),user.getLanguage());
String view = Util.null2String(request.getParameter("view"));
String direction = Util.null2String(request.getParameter("direction"));
String subitems = Util.null2String(request.getParameter("subitems"));
if (view.equals("")) view="1";
if (direction.equals("")) direction="1";
if (subitems.equals("")) subitems="0";

ConfigurationList.initConfigurationList();

//RecordSet.executeProc("LgcAsset_SelectByAsset",assetid+separator+direction);
//RecordSet.next();

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(724,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(535,user.getLanguage())+"-"+assetname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<% if(HrmUserVarify.checkUserRight("LgcConfigurationAdd:Add",user)){ %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(728,user.getLanguage())+",javascript:button1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=Btn id=button1 accessKey=1  style="display:none" 
onclick='location.href="LgcConfigurationAdd.jsp?paraid=<%=assetid%>&relation=1"' 
name=button1><U>1</U>-<%=SystemEnv.getHtmlLabelName(728,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(596,user.getLanguage())+",javascript:button2.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=Btn id=button2 accessKey=2  style="display:none" 
onclick='location.href="LgcConfigurationAdd.jsp?paraid=<%=assetid%>&relation=2"' 
name=button2><U>2</U>-<%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%></BUTTON>
<% } %>

<FORM name=frmain style="MARGIN-TOP: 5px" action='LgcConfiguration.jsp?paraid=<%=assetid%>' method=post>
  <TABLE class=ViewForm>
    <TBODY> 
<TR><TD class=Line1 colSpan=3></TD></TR>
    <TR> 
<!--      <TD> 
        <INPUT  onclick='OnSubmit()' type=radio <%if (view.equals("1")) {%>CHECKED<%}%> value=1 name=view>
        图表</TD> 
-->
      <TD> 
        <INPUT onclick='OnSubmit()' type=radio <%if (direction.equals("1")) {%>CHECKED<%}%> value=1 name=direction>
        显示: 下级</TD>
     <TD> 
        <INPUT onclick='OnSubmit()' type=radio <%if (direction.equals("2")) {%>CHECKED<%}%> value=2 name=direction>
        显示: 上级</TD>
	  <TD> 
        <input onClick='OnSubmit()' type=checkbox <%if (subitems.equals("1")) {%>CHECKED <%}%>  value=1 name=subitems>
        All levels</TD>
    </TR>
    <TR><TD class=Line colSpan=3></TD></TR>
<!--    <TR> 
      <TD> 
        <INPUT onclick='OnSubmit()' type=radio <%if (view.equals("2")) {%>CHECKED<%}%> value=2 name=view>
        清单</TD>
      <TD> 
        <INPUT onclick='OnSubmit()' type=radio <%if (direction.equals("2")) {%>CHECKED<%}%> value=2 name=direction>
        显示: 上级</TD> 
      <TD>&nbsp;</TD>

    </TR>
-->
    </TBODY> 
  </TABLE>
<%//-----------------------------------------------------------------------------------------%>
<TABLE class=ListStyle cellspacing=1>
<COL width=10>
<COL>
<COL>
<COL width="20%">
<TR class=header >
<TD colspan=4> <B><a href="LgcAsset.jsp?&paraid=<%=assetid%>"><%=assetmark%>-<%=assetname%></a></B> (<%if (direction.equals("1")) {%>上级<%}else{%>下级<%}%>)</TD>
<TD rowspan=6></TD></TR>
<TR class=Header><TD colspan=2><%if (direction.equals("2")) {%>上级<%}else{%>下级<%}%></TD>
<TD colspan=2>配置关系</TD></TR>
<TR class=Line><TD colSpan=4></TD></TR>
<%
int j=0;
ConfigurationList.setConfigurationList(assetid,direction);

while(ConfigurationList.next()){
String configid = ConfigurationList.getConfigurationId();
String subassetid = "";
if (direction.equals("1"))
	subassetid = ConfigurationList.getSubAssetId();
else
	subassetid = ConfigurationList.getSupAssetId();
String relationtypeid = ConfigurationList.getRelationTypeId();
String step = ConfigurationList.getConfigurationStep();
int tdwidth = Util.getIntValue(step)*15 ;
if(step.equals("1")||!subitems.equals("0")){
if(j==0){
		j=1;
%>
<TR class=DataLight>
<%
	}else{
		j=0;
%>
<TR class=DataDark>
<%
}
%>
	<td><%if (step.equals("1")){%><IMG src="../../images/arrownext_wev8.gif"><%}%></td>
	<td><img src="0_wev8.gif" width="<%=tdwidth%>" height="1"><a href="LgcAsset.jsp?&paraid=<%=subassetid%>"><%=Util.toScreen(AssetComInfo.getAssetName(subassetid),user.getLanguage())%></a></td>	<td><a href="../maintenance/LgcAssetRelationTypeEdit.jsp?&id=<%=relationtypeid%>"><%=Util.toScreen(AssetRelationTypeComInfo.getAssetRelationTypename(relationtypeid),user.getLanguage())%></a></td>
    <td>
	<% if(HrmUserVarify.checkUserRight("LgcConfigurationEdit:Edit",user)){ %>
		<a href="LgcConfigurationEdit.jsp?paraid=<%=configid%>&relation=<%=direction%>&assetid=<%=subassetid%>">编辑</a>
	<%}%>
	</td>
</TR>
<%}
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%//-----------------------------------------------------------------------------------------%>
</FORM>
<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
</SCRIPT>
</BODY>
</HTML>