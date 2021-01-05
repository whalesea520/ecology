
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />

<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<%
String resourceids=Util.null2String(request.getParameter("resourceids"));


%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:null,
        objName:"<%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%>",
        mouldID:"<%=MouldIDConst.getID("communicate") %>"
    });
 
 }); 
 
</script>

<BODY style="overflow: hidden;">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:reset_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
		<div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
			       	<li class="defaultTab">
			        	<a href="#" target="tabcontentframe">
			        		<%=TimeUtil.getCurrentTimeString() %>
			        	</a>
			        </li>
			    </ul>
		    	<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box">
	   <div>
			<div class="zDialog_div_content">
			<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="/sms/MutiCustomerBrowser_sms.jsp" method="post">
				<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
				<wea:layout type="4col">
				     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
					      <wea:item><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></wea:item>
					      <wea:item>
					      	<input class="InputStyle" id="name"  type="text" name="name" >
							<input type="hidden" name="pagenum" value=''>
							<input type="hidden" name="resourceids" value="<%=resourceids %>">
					      </wea:item>
					      <wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
					      <wea:item>
					      	<input class="InputStyle" id="engname"  type="text" name="engname" >
					      </wea:item>
					      
					      <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					      <wea:item>
					      	  <select id="type" name="type">
									<option value="" selected></option>
									<%if(!Util.null2String(request.getParameter("sqlwhere")).equals("where t1.type in (3,4)")){
										while(CustomerTypeComInfo.next()){
										%>
										  <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>"><%=CustomerTypeComInfo.getCustomerTypename()%></option>
										<%}%>
									<%}else{
										while(CustomerTypeComInfo.next()){
										if(CustomerTypeComInfo.getCustomerTypeid().equals("3") || CustomerTypeComInfo.getCustomerTypeid().equals("4")){
										%>
										  <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>"><%=CustomerTypeComInfo.getCustomerTypename()%></option>
										<%}}%>
									<%}%>
								</select>
					      </wea:item>
					      <wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
					      <wea:item>
								<brow:browser viewType="0" name="City" browserValue="" 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" 
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  
										completeUrl="/data.jsp?type=58" linkUrl="/hrm/city/HrmCity.jsp?id=" 
										browserSpanValue=""></brow:browser>
					      </wea:item>
					      
					      
						      <wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
						      <wea:item>
						      	 <select id="country1" name="country1">
									<option value=""></option>
									<%
									while(CountryComInfo.next()){
									%>
									  <option value="<%=CountryComInfo.getCountryid()%>"><%=CountryComInfo.getCountryname()%></option>
									  <%}%>
									</select>
						      </wea:item>
						<%if(!user.getLogintype().equals("2")){%>
						      <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						      <wea:item>
						      	<select id="departmentid" name="departmentid">
									<option value=""></option>
									<% while(DepartmentComInfo.next()) {
										String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
									%>
									  <option value=<%=tmpdepartmentid%>><%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
									<% } %>
									</select>
						      </wea:item>
					      <%}%>
					      
					      <wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
					      <wea:item>
					      		<brow:browser viewType="0" name="CustomerSector" browserValue="" 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp" 
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  
										completeUrl="/data.jsp?type=-99995" linkUrl="/CRM/Maint/ListSectorInfo.jsp?id=" 
										browserSpanValue=""></brow:browser>
					      </wea:item>
					       
					      
					 </wea:group>
				</wea:layout>
				</div>

				<div id="dialog">
					<div id='colShow' ></div>
				</div>
				</FORM>
				</div>
				
				 <div id="zDialog_div_bottom" class="zDialog_div_bottom">
					<wea:layout needImportDefaultJsAndCss="false">
						<wea:group context=""  attributes="{'groupDisplay':'none'}">
							<wea:item type="toolbar">
								<input type="button" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
								<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
								<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
						        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
							</wea:item>
						</wea:group>
					</wea:layout>
				</div>
		</div>
	</div>
</div>
</BODY>
</HTML>

<script language="javascript" type="text/javascript">

jQuery(document).ready(function(){
	resizeDialog(document);
	 showMultiDocDialog("<%=resourceids%>");

})

function reset_onclick(){
	$('#name').val("");
	$('#engname').val("");
	$('#type').val("");
	$("#type").selectbox('detach');
	$("#type").selectbox('attach');		
	$('#City').val("");
	$('#Cityspan').html("");
	$('#country1').val("");
	$("#country1").selectbox('detach');
	$("#country1").selectbox('attach');
	<%if(!user.getLogintype().equals("2")){%>
	$('#departmentid').val("");
	$("#departmentid").selectbox('detach');
	$("#departmentid").selectbox('attach');
	<%}%>
	$('#CustomerSector').val("");
	$('#CustomerSectorspan').html("");
	rightMenu.style.visibility='hidden';
}
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
								  
var config = null;
function showMultiDocDialog(selectids){
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%>"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.srcurl = "MutiCustomerBrowserAjax.jsp?src=src";
    config.desturl = "MutiCustomerBrowserAjax.jsp?src=dest";
    config.pagesize = 10;
    config.formId = "SearchForm";
    config.searchAreaId = "e8QuerySearchArea";
    config.selectids = selectids;
    config.okCallbackFn=okCallbackFn;
	try{
		config.dialog = dialog;
	}catch(e){
	
	}
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
    	rightsplugingForBrowser.system_btnok_onclick(config);
    });
    jQuery("#btnclear").bind("click",function(){
    	rightsplugingForBrowser.system_btnclear_onclick(config);
    });
    jQuery("#btncancel").bind("click",function(){
    	rightsplugingForBrowser.system_btncancel_onclick(config);
    });
    jQuery("#btnsearch").bind("click",function(){
    	rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}

function okCallbackFn(config,destMap,json,destMapKeys){
	 var ids="";
	 var names="";
	 var mobiles="";
	 for(var i=0;destMapKeys&&i<destMapKeys.length;i++){
		var key = destMapKeys[i];
		var dataitem = destMap[key];
		var name = dataitem.fullname;
		var mobile=dataitem.mobilephone;
		if(mobile!=""){
     		if(names==""){
     			ids=key;
     			names = name;
     			mobiles=mobile;
     		}else{
     			ids=ids+","+key;
     			names=names + ","+name;
     			mobiles=mobiles + ","+mobile;
     		}
   		}
	}
	try{
		if(config.dialog){
			config.dialog.callback({id:ids,name:names,mobile:mobiles});
		}else{
			window.parent.returnValue = {id:ids,name:names,mobile:mobiles};
			window.parent.close();
		}
	}catch(e){
		window.parent.returnValue = {id:ids,name:names,mobile:mobiles};
		window.parent.close();
	}
}

function btnOnSearch(){
	jQuery("#btnsearch").trigger("click");
	rightMenu.style.visibility='hidden';
}
</script>
