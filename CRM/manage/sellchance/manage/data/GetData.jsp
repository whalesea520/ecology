
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
int rows = 5;
String userid = user.getUID()+"";
String temptable = "";
String usertype="0";
if(user.getLogintype().equals("2")) usertype="1";
String json = "";
String key_word = Util.null2String(request.getParameter("key_word"));
String searchtype = Util.null2String(request.getParameter("searchtype"));
StringBuffer sql = new StringBuffer();
String sqlWhere = "";
String sqlWhere2 = "";
if(!key_word.equals("")){
	if(key_word.indexOf("+")>0){
		String[] ands = key_word.split("\\+");
		if(ands.length>0){
			sqlWhere += " ( ";
			sqlWhere2 += " ( ";
			for(int i=0;i<ands.length;i++){
				if(i == 0){
					sqlWhere += " #### like '%" + ands[i] + "%'";
					sqlWhere2 += " #### like '%," + ands[i] + ",%'";
				}else{
					sqlWhere += " and  #### like '%" + ands[i] + "%'";
					sqlWhere2 += " and  #### like '%," + ands[i] + ",%'";
				}
			}
			sqlWhere += " ) ";
			sqlWhere2 += " ) ";
		}
	}else{
		String[] ors = key_word.split(" ");
		if(ors.length>0){
			sqlWhere += " ( ";
			sqlWhere2 += " ( ";
			for(int i=0;i<ors.length;i++){
				if(i == 0){
					sqlWhere += " #### like '%" + ors[i] + "%'";
					sqlWhere2 += " #### like '%," + ors[i] + ",%'";
				}else{
					sqlWhere += " or  #### like '%" + ors[i] + "%'";
					sqlWhere2 += " or  #### like '%," + ors[i] + ",%'";
				}
			}
			sqlWhere += " ) ";
			sqlWhere2 += " ) ";
		}
	}
	
	
	if(searchtype.equals("hrm")){
		sql.append("select top "+rows+" id,lastname from HrmResource where (status =0 or status = 1 or status = 2 or status = 3) and ("+sqlWhere.replaceAll("####","lastname")+" or "+sqlWhere.replaceAll("####","pinyinlastname")+") order by dsporder");
		
	}else if(searchtype.equals("doc")){
		sql.append("select top "+rows+" id,docsubject from DocDetail  t1," + ShareManager.getShareDetailTableByUser("doc", user) + " t2 "
				+"where (ishistory is null or ishistory = 0) and  ( ( t1.docstatus = 7 and  (sharelevel>1)) or t1.docstatus in ('1','2','5')) "
				+"and "+sqlWhere.replaceAll("####","docsubject")+" and maincategory!=0  and subcategory!=0 and seccategory!=0 and t1.id=t2.sourceid order by doclastmoddate desc,doclastmodtime desc,id desc");
		
	}else if(searchtype.equals("wf")){
		sql.append("select top "+rows+" requestid,requestname from (select distinct top 5 workflow_requestbase.requestid ,requestname,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base "
				+"where "+sqlWhere.replaceAll("####","requestname")
				+" and (isnull(workflow_requestbase.currentstatus,-1) = -1 or (isnull(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+")) "
				+"and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc) as s  order by createdate , createtime");
	}else if(searchtype.equals("crm")){
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			sql.append("select top "+rows+" id,name from CRM_CustomerInfo where (deleted=0 or deleted is null) and "+sqlWhere.replaceAll("####","name")+" order by createdate desc,id desc");
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			sql.append("select distinct top "+rows+" t1.id,t1.name,t1.createdate "
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null) and "+sqlWhere.replaceAll("####","t1.name")+" order by createdate desc,id desc");
		}
	}else if(searchtype.equals("agent")){
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			sql.append("select top "+rows+" id,name from CRM_CustomerInfo where (deleted=0 or deleted is null) and "+sqlWhere.replaceAll("####","name"));
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			sql.append("select distinct top "+rows+" t1.id,t1.name,t1.createdate "
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null) and "+sqlWhere.replaceAll("####","t1.name"));
		}
		sql.append(" and t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25) order by createdate desc,id desc");
	}else if(searchtype.equals("proj")){
		temptable = "prjstemptable"+ Util.getRandom() ;
		String SearchSql = "";
		String SqlWhere = " where "+sqlWhere.replaceAll("####","t1.subject")+" and t1.prjid = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();

		if(rs.getDBType().equals("oracle")){
			SearchSql = "create table "+temptable+"  as select * from (select  t1.id,t1.subject,t1.prjid,t1.hrmid from Prj_TaskProcess  t1,PrjShareDetail t2 "+ SqlWhere +" order by t1.id desc ) where rownum<"+ rows;
		}else if(rs.getDBType().equals("db2")){
			SearchSql = "create table "+temptable+"  as  (select  t1.id,t1.subject,t1.prjid,t1.hrmid from Prj_TaskProcess  t1,PrjShareDetail t2  ) definition only ";

		    rs.executeSql(SearchSql);
		    
			SearchSql = "insert into "+temptable+" (select t1.id,t1.subject,t1.prjid,t1.hrmid from Prj_TaskProcess  t1,PrjShareDetail t2 "+ SqlWhere + " order by t1.id desc fetch first "+rows+" rows only )"; 
		}else{
			SearchSql = "select top "+rows+" t1.id,t1.subject,t1.prjid,t1.hrmid into "+temptable+" from Prj_TaskProcess  t1,PrjShareDetail t2 "+ SqlWhere + " order by t1.id desc"; 
		}
		rs.executeSql(SearchSql);

		if(rs.getDBType().equals("oracle")){
			sql.append("select id,subject from (select * from  "+temptable+" order by id) where rownum< "+rows);
		}else if(rs.getDBType().equals("db2")){
			sql.append("select  id,subject from "+temptable+"  order by id fetch first "+rows+" rows only ");
		}else{
			sql.append("select top "+rows+" id,subject from "+temptable+"  order by id ");
		}
	}else if(searchtype.equals("task")){
		String currentid = Util.null2String(request.getParameter("currentid"));
		sql.append("select top "+rows+" t1.id,t1.name,t1.status from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and "+sqlWhere.replaceAll("####","t1.name")+" "
				+" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
				+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
				+ ")");
		if(!currentid.equals("")) sql.append(" and t1.id<>"+currentid);
		sql.append(" order by t1.id desc");
	}else if(searchtype.equals("search")){
		String condition = "";
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			condition = "(select id,name from CRM_CustomerInfo where (deleted=0 or deleted is null)) as customerIds";
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			condition = "(select t1.id,t1.name "
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
		}
		sql.append("select A.id,A.subject,A.sellstatusid,A.customerid,A.createdate,A.endtatusid"
				+ " from (select top "+rows+" t.id,t.subject,t.sellstatusid,t.customerid,t.createdate,t.endtatusid"
				+ " from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id "
				+ " where ("+sqlWhere.replaceAll("####","t.subject")+" or "+sqlWhere.replaceAll("####","customerIds.name")+") order by t.createdate desc,t.createtime desc,t.id desc) A" 
				+ " union all"
				+ " select B.id,B.name,B.status,0,'',0 from "
				+ " (select top "+rows+" id,lastname as name,-1 as status from HrmResource where (status =0 or status = 1 or status = 2 or status = 3) "
				+ " and ("+sqlWhere.replaceAll("####","lastname")+" or "+sqlWhere.replaceAll("####","pinyinlastname")+") order by dsporder) B"
				);
	}else if(searchtype.equals("tag")){
		String tags = "";
		String tag = "";
		String history = ",";
		rs.executeSql("select tag from TM_TaskInfo where (deleted =0 or deleted is null) order by createdate desc,createtime desc");
		while(rs.next()){
			tag = Util.null2String(rs.getString("tag"));
			if(!tag.equals("")) tags += tag;
		}
		List tagList = Util.TokenizerString(tags,",");
		for(int i=0;i<tagList.size();i++){
			tag = (String)tagList.get(i);
			if(!tag.equals("") && history.indexOf(","+tag+",")<0 && tag.indexOf(key_word)>-1){
				history += tag + ",";
				json += "{id:'"+tag+"',name:'"+tag+"'},";
			}
		}
	}
	//System.out.println(sql.toString());
	if(!searchtype.equals("tag")){
		rs.executeSql(sql.toString());
		while(rs.next()){
			json += "{id:'"+rs.getString(1)+"',name:'"+rs.getString(2)+"'";
			if(searchtype.equals("search")){
				String endstatus = "进行";
				if("1".equals(rs.getString("endtatusid"))) endstatus = "成功";
				if("2".equals(rs.getString("endtatusid"))) endstatus = "失败";
				if("-1".equals(rs.getString(3))){
					json += ",status:'"+SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(rs.getString(1)))+"',type:2";
				}else{
					json += ",status:'"+SellstatusComInfo.getSellStatusname(rs.getString(3))+"("+endstatus+")',type:1,crmid:"+rs.getString("customerid")+",lastdate:'"+rs.getString("createdate")+"',crmname:'"+CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid"))+"'";
				}
			}
			json += "},";
		}
	}
	
	if(!json.equals("")){
		json = "[" + json.substring(0,json.length()-1) + "]";
	}
	if(searchtype.equals("proj")) rs.executeSql("drop table "+temptable);
}
//System.out.println(json);
out.println(json);
%>
