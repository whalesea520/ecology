<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CountTypeComInfo" class="weaver.lgc.maintenance.CountTypeComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language="javascript" type="text/javascript">
function initImg(img,w,h){
	var getResize=function(width,height,SCALE_WIDTH,SCALE_HEIGHT){
		var sizes=new Array(2);
		var rate=0;
		if(width<=SCALE_WIDTH && height<=SCALE_HEIGHT){
			sizes[0]=width;
			sizes[1]=height;
			return sizes;
		}
			
		if(width>=height){
			rate=height/width;
			sizes[0]=SCALE_WIDTH;
			sizes[1]=Math.ceil(SCALE_WIDTH*rate);
		}else{//height>width.
			rate=width/height;
			sizes[0]=Math.ceil(SCALE_HEIGHT*rate);
			sizes[1]=SCALE_HEIGHT;
		}
		return sizes;
	}
	var srcImg=new Image();
	srcImg.src=img.src;
	var size=getResize(parseInt(srcImg.width),parseInt(srcImg.height),w,h);
	img.width=size[0];
	img.height=size[1];
}

</script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetid = paraid ;
String assetcountryid = Util.null2String(request.getParameter("assetcountryid")) ;
if (assetcountryid.equals("")) assetcountryid = "-1";
char separator = Util.getSeparator() ;

RecordSet.executeProc("LgcAsset_SelectById",assetid+separator+assetcountryid);
RecordSet.next();

String assetmark = RecordSet.getString("assetmark");
String barcode = RecordSet.getString("barcode");
String seclevel = RecordSet.getString("seclevel");
String assetimageid = RecordSet.getString("assetimageid");
String assettypeid = RecordSet.getString("assettypeid");
String assetunitid = RecordSet.getString("assetunitid");
String replaceassetid = RecordSet.getString("replaceassetid");
String assetversion = RecordSet.getString("assetversion");
String assetattribute = RecordSet.getString("assetattribute");
String counttypeid = RecordSet.getString("counttypeid");
String assortmentid = RecordSet.getString("assortmentid");
String assortmentstr = RecordSet.getString("assortmentstr");
String relatewfid = RecordSet.getString("relatewfid");
String assetname = RecordSet.getString("assetname");
String assetcountyid = RecordSet.getString("assetcountyid");
String startdate = RecordSet.getString("startdate");
String enddate = RecordSet.getString("enddate");
String departmentid = RecordSet.getString("departmentid");
String resourceid = RecordSet.getString("resourceid");
String assetremark = RecordSet.getString("assetremark");
String currencyid = RecordSet.getString("currencyid");
String salesprice = RecordSet.getString("salesprice");
String costprice = RecordSet.getString("costprice");

String dff01 = RecordSet.getString("datefield1");
String dff02 = RecordSet.getString("datefield2");
String dff03 = RecordSet.getString("datefield3");
String dff04 = RecordSet.getString("datefield4");
String dff05 = RecordSet.getString("datefield5");
String nff01 = RecordSet.getString("numberfield1");
String nff02 = RecordSet.getString("numberfield2");
String nff03 = RecordSet.getString("numberfield3");
String nff04 = RecordSet.getString("numberfield4");
String nff05 = RecordSet.getString("numberfield5");
String tff01 = RecordSet.getString("textfield1");
String tff02 = RecordSet.getString("textfield2");
String tff03 = RecordSet.getString("textfield3");
String tff04 = RecordSet.getString("textfield4");
String tff05 = RecordSet.getString("textfield5");
String bff01 = RecordSet.getString("tinyintfield1");
String bff02 = RecordSet.getString("tinyintfield2");
String bff03 = RecordSet.getString("tinyintfield3");
String bff04 = RecordSet.getString("tinyintfield4");
String bff05 = RecordSet.getString("tinyintfield5");

String createrid = RecordSet.getString("createrid");
String createdate = RecordSet.getString("createdate");
String lastmoderid = RecordSet.getString("lastmoderid");
String lastmoddate = RecordSet.getString("lastmoddate");

RecordSetFF.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
RecordSetFF.next();


// 文档总数

DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setItemid(assetid);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ; 
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();


