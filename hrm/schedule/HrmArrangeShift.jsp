<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file = "/systeminfo/init_wev8.jsp" %>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
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
String id = Util.null2String(request.getParameter("id")) ; 
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16255 , user.getLanguage()) + ":" +                                             SystemEnv.getHtmlLabelName(93 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 

boolean CanEdit = HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance" , user) ; 
                         

String shiftname = "" ; 
String shiftbegintime = "" ; 
String shiftendtime = "" ; 
String validedatefrom = "" ; 

RecordSet.executeProc("HrmArrangeShift_Select_Default" , id ) ; 	
if(RecordSet.next()){ 
    shiftname = Util.null2String( RecordSet.getString("shiftname") ) ; 
    shiftbegintime = Util.null2String( RecordSet.getString("shiftbegintime") ) ; 
    shiftendtime = Util.null2String( RecordSet.getString("shiftendtime") ) ; 
    validedatefrom = Util.null2String( RecordSet.getString("validedatefrom") ) ; 
}
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id = frmmain name = frmmain action = "HrmArrangeShiftOperation.jsp" method = post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(CanEdit){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type = "hidden" name = "operation">
<input type = "hidden" name = "changeinhistory" value="0">
<input type = "hidden" name = "id" value = "<%=id%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16255,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item>
       <input type = "text" name = "shiftname" maxLength = 10 onchange = "checkinput('shiftname','shiftnamespan')" size = 43 value="<%=shiftname%>">
   		<span id = "shiftnamespan"></span>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
    <wea:item>
	    <button class = Clock type="button" onclick="onShowTime(shiftbegintimespan,shiftbegintime)"></button>
	    <span id = "shiftbegintimespan"><%=shiftbegintime%></span>
	    <input type = hidden name ="shiftbegintime" value = "<%=shiftbegintime%>">
	    <input type = "hidden" name = "oldshiftbegintime" value="<%=shiftbegintime%>">
    </wea:item>     
    <wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
    <wea:item>
	    <button class = Clock type="button" onclick = "onShowTime(shiftendtimespan,shiftendtime)"></button>
	    <span id = "shiftendtimespan"><%=shiftendtime%></span>
	    <input type = hidden name = "shiftendtime" value = "<%=shiftendtime%>">
	    <input type = hidden name = "oldshiftendtime" value = "<%=shiftendtime%>">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></wea:item>
    <wea:item>
	    <button class = Clock type="button" onclick = "onHrmShowDate(validedatefromspan,validedatefrom)"></button>
	    <span id = "validedatefromspan"><%=validedatefrom%></span>
	    <input type = hidden name = "validedatefrom" value = "<%=validedatefrom%>">
	    <input type = hidden name = "oldvalidedatefrom" value = "<%=validedatefrom%>">
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

<script language = javascript>
function doSave(){ 
	document.frmmain.operation.value = "editshift" ; 
    needinputfield = "" ;
    newshiftbegintime = document.frmmain.shiftbegintime.value ;
    oldshiftbegintime = document.frmmain.oldshiftbegintime.value ;
    newshiftendtime = document.frmmain.shiftendtime.value ;
    oldshiftendtime = document.frmmain.oldshiftendtime.value ;
    
    if(newshiftbegintime != oldshiftbegintime || newshiftendtime != oldshiftendtime ) {
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16748,user.getLanguage())%>",function(){
            needinputfield = "shiftname,validedatefrom" ;
            if(check_form(document.frmmain ,needinputfield)) {
                document.frmmain.changeinhistory.value = "1" ; 
                document.frmmain.submit() ; 
            }
        },function(){
        		needinputfield = "shiftname" ;
            if(check_form(document.frmmain ,needinputfield)) {
                document.frmmain.changeinhistory.value = "0" ; 
                document.frmmain.submit() ; 
            }
        })
    }
    else {
        needinputfield = "shiftname" ;
        if(check_form(document.frmmain ,needinputfield)) {
            document.frmmain.changeinhistory.value = "0" ; 
            document.frmmain.submit() ; 
        }
    }

} 

function doDelete(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>",function(){
		document.frmmain.operation.value = "deleteshift" ; 
		document.frmmain.submit() ; 
	})
} 


function ItemCount_KeyPress() { 
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58))) { 
     window.event.keyCode=0 ; 
  } 
} 
function checknumber(objectname) { 	
	valuechar = document.all(objectname).value.split("") ; 
	isnumber = false ; 
	for(i=0 ; i<valuechar.length ; i++) {
        charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;
        }
	if(isnumber) document.all(objectname).value = ""  ; 
} 
</SCRIPT>
</BODY>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
