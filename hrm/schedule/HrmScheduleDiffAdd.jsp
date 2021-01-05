
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-06 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add" , user)){ 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	} 
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));	
%>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
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
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(6139 , user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(82 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
boolean CanAdd = HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add" , user) ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>	
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

String rolelevel=CheckUserRight.getRightLevel("HrmScheduleDiffAdd:Add" , user);
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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
<FORM id=weaver name = frmmain method = post action = "HrmScheduleDiffOperation.jsp" >
<input class=inputstyle type = "hidden" name = "operation" value = "insert">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
       <input class=inputstyle type = "text" name = "diffname" maxLength = 10 onchange = "checkinput('diffname' , 'InvalidFlag_Description1')" size = 10 >
       <SPAN id = InvalidFlag_Description1><IMG src = "/images/BacoError_wev8.gif" align=absMiddle></SPAN>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
     <wea:item>
       <input class=inputstyle type = "text" name = "diffdesc" maxLength = 30 onchange = "checkinput('diffdesc' , 'InvalidFlag_Description3')" >
       <SPAN id = InvalidFlag_Description3><IMG src = "../../images/BacoError_wev8.gif" align = absMiddle></SPAN>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></wea:item>
     <wea:item>
	     <select class=inputstyle name = "diffscope" size = 1>
	     <%if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){%>
	     <option value = "0" >
	     <%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%></option>
	     <%}%>    
	     <option value = "1" >
	     <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
	     <option value = "2" >
	     <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921, user.getLanguage())%></option>
	   	</select>
   	 </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
     <wea:item>
		   <brow:browser viewType="0" name="subcompanyid" browserValue='<%=subcompanyid %>' 
		   browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
		   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=164"
		   _callback="" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(subcompanyid) %>'>
		   </brow:browser>
     </wea:item>
     <%--<wea:item><%=SystemEnv.getHtmlLabelName(450,user.getLanguage())%></wea:item>
     <wea:item>
       <select class=inputstyle name = "difftime" size = 1>
         <option value = "0"><%=SystemEnv.getHtmlLabelName(380 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277 , user.getLanguage())%></option>
         <option value="1"><%=SystemEnv.getHtmlLabelName(458 , user.getLanguage())%></option>
         <option value="2"><%=SystemEnv.getHtmlLabelName(370,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371 , user.getLanguage())%></option>
       </select>
     </wea:item>             
     <wea:item><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></wea:item>
     <wea:item>
     	<button class = Browser type="button" onclick = "onShowColor('colorspan','color')"></button> 
		   <span ID=SelectedColor style="height: 40px;background-color:#000000;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
       <input class=inputstyle type = "hidden" name = "color" value="000000">
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
     <wea:item>
       <textarea class=inputstyle name = diffremark rows="5" style="width: 98%"></textarea>
     </wea:item>--%>
	</wea:group>
</wea:layout>
</form>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
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
<SCRIPT language = javascript>
function submitData() {
	if(check_form(frmmain,'diffname,diffdesc,workflowid,subcompanyid')){
	 	frmmain.submit();
	}
}
function ItemCount_KeyPress(){ 
    if(!((window.event.keyCode>=48) && (window.event.keyCode<=58))) { 
       window.event.keyCode=0 ; 
  } 
} 
function checknumber(objectname){ 	
	valuechar = jQuery("#"+objectname).val().split("") ; 
	isnumber = false ; 
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	if(isnumber) jQuery("#"+objectname).val(""); 
} 

function onShowColor(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/ColorBrowser.jsp");
	if (data!=null){
	      if(data!=""){
	      jQuery("#SelectedColor").css("background","#"+data);
				jQuery("input[name="+inputename+"]").val(data);
			}else{
				jQuery("#SelectedColor").css("background","#"+data);
				jQuery("input[name="+inputename+"]").val("");
			}
	}
}
</SCRIPT>

<script language = vbs>
sub onShowSalaryItem(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> 0 then
		tdname.innerHtml = id(1)
		inputename.value = id(0)
		else
		tdname.innerHtml = ""
		inputename.value = ""
		end if
	end if
end sub

sub onShowWorkflow(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src = '/images/BacoError_wev8.gif' align = absMiddle>"
		document.all(inputename).value = ""
		end if
	end if
end sub

</script>
</body>
</html>
