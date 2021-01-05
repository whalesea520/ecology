<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.List"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="weaver.fna.maintenance.FnaFccDimensionHelp"%>
<%@page import="weaver.fna.maintenance.FnaFccDimension"%><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="org.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("BudgetCostCenter:maintenance", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation"));
char flag = Util.getSeparator() ;

String id = Util.getIntValue(request.getParameter("id"))+"";
String supFccId = Util.getIntValue(request.getParameter("supFccId"), 0)+"";
String type = Util.getIntValue(request.getParameter("type"), 0)+"";
String name = Util.null2String(request.getParameter("name"));
String code = Util.null2String(request.getParameter("code"));
String description = Util.null2String(request.getParameter("description"));
String archive = Util.getIntValue(request.getParameter("archive"), 0)+"";

String subId = Util.null2String(request.getParameter("subId"));
String depId = Util.null2String(request.getParameter("depId"));
String hrmId = Util.null2String(request.getParameter("hrmId"));
String crmId = Util.null2String(request.getParameter("crmId"));
String prjId = Util.null2String(request.getParameter("prjId"));

//科目封存
String sql = "";
String checkid=Util.null2String(request.getParameter("checkid"));
//科目级别
String subjectLevel = Util.null2String(request.getParameter("subjectLevel"));
//科目名称
String subjectName = Util.null2String(request.getParameter("subjectName"));
//上级科目
String parent = Util.null2String(request.getParameter("parent"));
//展开层
int level = new Integer(Util.null2o(request.getParameter("level"))).intValue();
//页
int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);

if("0".equals(type)){
	subId="";
	depId="";
	hrmId="";
	crmId="";
	prjId="";
}

String para = "" ;

if(operation.equals("add")){
	if(!"".equals(code)){
		rs.executeSql("select count(*) cnt from FnaCostCenter where code = '"+StringEscapeUtils.escapeSql(code)+"'");
		if(rs.next() && rs.getInt("cnt") > 0){
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("1321,18082",user.getLanguage()))+"}");
			out.flush();
			return;
		}
	}

	rs.executeSql("insert into FnaCostCenter (supFccId, type, name, code, archive, description) "+
		" values ("+supFccId+", "+type+", '"+StringEscapeUtils.escapeSql(name)+"', '"+StringEscapeUtils.escapeSql(code)+"', "+archive+", '"+StringEscapeUtils.escapeSql(description)+"') ");
	
	rs.executeSql("select max(id) maxId from FnaCostCenter where name = '"+StringEscapeUtils.escapeSql(name)+"'");
	if(rs.next()){
		id = rs.getInt("maxId")+"";
		FnaFccDimensionHelp fnaFccDimensionHelp = new FnaFccDimensionHelp();
		List<FnaFccDimension> fnaFccDimension_list = fnaFccDimensionHelp.queryAllFnaFccDimension();
		int fnaFccDimension_list_len = fnaFccDimension_list.size();
		for(int i=0;i<fnaFccDimension_list_len;i++){
			FnaFccDimension fccDimension = fnaFccDimension_list.get(i);
			String browserName = "fnaFccDimension_"+fccDimension.getId();
			String fnaFccDimension_ids = Util.null2String(request.getParameter(browserName));
			fccDimension.setFccSelectedIds(fnaFccDimension_ids);
		}
		FnaCostCenter.saveFnaCostCenterDtl(Util.getIntValue(id), subId, depId, hrmId, crmId, prjId, fnaFccDimension_list);
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
	out.flush();
	return;
	
}else if(operation.equals("edit")){
	if(!"".equals(code)){
		rs.executeSql("select count(*) cnt from FnaCostCenter where code = '"+StringEscapeUtils.escapeSql(code)+"' and id <> "+id);
		if(rs.next() && rs.getInt("cnt") > 0){
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelNames("1321,18082",user.getLanguage()))+"}");
			out.flush();
			return;
		}
	}

	rs.executeSql("update FnaCostCenter "+
		" set type="+type+", "+
		" supFccId = "+supFccId+", "+
		" name = '"+StringEscapeUtils.escapeSql(name)+"', "+
		" code = '"+StringEscapeUtils.escapeSql(code)+"', "+
		" archive = "+archive+", "+
		" description = '"+StringEscapeUtils.escapeSql(description)+"' "+
		" where id = " + id);

	FnaFccDimensionHelp fnaFccDimensionHelp = new FnaFccDimensionHelp();
	List<FnaFccDimension> fnaFccDimension_list = fnaFccDimensionHelp.queryAllFnaFccDimension();
	int fnaFccDimension_list_len = fnaFccDimension_list.size();
	for(int i=0;i<fnaFccDimension_list_len;i++){
		FnaFccDimension fccDimension = fnaFccDimension_list.get(i);
		String browserName = "fnaFccDimension_"+fccDimension.getId();
		String fnaFccDimension_ids = Util.null2String(request.getParameter(browserName));
		new BaseBean().writeLog("fnaFccDimension_ids", browserName+"="+fnaFccDimension_ids+";");
		fccDimension.setFccSelectedIds(fnaFccDimension_ids);
	}
	FnaCostCenter.saveFnaCostCenterDtl(Util.getIntValue(id), subId, depId, hrmId, crmId, prjId, fnaFccDimension_list);
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
	out.flush();
	return;
}else if(operation.equals("delete") || operation.equals("batchDel")){

	String batchDelIds = Util.null2String(request.getParameter("batchDelIds"));
	if(operation.equals("delete")){
		batchDelIds = id;
	}
	String[] batchDelIdsArray = batchDelIds.split(",");
	
	FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
	
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
		if(_delId > 0){
			List resultList = fnaSplitPageTransmethod.getCostCenterViewInner_popedom(_delId+"", "1");
			boolean allowDel = "true".equals((String)resultList.get(3));
			if(allowDel){
				rs.executeSql("delete from FnaCostCenterDtl where fccId = "+_delId);
				rs.executeSql("delete from FnaCostCenter where id = "+_delId);
				rs.executeSql("select id from FnaBudgetInfo b "+
						" where status = 0 and b.organizationtype = "+FnaCostCenter.ORGANIZATION_TYPE+" and b.budgetorganizationid = "+_delId);
				while(rs.next()){
					int _fnaBudgetInfoId = rs.getInt("id");
					rs2.executeSql("delete from FnaBudgetInfoDetail where budgetinfoid = "+_fnaBudgetInfoId);
					rs2.executeSql("delete from FnaBudgetInfo where id = "+_fnaBudgetInfoId);
				}
			}else{
				out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(81533,user.getLanguage()))+"}");//成本中心正在被使用不能删除
				out.flush();
				return;
			}
		}
	}
	out.println("{\"flag\":true}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("archive")){
	checkid +=-1;
	sql = "update FnaCostCenter set archive = 1 where id in ("+checkid+")";
	RecordSet.executeSql(sql);

	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
}else if(operation.equals("lifted")){
	checkid +=-1;
	sql = "update FnaCostCenter set archive = 0 where id in ("+checkid+")";
	RecordSet.executeSql(sql);	

	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
}
%>
