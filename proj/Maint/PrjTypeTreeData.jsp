<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="cptgroup" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	out.print("[]");
}
int userid=user.getUID();

String urlType=Util.null2String(request.getParameter("urlType"));
//System.out.println("urltype:"+urlType);


JSONArray arr=new JSONArray();
JSONObject obj=new JSONObject();

TreeMap<String,JSONObject> map=new  TreeMap<String,JSONObject>();

cptgroup.setTofirstRow();
    int dspindex=0;
while(cptgroup.next()){
	obj=new JSONObject();
	String id=cptgroup.getProjectTypeid();
	int tmpcnt=1;
	JSONObject attr=new JSONObject();
	attr.put("groupid", id);
	
	JSONObject numbers=new JSONObject();
	
	if("templateList".equalsIgnoreCase(urlType)){//项目模板列表
		numbers.put("data2count", cptgroup.getTemplateCount(id));
	}else if("MyProject".equalsIgnoreCase(urlType)){//项目执行
		String sqlWhere=" and t1.status not in (0,3,4,6,7)";//正常的项目(包括正常,自定义,延期的状态)
		sqlWhere+=" and dbo.getPrjFinish(t1.id)<100 and ( "+CommonShareManager.getPrjShareWhereByUser(user)+" ) ";
		sqlWhere+=" and ( t1.manager='"+user.getUID()+"' or ','+t1.members+',' like '%,"+user.getUID()+",%' ) ";
		sqlWhere=SQLUtil.filteSql(RecordSet.getDBType(), sqlWhere);
		tmpcnt=Util.getIntValue(cptgroup.getMyProjectCount(id,sqlWhere),0);
		numbers.put("data2count",tmpcnt );
	}else if("MyManagerProject".equalsIgnoreCase(urlType)){//我的项目
		String sqlWhere=" and t1.manager='"+userid+"' and ( "+CommonShareManager.getPrjShareWhereByUser(user)+" ) ";
		tmpcnt=Util.getIntValue(cptgroup.getMyProjectCount(id,sqlWhere),0);
		numbers.put("data2count", tmpcnt);
	}else if("prj_search".equalsIgnoreCase(urlType) ){//查询项目
		String sqlWhere=" and  ( "+CommonShareManager.getPrjShareWhereByUser(user) +" ) ";
		tmpcnt=Util.getIntValue(cptgroup.getMyProjectCount(id,sqlWhere),0);
		numbers.put("data2count", tmpcnt);
	}else if("batchshare".equalsIgnoreCase(urlType) ){//批量共享项目
		String sqlWhere=" and  ( "+CommonShareManager.getPrjShareWhereByUserCanEdit(user) +" ) ";
		tmpcnt=Util.getIntValue(cptgroup.getMyProjectCount(id,sqlWhere),0);
		numbers.put("data2count", tmpcnt);
	}else if("ProjectMonitor".equalsIgnoreCase(urlType)){//项目监控
		tmpcnt=Util.getIntValue(cptgroup.getMyProjectCount(id,""),0);
		numbers.put("data2count", tmpcnt);
	}else{
		numbers.put("data2count", "0");
	}
	
	if(tmpcnt>0){
		obj.put("id",id);
		obj.put("name", cptgroup.getProjectTypename());
		obj.put("pid", "0");
		obj.put("attr", attr);
		obj.put("numbers", numbers);
		obj.put("submenus", new JSONArray());
		obj.put("hasChildren", false);
		
		map.put(dspindex+"_"+id, obj);
	}
    dspindex++;
}

Iterator it=map.entrySet().iterator();
while(it.hasNext()){
	Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
	String k= entry.getKey();
	JSONObject v= entry.getValue();
	int pid=Util.getIntValue( v.getString("pid"),0);
	JSONObject p=map.get(""+pid);
	if(pid>0){
		if(p!=null){
			((JSONArray)p.get("submenus")).add(v);
		}
	}else{
		arr.add(v);
	}
	
	
	if(p!=null){//计数
		JSONObject pObj= ((JSONObject)p.get("numbers"));
		JSONObject sObj= ((JSONObject)v.get("numbers"));
		int cnt= Util.getIntValue((String)sObj.get("data2count"),0)+Util.getIntValue((String)pObj.get("data2count"),0);
		pObj.put("data2count", ""+cnt);
	}
	
}

out.print(arr.toString());
%>


