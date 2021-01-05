<%@page import="weaver.rtx.OrganisationComRunnable"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="org.json.JSONObject"%>
 <%@ include file="/systeminfo/init_wev8.jsp" %>

<%@page import="weaver.file.Prop"%>
<%@page import="weaver.ldap.LdapUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<jsp:useBean id="LN" class="ln.LN" scope="page" />
<%
	int userid=user.getUID();
	String _currentDate = weaver.common.DateUtil.getCurrentDate();
	String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	LdapUtil ldap=LdapUtil.getInstance();
	String method = request.getParameter("method");
	String para = "";
	char separator = Util.getSeparator() ;
	
	if(!HrmUserVarify.checkUserRight("HrmResourceSys:Mgr",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	if(method.equals("save")){
		String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage()) ;
		String subcompanyid1 = Util.fromScreen2(request.getParameter("subcompanyid1"),user.getLanguage());
		
		RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
		String checkSysValidate = Util.null2String(settings.getCheckSysValidate());
		
		if("1".equals(checkSysValidate)){
			String validatecode = Util.fromScreen2(request.getParameter("validatecode"),user.getLanguage());
	       	String validateRand=Util.null2String((String)request.getSession(true).getAttribute("validateRand"));
			
	         if(!validateRand.toLowerCase().equals(validatecode.trim().toLowerCase())){
		  		response.sendRedirect("/hrm/resource/HrmResourceSys.jsp?message=2&departmentid="+departmentid+"&subcompanyid1="+subcompanyid1);
		  		return;
	         }
		}
		int totaldetail =  Util.getIntValue(request.getParameter("tableMax"),0);
		
	
	if(LN.CkHrmnum() > 0){
  		response.sendRedirect("/hrm/resource/HrmResourceSys.jsp?message=1");
  		return;
	}
	String[] ids = request.getParameterValues("id");
	String[] dsporders = request.getParameterValues("dsporder");
	String[] loginids = request.getParameterValues("loginid");
	//String[] passwords = request.getParameterValues("password");
	String[] seclevels = request.getParameterValues("seclevel");
	String[] emails = request.getParameterValues("email");
	String[] managerids = request.getParameterValues("managerid");
	//String[] departmentids = request.getParameterValues("departmentid");
	String[] jobtitles = request.getParameterValues("jobtitle");
	String[] usbstate = request.getParameterValues("usbstate");
	String[] needusbs = request.getParameterValues("needusb");
	
	MD5 md5 = new MD5();
	for(int i=0;ids!=null&&i<ids.length;i++){
		String id = ids[i];
		String dsporder = dsporders[i];
		String loginid = loginids[i];
		//String password = passwords[i];
		String seclevel = seclevels[i];
		String email = emails[i];
  	    String jobtitle = Util.null2String(jobtitles[i]) ;
  	 
  	    String isadaccount="";
  	    String isadaccountsql="select isadaccount from hrmresource  where id="+id;
  	    RecordSet.executeSql(isadaccountsql) ;
  	    if(RecordSet.next()){
  		isadaccount=Util.null2String(RecordSet.getString("isadaccount"));
  	    }
  	 
		String sql =  " update hrmresource set dsporder="+dsporder+", loginid ='"+loginid+"', jobtitle = "+jobtitle+", " 
							 +  " seclevel="+seclevel+", email='"+email+"', lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"'";
		if(usbstate!=null){
			sql +=", usbstate="+usbstate[i];
		}
		if(needusbs!=null){	
			sql +=", needusb="+usbstate[i];
		}			
		//是否需要更新密码
		//if(!password.equals("qiwuien")&&!isadaccount.equals("1")){
		//	sql += ", password = '"+md5.getMD5ofStr(password)+"'";
		//}
		
		sql +=  " where id="+id;
		RecordSet.executeSql(sql) ;

		//同步RTX端的用户信息.
		boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
		if(checkrtxuser){   //存在就编辑，不存在就新增
			OrganisationCom.editUser(Integer.parseInt(id));//编辑
		} else {
			OrganisationCom.addUser(Integer.parseInt(id));//新增
		}
	}
	
	
  for(int i=0;ids!=null&&i<ids.length;i++){
  	String jobtitle = Util.null2String(jobtitles[i]) ;
  	//String password = passwords[i];
  	String loginid = loginids[i];
  	String isADAccount = "";
		String managerid = managerids == null ? "" : Util.null2String(managerids[i]) ;
		if(managerid.indexOf(",")>0) //前台选了多个上级
			managerid=managerid.substring(managerid.lastIndexOf(",")+1,managerid.length());
    String id = Util.null2String(ids[i]) ;
		String olddepartmentid = "";
		String oldmanagerid = "";
		String oldseclevel = "";
		String oldmanagerstr = "";
		String newjoblevel = "";
		String newjobtitleid = "";
		
		rs.executeSql("select isADAccount,departmentid, managerid, seclevel, managerstr, joblevel, jobtitle from HrmResource where id=" + Util.getIntValue(id));
		if(rs.next()){
			isADAccount = rs.getString("isADAccount");
			olddepartmentid = rs.getString("departmentid");
			oldmanagerid = rs.getString("managerid");
			oldseclevel = rs.getString("seclevel");
			oldmanagerstr = rs.getString("managerstr");
	     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
      if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
      if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
			newjoblevel = Util.null2s(rs.getString("joblevel"),"0");;
			newjobtitleid = rs.getString("jobtitle");
		}

		String tempmanagerid = managerid;
		if("".equals(managerid)){
			managerid = oldmanagerid;
		}

		String sql = "" ;
		int  costcenterid = 0;
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		String managerstr = "";
		try{
			//para = ""+id+separator+""+depid+separator+""+newjoblevel+separator+""+costcenterid+separator+""+newjobtitleid+separator+""+managerid;
			//rst.executeProc("HrmResource_DepUpdate",para);
			rst.executeSql("UPDATE  HrmResource SET joblevel = "+newjoblevel+" , costcenterid = "+costcenterid+" ,jobtitle = "+newjobtitleid+" ,managerid = "+managerid+", lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"' WHERE id = "+id);
			//subcmpanyid1 = dci.getSubcompanyid1(""+depid);
			//para = ""+id+separator+subcmpanyid1;
			//rst.executeProc("HrmResource_UpdateSubCom",para);
			
			if(!"".equals(tempmanagerid)){
				/*更新managerstr*/
				if(!id.equals(tempmanagerid)){
					rs.executeSql("select managerstr from HrmResource where id = "+Util.getIntValue(managerid));
			        while(rs.next()){
			          managerstr = rs.getString("managerstr");
			          /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
			          if(!managerstr.startsWith(","))managerstr=","+managerstr;
			          if(!managerstr.endsWith(","))managerstr=managerstr+",";
			          /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
				      managerstr =","+managerid+managerstr; 
				      managerstr =managerstr.endsWith(",")?managerstr:(managerstr+",");
			        }
				}else{
		        	managerstr =","+managerid+",";
		        }
		        para = ""+id+separator+ managerstr;
		        rst.executeProc("HrmResource_UpdateManagerStr",para);
			}else
				managerstr=oldmanagerstr;
		
			//String p_para = id + separator + depid + separator + subcmpanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";
		
			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
			  
			sql = "select max(id) from HrmStatusHistory";
			rst.executeSql(sql);
			rst.next();
			sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
			rst.executeSql(sql);
		
			rst.commit();
			
			boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
			if(checkrtxuser){   //存在就编辑，不存在就新增
				OrganisationCom.editUser(Integer.parseInt(id));//编辑
			} else {
				OrganisationCom.addUser(Integer.parseInt(id));//新增
			}
		
			//OA与第三方接口单条数据同步方法开始
			HrmServiceManager.SynInstantHrmResource(id,"2");  
			//OA与第三方接口单条数据同步方法结束 
		
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

		/*调整直接下级和间接下级 managerstr字段 开始*/
		if(!"".equals(tempmanagerid)){
			String temOldmanagerstr=","+id +oldmanagerstr;
			temOldmanagerstr=temOldmanagerstr.endsWith(",")?temOldmanagerstr:(temOldmanagerstr+",");
		
		      sql = "select id,departmentid,subcompanyid1,managerid,seclevel,managerstr from HrmResource where managerstr like '%"+temOldmanagerstr+ "'";
		      rs.executeSql(sql);
		      
		      while(rs.next()){
				String nowmanagerstr = Util.null2String(rs.getString("managerstr"));
		     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
	      if(!nowmanagerstr.startsWith(","))nowmanagerstr=","+nowmanagerstr;
	      if(!nowmanagerstr.endsWith(","))nowmanagerstr=nowmanagerstr+",";
	      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
				String resourceid = rs.getString("id");
				//指定上级为自身的情况，不更新自身上级
				if(id.equals(resourceid))
					continue;
				//String nowmanagerstr2 = Util.StringReplaceOnce(nowmanagerstr,oldmanagerstr ,managerstr);
				String nowmanagerstr2="";
				int index=nowmanagerstr.lastIndexOf(oldmanagerstr);
				if(index!=-1){
					if(!"".equals(managerstr)){
					   nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?managerstr.substring(1):managerstr);
					}   
					else{
					   nowmanagerstr2=nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?"":",");
					} 
					
				}
				String nowdepartmentid = rs.getString("departmentid");
				String nowsubcompanyid1 = rs.getString("subcompanyid1");
				String nowmanagerid = rs.getString("managerid");
				String nowseclevel = rs.getString("seclevel");
				rst=new RecordSetTrans();
				rst.setAutoCommit(false);
				try{
					para = resourceid + separator + nowmanagerstr2;
					rst.executeProc("HrmResource_UpdateManagerStr",para);
		
					//para = resourceid + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr2 + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr + separator + "1";
		
					//System.out.println(p_para);
					//rst.executeProc("HrmResourceShare", para);
					rst.commit();
				}catch(Exception e){
					rst.rollback();
					e.printStackTrace();
				}
		      }
		}
		
		if(Util.null2String(managerids[i]).length()==0){
			sql =  " update hrmresource set managerid=null, managerstr=null, lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"' where id="+id;
			RecordSet.executeSql(sql) ;
		}
		ResourceComInfo.updateResourceInfoCache(ids[i]);//更新缓存
		/*调整直接下级和间接下级 managerstr字段 结束*/
		
		//修改LDAP密码
		//if(!"".equals(password) && !password.equals("qiwuien") && mode.equals("ldap") && "1".equals(Util.null2String(isADAccount))){
		//	String samaccountname = ldap.authenticuser(loginid);
		//	if(StringUtils.isNotBlank(samaccountname) && !"uac".equals(samaccountname)){
		//		ldap.updateUserInfo(samaccountname,password,"",password,"","1");
		//	}
		//}
}
	
	
	response.sendRedirect("HrmResourceSys.jsp?departmentid="+departmentid+"&subcompanyid1="+subcompanyid1) ;
}else if(method.equals("saveManagerBatch")){
	//批量更新上级
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	if(resourceid.length()==0){
		response.sendRedirect("/hrm/resource/HrmResourceSys.jsp");
	  return;
	}
	String newmanager = Util.null2String(request.getParameter("managerid"));
	String[] resourceids = resourceid.split(",");
	
	for(String tmpResourceid : resourceids){
		String managerstr = "";
		String subcompanyid1 = ""; 
		String departmentid = ""; 
		String seclevel = "";  
		String oldmanager = "";
		String oldmanagerstr = "";
		
    if(!resourceid.equals(newmanager)){
    	RecordSet.executeSql("select managerstr from HrmResource where id = "+Util.getIntValue(newmanager,0));
      if(RecordSet.next()){
	     	managerstr = Util.null2String(RecordSet.getString("managerstr"));
	     	managerstr = "," + newmanager + managerstr; 
	     	managerstr = managerstr.endsWith(",")?managerstr:(managerstr+",");
      }
    }else{
    	managerstr = ","+newmanager+",";
    }
    
		RecordSet.executeSql("select subcompanyid1, departmentid, seclevel, managerid, managerstr from hrmresource where id = " + tmpResourceid );
		if(RecordSet.next()){
			subcompanyid1 = Util.null2String(RecordSet.getString("subcompanyid1")); 
			departmentid = Util.null2String(RecordSet.getString("departmentid")); 
			seclevel = Util.null2String(RecordSet.getString("seclevel"));  
			oldmanager = Util.null2String(RecordSet.getString("managerid"));
			oldmanagerstr = Util.null2String(RecordSet.getString("managerstr"));
      if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
      if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
		}
		
		RecordSetTrans RecordSetTrans = new RecordSetTrans();
		RecordSetTrans.setAutoCommit(false);
   	try{
   		RecordSetTrans.executeSql("update HrmResource set managerid="+newmanager+", lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"' where id = "+tmpResourceid);
     	para = ""+tmpResourceid+separator+managerstr;
     	RecordSetTrans.executeProc("HrmResource_UpdateManagerStr",para);
			//String p_para = tmpResourceid + separator + departmentid + separator + subcompanyid1 + separator + newmanager + separator + seclevel + separator + managerstr + separator + departmentid + separator + subcompanyid1 + separator + oldmanager + separator + seclevel + separator + oldmanagerstr + separator + "1";
			//RecordSetTrans.executeProc("HrmResourceShare", p_para);
			RecordSetTrans.commit();
		}catch(Exception e){
			RecordSetTrans.rollback();
			e.printStackTrace();
		}
		ResourceComInfo.updateResourceInfoCache(tmpResourceid);
		
		String temOldmanagerstr = ","+tmpResourceid+oldmanagerstr;
		temOldmanagerstr = temOldmanagerstr.endsWith(",")?temOldmanagerstr:(temOldmanagerstr+",");
		RecordSet.executeSql("select id,departmentid,subcompanyid1,managerid,seclevel,managerstr from HrmResource where managerstr like '%"+temOldmanagerstr+"'");
    while(RecordSet.next()){
			String nowmanagerstr = Util.null2String(RecordSet.getString("managerstr"));
			String resourceidtmp = Util.null2String(RecordSet.getString("id"));
			//指定上级为自身的情况，不更新自身上级
			if(tmpResourceid.equals(resourceidtmp)){
				continue;
			}
			String nowmanagerstr2 = "";
			int index = nowmanagerstr.lastIndexOf(oldmanagerstr);
			if(index!=-1){
				if(!"".equals(managerstr)){
				   nowmanagerstr2 = nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?managerstr.substring(1):managerstr);
				}else{
				   nowmanagerstr2 = nowmanagerstr.substring(0,index)+("".equals(oldmanagerstr)?"":",");
				}
			}
			String nowdepartmentid = Util.null2String(RecordSet.getString("departmentid"));
			String nowsubcompanyid1 = Util.null2String(RecordSet.getString("subcompanyid1"));
			String nowmanagerid = Util.null2String(RecordSet.getString("managerid"));
			String nowseclevel = Util.null2String(RecordSet.getString("seclevel"));
			RecordSetTrans = new RecordSetTrans();
			RecordSetTrans.setAutoCommit(false);
			try{
				para = resourceidtmp + separator + nowmanagerstr2;
				RecordSetTrans.executeProc("HrmResource_UpdateManagerStr",para);
				//para = resourceidtmp + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr2 + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr + separator + "1";
				//RecordSetTrans.executeProc("HrmResourceShare", para);
				RecordSetTrans.commit();
				ResourceComInfo.updateResourceInfoCache(resourceidtmp);
			}catch(Exception e){
				RecordSetTrans.rollback();
				e.printStackTrace();
			}
    }    
	}
	response.sendRedirect("/hrm/resource/HrmResourceSysManagerEdit.jsp?isclose=1");
  return;
}else if("saveBattchDept".equals(method)){
	String type =  "4";
	String resourceid = Util.null2String(request.getParameter("resourceid"));
    int depid = Util.getIntValue(Util.null2String(request.getParameter("departmentid")),0);
    String[] resourceids = resourceid.split(",") ;
    
   // backurl = "HrmResourceRedeploy.jsp" ;
    for(int i=0 ; i<resourceids.length; i++) {
        String id = Util.null2String(resourceids[i]) ;
        String name = ResourceComInfo.getResourcename(id);
		String olddepartmentid = "";
		String oldmanagerid = "";
		String oldseclevel = "";
		String oldmanagerstr = "";
		rs.executeSql("select departmentid, managerid, seclevel, managerstr  from HrmResource where id=" + Util.getIntValue(id));
		while(rs.next()){
			olddepartmentid = rs.getString("departmentid");
			oldmanagerid = rs.getString("managerid");
			oldseclevel = rs.getString("seclevel");
			oldmanagerstr = rs.getString("managerstr");
	     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
      if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
      if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
		}
		String oldsubcompanyid1 = "-1";
		rs.executeSql("select subcompanyid1 from HrmDepartment where id=" + Util.getIntValue(olddepartmentid));
		while(rs.next()){
			oldsubcompanyid1 = rs.getString("subcompanyid1");
		}
		String subcmpanyid1 = "-1";;
		rs.executeSql("select subcompanyid1 from HrmDepartment where id=" + depid);
		while(rs.next()){
			subcmpanyid1 = rs.getString("subcompanyid1");
		}
		
		String managerid=oldmanagerid;
		Date newdate = new Date() ;
		long datetime = newdate.getTime() ;
		Timestamp timestamp = new Timestamp(datetime) ;
		String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
		String changedate = CurrentDate ;
		String changereason = "批量调整部门";
		String oldjobtitleid = ResourceComInfo.getJobTitle(id);
		String oldjoblevel = ResourceComInfo.getJoblevel(id) ;
		oldjobtitleid = ResourceComInfo.getJobTitle(id) ;
		String newjobtitleid = oldjobtitleid ;
		String newjoblevel = oldjoblevel ;
		String infoman = "" ;
		String ischangesalary="0" ;
		
		
        para = ""+id+separator+changedate+separator+changereason+separator+oldjobtitleid+separator+oldjoblevel+
               separator+newjobtitleid+separator+newjoblevel+separator+ infoman+separator+type+separator+ischangesalary
               +separator+oldmanagerid+separator+managerid+separator+olddepartmentid+separator+depid+separator+oldsubcompanyid1+separator+subcmpanyid1+separator+user.getUID();

        rs.executeProc("HrmResource_Redeploy",para);

        if( !infoman.equals("")) {
            // 不做通知
        }

       if(Util.dayDiff(CurrentDate,changedate)<=1){

            String sql = "" ;
            int  costcenterid = 0;
			RecordSetTrans rst=new RecordSetTrans();
			rst.setAutoCommit(false);
			String managerstr = "";
			try{
				para = ""+id+separator+""+depid+separator+""+newjoblevel+separator+""+costcenterid+separator+""+newjobtitleid+separator+""+managerid;
				rst.executeProc("HrmResource_DepUpdate",para);
				subcmpanyid1 = dci.getSubcompanyid1(""+depid);
				para = ""+id+separator+subcmpanyid1;
				rst.executeProc("HrmResource_UpdateSubCom",para);
				// 上级领导不变
				managerstr=oldmanagerstr;

				String p_para = id + separator + depid + separator + subcmpanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";

				rst.executeProc("HrmResourceShare", p_para);
				  
				sql = "select max(id) from HrmStatusHistory";
				rs.executeSql(sql);
				rs.next();
				sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
				rst.executeSql(sql);

				rst.commit();
				
				/*boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
				if(checkrtxuser){   //存在就编辑，不存在就新增
					OrganisationCom.editUser(Integer.parseInt(id));//编辑
				} else {
					OrganisationCom.addUser(Integer.parseInt(id));//新增
				}*/
				new Thread(new OrganisationComRunnable("user","redeploy",id)).start();
				
				//OA与第三方接口单条数据同步方法开始
				HrmServiceManager.SynInstantHrmResource(id,"2");  
				//OA与第三方接口单条数据同步方法结束 

			}catch(Exception e){
				rst.rollback();
			}
			ResourceComInfo.updateResourceInfoCache(id);//更新缓存
        }
    }
	
    response.sendRedirect("/hrm/resource/HrmResourceSysDepartEdit.jsp?isclose=1");
    return ;
    
}else if(method.equals("saveJobTitleBatch")){
	//批量修改岗位
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String newjobtitle = Util.null2String(request.getParameter("jobtitle"));
	String[] resourceids = resourceid.split(",");
	//String departmentid = JobTitlesComInfo.getDepartmentid(newjobtitle);
	
	for(int i=0;resourceids!=null&&i<resourceids.length;i++){
		String id = resourceids[i];

		String sql =  " update hrmresource set jobtitle = "+newjobtitle ;
		sql +=  ", lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"' where id="+id;
		RecordSet.executeSql(sql) ;

		//同步RTX端的用户信息.
		boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
		if(checkrtxuser){   //存在就编辑，不存在就新增
			OrganisationCom.editUser(Integer.parseInt(id));//编辑
		} else {
			OrganisationCom.addUser(Integer.parseInt(id));//新增
		}
	}
	
  for(int i=0 ; i<resourceids.length; i++) {
  	//String depid = JobTitlesComInfo.getDepartmentid(newjobtitle);
    String id = Util.null2String(resourceids[i]) ;
		String olddepartmentid = "";
		String oldmanagerid = "";
		String managerid = "";
		String oldseclevel = "";
		String oldmanagerstr = "";
		String newjoblevel = "";
		String newjobtitleid = "";
		
		rs.executeSql("select departmentid, managerid, seclevel, managerstr, joblevel, jobtitle from HrmResource where id=" + Util.getIntValue(id));
		if(rs.next()){
			olddepartmentid = rs.getString("departmentid");
			managerid = rs.getString("managerid");
			oldmanagerid = rs.getString("managerid");
			oldseclevel = rs.getString("seclevel");
			oldmanagerstr = rs.getString("managerstr");
	     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
      if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
      if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
			newjoblevel = Util.null2s(rs.getString("joblevel"),"0");;
			newjobtitleid = rs.getString("jobtitle");
		}

		String sql = "" ;
		int  costcenterid = 0;
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		String managerstr = "";
		try{
			//para = ""+id+separator+""+depid+separator+""+newjoblevel+separator+""+costcenterid+separator+""+newjobtitleid+separator+""+managerid;
			//rst.executeProc("HrmResource_DepUpdate",para);
			//subcmpanyid1 = dci.getSubcompanyid1(""+depid);
			//para = ""+id+separator+subcmpanyid1;
			//rst.executeProc("HrmResource_UpdateSubCom",para);
			rst.executeSql("UPDATE  HrmResource SET joblevel = "+newjoblevel+" , costcenterid = "+costcenterid+" ,jobtitle = "+newjobtitleid+" ,managerid = "+managerid+", lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"' WHERE id = "+id);
			
			managerstr=oldmanagerstr;
		
			//String p_para = id + separator + depid + separator + subcmpanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";
		
			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
			  
			sql = "select max(id) from HrmStatusHistory";
			rst.executeSql(sql);
			rst.next();
			sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
			rst.executeSql(sql);
		
			rst.commit();
			
			boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在
			if(checkrtxuser){   //存在就编辑，不存在就新增
				OrganisationCom.editUser(Integer.parseInt(id));//编辑
			} else {
				OrganisationCom.addUser(Integer.parseInt(id));//新增
			}
		
			//OA与第三方接口单条数据同步方法开始
			HrmServiceManager.SynInstantHrmResource(id,"2");  
			//OA与第三方接口单条数据同步方法结束 
		
		}catch(Exception e){
			rst.rollback();
		}
		ResourceComInfo.updateResourceInfoCache(id);//更新缓存
}
	response.sendRedirect("/hrm/resource/HrmResourceSysJobTitleEdit.jsp?isclose=1");
  return;
}else if(method.equals("saveBelongtoBatch")){
	String ids = Util.null2String(request.getParameter("ids"));
	String accounttype = Util.null2String(request.getParameter("accounttype"));
  String belongto = Util.null2String(request.getParameter("belongto"));
  String loginid = "";
	if(accounttype.equals("1")){
		String[] arrid = ids.split(",");
		for(int i=0;arrid!=null&&i<arrid.length;i++ ){
			int id = Util.getIntValue(arrid[i]);
			rs.executeSql("select loginid from HrmResource where id ="+belongto);
			if(rs.next()){
				loginid = rs.getString("loginid");
			}
			if(LN.CkHrmnum() >= 0){
	   		response.sendRedirect("/hrm/resource/HrmResourceSysBelongtoEdit.jsp?message=1");
	   		return;
			}
			if(!loginid.equals("")){
				loginid = loginid+(id + 1);
			}
			rs.executeSql("update HrmResource set belongto="+belongto+", loginid='"+loginid+"', accounttype=1, lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"' where id ="+id);
		}
	}else{
		String[] arrid = ids.split(",");
		for(int i=0;arrid!=null&&i<arrid.length;i++ ){
			int id = Util.getIntValue(arrid[i]);
			if(LN.CkHrmnum() >= 0){
	   		response.sendRedirect("/hrm/resource/HrmResourceSysBelongtoEdit.jsp?message=1");
	   		return;
			}
			rs.executeSql("update HrmResource set belongto=null, accounttype=0, lastmodid = '"+userid+"' ,lastmoddate='"+_currentDate+"' where id ="+id);
		}
	}
	ResourceComInfo.removeResourceCache(); //更新缓存
	response.sendRedirect("/hrm/resource/HrmResourceSysBelongtoEdit.jsp?isclose=1");
  return;
}else if(method.equals("batchPasswordChange")){
  String ids = Util.null2String(request.getParameter("ids"));
  String pwd = Util.null2String(request.getParameter("pwd")) ;
  String[] idArr = ids.split(",");
  
  JSONObject result = new JSONObject() ;
  if(!StringUtils.isBlank(pwd)){ // pwd is not null
	  String updatPwdSql = "update hrmresource set password=? where id=?";
	  MD5 md5 = new MD5();
	  String mdPwd = md5.getMD5ofStr(pwd) ;
	  for(String id : idArr){ // loop id
		  if(StringUtils.isBlank(id)) continue ;
		  
	  	    String isadaccountsql="select isadaccount,loginid from hrmresource  where id="+id;
	  	    RecordSet.executeSql(isadaccountsql) ;
	  	  	RecordSet.next() ;
	  	    String isadaccount=Util.null2String(RecordSet.getString("isadaccount"));
	  	    String loginid=Util.null2String(RecordSet.getString("loginid"));
	  	   
	  	    if("1".equals(Util.null2String(isadaccount))){  // ad user
	  	    	 if("ldap".equals(mode)){ // ad config open 
	  	    		String samaccountname = ldap.authenticuser(loginid);
	  	    		if(StringUtils.isNotBlank(samaccountname) && !"uac".equals(samaccountname)){
	  	    			ldap.updateUserInfo(samaccountname,pwd,"",pwd,"","1");
	  	    		}
	  	    	 }
	  	    }else{ // normal user
	  	    	RecordSet.executeUpdate(updatPwdSql,mdPwd,id) ;
	  	    }
	  }
	  result.put("code","1") ;
  }else{
	  result.put("code","-1") ;
  }
  out.clear() ;
  out.print(result.toString()) ;
  return ;
}

%>


	
