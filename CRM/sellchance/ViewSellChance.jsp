
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetN" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<%@ include file="/CRM/data/uploader.jsp" %>

<%
String chanceid = Util.null2String(request.getParameter("id"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String needRefresh  = Util.null2String(request.getParameter("needRefresh"),"false");
String targetType =Util.null2String(request.getParameter("targetType"));
String status = Util.null2String(request.getParameter("status"));
String CustomerID = "";
RecordSet2.executeSql("select customerid from CRM_SellChance where id="+chanceid);
if(RecordSet2.next()){
	CustomerID = RecordSet2.getString("customerid");
}

RecordSet.executeProc("CRM_SellChance_SelectByID",chanceid);
RecordSet.execute("select * from CRM_SellChance where id = '"+chanceid+"'");
RecordSet.next();
String comefromid =Util.null2String(RecordSet.getString("comefromid"));
String endtatusid =Util.null2String(RecordSet.getString("endtatusid"));
String currencyid =Util.null2String(RecordSet.getString("currencyid"));  
String subject =Util.null2String(RecordSet.getString("subject"));
String comfromname = "";
if(!comefromid.equals("")){
	String sql="select name from WorkPlan where id = "+comefromid;
	RecordSetN.executeSql(sql);
	RecordSetN.next();
	comfromname = RecordSetN.getString("name");
}

int rownum=0;
String needcheck="subject";


RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
	return;
}

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
boolean first = true;
Map paramMap = new HashMap();
paramMap.put("content","where type in (3,4)");
paramMap.put("comefromid","where CustomerID="+CustomerID);
%>

<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<SCRIPT language="javascript" src="/CRM/js/util_wev8.js"></script>
<link rel="stylesheet" href="/CRM/css/Base1_wev8.css"/>
<link rel="stylesheet" href="/CRM/css/Contact1_wev8.css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<style>
.sbHolder{
	display:none;
}

.e8_os{
	display:none;
	height:28px;
}
.browser{
	display:none;
	height:28px;
}
.calendar{
	display: none;
}
.e8_txt{
	height:28px;
	line-height:28px;
}
</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%if(!isfromtab){ %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="customer"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32922,user.getLanguage()) %>"/>
	</jsp:include>
<%} %>
<div class="zDialog_div_content">
<FORM id=weaver name=weaver action="/CRM/sellchance/SellChanceOperation.jsp" method=post  >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="chanceid" value="<%=chanceid%>"> 
<input type="hidden" name="isfromtab" value="<%=isfromtab %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canedit){ %>
			<input class="e8_btn_top middle" onclick="doSave(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			<%} %>
		</td>
	</tr>
</table>
<%
	int rowindex = 0;
	rs.executeProc("CRM_Product_SelectByID",chanceid);
%>


