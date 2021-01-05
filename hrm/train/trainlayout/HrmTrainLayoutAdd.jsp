<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmTrainLayoutAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6128,user.getLanguage());
String needfav ="1";
String needhelp ="";
String layoutassessor=Util.null2String(request.getParameter("layoutassessor"));
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+S//ystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayout.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<input class=inputstyle type="hidden" name=operation value=add>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item><input class=inputstyle type=text size=30 name="layoutname" onchange='checkinput("layoutname","layoutnameimage")'>
	    <SPAN id=layoutnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>          
	    </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></wea:item>
      <wea:item>
      	<brow:browser viewType="0" name="typeid"
          browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/traintype/TrainTypeBrowser.jsp?selectedids="
          hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
          completeUrl="/data.jsp?type=HrmTrainType" width="120px" browserSpanValue=""
          _callback="jsGetTypeData">
        </brow:browser>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
      <wea:item>
        <BUTTON class=Calendar type="button" id=selectlayoutstartdate onclick="getDate(layoutstartdatespan,layoutstartdate)"></BUTTON> 
        <SPAN id=layoutstartdatespan ></SPAN> 
        <input class=inputstyle type="hidden" id="layoutstartdate" name="layoutstartdate" >
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
      <wea:item>
        <BUTTON class=Calendar type="button" id=selectlayoutenddate onclick="getDate(layoutenddatespan,layoutenddate)"></BUTTON> 
        <SPAN id=layoutenddatespan ></SPAN> 
        <input class=inputstyle type="hidden" id="layoutenddate" name="layoutenddate" >
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
      <wea:item>
        <textarea class=inputstyle cols=50 rows=4 id=layoutcontent name=layoutcontent ></textarea>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </wea:item>
      <wea:item>
        <textarea class=inputstyle cols=50 rows=4 id=layoutaim name=layoutaim ></textarea>            
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </wea:item>
	    <wea:item>
        <BUTTON class=Calendar type="button" id=selectlayouttestdatedate onclick="getDate(layouttestdatespan,layouttestdate)"></BUTTON> 
        <SPAN id=layouttestdatespan ></SPAN> 
        <input class=inputstyle type="hidden" id="layouttestdate" name="layouttestdate" >            
      </wea:item>  
      <wea:item><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </wea:item>
      <wea:item>
      	<brow:browser viewType="0" name="layoutassessor"
          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
          hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
          completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="240px">
        </brow:browser>
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
function submitData() {
 if(check_formM(frmMain,'layoutname,typeid,layoutassessor')&&checkDateRange(frmMain.layoutstartdate,frmMain.layoutenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>")){
 frmMain.submit();
 }
}

 function check_formM(thiswins,items){
	thiswin = thiswins
	items = ","+items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="layoutassessor"){
		if(tmpvalue == 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}

function jsGetTypeData(e, datas, name){
	var typeid = datas.id;
	
	jQuery.getJSON('/hrm/ajaxData.jsp',{'cmd':'traintype','typeid':typeid},function(data){ 
		jQuery("#layoutcontent").val(data.typecontent)
		jQuery("#layoutaim").val(data.typeaim)
  })
}
</script>
<%@include file="/hrm/include.jsp"%>
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
