
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.Maint.CustomerContacterComInfo"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page"/>
<link type="text/css" href="/CRM/css/Base_wev8.css" rel=stylesheet>
<script language=javascript src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language=javascript src="/js/checkData_wev8.js"></script>
<script language=javascript src="/CRM/js/customerUtil_wev8.js"></script>
<%
	String customerid = Util.null2String(request.getParameter("customerid"));
	String lastdate = Util.null2String(request.getParameter("lastdate"));
	
	String userid = user.getUID()+"";
	String manager = CustomerInfoComInfo.getCustomerInfomanager(customerid);
	
	boolean canedit = false;
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		//判断是否有编辑该客户商机权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs.getInt("status")==7 || rs.getInt("status")==8){
			canedit = false;
		}
	}
	
	
	if(manager.equals(userid)){
        //客户经理为本人时删除新客户标记
    	CustomerModifyLog.deleteCustomerLog(Util.getIntValue(customerid,-1),user.getUID());
    }
	
	String portalStatus=CustomerService.getFieldValue("portalStatus",customerid);
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="listoperate">
	<a style="margin-left:10px;" href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=customerid%>" title="<%=CustomerInfoComInfo.getCustomerInfoname(customerid) %>" target="_blank"><%=getCrmNameSeptem(CustomerInfoComInfo.getCustomerInfoname(customerid))%></a>
			/
	<a href="javascript:void(0)" onclick="pointerXY(event);openhrm('<%=manager%>');return false;"><%=ResourceComInfo.getLastname(manager)%></a>
</div>
<div class="tabStyle2" id="topMenu">
	<div class="tabitem select2" _type="contact" url="/CRM/data/ViewContactLog.jsp?CustomerID=<%=customerid%>&isfromtab=true&from=mine">
		<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(24973,user.getLanguage())%></A></div>
		<div class="arrow"></div>
	</div>
	<div class="tabitem" _type="contacter" url="/CRM/customer/ContacterCard.jsp?customerid=<%=customerid%>">
		<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></A></div>
		<div class="arrow"></div>
		<div class="tabseprator"></div>
	</div>
	<%if(portalStatus.equals("2")){%>
		<div class="tabitem" _type="message" url="/CRM/data/ViewMessageLog.jsp?customerid=<%=customerid%>&isfromtab=true">
			<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(84344,user.getLanguage())%></A></div>
			<div class="arrow"></div>
			<div class="tabseprator"></div>
		</div>
	<%}%>
	<div class="tabitem" _type="sellchance" url="/CRM/customer/SellChanceCard.jsp?customerid=<%=customerid%>">
		<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></A></div>
		<div class="arrow"></div>
		<div class="tabseprator"></div>
	</div>
	
	<div style="float:right;padding-right:10px;">
		<img class="middle" src="/CRM/images/addContacter_wev8.png" id="contacterImg" onclick="addContacter()" style="cursor: pointer;">
		<input type="button" id="btn_contacter" style="background: url('/CRM/images/addContacter_wev8.png') no-repeat;display:none;" class="addbtn" onclick="addContacter()" _status="1">
		<span id="searchblockspan" style="width:95px;">
			<span class="searchInputSpan" id="searchInputSpan" style="position:relative;top:6px;right:-4px;">
				<input type="text" class="searchInput middle" name="flowTitle" value="" style="vertical-align: top;">
				<span class="middle searchImg" onclick="searchCustomerName()">
					<img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png">
				</span>
			</span>
		</span>
		<span id="advancedSearch" class="advancedSearch middle" style="height: 20px !important;vertical-align: middle"><span><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span></span>
	</div>
</div>
<div id="contentdiv">
	<iframe id='contentframe' src='' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
</div>

<div id="loading" class="loading" align='center'>
	<%=SystemEnv.getHtmlLabelName(81558 ,user.getLanguage()) %>
</div>


