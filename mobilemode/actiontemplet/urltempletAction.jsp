<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.SplitPageUtil"%>
<%@ page import="weaver.general.SplitPageParaBean"%>
<%

/*在移动端这样获取当前用户*/
User user = MobileUserInit.getUser(request, response);

int pageNo = Util.getIntValue(request.getParameter("pageNo"));
int pageSize = Util.getIntValue(request.getParameter("pageSize"));
String searchKey = Util.null2String(request.getParameter("searchKey"));

String sql = "select * from hrmresource";
if(!searchKey.equals("")){
	sql += " where lastname like '%"+searchKey+"%'";
}

/*分页查询代码，标准代码*/
SplitPageParaBean spp = new SplitPageParaBean();
spp.setSqlFrom("("+sql+") t1");
spp.setPrimaryKey("id");
spp.setBackFields("*");
//spp.setSqlOrderBy("t1.lastname");	//排序字段
//spp.setSortWay(1);	//0 升序   1 降序
SplitPageUtil spu = new SplitPageUtil();
spu.setSpp(spp);
RecordSet rs = spu.getCurrentPageRs(pageNo,pageSize);

/*将查询结果按照 字段名作为key，字段值作为value 动态封装成json，标准代码*/
int totalSize = spu.getRecordCount();
JSONArray datas = new JSONArray();
String[] columnNames = rs.getColumnName();
while(rs.next()){
	JSONObject jsonObj = new JSONObject();
	for(String columnName : columnNames){
		jsonObj.put(columnName, Util.formatMultiLang(rs.getString(columnName)));
	}
	datas.add(jsonObj);
}
		
JSONObject resultObj = new JSONObject();
resultObj.put("totalSize", totalSize);
resultObj.put("datas", JSONArray.fromObject(datas));

out.print(resultObj);
%>