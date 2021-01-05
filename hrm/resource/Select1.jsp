<!DOCTYPE HTML>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,
				weaver.general.GCONST" %>
<!-- added by wcd 2014-07-08 -->
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="org.apache.commons.lang.StringUtils,weaver.hrm.appdetach.*"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!-- added by wcd 2014-07-08 start -->
<%!
/**
 * 取得指定分部下所有分部id（包括指定分部id）
 * @param subId
 * @return
 */
public String getAllSubId(String subId,String ids){
	RecordSet rs_s = new RecordSet();
	rs_s.executeSql("select id from HrmSubCompany where id <> " + subId + " and supsubcomid = "+subId);
	while(rs_s.next()){
		ids += ","+rs_s.getString(1);
		ids = this.getAllSubId(rs_s.getString(1), ids);
	}
	return ids;
}
/**
 * 取得指定部门下所有部门id（包括指定部门id）
 * @param deptId
 * @param ids
 * @return
 */
public String getAllDeptId(String deptId,String ids){
	RecordSet rs_d = new RecordSet();
	rs_d.executeSql("select id from HrmDepartment where id <> " + deptId + " and supdepid = "+deptId);
	while(rs_d.next()){
		ids += ","+rs_d.getString(1);
		ids = this.getAllDeptId(rs_d.getString(1), ids);
	}
	return ids;
}
%>
<!-- added by wcd 2014-07-08 end -->
<%
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String from  = Util.null2String(request.getParameter("from"));
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String needsystem = Util.null2String(request.getParameter("needsystem"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
String sqltag=Util.null2String(request.getParameter("sqltag"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
//System.out.println("departmentid"+departmentid);
if(fromHrmStatusChange.length()>0){
	isNoAccount = Util.null2String(request.getParameter("isNoAccount"),"1");
}
if(tabid.equals("")) tabid="0";

int uid=user.getUID();
String rem=(String)session.getAttribute("resourcesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("resourcesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
        
if(rem!=null)
  rem=tabid+rem.substring(1);
else
  rem=tabid;
if(!nodeid.equals(""))
  rem=rem.substring(0,1)+"|"+nodeid;


session.setAttribute("resourcesingle",rem);
Cookie ck = new Cookie("resourcesingle"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
    subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    //System.out.println("subcompanyid"+subcompanyid);
    }
  else{
    departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    //System.out.println("departmentid"+departmentid);
    }
}
else if(tabid.equals("1") && atts.length>1) {
	groupid=atts[1];
}
//System.out.println("departmentid"+departmentid);
//System.out.println("tabid"+tabid);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
//  String lastname = Util.toScreenToEdit(request.getParameter("searchid"),user.getLanguage(),"0");


String lastname = Util.null2String(request.getParameter("lastname"));
String resourcetype = Util.null2String(request.getParameter("resourcetype"));
String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
//String departmentid = Util.null2String(request.getParameter("departmentid"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
boolean hasSqlwhere = false;
if(sqlwhere.length()==0){
	sqlwhere = " where 1=1";
}else{
	sqlwhere = " where "+sqlwhere;
	hasSqlwhere = true;
}
String status = Util.null2String(request.getParameter("status"));
String firstname = Util.null2String(request.getParameter("firstname"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String roleid = Util.null2String(request.getParameter("roleid"));

//added by wcd 2014-07-08 start
String alllevel = Util.null2String(request.getParameter("alllevel"),"1");
String search = Util.null2String(request.getParameter("search"));
//added by wcd 2014-07-08 end

boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;

if(tabid.equals("0")&&departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";
if(departmentid.equals("0"))    departmentid="";

if(subcompanyid.equals("0"))    subcompanyid="";

/*if(resourcestatus.equals(""))   resourcestatus="0" ;
if(resourcestatus.equals("-1"))   resourcestatus="" ;*/
if(status.equals("-1")) status = "";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (lastname like '%"+Util.fromScreen2(lastname,user.getLanguage())+"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
	}
	else 
		sqlwhere += " and( lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
}
if(!firstname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
}
if(!seclevelto.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where hr.seclevel <= '"+ seclevelto + "' ";
	}
	else
		sqlwhere += " and hr.seclevel <= '"+ seclevelto + "' ";
}
if(!resourcetype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where resourcetype = '"+ resourcetype + "' ";
	}
	else
		sqlwhere += " and resourcetype = '"+ resourcetype + "' ";
}
/*
if(!resourcestatus.equals("")){
	if(ishead==0){
		ishead = 1;
		if(resourcestatus.equals("0")) 
			sqlwhere += " where (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else {
            if( !isoracle ) 
			    sqlwhere += " where (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
            else 
                sqlwhere += " where ((startdate is not null and '"+currentdate+"'<=startdate) or (enddate is not null and '"+currentdate+"'>= enddate)) ";
        }
	}
	else {
		if(resourcestatus.equals("0")) 
			sqlwhere += " and (((startdate='' or startdate is  null) or '"+currentdate+"'>=startdate ) and ((enddate='' or enddate is  null) or '"+currentdate+"'<= enddate )) ";
		else {
            if( !isoracle )
			    sqlwhere += " and (((startdate<>'' and startdate is not null) and '"+currentdate+"'<=startdate) or ((enddate<>'' and enddate is not null) and '"+currentdate+"'>= enddate)) ";
            else 
                sqlwhere += " and ((startdate is not null and '"+currentdate+"'<=startdate) or (enddate is not null and '"+currentdate+"'>= enddate)) ";
        }
	}
}
*/
if(!jobtitle.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
		//sqlwhere += " where jobtitle = " + jobtitle;
	}
	else
		sqlwhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
		//sqlwhere += " and jobtitle = " + jobtitle;
}
if(tabid.equals("0")&&alllevel.equals("1")){
	//包含下级机构不需要，
}else{
	if(!departmentid.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where departmentid =" + departmentid +" " ;
		}
		else
			sqlwhere += " and departmentid =" + departmentid +" " ;
	}
}
if(tabid.equals("0")&&alllevel.equals("1")){
	//包含下级机构不需要，
}
else{
	if(departmentid.equals("")&&!subcompanyid.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where subcompanyid1 =" + subcompanyid +" " ;
		}
		else
			sqlwhere += " and subcompanyid1 =" + subcompanyid +" " ;
	}
}
if(!status.equals("")&&!status.equals("9")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where status =" + status +" " ;
	}
	else
		sqlwhere += " and status =" + status +" " ;
}
if(status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (status =0 or status = 1 or status = 2 or status = 3) " ;
	}
	else
		sqlwhere += " and (status =0 or status = 1 or status = 2 or status = 3) ";
}

