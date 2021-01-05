<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="java.util.Random"%>
<%@page import="weaver.common.MessageUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.rdeploy.hrm.RdeployHrmSetting"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
    <jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
    <jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
    <jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
    <jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
    <jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%!
/***
 * 随机数密码
 * @param n
 * @return
 */
public static String random(int n) {
  Random ran = new Random();
  if (n == 1) {
      return String.valueOf(ran.nextInt(10));
  }
  int bitField = 0;
  char[] chs = new char[n];
  for (int i = 0; i < n; i++) {
      while(true) {
          int k = ran.nextInt(10);
          if( (bitField & (1 << k)) == 0) {
              bitField |= 1 << k;
              chs[i] = (char)(k + '0');
              break;
          }
      }
  }
  return new String(chs);
}
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


//是否是 初始化分部 或 部门 0 分部  1部门
String name = Util.null2String(request.getParameter("name")).trim();
String mobilephone = Util.null2String(request.getParameter("mobilephone"));
String operate = Util.null2String(request.getParameter("operate"));
String method = Util.null2String(request.getParameter("method"));
String managerName = Util.null2String(request.getParameter("managerName"));

if(method.equals("mobilefinishinfo")){
	String id = Util.null2String(request.getParameter("id"));
	String sex = Util.null2String(request.getParameter("sex"));
	String deptid = Util.null2String(request.getParameter("deptid"));
	String dept = Util.null2String(request.getParameter("dept")).trim();
	String job = Util.null2String(request.getParameter("job")).trim();
	String jobid = Util.null2String(request.getParameter("jobid"));
	String subcompanyid1 = "";
	if("".equals(deptid) && !"".equals(dept)){
	    rs.executeSql("select id from HrmDepartment where departmentname = '"+dept+"'");
	    if(rs.next()){
	        deptid = rs.getString(1);
	    }else{
	        String subcomid = Util.null2String(RdeployHrmSetting.getSettingInfo("subcom"));
	        subcompanyid1 = subcomid;
	       
	    	String insertSql = "INSERT INTO HrmDepartment (departmentname, supdepid, subcompanyid1) VALUES ('"+dept+"',"+0+","+subcomid+" ) ";
	    	//String insertSql ="";
	    	if(!rs.executeSql(insertSql)){
	    	    //msg="3";
	    	    //sURL="RdDeptAdd.jsp?method="+operation+"&subcompanyid1="+subcompanyid1+"&supdepid="+supdepid+"&id="+"&msg="+msg+"&from="+from;
	            response.sendRedirect("RdMobileFinishInfo.jsp?message=1");
	    		return;
	    	}
	    	int deptid_=-1;
	    	String getMaxIdSql= "select id from HrmDepartment where subcompanyid1 = "+subcomid
	    		+" and departmentname = '"+dept+"' and supdepid = "+0;
	    	rs.executeSql(getMaxIdSql);
	    	if(rs.next()){
	    	    deptid_ = rs.getInt(1);
	    	}
	    	deptid = deptid_+"";
	    	 User user = HrmUserVarify.getUser (request , response) ;
	    	 HttpServletRequest fu = request;
	    	  String info = "subcompanyid1 = "+subcomid
	    			+" and departmentname = '"+dept+"' and supdepid = "+0;
	          SysMaintenanceLog.resetParameter();
	          SysMaintenanceLog.setRelatedId(deptid_);
	          SysMaintenanceLog.setRelatedName(dept);
	          SysMaintenanceLog.setOperateType("1");
	          SysMaintenanceLog.setOperateDesc("INSERT INTO HrmDepartment,"+info);
	          SysMaintenanceLog.setOperateItem("12");
	          SysMaintenanceLog.setOperateUserid(user.getUID());
	          SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
	          SysMaintenanceLog.setSysLogInfo();

	    	DepartmentComInfo.removeCompanyCache();
	    	rs.executeSql("update orgchartstate set needupdate=1");

	        //add by wjy
	        //同步RTX端部门信息
	        OrganisationCom.addDepartment(deptid_);

	        //OA与第三方接口单条数据同步方法开始
	        HrmServiceManager.SynInstantDepartment(""+deptid_,"1"); 
	        //OA与第三方接口单条数据同步方法结束
	        
	        
	        //同步部门数据到矩阵
	        insertInto(deptid_);
	    }
	}else if("".equals(dept)){
	    subcompanyid1 = "0";
	    deptid = "0";
	}else{
	    subcompanyid1 = DepartmentComInfo.getSubcompanyid1(deptid);
	}
	if("".equals(jobid)&& !"".equals(job)){
	    String sqlStr ="Select id From HrmJobTitles WHERE  jobdepartmentid="+deptid+" and LTRIM(RTRIM(jobtitlename))='"+job.trim()+"'";
	    rs.executeSql(sqlStr);
	    if(rs.next()){
	        deptid = rs.getString(1);
	    }else{
	        char separator = Util.getSeparator() ;
	        String jobactivitId = "";  //职务ID
	        String sql = " select id  from HrmJobActivities a  where jobactivityname ='待定' ";
	        rs.executeSql(sql);
	        if(rs.next()){
	            jobactivitId = rs.getString(1);
	        }
	        String para = job + separator + job + separator + 
	        deptid + separator + jobactivitId + separator + 
	        ""+ separator + "" + separator + 
	        "";

	        rs.executeProc("HrmJobTitles_Insert",para);

	        int jobid_=-1;

	        if(rs.next()){
	            jobid_ = rs.getInt(1);
	        }
	        jobid = jobid_+"";
	        JobTitlesComInfo.removeJobTitlesCache();
	    }
	}else if("".equals(job)){
	    jobid = "0";
	}
	
	
	String sql = " UPDATE HrmResource SET lastname = '"+name+"', sex = '"+sex+"', departmentid = '"+deptid +"' ,subcompanyid1 ='"+subcompanyid1+"'"
    +", jobtitle = '"+jobid+"',  mobile = '"+mobilephone+"'" +" where id="+id;   

    rs.executeSql(sql);
    ResourceComInfo.updateResourceInfoCache(id);
    response.sendRedirect("RdMobileChangeResult.jsp?uid="+id);
    return;
}
if(method.equals("mobilechangepwd")){
	int id = Util.getIntValue(request.getParameter("id"));
	String userpassword = Util.null2String(request.getParameter("userpassword"));
    
	String password = Util.getEncrypt(userpassword);

    rs.executeSql("  UPDATE HrmResource SET  PASSWORD = '"+password+"' WHERE ID ="+id);
    ResourceComInfo.updateResourceInfoCache(id+"");
    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(name);
	    SysMaintenanceLog.setOperateItem("60");
	    SysMaintenanceLog.setOperateUserid(id);
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("6");
	SysMaintenanceLog.setOperateDesc("y");
	SysMaintenanceLog.setSysLogInfo();
    response.sendRedirect("RdMobileFinishInfo.jsp");
    return;
}

