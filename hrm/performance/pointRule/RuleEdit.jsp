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

rs.execute("select * from HrmPerformancePointRule ");
if (rs.next())
{
pointMethod=Util.null2String(rs.getString("pointMethod"));
pointModul=Util.null2String(rs.getString("pointModul"));
pointModify=Util.null2String(rs.getString("pointModify"));
minPoint=Util.null2String(rs.getString("minPoint"));
maxPoint=Util.null2String(rs.getString("maxPoint"));

minPoint=(minPoint.equals("0"))?"":minPoint;
maxPoint=(maxPoint.equals("0"))?"":maxPoint;
}
rsd.execute("select * from hrmPerformanceAppendRule");
%>
<BODY onload="init()">
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

<FORM name=resource id=resource action="RuleOperation.jsp" method=post>
<input type=hidden name=edittype value=detail >
<input type=hidden name=mainid  value=<%=mainid%> >
<input type=hidden name=id  value=<%=id%> >
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
          <TR class=spacing> 
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
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18069,user.getLanguage())%></TD>
            <TD class=Field> 
              <select class=inputstyle name=pointMethod>  <!-- 评分方式 0：依据评分标准 1：手工评分-->
              <option value=0><%=SystemEnv.getHtmlLabelName(18071,user.getLanguage())%><</option>
              <option value=1><%=SystemEnv.getHtmlLabelName(18072,user.getLanguage())%><</option>
              </select>
            </TD>
             <span id=pModulZ <%if (pointMethod.equals("")||pointMethod.equals("1"))%> style="display:none" <%}%>>
            <%=SystemEnv.getHtmlLabelName(18073,user.getLanguage())%>
            </span>
             <span id=pModulT <%if (pointMethod.equals("")||pointMethod.equals("0"))%> style="display:none" <%}%>>
           <%=SystemEnv.getHtmlLabelName(18074,user.getLanguage())%>
            </span>
            <span id=pModul <%if (pointMethod.equals(""))%> style="display:none" <%}%> >
            <input class=inputstyle type="checkbox" name="pointModul"  value="ON" >
            </span>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18070,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type="checkbox" name="pointModify"  if (pointModify.equals("1")) value="ON" <%}%> ><!-- 是否可以得分修正-->
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
      
  </FORM>
</td>
</tr>
</TABLE>
<!--附加规则-->
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
 <COL width="10%">
  <COL width="60%">
  <COL width="20%">
  <COL width="10%">
 
  <TBODY>
   <TR class=title> 
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=4></TD>
          </TR>
   <TR class=Header>
  <th></th>
  <th><%=SystemEnv.getHtmlLabelName(18092,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></th>
  <th  align="left"><a href="TargetStdAdd.jsp?mainid=<%=mainid%>&id=<%=id%> "><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line><TD colspan="4" ></TD></TR> 
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
		<TD><%=j%></TD>
		<TD><a href="TargetStdEdit.jsp?id=<%=rsd.getString("id")%>&mainid=<%=mainid%>&tid=<%=id%> "><%=Util.toScreen(rsd.getString("stdName"),user.getLanguage())%></a></TD>
		<TD><%=rsd.getString("point")%></TD>
		<TD><a  onclick="deldetail(<%=rsd.getString("id")%>,<%=mainid%>,<%=id%>)" href="#"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>

	</TR>
<%
	j++;}
%>
 </TABLE>
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
    if(check_form(document.resource,"targetName"))
	{	
		document.resource.submit();
	}
}
function init()
{ 
if (<%=type_t%>=="1")
{
document.all("ration").style.display="";
}
else
{
document.all("ration").style.display="none";
}
}

function deldetail(idd,mainids,ids)
{
if (isdel())
{
location.href="TargetTypeOperation.jsp?type=detaildel&id="+idd+"&type=detaildel&mainid="+mainids+"&tid="+ids;
}
}
</script>
</BODY>
</HTML>