if(fromHrmStatusChange.equals("")){
	if(!roleid.equals("")){
	        if(ishead==0){
	            ishead = 1;
	            sqlwhere += " where  hr.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
	        }
	        else
	            sqlwhere += " and    hr.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
	    }
}

String noAccountSql="";
if(StringUtils.isNotBlank(sqltag)){
	//String[] sqls={" (departmentid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and departmentid<>'' ")+" and (account is null "+(RecordSet.getDBType().equals("oracle")?"":" or account='' ")+")) "};
   String[] sqls={" (departmentid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and departmentid<>'' ")+" and (loginid is null "+(RecordSet.getDBType().equals("oracle")?"":" or loginid='' ")+")) "};
    if(ishead==0){
        ishead = 1;
        noAccountSql = " where "+sqls[Util.getIntValue(sqltag)] ;
    }
    else
    	noAccountSql = " and " +sqls[Util.getIntValue(sqltag)]   ;
}

 if(!isNoAccount.equals("1") && StringUtils.isBlank(sqltag)){
	 if(mode==null||!mode.equals("ldap")){
		 if(ishead==0){
			 ishead = 1;
			 noAccountSql=" where loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		 }else{
			 noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		 }
	 }else{
	 //loginid、account字段整合 qc:128484
		//if(ishead==0){
		//	 ishead = 1;
		//	 noAccountSql=" where account is not null "+(RecordSet.getDBType().equals("oracle")?"":" and account<>'' ");
		 //}else{
		//	 noAccountSql=" and account is not null "+(RecordSet.getDBType().equals("oracle")?"":" and account<>'' ");
		 //}
		if(ishead==0){
			 ishead = 1;
			 noAccountSql=" where loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		}else{
			 noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
		}
	 }
 }
 sqlwhere=sqlwhere+(isNoAccount.equals("1")?"":noAccountSql); //是否显示无账号人员
 if(adci.isUseAppDetach()){
	String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",false, "resource_hr");
	String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
	sqlwhere+=tempstr;
}

