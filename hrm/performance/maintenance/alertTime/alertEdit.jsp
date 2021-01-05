<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("AlertTimeInfo:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18046,user.getLanguage());
String needfav ="1";
String needhelp ="";

RecordSet.execute("select * from HrmPerformanceAlert order by type_a" );

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM name=resource id=resource action="AlertOperation.jsp" method=post>

   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="30%"> 
    <COL width="30%">
    <COL width="30%">  
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width="10%"> 
                     <COL width="30%"> 
				    <COL width="30%">
				    <COL width="30%">   <TBODY> 
          <TR class=title> 
            <TH colSpan=4 ><%=SystemEnv.getHtmlLabelName(18106,user.getLanguage())%></TH> <!--目标提醒-->
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=4></TD>
          </TR>
           <TR class=Header>
  		   <th></th>
           <th><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
           <th><%=SystemEnv.getHtmlLabelName(18079,user.getLanguage())%></th>
           <th><%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%></th>
           </tr>
      <TR class=Line><TD colspan="4" ></TD></TR>
     <TR CLASS=DataLight><!--年度提醒-->
       <td></td>
     <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
      <select class=inputStyle id=yearCondition1 
              name=yearCondition1>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
               <!--0:开始 1：结束-->
      </select>
           <select class=inputStyle id=yearCondition2 
              name=yearCondition2>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(18109,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(18110,user.getLanguage())%></option>
               <!--0:前 1：后-->
      </select>
      <input class=inputstyle maxlength=2 size=2 name=yearConCount id=yearConCount onchange='checknumber("yearConCount")'> >
     <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></td>
     <td> 
     <input class=inputstyle maxlength=2 size=2 name=yearAlertCount id=yearAlertCount onchange='checknumber("yearAlertCount")'> >
     <select class=inputStyle id=yearAlertUnit
              name=yearAlertUnit>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
                <!--0:天 1：小时-->
      </select>
      </td>
     <td>
     <input type="radio" value=0 checked name=yFrequency><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%><br>
      <input type="radio" value=1 checked name=yrFrequency><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%><input class=inputstyle maxlength=2 size=2 name=yearFrequency id=yearFrequency onchange='checknumber("yearFrequency")'> ><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%>,
      <%=SystemEnv.getHtmlLabelName(18084,user.getLanguage())%><input class=inputstyle maxlength=2 size=2 name=yearInterval id=yearInterval onchange='checknumber("yearInterval")'> ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
      </td>
   
     </TR>
      <TR CLASS=DataDark> <!--季度提醒-->
       <td></td>
     <td><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%>
      <select class=inputStyle id=quarterCondition1 
              name=quarterCondition1>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
               
      </select><!--0:开始 1：结束-->
       <select class=inputStyle id=quarterCondition2 
              name=quarterCondition2>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(18109,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(18110,user.getLanguage())%></option>
               <!--0:前 1：后-->
      </select>
       <input class=inputstyle maxlength=2 size=2 name=quarterConCount id=quarterConCount onchange='checknumber("quarterConCount")'> >
     <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></td>
     <td> <input class=inputstyle maxlength=2 size=2 name=quarterAlertCount id=quarterAlertCount onchange='checknumber("quarterAlertCount")'> >
     <select class=inputStyle id=quarterAlertUnit
              name=quarterAlertUnit>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
               <!--0:天 1：小时-->
      </select></td>
      <td> <input type="radio" value=0 checked name=qFrequency><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%><br>
      <input type="radio" value=1 checked name=qrFrequency><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%><input class=inputstyle maxlength=2 size=2 name=quarteFrequency id=quarteFrequency onchange='checknumber("quarteFrequency")'> ><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%>,
      <%=SystemEnv.getHtmlLabelName(18084,user.getLanguage())%><input class=inputstyle maxlength=2 size=2 name=quarteInterval id=quarteInterval onchange='checknumber("quarteInterval")'> ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
      </td>
    
     </TR>
      <TR CLASS=DataLight><!--月-->
      <td></td>
     <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
      <select class=inputStyle id=monthCondition1 
              name=monthCondition1>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
               <!--0:开始 1：结束-->
      </select>
           <select class=inputStyle id=monthCondition2 
              name=monthCondition2>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(18109,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(18110,user.getLanguage())%></option>
                <!--0:前 1：后-->
      </select>
       <input class=inputstyle maxlength=2 size=2 name=monthConCount id=monthConCount onchange='checknumber("monthConCount")'> >
     <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></td>
     <td><input class=inputstyle maxlength=2 size=2 name=monthAlertUnit id=monthAlertUnit onchange='checknumber("monthAlertUnit")'> >
     <select class=inputStyle id=monthAlertUnit
              name=monthAlertUnit>
                <option value=0 selected><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
                <option value=1 ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
               <!--0:天 1：小时-->
      </select></td>
      <td>
      <input type="radio" value=0 checked name=mFrequency><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%><br>
      <input type="radio" value=1 checked name=mFrequency><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%><input class=inputstyle maxlength=2 size=2 name=monthFrequency id=monthFrequency onchange='checknumber("monthFrequency")'> ><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%>,
      <%=SystemEnv.getHtmlLabelName(18084,user.getLanguage())%><input class=inputstyle maxlength=2 size=2 name=monthInterval id=monthInterval onchange='checknumber("monthInterval")'> ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
      </td>
     </TR>
          </TBODY> 
        </TABLE>
      </TD>
  </FORM>
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


<SCRIPT language="javascript">
function OnSubmit(){
    
	{	if(check_form(document.resource,"relatingFlow"))
	{
		document.resource.submit();
		enablemenu();
		}
	}
}</SCRIPT>
<SCRIPT language="vbs">

sub onShowFlowID() 
     id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/FlowBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	flowidspan.innerHtml = id(1)
	resource.relatingFlow.value=id(0)
	else
	flowidspan.innerHtml = ""
	resource.relatingFlow.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>