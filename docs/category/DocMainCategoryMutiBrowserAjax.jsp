<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryManager" class="weaver.docs.category.MainCategoryManager" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String documentids = Util.null2String(request.getParameter("systemIds"));
if(documentids.trim().startsWith(",")){
	documentids = documentids.substring(1);
}
if(src.equalsIgnoreCase("dest")){
	JSONArray jsonArr = new JSONArray();
	JSONArray jsonArr_tmp = new JSONArray();
	JSONObject json = new JSONObject();
	if (!documentids.equals("")) {
		String strtmp = "select id,categoryname from DocSecCategory where id in ("+documentids+")";
		recordSet.executeSql(strtmp);
		while(recordSet.next()){
				JSONObject tmp = new JSONObject();
				tmp.put("id",recordSet.getString("id"));
				tmp.put("categoryname",recordSet.getString("categoryname"));
				tmp.put("id2",recordSet.getString("id"));
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


String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));

int mainCategoryId=Util.getIntValue(request.getParameter("mainCategoryId"),0);
String mainCategoryName = Util.null2String(request.getParameter("mainCategoryName"));

String sqlwhere = " ";
int ishead = 0;

boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();

String subcompanyids = "";

if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}


if(mainCategoryId!=0){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  id = '";
		sqlwhere += mainCategoryId;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and id = '";
		sqlwhere += mainCategoryId;
		sqlwhere += "'";
	}
}
if(!"".equals(mainCategoryName)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where categoryname like '%";
		sqlwhere += Util.fromScreen2(mainCategoryName,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and categoryname like '%";
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
	if(ishead==0){
		ishead = 1;
		sqlwhere = " where id not in ("+documentids+")";
	}else{
		sqlwhere += " and id not in ("+documentids+")";
	}
}
 if(recordSet.getDBType().equals("oracle")){
		 
	  if(ishead==0){
		ishead = 1;
		sqlwhere += " nvl(parentid,0) <=0";
	   } else{
		sqlwhere += " and nvl(parentid,0) <=0";		
	   }
 } else{

	   if(ishead==0){
		ishead = 1;
		sqlwhere += " isnull(parentid,0)<=0";
	   } else{
		sqlwhere += " and isnull(parentid,0)<=0";		
	   }
        	
 }
String sqlwhere2 = "select * from DocSecCategory "+sqlwhere;

//System.out.println("sql = "+sqlwhere);
//System.out.println("sqlWhere1 = "+sqlwhere1);
recordSet.execute(sqlwhere2);
int RecordSetCounts = recordSet.getCounts();
int totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}

RecordSet rs = MainCategoryManager.getSelectResultSec(sqlwhere,pagenum,perpage);
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();

while(rs.next()){
	JSONObject tmp = new JSONObject();
	tmp.put("id",rs.getString("id"));
	tmp.put("categoryname",rs.getString("categoryname"));
	tmp.put("id2",rs.getString("id"));
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>
