
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="net.sf.json.*" %>
<%
	String ygid=Util.null2String(request.getParameter("ygid"));//得到异构产品的id
	String mark=Util.null2String(request.getParameter("mark"));
	String opera=Util.null2String(request.getParameter("opera"));
	String type=Util.null2String(request.getParameter("type"));//type==1,表示切换异构产品下拉框,/type==2表示切换数据源下拉框
	String sid="";//数据交互方式的id
	String selecteddatasourid=Util.null2String(request.getParameter("selecteddatasourid"));//得到选中的数据源的id
	JSONObject json = new JSONObject();
	if("1".equals(type))//需要查出数据源下拉框进行返回
	{
		json.accumulate("","");
		String sql="select sid from int_heteProducts where id='"+ygid+"'";
		if(RecordSet.execute(sql)&&RecordSet.next())
		{
			 sid=RecordSet.getString("sid");
		}
		if("1".equals(sid))//中间表的方式----dml数据源
		{
			//查出该产品下的数据源
			RecordSet.execute("select * from dml_datasource where hpid='"+ygid+"'");
			while(RecordSet.next())
			{
				json.accumulate(RecordSet.getString("id"),RecordSet.getString("sourcename"));
			}
		}else if("2".equals(sid))//webservice的方式--webservice数据源
		{
			//查出该产品下的数据源
			RecordSet.execute("select * from ws_datasource where hpid='"+ygid+"'");
			while(RecordSet.next())
			{
				json.accumulate(RecordSet.getString("id"),RecordSet.getString("poolname"));
			}
		}else if("3".equals(sid))//RFC的方式---sap的数据源
		{	
			//查出该产品下的数据源
			RecordSet.execute("select * from sap_datasource where hpid='"+ygid+"'");
			while(RecordSet.next())
			{
				json.accumulate(RecordSet.getString("id"),RecordSet.getString("poolname"));
			}
		}
	}else if("2".equals(type))//需要查询注册的服务下拉框进行返回
	{
	
		json.accumulate("","");
		String sql="select sid from int_heteProducts where id='"+ygid+"'";
		if(RecordSet.execute(sql)&&RecordSet.next())
		{
			 sid=RecordSet.getString("sid");
		}
		//依据异构产品的id和数据源的id,查出注册的服务
		if("1".equals(sid))//中间表的方式----dml数据源
		{
			RecordSet.execute("select * from dml_service where hpid='"+ygid+"' and poolid='"+selecteddatasourid+"'");
			while(RecordSet.next())
			{
				json.accumulate(RecordSet.getString("id"),RecordSet.getString("regname"));
			}
		}else if("2".equals(sid))//webservice的方式--webservice数据源
		{
			RecordSet.execute("select * from ws_service where hpid='"+ygid+"' and poolid='"+selecteddatasourid+"'");
			while(RecordSet.next())
			{
				json.accumulate(RecordSet.getString("id"),RecordSet.getString("regname"));
			}
			
		}else if("3".equals(sid))//RFC的方式---sap的数据源
		{	
			RecordSet.execute("select * from sap_service where hpid='"+ygid+"' and poolid='"+selecteddatasourid+"'");
			while(RecordSet.next())
			{
				json.accumulate(RecordSet.getString("id"),RecordSet.getString("regname"));
			}
		}
	}else if("3".equals(type))
	{
		
		//验证唯一
		if(RecordSet.execute("select count(*) s from int_BrowserbaseInfo where mark='"+mark+"'")&&RecordSet.next())
		{
			if(RecordSet.getInt("s")<=0)//证明没有重复的值了
			{
				json.accumulate("msg","0");
			}else
			{
				json.accumulate("msg","1");
			}
		}else
		{
			json.accumulate("msg","1");
		}
	}
	out.clear();
	out.print(json);
%>