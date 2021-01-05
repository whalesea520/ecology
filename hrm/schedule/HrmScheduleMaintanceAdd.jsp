<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>

<HTML>
<HEAD>
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add" , user)) {
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	} 
int level = Util.getIntValue(HrmUserVarify.getRightLevel("HrmScheduleMaintanceAdd:Add" , user)) ; 
String sqlwhere = "" ; 
if(level == 0 ) { 
    int departmentid = user.getUserDepartment() ; 
    sqlwhere = "?sqlwhere=where departmentid = "+departmentid ; 
}
if(level == 1 ) {
    int subcompanyid1 = user.getUserSubCompany1() ; 
    sqlwhere = "?sqlwhere=where subcompanyid1 = " + subcompanyid1 ; 
} 
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(6138 , user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(82 , user.getLanguage()) + SystemEnv.getHtmlLabelName(277 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 

boolean CanAdd = HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add" , user) ; 
String resourceid = Util.null2String(request.getParameter("resourceid")) ; 
String diffid     = Util.null2String(request.getParameter("diffid")) ; 
String startdate  = Util.null2String(request.getParameter("startdate")) ; 
String starttime  = Util.null2String(request.getParameter("starttime")) ; 
String enddate    = Util.null2String(request.getParameter("enddate")) ; 
String endtime    = Util.null2String(request.getParameter("endtime")) ; 
String totaltime  = Util.null2String(request.getParameter("totaltime")) ; 
String totalday   = Util.null2String(request.getParameter("totalday")) ; 
String memo       = Util.null2String(request.getParameter("memo")) ; 

// 从考勤偏差来的信息
String departmentid  = Util.null2String(request.getParameter("departmentid")) ; 
String resourceidpar  = Util.null2String(request.getParameter("resourceidpar")) ; 
String isself  = Util.null2String(request.getParameter("isself")) ; 
String counttime       = Util.null2String(request.getParameter("counttime")) ; 
String fromdate       = Util.null2String(request.getParameter("fromdate")) ; 
String theenddate       = Util.null2String(request.getParameter("theenddate")) ; 
String worktimeid       = Util.null2String(request.getParameter("worktimeid")) ; 

String backurl = "" ;
if( fromdate.equals("") ) backurl = "HrmScheduleMaintance.jsp" ;
else backurl = "HrmWorkTimeWarpList.jsp?fromdate="+fromdate+"&enddate="+theenddate ;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmScheduleMaintance:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+79+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+","+backurl+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmmain name=frmmain method=post action="HrmScheduleMaintanceOperation.jsp">
<input class=inputstyle type="hidden" name="operation">
<input class=inputstyle type="hidden" name="createtype" value="1">
<input class=inputstyle type="hidden" name="counttime" value="<%=counttime%>">
<input class=inputstyle type="hidden" name="fromdate" value="<%=fromdate%>">
<input class=inputstyle type="hidden" name="theenddate" value="<%=theenddate%>">
<input class=inputstyle type="hidden" name="worktimeid" value="<%=worktimeid%>">
<input class=inputstyle type="hidden" name="departmentid" value="<%=departmentid%>">
<input class=inputstyle type="hidden" name="resourceidpar" value="<%=resourceidpar%>">
<input class=inputstyle type="hidden" name="isself" value="<%=isself%>">
 
<table class=Viewform>
  <colgroup>
  <col width="30%">
  <col width="70%">    
  <tbody>
    <tr class=Title>
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(6138,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height:2px"> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
    <%
    %>

    <tr>
      <td><%=SystemEnv.getHtmlLabelName(16055,user.getLanguage())%></td>
      <td class=field>         
              <BUTTON class=Browser type="button" onclick="onShowResourceID(resourceid,resourceidspan)"></BUTTON> 
              <SPAN id=resourceidspan>
              <%if(!resourceid.equals("")){
                  String tempresourcename = "" ;
                  ArrayList al = Util.TokenizerString(resourceid , ",") ; 
                  for(int i = 0 ; i < al.size() ; i++) { 
                      String tempresourceid = (String)al.get(i) ; 
                      tempresourcename += ","+ResourceComInfo.getResourcename(tempresourceid) ;
                  }
                  if(!tempresourcename.equals("")) tempresourcename = tempresourcename.substring(1) ;

              %>
              <%=tempresourcename%>
              <%}else{%>
              <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              <%}%>
              </SPAN> 
              <input class=inputstyle type=hidden name=resourceid value="<%=resourceid%>" onChange="checkinput('resourceid','resourceidspan')">
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%></td>
      <td class=field>
          
          <input class="wuiBrowser" type=hidden name=diffid value="<%=diffid%>" onChange='checkinput("diffid","diffidspan")'
		  _url="/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp"
		  _displayText="<%=ScheduleDiffComInfo.getDiffname(diffid)%>"
		  _required="yes">
       </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
      <td class=field>
         <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON> 
         <SPAN id=startdatespan >
         <%if(!startdate.equals("")){%><%=startdate%><%}else{%>
              <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              <%}%>
         </SPAN> 
         <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>" onChange='checkinput("startdate","startdatespan")'>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=field>
         <button class=Clock type="button" onclick="onShowTime(starttimespan,starttime)"></button>
         <span id="starttimespan"><%=starttime%></span>
         <input class=inputstyle type=hidden name="starttime" value=<%=starttime%>>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
      <td class=field>
        <BUTTON class=Calendar type="button" id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
         <SPAN id=enddatespan >
         <%if(!enddate.equals("")){%><%=enddate%><%}else{%>
              <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
              <%}%>
         </SPAN> 
          <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>" onChange='checkinput("enddate","enddatespan")'>
      </td>  
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=field>
        <button class=Clock type="button" onclick="onShowTime(endtimespan,endtime)"></button>
         <span id="endtimespan"><%=endtime%></span>
         <input class=inputstyle type=hidden name="endtime" value=<%=endtime%>>
       </td>
    </tr>     
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(16056,user.getLanguage())%></td>
      <td class=field>        
         <input class=inputstyle type=text maxlength=10 name="totaltime" value=<%=totaltime%>><%=SystemEnv.getHtmlLabelName(129096, user.getLanguage())%> hh:mm
       </td>
    </tr>  
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(791,user.getLanguage())%></td>
      <td class=FIELD>
      <textarea class=inputstyle name=memo rows=8 cols=50 value="<%=memo%>"><%=memo%></textarea>      
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  </tbody>
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
<script language=javascript>
function doSave() { 
  if(document.frmmain.startdate.value > document.frmmain.enddate.value) {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>") ; 
    } else { 
        if(document.frmmain.startdate.value == document.frmmain.enddate.value && document.frmmain.starttime.value > document.frmmain.endtime.value) { 
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>") ; 
      } else {
	document.frmmain.operation.value = "insert" ; 
	if(check_form(document.frmmain , 'resourceid,diffid,startdate,enddate'))
	document.frmmain.submit() ; 
    }
  }
}
function doDelete() {  
	if(confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>")) { 
		document.frmmain.operation.value="delete" ; 
		document.frmmain.submit() ; 
	} 
} 

function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);

			jQuery(inputname).val(ids);
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");

			linkurl = ""

			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];

				sHtml += "<a target='_blank' href=/hrm/resource/HrmResource.jsp?id=" + curid + ">" + curname + "</a>&nbsp;";
			}

			jQuery(spanname).html(sHtml);
		} else {
			jQuery(inputname).val("");
			jQuery(spanname).html("");
		}
	}
}

function onShowResourceID(inputname,spanname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp<%=sqlwhere%>",inputname,spanname);
}
</script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language=vbs>
sub onShowResourceID1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp<%=sqlwhere%>")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            resourceidspan.innerHtml = Mid(id(1),2,len(id(1)))
            frmmain.resourceid.value=Mid(id(0),2,len(id(0)))
        else 
            resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
            frmmain.resourceid.value=""
	end if
	end if
end sub

sub onShowSalaryItem(tdname , inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value = ""
		end if
	end if
end sub
sub onShowScheduleDiff(tdname , inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value = ""
		end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>