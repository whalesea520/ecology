<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*,weaver.hrm.common.*" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.interfaces.email.CoreMailTestAPI" %>
<%@ page import="weaver.hrm.definedfield.HrmFieldComInfo" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<%!
/*
*Check if the subcompany level equals 10, if true,this subcompany can't have sub subcompany
*
*/
private boolean ifDeptLevelEquals10(int subcompanyid){
	boolean isEquals10 = false;
    RecordSet rs = new RecordSet();

	String sqlStr ="Select COUNT(d1.id) from Hrmsubcompany d1,Hrmsubcompany d2,Hrmsubcompany d3,Hrmsubcompany d4,Hrmsubcompany d5,Hrmsubcompany d6,Hrmsubcompany d7,Hrmsubcompany d8,Hrmsubcompany d9 WHERE   d1.supsubcomid = d2.id and d2.supsubcomid = d3.id and d3.supsubcomid = d4.id and d4.supsubcomid = d5.id and d5.supsubcomid = d6.id and d6.supsubcomid = d7.id and d7.supsubcomid = d8.id and d8.supsubcomid = d9.id and d1.id <> d2.id and d1.id ="+subcompanyid ;

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
  int companyid = 1;
  FileUpload fu = new FileUpload(request);
//int companyid = Util.getIntValue(fu.getParameter("companyid"));
String operation = Util.fromScreen(fu.getParameter("operation"),user.getLanguage());
String subcompanyname = Util.fromScreen(fu.getParameter("subcompanyname"),user.getLanguage());
String subcompanydesc = Util.fromScreen(fu.getParameter("subcompanydesc"),user.getLanguage());
int supsubcomid=Util.getIntValue(fu.getParameter("supsubcomid"),0);
String url=Util.null2String(fu.getParameter("url"));
int showorder=Util.getIntValue(fu.getParameter("showorder"),0);
String sURL="";
String subcompanycode = Util.fromScreen(fu.getParameter("subcompanycode"),user.getLanguage());
int limitUsers = Tools.parseToInt(Util.fromScreen(fu.getParameter("limitUsers"),user.getLanguage()), 0);
limitUsers = limitUsers < 0 ? 0 : limitUsers;

CoreMailAPI coremailapi = CoreMailAPI.getInstance();
CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();

if(!HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return  ;
}


if(operation.equals("addsubcompany")){
     char separator = Util.getSeparator() ;

	/*
	* 判断是否10级分部
	*/
	if(supsubcomid > 0){
		if(ifDeptLevelEquals10(supsubcomid)){
      sURL="HrmSubCompanyAdd.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&msgid=56";
      //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
      session.setAttribute("subcompanyname",subcompanyname);
      session.setAttribute("subcompanydesc",subcompanydesc);
      session.setAttribute("url",url);
      session.setAttribute("showorder",""+showorder);
      response.sendRedirect(sURL);
      //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
		}
	}

   if(!"".equals(subcompanycode)){
	String sql2="select id from HrmSubCompany where subcompanycode = '" + subcompanycode + "' ";
	RecordSet.executeSql(sql2);
	 if(RecordSet.next()){
            sURL="HrmSubCompanyAdd.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&msgid=176";
          session.setAttribute("subcompanyname",subcompanyname);
      session.setAttribute("subcompanydesc",subcompanydesc);
      session.setAttribute("url",url);
      session.setAttribute("showorder",""+showorder);
      response.sendRedirect(sURL);
      //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
     }
	}


	String para = subcompanyname + separator + subcompanydesc + separator + companyid+ separator + supsubcomid+ separator + url+ separator + showorder;
	RecordSet.executeProc("HrmSubCompany_Insert",para);

	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	
	String sql3="update HrmSubCompany set subcompanycode = '" + subcompanycode + "'";
	if(user.getUID() == 1) sql3 += ", limitUsers = "+limitUsers;
	
    HrmDeptFieldManager hrmDeptFieldManager = new HrmDeptFieldManager(4);
	hrmDeptFieldManager.editCustomData(fu,id);
	
	sql3 += ","+DbFunctionUtil.getInsertUpdateSetSql(RecordSet.getDBType(),user.getUID()) ;
	
	sql3+=" where id = "+id;
	
	
	//RecordSet.executeSql("update HrmSubCompany set subcompanycode = '" + subcompanycode + "' where id = " + id);
	RecordSet.executeSql(sql3);
	int flag=RecordSet.getFlag();
	//System.out.println(flag);
        if(flag==2){
            sURL="/hrm/company/HrmSubCompanyAdd.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&msgid=40";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyAdd.jsp?msgid=40");
        return;
        }
        if(flag==3){
            sURL="/hrm/company/HrmSubCompanyAdd.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&msgid=43";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
		    session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyAdd.jsp?msgid=43");
        return;
        }

    //更新机构权限数据：新增加的分部默认继承上级分部的所有机构权限。
    para = String.valueOf(id) + separator + String.valueOf(supsubcomid);
	RecordSet.executeProc("HrmRoleSRT_AddByNewSc",para);

	//更新左侧菜单，新增的分部继承上级分部的左侧菜单
	String strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
	if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
	String strSql="insert into leftmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+id+",2,locked,lockedbyid,usecustomname,customname,customname_e from leftmenuconfig "+strWhere;
	//System.out.println(strSql);
	RecordSet.executeSql(strSql);



	//更新顶部菜单，新增的分部继承上级分部的顶部菜单
	strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
	if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
	strSql="insert into mainmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+id+",2,locked,lockedbyid,usecustomname,customname,customname_e from mainmenuconfig "+strWhere;
	//System.out.println(strSql);
	RecordSet.executeSql(strSql);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(subcompanyname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmSubCompany_Insert,"+para);
      SysMaintenanceLog.setOperateItem("11");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		 SubCompanyComInfo.removeCompanyCache();
     RecordSet.executeSql("update orgchartstate set needupdate=1");
	weaver.hrm.company.OrgOperationUtil OrgOperationUtil = new weaver.hrm.company.OrgOperationUtil();
	OrgOperationUtil.updateSubcompanyLevel(""+id,"0");
     //add by wjy
    //同步RTX端的分部信息.
    OrganisationCom.addSubCompany(id);
    
    if(supsubcomid > 0) {
		coremailapi.synOrg("com_"+id, subcompanyname, "parent_org_unit_id=com_"+supsubcomid+"&org_unit_name="+subcompanyname, "0");
		//testapi.synOrg("com_"+id, subcompanyname, "com_"+supsubcomid, "0");
	} else {
		coremailapi.synOrg("com_"+id, subcompanyname, "org_unit_name="+subcompanyname, "0");
		//testapi.synOrg("com_"+id, subcompanyname, "", "0");
	}

	//OA与第三方接口单条数据同步方法开始
	HrmServiceManager.SynInstantSubCompany(""+id,"1"); 
	//OA与第三方接口单条数据同步方法结束
	
	//同步分部数据到矩阵
    MatrixUtil.updateSubcompayData(""+id);
  //初始化应用分权
    new weaver.hrm.appdetach.AppDetachComInfo().initSubDepAppData();
    
     response.sendRedirect("HrmSubCompanyAdd.jsp?isDialog=1&isclose=1&subcomid="+id);
 }
else if(operation.equals("editsubcompany")){
	char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(fu.getParameter("id"));
	HrmFieldComInfo hrmFieldComInfo = new HrmFieldComInfo();
	String sql = "select * from HrmSubCompany where id="+id;
	RecordSet rs = new RecordSet();
	rs.executeSql(sql);
	rs.writeLog("测试sql："+sql);
	while(rs.next()){
		if(!hrmFieldComInfo.getIsused("67").equals("1"))subcompanyname = rs.getString("subcompanyname");
		if(!hrmFieldComInfo.getIsused("68").equals("1"))subcompanydesc = rs.getString("subcompanydesc");
		if(!hrmFieldComInfo.getIsused("69").equals("1"))supsubcomid = rs.getInt("supsubcomid");
		if(!hrmFieldComInfo.getIsused("70").equals("1"))url = rs.getString("url");
		if(!hrmFieldComInfo.getIsused("71").equals("1"))showorder = rs.getInt("showorder");
		if(!hrmFieldComInfo.getIsused("72").equals("1"))subcompanycode = rs.getString("subcompanycode");
		if(!hrmFieldComInfo.getIsused("84").equals("1"))limitUsers = rs.getInt("limitUsers");
	}
	/*
	* 判断是否10级分部
	*/
	if(supsubcomid > 0){
		if(ifDeptLevelEquals10(supsubcomid)){
            sURL="/hrm/company/HrmSubCompanyEdit.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&id="+id+"&msgid=56";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
		}
	}

		if(!"".equals(subcompanycode)){
	String sql2="select id from HrmSubCompany where subcompanycode = '" + subcompanycode + "' and  id !="+id;
	RecordSet.executeSql(sql2);
	 if(RecordSet.next()){
           sURL="/hrm/company/HrmSubCompanyEdit.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&id="+id+"&msgid=176";
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&message=1");
			return;
    }
	}

	String para = ""+id + separator + subcompanyname + separator + subcompanydesc + separator + companyid+ separator + supsubcomid+ separator + url+ separator + showorder;
	RecordSet.executeProc("HrmSubCompany_Update",para);
	int flag=RecordSet.getFlag();
	

	String sql3="update HrmSubCompany set subcompanycode = '" + subcompanycode + "'";
	if(user.getUID() == 1) sql3 += ", limitUsers = "+limitUsers;
	
	//update time
	sql3 += ","+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID()) ;
	
	sql3+=" where id = "+id;
    //System.out.println(">>>>>>>>>>>>>>>>>>>>分部编辑 sql3="+sql3);	
	
	//RecordSet.executeSql("update HrmSubCompany set subcompanycode = '" + subcompanycode + "' where id = " + id);
	RecordSet.executeSql(sql3);

  HrmDeptFieldManager hrmDeptFieldManager = new HrmDeptFieldManager(4);
	hrmDeptFieldManager.editCustomData(fu,id);

	if(flag==2){
		sURL="/hrm/company/HrmSubCompanyEdit.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&id="+id+"&msgid=40";
		//sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
		session.setAttribute("subcompanyname",subcompanyname);
		session.setAttribute("subcompanydesc",subcompanydesc);
		session.setAttribute("url",url);
		session.setAttribute("showorder",""+showorder);
		response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyEdit.jsp?id="+id+"&msgid=40");
        return;
	}
	if(flag==3){
		sURL="/hrm/company/HrmSubCompanyEdit.jsp?isdialog=1&companyid="+companyid+"&supsubcomid="+supsubcomid+"&id="+id+"&msgid=43";
		//sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
		session.setAttribute("subcompanyname",subcompanyname);
		session.setAttribute("subcompanydesc",subcompanydesc);
		session.setAttribute("url",url);
		session.setAttribute("showorder",""+showorder);
		response.sendRedirect(sURL);
        //response.sendRedirect("/hrm/company/HrmSubCompanyEdit.jsp?id="+id+"&msgid=43");
        return;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(subcompanyname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmSubCompany_Update,"+para);
	SysMaintenanceLog.setOperateItem("11");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	SubCompanyComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");
	weaver.hrm.company.OrgOperationUtil OrgOperationUtil = new weaver.hrm.company.OrgOperationUtil();
	OrgOperationUtil.updateSubcompanyLevel(""+id,"0");
    //add by wjy
    //同步RTX端的分部信息.
    OrganisationCom.editSubCompany(id);
    
    if(supsubcomid > 0) {
		coremailapi.synOrg("com_"+id, subcompanyname, "parent_org_unit_id=com_"+supsubcomid+"&org_unit_name="+subcompanyname, "0");
		//testapi.synOrg("com_"+id, subcompanyname, "com_"+supsubcomid, "0");
	} else {
		coremailapi.synOrg("com_"+id, subcompanyname, "org_unit_name="+subcompanyname, "0");
		//testapi.synOrg("com_"+id, subcompanyname, "", "0");
	}

    //OA与第三方接口单条数据同步方法开始
	HrmServiceManager.SynInstantSubCompany(""+id,"2"); 
	//OA与第三方接口单条数据同步方法结束
	
	//同步分部数据到矩阵
    MatrixUtil.updateSubcompayData(""+id);

	response.sendRedirect("HrmSubCompanyEdit.jsp?isclose=1&id="+id+"&subcomid="+id);
}else if(operation.equals("deletesubcompany")){
	char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(fu.getParameter("id"));
  	
  	RecordSet rs = new RecordSet();
	rs.executeSql("select subcompanyname, supsubcomid from HrmSubCompany where id = " + id);
	if(rs.next()) {
		subcompanyname = Util.null2String(rs.getString("subcompanyname"));
		supsubcomid = Util.getIntValue(rs.getString("supsubcomid"), 0);
	}
  	
	String para = ""+id;
	RecordSet.executeProc("HrmSubCompany_Delete",para);

    //更新分级管理数据至默认分部
    RecordSet.executeSql("select detachable,dftsubcomid from SystemSet");
    String detachable = "";
    String dftsubcomid = "";
    if(RecordSet.next()){
    	detachable = Util.null2String(RecordSet.getString("detachable"));
        dftsubcomid = Util.null2String(RecordSet.getString("dftsubcomid"));
    }
    if(detachable.equals("1")&&!dftsubcomid.equals("")&&!dftsubcomid.equals("0")){
        //RecordSet.executeProc("SystemSet_DftSCUpdate",""+dftsubcomid);
        RecordSet rsupdate = new RecordSet();
    	 String updatesql = "update HrmRoles set subcompanyid="+dftsubcomid+" "+
   	  "where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  ";
    	 rsupdate.executeSql(updatesql);
	 updatesql ="update HrmContractTemplet set subcompanyid="+dftsubcomid+" "+
		  "where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)  ";
	 rsupdate.executeSql(updatesql);
	 updatesql =" update HrmContractType set subcompanyid="+dftsubcomid+" "+
		  "where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany) ";
	 rsupdate.executeSql(updatesql);
	 updatesql ="update HrmCareerApply set subCompanyId="+dftsubcomid+" "+
		  "where subCompanyId is null or subCompanyId=0 or subCompanyId=-1 or subCompanyId not in (select id from hrmsubcompany)  ";
	 rsupdate.executeSql(updatesql);
    }

	//add by wjy
	//同步RTX端的分部信息.
	  //RecordSet rs = new RecordSet();
     rs.executeSql("select count(id) from HrmDepartment where subcompanyid1 ="+id); 
     if(rs.next()){
          if(rs.getInt(1)>0){
             logger.info("subcompany delete fail");
          }else{
               OrganisationCom.deleteSubCompany(id);
               
               if(supsubcomid > 0) {
				    coremailapi.synOrg("com_"+id, subcompanyname, "parent_org_unit_id=com_"+supsubcomid+"&org_unit_name="+subcompanyname, "1");
				    //testapi.synOrg("com_"+id, subcompanyname, "com_"+supsubcomid, "1");
				} else {
					coremailapi.synOrg("com_"+id, subcompanyname, "org_unit_name="+subcompanyname, "1");
					//testapi.synOrg("com_"+id, subcompanyname, "", "1");
				}

			   //OA与第三方接口单条数据同步方法开始
			   HrmServiceManager.SynInstantSubCompany(""+id,"3"); 
			   //OA与第三方接口单条数据同步方法结束
          }
     }

	if(RecordSet.next()){
		if(RecordSet.getString(1).equals("20")){
            sURL="/hrm/company/HrmSubCompanyList.jsp?id="+id;
            //sURL=new String(sURL.getBytes("GBK"),"ISO8859_1");
            session.setAttribute("subcompanyname",subcompanyname);
            session.setAttribute("subcompanydesc",subcompanydesc);
            session.setAttribute("url",url);
            session.setAttribute("showorder",""+showorder);
            response.sendRedirect(sURL);
            //response.sendRedirect("HrmSubCompanyEdit.jsp?id="+id+"&msgid=20");
			return ;
		}
	}
	else {
	    SubCompanyComInfo.removeCompanyCache();
 	    //response.sendRedirect("HrmSubCompanyEdit.jsp?isclose=1");
		//return ;
	}


      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(subcompanyname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmSubCompany_Delete,"+para);
      SysMaintenanceLog.setOperateItem("11");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    String sql="update hrmsubcompany set supsubcomid=0 where supsubcomid="+id;
    RecordSet.executeSql(sql);
	SubCompanyComInfo.removeCompanyCache();

    RecordSet.executeSql("update orgchartstate set needupdate=1");

	//同步分部数据到矩阵
    MatrixUtil.updateSubcompayData(""+id);
	
		response.sendRedirect("HrmSubCompanyList.jsp?isDel=1&id="+id);
}
%>