<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">

	<%
		CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
		rst.execute("select t1.*,t2.* from CRM_CustomerDefinFieldGroup t1 left join "+
				"(select groupid,count(groupid) groupcount from CRM_CustomerDefinField where isopen=1 and usetable = 'CRM_SellChance' group by groupid) t2 on t1.id=t2.groupid "+
				"where t1.usetable = 'CRM_SellChance' and t2.groupid is not null order by t1.dsporder asc");
		while(rst.next()){
			String groupid = rst.getString("id");
			int groupcount = Util.getIntValue(rst.getString("groupcount"),0);
			if(0 == groupcount){
				continue;
			}
		%>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(rst.getInt("grouplabel"),user.getLanguage())%>'>
				<%while(comInfo.next()){
					if("CRM_SellChance".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
				%>
					<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
					<wea:item>
						<%if(canedit){%>
							<%=CrmUtil.getHtmlElementSetting(comInfo ,RecordSet.getString(comInfo.getFieldname()) ,Util.null2String(paramMap.get(comInfo.getFieldname())),user , "edit")%>
						<%}%>
						<%=CrmUtil.getHmtlElementInfo(comInfo ,RecordSet.getString(comInfo.getFieldname()) ,user , canedit?"edit":"info")%>
					</wea:item>
				<%}} %>
				
				<%if(first){ %>
					<wea:item><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></wea:item>
					<wea:item>
						<div class='e8_select_txt' id='txtdiv_endtatusid'>
							<%
								switch(Util.getIntValue(endtatusid,-1)){
									case 0:
										out.println(SystemEnv.getHtmlLabelName(1960,user.getLanguage()));
										break;
									case 1:
										out.println(SystemEnv.getHtmlLabelName(15242,user.getLanguage()));
										break;
									case 2:
										out.println(SystemEnv.getHtmlLabelName(498,user.getLanguage()));
										break;
									default:
										out.println("");
										break;
								}
							%>
						
						</div>
						<%if(canedit){ %>
						<select id="endtatusid"  name="endtatusid" style="width:138px" onchange="doUpdate(this,1);">
							<option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
							<option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
							<option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
						</select>
						<%} %>
					</wea:item>
				<%first = false;} %>
			</wea:group>
	<%} %>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15128, user.getLanguage())%>" onclick="addRow();">
			<input type="button" class="delbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteRow1();">
		</wea:item>
		
		
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE class=ListStyle cellspacing=1  cols=7 id="oTable">
			<input type="hidden" name="rownum" value="0">
				<colgroup>
					<col width="5%">
					<col width="20%">
					<col width="10%">
					<col width="20%">
					<col width="15%">
					<col width="10%">
					<col width="20%">
				</colgroup>
					  
				<tr class=header>
					<td class=Field><input type="checkbox" name="node_total" onclick="setCheckState(this)"/></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(2019,user.getLanguage())%></td>
				</tr>
				<%while(rs.next()){
				String productid = rs.getString("productid");
				String assetunitid = rs.getString("assetunitid");
				String salesprice = rs.getString("salesprice");
				String salesnum = rs.getString("salesnum");
				String totelprice = rs.getString("totelprice"); 
				
				%>
			
				<tr class="DataLight">
					<TD class="Field"> 
						<input type='checkbox' name='check_node' value='0'>
					</td>
					<TD class="Field">
						<brow:browser viewType="0" name='<%="productname_"+rowindex%>' 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp"
					         browserValue='<%=productid%>' 
					         browserSpanValue = '<%=Util.toScreen(AssetComInfo.getAssetName(productid),user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					         completeUrl="/data.jsp?type=product" width="150px" ></brow:browser> 
					</TD>
					<TD class=Field > 
						<span id=assetunitid_<%=rowindex%>span><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></span>         			
						<input type="hidden" name="assetunitid_<%=rowindex%>"  id="assetunitid_<%=rowindex%>" value="<%=assetunitid%>" >
					</TD>
			
					<TD class="Field" >
						<brow:browser viewType="0" name='<%="currencyid_"+rowindex%>' 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
					         browserValue='<%=currencyid%>' 
					         browserSpanValue = '<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					         completeUrl="/data.jsp?type=12" width="150px" ></brow:browser> 
					</TD class="Field" >
					<TD class="Field" >
						<input type=text class='InputStyle' id="salesprice_<%=rowindex%>"  name="salesprice_<%=rowindex%>" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("<%=rowindex%>")' size=10 value="<%=salesprice%>">
					</TD> 
					<TD class="Field" >
						<input type="text" class='InputStyle' name="number_<%=rowindex%>" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("<%=rowindex%>")' size=10  value="<%=salesnum%>">
					</TD>
					<TD class="Field" >
						<input type="text" class='InputStyle' id="totelprice_<%=rowindex%>"  name="totelprice_<%=rowindex%>" onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this),sumpreyield()' size=25  value="<%=totelprice%>">
					</TD>
				</tr>
				<%rowindex++;}%>
		     </table>  
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<!-- 提示信息 -->
<div id="warn">
	<div class="title"></div>
