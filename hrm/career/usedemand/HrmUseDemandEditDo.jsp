<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmUseDemandEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String id = request.getParameter("id");

String jobtitle = "";
String demandnum = "";
String otherrequest = "";
String date = "";
int status = 0;
String leastedulevel = "";
int createkind = 0;
String demandkind = "";

String sql = "select * from HrmUseDemand where id ="+id;
rs.executeSql(sql); 
while(rs.next()){
  jobtitle = Util.null2String(rs.getString("demandjobtitle"));
  demandnum = Util.null2String(rs.getString("demandnum"));
  status = Util.getIntValue(rs.getString("status"),0);
  leastedulevel = Util.null2String(rs.getString("leastedulevel"));  
  date = Util.null2String(rs.getString("demandregdate"));
  otherrequest = Util.toScreenToEdit(rs.getString("otherrequest"),user.getLanguage());
  createkind = Util.getIntValue(rs.getString("createkind"),0);
  demandkind = Util.null2String(rs.getString("demandkind"));
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6131,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmUseDemandEdit:Edit", user)&&createkind == 1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmUseDemandDelete:Delete", user)&&createkind == 1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmUseDemand:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+69+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/usedemand/HrmUseDemandEdit.jsp?id="+id+",_self} " ;
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
<FORM id=weaver name=frmMain action="UseDemandOperation.jsp" method=post >
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></TH></TR>
  <TR class= Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
          <TD class=Field>

              <input class="wuiBrowser" id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
			  _required="yes" _displayText="<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>">                                  
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
          <TD class=Field>
            <input class=inputstyle type=text size=30 name="demandnum" value="<%=demandnum%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("demandnum")' onchange='checkinput("demandnum","demandnumspan")'>
             <SPAN id=demandnumspan></SPAN> 
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></td>
          <td class=Field >

             <input class="wuiBrowser" type=hidden name=demandkind value="<%=demandkind%>"
			 _url="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp"
			 _displayText="<%=UseKindComInfo.getUseKindname(demandkind)%>">                        
          </td>
        </tr>          
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field>
<%if(status == 4){%><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%><%}else{%>          
            <select class=inputstyle name=status value="<%=status %>">
              <option value=0 <%if(status  == 0){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%></option>
              <option value=1 <%if(status  == 1){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15747,user.getLanguage())%></option>
              <option value=2 <%if(status  == 2){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15748,user.getLanguage())%></option>
              <option value=3 <%if(status  == 3){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15749,user.getLanguage())%></option>
<!--              <option value=4 <%if(status  == 4){%>selected <%}%>>效</option>              -->
            </select>
<%}%>            
          </TD>
        </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TD>
          <TD class=Field>
<!--          
            <select class=inputstyle id=leastedulevel name="leastedulevel" value="<%=leastedulevel%>">
	            <option value=0 <%if(leastedulevel.equals("0")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
	            <option value=1 <%if(leastedulevel.equals("1")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%></option>
	            <option value=2 <%if(leastedulevel.equals("2")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%></option>
	            <option value=12 <%if(leastedulevel.equals("12")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%></option>
	            <option value=13 <%if(leastedulevel.equals("13")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%></option>
	            <option value=3 <%if(leastedulevel.equals("3")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%></option>
	            <option value=4 <%if(leastedulevel.equals("4")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%></option>
	            <option value=5 <%if(leastedulevel.equals("5")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%></option>
	            <option value=6 <%if(leastedulevel.equals("6")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%></option>
	            <option value=7 <%if(leastedulevel.equals("7")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%></option>
	            <option value=8 <%if(leastedulevel.equals("8")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%></option>
	            <option value=9 <%if(leastedulevel.equals("9")){%>selected <%}%> >MBA</option>
	            <option value=10 <%if(leastedulevel.equals("10")){%>selected <%}%> >EMBA</option>
	            <option value=11 <%if(leastedulevel.equals("11")){%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%></option>
	     </select>              
-->	     

	      <input class="wuiBrowser" type=hidden name=leastedulevel value="<%=leastedulevel%>"
		  _url="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
		  _displayText="<%=EducationLevelComInfo.getEducationLevelname(leastedulevel)%>">
          </TD>
        </TR>         
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,date)"></BUTTON> 
              <SPAN id=datespan ><%=date%></SPAN> 
              <input class=inputstyle type="hidden" id="date" name="date" value="<%=date%>">                        
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=otherrequest value="<%=otherrequest%>"><%=otherrequest%></textarea>
          </td>
        </tr>     
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
 </form>
<script language=vbs>
sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	frmMain.demandkind.value=id(0)
	else 
	usekindspan.innerHtml = ""
	frmMain.demandkind.value=""
	end if
	end if
end sub
sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmMain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.jobtitle.value=""
	end if
	end if
end sub

sub onShowEduLevel(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	inputspan.innerHtml = id(1)
	inputname.value=id(0)
	else 
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
 <script language=javascript>
 function doedit(){
   if(check_form(document.frmMain,'jobtitle,demandnum')){
   document.frmMain.operation.value="edit";
   document.frmMain.submit();
   }
 }
 function dodelete(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
     document.frmMain.operation.value="delete";
     document.frmMain.submit();
   }
 }
 function doclose(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15751,user.getLanguage())%>")){
     document.frmMain.operation.value="close";
     document.frmMain.submit();
   }
 }
</script> 
</BODY> 
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>