<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.general.SplitPageUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String _type = Util.null2String(request.getParameter("type"));
String check_per = Util.null2String(request.getParameter("selectedids"));
if(check_per.equals(",")){
	check_per = "";
}
if(check_per.equals("")){
	check_per = Util.null2String(request.getParameter("systemIds"));
}

int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
String id=null;
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件	
	String[] groupids = check_per.split(",");
	for(int i=0;groupids!=null&&i<groupids.length;i++){
		if(Util.null2String(groupids[i]).length()==0)continue;
		rs.executeSql("select name from hrmgroup where id = "+groupids[i]);
		String name = "";
		if(rs.next()) name = rs.getString("name");
		JSONObject tmp = new JSONObject();
		tmp.put("id",groupids[i]);
		tmp.put("name",name);
		jsonArr.add(tmp);
	}

	int totalPage = jsonArr.size();
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}
	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}else{//左侧待选择列表的sql条件
String groupname = Util.null2String(request.getParameter("groupname"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

if(sqlwhere.length()==0)sqlwhere += " where 1=1";
if(!groupname.equals("")){
	sqlwhere += " and name like '%" + Util.fromScreen2(groupname,user.getLanguage()) +"%' ";
}

if(_type.length() > 0){
	sqlwhere += " and type = "+_type;
}

//屏蔽已选
String excludeId = Util.null2String(request.getParameter("excludeId"));
if(excludeId.length()==0)excludeId=check_per;
if(excludeId.length()>0){
	sqlwhere += " and id not in ("+excludeId+")";
}

String sqlfrom = " HrmGroup ";
SplitPageParaBean spp = new SplitPageParaBean();
spp.setBackFields(" id,name");
spp.setSqlFrom(sqlfrom);
spp.setSqlWhere(sqlwhere);
spp.setSqlOrderBy("type,sn");
spp.setPrimaryKey("id");
spp.setDistinct(false);
spp.setSortWay(spp.ASC);
SplitPageUtil spu = new SplitPageUtil();
spu.setSpp(spp);

int RecordSetCounts = spu.getRecordCount();
int totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}
rs = spu.getCurrentPageRs(pagenum, perpage);
while(rs.next()) {
	id = rs.getString("id");
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("name",rs.getString("name"));
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
}
%>
