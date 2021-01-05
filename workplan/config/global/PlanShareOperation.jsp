
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.splitepage.transform.SptmForWorkPlan"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSets" class="weaver.conn.RecordSet" scope="page" />
 
<%!
private void writeWorkplanShareLog(RecordSet rs,String operateType,String ip,User user){
	SysMaintenanceLog syslog=new SysMaintenanceLog();
	int id=0;
	String planType;
	String planTypeName;
	String sharetype;
	String seclevel;
	String rolelevel;
	String sharelevel;
	String userid;
	String subcompanyid;
	String departmentid;
	String roleid;
	String ssharetype;
	String sseclevel;
	String srolelevel;
	String suserid;
	String ssubcompanyid;
	String sdepartmentid;
	String sroleid;
    String seclevelMax;
    String sseclevelMax;

    SptmForWorkPlan sptmForWorkPlan=new SptmForWorkPlan();
    String descTemp=("4".equals(operateType)?"删除 ":"添加 ")+"[srcLevel][srcObj]的[planType]日程,共享给[toLevel][toObj][shareLevel]权限";
    String tempStr="";
    String and="+";
    int count=0;
    try{
		while(rs.next()){
			if("1".equals(operateType)&&count>0){
				continue;
			}
			count++;
		    String desc=descTemp;
			id=rs.getInt("id");
			planType=Util.null2String(rs.getString("planid"));
			planTypeName=Util.null2String(rs.getString("workPlanTypeName"));
			sharetype=Util.null2String(rs.getString("sharetype"));
			seclevel=Util.null2String(rs.getString("seclevel"));
			rolelevel=Util.null2String(rs.getString("rolelevel"));
			sharelevel=Util.null2String(rs.getString("sharelevel"));
			userid=Util.null2o(rs.getString("userid"));
			subcompanyid=Util.null2o(rs.getString("subcompanyid"));
			departmentid=Util.null2o(rs.getString("departmentid"));
			roleid=Util.null2o(rs.getString("roleid"));
			ssharetype=Util.null2String(rs.getString("ssharetype"));
			sseclevel=Util.null2String(rs.getString("sseclevel"));
			srolelevel=Util.null2String(rs.getString("srolelevel"));
			suserid=Util.null2o(rs.getString("suserid"));
			ssubcompanyid=Util.null2o(rs.getString("ssubcompanyid"));
			sdepartmentid=Util.null2o(rs.getString("sdepartmentid"));
			sroleid=Util.null2o(rs.getString("sroleid"));
		    seclevelMax=Util.null2String(rs.getString("seclevelMax"));
		    sseclevelMax=Util.null2String(rs.getString("sseclevelMax"));
			
		    tempStr=sptmForWorkPlan.getSeclevel(sseclevel,sseclevelMax+and+ssharetype);
		    if("".equals(tempStr)){
		    	desc=desc.replace("[srcLevel]","");
		    }else{
		    	desc=desc.replace("[srcLevel]","安全级别为["+tempStr+"]的");
		    }
		    
		    if("5".equals(ssharetype)){//所有人
		    	desc=desc.replace("[srcObj]","所有人");
		    }else{
		    	tempStr=sptmForWorkPlan.getWorkPlanShareTypes(ssharetype,"7")+":"
		    		+getWorkPlanShareTypeDesc(ssharetype,suserid+and+ssubcompanyid+and+sdepartmentid+and+sroleid+and+srolelevel+and+"7");
		    	desc=desc.replace("[srcObj]",tempStr);
		    }
		    tempStr=sptmForWorkPlan.getWorkPlanTypeNew(planTypeName,planType+and+"7");
		    desc=desc.replace("[planType]",tempStr);
		    
		    tempStr=sptmForWorkPlan.getSeclevel(seclevel,seclevelMax+and+sharetype);
		    if("".equals(tempStr)){
		    	desc=desc.replace("[toLevel]","");
		    }else{
		    	desc=desc.replace("[toLevel]","安全级别为["+tempStr+"]的" );
		    }
		    
		    if("5".equals(ssharetype)){//所有人
		    	desc=desc.replace("[toObj]","所有人");
		    }else if("6".equals(ssharetype)){//所有上级
		    	desc=desc.replace("[toObj]","所有上级");
		    }else{
		    	tempStr=sptmForWorkPlan.getWorkPlanShareTypes(sharetype,"7")+":"
		    		+getWorkPlanShareTypeDesc(sharetype,userid+and+subcompanyid+and+departmentid+and+roleid+and+rolelevel+and+"7");
		    	desc=desc.replace("[toObj]",tempStr);
		    }
		    
		    tempStr=sptmForWorkPlan.getWorkPlanShareLevelDesc(sharelevel,"7");
		    desc=desc.replace("[shareLevel]",tempStr);
		    
			syslog.resetParameter();
			syslog.insSysLogInfo(user,id,"日程共享设置",desc,"212",operateType,0,ip);
		}
	}catch(Exception e){
    	e.printStackTrace();
    }
}

