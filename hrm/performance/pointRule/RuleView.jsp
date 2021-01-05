<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("PointRule:Performance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18050,user.getLanguage());
String needfav ="1";
String needhelp ="";
String pointMethod="";
String pointModul="";
String pointModify="";
String minPoint="0";
String maxPoint="0";
String count="0";

rs.execute("select * from HrmPerformancePointRule ");
if (rs.next())
{
count="1";
pointMethod=Util.null2String(rs.getString("pointMethod"));
pointModul=Util.null2String(rs.getString("pointModul"));
pointModify=Util.null2String(rs.getString("pointModify"));
minPoint=Util.null2String(rs.getString("minPoint"));
maxPoint=Util.null2String(rs.getString("maxPoint"));
}
rsd.execute("select * from hrmPerformanceAppendRule");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
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

<FORM name=resource id=resource action="RuleOperation.jsp" method=post>
<input type=hidden name=edittype value=basic >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18068,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=3 size=3 
            name=minPoint  onchange='checkinput("minPoint","nameimage");checknumber("minPoint")' value=<%=minPoint%> >
			<SPAN id=nameimage>
			<%if (minPoint.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN> – <input class=inputstyle  maxLength=3 size=3 
            name=maxPoint  onchange='checkinput("maxPoint","maximage");checknumber("maxPoint")' value=<%=maxPoint%> >
			<SPAN id=maximage>
			<%if (maxPoint.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18069,user.getLanguage())%></TD>
            <TD class=Field> 
              <select class=inputstyle name=pointMethod onchange="show()">  <!-- 评分方式 0：依据评分标准 1：手工评分-->
              <option value=0 <%if (pointMethod.equals("0")) {%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(18071,user.getLanguage())%></option>
              <option value=1 <%if (pointMethod.equals("1")) {%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(18072,user.getLanguage())%></option>
             </select>
             <span id=pModulT <%if (!pointMethod.equals("")&&!pointMethod.equals("0")) {%> style="display:none" <%}%>>
            <%=SystemEnv.getHtmlLabelName(18073,user.getLanguage())%>
            </span>
             <span id=pModulZ <%if (!pointMethod.equals("1")) {%> style="display:none" <%}%>>
           <%=SystemEnv.getHtmlLabelName(18074,user.getLanguage())%>
            </span>
            <input class=inputstyle type="checkbox" name="pointModul"  value="1" <% if (pointModul.equals("1")){ %> checked <%}%>>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18070,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type="checkbox" name="pointModify" value="1" <% if (pointModify.equals("1")){ %> checked <%}%> ><!-- 是否可以得分修正-->
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
      
  </FORM>
</td>
</tr>
</TABLE>
<%if (count.equals("1"))
{%>
<!--附加规则-->
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
 <COL width="10%">
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">
  <COL width="5%">
  <COL width="5%">
  <TBODY>
   <TR class=title> 
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=6 style="padding:0;"></TD>
          </TR>
   <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18075,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  <th  align="left"><a href="AppendRuleAdd.jsp"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line  style="height:1px;"><TD colspan="6" style="padding:0;"></TD></TR> 
<%
int j=1;
boolean isLight = false;
	while(rsd.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="AppendRuleEdit.jsp?id=<%=rsd.getString("id")%>"><%=Util.toScreen(rsd.getString("ruleName"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(rsd.getString("memo"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(rsd.getString("conditionsum"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(rsd.getString("formulasum"),user.getLanguage())%></TD>
		<TD><%if ((rsd.getString("status")).equals("0")) {%><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%}%>
		    <%if ((rsd.getString("status")).equals("1")) {%><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%><%}%></TD>
		<TD><a  onclick="deldetail(<%=rsd.getString("id")%>)" href="#"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>

	</TR>
<%
	j++;}
%>
 </TABLE>
</td>
</tr>
</TABLE>
<%}%>
</td>
<td></td>
</tr>

<tr>
<td height="10" colspan="3"></td>
</tr>
</table>


<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.resource,"minPoint,maxPoint"))
	{	if (change2input(document.all("maxPoint").value,document.all("minPoint").value))
	    {
		document.resource.submit();
	   }
	   else
	   {
	    alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
	    return;
	   }
	}
}

function show()
{

if (document.all.pointMethod.options[document.all.pointMethod.selectedIndex].value=="0")
{
document.all("pModulT").style.display="";
document.all("pModulZ").style.display="none";
}
else
{
document.all("pModulT").style.display="none";
document.all("pModulZ").style.display="";
}

}
function deldetail(idd)
{
if (isdel())
{
location.href="RuleOperation.jsp?id="+idd+"&type=detaildel";
}
}
</script>
</BODY>
</HTML>