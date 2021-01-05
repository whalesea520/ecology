<%@page contentType="text/xml; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,
                 weaver.general.Util" %>
<jsp:useBean id="XmlReportManage" class="weaver.report.XmlReportManage" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<HTML>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET"/>
</head>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response);
if(user==null) return;
boolean isRemote = Util.null2String(weaver.file.Prop.getPropValue("xmlreport", "report.remote")).equals("1");
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22377,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY oncontextmenu="return false;">
<!-- 标题 -->
<DIV class="TopTitle" style="margin:0 3px 0 3px" id="divTopTitle">

<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0"  >
  <TBODY>
  <TR>
  <%if(imagefilename != null && !imagefilename.equals("")){%>
    <TD align="left" width="55"><IMG src="<%=imagefilename%>" /></TD>
   <%}%>
    <TD align="left"><SPAN id="BacoTitle" ><%=titlename%></SPAN></TD>
    <TD align="right"> </TD>
    <TD width="5"></TD>    
    <TD align="middle" width="24"><BUTTON class="btnLittlePrint" id="onPrint" title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>" onclick="javascript:window.print();" style="display:none"></BUTTON>
	</TD>
    <%
    if(!needhelp.equals("")){
    %>
    <TD align="middle" width="24"><BUTTON class="btnHelp" style="display:none"></BUTTON></TD>
    <%
    }
    %>
	 <TD align="middle" width="24"><BUTTON class="btnBack" id="onBack" title="<%=SystemEnv.getHtmlLabelName(15408,user.getLanguage())%>" onclick="javascript:history.back();" style="display:none"></BUTTON>
	 </TD>
     <td align="right">
	 <%
    if(true){
    %> <BUTTON class="btnFavorite" id="BacoAddFavorite"
    title="<%=SystemEnv.getHtmlLabelName(18753,user.getLanguage())%>" onclick="window.showModalDialog('/favourite/FavouriteBrowser.jsp')" ></BUTTON><%}%><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	 <img src="/images/help_wev8.gif" style="CURSOR:hand" width="12" onclick="javascript:showHelp()" title="<%=SystemEnv.getHtmlLabelName(275,user.getLanguage())%>" /></td>
     <td width="20"> </td >
  </TR>
  </TBODY>
</TABLE>
</DIV>
<!-- END 标题 -->
<%
String rptName = Util.null2String(request.getParameter("rptName"));
String[] headerStr = (String[]) XmlReportManage.XML_HEADER_INFO.get(rptName);
//System.out.println(headerStr);
String rptDate = "";
if(!isRemote) {
	rs.executeSql("SELECT * FROM XmlReport WHERE rptName='"+rptName+"'");
	if(rs.next()) {
		rptDate = rs.getString("rptDate");
	}
}
%>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10"/>
<col width=""/>
</colgroup>
<tr>
<td height="10" colspan="2"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class="Shadow">
<tr>
<td valign="top">
<%
String listName = headerStr[2];
StringTokenizer st = new StringTokenizer(listName, ",");
int colCnt = st.countTokens();
%>
<TABLE class="ListStyle" cellspacing="1" border="0" >
  <TR class="Header"> 
    <TH colspan="<%=(colCnt+1)%>">
      <P align="left"><%=headerStr[1]%>
      (
      <xsl:if test="''='<%=rptDate%>'">
      <xsl:for-each select="ResultSet">
      <xsl:value-of disable-output-escaping="yes" select="./@CXMKMC" />
      </xsl:for-each>
      </xsl:if>
      <xsl:if test="''!='<%=rptDate%>'">
      <%=rptDate%>
      </xsl:if>
      )
      </P>
    </TH>
  </TR>
  <xsl:for-each select="ResultSet/Record">
  <xsl:if test="position() = 1">
  <xsl:if test="string-length(TableCode1/@VALUE) != 0">
  <TR> 
    <TD colspan="<%=(colCnt+1)%>"><P align="left"><xsl:value-of disable-output-escaping="yes" select="TableCode1/@VALUE" /></P></TD>
  </TR>
  <TR class="Line"><TD colspan="<%=(colCnt+1)%>" ></TD></TR>
  </xsl:if>
  <xsl:if test="string-length(TableCode2/@VALUE) != 0">
  <TR> 
    <TD colspan="<%=(colCnt+1)%>"><P align="left"><xsl:value-of disable-output-escaping="yes" select="TableCode2/@VALUE" /></P></TD>
  </TR>
  <TR class="Line"><TD colspan="<%=(colCnt+1)%>" ></TD></TR>
  </xsl:if>
  <xsl:if test="string-length(TableCode3/@VALUE) != 0">
  <TR> 
    <TD colspan="<%=(colCnt+1)%>"><P align="left"><xsl:value-of disable-output-escaping="yes" select="TableCode3/@VALUE" /></P></TD>
  </TR>
  <TR class="Line"><TD colspan="<%=(colCnt+1)%>" ></TD></TR>
  </xsl:if>
  </xsl:if>
  </xsl:for-each>
    <TR class="Header" align="left">
<%
while (st.hasMoreTokens()) {
%>
    <TD style="TEXT-ALIGN: center"><%=st.nextToken()%></TD>
<%
}
%>
  </TR>
  <TR class="Line"><TD colspan="<%=(colCnt+1)%>" ></TD></TR>
  <TBODY>
  <xsl:for-each select="ResultSet/Record">
  <xsl:if test="position() > 1">
  <TR class=''>
<%
String listValue = headerStr[3];
st = new StringTokenizer(listValue, ",");
while (st.hasMoreTokens()) {
%>
    <TD><xsl:value-of disable-output-escaping="yes" select="<%=st.nextToken()%>/@VALUE" /></TD>  
<%
}
%>
	</TR>
	</xsl:if>
	</xsl:for-each>
</TBODY> 
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
</BODY></HTML>
</xsl:template>
</xsl:stylesheet>