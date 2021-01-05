
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
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
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String tabid = Util.null2String(request.getParameter("tabid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String companyid = Util.null2String(request.getParameter("companyid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
String newmail = Util.null2String(request.getParameter("newmail"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
//added by wcd 2014-07-08 start
String alllevel = Util.null2String(request.getParameter("alllevel"));
String search = Util.null2String(request.getParameter("search"));
//added by wcd 2014-07-08 end

	boolean isoracle = RecordSet.getDBType().equals("oracle");
	if(tabid.equals("")) tabid="0";
	int uid=user.getUID();
  String rem = null;
  Cookie[] cks = request.getCookies();
  for (int i = 0; i < cks.length; i++) {
	  //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
	  if (cks[i].getName().equals("resourcemulti" + uid)) {
	      rem = cks[i].getValue();
	      break;
	  }
  }
  
  if (rem != null)
	  rem = tabid + rem.substring(1);
  else
   	rem = tabid;
  if (!nodeid.equals("")) rem = rem.substring(0, 1) + "|" + nodeid;

	Cookie ck = new Cookie("resourcemulti"+uid,rem);  
	ck.setMaxAge(30*24*60*60);
	response.addCookie(ck);

	String[] atts=Util.TokenizerString2(rem,"|");
	if(tabid.equals("0")&&atts.length>1){
	   nodeid=atts[1];
	  if(nodeid.indexOf("com")>-1){
	    //subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
	    //System.out.println("subcompanyid"+subcompanyid);
	    }
	  else{
	    //departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	    //System.out.println("departmentid"+departmentid);
	    }
	}
	else if(tabid.equals("1") && atts.length>1) {
		//groupid=atts[1];
	}
	//System.out.println("departmentid"+departmentid);
	//System.out.println("tabid"+tabid);

	String check_per = Util.null2String(request.getParameter("selectedids"));
	if(check_per.equals(",")){
		check_per = "";
	}
	if(check_per.equals("")){
		check_per = Util.null2String(request.getParameter("systemIds"));
	}
	String resourceids = "" ;
	String resourcenames ="";
	String dpids="";
	StringTokenizer st = null;
	Hashtable ht = null;
	Hashtable htdp = null;
	//如果页面传过来的是自定义组id,而不是resourceids，则把group分解成resourceids
  String initgroupid=Util.null2String(request.getParameter("initgroupid"));

  if(!initgroupid.equals("")){
      check_per="";
      RecordSet.executeSql("select userid from hrmgroupmembers h1,HrmResource h2 where h1.userid=h2.id and groupid="+initgroupid) ;
      String userid;
      while(RecordSet.next()){
          userid=RecordSet.getString("userid");
          if(check_per.equals(""))
          check_per+=userid;
          else
          check_per=check_per+","+userid;
      }
  }
 	String coworkid= Util.null2String(request.getParameter("coworkid"));
  if(!coworkid.equals("")){
	  check_per="";
	  RecordSet.executeSql("select coworkers from cowork_items where id="+coworkid) ;
	  String userid;
	  while(RecordSet.next()){
	    userid=RecordSet.getString("coworkers");
	    if(check_per.equals(""))
	    check_per+=userid;
	    else
	    check_per=check_per+","+userid;
	  }
 	}
  String cowtypeid = Util.null2String(request.getParameter("cowtypeid"));
  if(!cowtypeid.equals("")){
	  check_per="";
	  RecordSet.executeSql("select members from cowork_types where id="+cowtypeid) ;
	  String userid;
	  while(RecordSet.next()){
	    userid=RecordSet.getString("members");
	    if(check_per.equals(""))
	    check_per+=userid;
	    else
	    check_per=check_per+","+userid;
	  }
  }
  
  String workID= Util.null2String(request.getParameter("workID"));
  if(!workID.equals("")){
	  check_per="";
	  RecordSet.executeSql("select resourceID from WorkPlan where id="+workID) ;
	  String userid;
	  while(RecordSet.next()){
	      userid=RecordSet.getString("resourceID");
	      if(check_per.equals(""))
	      check_per+=userid;
	      else
	      check_per=check_per+","+userid;
	  }
  }
	if(!check_per.equals("")){
	//if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	//if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	try{
		String strtmp = "select id,lastname,departmentid from HrmResource where id in ("+check_per+")";
    if(!initgroupid.equals(""))
    	strtmp = "select id,lastname,departmentid from HrmResource where id in (select userid from hrmgroupmembers where groupid="+initgroupid+")"; 

		if(!coworkid.equals("")&&isoracle){
      strtmp = "select id,lastname,departmentid from HrmResource where exists  (select 1  from cowork_items where id="+coworkid+" and dbms_lob.instr(coworkers,','||hrmresource.id||',',1,1)>0 )"; 
	}
	//System.out.print(strtmp);
  RecordSet.executeSql(strtmp);
	ht = new Hashtable();
	htdp = new Hashtable();
	//boolean ifhave=false;
	while(RecordSet.next()){
		//ifhave=true;
  	String department = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage());
    String mark=DepartmentComInfo.getDepartmentmark(department);

    if(mark.length()>6)
    mark=mark.substring(0,6);
    int length=mark.getBytes().length;
    if(length<12){
        for(int i=0;i<12-length;i++){
          mark+=" ";
        }
    }
    String subcid=DepartmentComInfo.getSubcompanyid1(department);
    String subc= SubCompanyComInfo.getSubCompanyname(subcid);
    String lastname=RecordSet.getString("lastname");
    length=lastname.getBytes().length;
    if(length<10){
        for(int i=0;i<10-length;i++){
          lastname+=" ";
        }
    }
    lastname=lastname+" | "+mark+" | "+subc;
    ht.put(RecordSet.getString("id"),lastname);
    htdp.put(RecordSet.getString("id"),department);
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}
  strtmp = "select id,lastname, 0 as departmentid from HrmResourcemanager where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
   String lastname=RecordSet.getString("lastname");
   String department = RecordSet.getString("departmentid");
   int length=lastname.getBytes().length;
   if(length<10){
       for(int i=0;i<10-length;i++){
         lastname+=" ";
       }
   }
   lastname=lastname;
   ht.put(RecordSet.getString("id"),lastname);
   htdp.put(RecordSet.getString("id"),department);
	}
	st = new StringTokenizer(check_per,",");

	//while(st.hasMoreTokens()){
		//String s = st.nextToken();
		//resourceids +=","+s;
		//resourcenames += ","+Util.StringReplace(ht.get(s).toString(),",","，");
		//dpids +=","+htdp.get(s).toString();
	//}
	}catch(Exception e){
		//resourceids="";
		//resourcenames="";
		//dpids="";
	}
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
String id=null;
String departmentname=null;
String subcompanyname=null;
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件	
	if(st!=null){
		while(st.hasMoreTokens()){
			id = st.nextToken();
			String tmp_lastname = ResourceComInfo.getLastname(id);
			departmentname = DepartmentComInfo.getDepartmentName(htdp.get(id).toString());
			String tmp_subcompanyid = DepartmentComInfo.getSubcompanyid1(htdp.get(id).toString());
			subcompanyname = SubCompanyComInfo.getSubCompanyname(tmp_subcompanyid);
			JSONObject tmp = new JSONObject();
			tmp.put("id",id);
			tmp.put("lastname",tmp_lastname);
			tmp.put("departmentname",departmentname);
			tmp.put("subcompanyname",subcompanyname);
			jsonArr.add(tmp);
		}
	}

	int totalPage = jsonArr.size();
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	json.put("currentPage", 1);
	json.put("totalPage", 1);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}else{//左侧待选择列表的sql条件
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
					 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
					 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String lastname = Util.null2String(request.getParameter("lastname"));
	String resourcetype = Util.null2String(request.getParameter("resourcetype"));
	String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
	String jobtitle = Util.null2String(request.getParameter("jobtitle"));
	 //departmentid = Util.null2String(request.getParameter("departmentid"));
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	String status = Util.null2String(request.getParameter("status"));
	String firstname = Util.null2String(request.getParameter("firstname"));
	String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());    
	String roleid = Util.null2String(request.getParameter("roleid"));
	
	if(tabid.equals("0")&&departmentid.equals("")&&sqlwhere.equals("")) departmentid=user.getUserDepartment()+"";

	if(departmentid.equals("0"))    departmentid="";

	if(subcompanyid.equals("0"))    subcompanyid="";

	if(status.equals("-1")) status = "";

	if(sqlwhere.length()==0)sqlwhere += " where 1=1";
	if(!lastname.equals("")){
			sqlwhere += " and( lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
	}
	if(!firstname.equals("")){
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	if(!seclevelto.equals("")){
		sqlwhere += " and HrmResource.seclevel <= '"+ seclevelto + "' ";
	}
	if(!resourcetype.equals("")){
		sqlwhere += " and resourcetype = '"+ resourcetype + "' ";
	}

	if(!jobtitle.equals("")){
		sqlwhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
	}

	if(!tabid.equals("0")){
		if(!departmentid.equals("")){
			sqlwhere += " and departmentid =" + departmentid +" " ;
		}
		if(departmentid.equals("")&&!subcompanyid.equals("")){
			sqlwhere += " and subcompanyid1 =" + subcompanyid +" " ;
		}
	}
	
	if(tabid.equals("0")&&!subcompanyid.equals("")){
	//added by wcd 2014-07-08 start
	//增加查询包含所有子分部人员
	String allsubId = subcompanyid;
	if(alllevel.equals("1")){//判断是否包含子分部
		allsubId = this.getAllSubId(subcompanyid,subcompanyid);
	}
	sqlwhere +=" and subcompanyid1 in("+allsubId+") ";
	//added by wcd 2014-07-08 end
	}else if(tabid.equals("0")&&!departmentid.equals("")){
	//added by wcd 2014-07-08 start
	//增加查询包含所有子部门人员
	String alldeptId = departmentid;
	if(alllevel.equals("1")){//判断是否包含子部门
		alldeptId = this.getAllDeptId(departmentid,departmentid);
	}
	sqlwhere+=" and departmentid in("+alldeptId+")";
	//added by wcd 2014-07-08 end
	}
	
	if(!status.equals("")&&!status.equals("9")&&!status.equals("8")){
		sqlwhere += " and status =" + status +" " ;
	}
	
	if(fromHrmStatusChange.equals("")){
		if(status.equals("")||status.equals("8")){
			sqlwhere += " and (status =0 or status = 1 or status = 2 or status = 3) ";
		}
	}
	if(!roleid.equals("")){
		sqlwhere += " and    HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
	}
	String noAccountSql="";
 	if(!isNoAccount.equals("1")){
		if(mode==null||!mode.equals("ldap")){
			noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
	 	}else{
	 		//loginid、account字段整合 qc:128484
			//noAccountSql=" and account is not null "+(RecordSet.getDBType().equals("oracle")?"":" and account<>'' ");
	 		noAccountSql=" and loginid is not null "+(RecordSet.getDBType().equals("oracle")?"":" and loginid<>'' ");
	 	}
 	}
	sqlwhere+=(isNoAccount.equals("1")?"":noAccountSql); //是否显示无账号人员  

	
	String sqlfrom = "HrmResource";
	/*
	if(mode==null||!mode.equals("ldap")){		 
		if(tabid.equals("0")&&!subcompanyid.equals("")){
			sqlwhere +=" and subcompanyid1="+Util.getIntValue(subcompanyid);
		}else if(tabid.equals("0")&&!departmentid.equals("")){
			sqlwhere +=" and departmentid="+Util.getIntValue(departmentid);
		}
	}else{
		if(tabid.equals("0")&&!subcompanyid.equals("")){
			sqlwhere += " and subcompanyid1="+Util.getIntValue(subcompanyid);
		}else if(tabid.equals("0")&&!departmentid.equals("")){
			sqlwhere+=" and departmentid="+Util.getIntValue(departmentid);
		}
	}*/
	
	if(tabid.equals("1")&&!groupid.equals("")){
		sqlfrom = "hrmresource, HrmGroupMembers";
		sqlwhere += " and HrmResource.id= userid and groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql);
	}
	//add by alan for td:10343
	//boolean isInit = Util.null2String(request.getParameter("isinit")).equals("");//是否点击过搜索
	//if((tabid.equals("2") && isInit) ||(tabid.equals("0") && nodeid.equals(""))) {
		//sqlstr = "select HrmResource.id,lastname,departmentid,jobtitle from HrmResource WHERE 1=2";
	//}
	
	//屏蔽已选人员
	String excludeId = Util.null2String(request.getParameter("excludeId"));
	if(excludeId.length()==0)excludeId=check_per;
	if(excludeId.length()>0){
		sqlwhere += " and HrmResource.id not in ("+excludeId+")";
	}
	

	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" HrmResource.id as id, lastname, departmentid, subcompanyid1, jobtitle, dsporder ");
	spp.setSqlFrom(sqlfrom);
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy("dsporder,lastname");
	spp.setPrimaryKey("id");
	spp.setDistinct(true);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	int RecordSetCounts = spu.getRecordCount();
	int totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	rs = spu.getCurrentPageRs(pagenum, perpage);

	while(rs.next()) {
		id = rs.getString("id");
		departmentname = DepartmentComInfo.getDepartmentName(rs.getString("departmentid"));
		subcompanyname = SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1"));

		JSONObject tmp = new JSONObject();
		tmp.put("id",id);
		tmp.put("lastname",rs.getString("lastname"));
		tmp.put("departmentname",departmentname);
		tmp.put("subcompanyname",subcompanyname);
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("totalPage", totalPage);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
}
%>
				