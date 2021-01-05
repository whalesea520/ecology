
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.crm.Maint.SectorInfoComInfo"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%@ page import="net.sf.json.JSONObject" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String parentid = Util.null2String(request.getParameter("parentid"));
parentid=parentid.equals("")?"0":parentid;

String sectors = "";

StringBuffer treeStr = new StringBuffer();
treeStr.append("[");
RecordSet rs1=new RecordSet();
StringBuffer sbf = null;
if(method.equals("getTreeJson"))
{
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	if(parentid.equals("")) parentid="0";
	RecordSet.executeProc("CRM_SectorInfo_SelectAll",parentid);
	
	if(RecordSet.getFlag()!= 1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
	}else
	{
		while(RecordSet.next())
		{
			JSONObject json = new JSONObject ();
			int _id = RecordSet.getInt("id");
			String _fullname = RecordSet.getString("fullname");
			String _description = RecordSet.getString("description");
			int _parentid = RecordSet.getInt("parentid");
			int _seclevel = RecordSet.getInt("seclevel");
			String _sectors = RecordSet.getString("sectors");
			json.put("id",_id);
			json.put("name",_fullname);
			json.put("parentId",_parentid);
			json.put("isParent",true);
			
			json.put("description",_description);
			json.put("seclevel",_seclevel);
			json.put("sectors",_sectors);
			rs1.executeSql(" select count(0) c from CRM_SectorInfo where parentid="+_id);
			if(rs1.next()&&rs1.getInt("c")>0);
			else
				json.put("isParent",false);
			treeStr.append(json.toString());
		    treeStr.append(",");
		}
		
		String treeJson = treeStr.toString().substring(0,treeStr.toString().length()-1)+"]";
		out.clear();
		out.print(treeJson);
	}
}
else if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddSectorInfo:add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = RecordSet.executeProc("CRM_SectorInfo_Insert",name+flag+desc+flag+parentid+flag+"0"+flag+sectors);

	int cid = 0;
	if(insertSuccess)
	{
		RecordSet.executeSql("Select Max(id) as maxid FROM CRM_SectorInfo");
	    RecordSet.next();
	    cid = RecordSet.getInt("maxid");
	    RecordSet.execute("update CRM_SectorInfo set orderkey='"+cid+"' where id='"+cid+"'");
	}
	SysMaintenanceLog.insSysLogInfo(user,cid,name,"CRM_SectorInfo_Insert,"+name+flag+desc+flag+parentid+flag+"0"+flag+sectors,
			"215","1",0,request.getRemoteAddr());
	SectorInfoComInfo.removeSectorInfoCache();
	SectorInfoComInfo sec = new SectorInfoComInfo();
	sectors = sec.getSectorFullParentid(cid+"");
	
	response.sendRedirect("/CRM/Maint/AddSectorInfo.jsp?isclose=1&sectors="+sectors);
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditSectorInfo:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_SectorInfo_Update",id+flag+name+flag+desc+flag+parentid+flag+"0"+flag+sectors);
	
	SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),name,"CRM_SectorInfo_Update,"+id+flag+name+flag+desc+flag+parentid+flag+"0"+flag+sectors,
			"215","2",0,request.getRemoteAddr());
	
	sectors = SectorInfoComInfo.getSectorFullParentid(id+"");
	SectorInfoComInfo.removeSectorInfoCache();
	response.sendRedirect("/CRM/Maint/EditSectorInfo.jsp?isclose=1&sectors="+sectors);
}
else if (method.equals("delete"))
{
	if(!HrmUserVarify.checkUserRight("EditSectorInfo:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	RecordSet.execute("select fullname from CRM_SectorInfo where id = "+id);
	if(RecordSet.next()){
		name = RecordSet.getString("fullname");
	}
	//RecordSet.executeProc("CRM_SectorInfo_Delete",id);

	// added by lupeng 2004-08-07 for TD761. //Modified by xwj on 2005-03-19 for td1548
	String sql="SELECT id FROM CRM_SectorInfo WHERE sectors LIKE '%,"+id+",%'";
	RecordSet.execute(sql);
	if (RecordSet.next()) {
		out.println(SystemEnv.getErrorMsgName(50,user.getLanguage()));
		return;
	}
	sql="SELECT id FROM CRM_CustomerInfo WHERE sector ='"+id+"' and deleted=0";
	RecordSet.execute(sql);
	if (RecordSet.next()) {
		out.println(SystemEnv.getErrorMsgName(49,user.getLanguage()));
		return;
	}
	
	sql="delete FROM CRM_SectorInfo WHERE id="+id;
	RecordSet.execute(sql);
	
	// end.
	SysMaintenanceLog.insSysLogInfo(user,Util.getIntValue(id),name,"CRM_SectorInfo_Delete,"+id,
			"215","3",0,request.getRemoteAddr());
	
	SectorInfoComInfo.removeSectorInfoCache();
	out.println("");
	return;
}else if(method.equals("sort"))
{
	if(!HrmUserVarify.checkUserRight("EditSectorInfo:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	RecordSetTrans.setAutoCommit(false);
	String[] menushowids = Util.TokenizerString2(Util.null2String(request.getParameter("menushowids")),"^,^");
	for(int i=0;i<menushowids.length;i++){
		if(!menushowids[i].equals(""))
		{
			String[] ids = Util.TokenizerString2(menushowids[i],"||");
			String __id = ids[0];
			String __parentid = ids[1];
			String setsectors = "";
			
			if(__parentid.equals("0"))
			{
				setsectors = " ,sectors='' ";
			}else{
				
				RecordSetTrans.executeSql(" select id, sectors from CRM_SectorInfo where id="+__parentid);
				RecordSetTrans.first();
				if(RecordSetTrans.getString(2).equals(""))
				{
					setsectors = ",";
				}
				else
				{
					setsectors = RecordSetTrans.getString(2);
				}
				setsectors += RecordSetTrans.getString(1) +",";
				setsectors = " ,sectors='"+setsectors + "' ";
			}
			RecordSetTrans.executeSql(" update CRM_SectorInfo set orderkey='"+i+"',parentid='"+__parentid+"' "+setsectors+" where id="+__id);
			//RecordSetTrans.executeProc("CRM_SectorInfo_SelectByID",__parentid);
			
		}
	}
	RecordSetTrans.commit();
	//response.sendRedirect("SystemMenuMaintList.jsp?type="+type+"&resourceType="+resourceType+"&resourceId="+resourceId+"&" + new Date().getTime() + "=" + new Date().getTime());
	out.print("OK");
}else if(method.equals("getSectorName")){
	out.println(SectorInfoComInfo.getSectorFullParentName(id));
	return;
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>