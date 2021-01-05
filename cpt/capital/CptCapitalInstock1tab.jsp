<%@page import="weaver.filter.XssUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CptDetailColumnUtil" class="weaver.cpt.util.CptDetailColumnUtil" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%

String isDialog = Util.null2String(request.getParameter("isdialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String from = Util.null2String(request.getParameter("from"));
String applyid = Util.null2String(request.getParameter("applyid"));
String type = Util.null2String(request.getParameter("type"));


String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:InStock", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}else{
	rightStr = "CptCapital:InStock";
	session.setAttribute("cptuser",rightStr);
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String needcheck="BuyerID,CheckerID,StockInDate";


String id = Util.null2String(request.getParameter("id"));//编辑入库单
boolean isOldBill=(Util.getIntValue(id,0)>0);
String BuyerID="";
String StockInDate_gz="";
String CheckerID="";
String StockInDate="";
String contractno="";
String customerid="";
String ischecked="0";

if(isOldBill){
	String sql="select distinct m.*,d.SelectDate,d.contractno,d.customerid from CptStockInMain m,CptStockInDetail d "+
			" where d.cptstockinid=m.id and m.id="+id+" and m.ischecked in(-2,-1) ";
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		ischecked=RecordSet.getString("ischecked");
		BuyerID=RecordSet.getString("buyerid");
		StockInDate_gz=RecordSet.getString("SelectDate");
		CheckerID=RecordSet.getString("checkerid");
		StockInDate=RecordSet.getString("StockInDate");
		contractno=RecordSet.getString("contractno");
		customerid=Util.getIntValue( RecordSet.getString("customerid"),0)>0?RecordSet.getString("customerid"):"";
	}
	
	
}else{
	BuyerID=""+user.getUID();
	StockInDate_gz=StockInDate=currentdate;
	CheckerID="";
}



%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script src="/cpt/js/myobserver_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent);
}
if("<%=isclose%>"=="1"){
	try {
		parentWin._table.reLoad();
		updatecptstockinnum("<%=user.getUID() %>",parentWin);
		//parentWin.closeDialog();
	} catch (e) {
	}
}else{
	try {
		updatecptstockinnum("<%=user.getUID() %>");
	} catch (e) {}
}

