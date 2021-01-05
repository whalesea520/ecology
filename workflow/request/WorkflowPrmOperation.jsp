
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String ProcPara = "";
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码                //当前用户id
String userID = ""+user.getUID();
int usertype = 0;
String operator=String.valueOf(user.getUID());
String method = Util.null2String(request.getParameter("method"));
int iscanread = Util.getIntValue(request.getParameter("iscanread"), 0); 
int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"),user.getUserSubCompany1());
int subid = Util.getIntValue(request.getParameter("subid"),user.getUserSubCompany1());
String ip=Util.getIpAddr(request);
//添加流程共享
if(method.equals("prmAdd")){
	boolean flag = false;
	String wfid =   Util.null2String(request.getParameter("wfid"));
	String requestid =   Util.null2String(request.getParameter("requestid"));
	String currentnodeid =   Util.null2String(request.getParameter("currentnodeid"));
	
	int currentid=-1;
	String currentsql = " select id from workflow_currentoperator where requestid="+requestid+" AND nodeid="+currentnodeid+" AND userid ="+operator;
	rs1.executeSql(currentsql);
	if(rs1.next()){
		currentid = rs1.getInt("id");
	}else{
		//如果是监控人添加，if条件就不满足，取当前节点操作者对应currentid
		currentsql = " select id from workflow_currentoperator where requestid="+requestid+" AND nodeid="+currentnodeid;
		rs1.executeSql(currentsql);
		if(rs1.next()){
			currentid = rs1.getInt("id");
		}
	}
	
	String sql = "";
    String permissiontype=Util.null2String(request.getParameter("permissiontype"));
    
    
    ArrayList relatedids = new ArrayList();
    int rt_rolelevel = 0 ;
    int rt_showlevel = 0 ;
    int rt_showlevel2 = 0 ;
    
    if("1".equals(permissiontype)){
            String departmentid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            int deptlevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int deptlevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            rt_showlevel = deptlevel ;
            rt_showlevel2 = deptlevelMax ;
            if(departmentid.length>0){
                for(String did : departmentid){
                	relatedids.add(did);
                    sql = "select wfid,requestid,departmentid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+ " and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and departmentid = "+did + " and deptlevel = " + deptlevel + " and deptlevelMax = " + deptlevelMax+" and currentid="+currentid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,departmentid,deptlevel,deptlevelMax,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+did+","+deptlevel+","+deptlevelMax+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")";
                        flag = RecordSet.executeSql(sql);
                    }
                }
            }
        }  else if("2".equals(permissiontype)){
        	String roleid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("roleid")),",");
            int rolelevel = Util.getIntValue(request.getParameter("rolelevel"), 0);
            int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            
            rt_rolelevel = rolelevel ;
            rt_showlevel = seclevel ;
            rt_showlevel2 = seclevelMax ;
            
            if(roleid.length>0){
                for(String did : roleid){
                	relatedids.add(did);
                    sql = "select wfid,roleid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and roleid = " + did + " and roleseclevel = " + seclevel + " and roleseclevelMax = " + seclevelMax +" and rolelevel = "+rolelevel+" and currentid="+currentid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,roleid,roleseclevel,roleseclevelMax,rolelevel,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+did+","+seclevel+","+seclevelMax+","+rolelevel+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")";
                        flag = RecordSet.executeSql(sql);
                    }
                }
            }
        }  else if("3".equals(permissiontype)){
            int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            
            rt_showlevel = seclevel ;
            rt_showlevel2 = seclevelMax ;
            
            sql = "select wfid,permissiontype from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = "+operator+" and currentnodeid = "+currentnodeid+" and permissiontype="+permissiontype+ " and seclevel = " + seclevel + " and seclevelMax = " + seclevelMax+" and currentid="+currentid;
            RecordSet.executeSql(sql);
            if(!RecordSet.next()){
                sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,seclevel,seclevelMax,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+seclevel+","+seclevelMax+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
                RecordSet.executeSql(sql);
            }
        }   else if("5".equals(permissiontype)){
            String userid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
            if(userid.length>0){
                  for(String uid : userid){
                	  relatedids.add(uid);
                       sql = "select wfid,userid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and userid = "+uid +" and currentid="+currentid;
                      RecordSet.executeSql(sql)   ;
                      if(!RecordSet.next()){
                          sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,userid,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+uid+","+iscanread+","+operator+","+currentnodeid+","+currentid+")"   ;
                          RecordSet.executeSql(sql);
                      }
                  }
            }
        } else if("6".equals(permissiontype)){
            String subcompanyids[]  = Util.TokenizerString2(Util.null2String(request.getParameter("subids")),",");
            int sublevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int sublevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            
            rt_showlevel = sublevel ;
            rt_showlevel2 = sublevelMax ;
            
            if(subcompanyids.length>0){
                for(String sid : subcompanyids){
                	relatedids.add(sid);
                    sql = "select wfid,subcompanyid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and subcompanyid = "+sid+ " and sublevel = " + sublevel + " and sublevelMax = " + sublevelMax+" and currentid="+currentid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next()){
                        sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,subcompanyid,sublevel,sublevelMax,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+sid+","+sublevel+","+sublevelMax+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }
                }
            }
        } else if("7".equals(permissiontype)){
            String jobid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("jobid")),",");
            int joblevel = Util.getIntValue(request.getParameter("joblevel"), 0); 
            String jobobj = Util.null2String(request.getParameter("relatedshareid_6"));
            int jobobjid = -1;
            rt_showlevel = joblevel ;
            //rt_showlevel2 = sublevelMax ;
            
            if(jobid.length>0){
                for(String sid : jobid){
                	relatedids.add(sid);
                    String[] jobobjids = Util.splitString(jobobj,",");
	    			for(int s=0;s<jobobjids.length;s++){
	    				//updatesql = "insert into  Workflow_SharedScope(wfid,requestid,permissiontype,iscanread,operator,currentnodeid,joblevel,jobid,jobobjid)  " +
	    				//		" values("+wfid+","+requestid+","+permissiontype+","+iscanread+",'"+operator+"',"+currentnodeid+","+joblevel+","+jobid+","+jobobjids[s]+") ";
	    				//rs1.executeSql(updatesql);
	    				jobobjid = Util.getIntValue(jobobjids[s], -1);
	    				sql = "select wfid,subcompanyid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and jobid = "+sid+ " and joblevel = " + joblevel + " and jobobjid = " + jobobjid + " and currentid="+currentid;
	                    RecordSet.executeSql(sql);
	                    if(!RecordSet.next()){
	                        sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,jobid,joblevel,jobobjid,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+sid+","+joblevel+","+jobobjid+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")";
	                        flag = RecordSet.executeSql(sql);
	                    }
	    			}
                }
            }
        }
        //SysMaintenanceLog.resetParameter();
		//SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(mid),name,"添加会议室共享","210","1",0,ip);
		
		//流程共享赋权
		new weaver.workflow.request.RequestAddShareMode().getWfShareUserid(Util.getIntValue(requestid),wfid,permissiontype,relatedids,rt_rolelevel,rt_showlevel,rt_showlevel2);
	
        response.sendRedirect("/workflow/request/WorkflowPrmsnAdd.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+usertype+"&isclose=1&wfid="+wfid+"&requestid="+requestid);
		return;

}
//删除流程共享
if(method.equals("prmDelete")){
	String wfid = Util.null2String(request.getParameter("wfid"));
	String requestid = Util.null2String(request.getParameter("requestid"));
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		String sql = "delete from Workflow_SharedScope where id in ("+ids+")";
		RecordSet.execute(sql);
		
		//SysMaintenanceLog.resetParameter();
		//SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),ids,"删除会议室共享","210","3",0,ip);
		//return;
	}
	response.sendRedirect("/workflow/request/WorkflowPrmsnAdd.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+usertype+"&wfid="+wfid+"&requestid="+requestid);
	return;
}

%>
