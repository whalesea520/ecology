<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.workflow.layout.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowComInfo" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    Workflow wf;
    String currWf = request.getParameter("id");
    if (currWf != null && !currWf.equals("")) {
	    wf = DownloadWFLayoutServlet.readWFLayout(Util.getIntValue(currWf,0), user.getLanguage(), false);
	    wf.checkAndAutosetLayout(10, 10, 20, 50);
	} else {
	    wf = new Workflow();
	}

    String wfnameq = Util.null2String(request.getParameter("wfnameq"));
   
    String serverstr=request.getScheme()+"://"+request.getHeader("Host");
%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16352,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<script language=javascript>
function editit() {
    var workflowids = document.getElementById("workflowids");
    for (i=0;i<workflowids.size;i++) {
        if (workflowids.options[i].selected) {
            form1.action = "/workflow/request/WorkflowLayoutEdit.jsp?id="+workflowids.options[i].value+"&wfnameq=<%=wfnameq%>";
            form1.submit();
            break;
        }
    }
}
</script>

<body>
<form name="form1" method="post" action="WorkflowLayoutEdit.jsp?id="+workflowids.options[i].value >
<%
    String sql = "select * from workflow_base where isvalid='1' and workflowname like '%"+wfnameq+"%' order by workflowname"; //xwj td1800 on 2005-04-27
    //System.out.println("sql = " + sql);
    rs.executeSql(sql);
    //WorkflowComInfo wfci = new WorkflowComInfo();
    //wfci.setTofirstRow();
    //int wfnum = wfci.getWorkflowNum();
    int top = 0;
    int left = 0;
    int listwidth = 150;
    int appletwidth = wf.getMaxPos().x+10>800?wf.getMaxPos().x+10:800;
    int appletheight = wf.getMaxPos().y+10>592?wf.getMaxPos().y+10:592;

    String viewName = "";
    while (rs.next()) {
        viewName = DownloadWFLayoutServlet.ch2China(rs.getString("workflowname"), user.getLanguage(), true);
        if(viewName != null){
            //System.out.println("viewName = "+viewName+" \tviewNameLength = " + viewName.getBytes().length);
            if(viewName.getBytes().length*420/60>listwidth){
                listwidth = viewName.getBytes().length*420/60;
            }

        }
    }
    //System.out.println("listwidth = " + listwidth);
    rs.beforFirst();
    listwidth +=30;
%>
    <div style="position:absolute;left:<%=left%>;top:<%=top%>;width:<%=listwidth%>;height:<%=appletheight%>">
        <input type="text" name="wfnameq" class="InputStyle" style="position:absolute;left:0;top:0;width:<%=listwidth%>;height:22">
        <select class=inputstyle  name="id" id="workflowids" ondblclick="editit()" size="100000" style="position:absolute;left:0;top:23;width:<%=listwidth%>;height:<%=appletheight-22%>">
<%  while (rs.next()) {  %>
          <option value="<%=rs.getString("id")%>" <%if (rs.getString("id").equals(currWf)) {%>selected<%}%>><%=DownloadWFLayoutServlet.ch2China(rs.getString("workflowname"), user.getLanguage(), true)%></option>
<%  }  %>
        </select>
    </div>
    <div style="position:absolute;left:<%=left+listwidth+2%>;top:<%=top%>;width:<%=appletwidth%>;height:<%=appletheight%>">
      <object classid="clsid:CAFEEFAC-0013-0001-0004-ABCDEFFEDCBA" width=<%=appletwidth%> height=<%=appletheight%> codebase="<%=serverstr%>/resource/j2re-1_3_1_04-windows-i586.exe">
        <param name = CODE value = weaver.workflow.layout.WorkflowEditor.class >
        <param name = CODEBASE value = /classbean >
        <param name="type" value="application/x-java-applet;jpi-version=1.3.1">
        <param name="scriptable" value="false">
    	<param name="MAYSCRIPT" value="true">
        <param name = "downloadUrl" value="<%=serverstr%>/weaver/weaver.workflow.layout.DownloadWFLayoutServlet"/>
        <param name = "uploadUrl" value ="<%=serverstr%>/weaver/weaver.workflow.layout.DownloadWFLayoutServlet"/>
        <param name = "id" value="<%=(currWf==null?"":currWf)%>">
        <param name = actionRedirectToLogin value = "redirect"/>
      </object>
    </div>
</form>
<%
String loginfile = Util.getCookie(request , "loginfileweaver");
%>
<form name="redirect" method="post" action="/Refresh.jsp?loginfile=<%=loginfile%>&message=19">
</form>
</body>
</html>

