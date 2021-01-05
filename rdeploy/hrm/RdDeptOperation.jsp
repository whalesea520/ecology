<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<%!
/*
*Added by Charoes Huang
*Check if the department level equals 10, if true,this department can't have sub department
*
*/
private boolean ifDeptLevelEquals10(int departmentid){
	boolean isEquals10 = false;
	RecordSet rs = new RecordSet();
	String sqlStr ="Select  COUNT(d1.id) from 	HrmDepartment d1,HrmDepartment d2,HrmDepartment d3,HrmDepartment d4,HrmDepartment d5,HrmDepartment d6,HrmDepartment d7,HrmDepartment d8,HrmDepartment d9 WHERE   d1.supdepid = d2.id and d2.supdepid = d3.id and	d3.supdepid = d4.id and	d4.supdepid = d5.id and	d5.supdepid = d6.id and	d6.supdepid = d7.id and	d7.supdepid = d8.id and	d8.supdepid = d9.id and  d1.id <> d2.id and d1.id = "+departmentid ;

	rs.executeSql(sqlStr);
	if(rs.next()){
		if(rs.getInt(1) > 0){
			isEquals10 = true ;
		}
	}
	return isEquals10;
}
private void insertInto(int departmentid){
    if(departmentid <= 0){
        return;
    }
    RecordSet rs = new RecordSet();
    String sql = "select f.matrixid from MatrixFieldInfo f inner join MatrixInfo m on f.matrixid = m.id where m.issystem = 2";
    rs.executeSql(sql);
    int matrixid = -1;
    if(rs.next()){
        matrixid = rs.getInt(1);
    }
    if(matrixid != -1){
        float maxMatrixDataOrder = 0;
        String dbType = rs.getDBType();
        String dataorderStr = "dataorder";
        if("oracle".equalsIgnoreCase(dbType)){
            dataorderStr = "dataorder+0";
        }else if("sqlserver".equalsIgnoreCase(dbType)){
            dataorderStr = "cast(dataorder as float)";
        }
        rs.executeSql("select max("+dataorderStr+") from Matrixtable_"+matrixid);
        if(rs.next()){
            maxMatrixDataOrder = rs.getFloat(1);
            if(maxMatrixDataOrder== -1){
                maxMatrixDataOrder = 0;
            }
        }
        maxMatrixDataOrder++;
        String insertMSql = "insert into Matrixtable_"+matrixid+"(uuid,dataorder,id)  values ('" +
        java.util.UUID.randomUUID()+"','"+maxMatrixDataOrder+"','"+departmentid+"')";
        rs.executeSql(insertMSql);
    }
}
%>
<%
HttpServletRequest fu = request;
String operation = Util.fromScreen(fu.getParameter("operation"),user.getLanguage());

String departmentname = Util.fromScreen(fu.getParameter("departmentname"),user.getLanguage());
String subcompanyid1 = Util.fromScreen(fu.getParameter("subcompanyid1"),user.getLanguage());
String from = Util.fromScreen(fu.getParameter("from"),user.getLanguage());
int supdepid = Util.getIntValue(fu.getParameter("supdepid"),0);


