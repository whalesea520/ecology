<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int itemtypeid = Util.getIntValue(request.getParameter("itemtypeid"),0);
rs.executeProc("T_IRIT_SelectByItemtypeid",""+itemtypeid);
rs.next() ;

String itemtypename = Util.toScreenToEdit(rs.getString("itemtypename"),user.getLanguage()) ;
String itemtypedesc = Util.toScreenToEdit(rs.getString("itemtypedesc"),user.getLanguage()) ;
String inprepid = Util.null2String(rs.getString("inprepid")) ;
String dsporder = Util.null2String(rs.getString("dsporder")) ;


String imagefilename = "/images/hdHRMCard.gif";
String titlename =SystemEnv.getHtmlLabelName(15208,user.getLanguage()) +":" +itemtypename ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",InputReportItemtypeAdd.jsp?inprepid="+inprepid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="InputReportItemtypeOperation.jsp" method=post>
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
        <INPUT type=text class="InputStyle" size=50 name="itemtypename" onchange='checkinput("itemtypename","itemtypenameimage")' value="<%=itemtypename%>">
        <SPAN id=itemtypenameimage></SPAN></TD>
    </TR><TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20802,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class="InputStyle"  size=50 name="itemtypedesc" value="<%=itemtypedesc%>">
      </TD>
    </TR><TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class="InputStyle"  size=50 name="dsporder" value="<%=dsporder%>" onKeyPress='ItemDecimal_KeyPress("dsporder",15,2)'  onchange='checknumber("dsporder");checkDigit("dsporder",15,2)' >
      </TD>
    </TR><TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    
    <input type="hidden" name=operation>
	<input type="hidden" name=inprepid value=<%=inprepid%>>
	<input type="hidden" name=itemtypeid value=<%=itemtypeid%>>
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
 <script language=javascript>
 function onSave(obj){
	if(check_form(document.frmMain,'itemtypename')){
		obj.disabled=true;
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script> 
 <script language="javascript">
function submitData()
{
	if (check_form(frmMain,'itemtypename'))
		frmMain.submit();
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

