
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<%
ArrayList nameList = new ArrayList();
ArrayList valueList = new ArrayList();
nameList.add("width");
nameList.add("height");
nameList.add("quality");
nameList.add("fullScreen");
nameList.add("autoPlay");
nameList.add("autoPlay");
nameList.add("videoSrcType");
nameList.add("videoSrc");
String strSettingSql = "select * from hpElementSetting where eid = "+eid;
rs_Setting.execute(strSettingSql);
if(!rs_Setting.next()){
	
	valueList.add("400");
	valueList.add("300");
	valueList.add("8");
	valueList.add("on");
	valueList.add("on");
	valueList.add("1");
	valueList.add("");
	int maxId = 0;
	strSettingSql = "select count(*) as maxId from hpElementSetting ";
	rs_Setting.execute(strSettingSql);
	if(rs_Setting.next()){
		maxId = rs_Setting.getInt("maxId");
	}
	maxId++;
	String insertStr = "";
	
	for(int i=0;i<nameList.size();i++){
		insertStr = "insert into hpElementSetting (id,eid,name,value) values("+(maxId+i)+","+eid+",'"+nameList.get(i)+"','"+valueList.get(i)+"')";
		rs_Setting.execute(insertStr);
		valueList.add("");		
	}
}else{
	String selectStr ="";
	for(int i=0;i<nameList.size();i++){
		selectStr = "select * from hpElementSetting where eid="+eid+" and name='"+nameList.get(i)+"'";
		rs_Setting.execute(selectStr);
		if(rs_Setting.next()){
			valueList.add(rs_Setting.getString("value"));
		}
	}
}
%>
