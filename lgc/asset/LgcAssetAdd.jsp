
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String isclose = Util.null2String(request.getParameter("isclose"));
String assortmentid = paraid ;
String assortmentstr = "" ;
String assortmentname = "" ;
assortmentname = Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage());

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
assortmentstr = Util.null2String(request.getParameter("assortmentstr"));
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
<input type="hidden" name="operation" value="addasset">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></wea:item>
          	<wea:item>
          		<INPUT class=InputStyle maxLength=50 size=45 name="assetname" onchange='checkinput("assetname","typeimage")'
          			style="width: 235px;"> 
          		<SPAN id=typeimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
          	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></wea:item>
          	<wea:item>
	          	<span>
		          	<brow:browser viewType="0" name="assetunitid" 
		               	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp"
		               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
		               	completeUrl="/data.jsp?type=-99993" width='267px'>
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
		               	browserSpanValue='<%=(!assortmentname.equals(""))?assortmentname:"0" %>' browserValue='<%=(!assortmentid.equals(""))?assortmentid:"0"  %>'>
		       		</brow:browser>
	       		</span>
	       		
         	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(17039,user.getLanguage())%></wea:item>
          	<wea:item>
          		<INPUT class=InputStyle maxLength=50 size=25 name="salesprice" _noMultiLang="true" ><span>
		          	<brow:browser viewType="0" name="currencyid" 
		               	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp?selectedids=27"
		               	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		               	completeUrl="/data.jsp?type=-99992" width='100px'
		               	browserSpanValue='<%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage()) %>' browserValue='<%=defcurrenyid %>'>
		       		</brow:browser>
	       		</span>
         	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
          	<wea:item>
          		<TEXTAREA class=InputStyle  style="WIDTH: 284px" name=assetremark rows=4></TEXTAREA>
         	</wea:item>
          	<wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></wea:item>
          	<wea:item>
          		<input class=InputStyle  type="file" name=assetimage style='width:284px'>
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
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript >
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
		// parentWin.location = "/lgc/search/LgcProductListInner.jsp?assortmentid=<%=assortmentid%>";
		parentWin._table.reLoad();
		parentWin.refreshTreeNum("<%=assortmentstr%>",true);
		parentWin.closeDialog();
	}
</script>
</BODY>
</HTML>
