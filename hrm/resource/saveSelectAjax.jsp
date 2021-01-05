<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response);
//只保存20条数据
String id=Util.null2String(request.getParameter("ids"));
String[] ids = null;
if(id.length()>0){
	ids=id.split(",");
	for(int i=0;i<ids.length;i++){
		if(i>20)break;
		rs.executeSql("delete from HrmResourceSelectRecord where selectid="+ids[i]+" and resourceid ="+user.getUID());
		rs.executeSql("insert into HrmResourceSelectRecord (selectid,resourceid) values("+ids[i]+","+user.getUID()+")");
	}
	//删除超过20条记录的数据
	if(rs.getDBType().equals("oracle")){
		rs.executeSql("delete from HrmResourceSelectRecord where resourceid = "+user.getUID()+" and id not in (select id from (select id from HrmResourceSelectRecord where resourceid = "+user.getUID()+" order by id desc) t where rownum<20)");
	}else{
		rs.executeSql("delete from HrmResourceSelectRecord where resourceid = "+user.getUID()+" and id not in (select top 20 id from HrmResourceSelectRecord where resourceid = "+user.getUID()+" order by id desc )");
	}
}
%>
				