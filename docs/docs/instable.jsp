<!-- Copyright 1999 Microsoft Corporation. All rights reserved. -->

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<TITLE>Enter Table Information</TITLE>

<STYLE TYPE="text/css">
 BODY   {margin-left:10; font-family:Verdana; font-size:12; background:menu}
 BUTTON {width:5em}
 TABLE  {font-family:Verdana; font-size:12}
 P      {text-align:center}
</STYLE>

<SCRIPT LANGUAGE=JavaScript>
<!--
function IsDigit()
{
  return ((event.keyCode >= 48) && (event.keyCode <= 57))
}
// -->
</SCRIPT>

<SCRIPT LANGUAGE=JavaScript FOR=window EVENT=onload>
<!--
  for ( elem in window.dialogArguments )
  {
    switch( elem )
    {
    case "NumRows":
      NumRows.value = window.dialogArguments["NumRows"];
      break;
    case "NumCols":
      NumCols.value = window.dialogArguments["NumCols"];
      break;
    case "TableAttrs":
      TableAttrs.value = window.dialogArguments["TableAttrs"];
      break;
    case "CellAttrs":
      CellAttrs.value = window.dialogArguments["CellAttrs"];
      break;
    case "Caption":
      Caption.value = window.dialogArguments["Caption"];
      break;
    }
  }
// -->
</SCRIPT>

<SCRIPT LANGUAGE=JavaScript FOR=Ok EVENT=onclick>
<!--
  var arr = new Array();
  arr["NumRows"] = NumRows.value;
  arr["NumCols"] = NumCols.value;
  arr["TableAttrs"] = TableAttrs.value;
  arr["CellAttrs"] = CellAttrs.value;
  arr["Caption"] = Caption.value;
  window.returnValue = arr;
  window.close();
// -->
</SCRIPT>

</HEAD>

<BODY>

<TABLE CELLSPACING=10>
 <TR>
  <TD><%=SystemEnv.getHtmlLabelName(1988,user.getLanguage())%>:
  <TD><INPUT ID=NumRows TYPE=TEXT SIZE=3 NAME=NumRows ONKEYPRESS="event.returnValue=IsDigit();">
 <TR>
  <TD><%=SystemEnv.getHtmlLabelName(1989,user.getLanguage())%>:
  <TD><INPUT ID=NumCols TYPE=TEXT SIZE=3 NAME=NumCols ONKEYPRESS="event.returnValue=IsDigit();">
 <TR>
  <TD><%=SystemEnv.getHtmlLabelName(1990,user.getLanguage())%>:
  <TD><INPUT TYPE=TEXT SIZE=40 NAME=TableAttrs>
 <TR>
  <TD><%=SystemEnv.getHtmlLabelName(1991,user.getLanguage())%>:
  <TD><INPUT TYPE=TEXT SIZE=40 NAME=CellAttrs>
 <TR>
  <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>:
  <TD><INPUT TYPE=TEXT SIZE=40 NAME=Caption>
</TABLE>

<P>
<BUTTON ID=Ok TYPE=SUBMIT><%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<BUTTON type="button" ONCLICK="window.close();"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>

</BODY>
</HTML>