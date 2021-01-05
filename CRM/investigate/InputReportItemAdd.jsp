<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(15213,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:weaver.domysave.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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
<FORM id=weaver name=frmMain action="InputReportItemOperation.jsp" method=post onSubmit="return check_form(this,'itemdspname,itemfieldname')">

<DIV>
<BUTTON class=btnSave accessKey=S  style="display:none" id=domysave  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
</DIV>
<br>

  <TABLE class=ViewForm>
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=Title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15199,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15207,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class=InputStyle size=50 name="itemdspname" onchange='checkinput("itemdspname","itemdspnameimage")'>
        <SPAN id=itemdspnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%></TD>
      <TD class=Field > 
        <select class=InputStyle  name="itemfieldtype" style="width:50%" onChange="showType()">
          <option value="1"><%=SystemEnv.getHtmlLabelName(15201,user.getLanguage())%></option>
          <option value="6"><%=SystemEnv.getHtmlLabelName(15206,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15202,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(15203,user.getLanguage())%></option>
          <option value="4"><%=SystemEnv.getHtmlLabelName(15204,user.getLanguage())%></option>
          <option value="5"><%=SystemEnv.getHtmlLabelName(15205,user.getLanguage())%></option>
        </select>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15209,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class=InputStyle size=40 name="itemfieldname" onchange='checkinput("itemfieldname","itemfieldnameimage")'>
        <SPAN id=itemfieldnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>（<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>："f_"+"<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>"[<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>]，<%=SystemEnv.getHtmlLabelName(15210,user.getLanguage())%>。）</TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr  id = textscale style="display:''" > 
      <td><%=SystemEnv.getHtmlLabelName(15211,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text class=InputStyle size=7 id=itemfieldscale1 name="itemfieldscale" value=60>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr id=numberscale style="display:none"> 
      <td><%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text class=InputStyle size=7 id=itemfieldscale2 name="itemfieldscale" value=2 >
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text class=InputStyle size=7 id=itemfieldunit name="itemfieldunit">
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <input type="hidden" name=operation value=add>
    <input type="hidden" name=inprepid value=<%=inprepid%>>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 <script language=javascript>
 function showType(){
		itemfieldtypelist = window.document.frmMain.itemfieldtype;
		if(itemfieldtypelist.value==1){
			textscale.style.display='';
			numberscale.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = false ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
		}
		if(itemfieldtypelist.value==2){
			textscale.style.display='none';
			numberscale.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
           
		}
		if(itemfieldtypelist.value==3){
			textscale.style.display='none';
			numberscale.style.display='';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = false ;
		}
		if(itemfieldtypelist.value==4){
			textscale.style.display='none';
			numberscale.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
		}
        if(itemfieldtypelist.value==5){
			textscale.style.display='none';
			numberscale.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
		}
        if(itemfieldtypelist.value==6){
			textscale.style.display='none';
			numberscale.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
		}
	}
</script>

</BODY></HTML>
