<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(351,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%"></COLGROUP>
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE width="100%">
        <TBODY> 
        <TR class=Title> 
          <TH>统计</TH>
        </TR>
        <TR class=Spacing> 
          <TD class=Line1></TD>
        </TR>
        <TR> 
          <TD><A 
            href="LgcRpAssortmentSum.jsp">种类</A></TD>
        </TR>
        <TR> 
          <TD><a 
        href="LgcRpAssetTypeSum.jsp">类型</a></TD>
        </TR>
        <!-- TR> 
          <TD><a 
        href="http://server-weaver/new/docs/BLRepItems.asp">属性</a></TD>
        </TR -->
        <tr> 
          <td><a 
            href="LgcRpAssetResourceSum.jsp">人力资源</a></td>
        </tr>
        <tr> 
          <td><a 
            href="LgcRpAssetDepartmentSum.jsp">部门</a></td>
        </tr>
        <TR> 
          <TD><A 
            href="LgcRpAssetConfigueSum.jsp">配置类型</A></TD>
        </TR>
        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top>
      <TABLE width="100%">
        <TBODY> 
        <TR class=Title> 
          <TH>资产</TH>
        </TR>
        <TR class=Spacing> 
          <TD class=Line1></TD>
        </TR>
        <tr> 
          <td><a href="/lgc/search/LgcSearch.jsp">搜索</a></td>
        </tr>
        <TR> 
          <TD><A href="/lgc/asset/LgcStockDetailView.jsp">库存</A></TD>
        </TR>
        </TBODY> 
      </TABLE>
    </TD></TR>
  <TR>
    <TD vAlign=top>
      <TABLE width="100%">
        <TBODY></TBODY></TABLE>
      <TABLE width="100%">
        <TBODY> 
        <TR class=Title> 
          <TH>销售</TH>
        </TR>
        <TR class=Spacing> 
          <TD class=Line1></TD>
        </TR>
        <TR> 
          <TD><A href="/lgc/sales/LgcWebSales.jsp">网上订单</A></TD>
        </TR>
        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top>
      <!-- TABLE width="100%">
        <TBODY>
        <TR class=Title>
          <TH>采购</TH></TR>
        <TR class=Spacing>
          <TD class=Line1></TD></TR>
        <TR>
          <TD><A 
            href="http://server-weaver/new/docs/BLTransactions.asp?Topic=P">采购订单</A></TD></TR>
        <TR>
          <TD><A 
        href="http://server-weaver/new/docs/BLPurchase.asp">将采购</A></TD></TR>
        <TR>
          <TD><A 
            href="http://server-weaver/new/docs/BLWorkflow.asp?Topic=P">工作流: 
            采购订单</A></TD></TR></TBODY></TABLE-->
</TD></TR></TBODY></TABLE></BODY></HTML>
