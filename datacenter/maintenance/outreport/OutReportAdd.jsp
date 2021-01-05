<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String outrepcategory = "" + Util.getIntValue(request.getParameter("outrepcategory"),0);

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=frmMain action="OutReportOperation.jsp" method=post >
<input type="hidden" name=operation value=add>
<input type="hidden" name=outrepcategory value="<%=outrepcategory%>">

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



<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15514,user.getLanguage())%></TH>
    </TR>
  <TR class=spacing  style="height:1px;">
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD>名称</TD>
          <TD class=Field><INPUT type=text class=inputstyle size=50 name="outrepname" onchange='checkinput("outrepname","outrepnameimage")'>
          <SPAN id=outrepnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>  
        <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2 ></TD></TR>
    <TR>
          <TD>英文名称</TD>
          <TD class=Field><INPUT type=text class=inputstyle size=50 name="outrepenname">
          </TD>
        </TR>  
        <TR class=spacing  style="height:1px;">
    <TD class=line colSpan=2 ></TD></TR>
    <% if(outrepcategory.equals("0")||outrepcategory.equals("2")) { // 只有为固定报表或者排序报表时候显示 %>
    <TR>
      <TD>行数</TD>
      <TD class=Field><INPUT type=text class=inputstyle size=50 name="outreprow" onchange='checkinput("outreprow","outreprowimage")' onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' <% if(outrepcategory.equals("2")) { %>value="1"<%}%>>
      <SPAN id=outreprowimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR>
    <TR class=spacing style="height:1px;"><TD class=line colSpan=2 ></TD></TR>
    <TR>
      <TD>列数</TD>
      <TD class=Field><INPUT type=text class=inputstyle size=50 name="outrepcolumn" onchange='checkinput("outrepcolumn","outrepcolumnimage")' onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
      <SPAN id=outrepcolumnimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR> 
    <TR class=spacing style="height:1px;"><TD class=line colSpan=2 ></TD></TR>
    <% } %>
    <TR>
          <TD>中文报表模板文件</TD>
          <TD class=Field><INPUT type=text class=inputstyle size=50 name="modulefilename" ></TD>
    </TR> 
    <TR class=spacing style="height:1px;"><TD class=line colSpan=2></TD></TR>
    <TR>
          <TD>英文报表模板文件</TD>
          <TD class=Field><INPUT type=text class=inputstyle size=50 name="enmodulefilename" ></TD>
    </TR> 
    <!-- 刘煜 2004 年10月23 日增加模板文件自适应行高和列宽-->
    <TR class=spacing style="height:1px;"><TD class=line colSpan=2></TD></TR>
    <TR>
          <TD>报表模板自适应</TD>
          <TD class=Field>
            列宽：<INPUT type=checkbox class=inputstyle name="autocolumn" value='1'>
            行高：<INPUT type=checkbox class=inputstyle name="autorow" value='1'>
          </TD>
    </TR> 
    <TR class=spacing style="height:1px;"><TD class=line colSpan=2 ></TD></TR>
    <TR> 
      <TD>报表种类</TD>
      <TD class=Field >
        <select class="InputStyle"  name="outreptype" style="width:50%">
          <option value="0">动态</option>
		  <option value="1">年报</option>
		  <option value="2">月报</option>
		  <option value="3">旬报</option>
		  <option value="4">周报</option>
		  <option value="5">日报</option>
        </select>
      </TD>
    </TR>
    <TR class=spacing style="height:1px;">
    <TD class=line colSpan=2 ></TD></TR>
        <TR>
          <TD>中文描述</TD>
          <TD class=Field><INPUT type=text class=inputstyle size=50 name="outrepdesc"></TD>
        </TR> 
     <TR class=spacing style="height:1px;"><TD class=line colSpan=2 ></TD></TR>
     <TR>
          <TD>英文描述</TD>
          <TD class=Field><INPUT type=text class=inputstyle size=50 name="outrependesc"></TD>
        </TR> <TR class=spacing  style="height:1px;">
    <TD class=line1 colSpan=2 style="height:1px;"></TD></TR>
 </TBODY></TABLE>
 
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

 </form>

<script language="javascript">

function submitData()
{
<% if(outrepcategory.equals("0")||outrepcategory.equals("2")) { %>
	if (check_form(frmMain,'outrepname,outreprow,outrepcolumn')) {
		if(toInt(document.frmMain.outreprow.value,0)>0 &&  toInt(document.frmMain.outrepcolumn.value,0)>0 ) {
		    frmMain.submit();
		}
		else {
			alert("行列必须大于0！");
		}
	}
<%}else{%>
if (check_form(frmMain,'outrepname')) {		
	frmMain.submit();		
}
<%}%>
}

function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return parseInt(str) ;
}

</script>
</BODY></HTML>