private String getWorkPlanShareTypeDesc(String sharetypes, String others) throws Exception{
	String rtnStr="";
	RolesComInfo rolesComInfo = new RolesComInfo();
	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	int ssharetype=Util.getIntValue(sharetypes);
	List parameterList = Util.TokenizerString(others, "+");
	String suerid=parameterList.get(0).toString();
	String checkBranchId=parameterList.get(1).toString();
	String checkDeptId=parameterList.get(2).toString();
	String SROLEID=parameterList.get(3).toString();
	int SROLELEVEL=Util.getIntValue(parameterList.get(4).toString(), -1);
	int languageId=Util.getIntValue(parameterList.get(5).toString(), 7);
	switch (ssharetype)
	{case 1:   //多人员
		  if (!suerid.equals("")) {
		  String hrmName="";
		  ArrayList hrmIda=Util.TokenizerString(suerid,",");
		  for (int k=0;k<hrmIda.size();k++)
		  {
		  hrmName+=resourceComInfo.getResourcename(""+hrmIda.get(k))+" ";
		  }
		  rtnStr = hrmName;
          }
		break;
	case 2:    //多分部
		if (!checkBranchId.equals("")) {
		  String branchName="";
		  ArrayList branchIda=Util.TokenizerString(checkBranchId,",");
		  for (int i=0;i<branchIda.size();i++)
		  {
		  branchName+=subCompanyComInfo.getSubCompanyname(""+branchIda.get(i))+" ";	 
		  }
		  rtnStr = branchName;
          }
		break;
	case 3:     //多部门
		 if (!checkDeptId.equals("")) {
		  String deptName="";
		  ArrayList deptIda=Util.TokenizerString(checkDeptId,",");
		  for (int i=0;i<deptIda.size();i++)
		  {
		  deptName+=departmentComInfo.getDepartmentname(""+deptIda.get(i))+" ";
		  }
		  rtnStr = deptName;
		 }
		break;
	case 4:     //角色
        String SROLELEVELName="";
		if (SROLELEVEL==0) SROLELEVELName=SystemEnv.getHtmlLabelName(124,languageId);
		if (SROLELEVEL==1) SROLELEVELName=SystemEnv.getHtmlLabelName(141,languageId);
		if (SROLELEVEL==2) SROLELEVELName=SystemEnv.getHtmlLabelName(140,languageId);
		rtnStr = rolesComInfo.getRolesname(SROLEID)+"/"+SROLELEVELName ;
		break;
	case 5:     //所有人
		
	case 6:     //所有人
		rtnStr = "";
        break;
	}
	return rtnStr;
}
%>
<%
 
char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String settype=Util.null2String(request.getParameter("types"));   //个人设置还是系统设置
String method = Util.null2String(request.getParameter("method"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));  //共享对象
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
int seclevel = Util.getIntValue(request.getParameter("seclevel"), 0);
int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax"), 255);
String sharelevel = Util.null2String(request.getParameter("sharelevel")); //共享级别 0：查看 1：编辑