if(method.equals("add")){
  //设置密码
	String password_tmp =random(4);
	String password = Util.getEncrypt(password_tmp);
	
	User user = HrmUserVarify.getUser (request , response) ;
    int languageid = user.getLanguage();
	
	rs.executeProc("HrmResourceMaxId_Get","");
	rs.next();
	String   id = ""+rs.getInt(1);
	String insertSql = "insert into HrmResource(id,Lastname,mobile,status,notallot,departmentid,subcompanyid1,systemlanguage,password,loginid ) values("
	        +id+",'"+name+"','"+mobilephone+"',1,1,0,0,"+languageid+",'"+password+"','"+mobilephone+"')";
	
	rs.executeSql(insertSql);
	
	ResourceComInfo.addResourceInfoCache(id);
	String comname = CompanyComInfo.getCompanyname("1");
	String reUrl = request.getRequestURL().toString();

	String invUrl =reUrl.substring(0,reUrl.indexOf("/rdeploy/hrm/RdResourceOperation.jsp"))+"/rdeploy/hrm/RdMobileLogin.jsp?uid="+id;
	//发送短信
	String content = managerName+""+SystemEnv.getHtmlLabelName(125172 ,languageid)+comname+SystemEnv.getHtmlLabelName(125173  ,languageid)+invUrl+""+SystemEnv.getHtmlLabelName(125174 ,languageid)+mobilephone+SystemEnv.getHtmlLabelName(125169  ,languageid)+password_tmp+"";
	MessageUtil.sendSMS(mobilephone,content);
	
	
	if(operate.equals("2")){
	    response.sendRedirect("RdResourceAdd.jsp?success='true'");
	    return;
	}
	%>
	<SCRIPT LANGUAGE='JavaScript'>
		parent.getParentWindow(window).showInfo();
	</SCRIPT>
	<%
	return;
}