</div>
</div>
<div style="height:42px;">
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</div>
<%if(!isfromtab){ %>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script language="JavaScript" src="/js/addRowBg_wev8.js">   
</script>  

<script language=javascript>
var parentWin = null;
if("<%=isfromtab%>" == "true"){
	parentWin = parent;
}else{
	parentWin = parent.getParentWindow(window);
}

$(function(){
	jQuery('body').jNice();
});

function setCheckState(obj){
	var checkboxs = jQuery("input[name='check_node']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
}

function onGetProduct(spanname1,inputename1,spanname2,inputename2,spanname3,inputename3,inputename4,inputename5){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
		if (data.id!=""){
			spanname1.innerHTML = "<A href='/lgc/asset/LgcAsset.jsp?paraid="+wuiUtil.getJsonValueByIndex(data,0)+"'>"+wuiUtil.getJsonValueByIndex(data,1)+"</A>"
			inputename1.value=wuiUtil.getJsonValueByIndex(data,0)
			spanname2.innerHTML = wuiUtil.getJsonValueByIndex(data,3)
			inputename2.value = wuiUtil.getJsonValueByIndex(data,2)
			spanname3.innerHTML = wuiUtil.getJsonValueByIndex(data,5)
			inputename3.value = wuiUtil.getJsonValueByIndex(data,4)
			inputename4.value = wuiUtil.getJsonValueByIndex(data,6)
			inputename5.value = wuiUtil.getJsonValueByIndex(data,6)
		}else{
			spanname1.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			inputename1.value = ""
			spanname2.innerHTML = ""
			inputename2.value = ""
			spanname3.innerHTML = ""
			inputename3.value = ""
			inputename4.value = "0"
			inputename5.value = "0"
		}
	}
}
rowindex = "<%=rowindex%>";
var rowColor="" ;
function addRow(){
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);
	oRow.setAttribute("class","DataLight");
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0' >"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<span id='productname_"+rowindex+"span_n'></span> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				$("#productname_"+rowindex+"span_n").e8Browser({
				   name:"productname_"+rowindex,
				   viewType:"0",
				   browserValue:"0",
				   isMustInput:"2",
				   browserSpanValue:"",
				   hasInput:true,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"/data.jsp?type=product",
				   browserUrl:"/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp",
				   width:"150px",
				   hasAdd:false,
				   _callback:'callBackSelectUpdatePro'
				  });
				  jQuery(".e8_os").show();
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=assetunitid_"+rowindex+"span></span> "+
        					"<input type='hidden' name='assetunitid_"+rowindex+"'  id=assetunitid_"+rowindex+">";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<span id='currencyid_"+rowindex+"span_n'></span> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				
				$("#currencyid_"+rowindex+"span_n").e8Browser({
				   name:"currencyid_"+rowindex,
				   viewType:"0",
				   browserValue:"0",
				   isMustInput:"2",
				   browserSpanValue:"",
				   hasInput:true,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"/data.jsp?type=12",
				   browserUrl:"/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp",
				   width:"150px",
				   hasAdd:false,
				   isSingle:true
				  });	
				  jQuery(".e8_os").show();
				break;             
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='salesprice_"+rowindex+"'  name='salesprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' name='number_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10 value='1'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;               
            case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='totelprice_"+rowindex+"'  name='totelprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this),sumpreyield()' size=25>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
		}
	}
	rowindex = rowindex*1 +1;
	jQuery('body').jNice(); 
}

function deleteRow1(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
		len = document.forms[0].elements.length;
		var i=0;
		var rowsum1 = 0;
	    for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_node')
				rowsum1 += 1;
		} 
		
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_node'){
				if(document.forms[0].elements[i].checked==true) {
					oTable.deleteRow(rowsum1);	
				}
				rowsum1 -=1;
			}	
		}	
	       sumpreyield();
    })
}

