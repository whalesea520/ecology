
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.StaticObj"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.interfaces.email.CoreMailTestAPI" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<%
    CoreMailAPI coremailapi = CoreMailAPI.getInstance();
	CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
	String cancelFlag = request.getParameter("cancelFlag");
	int deptorsupid = Util.getIntValue(request.getParameter("deptorsupid"));
	int userid = Util.getIntValue(request.getParameter("userid"));
	String operation = Util.null2String(request.getParameter("operation"));
	String deptorsubname = "";
	String sqlname = "";
	if ("subcompany".equals(operation)) {
	    int supsubcomid = 0;
	    sqlname = "select subcompanyname, supsubcomid from HrmSubCompany where id = "+deptorsupid;
	    rs.executeSql(sqlname);
	    if(rs.next()) {
			deptorsubname = rs.getString("subcompanyname");
			supsubcomid = Util.getIntValue(rs.getString("supsubcomid"), 0);
		}
	    
		if ("1".equals(cancelFlag)) {
			
			RecordSet.executeSql("select id from HrmSubCompany where canceled ='1' and id = (select supsubcomid from HrmSubCompany where id ="+deptorsupid+")");
			if(RecordSet.next()) {
				out.println("0");
			} else {
				RecordSet.executeSql("update HrmSubCompany set canceled = '0' where id ="+ deptorsupid);
				SubCompanyComInfo.removeCompanyCache();
				
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("11");
				SysMaintenanceLog.setOperateItem("11");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				OrganisationCom.addSubCompany(deptorsupid);//分部解封时同步到RTX
				if(supsubcomid == 0) {
					coremailapi.synOrg("com_"+deptorsupid, deptorsubname, "org_unit_name="+deptorsubname, "0");
					//testapi.synOrg("com_"+deptorsupid, deptorsubname, "", "0");
				} else {
					coremailapi.synOrg("com_"+deptorsupid, deptorsubname, "parent_org_unit_id=com_"+supsubcomid+"&org_unit_name="+deptorsubname, "0");
					//testapi.synOrg("com_"+deptorsupid, deptorsubname, "com_"+supsubcomid, "0");
				}

				//OA与第三方接口单条数据同步方法开始
				HrmServiceManager.SynInstantSubCompany(""+deptorsupid,"1"); 
				//OA与第三方接口单条数据同步方法结束
				
				out.println("1");
			}
		} else {
			String result = "";
			
			String sqlstr = "select id from hrmdepartment where (canceled = '0' or canceled is null) "
			+ " and exists (select 1 from hrmsubcompany b where hrmdepartment.subcompanyid1 = b.id and b.id ="+ deptorsupid+ ")";
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
				//分部下存在部门
				result = "0";
			}
			if(result.equals("")){
				sqlstr = " select id from hrmsubcompany where (canceled = '0' or canceled is null) and id in (select id from hrmsubcompany where supsubcomid ="+ deptorsupid + ")";
				RecordSet.executeSql(sqlstr);
				if (RecordSet.next()) {
					//分部下存在下级分部
					result = "2";
				}
			}
			if(result.equals("")){
				RecordSet.executeSql("update HrmSubCompany set canceled = '1' where id ="+ deptorsupid);
				SubCompanyComInfo.removeCompanyCache();
				
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("10");
				SysMaintenanceLog.setOperateItem("11");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				OrganisationCom.deleteSubCompany(deptorsupid);//分部封存时同步到RTX
				if(supsubcomid == 0) {
					coremailapi.synOrg("com_"+deptorsupid, deptorsubname, "org_unit_name="+deptorsubname, "1");
					//testapi.synOrg("com_"+deptorsupid, deptorsubname, "", "1");
				} else {
					coremailapi.synOrg("com_"+deptorsupid, deptorsubname, "parent_org_unit_id=com_"+supsubcomid+"&org_unit_name="+deptorsubname, "1");
					//testapi.synOrg("com_"+deptorsupid, deptorsubname, "com_"+supsubcomid, "1");
				}

				//OA与第三方接口单条数据同步方法开始
				HrmServiceManager.SynInstantSubCompany(""+deptorsupid,"3"); 
				//OA与第三方接口单条数据同步方法结束
				
				result = "1";
			}
			out.println(result);
		}
		//同步分部数据到矩阵
    	MatrixUtil.updateSubcompayData(""+deptorsupid);
	} else {
	    String supdepid = "";
		String subcompanyid1 = "";
	    sqlname = "select departmentname, supdepid, subcompanyid1 from hrmdepartment where id = "+deptorsupid;
	    rs.executeSql(sqlname);
	    if(rs.next()) {
	    	deptorsubname = rs.getString("departmentname");
	    	supdepid = Util.null2String(rs.getString("supdepid"));
	    	subcompanyid1 = Util.null2String(rs.getString("subcompanyid1"));
	    }
	    
		if ("1".equals(cancelFlag)) {
			RecordSet.executeSql("select id from HrmSubCompany where canceled ='1' and id = (select subcompanyid1 from hrmdepartment where id = "+deptorsupid+")");
			if(RecordSet.next()){
				out.println("0");
			} else {
				RecordSet.executeSql("select id from hrmdepartment where canceled ='1' and id = (select supdepid from hrmdepartment where id = "+deptorsupid+")");
				if(RecordSet.next()) {
					out.println("2");
				} else {
					RecordSet.executeSql("update hrmdepartment set canceled = '0' where id ="+ deptorsupid);
					DepartmentComInfo.removeCompanyCache();
		
					SysMaintenanceLog.resetParameter();
					SysMaintenanceLog.setRelatedId(deptorsupid);
					SysMaintenanceLog.setRelatedName(deptorsubname);
					SysMaintenanceLog.setOperateType("11");
					SysMaintenanceLog.setOperateItem("12");
					SysMaintenanceLog.setOperateUserid(userid);
					SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
					SysMaintenanceLog.setSysLogInfo();
					
					OrganisationCom.addDepartment(deptorsupid);//部门解封时同步到RTX
					
					if("0".equals(supdepid)) {
						coremailapi.synOrg(""+deptorsupid, deptorsubname, "parent_org_unit_id=com_"+subcompanyid1+"&org_unit_name="+deptorsubname, "0");
						//testapi.synOrg(""+deptorsupid, deptorsubname, "com_"+subcompanyid1, "0");
				    } else {
				    	coremailapi.synOrg(""+deptorsupid, deptorsubname, "parent_org_unit_id="+supdepid+"&org_unit_name="+deptorsubname, "0");
				    	//testapi.synOrg(""+deptorsupid, deptorsubname, ""+supdepid, "0");
				    }

					//OA与第三方接口单条数据同步方法开始
					HrmServiceManager.SynInstantDepartment(""+deptorsupid,"1");
					//OA与第三方接口单条数据同步方法结束
		
					out.println("1");
				}
			}
		} else {
			String result = "";
			String sqlstr = "select id from hrmresource where status in (0,1,2,3)"
			+ " and EXISTS (select 1 from hrmdepartment b where hrmresource.departmentid=b.id and b.id = "
			+ deptorsupid +")";
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
				//部门下有在职的人员
				result="0";
			} 
			if(result.equals("")){
				sqlstr = " select id from hrmdepartment where (canceled = '0' or canceled is null) and id in (select id from hrmdepartment where supdepid = "
							 + deptorsupid + ")";
				RecordSet.executeSql(sqlstr);
				if (RecordSet.next()) {
					//部门存在下级部门
					result="2";
				} 
			}
			if(result.equals("")){
				RecordSet.executeSql("update hrmdepartment set canceled = '1' where id ="+ deptorsupid);
				DepartmentComInfo.removeCompanyCache();
		
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("10");
				SysMaintenanceLog.setOperateItem("12");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				OrganisationCom.deleteDepartment(deptorsupid);//部门封存时同步到RTX
				if("0".equals(supdepid)) {
					coremailapi.synOrg(""+deptorsupid, deptorsubname, "parent_org_unit_id=com_"+subcompanyid1+"&org_unit_name="+deptorsubname, "1");
					//testapi.synOrg(""+deptorsupid, deptorsubname, "com_"+subcompanyid1, "1");
			    } else {
			    	coremailapi.synOrg(""+deptorsupid, deptorsubname, "parent_org_unit_id="+supdepid+"&org_unit_name="+deptorsubname, "1");
			    	//testapi.synOrg(""+deptorsupid, deptorsubname, ""+supdepid, "1");
			    }

				//OA与第三方接口单条数据同步方法开始
				HrmServiceManager.SynInstantDepartment(""+deptorsupid,"3");
				//OA与第三方接口单条数据同步方法结束
				result = "1";
			}
			
			out.println(result);
		}
		//同步部门数据到矩阵
    	MatrixUtil.updateDepartmentData(""+deptorsupid);
	}
	RecordSet.executeSql("update orgchartstate set needupdate=1");
%>
