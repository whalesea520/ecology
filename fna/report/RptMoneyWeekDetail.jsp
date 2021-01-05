<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="HrmUserVarify" class="weaver.hrm.HrmUserVarify" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
if(!HrmUserVarify.checkUserRight("MoneyWeek:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

String fromdate = Util.null2String(request.getParameter("fromdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
int level = Util.getIntValue(request.getParameter("level"),1);
int currency = Util.getIntValue(request.getParameter("currency"),0);
//int amountzero = Util.getIntValue(request.getParameter("amountzero"),0);
//int transzero = Util.getIntValue(request.getParameter("transzero"),0);
int unposted = Util.getIntValue(request.getParameter("unposted"),0);
int wang=Util.getIntValue(request.getParameter("wang"),0);

String departmentid="";
departmentid="("+departmentid+")";

String ProcPara = "";
String account = "no use";//需要在存储过程中对应德隆的科目号做修改
char flag = 2;
ProcPara = ""+fromdate + flag + enddate + flag + currency + flag + account + flag + unposted+flag+wang;

RecordSet.executeProc("sp_MoneyWeekRpt",ProcPara,"ecologyjindie");
%>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self}" ;
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

<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdReport_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle style="FONT-WEIGHT: bold; FONT-SIZE: 12pt"><%=SystemEnv.getHtmlLabelName(15418,user.getLanguage())%></SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
    <TD align=middle width=24><BUTTON class=btnFavorite id=BacoAddFavorite 
    title="Add to favorites" ></BUTTON></TD>
	 <TD align=middle width=24><BUTTON class=btnBack id=onBack title="<%=SystemEnv.getHtmlLabelName(15408,user.getLanguage())%>" onclick="javascript:history.back();"></BUTTON></TD>
  </TR>
  </TBODY>
</TABLE>


<table  class=ListStyle  cellSpacing=1>
  <tr class=Header>
    <td width="12%" ><%=SystemEnv.getHtmlLabelName(15409,user.getLanguage())%></td>
    <td width="12%" ><%=SystemEnv.getHtmlLabelName(15419,user.getLanguage())%></td>
    <td width="12%" ><%=SystemEnv.getHtmlLabelName(15420,user.getLanguage())%></td>
    <td width="12%" ><%=SystemEnv.getHtmlLabelName(15421,user.getLanguage())%></td>
    <td width="12%" ><%=SystemEnv.getHtmlLabelName(15422,user.getLanguage())%></td>
    <td width="12%" ><%=SystemEnv.getHtmlLabelName(15423,user.getLanguage())%></td>
    <td width="12%" ><%=SystemEnv.getHtmlLabelName(15424,user.getLanguage())%></td>
  </tr>
  <tr class="Line"><td colspan="7"></td></tr>
<%
    ExcelSheet es = new ExcelSheet() ;
    ExcelRow er = es.newExcelRow () ;  
    er.addStringValue(SystemEnv.getHtmlLabelName(15409,user.getLanguage())) ;
    er.addStringValue(SystemEnv.getHtmlLabelName(15419,user.getLanguage())) ;
    er.addStringValue(SystemEnv.getHtmlLabelName(15420,user.getLanguage())) ;
    er.addStringValue(SystemEnv.getHtmlLabelName(15421,user.getLanguage())) ;
    er.addStringValue(SystemEnv.getHtmlLabelName(15422,user.getLanguage())) ;
    er.addStringValue(SystemEnv.getHtmlLabelName(15423,user.getLanguage())) ;
    er.addStringValue(SystemEnv.getHtmlLabelName(15424,user.getLanguage())) ;
  
    es.addExcelRow(er) ;
boolean islight=true;
while(RecordSet.next())
{  er = es.newExcelRow () ;
%>
  <tr <%if(islight){%> class=datalight <%} else {%>class=datadark <%}%>>
    <td width="12%"><%=RecordSet.getString("FAccountName")%>
    <%
    er.addStringValue(RecordSet.getString("FAccountName"));%></td>
    
    <td width="12%"><%if(!RecordSet.getString("LastweekBal").equals("0.0000")){%>
    <%=Util.getFloatStr(RecordSet.getString("LastweekBal").substring(0,RecordSet.getString("LastweekBal").length()-2),3)%>
    <%er.addStringValue(Util.getFloatStr(RecordSet.getString("LastweekBal").substring(0,RecordSet.getString("LastweekBal").length()-2),3));
    }else{
	er.addStringValue("");
	}%></td>
    
    <td width="12%"><%if(!RecordSet.getString("thisWeekDebit").equals("0.0000")){%>
    <%=Util.getFloatStr(RecordSet.getString("thisWeekDebit").substring(0,RecordSet.getString("thisWeekDebit").length()-2),3)%>
    <%er.addStringValue(Util.getFloatStr(RecordSet.getString("thisWeekDebit").substring(0,RecordSet.getString("thisWeekDebit").length()-2),3));
    }else{
	er.addStringValue("");
	}%></td>
    
    <td width="12%"><%if(!RecordSet.getString("thisweekCredit").equals("0.0000")){%>
    <%=Util.getFloatStr(RecordSet.getString("thisweekCredit").substring(0,RecordSet.getString("thisweekCredit").length()-2),3)%>
    <%er.addStringValue(Util.getFloatStr(RecordSet.getString("thisweekCredit").substring(0,RecordSet.getString("thisweekCredit").length()-2),3));
    }else{
	er.addStringValue("");
	}%></td>
    
    <td width="12%"><%if(!RecordSet.getString("thisweekBal").equals("0.0000")){%>
    <%=Util.getFloatStr(RecordSet.getString("thisweekBal").substring(0,RecordSet.getString("thisweekBal").length()-2),3)%>
    <%er.addStringValue(Util.getFloatStr(RecordSet.getString("thisweekBal").substring(0,RecordSet.getString("thisweekBal").length()-2),3));
    }else{
	er.addStringValue("");
	}%></td>
    
    <td width="12%"><%if(!RecordSet.getString("dCount").equals("0")){%>
    <%=Util.getFloatStr(RecordSet.getString("dCount"),3)%>
    <%er.addStringValue(Util.getFloatStr(RecordSet.getString("dCount"),3));
    }else{
	er.addStringValue("");
	}%></td>
    <td width="12%"><%if(!RecordSet.getString("cCount").equals("0")){%>
    <%=Util.getFloatStr(RecordSet.getString("cCount"),3)%>
     <%er.addStringValue(Util.getFloatStr(RecordSet.getString("cCount"),3));
    }else{
	er.addStringValue("");
	}%></td>
  </tr>
<%
    islight=!islight;
    
  es.addExcelRow(er) ;
}%>
</table>
<%
 ExcelFile.init() ;
 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(15418,user.getLanguage())) ;
 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(15418,user.getLanguage()), es) ;
 %>
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


</BODY>
</HTML>

