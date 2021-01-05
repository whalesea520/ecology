<%@page import="java.util.ArrayList"%>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<%
	ArrayList nameList = new ArrayList();
	ArrayList valueList = new ArrayList();
	nameList.add("height");
	nameList.add("width");
	nameList.add("highopen");
	nameList.add("pictureShowType");
	nameList.add("autoShow");
	nameList.add("autoShowSpeed");
	nameList.add("pictureheight");
	nameList.add("picturewidth");
	nameList.add("picturewordcount");
	nameList.add("needbutton");
	
	
	String strSettingSql = "select * from hpElementSetting where eid = " + eid;
	rs_Setting.execute(strSettingSql);
	if (!rs_Setting.next())
	{
		valueList.add("75");
		valueList.add("75");
		valueList.add("0");
		valueList.add("2");
		valueList.add("1");
		valueList.add("20");
		valueList.add("75");
		valueList.add("75");
		valueList.add("8");
		valueList.add("1");
		
		int maxId = 0;
		strSettingSql = "select count(*) as maxId from hpElementSetting";
		rs_Setting.execute(strSettingSql);
		if (rs_Setting.next())
		{
			maxId = rs_Setting.getInt("maxId");
		}
		maxId++;
		String insertStr = "";

		for (int i = 0; i < nameList.size(); i++)
		{
			insertStr = "insert into hpElementSetting (id,eid,name,value) values(" + (maxId + i) + "," + eid + ",'" + nameList.get(i) + "','"
					+ valueList.get(i) + "')";
			rs_Setting.execute(insertStr);
			valueList.add("");
		}
	}
	else
	{
		String selectStr = "";
		for (int i = 0; i < nameList.size(); i++)
		{
			selectStr = "select * from hpElementSetting where eid=" + eid + " and name='" + nameList.get(i) + "'";
			rs_Setting.execute(selectStr);
			if (rs_Setting.next())
			{
				valueList.add(rs_Setting.getString("value"));
			}
		}
	}
%>
