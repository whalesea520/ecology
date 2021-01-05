
<%@ include file="/page/element/operationCommon.jsp"%>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<%
	
    String 	blog_showNum=Util.null2String(request.getParameter("blog_showNum_"+eid )) ;            //微博显示条数
    String 	blog_isCreatedate=Util.null2String(request.getParameter("blog_isCreatedate_"+eid )) ;   //是否显示创建日期
    String 	blog_isRelatedName=Util.null2String(request.getParameter("blog_isRelatedName_"+eid )) ; //是否显示相关人
	if("".equals(blog_showNum)){
		blog_showNum="10";
	}
	if("".equals(blog_isCreatedate)){
		blog_isCreatedate="0";
	}
	if("".equals(blog_isRelatedName)){
		blog_isRelatedName="0";
	}
	String strSettingSql = "select max(id) maxId from slideElement " ;
	rs_Setting.execute(strSettingSql);
	int maxid=0;
	if (rs_Setting.next())
	{
		maxid = rs_Setting.getInt("maxId");
	}
	maxid++;
	String sql1="delete from hpelementsetting where eid="+eid;

	rs_Setting.execute(sql1);
	String sql2="";
	sql2=" insert into hpelementsetting(id,eid,name,value) values("+(maxid+1)+","+eid+",'blog_showNum','"+blog_showNum+"')";
	rs_Setting.execute(sql2);
	sql2=" insert into hpelementsetting(id,eid,name,value) values("+(maxid+1)+","+eid+",'blog_isCreatedate','"+blog_isCreatedate+"')";
	rs_Setting.execute(sql2);
	sql2=" insert into hpelementsetting(id,eid,name,value) values("+(maxid+1)+","+eid+",'blog_isRelatedName','"+blog_isRelatedName+"')";
	rs_Setting.execute(sql2);

%>