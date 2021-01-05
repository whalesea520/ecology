<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String operation = Util.fromScreen3(request.getParameter("operation"),user.getLanguage());
	String orgId = Util.fromScreen3(request.getParameter("orgId"),user.getLanguage());
	String type = Util.fromScreen3(request.getParameter("type"),user.getLanguage());
	String hrmIds = Util.fromScreen3(request.getParameter("hrmIds"),user.getLanguage());
	
	//新增
	if(operation.equals("save")){
		//查询原人员ID
		List oldIdList = new ArrayList();
		RecordSet.executeSql("select hrmId from GM_RightSetting where orgId="+orgId+" and type="+type);
		while(RecordSet.next()){
			oldIdList.add(RecordSet.getString(1));
		}
		
		List hrmIdList = Util.TokenizerString(hrmIds,",");
		for (int i = 0; i < hrmIdList.size(); i++) {
			String hrmId = (String)hrmIdList.get(i);
			//如果不包含在原人员id中
			if(!oldIdList.contains(hrmId)){
				String sql = "insert into GM_RightSetting (orgId,type,hrmId) values ("+orgId+","+type+","+hrmId+")";
				RecordSet.executeSql(sql);
			}
		}
	}
	
	//删除
	if(operation.equals("delete")){
		String rownumber = Util.fromScreen3(request.getParameter("num"), user.getLanguage());
		int rownum = 0;
		if(rownumber != null && !"".equals(rownumber)){
			rownum = Integer.parseInt(rownumber);
		}
		String ids = "";
		for(int i=1;i<rownum;i++){
	    	String check = Util.fromScreen3(request.getParameter("check_node_"+i), user.getLanguage());
	    	if(check.equals("on")){
	    		ids += "," + Util.fromScreen3(request.getParameter("hrmId_"+i), user.getLanguage());
	    	}
		}
		if(!ids.equals("")){
			ids = ids.substring(1);
			String sql = "delete from GM_RightSetting where orgId="+orgId+" and type="+type+" and hrmId in ("+ids+")";
			RecordSet.executeSql(sql);
		}
	}
	response.sendRedirect("RightSetting.jsp?orgId="+orgId+"&type="+type);
%>
