
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<%
response.setHeader("X-UA-Compatible","IE=EmulateIE8");
if("false".equals(isIE)){
	response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=18017");
	return;
}

int wfid=Util.getIntValue(request.getParameter("wfid"),0);
int formid=Util.getIntValue(request.getParameter("formid"),0);
int nodeid=Util.getIntValue(request.getParameter("nodeid"),0);
int modeid=Util.getIntValue(request.getParameter("modeid"),0);
int isbill=Util.getIntValue(request.getParameter("isbill"),-1);
int isprint=Util.getIntValue(request.getParameter("isprint"),-1);
int isform=Util.getIntValue(request.getParameter("isform"),0);
int flag=Util.getIntValue(request.getParameter("flag"),0);
String ajax=Util.null2String(request.getParameter("ajax"));
// 是否来自流程图形化编辑
String design = Util.null2String(request.getParameter("design"));
if(flag==1){
%>
<SCRIPT LANGUAGE=javascript>
    alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
</SCRIPT>
<%
}
if(formid==0 || isbill==-1 || isprint==-1){
%>
<SCRIPT LANGUAGE=javascript>
    <%if(user.getLanguage()==8){%>
    alert("<%=SystemEnv.getHtmlLabelName(84009 ,user.getLanguage())%>");		
   	<%}else if(user.getLanguage()==9){%>
    	alert("<%=SystemEnv.getHtmlLabelName(84009 ,user.getLanguage())%>")
    <%}else{%>
    alert("<%=SystemEnv.getHtmlLabelName(84009 ,user.getLanguage())%>");
    <%}%>
</SCRIPT>
<%}else{%>
<SCRIPT LANGUAGE=javascript>
function window.onbeforeunload(){
        //return "";
}
function loadchinaexcel(){
    document.getElementById("chinaexcel").src="eWeb.jsp?design=<%=design%>&formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=<%=isform%>&isbill=<%=isbill%>&isprint=<%=isprint%>&modeid=<%=modeid%>&ajax=<%=ajax%>";
}
function showlist(){
    document.getElementById("fieldlist").style.display='';
	 document.getElementById("fieldlist").style.height="100%";
}
</SCRIPT>
<TITLE></TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">

<frameset rows="*" cols="*,20%" framespacing="0" frameborder="no" border="1">
  <frame id="chinaexcel"  src="" />
  <frame id="fieldlist" src="fieldlist.jsp?formid=<%=formid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&isform=<%=isform%>&isbill=<%=isbill%>&isprint=<%=isprint%>&modeid=<%=modeid%>" style="display:none" onload="loadchinaexcel()"/>
</frameset>
<noframes>
<%}%>
</HEAD>

<BODY>
</BODY>
</HTML>
