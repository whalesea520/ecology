   <%@ page buffer="8kb" autoFlush="true" errorPage="/notice/error.jsp" %>
   <%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <%@ page import="java.security.*,weaver.general.Util,weaver.hrm.settings.RemindSettings,weaver.file.Prop,weaver.rtx.RTXConfig" %>
	<%@ page import="java.lang.reflect.*,weaver.hrm.settings.ChgPasswdReminder,weaver.hrm.settings.RemindSettings" %>
    <%@ page import="weaver.file.FileUpload" %>
    <%@ page import="java.util.*" %>
    <%@ page import="java.text.*" %>
    <%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO" %>
    <%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO" %>
    <%@ page import="weaver.workflow.msg.PoppupRemindInfoUtil"%>
    <%@ page import="weaver.conn.RecordSet"%>
	<%@ page import="weaver.general.StaticObj"%>
	<%@page import="weaver.hrm.resource.ResourceBelongtoComInfo"%>
   <%@ page import="weaver.conn.RecordSetTrans" %>
<%@page import="weaver.login.TokenUtil"%>
	<%@ page import="weaver.ldap.LdapUtil" %>
<%@page import="weaver.hrm.common.DbFunctionUtil"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
    <jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
    <%@ include file="/systeminfo/init_wev8.jsp" %>
    <jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
	<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
	<jsp:useBean id="GCONST" class="weaver.general.GCONST" scope="page" />
    <jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
	<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="rsdb2" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />
    <jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
    <jsp:useBean id="HrmDateCheck" class="weaver.hrm.tools.HrmDateCheck" scope="page" />
    <jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
    <jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />
    <jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
    <jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
    <jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
    <jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
    <jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
    <jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
    <jsp:useBean id="LN" class="ln.LN" scope="page" />
    <jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
    <jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>
    <jsp:useBean id="VerifyPasswdCheck" class="weaver.login.VerifyPasswdCheck" scope="page" />
    <jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
    <%@ page import="weaver.rtx.OrganisationComRunnable" %>
   <%@ page import="weaver.hrm.definedfield.HrmFieldManager" %>
   <jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
	<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
	<jsp:useBean id="RSA" class="weaver.rsa.security.RSA" scope="page" />
    <%@ page import="weaver.interfaces.email.CoreMailAPI" %>
	<%@ page import="weaver.interfaces.email.CoreMailTestAPI" %>
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
    
      String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	  String bbsLingUrl=BaseBean.getPropValue(GCONST.getConfigFile() , "ecologybbs.linkUrl");
      FileUpload fu = new FileUpload(request);
      String f_weaver_belongto_userid = Util.null2String(fu.getParameter("f_weaver_belongto_userid"));
      user = HrmUserVarify.getUser(request,response,f_weaver_belongto_userid,null);
      char separator = Util.getSeparator() ;

      int userid = user.getUID();
      Calendar todaycal = Calendar.getInstance ();
      String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
      String userpara = ""+userid+separator+today;

      String operation = Util.null2String(fu.getParameter("operation"));
	  String isEdit = Util.null2String(fu.getParameter("isEdit"));
      String view=Util.null2String(fu.getParameter("view"));
      boolean isfromtab =  Util.null2String(fu.getParameter("isfromtab")).equals("true")?true:false;
      String para="";

      int isView = Util.getIntValue(fu.getParameter("isView"));
      String adtype = Util.null2String(request.getParameter("adtype"));

//update by fanggsh TD4233 begin
      HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
      String hrmResourceManagerId = Util.null2String(fu.getParameter("id")) ;
      HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(hrmResourceManagerId);	  
//update by fanggsh TD4233 end

