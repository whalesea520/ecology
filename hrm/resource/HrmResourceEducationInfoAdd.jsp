<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
String applyid	  =	Util.null2String(request.getParameter("applyid")) ;

if((!HrmUserVarify.checkUserRight("HrmResourceEducationInfoAdd:Add",user))&&applyid.equals("")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(813,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action="HrmResourceEducationInfoOperation.jsp?"Action=2 method=post>
  <DIV><BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> </DIV>

<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="applyid" value="<%=applyid%>">
<input type="hidden" name="operation" value="add">

  <TABLE class=Form>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
  <TR class=Section> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
    <TR class=Separator> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
    <tr> 
        <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
          <td class=Field><button class=Calendar type="button" id=selectstartdate onClick="getstartDate()"></button> 
              <span id=startdatespan ></span> 
              <input type="hidden" name="startdate">
          </td>
          </tr>
          <tr> 
         <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
            <td class=Field><button class=Calendar type="button" id=selectenddate onClick="getHendDate()"></button> 
              <span id=enddatespan ></span> 
              <input type="hidden" name="enddate">
            </td>
          </tr>
	<tr> 
            <td><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
            <td class=Field> 
              <select class=saveHistory id=educationlevel name=educationlevel>
                <option value="0" selected><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
                <option value="1" ><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%></option>
				<option value="2" ><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%></option>
                <option value="3" ><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%></option>
                <option value="4" ><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%></option>
                <option value="5" ><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%></option>
                <option value="6" ><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%></option>
                <option value="7" ><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%></option>
                <option value="8" ><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%></option>

              </select>
            </td>
    </tr>
	 <tr> 
      <td><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></td>
      <td class=Field>   
	  <INPUT class=saveHistory maxLength=60 size=30 name=speciality>
      </TD>
    </tr>

    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1850,user.getLanguage())%></TD>
	  <TD class=Field> 
              <INPUT class=Field maxLength=100 size=30 name="school"
            onchange='checkinput("school","schoolimage")'>
              <SPAN id=schoolimage><IMG 
            src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR>
    
   
    <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%></TD>
      <TD class=Field> 
        <textarea class="saveHistory"  style="width:90%" name=studydesc rows="6"></textarea>
      </TD>
    </TR>
     
    </TBODY> 
  </TABLE>
</FORM>
<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"school"))
	{	
		document.frmain.submit();
	}
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