String temStr="";
temStr+="<B>"+SystemEnv.getHtmlLabelName(125,user.getLanguage())+":&nbsp;</B>"+createdate+"&nbsp;&nbsp; <b>"+SystemEnv.getHtmlLabelName(271,user.getLanguage())+":&nbsp;</b>"+Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())+"&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":&nbsp;</B>"+lastmoddate+"&nbsp;&nbsp;<B>"+SystemEnv.getHtmlLabelName(424,user.getLanguage())+":&nbsp;</B>"+Util.toScreen(ResourceComInfo.getResourcename(lastmoderid),user.getLanguage())+"&nbsp;&nbsp;";


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = Util.toScreen("产品",user.getLanguage(),"2")+" : "+assetname +"&nbsp;&nbsp;&nbsp;&nbsp;"+temStr;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

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




<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<% if(HrmUserVarify.checkUserRight("CrmProduct:Add",user)){ %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doClick1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnEdit id=myfun1 accessKey=E  style="display:none" 
onclick='doClick1()' 
name=button1><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16513,user.getLanguage())+",javascript:doClick2(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnEdit id=myfun2 accessKey=E  style="display:none" 
onclick='doClick2()' 
name=button1><U>E</U>-<%=SystemEnv.getHtmlLabelName(16513,user.getLanguage())%></BUTTON>
<% }%>
<!--
<%
if(HrmUserVarify.checkUserRight("LgcAsset:Log",user)){ %>
<BUTTON class=BtnLog id=button2 accessKey=L 
onclick='location.href="/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=51 and relatedid=<%=assetid%>"' 
name=button2><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<% } 
%>
<BUTTON class=Btn id=button3 accessKey=R  name=button3 onclick='location.href="LgcConfiguration.jsp?paraid=<%=assetid%>"'><U>R</U>-<%=SystemEnv.getHtmlLabelName(724,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button4 accessKey=P name=button4><U>P</U>-<%//=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></BUTTON>
<% if (assetattribute.indexOf("2|")!=-1){%>
<BUTTON class=Btn id=button5 accessKey=S onclick='location.href="LgcAssetCrm.jsp?paraid=<%=assetid%>&countryid=<%=assetcountryid%>"' name=button5><U>S</U>-<%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></BUTTON>
<% 
}%>
-->
<TABLE class=ViewForm>
  <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
  <TR> 
    <TD vAlign=top> 
      <!-- Item info -->
<!--
        <TR> 
          <TD>标识</TD>
          <td class=FIELD><%=Util.toScreen(assetmark,user.getLanguage())%></td>
        </TR><tr><td class=Line colspan=3></td></tr>
-->
<!--
        <tr> 
          <td>条形码</td>
          <td class=FIELD><%=Util.toScreen(barcode,user.getLanguage())%> </td>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR> 
          <TD>国家</TD>
          <td class=Field> 
            <%	if (assetcountyid.equals("0")) {%>
            全球 
            <% } else {%>
            <%=Util.toScreen(CountryComInfo.getCountrydesc(assetcountyid),user.getLanguage())%> 
            <%}%>
          </TD>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR> 
          <TD>生效日</TD>
          <TD class=Field><%=Util.toScreen(startdate,user.getLanguage())%></TD>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR> 
          <TD>生效至</TD>
          <TD class=Field><%=Util.toScreen(enddate,user.getLanguage())%></TD>
        </TR><tr><td class=Line colspan=3></td></tr>
        <tr> 
          <td>安全级别</td>
          <td class=Field><%=Util.toScreen(seclevel,user.getLanguage())%></td>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR> 
          <TD>部门</TD>
          <TD class=Field colSpan=2><a  href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a></TD>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR> 
          <TD>人力资源</TD>
          <td class=Field><A    href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A> 
          </td>
        </TR><tr><td class=Line colspan=3></td></tr>
-->
    </TD>
    <TD></TD>
    <TD vAlign=top rowspan="2"> 
      <!-- Remarks -->
      <TABLE class=ViewForm>
        <TBODY> 
        <TR class=Title> 
          <TH>备注</TH>
        </TR>
<tr  style="height: 1px"><td class=Line1 colspan=1></td></tr>
        <TR> 
          <TD vAlign=top><%=Util.toScreen(assetremark,user.getLanguage())%></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=1></td></tr>
        </TBODY> 
      </TABLE>
      <table class=ViewForm>
        <tbody> 
        <tr class=Title> 
          <th>图片</th>
        </tr>
        <tr class=Spacing> 
          <td class=sep2></td>
        </tr>
        <tr> 
          <td> 
            <% if(!assetimageid.equals("") && !assetimageid.equals("0")) {%>
            <img onload="initImg(this,500,500)" border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=assetimageid%>"> 
            <%}%>
          </td>
        </TR><tr style="height: 1px"><td class=Line colspan=1></td></tr>
        </tbody> 
      </table>
<!--
      <table class=ViewForm>
        <colgroup> <col width=120> <tbody> 
        <tr class=Title> 
          <th colspan=2>空闲字段</th>
        </TR><tr><td class=Line colspan=1></td></tr>
        <tr class=Spacing> 
          <td class=Line1 colspan=2></td>
        </TR><tr><td class=Line colspan=1></td></tr>
        <%
	String tmpstr="";
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{
			if (i==1) tmpstr = dff01;
			if (i==2) tmpstr = dff02;
			if (i==3) tmpstr = dff03;
			if (i==4) tmpstr = dff04;
			if (i==5) tmpstr = dff05;
		%>
        <tr> 
          <td><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></td>
          <td class=Field><%=Util.toScreen(tmpstr,user.getLanguage())%></td>
        </TR><tr><td class=Line colspan=1></td></tr>
        <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{
			if (i==1) tmpstr = nff01;
			if (i==2) tmpstr = nff02;
			if (i==3) tmpstr = nff03;
			if (i==4) tmpstr = nff04;
			if (i==5) tmpstr = nff05;
		%>
        <tr> 
          <td><%=RecordSetFF.getString(i*2+20)%></td>
          <td class=Field><%=Util.toScreen(tmpstr,user.getLanguage())%></td>
        </TR><tr><td class=Line colspan=1></td></tr>
        <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{
			if (i==1) tmpstr = tff01;
			if (i==2) tmpstr = tff02;
			if (i==3) tmpstr = tff03;
			if (i==4) tmpstr = tff04;
			if (i==5) tmpstr = tff05;
		%>
        <tr> 
          <td><%=RecordSetFF.getString(i*2+30)%></td>
          <td class=Field><%=Util.toScreen(tmpstr,user.getLanguage())%></td>
        </TR><tr><td class=Line colspan=1></td></tr>
        <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+41).equals("1"))
		{
			if (i==1) tmpstr = bff01;
			if (i==2) tmpstr = bff02;
			if (i==3) tmpstr = bff03;
			if (i==4) tmpstr = bff04;
			if (i==5) tmpstr = bff05;
		%>
        <tr> 
          <td><%=RecordSetFF.getString(i*2+40)%></td>
          <td class=Field> 
            <input type=checkbox  name="bff0<%=i%>" <%if (tmpstr.equals("1")) {%>checked<%}%> disabled>
          </td>
        </TR><tr><td class=Line colspan=1></td></tr>
        <%}
	}
%>
        </tbody> 
      </table>
-->
      <br>
      <br>
      <br>
    </TD>
  </TR>
  <TR> 
    <TD vAlign=top> 
<!--
      <table class=ViewForm>
        <tbody> 
        <tr class=Title> 
          <th>统计报告</th>
        </tr>
        <tr class=Spacing> 
          <td class=Sep3></td>
        </tr>
        <tr> 
          <td> 
            <table cellspacing=0 cellpadding=0 width="100%">
              <tbody> 
              <tr> 
                <td valign=top width="33%"> 
                  <table cellspacing=1 cellpadding=1 width="100%">
                    <tbody> 
                    <tr> 
                      <td> 
                        <table class=Monitor cellspacing=1 cellpadding=0>
                          <tbody> 
                          <tr> 
                            <td width=29><img height=22 
                              src="/images/mtr_account_wev8.gif" width=29 
                              border=0></td>
                            <td class=Entity><a href="LgcAssetCrm.jsp?paraid=<%=assetid%>&countryid=<%=assetcountryid%>">CRM</a></td>
                          </tr>
                          </tbody> 
                        </table>
                      </td>
                    </tr>
                    <tr> 
                      <td> 
                        <table class=Monitor cellspacing=1 cellpadding=0>
                          <tbody> 
                          <tr> 
                            <td width=29><img height=22 
                              src="/images/mtr_trsaction_wev8.gif" 
                              width=29 border=0></td>
                            <td class=Entity><a href="/fna/transaction/FnaTransactionDetail.jsp?tranitemid=<%=assetid%>">交易</a></td>
                          </tr>
                          </tbody> 
                        </table>
                      </td>
                    </tr>
                    </tbody> 
                  </table>
                </td>
                <td valign=top width="33%"> 
                  <table cellspacing=1 cellpadding=1 width="100%">
                    <tbody> 
                    <tr> 
                      <td> 
                        <table class=Monitor cellspacing=1 cellpadding=0>
                          <tbody> 
                          <tr> 
                            <td width=29><img height=22 
                              src="/images/mtr_docs_wev8.gif" width=29 
                              border=0></td>
                            <td class=Entity><a href="/workflow/search/WFRelatedSearch.jsp?relatedid=<%=assetid%>&relatedtype=itemcontract">合同</a></td>
                          </tr>
                          </tbody> 
                        </table>
                      </td>
                    </tr>
                    <tr> 
                      <td> 
                        <table class=Monitor cellspacing=1 cellpadding=0>
                          <tbody> 
                          <tr> 
                            <td width=29><img height=22 
                              src="/images/mtr_docs_wev8.gif" width=29 
                              border=0></td>
							<td class=Entity><A HREF='../../docs/search/DocSearchTemp.jsp?itemid=<%=assetid%>&docstatus=6'>文档(<%=doccount%>)</A></td>
                          </tr>
                          </tbody> 
                        </table>
                      </td>
                    </tr>
                    </tbody> 
                  </table>
                </td>
                <td valign=top width="33%"> 
                  <table cellspacing=1 cellpadding=1 width="100%">
                    <tbody> 
                    <tr> 
                      <td> 
                        <table class=Monitor cellspacing=1 cellpadding=0>
                          <tbody> 
                          <tr> 
                            <td width=29><img height=22 
                              src="/images/mtr_request_wev8.gif" width=29 
                              border=0></td>
                            <td class=Entity>
							<% if(!relatewfid.equals("0")){%><a href="LgcAssetUse.jsp?relatedid=<%=assetid%>&relatewfid=<%=relatewfid%>">使用</a>
							<%} else {%><a href="/workflow/search/WFRelatedSearch.jsp?relatedid=<%=assetid%>&relatedtype=itemusage">使用</a><%}%></td>
                          </tr>
                          </tbody> 
                        </table>
                      </td>
                    </tr>
                    <tr> 
                      <td></td>
                    </tr>
                    </tbody> 
                  </table>
                  
                </td>
              </tr>
              </tbody> 
            </table>
          </td>
        </tr>
        </tbody> 
      </table>
-->	  
      <TABLE class=ViewForm>
        <COLGROUP> <COL width=120> <TBODY> 
        <TR class=Title> 
          <TH colSpan=3>一般</TH>
        </TR>
        <TR class=Spacing  style="height: 1px"> 
          <TD class=Line1 colSpan=3></TD>
        </TR>
<!--
        <TR class=Title> 
          <TH colSpan=3>价格</TH>
        </TR>
        <TR class=Spacing> 
          <TD class=sep2 colSpan=3></TD>
        </TR>

		<TR> 
          <TD style="PADDING-TOP: 6px" vAlign=top>售价</TD>
          <TD> 
            <TABLE class=ListStyle>
              <COLGROUP> <COL span=2> <COL align=right width="30%"> <TBODY> 
              <TR class=Header> 
                <TD>数量</TD>
                <TD>说明</TD>
                <TD>价格</TD>
              </TR>
			  <%
int j=0;
RecordSet.executeProc("LgcAssetPrice_SelectByAsset",assetid+separator+assetcountyid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String pricedesc = RecordSet.getString("pricedesc");
String numfrom = RecordSet.getString("numfrom");
String numto = RecordSet.getString("numto");
String pricecurrencyid = RecordSet.getString("currencyid");
String unitprice = RecordSet.getString("unitprice");
String taxrate = RecordSet.getString("taxrate");
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
	<td><%=Util.toScreen(numfrom,user.getLanguage())%>-<%=Util.toScreen(numto,user.getLanguage())%></td>
      <td><%=Util.toScreen(pricedesc,user.getLanguage())%></td>
      <td align=left><%=Util.toScreen(CurrencyComInfo.getCurrencyname(pricecurrencyid),user.getLanguage())%>&nbsp;<a href="LgcAssetPriceEdit.jsp?paraid=<%=id%>&redirect=1"><%=Util.toScreen(unitprice,user.getLanguage())%></a></td>
</TR>
<%}
%>
              </TBODY> 
            </TABLE>
          </TD>
        </TR>
-->
        <tr> 
          <td>名称</td>
          <td class=FIELD><%=Util.toScreen(assetname,user.getLanguage())%></td>
        </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
        <TR> 
          <TD>基本售价</TD>
          <TD class=Field><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>&nbsp;<%=Util.toScreen(salesprice,user.getLanguage())%></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
<!--
        <TR> 
          <TD>成本</TD>
          <TD class=Field><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>&nbsp;<%=Util.toScreen(costprice,user.getLanguage())%></TD>
        </TR><tr><td class=Line colspan=3></td></tr>
-->
      <!-- Type -->
<!--
        <tr class=Title> 
          <th colspan=2>其它</th>
        </TR><tr><td class=Line colspan=3></td></tr>
        <tr class=Spacing> 
          <td class=sep2 colspan=2></td>
        </TR><tr><td class=Line colspan=3></td></tr>
-->
        <tr> 
          <td>类别</td>
          <td class=Field><%=Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage())%></td>
        </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
        <tr> 
          <td>计量单位</td>
          <td class=Field><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></td>
