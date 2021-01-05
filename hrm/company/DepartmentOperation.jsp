<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.interfaces.email.CoreMailTestAPI" %>
<%@ page import="weaver.hrm.definedfield.HrmFieldComInfo" %>
<%@page import="weaver.hrm.common.DbFunctionUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
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

%>
<%
application.removeAttribute("organlist");//update for hrm broser,xiaofeng
FileUpload fu = new FileUpload(request);
String operation = Util.fromScreen(fu.getParameter("operation"),user.getLanguage());

String departmentmark = Util.fromScreen(fu.getParameter("departmentmark"),user.getLanguage());
String departmentname = Util.fromScreen(fu.getParameter("departmentname"),user.getLanguage());
String subcompanyid1 = Util.fromScreen(fu.getParameter("subcompanyid1"),user.getLanguage());
if(Util.getIntValue(subcompanyid1,0)<=0&&!operation.equals("delete")){
	subcompanyid1 = Util.fromScreen(fu.getParameter("subcompanyid1old"),user.getLanguage());
}
int supdepid = Util.getIntValue(fu.getParameter("supdepid"),0);
String showorder = Util.fromScreen(Util.null2s(fu.getParameter("showorder"),"0"),user.getLanguage());

if(Util.getIntValue(subcompanyid1,0)<=0&&!operation.equals("delete")) 
	throw new Exception("invalid subcompanyid:"+subcompanyid1);

String allsupdepid = "0";
String sURL="";
String departmentcode = Util.fromScreen(fu.getParameter("departmentcode"),user.getLanguage());
int coadjutant=Util.getIntValue(fu.getParameter("coadjutant"),0);  

if(!HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
	response.sendRedirect("/notice/noright.jsp");
	return  ;
}

CoreMailAPI coremailapi = CoreMailAPI.getInstance();
CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();

