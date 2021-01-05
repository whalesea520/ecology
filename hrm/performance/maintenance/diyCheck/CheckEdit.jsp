<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsb" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsl" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="show" class="weaver.hrm.performance.maintenance.TargetList" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("DiyCheck:Maintenance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18048,user.getLanguage());
String name="";
String memo="";
String status="";

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CheckList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String mainid=Util.null2String(request.getParameter("id"));
rs.execute("select * from HrmPerformanceCheckRule where id="+mainid);
if (rs.next())
{
name=Util.null2String(rs.getString("ruleName"));
memo=Util.null2String(rs.getString("memo"));
status=Util.null2String(rs.getString("status"));
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

<FORM name=resource id=resource action="CheckOperation.jsp" method=post>
<input type=hidden name=edittype value=basic>
<input type=hidden name=mainid value=<%=mainid%>>
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
            <TD class=line1 colSpan=2 style="padding:0;"></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=ruleName  onchange='checkinput("ruleName","nameimage")' value="<%=name%>">
			<SPAN id=nameimage>
			<%if (name.equals("")){%>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			<%}%></SPAN>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD> <!--??-->
              <TD class=Field>
              <input class=inputstyle name=memo rows=5 cols=40 value="<%=memo%>">
            </TD>
          </TR>
          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD><!--?? ??/??-->
             <TD class=Field> 
              <input class=inputstyle type="checkbox"  value="0" name="status" <%if (status.equals("0")) {%>checked <%}%>>
             <!-- ÊÇ·ñÆðÓÃ-->
              <!-- select class=inputStyle id=status 
              name=status>
                <option value=0 <%if (status.equals("0")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
                <option value=1 <%if (status.equals("1")) {%>selected <%}%> ><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
               
              </select-->
            </TD>
            
          </TR>
          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
  </FORM>
</td>
</tr>
<tr></tr><td valign="top">
<TABLE class=viewform>
<tr>
<td valign="top">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="10%">
  <COL width="50%">
  <COL width="10%">
  <TBODY>
   <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18094,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing  style="height:1px;"> 
            <TD class=line1 colSpan=4 style="padding:0;"></TD>
          </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(18086,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>(%)</th>
  <th><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></th>
  <th  align="right"><a href="TargetDetailAdd.jsp?id=<%=mainid%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line  style="height:1px;"><TD colspan="4" style="padding:0;"></TD></TR> 


	
	<%rsd.execute("update HrmPerformanceCheckDetail set targetIndex='-1' where  checkId="+mainid);
	show.setUser(user);
	
	out.print(show.getViewTargetListStr(Integer.parseInt(mainid),mainid));
	//show.init();
	//}	
	%>
 </TABLE>
</td>
</tr>
</TABLE>

</td></tr>
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
    if(check_form(document.resource,"ruleName"))
	{	
		document.resource.submit();
		enablemenu();
	}
}
function deldetail(ids,mainids,flag)
{
if (flag)
{
if(confirm('<%=SystemEnv.getHtmlLabelName(18255,user.getLanguage())%>')){
location.href="CheckOperation.jsp?type=detaildel&id="+ids+"&mainid="+mainids;
}
else
{
return;
}
}
else
{
if (isdel())
{ 
location.href="CheckOperation.jsp?type=detaildel&id="+ids+"&mainid="+mainids;
}
}
}
</script>
</BODY>
</HTML>