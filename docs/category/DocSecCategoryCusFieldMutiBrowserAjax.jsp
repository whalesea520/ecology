<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomDictManager" class="weaver.docs.docs.CustomDictManager" scope="page" />
<%@ page import="weaver.hrm.*,weaver.general.KnowledgeTransMethod" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String documentids = Util.null2String(request.getParameter("systemIds"));
String scope = Util.null2String(request.getParameter("scope"));
if(scope.equals(""))scope = "DocCustomFieldBySecCategory";
if(documentids.trim().startsWith(",")){
	documentids = documentids.substring(1);
}
String _fieldlabel = "";
KnowledgeTransMethod ktm = new KnowledgeTransMethod();
if(src.equalsIgnoreCase("dest")){
	JSONArray jsonArr = new JSONArray();
	JSONArray jsonArr_tmp = new JSONArray();
	JSONObject json = new JSONObject();
	if (!documentids.equals("")) {
		String strtmp = "select id,fieldlabel,fieldhtmltype,type from cus_formdict where id in ("+documentids+")";
		recordSet.executeSql(strtmp);
		while(recordSet.next()){
				JSONObject tmp = new JSONObject();
				tmp.put("id",recordSet.getString("id"));
				_fieldlabel = Util.null2String(recordSet.getString("fieldlabel"));
				if(_fieldlabel.equals(""))_fieldlabel = "field"+recordSet.getString("id");
				tmp.put("fieldlabel",_fieldlabel);
				tmp.put("type",ktm.getCusFieldType(recordSet.getString("fieldhtmltype"),recordSet.getString("type")+"+"+user.getLanguage()));
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

String fieldlabel=Util.null2String(request.getParameter("fieldlabel"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String fieldhtmltype=Util.null2String(request.getParameter("fieldhtmltype"));
String type = Util.null2String(request.getParameter("type"));

String sqlwhere = "where (scope='"+scope+"' or id in(select fieldid from cus_formfield where scope = '"+scope+"'))";
int ishead = 1;

if(!fieldlabel.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  fieldlabel like '%";
		sqlwhere += fieldlabel;
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and fieldlabel like '%";
		sqlwhere += fieldlabel;
		sqlwhere += "%'";
	}
}
if(!"".equals(fieldname)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where fieldname like '%";
		sqlwhere += Util.fromScreen2(fieldname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and fieldname like '%";
		sqlwhere += Util.fromScreen2(fieldname,user.getLanguage());
		sqlwhere += "%'";
	}
}

if(!"".equals(fieldhtmltype)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  fieldhtmltype = '";
		sqlwhere += fieldhtmltype;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and fieldhtmltype = '";
		sqlwhere += fieldhtmltype;
		sqlwhere += "'";
	}
}

if(!"".equals(type)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  type = '";
		sqlwhere += type;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and type = '";
		sqlwhere += type;
		sqlwhere += "'";
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
	//	sqlwhere = " where id not in ("+documentids+")";
	}else{
	//	sqlwhere += " and id not in ("+documentids+")";
	}
}

String sqlwhere2 = "select * from cus_formdict "+sqlwhere;


//System.out.println("sql = "+sqlwhere);
//System.out.println("sqlWhere1 = "+sqlwhere1);
recordSet.execute(sqlwhere2);
int RecordSetCounts = recordSet.getCounts();
int totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}

RecordSet rs = CustomDictManager.getSelectResult(sqlwhere,pagenum,perpage);
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
while(rs.next()){
	JSONObject tmp = new JSONObject();
	tmp.put("id",rs.getString("id"));
	_fieldlabel = Util.null2String(rs.getString("fieldlabel"));
	if(_fieldlabel.equals(""))_fieldlabel = "field"+rs.getString("id");
	tmp.put("fieldlabel",_fieldlabel);
	tmp.put("type",ktm.getCusFieldType(rs.getString("fieldhtmltype"),rs.getString("type")+"+"+user.getLanguage()));
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>
