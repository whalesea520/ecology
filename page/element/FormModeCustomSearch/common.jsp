<%@page import="java.util.ArrayList"%>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<%
ArrayList nameList = new ArrayList();
ArrayList valueList = new ArrayList();
String sqlBizListCommon = "";
int maxId = 0;

nameList.add("recordCount");
nameList.add("linkMode");
// nameList.add("reportId");
// nameList.add("fields");
// nameList.add("fieldsWidth");
nameList.add("isshowtitle");
nameList.add("rolltype");
nameList.add("searchid");

//
sqlBizListCommon = "select count(*) as maxId from hpElementSetting ";
rs_Setting.execute(sqlBizListCommon);
if(rs_Setting.next()){
	maxId = rs_Setting.getInt("maxId");
}
for(int i=0; i<nameList.size(); i++){
	sqlBizListCommon = "select * from hpElementSetting where eid="+eid+" and name='"+nameList.get(i)+"'";
	rs_Setting.execute(sqlBizListCommon);
	if(rs_Setting.next()){
		valueList.add(rs_Setting.getString("value"));
	}else{
		valueList.add("");
		sqlBizListCommon = "insert into hpElementSetting (id,eid,name,value) values(" + (maxId + i) + "," + eid + ",'" + nameList.get(i) + "','"+ valueList.get(i) + "')";
		rs_Setting.execute(sqlBizListCommon);
	}
}

%>
