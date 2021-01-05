
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page" />

<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
    AclManager am = new AclManager();

    boolean canMove = false ;
    int docId= Util.getIntValue(request.getParameter("docId"),0);
    int userCategory = Util.getIntValue(request.getParameter("userCategory"),0);  

    int secId = Util.getIntValue(request.getParameter("txtMoveTo"),0);  
    int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secId),-1);
    int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid),-1);

    if(am.hasPermission(secId, AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_CREATEDOC)) {
        if (secId != -1){
            canMove = true;
        }
    }


%>
</head>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18493,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(78,user.getLanguage());

String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if (canMove) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onDoSubmit(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 
<DIV class=HdrProps>
</DIV>
<form method="POST" action="PersonalDocOperation.jsp" name="frmMoveOut">
<input type=hidden name="docId" value="<%=docId%>">
<input type=hidden name="operation" value="fileMoveOut">
<input type=hidden name="userCategory" value="<%=userCategory%>">
<TABLE class=viewForm>
  <TBODY>
  <TR class=line1><TD colspan="2"></TD></TR>  
  <tr>
    <td width="40%"><%=DocUserSelfUtil.getDocNameAtonce(""+docId)+" "+SystemEnv.getHtmlLabelName(78,user.getLanguage())%>：</td>    
    <td width="60%" class="field">
        <BUTTON type="button" class=Browser onClick="onShowCatalog()" name=selectCategory></BUTTON><span id=spanMoveTo name=spanMoveTo>
        <%   if (secId!=-1) out.println(CategoryUtil.getCategoryPath(secId));   %></span>
        <%if (!canMove) out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=#FF0066>"+SystemEnv.getHtmlLabelName(18498,user.getLanguage())+"</font>");%>
        <input type="hidden" id="txtMoveTo" name="txtMoveTo" value="<%=secId%>">
    </td>
    <TR class=line><TD colspan="2"></TD></TR>  
</tbody>
</table>
</form>
</body>
</html>
<script language="javaScript">
function onShowCatalog() {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    if (result != null) {        
        if (result[0] > 0)  {
            document.all("txtMoveTo").value= result[1]   ;
            document.frmMoveOut.action='PersonalMoveOut.jsp'
            document.frmMoveOut.submit()
        } else {
             document.all("txtMoveTo").value= ""   ;
            document.frmMoveOut.action='PersonalMoveOut.jsp'
            document.frmMoveOut.submit() 
        }
    }
}
function onDoSubmit(obj) {
    obj.disabled = true ;
    frmMoveOut.submit() ;
}
</script>