
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSetTrans"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="MatrixUtil" class="weaver.matrix.MatrixUtil" scope="page"/>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%


if(!HrmUserVarify.checkUserRight("Matrix:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return  ;
}

String method = Util.null2String(request.getParameter("method"));
String name = Util.null2String(request.getParameter("name"));
String descr = Util.null2String(request.getParameter("descr"));

String id = Util.null2String(request.getParameter("matrixid"));

boolean isOracle = RecordSet.getDBType().equals("oracle");

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

if(method.equals("add")) {
	if(isOracle) {

		//获取 最大的id
		RecordSet.executeSql("select max(id) as id from MatrixInfo");
		while(RecordSet.next()){
			id = RecordSet.getString("id");
		}
		id = (Util.getIntValue(id,1)+1)+"";
		RecordSet.executeSql("insert into MatrixInfo (id,name,descr,createdate,createtime,createrid) values ("+id+",'"+name+"','"+descr+"','"+currentdate+"','"+currenttime+"',"+user.getUID()+")");
	    //System.out.println("insert into MatrixInfo (id,name,descr,createdate,createtime,createrid) values ("+id+",'"+name+"','"+descr+"','"+currentdate+"','"+currenttime+"',"+user.getUID()+")");
	}else{
		RecordSet.executeSql("insert into MatrixInfo (name,descr,createdate,createtime,createrid) values ('"+name+"','"+descr+"','"+currentdate+"','"+currenttime+"',"+user.getUID()+")");
	}
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
}

if(method.equals("edit")) {
	
	RecordSet.executeSql("update MatrixInfo set name='"+name+"', descr='"+descr+"' where id="+id);
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
}


if (method.equals("delete")) {
	
	
	//删除基本信息
	RecordSet.executeSql("delete from MatrixInfo where id="+id);
	//删除维护信息
	RecordSet.executeSql("delete from MatrixMaintInfo where matrixid="+id);
	//删除字段信息
	RecordSet.executeSql("delete from MatrixFieldInfo where matrixid="+id);
	
    //out.println("<script>window.open('Matrix.jsp','mainFrame','') </script>");
    response.sendRedirect("/matrixmanage/pages/MatrixList.jsp");
    return;
    
}

// 0 是分部  1是 部门
String inittype = Util.null2String(request.getParameter("inittype"));

//初始化 部门或分部
if (method.equals("init")) {
	
	RecordSetTrans.setAutoCommit(false);
	
	if(isOracle) {
		RecordSetTrans.executeSql("insert into MatrixInfo (id,name,descr,createdate,createtime,createrid) values (MatrixInfo_ID.nextval,'"+name+"','"+descr+"','"+currentdate+"','"+currenttime+"',"+user.getUID()+")");
	}else{
		RecordSetTrans.executeSql("insert into MatrixInfo (name,descr,createdate,createtime,createrid) values ('"+name+"','"+descr+"','"+currentdate+"','"+currenttime+"',"+user.getUID()+")");
	}
	
	//获取 最大的id
	RecordSetTrans.executeSql("select max(id) as id from MatrixInfo");
	while(RecordSetTrans.next()){
		id = RecordSetTrans.getString("id");
	}
	List<String> sqls = new ArrayList<String>();
	if("0".equals(inittype)){
		MatrixUtil.sysSubcompanyToMatrix(id,sqls,RecordSet,-1);
		//初始化后将 matrixinit 表中标志
		//RecordSetTrans.executeSql("update matrixinit set companyinit ='1' where id=0");
	}else{
		MatrixUtil.sysDepartToMatrix(id,sqls,RecordSet,-1);
		//初始化后将 matrixinit 表中标志
		//RecordSetTrans.executeSql("update matrixinit set deptinit ='1' where id=0");
	}
	
	for(String sql : sqls){
		RecordSetTrans.executeSql(sql);
	}
	
	
	
	
	RecordSetTrans.commit();
	
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
    
}




%>
