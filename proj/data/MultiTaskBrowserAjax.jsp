<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.proj.Maint.ProjectInfoComInfo"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.general.SplitPageUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
int userid=user.getUID();

String src = Util.null2String(request.getParameter("src"));

String check_per = Util.null2String(request.getParameter("systemIds"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
if(check_per.trim().startsWith(",")){
	check_per = check_per.substring(1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;

String sqlWhere = " where tt1.prjid=t1.id and tt1.isdelete =0   ";
String SqlWhere ="  ";

JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件

	if (!check_per.equals("")) {
		if(check_per.indexOf(",")==0){
			check_per=check_per.substring(1);
		}
		sqlWhere += " and tt1.id in ("+check_per+")";
		//System.out.println(sqlWhere);
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
	SqlWhere+=sqlWhere;
}else{

	String subject = Util.null2String(request.getParameter("subject"));
	String prjid = Util.null2String(request.getParameter("prjid"));
	String begindate = Util.null2String(request.getParameter("begindate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	String resourcenames = "";
	if (!check_per.equals("")) {
		String strtmp = "select id,subject,prjid,begindate,enddate from Prj_TaskProcess  where id in ("+check_per+")";
		RecordSet.executeSql(strtmp);
		Hashtable ht = new Hashtable();
		while (RecordSet.next()) {
			ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("subject")));
		}
		try{
			StringTokenizer st = new StringTokenizer(check_per,",");

			while(st.hasMoreTokens()){
				String s = st.nextToken();
				if(ht.containsKey(s)){//如果check_per中的已选的任务此时不存在会出错
					resourceids +=","+s;
					resourcenames += ","+ht.get(s).toString();
				}
			}
		}catch(Exception e){
			resourceids ="";
			resourcenames ="";
		}
	}
	int ishead = 0;
	if(!sqlwhere.equals("")) ishead = 1;
	if(!subject.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where  tt1.subject like '%" + Util.fromScreen2(subject,user.getLanguage()) +"%' ";
		}
		else 
			sqlwhere += " and tt1.subject like '%" + Util.fromScreen2(subject,user.getLanguage()) +"%' ";
	}

	if(!prjid.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where tt1.prjid = "+ prjid ;
		}
		else
			sqlwhere += " and tt1.prjid = "+ prjid ;
	}

	if(!begindate.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where tt1.begindate >= '"+ begindate+"'" ;
		}
		else
			sqlwhere += " and tt1.begindate >= '"+ begindate+"'" ;
	}

	if(!enddate.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where tt1.enddate <= '"+ enddate+"'" ;
		}
		else
			sqlwhere += " and tt1.enddate <= '"+ enddate+"'" ;
	}

	if(!hrmid.equals("")){
		if(ishead==0){
			ishead = 1;
			if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
				sqlwhere += " where ','||tt1.hrmid||',' like '%,"+ hrmid+",%'" ;
			}else{
				sqlwhere += " where ','+tt1.hrmid+',' like '%,"+ hrmid+",%'" ;
			}
		}
		else{
			if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
				sqlwhere += " and ','||tt1.hrmid||',' like '%,"+ hrmid+",%'" ;
			}else{
				sqlwhere += " and ','+tt1.hrmid+',' like '%,"+ hrmid+",%'" ;
			}
		}
	}
	
	
	
	if(!sqlwhere.equals("")){
		SqlWhere = sqlwhere+ " and tt1.prjid=t1.id and tt1.isdelete =0 and ( "+CommonShareManager.getPrjTskShareWhereByUser(user, "tt1")+" ) ";
	}else{
		SqlWhere = " tt1.prjid=t1.id and tt1.isdelete =0 and ( "+CommonShareManager.getPrjTskShareWhereByUser(user, "tt1")+" ) ";
	}
	
	if (check_per.equals("")) {
		check_per = Util.null2String(request.getParameter("excludeId"));
	}
	if (!check_per.equals("")) {
		if(check_per.indexOf(',')==0){
			check_per=check_per.substring(1);
		}
		//SqlWhere += " and tt1.id not in ("+check_per+")";
	}
	
}


SplitPageParaBean spp = new SplitPageParaBean();

spp.setBackFields(" tt1.id, tt1.subject, tt1.prjid,tt1.hrmid,tt1.begindate,tt1.enddate ");
spp.setSqlFrom(" Prj_TaskProcess tt1,Prj_ProjectInfo t1 ");
spp.setSqlWhere(SqlWhere+ " and tt1.level_n <10 ");
spp.setSqlOrderBy("tt1.subject");
spp.setPrimaryKey("tt1.id");
spp.setDistinct(true);
spp.setSortWay(spp.ASC);
SplitPageUtil spu = new SplitPageUtil();
spu.setSpp(spp);

JSONArray jsonArr = new JSONArray();

int totalPage=1;
/**
int RecordSetCounts = spu.getRecordCount();
totalPage = RecordSetCounts/perpage;

if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}
**/
String id=null;
String prjsubject=null;
String prjprjid=null;
String prjhrmid=null;
String prjbegindate=null;
String prjenddate=null;

int i=0;
RecordSet rs = spu.getCurrentPageRs(pagenum, perpage);


while(rs.next()) {
	id = rs.getString("id");
	prjsubject = Util.null2String(rs.getString("subject"));//任务名称
	prjprjid=ProjectInfoComInfo.getProjectInfoname ( Util.null2String(rs.getString("prjid")));//所属项目id
	prjhrmid=ResourceComInfo.getMulResourcename( Util.null2String(rs.getString("hrmid")));//负责人
	prjbegindate=Util.null2String(rs.getString("begindate"));
	prjenddate=Util.null2String(rs.getString("enddate"));
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("subject",prjsubject);	
	tmp.put("prjid",prjprjid);
	tmp.put("hrmid",prjhrmid);	
	tmp.put("begindate",prjbegindate);	
	tmp.put("enddate",prjenddate);	
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
//System.out.println(json.toString());
%>