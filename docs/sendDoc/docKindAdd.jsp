
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.net.URLDecoder" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("SendDoc:Manage",user)) {
	canedit=true;
   }

String name="";
String desc="";
String showOrder = "0.0";
String id=Util.null2String(request.getParameter("id"));
String navName=SystemEnv.getHtmlLabelName(16973,user.getLanguage());
if(!id.equals("")){
	RecordSet.executeSql("select * from DocSendDocKind where id = "+id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 desc=Util.null2String(RecordSet.getString("desc_n"));
	 showOrder=Util.null2String(RecordSet.getString("showOrder"));
	 navName = name;
	}
}
String name0 = URLDecoder.decode(Util.null2String(request.getParameter("name0")),"UTF-8");
String desc0 = URLDecoder.decode(Util.null2String(request.getParameter("desc0")),"UTF-8");
String showOrder0 = Util.null2String(request.getParameter("showOrder0"));
name = !"".equals(name0) ? name0 : name;
desc = !"".equals(desc0) ? desc0 : desc;
showOrder = !"".equals(showOrder0) ? showOrder0 : showOrder;
if("".equals(id) && "".equals(showOrder0)) {
	RecordSet.executeSql("SELECT MAX(showOrder)+1 FROM DocSendDocKind");
	if(RecordSet.next()){
		showOrder=Util.null2String(RecordSet.getString(1));
	}
}

String qname = Util.null2String(request.getParameter("flowTitle"));
String isClose = Util.null2String(request.getParameter("isclose"));
%>
<HTML><HEAD>
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	<%if(isClose.equals("1")){%>
		//parentWin.location.href = "docKind.jsp";
		parentWin._table.reLoad();
		parentWin.closeDialog();
	<%}%>
</script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16973,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<% if(canedit){ %>
				<input type=button class="e8_btn_top" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%if(canedit){%>
<div id="formDiv">
<FORM id=weaverA name=weaverA action="docKindOperation.jsp" method=post  >
<%if(id.equals("")){%>
	<input class=inputstyle type="hidden" name="method" value="add">
<%}else{%>
	<input class=inputstyle type="hidden" name="method" value="edit">
	<input class=inputstyle type="hidden" name="id" value="<%=id%>">
<%}%>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true"  value='<%=Util.convertInput2DB(name)%>' >
				<input temptitle="<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>" name=name class=inputstyle style="width:60%" value="<%=Util.convertInput2DB(name)%>" onchange='checkinput("name","nameimage")'>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=desc  style="width:60%" value="<%if(!desc.equals("")){%><%=desc%><%}%>"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="showOrderImage" required="true" value="0.0">
				<input style="width:120px;" temptitle="<%=SystemEnv.getHtmlLabelName(88,user.getLanguage()) %>" class="InputStyle" name="showOrder" size="7" maxlength="7" onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)'  onblur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' value="<%=showOrder %>" onchange='checkinput("showOrder","showOrderImage")'>
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<FORM id=weaverD  action="docKindOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="delete">
<input class=inputstyle type="hidden" name="IDs" id="IDs" value="">
</div>
<%}%>

<%
int existFlag = Util.getIntValue(request.getParameter("existFlag"),-1);
if(existFlag==1){
%>
<script type="text/javascript">
window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(26603,user.getLanguage()) %>');
</script>
<%
}
%>


</FORM>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
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
</body>
</html>
<script language=javascript>
try{
	parent.setTabObjName("<%= navName %>");
}catch(e){}
function submitData() {
	try{
		parent.disableTabBtn();
	}catch(e){}
 if(check_form(weaverA,"name")){
 weaverA.submit();
 }else{
	try{
		parent.enableTabBtn();
	}catch(e){}
 }
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
