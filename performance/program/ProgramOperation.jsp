<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.gp.util.RightUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String sql = "";
	String currentUserId = user.getUID()+"";
	String operation = Util.fromScreen3(request.getParameter("operation"),user.getLanguage());
	String resourceid = Util.fromScreen3(request.getParameter("resourceid"),user.getLanguage());
	
	//保存及提交
	if(operation.equals("save")||operation.equals("submit") || "forbidden".equals(operation) || "start".equals(operation)){
		if(RightUtil.getProgramRight(resourceid,currentUserId)<2){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		String programid = Util.fromScreen3(request.getParameter("programid"),user.getLanguage());
		String programtype = Util.fromScreen3(request.getParameter("programtype"),user.getLanguage());
		String startdate = Util.fromScreen3(request.getParameter("startdate"),user.getLanguage());
		String auditids = Util.fromScreen3(request.getParameter("auditids"),user.getLanguage());
		String programname = ResourceComInfo.getLastname(resourceid);
		String remark = Util.null2String(request.getParameter("remark"));
		String status = "0";
		if(operation.equals("submit")) status = "1";
		if(operation.equals("forbidden")) status = "13";
		if(programtype.equals("1")) programname += "月度";
		if(programtype.equals("2")) programname += "季度";
		if(programtype.equals("3")) programname += "半年度";
		if(programtype.equals("4")) programname += "年度";
		programname += "考核方案"+startdate;
		if(!programid.equals("")){
			//判断是否是可编辑状态,审批中不能编辑
			rs.executeSql("select status from GP_AccessProgram where id = "+programid);
			if(rs.next()){
				if("1".equals(rs.getString(1))){
					response.sendRedirect("/notice/noright.jsp");
					return; 
				}
			}
			sql = "update GP_AccessProgram set programname='"+programname+"',userid="+resourceid+",startdate='"+startdate+"',programtype="+programtype+",status="+status+",auditids='"+auditids+"',remark='"+remark+"' where id="+programid;
			rs.executeSql(sql);
			if(operation.equals("save")) OperateUtil.addProgramLog(currentUserId,programid,2);
			if(operation.equals("forbidden")) OperateUtil.addProgramLog(currentUserId,programid,13);
			if(operation.equals("start")) OperateUtil.addProgramLog(currentUserId,programid,14);
		}else{
			sql = "insert into GP_AccessProgram(programname,userid,startdate,programtype,status,auditids,remark) values('"+programname+"',"+resourceid+",'"+startdate+"',"+programtype+","+status+",'"+auditids+"','"+remark+"')";
			boolean flag = rs.executeSql(sql);
			if(flag){
				rs.executeSql("select max(id) from GP_AccessProgram t where t.userid ="+resourceid+" and t.programtype ="+programtype);
				if(rs.next()){
					programid = Util.null2String(rs.getString(1));
					OperateUtil.addProgramLog(currentUserId,programid,1);
				}
			}else{
				response.sendRedirect("../util/Message.jsp?type=3") ;
				return;
			}
		}
		//保存考核明细
		rs.executeSql("delete from GP_AccessProgramDetail where programid = "+programid);
		String rownumber1 = Util.fromScreen3(request.getParameter("indexnum"),user.getLanguage());
	    int rownum1 = 0;
	    if(rownumber1 != null && !"".equals(rownumber1)){
	    	rownum1 = Integer.parseInt(rownumber1);
	    }
	    String cate = "";
	    String accessitemid = "";
	    String desc = "";
	    String rate = "";
	    String target = "";
	    String target1 = "";
	    String target2 = "";
	    for(int i = 0;i<rownum1;i++){
	        cate = Util.convertInput2DB(request.getParameter("cate_"+i));
	        accessitemid = Util.fromScreen3(request.getParameter("accessitemid_"+i),user.getLanguage());
	        desc = Util.convertInput2DB(request.getParameter("desc_"+i));
	        rate = Util.getDoubleValue(request.getParameter("rate_"+i),0)+"";
	        target = Util.fromScreen3(request.getParameter("target_"+i),user.getLanguage());
	        if(!"".equals(accessitemid)){
	        	if("1".equals(AccessItemComInfo.getType(accessitemid))){
	        		target1 = "0";
	        		target2 = target;
	        	}else{
	        		target1 = Util.getDoubleValue(target,0)+"";
	        		target2 = "";
	        	}
	        	sql = "insert into GP_AccessProgramDetail(programid,cate,accessitemid,description,rate,target1,target2)"
	        		+" values("+programid+",'"+cate+"',"+accessitemid+",'"+desc+"',"+rate+","+target1+",'"+target2+"')";
				rs.executeSql(sql);
	        }
	  	}
	  	//保存考核流程
		rs.executeSql("delete from GP_AccessProgramCheck where programid = "+programid);
		String rownumber2 = Util.fromScreen3(request.getParameter("indexnum2"),user.getLanguage());
	    int rownum2 = 0;
	    if(rownumber2 != null && !"".equals(rownumber2)){
	    	rownum2 = Integer.parseInt(rownumber2);
	    }
	    String userid = "";
	    String crate = "";
	    int exeorder = 0;
	    for(int i = 0;i<rownum2;i++){
	    	userid = Util.fromScreen3(request.getParameter("userid_"+i),user.getLanguage());
	        crate = Util.getDoubleValue(request.getParameter("crate_"+i),0)+"";
	        if(!"".equals(userid)){
	        	sql = "insert into GP_AccessProgramCheck(programid,userid,rate,exeorder)"
	        		+" values("+programid+","+userid+","+crate+","+exeorder+")";
				rs.executeSql(sql);
				exeorder++;
	        }
	  	}
	    
	    //提交审批
	    if(operation.equals("submit")){
	    	OperateUtil.addProgramLog(currentUserId,programid,3);
	    	String programaudit = "";
	    	int manageraudit = 0;
	    	rs.executeSql("select * from GP_BaseSetting where (resourceid="+SubCompanyComInfo.getCompanyid(ResourceComInfo.getSubCompanyID(resourceid))+" and resourcetype=1) or (resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2) or (resourceid=" + ResourceComInfo.getDepartmentID(resourceid) + " and resourcetype=3) order by resourcetype desc");
	    	if(rs.next()){
	    		programaudit = Util.null2String(rs.getString("programaudit"));
	    		manageraudit = Util.getIntValue(rs.getString("manageraudit"),0);
	    		if(manageraudit==1){//直接上级审批
	    			String managerid =  ResourceComInfo.getManagerID(resourceid);
	    			if(programaudit.equals("")){
	    				programaudit = managerid;
	    			}else{
	    				if(programaudit.indexOf(","+managerid+",")<0){
	    					programaudit += "," + managerid;
	    				}
	    			}
	    		}
	    		List auditidList = new ArrayList();
	    		List auditidList2 = Util.TokenizerString(programaudit,",");
		    	String auditid = "";
		    	for(int i=0;i<auditidList2.size();i++){
		    		auditid = (String)auditidList2.get(i);
		    		if(!"".equals(auditid) && OperateUtil.isWork(auditid)){
		    			auditidList.add(auditid);
		    		}
		    	}
	    		if(auditidList.size()==0){
	    			//无审批人则系统自动审批通过
	    			OperateUtil.approveProgram(programid,"0");
	    		}else{
	    			for(int i=0;i<auditidList.size();i++){
	    				auditid = (String)auditidList.get(i);
	    				if(!"".equals(auditid)){
	    					if(!currentUserId.equals(auditid)){
		    					rs.executeSql("insert into GP_AccessProgramAudit (programid,userid) values("+programid+","+auditid+")");
		    				}else{
		    					OperateUtil.approveProgram(programid,currentUserId);
		    				}
	    				}
	    			}
	    		}
	    	}
	    }
	    
	    
	    response.sendRedirect("ProgramView.jsp?isrefresh=1resourceid="+resourceid+"&programid="+programid+"&programtype="+programtype);
	    return;
	}else if(operation.equals("approve")||operation.equals("return")){
		String programid = Util.fromScreen3(request.getParameter("programid"),user.getLanguage());
		if(!RightUtil.isCanAuditProgram(programid,currentUserId)){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		if(operation.equals("approve")){
			OperateUtil.approveProgram(programid,currentUserId);
		}else{
			OperateUtil.returnProgram(programid,currentUserId);
		}
		response.sendRedirect("ProgramView.jsp?isrefresh=1&resourceid="+resourceid+"&programid="+programid);
	    return;
	}else if(operation.equals("quick_approve")||operation.equals("quick_return")){
		String programids = Util.fromScreen3(request.getParameter("programids"),user.getLanguage());
		List programidList = Util.TokenizerString(programids,",");
		String programid = "";
		for(int i=0;i<programidList.size();i++){
			programid = (String)programidList.get(i);
			if(RightUtil.isCanAuditProgram(programid,currentUserId)){
				if(operation.equals("quick_approve")){
					OperateUtil.approveProgram(programid,currentUserId);
				}else{
					OperateUtil.returnProgram(programid,currentUserId);
				}
			}
		}
	    return;
	}else if(operation.equals("all_approve")||operation.equals("all_return")){ //批准全部和退回全部
		String programtype = Util.getIntValue(request.getParameter("programtype"),0)+"";
		String programname = Util.fromScreen3(request.getParameter("programname"),user.getLanguage());
		String hrmids = Util.fromScreen3(request.getParameter("hrmids"),user.getLanguage());
		String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
		String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
		String backfields = " select t1.id from GP_AccessProgram t1,GP_AccessProgramAudit t2,HrmResource h ";
		String sqlWhere = " where t1.id=t2.programid and t1.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":"")+" and t2.userid="+currentUserId;
		if(!programtype.equals("0")){
			sqlWhere += " and t1.programtype ="+programtype;
		}
		if(!programname.equals("")){
			sqlWhere += " and t1.programname like '%"+programname+"%'";
		}
		if(!hrmids.equals("")){
			sqlWhere += " and t1.userid in ("+hrmids+")";
		}
		if (!subcompanyids.equals("") && !"0".equals(subcompanyids)) {
			sqlWhere += " and h.subcompanyid1 in ("+subcompanyids+")";
		}
		if (!departmentids.equals("") && !"0".equals(departmentids)) {
			sqlWhere += " and h.departmentid in ("+departmentids+")";
		}
		rs.executeSql(backfields+sqlWhere);
		int totalcount = 0; 
		while(rs.next()){
			String id = Util.null2String(rs.getString("id"));
			if(RightUtil.isCanAuditProgram(id,currentUserId)){
				if(operation.equals("all_approve")){
					OperateUtil.approveProgram(id,currentUserId);
				}else{
					OperateUtil.returnProgram(id,currentUserId);
				}
				totalcount++;
			}
		}
		out.print(totalcount);
	    return;
	}else if(operation.equals("quote")){//引用
		if(RightUtil.getProgramRight(resourceid,currentUserId)<2){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		String quoteid = Util.fromScreen3(request.getParameter("quoteid"),user.getLanguage());
		String programid = Util.fromScreen3(request.getParameter("programid"),user.getLanguage());
		String programtype = Util.fromScreen3(request.getParameter("programtype"),user.getLanguage());
		String startdate = "";
		String programname = ResourceComInfo.getLastname(resourceid);
		String status = "0";
		String auditids = "";
		String remark = "";
		if(programtype.equals("1")) programname += "月度";
		if(programtype.equals("2")) programname += "季度";
		if(programtype.equals("3")) programname += "半年度";
		if(programtype.equals("4")) programname += "年度";
		if(!quoteid.equals("")){
			rs.executeSql("select startdate,auditids,remark from GP_AccessProgram where id="+quoteid);
			if(rs.next()){
				startdate = Util.null2String(rs.getString(1));
				auditids = Util.null2String(rs.getString(2));
				remark = Util.null2String(rs.getString(3));
			}
			programname += "考核方案"+startdate;
			if(!programid.equals("")){
				//判断是否是可编辑状态,审批中不能编辑
				rs.executeSql("select status from GP_AccessProgram where id = "+programid);
				if(rs.next()){
					if("1".equals(rs.getString(1))){
						response.sendRedirect("/notice/noright.jsp");
						return;
					}
				}
				sql = "update GP_AccessProgram set programname='"+programname+"',startdate='"+startdate+"',status="+status+",auditids='"+auditids+"',remark='"+remark+"' where id="+programid;
				rs.executeSql(sql);
				OperateUtil.addProgramLog(currentUserId,programid,2);
			}else{
				sql = "insert into GP_AccessProgram(programname,userid,startdate,programtype,status,auditids,remark) values('"+programname+"',"+resourceid+",'"+startdate+"',"+programtype+","+status+",'"+auditids+"','"+remark+"')";
				rs.executeSql(sql);
				rs.executeSql("select max(id) from GP_AccessProgram");
				if(rs.next()){
					programid = Util.null2String(rs.getString(1));
					OperateUtil.addProgramLog(currentUserId,programid,1);
				}
			}
			//保存考核明细
			rs.executeSql("delete from GP_AccessProgramDetail where programid = "+programid);
			rs.executeSql("select cate,accessitemid,description,rate,target1,target2 from GP_AccessProgramDetail where programid="+quoteid+" order by id");
		    String cate = "";
		    String accessitemid = "";
		    String desc = "";
		    String rate = "";
		    String target1 = "";
		    String target2 = "";
		    while(rs.next()){
		        cate = Util.null2String(rs.getString("cate"));
		        accessitemid = Util.null2String(rs.getString("accessitemid"));
		        desc = Util.null2String(rs.getString("description"));
		        rate = Util.getDoubleValue(rs.getString("rate"),0)+"";
		        target1 = Util.null2String(rs.getString("target1"));
		        target2 = Util.null2String(rs.getString("target2"));
		        if(!"".equals(accessitemid)){
		        	sql = "insert into GP_AccessProgramDetail(programid,cate,accessitemid,description,rate,target1,target2)"
		        		+" values("+programid+",'"+cate+"',"+accessitemid+",'"+desc+"',"+rate+","+target1+",'"+target2+"')";
					rs.executeSql(sql);
		        }
		  	}
		  	//保存考核流程
			rs.executeSql("delete from GP_AccessProgramCheck where programid = "+programid);
			rs.executeSql("select userid,rate from GP_AccessProgramCheck where programid="+quoteid);
		    String userid = "";
		    String crate = "";
		    int exeorder = 0;
		    while(rs.next()){
		    	userid = Util.null2String(rs.getString("userid"));
		        crate = Util.getDoubleValue(rs.getString("rate"),0)+"";
		        if(!"".equals(userid)){
		        	sql = "insert into GP_AccessProgramCheck(programid,userid,rate,exeorder)"
		        		+" values("+programid+","+userid+","+crate+","+exeorder+")";
					rs.executeSql(sql);
					exeorder++;
		        }
		  	}
		}
		response.sendRedirect("ProgramView.jsp?resourceid="+resourceid+"&programid="+programid+"&programtype="+programtype);
	    return;
	}else if(operation.equals("quoteindex")){
		if(RightUtil.getProgramRight(resourceid,currentUserId)<2){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		String quoteid = Util.fromScreen3(request.getParameter("quoteid"),user.getLanguage());
		String programid = Util.fromScreen3(request.getParameter("programid"),user.getLanguage());
		String programtype = Util.fromScreen3(request.getParameter("programtype"),user.getLanguage());
		String startdate = Util.fromScreen3(request.getParameter("startdate"),user.getLanguage());
		String programname = ResourceComInfo.getLastname(resourceid);
		String status = "0";
		String remark = "";
		if(programtype.equals("1")) programname += "月度";
		if(programtype.equals("2")) programname += "季度";
		if(programtype.equals("3")) programname += "半年度";
		if(programtype.equals("4")) programname += "年度";
		if(!quoteid.equals("")){
			rs.executeSql("select startdate,auditids,remark from GP_AccessProgram where id="+quoteid);
			if(rs.next()){
				remark = Util.null2String(rs.getString(3));
			}
			programname += "考核方案"+startdate;
			if(!programid.equals("")){
				//判断是否是可编辑状态,审批中不能编辑
				rs.executeSql("select status from GP_AccessProgram where id = "+programid);
				if(rs.next()){
					if("1".equals(rs.getString(1))){
						response.sendRedirect("/notice/noright.jsp");
						return;
					}
				}
				sql = "update GP_AccessProgram set programname='"+programname+"',status="+status+",remark='"+remark+"' where id="+programid;
				rs.executeSql(sql);
				OperateUtil.addProgramLog(currentUserId,programid,2);
			}
			//保存考核明细
			rs.executeSql("delete from GP_AccessProgramDetail where programid = "+programid);
			rs.executeSql("select cate,accessitemid,description,rate,target1,target2 from GP_AccessProgramDetail where programid="+quoteid+" order by id");
		    String cate = "";
		    String accessitemid = "";
		    String desc = "";
		    String rate = "";
		    String target1 = "";
		    String target2 = "";
		    while(rs.next()){
		        cate = Util.null2String(rs.getString("cate"));
		        accessitemid = Util.null2String(rs.getString("accessitemid"));
		        desc = Util.null2String(rs.getString("description"));
		        rate = Util.getDoubleValue(rs.getString("rate"),0)+"";
		        target1 = Util.null2String(rs.getString("target1"));
		        target2 = Util.null2String(rs.getString("target2"));
		        if(!"".equals(accessitemid)){
		        	sql = "insert into GP_AccessProgramDetail(programid,cate,accessitemid,description,rate,target1,target2)"
		        		+" values("+programid+",'"+cate+"',"+accessitemid+",'"+desc+"',"+rate+","+target1+",'"+target2+"')";
					rs.executeSql(sql);
		        }
		  	}
		}
		response.sendRedirect("ProgramView.jsp?resourceid="+resourceid+"&programid="+programid+"&programtype="+programtype);
	    return;
	}
%>