function callBackSelectUpdatePro(event,data,fieldId,oldid){
	var number = fieldId.substring(fieldId.indexOf("_")+1);
	jQuery.post("SellChanceOperation.jsp",{"method":"getProductInfo","productId":data.id},function(info){
		info = jQuery.trim(info);
		info = eval('('+info+')');
		jQuery("#assetunitid_"+number).val(info.assetunitid);//单位
		jQuery("#assetunitid_"+number+"span").html(info.assetunitname);
		
		jQuery("#currencyid_"+number).val(info.currencyid);
		var currencyname = "<a style=\"max-width:104px;\" href=\"#1\" onclick=\"return false;\">"+info.currencyname+"</a>";
		_writeBackData("currencyid_"+number,2,{id:info.currencyid,name:currencyname},{hasInput:true});
		
		var currencyname = "<span class='e8_showNameClass'><a style='max-width:104px;' href='#"+info.currencyid+"'"+
							" onclick='return false;'>"+info.currencyname+"</a>"+
							" <span id="+info.currencyid+" class='e8_delClass' style='opacity: 0; visibility: hidden;'>&nbsp;x&nbsp;</span></span></span>";
			
		jQuery("#salesprice_"+number).val(info.salesprice);//单价
		changenumber(number);//计算总价
		
	})
}

function changenumber(rowval){
	count_total = 0 ;
    count_number = 0;
    count_preyield =0;

    count_total = eval(toFloat($GetEle("salesprice_"+rowval).value,0));
	count_number = eval(toFloat($GetEle("number_"+rowval).value,0));
    
    count_total = toFloat(count_total) * toFloat(count_number);

    $GetEle("totelprice_"+rowval).value = toPrecision(count_total,4) ; 

    sumpreyield();
	//alert(count_preyield);
}


function checkvalue(prevalue){
    check_value=eval(toFloat($GetEle("probability").value,0));
    if(check_value>1 ){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15241,user.getLanguage())%>");
        $GetEle("probability").value=prevalue;
        return false;
    }
    return true;
}


function sumpreyield(){
    
    count_sum=0;
    for(i=0;i<rowindex;i++){
        if($GetEle("totelprice_"+i) != null){
            count_sum += eval(toFloat($GetEle("totelprice_"+i).value,0));
        }
        
    }
   document.weaver.preyield.value = toPrecision(count_sum,2);
}
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}

function doDel(){
	if(isdel()){onDelete();}
}
function doCancel(){
	location='/CRM/sellchance/ViewSellChance.jsp?id=<%=chanceid%>&CustomerID=<%=CustomerID%>'
}
function doSave(obj){
	window.onbeforeunload=null;
	if(check_form(document.weaver,'<%=needcheck%>,Creater,preselldate,')){
		document.weaver.rownum.value = rowindex;
		obj.disabled=true;
		document.weaver.submit();
	}
}
function onDelete(){
	window.onbeforeunload=null;
	
	window.location="/CRM/sellchance/SellChanceOperation.jsp?isfromtab=<%=isfromtab%>&chanceid=<%=chanceid%>&method=del&customer=<%=CustomerID%>";
}

jQuery(function(){
	jQuery(".e8_os").show();
	// checkinput("subject","subjectimage");
	// checkinput("preyield","preyieldimage");
	// checkinput("probability","probabilityimage");
});
</script>
<script type="text/javascript">

