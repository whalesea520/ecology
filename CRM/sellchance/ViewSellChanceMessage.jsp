
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page"/>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String hidetitle = Util.null2String(request.getParameter("hidetitle"));
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

String isfromtab  = Util.null2String(request.getParameter("isfromtab"),"false");
String targetType =Util.null2String(request.getParameter("targetType"));
String chanceid = Util.null2String(request.getParameter("id"));
String CustomerID = "";
RecordSet2.executeSql("select customerid from CRM_SellChance where id="+chanceid);
if(RecordSet2.next()){
	CustomerID = RecordSet2.getString("customerid");
}
    
/*check right begin*/
RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
	return;
}
RecordSetC.first();
String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;



int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

 if( useridcheck.equals(RecordSetC.getString("agent")) ) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

CustomerStatusCount.setExchangeInfo(chanceid,"CS",user.getUID());
%>


<style type="text/css">
	
</STYLE>
<LINK href="/CRM/css/Contact_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style>
TABLE.ListStyle{width:96%}
TABLE.ListStyle tbody tr td {
	padding:0px;
}
TABLE.ListStyle TR.HeaderForXtalbe{
	display:none;
}
.feedbackshow{width:100%}
.feedbackrelate{border:0px;}
</style>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(isfromtab.equals("false")){ %> 
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="customer"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15153,user.getLanguage()) %>"/>
	</jsp:include>
<%} %>

<div class="zDialog_div_content" style="height:497px;">
	<div id="fbmain" style="width: 100%;overflow: hidden;background: #fff;top:0px;z-index: 100;">
		<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
		<input type="hidden" name="isfromtab" value="<%=isfromtab %>">
		<input type="hidden" name="method1" value="add">
	    <input type="hidden" name="types" value="CS">
		<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
		<input type="hidden" name="sortid" value="<%=chanceid%>">
			<table style="width: 100%;height: auto;margin-top:5px;overflow: hidden;" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="*" valign="top" align="center">
					<textarea  name="ExchangeInfo" style="width: 96%;margin-top:0px;height:80px;overflow: auto;outline:none;"></textarea>
				</td>
			</tr>
			<tr>
				<td width="*" valign="top" align="center">
					<div style="width: 96%;overflow: hidden;margin-bottom: 5px;">
						<div onclick="doFeedback()" class="btn_feedback" style="margin-left: 0px;"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></div>
						<div id="fbdate" style="float: left;margin-left: 10px;line-height:30px;color: #D1D1D1;font-style: italic;display: none;"><%=SystemEnv.getHtmlLabelName(84353,user.getLanguage())%>：<%=TimeUtil.getCurrentDateString()%></div>
						<div id="submitload" style="float:left;margin-top: 6px;margin-bottom: 0px;margin-left: 20px;display: none;"><img src='../images/loading2_wev8.gif' align=absMiddle /></div>
						<div id="fbrelatebtn" _status="0"><%=SystemEnv.getHtmlLabelName(83273,user.getLanguage())%></div>
					</div>
				</td>
			</tr>
			</table>
			
			<TABLE id="extendtable" class=ViewForm style="width: 96%;display: none;" align="center">
				<COLGROUP>
		  			<COL width="30%">
		  			<COL width="70%">
	  			</COLGROUP>
	  			<tr style="height: 1px"><td class=Line colspan=2></td></tr>
	  			<tr>
	  				<td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
	  				<td class=Field>
	  					<brow:browser viewType="0" name="docids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' width="90%" browserSpanValue=""> </brow:browser>
	  				</td>
	  			</tr>
	  			<tr style="height: 1px"><td class=Line colspan=2></td></tr>
			</TABLE>
		</FORM>	
  	</div>
  	
	<div id="maininfo" style="width:100%;" align="center">
  		
		  <%
		    String tableString = "";
			int perpage=10;                                 
			String backfields = " id,creater,createdate,createtime,remark,docids ";
			String fromSql  = " Exchange_Info " ;
			String sqlWhere = " sortid = "+chanceid+" AND type_n='CS' ";
			String orderby = "";
			
			tableString = " <table pagesize=\""+perpage+"\" tabletype=\"none\">"+
						  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"/>"+
			              " <head>"+
			              "	<col width='100%' text='' column=\"id\" otherpara='column:creater+column:createdate+column:createtime+column:remark+column:docids' transmethod=\"weaver.crm.Maint.CRMTransMethod.getMessageContent\"/>"+
			 			  "	</head></table>";
		  
		  %>	
		  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" /> 	
	</div>
</div>

<%if(!targetType.equals("blank")){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>

<%if(isfromtab.equals("false")){ %> 
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>

<script language="javascript">

	var parentWin = null;
	if("<%=isfromtab%>" == "true"){
		parentWin = parent;
	}else{
		parentWin = parent.getParentWindow(window);
	}

	var tempval = "";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var keyword = "<%=SystemEnv.getHtmlLabelName(84354,user.getLanguage())%>";
	var begindate = "<%=TimeUtil.getCurrentDateString()%>";
	$(document).ready(function(){

		$("#maininfo").height($(window).height()-$("#fbmain").height());

		
		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				$("#extendtable").show();
				$(this).attr("_status",1).css("background", "url('../images/btn_up_wev8.png') right no-repeat");
			}else{
				$("#extendtable").hide();
				$(this).attr("_status",0).css("background", "url('../images/btn_down_wev8.png') right no-repeat");
			}
			$("#maininfo").height($(window).height()-$("#fbmain").height());
			layzyFunctionLoad();
		});
		

	});

	
function doFeedback(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}

jQuery(function(){
	if(parent.crmExchange_1){
		parent.crmExchange_1.innerHTML = '';
	}
});


jQuery(function(){
	jQuery("#objName").attr("style","font-size:16px")
});
	
</script>

