
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"),user.getUserSubCompany1());
int subid = Util.getIntValue(request.getParameter("subid"),user.getUserSubCompany1());
String ip=Util.getIpAddr(request);
	if(!HrmUserVarify.checkUserRight("MeetingRoomAdd:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
//添加会议室
if(method.equals("add"))
{
	String forward = Util.null2String(request.getParameter("forwd"));
	String hrmids=Util.null2String(request.getParameter("hrmids"));
	String roomname=Util.null2String(request.getParameter("roomname"));
	String status=request.getParameter("status");
	status = (status == null||status.equals("")) ? "1" : status;
	String roomdesc=Util.null2String(request.getParameter("roomdesc"));
	String dsporder=Util.getPointValue(request.getParameter("dsporder"), 1, "0");
	String equipment=Util.null2String(request.getParameter("equipment"));
	String images=Util.null2String(request.getParameter("images"));

	String sql = "insert into MeetingRoom(name,subcompanyid,hrmids,roomdesc,equipment,status,dsporder,images)"
		+" values('"+roomname+"',"+subcompanyid+",'"+hrmids+"','"+roomdesc+"','"+equipment+"','"+status+"',"+dsporder+",'"+images+"')";
	RecordSet.execute(sql);
	
	sql = "select id from MeetingRoom where name ='"+roomname+"'";
    RecordSet.execute(sql);
    int id = -1;
    if(RecordSet.next()) {
    	id = RecordSet.getInt("id");
    	if(ManageDetachComInfo.isUseMtiManageDetach()){
	    	sql = " insert into MeetingRoom_share (mid,permissiontype,subcompanyid,sublevel,sublevelMax) values ("+id+","+6+","+subcompanyid+","+0+","+100+")"   ;
    	}else{
    		sql = " insert into MeetingRoom_share (mid,permissiontype,seclevel,seclevelMax) values ("+id+",3,"+0+","+100+")"   ;
    	}
    	RecordSet.executeSql(sql);
    } 
    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,id,roomname,"新增会议室","210","1",0,ip);
	
    MeetingRoomComInfo.removeMeetingRoomInfoCache();
    if("edit".equals(forward)) {
    	if(id != -1) {
    		out.println("<script>wfforward(\"/meeting/Maint/MeetingRoomEditTab.jsp?dialog=1&reloadTb=1&id="+id+"&method=edit&from=add\");</script>");
    	    return ;
    	} 
    } 
	%>
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(window.parent);
		parentWin.location="/meeting/Maint/MeetingRoom_left.jsp?subCompanyId=<%=subcompanyid%>";
		parentWin.closeDlgARfsh();
	</script>
	<%
	return;
}

//编辑会议室
if(method.equals("edit"))
{
	String forward = Util.null2String(request.getParameter("forwd"));
	int mid = Util.getIntValue(request.getParameter("mid"));
	String hrmids=Util.null2String(request.getParameter("hrmids"));
	String roomname=Util.null2String(request.getParameter("roomname"));
	String status=request.getParameter("status");
	status = (status == null||status.equals("")) ? "1" : status;
	String roomdesc=Util.null2String(request.getParameter("roomdesc"));
	String dsporder=Util.getPointValue(request.getParameter("dsporder"), 1, "0");
	String equipment=Util.null2String(request.getParameter("equipment"));
	String images=Util.null2String(request.getParameter("images"));
	
	String sql = "update MeetingRoom set name ='" + roomname + "' "
		+ ", subcompanyid = " + subcompanyid
		+ ", hrmids = '" + hrmids+"'"
		+ ", roomdesc = '" + roomdesc + "' "
		+ ", equipment = '" + equipment + "' "
		+ ", status = '" + status + "' "
		+ ", dsporder = " + dsporder
		+ ", images = '" + images + "' "
		+ " where id = "+mid;
	RecordSet.executeSql(sql);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,mid,roomname,"修改会议室","210","2",0,ip);
    MeetingRoomComInfo.removeMeetingRoomInfoCache();
    
	response.sendRedirect("/meeting/Maint/MeetingRoomEdit.jsp?dialog=1&reloadTb=1&id="+mid+"&method=edit");
	
	return;
}

