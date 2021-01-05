<%--
  Created by IntelliJ IDEA.
  User: sean
  Date: 2006-3-29
  Time: 9:12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(831,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
</HTML>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
        <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30px">
  		<COL>
        <TBODY>
        <TR class=Title>
            <TH colSpan=2>操作说明：
            </TH>
        </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD height="5" colSpan=2></TD></TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD>点击左侧顶级节点可以直接创建第一级资产组；</TD>
        </TR>
        <TR>
          <TD height="5" colSpan=2></TD></TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD>点击左侧资产组名称，右侧会显示点击的资产组信息，顶级节点除外；</TD>
        </TR>
        <TR>
          <TD height="5" colSpan=2></TD></TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD>在资产组信息页面可以进行相关操作，包括：修改、删除、新建同级资产组、新建下级资产组；</TD>
        </TR>
        <TR>
          <TD height="5" colSpan=2></TD></TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD>没有建立资产资料的资产组，均可以建立下级资产组，已经建立资产资料的资产组不能再向下建立下级资产组；</TD>
        </TR>
        <TR>
          <TD height="5" colSpan=2></TD></TR>
        <TR>
          <TD align="right" valign="top" height="20"><li></TD>
          <TD>资产组名称旁边的数量是代表这个资产组底下有多少资产资料，但不包括下级资产组的资产资料。</TD>
        </TR>
        </table>
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
</BODY>
</HTML>