var tempval = "";
$(document).ready(function(){
		//绑定附件上传功能
		jQuery("div[name=uploadDiv]").each(function(){
	        bindUploaderDiv($(this),"<%=chanceid%>"); 
	        jQuery(this).find("#uploadspan").append($(this).attr("checkinputImage"));
	        if(jQuery(this).attr("ismust")== 1 && jQuery(this).parent("td").find(".txtlink").length != 0){
    			jQuery("#"+$(this).attr("fieldNameSpan")).html("");
    		}
    	});
    	
    	//绑定checkbox事件
		jQuery(".item_checkbox").bind("click",function(){
			exeUpdate(jQuery(this).attr("name"),jQuery(this).is(":checked")?"1":"0","num");
		});
		
		jQuery("#objName").css("font-size","16px");
		
		<%if(canedit){%>
			
			$(".item_input").bind("focus",function(){
				
				$(this).addClass("item_input_focus");
				var _selectid = getVal($(this).attr("_selectid"));
				if(_selectid!=""){
					if($(this).attr("id")=="projectrole"){
						var selectids = $(this).val();
						var ids = selectids.split(",");
						$("div.roletype").removeClass("roletype_select");
						for(var i=0;i<ids.length;i++){
							if(ids[i]!=""){
								$("#roleitem_"+ids[i]).addClass("roletype_select");
							}
						}
					}
					var _top = $(this).offset().top + 26;
					var _left = $(this).offset().left;
					$("#"+_selectid).css({"top":_top,"left":_left}).show();
					$(this).width(100);
				}
				if(this.id=="experience" || this.id=="remark"){
					$(this).height(70);
				}
				tempval = $(this).val();
				foucsobj2 = this;
			}).bind("blur",function(){
				$(this).removeClass("item_input_focus");
				if(this.id=="experience" || this.id=="remark"){
					setRemarkHeight(this.id);
				}
				if(!$(this).hasClass("input_select")){
					doUpdate(this,1);
				}
			});
	
			
			//表格行背景效果及操作按钮控制绑定
			$("table.LayoutTable").find("td.field").bind("click mouseenter",function(){
				$(".btn_add").hide();$(".btn_browser").hide();
				$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
				$(this).find(".item_input").addClass("item_input_hover");
				//$(this).find(".item_num").width(100);
				
				$(this).find("span.browser").show();
				$(this).find("div.e8_os").show();
				$(this).find(".calendar").show();
				$(this).find("div.e8_txt").hide();
				
				//对select框进行处理
				$(this).find(".sbHolder").parent().show();
				$(this).find("div.e8_select_txt").hide();
				
				if($(this).find("input.add_input2").css("display")=="none"){
					$(this).find("div.btn_add").show();
					$(this).find("div.btn_browser").show();
				}
				$(this).find("div.btn_add2").show();
				$(this).find("div.btn_browser2").show();
	
				if($(this).attr("id")=="imcodetd") $("#imcodelink").show();
				//$(this).find("div.upload").show();
			}).bind("mouseleave",function(){
				$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
				$(this).find(".item_input").removeClass("item_input_hover");
				//$(this).find(".item_num").width(40);
				
				$(this).find("span.browser").hide();
				$(this).find("div.e8_os").hide();
				$(this).find(".calendar").hide();
				$(this).find("div.e8_txt").show();
				
				//对select框进行处理
				if($(this).find(".sbHolder").length>0){
					var sb=$(this).find("select").attr("sb");
					var e=event?event:window.event;
					if($("#sbOptions_"+sb).parent().is(":hidden")){
						$(this).find(".sbHolder").parent().hide();
						$(this).find("div.e8_select_txt").show();
					}	
				}
				
				if($(this).find("input.add_input2").css("display")=="none"){
					$(this).find("div.btn_add").hide();
					$(this).find("div.btn_browser").hide();
				}
				$(this).find("div.btn_add2").hide();
				$(this).find("div.btn_browser2").hide();
				if($(this).attr("id")=="imcodetd") $("#imcodelink").hide();
				//$(this).find("div.upload").hide();
			});
			
			$(".sbHolder").parent().hide();
	
			//联想输入框事件绑定
			$("input.add_input2").bind("focus",function(){
				if($(this).attr("_init")==1){
					$(this).FuzzyQuery({
						url:"/CRM/manage/util/GetData.jsp",
						record_num:5,
						filed_name:"name",
						searchtype:$(this).attr("_searchtype"),
						divwidth: $(this).attr("_searchwidth"),
						updatename:$(this).attr("id"),
						operate:"select",
						updatetype:"str"
					});
					$(this).attr("_init",0);
				}
				foucsobj2 = this;
			}).bind("blur",function(e){
				$(this).val("");
				$(this).hide();
				$(this).nextAll("div.btn_add").show();
				$(this).nextAll("div.btn_browser").show();
				$(this).prevAll("div.showcon").show();
			});
	
			$("div.datamore").live("mouseover",function(){
				$(this).addClass("datamore_hover");
			}).live("mouseout",function(){
				$(this).removeClass("datamore_hover");
			});
	
			$("#leftdiv").scroll(function(){
				$(".item_select").hide();
			});
	
	
			//页面点击及回车事件绑定
			$(document).bind("click",function(e){
				var target=$.event.fix(e).target;
				if(!$(target).hasClass("item_select")){
					$("div.item_select").hide();
					if($(target).hasClass("input_select")){
						var _selectid = $(target).attr("_selectid");
						$("#"+_selectid).show();
					}
				}
				if($(target).attr("id")!="projectrole" && $(target).parent().attr("id") != "pr_select"){
					$("#pr_select").hide();
			    }
			}).bind("keydown",function(e){
				e = e ? e : event;   
			    if(e.keyCode == 13){
					var target=$.event.fix(e).target;
					if($(target).hasClass("item_input") && $(target).attr("id")!="experience" && $(target).attr("id")!="remark"){
			    		$(foucsobj2).blur();  
			    		$("div.item_select").hide();
			    		$("#pr_select").hide();
			    	}
			    }
			});
		<%}%>
});

