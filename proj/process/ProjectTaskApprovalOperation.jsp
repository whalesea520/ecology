
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.proj.Maint.*" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanViewer" %>

<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="PrjTskUtil" class="weaver.proj.util.PrjTskUtil" scope="page"/>

<%
    String hrmid="" ;
    int status = 0;
    String subject="";
    String begindate="";
    String enddate="";
    String content="";
    String ProjID ="";
    String parentids ="";


    char flag = Util.getSeparator();

    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);


    String CurrentUser = ""+user.getUID();
    String CurrentUserName = ""+user.getUsername();
    String SWFAccepter="";
    String SWFTitle="";
    String SWFRemark="";
    String SWFSubmiter="";

    int taskID =0;
    String method="";
    String[] arr= null;
    String opt= Util.null2String(request.getParameter("opt"));
    String ids= Util.null2String(request.getParameter("ids"));
    
    
    if("".equals(opt)||"".equals(ids)){
    	method= Util.null2String (request.getParameter("method"));
    	arr=new String[] {""+Util.getIntValue(request.getParameter("TaskID"))};
    }else{
    	arr=Util.TokenizerString2(ids, ",");
    	method="batchapprove".equalsIgnoreCase(opt)?"approve":"batchreject".equalsIgnoreCase(opt)?"refuse":"approve";
    }
    
