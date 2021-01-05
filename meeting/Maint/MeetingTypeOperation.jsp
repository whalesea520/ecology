
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="MeetingTypeComInfo" class="weaver.meeting.Maint.MeetingTypeComInfo" scope="page" />
<%
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"),user.getUserSubCompany1());
int subid = Util.getIntValue(request.getParameter("subid"),user.getUserSubCompany1());
String ip=Util.getIpAddr(request);

boolean canedit=false;
if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)) {
	canedit=true;
}
if (!canedit) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
if(method.equals("add"))
{
	String forward = Util.null2String(request.getParameter("forwd"));
	String name=Util.null2String(request.getParameter("name"));
	int approver=Util.getIntValue(request.getParameter("approver"), 0);
	int approver1=Util.getIntValue(request.getParameter("approver1"), 0);
	String desc=Util.null2String(request.getParameter("desc"));
	String catalogpath = Util.null2String(request.getParameter("catalogpath"));
	String dsporder=Util.getPointValue(request.getParameter("dsporder"), 1, "0");
	
	String sql = "insert into Meeting_Type(name,approver,approver1,desc_n,subcompanyid,catalogpath,dsporder)"
			+" values('"+name+"',"+approver+","+approver1+",'"+desc+"',"+subcompanyid+",'"+catalogpath+"',"+dsporder+")";

	RecordSet.execute(sql);
	
	sql = "select id from Meeting_Type where name ='"+name+"'";
    RecordSet.execute(sql);
    int id = -1;
    if(RecordSet.next()) {
    	id = RecordSet.getInt("id");
    	if(ManageDetachComInfo.isUseMtiManageDetach()){
	    	sql = " insert into MeetingType_share (mtid,permissiontype,subcompanyid,sublevel,sublevelMax) values ("+id+","+6+","+subcompanyid+","+0+","+100+")"   ;
    	}else{
    		sql = " insert into MeetingType_share (mtid,permissiontype,seclevel,seclevelMax) values ("+id+",3,"+0+","+100+")"   ;
    	}
    	RecordSet.executeSql(sql);
    	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.insSysLogInfo(user,id,name,"新增会议类型","209","1",0,ip);
    	MeetingTypeComInfo.removeMeetingTypeInfoCache();
    } 

	if("edit".equals(forward)) {
    	if(id != -1) {
    		//response.sendRedirect("/meeting/Maint/MeetingTypeEditTab.jsp?dialog=1&id="+id+"&method=edit&from=add");
    		out.println("<script>wfforward(\"/meeting/Maint/MeetingTypeEditTab.jsp?dialog=1&reloadTb=1&id="+id+"&method=edit&from=add\");</script>");
    		return;
    	} 
    } 
	%>
	<script type="text/javascript">
		try{
			var parentWin1 = parent.parent.getParentWindow(window.parent);
			//parentWin1.location="/meeting/Maint/MeetingType_left.jsp?subCompanyId=<%=subcompanyid%>";
			parentWin1.closeDlgARfsh();
		}catch(e){}
	</script>
	<%
	return;
}

if(method.equals("edit"))
{
	String id=Util.null2String(request.getParameter("mid"));
	String name=Util.null2String(request.getParameter("name"));
	int approver=Util.getIntValue(request.getParameter("approver"), 0);
	int approver1=Util.getIntValue(request.getParameter("approver1"), 0);
	String desc=Util.null2String(request.getParameter("desc"));
	String catalogpath = Util.null2String(request.getParameter("catalogpath"));
	String dsporder=Util.getPointValue(request.getParameter("dsporder"), 1, "0");
	
	String sql = "update Meeting_Type set name ='" + name + "' "
		+ ", subcompanyid = " + subcompanyid
		+ ", approver = " + approver
		+ ", approver1 = " + approver1
		+ ", desc_n = '" + desc + "' "
		+ ", catalogpath = '" + catalogpath + "' "
		+ ", dsporder = " + dsporder
		+ " where id = "+id;
		//System.out.println(sql);
	RecordSet.execute(sql);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),name,"修改会议类型","209","2",0,ip);
	MeetingTypeComInfo.removeMeetingTypeInfoCache();
	response.sendRedirect("/meeting/Maint/MeetingTypeEdit.jsp?&reloadTb=1&dialog=1&id="+id+"&method=edit");
	return;
}

