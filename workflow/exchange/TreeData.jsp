<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.*,org.apache.commons.lang3.*" %>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="weaver.workflow.exchange.ExchangeUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	out.print("[]");
}
int userid=user.getUID();
String urlType = Util.null2String(request.getParameter("urlType"));
String companyid = Util.null2String(request.getParameter("companyid"));
int subcompanyid = Util.getIntValue(Util.null2String(request.getParameter("subcompanyid")),0);
String departmentid = Util.null2String(request.getParameter("departmentid"));
String detachable = Util.null2String(request.getParameter("detachable"));
String sqlwhere = ""; //空的没用上
int operatelevel = -1  ;
int tempsubcomid = -1 ;
ArrayList ids = new ArrayList();
if(detachable.equals("1")){
	rs.executeSql("select wfdftsubcomid from SystemSet");
	rs.next();
	tempsubcomid = Util.getIntValue(rs.getString(1),0);
	if(request.getParameter("subcompanyid")==null){
		subcompanyid=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),0);
    }
    if(subcompanyid == 0){
    	subcompanyid = user.getUserSubCompany1();
    }
    session.setAttribute("managefield_subCompanyId",String.valueOf(subcompanyid));
    operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR,subcompanyid);
    int[] rightids = CheckSubCompanyRight.getSubComByDecUserRightId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR) ;
	for(int sid :rightids){
		ids.add(sid+"");
	}
}else{
	operatelevel = 2 ;
}

JSONArray arr = new JSONArray();
JSONObject obj = null ;

TreeMap<String,JSONObject> map=new  TreeMap<String,JSONObject>();
ArrayList<String> wfids = new ArrayList<String>();

String wfec_sqlwhere = "";
wfec_sqlwhere += ExchangeUtil.getDetachablesqlwhere(Util.getIntValue(detachable),tempsubcomid+"",StringUtils.join(ids,","),subcompanyid,operatelevel);
wfec_sqlwhere += " and EXISTS (select 1 from workflow_base WHERE isvalid='1' and id=workflowid )" ;
rs.executeSql("select workflowid from wfex_view where 1=1 "+wfec_sqlwhere+" group by workflowid ");
while(rs.next()){
	wfids.add(rs.getString("workflowid"));
}
// id in (select workflowid from wfec_view) 
//select * from workflow_type order by dsporder
String sql = "select id,typename from workflow_type where id in (select workflowtype from workflow_base where id in ("+StringUtils.join(wfids,",")+")"+sqlwhere+") order by dsporder";
rs.executeSql(sql);
while(rs.next()){
	String id = rs.getString("id");
	String typename = rs.getString("typename");
	obj=new JSONObject();
	JSONObject attr=new JSONObject();
	attr.put("typeid", id);
	obj.put("name", typename);
	obj.put("attr", attr);
	obj.put("isOpen",true);
	int rcount = 0 ;
	int wjscount = 0 ;
	int wfscount = 0 ;
	int jscount = 0 ;
	int fscount = 0 ;
	RecordSet.executeSql("select id,workflowname,workflowtype from workflow_base where workflowtype="+id+" and id in ("+StringUtils.join(wfids,",")+")"+sqlwhere);
	rcount = RecordSet.getCounts() ;
	JSONArray wfarray = new JSONArray();
	while(RecordSet.next()){
		JSONObject wfobj = new JSONObject();
		String wfid = RecordSet.getString("id");
		String workflowtype = RecordSet.getString("workflowtype");
		String workflowname = RecordSet.getString("workflowname");
		attr.put("workflowid", wfid);
		attr.put("workflowtype",workflowtype);
		
		wfobj.put("name",workflowname);
		wfobj.put("attr",attr);
		JSONObject numbers=new JSONObject();
		wfscount = getcount(wfid,"1");
		wjscount = getcount(wfid,"0");
		fscount += wfscount ;
		jscount += wjscount ;
		numbers.put("indatacount", ""+wfscount);
		numbers.put("outdatacount", ""+wjscount);
		wfobj.put("numbers",numbers);
		wfarray.add(wfobj);
	}
	obj.put("submenus", wfarray);
	JSONObject pnumbers=new JSONObject();
	pnumbers.put("indatacount", ""+fscount);
	pnumbers.put("outdatacount", ""+jscount);
	obj.put("numbers",pnumbers);
	if(rcount>0){
		obj.put("hasChildren", true);
	}else{
		obj.put("hasChildren", false);
	}
	
	//map.put(id, obj);
	arr.add(obj);
}
out.print(arr.toString());
%>
<%!
public int getcount(String wfid,String type){
	int count = 0 ;
	RecordSet rs = new RecordSet();
	try{
		rs.executeSql("select 1 from wfex_view where workflowid="+wfid+" and type="+type);
		count = rs.getCounts() ;
	}catch(Exception e){
		
	}
	return count ;
}
%>

