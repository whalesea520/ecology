
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String receiveUnitIds = Util.null2String(request.getParameter("receiveUnitIds"));
if("".equals(receiveUnitIds)){
	receiveUnitIds = Util.null2String(request.getParameter("selectids"));
}
String rightStr_multi = Util.null2String(request.getParameter("rightStr"));
session.setAttribute("rightStr_multi"+user.getUID(), rightStr_multi);
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String status=Util.null2String(request.getParameter("status"));
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
String requestid = Util.null2String(request.getParameter("requestid"));
int uid=user.getUID();
    String resourcemulti = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("receiveUnitIdsmulti" + uid)) {
            resourcemulti = cks[i].getValue();
            break;
        }
    }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE type=text/css>PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
</STYLE>


</HEAD>
<body scroll="no">



<TABLE class=form width=100% id=oTable1 height="100%">
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  </colgroup>
  <TBODY>
<tr>
<td  id=oTd1 name=oTd1 width=100% style="height:50% !important;">

<IFRAME name=frame1 id=frame1 src="/docs/sendDoc/DocReceiveUnitBrowserMultiTree.jsp?fromBrowser=1&receiveUnitIds=<%=receiveUnitIds%>" width=100%  height=100% frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
</IFRAME>

</td>
</tr>
<tr id="subdepttr">
  <td colspan="3" style="height:5% !important;"><input type="checkbox" id="showsubdept" name="showsubdept" value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24349,user.getLanguage())%></td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100% style="height:45% !important;">

<IFRAME name=frame2 id=frame2 src="/docs/sendDoc/MultiSelect.jsp?receiveUnitIds=<%=receiveUnitIds%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&isWorkflowDoc=<%=isWorkflowDoc %>&requestid=<%=requestid %>" width=100%  height=100% frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%>
</IFRAME>

</td>
</tr>
</TBODY>
</table>

</body>
</html>