<%@page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil"%>
<%@page import="weaver.cpt.util.CapitalTransUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));
boolean isfromView="viewdetail".equalsIgnoreCase(from);//来自查看明细

%>
<%
String rightStr = "";
if(false){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String needcheck="StockInDate,CptDept_to";
String id = Util.fromScreen(request.getParameter("ids"),user.getLanguage());
boolean isBatch= "batchinstock".equalsIgnoreCase( Util.null2String(request.getParameter("method")));//batchinstock:批量验收入库
String checkstate="0";

int num = 0;
String contactno="";
String buydate="";
String customername="";


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript">
var parentWin=null;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String titleLabel="6050";
if(isfromView){
	titleLabel="367,751";
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(127970,user.getLanguage())%>" />
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(33036,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver method=post action="CapitalInStockOperation.jsp" >
<input name=id type="hidden" value="<%=id%>">
<input name=isbatch type="hidden" value="<%=isBatch?"1":"" %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" id="btn_confirm" value="<%=SystemEnv.getHtmlLabelName(33036,user.getLanguage()) %>" class="e8_btn_top"  onclick="doSubmit(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>


<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(15301,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser width="150" name="CptDept_to" browserValue="" browserSpanValue="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" completeUrl="/data.jsp?type=4"  isMustInput="2" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
		</wea:item>

	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(83579,user.getLanguage())%>" attributes="" >
		<wea:item attributes="{'isTableList':'true'}">
			
			<table Class=ListStyle cellspacing=1 cols=6><COLGROUP>
				<COL width="15%">
                <COL width="15%">
                <COL width="10%">
                <COL width="10%">
                <COL width="10%">
                <COL width="10%">
                <COL width="10%">
			   <tr class=header> 
                    <!--资产资料-->
					<td><%=SystemEnv.getHtmlLabelName(1509,user.getLanguage())%></td>
                    <!--规格型号-->
                    <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
                    <!--单价-->
                    <td><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
                    <!--入库数量-->
                    <td><%=SystemEnv.getHtmlLabelName(15302,user.getLanguage())%></td>
                    <!--实收数量-->
                    <td style="<%=(isfromView&&!"1".equals(checkstate))?"display:none;":"" %>"><%=SystemEnv.getHtmlLabelName(906,user.getLanguage())%></td>
                    <!--发票号码-->
                    <td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
                    <!--存放地点-->
                    <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
			   </tr>
			<%
			
			boolean isLight=false;
				if(Util.null2String(id).startsWith(",")){
					id=id.substring(1,id.length());
				}
				if(Util.null2String(id).endsWith(",")){
					id=id.substring(0,id.length()-1);
				}
				String sql="select m.id as mainid,d.* from uf_CptStockIn_dt1 d,uf_CptStockIn m where m.id=d.mainid and m.id in("+id+") and ( m.ischecked='' or m.ischecked is null )  order by m.id,d.id ";
				RecordSetInner.executeSql(sql);
			while (RecordSetInner.next()){
					String mainid="";
					if(isBatch){
						mainid=Util.null2String(RecordSetInner.getString("mainid"));
					}else{
						mainid=id;
					}
					
					buydate=Util.null2String(RecordSetInner.getString("selectDate"));
					contactno=Util.null2String(RecordSetInner.getString("contractno"));
					customername= CustomerInfoComInfo.getCustomerInfoname(Util.null2String(RecordSetInner.getString("customerid")));
                if(isLight){%>	
                    <TR CLASS=DataDark>
                <%}else{%>
                    <TR CLASS=DataLight>
                <%}%>
                
                <!--资产资料-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen((String)Cpt4modeUtil.getCapitalInfo(RecordSetInner.getString("cpttype")).get("name") ,user.getLanguage())%> 
                <input type="hidden" name="node_<%=num%>_cptid" id="node_<%=num%>_cptid" value='<%=RecordSetInner.getString("cpttype")%>'>
                <input type="hidden" name="node_<%=num%>_mainid" id="node_<%=num%>_mainid" value='<%=mainid %>'>
                <input type="hidden" name="node_<%=num%>_id" id="node_<%=num%>_id" value='<%=RecordSetInner.getString("id")%>'>
                <input type="hidden" name="node_<%=num%>_contractno" id="node_<%=num%>_contractno" value='<%=contactno %>'>
                <input type="hidden" name="node_<%=num%>_customerid" id="node_<%=num%>_customerid" value='<%=RecordSetInner.getString("customerid")%>'>
                <input type="hidden" name="node_<%=num%>_stockindate" id="node_<%=num%>_stockindate" value='<%=buydate %>'>
                </td>
                <!--规格型号-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("capitalspec"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_capitalspec" id="node_<%=num%>_capitalspec" value='<%=RecordSetInner.getString("capitalspec")%>'>
                </td>
                <!--单价-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("price"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_unitprice" id="node_<%=num%>_unitprice" value='<%=RecordSetInner.getString("price")%>'></td>
                <!--入库数量-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("plannumber"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_plannumber" id="node_<%=num%>_plannumber" value='<%=RecordSetInner.getString("plannumber")%>'>
                </td>
                <!--实收数量-->
                <td style="word-break:break-all;<%=(isfromView&&!"1".equals(checkstate))?"display:none;":"" %>" valign="top">
                	<%
                	if(!isfromView){
                		%>
                	<input  name="node_<%=num%>_innumber" id="node_<%=num%>_innumber" value='<%=RecordSetInner.getString("plannumber")%>' onKeyPress="ItemNum_KeyPress()" onBlur='CheckNumInMorePlan("node_<%=num%>_plannumber","node_<%=num%>_innumber","node_<%=num%>_innumberspan")' class="InputStyle" size=6><span class=InputStyle id="node_<%=num%>_innumberspan"></span>
                		<%
                	}else{
                		%>
                		<span><%=Util.getDoubleValue( RecordSetInner.getString("innumber"),0) %></span>
                		<%
                	}
                	%>
                
                </td>
                <!--发票号码-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("Invoice"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_Invoice" id="node_<%=num%>_Invoice" value='<%=RecordSetInner.getString("Invoice")%>'>
                </td>
                <!--存放地点-->
                <td><%=Util.toScreen(RecordSetInner.getString("location"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_location" id="node_<%=num%>_location" value='<%=RecordSetInner.getString("location")%>'>
                </td>
                </tr>

                <%
                needcheck+="," + "node_" + num + "_innumber";
                num++;
                isLight = !isLight;
             }%>
			  </table>
			  <input type="hidden" name="totaldetail" value="<%=num%>">
		</wea:item>
		
	</wea:group>
	
	
	
</wea:layout>


 </form>
 

<script language=javascript>
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var numindex = <%=num %>;
function onShowDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("input[name="+inputename+"]").val());
	if (data!=null){
	    if (data.id != "" && data.id != "0"){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}
function doSubmit(obj) {
   if(check_form(document.weaver,needcheck)) {
	   document.weaver.submit();
	   //检查是否可验收
	   /**
	   jQuery.ajax({
		url : "/cpt/capital/CapitalInstock1Operation.jsp",
		type : "post",
		async : true,
		processData : true,
		data : {"method":"checkstate","checkstateids":'<%=id %>'},
		dataType : "json",
		success: function do4Success(data){
				if(data.msg=="true"){
					obj.disabled = true;
			       $("#btn_confirm").attr("disabled",true);
			       $("#btn_confirm").css("background-color","#F8F8F8");
			       $("#rightMenuIframe").hide();
			       
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83581,user.getLanguage())%>");
					return;
				}
			}
		});
	   **/
   }
}

function CheckNumInMorePlan(getInput1,getInput2,getSpan)
{
   checkinput(getInput2,getSpan);
   innum=eval(document.all(getInput2).value);
   plannum=eval(document.all(getInput1).value);
   if(innum > plannum) {
   document.all(getInput2).value=document.all(getInput1).value;

   }
}

function compare_date(){
	 var time1 =document.getElementById('StockInDateSpan').innerHTML;
	 var time2 =document.all.checked.value;
	 if (time1 != "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"){
		  if(time1!=time2){
	    	 var dateIn = time1.replace(/-/g,"");
	    	 document.all.checked.value = time1;
				if (numindex>0){
			 		for (var i=0;i<numindex;i++){
						if (document.all("node_"+i+"_stockindate").value.replace(/-/g,"")>dateIn){
						    compare_clear();
						    document.getElementById('StockInDateSpan').innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83582,user.getLanguage())%>");
				    		return false;
						}
					}
				} 
		  }
	  }
}

function compare_clear(){
	document.all.StockInDate.value="";
}
</script>



<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDlgARfsh(0);"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
	var contactno='<%=contactno %>';
	var buydate='<%=buydate %>';
	var customername='<%=customername %>';
	$("#contactno_span").html(contactno);
	$("#buydate_span").html(buydate);
	$("#customername_span").html(customername);
});
</script>
<%} %>


<script>
function onReject(obj){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83583,user.getLanguage())%>",function(){
		obj.disabled = true;
       $("#btn_reject").attr("disabled",true);
       $("#btn_reject").css("background-color","#F8F8F8");
       $("#rightMenuIframe").hide();
		jQuery.post(
			"/cpt/capital/CapitalInstock1Operation.jsp",
			{"method":"reject","id":'<%=id %>'},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83585,user.getLanguage())%>",function(){
					try{
						parentWin._table.reLoad();
						updatecptstockinnum("<%=user.getUID() %>");
						window.location.href="/cpt/capital/CapitalBlankTab.jsp?title=<%=SystemEnv.getHtmlLabelName(83575,user.getLanguage())%>&url=/cpt/capital/CptCapitalInstock1tab.jsp?isdialog=1%26id=<%=id %>";
					}catch(e){}
				});
			}
		);
		
	});
}

function onReApply(obj){
	obj.disabled = true;
    $("#btn_reapply").attr("disabled",true);
    $("#btn_reapply").css("background-color","#F8F8F8");
    $("#rightMenuIframe").hide();
	window.location.href="/cpt/capital/CapitalBlankTab.jsp?title=<%=SystemEnv.getHtmlLabelName(83586,user.getLanguage())%>&url=/cpt/capital/CptCapitalInstock1tab.jsp?isdialog=1%26id=<%=id %>";			
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
