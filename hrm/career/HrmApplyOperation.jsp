<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.security.*,weaver.file.FileUpload,weaver.conn.RecordSetTrans" %>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder,weaver.hrm.settings.RemindSettings" %>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LN" class="ln.LN" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />

<%
  	//固定页面头部增加以下代码
  	boolean formdefined = false;
    weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
    weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
    if(CusFormSetting!=null){
    	if(CusFormSetting.getStatus()==2){
    		//自定义布局页面
    		formdefined = true;
    	}
    }
FileUpload fu = new FileUpload(request);
char separator = Util.getSeparator() ;
int userid = user.getUID();
Calendar todaycal = Calendar.getInstance ();

String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
String userpara = ""+userid+separator+today;
String operation = Util.null2String(fu.getParameter("operation"));
String para="";

String id = Util.null2String(fu.getParameter("id"));
String paramId = id;
String planid = Util.null2String(fu.getParameter("planid"));

if(operation.equalsIgnoreCase("add")){
  String sql = "select lastname,sex from HrmCareerApply where id = "+id;
  rs.executeSql(sql);
  rs.next();
  String lastname = Util.null2String(rs.getString("lastname"));
  String sex = Util.null2String(rs.getString("sex"));

  String workcode = Util.fromScreen3(fu.getParameter("workcode"),user.getLanguage());
      String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
      String departmentid = Util.fromScreen3(fu.getParameter("departmentid"),user.getLanguage());
      String costcenterid = Util.fromScreen3(fu.getParameter("costcenterid"),user.getLanguage());
      String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle"),user.getLanguage());
      String joblevel = Util.fromScreen3(fu.getParameter("joblevel"),user.getLanguage());
      String jobactivitydesc = Util.fromScreen3(fu.getParameter("jobactivitydesc"),user.getLanguage());
      String managerid = Util.fromScreen3(fu.getParameter("managerid"),user.getLanguage());
      String assistantid = Util.fromScreen3(fu.getParameter("assistantid"),user.getLanguage());
      String status = Util.fromScreen3(fu.getParameter("status"),user.getLanguage());
      String locationid = Util.fromScreen3(fu.getParameter("locationid"),user.getLanguage());
      String workroom = Util.fromScreen3(fu.getParameter("workroom"),user.getLanguage());
      String telephone = Util.fromScreen3(fu.getParameter("telephone"),user.getLanguage());
      String mobile = Util.fromScreen3(fu.getParameter("mobile"),user.getLanguage());
      String mobileshowtype = Util.fromScreen3(fu.getParameter("mobileshowtype"),user.getLanguage());
      String mobilecall = Util.fromScreen3(fu.getParameter("mobilecall"),user.getLanguage());
      String fax = Util.fromScreen3(fu.getParameter("fax"),user.getLanguage());
      String jobcall = Util.fromScreen3(fu.getParameter("jobcall"),user.getLanguage());
      String email = Util.fromScreen3(fu.getParameter("email"),user.getLanguage());
      String dsporder = Util.fromScreen3(fu.getParameter("dsporder"),user.getLanguage());
	  String accounttype = Util.fromScreen3(fu.getParameter("accounttype"),user.getLanguage());
	  String systemlanguage = Util.null2String(fu.getParameter("systemlanguage"));
      if(systemlanguage.equals("")||systemlanguage.equals("0")) systemlanguage = "7";
      String belongto = Util.fromScreen3(fu.getParameter("belongto"),user.getLanguage());
      
      if(dsporder.length()==0)dsporder=id;
      if(accounttype.equals("0")){
	      belongto="-1";
      }
      String departmentvirtualids = Util.null2String(fu.getParameter("departmentvirtualids"));//虚拟部门id;
      
      //Td9325,解决多账号次账号没有登陆Id在浏览框组织结构中无法显示的问题。
      boolean falg = false;
	  String loginid = "";
		if(accounttype.equals("1")){
			rs.executeSql("select id from HrmResource where id ="+belongto);
			if(rs.next()){
				loginid = rs.getString("id");
			}
			if(LN.CkHrmnum() >= 0){
	    		response.sendRedirect("HrmResourceAdd.jsp?ifinfo=y&isfromtab=true");
	    		return;
			}
			if(!loginid.equals("")){
				String maxidsql = "select max(id) as id from HrmResource where loginid like '"+loginid+"%'";
				rs.executeSql(maxidsql);
				if(rs.next()){
					loginid = loginid+(rs.getInt("id")+1);
					falg = true;
				}
			}
		}
      rs.executeProc("HrmResourceMaxId_Get","");
      rs.next();
      id = ""+rs.getInt(1);

      sql = "select managerstr, seclevel from HrmResource where id = "+Util.getIntValue(managerid);
      rs.executeSql(sql);
      String managerstr = "";
	  String seclevel = "";
      while(rs.next()){
          managerstr += rs.getString("managerstr");
          managerstr =","+managerid+managerstr;
          managerstr=managerstr.endsWith(",")?managerstr:(managerstr+",");
		  seclevel = rs.getString("seclevel");
      }
      
      String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{

			para = ""+id+separator+workcode+separator+lastname+separator+sex+separator+resourceimageid+separator+
             departmentid+separator+ costcenterid+separator+jobtitle+separator+joblevel+separator+jobactivitydesc+separator+
             managerid+separator+assistantid+separator+status+separator+locationid+separator+workroom+separator+telephone+
             separator+mobile+separator+mobilecall+separator+fax+separator+jobcall+separator+subcmpanyid1+separator+managerstr+
             separator+accounttype+separator+belongto+separator+systemlanguage+separator+email+separator+dsporder+separator+mobileshowtype;

			rst.executeProc("HrmResourceBasicInfo_Insert",para);
			rst.executeSql("update hrmresource set countryid=(select countryid from HrmLocations where id="+locationid+") where id="+id);
			if(falg){
				String logidsql = "update HrmResource set loginid = '"+loginid+"' where id = "+id;
				rst.executeSql(logidsql);
			}
			if(seclevel == null || "".equals(seclevel)){
				seclevel = "0";
			}
			String p_para = id + separator + departmentid + separator + subcmpanyid1 + separator + managerid + separator + seclevel + separator + managerstr + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0";

			//System.out.println(p_para);
			rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

      para = ""+id;
      for(int i = 0;i<5;i++){
      	int idx = i;
      	if(formdefined) idx++;
        String datefield = Util.null2String(fu.getParameter("datefield"+idx));
        String numberfield = ""+Util.getDoubleValue(fu.getParameter("numberfield"+idx),0);
        String textfield = Util.null2String(fu.getParameter("textfield"+idx));
        String tinyintfield = ""+Util.getIntValue(fu.getParameter("tinyintfield"+idx),0);
        para += separator+datefield + separator+numberfield+separator+textfield+separator+tinyintfield;
      }
      rs.executeProc("HrmResourceDefine_Update",para);

      rs.executeProc("HrmResource_CreateInfo",""+id+separator+userpara+separator+userpara);

      // 改为只进行该人缓存信息的添加
      ResourceComInfo.addResourceInfoCache(id);

      SalaryManager.initResourceSalary(id);
    /*
      String sql = "select managerstr from HrmResource where id = "+Util.getIntValue(managerid);

      rs.executeSql(sql);
      String managerstr = "";
      while(rs.next()){
          managerstr += rs.getString("managerstr");
          managerstr +=   managerid + "," ;
      }
      para = ""+id+separator+ managerstr;

      rs.executeProc("HrmResource_UpdateManagerStr",para);

      //String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
      para = ""+id+separator+subcmpanyid1;
      rs.executeProc("HrmResource_UpdateSubCom",para);
    */


      para = ""+id+separator+managerid+separator+departmentid+separator+subcmpanyid1+separator+"0"+separator+managerstr;
      rs.executeProc("HrmResource_Trigger_Insert",para);

      String sql_1=("insert into HrmInfoStatus (itemid,hrmid) values(1,"+id+")");
      rs.executeSql(sql_1);
      String sql_2=("insert into HrmInfoStatus (itemid,hrmid) values(2,"+id+")");
      rs.executeSql(sql_2);
      String sql_3=("insert into HrmInfoStatus (itemid,hrmid) values(3,"+id+")");
      rs.executeSql(sql_3);
    /*
    String sql_4=("insert into HrmInfoStatus (itemid,hrmid) values(4,"+id+")");
    rs.executeSql(sql_4);
    String sql_5=("insert into HrmInfoStatus (itemid,hrmid) values(5,"+id+")");
    rs.executeSql(sql_5);
    String sql_6=("insert into HrmInfoStatus (itemid,hrmid) values(6,"+id+")");
    rs.executeSql(sql_6);
    String sql_7=("insert into HrmInfoStatus (itemid,hrmid) values(7,"+id+")");
    rs.executeSql(sql_7);
    String sql_8=("insert into HrmInfoStatus (itemid,hrmid) values(8,"+id+")");
    rs.executeSql(sql_8);
    String sql_9=("insert into HrmInfoStatus (itemid,hrmid) values(9,"+id+")");
    rs.executeSql(sql_9);
    */
      String sql_10=("insert into HrmInfoStatus (itemid,hrmid) values(10,"+id+")");
      rs.executeSql(sql_10);

     String name = lastname;

    String CurrentUser = ""+user.getUID();
    String CurrentUserName = ""+user.getUsername();

    String SWFAccepter="";
    String SWFTitle="";
    String SWFRemark="";
    String SWFSubmiter="";
    String Subject="";
    Subject= SystemEnv.getHtmlLabelName(15670,user.getLanguage()) ;
    Subject+=":"+name;

    //modifier by lvyi 2013-12-31
    ChgPasswdReminder reminder=new ChgPasswdReminder();
		RemindSettings settings=reminder.getRemindSettings();
		if(settings.getEntervalid().equals("1")){//入职提醒
	    String thesql="select distinct hrmid from HrmInfoMaintenance where id<4 or id = 10";
	    rs.executeSql(thesql);
	    String members="";
	    while(rs.next()){
			int hrmid_tmp = Util.getIntValue(rs.getString("hrmid"));//TD9392
			if(hrmid_tmp > 0 && user.getUID() != hrmid_tmp){
				members += ","+rs.getString("hrmid");
			}
	    }
	    if(!members.equals("")){
	        members = members.substring(1);
	
	        SWFAccepter=members;
	        SWFTitle= SystemEnv.getHtmlLabelName(15670,user.getLanguage()) ;
	        SWFTitle += ":"+name;
	        SWFTitle += "-"+CurrentUserName;
	        SWFTitle += "-"+today ;
	        SWFRemark="<a href=/hrm/employee/EmployeeManage.jsp?hrmid="+id+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
	        SWFSubmiter=CurrentUser;
	
	        SysRemindWorkflow.setPrjSysRemind(SWFTitle,0,Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
	    }
		}
		
		CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
		
		  //更新虚拟组织部门id
		  if(departmentvirtualids.length()>0){
			  //保存前先删除需要删除的数据，因为有managerid 所以不能全部删除再保存
		  	sql = "delete from hrmresourcevirtual where resourceid="+id +" and departmentid not in ("+departmentvirtualids+")";
			  rs.executeSql(sql);
			 
			  String[] departmentvirtualid = departmentvirtualids.split(",");
			  for(int i=0;departmentvirtualid!=null&&i<departmentvirtualid.length;i++){
					rs.executeSql(" select count(*) from HrmResourceVirtual where departmentid ='"+departmentvirtualid[i]+"' and resourceid = "+id);
					if(rs.next()){
						//如果已存在 无需处理
						if(rs.getInt(1)>0)continue;
					}
					
					//写入
					int tmpid = 0;
					rs.executeSql("select max(id) from HrmResourceVirtual ");
					if(rs.next()){
						tmpid = rs.getInt(1)+1;
					}
					String subcompanyid = DepartmentVirtualComInfo.getSubcompanyid1(departmentvirtualid[i]);
					sql = " insert into HrmResourceVirtual (id,resourceid,subcompanyid,departmentid ) "+
						    " values ("+tmpid+","+id+","+subcompanyid+","+departmentvirtualid[i]+")";	
					rs.executeSql(sql);
			  }
		  }
			
      SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(lastname);
      SysMaintenanceLog.setOperateItem("29");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourceBasicInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();

    sql = "select * from HrmCareerApply where id = "+paramId;
    rs.executeSql(sql);
    rs.next();
    String birthday = Util.null2String(rs.getString("birthday"));
    String folk = Util.null2String(rs.getString("folk"));
    String nativeplace = Util.null2String(rs.getString("nativeplace"));
    String regresidentplace = Util.null2String(rs.getString("regresidentplace"));

    String certificatenum = Util.null2String(rs.getString("certificatenum"));
    String maritalstatus = Util.null2String(rs.getString("maritalstatus"));
    String policy = Util.null2String(rs.getString("policy"));
    String bememberdate = Util.null2String(rs.getString("bememberdate"));

    String bepartydate = Util.null2String(rs.getString("bepartydate"));
    String islabouunion = Util.null2String(rs.getString("islabouunion"));
    String educationlevel = Util.null2String(rs.getString("educationlevel"));
    String degree = Util.null2String(rs.getString("degree"));

    String healthinfo = Util.null2String(rs.getString("healthinfo"));
    
    String height = Util.null2String(rs.getString("height"));
    if(height.indexOf(".")!=-1)height=height.substring(0,height.indexOf("."));
    String weight = Util.null2String(rs.getString("weight"));
    if(weight.indexOf(".")!=-1)weight=weight.substring(0,weight.indexOf("."));

    String residentplace = Util.null2String(rs.getString("residentplace"));

    String homeaddress = Util.null2String(rs.getString("homeaddress"));
    String tempresidentnumber = Util.null2String(rs.getString("tempresidentnumber"));

    para = "" + id + separator + birthday + separator + folk + separator + nativeplace + separator + regresidentplace + separator + maritalstatus + separator + policy + separator + bememberdate + separator + bepartydate + separator + islabouunion + separator + educationlevel + separator + degree + separator + healthinfo + separator + height + separator+weight + separator + residentplace + separator + homeaddress + separator + tempresidentnumber + separator + certificatenum ;

    rs.executeProc("HrmResourcePersonalInfo_Insert",para);
	rs.executeSql("update cus_fielddata set scope='HrmCustomFieldByInfoType' where scope='CareerCustomFieldByInfoType' and id="+id);
    rs.executeProc("HrmCareerApplyHire",paramId);
    response.sendRedirect("/hrm/career/HrmCareerApplyToResource.jsp?isclose=1&planid="+planid+"&id="+paramId);
}
%>