<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(682,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(60,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<TABLE class=Form>
  <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%"> <TBODY> 
  <TR> 
    <TD vAlign=top> 
      <TABLE width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH>资产</TH>
        </TR>
        <TR class=Separator> 
          <TD class=sep1></TD>
        </TR>
        <tr> 
          <td><a 
            href="asset/LgcAssetAssortment.jsp">新</a></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/LgcAssortment.jsp">种类</a></td>
        </tr>
        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top> 
      <!-- TABLE width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH>合同</TH>
        </TR>
        <TR class=Separator> 
          <TD class=sep2></TD>
        </TR>
        <tr> 
          <td><a 
            href="http://server-weaver/new/docs/BLContractParameters.asp">参数</a></td>
        </tr>
        <tr> 
          <td><a 
        href="http://server-weaver/new/docs/BLProcesses.asp">生效</a></td>
        </tr>
        <tr> 
          <td><a 
        href="http://server-weaver/new/docs/BLProcesses.asp">附文</a></td>
        </tr>
        </TBODY> 
      </TABLE -->
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th>财务</th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/LgcCountType.jsp">核算方法</a></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/LgcPaymentType.jsp">收付款方式</a></td>
        </tr>
        </tbody> 
      </table>
    </TD>
  </TR>
  <TR> 
    <TD vAlign=top> 
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th>属性</th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td> 
            <p><a 
          href="maintenance/LgcAssetType.jsp">类型</a></p>
          </td>
        </tr>
        <tr> 
          <td><a href="maintenance/LgcAssetUnit.jsp">计量单位</a></td>
        </tr>
        <tr> 
          <td><a href="maintenance/LgcAssetRelationType.jsp">配置类型</a></td>
        </tr>
        </tbody> 
      </table>
    </TD>
    <TD></TD>
    <TD vAlign=top>
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th>库存</th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/LgcWarehouse.jsp">仓库</a></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/LgcStockMode.jsp">进出库方式</a></td>
        </tr>
        <tr> 
          <td><a 
          href="/workflow/request/RequestType.jsp">单据</a></td>
        </tr>
        </tbody> 
      </table>
    </TD>
  </TR>
  <TR> 
    <TD vAlign=top> 
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th>列表</th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td><a 
          href="catalog/LgcCatalogs.jsp">目录</a></td>
        </tr>
        </tbody> 
      </table>
    </TD>
    <TD></TD>
    <TD vAlign=top> 
      <!-- table width="100%">
        <tbody> 
        <tr class=Section> 
          <th>采购</th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td><a 
          href="http://server-weaver/new/docs/BLItemCatalogs.asp">采购单</a></td>
        </tr>
        </tbody> 
      </table -->
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th>销售</th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <tr> 
          <td><a href="sales/LgcWebSales.jsp">网上销售单</a></td>
        </tr>
        </tbody> 
      </table>
    </TD>
  </TR>
  <tr> 
    <td valign=top> 
      <table width="100%">
        <tbody> 
        <tr class=Section> 
          <th>工具</th>
        </tr>
        <tr class=Separator> 
          <td class=sep1></td>
        </tr>
        <!-- tr> 
          <td><a 
        href="http://server-weaver/new/docs/BLSettings.asp">设定</a></td>
        </tr -->
        <tr> 
          <td><a 
          href="maintenance/LgcAttributeMove.jsp">移动－属性</a></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/LgcAssortmentMove.jsp">移动－种类</a></td>
        </tr>
        <tr> 
          <td><a 
          href="maintenance/LgcAssetmarkChg.jsp">更改－标识</a></td>
        </tr>
        </tbody> 
      </table>
    </td>
    <td></td>
    <td valign=top>&nbsp; </td>
  </tr>
  </TBODY> 
</TABLE>
</BODY>
</html>
