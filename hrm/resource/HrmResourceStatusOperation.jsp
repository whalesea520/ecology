<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.finance.SalaryManager" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.StaticObj"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.RecordSetTrans" %>
<%@ page import="weaver.crm.CrmShareBase"%>
<%@ page import="weaver.interfaces.email.CoreMailAPI" %>
<%@ page import="weaver.interfaces.email.CoreMailTestAPI" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="LN" class="ln.LN" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<jsp:useBean id="RTXConfig" class="weaver.rtx.RTXConfig" scope="page" />
<jsp:useBean id="poppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<jsp:useBean id="HrmDateCheck" class="weaver.hrm.tools.HrmDateCheck" scope="page" />

<%@ page import="weaver.rtx.OrganisationComRunnable" %>
<%
String tempresourceid = Util.null2String(request.getParameter("resourceid"));
String resourceids[] = null ;
if(!tempresourceid.equals("")) resourceids = Util.TokenizerString2(tempresourceid,",") ;

String changedate = Util.fromScreen(request.getParameter("changedate"),user.getLanguage());
String changeenddate = Util.fromScreen(request.getParameter("changeenddate"),user.getLanguage());
String changereason= Util.fromScreenVoting(request.getParameter("changereason"),user.getLanguage());
String changecontractid = Util.fromScreen(request.getParameter("changecontractid"),user.getLanguage());
String oldjobtitleid = Util.fromScreen(request.getParameter("oldjobtitle"),user.getLanguage());
String oldjoblevel = Util.fromScreen(request.getParameter("oldjoblevel"),user.getLanguage());
String newjobtitleid = Util.fromScreen(request.getParameter("newjobtitle"),user.getLanguage());
String newjoblevel = Util.fromScreen(request.getParameter("newjoblevel"),user.getLanguage());
String infoman = Util.fromScreen(request.getParameter("infoman"),user.getLanguage());
String ischangesalary = Util.fromScreen(request.getParameter("ischangesalary"),user.getLanguage());
String status = Util.fromScreen(request.getParameter("status"),user.getLanguage());
String managerid = Util.fromScreen(request.getParameter("managerid"),user.getLanguage());
String type = "0";

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String para = "";
char separator = Util.getSeparator() ;

String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String clientaddress = request.getRemoteAddr();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currentTime = (timestamp.toString()).substring(11,19);

String accepter="";
String title="";
String remark="";
String submiter="";
String subject="";
String backurl = "" ;