<div id="highSearchDiv" name="highSearchDiv" _status="0" class="hide " style="position:fixed; top:55px;right:0px; border: 1px solid #DADADA;border-top:0px;background: #fff;z-index: 999;">
<form name="weaver" id="weaver">					
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
		<!-- 联系记录搜索条件 -->
		<wea:item attributes="{'samePair':'contactTd'}"><%=SystemEnv.getHtmlLabelName(345 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'contactTd'}">
			<input class="w-180" type="text" id="remark" name="remark" />
		</wea:item>
		
		<wea:item attributes="{'samePair':'contactTd'}"><%=SystemEnv.getHtmlLabelName(616	,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'contactTd'}">
			<brow:browser viewType="0" name="manager" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item attributes="{'samePair':'contactTd'}"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
        <wea:item attributes="{'samePair':'contactTd','colspan':'full'}">
        	<span>
	        	<SELECT  id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 115px;">
				  <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3"><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6"><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
	        </span>
			        
        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
				<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
				<SPAN id=fromdatespan ></SPAN>
				<input type="hidden" name="fromdate" id= "fromdate">
				－<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
				<SPAN id=enddatespan ></SPAN>
				<input type="hidden" name="enddate" id="enddate">
			</span>
		</wea:item>
		
		<!-- 联系人搜索条件 -->
		<wea:item attributes="{'samePair':'contacterTd'}"><%=SystemEnv.getHtmlLabelName(413 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'contacterTd'}">
			<input class="w-180" type="text" id="firstname" name="firstname" />
		</wea:item>
		
		
		<wea:item attributes="{'samePair':'contacterTd'}"><%=SystemEnv.getHtmlLabelName(620 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'contacterTd'}">
			<input class="w-180" type="text" id="mobilephone" name="mobilephone" />
		</wea:item>
		
		<wea:item attributes="{'samePair':'contacterTd'}"><%=SystemEnv.getHtmlLabelName(477 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'contacterTd'}">
			<input class="w-180" type="text" id="email" name="email" />
		</wea:item>
		
		<wea:item attributes="{'samePair':'contacterTd'}">IM<%=SystemEnv.getHtmlLabelName(403 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'contacterTd'}">
			<input class="w-180" type="text" id="imcode" name="imcode" />
		</wea:item>
		
		
		<!-- 客户留言搜索条件 -->
		<wea:item attributes="{'samePair':'messageTd'}"><%=SystemEnv.getHtmlLabelName(345 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'messageTd'}">
			<input class="w-180" type="text" id="remarkM" name="remarkM" />
		</wea:item>
		
		<wea:item attributes="{'samePair':'messageTd'}"><%=SystemEnv.getHtmlLabelName(616	,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'messageTd'}">
			<brow:browser viewType="0" name="managerM" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item attributes="{'samePair':'messageTd'}"><%=SystemEnv.getHtmlLabelName(615 ,user.getLanguage())+SystemEnv.getHtmlLabelName(277 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'messageTd','colspan':'full'}">
			<span>
	        	<SELECT  id="datetypeM" name="datetypeM" onchange="onChangetypeM(this)" style="width: 115px;">
				  <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3"><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6"><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
	        </span>
	        
	        <span id="dateTdM" style="margin-left: 10px;padding-top: 5px;">
				<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(fromdatespanM,fromdateM)></BUTTON>&nbsp;
				<SPAN id=fromdatespanM ></SPAN>
				<input type="hidden" name="fromdateM" id= "fromdateM">
				－<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(enddatespanM,enddateM)></BUTTON>&nbsp;
				<SPAN id=enddatespanM ></SPAN>
				<input type="hidden" name="enddateM" id="enddateM">
			</span>
		</wea:item>
		
		<!-- 销售机会搜索条件 -->
		<wea:item attributes="{'samePair':'sellchanceTd'}"><%=SystemEnv.getHtmlLabelName(344 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'sellchanceTd'}">
			<input class="w-180" type="text" id="subject" name="subject" />
		</wea:item>
		
		<wea:item attributes="{'samePair':'sellchanceTd'}"><%=SystemEnv.getHtmlLabelName(2250 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'sellchanceTd'}">
			<INPUT text class=InputStyle maxLength=20 style="width:60px" size=12 id="preyield" name="preyield"     onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' >
	     		-- <INPUT text class=InputStyle maxLength=20 style="width:60px;" size=12 id="preyield_1" name="preyield_1"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()'>
		</wea:item>
		
		<wea:item attributes="{'samePair':'sellchanceTd'}"><%=SystemEnv.getHtmlLabelName(15112 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'sellchanceTd'}">
			<select text class=InputStyle id=sellstatusid name=sellstatusid style="width: 115px;">
			      <option value="" ><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></option>
				    <%  
					    String theid="";
					    String thename="";
					    String sql="select * from CRM_SellStatus where fullname is not null and fullname != ''";
					    rst.executeSql(sql);
					    while(rst.next()){
					        theid = rst.getString("id");
					        thename = rst.getString("fullname");
					%>
					    <option value=<%=theid%>  ><%=thename%></option>
				    <%}%>
			    </select>
		</wea:item>
		
		<wea:item attributes="{'samePair':'sellchanceTd'}"><%=SystemEnv.getHtmlLabelName(2248 ,user.getLanguage()) %></wea:item>
		<wea:item attributes="{'samePair':'sellchanceTd'}">
			<select text class=InputStyle id=endtatusid  name=endtatusid style="width: 115px;">
				    <option value="" ><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></option>
				    <option value=4 > <%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%> </option>
				    <option value=1 > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
				    <option value=2 > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
				    <option value=0 > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
	    	</select>
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="button" class="e8_btn_submit" onclick="submitdata()" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="reset" name="button" onclick="resetCondtion(highSearchDiv)" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>	
</form>	
</div>
<script>
$(document).ready(function(){
	var mainHeight=document.body.clientHeight;
	var operateHeight=$("#topMenu").height();
	$("#contentdiv").height(mainHeight-operateHeight);
	
	createIframeLinster("contentframe");
	
	jQuery("#contacterImg").hide();
	jQuery(".tabitem").click(function(obj){
		jQuery(".tabitem").removeClass("select2");
		$(this).addClass("select2");
		
		if($(this).attr("_type")=="contacter")
			$("#contacterImg").show();
		else
			$("#contacterImg").hide();
		
		hideEle("contactTd","true");
		hideEle("contacterTd","true");
		hideEle("messageTd","true");
		hideEle("sellchanceTd","true");
		showEle($(this).attr("_type")+"Td","true");
		jQuery("#dateTd").hide();
		
		displayLoading(1);
		
		var url=$(this).attr("url");
		$("#contentframe").attr("src",url);
		
		resetCondtion(highSearchDiv);
	});
	
	jQuery(".tabitem:first").click();
	
	$(".searchInput").bind("keypress",function(e){
		if(e.keyCode==13){
			searchCustomerName();
		}
	});
	
	$("#advancedSearch").bind("click",function(event){
		jQuery(this).css("line-height","21px");
		if(jQuery("#highSearchDiv").is(":visible")){
			jQuery("#highSearchDiv").hide();
			return;
		}
		hideEle("contactTd","true");
		hideEle("contacterTd","true");
		hideEle("messageTd","true");
		hideEle("sellchanceTd","true");
		
		var menuType=$(".select2").attr("_type");
		var x=$(this).offset().left
		var y=$(this).offset().top
		$("#highSearchDiv").css("top",y+25);
		$("#highSearchDiv").css("left",0);
		
		showEle(menuType+"Td","true");
		
		jQuery("#highSearchDiv").show();
		
	});
	
	$("#cancel").bind("click",function(event){
		weaver.reset();
		$("#highSearchDiv").hide();
	});
	
	$("#btn_contacter").hover(function(){
		$(this).css("background-image","url('/CRM/images/addContacter_h_wev8.png')");
	},function(){
		$(this).css("background-image","url('/CRM/images/addContacter_wev8.png')");
	});
	
});