<!--       
		<tr> 
          <td>替代</td>
          <td class=Field><%=Util.toScreen(AssetComInfo.getAssetName(replaceassetid),user.getLanguage())%> 
          </td>
        </TR><tr><td class=Line colspan=3></td></tr>
        <tr> 
          <td>版本</td>
          <td class=Field><%=Util.toScreen(assetversion,user.getLanguage())%></td>
        </TR><tr><td class=Line colspan=3></td></tr>
        <tr> 
          <td>相关工作流</td>
          <td class=Field>
		  <% if(relatewfid.equals("0")){%>无特定工作流
		  <%} else if(relatewfid.equals("1")){%>资产借用申请 
		  <%} else if(relatewfid.equals("2")){%>会议室使用申请 
		  <%} else if(relatewfid.equals("3")){%>小车使用申请 
		  <%} else if(relatewfid.equals("4")){%>大车使用申请<%}%>
		</td>-->
        </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>

        </tbody> 
      </table>
<!-- 
      <TABLE class=ViewForm>
        <TBODY> 
        <TR class=Title> 
          <TH colSpan=3>属性</TH>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR class=Spacing> 
          <TD class=Line1 colSpan=3></TD>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR> 
          <TD vAlign=top width="33%"> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%">
              <TBODY> 
              <TR> 
                <TD> 
                  <%if (assetattribute.indexOf("1|")!=-1){%>
                  <IMG src="/images/BacoCheck_wev8.gif" border=0> 
                  <%} else {%>
                  <IMG src="/images/BacoCross_wev8.gif" border=0> 
                  <%}%>
                  销售 </TD>
              </TR><tr><td class=Line colspan=3></td></tr>
              </TBODY> 
            </TABLE>
            <table cellspacing=0 cellpadding=0 width="100%">
              <tbody> 
              <tr> 
                <td> 
                  <%if (assetattribute.indexOf("4|")!=-1){%>
                  <IMG src="/images/BacoCheck_wev8.gif" border=0> 
                  <%} else {%>
                  <IMG src="/images/BacoCross_wev8.gif" border=0> 
                  <%}%>
                  网上销售</td>
              </TR><tr><td class=Line colspan=3></td></tr>
              </tbody> 
            </table>
          </TD>
          <TD vAlign=top width="33.33%"> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%">
              <TBODY> 
              <TR> 
                <TD> 
                  <%if (assetattribute.indexOf("2|")!=-1){%>
                  <IMG src="/images/BacoCheck_wev8.gif" border=0> 
                  <%} else {%>
                  <IMG src="/images/BacoCross_wev8.gif" border=0> 
                  <%}%>
                  采购</TD>
              </TR><tr><td class=Line colspan=3></td></tr>
              </TBODY> 
            </TABLE>
            <table cellspacing=0 cellpadding=0 width="100%">
              <tbody> 
              <tr> 
                <td> 
                  <%if (assetattribute.indexOf("5|")!=-1){%>
                  <IMG src="/images/BacoCheck_wev8.gif" border=0> 
                  <%} else {%>
                  <IMG src="/images/BacoCross_wev8.gif" border=0> 
                  <%}%>
                  批号</td>
              </TR><tr><td class=Line colspan=3></td></tr>
              </tbody> 
            </table>
          </TD>
          <TD vAlign=top width="33.33%"> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%">
              <TBODY> 
              <TR> 
                <TD> 
                  <%if (assetattribute.indexOf("3|")!=-1){%>
                  <IMG src="/images/BacoCheck_wev8.gif" border=0><A href="LgcAssetStock.jsp?paraid=<%=assetid%>">库存</A> 
                  <%} else {%>
                  <IMG src="/images/BacoCross_wev8.gif" border=0>库存
                  <%}%>
                </TD>
              </TR><tr><td class=Line colspan=3></td></tr>
              </TBODY> 
            </TABLE>
          </TD>
        </TR><tr><td class=Line colspan=3></td></tr>
        </TBODY> 
      </TABLE>

      <TABLE class=ViewForm>
        <COLGROUP> <COL width=120> <TBODY> 
        <TR class=Title> 
          <TH colSpan=2>财务</TH>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR class=Spacing> 
          <TD class=Sep2 colSpan=2></TD>
        </TR><tr><td class=Line colspan=3></td></tr>
        <TR> 
          <TD>核算方法</TD>
          <td class=Field><%=Util.toScreen(CountTypeComInfo.getCountTypename(counttypeid),user.getLanguage())%></td>
        </TR><tr><td class=Line colspan=3></td></tr>
        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
  </TR><tr><td class=Line colspan=3></td></tr>
  </TBODY> 
