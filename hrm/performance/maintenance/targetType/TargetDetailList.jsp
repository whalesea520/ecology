<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
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
String titlename =  SystemEnv.getHtmlLabelName(18086,user.getLanguage());
String id=Util.null2String(request.getParameter("id"));
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%


RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+", TargetDetailAdd.jsp?id="+id+ ",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",TargetTypeList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String sql="select a.*,b.targetName as tName,(select unitName from HrmPerformanceCustom where id=a.unit) as unitName from HrmPerformanceTargetDetail a left join HrmPerformanceTargetType b on a.targetId=b.id where targetId="+id ;
//搜索条件
String targetName=Util.null2String(request.getParameter("targetName"));
String targetCode=Util.null2String(request.getParameter("targetCode"));
String type_1=Util.null2String(request.getParameter("type_1"));
if (!targetName.equals(""))
{
sql+=" and a.targetName like '%"+targetName+"%'" ;
}
if (!targetCode.equals(""))
{
sql+=" and targetCode like '%"+targetCode+"%'";
}
if (!type_1.equals(""))
{
sql+=" and type_l='"+type_1+"' ";
}

RecordSet.execute(sql);
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
<form name=search id=search method=post>
<input type=hidden name=id value=<%=id%> >
<TABLE class=Shadow>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
 <COL width="20%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="15%">
  <COL width="25%">
  <TBODY>
   <TR><td colspan="7">
            <table class=ViewForm width="100%">
            <COLGROUP> 
		    <COL width="10%"> 
		    <COL width="25%"> 
		    <COL width="10%"> 
		    <COL width="25%"> 
		    <COL width="10%"> 
		    <COL width="20%"> 
		    <TBODY> 
            <tr>
            <td>
            <%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
            <td class="Field">
            <input class=inputstyle  name=targetName maxLength=30 size=30 value=<%=targetName%>>
            </td>
            <td>
            <%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
            <td class="Field">
            <input class=inputstyle  name=targetCode maxLength=20 size=20 value=<%=targetCode%> ></td>
            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
            <td class="Field"><select class=inputStyle id=type_1 name=type_1>
                <option value="" <%if(type_1.equals("")) {%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                <option value=0 <%if(type_1.equals("0")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></option>
                <option value=1 <%if(type_1.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                <option value=2 <%if(type_1.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                <option value=3 <%if(type_1.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>
              </select>
            </td>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=6></TD>
          </TR>
          </TBODY> 
          </Table>
          </td></tr>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan=7></TD></TR> 
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
	   <TD><a href="TargetDetailEdit.jsp?id=<%=RecordSet.getString("id")%>&mainid=<%=id%>"><%=RecordSet.getString("targetName")%></a></TD>
	   <TD><%=Util.toScreen(RecordSet.getString("targetCode"),user.getLanguage())%></TD>
	  
	    <TD>
	    
	    <%//0：公司，1：分部，2：部门 3：个人
	    if ((Util.null2String(RecordSet.getString("type_l"))).equals("0"))
	    { 
	    out.print(SystemEnv.getHtmlLabelName(1851,user.getLanguage()));
	    }
	    else if ((Util.null2String(RecordSet.getString("type_l"))).equals("1"))
	     {out.print(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
	    }
	     else if ((Util.null2String(RecordSet.getString("type_l"))).equals("2"))
	     {out.print(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
	    }
	     else if ((Util.null2String(RecordSet.getString("type_l"))).equals("3"))
	     {
	     out.print(SystemEnv.getHtmlLabelName(6087,user.getLanguage()));
	    }
	    %>
	    </TD> 
	   <TD><%
	   //0：月，1：极度，2：年中 3：年
	   if ((Util.null2String(RecordSet.getString("cycle"))).equals("3"))
	    { 
	    out.print(SystemEnv.getHtmlLabelName(445,user.getLanguage()));
	    }
	    else if ((Util.null2String(RecordSet.getString("cycle"))).equals("2"))
	    {
	     out.print(SystemEnv.getHtmlLabelName(18059,user.getLanguage()));
	    }
	     else if ((Util.null2String(RecordSet.getString("cycle"))).equals("1"))
	     {out.print(SystemEnv.getHtmlLabelName(17495,user.getLanguage()));
	    }
	     else if ((Util.null2String(RecordSet.getString("cycle"))).equals("0"))
	     {out.print(SystemEnv.getHtmlLabelName(6076,user.getLanguage()));
	    }
	    %>
	    </TD>
	     <TD><%
	     //0:定性 1:定量
	     if ((Util.null2String(RecordSet.getString("type_t"))).equals("0"))
	    { 
	       out.print(SystemEnv.getHtmlLabelName(18090,user.getLanguage()));
	    }
	    else if ((Util.null2String(RecordSet.getString("type_t"))).equals("1"))
	     {
	     out.print(SystemEnv.getHtmlLabelName(18089,user.getLanguage()));
	    }
	    
	    %>
	    </TD>
	  
	    <TD>
	    <%=Util.toScreen(RecordSet.getString("unitName"),user.getLanguage())%>
	    </TD>
	     <TD>
	    <a href="TargetTypeEdit.jsp?id=<%=id%>">
	    <%=Util.toScreen(RecordSet.getString("tName"),user.getLanguage())%>
	    </a>
	    </TD>

	</TR>
<%
	}
%>
 </TABLE>
</td>
</tr>
</TABLE>
</form>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script>
function deldetail(ids,mainids)
{
if (isdel())
{
location.href="TargetOperation.jsp?id="+ids+"&type=detaildel&mainid="+mainids;
}
}
function OnSubmit(){
    
	{	
		document.search.submit();
		enablemenu();
	}
}
</script>
</BODY>
</HTML>