function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}

function onChangetypeM(obj){
	if(obj.value == 6){
		jQuery("#dateTdM").show();
	}else{
		jQuery("#dateTdM").hide();
	}
}

function submitdata(){
	var menuType=$(".select2").attr("_type");
	var url = $(".select2").attr("url");
	if("contact" == menuType){
		url += "&keyword="+jQuery("#remark").val()+"&manager="+jQuery("#manager").val()+
			"&datetype="+jQuery("#datetype").val()+
			"&fromdate="+jQuery("#fromdate").val()+"&enddate="+jQuery("#enddate").val();
	}
	if("contacter" == menuType){
		url += "&keyword="+jQuery("#firstname").val()+"&mobilephone="+jQuery("#mobilephone").val()+
			"&email="+jQuery("#email").val()+"&imcode="+jQuery("#imcode").val();
	}
	if("message" == menuType){
		url += "&keyword="+jQuery("#remarkM").val()+"&manager="+jQuery("#managerM").val()+
			"&fromdate="+jQuery("#fromdateM").val()+"&enddate="+jQuery("#enddateM").val();
	}
	if("sellchance" == menuType){
		url += "&keyword="+jQuery("#subject").val()+"&preyield="+jQuery("#preyield").val()+"&preyield_1="+jQuery("#preyield_1").val()+
			"&sellstatusid="+jQuery("#sellstatusid").val()+"&endtatusid="+jQuery("#endtatusid").val();
	}
	$("#contentframe").attr("src",url);
	jQuery("#highSearchDiv").hide();
}
	
function searchCustomerName(){
	
	var keyword =$(".searchInput").val();
	var _type = jQuery(".select2").closest(".tabitem").attr("_type");
	if(_type == "contact"){
		jQuery("#remark").val(keyword);
	}
	if(_type == "contacter"){
		jQuery("#firstname").val(keyword);
	}
	if(_type == "message"){
		jQuery("#remarkM").val(keyword);
	}
	if(_type == "sellchance"){
		jQuery("#subject").val(keyword);
	}
	
	$("#contentframe").attr("src",$(".select2").attr("url")+"&keyword="+keyword);
}

var dialog = null;
function closeDialog(){
	if(dialog){
		dialog.close();
		jQuery(".tabitem[_type='contacter']").click();
	}
}

function addContacter(){
	dialog=getDialog("<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(572,user.getLanguage())%>", 680 , 520);//定义Dialog对象
	dialog.URL = "/CRM/data/AddContacter.jsp?CustomerID=<%=customerid%>";
	dialog.show();
	document.body.click();
}

function getDialog(title, width ,height){
	var dialog =new window.top.Dialog();
    dialog.currentWindow = window; 
    dialog.Modal = true;
    dialog.Drag=true;
	dialog.Width =width?width:680;
	dialog.Height =height?height:420;
	dialog.Title = title;
	return dialog;
}
</script>
<%!
public String getCrmNameSeptem(String name) {
	if(name == null || "".equals(name))return "";
	if(name.length() > 20)return name.substring(0,20)+"...";
	return name;
}

%>

