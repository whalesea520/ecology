<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String sqlStr = "" ;
String method = Util.null2String(request.getParameter("method"));
if(method.equals("add"))
{
	String name=Util.null2String(request.getParameter("name"));
	String linkKey=Util.null2String(request.getParameter("linkKey"));
	String newsId=Util.fromScreen2(request.getParameter("newsId"),user.getLanguage());
	String type=Util.fromScreen2(request.getParameter("type"),user.getLanguage());
	name=name.trim();
	linkKey=linkKey.trim();
	sqlStr = "select id from webSite where linkKey = '" + Util.fromScreen2(linkKey,user.getLanguage()) + "'"; 
	RecordSet.executeSql(sqlStr);
	if (RecordSet.next()) {response.sendRedirect("/web/data/WebSite.jsp?error=1&name="+name+"&linkKey="+linkKey+"&newsId="+newsId+"&type="+type);}
	else {
		sqlStr = "insert into webSite(name,linkKey,newsId,type) values(";
		sqlStr +="'"+Util.fromScreen2(name,user.getLanguage())+"'," ;
		sqlStr +="'"+Util.fromScreen2(linkKey,user.getLanguage())+"'," ;
		sqlStr +=newsId+"," ;
		sqlStr +="'"+type+"'" ;
		sqlStr +=")";
		RecordSet.executeSql(sqlStr);
		sqlStr = "select max(id) from webSite " ;
		String id = "" ;
        RecordSet.executeSql(sqlStr);		
		if(RecordSet.next())  id = RecordSet.getString(1) ;

		if (type.equals("7")) //调查表 begin
		{
			Calendar todaycal = Calendar.getInstance ();
			String reportdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
			String inprepname = "" ; 
			String rsearchname = "" ;
			String inputid = "" ;
			sqlStr = "select inprepname from T_SurveyItem where inprepid="+newsId ;
			RecordSet.executeSql(sqlStr) ;
			if(RecordSet.next()) 
				inprepname = Util.fromScreen2(RecordSet.getString("inprepname"),user.getLanguage()) ;
			rsearchname = inprepname +"~"+ reportdate;
			sqlStr = " INSERT INTO T_ResearchTable (inprepid,rsearchname,rsearchdate,countfrom,countemial,state) VALUES("+newsId+",'"+rsearchname+"','"+reportdate+"',"+"0,0"+",0)" ;
            RecordSet.executeSql(sqlStr);
			sqlStr = "select max(inputid) from T_ResearchTable where inprepid="+newsId ;
            RecordSet.executeSql(sqlStr);
            if(RecordSet.next()) inputid = RecordSet.getString(1) ;
			sqlStr = "update webSite set researchId = "+inputid+" where id="+id ;
            RecordSet.executeSql(sqlStr);

		}	//调查表 end
		response.sendRedirect("/web/data/WebSite.jsp");
	}
	return;
}

String webIDs[]=request.getParameterValues("webIDs");
if(method.equals("delete"))
{
	if(webIDs != null)
	{
		for(int i=0;i<webIDs.length;i++)
		{
			sqlStr = "DELETE FROM webSite where id=" + webIDs[i];
            RecordSet.executeSql(sqlStr);			
		}
	}
	response.sendRedirect("/web/data/WebSite.jsp");
	return;
}

if(method.equals("edit"))
{   
    String id=Util.null2String(request.getParameter("id"));
	String name=Util.null2String(request.getParameter("name"));
	String linkKey=Util.null2String(request.getParameter("linkKey"));
	String newsId=Util.fromScreen2(request.getParameter("newsId"),user.getLanguage());
	String type=Util.fromScreen2(request.getParameter("type"),user.getLanguage());
	name=name.trim();
	linkKey=linkKey.trim();
	sqlStr = "select id from webSite where linkKey = '" + Util.fromScreen2(linkKey,user.getLanguage()) + "'"; 
	RecordSet.executeSql(sqlStr);
	if (RecordSet.next() && (!id.equals(RecordSet.getString("id"))))
			response.sendRedirect("/web/data/WebSite.jsp?id="+id+"&error=1&name="+name+"&linkKey="+linkKey+"&newsId="+newsId+"&type="+type);
	else {
			sqlStr = "select newsId from webSite where id = " + id ;
			RecordSet.executeSql(sqlStr);
			RecordSet.next();
			String newsIdTemp = RecordSet.getString("newsId");
			sqlStr = "UPDATE webSite set " ;
			sqlStr += " name = '" + Util.fromScreen2(name,user.getLanguage()) + "' , " ;
			sqlStr += " linkKey = '" + Util.fromScreen2(linkKey,user.getLanguage()) + "' , " ;
			sqlStr += " newsId = " + newsId + " , ";
			sqlStr += " type = '" + type + "' " ;
			sqlStr += " where id = " + id ;
			RecordSet.executeSql(sqlStr);
			
			if ((!newsIdTemp.equals(newsId))&&(type.equals("7"))) //调查表 begin
			{
				Calendar todaycal = Calendar.getInstance ();
				String reportdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
					 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
					 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
				String inprepname = "" ; 
				String rsearchname = "" ;
				String inputid = "" ;
				sqlStr = "select inprepname from T_SurveyItem where inprepid="+newsId ;
				RecordSet.executeSql(sqlStr) ;
				if(RecordSet.next()) 
					inprepname = Util.fromScreen2(RecordSet.getString("inprepname"),user.getLanguage()) ;
				rsearchname = inprepname +"~"+ reportdate;
				sqlStr = " INSERT INTO T_ResearchTable (inprepid,rsearchname,rsearchdate,countfrom,countemial,state) VALUES("+newsId+",'"+rsearchname+"','"+reportdate+"',"+"0,0"+",0)" ;
				RecordSet.executeSql(sqlStr);
				sqlStr = "select max(inputid) from T_ResearchTable where inprepid="+newsId ;
				RecordSet.executeSql(sqlStr);
				if(RecordSet.next()) inputid = RecordSet.getString(1) ;
				sqlStr = "update webSite set researchId = "+inputid+" where id="+id ;
				RecordSet.executeSql(sqlStr);

			}	//调查表 end

			response.sendRedirect("/web/data/WebSite.jsp");
	}
	return;
}

%>