for(int k=0;k<arr.length;k++){
	taskID=Util.getIntValue(arr[k]);
    
    int manager =0;
    
     
    
    String sqlStr ="";
    /*Test if the current user is the project manager*/
    if(taskID>0){
     sqlStr =" Select t1.ID,t1.manager,t2.parentids,t2.hrmid,t2.subject,t2.begindate,t2.enddate,t2.content,t2.status from Prj_ProjectInfo t1,Prj_TaskProcess t2 where t1.ID = t2.PrjID and t2.ID = "+taskID;
        RecordSet rs = new RecordSet();
        rs.executeSql(sqlStr);
        if(rs.next()){
            manager = rs.getInt("manager");
            hrmid = rs.getString("hrmid");
            subject = rs.getString("subject");
            begindate = rs.getString("begindate");
            enddate = rs.getString("enddate");
            content = rs.getString("content");
            status = rs.getInt("status") ;
            ProjID = rs.getString("ID");
            parentids = rs.getString("parentids");

        }
    }

    String Prj_manager = ""+manager;
    ArrayList arrayParentids = Util.TokenizerString(parentids,",");

    /**if(user.getUID() != manager){
        response.sendRedirect("/notice/noright.jsp") ;
        return;
    }**/

    /*If the task has been approved,then redirect to the task log page*/
    if(status == ProjectTask.APPROVED){
        response.sendRedirect("ProjectTaskApprovalDetail.jsp?TaskID="+taskID) ;
        return;
    }
    

    RecordSet rs = new RecordSet();

//================================================================================
//TD2521
//added by hubo,2006-03-19
int taskModifyLogMaxId = 0;
sqlStr = "Select MAX(id) AS maxid FROM Prj_TaskModifyLog WHERE TaskID="+taskID+"";
rs.executeSql(sqlStr);
if(rs.next()){
	taskModifyLogMaxId = rs.getInt("maxid");
}
//================================================================================


       /*approve operation*/
    if(method.equals("approve")){
         if(status == ProjectTask.DELETE_UNAPPROVED){
                String ProcPara ="";
           ProcPara = ""+taskID ;
             //联动删除子任务
            PrjTskUtil.linkedApproveSubTask(ProjID,""+taskID,method,status);
			rs.executeSql("delete Prj_TaskProcess where id="+taskID);
			//更新工作计划中该项目的经理的时间Begin
			String begindate01 = "";
			String enddate01 = "";

			rs.executeProc("Prj_TaskProcess_Sum",""+ProjID);
			if(rs.next() && !rs.getString("workday").equals("")){

				if(!rs.getString("begindate").equals("x")) begindate01 = rs.getString("begindate");
				if(!rs.getString("enddate").equals("-")) enddate01 = rs.getString("enddate");

			}
			if (!begindate01.equals("")){
				rs.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
			}
			//更新工作计划中该项目的经理的时间End

			//删除工作计划Begin

			rs.executeSql("delete from workplan where taskid = " + taskID);

			//删除工作计划End

			int i=arrayParentids.size()-2;
			for( i=arrayParentids.size()-2;i>=0;i--){
				String tmpparentid = ""+arrayParentids.get(i);
				String sqlx = "select begindate,begintime,enddate,endtime from Prj_TaskProcess where id = "+tmpparentid;
                   rs.executeSql(sqlx);
                   String begindate2 = "";
	               String begintime2 = "";
	               String enddate2 = "";
	               String endtime2 = "";
                   if(rs.next()){
	                    begindate2 = rs.getString("begindate");
	                    begintime2 = rs.getString("begintime");
	                    enddate2 = rs.getString("enddate");
	                    endtime2 = rs.getString("endtime");
                   }
				rs.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid);
				 sqlx = "update Prj_TaskProcess set begindate='"+begindate2+"',begintime = '"+begintime2+"',enddate = '"+enddate2+"',endtime = '"+endtime2+"' where id = "+tmpparentid;
                 rs.executeSql(sqlx);
			}


			String tmpsql="";
			if(i>=0){
			tmpsql="update Prj_taskprocess set childnum=childnum-1 where id="+arrayParentids.get(arrayParentids.size()-2);
			rs.executeSql(tmpsql);
			}

			//PrjViewer.setPrjShareByPrj(""+ProjID);
			tmpsql="select * from prj_taskinfo where prjid="+ProjID;
			rs.executeSql(tmpsql);
			if(rs.next()){
				tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID;
				rs.executeSql(tmpsql);
			}


        }else if(status == ProjectTask.ADD_UNAPPROVED){
            /*触发工作流通知任务负责人或经理*/
                   boolean isall=true;
                   if(CurrentUser.equals(Prj_manager) && (","+hrmid+",").indexOf(","+CurrentUser+",")!=-1) isall=false;
                   if (isall){//任务负责人是自己，也是经理就不触发
                      if( CurrentUser.equals(Prj_manager) && (","+hrmid+",").indexOf(","+CurrentUser+",")==-1 ){//经理自己,负责人不是自己
                          SWFAccepter=hrmid;
                      }
                      if( (!CurrentUser.equals(Prj_manager) ) && (","+hrmid+",").indexOf(","+CurrentUser+",")==-1 ){//不是经理，负责人也不是自己
                          SWFAccepter=hrmid+","+Prj_manager;
                      }
                      if ( (!CurrentUser.equals(Prj_manager) ) && (","+hrmid+",").indexOf(","+CurrentUser+",")!=-1 ){//不是经理，负责人是自己
                          SWFAccepter= Prj_manager;
                      }
                      //SWFAccepter=hrmid+","+Prj_manager;
                      //SWFTitle=Util.toScreen("项目",user.getLanguage(),"0");
                      //SWFTitle += ":"+Prj_name;
                      SWFTitle =SystemEnv.getHtmlLabelName(15283,user.getLanguage());
                      SWFTitle += ":"+subject;
                      SWFTitle += "-"+CurrentUserName;
                      SWFTitle += "-"+CurrentDate;
                      SWFRemark="";
                      SWFSubmiter=CurrentUser;

                      SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
                  }

                   
				//添加工作计划
           		WorkPlan workPlan = new WorkPlan();
           		
           		workPlan.setCreaterId(Integer.parseInt(CurrentUser));

           	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
           	    workPlan.setWorkPlanName(subject);    
           	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
           	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
           	    workPlan.setResourceId(hrmid);           	    
           	    workPlan.setBeginDate(begindate);           	    
           	    workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间	    
           	    workPlan.setEndDate(enddate);
           	    workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
           	    
           	 	String workPlanDescription = Util.null2String(content);
     	    	workPlanDescription = Util.replace(workPlanDescription, "\n", "", 0);
     	    	workPlanDescription = Util.replace(workPlanDescription, "\r", "", 0);
           	    workPlan.setDescription(workPlanDescription);           	    
           	    
           	    workPlan.setProject(ProjID);
           	    workPlan.setTask(""+taskID);

           	    workPlanService.insertWorkPlan(workPlan);  //插入日程
                


        }else if(status == ProjectTask.MODIFY_UNAPPROVED){
            sqlStr = "Select  * From Prj_TaskModifyLog WHERE status=0 and OperationType = "+ProjectTask.MODIFY_UNAPPROVED+"  and TaskID="+taskID+" Order by ID ";
            rs.executeSql(sqlStr);
            String strTemp = hrmid ;
            String Subject = "";
            if(hrmid.equals(rs.getString("HrmID"))){
                //触发工作流通知原任务负责人和现任务负责人，若其中有一个是现登陆者，那么就不用再通知本人。
                      if(CurrentUser.equals(Prj_manager)){//修改者是经理
                          if(CurrentUser.equals(strTemp)){//同时原负责人也是自己,只要通知当前负责人
                              SWFAccepter=hrmid;
                          }
                          else{
                              if(CurrentUser.equals(hrmid)){//原负责人不是自己，现负责人是自己,通知原负责人
                                  SWFAccepter = strTemp;
                              }
                              else{//原负责人不是自己，现负责人也不是自己:通知原负责人和现负责人
                                  SWFAccepter = hrmid+","+strTemp;
                              }
                          }
                      }
                      else{
                          if(CurrentUser.equals(strTemp)){//不是经理，同时原负责人是自己：要通知现负责人和经理
                              SWFAccepter=hrmid+","+Prj_manager;
                          }
                          else{
                              if(CurrentUser.equals(hrmid)){//不是经理，同时现负责人是自己。通知原负责人和经理
                                  SWFAccepter=Prj_manager+","+strTemp;
                              }
                              else{//不是经理，也不是现负责人。通知三个人
                                  SWFAccepter=hrmid+","+Prj_manager+","+strTemp;
                              }
                          }
                      }

                      //out.print(SWFAccepter);
                      String name=ResourceComInfo.getResourcename(hrmid);
                      Subject=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                      Subject+=":"+subject+"-";
                      Subject+=SystemEnv.getHtmlLabelName(15285,user.getLanguage());
                      Subject+=":"+name;

                      //SWFTitle=SystemEnv.getHtmlLabelName(101,user.getLanguage());
                      //SWFTitle += ":"+Prj_name;
                      SWFTitle=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                      SWFTitle += ":"+subject;
                      SWFTitle += "-"+CurrentUserName;
                      SWFTitle += "-"+CurrentDate;
                      SWFRemark="<a href=/proj/process/ViewProcess.jsp?ProjID="+ProjID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
                      SWFSubmiter=CurrentUser;

                      SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);


            }

        }

        /*Update the task status first*/

        sqlStr ="Update Prj_TaskProcess Set status=0 Where ID="+taskID;
        rs.executeSql(sqlStr);
        /*Then Update the Log Status */
		  //TD2521
		  //modified by hubo,2006-03-19
        sqlStr ="Update Prj_TaskModifyLog Set status = 1 WHERE id="+taskModifyLogMaxId;
        rs.executeSql(sqlStr);

        //response.sendRedirect("ProjectTaskApprovalDetail.jsp?TaskID="+taskID) ;
        //return;
    }
        /*refuse operation*/
    if(method.equals("refuse")){

        if(status == ProjectTask.DELETE_UNAPPROVED){
                sqlStr ="Update Prj_TaskProcess Set status=0 Where ID="+taskID;
                rs.executeSql(sqlStr);
                PrjTskUtil.linkedRefuseParentTask(ProjID,""+taskID,method,status);
        }else if(status == ProjectTask.ADD_UNAPPROVED){
             sqlStr = "Update Prj_TaskProcess Set status=0 WHERE ID="+taskID;
             rs.executeSql(sqlStr);
            String ProcPara ="";
           ProcPara = ""+taskID ;
			//rs.executeProc("Prj_TaskProcess_DeleteByID",ProcPara);
            rs.executeSql("delete Prj_TaskProcess where id="+taskID);
			//更新工作计划中该项目的经理的时间Begin
			String begindate01 = "";
			String enddate01 = "";

			rs.executeProc("Prj_TaskProcess_Sum",""+ProjID);
			if(rs.next() && !rs.getString("workday").equals("")){

				if(!rs.getString("begindate").equals("x")) begindate01 = rs.getString("begindate");
				if(!rs.getString("enddate").equals("-")) enddate01 = rs.getString("enddate");

			}
			if (!begindate01.equals("")){
				rs.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
			}
			//更新工作计划中该项目的经理的时间End

			//删除工作计划Begin

			rs.executeSql("delete from workplan where taskid = " + taskID);

			//删除工作计划End

			int i=arrayParentids.size()-2;
			for( i=arrayParentids.size()-2;i>=0;i--){
				String tmpparentid = ""+arrayParentids.get(i);
				String sqlx = "select begindate,begintime,enddate,endtime from Prj_TaskProcess where id = "+tmpparentid;
                   rs.executeSql(sqlx);
                   String begindate2 = "";
	               String begintime2 = "";
	               String enddate2 = "";
	               String endtime2 = "";
                   if(rs.next()){
	                    begindate2 = rs.getString("begindate");
	                    begintime2 = rs.getString("begintime");
	                    enddate2 = rs.getString("enddate");
	                    endtime2 = rs.getString("endtime");
                   }
				rs.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid);
				 sqlx = "update Prj_TaskProcess set begindate='"+begindate2+"',begintime = '"+begintime2+"',enddate = '"+enddate2+"',endtime = '"+endtime2+"' where id = "+tmpparentid;
                 rs.executeSql(sqlx);
			}


			String tmpsql="";
			if(i>=0){
			tmpsql="update Prj_taskprocess set childnum=childnum-1 where id="+arrayParentids.get(arrayParentids.size()-2);
			rs.executeSql(tmpsql);
			}

			//PrjViewer.setPrjShareByPrj(""+ProjID);
			tmpsql="select * from prj_taskinfo where prjid="+ProjID;
			rs.executeSql(tmpsql);
			if(rs.next()){
				tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID;
				rs.executeSql(tmpsql);
			}
        }else if(status == ProjectTask.MODIFY_UNAPPROVED){
             /*restore the task info*/
            sqlStr = "Select  * From Prj_TaskModifyLog WHERE status=0 and OperationType = "+ProjectTask.MODIFY_UNAPPROVED+"  and TaskID="+taskID+" Order by ID Desc";
            rs.executeSql(sqlStr);
            if(rs.next()) {
                sqlStr = "Update Prj_TaskProcess Set" +
                        " Subject='" +rs.getString("Subject")+   "'"+
                        ",HrmID='" + rs.getString("HrmID")+"' "+
                        ",BeginDate='" +  rs.getString("BeginDate")+ "'"+
                        ",EndDate='" +rs.getString("EndDate")+ "'"+
                        ",WorkDay=" + rs.getString("WorkDay")+
                        ",FixedCost=" + rs.getString("FixedCost")+
                        ",Finish=" +  rs.getString("Finish")+
                        ",Prefinish='" + rs.getString("Prefinish")+   "'"+
                        ",isLandMark='" +   rs.getString("isLandMark")+  "'"+
                        ",status=0 " +
                        " Where ID="+taskID;

                 rs.executeSql(sqlStr);

                manager = rs.getInt("manager");
              hrmid = rs.getString("hrmid");
              subject = rs.getString("subject");
              begindate = rs.getString("begindate");
              enddate = rs.getString("enddate");
              content = rs.getString("content");
              status = rs.getInt("status") ;
              ProjID = rs.getString("projid");
              parentids = rs.getString("parentids");

                //编辑工作计划Begin

                   String para = "";
                   String workid = "";
                   rs.executeSql("select id from workplan where taskid = " + taskID);

                   if (rs.next()) {
                       workid = rs.getString("id");

                       para = workid;
                       para +=flag+"2"; //type_n
                       para +=flag+subject;
                       para +=flag+hrmid;
                       para +=flag+begindate;
                       para +=flag+""; //BeginTime
                       para +=flag+enddate;
                       para +=flag+""; //EndTime
                       para +=flag+"008DC8";
                       para +=flag+content;
                       para +=flag+"0";//requestid
                       para +=flag+ProjID;//projectid
                       para +=flag+"0";//crmid
                       para +=flag+"0";//docid
                       para +=flag+"0";//meetingid
                       para +=flag+"1";//isremind;
                       para +=flag+"0";//waketime;

                       rs.executeProc("WorkPlan_Update",para);
                       WorkPlanViewer.setWorkPlanShareById(workid);
                   }

               //编辑工作计划End
            }
            //更新工作计划中该项目的经理的时间Begin
               String begindate01 = "";
               String enddate01 = "";

               rs.executeProc("Prj_TaskProcess_Sum",""+ProjID);
               if(rs.next() && !rs.getString("workday").equals("")){

                   if(!rs.getString("begindate").equals("x")) begindate01 = rs.getString("begindate");
                   if(!rs.getString("enddate").equals("-")) enddate01 = rs.getString("enddate");

               }
               if (!begindate01.equals("")){
                   rs.executeSql("update workplan set begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
               }
               //更新工作计划中该项目的经理的时间End



               for(int i=arrayParentids.size()-2;i>=0;i--){
                   String tmpparentid = ""+arrayParentids.get(i);
                   String sqlx = "select begindate,begintime,enddate,endtime from Prj_TaskProcess where id = "+tmpparentid;
                   rs.executeSql(sqlx);
                   String begindate2 = "";
	               String begintime2 = "";
	               String enddate2 = "";
	               String endtime2 = "";
                   if(rs.next()){
	                    begindate2 = rs.getString("begindate");
	                    begintime2 = rs.getString("begintime");
	                    enddate2 = rs.getString("enddate");
	                    endtime2 = rs.getString("endtime");
                   }
                   rs.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid);
				   sqlx = "update Prj_TaskProcess set begindate='"+begindate2+"',begintime = '"+begintime2+"',enddate = '"+enddate2+"',endtime = '"+endtime2+"' where id = "+tmpparentid;
                   rs.executeSql(sqlx);
                   // out.print(RecordSet.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid));
               }

        }

        /*Then Update the Log Status */
		  //TD2521
		  //modified by hubo,2006-03-19
        sqlStr ="Update Prj_TaskModifyLog Set status = 2 WHERE id="+taskModifyLogMaxId;
        rs.executeSql(sqlStr);
        //response.sendRedirect("ProjectTaskApprovalDetail.jsp?TaskID="+taskID) ;
        //return;
    }
        
        
}


%>