String allsupdepid = "";
String sURL="";
String msg="";
if(operation.equals("add")){
	/*
	* Added by Charoes Huang
	* 判断是否10级部门
	*/
	int supdepartmentid = supdepid;
	if(supdepartmentid > 0){
		if(ifDeptLevelEquals10(supdepartmentid)){
		    msg = "1";
		    sURL="RdDeptAdd.jsp?method="+operation+"&subcompanyid1="+subcompanyid1+"&supdepid="+supdepid+"&id="+"&msg="+msg+"&from="+from;
            response.sendRedirect(sURL);
			return;
		}
	}
   //allsupdepid = DepartmentComInfo.getAllSupDepId(Util.getIntValue(supdepid))+supdepid+",";
	
   String checkNameSql ="select count(*)  from HrmDepartment where subcompanyid1 = "+subcompanyid1
   						+" and departmentname = '"+departmentname+"' and supdepid = "+supdepid;
   RecordSet.executeSql(checkNameSql);
   int flag= 0;
   if(RecordSet.next()){
       flag = RecordSet.getInt(1);
       if(flag >  0){
   		    msg="2";
   		    sURL="RdDeptAdd.jsp?method="+operation+"&subcompanyid1="+subcompanyid1+"&supdepid="+supdepid+"&id="+"&msg="+msg+"&from="+from;
	        response.sendRedirect(sURL);
			return;
   		}
   }
   
	String insertSql = "INSERT INTO HrmDepartment (departmentname, supdepid, subcompanyid1) VALUES ('"+departmentname+"',"+supdepid+","+subcompanyid1+" ) ";
	//String insertSql ="";
	if(!RecordSet.executeSql(insertSql)){
	    msg="3";
	    sURL="RdDeptAdd.jsp?method="+operation+"&subcompanyid1="+subcompanyid1+"&supdepid="+supdepid+"&id="+"&msg="+msg+"&from="+from;
        response.sendRedirect(sURL);
		return;
	}
	int id=0;
	String getMaxIdSql= "select id from HrmDepartment where subcompanyid1 = "+subcompanyid1
		+" and departmentname = '"+departmentname+"' and supdepid = "+supdepid;
	RecordSet.executeSql(getMaxIdSql);
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	  String info = "subcompanyid1 = "+subcompanyid1
			+" and departmentname = '"+departmentname+"' and supdepid = "+supdepid;
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("INSERT INTO HrmDepartment,"+info);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    //add by wjy
    //同步RTX端部门信息
    OrganisationCom.addDepartment(id);

    //OA与第三方接口单条数据同步方法开始
    HrmServiceManager.SynInstantDepartment(""+id,"1"); 
    //OA与第三方接口单条数据同步方法结束
    
    
    //同步部门数据到矩阵
    insertInto(id);
	if("1".equals(from)){
	    %>
		<SCRIPT LANGUAGE='JavaScript'>
			parent.getParentWindow(window).getNewDeptId('<%=id%>','<%=departmentname%>');
			window.parent.Dialog.close();
		</SCRIPT>
		<%
		return;
	}
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		parent.getParentWindow(window).getNewDeptId(<%=id%>,<%=supdepid%>);
		window.parent.Dialog.close();
	</SCRIPT>
	<%
    return;
 }
 else if(operation.equals("edit")){
	int id = Util.getIntValue(fu.getParameter("id"),0);

	/*
	* Added by Charoes Huang
	* 判断是否10级部门
	*/
	int supdepartmentid = supdepid;
	if(supdepartmentid > 0){
		if(ifDeptLevelEquals10(supdepartmentid)){
		    msg = "1";
		    sURL="RdDeptAdd.jsp?method="+operation+"&subcompanyid1="+subcompanyid1+"&supdepid="+supdepid+"&id="+id+"&msg="+msg;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentname",departmentname);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
			return;
		}
	}

	//RecordSet.executeProc("HrmDepartment_Update",para);
	
	String checkNameSql ="select count(*)  from HrmDepartment where subcompanyid1 = "+subcompanyid1
		+" and departmentname = '"+departmentname+"' and supdepid = "+supdepid +" and id != "+id+"";
	RecordSet.executeSql(checkNameSql);
	int flag= 0;
	if(RecordSet.next()){
		flag = RecordSet.getInt(1);
		if(flag >  0){
			msg="2";
			sURL="RdDeptAdd.jsp?method="+operation+"&subcompanyid1="+subcompanyid1+"&supdepid="+supdepid+"&id="+id+"&msg="+msg;
			response.sendRedirect(sURL);
			return;
		}
	}
	
	String insertSql = "update HrmDepartment set departmentname = '"+departmentname+"' where id ="+id+"";
	if(!RecordSet.executeSql(insertSql)){
		msg="3";
		sURL="RdDeptAdd.jsp?method="+operation+"&subcompanyid1="+subcompanyid1+"&supdepid="+supdepid+"&id="+id+"&msg="+msg;
		response.sendRedirect(sURL);
		return;
	}


	  String info = "subcompanyid1 = "+subcompanyid1
		+" and departmentname = '"+departmentname+"' and supdepid = "+supdepid;
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("update HrmDepartment,"+info);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

	//OA与第三方接口单条数据同步方法开始
    HrmServiceManager.SynInstantDepartment(""+id,"2"); 
    //OA与第三方接口单条数据同步方法结束
    
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		parent.getParentWindow(window).setEditDeptValue('<%=departmentname%>');
		window.parent.Dialog.close();
	</SCRIPT>
	<%
    return;
 }
%>