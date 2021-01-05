
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String method=Util.null2String(request.getParameter("method"), "");	
	String hpid=Util.null2String(request.getParameter("hpid"), "");	
	
	if ("getFormFilterId".equals(method)) {
		// 根据hpid获取布局中的元素
		String layoutSql = "select areaElements from hpLayout where hpid = " + hpid;
		rs.execute(layoutSql);
		
		String areaElements = "";
		while (rs.next()) {
			if (!"".equals(rs.getString("areaElements"))) {
				areaElements += rs.getString("areaElements");
			}
		}
		
		String expids = "";
		if (!"".equals(areaElements)) {
			rs.execute("select expids from sypara_expressions where wfexid in (select distinct wfexid from sywfexinfo where sourceid in (select id  from hpsetting_wfcenter  where eid in (" + areaElements.substring(0, areaElements.length()-1) + ")))"); 
			while (rs.next()) {
				if (!"".equals(rs.getString("expids"))) {
					expids += rs.getString("expids") + ",";
				}
			}
		}
		
		// 获取参数配置中关联的表单字段
		String filters = "";
		if (!"".equals(expids)) {
			String sql = "select distinct filtername from sypara_variablebase where id in (select expbaseid from sypara_expressions where id in (" + expids.substring(0, expids.length()-1) + "))"; 
			rs.execute(sql);
			while (rs.next()) {
				if (!"".equals(rs.getString("filtername"))) {
					filters += "field" + rs.getString("filtername") + ",";
				}
			}
		}
		
		if (!"".equals(filters)) {
			filters = filters.substring(0, filters.length()-1);
		}
		
		out.print(filters);
	    return;
	}
	
	if ("delHpInfo".equals(method)) {
		// 根据基本信息
		String delInfoSql = "delete from hpinfo_workflow where hpid = " + hpid;
		rs.execute(delInfoSql);
		
		// 删除布局
		String delLayoutSql = "delete from hpLayout where hpid = " + hpid;
		rs.execute(delLayoutSql);
		
		out.print(1);
	    return;
	}
%>