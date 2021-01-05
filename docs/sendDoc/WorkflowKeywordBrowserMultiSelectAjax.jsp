
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response);
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String parentId = Util.null2String(request.getParameter("parentId"));
String src = Util.null2String(request.getParameter("src"));
if(tabid.equals("")) tabid="0";
String documentids = Util.null2String(request
		.getParameter("systemIds"));
if (documentids.trim().startsWith(",")) {
	documentids = documentids.substring(1);
}
if (src.equalsIgnoreCase("dest")) {
	JSONArray jsonArr = new JSONArray();
	JSONArray jsonArr_tmp = new JSONArray();
	JSONObject json = new JSONObject();
	if (!documentids.equals("")) {
		String sql = "select id,keywordName from Workflow_Keyword where id in ("
				+ documentids + ")";
		rs.executeSql(sql);
		while (rs.next()) {
			JSONObject tmp = new JSONObject();
			tmp.put("id", rs.getString("id"));
			tmp.put("keyword", rs.getString("keywordName"));
			jsonArr_tmp.add(tmp);
		}
		String[] documentidArr = Util.TokenizerString2(documentids,
				",");
		for (int i = 0; i < documentidArr.length; i++) {
			for (int j = 0; j < jsonArr_tmp.size(); j++) {
				JSONObject tmp = (JSONObject) jsonArr_tmp.get(j);
				if (tmp.get("id").equals(documentidArr[i])) {
					jsonArr.add(tmp);
				}
			}
		}

	}
	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList", jsonArr.toString());
	out.println(json.toString());
	return;
}

String strKeyword = Util.null2String(request.getParameter("strKeyword"));
String intKeywords = "" ;


if(!strKeyword.equals("")){

	try{
		List strKeywordList=Util.TokenizerString(strKeyword," ");
		strKeyword="";
		String tempKeyword=null;
		String tempId="0";
		boolean keywordIsExists=false;

		for(int i=0;i<strKeywordList.size();i++){
			tempKeyword=(String)strKeywordList.get(i);

			if(tempKeyword!=null&&!tempKeyword.trim().equals("")){
				keywordIsExists=false;
				WorkflowKeywordComInfo.setTofirstRow();
				while(WorkflowKeywordComInfo.next()){
					if(tempKeyword.equals(WorkflowKeywordComInfo.getKeywordName())){
						tempId=WorkflowKeywordComInfo.getId();
						strKeyword+=","+tempKeyword;
						intKeywords+=","+tempId;
						keywordIsExists=true;
						break;
					}
				}

				if(!keywordIsExists){
					strKeyword+=","+tempKeyword;
					intKeywords+=","+(-i-1);
				}
			}
		}
	
	}catch(Exception e){
		intKeywords="";
		strKeyword="";
	}
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String keyWordName = Util.null2String(java.net.URLDecoder.decode(request.getParameter("keyWordName"),"utf-8"));
String keywordDesc = Util.null2String(java.net.URLDecoder.decode(request.getParameter("keywordDesc"),"utf-8"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));


if(parentId.equals("0"))    parentId="";




int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;

if(ishead==0){
	ishead = 1;
	sqlwhere += " where isKeyword='1' ";
}else{
	sqlwhere += " and isKeyword='1' ";
}

if(!keyWordName.equals("")){
	sqlwhere += " and keyWordName like '%" + Util.fromScreen2(keyWordName,user.getLanguage()) +"%' ";
}
if(!keywordDesc.equals("")){
	sqlwhere += " and keywordDesc like '%" + Util.fromScreen2(keywordDesc,user.getLanguage()) +"%' ";
}

if(tabid.equals("0")&&!parentId.equals("")){
	sqlwhere += " and parentId=" + parentId;
}
int perpage = Util
.getIntValue(request.getParameter("pageSize"), 10);
int pagenum = Util.getIntValue(request.getParameter("currentPage"),
1);
if (documentids.equals("")) {
documentids = Util.null2String(request
	.getParameter("excludeId"));
}
if (!documentids.equals("")) {
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where id not in (" + documentids + ")";
	}else{
		sqlwhere += " and id not in (" + documentids + ")";
	}
}

String sql = "select count(id) from Workflow_Keyword "+sqlwhere;
rs.executeSql(sql);
int RecordSetCounts = 0;
int totalPage = RecordSetCounts / perpage;
if (totalPage % perpage > 0 || totalPage == 0) {
	totalPage++;
}
if(rs.next()){
	RecordSetCounts = rs.getInt(1);
}

String sqlstr = " select id,keywordName  from Workflow_Keyword " + sqlwhere+" order by showOrder asc";
rs.executeSql(sqlstr);
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
while (rs.next()) {
	JSONObject tmp = new JSONObject();
	tmp.put("id", rs.getString("id"));
	tmp.put("keyword", rs.getString("keywordName"));
	jsonArr.add(tmp);
}
json.put("currentPage", 1);
json.put("totalPage", 1);
json.put("mapList", jsonArr.toString());
out.println(json.toString());
%>
