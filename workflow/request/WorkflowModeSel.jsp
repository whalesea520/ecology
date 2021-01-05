
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import = "weaver.general.Util"%>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<%
int nrow = Util.getIntValue(request.getParameter("nrow"),0);
int ncol = Util.getIntValue(request.getParameter("ncol"),0);
String selvalue=Util.null2String(request.getParameter("selvalue"));
String isbill=Util.null2String(request.getParameter("isbill"));
String fieldid=Util.null2String(request.getParameter("fieldid"));
FieldInfo.getSelectItem(fieldid,isbill);
ArrayList  SelectItems=FieldInfo.getSelectItems();
ArrayList SelectItemValues=FieldInfo.getSelectItemValues();
String fieldvalue="";
for(int i=0;i<SelectItems.size();i++){
    String temp=(String)SelectItems.get(i);
    if(selvalue.equals(temp)){
        fieldvalue=(String)SelectItemValues.get(i);
    }
}
%>
<script language=javascript>
window.parent.document.all("<%=fieldid%>").value="<%=fieldvalue%>";
</script>