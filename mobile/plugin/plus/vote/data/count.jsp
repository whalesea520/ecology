<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");
int userid = user.getUID();
String sql = "select count(*) as amount from voting where ";
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();
if(rs.getDBType().equals("oracle")){
	rs.execute("select 1 from user_tab_cols where table_name='VOTINGSHARE' and column_name='JOBLEVEL'");
}else{
	rs.execute("select 1 from syscolumns where name='joblevel' and id=object_id('VotingShare')");
}
boolean ifNewTable = false;
if(rs.next()){//判断是否有支持岗位共享等字段
	ifNewTable = true;
}
if(rs.getDBType().equals("oracle")){
	rs.execute("select 1 from user_tab_cols where table_name='VOTINGSHARE' and column_name='SECLEVELMAX'");
}else{
	rs.execute("select 1 from syscolumns where name='seclevelmax' and id=object_id('VotingShare')");
}
boolean ifNewTable2 = false;
if(rs.next()){//判断是否支持最大安全级别字段

	ifNewTable2 = true;
}
if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
	String[] votingshareids=Util.TokenizerString2(belongtoids,",");
	String sqlWhere = "";
	for(int i=0;i<votingshareids.length;i++){
		User tmptUser=this.getUser(Util.getIntValue(votingshareids[i]));
		String seclevel=tmptUser.getSeclevel();
		int subcompany1=tmptUser.getUserSubCompany1();
		int department=tmptUser.getUserDepartment();
		String  jobtitles=tmptUser.getJobtitle();
		String tmptsubcompanyid=subcompany1+"";
		String tmptdepartment=department+"";
		rs.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+tmptUser.getUID());
		while(rs.next()){
			tmptsubcompanyid +=","+Util.null2String(rs.getString("subcompanyid"));
			tmptdepartment +=","+Util.null2String(rs.getString("departmentid"));
		}
		String maxSql = "";
		if(ifNewTable2){
			maxSql = " and (seclevelmax is null or seclevelmax>="+seclevel+")";
		}
		String sharetypeSql = "";
		if(ifNewTable){
			sharetypeSql = " or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) )";
		}
		sqlWhere += " or (( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
		" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+maxSql+") or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+maxSql+") or (sharetype=5 and seclevel<="+seclevel+maxSql+")"+sharetypeSql;
		sqlWhere+=" or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+maxSql+") )) ))";	
	}
	sqlWhere=sqlWhere.substring(3);
	sqlWhere="("+sqlWhere+")";
	sql+=" "+sqlWhere;
}else{
	String seclevel=user.getSeclevel();
	int subcompany1=user.getUserSubCompany1();
	int department=user.getUserDepartment();
	String  jobtitles=user.getJobtitle();
	String tmptsubcompanyid=subcompany1+"";
	String tmptdepartment=department+"";
	rs.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+userid);
	while(rs.next()){
		tmptsubcompanyid +=","+Util.null2String(rs.getString("subcompanyid"));
		tmptdepartment +=","+Util.null2String(rs.getString("departmentid"));
	}
	String maxSql = "";
	if(ifNewTable2){
		maxSql = " and (seclevelmax is null or seclevelmax>="+seclevel+")";
	}
	String sharetypeSql = "";
	if(ifNewTable){
		sharetypeSql = " or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) )";
	}
	sql += " id not in (select votingid from VotingRemark where resourceid="+userid+")" +
	" and id in (select votingid from VotingShare t where ((sharetype=1 and resourceid="+user.getUID()+
	") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+maxSql+
	" ) or (sharetype=3 and departmentid in("+tmptdepartment+
	") and seclevel<="+seclevel+maxSql+
	") or (sharetype=5 and seclevel<="+seclevel+maxSql+
	")"+sharetypeSql;
	sql +=" or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel>=t.rolelevel and resourceid="+user.getUID()+
	") and seclevel<="+seclevel+maxSql+") ))";
}
sql += " and (istemplate <> '1' or istemplate is null) and status = 1 ";
int newcount = 0;
rs.executeSql(sql);
if(rs.next()){
	newcount = rs.getInt(1);
}
Map result = new HashMap();
result.put("count",newcount);
result.put("unread",newcount);

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>
<%!
public User getUser(int userid) {
		User user=new User();
		try {
			ResourceComInfo rc = new ResourceComInfo();
			DepartmentComInfo dc = new DepartmentComInfo() ;
	        
			user.setUid(userid);
			user.setLoginid(rc.getLoginID("" + userid));
			user.setFirstname(rc.getFirstname("" + userid));
			user.setLastname(rc.getLastname("" + userid));
			user.setLogintype("1");
			// user.setAliasname(rc.getAssistantID(""+userid));
			// user.setTitle(rs.getString("title"));
			// user.setTitlelocation(rc.getLocationid(""+userid));
			user.setSex(rc.getSexs("" + userid));
			user.setLanguage(7);
			// user.setTelephone(rc);
			// user.setMobile(rc.getm);
			// user.setMobilecall(rs.getString("mobilecall"));
			user.setEmail(rc.getEmail("" + userid));
			// user.setCountryid();
			user.setLocationid(rc.getLocationid("" + userid));
			user.setResourcetype(rc.getResourcetype("" + userid));
			// user.setStartdate(rc.gets);
			// user.setEnddate(rc.gete);
			// user.setContractdate(rc.getc);
			user.setJobtitle(rc.getJobTitle("" + userid));
			// user.setJobgroup(rs.getString("jobgroup"));
			// user.setJobactivity(rs.getString("jobactivity"));
			user.setJoblevel(rc.getJoblevel("" + userid));
			user.setSeclevel(rc.getSeclevel("" + userid));
			user.setUserDepartment(Util.getIntValue(rc.getDepartmentID("" + userid), 0));
			user.setUserSubCompany1(Util.getIntValue(dc.getSubcompanyid1(user.getUserDepartment() + ""), 0));
			// user.setUserSubCompany2(Util.getIntValue(rs.getString("subcompanyid2"),0));
			// user.setUserSubCompany3(Util.getIntValue(rs.getString("subcompanyid3"),0));
			// user.setUserSubCompany4(Util.getIntValue(rs.getString("subcompanyid4"),0));
			user.setManagerid(rc.getManagerID("" + userid));
			user.setAssistantid(rc.getAssistantID("" + userid));
			// user.setPurchaselimit(rc.getPropValue(""+userid));
			// user.setCurrencyid(rc.getc);
			// user.setLastlogindate(rc.get);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
%>