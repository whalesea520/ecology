
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*,weaver.conn.ConnStatement" %>
<jsp:useBean id="FieldManager" class="weaver.worktask.field.FieldManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String sql = "";
	String mothed = Util.null2String(request.getParameter("mothed"));
	int wtid = Util.getIntValue(request.getParameter("wtid"), -1);
	if("save".equals(mothed)){
		String[] fieldids = request.getParameterValues("fieldid");
		if(fieldids==null || fieldids.length==0){
			response.sendRedirect("worktaskFieldEdit.jsp?wtid="+wtid);
			return;
		}
		ConnStatement statement = null;
		try{
			rs.execute("delete from worktask_taskfield where taskid="+wtid);
			sql = "insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid, defaultvalue, defaultvaluecn) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			statement = new ConnStatement();
			statement.setStatementSql(sql);
			for(int i=0; i<fieldids.length; i++){
				int field = Util.getIntValue(fieldids[i], 0);
				if(field == 0){
					continue;
				}
				String crmname = Util.null2String(request.getParameter("crmname_"+field));
				int isshow = Util.getIntValue(request.getParameter("isshow_"+field), 0);
				int isedit = Util.getIntValue(request.getParameter("isedit_"+field), 0);
				int ismand = Util.getIntValue(request.getParameter("ismand_"+field), 0);
				int orderid = Util.getIntValue(request.getParameter("orderid_"+field), 0);
				String defaultvalue = Util.null2String(request.getParameter("defaultvalue_"+field));
				String defaultvaluecn = Util.null2String(request.getParameter("defaultvaluecn_"+field));
				if(isshow == 0){
					orderid = 0;
				}

				statement.setInt(1, wtid);
				statement.setInt(2, field);
				statement.setString(3, crmname);
				statement.setInt(4, isshow);
				statement.setInt(5, isedit);
				statement.setInt(6, ismand);
				statement.setInt(7, orderid);
				statement.setString(8, defaultvalue);
				statement.setString(9, defaultvaluecn);
				statement.executeUpdate();
			}
			sql = "update worktask_tasklist set isshowlist=0, orderidlist=0, isquery=0, isadvancedquery=0, width=0 where fieldid in (select f.fieldid from worktask_taskfield f where f.taskid="+wtid+" and f.isshow=0) and taskid="+wtid;
			rs.execute(sql);
			sql = "update worktask_tasklist set isshowlist=1 where fieldid in (select f.fieldid from worktask_taskfield f where f.taskid="+wtid+" and f.ismand=1) and taskid="+wtid;
			rs.execute(sql);
			sql = "insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, width, isquery, isadvancedquery) select "+wtid+", f.fieldid, 1, 0, 0, 0, 0 from worktask_taskfield f where f.taskid="+wtid+" and f.ismand=1 and f.fieldid not in (select l.fieldid from worktask_tasklist l where l.taskid="+wtid+")";
			rs.execute(sql);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				statement.close();
			}catch(Exception ex){
			}
		}
		response.sendRedirect("worktaskFieldEdit.jsp?wtid="+wtid);
		return;
	}else if("delete".equals(mothed)){
		int wttype = Util.getIntValue(request.getParameter("wttype_delete"), 0);
		String message ="";
		String[] fieldids = request.getParameterValues("delete_field_id"+wttype);
		if(fieldids==null || fieldids.length==0){
			response.sendRedirect("worktaskFieldEdit.jsp?wtid="+wtid);
			return;
		}
		String ids = "";
		for(int i=0; i<fieldids.length; i++){
			int field = Util.getIntValue(fieldids[i], 0);
			if(field == 0){
				continue;
			}
			ids += (field + ",");
		}
		if("".equals(ids)){
			response.sendRedirect("worktaskFieldEdit.jsp");
			return;
		}else{
			ids = ids.substring(0, ids.length()-1);
			rs.execute("select * from worktask_fielddict where id in ("+ids+")");
			while(rs.next()){
					int fieldid = Util.getIntValue(rs.getString("id"), 0);
					if(fieldid == 0){
						continue;
					}
					String fieldname = Util.null2String(rs.getString("fieldname"));
					FieldManager.reset();
					FieldManager.setAction("deletefield");
					FieldManager.setFieldid(fieldid);
					FieldManager.setWttype(wttype);
					FieldManager.setFieldname(fieldname);
					message = FieldManager.delFieldInfo();
			}
			response.sendRedirect("worktaskFieldEdit.jsp?wtid="+wtid);
			return;
		}
	}else if("savelist".equals(mothed)){
		String[] fieldids = request.getParameterValues("fieldid");
		if(fieldids==null || fieldids.length==0){
			response.sendRedirect("worktaskListEdit.jsp?wtid="+wtid);
			return;
		}
		ConnStatement statement = null;
		try{
			rs.execute("delete from worktask_tasklist where taskid="+wtid);
			sql = "insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width, needorder) values (?, ?, ?, ?, ?, ?, ?, ?)";
			statement = new ConnStatement();
			statement.setStatementSql(sql);
			for(int i=0; i<fieldids.length; i++){
				int field = Util.getIntValue(fieldids[i], 0);
				if(field == 0){
					continue;
				}
				int isshowlist = Util.getIntValue(request.getParameter("isshowlist_"+field), 0);
				int orderidlist = Util.getIntValue(request.getParameter("orderidlist_"+field), 0);
				int isquery = Util.getIntValue(request.getParameter("isquery_"+field), 0);
				int isadvancedquery = Util.getIntValue(request.getParameter("isadvancedquery_"+field), 0);
				int width = Util.getIntValue(request.getParameter("width_"+field), 0);
				int needorder = Util.getIntValue(request.getParameter("needorder_"+field), 0);
				if(isshowlist == 0){
					orderidlist = 0;
					width = 0;
				}

				statement.setInt(1, wtid);
				statement.setInt(2, field);
				statement.setInt(3, isshowlist);
				statement.setInt(4, orderidlist);
				statement.setInt(5, isquery);
				statement.setInt(6, isadvancedquery);
				statement.setInt(7, width);
				statement.setInt(8, needorder);
				statement.executeUpdate();
			}
		}catch(Exception e){
			//e.printStackTrace();
		}finally{
			try{
				statement.close();
			}catch(Exception ex){
			}
		}
		response.sendRedirect("worktaskListEdit.jsp?wtid="+wtid);
		return;
	}





%>