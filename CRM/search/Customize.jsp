
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String ProcPara = "";
//add by xhheng @20050118 for TD 1345
int perpage=10;
char flag = 2;
ProcPara = CurrentUser;
ProcPara += flag+logintype;
RecordSet.executeProc("CRM_Customize_SelectByUid",ProcPara);

boolean hasCustomize = true;
String method = "insert";
if(RecordSet.getCounts()<=0)
{
	hasCustomize = false;
}
else
{
	RecordSet.first();
	method = "update";
  //add by xhheng @20050118 for TD 1345
  perpage=RecordSet.getInt("perpage");
  if(perpage==-1 || perpage==0) perpage=10;
}

int options[][] = new int[3][6];
for(int i=0;i<3;i++)
{
	for(int j=0;j<6;j++)
	{
		if(hasCustomize)
		{
			options[i][j] = RecordSet.getInt(i*6+j+2);
		}
		else
		{
			switch(i*10+j)
			{
				case 0: options[i][j] = 101;break;
				case 1: options[i][j] = 203;break;
				default: options[i][j] = 0;
			}
		}
	}
}

RecordSet.executeProc("CRM_CustomizeOption_SelectAll","");
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/CRM/DBError.jsp?type=FindData");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(343,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(197,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.go(-1)',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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
<FORM id=weaver name="weaver" action="/CRM/search/CustomizeOperation.jsp" method=post>
<input type="hidden" name="method" value="<%=method%>">
  <table class=ViewForm border="0" width="100%" cellspaning=0>
    <!--add by xhheng @20050118 for TD 1345-->
    <TR class=Title>
      <TH ><%=SystemEnv.getHtmlLabelName(17580,user.getLanguage())%></TH>
    </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=6></TD></TR>
<%
	for(int i=1;i<=1;i++)
	{
%>
    <tr>
<%
		for(int j=1;j<=6;j++)
		{
%>
      <td width="16%"><select class=InputStyle  size="1" name="row<%=i%>col<%=j%>" style="width:100%" class=InputStyle>
<%	if(options[i-1][j-1]==0){%>
          <option selected value="0"></option>
<%	}else{%>
          <option value="0"></option>
<%	}
	
	RecordSet.first();
	do
	{
		if(user.getLogintype().equals("2")){
			switch(RecordSet.getInt("id"))
			{
				case 122:
				case 123:
				case 124:
				case 125:
				case 212://需要把相应数据转换成 语言
					continue;
			}
		}
		if(RecordSet.getInt("id")==options[i-1][j-1])
		{%>
          <option selected value="<%=RecordSet.getString("id")%>"><%if(RecordSet.getInt("tabledesc")==1){%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%}%>:<%=Util.toScreen(RecordSet.getString("labelname"),user.getLanguage())%></option>
		<%}
		else
		{%>
          <option value="<%=RecordSet.getString("id")%>"><%if(RecordSet.getInt("tabledesc")==1){%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%}%>:<%=Util.toScreen(RecordSet.getString("labelname"),user.getLanguage())%></option>
		<%}
	}while(RecordSet.next());
%>
        </select></td>
<%
		}
%>
    </tr>
    <TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>
<%
	}
%>

  </table>

<!--add by xhheng @20050118 for TD 1345-->
<P></P>
<TABLE class=ViewForm>
<COLGROUP>
<COL width="20%">
<COL width="80%">
<TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17579,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17579,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=InputStyle maxLength=10 name="PERPAGE" value=<%=perpage%>></TD>
  </TR>
  <tr style="height: 1px"><td class=Line colspan=2></td></tr>
</TBODY>
</TABLE>

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
</body>
</html>