//删除会议室
if(method.equals("delete"))
{
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		RecordSet.execute("select * from Meeting_Type where id in ("+ids+")");
		while(RecordSet.next()){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("id"),RecordSet.getString("name"),"删除会议类型","209","3",0,ip);
		}
		
		String sql = "delete from Meeting_Type where id in ("+ids+")";
		RecordSet.execute(sql);
		RecordSet.execute("delete from MeetingType_share where mtid in ("+ids+")");
		MeetingTypeComInfo.removeMeetingTypeInfoCache();
	}
	%>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%
	return;
}

//添加会议类型共享
if(method.equals("prmAdd")){
	boolean flag = false;
	String mid =   Util.null2String(request.getParameter("mid"));
	RecordSet.execute("select * from Meeting_Type where id = "+mid);
	String name="";
	if(RecordSet.next()){
		name=RecordSet.getString("name");
	}
	String sql = "";
        String permissiontype=         Util.null2String(request.getParameter("permissiontype"));
        if("1".equals(permissiontype)){
            String departmentid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            String deptlevel = Util.null2String(request.getParameter("seclevel"));
            String deptlevelMax = Util.null2String(request.getParameter("seclevelMax"));
            if(departmentid.length>0){
                for(String did : departmentid){
                    sql = "select mtid,departmentid from MeetingType_share where mtid ="+mid +" and departmentid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingType_share (mtid,permissiontype,departmentid,deptlevel,deptlevelMax) values ("+mid+","+permissiontype+","+did+","+deptlevel+","+deptlevelMax+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingType_share set deptlevel = "+deptlevel+",deptlevelMax="+deptlevelMax+" where mtid="+mid+" and departmentid = "+did   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }  else if("2".equals(permissiontype)){
        	String roleid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("roleid")),",");
            int rolelevel = Util.getIntValue(request.getParameter("rolelevel"), 0);
            int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            if(roleid.length>0){
                for(String did : roleid){
                    sql = "select mtid,departmentid from MeetingType_share where mtid ="+mid +" and roleid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingType_share (mtid,permissiontype,roleid,roleseclevel,roleseclevelMax,rolelevel) values ("+mid+","+permissiontype+","+did+","+seclevel+","+seclevelMax+","+rolelevel+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingType_share set roleseclevel = "+seclevel+",roleseclevelMax="+seclevelMax+",rolelevel="+rolelevel+" where mtid="+mid+" and roleid = "+did   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }  else if("3".equals(permissiontype)){
            String seclevel = Util.null2String(request.getParameter("seclevel"));
            String seclevelMax = Util.null2String(request.getParameter("seclevelMax"));
            sql = "select mtid,permissiontype from MeetingType_share where mtid ="+mid +" and permissiontype="+permissiontype;
            RecordSet.executeSql(sql);
            if(!RecordSet.next())                 {
                sql = " insert into MeetingType_share (mtid,permissiontype,seclevel,seclevelMax) values ("+mid+","+permissiontype+","+seclevel+","+seclevelMax+")"   ;
                RecordSet.executeSql(sql);
            }   else{
                sql = " update MeetingType_share set seclevel = "+seclevel+",seclevelMax="+seclevelMax+" where mtid="+mid+" and permissiontype = "+permissiontype   ;
                RecordSet.executeSql(sql);
            }
        }   else if("5".equals(permissiontype)){
            String userid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
            if(userid.length>0){
                  for(String uid : userid){
                       sql = "select mtid,userid from MeetingType_share where mtid ="+mid +" and userid = "+uid ;
                      RecordSet.executeSql(sql)   ;
                      if(!RecordSet.next())                 {
                          sql = " insert into MeetingType_share (mtid,permissiontype,userid) values ("+mid+","+permissiontype+","+uid+")"   ;
                          RecordSet.executeSql(sql);
                      }
                  }
            }
        } else if("6".equals(permissiontype)){
            String subcompanyids[]  = Util.TokenizerString2(Util.null2String(request.getParameter("subids")),",");
            String sublevel = Util.null2String(request.getParameter("seclevel"));
            String sublevelMax = Util.null2String(request.getParameter("seclevelMax"));
            if(subcompanyids.length>0){
                for(String sid : subcompanyids){
                    sql = "select mtid,subcompanyid from MeetingType_share where mtid ="+mid +" and subcompanyid = "+sid;
                    //System.out.println(sql);
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingType_share (mtid,permissiontype,subcompanyid,sublevel,sublevelMax) values ("+mid+","+permissiontype+","+sid+","+sublevel+","+sublevelMax+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingType_share set sublevel = "+sublevel+",sublevelMax="+sublevelMax+" where mtid="+mid+" and subcompanyid = "+sid   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }
        else if("8".equals(permissiontype)){
        	String jobid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("jobid")),",");
            int joblevel = Util.getIntValue(request.getParameter("joblevel"), 0); 
            String joblevelvalue ="";
            if(joblevel==1){
            	joblevelvalue=Util.null2String(request.getParameter("sublevelids"));
            }else if(joblevel==2){
            	joblevelvalue=Util.null2String(request.getParameter("deplevelids"));
            }
            if(jobid.length>0){
                for(String jid : jobid){
                	sql = "select mtid from MeetingType_share where mtid ="+mid +" and jobtitleid = "+jid;
                	 RecordSet.executeSql(sql);
                    if(!RecordSet.next()){
                    	sql = " insert into MeetingType_share (mtid,permissiontype,jobtitleid,joblevel,joblevelvalue) values ("+mid+","+permissiontype+","+jid+","+joblevel+",'"+joblevelvalue+"')";
                        flag = RecordSet.executeSql(sql);
                    } else{
                    	sql = " update MeetingType_share set joblevel = "+joblevel+",joblevelvalue="+joblevelvalue+" where mtid="+mid+" and jobtitleid = "+jid;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }
        SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(mid),name,"添加会议类型共享","209","1",0,ip);
        response.sendRedirect("/meeting/Maint/MeetingTypePrmsnAdd.jsp?isclose=1&mid="+mid);
		return;

}

//删除会议类型
if(method.equals("prmDelete")){
	String id = Util.null2String(request.getParameter("mid"));
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		RecordSet.execute("select DISTINCT mtid from MeetingType_share where id in ("+ids+")");
		if(RecordSet.next()){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("mtid"),ids,"删除会议类型共享","209","3",0,ip);
		}
		String sql = "delete from MeetingType_share where id in ("+ids+")";
		RecordSet.execute(sql);
		return;
	}
	response.sendRedirect("/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id="+id+"&method=share");
	return;
}

//添加会议类型参会人
if(method.equals("mbrAdd")){
	boolean flag = false;
	String mid =   Util.null2String(request.getParameter("mid"));
	String desc_n = Util.null2String(request.getParameter("desc_n"));
	String sql = "";
        String membertype=         Util.null2String(request.getParameter("membertype"));
        if("5".equals(membertype)){
            String departmentid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            String deptlevel = Util.null2String(request.getParameter("seclevel"));
            String deptlevelMax = Util.null2String(request.getParameter("seclevelMax"));
            if(departmentid.length>0){
                for(String did : departmentid){
                    sql = "select meetingtype,departmentid from Meeting_Member where meetingtype ="+mid +" and departmentid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into Meeting_Member (meetingtype,membertype,departmentid,seclevel,seclevelMax,desc_n) values ("+mid+","+membertype+","+did+","+deptlevel+","+deptlevelMax+",'"+desc_n+"')"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update Meeting_Member set seclevel = "+deptlevel+",seclevelMax="+deptlevelMax+",desc_n='"+desc_n+"' where meetingtype="+mid+" and departmentid = "+did   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }  else if("2".equals(membertype)){
            String crmid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("crmid")),",");
            if(crmid.length>0){
                  for(String uid : crmid){
                       sql = "select meetingtype,memberid from Meeting_Member where meetingtype ="+mid +" and memberid = "+uid ;
                      RecordSet.executeSql(sql)   ;
                      if(!RecordSet.next())                 {
                          sql = " insert into Meeting_Member (meetingtype,membertype,memberid,desc_n) values ("+mid+","+membertype+","+uid+",'"+desc_n+"')"   ;
                          RecordSet.executeSql(sql);
                      }
                  }
            }
        } else if("3".equals(membertype)){
            String seclevel = Util.null2String(request.getParameter("seclevel"));
            String seclevelMax = Util.null2String(request.getParameter("seclevelMax"));
            sql = "select meetingtype,membertype from Meeting_Member where meetingtype ="+mid +" and membertype="+membertype;
            RecordSet.executeSql(sql);
            if(!RecordSet.next())                 {
                sql = " insert into Meeting_Member (meetingtype,membertype,seclevel,seclevelMax,desc_n) values ("+mid+","+membertype+","+seclevel+","+seclevelMax+",'"+desc_n+"')"   ;
                RecordSet.executeSql(sql);
            }   else{
                sql = " update Meeting_Member set seclevel = "+seclevel+",seclevelMax="+seclevelMax+",desc_n='"+desc_n+"' where meetingtype="+mid+" and membertype = "+membertype   ;
                RecordSet.executeSql(sql);
            }
        }   else if("1".equals(membertype)){
            String userid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
            if(userid.length>0){
                  for(String uid : userid){
                       sql = "select meetingtype,memberid from Meeting_Member where meetingtype ="+mid +" and memberid = "+uid ;
                      RecordSet.executeSql(sql)   ;
                      if(!RecordSet.next())                 {
                          sql = " insert into Meeting_Member (meetingtype,membertype,memberid,desc_n) values ("+mid+","+membertype+","+uid+",'"+desc_n+"')"   ;
                          RecordSet.executeSql(sql);
                      }
                  }
            }
        } else if("6".equals(membertype)){
            String subcompanyids[]  = Util.TokenizerString2(Util.null2String(request.getParameter("subids")),",");
            String sublevel = Util.null2String(request.getParameter("seclevel"));
            String sublevelMax = Util.null2String(request.getParameter("seclevelMax"));
            if(subcompanyids.length>0){
                for(String sid : subcompanyids){
                    sql = "select meetingtype,subcompanyid from Meeting_Member where meetingtype ="+mid +" and subcompanyid = "+sid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into Meeting_Member (meetingtype,membertype,subcompanyid,seclevel,seclevelMax,desc_n) values ("+mid+","+membertype+","+sid+","+sublevel+","+sublevelMax+",'"+desc_n+"')"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update Meeting_Member set seclevel = "+sublevel+",seclevelMax="+sublevelMax+",desc_n='"+desc_n+"' where meetingtype="+mid+" and subcompanyid = "+sid   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        } else if("7".equals(membertype)){
        	String roleid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("roleid")),",");
            int rolelevel = Util.getIntValue(request.getParameter("rolelevel"), 0);
            int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            if(roleid.length>0){
                for(String did : roleid){
                    sql = "select meetingtype,departmentid from Meeting_Member where meetingtype ="+mid +" and roleid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into Meeting_Member (meetingtype,membertype,roleid,seclevel,seclevelMax,rolelevel,desc_n) values ("+mid+","+membertype+","+did+","+seclevel+","+seclevelMax+","+rolelevel+",'"+desc_n+"')"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update Meeting_Member set seclevel = "+seclevel+",seclevelMax="+seclevelMax+",rolelevel="+rolelevel+",desc_n='"+desc_n+"' where meetingtype="+mid+" and roleid = "+did   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }else if("8".equals(membertype)){
        	String jobid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("jobid")),",");
            int joblevel = Util.getIntValue(request.getParameter("joblevel"), 0); 
            String joblevelvalue ="";
            if(joblevel==1){
            	joblevelvalue=Util.null2String(request.getParameter("sublevelids"));
            }else if(joblevel==2){
            	joblevelvalue=Util.null2String(request.getParameter("deplevelids"));
            }
            if(jobid.length>0){
                for(String jid : jobid){
                    sql = "select meetingtype,departmentid from Meeting_Member where meetingtype ="+mid +" and jobtitleid = "+jid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next()){
                        sql = " insert into Meeting_Member (meetingtype,membertype,jobtitleid,joblevel,joblevelvalue,desc_n) values ("+mid+","+membertype+","+jid+","+joblevel+",'"+joblevelvalue+"','"+desc_n+"')";
                        flag = RecordSet.executeSql(sql);
                    } else{
                        sql = " update Meeting_Member set joblevel="+joblevel+",joblevelvalue='"+joblevelvalue+"',desc_n='"+desc_n+"' where meetingtype="+mid+" and jobtitleid = "+jid;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }
        SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(mid),"添加参会人","添加会议类型参会人","209","1",0,ip);
        response.sendRedirect("/meeting/Maint/MeetingTypeMbrAdd.jsp?isclose=1&mid="+mid);
		return;

}

//删除会议类型参会人
if(method.equals("mbrDelete")){
	String id = Util.null2String(request.getParameter("mid"));
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		String sql = "delete from Meeting_Member where id in ("+ids+")";
		RecordSet.execute(sql);
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),ids,"删除会议类型参会人","209","3",0,ip);
		return;
	}
	response.sendRedirect("/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id="+id+"&method=member");
	return;
}

//添加会议类型召集人
if(method.equals("cllrAdd")){
	boolean flag = false;
	String mid =   Util.null2String(request.getParameter("mid"));
	String sql = "";
        String callertype= Util.null2String(request.getParameter("callertype"));
        if("1".equals(callertype)){
            String userid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
            if(userid.length>0){
                  for(String uid : userid){
                       sql = "select meetingtype,userid from MeetingCaller where meetingtype ="+mid +" and userid = "+uid ;
                      RecordSet.executeSql(sql)   ;
                      if(!RecordSet.next())                 {
                          sql = " insert into MeetingCaller (meetingtype,callertype,userid) values ("+mid+","+callertype+","+uid+")"   ;
                          RecordSet.executeSql(sql);
                      }
                  }
            }
        } else if("2".equals(callertype)){
            String departmentid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            String deptlevel = Util.null2String(request.getParameter("seclevel"));
            String deptlevelMax = Util.null2String(request.getParameter("seclevelMax"));
            if(departmentid.length>0){
                for(String did : departmentid){
                    sql = "select meetingtype,departmentid from MeetingCaller where meetingtype ="+mid +" and departmentid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingCaller (meetingtype,callertype,departmentid,seclevel,seclevelMax) values ("+mid+","+callertype+","+did+","+deptlevel+","+deptlevelMax+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingCaller set seclevel = "+deptlevel+",seclevelMax="+deptlevelMax+" where meetingtype="+mid+" and departmentid = "+did   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
         } 
         else if("3".equals(callertype)){
        	String roleid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("roleid")),",");
            int rolelevel = Util.getIntValue(request.getParameter("rolelevel"), 0);
            int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            if(roleid.length>0){
                for(String did : roleid){
                    sql = "select meetingtype,departmentid from MeetingCaller where meetingtype ="+mid +" and roleid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingCaller (meetingtype,callertype,roleid,seclevel,seclevelMax,rolelevel) values ("+mid+","+callertype+","+did+","+seclevel+","+seclevelMax+","+rolelevel+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingCaller set seclevel = "+seclevel+",seclevelMax="+seclevelMax+",rolelevel="+rolelevel+" where meetingtype="+mid+" and roleid = "+did   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        } else if("4".equals(callertype)){
            String seclevel = Util.null2String(request.getParameter("seclevel"));
            String seclevelMax = Util.null2String(request.getParameter("seclevelMax"));
            sql = "select meetingtype,permissiontype from MeetingCaller where meetingtype ="+mid +" and callertype="+callertype;
            RecordSet.executeSql(sql);
            if(!RecordSet.next())                 {
                sql = " insert into MeetingCaller (meetingtype,callertype,seclevel,seclevelMax) values ("+mid+","+callertype+","+seclevel+","+seclevelMax+")"   ;
                RecordSet.executeSql(sql);
            }   else{
                sql = " update MeetingCaller set seclevel = "+seclevel+",seclevelMax="+seclevelMax+" where meetingtype="+mid+" and callertype = "+callertype   ;
                RecordSet.executeSql(sql);
            }
        }   else  if("5".equals(callertype)){
            String subcompanyids[]  = Util.TokenizerString2(Util.null2String(request.getParameter("subids")),",");
            String sublevel = Util.null2String(request.getParameter("seclevel"));
            String sublevelMax = Util.null2String(request.getParameter("seclevelMax"));
            if(subcompanyids.length>0){
                for(String sid : subcompanyids){
                    sql = "select meetingtype,subcompanyid from MeetingCaller where meetingtype ="+mid +" and subcompanyid = "+sid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingCaller (meetingtype,callertype,subcompanyid,seclevel,seclevelMax) values ("+mid+","+callertype+","+sid+","+sublevel+","+sublevelMax+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingCaller set seclevel = "+sublevel+",seclevelMax="+sublevelMax+" where meetingtype="+mid+" and subcompanyid = "+sid   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        } else if("8".equals(callertype)){
        	String jobid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("jobid")),",");
            int joblevel = Util.getIntValue(request.getParameter("joblevel"), 0); 
            String joblevelvalue ="";
            if(joblevel==1){
            	joblevelvalue=Util.null2String(request.getParameter("sublevelids"));
            }else if(joblevel==2){
            	joblevelvalue=Util.null2String(request.getParameter("deplevelids"));
            }
            if(jobid.length>0){
                for(String jid : jobid){
                    sql = "select meetingtype,departmentid from MeetingCaller where meetingtype ="+mid +" and jobtitleid = "+jid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next()){
                        sql = " insert into MeetingCaller (meetingtype,callertype,jobtitleid,joblevel,joblevelvalue) values ("+mid+","+callertype+","+jid+","+joblevel+",'"+joblevelvalue+"')";
                        flag = RecordSet.executeSql(sql);
                    } else{
                        sql = " update MeetingCaller set joblevel="+joblevel+",joblevelvalue='"+joblevelvalue+"' where meetingtype="+mid+" and jobtitleid = "+jid;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }
        SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(mid),"添加召集人","添加会议类型召集人","209","1",0,ip);
        response.sendRedirect("/meeting/Maint/MeetingTypeCllrAdd.jsp?isclose=1&mid="+mid);
		return;

}

//删除会议类型召集人
if(method.equals("cllrDelete")){
	String id = Util.null2String(request.getParameter("mid"));
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		String sql = "delete from MeetingCaller where id in ("+ids+")";
		RecordSet.execute(sql);
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),ids,"删除会议类型召集人","209","3",0,ip);
		return;
	}
	response.sendRedirect("/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id="+id+"&method=caller");
	return;
}

//添加会议类型的会议服务
if(method.equals("srvcAdd")){
	String mid = Util.null2String(request.getParameter("mid"));
	String name = Util.null2String(request.getParameter("name"));
	int hrmid = Util.getIntValue(request.getParameter("hrmid"));
	String desc = Util.null2String(request.getParameter("desc"));
	String sql = "insert into Meeting_Service(NAME,MEETINGTYPE,HRMID,DESC_N) values('"+name+"',"+mid+","+hrmid+",'"+desc+"')";
	RecordSet.execute(sql);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(mid),name,"添加会议服务","209","1",0,ip);
	response.sendRedirect("/meeting/Maint/MeetingTypeSrvcAdd.jsp?isclose=1&mid="+mid);
	return;
}

//修改会议类型的会议服务
if(method.equals("srvcEdit")){
	String id = Util.null2String(request.getParameter("id"));
	String mid = Util.null2String(request.getParameter("mid"));
	String name = Util.null2String(request.getParameter("name"));
	int hrmid = Util.getIntValue(request.getParameter("hrmid"));
	String desc = Util.null2String(request.getParameter("desc"));
	String sql = "update Meeting_Service set NAME = '"+name+"', HRMID = "+hrmid +", DESC_N = '"+desc+"' where id ="+id;
	RecordSet.execute(sql);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(mid),name,"修改会议服务","209","2",0,ip);
	response.sendRedirect("/meeting/Maint/MeetingTypeSrvcAdd.jsp?isclose=1&mid="+mid);
	return;
}

//删除会议类型的会议服务
if(method.equals("srvcDelete")){
	String id = Util.null2String(request.getParameter("mid"));
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		String sql = "delete from Meeting_Service where id in ("+ids+")";
		RecordSet.execute(sql);
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),"删除会议服务","删除会议服务","209","3",0,ip);
		return;
	}
	response.sendRedirect("/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id="+id+"&method=service");
	return;
}

%>