if(method.equals("newuser")){
  //设置密码
	String password_tmp = Util.null2String(request.getParameter("userpassword"));
	String loginid = Util.null2String(request.getParameter("loginid"));
	String language = Util.null2String(request.getParameter("language"));
	String password = Util.getEncrypt(password_tmp);
	String onoff = RdeployHrmSetting.getSettingInfo("onoff");
	String status = "1";
	if("1".equals(onoff)){
	    status = "7";
	}
	
	rs.executeProc("HrmResourceMaxId_Get","");
	rs.next();
	int   id = rs.getInt(1);
	String insertSql = "insert into HrmResource(id,Lastname,mobile,status,isnewuser,departmentid,subcompanyid1,systemlanguage,password,loginid,resourcefrom ) values("
	        +id+",'"+name+"','"+loginid+"',"+status+",1,0,0,"+language+",'"+password+"','"+loginid+"','PC')";
	
	rs.executeSql(insertSql);
	
	ResourceComInfo.addResourceInfoCache(id+"");
	
	
	if("1".equals(onoff)){
	    response.sendRedirect("RdRegistResult.jsp?language="+language);
	    return; 	
	}else{
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(id);
		SysMaintenanceLog.setRelatedName(name);
		    SysMaintenanceLog.setOperateItem("60");
		    SysMaintenanceLog.setOperateUserid(id);
		    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setOperateType("6");
		SysMaintenanceLog.setOperateDesc("y");
		SysMaintenanceLog.setSysLogInfo();
	    //request.getRequestDispatcher("/login/VerifyLogin.jsp").forward(request,response);
	    //return;
	    //response.sendRedirect("/login/VerifyLogin.jsp?loginid="+mobilephone+"&userpassword="+password_tmp+"&gopage=RdRegistResourceFinish.jsp?uid="+id+"&mobilephone="+mobilephone+"&name="+name);
	    //request.setAttribute("userpassword",password_tmp);
	    //request.setAttribute("loginid",mobilephone);
	    //request.setAttribute("logintype","1");
	    //request.setAttribute("gopage","RdRegistResourceFinish.jsp?uid="+id+"&mobilephone="+mobilephone+"&name="+name+"&other="+password_tmp+"&language="+language);
	    //request.getRequestDispatcher("/login/VerifyLogin.jsp?gopage=/rdeploy/hrm/RdRegistResourceFinish.jsp?red=1&uid="+id+"&mobilephone="+mobilephone+"&name="+name+"&language="+language).forward(request,response);
	    
	    //request.getSession().setAttribute("rd_other",password_tmp);
	    response.sendRedirect("RdRegistLogin.jsp?uid="+id+"&loginid="+loginid+"&name="+name+"&language="+language+"&userpassword="+password_tmp);
	    return;
	}
	
}

if(method.equals("edit")){
    String id = Util.null2String(request.getParameter("id"));
    String sex = Util.null2String(request.getParameter("sex"));
    String email = Util.null2String(request.getParameter("email"));
    String telephone = Util.null2String(request.getParameter("phone"));
    String departmentid = request.getParameter("departmentid");
    String jobtitle = request.getParameter("jobtitle");
    String managerid = request.getParameter("managerid");
    String messageurl = Util.null2String(request.getParameter("messageUrl"));
    
    String subcompanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
    
    String sql = " UPDATE HrmResource SET lastname = '"+name+"', sex = '"+sex+"', departmentid = '"+departmentid +"' ,subcompanyid1 ='"+subcompanyid1+"'"
    +", jobtitle = '"+jobtitle+"', managerid = '"+managerid+"', telephone = '"+telephone+"', mobile = '"+mobilephone+"', email = '"+email+"'";
    if(!"".equals(departmentid)){
        sql+=" ,notallot = null";
    }
    sql+=",messagerurl ='"+messageurl+"'  WHERE id = "+id;
    
    rs.executeSql(sql);
    ResourceComInfo.updateResourceInfoCache(id);
    %>
    <SCRIPT LANGUAGE='JavaScript'>
    	parent.getParentWindow(window).editSuccess('<%=id%>','<%=departmentid%>');
    </SCRIPT>
    <%
}

