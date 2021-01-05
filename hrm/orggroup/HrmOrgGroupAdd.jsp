
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
    if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	double showOrder = 0;

	RecordSet.executeSql("select max(showOrder) from HrmOrgGroup ");
	if(RecordSet.next()){
		showOrder=Util.getDoubleValue(RecordSet.getString(1),0);
	}

	showOrder+=1;


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24002,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="HrmOrgGroupOperation.jsp" method=post>
<input class=inputstyle type="hidden" name=operation>
<wea:layout type="2col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(24002,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	<wea:item>
	  <INPUT class=InputStyle temptitle="<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>"  name=orgGroupName value="" size=30 maxlength=30   onchange='checkinput("orgGroupName","orgGroupNameImage")'>
	          <SPAN id=orgGroupNameImage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
	          </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
	<wea:item> 
		<INPUT class=InputStyle  name=orgGroupDesc value="" size=60 maxlength=100>					           
	  </wea:item>
	        <wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
	<wea:item>
	  <INPUT class=InputStyle temptitle="<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>" name=showOrder size=7 maxlength=7 value="<%=showOrder%>"   onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)'  onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")'>
	  <SPAN id=showOrderImage></SPAN>
	</wea:item>
</wea:group>
</wea:layout>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
</wea:item></wea:group></wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</td>
</tr>
</TABLE>
</form> 
</BODY>
</HTML>


<script language=javascript>

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


function onSave(){

 	if(check_form(document.frmMain,'orgGroupName,showOrder')){
		document.frmMain.operation.value="AddSave";
		document.frmMain.submit();
		enableAllmenu();
	}
 }

</script>