<%if(canedit){%>
function onShowDate1(spanname,inputname,mand){
  tempval = $ele4p(inputname).value;
  var fieldName = jQuery($ele4p(inputname)).parent("td").find("input").attr("name");
  var oncleaingFun = function(){
	    if(mand == 1){
		 	$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}else{
		  	$ele4p(spanname).innerHTML = '';
		}
		$ele4p(inputname).value = '';
  }
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		$dp.$(inputname).value = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = dp.cal.getDateStr();
	   	if($ele4p(inputname).value!=tempval){
	   		exeUpdate(fieldName,$ele4p(inputname).value,"str");
	   	}
		
 },oncleared:function(){
 	exeUpdate(fieldName,"","str");
 }});
   
   
   
   if(mand == 1){
     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
   }
}

//输入框保存方法
function doUpdate(obj,type){
	var fieldname = $(obj).attr("id");
	var fieldtype = getVal($(obj).attr("_type"));
	if(fieldtype=="") fieldtype="str";
	var fieldvalue = "";
	if(type==1){
		if($(obj).val()==tempval) return;
		fieldvalue = $(obj).val();
	}
	if(fieldname=="email"){
		var emailStr = fieldvalue.replace(" ","");
		if (!checkEmail(emailStr)) {
			$(obj).val(tempval);
			return;
		}
	}
	
	if(fieldname=="probability"){
		var check_value=eval(toFloat($GetEle("probability").value,0));
	    if(check_value>1){
	        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15241,user.getLanguage())%>");
	        $GetEle("probability").value=0;
	        return;
	    }
	}
	
	
	if(obj.nodeName=="SELECT"){
		$("#txtdiv_"+fieldname).html($(obj).find("option[value="+fieldvalue+"]").text()).show();
		var sb=$(obj).attr("sb");
		$("#sbHolderSpan_"+sb).hide();
	}
	// alert(document.getElementById("endtatusid").options[fieldvalue].text);
	exeUpdate(fieldname,fieldvalue,fieldtype);
}

function callBackSelectUpdate(event,data,fieldid,oldid){
	
	if(jQuery("#"+fieldid).data("oldid")){//为true表示不是第一次进行数据修改，获取oldid作为变更前的值
		oldid = jQuery("#"+fieldid).data("oldid");
	}
	
	// 防止多浏览框，每次动态添加
	var name = "";
	var id = jQuery("#"+fieldid).val();
	
	jQuery("#"+fieldid+"span").find("a").each(function(){
		name += jQuery(this).html()+",";
	});
	if("" != name){
		name = name.substring(0,name.length-1);
	}
	
	doSelectUpdate(fieldid,id,name,oldid);
}
			
