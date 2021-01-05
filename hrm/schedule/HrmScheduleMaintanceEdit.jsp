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
<HTML><HEAD>
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmmain.resourceid.value=""
	end if
	end if
end sub

sub onShowSalaryItem(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value=""
		end if
	end if
end sub
sub onShowScheduleDiff(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub
</script>
</head>
<%

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6138,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(277,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean CanEdit = HrmUserVarify.checkUserRight("HrmScheduleMaintanceEdit:Edit", user);
boolean CanDelete=HrmUserVarify.checkUserRight("HrmScheduleMaintanceDelete:Delete", user);
int id = Util.getIntValue(request.getParameter("id"),0);

String sql = "select * from HrmScheduleMaintance where id = "+id;
rs.executeSql(sql);
rs.next();
String resourceid = Util.null2String(rs.getString("resourceid"));
String diffid = Util.null2String(rs.getString("diffid"));
String startdate = Util.null2String(rs.getString("startdate"));
String starttime = Util.null2String(rs.getString("starttime"));

String enddate = Util.null2String(rs.getString("enddate"));
String endtime = Util.null2String(rs.getString("endtime"));
String memo = Util.toScreenToEdit(rs.getString("memo"),user.getLanguage());
int realdifftime =   Util.getIntValue(rs.getString("realdifftime"),0);

int realdiffhour = realdifftime/60 ;
int realdiffmin = realdifftime - realdiffhour*60 ;
String totaltime = Util.add0(realdiffhour,2) + ":" + Util.add0(realdiffmin,2) ;


String resourceidpar = Util.null2String(request.getParameter("resourceid"));
if(!resourceidpar.equals("")){
  resourceid = resourceidpar;
}
String diffidpar = Util.null2String(request.getParameter("diffid"));
if(!diffidpar.equals("")){
  diffid = diffidpar;
}
String startdatepar = Util.null2String(request.getParameter("startdate"));
if(!startdatepar.equals("")){
  startdate = startdatepar;
}
String starttimepar = Util.null2String(request.getParameter("starttime"));
if(!starttimepar.equals("")){
  starttime = starttimepar;
}
String enddatepar = Util.null2String(request.getParameter("enddate"));
if(!enddatepar.equals("")){
  enddate = enddatepar;
}
String endtimepar = Util.null2String(request.getParameter("endtime"));
if(!endtimepar.equals("")){
  endtime = endtimepar;
}
String totaltimepar = Util.null2String(request.getParameter("totaltime"));
if(!totaltimepar.equals("")){
  totaltime = totaltimepar;
}
String memopar = Util.null2String(request.getParameter("memo"));
if(!memopar.equals("")){
  memo = memopar;
}

String fromdate       = Util.null2String(request.getParameter("fromdate")) ; 
String theenddate       = Util.null2String(request.getParameter("theenddate")) ;

String backurl = "" ;
if( fromdate.equals("") ) backurl = "HrmScheduleMaintanceView.jsp?id="+id ;
else backurl = "HrmWorkTimeWarpList.jsp?fromdate="+fromdate+"&enddate="+theenddate ;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanDelete){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmScheduleMaintance:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+79+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmScheduleMaintanceView.jsp?id="+id+",_self} " ;
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
<input class=inputstyle type="hidden" name="id" value="<%=id%>">
<input class=inputstyle type="hidden" name="fromdate" value="<%=fromdate%>">
<input class=inputstyle type="hidden" name="theenddate" value="<%=theenddate%>">
<div>
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
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <tr>
      <td><%=SystemEnv.getHtmlLabelName(16055,user.getLanguage())%></td>
      <td class=field>         
              <%=ResourceComInfo.getResourcename(resourceid)%>
              <input class=inputstyle type=hidden name=resourceid value="<%=resourceid%>" onChange='checkinput("resourceid","resourceidspan")'>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%></td>
      <td class=field>

          <input class="wuiBrowser" type=hidden name=diffid value="<%=diffid%>" onChange='checkinput("diffid","diffidspan")'
		  _url="/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp"
		  _displayText="<%=ScheduleDiffComInfo.getDiffname(diffid)%>">
       </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
      <td class=field>
         <BUTTON class=Calendar type="button" id=selectstartdate onclick="getSdHrmDate(startdatespan,startdate)"></BUTTON> 
         <SPAN id=startdatespan ><%=startdate%></SPAN> 
         <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>" onChange='checkinput("startdate","startdatespan")'>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=field>
         <button class=Clock type="button" onclick="onHrmSdTime(starttimespan,starttime)"></button>
         <span id="starttimespan"><%=starttime%></span>
         <input class=inputstyle type=hidden name="starttime" value=<%=starttime%>>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
      <td class=field>
        <BUTTON class=Calendar type="button" id=selectenddate onclick="getSdHrmDate(enddatespan,enddate)"></BUTTON> 
         <SPAN id=enddatespan ><%=enddate%></SPAN> 
         <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>" onChange='checkinput("enddate","enddatespan")'>
      </td>  
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=field>
        <button class=Clock type="button" onclick="onHrmSdTime(endtimespan,endtime)"></button>
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
<td height="10" colspan="3"></td>
</tr>
</table>
<script language=javascript>
function doSave(){
    if(document.frmmain.startdate.value>document.frmmain.enddate.value){
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
    }else{
      if(document.frmmain.startdate.value==document.frmmain.enddate.value&&document.frmmain.starttime.value>document.frmmain.endtime.value){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
      }else{
	document.frmmain.operation.value="save";
	if(check_form(document.frmmain,'resourceid,diffid,startdate,enddate'))
	document.frmmain.submit();	
      }
    }
}
function dosubmit(){
    if(document.frmmain.startdate.value>document.frmmain.enddate.value){
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
    }else{
      if(document.frmmain.startdate.value==document.frmmain.enddate.value&&document.frmmain.starttime.value>document.frmmain.endtime.value){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
      }else{	
	if(check_form(document.frmmain,'resourceid,diffid,startdate,enddate'))
	document.frmmain.operation.value="submit";
	document.frmmain.submit();	
      }
    }
}
function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmmain.operation.value="delete";
		document.frmmain.submit();
	}
}
</script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>