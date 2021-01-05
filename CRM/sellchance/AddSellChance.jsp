
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<%@ include file="/CRM/data/uploader.jsp" %>
<%
String CustomerID = request.getParameter("CustomerID");
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String tabtype = Util.null2String(request.getParameter("tabtype"));
String target = Util.null2String(request.getParameter("target"));
int rownum=0;
String needcheck="subject";

String userid=""+user.getUID();

Map map = new HashMap();
Map paramMap = new HashMap();
map.put("customerid",CustomerID);
map.put("creater",user.getUID());
paramMap.put("content","where type in (3,4)");
paramMap.put("comefromid","where CustomerID="+CustomerID);
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/CRM/sellchance/ListSellChance.jsp?isfromtab="+isfromtab+"&CustomerID="+CustomerID+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32922,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:497px;">
<FORM id=weaver name=weaver action="/CRM/sellchance/SellChanceOperation.jsp" method=post  >
	<input type="hidden" name="method" value="add">
    <input type="hidden" name="isfromtab" value="<%=isfromtab%>">
    <input type="hidden" name="target" value="<%=target%>">
    
    <wea:layout type="4Col" attributes="{'expandAllGroup':'true'}">
		
		<%
		CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
		rs.execute("select t1.*,t2.* from CRM_CustomerDefinFieldGroup t1 left join "+
				"(select groupid,count(groupid) groupcount from CRM_CustomerDefinField where isopen=1 and usetable = 'CRM_SellChance' group by groupid) t2 on t1.id=t2.groupid "+
				"where t1.usetable = 'CRM_SellChance' and t2.groupid is not null order by t1.dsporder asc");
		while(rs.next()){
			String groupid = rs.getString("id");
			int groupcount = Util.getIntValue(rs.getString("groupcount"),0);
			if(0 == groupcount){
				continue;
			}
			%>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>' attributes="{'isColspan':'false'}">
				<% while(comInfo.next()){
					if("CRM_SellChance".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
				%>
					<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
					<wea:item><%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(map.get(comInfo.getFieldname())),Util.null2String(paramMap.get(comInfo.getFieldname())), user)%></wea:item>
				<%}}%>	
			</wea:group>
			
		<%}%>
			
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15128, user.getLanguage())%>" onclick="addRow();">
			<input type="button" class="delbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="if(isdel()){deleteRow1()};">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE class="ListStyle" cellpadding=1  cols=7 id="oTable">
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
			
				<tbody>
					<tr class=header>
					<td class=Field><input type="checkbox" name="node_total" onclick="setCheckState(this)"/></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(2019,user.getLanguage())%></td>
				</tbody>
			</table>  
		</wea:item>
	</wea:group>
	
</wea:layout>

</FORM>
</div>

<%if(!"add".equals(tabtype)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getParentWindow(window).diag.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="JavaScript" src="/js/addRowBg_wev8.js">   
</script>  
<script language=javascript>
function setCheckState(obj){
	var checkboxs = jQuery("input[name='check_node']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
}

jQuery(function(){
	beautySelect();
})
rowindex = "<%=rownum%>";
var rowColor="" ;
function addRow()
{
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
				   _callback:'callBackSelectUpdate'
				  });
				 
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span text class=InputStyle id=assetunitid_"+rowindex+"span></span> "+
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
				break;                
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text id='salesprice_"+rowindex+"'  name='salesprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  name='number_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10 value='1'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;               
            case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  id='totelprice_"+rowindex+"'  name='totelprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress(this.id)' onBlur='checknumber1(this),sumpreyield()' size=25>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
		}
	}
	rowindex = rowindex*1 +1;
 	jQuery('body').jNice();
}

function callBackSelectUpdate(event,data,fieldId,oldid){
	var number = fieldId.substring(fieldId.indexOf("_")+1);
	jQuery.post("SellChanceOperation.jsp",{"method":"getProductInfo","productId":data.id},function(info){
		info = jQuery.trim(info);
		info = eval('('+info+')');
		jQuery("#assetunitid_"+number).val(info.assetunitid);//单位
		jQuery("#assetunitid_"+number+"span").html(info.assetunitname);
		
		jQuery("#currencyid_"+number).val(info.currencyid);
		var currencyname = "<a style=\"max-width:104px;\" href=\"#1\" onclick=\"return false;\">"+info.currencyname+"</a>";
		__browserNamespace_writeBackData("currencyid_"+number,2,{id:info.currencyid,name:currencyname},{hasInput:true});
		
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


function deleteRow1()
{
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

var upfilesnum=0;//获得上传文件总数
function doSave(obj){
	obj.disabled = true; // added by 徐蔚绛 for td:1553 on 2005-03-22
	if(jQuery("img[src='/images/BacoError_wev8.gif']").length ==0){
		jQuery("div[name=uploadDiv]").each(function(){
	  		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
	    	if(oUploader.getStats().files_queued>0){
	    		upfilesnum+=oUploader.getStats().files_queued;
	    		oUploader.startUpload();
	    	}
	    });
	    if(upfilesnum==0) doSaveAfterAccUpload();
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
	}
	
}

function doSaveAfterAccUpload(){
	document.weaver.rownum.value = rowindex;
	window.weaver.submit();
}

jQuery(document).ready(function(){
   //绑定附件上传
   if(jQuery("div[name=uploadDiv]").length>0){
    	jQuery("div[name=uploadDiv]").each(function(){
	    	
	        bindUploaderDiv($(this)); 
	        // alert(this).find("#uploadspan").length);
	        jQuery(this).find("#uploadspan").append($(this).attr("checkinputImage"));
	        
	        if($(this).attr("ismust") == 1){
		        var fieldNameSpan = $(this).attr("fieldNameSpan");
		        jQuery(this).find(".progressCancel.progressCancel").live("click",function(){
		        	
		       		var childLength = jQuery(this).parents(".fieldset").find(".progressWrapper:visible[id!='"+jQuery(this).parents(".progressWrapper").attr("id")+"']").length;  
					 if(childLength==0){
					 	if(jQuery("#"+fieldNameSpan).html()==""){
					 		jQuery("#"+fieldNameSpan).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					 	}
					 }    
		        });
	        }
    	});
    } 
    
   jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   	jQuery(this).tzCheckbox({labels:['','']});
	  }
 	});
 });
 

function protectSellChance(){
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19005,user.getLanguage())%>";
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}
jQuery(function(){
	jQuery("input[name='probability'").bind("change",function(){
		var check_value=eval(toFloat($GetEle("probability").value,0));
	    if(check_value>1){
	        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15241,user.getLanguage())%>");
	        $GetEle("probability").value=0;
	    }
	})
});
</script>

</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language=javascript src="/js/checkData_wev8.js"></script>
</HTML>
