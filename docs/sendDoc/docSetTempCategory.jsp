
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="CategoryUtil" class="weaver.docs.category.CategoryUtil" scope="page" />
<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("SendDoc:Manage",user)) {
	canedit=true;
   }
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16997,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
String path="";
String secid="";
String createrId="";
String secidTemp=Util.null2String(request.getParameter("secid"));
String createrIdTemp=Util.null2String(request.getParameter("createrId"));
String method=Util.null2String(request.getParameter("method"));
if (method.equals("save")&&(!secidTemp.equals("")))
{
    String sqlTemp="";
    RecordSet.executeSql("select * from DocSendDocDefaultValue") ;
    if (RecordSet.next())  sqlTemp="update DocSendDocDefaultValue set categoryId="+secidTemp+",createrId="+createrIdTemp;
        else  sqlTemp="insert into DocSendDocDefaultValue(categoryId,createrId) values("+secidTemp+","+createrIdTemp+")";
    RecordSetV.executeSql(sqlTemp);
}
RecordSet.executeSql("select * from DocSendDocDefaultValue") ;
if (RecordSet.next())
{
  secid=RecordSet.getString("categoryId") ;
  createrId=RecordSet.getString("createrId") ;
}
if (!secidTemp.equals(""))  secid=secidTemp;
if (!createrIdTemp.equals(""))  createrId=createrIdTemp;
if (!secid.equals("")) {
    path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secid,0));
}
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

    <table width=100% border="0"  class=Viewform>
    <FORM id=weaver name=weaver action="docSetTempCategory.jsp" method=post  >
    <colgroup>
    <col width="10%">
    <col width="90%">
    <tr><td class=Line colspan=2></td></tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(16998,user.getLanguage())%></td>
      <td class=field>
      <%if (canedit) {%>
      <BUTTON type='button' class=Browser onClick="onSelectCategory()" name=selectCategory></BUTTON>
      <%}%>
      <span id=path name=path><%=path.equals("")?"<IMG src='/images/BacoError_wev8.gif' align=absMiddle>":"<a href=/docs/category/DocSecCategoryEdit.jsp?id="+secid+">"+path+"</a>"%></span>
      <INPUT type=hidden name=secid value="<%=secid%>">
      <INPUT type=hidden id=method name=method >
      </td>
    </tr>
    <tr><td class=Line colspan=2></td></tr>
    <TR>
    <TD><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TD>
    <TD class=Field>
    <%if (canedit) {%>
    <BUTTON type='button' class=Browser id=SelectResourceID onClick="onShowManagerID()"></BUTTON>
    <%}%>
    <span id=createrIdSpan><%if(createrId.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}else{%><%=ResourceComInfo.getResourcename(createrId)%><%}%></span>
    <INPUT type=hidden name=createrId value="<%=createrId%>"></TD>
    </TR>
    <tr><td class=Line colspan=2></td></tr>
    </FORM>
    </table>

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
</HTML>
<script>
function onSelectCategory() {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode=0");
	if (result != null) {
	    if (result[0] > 0)  {
	        location.href = "docSetTempCategory.jsp?secid="+result[1]+"&createrId="+weaver.createrId.value;
    	} else {
    	    location.href = "docSetTempCategory.jsp?createrId="+weaver.createrId.value;
    	}
	}
}

function submitData() {
 if(check_form(weaver,"secid,createrId")){
 weaver.method.value="save";
 weaver.submit();
 }
}
</script>
<script language=vbs>
sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	createrIdSpan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	weaver.createrId.value=id(0)
	else
	createrIdSpan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.createrId.value=""
	end if
	end if
end sub
</script>
