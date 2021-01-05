<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.conn.*"%>
<%
	try{
		FileUpload fu = new FileUpload(request);
		String taskId = Util.null2String(fu.getParameter("taskId"));
		int showallsub = Util.getIntValue(fu.getParameter("showallsub"),0);
		String data = this.getSubTask(taskId,user,1,showallsub);
		if(data.equals("")){
			data = "<tr><td class='data' align='center' colspan='2'><div class='taskTips'>没有下级任务</div></td></tr>";
		}
		out.print(data);
	}catch(Exception e){
		out.print("<tr><td class='data' align='center'  colspan='2'><div class='taskTips'>获取下级任务失败</div></td></tr>");	
	}
%>
<%! 
	private String getSubTask(String maintaskid,User user,int type,int showallsub) throws Exception{
		String userid = user.getUID()+"";
		StringBuffer res = new StringBuffer();
		boolean editsub = false;
		int cancreate = 0;
		RecordSet rs = new RecordSet();
		ResourceComInfo rc = new ResourceComInfo();
		StringBuffer sql = new StringBuffer();
		sql.append("select t1.id,t1.name,t1.principalid,t1.status,t1.creater"
				+",(select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+") as cancreate"
				+",(select max(tt.tododate) from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+userid+") as tododate"
				+" from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid);
		if(showallsub==0){
			sql.append(" and (t1.principalid="+userid+" or t1.creater="+userid
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
				+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
				+ ")");
		}
		sql.append(" order by t1.enddate,t1.id");
		rs.executeSql(sql.toString());
		if(type==2) res.append("<tr class='subtable_tr'><td colspan='2' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'><colgroup><col width='*'/><col width='50px'/></colgroup>");
		while(rs.next()){
			String taskid = Util.null2String(rs.getString("id"));
			String dutyMan = rc.getLastname(rs.getString("principalid"));
			res.append("<tr class='subitem_tr'>");
			res.append("<td class='item_td'><a href='javascript:toTask("+taskid+")'>"+Util.null2String(rs.getString("name"))+"</a></td>");
			res.append("<td class='item_hrm'>"+dutyMan+"</td>");
			res.append("</tr>");
			res.append(this.getSubTask(rs.getString("id"),user,2,showallsub));
		}
		if(type==2) res.append("</table></td></tr>");
		return res.toString();
	}
%>