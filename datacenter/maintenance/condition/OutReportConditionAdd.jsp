<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("新 ：报表条件信息",user.getLanguage(),"0");
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
<FORM id=weaver name=frmMain action="OutReportConditionOperation.jsp" method=post >
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
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=title> 
      <TH colSpan=2>报表条件信息</TH>
    </TR>
    <TR class=spacing style='height:1px'> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>条件名称</TD>
      <TD class=Field>
        <INPUT type=text class=inputstyle size=50 name="conditionname" onchange='checkinput("conditionname","conditionnameimage")'>
        <SPAN id=conditionnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR>  <TR class=spacing style='height:1px'> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>对应字段名</TD>
      <TD class=Field > 
        <INPUT type=text class=inputstyle size=50 name="conditionitemfieldname" onchange='checkinput("conditionitemfieldname","conditionitemfieldnameimage")'>
        <SPAN id=conditionitemfieldnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR><TR class=spacing style='height:1px'> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>输入项类型</TD>
      <TD class=Field > 
        <select class="InputStyle" name="conditiontype" style="width:50%">
          <option value="1">文本型</option>
          <option value="2">选择型</option>
          <option value="3">公式型</option>
        </select>
      </TD>
    </TR><TR class=spacing style='height:1px'> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr  id = textscale style="display:''" > 
      <td>条件描述</td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=50 name="conditiondesc" >
      </td>
    </tr><TR class=spacing style='height:1px'> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <input type="hidden" name=operation value=add>
    </TBODY> 
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


 </form>

<script language=javascript>
 function showType(){
    conditiontypelist = window.document.frmMain.conditiontype;
    if(conditiontypelist.value==1){
        conditionitemfield.style.display='';
    }
    if(conditiontypelist.value==2){
        conditionitemfield.style.display='';
    }
    if(conditiontypelist.value==3){
        conditionitemfield.style.display='none';
    }
 }

 function doSubmit() {
     if(conditiontypelist.value != 3) return check_form(this,'conditionname,conditionitemfieldname') ;
     else return check_form(this,'conditionname') ;
 }


</script>
 <script language="javascript">
function submitData()
{
	if (check_form(frmMain,'conditionname,conditionitemfieldname'))
		frmMain.submit();
}
</script>
</BODY></HTML>
