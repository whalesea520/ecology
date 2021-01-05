<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.voting.VotingSearchResult" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.hrm.company.DepartmentComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page"/>
<jsp:useBean id="rsBelong" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />	
<%
	FileUpload fu = new FileUpload(request);
	int status = 1;String msg = ""; 
	String userid=user.getUID()+"";
	JSONObject json = new JSONObject();
	request.setCharacterEncoding("UTF-8");
	String operate = Util.null2String(fu.getParameter("operate"));
	try{
		if(operate.equals("getVotingList")){//获取投票列表 需要参数type
			String type = Util.null2String(fu.getParameter("type"));//空表示未参与 1表示已参与 2表示查看调查结果
			String subject = Util.null2String(new String(Util.null2String(fu.getParameter2("subject")).getBytes("ISO-8859-1"), "UTF-8"));//标题
			String vstatus = Util.null2String(fu.getParameter("status"));//状态

			String begindate = Util.null2String(fu.getParameter("begindate"));//开始日期

			String enddate = Util.null2String(fu.getParameter("enddate"));//截止日期
			HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
		    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
			String belongtoids = user.getBelongtoids();
			String account_type = user.getAccount_type();
			String sql = "select * from voting where ";
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
			if(type.equals("2")){
				boolean canmaintview=HrmUserVarify.checkUserRight("Voting:Maint", user);
				if(canmaintview){
					sql+="1=1";
				}else{
		        	String sqlWhere = "";
		        	if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			  			belongtoids+=","+userid;
			 			sqlWhere = " id in (";
						String[] votingshareids=Util.TokenizerString2(belongtoids,",");
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
					  		sqlWhere +=" select votingid from VotingViewer t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+maxSql+") or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+maxSql+") or (sharetype=5 and seclevel<="+seclevel+maxSql+")";
					  		if(ifNewTable){
					  			sqlWhere +=" or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) ";
					  		}
					  		sqlWhere +=" or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel<=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+maxSql+") ) union ";
					  		sqlWhere +=" select votingid from VotingShare ta"+i+",voting tt"+i+" where ta"+i+".votingid=tt"+i+".id and (tt"+i+".isSeeResult='' or tt"+i+".isSeeResult is null) and ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+maxSql+") or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+maxSql+") or (sharetype=5 and seclevel<="+seclevel+maxSql+") ";
					  		if(ifNewTable){
					  			sqlWhere +=" or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) ";
					  		}
					  		sqlWhere +=" or (sharetype=4 and exists (select 1 from HrmRoleMembers where roleid=ta"+i+".roleid and rolelevel<=ta"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+maxSql+") ) union ";	
					 	}
						sqlWhere +=" select id as votingid from voting where createrid in ("+belongtoids+") or approverid in ( "+belongtoids+") ";
						sqlWhere +=" ) ";
		   			}else{
		   				String seclevel=user.getSeclevel();
						int subcompany1=user.getUserSubCompany1();
						int department=user.getUserDepartment();
			  		    String  jobtitles=user.getJobtitle();
				  		String tmptsubcompanyid=subcompany1+"";
				  		String tmptdepartment=department+"";
				  		rs.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+user.getUID());
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
		   				sqlWhere = " id in (select votingid from VotingViewer t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+maxSql+" ) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+maxSql+") or (sharetype=5 and seclevel<="+seclevel+maxSql+") "+sharetypeSql;
		   				sqlWhere+=" or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel<=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+maxSql+") )" +//在查看结果范围

			        		 " union " +
			        		 " select id as votingid from voting where createrid="+userid+" or approverid = "+userid+//调查是 userid 创建或审批

			        		 " union " +
			        		 //以及调查设置了提交后可查看结果内的

			        		 " select votingid from VotingShare t,voting tt where t.votingid=tt.id and (tt.isSeeResult='' or tt.isSeeResult is null) and ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+maxSql+") or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+maxSql+") or (sharetype=5 and seclevel<="+seclevel+maxSql+") "+sharetypeSql;
		        		 sqlWhere+=" or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel<=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+maxSql+"))"+
			        	 " and exists (select 1 from VotingRemark where resourceid = "+user.getUID()+" and votingid = tt.id)"+
		        		 " ) ";
		   			}
		   			sqlWhere +=" and status in ('1','2') ";
		   			sql +=sqlWhere;
				}
			}else if(type.equals("1")){//查询已参与的
				if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
					sql += " ((id in (select votingid from VotingRemark where resourceid="+ userid+//已投过票的

					" union select votingid from VotingResourceRemark where resourceid="+userid+") )";
			        String[] votingshareids=Util.TokenizerString2(belongtoids,",");
				    for(int i=0;i<votingshareids.length;i++){
				    	sql+=" or (id in (select votingid from VotingRemark where resourceid="+ votingshareids[i]+
					 	" union select votingid from VotingResourceRemark where resourceid="+votingshareids[i]+"))";
					}
				    sql+=")";
				}else{
					sql += " id in (select votingid from VotingRemark where resourceid="+ userid+//已投过票的

					 " union select votingid from VotingResourceRemark where resourceid="+userid+") ";
				}
			}else{//查询未参与的
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
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm") ;
				String currentDate = sdf.format(new Date());
				String _begindate = "",_enddate = "";
				if(!"oracle".equals(rs.getDBType())){
					_begindate = "begindate+' '+begintime";
					_enddate = "enddate+' '+endtime";
				}else{
					_begindate = "CONCAT(CONCAT(begindate,' '),begintime)";
					_enddate = "CONCAT(CONCAT(enddate,' '),endtime)";
				}
				sql += " and ("+_begindate+") <='"+currentDate+"' and ("+_enddate+") >='"+currentDate+"'";
			}
		 	if(!subject.equals("")){//名称
	         	sql += " and subject like '%"+subject+"%'";
	        }
	        if(!vstatus.equals("")){//状态

	         	sql += " and status in ("+vstatus+")";
	        }
	       	if(!begindate.equals("")){//开始日期

	         	sql += " and begindate >= '"+begindate+"'";
	       	}
	       	if(!enddate.equals("")){//截止日期
        	 	sql += " and enddate <= '"+enddate+"'";
          	}
			sql+=" order by begindate desc,begintime desc";
			//System.out.println("sql============"+sql);
			rs.executeSql(sql);
			JSONArray ja = new JSONArray();
			while(rs.next()){
				JSONObject jo = new JSONObject();
				jo.put("id", Util.null2String(rs.getString("id")));//投票表ID
				jo.put("subject", Util.null2String(rs.getString("subject")));//投票标题
				jo.put("begindate", Util.null2String(rs.getString("begindate")));//开始日期

				jo.put("begintime", Util.null2String(rs.getString("begintime")));//开始时间

				jo.put("enddate", Util.null2String(rs.getString("enddate")));//结束日期
				jo.put("endtime", Util.null2String(rs.getString("endtime")));//结束时间
				jo.put("desc", Util.null2String(rs.getString("descr")));//投票描述
				jo.put("status", Util.null2String(rs.getString("status")));//状态 0创建 1进行中 2结束
				jo.put("votingcount", Util.null2String(rs.getString("votingcount")));//投票数量
				ja.add(jo);
			}
			json.put("voteList", ja);
			status = 0;
		}else if(operate.equals("getVotingById")){
			//根据ID获取投票详情 返回数据参见/voting/surverdesign/pages/surveyData.jsp 以及/voting/surverdesign/js/survey_wev8.js
			String votingid= Util.null2String(fu.getParameter("votingid"));
			String sql="select a.isother as isother,c.subject as surveyname,a.pagenum as pagenum,"+
				  " a.subject as name,a.showorder as questionorder,a.questiontype as questiontype "+
				  " ,a.ismulti as type,a.ismustinput as ismustinput,a.israndomsort as israndomsort, "+
				  " a.limit as limit,a.max as maxitem,a.perrowcols as perrowcols,b.description as oplabel, "+
				  " b.questionid as quesionid,b.id as opid,b.roworcolumn as roworcolumn,b.showorder as optionorder "+ 
				  " from VotingQuestion a inner join VotingOption b inner join Voting c on b.votingid=c.id "+
				  " on a.id=b.questionid  "+
				  " where a.votingid='"+votingid+"' order by pagenum,a.showorder,b.showorder ";
		   rs.execute(sql);
		   Map<Integer,Map<Integer,Map<String,Object>>> pages=new TreeMap<Integer,Map<Integer,Map<String,Object>>>();
		   int pagenum=0;
		   int questionorder;
		   int optionorder;
		   Map<Integer,Map<String,Object>> pageinfo;//页码信息
		   Map<String,Object>  questioninfo;//问题信息
		   Map<Integer,Map<String,String>> optioninfo;
		   String surveyname;//调查名称
		   String quesname;//问题名称
		   String questiontype;//问题类型 0:选择题（单选、多选、下拉） 1:组合选择题 2：说明文字 3：填空题
		   String type;//单选还是多选 0:单选 1:多选 2:下拉 -1:填空或说明

		   String ismustinput;//是否必需
		   String israndomsort;//是否随机显示
		   String limit;//最小显示选项
		   String max;//最多显示选项
		   String perrowcols;//每行多少列

		   String isother;//是否包含其它输入
		   Map<String,String> opinfo;//选项信息
		   String oplabel;//选项名称
		   String quesionid;//问题id
		   String opid;//选项id
		   String roworcolumn;//行选项or列选项
		   while(rs.next()){
			   pagenum=rs.getInt("pagenum");//获取页码
			   questionorder=rs.getInt("questionorder");
			   optionorder=rs.getInt("optionorder");
			   //存放页信息

			   if(!pages.containsKey(pagenum)){
				   pageinfo=new TreeMap<Integer,Map<String,Object>>();
				   pages.put(pagenum,pageinfo);
			   }else{
				   pageinfo=pages.get(pagenum);
			   }
			   //存放问题信息
			   if(!pageinfo.containsKey(questionorder)){
				   questioninfo=new TreeMap<String,Object>();
				   pageinfo.put(questionorder,questioninfo);
				   surveyname=rs.getString("surveyname");
		           questioninfo.put("surveyname",surveyname);
				   quesname=rs.getString("name");
				   questioninfo.put("name",quesname);
				   questiontype=rs.getString("questiontype"); 
				   questioninfo.put("questiontype",questiontype);
				   isother=rs.getString("isother"); 
		           questioninfo.put("isother",isother);
				   quesionid=rs.getString("quesionid"); 
		           questioninfo.put("quesionid",quesionid);
				   type=rs.getString("type"); 
				   questioninfo.put("type",type);
				   ismustinput=rs.getString("ismustinput"); 
				   questioninfo.put("ismustinput",ismustinput);
				   israndomsort=rs.getString("israndomsort"); 
				   questioninfo.put("israndomsort",israndomsort);
				   limit=rs.getString("limit"); 
				   questioninfo.put("limit",limit);
				   max=rs.getString("maxitem"); 
				   questioninfo.put("max",max);
				   perrowcols=rs.getString("perrowcols"); 
				   questioninfo.put("perrowcols",perrowcols);
				   optioninfo=new TreeMap<Integer,Map<String,String>>();
				   questioninfo.put("options",optioninfo);
			   }else{
				   questioninfo=pageinfo.get(questionorder);
				   optioninfo=(TreeMap<Integer,Map<String,String>>)questioninfo.get("options");
			   }
			   //选项信息
			   opinfo=new HashMap<String,String>();
			   oplabel=rs.getString("oplabel");
			   opinfo.put("oplabel",oplabel);
			   quesionid=rs.getString("quesionid");
			   opinfo.put("quesionid",quesionid);
			   opid=rs.getString("opid");
			   opinfo.put("opid",opid);
			   roworcolumn=rs.getString("roworcolumn");
			   opinfo.put("roworcolumn",roworcolumn);
			   optioninfo.put(optionorder,opinfo); 
		   }

		   Map<String, Object> voteinfo = new HashMap<String, Object>();
		   voteinfo.put("votepages", pages);
		   rs.execute("select * from Voting where id = '" + votingid + "'");

		   if(rs.next()) {
			   voteinfo.put("subject", rs.getString("subject"));
			   voteinfo.put("detail", rs.getString("detail"));
			   voteinfo.put("begindate", rs.getString("begindate"));
			   voteinfo.put("begintime", rs.getString("begintime"));
			   voteinfo.put("enddate", rs.getString("enddate"));
			   voteinfo.put("endtime", rs.getString("endtime"));
			   voteinfo.put("isanony", rs.getString("isanony"));
			   voteinfo.put("approverid", rs.getInt("approverid"));
		   }
		   json.put("voteinfo", voteinfo);
		   status = 0;
		}else if(operate.equals("saveVoting")){
			//保存投票 代码参见/voting/surverdesign/pages/savesurvey.jsp 
			//需要校验必填  参数名称需要与PC端相符

			String votingid=fu.getParameter("votingid");//调查id
			String opdate = TimeUtil.getCurrentDateString();
			String optime = TimeUtil.getOnlyCurrentTimeString();
			Enumeration  paramnames=fu.getParameterNames();//遍历参数
			String sql="";
			List<String>  sqls=new ArrayList<String>();
			String paramname;
			String paramitems[];
			String questionid;
			String questionchild;
			String[] questionvalues;
			String optionvalue;
			String othername;
			String othervalue;
			//是否匿名操作
			String annony=Util.null2String(fu.getParameter("useranony"));
			if("".equals(annony)){
				annony="0";	
			}
		    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
		    String belongtoshow = userSetting.getBelongtoshowByUserId(userid+""); 
			String belongtoids = user.getBelongtoids();
			String account_type = user.getAccount_type();
			//防止同账号并发操作,先删除操作

			sql = "select * from VotingRemark where resourceid = '"+user.getUID()+"' and votingid='"+votingid+"'";
			rs.execute(sql);
			if(!(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals(""))){
				if(rs.next()){
					msg = "该用户已参与过投票";//该用户已参与过投票

				}
			}
			if(msg.equals("")){
				sql="insert into VotingRemark(votingid,resourceid,useranony,operatedate,operatetime) values('"+votingid+"','"+user.getUID()+"','"+annony+"','"+opdate+"','"+optime+"')";
				sqls.add(sql);
				while(paramnames.hasMoreElements()){
					paramname=(String)paramnames.nextElement();
					if(paramname.indexOf("q_")==0){
				    	paramitems=paramname.split("_");
				    	if(paramitems.length==2){	//选择题 
				    		questionid=paramitems[1]; 	//问题id
				    		if(questionid.indexOf("[]")>=0){//如果是多选

				    			questionid=questionid.substring(0,questionid.indexOf("[]"));
				    		}
				    		questionvalues=fu.getParameterValues(paramname);
				    		for(String optionid:questionvalues){
				    			 if("-100".equals(optionid)){//其它选项
				    				 othername="qother_"+questionid;
				    				 othervalue = Util.convertInput2DB(new String(Util.null2String(fu.getParameter2(othername)).getBytes("ISO-8859-1"), "UTF-8"));
				    				 sql="insert into VotingResourceRemark(votingid,questionid,resourceid,useranony,otherinput,operatedate,operatetime) values('"+votingid+"','"+questionid+"','"+userid+"','"+annony+"','"+othervalue+"','"+opdate+"','"+optime+"')";
				    	    	 }else{
				    	    		 sql="insert into VotingResource(votingid,questionid,optionid,resourceid,operatedate,operatetime) values('"+votingid+"','"+questionid+"','"+optionid+"','"+userid+"','"+opdate+"','"+optime+"')";
				    			 }
					    		 sqls.add(sql);
				    		}
					    }else if(paramitems.length==3){//组合选择
					    	questionid=paramitems[1];
					    	questionchild=paramitems[2];
				    		if(questionchild.indexOf("[]")>=0){//如果是多选

				    			questionchild=questionchild.substring(0,questionchild.indexOf("[]"));
				    		}
					    	questionvalues=fu.getParameterValues(paramname);
				    		for(String optionid:questionvalues){
					    		 sql="insert into VotingResource(votingid,questionid,optionid,resourceid,operatedate,operatetime) values('"+votingid+"','"+questionid+"','"+questionchild+"_"+optionid+"','"+userid+"','"+opdate+"','"+optime+"')";
					    		 sqls.add(sql);
				    		}
					    }
					}
				}
				RecordSetTrans.setAutoCommit(false);
				for(String sqlitem:sqls){
					RecordSetTrans.execute(sqlitem);
				}	
				RecordSetTrans.commit();//提交事务
				if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
					Set undoUserSet=this.getUndoUserSet(votingid);
					Set hasPollRightUserSet=this.getHasPollRightUserSet(votingid);
					String[] belongtoidarr=belongtoids.split(",");
					for(int i=0;i<belongtoidarr.length;i++){
						if(undoUserSet.contains(belongtoidarr[i])){
							rsBelong.executeSql(" insert into VotingRemark(votingid,resourceid,useranony,remark,operatedate,operatetime) select      votingid,"+belongtoidarr[i]+",useranony,remark,operatedate,operatetime from VotingRemark where resourceid="+userid+" and votingid="+votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
					    	rsBelong.executeSql(" insert into VotingResource(votingid,questionid,optionid,resourceid,operatedate,operatetime) select   votingid,questionid,optionid,'"+belongtoidarr[i]+"',operatedate,operatetime from VotingResource where resourceid="+userid+" and votingid="+votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
					    	rsBelong.executeSql("  insert into VotingResourceRemark (votingid,questionid,resourceid,useranony,otherinput,operatedate,operatetime) select votingid,questionid,'"+belongtoidarr[i]+"',useranony,otherinput,operatedate,operatetime from VotingResourceRemark where resourceid="+userid+" and votingid="+votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
						}
					}
					if(!hasPollRightUserSet.contains(String.valueOf(userid))){
					   rsBelong.executeSql("delete from VotingRemark where resourceid ="+userid+" and votingid=" + votingid);
						 rsBelong.executeSql("delete from VotingResource where resourceid ="+userid+" and votingid=" + votingid);
						 rsBelong.executeSql("delete from VotingResourceRemark where resourceid ="+userid+" and votingid=" + votingid);
					 }else{
						  rsBelong.executeSql("select count(resourceid) as hanum from VotingRemark where resourceid ="+userid+" and votingid=" + votingid);
						  if(rsBelong.next()){
							  int hanum=rsBelong.getInt("hanum");
							  if(hanum==2){
							     rsBelong.executeSql("delete from VotingRemark where resourceid ="+userid+" and votingid=" + votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
							     rsBelong.executeSql("delete from VotingResource where resourceid ="+userid+" and votingid=" + votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
							     rsBelong.executeSql("delete from VotingResourceRemark where resourceid ="+userid+" and votingid=" + votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
							  }
						 }
					}
				}
				status = 0;
			}
		}else if(operate.equals("getMyVotingData")){
			//获取我的投票情况 页面上需要先获取投票的详情展示出来，然后获取我的投票详情，使用JS将值填上

			//参见/voting/surverdesign/js/survey_wev8.js中的initSurvey和fillUserInput方法
			String votingid= Util.null2String(fu.getParameter("votingid"));
			String sql="select questiontype,isother,ismulti as type,questionid,value,isothervalue from ( "+
		   " select questionid,optionid as value, '0' as isothervalue from VotingResource where votingid='"+votingid+"' and resourceid='"+userid+"' "+
		   " union all "+
		   " select rr.questionid, rr.otherinput as value, case q.questiontype when '0' then case q.isother when 1 then '1' else '0' end else '0' end as isothervalue from VotingResourceRemark rr, VotingQuestion q where rr.questionid = q.id and rr.votingid = '"+votingid+"' and rr.resourceid='"+userid+"' "+
		   " )a inner join (select id,ismulti,isother,questiontype  from VotingQuestion) b  on a.questionid=b.id";
		   rs.execute(sql);
		   JSONArray userinputs=new JSONArray();
		   String qtype;
		   String qother;
		   String qdtype;
		   String qid;
		   String qvalue;
		   String isothervalue;
		   while(rs.next()){
			   JSONObject userinput = new JSONObject();
			   qtype=rs.getString("questiontype");
			   userinput.put("qtype",qtype);
			   qother=rs.getString("isother");
			   userinput.put("qother",qother);
			   qdtype=rs.getString("type");
			   userinput.put("qdtype",qdtype);
			   qid=rs.getString("questionid");
			   userinput.put("qid",qid);
			   qvalue=rs.getString("value");
			   userinput.put("qvalue",qvalue);
			   isothervalue = rs.getString("isothervalue");
			   userinput.put("isothervalue",isothervalue);
			   userinputs.add(userinput);
		   }
		   json.put("myVotingData", userinputs);
		   status = 0;
		}else if(operate.equals("getVotingResult")){//获取投票结果
			String votingid= Util.null2String(fu.getParameter("votingid"));
			List<List<Map<String,String>>>  rsallitems=new ArrayList<List<Map<String,String>>>();
			//获取每个问题选项所占的数量
			List<Map<String, String>> rsitem = VotingSearchResult.votingAllRs(votingid);
			rsallitems.add(rsitem);
			json.put("votersobj", rsallitems);
			//获取针对每个选项又那些人进行投票
			String sql="select optionid,a.resourceid,lastname,subcompanyid1,c.useranony  from VotingResource a "+
						"inner join HrmResource b on a.resourceid=b.id left join VotingRemark c "+
						"on a.votingid=c.votingid and a.resourceid=c.resourceid  where a.votingid='"+votingid+"' ";
		   	rs.execute(sql);
		   	Map<String,List<Map<String,String>>> optionvoters=new HashMap<String,List<Map<String,String>>>();
		   	List<Map<String,String>> voteitems;
		   	while(rs.next()){
			   	String opitem=rs.getString("optionid");
			   	String resourceid=rs.getString("resourceid");
			   	String lastname=rs.getString("lastname");
			   	String subcomid=rs.getString("subcompanyid1");
			   	String useranony=Util.null2String(rs.getString("useranony"));
			   	Map<String,String> voteitem=new HashMap<String,String>();
			   	voteitem.put("rid",resourceid);
			   	voteitem.put("name",lastname);
			   	voteitem.put("subcomid",subcomid);
			   	voteitem.put("useranony",useranony);
			   	if(!optionvoters.containsKey(opitem)){
				   	voteitems=new ArrayList<Map<String,String>>();
				   	optionvoters.put(opitem,voteitems);
			  	}
			   	voteitems=optionvoters.get(opitem);
			   	voteitems.add(voteitem);
		   	}
		   	json.put("optionvoters",optionvoters);
		  	//获取没有投票的人员信息

		    List<String> novotingperson = new ArrayList<String>();
		    Set undoUserSet = this.getUndoUserSet(votingid);
		    if(null!=undoUserSet&&undoUserSet.size()>0){
		    	for(Object id:undoUserSet){
		    		novotingperson.add(rc.getLastname((String)id));
			    }
		    }
		 	json.put("novotingperson",novotingperson);
		 	//获取已投票的人员信息
		    List<String> votingperson = new ArrayList<String>();
		    sql = "select lastname,id from hrmresource where status in(0,1,2,3) and "+
		    	  "	id in (select distinct resourceid from VotingRemark where votingid ="
		 		+ votingid + ")";
		    rs.execute(sql);
		 	while(rs.next()){
		 		votingperson.add(rs.getString("lastname"));
		 	}
		 	json.put("votingperson",votingperson);
		 	status = 0;
		} else if(operate.equals("getOtherInput")) {
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			String votingid= Util.null2String(fu.getParameter("votingid"));
			String questionid= Util.null2String(fu.getParameter("questionid"));
			String sql = "select distinct a.votingid, a.otherinput, b.lastname, a.useranony from VotingResourceRemark a, HrmResource b where a.votingid = '" + votingid + "' and a.questionid = '" + questionid + "' and a.resourceid = b.id order by votingid";
			rs.execute(sql);
			
			while(rs.next()){
			   	String opitem = rs.getString("otherinput");
			   	String lastname=rs.getString("lastname");

				if (rs.getInt("useranony") == 1) {
					lastname = "匿名";
				}
			   	Map<String, Object> map = new HashMap<String, Object>();
			   	map.put("otherinput", opitem);
			   	map.put("lastname", lastname);
			   	result.add(map);
		   	}
			json.put("result", result);
		 	status = 0;
		} else if(operate.equals("checkViewResultPermission")) {
			String votingid = Util.null2String(fu.getParameter("votingid"));
			boolean flag = hasViewResultRight(Integer.parseInt(userid), Integer.parseInt(votingid));
			json.put("flag", flag);
			status = 0;
		} else if(operate.equals("checkIsAnswered")) {
			String votingid = fu.getParameter("votingid");//调查id
			try{
				String sql = "select * from voting where id= "+votingid+" and (istemplate <> '1' or istemplate is null) and status = 1 ";
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm") ;
				String currentDate = sdf.format(new Date());
				String _begindate = "",_enddate = "";
				if(!"oracle".equals(rs.getDBType())){
					_begindate = "begindate+' '+begintime";
					_enddate = "enddate+' '+endtime";
				}else{
					_begindate = "CONCAT(CONCAT(begindate,' '),begintime)";
					_enddate = "CONCAT(CONCAT(enddate,' '),endtime)";
				}
				sql += " and ("+_begindate+") <='"+currentDate+"' and ("+_enddate+") >='"+currentDate+"'";
				rs.execute(sql);
				//System.out.println(sql);
				boolean ifEnd = true;
				if(rs.next()){
					ifEnd = false;
				}
				boolean flag = false;
				sql = "select * from VotingRemark where resourceid = '" + userid + "' and votingid='" + votingid + "'";
				rs.execute(sql);
	
				if(rs.next()) {
					flag = true;//该用户已参与过投票
	
				}
				if(ifEnd&&!flag){//已经结束并且没有投过票提示已结束
					msg = "投票已结束";
				}else{
					json.put("flag", flag);
					status = 0;
				}
			}catch(Exception e){
				msg = "获取是否作答程序出现异常:"+e.getMessage();
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		msg = e.getMessage();
	}
	json.put("status",status);
	json.put("msg",msg);
	//System.out.println(json.toString());
	out.println(json.toString());
%>

<%!
	private boolean hasViewResultRight(int userid,int votingid){
		boolean flag = false;
		try{
			//有权限查看投票结果的人为:
			//1.是投票创建人或者审核人
			//2.已经投过票并且设置了投票后可查看结果
			//3.在投票结果查看范围内的人员

			String sql = "select 1 from voting v where v.id = "+votingid+" and"+
					" ((createrid = "+userid+" or approverid ="+userid+") or" +
					" ((isSeeResult='' or isSeeResult is null) "+
					" and exists (select 1 from VotingRemark vr where vr.votingid = "+votingid+
					" and vr.resourceid = "+userid+")))";
			RecordSet rs = new RecordSet();
			rs.executeSql(sql);
			if(rs.next()){
				flag = true;
			}else{
				Set set = this.getHasViewRightUserSet(votingid+"");
				if(null!=set&&set.size()>0){
					if(set.contains(userid+"")){
						flag = true;
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return flag;
	}
	public Set getUndoUserSet(String votingid){
		RecordSet rs=new RecordSet();
		RecordSet rs2=new RecordSet();
		Set hrmIdSet=new HashSet();
		Map tmptmap=new HashMap();
		rs.executeSql("select resourceid from votingremark where votingid="+votingid);
		while(rs.next()){
			tmptmap.put(rs.getString("resourceid"),"");	
		}
		String hrmStatusSql = " and status in (0,1,2,3) ";
		String hrmStatusSql2 = " and a.status in (0,1,2,3) ";
		rs.executeSql("select * from votingshare where votingid="+votingid);
		while(rs.next()){
			String tmptsharetype = Util.null2String(rs.getString("sharetype"));
			int seclevel = Util.getIntValue(rs.getString("seclevel"),0);
			int seclevelmax = Util.getIntValue(rs.getString("seclevelmax"));
			String seclevelmaxstr="";
			String seclevelmaxstr2="";
			if(seclevelmax>0){
				seclevelmaxstr=" and seclevel<="+seclevelmax;	
				seclevelmaxstr2=" and a.seclevel<="+seclevelmax;	
			}
			String sql="";
			//人力资源1
			if(tmptsharetype.equals("1")){
				String tmptresourceid = rs.getString("resourceid");
				sql = "select id from hrmresource where id="+tmptresourceid+hrmStatusSql;
			}
			//分部2
			else if(tmptsharetype.equals("2")){
				int subcompanyid = Util.getIntValue(rs.getString("subcompanyid"),0);
				if(subcompanyid>0){
					sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+" and subcompanyid1="+subcompanyid+hrmStatusSql;	
				} else {
					sql = "select a.id from hrmresource a inner join HrmResourceVirtual b on a.id=b.resourceid where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.subcompanyid="+subcompanyid+hrmStatusSql2;	
				}
			}
			//部门3
			else if(tmptsharetype.equals("3")){
				int departmentid = Util.getIntValue(rs.getString("departmentid"),0);
				if(departmentid>0){
					sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+" and departmentid="+departmentid+hrmStatusSql;	
				} else {
					sql = "select a.id from hrmresource a inner join HrmResourceVirtual b on a.id=b.resourceid where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.departmentid="+departmentid+hrmStatusSql2;	
				}
			}
			//角色4
			else if(tmptsharetype.equals("4")){
				String roleid = rs.getString("roleid");
				String tmptrolelevel = rs.getString("rolelevel");
				sql = "select distinct a.id from hrmresource a join hrmrolemembers b on b.resourceid=a.id where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.roleid="+roleid+" and b.rolelevel>="+tmptrolelevel+hrmStatusSql2;
			}
			//所有人5
			else if(tmptsharetype.equals("5")){
				sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+hrmStatusSql;
			}
			//所有人5
			else if(tmptsharetype.equals("6")){
				String jobtitles=rs.getString("jobtitles");
				String joblevel=rs.getString("joblevel");
				String jobdepartment=rs.getString("jobdepartment");
				String jobsubcompany=rs.getString("jobsubcompany");
				String jobsql="";
				if(joblevel.equals("1")){
				  jobsql=" and  subcompanyid1="+jobsubcompany;
				}else if(joblevel.equals("2")){
				  jobsql=" and  departmentid="+jobdepartment;
				}
				sql = "select id from hrmresource where jobtitle="+jobtitles+jobsql+hrmStatusSql;
			}
			rs2.executeSql(sql);
			while(rs2.next()){
				String id =rs2.getString("id");
				if(tmptmap.containsKey(id)) continue;
				
				hrmIdSet.add(id);
			}	
		}
		return hrmIdSet;
	}
	 public Set getHasViewRightUserSet(String votingid){
    	RecordSet rs=new RecordSet();
    	RecordSet rs2=new RecordSet();
    	Set hrmIdSet=new HashSet();
    	String hrmStatusSql = " and status in (0,1,2,3) ";
		String hrmStatusSql2 = " and a.status in (0,1,2,3) ";
    	rs.executeSql("select * from VotingViewer where votingid="+votingid);
    	while(rs.next()){
    		String tmptsharetype = Util.null2String(rs.getString("sharetype"));
    		int seclevel = Util.getIntValue(rs.getString("seclevel"),0);
			int seclevelmax = Util.getIntValue(rs.getString("seclevelmax"));
			
			String seclevelmaxstr="";
			String seclevelmaxstr2="";
			if(seclevelmax>0){
				seclevelmaxstr=" and seclevel<="+seclevelmax;	
				seclevelmaxstr2=" and a.seclevel<="+seclevelmax;	
			}
    		String sql="";
    		//人力资源1
			if(tmptsharetype.equals("1")){
				String tmptresourceid = rs.getString("resourceid");
				sql = "select id from hrmresource where id="+tmptresourceid+hrmStatusSql;
			}
			//分部2
			else if(tmptsharetype.equals("2")){
				int subcompanyid = Util.getIntValue(rs.getString("subcompanyid"),0);
				if(subcompanyid>0){
					sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+" and subcompanyid1="+subcompanyid+hrmStatusSql;	
				} else {
					sql = "select a.id from hrmresource a inner join HrmResourceVirtual b on a.id=b.resourceid where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.subcompanyid="+subcompanyid+hrmStatusSql2;	
				}
			}
			//部门3
			else if(tmptsharetype.equals("3")){
				int departmentid = Util.getIntValue(rs.getString("departmentid"),0);
				if(departmentid>0){
					sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+" and departmentid="+departmentid+hrmStatusSql;	
				} else {
					sql = "select a.id from hrmresource a inner join HrmResourceVirtual b on a.id=b.resourceid where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.departmentid="+departmentid+hrmStatusSql2;	
				}
			}
			//角色4
			else if(tmptsharetype.equals("4")){
				String roleid = rs.getString("roleid");
				String tmptrolelevel = rs.getString("rolelevel");
				sql = "select distinct a.id from hrmresource a join hrmrolemembers b on b.resourceid=a.id where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.roleid="+roleid+" and b.rolelevel>="+tmptrolelevel+hrmStatusSql2;
			}
			//所有人5
			else if(tmptsharetype.equals("5")){
				sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+hrmStatusSql;
			}
			rs2.executeSql(sql);
			while(rs2.next()){
				String id =rs2.getString("id");
				hrmIdSet.add(id);
			}	
    	}
    	return hrmIdSet;
    }
	public Set getHasPollRightUserSet(String votingid){
	   	RecordSet rs=new RecordSet();
	   	RecordSet rs2=new RecordSet();
	   	Set hrmIdSet=new HashSet();
	   	String hrmStatusSql = " and status in (0,1,2,3) ";
		String hrmStatusSql2 = " and a.status in (0,1,2,3) ";
	   	rs.executeSql("select * from votingshare where votingid="+votingid);
	   	while(rs.next()){
	   		String tmptsharetype = Util.null2String(rs.getString("sharetype"));
	   		int seclevel = Util.getIntValue(rs.getString("seclevel"),0);
			int seclevelmax = Util.getIntValue(rs.getString("seclevelmax"));
			
			String seclevelmaxstr="";
			String seclevelmaxstr2="";
			if(seclevelmax>0){
				seclevelmaxstr=" and seclevel<="+seclevelmax;	
				seclevelmaxstr2=" and a.seclevel<="+seclevelmax;	
			}
	   		String sql="";
	   		//人力资源1
			if(tmptsharetype.equals("1")){
				String tmptresourceid = rs.getString("resourceid");
				sql = "select id from hrmresource where id="+tmptresourceid+hrmStatusSql;
			}
			//分部2
			else if(tmptsharetype.equals("2")){
				int subcompanyid = Util.getIntValue(rs.getString("subcompanyid"),0);
				if(subcompanyid>0){
					sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+" and subcompanyid1="+subcompanyid+hrmStatusSql;	
				} else {
					sql = "select a.id from hrmresource a inner join HrmResourceVirtual b on a.id=b.resourceid where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.subcompanyid="+subcompanyid+hrmStatusSql2;	
				}
			}
			//部门3
			else if(tmptsharetype.equals("3")){
				int departmentid = Util.getIntValue(rs.getString("departmentid"),0);
				if(departmentid>0){
					sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+" and departmentid="+departmentid+hrmStatusSql;	
				} else {
					sql = "select a.id from hrmresource a inner join HrmResourceVirtual b on a.id=b.resourceid where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.departmentid="+departmentid+hrmStatusSql2;	
				}
			}
			//角色4
			else if(tmptsharetype.equals("4")){
				String roleid = rs.getString("roleid");
				String tmptrolelevel = rs.getString("rolelevel");
				
				sql = "select distinct a.id from hrmresource a join hrmrolemembers b on b.resourceid=a.id where a.seclevel>="+seclevel+seclevelmaxstr2+" and b.roleid="+roleid+" and b.rolelevel>="+tmptrolelevel+hrmStatusSql2;
				
			}
			//所有人5
			else if(tmptsharetype.equals("5")){
				sql = "select id from hrmresource where seclevel>="+seclevel+seclevelmaxstr+hrmStatusSql;
			}

			//岗位6
			else if(tmptsharetype.equals("6")){
				String jobtitles=rs.getString("jobtitles");
				String joblevel=rs.getString("joblevel");
				String jobdepartment=rs.getString("jobdepartment");
				String jobsubcompany=rs.getString("jobsubcompany");
				String jobsql="";
				if(joblevel.equals("1")){
				  jobsql=" and  subcompanyid1="+jobsubcompany;
				}else if(joblevel.equals("2")){
				  jobsql=" and  departmentid="+jobdepartment;
				}
				sql = "select id from hrmresource where jobtitle="+jobtitles+jobsql+hrmStatusSql;
			}					
			rs2.executeSql(sql);
			while(rs2.next()){
				String id =rs2.getString("id");
				
				hrmIdSet.add(id);
			}	
	   	}
	   	return hrmIdSet;
	 }
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