</script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(751,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver method=post action="CapitalInstock1Operation.jsp" >
<INPUT  type=hidden name="method" value="<%=(isOldBill&&!"-1".equals(ischecked) )?"edit":"add" %>">
<INPUT  type=hidden name="id" value="<%=id %>">
<INPUT  type=hidden name="reapplyflag" value="<%="-1".equals(ischecked)?"1":"" %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" class="e8_btn_top"  onclick="onSubmit()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
</div>


<wea:layout type="4col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(913,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<brow:browser width="150px;" name="BuyerID" browserValue='<%=BuyerID %>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(BuyerID),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" completeUrl="/data.jsp"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></wea:item>
    	<wea:item>
    		<button type=button  class=calendar id=SelectDate onclick="onShowDate(StockInDateSpan_gz,StockInDate_gz)"></BUTTON>&nbsp;
						  <SPAN id="StockInDateSpan_gz" ><%=StockInDate_gz  %></SPAN>
						  <input type="hidden" name="StockInDate_gz" value=<%=StockInDate_gz %>>
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(901,user.getLanguage())%></wea:item>
    	<wea:item>
    		<brow:browser width="150px;" name="CheckerID" browserValue='<%=CheckerID %>' browserSpanValue='<%=ResourceComInfo.getResourcename(CheckerID) %>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" completeUrl="/data.jsp"  isMustInput="2" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></wea:item>
    	<wea:item>
    		<button type=button  class=calendar id=SelectDate onclick="onShowDate(StockInDateSpan,StockInDate)"></BUTTON>&nbsp;
						  <SPAN id="StockInDateSpan" ><%=StockInDate%></SPAN>
						  <input type="hidden" name="StockInDate" value=<%=StockInDate%>>
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></wea:item>
    	<wea:item>
    		<input class="InputStyle" style="width:160px;" type=text name="contactno" id="contactno" value="<%=contractno %>" />
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></wea:item>
    	<wea:item>
	    	<%
			String customerbrowurl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere="+new XssUtil().put("where t1.type=2");
			%>
    		<brow:browser  name="customerid" browserValue='<%=customerid %>' browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname(customerid) %>' browserUrl='<%=customerbrowurl %>' completeUrl="/data.jsp?type=7"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
    	</wea:item>
    </wea:group>
</wea:layout>

<div class="subgroupmain" style="width: 100%;margin-left:0px;"></div>
<script>
	var items=<%=CptDetailColumnUtil.getDetailColumnConf("CptStockInDetail", user) %>;
    var option= {
    		navcolor:"#00cc00",
    		basictitle:"<%=SystemEnv.getHtmlLabelNames("83579",user.getLanguage())%>",
    		toolbarshow:true,
    		openindex:true,
    		colItems:items,
    		useajax:true,
   		 	ajaxurl:'/cpt/capital/CapitalInstock1Operation.jsp',
   		 	ajaxparams:{"method":"loaddetaildata","id":"<%=id %>","from":"<%=from %>","applyid":"<%=applyid %>","type":"<%=type %>"}
    };
    var group1=new WeaverEditTable(option);
    $(".subgroupmain").append(group1.getContainer());
</script>
<input type="hidden" name="dtinfo" id="dtinfo" value=""/>

</form>
<div style="height:50px"></div>

<script language=javascript>
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;


function onSubmit()
{
	var StockInDateSpan_gz = jQuery("#StockInDateSpan_gz").html();
	var StockInDateSpan = jQuery("#StockInDateSpan").html();
	enableAllmenu();
	if(StockInDateSpan < StockInDateSpan_gz ){
		displayAllmenu();
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83582",user.getLanguage())%>");
		return;
	}
	
	var dtinfo= group1.getTableSeriaData();	
	var dtjson= group1.getTableJson();
	if(dtinfo){
		//dtjson[0].unshift("{'test':'null'}");
		var dtmustidx=[1,2,3,6];
		var jsonstr= JSON.stringify(dtjson);
		//console.log("jsonstr:"+jsonstr);
		if(checkdtismust(dtjson,dtmustidx)==false){
			displayAllmenu();
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			return;
		}
		if(check_form(document.weaver,needcheck)) {
			document.weaver.dtinfo.value=jsonstr;
			document.weaver.submit();
		} else {
			displayAllmenu();
		}
	}else{
		displayAllmenu();
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33027,user.getLanguage()) %>");
	}
}

function checkinput1(elementname,spanid){
	var tmpvalue = $GetEle(elementname).value;
	
    if(tmpvalue==undefined)
        tmpvalue=document.getElementById(elementname).value;
 	if(!/^[0-9]*$/.test(tmpvalue)){
       tmpvalue="";
    }
	while(tmpvalue.indexOf(" ") >= 0){
		tmpvalue = tmpvalue.replace(" ", "");
	}
	if(tmpvalue != ""){
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue != ""){
			$GetEle(spanid).innerHTML = "";
		}else{
			$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			//$GetEle(elementname).value = "";
		}
	}else{
		$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		//$GetEle(elementname).value = "";
	}
}
</script>
 <script language="javascript">
 function back()
{
	window.history.back(-1);
}
 

function loadinfo(event,data,name){

	if(name){
		var cptid=$('#'+name).val();
		if(cptid!=''){
				jQuery.ajax({
				url:"/cpt/capital/CptInstock1Ajax.jsp?id="+cptid,
				dataType:"json",
				contentType:"charset=UTF-8", 
				success:function(data){
					$('#'+name).parents('td').first().next('td').find('input[id^=capitalspec]').val(data.spec).trigger('blur')
					.end().next('td').find('input[id^=price]').val(data.price).trigger('blur');
				}
			});
		
		}else{
			$('#'+name).parents('td').first().next('td').find('input[id^=capitalspec]').val('').trigger('blur')
			.end().next('td').find('input[id^=price]').val('').trigger('blur');
		}
		
	}
}
$(function(){
	if("<%=id %>"=="" && "<%=from %>"!="cptalertsearch" ){
		setTimeout("group1.addRow();",100);
	}
});

</script>

<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