/*String sqlstr = "select hr.id,lastname,resourcetype,startdate,enddate,jobtitlename,departmentid "+
			    "from HrmResource hr, HrmJobTitles " + sqlwhere ;
if(ishead ==0) sqlstr += "where HrmJobTitles.id = hr.jobtitle " ;
else sqlstr += " and HrmJobTitles.id = hr.jobtitle " ;*/
String sqlstr = "";
if(mode==null||!mode.equals("ldap")){//win
if(from.equals("add")){
 sqlstr = "select hr.id,lastname,departmentid,jobtitle "+
			    "from HrmResource hr " + sqlwhere+" and (accounttype is null or accounttype=0) order by dsporder,lastname"; ;

if(tabid.equals("1")&&!groupid.equals("")){
sqlstr="select hr.id,hr.lastname,hr.departmentid,hr.jobtitle from hrmresource hr,HrmGroupMembers t2 where (hr.accounttype is null or hr.accounttype=0) and hr.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by hr.dsporder,hr.lastname";
}

if(tabid.equals("0")&&!companyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" order by dsporder,lastname";
}else if(tabid.equals("0")&&!subcompanyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
//added by wcd 2014-07-08 start
//增加查询包含所有子分部人员
String allsubId = subcompanyid;
if(alllevel.equals("1")){//判断是否包含子分部
	allsubId = this.getAllSubId(subcompanyid,subcompanyid);
}
sqlstr+=" and subcompanyid1 in("+allsubId+") order by dsporder,lastname";
//added by wcd 2014-07-08 end
}else if(tabid.equals("0")&&!departmentid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr where (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
//added by wcd 2014-07-08 start
//增加查询包含所有子部门人员
String alldeptId = departmentid;
if(alllevel.equals("1")){//判断是否包含子部门
	alldeptId = this.getAllDeptId(departmentid,departmentid);
}
sqlstr+=" and departmentid in("+alldeptId+") order by dsporder,lastname";
//added by wcd 2014-07-08 end
}
}else{
 sqlstr = "select hr.id,lastname,departmentid,jobtitle "+
			    "from HrmResource hr " + sqlwhere+" order by dsporder,lastname"; ;

if(tabid.equals("1")&&!groupid.equals("")){
sqlstr="select hr.id,hr.lastname,hr.departmentid,hr.jobtitle from hrmresource hr,HrmGroupMembers t2 where hr.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by hr.dsporder,hr.lastname";
}

if(tabid.equals("0")&&!companyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

sqlstr+=" order by dsporder,lastname";
}else if(tabid.equals("0")&&!subcompanyid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
//added by wcd 2014-07-08 start
//增加查询包含所有子分部人员
String allsubId = subcompanyid;
if(alllevel.equals("1")){//判断是否包含子分部
	allsubId = this.getAllSubId(subcompanyid,subcompanyid);
}
sqlstr+=" and subcompanyid1 in("+allsubId+") order by dsporder,lastname";
//added by wcd 2014-07-08 end
}else if(tabid.equals("0")&&!departmentid.equals("")){
sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
//added by wcd 2014-07-08 start
//增加查询包含所有子部门人员
String alldeptId = departmentid;
if(alllevel.equals("1")){//判断是否包含子部门
	alldeptId = this.getAllDeptId(departmentid,departmentid);
}
sqlstr+=" and departmentid in("+alldeptId+") order by dsporder,lastname";
//added by wcd 2014-07-08 end
}
}
}else{//ldap
	if(from.equals("add")){
		 sqlstr = "select hr.id,lastname,departmentid,jobtitle "+
					    "from HrmResource hr " + sqlwhere+" and (accounttype is null or accounttype=0) order by dsporder,lastname"; ;

		if(tabid.equals("1")&&!groupid.equals("")){
		sqlstr="select hr.id,hr.lastname,hr.departmentid,hr.jobtitle from hrmresource hr,HrmGroupMembers t2 " + sqlwhere+" and (hr.accounttype is null or hr.accounttype=0) and hr.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by hr.dsporder,hr.lastname";
		}

		if(tabid.equals("0")&&!companyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

		sqlstr+=" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!subcompanyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
		//added by wcd 2014-07-08 start
		//增加查询包含所有子分部人员
		String allsubId = subcompanyid;
		if(alllevel.equals("1")){//判断是否包含子分部
			allsubId = this.getAllSubId(subcompanyid,subcompanyid);
		}
		sqlstr+=" and subcompanyid1 in("+allsubId+") order by dsporder,lastname";
		//added by wcd 2014-07-08 end
		}else if(tabid.equals("0")&&!departmentid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (accounttype is null or accounttype=0) and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
		//added by wcd 2014-07-08 start
		//增加查询包含所有子部门人员
		String alldeptId = departmentid;
		if(alllevel.equals("1")){//判断是否包含子部门
			alldeptId = this.getAllDeptId(departmentid,departmentid);
		}
		sqlstr+=" and departmentid in("+alldeptId+") order by dsporder,lastname";
		//added by wcd 2014-07-08 end
		}
		}else{
		 sqlstr = "select hr.id,lastname,departmentid,jobtitle "+
					    "from HrmResource hr " + sqlwhere+" order by dsporder,lastname"; ;

		if(tabid.equals("1")&&!groupid.equals("")){
		sqlstr="select hr.id,hr.lastname,hr.departmentid,hr.jobtitle from hrmresource hr,HrmGroupMembers t2 " + sqlwhere+" and hr.id=t2.userid and t2.groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql)+" order by hr.dsporder,hr.lastname";
		}

		if(tabid.equals("0")&&!companyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);

		sqlstr+=" order by dsporder,lastname";
		}else if(tabid.equals("0")&&!subcompanyid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
		//added by wcd 2014-07-08 start
		//增加查询包含所有子分部人员
		String allsubId = subcompanyid;
		if(alllevel.equals("1")){//判断是否包含子分部
			allsubId = this.getAllSubId(subcompanyid,subcompanyid);
		}
		sqlstr+=" and subcompanyid1 in("+allsubId+") order by dsporder,lastname";
		//added by wcd 2014-07-08 end
		}else if(tabid.equals("0")&&!departmentid.equals("")){
		sqlstr="select  id,lastname,departmentid,jobtitle  from hrmresource hr " + sqlwhere+" and (status =0 or status = 1 or status = 2 or status = 3) "+(isNoAccount.equals("1")?"":noAccountSql);
		//added by wcd 2014-07-08 start
		//增加查询包含所有子部门人员
		String alldeptId = departmentid;
		if(alllevel.equals("1")){//判断是否包含子部门
			alldeptId = this.getAllDeptId(departmentid,departmentid);
		}
		sqlstr+=" and departmentid in("+alldeptId+") order by dsporder,lastname";
		//added by wcd 2014-07-08 end
		} 
		}
}
//add by alan for td:10343
boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
if(!hasSqlwhere){
	if((tabid.equals("2") && isInit) ||(tabid.equals("0") && nodeid.equals(""))) sqlstr = "select hr.id,lastname,departmentid,jobtitle from HrmResource hr WHERE 1=2";
}
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}
	catch(e){}
