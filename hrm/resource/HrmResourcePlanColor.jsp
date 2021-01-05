<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(73,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(495,user.getLanguage());
String needfav ="1";
String needhelp ="";

String resourceid=user.getUID()+"";
char flag=2;

//设定颜色默认值
String color11="ffff00",color21="00ff00",color31="0066ff",color41="cc66ff";
String color12="ff0000",color22="ff0000",color32="ff0000",color42="ff0000";
int type=0;

RecordSet.executeProc("HrmPlanColor_SelectByID",resourceid);
while(RecordSet.next()){
	type=RecordSet.getInt("basictype");
	switch(type){
		case 1:
			color11=RecordSet.getString("colorid1");
			color12=RecordSet.getString("colorid2");
			break;
		case 2:
			color21=RecordSet.getString("colorid1");
			color22=RecordSet.getString("colorid2");
			break;
		case 3:
			color31=RecordSet.getString("colorid1");
			color32=RecordSet.getString("colorid2");
			break;
		case 4:
			color41=RecordSet.getString("colorid1");
			color42=RecordSet.getString("colorid2");
			break;
	}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/resource/HrmResourcePlan.jsp?resourceid="+resourceid+",_self} " ;
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
<form name=frmmain method="post" action="HrmResourcePlanColorOperation.jsp">
<table class=viewform>
  <col width=20%>
  <col width=40%>
  <col width=40%>
  <TR CLASS=title> 
  	<TH colspan=3><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
  </TR>
  <TR Class=spacing> 
    <TD CLASS=line1 colspan=3></TD>
  </TR>
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(1955,user.getLanguage())%></td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color11 BGCOLOR="#<%=color11%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color11','colorid11')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><input class=inputstyle type=hidden name="colorid11" value="<%=color11%>"></td>
  		  </tr>
  		</table>
  	</td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color12 BGCOLOR="#<%=color12%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color12','colorid12')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%><input class=inputstyle type=hidden name="colorid12" value="<%=color12%>"></td>
  		  </tr>
  		</table>
  	</td>
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(1956,user.getLanguage())%></td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color21 BGCOLOR="#<%=color21%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color21','colorid21')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><input class=inputstyle type=hidden name="colorid21" value="<%=color21%>"></td>
  		  </tr>
  		</table>
  	</td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color22 BGCOLOR="#<%=color22%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color22','colorid22')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%><input class=inputstyle type=hidden name="colorid22" value="<%=color22%>"></td>
  		  </tr>
  		</table>
  	</td>
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(786,user.getLanguage())%></td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color31 BGCOLOR="#<%=color31%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color31','colorid31')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><input class=inputstyle type=hidden name="colorid31" value="<%=color31%>"></td>
  		  </tr>
  		</table>
  	</td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color32 BGCOLOR="#<%=color32%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color32','colorid32')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%><input class=inputstyle type=hidden name="colorid32" value="<%=color32%>"></td>
  		  </tr>
  		</table>
  	</td>
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(1957,user.getLanguage())%></td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color41 BGCOLOR="#<%=color41%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color41','colorid41')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><input class=inputstyle type=hidden name="colorid41" value="<%=color41%>"></td>
  		  </tr>
  		</table>
  	</td>
  	<td class=field>
  		<table border=0 cellspacing=0 cellpadding=0 width=90%>
  		  <tr>
  		  	<td width=70%>
  		  	<TABLE border=1 cellspacing=0 cellpadding=0 bordercolor=black width=90%>
			<TR><TD STYLE="border:1px" ID=Color42 BGCOLOR="#<%=color42%>">
			&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
			</TABLE>
  		  	</td>
  		  	<TD><BUTTON CLASS=Browser onclick="SelectColor('Color42','colorid42')">&nbsp;</BUTTON></TD>
  		  	<td><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%><input class=inputstyle type=hidden name="colorid42" value="<%=color42%>"></td>
  		  </tr>
  		</table>
  	</td>
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
</table>
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
<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>

<SCRIPT LANGUAGE=VBS>
		Sub SelectColor(tdname,colorinput)
		   id = window.showModalDialog("/systeminfo/ColorBrowser.jsp")
		   If IsNull(id) Then
		      document.all(colorinput).value = ""
		   ElseIf Not IsEmpty(id) Then
		      document.all(colorinput).value = id
		      document.all(tdname).bgColor = id
		   End If
		End Sub
</SCRIPT>
</body>
</html>