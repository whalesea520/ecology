<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="WarehouseComInfo" class="weaver.lgc.maintenance.WarehouseComInfo" scope="page"/>
<jsp:useBean id="StockModeComInfo" class="weaver.lgc.maintenance.StockModeComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String assetid = Util.null2String(request.getParameter("assetid")) ;
String warehouseid = Util.null2String(request.getParameter("warehouseid")) ;
String datestart = Util.null2String(request.getParameter("datestart")) ;
String dateend   = Util.null2String(request.getParameter("dateend")) ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

if (dateend.equals("")) dateend=currentdate;
if (datestart.equals("")) {
	int year = Util.getIntValue(dateend.substring(0,4),0);
	int month = Util.getIntValue(dateend.substring(5,7),0);
	int day = Util.getIntValue(dateend.substring(8,10),0);
	Calendar tempday = Calendar.getInstance();
	tempday.set(year,month-1,day);
	tempday.add(Calendar.MONTH,-1);
	datestart = Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
}

String sqlwhere = "" ;
if(!assetid.equals("")){
		sqlwhere += " where assetid = '" + assetid +"' ";
}
if(!warehouseid.equals("")){
		if(!sqlwhere.equals("")) sqlwhere += " and warehouseid = '" + warehouseid +"' ";
		else sqlwhere += " where warehouseid = '" + warehouseid +"' ";
}

String sqlstr = "select assetid,warehouseid ,stocknum from LgcAssetStock "+sqlwhere + 
				" order by assetid,warehouseid ";

String imagefilename = "/images/hdreport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(748,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
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
		<td valign="top"><FORM NAME=frmain STYLE="margin-bottom:0" action="LgcStockDetailView.jsp" method=post>

  <table class=ViewForm border=0>
    <colgroup> <col width="6%"> <col width="45%"> <col width="6%"> <col width="43%"> 
    <tbody> 
    <tr> 
      <th align=left colspan=4>标准</th>
    </tr>
    <tr class=Spacing> 
      <td class=Line1 colspan=4></td>
    </tr>
    <tr> 
      <td>资产</td>
		<td class=Field>
			<BUTTON class=Browser id=SelectAssetID onClick="onShowAssetID()"></BUTTON> 
			<span id=assetidspan><a href="LgcAsset.jsp?paraid=<%=assetid%>"><%=Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage())%></a></span> 
              <INPUT <input class=InputStyle  type=hidden name=assetid value='<%=assetid%>'></TD>
            </td>
      <td>仓库</td>
      <td class=Field><button class=Browser id=selectwarehouse onClick="onShowWarehouseID()"></button> 
	 <span <input class=InputStyle  id=warehouseidspan><%=Util.toScreen(WarehouseComInfo.getWarehousename(warehouseid),user.getLanguage())%></span> 
      <input <input class=InputStyle  id=warehouseid type=hidden name=warehouseid value=<%=warehouseid%>>
	  </TD>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>日期</td>
     <TD class=Field>
				<BUTTON class=Calendar onclick="getDate(datestartspan,datestart)"></BUTTON> 
              <SPAN id=datestartspan ><%=datestart%></SPAN> 
              <input type="hidden" name="datestart"  value="<%=datestart%>">
			&nbsp;-&nbsp;
			<BUTTON class=Calendar onclick="getDate(dateendspan,dateend)"></BUTTON> 
              <SPAN id=dateendspan ><%=dateend%></SPAN> 
              <input type="hidden" name="dateend"  value="<%=dateend%>">
	 </TD>
      <td>&nbsp;</td>
      <td >&nbsp;</td>
    </TR><tr><td class=Line colspan=4></td></tr>
    </tbody> 
  </table>

  <table class=ListStyle border=0 cellspacing=1>
	  <THEAD>
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="20%">
	  <COL width="10%">
	  <COL width="15%">
	  <COL width="15%">
	  <COL width="20%" align="right">
    <tbody> 
    <tr class=Header> 
      <th colspan=6>详细</th>
    </tr>
    <tr class=Header> 
      <th>资产</th>
      <th>仓库</th>
      <th>编号</th>
      <th>出入库时间</th>
      <th>类型</th>
      <th>数量</th>
    </tr>
    <TR class=Line><TD colSpan=6></TD></TR>
<%
int i=0;
String flagassetid="";
boolean flag=false;

Hashtable htin = new Hashtable() ;
Hashtable htout = new Hashtable() ;


String sqlstr1 = "select assetid, warehouseid, sum(number) sumin from LgcStockInOut a,LgcStockInOutDetail b where a.id=b.inoutid and a.stockdate>='"+datestart+"' and  and modetype = '0' and status='1' ";

RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String tempassetid = RecordSet.getString(1);
	String tempwarehouseid = RecordSet.getString(2);
	String tempstocknum = RecordSet.getString(3);
	htin.put(tempassetid+"_"+tempwarehouseid , tempstocknum) ;
}

sqlstr1 = "select assetid, warehouseid, sum(number) sumin from LgcStockInOut a,LgcStockInOutDetail b where a.id=b.inoutid and a.stockdate>='"+datestart+"' and  and modetype = '1' and status='1' ";

RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String tempassetid = RecordSet.getString(1);
	String tempwarehouseid = RecordSet.getString(2);
	String tempstocknum = RecordSet.getString(3);
	htout.put(tempassetid+"_"+tempwarehouseid , tempstocknum) ;
}

RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String tempassetid = RecordSet.getString(1);
	String tempwarehouseid = RecordSet.getString(2);
	String tempstocknum = RecordSet.getString(3);

	if (flagassetid.equals(tempassetid))  flag=true;
	else  { 
		flag=false;
		flagassetid=tempassetid;
	}
	
	float stocknumbetween=0;
	float begstocknum=0;
	float endstocknum=0;
	
	float sumall = Util.getFloatValue(tempstocknum,0);
	float sumafterstartin=Util.getFloatValue((String)htin.get(tempassetid+"_"+tempwarehouseid) ,0);
	float sumafterstartout=Util.getFloatValue((String)htout.get(tempassetid+"_"+tempwarehouseid) ,0);
	
	begstocknum = sumall-sumafterstartin+sumafterstartout;

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
	<TD><%if(!flag){%><%=Util.toScreen(AssetComInfo.getAssetName(tempassetid),user.getLanguage())%><%}%></TD>
	<TD><%=Util.toScreen(WarehouseComInfo.getWarehousename(tempwarehouseid),user.getLanguage())%></TD>
	<TD></TD>
	<TD></TD>
	<TD>期初</TD>
	<TD><%=Util.getFloatStr(""+begstocknum,3)%></TD>
</TR>
<%
    if((RecordSet.getDBType()).equals("oracle")) {
        sqlstr="select a.id,instockno,outstockno,modetype,stockmodeid,number_n,stockdate,requestid from LgcStockInOut a,LgcStockInOutDetail b,workflow_form c where a.id=b.inoutid and a.stockdate>='"+datestart+"' and a.stockdate<='"+dateend+"' and a.warehouseid = '" + tempwarehouseid +"' and b.assetid = '" + tempassetid +"' and status='1' and to_number(a.modetype)=c.billformid-2 and a.id=c.billid";
    }
    else {
        sqlstr="select a.id,instockno,outstockno,modetype,stockmodeid,number_n,stockdate,requestid from LgcStockInOut a,LgcStockInOutDetail b,workflow_form c where a.id=b.inoutid and a.stockdate>='"+datestart+"' and a.stockdate<='"+dateend+"' and a.warehouseid = '" + tempwarehouseid +"' and b.assetid = '" + tempassetid +"' and status='1' and convert(int,a.modetype)=c.billformid-2 and a.id=c.billid";
    }
	
	RecordSetInner.executeSql(sqlstr);
	while(RecordSetInner.next()){
	String inoutid = RecordSetInner.getString("LgcStockInOut.id");
	String tempinstockno = RecordSetInner.getString("instockno");
	String tempoutstockno = RecordSetInner.getString("outstockno");
	String tempmodetype = RecordSetInner.getString("modetype");
	String tempstockmodeid = RecordSetInner.getString("stockmodeid");
	float tempnum = Util.getFloatValue(RecordSetInner.getString("number_n"));
	String tempstockdate = RecordSetInner.getString("stockdate");
	String temprequestid = RecordSetInner.getString("requestid");
	if (tempmodetype.equals("0")) 
		stocknumbetween +=tempnum;
	else
		stocknumbetween -=tempnum;
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
	<TD></TD>
	<TD></TD>
	<TD><a href="../../workflow/request/ViewRequest.jsp?requestid=<%=temprequestid%>"><%if (tempmodetype.equals("0")) {%><%=tempinstockno%><%}else{%><%=tempoutstockno%><%}%></a></TD>
	<TD><%=tempstockdate%></TD>
	<TD><%=Util.toScreen(StockModeComInfo.getStockModename(tempstockmodeid),user.getLanguage())%></TD>
	<TD><%=tempnum%></TD>
</TR>
<%}//inner while
	endstocknum = begstocknum+stocknumbetween;
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
	<TD></TD>
	<TD></TD>
	<TD></TD>
	<TD></TD>
	<TD>期末</TD>
	<TD><%=Util.getFloatStr(""+endstocknum,3)%></TD>
</TR>
<%
}// while
%>
   </tbody> 
  </table>
</FORM>
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
<SCRIPT language=VBS>
/////////////////////////////////////////////////////////////////////////////////
sub onShowAssetID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assetidspan.innerHtml = "<a href='LgcAsset.jsp?paraid="+id(0)+"'>"+id(1)+"</a>"
	frmain.assetid.value=id(0)
	else 
	assetidspan.innerHtml = ""
	frmain.assetid.value=""
	end if
	end if
end sub

sub onShowWarehouseID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcWarehouseBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		warehouseidspan.innerHtml = id(1)
		frmain.warehouseid.value=id(0)
		else
		warehouseidspan.innerHtml = ""
		frmain.warehouseid.value= ""
		end if
	end if
end sub
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>