
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*,weaver.conn.ConnStatement" %>
<jsp:useBean id="WTManager" class="weaver.worktask.worktask.WTManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String sql = "";
	int error = 0;
	int returnValue = 0;
	String src = Util.null2String(request.getParameter("src"));
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	if(src.equalsIgnoreCase("addwt")){
		String name = Util.null2String(request.getParameter("name"));
		int orderid = Util.getIntValue(request.getParameter("orderid"), 0);
		int isvalid = Util.getIntValue(request.getParameter("isvalid"), 0);
		int autotoplan = Util.getIntValue(request.getParameter("autotoplan"), 0);
		int workplantypeid = Util.getIntValue(request.getParameter("workplantypeid"), 0);
		if(autotoplan == 0){
			workplantypeid = 0;
		}
		int annexmaincategory = Util.getIntValue(request.getParameter("annexmaincategory"), 0);
		int annexsubcategory = Util.getIntValue(request.getParameter("annexsubcategory"), 0);
		int annexseccategory = Util.getIntValue(request.getParameter("annexseccategory"), 0);
		WTManager.reset();
		WTManager.setAction("addwt");
		WTManager.setName(name);
		WTManager.setOrderid(orderid);
		WTManager.setIsvalid(isvalid);
		WTManager.setAutotoplan(autotoplan);
		WTManager.setWorkplantypeid(workplantypeid);
		WTManager.setAnnexmaincategory(annexmaincategory);
		WTManager.setAnnexsubcategory(annexsubcategory);
		WTManager.setAnnexseccategory(annexseccategory);
		wtid = WTManager.setWtInfo();
		if(wtid == -1){
			error = 1;
			wtid = 0;
		}
%>
	<script language="javascript">
		try{parent.parent.e8_initTree("/worktask/base/WT_TreeLeft.jsp");}catch(e){}
		parent.location.href = "worktaskAdd.jsp?wtid=<%=wtid%>&error=<%=error%>";
	</script>
<%
		return;
	}else if(src.equalsIgnoreCase("editwt")){
		String name = Util.null2String(request.getParameter("name"));
		int orderid = Util.getIntValue(request.getParameter("orderid"), 0);
		int isvalid = Util.getIntValue(request.getParameter("isvalid"), 0);
		int autotoplan = Util.getIntValue(request.getParameter("autotoplan"), 0);
		int workplantypeid = Util.getIntValue(request.getParameter("workplantypeid"), 0);
		if(autotoplan == 0){
			workplantypeid = 0;
		}
		int annexmaincategory = Util.getIntValue(request.getParameter("annexmaincategory"), 0);
		int annexsubcategory = Util.getIntValue(request.getParameter("annexsubcategory"), 0);
		int annexseccategory = Util.getIntValue(request.getParameter("annexseccategory"), 0);
		WTManager.reset();
		WTManager.setAction("editwt");
		WTManager.setWtid(wtid);
		WTManager.setName(name);
		WTManager.setOrderid(orderid);
		WTManager.setIsvalid(isvalid);
		WTManager.setAutotoplan(autotoplan);
		WTManager.setWorkplantypeid(workplantypeid);
		WTManager.setAnnexmaincategory(annexmaincategory);
		WTManager.setAnnexsubcategory(annexsubcategory);
		WTManager.setAnnexseccategory(annexseccategory);
		returnValue = WTManager.setWtInfo();
		if(returnValue == -1){
			error = 1;
		}
%>
	<script language="javascript">
			try{parent.parent.e8_initTree("/worktask/base/WT_TreeLeft.jsp");}catch(e){}
		location.href = "addwt0.jsp?wtid=<%=wtid%>&error=<%=error%>";
	</script>
<%
		//response.sendRedirect("addwt0.jsp?wtid="+wtid+"&error="+error);
		return;
	}else if(src.equalsIgnoreCase("delwt")){
		WTManager.reset();
		WTManager.setAction("editwt");
		WTManager.setWtid(wtid);
		returnValue = WTManager.delWorktask();
		if(returnValue == 0){
%>
		<script language="javascript">
			try{parent.parent.e8_initTree("/worktask/base/WT_TreeLeft.jsp");}catch(e){}
			try{parent.location.href = "worktaskSysSet.jsp?wtid=0";}catch(e){}
		</script>
<%
			return;
		}else{
			error = 2;
%>
		<script language="javascript">
			location.href = "addwt0.jsp?wtid=<%=wtid%>&error=<%=error%>";
		</script>
<%
			return;
		}
	}else if(src.equalsIgnoreCase("saveremind")){
		int remindtype = Util.getIntValue(request.getParameter("remindtype"), 0);
		int beforestart = Util.getIntValue(request.getParameter("beforestart"), 0);
		int beforestarttime = Util.getIntValue(request.getParameter("beforestarttime"), 0);
		int beforestarttype = Util.getIntValue(request.getParameter("beforestarttype"), 0);
		int beforestartper = Util.getIntValue(request.getParameter("beforestartper"), 0);
		int beforeend = Util.getIntValue(request.getParameter("beforeend"), 0);
		int beforeendtime = Util.getIntValue(request.getParameter("beforeendtime"), 0);
		int beforeendtype = Util.getIntValue(request.getParameter("beforeendtype"), 0);
		int beforeendper = Util.getIntValue(request.getParameter("beforeendper"), 0);
		if(remindtype == 0){
			sql = "update worktask_base set remindtype=0, beforestart=0, beforestarttime=0, beforestarttype=0, beforestartper=0, beforeend=0, beforeendtime=0, beforeendtype=0, beforeendper=0 where id="+wtid;
		}else if(beforestart == 0){
			sql = "update worktask_base set remindtype="+remindtype+", beforestart=0, beforestarttime=0, beforestarttype=0, beforestartper=0, beforeend=1, beforeendtime="+beforeendtime+", beforeendtype="+beforeendtype+", beforeendper="+beforeendper+" where id="+wtid;
		}else{
			sql = "update worktask_base set remindtype="+remindtype+", beforestart=1, beforestarttime="+beforestarttime+", beforestarttype="+beforestarttype+", beforestartper="+beforestartper+", beforeend="+beforeend+", beforeendtime="+beforeendtime+", beforeendtype="+beforeendtype+", beforeendper="+beforeendper+" where id="+wtid;
		}
		//System.out.println(sql);
		rs.execute(sql);
		response.sendRedirect("RemindedSet.jsp?wtid="+wtid);
		return;
	}

	//response.sendRedirect("addwt0.jsp?");
	//return;
%>