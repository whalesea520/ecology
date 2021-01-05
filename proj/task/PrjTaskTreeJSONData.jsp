<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(user==null){
	out.print("[]");
}else{
	JSONArray arr=new JSONArray();
	JSONObject obj=new JSONObject();
	TreeMap<Integer,JSONObject> map=new  TreeMap<Integer,JSONObject>();
	
	
	String src=Util.null2String(request.getParameter("src"));//来源 template:取模板任务;project:取项目任务
	boolean loadAll=1==Util.getIntValue(request.getParameter("loadAll"),0);//加载全部
	boolean preview=1==Util.getIntValue(request.getParameter("preview"),0);//预览
	boolean openlazy=!loadAll;
	String templateId=Util.null2String(request.getParameter("templateId"));
	String ProjID=Util.null2String(request.getParameter("ProjID"));
	String parentId=Util.null2String(request.getParameter("parentId"));
	String sql="";
	//System.out.println("src:"+src);
	//System.out.println("templateId:"+templateId);

	if("template".equalsIgnoreCase(src)&&!"".equals(templateId)){//取模板里的任务
		if(loadAll){
			sql=" select t1.templettaskid,t1.taskname,t1.parenttaskid,t1.taskmanager,t1.befTaskId,t1.budget,t1.id as realid,t2.taskname as beftaskname,t1.* from Prj_TemplateTask t1 left outer join Prj_TemplateTask t2 on t2.templettaskid=t1.beftaskid and t2.templetid=t1.templetid where t1.templetid='"+templateId+"' order by t1.taskindex,t1.parenttaskid,t1.templettaskid ";
		}else{
			sql=" select t1.templettaskid,t1.taskname,t1.parenttaskid,t1.taskmanager,t1.befTaskId,t1.budget,t1.id as realid,t2.taskname as beftaskname,t1.* from Prj_TemplateTask t1 left outer join Prj_TemplateTask t2 on t2.templettaskid=t1.beftaskid and t2.templetid=t1.templetid where t1.templetid='"+templateId+"' and "+(!"".equals(parentId)?" t1.parenttaskid='"+Util.getIntValue(parentId,0)+"' ":" 1=2 ")+"' order by t1.taskindex,t1.parenttaskid,t1.templettaskid ";
		}
	}else if("project".equalsIgnoreCase(src)&&!"".equals(ProjID)){//取项目里的任务
		String subsql=" select top 1 t3.taskindex from Prj_TaskProcess t3 where t3.id=t1.parentid and t3.prjid=t1.prjid ";
		if("oracle".equalsIgnoreCase(rs.getDBType())){
			subsql=" select  t3.taskindex from Prj_TaskProcess t3 where rownum=1 and t3.id=t1.parentid and t3.prjid=t1.prjid  ";
		}
		if(loadAll){
			sql=" select t1.id, t1.subject,t1.parentid,t1.hrmid,t1.prefinish,t1.fixedcost,t1.id as realid,t2.subject as beftaskname,t1.*,("+subsql+") as pindex from Prj_TaskProcess t1 left outer join Prj_TaskProcess t2 on t2.taskindex=t1.prefinish and t2.prjid=t1.prjid  where t1.prjid='"+ProjID+"' order by t1.taskindex ";
		}else{
			sql=" select t1.id,t1.subject,t1.parentid,t1.hrmid,t1.prefinish,t1.fixedcost,t1.id as realid,t2.subject as beftaskname,t1.*,("+subsql+") as pindex from Prj_TaskProcess t1 left outer join Prj_TaskProcess t2 on t2.taskindex=t1.prefinish and t2.prjid=t1.prjid  where t1.prjid='"+ProjID+"' and "+(!"".equals(parentId)?" t1.parentid='"+Util.getIntValue(parentId,0)+"' ":" 1=2 ")+"' order by t1.taskindex ";
		}
	}
	rs.executeSql(sql);
	while(rs.next()){
		
		String id=Util.null2String( rs.getString(1));
		String name=Util.null2String( rs.getString(2));
		String pid=Util.null2String( rs.getString(3));
		String hrmid=Util.null2String( rs.getString(4));
		String beftaskid=Util.null2String( rs.getString(5));
		String budget=Util.null2String( rs.getString(6));
		String realid=Util.null2String( rs.getString(7));
		String beftaskname=Util.null2String( rs.getString(8));
		String begindate=Util.null2String( rs.getString("begindate"));
		String enddate=Util.null2String( rs.getString("enddate"));
		String begintime=Util.null2String( rs.getString("begintime"));
		String endtime=Util.null2String( rs.getString("endtime"));
		String workday=Util.null2String( rs.getString("workday"));
		
		
		obj=new JSONObject();
		
		obj.put("id",id);
		if(preview&&"template".equalsIgnoreCase(src)){
			obj.put("title","<a  href=\"/proj/Templet/TempletTaskTab.jsp?id="+realid+"\" target=\"_blank\">"+name+"</a>");
		}else{
			obj.put("title",name);
		}
		
		obj.put("pid",pid);
		obj.put("hrmid",hrmid);
		String approvename="";
		 if(!"".equals(hrmid)){
	        	String[] approves = hrmid.split(",");
	        	for(int j=0;j<approves.length;j++){
	        		approvename += ResourceComInfo.getResourcename(approves[j])+"&nbsp;";
	        	}
	        }
		obj.put("hrmname",approvename);
		obj.put("beftaskid",beftaskid);
		obj.put("begindate",begindate);
		obj.put("begintime",begintime);
		obj.put("enddate",enddate);
		obj.put("endtime",endtime);
		obj.put("workday",workday);
		obj.put("budget",budget);
		obj.put("realid",realid);
		obj.put("beftaskname",beftaskname);
		
		obj.put("children",new JSONArray());
		
		
		obj.put("lazy", openlazy);
		
		if("project".equalsIgnoreCase(src)){
			String pindex=""+Util.getIntValue(rs.getString("pindex"),0);
			obj.put("pindex", pindex);
			map.put(Integer.parseInt( rs.getString("taskindex")),obj);
		}else{
			map.put(Integer.parseInt(id),obj);
		}
	}
	
	
	Iterator it=map.entrySet().iterator();
	while(it.hasNext()){
		Entry<Integer,JSONObject> entry=(Entry<Integer,JSONObject>)it.next();
		Integer k= entry.getKey();
		JSONObject v= entry.getValue();
		int pid=0;
		if("project".equalsIgnoreCase(src)){
			pid=Util.getIntValue( v.getString("pindex"),0);
		}else{
			pid=Util.getIntValue( v.getString("pid"),0);
		}
		
		
		JSONObject p=map.get(Integer.parseInt(""+pid));
		if(pid>0){
			if(p!=null){
				((JSONArray)p.get("children")).put(v);
			}
		}else{
			arr.put(v);
		}
		
	}

	out.print(arr.toString());
}

%>


