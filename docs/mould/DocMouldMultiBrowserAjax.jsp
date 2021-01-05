<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String documentids = Util.null2String(request.getParameter("systemIds"));
String mouldType = Util.null2String(request.getParameter("mouldType"));
String tablename = "DocMould";
if(mouldType.equals("3"))tablename = "DocMouldFile";
if(documentids.trim().startsWith(",")){
	documentids = documentids.substring(1);
}
if(src.equalsIgnoreCase("dest")){
	JSONArray jsonArr = new JSONArray();
	JSONArray jsonArr_tmp = new JSONArray();
	JSONObject json = new JSONObject();
	if (!documentids.equals("")) {
		String strtmp = "select id,mouldname from "+tablename+" where id in ("+documentids+")";
		recordSet.executeSql(strtmp);
		while(recordSet.next()){
				JSONObject tmp = new JSONObject();
				tmp.put("id",recordSet.getString("id"));
				tmp.put("mouldname",recordSet.getString("mouldname"));
				jsonArr_tmp.add(tmp);
		}
		String[] documentidArr = Util.TokenizerString2(documentids,",");
		for(int i=0;i<documentidArr.length;i++){
			for(int j=0;j<jsonArr_tmp.size();j++){
				JSONObject tmp = (JSONObject)jsonArr_tmp.get(j);
				if(tmp.get("id").equals(documentidArr[i])){
					jsonArr.add(tmp);
				}
			}
		}
	}
	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}



String mainCategoryName = Util.null2String(request.getParameter("mouldname"));

String sqlwhere = "where mouldType in (2,4) ";
if(mouldType.equals("3")){
	sqlwhere += " and ID NOT IN (Select TEMPLETDOCID From HrmContractTemplet) ";
}
int ishead = 1;

boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();

String subcompanyids = "";
if(isUseDocManageDetach){
	subcompanyids = SubCompanyComInfo.getRightSubCompany(user.getUID(),"DocMouldAdd:Add",-1);

}


if(!"".equals(mainCategoryName)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where mouldname like '%";
		sqlwhere += Util.fromScreen2(mainCategoryName,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and mouldname like '%";
		sqlwhere += Util.fromScreen2(mainCategoryName,user.getLanguage());
		sqlwhere += "%'";
	}
}

if(!"".equals(subcompanyids)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  subcompanyid in (";
		sqlwhere += subcompanyids;
		sqlwhere += ")";
	}
	else{
		sqlwhere += " and subcompanyid in(";
		sqlwhere += subcompanyids;
		sqlwhere += ")";
	}
}


int i=0;

int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
if(documentids.equals("")){
	documentids = Util.null2String(request.getParameter("excludeId"));
}
if(!documentids.equals("")){
	sqlwhere += " and id not in ("+documentids+")";
}

String sqlwhere2 = "select * from "+tablename+" "+sqlwhere;

//System.out.println("sql = "+sqlwhere);
//System.out.println("sqlWhere1 = "+sqlwhere1);
recordSet.execute(sqlwhere2);
int RecordSetCounts = recordSet.getCounts();
int totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}

RecordSet rs = MouldManager.getSelectResult(sqlwhere,pagenum,perpage,tablename);
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();

while(rs.next()){
	JSONObject tmp = new JSONObject();
	tmp.put("id",rs.getString("id"));
	tmp.put("mouldname",rs.getString("mouldName"));
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>
