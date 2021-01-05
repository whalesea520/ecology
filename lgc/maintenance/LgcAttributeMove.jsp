<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcAttributeMove:Move",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int countid = Util.getIntValue(request.getParameter("countid"),-1);
String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(78,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(713,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
<%
if(countid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlNoteName(40,user.getLanguage())%> : <%=countid%>
</font>
</DIV>
<%}%>

<FORM id=frmMain name=frmMain action=LgcToolsOperation.jsp method=post onsubmit="return checkvalue()">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:frmMain.myfun1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  <BUTTON class=Btn accessKey=1 id=myfun1 style="display:none"  type=submit><U>1</U>-<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  <BUTTON class=Btn accessKey=2  style="display:none"  onclick='location="../LgcMaintenance.jsp"'><U>2</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON> 
  <TABLE width="100%">
    <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%"> <TBODY> 
    <TR> 
      <TD> 
        <input type=hidden value="attributemove" name=operation>
        <table class=ViewForm>
          <colgroup> <col width=*> <col width=275> <tbody> 
          <tr><td class=Line1 colspan=2></td></tr>
          <tr> 
            <td><b>种类</b></td>
            <td  class=Field>
			<button class=Browser id=SelectAssortment onClick="onShowAssortmentID(assortmentidspan,assortmentid)"></button> 
        <span class=InputStyle id=assortmentidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
        <input id=assortmentid type=hidden name=assortmentid></td>
          </TR><tr><td class=Line colspan=2></td></tr>
          </tbody> 
        </table>
      </TD>
    </TR>
    <TR> 
      <TD> 
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=*> <COL width=275> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>属性 - 旧</TH>
          </TR>
          <TR class=Spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD>销售</TD>
            <TD> 
              <select class=InputStyle  name=issales_from>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>采购</TD>
            <TD> 
              <select class=InputStyle  name=ispurchase_from>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>库存</TD>
            <TD> 
              <select class=InputStyle  name=isstock_from>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>网上销售</TD>
            <TD> 
              <select class=InputStyle  name=iswebsales_from>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>批号</TD>
            <TD> 
              <select class=InputStyle  name=isorder_from>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
      <TD></TD>
      <TD> 
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=*> <COL width=275> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>属性 - 新</TH>
          </TR>
          <TR class=Spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD>销售</TD>
            <TD> 
              <select class=InputStyle  name=issales_to>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>采购</TD>
            <TD> 
              <select class=InputStyle  name=ispurchase_to>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>库存</TD>
            <TD> 
              <select class=InputStyle  name=isstock_to>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>网上销售</TD>
            <TD> 
              <select class=InputStyle  name=iswebsales_to>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          <TR> 
            <TD>批号</TD>
            <TD> 
              <SELECT class=InputStyle   name=isorder_to>
                <OPTION value="" 
              selected></OPTION>
                <OPTION value=0>否</OPTION>
                <OPTION 
              value=1>是</OPTION>
              </SELECT>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
    </TBODY>
  </TABLE>
</FORM>

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
<script language="vbs">
sub onShowAssortmentID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp ")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		inputname.value=""
		end if
	end if
end sub
</script>

<Script language="javascript">
function checkvalue() {
	if(!check_form(document.frmMain,"assortmentid")) return false ;
	ischeckright = true ;
	if((frmMain.issales_from.selectedIndex==0 && frmMain.issales_to.selectedIndex!=0) || (frmMain.issales_from.selectedIndex!=0 && frmMain.issales_to.selectedIndex==0) || (frmMain.issales_from.selectedIndex==frmMain.issales_to.selectedIndex && frmMain.issales_from.selectedIndex!=0)) ischeckright = false ;
	if((frmMain.ispurchase_from.selectedIndex==0 && frmMain.ispurchase_to.selectedIndex!=0) || (frmMain.ispurchase_from.selectedIndex!=0 && frmMain.ispurchase_to.selectedIndex==0) || (frmMain.ispurchase_from.selectedIndex==frmMain.ispurchase_to.selectedIndex && frmMain.ispurchase_from.selectedIndex!=0)) ischeckright = false ;
	if((frmMain.isstock_from.selectedIndex==0 && frmMain.isstock_to.selectedIndex!=0) || (frmMain.isstock_from.selectedIndex!=0 && frmMain.isstock_to.selectedIndex==0) || (frmMain.isstock_from.selectedIndex==frmMain.isstock_to.selectedIndex && frmMain.isstock_from.selectedIndex!=0)) ischeckright = false ;
	if((frmMain.iswebsales_from.selectedIndex==0 && frmMain.iswebsales_to.selectedIndex!=0) || (frmMain.iswebsales_from.selectedIndex!=0 && frmMain.iswebsales_to.selectedIndex==0) || (frmMain.iswebsales_from.selectedIndex==frmMain.iswebsales_to.selectedIndex && frmMain.iswebsales_from.selectedIndex!=0)) ischeckright = false ;
	if((frmMain.isorder_from.selectedIndex==0 && frmMain.isorder_to.selectedIndex!=0) || (frmMain.isorder_from.selectedIndex!=0 && frmMain.isorder_to.selectedIndex==0) || (frmMain.isorder_from.selectedIndex==frmMain.isorder_to.selectedIndex && frmMain.isorder_from.selectedIndex!=0)) ischeckright = false ;
	if(!ischeckright) alert("<%=SystemEnv.getHtmlNoteName(39,user.getLanguage())%>") ;
	return ischeckright ;
}
</script>
</BODY></HTML>