String srelatedshareid = Util.null2String(request.getParameter("relatedshareided")); //被共享对象
String ssharetype = Util.null2String(request.getParameter("sharetyped")); 
String srolelevel = Util.null2String(request.getParameter("roleleveled")); 
int sseclevel = Util.getIntValue(request.getParameter("secleveled"), 0);
int sseclevelMax = Util.getIntValue(request.getParameter("seclevelMaxd"), 255);

String planType= Util.null2String(request.getParameter("planType")); //共享日程类型

String companyVirtual= Util.null2String(request.getParameter("companyVirtual")); //维度

String userid = "" ;
String departmentid = "" ;
String subcompanyid="";
String roleid = "0" ;
String foralluser = "" ;

String suserid = "" ;
String sdepartmentid = "" ;
String ssubcompanyid="";
String sroleid = "0" ;
String sforalluser = "" ;
String sforallmanager="";
String jobtitleid=Util.null2String(request.getParameter("jobided")); 
String sjobtitleid=Util.null2String(request.getParameter("jobid")); 
int joblevel=Util.getIntValue(request.getParameter("jobleveled")); 
String joblevelvalue=""; 
int sjoblevel=Util.getIntValue(request.getParameter("joblevel")); 
String sjoblevelvalue=""; 
%>
<%  if (settype.equals("0")) {
	if(!HrmUserVarify.checkUserRight("SHARERIGHT:WORKPLAN", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }	
}
%>
<%
if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;
if(sharetype.equals("6")) foralluser = "" ;
if(sharetype.equals("8")){
    if(joblevel==1){
    	joblevelvalue=Util.null2String(request.getParameter("sublevelidsd"));
    }else if(joblevel==2){
    	joblevelvalue=Util.null2String(request.getParameter("deplevelidsd"));
    }
}
if (settype.equals("0"))
{
if(ssharetype.equals("1")) suserid = srelatedshareid ;
if(ssharetype.equals("2")) ssubcompanyid = srelatedshareid ;
if(ssharetype.equals("3")) sdepartmentid = srelatedshareid ;
if(ssharetype.equals("4")) sroleid = srelatedshareid ;
if(ssharetype.equals("5")) sforalluser = "1" ;
 if(ssharetype.equals("6")) sforallmanager = "" ;
 
 if(ssharetype.equals("8")){
	    if(sjoblevel==1){
	    	sjoblevelvalue=Util.null2String(request.getParameter("sublevelids"));
	    }else if(sjoblevel==2){
	    	sjoblevelvalue=Util.null2String(request.getParameter("deplevelids"));
	    }
	}
}
else
{
ssharetype="1";
suserid=""+user.getUID();
}
if(method.equals("delete"))
{
	RecordSet.execute("select workPlanType.workPlanTypename, WorkPlanShareSet.* from WorkPlanShareSet left join workPlanType on WorkPlanShareSet.planid=workPlanType.workPlanTypeID where id in ("+id+")");
	writeWorkplanShareLog(RecordSet,"4",Util.getIpAddr(request),user);
	RecordSet.execute("delete from WorkPlanShareSet where id in ("+id+")");
    //response.sendRedirect("WorkPlanShareSet.jsp");
}


else if(method.equals("add"))
{
	if("1".equals(settype)){
		if("1".equals(sharetype)){
			String userIds[]  = Util.TokenizerString2(userid,",");
		    if(userIds.length>0){
                for(String uid : userIds){
                	 String sql="insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid, departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype,seclevelMax,sseclevelMax,jobtitleid,joblevel,joblevelvalue,sjobtitleid,sjoblevel,sjoblevelvalue,companyVirtual) values ('"+planType+"','"+sharetype+"','"+""+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+uid+"','"+subcompanyid+"','"+departmentid+"','"+roleid+"','"+foralluser+"','"+ssharetype+"', '"+sseclevel+"','"+srolelevel+"','"+suserid+"','"+ssubcompanyid+"','"+sdepartmentid+"','"+sroleid+"','"+sforalluser+"','"+settype+"','"+""+seclevelMax+"','"+""+sseclevelMax+"','"+jobtitleid+"','"+joblevel+"','"+joblevelvalue+"','"+sjobtitleid+"','"+sjoblevel+"','"+sjoblevelvalue+"','"+companyVirtual+"')";
                 	RecordSet.executeSql(sql);
                }
		    }
		}else if("2".equals(sharetype)){
			String subids[]  = Util.TokenizerString2(subcompanyid,",");
		    if(subids.length>0){
                for(String subid : subids){
                	 String sql="insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid, departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype,seclevelMax,sseclevelMax,jobtitleid,joblevel,joblevelvalue,sjobtitleid,sjoblevel,sjoblevelvalue,companyVirtual) values ('"+planType+"','"+sharetype+"','"+""+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+userid+"','"+subid+"','"+departmentid+"','"+roleid+"','"+foralluser+"','"+ssharetype+"', '"+sseclevel+"','"+srolelevel+"','"+suserid+"','"+ssubcompanyid+"','"+sdepartmentid+"','"+sroleid+"','"+sforalluser+"','"+settype+"','"+""+seclevelMax+"','"+""+sseclevelMax+"','"+jobtitleid+"','"+joblevel+"','"+joblevelvalue+"','"+sjobtitleid+"','"+sjoblevel+"','"+sjoblevelvalue+"','"+companyVirtual+"')";
                 	RecordSet.executeSql(sql);
                }
		    }
		}else if("3".equals(sharetype)){
			String departmentids[]  = Util.TokenizerString2(departmentid,",");
		    if(departmentids.length>0){
                for(String depid : departmentids){
                	 String sql="insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid, departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype,seclevelMax,sseclevelMax,jobtitleid,joblevel,joblevelvalue,sjobtitleid,sjoblevel,sjoblevelvalue,companyVirtual) values ('"+planType+"','"+sharetype+"','"+""+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+userid+"','"+subcompanyid+"','"+depid+"','"+roleid+"','"+foralluser+"','"+ssharetype+"', '"+sseclevel+"','"+srolelevel+"','"+suserid+"','"+ssubcompanyid+"','"+sdepartmentid+"','"+sroleid+"','"+sforalluser+"','"+settype+"','"+""+seclevelMax+"','"+""+sseclevelMax+"','"+jobtitleid+"','"+joblevel+"','"+joblevelvalue+"','"+sjobtitleid+"','"+sjoblevel+"','"+sjoblevelvalue+"','"+companyVirtual+"')";
                 	RecordSet.executeSql(sql);
                }
		    }
		}else if("8".equals(sharetype)){
			String jobtitleids[]  = Util.TokenizerString2(jobtitleid,",");
		    if(jobtitleids.length>0){
                for(String jobid : jobtitleids){
                	 String sql="insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid, departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype,seclevelMax,sseclevelMax,jobtitleid,joblevel,joblevelvalue,sjobtitleid,sjoblevel,sjoblevelvalue,companyVirtual) values ('"+planType+"','"+sharetype+"','"+""+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+userid+"','"+subcompanyid+"','"+departmentid+"','"+roleid+"','"+foralluser+"','"+ssharetype+"', '"+sseclevel+"','"+srolelevel+"','"+suserid+"','"+ssubcompanyid+"','"+sdepartmentid+"','"+sroleid+"','"+sforalluser+"','"+settype+"','"+""+seclevelMax+"','"+""+sseclevelMax+"','"+jobid+"','"+joblevel+"','"+joblevelvalue+"','"+sjobtitleid+"','"+sjoblevel+"','"+sjoblevelvalue+"','"+companyVirtual+"')";
                 	RecordSet.executeSql(sql);
                }
		    }
		}else{
			 String sql="insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid, departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype,seclevelMax,sseclevelMax,jobtitleid,joblevel,joblevelvalue,sjobtitleid,sjoblevel,sjoblevelvalue,companyVirtual) values ('"+planType+"','"+sharetype+"','"+""+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+userid+"','"+subcompanyid+"','"+departmentid+"','"+roleid+"','"+foralluser+"','"+ssharetype+"', '"+sseclevel+"','"+srolelevel+"','"+suserid+"','"+ssubcompanyid+"','"+sdepartmentid+"','"+sroleid+"','"+sforalluser+"','"+settype+"','"+""+seclevelMax+"','"+""+sseclevelMax+"','"+jobtitleid+"','"+joblevel+"','"+joblevelvalue+"','"+sjobtitleid+"','"+sjoblevel+"','"+sjoblevelvalue+"','"+companyVirtual+"')";
		    	RecordSet.executeSql(sql);
		}
	}else{
    String sql="insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid, departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype,seclevelMax,sseclevelMax,jobtitleid,joblevel,joblevelvalue,sjobtitleid,sjoblevel,sjoblevelvalue,companyVirtual) values ('"+planType+"','"+sharetype+"','"+""+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+userid+"','"+subcompanyid+"','"+departmentid+"','"+roleid+"','"+foralluser+"','"+ssharetype+"', '"+sseclevel+"','"+srolelevel+"','"+suserid+"','"+ssubcompanyid+"','"+sdepartmentid+"','"+sroleid+"','"+sforalluser+"','"+settype+"','"+""+seclevelMax+"','"+""+sseclevelMax+"','"+jobtitleid+"','"+joblevel+"','"+joblevelvalue+"','"+sjobtitleid+"','"+sjoblevel+"','"+sjoblevelvalue+"','"+companyVirtual+"')";
    	RecordSet.executeSql(sql);
	}
    StringBuffer sb=new StringBuffer();
    sb.append("select workPlanType.workPlanTypename, WorkPlanShareSet.* from WorkPlanShareSet left join workPlanType on WorkPlanShareSet.planid=workPlanType.workPlanTypeID where 1=1 ")
    .append(" and planid='"+planType+"'")
    .append(" and sharetype='"+sharetype+"'")
    .append(" and seclevel='"+seclevel+"'")
    .append(" and rolelevel='"+rolelevel+"'")
    .append(" and sharelevel='"+sharelevel+"'")
    .append(" and userid='"+userid+"'")
    .append(" and subcompanyid='"+subcompanyid+"'")
    .append(" and departmentid='"+departmentid+"'")
    .append(" and roleid='"+roleid+"'")
    .append(" and foralluser='"+foralluser+"'")
    .append(" and ssharetype='"+ssharetype+"'")
    .append(" and sseclevel='"+sseclevel+"'")
    .append(" and srolelevel='"+srolelevel+"'")
    .append(" and suserid='"+suserid+"'")
    .append(" and ssubcompanyid='"+ssubcompanyid+"'")
    .append(" and sdepartmentid='"+sdepartmentid+"'")
    .append(" and sroleid='"+sroleid+"'")
    .append(" and sforalluser='"+sforalluser+"'")
    .append(" and settype='"+settype+"'")
    .append(" and seclevelMax='"+seclevelMax+"'")
    .append(" and sseclevelMax='"+sseclevelMax+"'")
    .append(" and jobtitleid='"+jobtitleid+"'")
    .append(" and joblevel='"+joblevel+"'")
    .append(" and joblevelvalue='"+joblevelvalue+"'")
    .append(" and sjobtitleid='"+sjobtitleid+"'")
    .append(" and sjoblevel='"+sjoblevel+"'")
    .append(" and sjoblevelvalue='"+sjoblevelvalue+"'")
    .append(" order by WorkPlanShareSet.id desc");
    RecordSet.execute(sb.toString());
    //RecordSet.writeLog(sb.toString());
    writeWorkplanShareLog(RecordSet,"1",Util.getIpAddr(request),user);
}

//if (settype.equals("0")) {
//response.sendRedirect("WorkPlanShareSet.jsp");
%>
	<script type="text/javascript">
		var parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
	</script>
<%
//}
//if (settype.equals("1")) response.sendRedirect("WorkPlanSharePersonal.jsp");
%>
