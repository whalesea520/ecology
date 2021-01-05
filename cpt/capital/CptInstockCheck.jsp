<%@page import="weaver.cpt.util.CapitalTransUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));

%>
<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:InStockCheck", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}else{
	rightStr = "CptCapital:InStockCheck";
	session.setAttribute("cptuser",rightStr);
}
RecordSet1.executeSql("select cptdetachable from SystemSet");
int detachable=0;
if(RecordSet1.next()){
    detachable=RecordSet1.getInt("cptdetachable");
    session.setAttribute("cptdetachable",String.valueOf(detachable));
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String needcheck="StockInDate,CptDept_to";
String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String checkstate="0";
RecordSet.executeProc("CptStockInMain_SelectByid",id);
RecordSet.next();
checkstate=RecordSet.getString("ischecked");

int num = 0;
String contactno="";
String buydate="";
String customername="";


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script src="/cpt/js/myobserver_wev8.js"></script>
<script type="text/javascript">
var parentWin;
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
String titleLabel="367,751";


String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames(titleLabel,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelNames(titleLabel,user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver method=post action="CapitalInStockOperation.jsp" >
<input name=id type="hidden" value="<%=id%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>


<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(913,user.getLanguage())%></wea:item>
		<wea:item>
			<A href="/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("buyerid")),user.getLanguage())%></a>
					  <INPUT class=InputStyle type=hidden name="BuyerID" value="<%=RecordSet.getString("buyerid")%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="buydate_span"></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(901,user.getLanguage())%></wea:item>
		<wea:item>
			<span id=Checkerspan><A href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("checkerid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("checkerid")),user.getLanguage())%></A></span> 
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></wea:item>
		<wea:item>
				  <SPAN id=StockInDateSpan ><%=Util.null2String( RecordSet.getString("stockindate")) %></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15301,user.getLanguage())%></wea:item>
		<wea:item>
			<span id=CptDept_to><A href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("stockindept")%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentName(RecordSet.getString("stockindept")),user.getLanguage())%></A></span> 
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="contactno_span"></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="customername_span"></span>
			<input type=hidden name=customerid value="<%=RecordSet.getString("supplierid")%>">
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelNames("751,602",user.getLanguage())%></wea:item>
		<wea:item>
			<span><%=new CapitalTransUtil().getCapitalInstockState(checkstate, ""+user.getLanguage())%></span>
		</wea:item>
				
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83579",user.getLanguage())%>' attributes="" >
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
                    <td><%=SystemEnv.getHtmlLabelName(906,user.getLanguage())%></td>
                    <!--发票号码-->
                    <td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
                    <!--存放地点-->
                    <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
			   </tr>
			<%
			
			boolean isLight=false;
				RecordSetInner.executeProc("CptStockInDetail_SByStockid",id);
				
			while (RecordSetInner.next()){
					String mainid="";
						mainid=id;
					
					buydate=Util.null2String(RecordSetInner.getString("selectDate"));
					contactno=Util.null2String(RecordSetInner.getString("contractno"));
					customername= CustomerInfoComInfo.getCustomerInfoname(Util.null2String(RecordSetInner.getString("customerid")));
                if(isLight){%>	
                    <TR CLASS=DataDark>
                <%}else{%>
                    <TR CLASS=DataLight>
                <%}%>
                
                <!--资产资料-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSetInner.getString("cpttype")),user.getLanguage())%> 
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
                <td style="word-break:break-all;" valign="top">
                		<span><%=Util.getDoubleValue( RecordSetInner.getString("innumber"),0) %></span>
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

<div style="height:50px;"></div>
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
	   //检查是否可验收
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
			       document.weaver.submit();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83581",user.getLanguage())%>");
					return;
				}
			}
		});
	   
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
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83582",user.getLanguage())%>");
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
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83583",user.getLanguage())%>',function(){
		obj.disabled = true;
       $("#btn_reject").attr("disabled",true);
       $("#btn_reject").css("background-color","#F8F8F8");
       $("#rightMenuIframe").hide();
		jQuery.post(
			"/cpt/capital/CapitalInstock1Operation.jsp",
			{"method":"reject","id":'<%=id %>'},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83585",user.getLanguage())%>",function(){
					try{
						parentWin._table.reLoad();
						updatecptstockinnum("<%=user.getUID() %>");
						window.location.href="/cpt/capital/CapitalBlankTab.jsp?title=<%=SystemEnv.getHtmlLabelNames("83575",user.getLanguage())%>&url=/cpt/capital/CptCapitalInstock1tab.jsp?isdialog=1%26id=<%=id %>";
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
	window.location.href="/cpt/capital/CapitalBlankTab.jsp?title=<%=SystemEnv.getHtmlLabelNames("83586",user.getLanguage())%>&url=/cpt/capital/CptCapitalInstock1tab.jsp?isdialog=1%26id=<%=id %>";			
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
