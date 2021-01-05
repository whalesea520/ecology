<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ModeDetailImport" class="weaver.formmode.view.ModeDetailImport" scope="page"/>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String src = Util.null2String(fu.getParameter("src"));
    int modeId = Util.getIntValue(fu.getParameter("modeId"));
    int formId = Util.getIntValue(fu.getParameter("formId"));
    int billid = Util.getIntValue(fu.getParameter("billid"));
    out.print("<script>try{");
    
    String msg=ModeDetailImport.ImportDetail(fu,user);
    if("".equals(msg)){
    	msg = SystemEnv.getHtmlLabelName(25750, user.getLanguage());//导入成功
    }
    StringBuffer resultJs = new StringBuffer();
    resultJs.append("var parentWin = null;");
    resultJs.append("var dialog = null;");
    resultJs.append("try{");
    resultJs.append("parentWin = parent.parent.getParentWindow(parent);");
    resultJs.append("dialog = parent.parent.getDialog(parent);");
    resultJs.append("}catch(e){}");
    resultJs.append("if(dialog){dialog.close('"+msg+"')}");
    resultJs.append("else{window.parent.parent.close();}");
    out.print(resultJs);
    out.print("}catch(e){}");
    out.print("</script>");
%>