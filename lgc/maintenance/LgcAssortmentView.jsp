<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String assortmentid = paraid;

RecordSet.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
RecordSet.next();

String assortmentmark = RecordSet.getString("assortmentmark");
String assortmentname = RecordSet.getString("assortmentname");
String seclevel = RecordSet.getString("seclevel");
String resourceid = RecordSet.getString("resourceid");
String supassortmentid = RecordSet.getString("supassortmentid");
String supassortmentstr = RecordSet.getString("supassortmentstr");
String assortmentremark= RecordSet.getString("assortmentremark");
String assortmentimageid = Util.getFileidOut(RecordSet.getString("assortmentimageid")) ;				 
String subassortmentcount= RecordSet.getString("subassortmentcount");
String assetcount= RecordSet.getString("assetcount");
String tff01name = RecordSet.getString("tff01name");
String tff02name = RecordSet.getString("tff02name");
String tff03name = RecordSet.getString("tff03name");
String tff04name = RecordSet.getString("tff04name");
String tff05name = RecordSet.getString("tff05name");
String nff01name = RecordSet.getString("nff01name");
String nff02name = RecordSet.getString("nff02name");
String nff03name = RecordSet.getString("nff03name");
String nff04name = RecordSet.getString("nff04name");
String nff05name = RecordSet.getString("nff05name");
String dff01name = RecordSet.getString("dff01name");
String dff02name = RecordSet.getString("dff02name");
String dff03name = RecordSet.getString("dff03name");
String dff04name = RecordSet.getString("dff04name");
String dff05name = RecordSet.getString("dff05name");
String bff01name = RecordSet.getString("bff01name");
String bff02name = RecordSet.getString("bff02name");
String bff03name = RecordSet.getString("bff03name");
String bff04name = RecordSet.getString("bff04name");
String bff05name = RecordSet.getString("bff05name");

boolean canedit = HrmUserVarify.checkUserRight("CrmProduct:Add", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(178,user.getLanguage())+" : "+ Util.toScreen(assortmentname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<FORM id=frmain action=LgcAssortmentOperation.jsp method=post enctype="multipart/form-data">

<div>
<% if(canedit) {%>
<BUTTON type="button" class=BtnEdit id=BtnEdit accessKey=E name=BtnEdit onclick='location.href="LgcAssortmentEdit.jsp?paraid=<%=assortmentid%>"'><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON> 
<% } %>
<!--
<% if(HrmUserVarify.checkUserRight("LgcAssortment:Log", user)){%>
<BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 43 and relatedid=<%=assortmentid%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}%>
-->
</div>  

<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation" value="addassortment">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
    <TD vAlign=top><!-- General -->
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=130> <TBODY> 
           <TR class=Spacing style='height:1px'> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
<!--
          <TR> 
            <TD>标识</TD>
            <td class=FIELD> <%=Util.toScreen(assortmentmark,user.getLanguage())%></td>
          </TR>
-->
          <TR> 
		    <td>名称</td>
            <td class=FIELD><%=Util.toScreen(assortmentname,user.getLanguage())%></td>
          </TR>
<!--
          <tr> 
            <td>安全级别</td>
            <td class=Field><%=Util.toScreen(seclevel,user.getLanguage())%></td>
          </tr>
          <tr> 
            <td>人力资源</td><td class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></td>
          </tr>
-->
          </TBODY> 
        </TABLE>
      </TD>
    <TD></TD>
      <TD vAlign=top>
        <table class=ViewForm>
          <colgroup> <col width=130> <tbody> 
           <TR class=Spacing style='height:1px'> 
            <td class=Line1 colspan=2></td>
          </tr>
          <tr> 
            <TD>
			  <% if(!assortmentimageid.equals("") && !assortmentimageid.equals("0")) {%> 
              <img border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=assortmentimageid%>"> 
			  <%}%>
            </TD>
          </tr>
          </tbody> 
        </table>
      </TD>
    </TR></TBODY></TABLE>
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
    <TR class=Title> 
      <TH>备注</TH>
    </TR>
     <TR class=Spacing style='height:1px'> 
      <TD class=Line1></TD>
    </TR>
    <TR> 
      <TD vAlign=top><%=Util.toScreen(assortmentremark,user.getLanguage())%></TD>
    </TR>
    </TBODY> 
  </TABLE>
<!--
<TABLE class=ViewForm>
  <COLGROUP>
  <COL span=2 width="50%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2>空闲字段</TH></TR>
   <TR class=Spacing style='height:1px'>
    <TD class=Sep3 colSpan=2></TD></TR>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
        <TBODY>
        <TR>
          <TD width="15%">文本 1</TD>
          <TD class=Field><%=Util.toScreen(tff01name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>文本 2</TD>
          <TD class=Field><%=Util.toScreen(tff02name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>文本 3</TD>
          <TD class=Field><%=Util.toScreen(tff03name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>文本 4</TD>
          <TD class=Field><%=Util.toScreen(tff04name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>文本 5</TD>
          <TD class=Field><%=Util.toScreen(tff05name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>数字 1</TD>
          <TD class=Field><%=Util.toScreen(nff01name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>数字 2</TD>
          <TD class=Field><%=Util.toScreen(nff02name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>数字 3</TD>
          <TD class=Field><%=Util.toScreen(nff03name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>数字 4</TD>
          <TD class=Field><%=Util.toScreen(nff04name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>数字 5</TD>
          <TD class=Field><%=Util.toScreen(nff05name,user.getLanguage())%></TD></TR></TBODY></TABLE></TD>
    <TD vAlign=top>
      <TABLE class=ViewForm>
        <TBODY>
        <TR>
          <TD width="15%">日期 1</TD>
          <TD class=Field><%=Util.toScreen(dff01name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>日期 2</TD>
          <TD class=Field><%=Util.toScreen(dff02name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>日期 3</TD>
          <TD class=Field><%=Util.toScreen(dff03name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>日期 4</TD>
          <TD class=Field><%=Util.toScreen(dff04name,user.getLanguage())%></TD></TR>
        <TR>
          <TD>日期 5</TD>
          <TD class=Field><%=Util.toScreen(dff05name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>判断 1</TD>
          <TD class=Field><%=Util.toScreen(bff01name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>判断 2</TD>
          <TD class=Field><%=Util.toScreen(bff02name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>判断 3</TD>
          <TD class=Field><%=Util.toScreen(bff03name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>判断 4</TD>
          <TD class=Field><%=Util.toScreen(bff04name,user.getLanguage())%></TD></TR>
        <TR>
            <TD>判断 5</TD>
          <TD class=Field><%=Util.toScreen(bff05name,user.getLanguage())%></TD></TR></TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
-->
	</FORM>
</BODY></HTML>
