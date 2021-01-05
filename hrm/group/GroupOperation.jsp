<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.hrm.common.Tools"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"1")+"}");//对不起，您暂时没有权限！
	out.flush();
	return;
}else{
	/*
	String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
	if(!HrmUserVarify.checkUserRight("CustomGroup:Edit", user)&&!operation.equals("savesuggest")) {
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"2")+"}");//对不起，您暂时没有权限！
		out.flush();
		return;
	}*/
}
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int groupid = Util.getIntValue(request.getParameter("groupid"));
int ownerid = Util.getIntValue(request.getParameter("ownerid"));
String isdialog = Util.null2String(request.getParameter("isdialog"));
String istree = Util.null2String(request.getParameter("istree"));

String name = Util.null2String(request.getParameter("name"));
String type = Util.null2String(request.getParameter("type"));
String sn = Util.null2String(request.getParameter("sn"));
String hrmids = Util.null2String(request.getParameter("hrmids"));
String savetype = Util.null2String(request.getParameter("savetype"));

int uid=user.getUID();
/*权限判断--Begin*/  
boolean cansave=HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
/*权限判断--End*/  
if(operation.equals("addgroup")){
	if(ownerid!=uid&&!cansave){
		response.sendRedirect("/notice/noright.jsp");
    	return;
}
        int flag=0;
        boolean isAdd = false;
        if(groupid==-1){
        	flag=GroupAction.create(name,type,uid,hrmids,sn);
        	String sql = "select id from HrmGroup where name='" + name + "' and type=" + type + " and owner=" + uid;
        	RecordSet.executeSql(sql);
        	if(RecordSet.next()){
        		groupid = RecordSet.getInt("id");
        	}
        	isAdd = true;
        }else
        flag=GroupAction.update(groupid,name,type,uid,hrmids,sn);
	
        if(flag==-1){
        request.getRequestDispatcher("/hrm/group/HrmGroupAdd.jsp?isclose=1&msgid=12").forward(request,response);
        return;
        }
        session.removeAttribute("grouplist");
 			response.sendRedirect("/hrm/group/HrmGroupAdd.jsp?groupid="+groupid+"&isdialog="+isdialog+"&isclose=1"+(isAdd?"&isAdd=1":""));
 }else if(operation.equals("addgroupbase")){
	if(ownerid!=uid&&!cansave){
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}
        int flag=0;
        boolean isAdd = false;
        if(groupid==-1){
        	flag=GroupAction.createBase(name,type,uid,hrmids,sn);
        	String sql = "select id from HrmGroup where name='" + name + "' and type=" + type + " and owner=" + uid;
        	RecordSet.executeSql(sql);
        	if(RecordSet.next()){
        		groupid = RecordSet.getInt("id");
        	}
        	isAdd = true;
        }else
        flag=GroupAction.updateBase(groupid,name,type,uid,hrmids,sn);
	
        if(flag==-1){
        request.getRequestDispatcher("/hrm/group/HrmGroupBaseAdd.jsp?isclose=1&msgid=12").forward(request,response);
        return;
        }
        session.removeAttribute("grouplist");
        if("1".equals(savetype)){
			response.sendRedirect("/hrm/group/HrmGroupBaseAdd.jsp?groupid="+groupid+"&isdialog="+isdialog+"&isclose=1&isDetail=1"+(isAdd?"&isAdd=1":"")+"&istree="+istree);
        }else{
			response.sendRedirect("/hrm/group/HrmGroupBaseAdd.jsp?groupid="+groupid+"&isdialog="+isdialog+"&isclose=1"+(isAdd?"&isAdd=1":"")+"&istree="+istree);
        }
 }else if(operation.equals("deletegroup")){
		//1、就是私人组自己能新建、自己能删除。
		//2、公共组 有组维护权限的人员：可以新建、编辑公共组，也可以删除 但是只能删除自己新建的公共组
		
		//私人组
		if("0".equals(type)){
			if(ownerid!=uid){
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		}
		//公共组
		if("1".equals(type)){
			if((user.getUID() != 1 || ownerid!=uid)&&!cansave){
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		}
        GroupAction.delete(groupid);
        session.removeAttribute("grouplist");
        response.sendRedirect("/hrm/group/HrmGroup.jsp");
 }else if(operation.equals("editgroup")){
	if(ownerid!=uid&&!cansave){
		response.sendRedirect("/notice/noright.jsp");
    	return;
}
        //session.removeAttribute("grouplist");
        request.getRequestDispatcher("/hrm/group/HrmGroupAdd.jsp").forward(request,response);
 }else if(operation.equals("savesuggest")){
		//保存建议
		int id = -1;
		String suggesttitle = Util.null2String(request.getParameter("suggesttitle"));
		String suggesttype = Util.null2String(request.getParameter("suggesttype"));
		String content = Util.null2String(request.getParameter("content"));
		String today = Tools.getCurrentDate();
		String sql = "";
		
		sql = " insert into HrmGroupSuggest  ( suggesttitle ,groupid ,suggesttype ,content ,STATUS ,creater ,createdate) "
				+ " VALUES  ( '"+suggesttitle+"' ,"+groupid+" ,"+suggesttype+" ,'"+content+"' , 0 ,"+user.getUID()+" , '"+today+"' )";
		RecordSet.executeSql(sql);
		
		RecordSet.executeSql("select max(id) from HrmGroupSuggest");
		if(RecordSet.next()){
			id = RecordSet.getInt(1);
		}

		//获得要通知的人
		List<String> lsReceiver = new ArrayList<String>();
		lsReceiver.add("1");//通知sysadmin
		sql = " SELECT DISTINCT resourceid FROM SystemRightDetail a, SystemRightRoles b, HrmRoleMembers c, HrmResource d "
				+ " WHERE a.rightid=b.rightid AND b.roleid = c.roleid AND c.resourceid =d.id AND d.subcompanyid1='"+user.getUserSubCompany1()+"' and a.rightdetail='CustomGroup:Edit' ";
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			lsReceiver.add(RecordSet.getString("resourceid"));
		}
		
		for(String receiver:lsReceiver){
			PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue(receiver),25,"0",id);
		}
	 	response.sendRedirect("HrmGroupSuggest.jsp?groupid="+groupid+"&isclose=1");
   return;
	}else if(operation.equals("addsuggest")){
		//增加建议成员
		String id = Util.null2String(request.getParameter("id")); 
		String members = "";
		int status = 0;
		RecordSet.executeSql("select groupid, content, status from HrmGroupSuggest where id = "+id);
		if(RecordSet.next()){
			groupid = RecordSet.getInt("groupid");
			members = Util.null2String(RecordSet.getString("content"));
			status = RecordSet.getInt("status");
		}
		if(status==1){//防止重复执行
			response.sendRedirect("/hrm/group/HrmGroupRemindList.jsp");
			return;
		}
		String[] arrmembers = members.split(",");
		for(int i=0;arrmembers!=null&&i<arrmembers.length;i++){
			if(Util.null2String(arrmembers[i]).length()==0)continue;
			String usertype = Util.null2String(ResourceComInfo.getResourcetype(arrmembers[i]));
			if(usertype.length()==0)usertype="NULL";
			//检查是否已存在该用户，如果已存在，不再新增数据
			String sql = " select count(1) from HrmGroupMembers where groupid="+groupid+" and userid= "+arrmembers[i];
			RecordSet.executeSql(sql);
			if(RecordSet.next()){
				if(RecordSet.getInt(1)>=1){
					continue;
				}
			}
		 	sql = " INSERT INTO HrmGroupMembers(groupid,userid,usertype,dsporder) " +
									" VALUES  ( "+groupid+","+arrmembers[i]+" , "+usertype+","+(i+1)+") ";
		 	RecordSet.executeSql(sql);
		}
		RecordSet.executeSql("update HrmGroupSuggest set status = 1 where id = "+id);
		//清理已处理的提醒
		String sql=" delete from SysPoppupRemindInfoNew where type=25 and " +
							 " (exists(select t2.id from HrmGroupSuggest t2 where t2.id=SysPoppupRemindInfoNew.requestid and status=1 )"+
							 " or requestid not in (select id from HrmGroupSuggest)) ";
		RecordSet.executeSql(sql);
   	response.sendRedirect("/hrm/group/HrmGroupRemindList.jsp");
   	return;
	}else if(operation.equals("delsuggest")){
		//删除建议成员
		String id = Util.null2String(request.getParameter("id")); 
		String members = "";
		int status =0;
		RecordSet.executeSql("select groupid,content from HrmGroupSuggest where id = "+id);
		if(RecordSet.next()){
			groupid = RecordSet.getInt("groupid");
			members = Util.null2String(RecordSet.getString("content"));
			status = RecordSet.getInt("status");
		}
		if(status==1){//防止重复执行
			response.sendRedirect("/hrm/group/HrmGroupRemindList.jsp");
			return;
		}
		String[] arrmembers = members.split(",");
		for(int i=0;arrmembers!=null&&i<arrmembers.length;i++){
			if(Util.null2String(arrmembers[i]).length()==0)continue;
		 	String sql = " delete from HrmGroupMembers where groupid= "+groupid+" and userid = "+arrmembers[i];
		 	RecordSet.executeSql(sql);
		}
		RecordSet.executeSql("update HrmGroupSuggest set status = 1 where id = "+id);
		//清理已处理的提醒
		String sql=" delete from SysPoppupRemindInfoNew where type=25 and " +
							 " (exists(select t2.id from HrmGroupSuggest t2 where t2.id=SysPoppupRemindInfoNew.requestid and status=1 )"+
							 " or requestid not in (select id from HrmGroupSuggest)) ";
		RecordSet.executeSql(sql);
	  response.sendRedirect("/hrm/group/HrmGroupRemindList.jsp");
	  return;
	}else if(operation.equals("getmsginfo")){
		String id = Util.null2String(request.getParameter("id"));
		String groupname = "";
		String members = "";
		RecordSet.executeSql("select a.groupid,b.name,content from HrmGroupSuggest a, hrmgroup b where a.groupid = b.id and a.id = "+id);
		if(RecordSet.next()){
			groupname = RecordSet.getString("name");
			members = ResourceComInfo.getMulResourcename(Util.null2String(RecordSet.getString("content")));
		}
		out.println("{\"groupname\":"+JSONObject.quote(groupname)+",\"members\":"+JSONObject.quote(members)+"}");
		return;
	}else if(operation.equals("changesuggeststatus")){
		String id = Util.null2String(request.getParameter("id")); 
		RecordSet.executeSql("update HrmGroupSuggest set status = 1 where id = "+id);
		//清理已处理的提醒
		String sql=" delete from SysPoppupRemindInfoNew where type=25 and " +
							 " (exists(select t2.id from HrmGroupSuggest t2 where t2.id=SysPoppupRemindInfoNew.requestid and status=1 )"+
							 " or requestid not in (select id from HrmGroupSuggest)) ";
		RecordSet.executeSql(sql);
		out.println("{\"flag\":true}");
   return;
	}

%>