</script>
</HEAD>
<BODY>
<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" onclick="btnsub_onclick();" id="btnsub" <%if(!tabid.equals("2")){%>style="display:none"<%}%> value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>">
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<!--########Browser Table Start########-->
<TABLE width=100% class="BroswerStyle"  cellspacing="0" STYLE="margin-top:0">
    <tr>
       <td colspan="3" align="right">
					<%if(tabid.equals("0")){ %>
					<input type="checkbox" id="alllevel" name="alllevel" value="1" <%=alllevel.equals("1")?"checked='checked'":""%>/><%=SystemEnv.getHtmlLabelName(33454,user.getLanguage())%>
					<input class=inputstyle type="hidden" name="search" value="1">
				<%} %>
			<% if(StringUtils.isBlank(sqltag)){ %>	
           <input type="checkbox" value="1" name="isNoAccount" id="isNoAccount" <%=isNoAccount.equals("1")?"checked='checked'":""%>><%=SystemEnv.getHtmlLabelName(31504,user.getLanguage())%>
       		<% } %>
       </td>
   </tr>
   </TABLE>
   <!-- <div id="tableList" style="overflow-y:scroll;width:100%;height:295px">  </div> -->
    
		<%
		//out.println(sqlstr);
		String tableString=""+
		"<table instanceid=\"BrowseTable\" pageId=\""+PageIdConst.HRM_Select+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_Select,user.getUID(),PageIdConst.HRM)+"\"  datasource=\"weaver.hrm.HrmDataSource.getHrmResourceList\" sourceparams=\"needsystem:"+needsystem+"+sqlstr:"+Util.toHtmlForSplitPage(sqlstr)+"\" tabletype=\"none\">"+
		"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  />"+
		"<head>";
			tableString+=	 "<col width=\"0%\" hide=\"true\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"ids\" orderkey=\"ids\"/>";
			tableString+=	 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastnames\" orderkey=\"lastnames\"/>";
			tableString += "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitlenames\" orderkey=\"jobtitlenames\"/>";
			tableString += "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentids\" orderkey=\"departmentids\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\"/>"+
		"</head>"+
		"</table>";      
		%>
		<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.HRM_Select %>"/>
		<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class="zd_btn_submit" onclick="btnclear_onclick();" id="btnclear" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
      <input type="button" class="zd_btn_cancle" onclick="btncancel_onclick();" id="btncancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
