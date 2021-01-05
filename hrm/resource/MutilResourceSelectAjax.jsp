
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.hrm.common.Tools,weaver.hrm.common.AjaxManager"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page"/>
<jsp:useBean id="ResourceVirtualComInfo" class="weaver.hrm.companyvirtual.ResourceVirtualComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<%!
/*
标准数据格式
tmp.put("messagerurl","/images/treeimages/Home_wev8.gif");
tmp.put("id",tmpid[1]);
tmp.put("nodeid",id);
tmp.put("name",SubCompanyComInfo.getSubCompanyname(tmpid[1])+"("+num+")");
tmp.put("pinyinname",SubCompanyComInfo.getSubCompanyname(tmpid[1]));
tmp.put("num",num);
tmp.put("type",tmpid[0]);
*/
%>
<%
int rowIndex = 0;
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String tabid = Util.null2String(request.getParameter("tabid"));
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String groupid = Util.null2String(request.getParameter("groupid"));
String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
String managerid = Util.null2String(request.getParameter("managerid"));
String selectedids = Util.null2String(request.getParameter("selectedids"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int perpage = Util.getIntValue(request.getParameter("pageSize"),30) ;
int pagenum = 1;

if(!fromHrmStatusChange.equals("")){
	if(Util.getIntValue(virtualtype)<-1){
		sqlwhere = sqlwhere.replace("hr.subcompanyid1","hr.hrmsubcompanyid1");
		sqlwhere = sqlwhere.replace("hr.departmentid","hr.hrmdepartmentid");
	}
}
//added by wcd 2014-07-08 start
String alllevel = Util.null2String(request.getParameter("alllevel"));
//added by wcd 2014-07-08 end

String cmd = Util.null2String(request.getParameter("cmd"));
JSONArray jsonArr = new JSONArray();
if(cmd.equals("getComDeptResource")){
	//获得分部 部门 人员
	String comdeptnodeids = Util.null2String(request.getParameter("comdeptnodeids"));
	jsonArr = MutilResourceBrowser.getComDeptResource(comdeptnodeids,alllevel,isNoAccount,selectedids,user, sqlwhere);	
	out.println(jsonArr.toString());
	//System.out.println(jsonArr.toString());
	return;
}else if(cmd.equals("getComDeptResourceNum")){
	String comdeptnodeids = Util.null2String(request.getParameter("nodeids"));
	int num = MutilResourceBrowser.getComDeptResourceNum(comdeptnodeids, alllevel, isNoAccount, user, sqlwhere);
	JSONObject json = new JSONObject();
	json.put("num",num);
	out.println(json.toString());
	//System.out.println(json.toString());
	return;
}else if(cmd.equals("getComDeptResourceVirtual")){
	String comdeptnodeids = Util.null2String(request.getParameter("comdeptnodeids"));
	jsonArr = MutilResourceBrowser.getComDeptResourceVirtual(comdeptnodeids,alllevel,isNoAccount,selectedids,user, sqlwhere);	
	out.println(jsonArr.toString());
	//System.out.println(jsonArr.toString());
	return;
}if(cmd.equals("getGroupResource")){
	//获得自定义组 人员
	String comdeptnodeids = Util.null2String(request.getParameter("comdeptnodeids"));
	jsonArr = MutilResourceBrowser.getGroupResource(comdeptnodeids,alllevel,isNoAccount,selectedids,user, sqlwhere);	
	out.println(jsonArr.toString());
	//System.out.println(jsonArr.toString());
	return;
}else if(cmd.equals("getManagerResource")){
	String comdeptnodeids = "manager_"+virtualtype;
	if(Integer.parseInt(virtualtype)<0){
		jsonArr = MutilResourceBrowser.getComDeptResourceVirtual(comdeptnodeids,alllevel,isNoAccount,selectedids,user, sqlwhere);	
	}else{
		jsonArr = MutilResourceBrowser.getComDeptResource(comdeptnodeids,alllevel,isNoAccount,selectedids,user, sqlwhere);	
	}
	out.println(jsonArr.toString());
	return;
}else if(cmd.equals("getSelectedidsNum")){
	String num = MutilResourceBrowser.getSelectedidsNum(selectedids,alllevel,isNoAccount,user, sqlwhere);	
	JSONObject json = new JSONObject();
	json.put("num",num);
	out.println(json.toString());
	return;
}else if(cmd.equals("getGroupResourceNum")){
	String comdeptnodeids = Util.null2String(request.getParameter("nodeids"));
	int num = MutilResourceBrowser.getGroupResourceNum(comdeptnodeids, isNoAccount, user, sqlwhere);
	JSONObject json = new JSONObject();
	json.put("num",num);
	out.println(json.toString());
	//System.out.println(json.toString());
	return;
}

	boolean isoracle = RecordSet.getDBType().equals("oracle");
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
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(0,1).equals(","))check_per = check_per.substring(1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	if(check_per.substring(check_per.length()-1).equals(","))check_per = check_per.substring(0,check_per.length()-1);
	try{
		//System.out.println("check_per======="+check_per);
		String  tmpids = MutilResourceBrowser.getExcludeSqlWhere(check_per,alllevel,isNoAccount,user, sqlwhere);
		String strtmp = "select id,lastname,departmentid from HrmResource where "+Tools.getOracleSQLIn(tmpids,"id");
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
	}
	
	tmpids = MutilResourceBrowser.getExcludeSqlWhere(check_per,alllevel,isNoAccount,user, sqlwhere);
  strtmp = "select id,lastname, 0 as departmentid from HrmResourcemanager where "+Tools.getOracleSQLIn(tmpids,"id");
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
	 if(rowIndex>50)break;
	 rowIndex++;
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
	}catch(Exception e){
	}
}
String id=null;
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件	
	if(st!=null){
		while(st.hasMoreTokens()){
			id = st.nextToken();
			if(id.startsWith("subcom")||id.startsWith("dept")){
			//公司, 部门								
				String[] tmpid = Util.TokenizerString2(id,"_");
				String name = "";
				String messagerurl = "";
				if(Integer.parseInt(tmpid[1])<0){
				//虚拟
					if(tmpid[0].equals("subcom")){
						name = SubCompanyVirtualComInfo.getSubCompanyname(tmpid[1]);
						messagerurl = "/images/treeimages/Home1_wev8.gif";
					}else{
						name = DepartmentVirtualComInfo.getDepartmentname(tmpid[1]);
						messagerurl = "/images/treeimages/subCopany_Colse1_wev8.gif";
					}
				}else{
					if(tmpid[0].equals("subcom")){
						name = SubCompanyComInfo.getSubCompanyname(tmpid[1]);
						messagerurl = "/images/treeimages/Home1_wev8.gif";
					}else{
						name = DepartmentComInfo.getDepartmentname(tmpid[1]);
						messagerurl = "/images/treeimages/subCopany_Colse1_wev8.gif";
					}
				}

				int num = MutilResourceBrowser.getComDeptResourceNum(id,alllevel,isNoAccount,user, sqlwhere);
				JSONObject tmp = new JSONObject();
				tmp.put("messagerurl",messagerurl);
				tmp.put("id",tmpid[1]);
				tmp.put("nodeid",id);
				tmp.put("nodenum",num);
				tmp.put("name",name+"("+num+")");
				tmp.put("type",tmpid[0]);
				tmp.put("pinyinlastname",name);
				jsonArr.add(tmp);
			}else if(id.startsWith("group")){
				//人力资源
				String[] tmpid = Util.TokenizerString2(id,"_");
				rs.executeSql(" select id, name from HrmGroup where id ="+tmpid[1]);
				if(rs.next()){
					JSONObject tmp = new JSONObject();
					int num = MutilResourceBrowser.getGroupResourceNum(rs.getString("id"),isNoAccount,user, sqlwhere);
					tmp.put("messagerurl","/images/treeimages/subCopany_Colse1_wev8.gif");
					tmp.put("id",rs.getString("id"));
					tmp.put("nodeid",id);
					tmp.put("nodenum",num);
					tmp.put("name",rs.getString("name")+"("+num+")");
					tmp.put("type",tmpid[0]);
					tmp.put("pinyinlastname",rs.getString("name"));
					jsonArr.add(tmp);
				}
			}else{
			//人力资源
				String tmp_lastname = ResourceComInfo.getLastname(id);
				String tmp_pinyinlastname = "";
				rs.executeSql(" select pinyinlastname from hrmresource where id ="+id);
				if(rs.next()){
					tmp_pinyinlastname = Util.null2String(rs.getString("pinyinlastname"));
				}
				if(tmp_pinyinlastname.length()==0)tmp_pinyinlastname=tmp_lastname;
				JSONObject tmp = new JSONObject();
				tmp.put("messagerurl",ResourceComInfo.getMessagerUrls(id));
				tmp.put("id",id);
				tmp.put("nodeid","resource_"+id);
				tmp.put("lastname",tmp_lastname);
				tmp.put("type","resource");
				tmp.put("pinyinlastname",rs.getString("pinyinlastname"));
				tmp.put("jobtitlename",MutilResourceBrowser.getJobTitlesname(id));
				jsonArr.add(tmp);
			}
		}
	}
	//System.out.println(jsonArr.toString());
	out.println(jsonArr.toString());
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
	String status = Util.null2String(request.getParameter("status"));
	String firstname = Util.null2String(request.getParameter("firstname"));
	String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());    
	String roleid = Util.null2String(request.getParameter("roleid"));
	String rightStr = Util.null2String(request.getParameter("rightStr"));
	String personCmd = Util.null2String(request.getParameter("personCmd"));

	if(departmentid.equals("0"))    departmentid="";

	if(subcompanyid.equals("0"))    subcompanyid="";

	if(status.equals("-1")) status = "";

	if(sqlwhere.length()==0||sqlwhere.trim().toLowerCase().startsWith("and")){
		sqlwhere = " where 1=1";
	}else{
		sqlwhere = " where "+sqlwhere;
	}
	
	if(!lastname.equals("")){
			sqlwhere += " and( lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
	}
	if(!firstname.equals("")){
		sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
	}
	if(!seclevelto.equals("")){
		sqlwhere += " and hr.seclevel <= '"+ seclevelto + "' ";
	}
	if(!resourcetype.equals("")){
		sqlwhere += " and resourcetype = '"+ resourcetype + "' ";
	}

	if(!jobtitle.equals("")){
		sqlwhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
		//sqlwhere += " and jobtitle = "+jobtitle;
	}
	if(!tabid.equals("0")){
		if(!departmentid.equals("")){
			sqlwhere += " and departmentid in(" + departmentid +") " ;
		}
		if(departmentid.equals("")&&!subcompanyid.equals("")){
			sqlwhere += " and subcompanyid1 in(" + subcompanyid +") " ;
		}
	}
	
	if(tabid.equals("0")&&!subcompanyid.equals("")){
	//added by wcd 2014-07-08 start
	//增加查询包含所有子分部人员
	String allsubId = subcompanyid;
	if(alllevel.equals("1")){//判断是否包含子分部
		allsubId = SubCompanyComInfo.getAllChildSubcompanyId(subcompanyid,subcompanyid);
	}
	//sqlwhere +=" and subcompanyid1 in("+allsubId+") ";
	sqlwhere +=" and "+Tools.getOracleSQLIn(allsubId,"subcompanyid1");
	
	//added by wcd 2014-07-08 end
	}else if(tabid.equals("0")&&!departmentid.equals("")){
	//added by wcd 2014-07-08 start
	//增加查询包含所有子部门人员
	String alldeptId = departmentid;
	if(alllevel.equals("1")){//判断是否包含子部门
		alldeptId = DepartmentComInfo.getAllChildDepartId(departmentid,departmentid);
	}
	//sqlwhere+=" and departmentid in("+alldeptId+")";
	sqlwhere +=" and "+Tools.getOracleSQLIn(alldeptId,"departmentid");
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
	
	if(personCmd.equals("schedulePerson")) {
		sqlwhere += AjaxManager.getData(String.valueOf(user.getUID()), "getSchedulePersonSql;"+rightStr);
	}
	
	if(!roleid.equals("")){
		sqlwhere += " and    hr.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
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

 	if(adci.isUseAppDetach()){
		String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",true,"resource_hr");
		String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
		sqlwhere+=tempstr;
	}
	
	String sqlfrom = "HrmResource hr";
	if(Util.getIntValue(virtualtype)<-1)sqlfrom = "HrmResourceVirtualView hr";
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
		sqlfrom = "hrmresource hr, HrmGroupMembers";
		sqlwhere += " and hr.id= userid and groupid="+groupid+(isNoAccount.equals("1")?"":noAccountSql);
	}
	
	//屏蔽已选人员
	String excludeId = Util.null2String(request.getParameter("excludeId"));
	if(excludeId.length()==0)excludeId=check_per;
	if(excludeId.length()>0){
		//excludeId = MutilResourceBrowser.getExcludeSqlWhere(check_per,alllevel,isNoAccount,user, sqlwhere);
		excludeId = MutilResourceBrowser.getExcludeSqlWhere(check_per,alllevel,isNoAccount,user, "");
		//sqlwhere += " and hrmresource.id not in ("+excludeId+")";
		if(excludeId.length()>0){
		  sqlwhere += " and "+Tools.getOracleSQLNotIn(excludeId,"hr.id");
		}
	}
	
	if(managerid.length()>0){
		sqlwhere += " and hr.managerstr like ('%,"+managerid+",%')";
	}
	
 	if(tabid.equals("1")){
 		//同部门
 		if(Util.getIntValue(virtualtype)<-1){
 			sqlwhere += " and hr.departmentid = "+ResourceVirtualComInfo.getDepartmentid(virtualtype,""+user.getUID());
 		}else{
			if(adci.getOutCustomer()){
 	 			sqlwhere += " and hr.departmentid = "+ResourceVirtualComInfo.getDepartmentid("-10000",""+user.getUID());
 			}else{
 				sqlwhere += " and hr.departmentid = "+user.getUserDepartment();
 			}
 		}
	}else if(tabid.equals("2")){
	//我的下属
		if(alllevel.equals("1")){
		//显示所有下属
			sqlwhere += " and hr.managerstr like '%,"+user.getUID()+",%'";
		}else{
			sqlwhere += " and hr.managerid = "+user.getUID();
		}
	}

 	if(Util.getIntValue(virtualtype)<-1){
 		sqlwhere += " and virtualtype="+virtualtype;
 	}
 	
 	String backfields = " hr.id as id, lastname, pinyinlastname, jobtitle, dsporder ";
 	String orderby = " dsporder, lastname";
	if(tabid.equals("0")){
	//最近
		backfields = " hr.id as id, hrsd.id dsporder0, lastname, pinyinlastname, jobtitle, dsporder ";
		if(Util.getIntValue(virtualtype)<-1){
			sqlfrom= " HrmResourcevirtualview hr, HrmResourceSelectRecord  hrsd "; 
		}else{
			sqlfrom= " hrmresource hr, HrmResourceSelectRecord  hrsd "; 
		}
		sqlwhere = sqlwhere + " and hr.id = selectid and resourceid ="+user.getUID();
		orderby = " dsporder0 DESC, dsporder ";
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(backfields);
	spp.setDistinct(true);
	spp.setSqlFrom(sqlfrom);
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy(orderby);
	spp.setPrimaryKey("hr.id");
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
		JSONObject tmp = new JSONObject();
		tmp.put("messagerurl",ResourceComInfo.getMessagerUrls(id));
		tmp.put("id",id);
		tmp.put("nodeid","resource_"+id);
		tmp.put("type","resource");
		tmp.put("lastname",rs.getString("lastname"));
		tmp.put("pinyinlastname",rs.getString("pinyinlastname"));
		tmp.put("jobtitlename",MutilResourceBrowser.getJobTitlesname(id));
		tmp.put("totalPage",RecordSetCounts);
		jsonArr.add(tmp);
	}
	out.println(jsonArr.toString());
}
%>
				