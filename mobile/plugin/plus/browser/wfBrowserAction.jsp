<%@ page language="java" contentType="text/html;charset=GBK" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.general.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="weaver.wxinterface.FormatMultiLang"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%
//判断编码
if(WxInterfaceInit.isIsutf8()){
	response.setContentType("application/json;charset=UTF-8");
}
String action = Util.null2String(request.getParameter("action"));
JSONObject json = new JSONObject();
int status = 1;String msg = "";
try{
	BaseBean bb = new BaseBean();
	if("getTreeData".equals(action)){
		RecordSet rs = new RecordSet();
		int type = Util.getIntValue(request.getParameter("type"),1);//1.查询流程类型 2.查询类型下的流程
		String setting = Util.null2String(request.getParameter("setting"));
		String listtypes = Util.null2String(request.getParameter("listtypes"));
		JSONArray js = new JSONArray();
		if(type==1){
			List<Integer> ftypeList = new ArrayList<Integer>();
			if(!"".equals(setting)||!"".equals(listtypes)){//获取模块设置中选择的工作流的所有类型
				String sql = "select workflowtype from workflow_base where 1=1 ";
				if(!"".equals(setting)){
					String settings = "";
					try{			
						Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
						Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
						settings = (String)m.invoke(WorkflowVersion, setting);
					}catch (Exception e){
						settings = setting;
					}
					if(!"".equals(settings)){
						sql+=" and id in ("+settings+")";
					}
				}
				if(!"".equals(listtypes)){
					String listtypess = "";
					try{			
						Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
						Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
						listtypess = (String)m.invoke(WorkflowVersion, listtypes);
					}catch (Exception e){
						listtypess = listtypes;
					}
					if(!"".equals(listtypess)){
						sql+=" and id in ("+listtypess+")";
					}
				}
				rs.executeSql(sql);
				while(rs.next()){
					int workflowtype = Util.getIntValue(rs.getString("workflowtype"),0);
					if(!ftypeList.contains(workflowtype)){
						ftypeList.add(workflowtype);
					}
				}
			}
			rs.executeSql("select id,typename from workflow_type order by dsporder");
			while(rs.next()){
				int id = Util.getIntValue(rs.getString("id"),0);
				if(ftypeList.size()<=0||ftypeList.contains(id)){
					String name = Util.null2String(rs.getString("typename"));
					JSONObject j = new JSONObject();
					j.put("id", id);
			        j.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
			        j.put("hasChild", true);
			        j.put("type", "2");
			        js.add(j);
				}
			}
		}else{
			String pid = Util.null2String(request.getParameter("pid"));
			String sql = "select id,workflowname from workflow_base where (isvalid='1' or isvalid='2') and workflowtype = "+pid;
			if(!"".equals(setting)){
				String settings = "";
				try{			
					Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
					Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
					settings = (String)m.invoke(WorkflowVersion, setting);
				}catch (Exception e){
					settings = setting;
				}
				if(!"".equals(settings)){
					sql+=" and id in ("+settings+")";
				}
			}
			if(!"".equals(listtypes)){
				String listtypess = "";
				try{			
					Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
					Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
					listtypess = (String)m.invoke(WorkflowVersion, listtypes);
				}catch (Exception e){
					listtypess = listtypes;
				}
				if(!"".equals(listtypess)){
					sql+=" and id in ("+listtypess+")";
				}
			}
			sql+=" order by workflowname";
			//System.out.println(sql);
			//bb.writeLog("\n\n\n==============="+sql+"==============\n\n\n");
			rs.executeSql(sql);
			while(rs.next()){
				JSONObject j = new JSONObject();
				j.put("id", rs.getString("id"));	//id
				j.put("name", FormatMultiLang.formatByUserid(rs.getString("workflowname"),user.getUID()+""));//名称
				j.put("hasChild", false);
			    j.put("type", "3");
			    js.add(j);
			}
		}
		json.put("datas", js);
		status = 0;
	}else if("getSelectedDatas".equals(action)){
		String selectedIds = Util.null2String(request.getParameter("selectedIds"));
		JSONArray selectedArr = new JSONArray();
		if(!selectedIds.trim().equals("")){
			RecordSet rs = new RecordSet();
			rs.executeSql("select id,workflowname from workflow_base where id in ("+selectedIds+") order by workflowname");
			while(rs.next()){
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", rs.getString("id"));	//id
				selectedObj.put("name", FormatMultiLang.formatByUserid(rs.getString("workflowname"),user.getUID()+""));//名称
				selectedArr.add(selectedObj);
			}
		}
		json.put("datas", selectedArr);
		status = 0;
	}
}catch(Exception e){
	msg = "操作失败:"+e.getMessage();
}
json.put("status", status);
json.put("msg", msg);
//System.out.println(json.toString());
out.print(json.toString());
%>
<%!

%>