</TABLE>
		
  
<table class=ViewForm width="100%">
  <colgroup> <col width="49%"> <col width=10> <col width="49%"> <tbody> 
  <tr> 
    <td colspan=3> 
      <table class=ListStyle>
        <colgroup> <col span=4> <col width=130> <tbody> 
		<tr class=Title> 
          <th colspan=5>国家&nbsp;&nbsp;
		  <% if(HrmUserVarify.checkUserRight("LgcAssetAddOtherCountry:Add",user)){ %>
		  <button class=btnNew id=AddNew accesskey=N          onClick="location.href='LgcAssetAddOtherCountry.jsp?paraid=<%=assetid%>'"><u>N</u>-新</button>
		  <%}%>
		  </th>
        </TR><tr><td class=Line colspan=3></td></tr>
        <tr class=Spacing> 
          <td class=Line1 colspan=5></td>
        </TR><tr><td class=Line colspan=3></td></tr>
        <tr class=Header> 
          <td>国家</td>
          <td>名称</td>
          <td align=middle colspan=2>售价</td>
        </TR><tr><td class=Line colspan=3></td></tr>
<%
	int i=0;
	RecordSet.executeProc("LgcAssetCountry_SByAssetID",assetid);
	while(RecordSet.next()){
	String id = RecordSet.getString("id");
	String othercountryid   = RecordSet.getString("assetcountyid");
	String othercountryassetname = RecordSet.getString("assetname");
	String othercountrycurrencyid = RecordSet.getString("currencyid");
	String othercountrysalesprice = RecordSet.getString("salesprice");
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<td><%	if (othercountryid.equals("0")) {%>
            <a href='LgcAsset.jsp?paraid=<%=assetid%>&assetcountryid=<%=othercountryid%>'>全球</a> 
            <% } else {%>
            <a href='LgcAsset.jsp?paraid=<%=assetid%>&assetcountryid=<%=othercountryid%>'><%=Util.toScreen(CountryComInfo.getCountrydesc(othercountryid),user.getLanguage())%></a>  
            <%}%></td>
    <td><%=Util.toScreen(othercountryassetname,user.getLanguage())%></td>
    <td><b>
	<%=Util.toScreen(CurrencyComInfo.getCurrencyname(othercountrycurrencyid),user.getLanguage())%>&nbsp;
	<%=Util.toScreen(othercountrysalesprice,user.getLanguage())%>
	</b></td>
    <td align=right>
	<% if(HrmUserVarify.checkUserRight("LgcAssetEditOtherCountry:Edit",user)){ %>
	<a href='LgcAssetPrice.jsp?paraid=<%=assetid%>&assetcountryid=<%=othercountryid%>'>编辑</a>&nbsp;&nbsp
	<%}%>
	</td>
</TR><tr><td class=Line colspan=3></td></tr>
<%}
%>
        </tbody>
      </table>
 -->
    </td>
  </tr>
  </tbody>
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
<script type="text/javascript">
function doClick1(){
	location.href="LgcAssetEdit.jsp?paraid=<%=assetid%>&assetcountryid=<%=assetcountryid%>"
}
function doClick2(){
	location.href="LgcAssetAdd.jsp?paraid=<%=assortmentid%>&assetcountryid=<%=assetcountryid%>"
}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY>
</HTML>
