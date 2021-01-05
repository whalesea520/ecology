<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%
// 由于嵌入了图形化的表单设计，不能在一个页面来导入body，现在增加一个跳转页面


int requestid = Util.getIntValue(request.getParameter("requestid"),0);
String message = Util.null2String(request.getParameter("message"));  // 返回的错误信息
String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面

// 工作流新建文档的处理
String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
String newdocid = Util.null2String(request.getParameter("docid"));        // 新建的文档

String actionPage = "" ;

RecordSet.executeSql("select count(a.formid) from workflow_formprop a, workflow_base b, workflow_Requestbase c where a.formid = b.formid and b.id = c.workflowid and c.requestid = "+requestid);
if(RecordSet.next() && RecordSet.getInt(1) > 0 ) actionPage = "ManageRequestForm.jsp" ;
else actionPage = "ManageRequestNoForm.jsp" ;

int userid=user.getUID();                   //当前用户id
int lastOperator=0; //最后操作者id
String lastOperateDate="";//最后操作日期
String lastOperateTime="";//最后操作时间
// 查询请求的相关工作流基本信息
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){
    lastOperator = Util.getIntValue(RecordSet.getString("lastOperator"),0);
    lastOperateDate=Util.null2String(RecordSet.getString("lastOperateDate"));
    lastOperateTime=Util.null2String(RecordSet.getString("lastOperateTime"));
}

session.setAttribute(userid+"_"+requestid+"lastOperator",""+lastOperator);
session.setAttribute(userid+"_"+requestid+"lastOperateDate",lastOperateDate);
session.setAttribute(userid+"_"+requestid+"lastOperateTime",lastOperateTime);
%>

<BODY onload='manageform.submit ()'>
<FORM name=manageform method=post action='<%=actionPage%>?requestid=<%=requestid%>&message=<%=message%>&topage=<%=topage%>&docfileid=<%=docfileid%>&newdocid=<%=newdocid%>'>
    <input type="hidden" name="requestid" value="<%=requestid%>">
    <input type="hidden" name="message" value="<%=message%>">
    <input type="hidden" name="topage" value="<%=topage%>">
    <input type="hidden" name="docfileid" value="<%=docfileid%>">
    <input type="hidden" name="newdocid" value="<%=newdocid%>">
	<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
	<input type="hidden" name="needChooseOperator" value="<%=Util.null2String(request.getParameter("needChooseOperator")) %>"/>
</FORM>
</BODY>
</HTML>