
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@page import="java.util.ArrayList"%>
<%
    User user = HrmUserVarify.getUser(request,response);
    int userid=user.getUID();
	int departmentid=user.getUserDepartment();   //用户所属部门
	int subCompanyid=user.getUserSubCompany1();  //用户所属分部
	String seclevel=user.getSeclevel();          //用于安全等级
	String sqlStr="select distinct typeid,typename,mainid,mainname from ("+
	" select t1.id,t1.name,t1.status,t1.typeid,t9.typename,t9.mainid,t9.mainname,"+
	" case when  t3.sourceid is not null then 1 when t2.cotypeid is not null then 0 end as jointype,"+
	" case when  t6.coworkid is not null then 1 else 0 end as ishidden"+
	" from cowork_items  t1 left join "+
	//关注的协作
	" (select distinct cotypeid from  cotype_sharemanager where (sharetype=1 and sharevalue like '%,"+userid+",%' )"+
	" or (sharetype=2 and sharevalue like '%,"+departmentid+",%' and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax) "+
	" or (sharetype=3 and sharevalue like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
	" or (sharetype=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and  sharevalue=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
	" or (sharetype=5 and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
	" )  t2 on t1.typeid=t2.cotypeid left join "+
	//直接参与的协作
	" (select distinct sourceid from coworkshare where"+
	" (type=1 and  (content='"+userid+"' or content like '%,"+userid+",%') )"+
	" or (type=2 and content like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax) "+
	" or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
	" or (type=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and content=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
	" or (type=5 and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
	" )  t3 on t3.sourceid=t1.id"+
	" left join (select t7.id,t7.typename,t8.id as mainid,t8.typename as mainname from cowork_types  t7 left join cowork_maintypes  t8 on t7.departmentid=t8.id)  t9 on t1.typeid=t9.id"+
	//阅读|重要|隐藏
	" left join (select distinct coworkid,userid from cowork_hidden where userid="+userid+" )  t6 on t1.id=t6.coworkid"+    //是否隐藏
	" ) t where 1=1 and jointype is not null and ishidden<>1 and status=1";
%>
<ul id="coworkAreaList" class="filetree">
<%
	RecordSet recordSet=new RecordSet();
	RecordSet recordSet2=new RecordSet();
	
	String mainid="";
	String mainName="";
	
	String typeid="";
	String typename="";
	
	String mainidstr=",";
	String typeidstr=",";
	recordSet.execute(sqlStr);
	while(recordSet.next()){
		mainid=recordSet.getString("mainid");
		typeid=recordSet.getString("typeid");
		if(!mainidstr.contains(","+mainid+","))
			mainidstr=mainidstr+mainid+",";
		if(!typeidstr.contains(","+typeid+","))
			typeidstr=typeidstr+typeid+",";
	}
	mainidstr=mainidstr.substring(1,mainidstr.length()-1);
	typeidstr=typeidstr.substring(1,typeidstr.length()-1);
	
	String sql="select * from cowork_maintypes where id in ("+mainidstr+")";
	recordSet.execute(sql);
	int count=1;
	while(recordSet.next()){
	   	mainid=recordSet.getString("id");
	   	mainName=recordSet.getString("typename");
	   	sql="select * from cowork_types where departmentid="+mainid+" and id in ("+typeidstr+")";
	   	recordSet2.execute(sql);
%>
    <li class="<%=count==1?"":"closed"%>"><span class="folder"><%=mainName%></span>
      <ul>
<%	   	
	 while(recordSet2.next()){
	   	typeid=recordSet2.getString("id");
	   	typename=recordSet2.getString("typename");
%>
       <li style="background-color:#F7F7F7 !important">
		   <span class="file" onclick="loadCoworkArea(this,<%=typeid%>)" style="cursor: pointer;">
		     <%=typename%>
		   </span>
	   </li>
<%}%>
      </ul>
    </li>  
<%
	count++;
	}
%>
</ul>