if(operation.equals("add")){
	/*
	* Added by Charoes Huang
	* 判断是否10级部门
	*/
	int supdepartmentid = supdepid;
	if(supdepartmentid > 0){
		if(ifDeptLevelEquals10(supdepartmentid)){
            sURL="HrmDepartmentAdd.jsp?isdialog=1&subcompanyid="+subcompanyid1+"&supdepid="+supdepid+"&msgid=56&departmentmark="+departmentmark+"&departmentname="+departmentname+"&showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
			return;
		}
	}

	if(!"".equals(departmentcode)){
	String sql2="select id from hrmdepartment where departmentcode = '" + departmentcode + "' ";
	RecordSet.executeSql(sql2);
	 if(RecordSet.next()){
          sURL="HrmDepartmentAdd.jsp?isdialog=1&subcompanyid="+subcompanyid1+"&supdepid="+supdepid+"&msgid=177";
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);

            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
         
        return;
     }
	}


   char separator = Util.getSeparator() ;
   //allsupdepid = DepartmentComInfo.getAllSupDepId(Util.getIntValue(supdepid))+supdepid+",";

	if(supdepid > 0){//当选择了上级部门的时候，需要更改当前部门的上级分部
		subcompanyid1 = DepartmentComInfo.getSubcompanyid1(supdepid+"");
	}
	String para =  departmentmark + separator + departmentname + separator +
	                supdepid+separator+allsupdepid+separator+subcompanyid1 + separator+ showorder+separator+coadjutant;
	RecordSet.executeProc("HrmDepartment_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	weaver.hrm.company.OrgOperationUtil OrgOperationUtil = new weaver.hrm.company.OrgOperationUtil();
	OrgOperationUtil.updateDepartmentLevel(""+id,"0");
	String sql3="update hrmdepartment set departmentcode = '" + departmentcode + "' ";
	
    HrmDeptFieldManager hrmDeptFieldManager = new HrmDeptFieldManager(5);
	hrmDeptFieldManager.editCustomData(fu,id);
	
	
	// add time 
	sql3+= ","+DbFunctionUtil.getInsertUpdateSetSql(RecordSet.getDBType(),user.getUID()) ;
	
	sql3+=" where id = "+id;
	RecordSet.executeSql(sql3);
	
	//xiaofeng
        int flag=RecordSet.getFlag();
	//System.out.println(flag);
        if(flag==2){
			sURL="/hrm/company/HrmDepartmentAdd.jsp?isdialog=1&subcompanyid="+subcompanyid1+"&supdepid="+supdepid+"&msgid=41";
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
            //response.sendRedirect("/hrm/company/HrmDepartmentAdd.jsp?msgid=41");
        return;
        }
        if(flag==3){
            sURL="/hrm/company/HrmDepartmentAdd.jsp?isdialog=1&subcompanyid="+subcompanyid1+"&supdepid="+supdepid+"&msgid=44";
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmDepartmentAdd.jsp?msgid=44");
        return;
        }

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Insert,"+para);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    //add by wjy
    //同步RTX端部门信息
    OrganisationCom.addDepartment(id);
    
    if(supdepid == 0) {
		coremailapi.synOrg(""+id, departmentname, "parent_org_unit_id=com_"+subcompanyid1+"&org_unit_name="+departmentname, "0");
		//testapi.synOrg(""+id, departmentname, "com_"+subcompanyid1, "0");
	} else {
		coremailapi.synOrg(""+id, departmentname, "parent_org_unit_id="+supdepid+"&org_unit_name="+departmentname, "0");
		//testapi.synOrg(""+id, departmentname, ""+supdepid, "0");
	}

    //OA与第三方接口单条数据同步方法开始
    HrmServiceManager.SynInstantDepartment(""+id,"1"); 
    //OA与第三方接口单条数据同步方法结束
    
    
    //同步部门数据到矩阵
    MatrixUtil.updateDepartmentData(""+id);
    //初始化应用分权
    new weaver.hrm.appdetach.AppDetachComInfo().initSubDepAppData();
    //response.sendRedirect("HrmCompany_frm.jsp?subcomid="+subcompanyid1+"&deptid="+id);
    String nodeid = "dept_"+subcompanyid1+"_"+id;
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		var parentPage = parent.location.href;
		if(parentPage.indexOf("HrmCompany_frm") > -1){
			parent.location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}else{
			location.href = "HrmDepartmentAdd.jsp?isclose=1";
		}
	</SCRIPT>
	<%
    return;
 }
 else if(operation.equals("edit")){
	int id = Util.getIntValue(fu.getParameter("id"),0);
	HrmFieldComInfo hrmFieldComInfo = new HrmFieldComInfo();
	String sql = "select * from HrmDepartment where id="+id;
	rs.writeLog(sql);
	rs.executeSql(sql);
	while(rs.next()){
	    if(!hrmFieldComInfo.getIsused("73").equals("1"))departmentmark = rs.getString("departmentmark");
	    if(!hrmFieldComInfo.getIsused("74").equals("1"))departmentname = rs.getString("departmentname");
        if(!hrmFieldComInfo.getIsused("75").equals("1"))subcompanyid1 = rs.getString("subcompanyid1");
        if(!hrmFieldComInfo.getIsused("76").equals("1"))supdepid = rs.getInt("supdepid");
        if(!hrmFieldComInfo.getIsused("77").equals("1"))coadjutant = rs.getInt("coadjutant");
        if(!hrmFieldComInfo.getIsused("78").equals("1"))showorder = rs.getString("showorder");
        //if(hfm.getIsUsed("79"))showid = rs.getString("showid");
        if(!hrmFieldComInfo.getIsused("80").equals("1"))departmentcode = rs.getString("departmentcode");
    }
	/*
	* Added by Charoes Huang
	* 判断是否10级部门
	*/
	int supdepartmentid = supdepid;
	if(supdepartmentid > 0){
		if(ifDeptLevelEquals10(supdepartmentid)){
            sURL="HrmDepartmentEdit.jsp?isdialog=1&subcompanyid="+subcompanyid1+"&supdepid="+supdepid+"&id="+id+"&msgid=56&departmentmark="+departmentmark+"&departmentname="+departmentname+"&showorder="+showorder;
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
		}
	}


	if(!"".equals(departmentcode)){
	String sql2="select id from hrmdepartment where departmentcode = '" + departmentcode + "' and  id !="+id;
	RecordSet.executeSql(sql2);
	 if(RecordSet.next()){
          sURL="HrmDepartmentEdit.jsp?isdialog=1&subcompanyid="+subcompanyid1+"&supdepid="+supdepid+"&id="+id+"&msgid=177";
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmDepartmentEdit.jsp?id="+id+"&msgid=41");
        return;
    }
	}

    char separator = Util.getSeparator() ;
	if(supdepartmentid > 0){//当选择了上级部门的时候，需要更改当前部门的上级分部
		subcompanyid1 = DepartmentComInfo.getSubcompanyid1(supdepartmentid+"");
	}
	String para = ""+id +separator+ departmentmark + separator + departmentname + separator +
					supdepartmentid+separator+allsupdepid+separator+subcompanyid1 + separator+ showorder+separator+coadjutant;
	RecordSet.executeProc("HrmDepartment_Update",para);
	
	String sql3="update hrmdepartment set departmentcode = '" + departmentcode + "' ";
	weaver.hrm.company.OrgOperationUtil OrgOperationUtil = new weaver.hrm.company.OrgOperationUtil();
	OrgOperationUtil.updateDepartmentLevel(""+id,"0");
	/*
	String sqlUpdateField="";
	rs3=FormFieldTransMethod.getDeptFieldRs();
	if(rs3!=null){
  	  while(rs3.next()){//取得部门所有开启的自定义字段
    	String idTemp=rs3.getString("id");
    	String fieldnameTemp=rs3.getString("fieldname");
    	int fieldlabelTemp=rs3.getInt("fieldlabel");
    	String fieldhtmltypeTemp=rs3.getString("fieldhtmltype");
    	String typeTemp=rs3.getString("type");
    	String viewtypeTemp=rs3.getString("viewtype");
    	if(fieldnameTemp!=null && !"".equals(fieldnameTemp)){
    	   String fieldnameValueTemp = fu.getParameter(fieldnameTemp);
    	   if("".equals(fieldnameValueTemp)|| "0".equals(fieldnameValueTemp)){
    	     sqlUpdateField+=" ,"+fieldnameTemp+"=null ";
    	   }else{
    	     sqlUpdateField+=" ,"+fieldnameTemp+"='"+Util.null2String(fu.getParameter(fieldnameTemp))+"' ";
    	   }  
    	}
      }
	}
	if(!"".equals(sqlUpdateField)){
	   sql3+=sqlUpdateField;
	}
	*/
	
  HrmDeptFieldManager hrmDeptFieldManager = new HrmDeptFieldManager(5);
	hrmDeptFieldManager.editCustomData(fu,id);
	
	// update time
	sql3 += ","+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID()) ;
	sql3+=" where id = "+id;	
    RecordSet.executeSql(sql3);

