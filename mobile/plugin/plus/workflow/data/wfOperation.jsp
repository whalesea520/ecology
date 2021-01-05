<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestInfo"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ws" class="weaver.mobile.webservices.workflow.WorkflowServiceImpl" scope="page" />
<%
out.clearBuffer();

request.setCharacterEncoding("UTF-8");
response.setContentType("application/json;charset=UTF-8");
String operation = Util.null2String(request.getParameter("operation"));
JSONObject json = new JSONObject();
String msg = "";int status = 1;
BaseBean bb = new BaseBean();
if(operation.equals("getDataList")){
	try{
		int pageSize = Util.getIntValue(request.getParameter("pagesize"),10);
		int pageIndex = Util.getIntValue(request.getParameter("pageindex"),1);
		String requestname = Util.null2String(request.getParameter("requestname"));//标题
		String workcode = Util.null2String(request.getParameter("workcode"));//编号
		int createid = Util.getIntValue(Util.null2String(request.getParameter("createid")), 0);//创建人
		String createdatestart = Util.null2String(request.getParameter("createdatestart"));//创建开始日期
		String createdateend = Util.null2String(request.getParameter("createdateend"));//创建结束日期
		String receivedatestart = Util.null2String(request.getParameter("receivedatestart"));//接收开始日期
		String receivedateend = Util.null2String(request.getParameter("receivedateend"));//接收结束日期
		String setting = Util.null2String(request.getParameter("setting"));//模块设置中选择的流程类型
		String workflowid = Util.null2String(request.getParameter("workflowid"));//查询页面中选择的流程类型
		int showcopy = Util.getIntValue(request.getParameter("showcopy"),0);//查询待办时是否显示抄送
		int archivestatus = Util.getIntValue(request.getParameter("archivestatus"),1);//流程归档状态：1：全部， 2：未归档， 3：已归档
		int ifFirst = Util.getIntValue(request.getParameter("ifFirst"),0);//是否首次加载
		//查询类型 -1019查询所有流程 -11000待办 -11001 已办 -11002 我的请求
		int module = Util.getIntValue(request.getParameter("module"),0);
		String modules = Util.null2String(request.getParameter("modules"));// 1,2,3,4,5 待办 抄送 已办 办结 我的请求
		int settingType = Util.getIntValue(request.getParameter("settingType"),1);//1 包含 0排除
		List conditions = new ArrayList();
		boolean ifNewTable = false;
		if(module==-11000||module==-11001||(!modules.equals("")&&module==-1019)){
			if(rs.getDBType().equals("oracle")){
				rs.execute("select 1 from user_tab_cols where table_name='WORKFLOW_CURRENTOPERATOR' and column_name='TAKISREMARK'");
			}else{
				rs.execute("select 1 from syscolumns where name='takisremark' and id=object_id('workflow_currentoperator')");
			}
			if(rs.next()){
				ifNewTable = true;
			}
		}
		boolean ifNewRequestName = false;
		if(rs.getDBType().equals("oracle")){
			rs.execute("select 1 from user_tab_cols where table_name='WORKFLOW_REQUESTBASE' and column_name='REQUESTNAMENEW'");
		}else{
			rs.execute("select 1 from syscolumns where name='requestname' and id=object_id('workflow_requestbase')");
		}
		if(rs.next()){
			ifNewRequestName = true;
		}
		if(!modules.equals("")&&module==-1019&&!modules.equals("1,2,3,4,5")){
			String sql = "";
			if(modules.contains("1")){//包含待办
				if(ifNewTable){
		        	sql = "((t2.isremark='0' and (t2.takisremark is null or t2.takisremark='0' )) or t2.isremark in ('1','5','7')) ";
		        }else{
		        	sql = "t2.isremark in ('0','1','5','7') ";
		        }
			}
			if(modules.contains("2")){//包含抄送
		        sql += "or t2.isremark in ('8','9') ";
			}
			if(modules.contains("3")){//包含已办
				if(ifNewTable){
					sql += "or ((t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark ='-2')) and t2.iscomplete=0) ";
				}else{
					sql += "or (t2.isremark in('2','4') and t2.iscomplete=0) ";
				}
			}
			if(modules.contains("4")){//包含办结
				//sql += "or (t2.isremark in ('2','4') and t1.currentnodetype = '3' and t2.iscomplete=1) ";
				sql += "or (t2.isremark in ('2','4') and t2.iscomplete=1) ";
			}
			if(modules.contains("5")){//包含我的请求
				sql += "or ((t2.isremark is not null or t2.isremark !='') and t1.creater = " + 
						user.getUID() + " and t1.creatertype = 0) ";
			}
			if(sql.startsWith("or")){
				sql = sql.substring(2);
			}
			if(!sql.equals("")){
				sql = " ("+sql+")";
			}
			conditions.add(sql);
		}else{
			if(module==-11000){//查询待办
				String remark = "'1','5','7'";
		        if (showcopy==1) {
		            remark += ",'8','9'";
		        }
		        if(ifNewTable){
		        	conditions.add(" ((t2.isremark='0' and (t2.takisremark is null or t2.takisremark='0' )) or t2.isremark in(" + remark + "))");
		        }else{
		        	conditions.add(" t2.isremark in ('0',"+remark+")");
		        }
			}else if(module==-11001){//查询已办包含办结
				if(ifNewTable){
					conditions.add(" (t2.isremark in('2','4') or (t2.isremark=0 and t2.takisremark ='-2'))");
				}else{
					conditions.add(" t2.isremark in('2','4')");
				}
			}else if(module==-11002){//我的请求
				conditions.add(" (t2.isremark is not null or t2.isremark !='') and t1.creater = " + 
						user.getUID() + " and t1.creatertype = 0 ");
			}
		}
		
		if(archivestatus!=1){
			if(archivestatus==2){//未归档
				conditions.add(" t2.iscomplete = 0 ");
			}else if(archivestatus==3){//已归档
				conditions.add(" t2.iscomplete = 1 ");
			}
		}
		if(!requestname.equals("")) {//标题
			if(ifNewRequestName){
				conditions.add(" t1.requestnamenew like '%" + requestname + "%'");
			}else{
				conditions.add(" t1.requestname like '%" + requestname + "%'");
			}
		}
		if (!"".equals(workcode)){//编号
			conditions.add(" t1.requestmark like '%"+workcode+"%' ");
		}
		if (createid > 0) {//创建人
		    conditions.add(" t1.creater=" + createid );
		}
		if (!"".equals(createdatestart)) {//创建起始日期
		    conditions.add(" t1.createdate>='" + createdatestart + "' ");
		}
		if (!"".equals(createdateend)) {//创建结束日期
		    conditions.add(" t1.createdate<='" + createdateend + "' ");
		}
		if (!"".equals(receivedatestart)) {//接收起始日期
		    conditions.add(" t2.receivedate>='" + receivedatestart + "' ");
		}
		if (!"".equals(receivedateend)) {//接收结束日期
		    conditions.add(" t2.receivedate<='" + receivedateend + "' ");
		}
		if (!"".equals(setting)) {//模块设置中选择的流程类型
			String settings = "";
			try{			
				Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
				Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
				settings = (String)m.invoke(WorkflowVersion, setting);
			}catch (Exception e){
				settings = setting;
			}
			if(!"".equals(settings)){
				if(settingType==1){
					conditions.add(" t1.workflowid in (" + settings + ")");
				}else{
					conditions.add(" t1.workflowid not in (" + settings + ")");
				}
			}
		}
		if (!"".equals(workflowid)) {//查询页面选择的流程类型
			String workflowids = "";
			try{			
				Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
				Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
				workflowids = (String)m.invoke(WorkflowVersion, workflowid);
			}catch (Exception e){
				workflowids = workflowid;
			}
			if(!"".equals(workflowids)){
				conditions.add(" t1.workflowid in (" + workflowids + ")");
			}
		}
		int ifFdSSo = Util.getIntValue(Prop.getPropValue("fdcsdev","ifFdSSo"),0);
		if(ifFdSSo==1){//是复地客户 增加异构系统查询条件
			String sysid = Util.null2String(request.getParameter("sysid"));//异构系统ID
			if(!sysid.equals("")){
				conditions.add(" sysid in ("+sysid+")");
			}
		}
		conditions.add("");
		String[] strconditions = new String[conditions.size()];
		conditions.toArray(strconditions);
		//String where = "";
		//for (int m=0;m<strconditions.length;m++) {
		//	String condition = strconditions[m];
		//	where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
		//}
		//System.out.println(where);
		int count = ws.getAllWorkflowRequestCount(user.getUID(), strconditions);
		if(ifFdSSo==1){//是复地客户 增加排序条件设置
			String orderby = Util.null2String(request.getParameter("orderby"));//排序
			if(orderby.equals("")){
				orderby = "desc";
			}
			strconditions[strconditions.length-1] = " order by t2.receivedate "+orderby+",t2.receivetime "+orderby+",t1.requestid "+orderby;
		}
		WorkflowRequestInfo[] wris = ws.getAllWorkflowRequestList(pageIndex, pageSize, count, user.getUID(), strconditions);
		int pageCount = 0;
		int isHavePre = 0;
		int isHaveNext = 0;
		JSONArray list = new JSONArray();
		if (count <= 0) pageCount = 0;
		pageCount = count / pageSize + ((count % pageSize > 0)?1:0);
		isHaveNext = (pageIndex + 1 <= pageCount)?1:0;
		isHavePre = (pageIndex - 1 >= 1)?1:0;
		List<WorkflowRequestInfo> datas = Arrays.asList(wris);
		String[] requestids = new String[datas.size()];
		int i=0;
		for(WorkflowRequestInfo wri:datas) {
			requestids[i] = wri.getRequestId();
			i++;
			JSONObject newdata = new JSONObject();
			newdata.put("time", Util.null2String(wri.getReceiveTime()));
			newdata.put("image", Util.null2String(rc.getMessagerUrls(wri.getCreatorId())));
			newdata.put("id", Util.null2String(wri.getRequestId()));
			newdata.put("subject", Util.null2String(wri.getRequestName()).replace("&quot;", "\""));
			String description = "" +
					 "[" +Util.null2String(wri.getWorkflowBaseInfo().getWorkflowName())+ "]" +
					 "   创建人 :  " +Util.null2String(wri.getCreatorName())+
					 "   接收时间 : " +Util.null2String(wri.getReceiveTime())+
					 "   流程状态 : " +Util.null2String(wri.getStatus())+
					 "   创建时间 : " +Util.null2String(wri.getCreateTime());
			description = FormatMultiLang.formatByUserid(description,user.getUID()+"");
			newdata.put("description", description);
			//newdata.put("f_weaver_belongto_userid", Util.null2String(wri.getWorkflowBaseInfo().getF_weaver_belongto_userid()));
			//newdata.put("f_weaver_belongto_usertype", Util.null2String(wri.getWorkflowBaseInfo().getF_weaver_belongto_usertype()));
			//newdata.put("url", Util.null2String(wri.getAppurl()));
			list.add(newdata);
		}
   		if (requestids.length > 0) {
   			String[] newflagarray = ws.getWorkflowNewFlag(requestids, user.getUID()+"");
   			if(newflagarray!=null&&newflagarray.length==requestids.length){
   				for(i=0;i<requestids.length;i++){
   					JSONObject newdata = list.getJSONObject(i);
   					newdata.put("isnew", newflagarray[i]);
   				}
   			}
   		}
   		if(ifFirst==1){
   			String listtypes = getWorkFlowTypes(user.getUID(),strconditions);
   			json.put("listtypes", listtypes);
   			if(ifFdSSo==1){//获取异构系统数据
   				rs.executeSql("select sysid,syscode,sysfullname from ofs_sysinfo order by sysid");
   				JSONArray ja = new JSONArray();
   				while(rs.next()){
   					JSONObject jo = new JSONObject();
   					String sysid = Util.null2String(rs.getString("sysid"));
   					String syscode = Util.null2String(rs.getString("syscode"));
   					String sysfullname = Util.null2String(rs.getString("sysfullname"));
   					jo.put("sysid", sysid);
   					jo.put("syscode", syscode);
   					jo.put("sysfullname", sysfullname);
   					ja.add(jo);
   				}
   				json.put("syslist", ja);
   			}
   		}
		json.put("pageindex", pageIndex);
		json.put("pagesize", pageSize);
		json.put("ishavepre", isHavePre);
		json.put("ishavenext", isHaveNext);
		json.put("count", count);
		json.put("pagecount", pageCount);
		json.put("list", list);
		//获取流程推送设置
		if(ifFdSSo==1){
			int settype = 1;
			rs.executeSql("select settype from FdWFMsgSet where userid = "+user.getUID());
			if(rs.next()){
				settype = Util.getIntValue(rs.getString("settype"));
			}
			json.put("settype", settype);
		}
	}catch(Exception e){
		//e.printStackTrace();
		msg = e.getMessage();
	}
}else if(operation.equals("setWFMsg")){
	int value = Util.getIntValue(request.getParameter("value"));
	rs.executeSql("delete from FdWFMsgSet where userid = "+user.getUID());
	boolean flag = rs.executeSql("insert into FdWFMsgSet (userid,settype) values ("+user.getUID()+","+value+")");
	if(flag){
		status = 0;
	}else{
		msg = "执行保存动作失败:保存数据库出错";
	}
	json.put("status", status);
	json.put("msg", msg);
}
//System.out.println(json.toString());
out.print(json.toString());
%>
<%!
	private String getWorkFlowTypes(int userid,String[] conditions){
		String result = "";
		try{
			String select = " select distinct ";
		    String fields = " t1.workflowid ";
		    String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
		    String where = " where t1.requestid=t2.requestid ";
		    where += " and t2.usertype = 0 and t2.userid = " + userid;
		    where += " and t2.islasttimes=1 ";
		    where += " and t1.workflowID in (select id from workflow_base where isvalid in('1','3')) ";
		    if (conditions != null){
	            for (int m=0;m<conditions.length;m++) {
	                String condition = conditions[m];
	                where += (condition != null && !"".equals(condition)) ? " and " + condition : "";
	            }
		    }
	        String sql = select + fields + from + where;
	        RecordSet rs = new RecordSet();
	        rs.executeSql(sql);
	        while (rs.next()) {
	            result += "," + rs.getString(1);
	        }
	        if (result.length() > 1) {
	            result = result.substring(1);
	        }
		}catch(Exception e){
			
		}
		return result;
	}
%>