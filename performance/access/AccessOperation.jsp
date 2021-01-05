<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.gp.util.RightUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
	String currentUserId = user.getUID()+"";
	String operation = Util.fromScreen3(request.getParameter("operation"),user.getLanguage());
	String resourceid = Util.fromScreen3(request.getParameter("resourceid"),user.getLanguage());
	
	if(operation.equals("save")||operation.equals("submit")){//保存及提交
		String scoreid = Util.fromScreen3(request.getParameter("scoreid"),user.getLanguage());
		//判断是否能考核评分
		rs.executeSql("select userid,year,type1,type2,status,operator,startdate,enddate,auditids from GP_AccessScore where id = "+scoreid);
		if(rs.next()){
			boolean canedit = true;
			String status = Util.null2String(rs.getString("status"));
			String currentoperator = Util.null2String(rs.getString("operator"));
			String startdate = Util.null2String(rs.getString("startdate"));
			String enddate = Util.null2String(rs.getString("enddate"));
			String auditids = Util.null2String(rs.getString("auditids"));
			String currentdate = TimeUtil.getCurrentDateString();
			if(TimeUtil.dateInterval(startdate,currentdate)<0 || TimeUtil.dateInterval(enddate,currentdate)>0){
				canedit = false;
			}
			if(!"0".equals(status)&&!"2".equals(status)){
				canedit = false;
			}
			if(!currentoperator.equals(currentUserId)){
				canedit = false;
			}
			if(!canedit){
				response.sendRedirect("/performance/util/Message.jsp?type=1");
				return;
			}
			//更新总分
			String score_result = Util.getDoubleValue(request.getParameter("score_result"),0)+"";
			rs.executeSql("update GP_AccessScore set result="+score_result+",isinit=0 where id="+scoreid);
			
			String checkid = "";
			int currentexeorder = 0;
			rs3.executeSql("select id,status,exeorder,userid from GP_AccessScoreCheck where scoreid="+scoreid);
			while(rs3.next()){
				String checkstatus = Util.null2String(rs3.getString("status"));
				int exeorder = Util.getIntValue(rs3.getString("exeorder"),0);
				if(operation.equals("submit")) checkstatus = "2";
				checkid = Util.null2String(rs3.getString(1));
				String exeuserid = Util.null2String(rs3.getString("userid"));
				String s_score = Util.getDoubleValue(request.getParameter("s_score_"+checkid),0)+"";
				String s_revise = Util.getDoubleValue(request.getParameter("s_revise_"+checkid),0)+"";
				String s_remark = Util.convertInput2DB(request.getParameter("s_remark_"+checkid));
				String s_result = Util.getDoubleValue(request.getParameter("s_result_"+checkid),0)+"";
				String fileids = Util.null2String(request.getParameter("newrelatedacc")).trim();
				String s_reason = Util.convertInput2DB(request.getParameter("s_reason_"+checkid));
				
				if(exeuserid.equals(currentUserId)){
					currentexeorder = exeorder;
					String edit_relatedacc=Util.null2String(request.getParameter("edit_relatedacc")).trim();
					if(edit_relatedacc.endsWith(",")) edit_relatedacc = edit_relatedacc.substring(0,edit_relatedacc.length()-1);
					String delrelatedacc =Util.fromScreen(request.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
			    	if(!edit_relatedacc.equals("")){
			    		fileids = edit_relatedacc + "," + fileids;//新附件id
			    	}
			   		if(fileids.endsWith(",")) fileids = fileids.substring(0,fileids.length()-1);
			   		if(!fileids.equals("")) fileids = "," + fileids + ",";
			   		//删除附件
			   		if(!delrelatedacc.equals("")){
			   			List delidList = Util.TokenizerString(delrelatedacc,",");
			   			for(int i=0;i<delidList.size();i++){
			   				int docid = Util.getIntValue((String)delidList.get(i),0);
			   				if(docid!=0){
			   					DocManager dm = new DocManager();
								dm.setId(docid);
								dm.setUserid(user.getUID());
								dm.DeleteDocInfo();
			   				}
			   			}
			   		}
					
					//保存人员评分信息
					rs.executeSql("update GP_AccessScoreCheck set score="+s_score+",revise="+s_revise+",remark='"+s_remark+"',result="+s_result+",status="+checkstatus+",fileids='"+fileids+"',reason='"+s_reason+"' where id="+checkid);
					
					//保存人员评分明细
					String detailid = "";
					String accessitemid = "";
					String target = "";
					String target1 = "";
					String target2 = "";
					String result = "";
					String result1 = "";
					String result2 = "";
					String next = "";
					String next1 = "";
					String next2 = "";
					String d_score = "";
					String d_result = "";
					String d_remark = "";
					rs.executeSql("delete from GP_AccessScoreCheckDetail where scoreid="+scoreid+" and checkid="+checkid);
					rs.executeSql("select t.id,t.accessitemid,t.rate from GP_AccessScoreDetail t where t.scoreid="+scoreid);
					while(rs.next()){
						detailid = Util.null2String(rs.getString("id"));
						accessitemid = Util.null2String(rs.getString("accessitemid"));
						target = Util.null2String(request.getParameter("target_"+detailid));
						result = Util.null2String(request.getParameter("result_"+detailid));
						next = Util.null2String(request.getParameter("next_"+detailid));
						if("1".equals(AccessItemComInfo.getType(accessitemid))){
							target1 = "0";
							target2 = target;
							result1 = "0";
							result2 = result;
							next1 = "0";
							next2 = next;
			        	}else{
			        		target1 = Util.getDoubleValue(target,0)+"";
							target2 = "";
			        		result1 = Util.getDoubleValue(result,0)+"";
			        		result2 = "";
			        		next1 = Util.getDoubleValue(next,0)+"";
			        		next2 = "";
			        	}
						//更新目标值、完成值、下月目标值
						rs2.executeSql("update GP_AccessScoreDetail set target1="+target1+",target2='"+target2+"',result1="+result1+",result2='"+result2+"',next1="+next1+",next2='"+next2+"' where id="+detailid);
						//更新评分明细
						d_score = Util.getDoubleValue(request.getParameter("d_score_"+detailid+"_"+checkid),0)+"";
						d_result = Util.getDoubleValue(request.getParameter("d_result_"+detailid+"_"+checkid),0)+"";
						d_remark = Util.convertInput2DB(request.getParameter("d_remark_"+detailid+"_"+checkid));
						rs2.executeSql("insert into GP_AccessScoreCheckDetail (scoreid,detailid,checkid,score,result,remark)"
								+" values("+scoreid+","+detailid+","+checkid+","+d_score+","+d_result+",'"+d_remark+"')");
					}
				}else{
					//保存人员评分信息
					rs.executeSql("update GP_AccessScoreCheck set score="+s_score+",result="+s_result+" where id="+checkid);
					//更新其他人员的评分明细
					String detailid = "";
					String accessitemid = "";
					String cdid = "";
					String d_score = "";
					String d_result = "";
					//rs.executeSql("delete from GP_AccessScoreCheckDetail where scoreid="+scoreid+" and checkid="+checkid);
					rs.executeSql("select t.id,t.accessitemid,t.rate from GP_AccessScoreDetail t where t.scoreid="+scoreid);
					while(rs.next()){
						detailid = Util.null2String(rs.getString("id"));
						accessitemid = Util.null2String(rs.getString("accessitemid"));
						if(Util.getIntValue(AccessItemComInfo.getFormula(accessitemid),0)!=0){
							//更新评分明细
							d_score = Util.getDoubleValue(request.getParameter("d_score_"+detailid+"_"+checkid),0)+"";
							d_result = Util.getDoubleValue(request.getParameter("d_result_"+detailid+"_"+checkid),0)+"";
							cdid = Util.null2String(request.getParameter("cdid_"+detailid+"_"+checkid));
							if(cdid.equals("")){
								rs2.executeSql("insert into GP_AccessScoreCheckDetail (scoreid,detailid,checkid,score,result,remark)"
										+" values("+scoreid+","+detailid+","+checkid+","+d_score+","+d_result+",'')");
							}else{
								rs2.executeSql("update GP_AccessScoreCheckDetail set score="+d_score+",result="+d_result+" where id="+cdid);
							}
							
						}
					}
				}
			}
			
			if(operation.equals("save")) {
				OperateUtil.addScoreLog(currentUserId,scoreid,2);
				//增加日志总分记录
				rs.executeSql("select max(id) from GP_AccessScoreLog where operator="+currentUserId+" and scoreid="+scoreid+" and operatetype=2");
				if(rs.next()){
					String logid = Util.null2String(rs.getString(1));
					rs.executeSql("update GP_AccessScoreLog set result="+score_result+" where id="+logid);
				}
			}
			
			//考核提交
		    if(operation.equals("submit")){
		    	//更新主信息是否第一评分人
	    		rs.executeSql("update GP_AccessScore set isfirst=0,status=0 where id="+scoreid);
		    	OperateUtil.addScoreLog(currentUserId,scoreid,3);
		    	//增加日志总分记录
				rs.executeSql("select max(id) from GP_AccessScoreLog where operator="+currentUserId+" and scoreid="+scoreid+" and operatetype=3");
				if(rs.next()){
					String logid = Util.null2String(rs.getString(1));
					rs.executeSql("update GP_AccessScoreLog set result="+score_result+" where id="+logid);
				}
		    	
		    	//判断是否还有考核人
		    	rs.executeSql("select id,userid,status,exeorder from GP_AccessScoreCheck where scoreid="+scoreid+" and exeorder="+(currentexeorder+1));
		    	if(rs.next()){
		    		//更新下一考核人状态
		    		String nextcheckid = Util.null2String(rs.getString("id"));
		    		String nextcheckuser = Util.null2String(rs.getString("userid"));
		    		rs.executeSql("update GP_AccessScoreCheck set status=1 where id="+nextcheckid);
		    		//更新当前评分人ID
		    		rs.executeSql("update GP_AccessScore set operator="+nextcheckuser+" where id="+scoreid);
		    	}else{
		    		//更新当前评分人ID
		    		rs.executeSql("update GP_AccessScore set operator=0 where id="+scoreid);
		    		//提交审批，读取成绩审批人
		    		String accessconfirm = "";
		    		List auditidList = new ArrayList();
			    	rs.executeSql("select accessconfirm from GP_BaseSetting where resourceid=" + ResourceComInfo.getDepartmentID(resourceid) + " and resourcetype=3");
			    	if(rs.next()){
			    		accessconfirm += Util.null2String(rs.getString("accessconfirm"));
			    	}else{
			    		rs.executeSql("select accessconfirm from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
			    		if(rs.next()){
			    			accessconfirm += Util.null2String(rs.getString("accessconfirm"));
			    		}
			    	}
			    	List auditidList2 = Util.TokenizerString(auditids,",");
			    	List auditidList3 = Util.TokenizerString(accessconfirm,",");
			    	String auditid = "";
			    	String remindids = "";//需要提醒的审批人
			    	for(int i=0;i<auditidList2.size();i++){
			    		auditid = (String)auditidList2.get(i);
			    		if(auditid.equals("-1")) auditid = ResourceComInfo.getManagerID(ResourceComInfo.getManagerID(resourceid));
			    		if(!"".equals(auditid) && OperateUtil.isWork(auditid) && auditidList.indexOf(auditid)<0){
			    			auditidList.add(auditid);
			    			remindids += "," + auditid;
			    		}
			    	}
			    	for(int i=0;i<auditidList3.size();i++){
			    		auditid = (String)auditidList3.get(i);
			    		if(auditid.equals("-1")) auditid = ResourceComInfo.getManagerID(ResourceComInfo.getManagerID(resourceid));
			    		if(!"".equals(auditid) && OperateUtil.isWork(auditid) && auditidList.indexOf(auditid)<0){
			    			auditidList.add(auditid);
			    		}
			    	}
			    	//更新需提醒的人员id
			    	if(!remindids.equals("")) remindids += ",";
			    	rs.executeSql("update GP_AccessScore set remindids='"+remindids+"' where id="+scoreid);
			    		
			    	if(auditidList.size()==0){
		    			//无审批人则系统自动审批通过
		    			OperateUtil.approveScore(scoreid,"0");
		    		}else{
		    			//更改状态为审批中
		    			rs.executeSql("update GP_AccessScore set status=1 where id="+scoreid);
		    			boolean autoAudit = false;//标记是否要自动审批
		    			for(int i=0;i<auditidList.size();i++){
		    				auditid = (String)auditidList.get(i);
		    				if(!"".equals(auditid)){
		    					if(currentUserId.equals(auditid)) autoAudit = true;//如果审批人中有当前用户则标记需要直接审批
		    					rs.executeSql("insert into GP_AccessScoreAudit (scoreid,userid) values("+scoreid+","+auditid+")");
		    				}
		    			}
		    			if(autoAudit) OperateUtil.approveScore(scoreid,currentUserId);
		    		}	
		    	}
		    }
		}
	    
		response.sendRedirect("AccessView.jsp?islog=0&isrefresh=1&scoreid="+scoreid);
	    return;
	}else if(operation.equals("approve")||operation.equals("return")){//批准及退回
		String scoreid = Util.fromScreen3(request.getParameter("scoreid"),user.getLanguage());
		if(!RightUtil.isCanAuditScore(scoreid,currentUserId)){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		if(operation.equals("approve")){
			OperateUtil.approveScore(scoreid,currentUserId);
		}else{
			OperateUtil.returnScore(scoreid,currentUserId);
		}
		response.sendRedirect("AccessView.jsp?islog=0&isrefresh=1&scoreid="+scoreid);
	    return;
	}else if(operation.equals("quick_approve")||operation.equals("quick_return")){
		String scoreids = Util.fromScreen3(request.getParameter("scoreids"),user.getLanguage());
		List scoreidList = Util.TokenizerString(scoreids,",");
		String scoreid = "";
		for(int i=0;i<scoreidList.size();i++){
			scoreid = (String)scoreidList.get(i);
			if(RightUtil.isCanAuditScore(scoreid,currentUserId)){
				if(operation.equals("quick_approve")){
					OperateUtil.approveScore(scoreid,currentUserId);
				}else{
					OperateUtil.returnScore(scoreid,currentUserId);
				}
			}
		}
	    return;
	}else if(operation.equals("init")){//重置考核项及结果
		String scoreid = Util.fromScreen3(request.getParameter("scoreid"),user.getLanguage());
		if(!RightUtil.isCanInitScore(scoreid,currentUserId)){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		String newscoreid = OperateUtil.resetScore(scoreid,currentUserId);
		response.sendRedirect("AccessView.jsp?islog=0&isrefresh=1&scoreid="+newscoreid);
	    return;
	}else if(operation.equals("score_return")){//考核中退回
		String scoreid = Util.fromScreen3(request.getParameter("scoreid"),user.getLanguage());
		if(!RightUtil.isCanScoreReturn(scoreid,currentUserId)){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		OperateUtil.returnScore(scoreid,currentUserId);
		response.sendRedirect("AccessView.jsp?islog=0&isrefresh=1&scoreid="+scoreid);
	    return;
	}else if(operation.equals("reset")){//重新考核评分
		String scoreid = Util.fromScreen3(request.getParameter("scoreid"),user.getLanguage());
		if(!RightUtil.isCanResetScore(scoreid,currentUserId)){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		rs.executeSql("select t2.id,t2.exeorder from GP_AccessScore t1,GP_AccessScoreCheck t2 where t1.id=t2.scoreid and (t1.status=1 or t1.status=3) and t1.id="+scoreid+" and t2.userid="+currentUserId);
		if(rs.next()){
			String checkid = Util.null2String(rs.getString("id"));
			int exeorder = Util.getIntValue(rs.getString("exeorder"),0);
			int isfirst = 0;
			if(exeorder==0) isfirst = 1;
			rs.executeSql("delete from GP_AccessScoreAudit where scoreid="+scoreid);
			rs.executeSql("update GP_AccessScore set isrescore=1,status=0,isfirst="+isfirst+",operator="+currentUserId+",remindids='' where id="+scoreid);
			rs.executeSql("update GP_AccessScoreCheck set status=1 where scoreid="+scoreid+" and id="+checkid);
			rs.executeSql("update GP_AccessScoreCheck set status=0 where exeorder>"+exeorder+" and scoreid="+scoreid);
			OperateUtil.addScoreLog(currentUserId, scoreid, 6);
		}else{
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		response.sendRedirect("AccessView.jsp?islog=0&isrefresh=1&scoreid="+scoreid);
	    return;
	}else if("add_exchange".equals(operation)){//添加交流
		String scoreid = Util.fromScreen3(request.getParameter("scoreid"),user.getLanguage());
		String content = Util.convertInput2DB(URLDecoder.decode(request.getParameter("content"),"utf-8"));
		if(!scoreid.equals("") && !content.equals("")){
			//判断是否可查看此考核结果
			String currentuserid = user.getUID()+"";
			if(RightUtil.isCanViewScore(scoreid,currentuserid)){
				StringBuffer restr = new StringBuffer();
				String currentDate = TimeUtil.getCurrentDateString();
				String currentTime = TimeUtil.getOnlyCurrentTimeString();
				String sql = "insert into GP_AccessScoreExchange (scoreid,content,operator,operatedate,operatetime)"
					+" values("+scoreid+",'"+content+"',"+user.getUID()+",'"+currentDate+"','"+currentTime+"')";
				rs.executeSql(sql);
				restr.append("<div class='exchange_title'>"+cmutil.getPerson(user.getUID()+"")+"&nbsp;"+currentDate+"&nbsp;"+currentTime+"</div>"
							+"<div class='exchange_content'>"+Util.toHtml(content)+"</div>");
				out.print(restr.toString());
				//out.close();
			}
		}
	}else if(operation.equals("all_approve")||operation.equals("all_return")){
		int showtype = Util.getIntValue(request.getParameter("showtype"),0);
		String type1 = Util.null2String(request.getParameter("type1"));
		String currentdate = TimeUtil.getCurrentDateString();
		String hrmids = Util.fromScreen3(request.getParameter("hrmids"),user.getLanguage());
		
		String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
		String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
					
		String backfields = "select t.id from GP_AccessScore t,HrmResource h  ";
		String sqlWhere = " where t.isvalid=1 and t.status<>3 and t.userid=h.id and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
		 	+" and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":"")
			+" and (t.operator="+currentUserId+" or exists(select 1 from GP_AccessScoreAudit aa where aa.scoreid=t.id and aa.userid="+currentUserId+"))";
		if(!hrmids.equals("")){
			sqlWhere += " and t.userid in ("+hrmids+")";
		}
		if(!type1.equals("")){
			sqlWhere += " and t.type1 =" + type1;
		}
		if(showtype==1){
			sqlWhere += " and (t.status=0 or t.status=2)";
		}
		if(showtype==2){
			sqlWhere += " and t.status=1";
		}
		int includesub = Util.getIntValue(request.getParameter("includesub"),3);
		if(!subcompanyids.equals("")&&!subcompanyids.equals("0")){//分部ID
			 if(includesub==2){
				String subCompanyIds = "";
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubCompanyLists(subcompanyids,list);
				for(int i=0;i<list.size();i++){
					subCompanyIds += ","+(String)list.get(i);
				}
				if(list.size()>0)subCompanyIds = subCompanyIds.substring(1);
				
				sqlWhere += " and h.subcompanyid1 in ("+subCompanyIds+")";
				
			}else if(includesub==3){
				String subCompanyIds = subcompanyids;
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubCompanyLists(subcompanyids,list);
				for(int i=0;i<list.size();i++){
					subCompanyIds += ","+(String)list.get(i);
				}

				sqlWhere += " and h.subcompanyid1 in ("+subCompanyIds+")";
			}else{
				sqlWhere += " and h.subcompanyid1 in ("+subcompanyids+")";
			}
		}
		int includedept = Util.getIntValue(request.getParameter("includedept"),3);
		if(!departmentids.equals("") && !"0".equals(departmentids)){//部门ID
			if(includedept==2){
				String departmentIds = "";
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubDepartmentLists(departmentids,list);
				for(int i=0;i<list.size();i++){
					departmentIds += ","+(String)list.get(i);
				}
				if(list.size()>0) departmentIds = departmentIds.substring(1);

				sqlWhere += " and h.departmentid in ("+departmentIds+")";
			}else if(includedept==3){
				String departmentIds = departmentids;
				ArrayList list = new ArrayList();
				SubCompanyComInfo.getSubDepartmentLists(departmentids,list);
				for(int i=0;i<list.size();i++){
					departmentIds += ","+(String)list.get(i);
				}

				sqlWhere += " and h.departmentid in ("+departmentIds+")";
			}else{
				sqlWhere += " and h.departmentid in ("+departmentids+")";
			}
		}
		
		rs.executeSql(backfields+sqlWhere);
		int totalcount = 0; 
		while(rs.next()){
			String id = Util.null2String(rs.getString("id"));
			if(RightUtil.isCanAuditScore(id,currentUserId)){
				if(operation.equals("all_approve")){
					OperateUtil.approveScore(id,currentUserId);
				}else{
					OperateUtil.returnScore(id,currentUserId);
				}
				totalcount++;
			}
		}
		out.print(totalcount);
	    return;
	}
	//获取更多操作日志
	if("get_more_log".equals(operation)){
		String scoreid = Util.null2String(request.getParameter("scoreid"));
		if(!RightUtil.isCanViewScore(scoreid,user.getUID()+"")) return;
		
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		
		String orderby1 = " order by operatedate desc,operatetime desc,id desc";
		String orderby2 = " order by operatedate asc,operatetime asc,id asc";
		String orderby3 = " order by operatedate desc,operatetime desc,id desc";
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		String querysql = " id,operator,operatedate,operatetime,operatetype,result from GP_AccessScoreLog where scoreid="+ scoreid;
		//String sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql + orderby3 + ") A "+orderby2;
		//sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		String sql = "";
		if("oracle".equals(rs.getDBType())){
			sql = "select " + querysql+ orderby3;
			sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + (iNextNum);
			sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum - pagesize);
		}else{
			sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
			sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		}
		
		rs.executeSql(sql);
		String logoperator = "";
		String operatetype = "";
		String logresult = "";
		while (rs.next()) {
			logresult = Util.null2String(rs.getString("result"));
			logoperator = Util.null2String(rs.getString("operator"));
			operatetype = Util.null2String(rs.getString("operatetype"));
			if(logoperator.equals("0")){
				logoperator = "系统";
			}else{
				logoperator = cmutil.getPerson(logoperator);
			}
%>
	<div style="color: #808080;">
		<%=logoperator %>
		&nbsp;&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>&nbsp;&nbsp;&nbsp;<%=operatetype.equals("0")?"查看":cmutil.getSocreOperateType(rs.getString("operatetype")) %>
		<%if(!logresult.equals("")){ %>&nbsp;&nbsp;&nbsp;最终得分：<%=logresult%><%} %>
	</div>
<%
		}
	}
%>