//xiaofeng
        int flag=RecordSet.getFlag();
	//System.out.println(flag);
        if(flag==2){
            sURL="/hrm/company/HrmDepartmentEdit.jsp?isdialog=1&id="+id+"&msgid=41";
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmDepartmentEdit.jsp?id="+id+"&msgid=41");
        return;
        }
        if(flag==3){
            sURL="/hrm/company/HrmDepartmentEdit.jsp?isdialog=1&id="+id+"&msgid=44";
            session.setAttribute("subcompanyid",subcompanyid1);
            session.setAttribute("supdepid",""+supdepid);
            session.setAttribute("departmentmark",departmentmark);
            session.setAttribute("departmentname",departmentname);
            session.setAttribute("showorder",""+showorder);
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmDepartmentEdit.jsp?id="+id+"&msgid=44");
        return;
        }
        
        ArrayList departmentlist = new ArrayList();
        //departmentlist.add(id+"");
        //rs.execute("select id from HrmDepartment where supdepid="+id);
        //while(rs.next()){
        //	int childdepartmenttmp = Util.getIntValue(rs.getString(1), 0);
        //	departmentlist.add(childdepartmenttmp+"");
        //	RecordSet.execute("update HrmDepartment set subcompanyid1="+subcompanyid1+" where id="+childdepartmenttmp);
        //}
        departmentlist = DepartmentComInfo.getAllChildDeptByDepId(departmentlist,id+"");
        departmentlist.add(id+"");
        
        for(int i=0;i<departmentlist.size();i++){
        	String listdepartmenttemp = (String)departmentlist.get(i);
        	RecordSet.execute("update HrmDepartment set subcompanyid1="+subcompanyid1+" where id="+listdepartmenttemp);
	        //TD16048改为逐条修改
			rs.execute("select id, subcompanyid1,managerid,seclevel,managerstr from hrmresource where departmentid="+listdepartmenttemp);
	        while(rs.next()){
	        	int resourceid_tmp = Util.getIntValue(rs.getString(1), 0);
	        	int oldsubcompanyid1 = Util.getIntValue(rs.getString(2), 0);
	        	int oldmanagerid = Util.getIntValue(rs.getString(3), 0);
	        	int seclevel = Util.getIntValue(rs.getString(4), 0);
	        	String oldmanagerstr = Util.null2String(rs.getString(5));
	        	RecordSet.execute("update hrmresource set subcompanyid1="+subcompanyid1+" where id="+resourceid_tmp);
	        	para = ""+resourceid_tmp + separator + listdepartmenttemp + separator + subcompanyid1 + separator + oldmanagerid + separator + seclevel + separator + oldmanagerstr + separator + listdepartmenttemp + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + seclevel + separator + oldmanagerstr + separator + "1";
	        	RecordSet.executeProc("HrmResourceShare",para);
	        }
	      //add by wjy
	        //同步RTX端部门信息
	        OrganisationCom.editDepartment(Util.getIntValue(listdepartmenttemp));
        }

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Update,"+para);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	DepartmentComInfo.removeCompanyCache();
	ResourceComInfo.removeResourceCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    if(supdepid == 0) {
		coremailapi.synOrg(""+id, departmentname, "parent_org_unit_id=com_"+subcompanyid1+"&org_unit_name="+departmentname, "0");
		//testapi.synOrg(""+id, departmentname, "com_"+subcompanyid1, "0");
	} else {
		coremailapi.synOrg(""+id, departmentname, "parent_org_unit_id="+supdepid+"&org_unit_name="+departmentname, "0");
		//testapi.synOrg(""+id, departmentname, ""+supdepid, "0");
	}

	//OA与第三方接口单条数据同步方法开始
    HrmServiceManager.SynInstantDepartment(""+id,"2"); 
    //OA与第三方接口单条数据同步方法结束
    
    //同步部门数据到矩阵
    MatrixUtil.updateDepartmentData(""+id);

    String nodeid = "dept_"+subcompanyid1+"_"+id;
    response.sendRedirect("/hrm/company/HrmDepartmentEdit.jsp?isclose=1&subcomid="+subcompanyid1+"&id="+id);
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		var parentPage = parent.location.href;
		alert(location.href);
		alert(parentPage.indexOf("HrmCompany_frm"));
		if(parentPage.indexOf("HrmCompany_frm") > -1){
			parent.location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}else{
			location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}
	</SCRIPT>
	<%
    return;
    
 }
 else if(operation.equals("delete")){
	boolean canDelete = true;
	int id = Util.getIntValue(fu.getParameter("id"),0);
	
	RecordSet.executeSql("select departmentname, supdepid, subcompanyid1 from HrmDepartment  where id = " + id);
	if(RecordSet.next()) {
		departmentname = Util.null2String(RecordSet.getString("departmentname"));
		supdepid = Util.getIntValue(RecordSet.getString("supdepid"), 0);
		subcompanyid1 = Util.null2String(RecordSet.getString("subcompanyid1"));
	}
	
     char separator = Util.getSeparator() ;
	String para = ""+id;
/*
    原有的判断数据中心删除部门去掉
    String sql = "select count(id) from HrmCostcenter where departmentid = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} 

	String sql = "select count(id) from HrmJobTitles where jobdepartmentid ="+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
        sURL="/hrm/company/HrmDepartmentEdit.jsp?isdialog=1&id="+id+"&msgid=20";
        session.setAttribute("subcompanyid",subcompanyid1);
        session.setAttribute("supdepid",""+supdepid);
        session.setAttribute("departmentmark",departmentmark);
        session.setAttribute("departmentname",departmentname);
        session.setAttribute("showorder",""+showorder);
        //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
        response.sendRedirect(sURL);
        //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
        return ;
	}*/

/*
    原有的判断部门工作时间删除部门去掉
	 sql = "select count(id) from HrmSchedule where relatedid ="+id+" and scheduletype = 1";
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

/*
    原有的判断部门下面人力资源删除部门去掉，由控制岗位来实现
	 sql = "select count(id) from HrmResource where departmentid ="+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

	if(canDelete){
	    RecordSet.executeProc("HrmDepartment_Delete",para);
        //add by wjy
        //同步RTX端部门信息
        OrganisationCom.deleteDepartment(id);
        
        if(supdepid == 0) {
    		coremailapi.synOrg(""+id, departmentname, "parent_org_unit_id=com_"+subcompanyid1+"&org_unit_name="+departmentname, "1");
    		//testapi.synOrg(""+id, departmentname, "com_"+subcompanyid1, "1");
    	} else {
    		coremailapi.synOrg(""+id, departmentname, "parent_org_unit_id="+supdepid+"&org_unit_name="+departmentname, "1");
    		//testapi.synOrg(""+id, departmentname, ""+supdepid, "1");
    	}

		//OA与第三方接口单条数据同步方法开始
        HrmServiceManager.SynInstantDepartment(""+id,"3");
        //OA与第三方接口单条数据同步方法结束
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Delete,"+para);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    String supid=DepartmentComInfo.getDepartmentsupdepid(""+id);
	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    //同步部门数据到矩阵
    MatrixUtil.updateDepartmentData(""+id);
    
    String nodeid = "";
    
    //response.sendRedirect("/hrm/company/HrmDepartmentEdit.jsp?isclose=1&subcomid="+subcompanyid1+"&deptid="+supid);
    %>
	<SCRIPT LANGUAGE='JavaScript'>
		var parentPage = parent.location.href;
		if(parentPage.indexOf("HrmDepartmentDsp") > -1){
			parent.parent.location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}else{
			location.href = "HrmCompany_frm.jsp?nodeid=<%=nodeid%>&subcomid=<%=subcompanyid1%>&deptid=<%=id%>";
		}
	</SCRIPT>
	<%
    return;    
 }
%>
