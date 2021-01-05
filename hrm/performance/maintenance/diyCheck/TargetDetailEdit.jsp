<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("TargetTypeInfo:Maintenance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18122,user.getLanguage());
String id=Util.null2String(request.getParameter("id"));
String mainid=Util.null2String(request.getParameter("mainid"));
String parentId=Util.null2String(request.getParameter("parentId"));
String needfav ="1";
String needhelp ="";
String tName="";
String targetName="";

String percent_n="";
String memo="";
rs.execute("select * from HrmPerformanceCheckDetail  where id="+id);
if (rs.next())
{
targetName=Util.null2String(rs.getString("targetName"));
percent_n=Util.null2String(rs.getString("percent_n"));
}
rsd.execute("select * from hrmPerformanceCheckStd where checkDetailId="+id+" order by id ");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18119,user.getLanguage())+",javascript:OnSubmitM(),_self} " ;
RCMenuHeight += RCMenuHeightStep ; //保存为指标
RCMenu += "{"+SystemEnv.getHtmlLabelName(18120,user.getLanguage())+",CheckEdit.jsp?id="+mainid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ; //完成，回到自定义指标修改页面
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CheckEdit.jsp?id="+mainid+",_self} " ;
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

<FORM name=resource id=resource action="CheckOperation.jsp" method=post>
<input type=hidden name=edittype value=detail >
<input type=hidden name=mainid  value=<%=mainid%> >
<input type=hidden name=id  value=<%=id%> >
<input type=hidden name=parentId  value=<%=parentId%> >
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
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=targetName  onchange='checkinput("targetName","nameimage")' value=<%=targetName%> >
			<SPAN id=nameimage>
			<%if (targetName.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle name=percent_n  value="<%=percent_n%>" onchange='checkinput("percent_n","pimage");checknumber("percent_n")' size=4 maxLength=4>
			<SPAN id=pimage>
			<%if (percent_n.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
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
<!--评分标准-->
<TABLE class=ViewForm>
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
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=4 style="padding:0;"></TD>
          </TR>
   <TR class=Header>
  <th></th>
  <th><%=SystemEnv.getHtmlLabelName(18092,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></th>
  <th  align="left"><a href="TargetStdAdd.jsp?mainid=<%=mainid%>&id=<%=id%> "><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line  style="height:1px;"><TD colspan="4" style="padding:0;"></TD></TR> 
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
    if(check_form(document.resource,"targetName,percent_n"))
	{		if (parseFloat(document.all("percent_n").value)>100) 
           {
	     alert("<%=SystemEnv.getHtmlLabelName(18118,user.getLanguage())%>");
	     return;
	       }
		document.resource.submit();
		enablemenu();
	}
}

function OnSubmitM(){
    if(check_form(document.resource,"targetName,percent_n"))
	{		if (parseFloat(document.all("percent_n").value)>100) 
           {
	     alert("<%=SystemEnv.getHtmlLabelName(18118,user.getLanguage())%>");
	     return;
	       }
	    document.all("edittype").value="modul";   
		document.resource.submit();
		enablemenu();
	}
}
function deldetail(idd,mainids,ids)
{
if (isdel())
{
location.href="CheckOperation.jsp?type=detaildelstd&id="+idd+"&mainid="+mainids+"&tid="+ids;
}
}
</script>
</BODY>
</HTML>