// update time
if(!"addresourcebasicinfo".equals(operation)){
	String id = Util.null2String(fu.getParameter("id")) ;
	RecordSet.execute("update HrmResource set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
	RecordSet.execute("update HrmResourceManager set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
}


if(operation.equalsIgnoreCase("maindactylogram")){
	String id = Util.null2String(fu.getParameter("id")) ;
  if(!id.equals(String.valueOf(userid))){
  	response.sendRedirect("HrmResourcePassword.jsp?id="+id);
    return ;
	}
	String maindactylogram = Util.null2String(fu.getParameter("maindactylogram")) ;
	rs.executeSql("update HrmResource set dactylogram='"+maindactylogram+"' where id="+id);
	rs.executeSql("update HrmResourceManager set dactylogram='"+maindactylogram+"' where id="+id);
	String topage = Util.null2String(fu.getParameter("topage")) ;
	if(topage.equals(""))
		response.sendRedirect("HrmResourcePassword.jsp?id="+id);
	else
		response.sendRedirect(topage+"?id="+id);
	return;
}
if(operation.equalsIgnoreCase("assistantdactylogram")){
	String id = Util.null2String(fu.getParameter("id")) ;
  if(!id.equals(String.valueOf(userid))){
  	response.sendRedirect("HrmResourcePassword.jsp?id="+id);
    return ;
	}
	String assistantdactylogram = Util.null2String(fu.getParameter("assistantdactylogram")) ;
	rs.executeSql("update HrmResource set assistantdactylogram='"+assistantdactylogram+"' where id="+id);
	rs.executeSql("update HrmResourceManager set assistantdactylogram='"+assistantdactylogram+"' where id="+id);
	String topage = Util.null2String(fu.getParameter("topage")) ;
	if(topage.equals(""))
		response.sendRedirect("HrmResourcePassword.jsp?id="+id);
	else
		response.sendRedirect(topage+"?id="+id);
	return;
}

if(operation.equalsIgnoreCase("changepassword")&&adtype.equals("1")) {
			String frompage = Util.null2String(fu.getParameter("frompage"));
			String RedirectFile = Util.null2String(request.getParameter("RedirectFile"));
			//String passwordnew2= Util.fromScreen3(request.getParameter("passwordnew"),user.getLanguage());
			//String passwordold1= Util.fromScreen3(request.getParameter("passwordold"),user.getLanguage());
			String passwordnew2= Util.null2String(request.getParameter("passwordnew"));
			String passwordold1= Util.null2String(request.getParameter("passwordold"));
			String id = Util.null2String(fu.getParameter("id")) ;
      if(!id.equals(String.valueOf(userid))){
      	response.sendRedirect("HrmResourcePassword.jsp?message=4&id="+id+"&frompage="+frompage+"&mode=1");
        return ;
    	}
			String adaccount = Util.null2String(request.getParameter("loginid"));
			String errorType = "";
			if(!id.equals("")){
				if(!"".equals(adaccount)){
					LdapUtil ldap=LdapUtil.getInstance();
					//System.out.println("account2:"+adaccount+"lastname:"+""+"passwordnew2:"+passwordnew2);
					java.util.HashMap map=ldap.updateUserInfo(adaccount,passwordold1,"",passwordnew2,"","0");
					String isSuccess = (String)map.get("isSuccess");
					String errorMsg = (String)map.get("errorMsg");
					errorType = (String)map.get("errorType");
					
					if(isSuccess.equals("false")){
						if("2".equals(errorType)) {
							response.sendRedirect("HrmResourcePassword.jsp?message=5&id="+id+"&frompage="+frompage+"&mode=1");
						} else if("3".equals(errorType)) {//无法连接
							response.sendRedirect("HrmResourcePassword.jsp?message=6&id="+id+"&frompage="+frompage+"&mode=1");
						}else if("4".equals(errorType)) {//证书不可使用
							response.sendRedirect("HrmResourcePassword.jsp?message=7&id="+id+"&frompage="+frompage+"&mode=1");
						}else if("5".equals(errorType)) {//证书路径错误
							response.sendRedirect("HrmResourcePassword.jsp?message=8&id="+id+"&frompage="+frompage+"&mode=1");
						}else if("6".equals(errorType)) {//证书密码错误
							response.sendRedirect("HrmResourcePassword.jsp?message=9&id="+id+"&frompage="+frompage+"&mode=1");
						}else if("7".equals(errorType)) {//证书过期
							response.sendRedirect("HrmResourcePassword.jsp?message=10&id="+id+"&frompage="+frompage+"&mode=1");
						}else {
							response.sendRedirect("HrmResourcePassword.jsp?message=4&id="+id+"&frompage="+frompage+"&mode=1");
						}
						
						return;
					} else {
						String procedurepara = id+separator+passwordold1+separator+passwordnew2 ;
						
						SysMaintenanceLog.resetParameter();
				    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
				    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
				            SysMaintenanceLog.setOperateItem("29");
				            SysMaintenanceLog.setOperateUserid(user.getUID());
				            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				    	SysMaintenanceLog.setOperateType("2");
				    	SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePassword,"+procedurepara);
				    	SysMaintenanceLog.setSysLogInfo();
						
						SysMaintenanceLog.resetParameter();
				    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
				    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
				        SysMaintenanceLog.setOperateItem("421");
				        SysMaintenanceLog.setOperateUserid(user.getUID());
				        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				    	SysMaintenanceLog.setOperateType("2");
				    	SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePassword,"+procedurepara);
				    	SysMaintenanceLog.setSysLogInfo();

						//更新修改密码时间
				    	if(rs.getDBType().equalsIgnoreCase("oracle")){
							rs.executeSql("update HrmResource set passwdchgdate = to_char(sysdate, 'yyyy-mm-dd') where id = "+id);
				    	}else{
				    		rs.executeSql("update HrmResource set passwdchgdate = convert(char(10),getdate(),20) where id = "+id);
				    	}
						
				    	if(frompage.length()<=0){
							//response.sendRedirect("HrmResource.jsp?id="+id);
							session.setAttribute("password",passwordnew2);
				    		response.sendRedirect("HrmResourcePassword.jsp?isfromtab="+isfromtab+"&RedirectFile="+RedirectFile+"&message=1&id="+id);
			    		}else{
			    			request.getSession().setAttribute("changepwd","y");
			    			String gotourl = "";
			    			if(RedirectFile.indexOf("templateId")>0){
			    				gotourl = RedirectFile+"&gopage=/hrm/resource/HrmResourcePassword.jsp?isfromtab=false&frompage="+frompage;
			    			}else{
			    				gotourl = RedirectFile+"?gopage=/hrm/resource/HrmResourcePassword.jsp?isfromtab=false&frompage="+frompage;
			    			}
							rs.executeSql("update HrmSysMaintenanceLog set operatedesc='y' where relatedid = "+userid+" and  id = (select MAX(id) from HrmSysMaintenanceLog where relatedid = "+userid+" and operatetype = 6 and operateitem = 60)");
			    			%>
							<script>
								parent.parent.getParentWindow(parent).closeDialog('<%=gotourl%>');
							</script>
							<%
							return ;
			    		}
				    	
						response.sendRedirect("HrmResourcePassword.jsp?message=1&id="+id+"&frompage="+frompage+"&mode=1");
						return;
					}
				}else{
					errorType = "3";
					response.sendRedirect("HrmResourcePassword.jsp?message=4&id="+id+"&frompage="+frompage+"&mode=1");
					return;
				}
			}
			return;
}

      if(operation.equalsIgnoreCase("changepassword")) {
      
    	 String id = Util.null2String(fu.getParameter("id")) ;
    	 String frompage = Util.null2String(fu.getParameter("frompage"));
    	 if(!id.equals(String.valueOf(userid))){
    	      response.sendRedirect("HrmResourcePassword.jsp?message=4&id="+id+"&frompage="+frompage+"&mode=1");
    	       return ;
    	 }
    	  
        String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
		String RedirectFile = Util.null2String(request.getParameter("RedirectFile"));
        if("2".equals(logintype)||!id.equals(String.valueOf(userid))){
            response.sendRedirect("HrmResource.jsp?id="+id+"&RedirectFile="+RedirectFile);
            return ;
        }

        int usertype = 0;
        if(logintype.equals("1")) usertype = 0;
        if(logintype.equals("2")) usertype = 1;
        PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,6,(logintype).equals("1") ? "0" : "1",-1);
    //	String id = ""+user.getUID() ;
    	String oripasswordold = Util.null2String(fu.getParameter("passwordold"));
    	String oripasswordnew = Util.null2String(fu.getParameter("passwordnew"));
    	String passwordnew1= Util.null2String(request.getParameter("passwordnew"));

        String isrsaopen = Util.null2String(rs.getPropValue("openRSA","isrsaopen"));//是否开启RSA
        if("1".equals(isrsaopen)){
        	List<String> rsaList = new ArrayList<String>();
        	rsaList.add(oripasswordnew);
        	rsaList.add(oripasswordnew);
        	rsaList.add(oripasswordold);
        	List<String> desList = RSA.decryptList(request,rsaList);
        	System.out.println("desList>"+desList);
        	if(desList.size() > 0){
	        	oripasswordold = desList.get(2);
	        	oripasswordnew = desList.get(0);
	        	passwordnew1 = oripasswordnew;
        	}
        	if(!RSA.getMessage().equals("0")){
              	response.sendRedirect("HrmResourcePassword.jsp?message=184&id="+id+"&frompage="+frompage+"&mode=1");
                return ;
        	}
        }
    	String passwordold= Util.getEncrypt(oripasswordold);
    	String passwordnew= Util.getEncrypt(oripasswordnew);
    	
    	
    	/*String oldpassword1 = "";
    	String oldpassword2 = "";
    	String oldpassword3 = "";
    	rs.executeSql("select password ,oldpassword1,oldpassword2 from hrmresource where id = "+id);
    	if(rs.next()){
    		oldpassword1 = rs.getString(1);
    		oldpassword2 = rs.getString(2);
    		oldpassword3 = rs.getString(3);
    	}
    	if(passwordnew.equals(oldpassword1)||passwordnew.equals(oldpassword2)||passwordnew.equals(oldpassword3)){
    		response.sendRedirect("HrmResourcePassword.jsp?message=3&id="+id+"&frompage="+frompage+"&RedirectFile="+RedirectFile);
    		return;
    	}*/
    	
    	String procedurepara = id+separator+passwordold+separator+passwordnew ;
    	rs.executeProc("HrmResource_UpdatePassword",procedurepara);

    	if (rs.next()){
			user.setPwd(passwordnew);
			session.setAttribute("weaver_user@bean", user);
    		//rs4.executeSql("update hrmresource set oldpassword1 = '"+oldpassword1+"',oldpassword2='"+oldpassword2+"' where id = "+id);
		
			//BBS集成相关
			if (!bbsLingUrl.equals("")) {
				/*取消原BBS同步方式，改用线程类
				try{
					Class s=Class.forName("weaver.bbs.UserOAToBBS");
					if (s!=null) {
						Class partypes[] = new Class[2];
						partypes[0]=String.class;
						partypes[1] = String.class;
						Method  meh=s.getMethod("changBBSUser",partypes);
				
				 
						Object arglist[] = new Object[2];
						arglist[0] = new String(user.getLoginid());
						arglist[1] = new String(passwordnew);   
						meh.invoke(s.newInstance(), arglist);
					}
				}catch (Exception ee){}
				*/
				new Thread(new weaver.bbs.BBSRunnable(user.getLoginid()+"",passwordnew)).start();
			}
		}

        RTXConfig rtxConfig = new RTXConfig();
	    String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
	    if("ELINK".equals(RtxOrElinkType)){   //修改密码同步到ELINK中

			OrganisationCom.editUser(Integer.parseInt(id));
		}

    	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
            SysMaintenanceLog.setOperateItem("29");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePassword,"+procedurepara);
    	SysMaintenanceLog.setSysLogInfo();
		
		SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("421");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePassword,"+procedurepara);
    	SysMaintenanceLog.setSysLogInfo();

   	 	// 改为自进行修正

		ResourceComInfo.updateResourceInfoCache(id);
    	
        //OA与第三方接口单条数据同步方法开始

		HrmServiceManager.SynInstantHrmResource(id,"2");  
		//OA与第三方接口单条数据同步方法结束
        
    	if(rs.getString(1).equals("2")){                   
		    response.sendRedirect("HrmResourcePassword.jsp?message=2&id="+id+"&frompage="+frompage+"&isfromtab="+isfromtab+"&RedirectFile="+RedirectFile);
		}
        else if( id.equals("1") ){
        	session.setAttribute("password",passwordnew1);
			response.sendRedirect("HrmResourcePassword.jsp?message=1&id="+id+"&RedirectFile="+RedirectFile);
		}
//update by fanggsh TD4233 begin
        else if(vo.getId()!=null&&!(vo.getId()).equals("")&&vo.getId().equals(String.valueOf(id))){
        	session.setAttribute("password",passwordnew1);
			response.sendRedirect("HrmResourcePassword.jsp?message=1&id="+id+"&RedirectFile="+RedirectFile);
		}     
//update by fanggsh TD4233 end
    	else{
    		if(frompage.length()<=0){
			//response.sendRedirect("HrmResource.jsp?id="+id);
			session.setAttribute("password",passwordnew1);
    		response.sendRedirect("HrmResourcePassword.jsp?isfromtab="+isfromtab+"&RedirectFile="+RedirectFile+"&message=1&id="+id);
    		}else{
    			request.getSession().setAttribute("changepwd","y");
    			String gotourl = "";
    			if(RedirectFile.indexOf("templateId")>0){
    				gotourl = RedirectFile+"&gopage=/hrm/resource/HrmResourcePassword.jsp?isfromtab=false&frompage="+frompage;
    			}else{
    				gotourl = RedirectFile+"?gopage=/hrm/resource/HrmResourcePassword.jsp?isfromtab=false&frompage="+frompage;
    			}
				rs.executeSql("update HrmSysMaintenanceLog set operatedesc='y' where relatedid = "+userid+" and  id = (select MAX(id) from HrmSysMaintenanceLog where relatedid = "+userid+" and operatetype = 6 and operateitem = 60)");
    			%>
				<script>
					parent.parent.getParentWindow(parent).closeDialog('<%=gotourl%>');
				</script>
				<%
    		}
		}
    	return ;
      }

      if(operation.equalsIgnoreCase("delpic")) {
    	String id = Util.null2String(fu.getParameter("id")) ;
    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)&&!id.equals(String.valueOf(userid))) {
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
    	}
    	String oldresourceimageid= Util.null2String(fu.getParameter("oldresourceimage"));
    	String firstname = Util.fromScreen3(fu.getParameter("firstname"),user.getLanguage());
    	String lastname = Util.fromScreen3(fu.getParameter("lastname"),user.getLanguage());
    	rs.executeProc("HrmResource_UpdatePic",id+separator+oldresourceimageid);

    	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(firstname+" "+lastname);
            SysMaintenanceLog.setOperateItem("29");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResource_UpdatePic,"+id+separator+oldresourceimageid);
    	SysMaintenanceLog.setSysLogInfo();

    	if(view.equals("contactinfo")){
			response.sendRedirect("HrmResourceContactEdit.jsp?id="+id+"&isView="+isView+"&isfromtab="+isfromtab);
		}else{
    		response.sendRedirect("HrmResourceBasicEdit.jsp?id="+id+"&isView="+isView+"&isfromtab="+isfromtab); 
		}
    	return ;
      }

	//新增基本信息xiao
    if(operation.equalsIgnoreCase("addresourcebasicinfo")){
    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
    	}
    	String cmd = Util.null2String(fu.getParameter("cmd"));
    	String urlFrom = Util.null2String(fu.getParameter("urlFrom"));
      String id = Util.null2String(fu.getParameter("id"));
      String workcode = Util.fromScreen3(fu.getParameter("workcode"),user.getLanguage());
      String lastname = Util.fromScreen3(fu.getParameter("lastname"),user.getLanguage()).trim();
      String sex = Util.fromScreen3(fu.getParameter("sex"),user.getLanguage());
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
			rs.executeSql("select loginid from HrmResource where id ="+belongto);
			if(rs.next()){
				loginid = rs.getString("loginid");
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

      String sql = "select managerstr, seclevel from HrmResource where id = "+Util.getIntValue(managerid);
      rs.executeSql(sql);
      String managerstr = "";
	  String seclevel = "";
      while(rs.next()){
      	String tmp_managerstr = rs.getString("managerstr");
        /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
        if(!tmp_managerstr.startsWith(","))tmp_managerstr=","+tmp_managerstr;
        if(!tmp_managerstr.endsWith(","))tmp_managerstr=tmp_managerstr+",";
        /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
          managerstr += tmp_managerstr;
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
			rst.executeSql("update hrmresource set countryid=(select countryid from HrmLocations where id="+locationid+"),"
					                      +DbFunctionUtil.getInsertUpdateSetSql(rst.getDBType(),user.getUID())+" where id="+id);
			if(falg){
				String logidsql = "update HrmResource set loginid = '"+loginid+"' where id = "+id;
				rst.executeSql(logidsql);
			}
			if(seclevel == null || "".equals(seclevel)){
				seclevel = "0";
			}
			//String p_para = id + separator + departmentid + separator + subcmpanyid1 + separator + managerid + separator + seclevel + separator + managerstr + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0";

			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
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
      //rs.executeProc("HrmResourceDefine_Update",para);

      rs.executeProc("HrmResource_CreateInfo",""+id+separator+userpara+separator+userpara);
      
      //
      HrmUserSettingManager.checkUserSettingInit(Integer.parseInt(id)) ;

      // 改为只进行该人缓存信息的添加
      ResourceComInfo.addResourceInfoCache(id);
	  
	  try{ 
	        if(Integer.parseInt(belongto) > 0){
	        	new ResourceBelongtoComInfo().updateCache(belongto);
	        }
       }catch(Exception e){
			rs.writeLog(e.getMessage());
	   }

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

        CoreMailAPI coremailapi = CoreMailAPI.getInstance();
	    coremailapi.synUser(id);
	    //CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
	    //testapi.synUser(id);

     	if(software.equals("KM") || software.equals("CRM")){
    		response.sendRedirect("HrmResource.jsp?isclose=1&id="+id);
      }else if( cmd.equals("SaveAndNew")){
    		response.sendRedirect("HrmResourceAdd.jsp?departmentid="+departmentid);
    		return;
    	}else if(cmd.equals("SaveAndNext")){
    		response.sendRedirect("HrmResourceAddTwo.jsp?id="+id);
    		return;
    	}else{
    		response.sendRedirect("/hrm/search/HrmResourceSearchTmp.jsp?isclose=1&department="+departmentid);
      }
      return;
    }

    if(operation.equalsIgnoreCase("addresourcepersonalinfo")){
    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
    	}
      String id = Util.null2String(fu.getParameter("id"));
      String birthday = Util.fromScreen3(fu.getParameter("birthday"),user.getLanguage());
      String folk = Util.fromScreen3(fu.getParameter("folk"),user.getLanguage()) ;	 /*民族*/
      String nativeplace = Util.fromScreen3(fu.getParameter("nativeplace"),user.getLanguage()) ;	/*籍贯*/
      String regresidentplace = Util.fromScreen3(fu.getParameter("regresidentplace"),user.getLanguage()) ;	/*户口所在地*/
      String maritalstatus = Util.fromScreen3(fu.getParameter("maritalstatus"),user.getLanguage());
      String policy = Util.fromScreen3(fu.getParameter("policy"),user.getLanguage()) ; /*政治面貌*/
      String bememberdate = Util.fromScreen3(fu.getParameter("bememberdate"),user.getLanguage()) ;	/*入团日期*/
      String bepartydate = Util.fromScreen3(fu.getParameter("bepartydate"),user.getLanguage()) ;	/*入党日期*/
      String islabourunion = Util.fromScreen3(fu.getParameter("islabouunion"),user.getLanguage()) ;
      String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel"),user.getLanguage()) ;/*学历*/
      String degree = Util.fromScreen3(fu.getParameter("degree"),user.getLanguage()) ; /*学位*/
      String healthinfo = Util.fromScreen3(fu.getParameter("healthinfo"),user.getLanguage()) ;/*健康状况*/
      String height = Util.null2o(fu.getParameter("height")) ;/*身高*/
      String weight = Util.null2o(fu.getParameter("weight")) ;
      String residentplace = Util.fromScreen3(fu.getParameter("residentplace"),user.getLanguage()) ;	/*现居住地*/
      String homeaddress = Util.fromScreen3(fu.getParameter("homeaddress"),user.getLanguage()) ;
      String tempresidentnumber = Util.fromScreen3(fu.getParameter("tempresidentnumber"),user.getLanguage()) ;
      String certificatenum = Util.fromScreen3(fu.getParameter("certificatenum"),user.getLanguage()) ;/*证件号码*/
      certificatenum=certificatenum.trim();
      String tempcertificatenum=certificatenum;
        int msg=0;
        if(!certificatenum.equals("")){
			rs.executeSql("select accounttype,certificatenum from HrmResource where id="+id);
			String accountType = "", tempCertificatenum = "";
			if(rs.next()){
				accountType = Util.null2String(rs.getString("accounttype"));
				tempCertificatenum = Util.null2String(rs.getString("certificatenum"));
			}
			if(!accountType.equals("1")) {
				rs.executeSql("select id from HrmResource where id<>"+id+" and certificatenum='"+certificatenum+"' and accounttype != '1'");
				if(rs.next()){
					msg=1;
					tempcertificatenum = tempCertificatenum;
				}
			}			
        }
      para = ""+id+	separator+birthday+separator+folk+separator+nativeplace+separator+regresidentplace+separator+
             maritalstatus+	separator+policy+separator+bememberdate+separator+bepartydate+separator+islabourunion+
             separator+educationlevel+separator+degree+separator+healthinfo+separator+height+separator+weight+
             separator+residentplace+separator+homeaddress+separator+tempresidentnumber+separator+tempcertificatenum;

      rs.executeProc("HrmResourcePersonalInfo_Insert",para);
      rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);

      int rownum = Util.getIntValue(fu.getParameter("rownum"),user.getLanguage()) ;
      for(int i = 0;i<rownum;i++){
        String member = Util.fromScreen3(fu.getParameter("member_"+i),user.getLanguage());
        String title = Util.fromScreen3(fu.getParameter("title_"+i),user.getLanguage());
        String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage());
        String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage());
        String address = Util.fromScreen3(fu.getParameter("address_"+i),user.getLanguage());
        String info = member+title+company+jobtitle+address;
        if(!(info.trim().equals(""))){
        para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle+separator+address;
        rs.executeProc("HrmFamilyInfo_Insert",para);
        }
      }

            SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
            SysMaintenanceLog.setOperateItem("29");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourcePersonalInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();
    	
        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));

      if(msg==1)
            response.sendRedirect("HrmResourcePersonalEdit.jsp?id="+id+"&isView="+isView+"&msg=1&iscreate=1&certificatenum="+certificatenum);
      else
            response.sendRedirect("HrmResourceAddThree.jsp?id="+id);
      return;
    }

    if(operation.equalsIgnoreCase("addresourceworkinfo")){
    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
    	}
      String id = Util.null2String(fu.getParameter("id"));
      String usekind = Util.fromScreen3(fu.getParameter("usekind"),user.getLanguage()) ;
      String startdate = Util.fromScreen3(fu.getParameter("startdate"),user.getLanguage()) ;
      String probationenddate = Util.fromScreen3(fu.getParameter("probationenddate"),user.getLanguage()) ;
      String enddate = Util.fromScreen3(fu.getParameter("enddate"),user.getLanguage()) ;

      para = ""+id+	separator+usekind+separator+startdate+separator+probationenddate+separator+ enddate;
      rs.executeProc("HrmResourceWorkInfo_Insert",para);
      rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);

      para=""+id+separator+"0";
      //rs.executeProc("DocUserCategory_InsertByUser",para);

      int edurownum = Util.getIntValue(fu.getParameter("edurownum"),0);
      for(int i = 0;i<edurownum;i++){
        String school = Util.fromScreen3(fu.getParameter("school_"+i),user.getLanguage()) ;
        String speciality = Util.fromScreen3(fu.getParameter("speciality_"+i),user.getLanguage()) ;
        String edustartdate = Util.fromScreen3(fu.getParameter("edustartdate_"+i),user.getLanguage()) ;
        String eduenddate = Util.fromScreen3(fu.getParameter("eduenddate_"+i),user.getLanguage()) ;
        String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel_"+i),user.getLanguage()) ;
        String studydesc = Util.fromScreen3(fu.getParameter("studydesc_"+i),user.getLanguage()) ;

        String info = school+speciality+edustartdate+eduenddate+educationlevel+studydesc;
        if(!info.trim().equals("")){
        para = ""+id+separator+edustartdate+separator+eduenddate+separator+school+separator+speciality+
        	    separator+educationlevel+separator+studydesc;
        rs.executeProc("HrmEducationInfo_Insert",para);
        }
      }

      int lanrownum = Util.getIntValue(fu.getParameter("lanrownum"),0);
      for(int i = 0;i<lanrownum;i++){
        String language = Util.fromScreen3(fu.getParameter("language_"+i),user.getLanguage()) ;
        String level = Util.fromScreen3(fu.getParameter("level_"+i),user.getLanguage()) ;
        String memo = Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage()) ;
    	String info = language+memo;
    	if(!info.trim().equals("")){
        para = ""+id+separator+language+separator+level+separator+memo;
        rs.executeProc("HrmLanguageAbility_Insert",para);
    	}
      }

      int workrownum = Util.getIntValue(fu.getParameter("workrownum"),0);
      for(int i = 0;i<workrownum;i++){
        String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage()) ;
        String workstartdate = Util.fromScreen3(fu.getParameter("workstartdate_"+i),user.getLanguage()) ;
        String workenddate = Util.fromScreen3(fu.getParameter("workenddate_"+i),user.getLanguage()) ;
        String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage()) ;
        String workdesc = Util.fromScreen3(fu.getParameter("workdesc_"+i),user.getLanguage()) ;
        String leavereason = Util.fromScreen3(fu.getParameter("leavereason_"+i),user.getLanguage()) ;

        String info = company+workstartdate+workenddate+jobtitle+workdesc+leavereason;
        if(!info.trim().equals("")){
        para = ""+id+separator+workstartdate+separator+workenddate+separator+company+separator+jobtitle+
        	    separator+workdesc+separator+leavereason;
        rs.executeProc("HrmWorkResume_Insert",para);
        }
      }

      int trainrownum = Util.getIntValue(fu.getParameter("trainrownum"),0);
      for(int i = 0;i<trainrownum;i++){
        String trainname = Util.fromScreen3(fu.getParameter("trainname_"+i),user.getLanguage()) ;
        String trainstartdate = Util.fromScreen3(fu.getParameter("trainstartdate_"+i),user.getLanguage()) ;
        String trainenddate = Util.fromScreen3(fu.getParameter("trainenddate_"+i),user.getLanguage()) ;
        String trainresource = Util.fromScreen3(fu.getParameter("trainresource_"+i),user.getLanguage()) ;
        String trainmemo = Util.fromScreen3(fu.getParameter("trainmemo_"+i),user.getLanguage()) ;

        String info = trainname+trainstartdate+trainenddate+trainresource+trainmemo;
        if(!info.trim().equals("")){
        para = ""+id+separator+trainname+separator+trainresource+separator+trainstartdate+separator+trainenddate+
        	    separator+trainmemo;

        rs.executeProc("HrmTrainBeforeWork_Insert",para);
        }
      }

      int rewardrownum = Util.getIntValue(fu.getParameter("rewardrownum"),0);
      for(int i = 0;i<rewardrownum;i++){
        String rewardname = Util.fromScreen3(fu.getParameter("rewardname_"+i),user.getLanguage()) ;
        String rewarddate = Util.fromScreen3(fu.getParameter("rewarddate_"+i),user.getLanguage()) ;
        String rewardmemo = Util.fromScreen3(fu.getParameter("rewardmemo_"+i),user.getLanguage()) ;
        String info = rewardname+rewarddate+rewardmemo;
        if(!info.trim().equals("")){
        para = ""+id+separator+rewardname+separator+rewarddate+separator+rewardmemo;

        rs.executeProc("HrmRewardBeforeWork_Insert",para);
        }
      }

      int cerrownum = Util.getIntValue(fu.getParameter("cerrownum"),0);

      for(int i = 0;i<cerrownum;i++){
        String cername = Util.fromScreen3(fu.getParameter("cername_"+i),user.getLanguage()) ;
        String cerstartdate = Util.fromScreen3(fu.getParameter("cerstartdate_"+i),user.getLanguage()) ;
        String cerenddate = Util.fromScreen3(fu.getParameter("cerenddate_"+i),user.getLanguage()) ;
        String cerresource = Util.fromScreen3(fu.getParameter("cerresource_"+i),user.getLanguage()) ;

        String info = cername+cerstartdate+cerenddate+cerresource;
        if(!info.trim().equals("")){
        para = ""+id+separator+cerstartdate +separator+cerenddate +separator+cername+separator+cerresource;

        rs.executeProc("HrmCertification_Insert",para);
        }
      }


    // 工作信息不需要清理缓存 ResourceComInfo.removeResourceCache();

        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));


        SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourceWorkInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();
        String isNewAgain = Util.fromScreen3(fu.getParameter("isNewAgain"),user.getLanguage()) ;
        if(isNewAgain.equals("1")){
            String deptid=ResourceComInfo.getDepartmentID(id);
            response.sendRedirect("/hrm/resource/HrmResourceAdd.jsp?departmentid="+deptid);
            return ;
        }
        //response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id);
        response.sendRedirect("/hrm/search/HrmResourceSearchResult.jsp?from=HrmResourceAdd");
        return;
    }

    if(operation.equalsIgnoreCase("addresourcefinanceinfo")){
	    	if(!HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit",user)) {
	    		response.sendRedirect("/notice/noright.jsp") ;
	    		return ;
	    	}
        String id = Util.null2String(fu.getParameter("id"));

        String bankid1 = Util.null2String(fu.getParameter("bankid1"));
        String accountid1 = Util.null2String(fu.getParameter("accountid1"));
        String accumfundaccount = Util.null2String(fu.getParameter("accumfundaccount"));
        String accountname = Util.null2String(fu.getParameter("accountname"));

        para = ""+id+	separator+bankid1+separator+accountid1+separator+accumfundaccount+separator+accountname;
        rs.executeProc("HrmResourceFinanceInfo_Insert",para);
        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
        rs.executeProc("HrmInfoStatus_UpdateFinance",""+id);

        rs.executeProc("HrmInfoStatus_UpdateFinance",""+id);
        // 财务信息不需要清理人力资源缓存 ResourceComInfo.removeResourceCache();

        SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("HrmResourceFinanceInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();

        response.sendRedirect("/hrm/resource/HrmResourceFinanceView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
        return;
    }

//增加系统信息xiao
    if(operation.equalsIgnoreCase("addresourcesysteminfo")){
    
		//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
		int hrmdetachable=0;
		if(session.getAttribute("hrmdetachable")!=null){
		    hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
		}else{
			boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
			if(isUseHrmManageDetach){
			   hrmdetachable=1;
			   session.setAttribute("detachable","1");
			   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
			}else{
			   hrmdetachable=0;
			   session.setAttribute("detachable","0");
			   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
			}
		}  
	String id = Util.null2String(fu.getParameter("id"));
           int hrmoperatelevel=-1;
         if(hrmdetachable==1){
             String deptid=ResourceComInfo.getDepartmentID(id);
             String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
             hrmoperatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Util.getIntValue(subcompanyid));
         }else{
			String departmentidtmp = ResourceComInfo.getDepartmentID(id);
			if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All",user,departmentidtmp)){
				hrmoperatelevel=2;
			}
        }
         boolean iss = ResourceComInfo.isSysInfoView(userid,id);
        if(!(hrmoperatelevel>0) && !iss){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
    	}
     	 String password = Util.null2String(fu.getParameter("password"));

         String isrsaopen = Util.null2String(rs.getPropValue("openRSA","isrsaopen"));//是否开启RSA
         if("1".equals(isrsaopen)){
         	List<String> rsaList = new ArrayList<String>();
         	rsaList.add(password);
         	List<String> desList = RSA.decryptList(request,rsaList);
         	System.out.println("desList>"+desList);
         	if(desList.size() > 0){
         		password = desList.get(0);
         	}
         	if(!RSA.getMessage().equals("0")){
				response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=184");
                 return ;
         	}
         }
     	 
     	String oldpassword = "";
     	String oldloginid = "";
     	//String oldLginid = 
     	String loginid = Util.null2String(fu.getParameter("loginid"));
     	String isADAccount = Util.null2String(request.getParameter("isADAccount"));
     	//修改AD域密码

     	if(mode.equals("ldap") && "1".equals(isADAccount)) {
			//String adpasswordconfirm= Util.fromScreen3(request.getParameter("passwordconfirm"),user.getLanguage());
		
			rs.executeSql("select * from hrmresource where id="+id);
			if(rs.next()) {
				oldloginid = rs.getString("loginid");
				oldpassword  = rs.getString("password");
			}
			String errorType = "";
			int  flage = 0;
			if(!id.equals("")){
				if(!"".equals(loginid)){
					 ResourceComInfo.setTofirstRow();
					 while(ResourceComInfo.next()) {
					 	if(loginid.equals(ResourceComInfo.getLoginID())&&!id.equals(ResourceComInfo.getResourceid())){
             				response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=1&usingid="+ResourceComInfo.getResourceid());
            				flage = 1;
            				break;
          				}
					}
					if(flage == 1) {
						return;
					}
					LdapUtil ldap=LdapUtil.getInstance();
					//if this account is in ad
					String samaccountname = ldap.authenticuser(loginid);	
					if(samaccountname == null) {
						response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=2");
						return;
					} else if("uac".equals(samaccountname)) {//账号被禁用

						response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=9");
						return;
					} else {
					//将AD中的账号取出来 作为loginid。因为在查询的时候不区分大小写，而SQLSERVER数据库区分大小写，账号以ad为准
						//loginid = samaccountname;
					}
					
					//System.out.println("account2:"+adaccount+"lastname:"+""+"passwordnew2:"+adpasswordconfirm);
					if(!"".equals(password)) {
						java.util.HashMap map = ldap.updateUserInfo(loginid,password,"",password,"","1");
						String isSuccess = (String)map.get("isSuccess");
						String errorMsg = (String)map.get("errorMsg");
						errorType = (String)map.get("errorType");
						
						if(isSuccess.equals("false")){
							if("2".equals(errorType)) {//账号不存在

								response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=2");
							} else if("3".equals(errorType)) {//无法连接
								response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=3");
							}else if("4".equals(errorType)) {//证书不可使用
								response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=4");
							}else if("5".equals(errorType)) {//证书路径错误
								response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=5");
							}else if("6".equals(errorType)) {//证书密码错误
								response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=6");
							} else if("7".equals(errorType)) {//证书过期
								response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=8");
							}else {//不符合密码策略

								response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=7");
							}
							
							return;
						} else {
						}
					}
				}else{
				}
			}
		}
		
        String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户  
        int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
        hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
        int operatelevel=0;
        if(hrmdetachable==1 && user.getUID()!=1){
            String deptid=ResourceComInfo.getDepartmentID(id);
            String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ; 
			if(subcompanyid==null||"".equals(subcompanyid)){
				rs.executeSql("select Subcompanyid1 from hrmresource where id = "+id);
				if(rs.next()) subcompanyid = Util.null2String(rs.getString("Subcompanyid1"));
			}
			if(subcompanyid!=null&&!"".equals(subcompanyid))
			operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ResourcesInformationSystem:All",Integer.parseInt(subcompanyid));
        }else{
            if(HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user))
                operatelevel=2;
        }
        if("2".equals(logintype)||!(iss || operatelevel>0)){  
           rs.writeLog("illegal attack user"); response.sendRedirect("/hrm/resource/HrmResourceSystemView.jsp?id="+id+"&isView="+isView);
            return ;
        }

      //String loginid = Util.null2String(fu.getParameter("loginid"));
      
      int passwordlock = Util.getIntValue(Util.null2String(fu.getParameter("passwordlock")),0);
      //String account = Util.null2String(fu.getParameter("account"));
     // if("ldap".equals(mode)) {
      //	account = adaccount;
     // }
     
      if(logintype.equals("1") && !loginid.equalsIgnoreCase("")){//如果是内部用户，且本次的loginid不为空

        	String oldLoginId = "";
  			rs.executeSql("select loginid from HrmResource where id ="+id);//查询这个用户之前的loginid
  			if(rs.next()){
  				oldLoginId = Util.null2String(rs.getString(1));
  			}
  			if("".equals(oldLoginId)) {//如果旧loginid为空，检查license数量
  				if(LN.CkHrmnum() >= 0){
  		    		response.sendRedirect("HrmResourceSystemEdit.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView+"&errmsg=2");
  		    		return;
  				}
  			}
  		}
     

      String enc_account="";
      if(!loginid.equals(""))
      enc_account=Util.getEncrypt(loginid);
     // String password = Util.fromScreen3(fu.getParameter("password"),user.getLanguage());
      if(!password.equals("qwertyuiop"))  password = Util.getEncrypt(password);
      else password = "0" ;
      String systemlanguage = Util.null2String(fu.getParameter("systemlanguage"));
      if(systemlanguage.equals("")||systemlanguage.equals("0")) systemlanguage = "7";

      int seclevel = Util.getIntValue(fu.getParameter("seclevel"),0);
      String email = Util.null2String(fu.getParameter("email"));
      String needdynapass= String.valueOf(Util.null2String(fu.getParameter("needdynapass"))); 
	  String passwordstate= String.valueOf(Util.null2String(fu.getParameter("passwordstate"))); 	
      //int passwordstate = Util.getIntValue(fu.getParameter("passwordstate"),1);
	  //System.out.println(passwordstate.equals("0")||passwordstate.equals("2"));
	  if(passwordstate.equals("0")||passwordstate.equals("2")){
	        needdynapass = "1";
	  }else{
	        needdynapass="0";  
	  }

		//Start 手机接口功能 by alan
		rs.executeSql("DELETE FROM workflow_mgmsusers WHERE userid="+id);
		if(!Util.null2String(request.getParameter("isMgmsUser")).equals("")){
			rs.executeSql("INSERT INTO workflow_mgmsusers(userid) VALUES ("+id+")");
		}	
		//End 手机接口功能 by alan
	  	
      //xiaofeng
      String needusb= Util.null2String(fu.getParameter("needusb"));
      if(!needusb.equals("1"))
      needusb="0";
      String old_needusb= Util.null2String(fu.getParameter("old_needed"));
      if(!old_needusb.equals("1"))
      old_needusb="0";
      String serial= Util.null2String(fu.getParameter("serial"));
	  String username = Util.null2String(fu.getParameter("username"));

	  RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
	  String usbType = settings.getUsbType();
	  String userUsbType=Util.null2String(fu.getParameter("userUsbType"));
	  String tokenkey=Util.null2String(fu.getParameter("tokenKey"));
	  
	  String serial21 =Util.null2String(fu.getParameter("serial21")) ;
      if("21".equals(userUsbType) && StringUtils.isNotBlank(serial21)){
    	  rs.execute("select 1 from hrmresource where id !="+id+" and userUsbType='21' and serial='"+serial21+"'") ;
    	  if(rs.next()){
    		  response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=-21");
    		  return ;
    	  }
      }
      
	  //if(loginid.equals("")&&needusb.equals("0")&&!userUsbType.equals("2")){
	  		
		//	loginid=account;
		//  }
	  //if("".equals(account)||(needusb.equals("1") && userUsbType.equals("2"))){
		//  account = username;
	  //}
	  
      if((needusb.equals("1")&&old_needusb.equals("1")&&serial.equals(""))||(!needusb.equals("1")&&!old_needusb.equals("1"))) serial="0"; //如果该用户的序列号不做变更

		String usbstate = Util.null2String(fu.getParameter("usbstate"));
		StringBuffer upSql = new StringBuffer("update HrmResource set");
		if(userUsbType.equals("4")){
			needdynapass = "1";
			needusb = "0";
		}else if(userUsbType.equals("2") || userUsbType.equals("3")){
			needdynapass = "0";
			needusb = "1";
		}else{
			//解绑辅助验证方式
			needdynapass = "0" ;
			needusb="0" ;
		}
	if(!"".equals(usbstate) && !"".equals(userUsbType)){
	 upSql.append(" needusb = ").append(needusb)
	 .append(" ,usbstate = ").append(usbstate)
	 .append(" ,needdynapass = ").append(needdynapass)
	 .append(" ,userUsbType = ").append(userUsbType)
	 .append(" where id = ").append(id);
	 rs.executeSql(upSql.toString());
	}
      
      String oldLoginid="";
      //if(mode.equals("ldap")){
      //不覆盖loginid
    	  //loginid=account;
    	  
     // }
      //para = ""+id+	separator+loginid+separator+password+separator+systemlanguage+separator+seclevel+separator+email+separator+needusb+separator+serial+separator+account+separator+enc_account+separator+needdynapass+separator+passwordstate;
      if("1".equals(isADAccount)) {//修改AD账户的密码不同步到人员信息表中,所以把旧密码赋给password
      	password = oldpassword;
      }
      para = ""+id+	separator+loginid+separator+password+separator+systemlanguage+separator+seclevel+separator+email+separator+needusb+separator+serial+separator+""+separator+enc_account+separator+needdynapass+separator+passwordstate;
      //System.out.println("para = " + para);
      ResourceComInfo.setTofirstRow();
      //while(!account.equals("")&&ResourceComInfo.next()){
      //    if(ResourceComInfo.getAccount().equals(account)&&!ResourceComInfo.getResourceid().equals(id)){
      //        response.sendRedirect("HrmResourceSystemEdit.jsp?id="+id+"&isView="+isView+"&errmsg=1");
      //       return ;
      //    }
      //}
//      HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
       if(!loginid.equals("") && dao.ifHaveSameLoginId(loginid,id)){  //检测loginid重名
       	  rs.executeSql("select id from hrmresource where loginid='"+loginid+"'"); 
       	  if(rs.next()) {
       	  	String theid = rs.getString("id");
       	  	response.sendRedirect("HrmResourceSystemEdit.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView+"&errmsg=1&&usingid="+theid);
         	return ;
       	  }
          
      }else{

		rs.executeSql("select * from HrmResource where id = "+Util.getIntValue(id));
		String olddepartmentid = "";
		String oldmanagerid = "";
		String oldsubcompanyid1 = "";
		String oldseclevel = "";
		String oldmanagerstr = "";
		
		String lastname="";
		String oldTokenKey="";
		
		while(rs.next()){
		olddepartmentid = rs.getString("departmentid");
		oldmanagerid = rs.getString("managerid");
		oldsubcompanyid1 = rs.getString("subcompanyid1");
		oldseclevel = rs.getString("seclevel");
		oldmanagerstr = rs.getString("managerstr");
    /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
    if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
    if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
    /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
		lastname=rs.getString("lastname");
		
		oldLoginid = rs.getString("loginid");
		oldTokenKey = rs.getString("tokenKey");
		}
		
		String falgtmp = "1";//"1"表示修改,"0"表示新增
		if("".equals(oldLoginid) && !"".equals(loginid)) {  //使用登陆名的情况下，将会在Rtx中新增一用户
			falgtmp = "0";
			if(!loginid.equals(oldLoginid)) {//修改用户名的情况下新添加用户
				//OrganisationCom.deleteUser2(oldLoginid);
				new Thread(new OrganisationComRunnable("user","del2",id)).start();
			}
		}

		//修改用户名的情况下Rtx中去除这一用户用户
		if(!"".equals(oldLoginid) && !"".equals(loginid) && !oldLoginid.equals(loginid)) {
			//OrganisationCom.deleteUser2(oldLoginid);
			new Thread(new OrganisationComRunnable("user","del2",id)).start();
		}

		boolean ret = false;
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
	   		 //if(mode.equals("ldap")){  //开启ad域

	    		//System.out.println(para);
			//	ret=rst.executeProc("HrmResourceSystemInfo_Insert1",para);  //不检测 loginid重名
			// }
			// else{
			 //  ret=rst.executeProc("HrmResourceSystemInfo_Insert",para);
			// }
			
			 ret=rst.executeProc("HrmResourceSystemInfo_Insert",para);
			//保存指定的usbType和tokenkey
			if(userUsbType.equals("2")){
				rst.execute("update hrmresource set userUsbType="+userUsbType+",serial='"+(serial.equals("0")?"":serial)+"' where id="+id);
			} else if(userUsbType.equals("3")){
				rst.execute("update hrmresource set userUsbType="+userUsbType+",tokenkey='"+tokenkey+"' where id="+id);
			}else if("21".equals(userUsbType)){
				rst.execute("update hrmresource set userUsbType="+userUsbType+",serial='"+serial21+"' where id="+id);
			}
			
			if(user.getLoginid().equals(loginid)){
				String languid = String.valueOf(systemlanguage); 
				Cookie syslanid = new Cookie("Systemlanguid",languid);
				syslanid.setMaxAge(-1);
				syslanid.setPath("/");
				response.addCookie(syslanid);
			}

			//String p_para = id + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + seclevel + separator + oldmanagerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + falgtmp;

			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}
		VerifyPasswdCheck.unlockOrLockPassword(id,passwordlock);
      if(ret){
          if(needdynapass.equals("1")){
            rs.executeSql("select id from hrmpassword where id='"+id+"'") ;
              if(rs.next()) ;
              else{                 
              rs.executeSql("insert into hrmpassword(id,loginid) values("+id+",'"+loginid+"')") ;
              }
          }

      }else{

      }
      }
      //db2
      //rsdb2.executeProc("Tri_UMMInfo_ByHrmResourceManager",""+id);
      if (RecordSetDB.getDBType().equals("db2")){
        rsdb2.executeProc("Tri_UMMInfo_ByHrmResource",""+id); //主菜单


        String departmentid=ResourceComInfo.getDepartmentID(id);

        //System.out.println(""+id+separator+loginid+separator+departmentid+separator+seclevel);
        //rsdb2.executeProc("Tri_U_workflow_createlist_1",""+id+separator+loginid+separator+departmentid+separator+seclevel); //工作流菜单

        /*

        CREATE procedure Tri_U_W_createl
        (
        in id int,
        in loginid varchar(60),
        in departmentid int ,
        in seclevel int
        )*/


		//文档菜单
		/*
		CREATE procedure Tri_U_HrmresourceShare_ini
		(
		in id integer ,
		in departmentid integer,
		in olddepartmentid integer,
		in subcompanyid1 integer,
		in seclevel integer,
		in oldseclevel integer,
		in managerstr varchar(200)
		)
		*/
		String oldSeclevel =ResourceComInfo.getSeclevel(id);
		String managerid=ResourceComInfo.getManagerID(id);

		String sql = "select managerstr from HrmResource where id = "+Util.getIntValue(managerid);
		rs.executeSql(sql);
		String managerstr = "";
		while(rs.next()){
			String tmp_managerstr = rs.getString("managerstr");
	     /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
      if(!tmp_managerstr.startsWith(","))tmp_managerstr=","+tmp_managerstr;
      if(!tmp_managerstr.endsWith(","))tmp_managerstr=tmp_managerstr+",";
      /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
		managerstr += tmp_managerstr;
			
		managerstr +=   managerid + "," ;
		};

	//rsdb2.executeProc("Tri_U_HrmresourceShare_ini",""+id+separator+departmentid+separator+departmentid+DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(id))+separator+seclevel+separator+oldSeclevel+separator+managerstr);




      }


      rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
      rs.executeProc("HrmInfoStatus_UpdateSystem",""+id);

      para = ""+id+	separator+loginid+separator+"1";
      rs.executeProc("Ycuser_Insert",para);

      para = ""+seclevel+separator+ResourceComInfo.getDepartmentID(id)+separator+DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(id))+separator+id;
      rs.executeProc("MailShare_InsertByUser",para);
      //log usb setting
      if(!old_needusb.equals("1")&&needusb.equals("1")){
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateItem("89");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setOperateType("7");
      SysMaintenanceLog.setOperateDesc("HrmResourceSystemInfo_USB");
      SysMaintenanceLog.setSysLogInfo();
      }
      if(old_needusb.equals("1")&&!needusb.equals("1")){
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateItem("89");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setOperateType("8");
      SysMaintenanceLog.setOperateDesc("HrmResourceSystemInfo_USB");
      SysMaintenanceLog.setSysLogInfo();
      }
      //add by wjy
      //同步RTX端的用户信息.
      boolean isAdd = false;
      //OrganisationCom.checkUser(Integer.parseInt(id));
      if(("".equals(oldLoginid) && !"".equals(loginid))||(!loginid.equals(oldLoginid)&&!"".equals(loginid))) {  //使用登陆名的情况下，将会在Rtx中新增一用户
			if(!loginid.equals(oldLoginid)) {//修改用户名的情况下新添加用户
				//OrganisationCom.addUser(Util.getIntValue(id));
				new Thread(new OrganisationComRunnable("user","add",id)).start();
				isAdd = true;
			}

		} else if(!"".equals(oldLoginid) && "".equals(loginid)) {  //去除登陆名的情况下，将会在Rtx中去除这一用户
			new Thread(new OrganisationComRunnable("user","del2",id)).start();
		}
      if(!isAdd && !"".equals(loginid))
      {
      	//OrganisationCom.editUser(Integer.parseInt(id));
		new Thread(new OrganisationComRunnable("user","edit",id)).start();
      }
	// 改为自进行修正

      ResourceComInfo.updateResourceInfoCache(id);

      PluginUserCheck.clearPluginUserCache("messager");

	  //OA与第三方接口单条数据同步方法开始

	  HrmServiceManager.SynInstantHrmResource(id,"1");  
	  //OA与第三方接口单条数据同步方法结束

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
      SysMaintenanceLog.setOperateItem("29");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      if("1".equals(isEdit)){
	      SysMaintenanceLog.setOperateType("2");
      }else{
		  SysMaintenanceLog.setOperateType("1");
      }
      SysMaintenanceLog.setOperateDesc("HrmResourceSystemInfo_Insert");
      SysMaintenanceLog.setSysLogInfo();

	//if("ldap".equals(mode)) {
	//	rs.executeSql("update HrmResource set account='"+adaccount+"',loginid='"+oldloginid+"' where id='"+id+"'");
	//}
	//更新账户的状态 是否为AD的账户

	if("ldap".equals(mode)) {
		if("1".equals(isADAccount)) {
			rs.executeSql("update HrmResource set isADAccount='1' where id='"+id+"'");
		} else {
			rs.executeSql("update HrmResource set isADAccount=NULL where id='"+id+"'");
		}
	}
		SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("421");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourceSystemInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();

		
		//BBS集成相关
		if (!password.equals("0")) {
			if (!bbsLingUrl.equals("")) {
				/*取消原BBS同步方式，改用线程类
				try{
					Class s=Class.forName("weaver.bbs.UserOAToBBS");
						
					if (s!=null) {
						Class partypes[] = new Class[2];
						partypes[0]=String.class;
						partypes[1] = String.class;
						Method  meh=s.getMethod("changBBSUser",partypes);
				
						Object arglist[] = new Object[2];
						arglist[0] = new String(loginid);
						arglist[1] = new String(password); 
						Boolean bbsStatus =(Boolean) meh.invoke(s.newInstance(), arglist);
						if(!bbsStatus){
							response.sendRedirect("HrmResourceSystemEdit.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView+"&errmsg=bbserror");
							//response.sendRedirect("HrmResourceSystemEdit.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView+"&errmsg=1&&usingid="+theid);
					        return ;
						}
					}
				}catch (Exception e){
				}
				*/
				new Thread(new weaver.bbs.BBSRunnable(loginid,password)).start();
			}
		}
 
        CoreMailAPI coremailapi = CoreMailAPI.getInstance();
	    coremailapi.synUser(id);
	    //CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
	    //testapi.synUser(id);

      response.sendRedirect("/hrm/resource/HrmResourceSystemView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
      return;
    }

	//修改基本信息xiao
    if(operation.equalsIgnoreCase("editbasicinfo")){
	    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
	    		response.sendRedirect("/notice/noright.jsp") ;
	    		return ;
	    	}
    		String isDialog = Util.null2String(fu.getParameter("isDialog"));
    		String urlFrom = Util.null2String(fu.getParameter("urlFrom"));
        String id = Util.null2String(fu.getParameter("id"));
        String workcode = Util.fromScreen3(fu.getParameter("workcode"),user.getLanguage());
        String lastname = Util.fromScreen3(fu.getParameter("lastname"),user.getLanguage()).trim();
        String sex = Util.fromScreen3(fu.getParameter("sex"),user.getLanguage());

        String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
        String oldresourceimageid= Util.null2String(fu.getParameter("oldresourceimage"));
        if(resourceimageid.equals("")) resourceimageid=oldresourceimageid ;

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
        String email = Util.fromScreen3(fu.getParameter("email"),user.getLanguage());
        String dsporder = Util.fromScreen3(fu.getParameter("dsporder"),user.getLanguage());
        String jobcall = Util.fromScreen3(fu.getParameter("jobcall"),user.getLanguage());
        String systemlanguage = Util.fromScreen3(fu.getParameter("systemlanguage"),user.getLanguage());
        if(systemlanguage.equals("")||systemlanguage.equals("0")){
         systemlanguage = "7";
        }
				String accounttype = Util.fromScreen3(fu.getParameter("accounttype"),user.getLanguage());
        String belongto = Util.fromScreen3(fu.getParameter("belongto"),user.getLanguage());
				if(accounttype.equals("0")){
				belongto="-1";
				}
		
		//Td9325,解决多账号次账号没有登陆Id在浏览框组织结构中无法显示的问题。

		String oldbelongto ="";
	    boolean falg = false;
		String loginid = "";
		rs3.executeSql("select * from HrmResource where id ="+id);
		if(rs3.next()){
					loginid = rs3.getString("loginid");
					float idsporder = rs3.getFloat("dsporder");
					if(idsporder<=0){
						dsporder = rs3.getString("id");
					}else{
						dsporder = ""+idsporder;
					}

					String thisAccounttype = rs3.getString("accounttype");
					if(thisAccounttype.equals("1")&&accounttype.equals("0")){
						oldbelongto = rs3.getString("belongto");
					}
		}
		
		if(accounttype.equals("1") && loginid.equalsIgnoreCase("")){
				rs.executeSql("select loginid from HrmResource where id ="+belongto);
				if(rs.next()){
					loginid = rs.getString(1);
				}
				if(LN.CkHrmnum() >= 0){
		    		response.sendRedirect("HrmResourceBasicEdit.jsp?id="+id+"&ifinfo=y&isfromtab=true");
		    		return;
				}
				if(!loginid.equals("")){
					//String maxidsql = "select max(id) as id from HrmResource where loginid like '"+loginid+"%'";
					//rs.executeSql(maxidsql);
					//if(rs.next()){
						loginid = loginid+(id + 1);
						falg = true;
					//}
				}
		}	
		String sql = "select * from HrmResource where id = "+Util.getIntValue(id);
		rs.executeSql(sql);
		String olddepartmentid = "";
		String oldmanagerid = "";
		String oldsubcompanyid1 = "";
		String oldseclevel = "";
		String oldmanagerstr = "";
		while(rs.next()){
		olddepartmentid = rs.getString("departmentid");
		oldmanagerid = rs.getString("managerid");
		oldsubcompanyid1 = rs.getString("subcompanyid1");
		oldseclevel = rs.getString("seclevel");
		oldmanagerstr = rs.getString("managerstr");
    /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 begin***********/
    if(!oldmanagerstr.startsWith(","))oldmanagerstr=","+oldmanagerstr;
    if(!oldmanagerstr.endsWith(","))oldmanagerstr=oldmanagerstr+",";
    /*********处理managerstr 不以逗号开始或者结束的情况 形如 managerstr：8 end ***********/
		}
        para =""+id+separator+workcode+separator+lastname+separator+sex+separator+resourceimageid
          +separator+ departmentid+separator+ costcenterid+separator+jobtitle+separator+joblevel
          +separator+jobactivitydesc+separator+managerid+separator+assistantid+separator+status
          +separator+locationid+separator+workroom+separator+telephone+separator+mobile
          +separator+mobilecall+separator+fax+separator+jobcall+separator+systemlanguage
          +separator+accounttype+separator+belongto+separator+email+separator+dsporder+separator+mobileshowtype;
		String basicPara = para;
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{

			rst.executeProc("HrmResourceBasicInfo_Update",para);
			rst.executeSql("update hrmresource set countryid=(select countryid from HrmLocations where id="+locationid+") where id="+id);
			if(falg){
				String logidsql = "update HrmResource set loginid = '"+loginid+"' where id = "+id;
				rst.executeSql(logidsql);
			}
			//String p_para = id + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + oldmanagerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";

			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
        String managerstr = "";
        if(!id.equals(managerid)){
	        sql = "select managerstr from HrmResource where id = "+Util.getIntValue(managerid);
	        rs.executeSql(sql);
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
        
        
		rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			para = ""+id+separator+ managerstr;
			rst.executeProc("HrmResource_UpdateManagerStr",para);
			//String p_para = id + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";

			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

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
				//String p_para = resourceid + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr2 + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr + separator + "1";

				//System.out.println(p_para);
				//rst.executeProc("HrmResourceShare", p_para);
				rst.commit();
				ResourceComInfo.updateResourceInfoCache(resourceid); //更新缓存
			}catch(Exception e){
				rst.rollback();
				e.printStackTrace();
			}

        }

        String subcmpanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
        para = ""+id+separator+subcmpanyid1;
		rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			 rst.executeProc("HrmResource_UpdateSubCom",para);

			//String p_para = id + separator + departmentid + separator + subcmpanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + departmentid + separator + oldsubcompanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + "1";

			//System.out.println(p_para);
			//rst.executeProc("HrmResourceShare", p_para);
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}
		
		if(!oldmanagerid.equals(managerid)){//修改人力资源经理，对客户和日程共享重新计算

		    CrmShareBase.setShareForNewManager(id);
		    //WorkPlanShareBase.setShareForNewManager(id);
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


    if (RecordSetDB.getDBType().equals("db2")){
        //db2 trigger
        int seclevel = Util.getIntValue(fu.getParameter("seclevel"),0);
        String nowmanagerstr = Util.null2String(rs.getString("managerstr"));
        //rs.executeProc("Tri_U_HrmresourceShare",""+id+separator+departmentid+separator+subcmpanyid1+separator+seclevel+separator+nowmanagerstr);
    }

        /*
        CREATE procedure Tri_U_HrmresourceShare
        (
        in id integer ,
        in departmentid integer,
        in subcompanyid1 integer,
        in seclevel integer,
        in managerstr varchar(200)
        )
        */
		String oldloginid = "";
		rs.executeSql("select loginid from HrmResource where id = "+id);
		if(rs.next())
		{
			oldloginid = Util.null2String(rs.getString("loginid"));
			if(mode.equals("ldap")) {
				//loginid 、account字段整合
				oldloginid= Util.null2String(rs.getString("loginid"));
				//oldloginid= Util.null2String(rs.getString("account"));
			}
		}
        //add by wjy
        //同步RTX端的用户信息.
	    /*取消原同步方式，改为用线程方式
		boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在

        if(checkrtxuser){   //存在就编辑，不存在就新增
        	OrganisationCom.editUser(Integer.parseInt(id));//编辑
        } else {
			if(Integer.parseInt(status)<4){  //如果这个人状态不是 0：试用1：正式2：临时3：试用延期，或者没有OA登录名,则不进行人员同步操作
        		OrganisationCom.addUser(Integer.parseInt(id));//新增
			}
        }
		*/
		new Thread(new OrganisationComRunnable("user","editbasicinfo",id+"-"+status)).start();
        // 改为自进行修正

        ResourceComInfo.updateResourceInfoCache(id);

		//OA与第三方接口单条数据同步方法开始

		HrmServiceManager.SynInstantHrmResource(id,"2");  
		//OA与第三方接口单条数据同步方法结束

		//处理自定义字段 add by wjy
    CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));

	//处理次账号修改为主账号时，检查次账号所属 主账号的 其他设置是否需要修改 add by kzw QC159888
		try{
		if(!oldbelongto.equals("")){
			HrmUserSettingComInfo userSetting = new HrmUserSettingComInfo();
			String belongtoshow = userSetting.getBelongtoshowByUserId(oldbelongto);
			if(belongtoshow.equals("1")){
				rs.executeSql("select id from hrmresource where belongto = "+oldbelongto);
				if(!rs.next()){
					String setId =userSetting.getId(oldbelongto);
					rs.executeSql("update HrmUserSetting set belongtoshow=0  where id="+setId);
					userSetting.removeHrmUserSettingComInfoCache();
				}
			}
		}
		}catch(Exception e){
			rs.writeLog(e.getMessage());
		}

		SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourceBasicInfo_Update"+":"+basicPara);
    	SysMaintenanceLog.setSysLogInfo();

        CoreMailAPI coremailapi = CoreMailAPI.getInstance();
	    coremailapi.synUser(id);
	    //CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
	    //testapi.synUser(id);

        if(isView == 0){
        	if(isDialog.equals("1")){
        		if(urlFrom.equals("departmentList")){
        			response.sendRedirect("/hrm/company/HrmResourceBasicEdit.jsp?isclose=1&id="+id);
        		}
        		else{
        			response.sendRedirect("HrmResourceBasicInfo.jsp?isclose=1&id="+id);
        		}
        	}
        	else{
            response.sendRedirect("HrmResourceBasicInfo.jsp?id="+id);
        	}
        }else{
        	//response.sendRedirect("HrmResource.jsp?id="+id);
        	response.sendRedirect("HrmResourceBase.jsp?id="+id);
            
        }
        return;
    }

    if(operation.equalsIgnoreCase("editcontactinfo")){
        String id = Util.null2String(fu.getParameter("id"));
        if(user.getUID()!=Util.getIntValue(id)){//本人才能修改
        	response.sendRedirect("/notice/noright.jsp") ;
	    		return;
				}
        String locationid = Util.fromScreen3(fu.getParameter("locationid"),user.getLanguage());
        String workroom = Util.fromScreen3(fu.getParameter("workroom"),user.getLanguage());
        String telephone = Util.fromScreen3(fu.getParameter("telephone"),user.getLanguage());
        String mobile = Util.fromScreen3(fu.getParameter("mobile"),user.getLanguage());
        String mobileshowtype = Util.fromScreen3(fu.getParameter("mobileshowtype"),user.getLanguage());
        String mobilecall = Util.fromScreen3(fu.getParameter("mobilecall"),user.getLanguage());
        String fax = Util.fromScreen3(fu.getParameter("fax"),user.getLanguage());
        String systemlanguage = Util.fromScreen3(fu.getParameter("systemlanguage"),user.getLanguage());
		String resourceimageid= Util.null2String(fu.uploadFiles("photoid"));
		String oldresourceimageid= Util.null2String(fu.getParameter("oldresourceimage"));
		if(resourceimageid.equals("")) resourceimageid=oldresourceimageid ;
        if(systemlanguage.equals("")||systemlanguage.equals("0")){
         systemlanguage = "7";
        }
        String email = Util.fromScreen3(fu.getParameter("email"),user.getLanguage());

        para =""+id    +separator+locationid+separator+workroom  +separator+
            telephone+separator+ mobile  +separator+mobilecall+separator+
            fax+separator+systemlanguage+separator+email+separator+ mobileshowtype;
        rs.executeProc("HrmResourceContactInfo_Update",para);
		//added by zfh 
		//增加上传头像的功能

		String sql="update HrmResource set resourceimageid='"+resourceimageid+"' where id="+id;
		rs.execute(sql);
		Date dt=new Date();    
	    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd"); 
		String logidsql = "update HrmResource set lastmodid = '"+user.getUID()+"' ,lastmoddate='"+sdf.format(dt)+"' where id = "+id;
		rs.executeSql(logidsql);
        //add by wjy
        //同步RTX端的用户信息.
		/*取消原同步方式，改为用线程方式
        boolean checkrtxuser = OrganisationCom.checkUser(Integer.parseInt(id));//检测用户是否存在

        if(checkrtxuser){   //存在就编辑，不存在就新增
        	OrganisationCom.editUser(Integer.parseInt(id));//编辑
        } else {
        	OrganisationCom.addUser(Integer.parseInt(id));//新增
        }
        */
		new Thread(new OrganisationComRunnable("user","editcontactinfo",id)).start();
        // 改为自进行修正

        ResourceComInfo.updateResourceInfoCache(id);

		//OA与第三方接口单条数据同步方法开始

		HrmServiceManager.SynInstantHrmResource(id,"2");  
		//OA与第三方接口单条数据同步方法结束

      	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourceContactInfo_Update");
    	SysMaintenanceLog.setSysLogInfo();

        CoreMailAPI coremailapi = CoreMailAPI.getInstance();
	    coremailapi.synUser(id);
	    //CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
	    //testapi.synUser(id);

      if(isView == 0){
        response.sendRedirect("HrmResourceBasicInfo.jsp?id="+id);
      }else{
    	if(isfromtab){
    		response.sendRedirect("HrmResourceBase.jsp?id="+id);
    	}else{  
    		response.sendRedirect("HrmResourceBase.jsp?id="+id);
    	}
      }
      return;
    }

    if(operation.equalsIgnoreCase("editpersonalinfo")){
	    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
	    		response.sendRedirect("/notice/noright.jsp") ;
	    		return ;
	    	}
        String id = Util.null2String(fu.getParameter("id"));
        String birthday = Util.fromScreen3(fu.getParameter("birthday"),user.getLanguage());
        String folk = Util.fromScreen3(fu.getParameter("folk"),user.getLanguage()) ;	 /*民族*/
        String nativeplace = Util.fromScreen3(fu.getParameter("nativeplace"),user.getLanguage()) ;	/*籍贯*/
        String regresidentplace = Util.fromScreen3(fu.getParameter("regresidentplace"),user.getLanguage()) ;	/*户口所在地*/
        String maritalstatus = Util.fromScreen3(fu.getParameter("maritalstatus"),user.getLanguage());
        String policy = Util.fromScreen3(fu.getParameter("policy"),user.getLanguage()) ; /*政治面貌*/
        String bememberdate = Util.fromScreen3(fu.getParameter("bememberdate"),user.getLanguage()) ;	/*入团日期*/
        String bepartydate = Util.fromScreen3(fu.getParameter("bepartydate"),user.getLanguage()) ;	/*入党日期*/
        String islabourunion = Util.fromScreen3(fu.getParameter("islabouunion"),user.getLanguage()) ;
        String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel"),user.getLanguage()) ;/*学历*/
        String degree = Util.fromScreen3(fu.getParameter("degree"),user.getLanguage()) ; /*学位*/
        String healthinfo = Util.fromScreen3(fu.getParameter("healthinfo"),user.getLanguage()) ;/*健康状况*/
        String height = Util.null2o(fu.getParameter("height")) ;/*身高*/
        String weight = Util.null2o(fu.getParameter("weight")) ;
        String residentplace = Util.fromScreen3(fu.getParameter("residentplace"),user.getLanguage()) ;	/*现居住地*/
        String homeaddress = Util.fromScreen3(fu.getParameter("homeaddress"),user.getLanguage()) ;
        String tempresidentnumber = Util.fromScreen3(fu.getParameter("tempresidentnumber"),user.getLanguage()) ;
        String certificatenum = Util.fromScreen3(fu.getParameter("certificatenum"),user.getLanguage()) ;/*证件号码*/
        int iscreate = Util.getIntValue(fu.getParameter("iscreate"),0);    
	HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",Util.getIntValue(fu.getParameter("scopeid"),0));
	String sql = "select * from HrmResource where id="+id;
	rs.executeSql(sql);
	if(rs.next()){
	    if(!hfm.isUse("birthday"))birthday = rs.getString("birthday");
		if(!hfm.isUse("folk"))folk = rs.getString("folk");
		if(!hfm.isUse("nativeplace"))nativeplace = rs.getString("nativeplace");
		if(!hfm.isUse("regresidentplace"))regresidentplace = rs.getString("regresidentplace");
		if(!hfm.isUse("maritalstatus"))maritalstatus = rs.getString("maritalstatus");
		if(!hfm.isUse("policy"))policy = rs.getString("policy");
		if(!hfm.isUse("bememberdate"))bememberdate = rs.getString("bememberdate");
		if(!hfm.isUse("bepartydate"))bepartydate = rs.getString("bepartydate");
		if(!hfm.isUse("islabouunion"))islabourunion = rs.getString("islabourunion");
		if(!hfm.isUse("educationlevel"))educationlevel = rs.getString("educationlevel");
		if(!hfm.isUse("degree"))degree = rs.getString("degree");
		if(!hfm.isUse("healthinfo"))healthinfo = rs.getString("healthinfo");
		if(!hfm.isUse("height"))height = rs.getString("height");
		if(!hfm.isUse("weight"))weight = rs.getString("weight");
		if(!hfm.isUse("residentplace"))residentplace = rs.getString("residentplace");
		if(!hfm.isUse("homeaddress"))homeaddress = rs.getString("homeaddress");
		if(!hfm.isUse("tempresidentnumber"))tempresidentnumber = rs.getString("tempresidentnumber");
		if(!hfm.isUse("certificatenum"))certificatenum = rs.getString("certificatenum");
	}
        certificatenum = certificatenum.trim();
        String tempcertificatenum = certificatenum;
        int msg=0;
        if(!certificatenum.equals("")){
			rs.executeSql("select accounttype,certificatenum from HrmResource where id="+id);
			String accountType = "", tempCertificatenum = "";
			if(rs.next()){
				accountType = Util.null2String(rs.getString("accounttype"));
				tempCertificatenum = Util.null2String(rs.getString("certificatenum"));
			}
			if(!accountType.equals("1")) {
				rs.executeSql("select id from HrmResource where id<>"+id+" and certificatenum='"+certificatenum+"' and accounttype != '1'");
				if(rs.next()){
					msg=1;
					tempcertificatenum = tempCertificatenum;
				}
			}			
        }
        para = ""+id+	separator+birthday+separator+folk+separator+nativeplace+separator+regresidentplace+separator+
             maritalstatus+	separator+policy+separator+bememberdate+separator+bepartydate+separator+islabourunion+
             separator+educationlevel+separator+degree+separator+healthinfo+separator+height+separator+weight+
             separator+residentplace+separator+homeaddress+separator+tempresidentnumber+separator+tempcertificatenum;

        rs.executeProc("HrmResourcePersonalInfo_Insert",para);
        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);

        int rownum = Util.getIntValue(fu.getParameter("rownum"),user.getLanguage()) ;
        rs.executeProc("HrmFamilyInfo_Delete",""+id);
        for(int i = 0;i<rownum;i++){
            String member = Util.fromScreen3(fu.getParameter("member_"+i),user.getLanguage());
            String title = Util.fromScreen3(fu.getParameter("title_"+i),user.getLanguage());
            String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage());
            String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage());
            String address = Util.fromScreen3(fu.getParameter("address_"+i),user.getLanguage());
            String info = member+title+company+jobtitle+address;
            if(!info.trim().equals("")){
                para = ""+id+separator+member+separator+title+separator+company+separator+jobtitle+separator+address;

                rs.executeProc("HrmFamilyInfo_Insert",para);
            }
        }

        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));

        // 个人信息不需要清理人力资源缓存 ResourceComInfo.removeResourceCache();

      	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourcePersonalInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();
        if(msg==1)
            response.sendRedirect("HrmResourcePersonalEdit.jsp?id="+id+"&isView="+isView+"&msg=1&iscreate="+iscreate+"&certificatenum="+certificatenum);
        else if(iscreate==1)
            response.sendRedirect("HrmResourceAddThree.jsp?id="+id);
        else
            response.sendRedirect("HrmResourcePersonalView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
        return;
    }

    if(operation.equalsIgnoreCase("editwork")){
	    	if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
	    		response.sendRedirect("/notice/noright.jsp") ;
	    		return ;
	    	}
        String id = Util.null2String(fu.getParameter("id"));
		//System.out.println("id:"+id);
        String name = "";
        String sql = "select lastname from HrmResource where id ="+id;
        rs.executeSql(sql);
        while(rs.next()){
            name = rs.getString("lastname");
        }

        String usekind = Util.fromScreen3(fu.getParameter("usekind"),user.getLanguage()) ;
        String startdate = Util.fromScreen3(fu.getParameter("startdate"),user.getLanguage()) ;
        String probationenddate = Util.fromScreen3(fu.getParameter("probationenddate"),user.getLanguage()) ;
        String enddate = Util.fromScreen3(fu.getParameter("enddate"),user.getLanguage()) ;

        HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0));
        sql = "select * from HrmResource where id="+id;
        rs.executeSql(sql);
        if(rs.next()){
            if(!hfm.isUse("usekind"))usekind = rs.getString("usekind");
	    if(!hfm.isUse("startdate"))startdate = rs.getString("startdate");
	    if(!hfm.isUse("probationenddate"))probationenddate = rs.getString("probationenddate");
	    if(!hfm.isUse("enddate"))enddate = rs.getString("enddate");
	}

        para = ""+id+	separator+usekind+separator+startdate+separator+probationenddate+separator+ enddate;
        rs.executeProc("HrmResourceWorkInfo_Insert",para);
        rs.executeProc("HrmResource_ModInfo",""+id+separator+userpara);
        
		String contracttypeid = "";
		String ishirecontract = "";
		String contractid = "";
		String sqltype = "select * from hrmcontract where exists (select * from HrmContractType where hrmcontract.contracttypeid=HrmContractType.id and HrmContractType.ishirecontract=1) and contractman="+id+" order by contractenddate desc,contractstartdate desc";
		rs.executeSql(sqltype);
		if(rs.next()){
			contracttypeid = rs.getString("contracttypeid");
			contractid = rs.getString("id");
   		//根据qc212896 人事卡片合同日期修改的时候 同步更新合同类型为入职合同中 最新的一个合同的日期 
			sqltype = "update HrmContract set contractstartdate = '"+startdate+"',contractenddate = '"+enddate+"',proenddate = '"+probationenddate+"' where id = "+contractid; 
			rs.execute(sqltype);
		}
		
        sql = "delete from HrmLanguageAbility where resourceid = "+id;
        rs.executeSql(sql);
        int lanrownum = Util.getIntValue(fu.getParameter("lanrownum"),0);
        for(int i = 0;i<lanrownum;i++){
            String language = Util.fromScreen3(fu.getParameter("language_"+i),user.getLanguage()) ;
            String level = Util.fromScreen3(fu.getParameter("level_"+i),user.getLanguage()) ;
            String memo = Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage()) ;
            String info = language+memo;
            if(!info.trim().equals("")){
                para = ""+id+separator+language+separator+level+separator+memo;
                rs.executeProc("HrmLanguageAbility_Insert",para);
            }
        }

        sql = "delete from HrmEducationInfo where resourceid = "+id;
        rs.executeSql(sql);
        int edurownum = Util.getIntValue(fu.getParameter("edurownum"),0);
        for(int i = 0;i<edurownum;i++){
            String school = Util.fromScreen3(fu.getParameter("school_"+i),user.getLanguage()) ;
            String speciality = Util.fromScreen3(fu.getParameter("speciality_"+i),user.getLanguage()) ;
            String edustartdate = Util.fromScreen3(fu.getParameter("edustartdate_"+i),user.getLanguage()) ;
            String eduenddate = Util.fromScreen3(fu.getParameter("eduenddate_"+i),user.getLanguage()) ;
            String educationlevel = Util.fromScreen3(fu.getParameter("educationlevel_"+i),user.getLanguage()) ;
            String studydesc = Util.fromScreen3(fu.getParameter("studydesc_"+i),user.getLanguage()) ;
            String info = school+speciality+edustartdate+eduenddate+studydesc;
            if(!info.trim().equals("")){
                para = ""+id+separator+edustartdate+separator+eduenddate+separator+school+separator+speciality+
                        separator+educationlevel+separator+studydesc;
                rs.executeProc("HrmEducationInfo_Insert",para);
            }
        }

        int workrownum = Util.getIntValue(fu.getParameter("workrownum"));
        sql = "delete from HrmWorkResume where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<workrownum;i++){
            String company = Util.fromScreen3(fu.getParameter("company_"+i),user.getLanguage()) ;
            String workstartdate = Util.fromScreen3(fu.getParameter("workstartdate_"+i),user.getLanguage()) ;
            String workenddate = Util.fromScreen3(fu.getParameter("workenddate_"+i),user.getLanguage()) ;
            String jobtitle = Util.fromScreen3(fu.getParameter("jobtitle_"+i),user.getLanguage()) ;
            String workdesc = Util.fromScreen3(fu.getParameter("workdesc_"+i),user.getLanguage()) ;
            String leavereason = Util.fromScreen3(fu.getParameter("leavereason_"+i),user.getLanguage()) ;
            String info = company+workstartdate+workenddate+jobtitle+workdesc+leavereason;
            if(!info.trim().equals("")){
                para = ""+id+separator+workstartdate+separator+workenddate+separator+company+separator+jobtitle+
                        separator+workdesc+separator+leavereason;
                rs.executeProc("HrmWorkResume_Insert",para);
            }
        }

        int trainrownum = Util.getIntValue(fu.getParameter("trainrownum"),0);
        sql = "delete from HrmTrainBeforeWork where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<trainrownum;i++){
            String trainname = Util.fromScreen3(fu.getParameter("trainname_"+i),user.getLanguage()) ;
            String trainstartdate = Util.fromScreen3(fu.getParameter("trainstartdate_"+i),user.getLanguage()) ;
            String trainenddate = Util.fromScreen3(fu.getParameter("trainenddate_"+i),user.getLanguage()) ;
            String trainresource = Util.fromScreen3(fu.getParameter("trainresource_"+i),user.getLanguage()) ;
            String trainmemo = Util.fromScreen3(fu.getParameter("trainmemo_"+i),user.getLanguage()) ;
            String info = trainname+trainstartdate+trainenddate+trainresource+trainmemo;
            if(!info.trim().equals("")){
                para = ""+id+separator+trainname+separator+trainresource+separator+trainstartdate+separator+trainenddate+
                        separator+trainmemo;
                rs.executeProc("HrmTrainBeforeWork_Insert",para);
            }
        }

        int cerrownum = Util.getIntValue(fu.getParameter("cerrownum"),0);

        sql = "delete from HrmCertification where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<cerrownum;i++){
            String cername = Util.fromScreen3(fu.getParameter("cername_"+i),user.getLanguage()) ;
            String cerstartdate = Util.fromScreen3(fu.getParameter("cerstartdate_"+i),user.getLanguage()) ;
            String cerenddate = Util.fromScreen3(fu.getParameter("cerenddate_"+i),user.getLanguage()) ;
            String cerresource = Util.fromScreen3(fu.getParameter("cerresource_"+i),user.getLanguage()) ;

            String info = cername+cerstartdate+cerenddate+cerresource;
            if(!info.trim().equals("")){
                para = ""+id+separator+cerstartdate+separator+cerenddate +separator+cername+separator+cerresource;

                rs.executeProc("HrmCertification_Insert",para);
            }
        }

        int rewardrownum = Util.getIntValue(fu.getParameter("rewardrownum"),0);
        sql = "delete from HrmRewardBeforeWork where resourceid = "+id;
        rs.executeSql(sql);
        for(int i = 0;i<rewardrownum;i++){
            String rewardname = Util.fromScreen3(fu.getParameter("rewardname_"+i),user.getLanguage()) ;
            String rewarddate = Util.fromScreen3(fu.getParameter("rewarddate_"+i),user.getLanguage()) ;
            String rewardmemo = Util.fromScreen3(fu.getParameter("rewardmemo_"+i),user.getLanguage()) ;
            String info = rewardname+rewarddate+rewardmemo;
            if(!info.trim().equals("")){
                para = ""+id+separator+rewardname+separator+rewarddate+separator+rewardmemo;
                rs.executeProc("HrmRewardBeforeWork_Insert",para);
            }
        }

        // 工作信息不需要清理缓存 ResourceComInfo.removeResourceCache();

        //处理自定义字段 add by wjy
        CustomFieldTreeManager.editCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));
        CustomFieldTreeManager.editMutiCustomData("HrmCustomFieldByInfoType", Util.getIntValue(fu.getParameter("scopeid"),0), fu, Util.getIntValue(id,0));

     	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmResourceWorkInfo_Insert");
    	SysMaintenanceLog.setSysLogInfo();
		
        response.sendRedirect("HrmResourceWorkView.jsp?isfromtab="+isfromtab+"&id="+id+"&isView="+isView);
        return;
    }

    if(operation.equalsIgnoreCase("finish")) {
        String id = Util.null2String(fu.getParameter("id")) ;
        String Sql=("select lastname from HrmResource where id="+id);
        RecordSet.executeSql(Sql);
        RecordSet.next();
        String CurrentUser = ""+user.getUID();
        String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
        //判断登陆者－－－－//
        String sql_10="select hrmid from HrmInfoMaintenance where id =10 ";
        RecordSet.executeSql(sql_10);
        RecordSet.next();
        String hrmid_10= RecordSet.getString("hrmid");
        boolean canedit_10=false;
        if(CurrentUser.equals(hrmid_10)){
            canedit_10=true;
        }
        String sql_1="select hrmid from HrmInfoMaintenance where id =1 ";
        RecordSet.executeSql(sql_1);
        RecordSet.next();
        String hrmid_1= RecordSet.getString("hrmid");
        boolean canedit_1=false;
        if(CurrentUser.equals(hrmid_1)){
            canedit_1=true;
        }
        String sql_2="select hrmid from HrmInfoMaintenance where id =2 ";
        RecordSet.executeSql(sql_2);
        RecordSet.next();
        String hrmid_2= RecordSet.getString("hrmid");
        boolean canedit_2=false;
        if(CurrentUser.equals(hrmid_2)){
            canedit_2=true;
        }
        String sql_3="select hrmid from HrmInfoMaintenance where id =3 ";
        RecordSet.executeSql(sql_3);
        RecordSet.next();
        String hrmid_3= RecordSet.getString("hrmid");
        boolean canedit_3=false;
        if(CurrentUser.equals(hrmid_3)){
            canedit_3=true;
        }
        String sql_4="select hrmid from HrmInfoMaintenance where id =4 ";
        RecordSet.executeSql(sql_4);
        RecordSet.next();
        String hrmid_4= RecordSet.getString("hrmid");
        boolean canedit_4=false;
        if(CurrentUser.equals(hrmid_4)){
            canedit_4=true;
        }
        String sql_5="select hrmid from HrmInfoMaintenance where id =5 ";
        RecordSet.executeSql(sql_5);
        RecordSet.next();
        String hrmid_5= RecordSet.getString("hrmid");
        boolean canedit_5=false;
        if(CurrentUser.equals(hrmid_5)){
            canedit_5=true;
        }
        String sql_6="select hrmid from HrmInfoMaintenance where id =6 ";
        RecordSet.executeSql(sql_6);
        RecordSet.next();
        String hrmid_6= RecordSet.getString("hrmid");
        boolean canedit_6=false;
        if(CurrentUser.equals(hrmid_6)){
            canedit_6=true;
        }
        String sql_7="select hrmid from HrmInfoMaintenance where id =7 ";
        RecordSet.executeSql(sql_7);
        RecordSet.next();
        String hrmid_7= RecordSet.getString("hrmid");
        boolean canedit_7=false;
        if(CurrentUser.equals(hrmid_7)){
            canedit_7=true;
        }
        String sql_8="select hrmid from HrmInfoMaintenance where id =8 ";
        RecordSet.executeSql(sql_8);
        RecordSet.next();
        String hrmid_8= RecordSet.getString("hrmid");
        boolean canedit_8=false;
        if(CurrentUser.equals(hrmid_8)){
            canedit_8=true;
        }
        String sql_9="select hrmid from HrmInfoMaintenance where id =9 ";
        RecordSet.executeSql(sql_9);
        RecordSet.next();
        String hrmid_9= RecordSet.getString("hrmid");
        boolean canedit_9=false;
        if(CurrentUser.equals(hrmid_9)){
            canedit_9=true;
        }
        if((HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user))||canedit_1||canedit_2||canedit_3||canedit_4||canedit_5||canedit_6||canedit_7||canedit_8||canedit_9||canedit_10){//权限判断

        }else{//没有权限
        	response.sendRedirect("/hrm/employee/EmployeeManage.jsp?hrmid="+id);
          return;
        }
        rs.executeProc("HrmInfoStatus_Finish",id);

        SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    	SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setOperateType("2");
    	SysMaintenanceLog.setOperateDesc("HrmInfoStatus_Finish");
    	SysMaintenanceLog.setSysLogInfo();

        response.sendRedirect("/hrm/employee/EmployeeManage.jsp?hrmid="+id);
        return;
    }

    if(operation.equalsIgnoreCase("info")) {
        String id = Util.null2String(fu.getParameter("id"));
        String probationenddate = Util.fromScreen3(fu.getParameter("probationenddate"),user.getLanguage()) ;
        String enddate = Util.fromScreen3(fu.getParameter("enddate"),user.getLanguage()) ;
        String name = ResourceComInfo.getResourcename(id);
        String infoman = HrmDateCheck.getHrmId(id);

        String accepter="";
        String title="";
        String remark="";
        String submiter="";
        String subject="";

        if(!HrmDateCheck.hasContract(id)){
          if(Util.dayDiff(today,enddate)==3){
              ArrayList al = Util.TokenizerString(infoman,",");
              for(int i = 0; i<al.size();i++){
                accepter = (String)al.get(i);
                subject= SystemEnv.getHtmlLabelName(15783,user.getLanguage()) ;
                subject += ":"+name;
                title = SystemEnv.getHtmlLabelName(15783,user.getLanguage());
                title += ":System Remind ";
    //          title += "-"+ResourceComInfo.getResourcename(accepter);
                title += "-"+name;
                title += "-"+today;
                remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
                submiter="0";
                SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
              }
            }
            if(Util.dayDiff(today,probationenddate)==3){
              ArrayList al = Util.TokenizerString(infoman,",");
              for(int i = 0; i<al.size();i++){
                accepter = (String)al.get(i);
                subject= SystemEnv.getHtmlLabelName(15784,user.getLanguage()) ;
                subject += ":"+name;
                title = SystemEnv.getHtmlLabelName(15784,user.getLanguage()) ;
                title += ":System Remind ";
    //          title += "-"+ResourceComInfo.getResourcename(accepter);
                title += "-"+name;
                title += "-"+today;
                remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
                submiter="0";
                SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }
        }
      }
      response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id);
    }

    if(operation.equalsIgnoreCase("delete")) {
    		
        String id = Util.null2String(fu.getParameter("id"));
        /*
        String sql = "update HrmResource set status = 10 where id = "+id;
        rs.executeSql(sql);

        //add by wjy
        //同步RTX端的用户信息.
        //OrganisationCom.checkUser(Integer.parseInt(id));

        // 改为自进行修正

        ResourceComInfo.deleteResourceInfoCache(id);

        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(ResourceComInfo.getResourcename(id));
        SysMaintenanceLog.setOperateItem("29");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("HrmResource_Delete");
        SysMaintenanceLog.setSysLogInfo();
				*/
        response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+id);
    }
    
    //人员锁定
    if(operation.equalsIgnoreCase("lock")) {
    	/*String[] resourceids=Util.null2o(fu.getParameter("resourceids")).split(",");
    	String createdate=TimeUtil.getCurrentDateString();
    	String createtime=TimeUtil.getOnlyCurrentTimeString();
    	for(int i=0;i<resourceids.length;i++){
    		String resourceid=resourceids[i];
    		if(!resourceid.equals("")){
    		   String sql="select id from HrmResource_lock where userid="+resourceid;
    		   rs.execute(sql);
    		   if(!rs.next()){
    			   sql="insert into HrmResource_lock(userid,createdate,createtime) values("+resourceid+",'"+createdate+"','"+createtime+"')";
    			   rs.execute(sql);
    		   }
    		}
    	}*/
    	response.sendRedirect("/hrm/resource/HrmResourceLock.jsp");
    }else if(operation.equalsIgnoreCase("unlock")||operation.equalsIgnoreCase("unlocksearch")){
    	/*
    	if(operation.equalsIgnoreCase("unlock")){
	    	String[] ids=fu.getParameters("lockid");
	    	for(int i=0;i<ids.length;i++){
	    		String resourceid=ids[i];
	    		if(!resourceid.equals("")){
	    		   String sql="delete from HrmResource_lock where id="+ids[i];
	    		   rs.execute(sql);
	    		}
	    	}
    	}
    	String name=Util.null2String(fu.getParameter("name"));
    	String departmentids=Util.null2String(fu.getParameter("departmentids"));
    	//System.out.println("name1================="+name);
    	request.setAttribute("name",name);
    	request.setAttribute("departmentids",departmentids);*/
    	response.sendRedirect("/hrm/resource/HrmResourceUnlock.jsp");
    }

%>
