
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-08-06 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));	
%>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "SalaryComInfo" class = "weaver.hrm.finance.SalaryComInfo" scope = "page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<HTML>
<HEAD>
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
boolean CanEdit= HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add" , user);
if(!CanEdit){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
	}
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename =  SystemEnv.getHtmlLabelName(6139 , user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
String rolelevel=CheckUserRight.getRightLevel("HrmScheduleDiffAdd:Add" , user);
int id = Util.getIntValue(request.getParameter("id") , 0) ;

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) ="+17+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+17+",_self} " ;
    }
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
<FORM id = frmmain name = frmmain method = post action = "HrmScheduleDiffOperation.jsp">
<input class=inputstyle type = "hidden" name = "operation">
<input class=inputstyle type = "hidden" name = "id" value = "<%=id%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%>'>
		<%
    RecordSet.executeProc("HrmScheduleDiff_Select_ByID" , id + "") ;
    RecordSet.next() ; 
    %>
    <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item>
      <%if(CanEdit){%>
      <input class=inputstyle type = "text" name = "diffname" maxLength = 10 value = "<%=Util.toScreenToEdit(RecordSet.getString("diffname") , user.getLanguage())%>" onchange = "checkinput('diffname','InvalidFlag_Description1')" size = 10>
  		<SPAN id = InvalidFlag_Description1>
  	  <% if(RecordSet.getString("diffname").equals("")){%>
  	    <IMG src = "../../images/BacoError_wev8.gif" align = absMiddle>
  	  <%} %>
  	</SPAN>
  	<%} else {%>
  	<%=Util.toScreen(RecordSet.getString("diffname") , user.getLanguage())%><%}%>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
      <input class=inputstyle type = "text" name = "diffdesc" maxLength = 30 value = "<%=Util.toScreenToEdit(RecordSet.getString("diffdesc"),user.getLanguage())%>" onchange = "checkinput('diffdesc','InvalidFlag_Description3')" >
  	<SPAN id = InvalidFlag_Description3>
  	<% if(RecordSet.getString("diffdesc").equals("")){%>
  	 <IMG src = "/images/BacoError_wev8.gif" align = absMiddle>
  	<%}%>
  	</SPAN>
    <%} else {%><%=Util.toScreen(RecordSet.getString("diffdesc") , user.getLanguage())%><%}%>
    </wea:item>   
    <wea:item><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></wea:item>
    <wea:item>
         <%if(CanEdit){%>
        <select class=inputstyle name = "diffscope" size = 1>
        <%if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){%>
        <option value = "0" <% if(RecordSet.getString("diffscope").equals("0")){%> selected<%}%>>
        <%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%></option>
        <%}%>    
        <option value = "1" <% if(RecordSet.getString("diffscope").equals("1")){%> selected<%}%>>
        <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
        <option value = "2" <% if(RecordSet.getString("diffscope").equals("2")){%> selected<%}%>>
        <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921, user.getLanguage())%></option>
      </select>
      <%} else {%>
      <%if(RecordSet.getString("diffscope").equals("0")){%><%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%><%}%>
      <%if(RecordSet.getString("diffscope").equals("1")){%><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%}%>
      <%if(RecordSet.getString("diffscope").equals("2")){%><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921 , user.getLanguage())%><%}%>
      <% } %>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
     <wea:item>
       <brow:browser viewType="0" name="subcompanyid" browserValue='<%=RecordSet.getString("subcompanyid") %>' 
		   browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
		   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=164"
		   _callback="" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")) %>'>
		   </brow:browser>
     </wea:item>
     <%--<wea:item><%=SystemEnv.getHtmlLabelName(450,user.getLanguage())%></wea:item>
    <wea:item>
       <%if(CanEdit){%>
	      <select class=inputstyle name = "difftime" size = 1>
	      <option value = "0" <% if(RecordSet.getString("difftime").equals("0")){%> selected<%}%>>
	      <%=SystemEnv.getHtmlLabelName(380 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277 , user.getLanguage())%></option>
	      <option value = "1" <% if(RecordSet.getString("difftime").equals("1")){%> selected<%}%>>
	      <%=SystemEnv.getHtmlLabelName(458 , user.getLanguage())%></option>
	      <option value = "2" <% if(RecordSet.getString("difftime").equals("2")){%> selected<%}%>>
	      <%=SystemEnv.getHtmlLabelName(370 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371 , user.getLanguage())%></option>
	    </select>
	    <%} else {%>
	    <%if(RecordSet.getString("difftime").equals("0")){%><%=SystemEnv.getHtmlLabelName(380 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277 , user.getLanguage())%><%}%> 
	    <%if(RecordSet.getString("difftime").equals("1")){%><%=SystemEnv.getHtmlLabelName(458 , user.getLanguage())%><%}%>
	    <%if(RecordSet.getString("difftime").equals("2")){%><%=SystemEnv.getHtmlLabelName(370 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371 , user.getLanguage())%><%}%>
	    <% } %>   
	  </wea:item>             
    <wea:item><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></wea:item>
    <wea:item>
			<%if(CanEdit){%><button class = Browser type="button" onclick="onShowColor('colorspan','color')"></button> <%}%>
			<span ID=SelectedColor style="height: 40px;background-color:#<%=RecordSet.getString("color")%>;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
      <input class=inputstyle type="hidden" name="color" value="">
    </wea:item> 
    <wea:item><%=SystemEnv.getHtmlLabelName(454 , user.getLanguage())%></wea:item>
    <wea:item>
     <%if(CanEdit){%><textarea class=inputstyle name = diffremark rows="5" style="width: 98%"><%=Util.toScreenToEdit(RecordSet.getString("diffremark") , user.getLanguage())%></textarea>
     <%} else {%><%=Util.toScreen(RecordSet.getString("diffremark") , user.getLanguage())%><%}%>
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
<script language=javascript>
function submitData(){
	document.frmmain.operation.value = "save" ; 
    if(check_form(document.frmmain,'diffname,diffdesc,workflowid,subcompanyid')){

            frmmain.submit(); 
    }
} 

function doDelete(obj){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>")) {
		document.frmmain.operation.value = "delete" ;
        obj.disabled = true;
        document.frmmain.submit() ;
	} 
} 

function ItemCount_KeyPress() { 
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58)))
  { 
     window.event.keyCode=0 ; 
  } 
} 

function checknumber(objectname) { 	
	valuechar = jQuery("#"+objectname).val().split("") ; 
	isnumber = false ; 
    for(i=0 ; i < valuechar.length ; i++ ) {
            charnumber = parseInt(valuechar[i]) ; 
            if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;
  }
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

function onShowSalaryItem(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp")
	if (data!=null){
	        if( data!= ""){
				jQuery($G(tdname)).html(data.name);
				jQuery($G(inputename)).val(data.id);
			}else{
				jQuery($G(tdname)).html("");
				jQuery($G(inputename)).val("");
			}
	}
}
</script>
<script language = vbs>


sub onShowWorkflow(tdname , inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value = ""
		end if
	end if
end sub
</script>
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</body>
</html>
