<%@ page language="java" contentType="json; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,
                 weaver.general.Util" %>
<%@ page import="net.sf.json.*,com.sap.mw.jco.JCO" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/> 

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>





<%
User user = HrmUserVarify.getUser (request , response) ;
HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
String belongtoids = user.getBelongtoids();
String account_type = user.getAccount_type();
String voteids="";
String voteshows="";
String forcevotes="";
boolean isSys=true;
RecordSet.executeSql("select 1 from hrmresource where id="+user.getUID());
if(RecordSet.next()){
	isSys=false;
}	

Date votingnewdate = new Date() ;
long votingdatetime = votingnewdate.getTime() ;
Timestamp votingtimestamp = new Timestamp(votingdatetime) ;
String votingCurrentDate = (votingtimestamp.toString()).substring(0,4) + "-" + (votingtimestamp.toString()).substring(5,7) + "-" +(votingtimestamp.toString()).substring(8,10);
String votingCurrentTime = (votingtimestamp.toString()).substring(11,13) + ":" + (votingtimestamp.toString()).substring(14,16);
String votingsql=""; 
if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
belongtoids +=","+user.getUID();

votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+ 
        " and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"'))) "; 
	votingsql +=" and (";
	
  String[] votingshareids=Util.TokenizerString2(belongtoids,",");
	for(int i=0;i<votingshareids.length;i++){
		User tmptUser=VotingManager.getUser(Util.getIntValue(votingshareids[i]));
		String seclevel=tmptUser.getSeclevel();
		int subcompany1=tmptUser.getUserSubCompany1();
		int department=tmptUser.getUserDepartment();
		String  jobtitles=tmptUser.getJobtitle();
	     	
		String tmptsubcompanyid=subcompany1+"";
		String tmptdepartment=department+"";
		RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+tmptUser.getUID());
		while(RecordSet.next()){
			tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
			tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
		}
		
		if(i==0){
			votingsql += " ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		} else {
			votingsql += " or ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		}
		
		  		
	}
	votingsql +=")";

}else{
	String seclevel=user.getSeclevel();
	int subcompany1=user.getUserSubCompany1();
	int department=user.getUserDepartment();
	String  jobtitles=user.getJobtitle();
	  		
	String tmptsubcompanyid=subcompany1+"";
	String tmptdepartment=department+"";
	RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+user.getUID());
	while(RecordSet.next()){
		tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
		tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
	}
	
	votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+
	" and t1.id not in (select distinct votingid from VotingRemark where resourceid ="+user.getUID()+")"+
	" and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"')))"+
	" and t1.id in(select votingid from VotingShare t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) )  or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel>=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ))"; 
}
if(isSys){
	votingsql +=" and 1=2";
}

//signRs.writeLog("###abc:"+votingsql);
signRs.executeSql(votingsql);
while(signRs.next()){ 
String votingid = signRs.getString("id");
String voteshow = signRs.getString("autoshowvote"); 
String forcevote = signRs.getString("forcevote"); 
if(voteids.equals("")){
  voteids = votingid;
  voteshows = voteshow;
  forcevotes = forcevote;
}else{
  voteids =voteids + "," + votingid;
  voteshows =voteshows + "," + voteshow;
  forcevotes =forcevotes + "," + forcevote;

}


}

	JSONObject jsa = new JSONObject();
	jsa.put("voteids", voteids);	
	jsa.put("voteshows", voteshows);
	jsa.put("forcevotes", forcevotes);
	jsa.put("title", SystemEnv.getHtmlLabelName(17599,user.getLanguage()));
	out.print(jsa.toString());

%> 


