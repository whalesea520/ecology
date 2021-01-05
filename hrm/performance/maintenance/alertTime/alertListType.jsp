<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

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
<BODY >

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String type=Util.null2String(request.getParameter("type"));
   String yearCondition1="0";
    String yearCondition2="0";
    String yearConCount="";
    String yearAlertCount="";
    String yearAlertUnit="0";
    String yearFrequency="1";
    String yearInterval="";
    String yFrequency="";
    
    String monthCondition1="0";
    String monthCondition2="0";
    String monthConCount="";
    String monthAlertCount="";
    String monthAlertUnit="0";
    String monthFrequency="1";
    String monthInterval="";
    String mFrequency="";
    
    String weekCondition1="0";
    String weekCondition2="0";
    String weekConCount="";
    String weekAlertCount="";
    String weekAlertUnit="0";
    String weekFrequency="1";
    String weekInterval="";
    String wFrequency="";
    
    String quarterCondition1="0";
    String quarterCondition2="0";
    String quarterConCount="";
    String quarterAlertCount="";
    String quarterAlertUnit="0";
    String quarterFrequency="1";
    String quarterInterval="";
    String qFrequency="";
if (type.equals("")) type="0";
rs.execute("select * from HrmPerformanceAlert where type_a='"+type+"' ");
if (rs.next())
{
     yearCondition1=Util.null2String(rs.getString("yearCondition1"));
     yearCondition2=Util.null2String(rs.getString("yearCondition2"));
     yearConCount=Util.null2String(rs.getString("yearConCount"));
     yearAlertCount=Util.null2String(rs.getString("yearAlertCount"));
     yearAlertUnit=Util.null2String(rs.getString("yearAlertUnit"));
     yearFrequency=Util.null2String(rs.getString("yearFrequency"));
     yearInterval=Util.null2String(rs.getString("yearInterval"));
     
     yearConCount=(yearConCount.equals("-1"))?"":yearConCount;
     yearAlertCount=(yearAlertCount.equals("-1"))?"":yearAlertCount;
     yearInterval=(yearInterval.equals("-1"))?"":yearInterval;
    // yFrequency=Util.null2String(rs.getString("yFrequency"));
    
     monthCondition1=Util.null2String(rs.getString("monthCondition1"));
     monthCondition2=Util.null2String(rs.getString("monthCondition2"));
     monthConCount=Util.null2String(rs.getString("monthConCount"));
     monthAlertCount=Util.null2String(rs.getString("monthAlertCount"));
     monthAlertUnit=Util.null2String(rs.getString("monthAlertUnit"));
     monthFrequency=Util.null2String(rs.getString("monthFrequency"));
     monthInterval=Util.null2String(rs.getString("monthInterval"));
     //mFrequency=Util.null2String(rs.getString("mFrequency"));
     monthConCount=(monthConCount.equals("-1"))?"":monthConCount;
     monthAlertCount=(monthAlertCount.equals("-1"))?"":monthAlertCount;
     monthInterval=(monthInterval.equals("-1"))?"":monthInterval;
     
     weekCondition1=Util.null2String(rs.getString("weekCondition1"));
     weekCondition2=Util.null2String(rs.getString("weekCondition2"));
     weekConCount=Util.null2String(rs.getString("weekConCount"));
     weekAlertCount=Util.null2String(rs.getString("weekAlertCount"));
     weekAlertUnit=Util.null2String(rs.getString("weekAlertUnit"));
     weekFrequency=Util.null2String(rs.getString("weekFrequency"));
     weekInterval=Util.null2String(rs.getString("weekInterval"));
    // wFrequency=Util.null2String(rs.getString("wFrequency"));
     weekConCount=(weekConCount.equals("-1"))?"":weekConCount;
     weekAlertCount=(weekAlertCount.equals("-1"))?"":weekAlertCount;
     weekInterval=(weekInterval.equals("-1"))?"":weekInterval;
     
     quarterCondition1=Util.null2String(rs.getString("quarterCondition1"));
     quarterCondition2=Util.null2String(rs.getString("quarterCondition2"));
     quarterConCount=Util.null2String(rs.getString("quarterConCount"));
     quarterAlertCount=Util.null2String(rs.getString("quarterAlertCount"));
     quarterAlertUnit=Util.null2String(rs.getString("quarterAlertUnit"));
     quarterFrequency=Util.null2String(rs.getString("quarterFrequency"));
     quarterInterval=Util.null2String(rs.getString("quarterInterval"));
     //qFrequency=Util.null2String(rs.getString("qFrequency"));
     quarterConCount=(quarterConCount.equals("-1"))?"":quarterConCount;
     quarterAlertCount=(quarterAlertCount.equals("-1"))?"":quarterAlertCount;
     quarterInterval=(quarterInterval.equals("-1"))?"":quarterInterval;
}
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