if(method.equals("newuseredit")){
    String id = Util.null2String(request.getParameter("id"));
    String sex = Util.null2String(request.getParameter("sex"));
    int departmentid = Util.getIntValue(request.getParameter("departmentid"),0);
    int jobtitle = Util.getIntValue(request.getParameter("jobtitle"),0);
    String other = request.getParameter("other");
    
    int subcompanyid1 = Util.getIntValue(DepartmentComInfo.getSubcompanyid1(departmentid+""),0);
    
    if("".equals(id)){
        response.sendRedirect("/wui/main.jsp");
        return;
    }
    
    String sql = " UPDATE HrmResource SET lastname = '"+name+"', sex = '"+sex+"', departmentid = '"+departmentid +"' ,subcompanyid1 ='"+subcompanyid1+"'"
    +", jobtitle = '"+jobtitle+"'  WHERE id = "+id;
    rs.executeSql(sql);
    ResourceComInfo.updateResourceInfoCache(id);
    //request.setAttribute("userpassword",other);
    //request.setAttribute("loginid",mobilephone);
    //request.setAttribute("logintype","1");
    //request.getRequestDispatcher("/login/VerifyLogin.jsp").forward(request,response);
    response.sendRedirect("/wui/main.jsp");
    return;
}


if(method.equals("editDept")){
    String ids = Util.null2String(request.getParameter("ids"));
    String departmentid = Util.null2String(request.getParameter("departmentid"));
    String subcompanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
    String[] idsArray = ids.split(",");
    String idStr = "";
    for(int i =0;i<idsArray.length;i++){
        if(!"".equals(idsArray[i].trim())){
	         if(i>0){
	         idStr+=",";
	         }
	         idStr+=idsArray[i];
        }
    }
    String sql = " UPDATE HrmResource SET departmentid='"+departmentid+"' ,subcompanyid1='"+subcompanyid1+"'  WHERE id in( "+idStr+")";
    boolean result = rs.executeSql(sql);
    String[] needUpdateIds = idStr.split(",");
    for(int i =0;i<needUpdateIds.length;i++){
	    ResourceComInfo.updateResourceInfoCache(needUpdateIds[i]);
    }
    %>
    <SCRIPT LANGUAGE='JavaScript'>
    	parent.getParentWindow(window).reloadTable();
    	window.parent.Dialog.close();
		parent.getParentWindow(window.parent.window).closeInfo();
    </SCRIPT>
    <%
    
    
}

if(method.equals("editManager")){
    String ids = Util.null2String(request.getParameter("ids"));
    String managerid = Util.null2String(request.getParameter("managerid"));
    String[] idsArray = ids.split(",");
    String idStr = "";
    for(int i =0;i<idsArray.length;i++){
        if(!"".equals(idsArray[i].trim())){
	         if(i>0){
	         idStr+=",";
	         }
	         idStr+=idsArray[i];
        }
    }
    String sql = " UPDATE HrmResource SET managerid='"+managerid+"'  WHERE id in( "+idStr+")";
    boolean result = rs.executeSql(sql);
    String[] needUpdateIds = idStr.split(",");
    for(int i =0;i<needUpdateIds.length;i++){
	    ResourceComInfo.updateResourceInfoCache(needUpdateIds[i]);
    }
    %>
    <SCRIPT LANGUAGE='JavaScript'>
    	parent.getParentWindow(window).reloadTable();
    	window.parent.Dialog.close();
    	parent.getParentWindow(window.parent.window).closeInfo();
    </SCRIPT>
    <%
    
    
}



%>