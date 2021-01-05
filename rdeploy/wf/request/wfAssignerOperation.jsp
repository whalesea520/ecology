
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

RecordSet rs = new RecordSet();
//System.out.println("actionkey = "+actionkey);
int wfid = Util.getIntValue(request.getParameter("wfid"));

//更新操作组
int savenodeid = Util.getIntValue(request.getParameter("savenodeid"));
int grouptype = Util.getIntValue(request.getParameter("grouptype"), 0);
int objid = Util.getIntValue(request.getParameter("objid"), 0);
int Signtype = Util.getIntValue(request.getParameter("Signtype"), 0);
//System.out.println("nodename = "+nodename);
String groupid = "";
String data = "";
if((grouptype==3&&objid!=0) || (grouptype!=3&&grouptype!=0)){
	//获取groupid
	String sql = "select id from workflow_nodegroup where nodeid = "+savenodeid;
	rs.executeSql(sql);
	if(rs.next()){
		groupid = Util.null2String(rs.getString("id"));
	}
	if(!"".equals(groupid)){
		//删除节点操作者明细
		sql = "delete from workflow_groupdetail where groupid = " + groupid;
        rs.executeSql(sql);
        //添加节点操作者明细
        sql = "insert into workflow_groupdetail (groupid,type,objid,level_n,level2_n,signorder,conditions,conditioncn,orders) values(" + groupid +
                   ","+grouptype+"," + objid + ",0,100,'" + Signtype + "','','',0)";
           //System.out.println("操作组明细sql"+sql);
        rs.executeSql(sql);
	}
	data="{\"wfid\":\""+wfid+"\",\"success\":\"success\"}";
}else{
	data="{\"wfid\":\""+wfid+"\",\"success\":\"false\"}";
}
response.getWriter().write(data);
%>

