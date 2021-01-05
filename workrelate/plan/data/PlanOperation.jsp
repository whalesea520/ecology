<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.pr.util.RightUtil" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.pr.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
	String currentUserId = user.getUID()+"";
	String operation = Util.fromScreen3(request.getParameter("operation"),user.getLanguage());
	String resourceid = Util.fromScreen3(request.getParameter("resourceid"),user.getLanguage());
	
	if(operation.equals("save")||operation.equals("submit")){//保存及提交
		if(!currentUserId.equals(resourceid)){
			response.sendRedirect("../util/Message.jsp?type=0") ;
			return;
		}
		String planid = Util.fromScreen3(request.getParameter("planid"),user.getLanguage());
		String planname = Util.fromScreen3(request.getParameter("planname"),user.getLanguage());
		String auditids = Util.fromScreen3(request.getParameter("auditids"),user.getLanguage());
		String year = Util.fromScreen3(request.getParameter("year"),user.getLanguage());
		String type1 = Util.fromScreen3(request.getParameter("type1"),user.getLanguage());
		String type2 = Util.fromScreen3(request.getParameter("type2"),user.getLanguage());
		String remark = Util.convertInput2DB(request.getParameter("remark"));
		String sql = "";
		
		//判断是否可编辑或提交
		int isweek = 0;       
		int ismonth = 0;    
		String reportaudit = "";
		int manageraudit = 0;
		int wstarttype = 0;      
		int wstartdays = 0;      
		int wendtype = 0;        
		int wenddays = 0;        
		int mstarttype = 0;      
		int mstartdays = 0;      
		int mendtype = 0;        
		int menddays = 0;
		rs.executeSql("select * from PR_BaseSetting where resourceid=" + ResourceComInfo.getDepartmentID(resourceid) + " and resourcetype=3");
		if(rs.next()){
			reportaudit = Util.null2String(rs.getString("reportaudit"));
			manageraudit = Util.getIntValue(rs.getString("manageraudit"),0);
			rs2.executeSql("select * from PR_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
			if(rs2.next()){
				isweek = Util.getIntValue(rs2.getString("isweek"),0);      
				ismonth = Util.getIntValue(rs2.getString("ismonth"),0);   
				wstarttype = Util.getIntValue(rs2.getString("wstarttype"),0);     
				wstartdays = Util.getIntValue(rs2.getString("wstartdays"),0);     
				wendtype = Util.getIntValue(rs2.getString("wendtype"),0);       
				wenddays = Util.getIntValue(rs2.getString("wenddays"),0);       
				mstarttype = Util.getIntValue(rs2.getString("mstarttype"),0);     
				mstartdays = Util.getIntValue(rs2.getString("mstartdays"),0);     
				mendtype = Util.getIntValue(rs2.getString("mendtype"),0);       
				menddays = Util.getIntValue(rs2.getString("menddays"),0); 
			}
		}else{
			rs.executeSql("select * from PR_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
			if(rs.next()){
				isweek = Util.getIntValue(rs.getString("isweek"),0);      
				ismonth = Util.getIntValue(rs.getString("ismonth"),0);   
				wstarttype = Util.getIntValue(rs.getString("wstarttype"),0);     
				wstartdays = Util.getIntValue(rs.getString("wstartdays"),0);     
				wendtype = Util.getIntValue(rs.getString("wendtype"),0);       
				wenddays = Util.getIntValue(rs.getString("wenddays"),0);       
				mstarttype = Util.getIntValue(rs.getString("mstarttype"),0);     
				mstartdays = Util.getIntValue(rs.getString("mstartdays"),0);     
				mendtype = Util.getIntValue(rs.getString("mendtype"),0);       
				menddays = Util.getIntValue(rs.getString("menddays"),0); 
				reportaudit = Util.null2String(rs.getString("reportaudit"));
				manageraudit = Util.getIntValue(rs.getString("manageraudit"),0);
			}
		}
		String currentdate = TimeUtil.getCurrentDateString();
		String basedate = "";
		String begindate = "";
		String enddate = "";
		if(type1.equals("1")){
			basedate = TimeUtil.getYearMonthEndDay(Integer.parseInt(year),Integer.parseInt(type2));
			begindate = TimeUtil.dateAdd(basedate,mstartdays*mstarttype);
			enddate = TimeUtil.dateAdd(basedate,menddays*mendtype);
		}else if(type1.equals("2")){
			basedate = TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(Integer.parseInt(year),Integer.parseInt(type2)));
			begindate = TimeUtil.dateAdd(basedate,wstartdays*wstarttype);
			enddate = TimeUtil.dateAdd(basedate,wenddays*wendtype);
		}
		if(TimeUtil.dateInterval(currentdate, begindate)>0 || TimeUtil.dateInterval(currentdate,enddate)<0 || (ismonth!=1 && type1.equals("1")) || (isweek!=1 && type1.equals("2"))){
			return;
		}
		//处理附件
		String fileids = Util.null2String(request.getParameter("newrelatedacc")).trim();
		String edit_relatedacc=Util.null2String(request.getParameter("edit_relatedacc")).trim();
		if(edit_relatedacc.endsWith(",")) edit_relatedacc = edit_relatedacc.substring(0,edit_relatedacc.length()-1);
		String delrelatedacc =Util.fromScreen(request.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
    	if(!edit_relatedacc.equals("")){
    		fileids = edit_relatedacc + "," + fileids;//新附件id
    	}
   		if(fileids.endsWith(",")) fileids = fileids.substring(0,fileids.length()-1);
   		if(!fileids.equals("")) fileids = "," + fileids + ",";
   		//删除附件
   		if(!delrelatedacc.equals("")) this.delfileimage(delrelatedacc,user.getUID());
		
		//执行编辑
		int status = 0;
		if(operation.equals("submit")) status = 1;
		
		//避免重复数据
		if(planid.equals("")){
			rs.executeSql("select id from PR_PlanReport where userid='"+resourceid+"' and year='"+year+"' and type1='"+type1+"' and type2='"+type2+"'");
			if(rs.next()){
				planid = Util.null2String(rs.getString(1));
			}
		}
		if(planid.equals("")){
			//第一次保存
			sql = "insert into PR_PlanReport(planname,userid,year,type1,type2,status,isvalid,remark,auditids,startdate,enddate,fileids) "
				+ "values('"+planname+"','"+resourceid+"','"+year+"','"+type1+"','"+type2+"','"+status+"','1','"+remark+"','"+auditids+"','"+begindate+"','"+enddate+"','"+fileids+"')";
			//System.out.println(sql);
			boolean flag = rs.executeSql(sql);
			if(flag){
				rs.executeSql("select max(id) from PR_PlanReport t where t.userid='"+resourceid+"'");
			
				if(rs.next()) planid = rs.getString(1);
				
				//保存显示列的设置
				int rownum1 = Util.getIntValue(request.getParameter("showindex"),0);
			    String fieldname = "";
			    String showname = "";
			    String customname = "";
			    int isshow = 0;
			    double showorder = 0;
			    int showwidth = 0;
			    int isshow2 = 0;
			    double showorder2 = 0;
			    int showwidth2 = 0;
			    int ismust = 0;
			    int ismust2 = 0;
			    for(int i = 0;i<rownum1;i++){
			    	fieldname = Util.fromScreen3(request.getParameter("fieldname_"+i),user.getLanguage());
			    	showname = Util.fromScreen3(request.getParameter(fieldname+"_showname"),user.getLanguage());
			    	customname = Util.fromScreen3(request.getParameter(fieldname+"_customname"),user.getLanguage());
			    	isshow = Util.getIntValue(request.getParameter(fieldname+"_isshow"),0);
			    	showorder = Util.getDoubleValue(request.getParameter(fieldname+"_showorder"),0);
			    	showwidth = Util.getIntValue(request.getParameter(fieldname+"_showwidth"),0);
			    	ismust = Util.getIntValue(request.getParameter(fieldname+"_ismust"),0);
			    	isshow2 = Util.getIntValue(request.getParameter(fieldname+"_isshow2"),0);
			    	showorder2 = Util.getDoubleValue(request.getParameter(fieldname+"_showorder2"),0);
			    	showwidth2 = Util.getIntValue(request.getParameter(fieldname+"_showwidth2"),0);
			    	ismust2 = Util.getIntValue(request.getParameter(fieldname+"_ismust2"),0);
			    	if(fieldname.equals("name")){ isshow = 1;isshow2 = 1;ismust=1;ismust2=1;}
			    	sql = "insert into PR_PlanProgramDetail(programid,planid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2,ismust,ismust2)"
		        		+" values(-1,'"+planid+"','"+showname+"','"+fieldname+"','"+customname+"','"+isshow+"','"+showorder+"','"+showwidth+"','"+isshow2+"','"+showorder2+"','"+showwidth2+"','"+ismust+"','"+ismust2+"')";
					rs.executeSql(sql);
			  	}
			}else{
				response.sendRedirect("../util/Message.jsp?type=3") ;
				return;
			}
		}else{
			//更新总结
			sql = "update PR_PlanReport set remark='"+remark+"',fileids='"+fileids+"' where id="+planid;
			rs.executeSql(sql);
		}
		//处理总结及计划明细部分
		List sdetailidlist = new ArrayList();
		List pdetailidlist = new ArrayList();
		//查找原有明细ID
		sdetailidlist.clear();pdetailidlist.clear();
		rs.executeSql("select id,planid,planid2 from PR_PlanReportDetail where planid="+planid+" or planid2="+planid);
		while(rs.next()){
			if(planid.equals(rs.getString("planid2"))){
				sdetailidlist.add(Util.null2String(rs.getString(1)));
			}else{
				pdetailidlist.add(Util.null2String(rs.getString(1)));
			}
		}
		String tag = "s";
		String splanid = "";//总结主id
		String pplanid = "";//计划主id
		for(int j=1;j<3;j++){
			int index = Util.getIntValue(request.getParameter("index"+j),0);
			if(j==2) tag = "p";
			String detailid="",datatype="",name="",cate="",begindate1="",enddate1="",begindate2="",enddate2="",days1="",days2="",finishrate="",target="",result="",custom1="",custom2="",custom3="",custom4="",custom5="";
		    int showorder = 0;
			for(int i = 0;i<index;i++){
		    	detailid = Util.fromScreen3(request.getParameter(tag+"_id_value_"+i),user.getLanguage());
		    	datatype = Util.fromScreen3(request.getParameter(tag+"_datatype_value_"+i),user.getLanguage());
		    	name = Util.convertInput2DB(request.getParameter(tag+"_name_value_"+i));
		    	cate = Util.fromScreen3(request.getParameter(tag+"_cate_value_"+i),user.getLanguage());
		    	begindate1 = Util.fromScreen3(request.getParameter(tag+"_begindate1_value_"+i),user.getLanguage());
		    	enddate1 = Util.fromScreen3(request.getParameter(tag+"_enddate1_value_"+i),user.getLanguage());
		    	begindate2 = Util.fromScreen3(request.getParameter(tag+"_begindate2_value_"+i),user.getLanguage());
		    	enddate2 = Util.fromScreen3(request.getParameter(tag+"_enddate2_value_"+i),user.getLanguage());
		    	days1 = Util.fromScreen3(request.getParameter(tag+"_days1_value_"+i),user.getLanguage());
		    	days2 = Util.fromScreen3(request.getParameter(tag+"_days2_value_"+i),user.getLanguage());
		    	finishrate = Util.fromScreen3(request.getParameter(tag+"_finishrate_value_"+i),user.getLanguage());
		    	target = Util.convertInput2DB(request.getParameter(tag+"_target_value_"+i));
		    	result = Util.convertInput2DB(request.getParameter(tag+"_result_value_"+i));
		    	custom1 = Util.convertInput2DB(request.getParameter(tag+"_custom1_value_"+i));
		    	custom2 = Util.convertInput2DB(request.getParameter(tag+"_custom2_value_"+i));
		    	custom3 = Util.convertInput2DB(request.getParameter(tag+"_custom3_value_"+i));
		    	custom4 = Util.convertInput2DB(request.getParameter(tag+"_custom4_value_"+i));
		    	custom5 = Util.convertInput2DB(request.getParameter(tag+"_custom5_value_"+i));
		    	showorder = Util.getIntValue(request.getParameter(tag+"_showorder_value_"+i),0);
		        if(!"".equals(name)){
		        	if(detailid.equals("")){
		        		if(j==1){
		        			splanid = planid;
		        			pplanid = "0";
		        		}else{
		        			splanid = "0";
		        			pplanid = planid;
		        		}
		        		sql = "insert into PR_PlanReportDetail(programid,planid,planid2,userid,datatype,name,cate,begindate1,enddate1,begindate2,enddate2,days1,days2,finishrate,target,result,custom1,custom2,custom3,custom4,custom5,showorder)"
			        		+" values('-1','"+pplanid+"','"+splanid+"','"+resourceid+"','"+datatype+"','"+name+"','"+cate+"','"+begindate1+"','"+enddate1+"','"+begindate2+"','"+enddate2+"','"+days1+"','"+days2+"','"+finishrate+"','"+target+"','"+result+"','"+custom1+"','"+custom2+"','"+custom3+"','"+custom4+"','"+custom5+"','"+showorder+"')";
		        		rs.executeSql(sql);
		        	}else{
		        		if(j==1) sdetailidlist.remove(detailid);
		        		if(j==2) pdetailidlist.remove(detailid);
		        		sql = "update PR_PlanReportDetail set "+((j==1)?"planid2":"planid")+"='"+planid+"',name='"+name+"',cate='"+cate+"',begindate1='"+begindate1+"',enddate1='"+enddate1+"',begindate2='"+begindate2+"',enddate2='"+enddate2+"',days1='"+days1+"',days2='"+days2+"',finishrate='"+finishrate+"'"
		        			+",target='"+target+"',result='"+result+"',custom1='"+custom1+"',custom2='"+custom2+"',custom3='"+custom3+"',custom4='"+custom4+"',custom5='"+custom5+"',showorder='"+showorder+"' where id="+detailid;
		        		rs.executeSql(sql);
		        	}
					
		        }
		  	}
		}
		//删除剩余明细
	    String sdelids = "";
	    String pdelids = ""; 
	    for(int i=0;i<sdetailidlist.size();i++){
	    	sdelids += "," + sdetailidlist.get(i);
	    }
	    if(!sdelids.equals("")){
	    	sdelids = sdelids.substring(1);
	    	rs.executeSql("update PR_PlanReportDetail set planid2=0 where id in("+sdelids+")");
	    }
	    for(int i=0;i<pdetailidlist.size();i++){
	    	pdelids += "," + pdetailidlist.get(i);
	    }
	    if(!pdelids.equals("")){
	    	pdelids = pdelids.substring(1);
	    	rs.executeSql("update PR_PlanReportDetail set planid=0 where id in("+pdelids+")");
	    }
	    //删除明细附件
	    rs.executeSql("select fileids from PR_PlanReportDetail where planid=0 and planid2=0 and userid="+resourceid);
		while(rs.next()){
			delrelatedacc = Util.null2String(rs.getString(1));
			this.delfileimage(delrelatedacc,user.getUID());
		}
	    rs.executeSql("delete from PR_PlanReportDetail where planid=0 and planid2=0 and userid="+resourceid);
		
		if(operation.equals("save")) {
			OperateUtil.addPlanLog(currentUserId,planid,2);
		}
		
		//提交
	    if(operation.equals("submit")){
	    	OperateUtil.addPlanLog(currentUserId,planid,3);
	    	//提交审批，读取审批人
    		//reportaudit += auditids;
	    	if(manageraudit==1) auditids += "," + ResourceComInfo.getManagerID(resourceid);
    		List auditidList = new ArrayList();//所有审批人
	    	//rs.executeSql("select * from GP_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
	    	//if(rs.next()) reportaudit += Util.null2String(rs.getString("reportaudit"));
	    	List auditidList2 = Util.TokenizerString(auditids,",");//模板中设置的审批人及上级审批人
	    	List auditidList3 = Util.TokenizerString(reportaudit,",");//后台设置的审批人
	    	String auditid = "";
	    	String remindids = "";//需要提醒的审批人
	    	for(int i=0;i<auditidList2.size();i++){
	    		auditid = (String)auditidList2.get(i);
	    		if(auditid.equals("-1")) auditid = ResourceComInfo.getManagerID(resourceid);
	    		if(!"".equals(auditid) && OperateUtil.isWork(auditid) && auditidList.indexOf(auditid)<0){
	    			auditidList.add(auditid);
	    			remindids += "," + auditid;
	    		}
	    	}
	    	for(int i=0;i<auditidList3.size();i++){
	    		auditid = (String)auditidList3.get(i);
	    		if(auditid.equals("-1")) auditid = ResourceComInfo.getManagerID(resourceid);
	    		if(!"".equals(auditid) && OperateUtil.isWork(auditid) && auditidList.indexOf(auditid)<0){
	    			auditidList.add(auditid);
	    		}
	    	}
	    	//更新需提醒的人员id
	    	if(!remindids.equals("")) remindids += ",";
	    	rs.executeSql("update PR_PlanReport set remindids='"+remindids+"' where id="+planid);
	    		
	    	if(auditidList.size()==0){
    			//无审批人则系统自动审批通过
    			OperateUtil.approvePlan(planid,"0"); 
    		}else{
    			//更改状态为审批中
    			rs.executeSql("update PR_PlanReport set status=1 where id="+planid);
    			boolean autoAudit = false;//标记是否要自动审批
    			for(int i=0;i<auditidList.size();i++){
    				auditid = (String)auditidList.get(i);
    				if(!"".equals(auditid)){
    					if(currentUserId.equals(auditid)) autoAudit = true;//如果审批人中有当前用户则标记需要直接审批
    					rs.executeSql("insert into PR_PlanReportAudit (planid,userid) values("+planid+","+auditid+")");
    				}
    			}
    			if(autoAudit) OperateUtil.approvePlan(planid,currentUserId);
    		}	
	    }
		
		response.sendRedirect("PlanView.jsp?islog=0&isrefresh=1&planid="+planid);
	    return;
	}else if(operation.equals("approve")||operation.equals("return")){//批准及退回
		String planid = Util.fromScreen3(request.getParameter("planid"),user.getLanguage());
		if(!RightUtil.isCanAuditPlan(planid,currentUserId)){
			response.sendRedirect("/performance/util/Message.jsp?type=1");
			return;
		}
		if(operation.equals("approve")){
			OperateUtil.approvePlan(planid,currentUserId);
		}else{
			OperateUtil.returnPlan(planid,currentUserId);
		}
		response.sendRedirect("PlanView.jsp?islog=0&isrefresh=1&planid="+planid);
	    return;
	}else if(operation.equals("quick_approve")||operation.equals("quick_return")){
		String planids = Util.fromScreen3(request.getParameter("planids"),user.getLanguage());
		List planidList = Util.TokenizerString(planids,",");
		String planid = "";
		for(int i=0;i<planidList.size();i++){
			planid = (String)planidList.get(i);
			if(RightUtil.isCanAuditPlan(planid,currentUserId)){
				if(operation.equals("quick_approve")){
					OperateUtil.approvePlan(planid,currentUserId);
				}else{
					OperateUtil.returnPlan(planid,currentUserId);
				}
			}
		}
	    return;
	}else if(operation.equals("delete")){//删除
		String planid = Util.fromScreen3(request.getParameter("planid"),user.getLanguage());
		String year = Util.fromScreen3(request.getParameter("year"),user.getLanguage());
		String type1 = Util.fromScreen3(request.getParameter("type1"),user.getLanguage());
		String type2 = Util.fromScreen3(request.getParameter("type2"),user.getLanguage());
		if(!RightUtil.isCanDelPlan(planid,currentUserId)){
			response.sendRedirect("../util/Message.jsp?type=1");
			return;
		}
		//删除附件
		String delrelatedacc = "";
		rs.executeSql("select fileids from PR_PlanReport where id="+planid);
		if(rs.next()){
			delrelatedacc = Util.null2String(rs.getString(1));
			this.delfileimage(delrelatedacc,user.getUID());
		}
		rs.executeSql("delete from PR_PlanReportAudit where planid="+planid);
		rs.executeSql("update PR_PlanReportDetail set planid=0 where planid="+planid);
		rs.executeSql("update PR_PlanReportDetail set planid2=0 where planid2="+planid);
		//删除明细信息附件
		rs.executeSql("select fileids from PR_PlanReportDetail where planid=0 and planid2=0 and userid="+resourceid);
		while(rs.next()){
			delrelatedacc = Util.null2String(rs.getString(1));
			this.delfileimage(delrelatedacc,user.getUID());
		}
		rs.executeSql("delete from PR_PlanReportDetail where planid=0 and planid2=0 and userid="+resourceid);//总结计划明细
		rs.executeSql("delete from PR_PlanProgramDetail where planid="+planid);//显示列定义
		rs.executeSql("delete from PR_PlanReportExchange where planid="+planid);//相关交流
		rs.executeSql("delete from PR_PlanReport where id="+planid);
		response.sendRedirect("PlanView.jsp?isrefresh=1&resourceid="+resourceid+"&year="+year+"&type1="+type1+"&type2="+type2);
	    return;
	}else if(operation.equals("reset")){//重新编写
		String planid = Util.fromScreen3(request.getParameter("planid"),user.getLanguage());
		if(!RightUtil.isCanResetPlan(planid,currentUserId)){
			response.sendRedirect("../util/Message.jsp?type=1");
			return;
		}
		rs.executeSql("delete from PR_PlanReportAudit where planid="+planid);
		rs.executeSql("update PR_PlanReport set isresubmit=1,status=0,remindids='' where id="+planid);
		OperateUtil.addPlanLog(currentUserId, planid, 6);
		
		response.sendRedirect("PlanView.jsp?islog=0&isrefresh=1&planid="+planid);
	    return;
	}else if("add_exchange".equals(operation)){//添加交流
		String planid = Util.fromScreen3(request.getParameter("planid"),user.getLanguage());
		String content = Util.convertInput2DB(URLDecoder.decode(request.getParameter("content"),"utf-8"));
		if(!planid.equals("") && !content.equals("")){
			//判断是否可查看此考核结果
			String currentuserid = user.getUID()+"";
			if(RightUtil.isCanViewPlan(planid,currentuserid)){
				StringBuffer restr = new StringBuffer();
				String currentDate = TimeUtil.getCurrentDateString();
				String currentTime = TimeUtil.getOnlyCurrentTimeString();
				String sql = "insert into PR_PlanReportExchange (planid,content,operator,operatedate,operatetime)"
					+" values("+planid+",'"+content+"',"+user.getUID()+",'"+currentDate+"','"+currentTime+"')";
				rs.executeSql(sql);
				restr.append("<div class='exchange_title'>"+cmutil.getPerson(user.getUID()+"")+"&nbsp;"+currentDate+"&nbsp;"+currentTime+"</div>"
							+"<div class='exchange_content'>"+Util.toHtml(content)+"</div>");
				out.print(restr.toString());
				//out.close();
			}
		}
	}else if("set_share".equals(operation)){//设置共享
		String planid = Util.fromScreen3(request.getParameter("planid"),user.getLanguage());
		String shareids = Util.fromScreen3(request.getParameter("shareids"),user.getLanguage());
		if(!shareids.equals("")){
			if(!shareids.startsWith(",")) shareids = "," + shareids;
			if(!shareids.endsWith(",")) shareids += ",";
		}
		if(!planid.equals("")){
			//判断是否可共享此考核结果
			String currentuserid = user.getUID()+"";
			if(RightUtil.isCanSharePlan(planid,currentuserid)){
				StringBuffer restr = new StringBuffer();
				String currentDate = TimeUtil.getCurrentDateString();
				String currentTime = TimeUtil.getOnlyCurrentTimeString();
				String sql = "update PR_PlanReport set shareids='"+shareids+"' where id="+planid;
				rs.executeSql(sql);
				OperateUtil.addPlanLog(currentUserId, planid, 7);
				restr.append("<div class=\"log_op\" style=\"color: #808080;\">"+cmutil.getPerson(currentuserid)+"&nbsp;&nbsp;&nbsp;"+currentDate+"&nbsp;&nbsp;"+currentTime+"&nbsp;&nbsp;&nbsp;设置共享</div>");
				out.print(restr.toString());
				//out.close();
			}
		}
	}else if(operation.equals("all_approve")||operation.equals("all_return")){ //批准全部和退回全部
		String type1 = Util.null2String(request.getParameter("type1"));
		String hrmids = Util.fromScreen3(request.getParameter("hrmids"),user.getLanguage());
		String currentdate = TimeUtil.getCurrentDateString();
		String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"), user.getLanguage());
		String departmentids = Util.fromScreen3(request.getParameter("departmentids"), user.getLanguage());
		String backfields = "select t.id from PR_PlanReport t,HrmResource h ";
		
		String sqlWhere = " where t.isvalid=1 and t.status=1 and t.userid=h.id and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
		 	+" and h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>''"
			+" and (exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid="+currentUserId+"))";
		if("oracle".equals(rs.getDBType())){
			sqlWhere = " where t.isvalid=1 and t.status=1 and t.userid=h.id and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
		 		+" and h.status in (0,1,2,3) and h.loginid is not null"
				+" and (exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid="+currentUserId+"))";
		}
		if(!hrmids.equals("")){
			sqlWhere += " and t.userid in ("+hrmids+")";
		}
		if(!type1.equals("")){
			sqlWhere += " and t.type1 =" + type1;
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
			if(RightUtil.isCanAuditPlan(id,currentUserId)){
				if(operation.equals("all_approve")){
					OperateUtil.approvePlan(id,currentUserId);
				}else{
					OperateUtil.returnPlan(id,currentUserId);
				}
				totalcount++;
			}
		}
		out.print(totalcount);
	    return;
	}
%>
<%!
	private void delfileimage(String docids,int userid) throws Exception{
		if(!docids.equals("")){
			List delidList = Util.TokenizerString(docids,",");
			for(int i=0;i<delidList.size();i++){
				int docid = Util.getIntValue((String)delidList.get(i),0);
				if(docid!=0){
					DocManager dm = new DocManager();
					dm.setId(docid);
					dm.setUserid(userid);
					dm.DeleteDocInfo();
				}
			}
		}
	}
%>