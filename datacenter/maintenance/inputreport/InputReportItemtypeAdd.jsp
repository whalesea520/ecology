<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
String imagefilename = "/images/hdHRMCard.gif";
//String titlename = Util.toScreen("新：输入项类型",user.getLanguage(),"0");
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(15208,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
double  dsporder=1.00;
RecordSet.executeSql("select max(dsporder) as maxdsporder from T_InputReportItemType where inprepId="+inprepid);
if(RecordSet.next()){
	dsporder=Util.getDoubleValue(RecordSet.getString("maxdsporder"),0);
	dsporder=dsporder+1;
}
DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式
%>

<FORM id=weaver name=frmMain action="InputReportItemtypeOperation.jsp" method=post >
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
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height: 1px"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20801,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class="InputStyle" size=50 name="itemtypename" onchange='checkinput("itemtypename","itemtypenameimage")'>
        <SPAN id=itemtypenameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR> <TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20802,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class="InputStyle"  size=50 name="itemtypedesc" >
      </TD>
    </TR>
    <TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
      <td class=Field>
        <INPUT type=text class=inputstyle size=7 id=dsporder name="dsporder" value="<%=decimalFormat.format(dsporder)%>" onKeyPress='ItemDecimal_KeyPress("dsporder",15,2)'  onchange='checknumber("dsporder");checkDigit("dsporder",15,2)'>
      </td>
    </tr>
     <TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD></TR>
    <input type="hidden" name=operation value=add>
	<input type="hidden" name=inprepid value=<%=inprepid%>>
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
</BODY></HTML>
 <script language="javascript">
function submitData(obj){
	if (check_form(frmMain,'itemtypename')){
	    obj.disabled=true;
		frmMain.submit();
	}
}

/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}
</script>

