
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/HrmUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>

<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(378,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}


//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
double  showOrder=1;
RecordSet.executeSql("select max(showOrder) as maxShowOrder from HrmLocations");
if(RecordSet.next()){
	showOrder=Util.getDoubleValue(RecordSet.getString("maxShowOrder"),0);
	showOrder++;
}
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="LocationOperation.jsp" method=post >
<wea:layout type="2Col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="locationnamespan" required="true">
				<INPUT class=inputStyle type=text name="locationname" onchange="checkinput('locationname','locationnamespan')">
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())+SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="locationdescspan" required="true">
				<INPUT class=inputStyle type=text name="locationdesc" onchange="checkinput('locationdesc','locationdescspan')">
			</wea:required>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</wea:item>
		<wea:item>
			<INPUT class=inputStyle maxLength=100 name=address1>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2</wea:item>
		<wea:item>
			<INPUT class=inputStyle maxLength=100 name=address2>
		</wea:item>
		<!-- tbei 2017-6-8 start -->
		<wea:item><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></wea:item>
			<wea:item>
				<span style="float: left"><INPUT class=InputStyle maxLength=6 style="width: 120px" name=postcode value="" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("postcode")' >&nbsp;</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
			<wea:item>
  			<brow:browser viewType="0"  name="cityid" browserValue="" 
	            browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/city/CityBrowser.jsp?selectedids="
	            hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
	            completeUrl="/data.jsp?type=city" width="120px"
	            _callback="getCountry" browserSpanValue="">
            </brow:browser>
   		 </wea:item>
   		<!-- tbei 2017-6-8 end -->
    <wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
    <wea:item>
    	<span class=inputStyle id=countryspan></span> 
			<INPUT class=inputStyle id=countryid type=hidden name=countryid>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15858,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=inputStyle maxLength=30 name=telephone>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=inputStyle maxLength=30 name=fax>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=inputStyle maxLength=15 name=showOrder style="width: 80px" value="<%=showOrder%>" onKeyPress='ItemDecimal_KeyPress("showOrder",15,2)'  onchange='checknumber("showOrder");checkDigit("showOrder",15,2);'>
			<input class=inputStyle type="hidden" name=operation value=add>
		</wea:item>
	</wea:group>
</wea:layout>
 </form>
   <%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="">
				<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
<script language=javascript>
function submitData(obj) {
 if(check_form(frmMain,'locationname,locationdesc,countryid,cityid')){
	 obj.disabled=true;
     frmMain.submit();
 }
}
 function showCountry(o){
   $G("countryspan").innerHTML =o.split('_')[0];
	 $G("countryid").value=o.split('_')[1] ;
 }
 
 function getCountry(e,datas,name){
  HrmUtil.getCountryByCity(datas.id,showCountry) ;
 }

function check(o){
     if(!o)
     window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83505,user.getLanguage())%>') ;
     return o;
 }
function checkCity(id,countryid){
     HrmUtil.checkCity(id,countryid,check) ;
 }

/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}


function onShowCity() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		
		if (rid != 0 && rid != "") {
			$G("cityspan").innerHTML = rname;
			$G("locationcity").value = rid;
			getCountry(rid);
		} else {
			$G("cityspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			$G("locationcity").value=""
		}
	}
}


function onShowCountry() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		
		if (rid != 0 && rid != "") {
			 if ($G("locationcity").value != "") {
		         var result = checkCity($G("locationcity").value, rid);
		         if (result) {
			         $G("countryspan").innerHTML = rname;
			         $G("countryid").value= rid;
		         }
			 } else {
			    $G("countryspan").innerHTML = rname;
			    $G("countryid").value= rid;
			 }
		} else {
			//$G("countryspan").innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				$G("countryspan").innerHtml = "";
				$G("countryid").value="";
		}
	}
}
</script>
 <script language=vbs>
 sub onShowCountry()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
         if frmMain.locationcity.value<>"" then
             result=checkCity(frmMain.locationcity.value,id(0) )
             if result then
              countryspan.innerHtml = id(1)
	          frmMain.countryid.value=id(0)
             end if
        else
        countryspan.innerHtml = id(1)
	    frmMain.countryid.value=id(0)
        end if
    else
	countryspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.countryid.value=""
	end if
	end if
end sub
sub onShowCity()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	cityspan.innerHtml = id(1)
	frmMain.locationcity.value=id(0)
    getCountry(id(0))
    else
	cityspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.locationcity.value=""
	end if
	end if
end sub
</script>
</BODY></HTML>
