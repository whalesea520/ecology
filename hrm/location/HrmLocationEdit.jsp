<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int id = Util.getIntValue(request.getParameter("id"),0);
String locationname="";
String locationdesc="";
String address1="";
String address2="";
String locationcity="";
String postcode="";
String countryid="";
String telephone="";
String fax="";
String showOrder="";
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("HrmLocations_SelectByID",""+id);

if(RecordSet.next()){
	locationname = Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage());
	locationdesc = Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage());
	address1 = Util.toScreenToEdit(RecordSet.getString(4),user.getLanguage());
	address2= Util.toScreenToEdit(RecordSet.getString(5),user.getLanguage());
	locationcity = Util.toScreenToEdit(RecordSet.getString(6),user.getLanguage());
	postcode = Util.toScreenToEdit(RecordSet.getString(7),user.getLanguage());
	countryid = Util.toScreenToEdit(RecordSet.getString(8),user.getLanguage());
	telephone = Util.toScreenToEdit(RecordSet.getString(9),user.getLanguage());
	fax = Util.toScreenToEdit(RecordSet.getString(10),user.getLanguage());
	showOrder = Util.null2String(RecordSet.getString("showOrder"));        
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(378,user.getLanguage())+"："+locationname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
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
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmLocationsEdit: Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
if(HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/location/HrmLocationAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmLocationsEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmLocations:Log", user)){
    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=23 and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=23 and relatedid="+id+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="LocationOperation.jsp" method=post>
	<wea:layout type="2Col" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(canEdit){%>
				<wea:required id="locationnamespan" required="true" value='<%=locationname %>'>
					<INPUT class=inputstyle type=text name="locationname" value="<%=locationname%>" onchange="checkinput('locationname','locationnamespan')">
				</wea:required>
				<%}else{%><%=locationname%><%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())+SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(canEdit){%>
				<wea:required id="locationdescspan" required="true" value='<%=locationdesc %>'>
					<INPUT class=inputstyle type=text name="locationdesc"  value="<%=locationdesc%>" onchange="checkinput('locationdesc','locationdescspan')">
				</wea:required>
        <%}else{%><%=locationdesc%><%}%>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 1</wea:item>
			<wea:item>
			<%if(canEdit){%>
				<INPUT class=InputStyle maxLength=100 name=address1 value="<%=address1%>">
			<%}else{%><%=address1%><%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 2</wea:item>
			<wea:item>
			<%if(canEdit){%><INPUT class=InputStyle maxLength=100
      name=address2 value="<%=address2%>"> <%}else{%><%=address2%><%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></wea:item>
			<wea:item>
			<%if(canEdit){%>
				<span style="float: left"><INPUT class=InputStyle maxLength=6 style="width: 120px" name=postcode value="<%=postcode%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("postcode")' >&nbsp;</span>
			<%}else{%><%=postcode%><%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(canEdit){%>
			  	<brow:browser viewType="0" name="cityid" browserValue='<%=locationcity%>' 
		            browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/city/CityBrowser.jsp?selectedids="
		            hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
		            completeUrl="/data.jsp?type=city" width="120px"
		            _callback="getCountry" browserSpanValue='<%=CityComInfo.getCityname(locationcity)%>'>
	            </brow:browser>  
        		<%}else{%><%=CityComInfo.getCityname(locationcity)%><%}%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
			<wea:item>
			<%if(canEdit){%>
				<INPUT id=countryid type=hidden name=countryid  value="<%=countryid%>">
				<span id="countryspan"><%=CountryComInfo.getCountrydesc(countryid)%></span>
      <%}else{%><%=CountryComInfo.getCountrydesc(countryid)%><%}%>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15858,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></wea:item>
			<wea:item><%if(canEdit){%><INPUT class=inputStyle maxLength=30
    	name=telephone value="<%=telephone%>" ><%}else{%><%=telephone%><%}%></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
    	<wea:item><%if(canEdit){%><INPUT class=inputStyle maxLength=30
  		name=fax value="<%=fax%>" ><%}else{%><%=fax%><%}%></wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(canEdit){%><INPUT class=inputStyle maxLength=15 style="width: 80px"
    		name=showOrder value="<%=showOrder%>" onKeyPress='ItemDecimal_KeyPress("showOrder",15,2)'  onchange='checknumber("showOrder");checkDigit("showOrder",15,2);checkinput("showOrder","showOrderImage")'><%}else{%><%=showOrder%><%}%>
			</wea:item>
		</wea:group>
	</wea:layout>
   <input class=inputstyle type="hidden" name=operation>
   <input class=inputstyle type="hidden" name=id value=<%=id%>>
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
 function onSave(){

	if(document.frmMain.locationname.value==""|| document.frmMain.locationdesc.value==""||
	   document.frmMain.countryid.value==""||
	   document.frmMain.cityid.value==""){
	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	}else{
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 function showCountry(o){
   $G('countryspan').innerHTML =o.split('_')[0];
	 $G('countryid').value=o.split('_')[1] ;
 }
 function getCountry(e,datas,name){
     HrmUtil.getCountryByCity(datas.id,showCountry) ;

 }
 function check(o){
      if(!o)
      alert('<%=SystemEnv.getHtmlLabelName(83505,user.getLanguage())%>') ;
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
 </script>
</BODY></HTML>
