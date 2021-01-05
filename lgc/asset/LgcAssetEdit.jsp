<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
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
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";

String paraid = Util.null2String(request.getParameter("paraid")) ;
String isclose = Util.null2String(request.getParameter("isclose"));

String assetid = "";
String assetcountryid = "";
String assetremark = "";
String currencyid = "";
String salesprice = "";
String assetunitid = "";
String assortmentid = "";
String assetname = "";
String assetimageid = "";
if(!isclose.equals("1"))
{
	assetid = paraid ;
	assetcountryid = Util.null2String(request.getParameter("assetcountryid")) ;
	char separator = Util.getSeparator() ;
	
	RecordSet.executeProc("LgcAsset_SelectById",assetid+separator+assetcountryid);
	RecordSet.next();
	
	String assetmark = RecordSet.getString("assetmark");
	String barcode = RecordSet.getString("barcode");
	String seclevel = RecordSet.getString("seclevel");
	assetimageid = RecordSet.getString("assetimageid");
	String assettypeid = RecordSet.getString("assettypeid");
	assetunitid = RecordSet.getString("assetunitid");
	String replaceassetid = RecordSet.getString("replaceassetid");
	String assetversion = RecordSet.getString("assetversion");
	String assetattribute = RecordSet.getString("assetattribute");
	String counttypeid = RecordSet.getString("counttypeid");
	assortmentid = RecordSet.getString("assortmentid");
	String assortmentstr = RecordSet.getString("assortmentstr");
	String relatewfid = RecordSet.getString("relatewfid");
	assetname = RecordSet.getString("assetname");
	String assetcountyid = RecordSet.getString("assetcountyid");
	String startdate = RecordSet.getString("startdate");
	String enddate = RecordSet.getString("enddate");
	String departmentid = RecordSet.getString("departmentid");
	String resourceid = RecordSet.getString("resourceid");
	assetremark = RecordSet.getString("assetremark");
	currencyid = RecordSet.getString("currencyid");
	salesprice = RecordSet.getString("salesprice");
	String costprice = RecordSet.getString("costprice");
	String isdefault = RecordSet.getString("isdefault");
	
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
	
	
}else{
	assortmentid = Util.null2String(request.getParameter("assortmentid"));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15115,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM name=weaver action=LgcAssetOperation.jsp?Action=2 method=post enctype="multipart/form-data" >
<input type="hidden" name="assetattribute">
<input type="hidden" name="operation" value="editasset">
<input type="hidden" name="assetid" value="<%=assetid%>">
<input type="hidden" name="assetcountryid" value="<%=assetcountryid%>">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></wea:item>
          	<wea:item><INPUT class=InputStyle maxLength=50 size=45 style="width: 235px;" name="assetname" onchange='checkinput("assetname","typeimage")' value='<%=Util.toScreenToEdit(assetname,user.getLanguage())%>'> <SPAN id=typeimage></SPAN></wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></wea:item>
          	<wea:item>
	          	<span>
		          	<brow:browser viewType="0" name="assetunitid" 
		               	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp?selectedids=1"
		               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
		               	completeUrl="/data.jsp?type=-99993" width='267px'
		               	browserSpanValue='<%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%>' browserValue='<%=Util.toScreen(assetunitid,user.getLanguage())%>'>
		       		</brow:browser>
	       		</span>
         	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
          	<wea:item>
	          	<span>
		          	<brow:browser viewType="0" name="assortmentid" 
		               	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp?newtype=product"
		               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		               	completeUrl="/data.jsp?type=-99994" width='267px'
		               	browserSpanValue='<%=Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage())%>' 
		               	browserValue='<%=assortmentid%>'>
		       		</brow:browser>
	       		</span>
	       		
         	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(17039,user.getLanguage())%></wea:item>
          	<wea:item>
          		<INPUT class=InputStyle maxLength=50 size=25 name="salesprice" _noMultiLang="true" value="<%=Util.toScreenToEdit(salesprice,user.getLanguage())%>"><span>
		          	<brow:browser viewType="0" name="currencyid" 
		               	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp?selectedids=27"
		               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		               	completeUrl="/data.jsp?type=-99992" width='100px'
		               	browserSpanValue='<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage()) %>' browserValue='<%=currencyid%>'>
		       		</brow:browser>
	       		</span>
         	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
          	<wea:item>
          		<TEXTAREA class=InputStyle  style="WIDTH: 284px" name=assetremark rows=4><%=Util.toScreenToEdit(assetremark,user.getLanguage())%></TEXTAREA>
         	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></wea:item>
          	<wea:item>
          		<% if(assetimageid.equals("") || assetimageid.equals("0")) {%> 
              	<input class=InputStyle  type="file" name=assetimage style='width:284px'>
			  	<%} else {%>
          		<img onload="initImg(this,100,100)" border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=assetimageid%>"> 
				<input type="button" onclick="javascript:onDelPic()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>">
				 <% } %>
				<input type="hidden" name="oldassetimage" value="<%=assetimageid%>">
         	</wea:item>
	</wea:group>
</wea:layout>

</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    </td></tr>
	</table>
</div>
</table>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<script language=javascript >

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

function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.weaver.operation.value="delpic";
		document.weaver.submit();
	}
}

	function openNewType()
	{
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/lgc/maintenance/LgcAssortmentAdd.jsp";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(178 ,user.getLanguage()) %>";
		dialog.Width = 420;
		dialog.Height = 250;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function checkSubmit(){
	    if(check_form(weaver,'assetname,assetunitid')){
	        weaver.submit();
	    }
	}
	
	var parentWin = parent.getParentWindow(window);
	if("<%=isclose%>"=="1"){
		// parentWin.location = "/lgc/search/LgcProductListInner.jsp?assortmentid=<%=assortmentid %>";
		parentWin._table.reLoad();
		parentWin.closeDialog();
	}
</script>
</BODY>
</HTML>