<FORM name=resource id=resource action="alertOperation.jsp" method=post>
<input type=hidden name=type value=<%=type%>>
   <TABLE class=ListStyle cellspacing=1>
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="30%"> 
    <COL width="30%"> 
    <!-- COL width="30%"--> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP>    <COL width="10%"> 
		    <COL width="30%"> 
		    <COL width="30%"> 
		    <!-- COL width="30%"--> <TBODY> 
            <TR class=Header>
              <th></th>
			  <th>
			  <%if (type.equals("0")) {%>
			  <%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%>
			  <%}
			  else {%>
			  <%
			  out.print(SystemEnv.getHtmlLabelName(18111,user.getLanguage()));
			  }
			  %>
			  </th>
			  <th><%=SystemEnv.getHtmlLabelName(18079,user.getLanguage())%></th>
			  <!-- th><%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%></th-->
			  </tr>
              <TR class=Line><TD colspan="3" ></TD></TR> 
             <!--年度提醒-->
              <TR CLASS=DataLight> 
             <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
             <TD class=Field> 
              <%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
              <select class=inputStyle id=yearCondition1 
              name=yearCondition1 onchange="changes()">
                <option value=0 <%if (yearCondition1.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value=1 <%if (yearCondition1.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
               
              </select><!--0:开始 1：结束-->
                <select class=inputStyle id=yearCondition2 
              name=yearCondition2 onchange="changes()">
                <option value=0 <%if (yearCondition2.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18109,user.getLanguage())%></option>
                <option value=1 <%if (yearCondition2.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18110,user.getLanguage())%></option>
               
              </select><!--0:前 1：后-->
              <input class=inputstyle  maxLength=2 size=2
              
              name=yearConCount id=yearConCount value="<%=yearConCount%>" onchange='checknumber("yearConCount");changes()'>
              <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
            </TD>
            <td>
            <input class=inputstyle  maxLength=2 size=2
              name=yearAlertCount id=yearAlertCount value="<%=yearAlertCount%>" onchange='checknumber("yearAlertCount");changes()'>
               <select class=inputStyle id=yearAlertUnit 
              name=yearAlertUnit onchange="changes()">
                <option value=0 <%if (yearAlertUnit.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
                <option value=1 <%if (yearAlertUnit.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
               
              </select><!--0:天 1：小时-->
            </td>
            <!--提醒频率-->
            <!-- td>
            <input type=radio name=yFrequency id=yFrequency value=0 <%if (yearFrequency.equals("1")) {%>checked <%}%> onclick="disableinput('year')"><%=SystemEnv.getHtmlLabelName(18081,user.getLanguage())%><br>
            <input type=radio name=yFrequency id=yFrequency value=1 <%if (!yearFrequency.equals("1")) {%>checked <%}%> onclick="enableinput('year')"><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>
            <input class=inputstyle  maxLength=2 size=2
              name=yearFrequency id=yearFrequency value="<%=yearFrequency%>" onchange='checknumber("yearFrequency")'><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%>,
           <%=SystemEnv.getHtmlLabelName(18084,user.getLanguage())%>
           <input class=inputstyle  maxLength=2 size=2
              name=yearInterval id=yearInterval value="<%=yearInterval%>" onchange='checknumber("yearInterval")'><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
            </td-->
          </TR>
          <!--年度提醒结束-->
           <!--季度提醒-->
              <TR CLASS=DataDark>
             <TD><%=SystemEnv.getHtmlLabelName(18280,user.getLanguage())%></TD>
             <TD class=Field> 
              <%=SystemEnv.getHtmlLabelName(18280,user.getLanguage())%>
              <select class=inputStyle id=quarterCondition1 
              name=quarterCondition1 onchange="changes()">
                <option value=0 <%if (quarterCondition1.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value=1 <%if (quarterCondition1.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
               
              </select><!--0:开始 1：结束-->
                <select class=inputStyle id=quarterCondition2 
              name=quarterCondition2 onchange="changes()">
                <option value=0 <%if (quarterCondition2.equals("0")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(18109,user.getLanguage())%></option>
                <option value=1 <%if (quarterCondition2.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(18110,user.getLanguage())%></option>
               
              </select><!--0:前 1：后-->
              <input class=inputstyle  maxLength=2 size=2
              name=quarterConCount id=quarterConCount value="<%=quarterConCount%>" onchange='checknumber("quarterConCount");changes()'>
              <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
            </TD>
            <td>
            <input class=inputstyle  maxLength=2 size=2
              name=quarterAlertCount id=quarterAlertCount value="<%=quarterAlertCount%>" onchange='checknumber("quarterAlertCount");changes()'>
               <select class=inputStyle id=quarterAlertUnit 
              name=quarterAlertUnit onchange="changes()">
                <option value=0 <%if (quarterAlertUnit.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
                <option value=1 <%if (quarterAlertUnit.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
               
              </select><!--0:天 1：小时-->
            </td>
            <!-- td>
            <input type=radio name=qFrequency id=qFrequency value=0 <%if (quarterFrequency.equals("1")) {%>checked <%}%> onclick="disableinput('quarter')"><%=SystemEnv.getHtmlLabelName(18081,user.getLanguage())%><br>
            <input type=radio name=qFrequency id=qFrequency value=1 <%if (!quarterFrequency.equals("1")) {%>checked <%}%> onclick="enableinput('quarter')"><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>
            <input class=inputstyle  maxLength=2 size=2
              name=quarterFrequency id=quarterFrequency  value="<%=quarterFrequency%>"  onchange='checknumber("quarterFrequency")'><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%>,
           <%=SystemEnv.getHtmlLabelName(18084,user.getLanguage())%>
           <input class=inputstyle  maxLength=2 size=2
              name=quarterInterval id=quarterInterval value="<%=quarterInterval%>"  onchange='checknumber("quarterInterval")'><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
            </td-->
          </TR>
          <!--季度提醒结束-->
          <!--月提醒-->
              <TR CLASS=DataLight> 
             <TD><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></TD>
             <TD class=Field> 
              <%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
              <select class=inputStyle id=monthCondition1 
              name=monthCondition1 onchange="changes()">
                <option value=0 <%if (monthCondition1.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value=1 <%if (monthCondition1.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
               
              </select><!--0:开始 1：结束-->
                <select class=inputStyle id=monthCondition2 
              name=monthCondition2 onchange="changes()">
                <option value=0 <%if (monthCondition2.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18109,user.getLanguage())%></option>
                <option value=1 <%if (monthCondition2.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(18110,user.getLanguage())%></option>
               
              </select><!--0:前 1：后-->
              <input class=inputstyle  maxLength=2 size=2
              name=monthConCount id=monthConCount value="<%=monthConCount%>"  onchange='checknumber("monthConCount");changes()'>
              <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
            </TD>
            <td>
            <input class=inputstyle  maxLength=2 size=2
              name=monthAlertCount id=monthAlertCount value="<%=monthAlertCount%>"  onchange='checknumber("monthAlertCount");changes()'>
               <select class=inputStyle id=monthAlertUnit 
              name=monthAlertUnit onchange="changes()">
                <option value=0 <%if (monthAlertUnit.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
                <option value=1 <%if (monthAlertUnit.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
               
              </select><!--0:天 1：小时-->
            </td>
            <!-- td>
            <input type=radio name=mFrequency id=mFrequency value=0 <%if (monthFrequency.equals("1")) {%>checked <%}%> onclick="disableinput('month')"><%=SystemEnv.getHtmlLabelName(18081,user.getLanguage())%><br>
            <input type=radio name=mFrequency id=mFrequency value=1 <%if (!monthFrequency.equals("1")) {%>checked <%}%> onclick="enableinput('month')"><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>
            <input class=inputstyle  maxLength=2 size=2
              name=monthFrequency id=monthFrequency value="<%=monthFrequency%>" onchange='checknumber("monthFrequency")'><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%>,
           <%=SystemEnv.getHtmlLabelName(18084,user.getLanguage())%>
           <input class=inputstyle  maxLength=2 size=2
              name=monthInterval id=monthInterval value="<%=monthInterval%>" onchange='checknumber("monthInterval")'><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
            </td-->
          </TR>
          <!--月醒结束-->
          <!--报告和计划有周提醒设置-->
          <%if (type.equals("1")||type.equals("2")) {%>
               <!--周提醒-->
              <TR CLASS=DataLight> 
             <TD><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></TD>
             <TD class=Field> 
              <%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%>
              <select class=inputStyle id=weekCondition1 
              name=weekCondition1 onchange="changes()">
                <option value=0 <%if (weekCondition1.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%></option>
                <option value=1 <%if (weekCondition1.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
               
              </select><!--0:开始 1：结束-->
                <select class=inputStyle id=weekCondition2 
              name=weekCondition2 onchange="changes()">
                <option value=0 <%if (weekCondition1.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18109,user.getLanguage())%></option>
                <option value=1 <%if (weekCondition2.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(18110,user.getLanguage())%></option>
               
              </select><!--0:前 1：后-->
              <input class=inputstyle  maxLength=2 size=2
              name=weekConCount id=weekConCount value="<%=weekConCount%>"  onchange='checknumber("weekConCount");changes()'>
              <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
            </TD>
            <td>
            <input class=inputstyle  maxLength=2 size=2
              name=weekAlertCount id=weekAlertCount value="<%=weekAlertCount%>"  onchange='checknumber("weekAlertCount");changes()'>
               <select class=inputStyle id=weekAlertUnit 
              name=weekAlertUnit onchange="changes()">
                <option value=0 <%if (weekAlertUnit.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
                <option value=1  <%if (weekAlertUnit.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
               
              </select><!--0:天 1：小时-->
            </td>
            <!-- td>
            <input type=radio name=wFrequency id=wFrequency value=0 <%if (weekFrequency.equals("1")) {%>checked <%}%> onclick="disableinput('week')"><%=SystemEnv.getHtmlLabelName(18081,user.getLanguage())%><br>
            <input type=radio name=wFrequency id=wFrequency value=1 <%if (!weekFrequency.equals("1")) {%>checked <%}%> onclick="enableinput('week')"><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>
            <input class=inputstyle  maxLength=2 size=2
              name=weekFrequency id=weekFrequency value="<%=weekFrequency%>" onchange='checknumber("weekFrequency")'><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%>,
           <%=SystemEnv.getHtmlLabelName(18084,user.getLanguage())%>
           <input class=inputstyle  maxLength=2 size=2
              name=weekInterval id=weekInterval value="<%=weekInterval%>" onchange='checknumber("weekInterval")'><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
            </td-->
          </TR>
          <%}%>
          </TBODY> 
        </TABLE>
      </TD>
      <input type="hidden" name="changed" value="0">
      <button id="bton" name="bton" style="display:none"></button>
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

<script language="javascript" for="bton" event="onclick">
if (!protectsave())
{
parent.document.weaver.changed.value="1";
}
else
{parent.document.weaver.changed.value="0";
}
</script>
<SCRIPT language="javascript">
 function protectsave(){ 
        
        if (document.resource.changed.value=="1")
        { 
        if (!confirm("<%=SystemEnv.getHtmlLabelName(18399,user.getLanguage())%>"))
          return false; 
        }
      
        return true;
   }
 function changes()
     {
     document.resource.changed.value="1";
     }  
function OnSubmit(){
    if(checkfull())
	{	
		document.resource.submit();
		enablemenu();
	}
}
function enableinput(a)
{
var temp=a+"Frequency";
var temp2=a+"Interval"
document.all(temp).disabled=false;
document.all(temp2).disabled=false;
}
function disableinput(a)
{
var temp=a+"Frequency";
var temp2=a+"Interval"
document.all(temp).disabled=true;
document.all(temp2).disabled=true;
document.all(temp).value="";
document.all(temp2).value="";

}
function init()
{
for(i=0;i<document.all.yFrequency.length;i++)
{
if (document.all.yFrequency[i].checked)
{

if (i==0) 
{
document.all("yearFrequency").value="";
document.all("yearFrequency").disabled=true;
document.all("yearInterval").disabled=true;
}
}
}

for(i=0;i<document.all.qFrequency.length;i++)
{
if (document.all.qFrequency[i].checked)
{
if (i==0) {
document.all("quarterFrequency").value="";
document.all("quarterFrequency").disabled=true;
document.all("quarterInterval").disabled=true;
}
}
}
for(i=0;i<document.all.mFrequency.length;i++)
{
if (document.all.mFrequency[i].checked)
{
if (i==0) {
document.all("monthFrequency").value="";
document.all("monthFrequency").disabled=true;
document.all("monthInterval").disabled=true;
}
}
}
if (<%=type%>=="1"||<%=type%>=="2")
{
for(i=0;i<document.all.wFrequency.length;i++)
{
if (document.all.wFrequency[i].checked)
{
if (i==0) {
document.all("weekFrequency").value="";
document.all("weekFrequency").disabled=true;
document.all("weekInterval").disabled=true;
}
}
}
}
}
function checkfull()
{
qCheck="0" ;
wCheck="0" ;
mCheck="0" ;
yCheck="0" ;
if (<%=type%>=="1"||<%=type%>=="2")
{
if ((document.all("weekConCount").value!="" && document.all("weekAlertCount").value=="")||(document.all("weekConCount").value=="" && document.all("weekAlertCount").value!="" ))
{
   alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
}
if ((document.all("yearConCount").value!=""&&document.all("yearAlertCount").value=="")||(document.all("yearConCount").value==""&&document.all("yearAlertCount").value!=""))
{
   alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
if ((document.all("monthConCount").value!=""&&document.all("monthAlertCount").value=="")||(document.all("monthConCount").value==""&&document.all("monthAlertCount").value!=""))
{
    alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
if ((document.all("quarterConCount").value!=""&&document.all("quarterAlertCount").value=="")||(document.all("quarterConCount").value==""&&document.all("quarterAlertCount").value!=""))
{
    alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
/*
for(i=0;i<document.all.yFrequency.length;i++)
{
if (document.all.yFrequency[i].checked)
{
yCheck=document.all.yFrequency[i].value;
}
}

for(i=0;i<document.all.qFrequency.length;i++)
{
if (document.all.qFrequency[i].checked)
{
qCheck=document.all.qFrequency[i].value;
}
}
for(i=0;i<document.all.mFrequency.length;i++)
{
if (document.all.mFrequency[i].checked)
{
mCheck=document.all.mFrequency[i].value;
}
}
if (<%=type%>=="1"||<%=type%>=="2")
{
for(i=0;i<document.all.wFrequency.length;i++)
{
if (document.all.wFrequency[i].checked)
{
wCheck=document.all.wFrequency[i].value;
}
}
}
if (qCheck=="1")
{
if (document.all("quarterFrequency").value==""||document.all("quarterInterval").value==""||document.all("quarterConCount").value==""||document.all("quarterAlertCount").value=="")
{
  alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
}

if (yCheck=="1")
{
if (document.all("yearFrequency").value==""||document.all("yearInterval").value==""||document.all("yearConCount").value==""||document.all("yearAlertCount").value=="")
{
    alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
}

if (mCheck=="1")
{
if (document.all("monthFrequency").value==""||document.all("monthInterval").value==""||document.all("monthConCount").value==""||document.all("monthAlertCount").value=="")
{
  alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
}
if (<%=type%>=="1"||<%=type%>=="2")
{
if (wCheck=="1")
{
if (document.all("weekFrequency").value==""||document.all("weekInterval").value==""||document.all("weekConCount").value==""||document.all("weekAlertCount").value=="")
{
  alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  return false;
}
}
}
*/
return true;
}

</script>
</BODY>
</HTML>