//删除会议室
if(method.equals("delete"))
{
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		RecordSet.execute("select * from MeetingRoom where id in ("+ids+")");
		while(RecordSet.next()){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("id"),RecordSet.getString("name"),"删除会议室","210","3",0,ip);
		}
		String sql = "delete from MeetingRoom where id in ("+ids+")";
		RecordSet.execute(sql);
		RecordSet.execute( "delete from MeetingRoom_share where mid in ("+ids+")");
		MeetingRoomComInfo.removeMeetingRoomInfoCache();
		
	}
	%>
	<script type="text/javascript">
		window.parent.closeWinAFrsh();
	</script>
	<%
	return;
}
//封存会议室
if(method.equals("lock"))
{
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		RecordSet.execute("select * from MeetingRoom where id in ("+ids+")");
		while(RecordSet.next()){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("id"),RecordSet.getString("name"),"封存会议室","210","10",0,ip);
		}
		String sql = "update MeetingRoom set status = '2' where id in ("+ids+")";
		RecordSet.execute(sql);
		MeetingRoomComInfo.removeMeetingRoomInfoCache();
		return;
	}
}
//解封会议室
if(method.equals("reOpen"))
{
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		RecordSet.execute("select * from MeetingRoom where id in ("+ids+")");
		while(RecordSet.next()){
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.insSysLogInfo(user,RecordSet.getInt("id"),RecordSet.getString("name"),"解封会议室","210","11",0,ip);
		}
		String sql = "update MeetingRoom set status = '1' where id in ("+ids+")";
		RecordSet.execute(sql);
		MeetingRoomComInfo.removeMeetingRoomInfoCache();
		return;
	}
}
//添加会议室共享
if(method.equals("prmAdd")){
	boolean flag = false;
	String mid =   Util.null2String(request.getParameter("mid"));
	RecordSet.execute("select * from MeetingRoom where id = "+mid);
	String name="";
	if(RecordSet.next()){
		name=RecordSet.getString("name");
	}
	String sql = "";
        String permissiontype=Util.null2String(request.getParameter("permissiontype"));
        if("1".equals(permissiontype)){
            String departmentid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            int deptlevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int deptlevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            if(departmentid.length>0){
                for(String did : departmentid){
                    sql = "select mid,departmentid from MeetingRoom_share where mid ="+mid +" and departmentid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingRoom_share (mid,permissiontype,departmentid,deptlevel,deptlevelMax) values ("+mid+","+permissiontype+","+did+","+deptlevel+","+deptlevelMax+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingRoom_share set deptlevel = "+deptlevel+",deptlevelMax="+deptlevelMax+" where mid="+mid+" and departmentid = "+did   ;
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
                    sql = "select mid,roleid from MeetingRoom_share where mid ="+mid +" and roleid = "+did;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingRoom_share (mid,permissiontype,roleid,roleseclevel,roleseclevelMax,rolelevel) values ("+mid+","+permissiontype+","+did+","+seclevel+","+seclevelMax+","+rolelevel+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingRoom_share set roleseclevel = "+seclevel+",roleseclevelMax="+seclevelMax+",rolelevel="+rolelevel+" where mid="+mid+" and roleid = "+did   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }  else if("3".equals(permissiontype)){
            int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            sql = "select mid,permissiontype from MeetingRoom_share where mid ="+mid +" and permissiontype="+permissiontype;
            RecordSet.executeSql(sql);
            if(!RecordSet.next())                 {
                sql = " insert into MeetingRoom_share (mid,permissiontype,seclevel,seclevelMax) values ("+mid+","+permissiontype+","+seclevel+","+seclevelMax+")"   ;
                RecordSet.executeSql(sql);
            }   else{
                sql = " update MeetingRoom_share set seclevel = "+seclevel+",seclevelMax="+seclevelMax+" where mid="+mid+" and permissiontype = "+permissiontype   ;
                RecordSet.executeSql(sql);
            }
        }   else if("5".equals(permissiontype)){
            String userid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
            if(userid.length>0){
                  for(String uid : userid){
                       sql = "select mid,userid from MeetingRoom_share where mid ="+mid +" and userid = "+uid ;
                      RecordSet.executeSql(sql)   ;
                      if(!RecordSet.next())                 {
                          sql = " insert into MeetingRoom_share (mid,permissiontype,userid) values ("+mid+","+permissiontype+","+uid+")"   ;
                          RecordSet.executeSql(sql);
                      }
                  }
            }
        } else if("6".equals(permissiontype)){
            String subcompanyids[]  = Util.TokenizerString2(Util.null2String(request.getParameter("subids")),",");
            int sublevel = Util.getIntValue(request.getParameter("seclevel"), 0); 
            int sublevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 100);
            if(subcompanyids.length>0){
                for(String sid : subcompanyids){
                    sql = "select mid,subcompanyid from MeetingRoom_share where mid ="+mid +" and subcompanyid = "+sid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into MeetingRoom_share (mid,permissiontype,subcompanyid,sublevel,sublevelMax) values ("+mid+","+permissiontype+","+sid+","+sublevel+","+sublevelMax+")"   ;
                        flag = RecordSet.executeSql(sql);
                    }   else{
                        sql = " update MeetingRoom_share set sublevel = "+sublevel+",sublevelMax="+sublevelMax+" where mid="+mid+" and subcompanyid = "+sid   ;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }else if("8".equals(permissiontype)){
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
                	sql = "select mtid from MeetingRoom_share where mid ="+mid +" and jobtitleid = "+jid;
                	 RecordSet.executeSql(sql);
                    if(!RecordSet.next()){
                    	sql = " insert into MeetingRoom_share (mid,permissiontype,jobtitleid,joblevel,joblevelvalue) values ("+mid+","+permissiontype+","+jid+","+joblevel+",'"+joblevelvalue+"')";
                        flag = RecordSet.executeSql(sql);
                    } else{
                    	sql = " update MeetingRoom_share set joblevel = "+joblevel+",joblevelvalue="+joblevelvalue+" where mid="+mid+" and jobtitleid = "+jid;
                        RecordSet.executeSql(sql);
                    }
                }
            }
        }
        SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(mid),name,"添加会议室共享","210","1",0,ip);
	
        response.sendRedirect("/meeting/Maint/MeetingRoomPrmsnAdd.jsp?isclose=1&mid="+mid);
		return;

}
//删除会议室共享
if(method.equals("prmDelete")){
	String id = Util.null2String(request.getParameter("mid"));
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	if(!"".equals(ids)){
		String sql = "delete from MeetingRoom_share where id in ("+ids+")";
		RecordSet.execute(sql);
		
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),ids,"删除会议室共享","210","3",0,ip);
		return;
	}
	response.sendRedirect("/meeting/Maint/MeetingRoomEdit.jsp?dialog=1&id="+id+"&method=shangeShare");
	return;
}

if(method.equals("deleteimg")){
	String imgid = Util.null2String(request.getParameter("imgid"));
	String sql = "select * from MeetingRoom where id in ("+imgid+")";
	RecordSet.execute(sql);
	return;
}

%>