</div>

<script language="javascript">
function btnclear_onclick(){
  var returnjson = {id:"",name:""};
	if(dialog){
		try{
          dialog.callback(returnjson);
     }catch(e){}

		try{
		     dialog.close(returnjson);
		 }catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
  	window.parent.parent.close();
	}
}

function btnsub_onclick(){
     window.parent.frame1.document.SearchForm.btnsub.click();
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
  	window.parent.parent.close();
	}
}

function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{ 
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
  var target=e.srcElement||e.target;
  if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		var returnjson = {
    		 id:jQuery(curTr.cells[0]).text(),
    		 name:replaceToHtml(jQuery(curTr.cells[1]).text()),
    		 a1:jQuery(curTr.cells[3]).text(),
    		 a2:jQuery(curTr.cells[4]).text()};	 
		if(dialog){
			try{
          dialog.callback(returnjson);
     }catch(e){}

			try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{
    	window.parent.parent.returnValue = returnjson;
    	window.parent.parent.close();
	 	}
	}
}

function afterDoWhenLoaded(){
	$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing']").each(function(){
		var tr = jQuery(this);
		tr.bind("click",function(){
			var id = tr.children("td:first").next().text();
			var name = tr.children("td:first").next().next().text();
			var a1 = tr.children("td:first").next().next().next().text();
			var a2 = tr.children("td:first").next().next().next().next().text();
			var returnjson = {'id':id,'name':name,'a1':a1,'a2':a2};	 
			if(dialog){
							try{
          dialog.callback(returnjson);
     }catch(e){}

			try{
			     dialog.close(returnjson);
			 }catch(e){}
			}else{
	    	window.parent.parent.returnValue = returnjson;
	    	window.parent.parent.close();
		 	}
		});
	});
}

jQuery(document).ready(function(){
	//$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	//$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	//$("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	
	//$("#btnclear").click(btnclear_onclick);
	
});
</script>
</BODY>
</HTML>