function callBackSelectDelete(text,fieldid,oldid){
	
	if(jQuery("#"+fieldid).data("oldid")){//为true表示不是第一次进行数据修改，获取oldid作为变更前的值
		oldid = jQuery("#"+fieldid).data("oldid");
	}
	
	var name = "";
	var id = jQuery("#"+fieldid).val();
	jQuery("#"+fieldid+"span").find("a").each(function(){
		if(-1 != (","+id+",").indexOf(","+jQuery(this).next("span").attr("id")+",")){
			name += jQuery(this).html()+",";
		}
	});
	if("" != name){
		name = name.substring(0,name.length-1);
	}
	doSelectUpdate(fieldid,id,name,oldid);
}

//选择内容后执行更新
function doSelectUpdate(fieldname,id,name,oldid){

	var addtxt = "";
	var fieldtype = "num";

	if(fieldname=="principalIds"){
		var sumids = "";
		var addids = "";
		var ids = id.split(",");
		var names = name.split(",");
		var vals = $("#"+fieldname+"_val").val();
		for(var i=0;i<ids.length;i++){
			if((","+vals+",").indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
				addids += "," + ids[i];
				addtxt += doTransName(fieldname,ids[i],names[i]);
			}
		}
		if(addids==""){
			return;
		}else{
			addids = addids.substring(1);
			sumids = addids;
			if(vals!="") sumids = vals+","+addids;
			$("#"+fieldname).before(addtxt);
			$("#"+fieldname+"_val").val(sumids);
			exeUpdate(fieldname,sumids,"","",addids);
		}
	}else{
		tempval = oldid;
		if(tempval==id) return;

		$("#txtdiv_"+fieldname).html(name);
		//addtxt = doTransName(fieldname,id,name);
		//$("#"+fieldname).prev("div.txtlink").remove();
		//$("#"+fieldname).before(addtxt);

		exeUpdate(fieldname,id,"num");
	}
	$("#txtdiv_"+fieldname).html(name);
	jQuery("#"+fieldname).data("oldid",id);
}
//执行编辑
function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue,setid){
	if(fieldtype == "attachment"){
		var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
   		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 1){
   			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
   			return;
   		}
	}
	
	var _tempval = tempval;
	if(typeof(delvalue)=="undefined") delvalue = "";
	if(typeof(addvalue)=="undefined") addvalue = "";
	
	$.ajax({
		type: "post",
	    url: "SellChanceOperation.jsp",
	    data:{"method":"edit_sellchance_field","chanceid":<%=chanceid%>,"setid":setid,"fieldname":filter(encodeURI(fieldname)),"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue),"subject":"<%=subject%>"}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    //var txt = $.trim(data.responseText);
		    setLastUpdate();
		    
		    if(fieldtype == "attachment"){
	    		jQuery(".txtlink"+delvalue).remove();
	    		var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
	    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 0){
	    			var fieldNameSpan = jQuery("div[fieldName='"+fieldname+"']").attr("fieldNameSpan");
	    			jQuery("#"+fieldNameSpan).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
	    		}
	    	}
		}
    });
	tempval = fieldvalue;
}

//显示删除按钮
function showdel(obj){
	$(obj).find("div.btn_del").show();
	$(obj).find("div.btn_wh").hide();
}
//隐藏删除按钮
function hidedel(obj){
	$(obj).find("div.btn_del").hide();
	$(obj).find("div.btn_wh").show();
}

function setLastUpdate(){
	updateFlag = true;			
	var currentdate = new Date();
	datestr = currentdate.format("yyyy-MM-dd hh:mm:ss");
	$("#lastupdate").html("<%=SystemEnv.getHtmlLabelName(623,user.getLanguage())%> <a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> <%=SystemEnv.getHtmlLabelName(84243,user.getLanguage())%> "+datestr+" <%=SystemEnv.getHtmlLabelName(84094,user.getLanguage())%>");
	
	showMsg();
}
			
//消息提醒
function showMsg(msg){
  
	jQuery("#warn").find(".title").html("<%=SystemEnv.getHtmlLabelName(83885,user.getLanguage())%>");
	jQuery("#warn").css("display","block");
	setTimeout(function (){
		jQuery("#warn").css("display","none");
	},1500);
}		
<%}%>	


</script>
</BODY>
</HTML>
