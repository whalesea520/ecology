<%@page import="weaver.cpcompanyinfo.CompanyKeyValue"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.net.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="infoMeth" class="weaver.cpcompanyinfo.CompanyInfoTransMethod" scope="page" />

<%
	int type = Util.getIntValue(Util.null2String(request.getParameter("type")),0);
	// 1--法人，2--董事会，3-即将到期证照，4-股东，5--年检证照
	int showvalue = Util.getIntValue( Util.null2String(request.getParameter("showvalue")),0);
	int companyid=Util.getIntValue( Util.null2String(request.getParameter("companyid")),0);
	String isEnableExtranetHelp = KtreeHelp.getInstance().isEnableExtranetHelp;
	String uri = request.getRequestURI();
	String querystring="";
	String navName = SystemEnv.getHtmlLabelNames(("1".equals(showvalue+"")?"31081":"2".equals(showvalue+"")?"31082":
   "3".equals(showvalue+"")?"31079":"4".equals(showvalue+"")?"31083":"5".equals(showvalue+"")?"31080":""
   ),user.getLanguage()) ;
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="cpcompany"/>
   <jsp:param name="navName" value="<%=navName %>"/>
</jsp:include>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span title='<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>' class="cornerMenu"></span>
		</td>
	</tr>
</table>



<wea:layout >
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("19918",user.getLanguage())%>' attributes="">
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" cellspacing="1"  id="webTable2gd"   style="">
					<colgroup>
							<col width="10%">
							<col width="30%">
							<col width="30%">
							<col width="30%">
					</colgroup>
					
					<tr class="header">
						<td ><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
						<td ><%
										if(1==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31081,user.getLanguage()));
										}else if(2==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31082,user.getLanguage()));
										}else if(3==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31079,user.getLanguage()));
										}else if(4==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31083,user.getLanguage()));
										}else if(5==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31080,user.getLanguage()));
										}
											
									 %></td>
						<td><%=SystemEnv.getHtmlLabelName(26113,user.getLanguage())%></td>
						<td><% 
										if(1==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31796,user.getLanguage()));
										}else if(2==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31796,user.getLanguage()));
										}else if(3==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31029,user.getLanguage()));
										}else if(4==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31796,user.getLanguage()));
										}else if(5==showvalue){
												out.print(SystemEnv.getHtmlLabelName(31030,user.getLanguage()));
										}
						%></td>
					</tr>
					<%
							List list=infoMeth.getStaleValue(showvalue,type,companyid);
							if(null!=list){
							for(int i=0;i<list.size();i++){
								CompanyKeyValue ckvalue=(CompanyKeyValue)list.get(i);
					 %>
			
					<tr class="DataLight">
						<td><%=(i+1) %></td>
						<td ><%=ckvalue.getDesc() %></td>
						<td><%=ckvalue.getValue() %></td>
						<td><%=ckvalue.getDatetime()%></td>
					</tr>
					<%
							}
						}
					 %>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value='<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>' id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doCancel(this)">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

<script type="text/javascript">
function doCancel(){
	parentDialog.close();
	//window.close();
}

function showHelp(){
    /*var pathKey = this.location.pathname;
    //alert(pathKey);
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }*/
    var pathKey = "";
	var __url = this.location.href;
	try {
		var __regexp = new RegExp("http://[^/]+", "gmi");
		__url = __url.replace(__regexp, '');
	} catch (e) {}
	pathKey = encodeURIComponent(__url);
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;

    var isEnableExtranetHelp = <%=isEnableExtranetHelp%>;
    if(isEnableExtranetHelp==1){
    	//operationPage = "http://e-cology.com.cn/formmode/apps/ktree/ktreeHelp.jsp";
    	operationPage = '<%=KtreeHelp.getInstance().extranetUrl%>';
    }
    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=1000,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
function openFavouriteBrowser()
{  
	
	var BacoTitle = jQuery("#BacoTitle");
	var pagename = "";
	var navName = "";
	var fav_uri = "<%=URLEncoder.encode(uri)%>";
	var fav_querystring = "<%=URLEncoder.encode(querystring)%>";
	
	try
	{
			var e8tabcontainer = jQuery("div[_e8tabcontainer='true']",parent.document);
			if(e8tabcontainer.length > 0) 
			{
				fav_uri = escape(parent.window.location.pathname);
				fav_querystring = escape(parent.window.location.search);
				navName = e8tabcontainer.find("#objName").text();
			}else{
				navName = jQuery("#objName").text();
			}
			//alert(fav_uri+"  "+fav_querystring)
	}
	catch(e)
	{
		
	}
	if(BacoTitle)
	{
		pagename = BacoTitle.text();
	}
	if(!pagename){
		pagename = navName;
	}
	pagename = escape(pagename); 
	//window.showModalDialog('/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+pagename+'&fav_uri='+fav_uri+'&fav_querystring='+fav_querystring+'&mouldID=doc');
	var e8tabcontainer2 = jQuery("div[_e8tabcontainer='true']",parent.document);
	var dialogurl = "";
	if(e8tabcontainer2.length > 0){
		dialogurl = '/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+pagename+'&fav_uri='+fav_uri+'&fav_querystring='+fav_querystring+'&mouldID=doc';
	}else{
		dialogurl = '/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_uri='+fav_uri+'&mouldID=doc';  //fav_pagename和fav_querystring不通过url传值，而通过session获取，避免url过长时，导致问题
	}

	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}
</script>
</BODY></HTML>
