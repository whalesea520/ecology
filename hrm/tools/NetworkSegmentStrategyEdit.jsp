<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
 if(!HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
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
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21384,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

String id =  request.getParameter("id");

String inceptipaddress = "";
String endipaddress ="";
String createrid = "";
String createdate = "";
String segmentdesc = "";


String Ipnetsql = "select * from HrmnetworkSegStr where id = "+id;
RecordSet.executeSql(Ipnetsql); 
while(RecordSet.next()){ 
		inceptipaddress = RecordSet.getString("inceptipaddress");
		endipaddress = RecordSet.getString("endipaddress");
		createrid = RecordSet.getString("createrid");
		createdate = RecordSet.getString("createdate");
		segmentdesc = RecordSet.getString("segmentdesc");
		//System.out.println("aaa"+inceptipaddress);
}

String inceptipaddressA = "";
String inceptipaddressB = "";
String inceptipaddressC = "";
String inceptipaddressD = "";
String endipaddressA = "";
String endipaddressB = "";
String endipaddressC = "";
String endipaddressD = "";
String[] ipstartaddress = Util.TokenizerString2(inceptipaddress,"."); 
if(ipstartaddress.length>0){
	inceptipaddressA = ipstartaddress[0];
	inceptipaddressB = ipstartaddress[1];
	inceptipaddressC = ipstartaddress[2];
	inceptipaddressD = ipstartaddress[3];
}

String[] ipendaddress = Util.TokenizerString2(endipaddress,"."); 
if(ipendaddress.length>0){
	endipaddressA = ipendaddress[0];
	endipaddressB = ipendaddress[1];
	endipaddressC = ipendaddress[2];
	endipaddressD = ipendaddress[3];
}

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onAdd(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onAdd(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="NetworkSegmentStrategyOperation.jsp" method=post >
	        <input class=inputstyle type="hidden" name=operation value=edit>
		<input class=inputstyle type="hidden" name=id value="<%=id%>">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
          <wea:item><%=SystemEnv.getHtmlLabelName(21387,user.getLanguage())%></wea:item>
          <wea:item>
          <input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="inceptipaddressA" onBlur="checkcount1(this),CheckIntRange1(this),checkinputip('inceptipaddressimage')" value = "<%=inceptipaddressA%>">.<input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="inceptipaddressB" onBlur="checkcount1(this),CheckIntRange(this),checkinputip('inceptipaddressimage')" value = "<%=inceptipaddressB%>">.<input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="inceptipaddressC" onBlur="checkcount1(this),CheckIntRange(this),checkinputip('inceptipaddressimage')" value = "<%=inceptipaddressC%>">.<input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="inceptipaddressD" onBlur="checkcount1(this),CheckIntRange(this),checkinputip('inceptipaddressimage')" value = "<%=inceptipaddressD%>">
          <SPAN id=inceptipaddressimage><%if(inceptipaddressA.equals("")&&inceptipaddressB.equals("")&&inceptipaddressC.equals("")&&inceptipaddressD.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
          </wea:item>
          <wea:item><%=SystemEnv.getHtmlLabelName(21388,user.getLanguage())%></wea:item>
          <wea:item><input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="endipaddressA" onBlur="checkcount1(this),CheckIntRange1(this),checkinputipB('endipaddressimage')" value = '<%=endipaddressA%>'>.<input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="endipaddressB" onBlur="checkcount1(this),CheckIntRange(this),checkinputipB('endipaddressimage')" value = "<%=endipaddressB%>">.<input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="endipaddressC" onBlur="checkcount1(this),CheckIntRange(this),checkinputipB('endipaddressimage')" value = "<%=endipaddressC%>">.<input class=inputstyle maxLength=3 style="width: 60px" type=text size=8 name="endipaddressD" onBlur="checkcount1(this),CheckIntRange(this),checkinputipB('endipaddressimage')" value = "<%=endipaddressD%>">
		  <SPAN id=endipaddressimage><%if(endipaddressA.equals("")&&endipaddressB.equals("")&&endipaddressC.equals("")&&endipaddressD.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
</wea:item>         
<wea:item><%=SystemEnv.getHtmlLabelName(21386,user.getLanguage())%></wea:item>
          <wea:item><input class=inputstyle type=text size=42 name="segmentdesc" value='<%=segmentdesc%>'>
          </wea:item>
        </wea:group>
        </wea:layout>
 </form>
   <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
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
function onAdd(obj) {
if(check_form(document.frmMain,'inceptipaddressA,inceptipaddressB,inceptipaddressC,inceptipaddressD,endipaddressA,endipaddressB,endipaddressC,endipaddressD')){
 frmMain.submit();
 obj.disabled=true;

 }
}
function goBack() {
	window.history.go(-1);
}

function onDelete() {
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.frmMain.operation.value="delete";
	document.frmMain.submit();
	}
}
function CheckIntRange1(CheckCtl){
 valuechar = CheckCtl.value;
 if(valuechar!=""){
  if(valuechar>223||valuechar<1){
	window.top.Dialog.alert(CheckCtl.value+"<%=SystemEnv.getHtmlLabelName(21390,user.getLanguage())%>"+"，"+"<%=SystemEnv.getHtmlLabelName(21389,user.getLanguage())%>");
	  if(valuechar>223){
	  CheckCtl.value="223";
	}else if(valuechar<1){
	  CheckCtl.value="1";	
	}
  }
 }
}

function CheckIntRange(CheckCtl){
 valuechar = CheckCtl.value;
 if(valuechar!=""){
  if(valuechar>255||valuechar<0){
	window.top.Dialog.alert(CheckCtl.value+"<%=SystemEnv.getHtmlLabelName(21390,user.getLanguage())%>"+"，"+"<%=SystemEnv.getHtmlLabelName(21392,user.getLanguage())%>");
	if(valuechar>255){
	  CheckCtl.value="255";
	}else if(valuechar<0){
	  CheckCtl.value="0";	
	}
  }
 }
}

function checkinputip(spanid){
	tmpvalueA = document.all("inceptipaddressA").value;
	tmpvalueB = document.all("inceptipaddressB").value;
	tmpvalueC = document.all("inceptipaddressC").value;
	tmpvalueD = document.all("inceptipaddressD").value;
	if(tmpvalueA!=""&&tmpvalueB!=""&&tmpvalueC!=""&&tmpvalueD!=""){
		document.getElementById(spanid).innerHTML="";
	}else{
		document.getElementById(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
}
function checkinputipB(spanid){
	tmpvalueipA = document.all("endipaddressA").value;
	tmpvalueipB = document.all("endipaddressB").value;
	tmpvalueipC = document.all("endipaddressC").value;
	tmpvalueipD = document.all("endipaddressD").value;
	if(tmpvalueipA!=""&&tmpvalueipB!=""&&tmpvalueipC!=""&&tmpvalueipD!=""){
		document.getElementById(spanid).innerHTML="";
	}else{
		document.getElementById(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
}
</script>
</BODY>
</HTML>