if( resourceids != null ) {

    if(operation.equalsIgnoreCase("fire")){  //解聘
        type = "1";
        backurl = "HrmResourceFire.jsp" ;
        for(int i=0 ; i<resourceids.length; i++) {
            String id = Util.null2String(resourceids[i]) ;
            String loginId = RTXConfig.getRtxLoginFiledExtend(Integer.parseInt(id));
            String name = ResourceComInfo.getResourcename(id);

            oldjobtitleid = ResourceComInfo.getJobTitle(id);
            para = ""+id+separator+changedate+separator+changereason+separator+changecontractid+separator+infoman+separator+oldjobtitleid+separator+type+separator+user.getUID();
            boolean flag=rs.executeProc("HrmResource_Fire",para);
            //delete by chengfeng.han 2011-7-18 27152 删除权限和手机用户不应该立即处理，应该在定时任务中处理
            //if(flag){
            //    rs.executeSql("delete from hrmrolemembers where resourceid="+id);
                //删除手机版中设置的登录人员
            //    rs.executeSql("delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue='"+id+"'");
            //}
            //end
            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(16119,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title = SystemEnv.getHtmlLabelName(16119,user.getLanguage()) ;
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }

            if(Util.dayDiff(CurrentDate,changedate)<=1){
            	if(HrmDateCheck.hasStatueChanged(id, changedate)){
            		continue;
            	}
            	// 人员离职删除CoreMail中帐号
            	CoreMailAPI coremailapi = CoreMailAPI.getInstance();
            	coremailapi.synLeaveUser(id);
            	//CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
            	//testapi.synLeaveUser(id);
            
            	//add by chengfeng.han 2011-7-18 27152 如果离职日期和当前日期比较小于等于1天，就立即执行离职的相关处理
                rs.executeSql("delete from hrmrolemembers where resourceid="+id);
	                //删除手机版中设置的登录人员
	            rs.executeSql("delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue='"+id+"'");
	            //end
                String sql = "update HrmResource set status = 4 , loginid='',password='',account='',lastmoddate='"+changedate+"' where id = "+id;
                
                if("1".equals(coremailapi.getIsuse()) && "1".equals(coremailapi.getIssync())) {
	            	sql = "update HrmResource set status=4, loginid='', password='', account='', email='', lastmoddate='"+changedate+"' where id = "+id;
	            }
	            //if("1".equals(testapi.getIsuse()) && "1".equals(testapi.getIssync())) {
	            //	sql = "update HrmResource set status=4, loginid='', password='', account='', email='', lastmoddate='"+changedate+"' where id = "+id;
	            //}
                
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
                rs.executeSql(sql);
            }

            //OrganisationCom.checkUser(Integer.parseInt(id));
            //OrganisationCom.deleteUser2(ResourceComInfo.getLoginID(id));//人员离职从RTX中删除该人员
			new Thread(new OrganisationComRunnable("user","fire",id+"-"+loginId)).start();

			//OA与第三方接口单条数据同步方法开始
			HrmServiceManager.SynInstantHrmResource(id,"3"); 
			//OA与第三方接口单条数据同步方法结束
            
        }
    }
    else if(operation.equalsIgnoreCase("hire")){
        type =  "2";
        backurl = "HrmResourceHire.jsp" ;

        for(int i=0 ; i<resourceids.length; i++) {
            String id = Util.null2String(resourceids[i]) ;
            String name = ResourceComInfo.getResourcename(id);

            oldjobtitleid = ResourceComInfo.getJobTitle(id);
            para = ""+id+separator+changedate+separator+changereason+separator+infoman+separator+oldjobtitleid+separator+type+separator+user.getUID();
            rs.executeProc("HrmResource_Hire",para);

            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(16120,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title =  SystemEnv.getHtmlLabelName(16120,user.getLanguage());
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }

            if(Util.dayDiff(CurrentDate,changedate)<=1){
            	if(HrmDateCheck.hasStatueChanged(id, changedate)){
            		continue;
            	}
                String sql = "update HrmResource set status = 1 where id = "+id;
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
                rs.executeSql(sql);
            }
            OrganisationCom.checkUser(Integer.parseInt(id));
            
        }
    }

    else if(operation.equalsIgnoreCase("extend")){
        type=  "3";
        backurl = "HrmResourceExtend.jsp" ;

        for(int i=0 ; i<resourceids.length; i++) {
            String id = Util.null2String(resourceids[i]) ;
            String name = ResourceComInfo.getResourcename(id);
            //check user num
            boolean canSave = false;
            if(LN.CkHrmnum()<0){
                    canSave = true;
            }
            String sqluser = "select status from HrmResource where id = "+id;
            rs.executeSql(sqluser);
            rs.next();
            int userstatus = rs.getInt(1);
            if(userstatus==0||userstatus==1||userstatus==2||userstatus==3){
                canSave = true;
            }
            if(ResourceComInfo.getLoginID(id).equals("")){
                canSave = true;
            }

            if(!canSave){
               response.sendRedirect("/hrm/resource/HrmResourceExtend.jsp?errmsg=1");
               return;
            }

            oldjobtitleid = ResourceComInfo.getJobTitle(id);
            para = ""+id+separator+changedate+separator+changeenddate+separator+
                   changereason+separator+changecontractid+separator+infoman+separator+oldjobtitleid+separator+type+separator+status+separator+user.getUID();
            
 
      rs.executeProc("HrmResource_Extend",para);
			String contracttypeid = "";
			String idType = "";
			String contracttypeidsql = "select * from HrmContract where ContractMan ="+id;
			rs.executeSql(contracttypeidsql);
			while(rs.next()){
				contracttypeid = rs.getString("contracttypeid");
				String ishirecontractsql = "select * from HrmContracttype where ishirecontract = 1 and id ="+contracttypeid;
				rs2.executeSql(ishirecontractsql);
				while(rs2.next()){
					  idType = rs2.getString("id");
					  //System.out.println("idType:"+idType);
					  String sqloo = "";
					  if(!"".equals(changecontractid)) {
						  sqloo = "UPDATE HrmContract SET contractenddate = '"+changeenddate+"' WHERE id = "+changecontractid+"and contractman = "+id+" and contracttypeid = "+idType+"";
					  } else {
						  sqloo = "UPDATE HrmContract SET contractenddate = '"+changeenddate+"' WHERE contractman = "+id+" and contracttypeid = "+idType+"";
					  }
					  rs.executeSql(sqloo);	
			    
				}
				
		}
		
            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(16121,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title =  SystemEnv.getHtmlLabelName(16121,user.getLanguage()) ;
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }

            if(Util.dayDiff(CurrentDate,changedate)<=1){

            	if(HrmDateCheck.hasStatueChanged(id, changedate)){
            		continue;
            	}
				//TD8237
				if(!status.equals("0")){
                String sql = "update HrmResource set status ="+status+" where id = "+id;
				//System.out.println("sql----"+sql);
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
                rs.executeSql(sql);
				}else{
					String sql = "update HrmResource set status =2 where id = "+id;
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
                rs.executeSql(sql);
				}
            }
            OrganisationCom.checkUser(Integer.parseInt(id));
        }
    }

    else if(operation.equalsIgnoreCase("redeploy")){
        type =  "4";
        int depid = Util.getIntValue(Util.null2String(request.getParameter("departmentid")),0);
        backurl = "HrmResourceRedeploy.jsp" ;
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
			
			String tempmanagerid=managerid;
			if("".equals(managerid)){
				managerid = oldmanagerid;
			}
            para = ""+id+separator+changedate+separator+changereason+separator+oldjobtitleid+separator+oldjoblevel+
                   separator+newjobtitleid+separator+newjoblevel+separator+ infoman+separator+type+separator+ischangesalary
                   +separator+oldmanagerid+separator+managerid+separator+olddepartmentid+separator+depid+separator+oldsubcompanyid1+separator+subcmpanyid1+separator+user.getUID();

            rs.executeProc("HrmResource_Redeploy",para);

            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(16122,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title =  SystemEnv.getHtmlLabelName(16122,user.getLanguage()) ;
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }

           if(Util.dayDiff(CurrentDate,changedate)<=1){

                //depid = Util.getIntValue(JobTitlesComInfo.getDepartmentid(newjobtitleid),0);
                String sql = "" ;
               /* String sql = "select id from HrmCostcenter where departmentid = "+depid+" order by id";
                rs.executeSql(sql);
                rs.next();
                int  costcenterid = Util.getIntValue(rs.getString("id"),0);*/
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

					String p_para = id + separator + depid + separator + subcmpanyid1 + separator + managerid + separator + oldseclevel + separator + managerstr + separator + olddepartmentid + separator + oldsubcompanyid1 + separator + oldmanagerid + separator + oldseclevel + separator + oldmanagerstr + separator + "1";

					//System.out.println(p_para);
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

							para = resourceid + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr2 + separator + nowdepartmentid + separator + nowsubcompanyid1 + separator + nowmanagerid + separator + nowseclevel + separator + nowmanagerstr + separator + "1";

							//System.out.println(p_para);
							rst.executeProc("HrmResourceShare", para);
							rst.commit();
						}catch(Exception e){
							rst.rollback();
							e.printStackTrace();
						}
			        }
				}
				/*调整直接下级和间接下级 managerstr字段 结束*/
				
				//修改人力资源经理，对客户和日程共享重新计算
				if(!oldmanagerid.equals(managerid)){
					CrmShareBase CrmShareBase=new CrmShareBase();
				    CrmShareBase.setShareForNewManager(id);
				}
                // 是否需要工资变动的判断  刘煜挪到后面
            }
			String logsql = "select max(id) from HrmStatusHistory";
			rs.executeSql(logsql);
			rs.next();
			logsql = "update HrmStatusHistory set operatedate = '"+CurrentDate+"',operatetime='"+currentTime+"',clientaddress = '"+clientaddress+"',operatefrom = 'hrm' where id="+rs.getInt(1);
			rs2.executeSql(logsql);
        }
    }
    else if(operation.equalsIgnoreCase("dismiss")){
        type =  "5";
        backurl = "HrmResourceDismiss.jsp" ;
        for(int i=0 ; i<resourceids.length; i++) {
            String id = Util.null2String(resourceids[i]) ;
            String loginId = RTXConfig.getRtxLoginFiledExtend(Integer.parseInt(id));
            String name = ResourceComInfo.getResourcename(id);
			String oldDepartmentId = ResourceComInfo.getDepartmentID(id);
            oldjobtitleid = ResourceComInfo.getJobTitle(id);
            para = ""+id+separator+changedate+separator+changereason+separator+changecontractid+separator+infoman+separator+oldjobtitleid+separator+type+separator+user.getUID();
            boolean flag=rs.executeProc("HrmResource_Dismiss",para);
            //delete by chengfeng.han 2011-7-18 27152 删除权限和手机用户不应该立即处理，应该在定时任务中处理
            //if(flag){
            //    rs.executeSql("delete from hrmrolemembers where resourceid="+id);
                //删除手机版中设置的登录人员
            //    rs.executeSql("delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue='"+id+"'");
            //}
            //end
            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(16123,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title =  SystemEnv.getHtmlLabelName(16123,user.getLanguage()) ;
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }
            if(Util.dayDiff(CurrentDate,changedate)<=1){
            	if(HrmDateCheck.hasStatueChanged(id, changedate)){
            		continue;
            	}
            	// 人员离职删除CoreMail中帐号
            	CoreMailAPI coremailapi = CoreMailAPI.getInstance();
            	coremailapi.synLeaveUser(id);
            	//CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
            	//testapi.synLeaveUser(id);
            
                //add by chengfeng.han 2011-7-18 27152 如果离职日期和当前日期比较小于等于1天，就立即执行离职的相关处理
                rs.executeSql("delete from hrmrolemembers where resourceid="+id);
	                //删除手机版中设置的登录人员
	            rs.executeSql("delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue='"+id+"'");
	            //end
                String sql = "update HrmResource set status =5, loginid='',password='' ,account='',lastmoddate='"+changedate+"' where id = "+id;
                
                if("1".equals(coremailapi.getIsuse()) && "1".equals(coremailapi.getIssync())) {
                	sql = "update HrmResource set status=5, loginid='', password='', account='', email='', lastmoddate='"+changedate+"' where id = "+id;
	            }
                //if("1".equals(testapi.getIsuse()) && "1".equals(testapi.getIssync())) {
                //	sql = "update HrmResource set status=5, loginid='', password='', account='', email='', lastmoddate='"+changedate+"' where id = "+id;
	            //}
                
                rs.executeSql(sql);
                sql="delete hrmgroupmembers where userid="+id;
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = ?, oldDepartmentId=? where id=?";
                rs.executeUpdate(sql, 1, oldDepartmentId, rs.getInt(1));
            }
			String logsql = "select max(id) from HrmStatusHistory";
			rs.executeSql(logsql);
			rs.next();
			logsql = "update HrmStatusHistory set operatedate = '"+CurrentDate+"',operatetime='"+currentTime+"',clientaddress = '"+clientaddress+"',operatefrom = 'hrm' where id="+rs.getInt(1);
			rs2.executeSql(logsql);
            //OrganisationCom.checkUser(Integer.parseInt(id));
            //OrganisationCom.deleteUser2(ResourceComInfo.getLoginID(id));//人员离职从RTX中删除该人员
			new Thread(new OrganisationComRunnable("user","dismiss",id+"-"+loginId)).start();

			//OA与第三方接口单条数据同步方法开始
			HrmServiceManager.SynInstantHrmResource(id,"3");
			//OA与第三方接口单条数据同步方法结束 
            
            //离职时离职者参与的所有协作全部标记为已读 myq 修改 2008.2.18 开始
            rs.executeSql("select id,readers from cowork_items where coworkers like '%"+id+"%' and readers not like '"+id+"%'");
          	while(rs.next()){
          		String cowork_id = Util.null2String(rs.getString(1));
          		String readers = Util.null2String(rs.getString(2));
          		if(!readers.equals("")){ readers = readers + id + ",";}
          		else{ readers = "," + id + ",";}
          		rs2.executeSql("update cowork_items set readers='"+readers+"' where id="+cowork_id);
            }
            //离职时离职者参与的所有协作全部标记为已读 myq 修改 2008.2.20 结束
        }
    }

    else if(operation.equalsIgnoreCase("retire")){
        type =  "6";
        backurl = "HrmResourceRetire.jsp" ;
        for(int i=0 ; i<resourceids.length; i++) {
            String id = Util.null2String(resourceids[i]) ;
            String loginId = RTXConfig.getRtxLoginFiledExtend(Integer.parseInt(id));
            String name = ResourceComInfo.getResourcename(id);

            oldjobtitleid = ResourceComInfo.getJobTitle(id);
            para = ""+id+separator+changedate+separator+changereason+separator+changecontractid+separator+infoman+separator+oldjobtitleid+separator+type+separator+user.getUID();
            boolean flag=rs.executeProc("HrmResource_Retire",para);
            //delete by chengfeng.han 2011-7-18 27152 删除权限和手机用户不应该立即处理，应该在定时任务中处理
            //if(flag){
            //    rs.executeSql("delete from hrmrolemembers where resourceid="+id);
                //删除手机版中设置的登录人员
            //    rs.executeSql("delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue='"+id+"'");
            //}
            //end
            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(16124,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title =  SystemEnv.getHtmlLabelName(16124,user.getLanguage()) ;
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }

            if(Util.dayDiff(CurrentDate,changedate)<=1){
            	if(HrmDateCheck.hasStatueChanged(id, changedate)){
            		continue;
            	}
            	// 人员离职删除CoreMail中帐号
            	CoreMailAPI coremailapi = CoreMailAPI.getInstance();
            	coremailapi.synLeaveUser(id);
            	//CoreMailTestAPI testapi = CoreMailTestAPI.getInstance();
            	//testapi.synLeaveUser(id);
                
            	//add by chengfeng.han 2011-7-18 27152 如果离职日期和当前日期比较小于等于1天，就立即执行离职的相关处理
                rs.executeSql("delete from hrmrolemembers where resourceid="+id);
                //删除手机版中设置的登录人员
            	rs.executeSql("delete from PluginLicenseUser where plugintype='mobile' and sharetype='0' and sharevalue='"+id+"'");
           		//end
                String sql = "update HrmResource set status =6, loginid='',password='',account='',lastmoddate='"+changedate+"' where id = "+id;
               
                if("1".equals(coremailapi.getIsuse()) && "1".equals(coremailapi.getIssync())) {
                	sql = "update HrmResource set status=6, loginid='', password='', account='', email='', lastmoddate='"+changedate+"' where id = "+id;
	            }
                //if("1".equals(testapi.getIsuse()) && "1".equals(testapi.getIssync())) {
                //	sql = "update HrmResource set status=6, loginid='', password='', account='', email='', lastmoddate='"+changedate+"' where id = "+id;
	            //}
               
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
                rs.executeSql(sql);
            }

            //OrganisationCom.checkUser(Integer.parseInt(id));
            //OrganisationCom.deleteUser2(ResourceComInfo.getLoginID(id));//人员离职从RTX中删除该人员
			new Thread(new OrganisationComRunnable("user","retire",id+"-"+loginId)).start();

			//OA与第三方接口单条数据同步方法开始
			HrmServiceManager.SynInstantHrmResource(id,"3");  
			//OA与第三方接口单条数据同步方法结束 
        }
    }
    else if(operation.equalsIgnoreCase("rehire")){
        type =  "7";
        backurl = "HrmResourceRehire.jsp" ;
        for(int i=0 ; i<resourceids.length; i++) {
            String id = Util.null2String(resourceids[i]) ;
            String name = ResourceComInfo.getResourcename(id);

          //check user num
            boolean canSave = false;
            if(LN.CkHrmnum()<0){
                    canSave = true;
            }
            String sqluser = "select status from HrmResource where id = "+id;
            rs.executeSql(sqluser);
            rs.next();
            int userstatus = rs.getInt(1);
            if(userstatus==0||userstatus==1||userstatus==2||userstatus==3){
                canSave = true;
            }
            if(ResourceComInfo.getLoginID(id).equals("")){
                canSave = true;
            }

            if(!canSave){
               response.sendRedirect("/hrm/resource/HrmResourceRehire.jsp?errmsg=1");
               return;
            }

            oldjobtitleid = ResourceComInfo.getJobTitle(id);
            para = ""+id+separator+changedate+separator+changeenddate+separator+
                   changereason+separator+changecontractid+separator+infoman+separator+oldjobtitleid+separator+type+separator+user.getUID();
            rs.executeProc("HrmResource_Rehire",para);

            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(16125,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title =  SystemEnv.getHtmlLabelName(16125,user.getLanguage()) ;
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }

            if(Util.dayDiff(CurrentDate,changedate)<=1){
            	if(HrmDateCheck.hasStatueChanged(id, changedate)){
            		continue;
            	}
                String sql = "update HrmResource set status =1 where id = "+id;
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
                rs.executeSql(sql);
            }
            OrganisationCom.checkUser(Integer.parseInt(id));
        }
    }
    else if(operation.equalsIgnoreCase("try")){
        type =  "8";
        backurl = "HrmResourceTry.jsp" ;
        for(int i=0 ; i<resourceids.length; i++) {
            String id = Util.null2String(resourceids[i]) ;
            String name = ResourceComInfo.getResourcename(id);

          //check user num
            boolean canSave = false;
            if(LN.CkHrmnum()<0){
                canSave = true;
            }
            String sqluser = "select status from HrmResource where id = "+id;
            rs.executeSql(sqluser);
            rs.next();
            int userstatus = rs.getInt(1);
            if(userstatus != 2){
               response.sendRedirect("/hrm/resource/HrmResourceTry.jsp?errmsg=1");
               return;
            }

            oldjobtitleid = ResourceComInfo.getJobTitle(id);
            para = ""+id+separator+changedate+separator+changereason+separator+infoman+separator+oldjobtitleid+separator+type+separator+user.getUID();
            rs.executeProc("HrmResource_Try",para);

            if( !infoman.equals("")) {
                subject= SystemEnv.getHtmlLabelName(17514,user.getLanguage()) ;
                subject+=":"+name;
                  accepter = infoman;
                  title =  SystemEnv.getHtmlLabelName(17514,user.getLanguage()) ;
                  title += ":"+name;
                  title += "-"+CurrentUserName;
                  title += "-"+CurrentDate;
                  remark="<a href=/hrm/resource/HrmResource.jsp?id="+id+">"+Util.fromScreen2(subject,user.getLanguage())+"</a><br>"+SystemEnv.getHtmlLabelName(454,user.getLanguage())+":"+changereason;
                  submiter=CurrentUser;
                  SysRemindWorkflow.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
            }

            if(Util.dayDiff(CurrentDate,changedate)<=1){
            	if(HrmDateCheck.hasStatueChanged(id, changedate)){
            		continue;
            	}
                String sql = "update HrmResource set status =0 where id = "+id;
                rs.executeSql(sql);
                sql = "select max(id) from HrmStatusHistory";
                rs.executeSql(sql);
                rs.next();
                sql = "update HrmStatusHistory set isdispose = 1 where id="+rs.getInt(1);
                rs.executeSql(sql);
            }
        }
    }

    for(int i=0 ; i<resourceids.length; i++) {
        String id = Util.null2String(resourceids[i]) ;
        ResourceComInfo.updateResourceInfoCache(id);

        // 是否需要工资变动的判断  刘煜挪到这里
        if(ischangesalary.equals("1")){
            SalaryManager sm = new SalaryManager();
            sm.initResourceSalary(id);
        }
    }
}
//update popup message table
    int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
if(resourceids!=null){
    for (int i = 0; i < resourceids.length; i++) {
        rs.executeSql("SELECT id FROM HrmRemindMsg where remindtype<5 and resourceid=" + resourceids[i]);
        while (rs.next()) {
            String id = rs.getString("id");
            poppupRemindInfoUtil.updatePoppupRemindInfo(userid, 7, (logintype).equals("1") ? "0" : "1", Util.getIntValue(id, 0));
        }
    }
}
response.sendRedirect(backurl);

%>
