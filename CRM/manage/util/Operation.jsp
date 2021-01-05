
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.crm.CrmShareBase"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="logMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	String userid = user.getUID()+"";
	//添加取消提醒
	if("do_remind".equals(operation)){
		String operatetype=Util.null2String(request.getParameter("operatetype"));//1为客户 2为商机 3为联系人
		String objid=Util.null2String(request.getParameter("objid"));
		//权限判断
		if(!checkRight(objid,userid,Util.getIntValue(operatetype,1),1)) return;
		
		String settype=Util.null2String(request.getParameter("settype"));//1为添加 0为取消
		if(!objid.equals("")){
			if(settype.equals("1")){
				rs.executeSql("insert into CRM_Common_Remind (operator,objid,operatetype,operatedate,operatetime) values("+userid+","+objid+","+operatetype+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"')");
				if(operatetype.equals("2")){//商机日志
					rs.executeSql("insert into CRM_SellChanceLog (sellchanceid,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue)"
							+" values("+objid+",5,"+user.getUID()+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"','','','')");
				}else if(operatetype.equals("1")){//客户日志
					char flag = 2; 
					String ProcPara = "";
					ProcPara = objid;
					ProcPara += flag+"r";
					ProcPara += flag+"";
					ProcPara += flag+"";
					ProcPara += flag+TimeUtil.getCurrentDateString();
					ProcPara += flag+TimeUtil.getOnlyCurrentTimeString();
					ProcPara += flag+(user.getUID()+"");
					ProcPara += flag+(user.getLogintype()+"");
					ProcPara += flag+request.getRemoteAddr();
					rs.executeProc("CRM_Log_Insert",ProcPara);
				}
			}else{
				rs.executeSql("delete from CRM_Common_Remind where objid="+objid+" and operatetype="+operatetype);
			}
		}
	}
	//添加取消关注
	else if("do_attention".equals(operation)){
		String operatetype=Util.null2String(request.getParameter("operatetype"));//1为客户 2为商机 3为联系人
		String objid=Util.null2String(request.getParameter("objid"));
		//权限判断
		if(!checkRight(objid,userid,Util.getIntValue(operatetype,1),1)) return;
		
		String settype=Util.null2String(request.getParameter("settype"));//1为添加 否则为取消
		if(!objid.equals("")){
			rs.executeSql("delete from CRM_Common_Attention where operator="+userid+" and objid="+objid+" and operatetype="+operatetype);
			if(settype.equals("1")){
				rs.executeSql("insert into CRM_Common_Attention (operator,objid,operatetype,operatedate,operatetime) values("+userid+","+objid+","+operatetype+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"')");
			}
			
			if(operatetype.equals("2")){//商机日志
				String logtype = "6";
				if(settype.equals("0")) logtype = "7";
				rs.executeSql("insert into CRM_SellChanceLog (sellchanceid,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue)"
						+" values("+objid+","+logtype+","+user.getUID()+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"','','','')");
			}
		}
	}
	//添加联系记录
	else if("addquick".equals(operation)){
		String userId = user.getUID()+"";
		String CustomerID = Util.null2String(request.getParameter("CustomerID"));
		//权限判断
		if(!checkRight(CustomerID,userid,1,1)) return;
		
		String relatedprj = Util.null2String(request.getParameter("relatedprj"));
		String relatedcus = Util.null2String(request.getParameter("relatedcus"));
		String relatedwf = Util.null2String(request.getParameter("relatedwf"));
		String relateddoc = Util.null2String(request.getParameter("relateddoc"));
		String description = Util.convertInput2DB(Util.null2String(URLDecoder.decode(request.getParameter("ContactInfo"),"utf-8")));
		String currDate = Util.null2String(request.getParameter("begindate"));
		String currTime = Util.null2String(request.getParameter("begintime"));
		if(currDate.equals("")) currDate = TimeUtil.getCurrentDateString();
		if(!currDate.equals(TimeUtil.getCurrentDateString())) currTime = "00:00";
		if(currTime.equals("")) currTime = TimeUtil.getOnlyCurrentTimeString().substring(0, 5);

		if((","+relatedcus+",").indexOf(","+CustomerID+",")==-1)
		{
		    relatedcus=CustomerID+","+relatedcus;
		}
		
		WorkPlan workPlan = new WorkPlan();
	    workPlan.setCreaterId(user.getUID());
	    workPlan.setCreateType(Integer.parseInt(user.getLogintype()));
	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_CustomerContact));        
	    workPlan.setWorkPlanName(CustomerInfoComInfo.getCustomerInfoname(CustomerID) + "-" + SystemEnv.getHtmlLabelName(6082, user.getLanguage()));    
	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
	    workPlan.setResourceId(String.valueOf(user.getUID()));
	    workPlan.setBeginDate(currDate);  //开始日期
	    workPlan.setBeginTime(currTime);  //开始时间  
	    //workPlan.setDescription(Util.convertInput2DB(Util.null2String(request.getParameter("ContactInfo"))));
	    workPlan.setDescription(description);
	    workPlan.setStatus(Constants.WorkPlan_Status_Archived);  //直接归档
	    
	    workPlan.setCustomer(relatedcus);
	    workPlan.setDocument(relateddoc);
	    workPlan.setWorkflow(relatedwf);
	    workPlan.setTask(relatedprj);

	    workPlanService.insertWorkPlan(workPlan);  //插入日程
	    
		String workplanid = workPlan.getWorkPlanID()+"";
		//插入日志
		String[] logParams = new String[]{workplanid,
									WorkPlanLogMan.TP_CREATE,
									userId,
									request.getRemoteAddr()};
		logMan.writeViewLog(logParams);

	    //客户联系共享给能够查看到该客户的所有人
	    //CrmShareBase.setCRM_WPShare_newContact(CustomerID,workplanid);
	    
	    //添加相关附件
	    String relatedfile = Util.null2String(request.getParameter("relatedfile"));
	    relatedfile = cmutil.cutString(relatedfile,",",3);
	    if(!relatedfile.equals("")){
	    	rs.executeSql("update WorkPlan set relateddoc=',"+relatedfile+",' where id="+workplanid);
	    }
	    //商机id
	    String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
	  	//联系人id
	    String contacterid = Util.null2String(request.getParameter("contacterid"));
	    if(!sellchanceid.equals("")){
	    	rs.executeSql("update WorkPlan set sellchanceid="+sellchanceid+" where id="+workplanid);
	    	
	    	//如果有相应的客服销售机会则自动添加客服联系记录
	    	rs.executeSql("select id from CS_CustomerSellChance where sellchanceid="+sellchanceid);
	    	if(rs.next()){
	    		String chanceid = Util.null2String(rs.getString(1));
	    		if(!chanceid.equals("")){
	    			chanceid = "," + chanceid + ",";
	    			//保存联系记录
		    		char separator = Util.getSeparator();
		    		StringBuffer para = new StringBuffer();
		    		para.append(CustomerInfoComInfo.getCustomerInfoname(CustomerID)+"("+currDate+" "+currTime+")" + separator);
		    		para.append(CustomerID + separator);
		    		para.append(contacterid + separator);
		    		para.append(user.getUID()+"" + separator);
		    		para.append(currDate + separator);
		    		para.append(currTime + separator);
		    		para.append(currDate + separator);
		    		para.append(currTime + separator);
		    		para.append("1" + separator);
		    		para.append(description + separator);
		    		para.append("" + separator);
		    		para.append("" + separator);
		    		para.append(chanceid + separator);
		    		para.append("" + separator);
		    		para.append("");

		    		rs.executeProc("CS_CustomerContactRecord_Insert", para.toString());
		    		if (rs.next()) {
		    			String recordId = Util.null2String(rs.getString(1));
		    			//out.print("id"+id);
		    			
		    			//增加联系记录缓存
		    			//ContactRecordComInfo.addContactRecordComInfo(recordId);

		    			//保存联系记录与联系内容关联
		    			rs.executeProc("CS_ContactRecordContent_Insert", recordId + separator + "27");
		    			
		    			String currentdate = TimeUtil.getCurrentDateString();
		    			String currenttime = TimeUtil.getOnlyCurrentTimeString();
		    			para = new StringBuffer();
		    			para.append(recordId + separator);
		    			para.append(currentdate + separator);
		    			para.append(currenttime + separator);
		    			para.append("" + user.getUID() + separator);
		    			para.append(user.getLoginip() + separator);
		    			para.append("1");//新增

		    			rs.executeProc("CS_CustomerContactRecordLog_Insert", para.toString());
		    			
		    			//记录相关销售机会的最后日期
		    			this.updateLastDate2(chanceid);
		    		}
	    		}
	    	}
	    }
	  	
	    if(!contacterid.equals("")){
	    	rs.executeSql("update WorkPlan set contacterid="+contacterid+" where id="+workplanid);
	    }
	    if(!"".equals(workplanid) && !"-1".equals(workplanid)  && !"0".equals(workplanid)){
%>
				<tr>
					<td class="data fbdata1 fbdata2">
						<div class="feedbackshow">
							<div class="feedbackinfo" >
								<%=cmutil.getHrm(user.getUID()+"") %> <%=currDate %> <%=currTime %>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.toHtml(Util.convertDB2Input(description)) %></div>
								<%if(!"".equals(relateddoc)&&!"0".equals(relateddoc)&&!",".equals(relateddoc)){ %>
								<div class="relatetitle">相关文档：<%=cmutil.getDocName(relateddoc) %></div>
								<%} %>
								<%if(!"".equals(relatedwf)&&!"0".equals(relatedwf)&&!",".equals(relatedwf)){ %>
								<div class="relatetitle">相关流程：<%=cmutil.getRequestName(relatedwf) %></div>
								<%} %>
								<%if(!"".equals(relatedprj)&&!"0".equals(relatedprj)&&!",".equals(relatedprj)){ %>
								<div class="relatetitle">相关项目：<%=cmutil.getProject(relatedprj) %></div>
								<%} %>
								<%	String fileids = relatedfile;
									String customerid = CustomerID;
									if(!"".equals(fileids)&&!"0".equals(fileids)&&!",".equals(fileids)){ 
								%>
									<div class="relatetitle">相关附件：
								<%
										List fileidList = Util.TokenizerString(fileids,",");
										for(int i=0;i<fileidList.size();i++){
											if(!"0".equals(fileidList.get(i)) && !"".equals(fileidList.get(i))){
												DocImageManager.resetParameter();
									            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
									            DocImageManager.selectDocImageInfo();
									            DocImageManager.next();
									            String docImagefileid = DocImageManager.getImagefileid();
									            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
									            String docImagefilename = DocImageManager.getImagefilename();
									%>
												<a href="javaScript:openFullWindowHaveBar('/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>')"><%=docImagefilename %></a>
												&nbsp;<a href='/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
												&nbsp;&nbsp;
									<% 		} 
										}
									%>	
									</div>
								<%} %>
								<%
								if(!"".equals(sellchanceid)&&!"0".equals(sellchanceid)){ 
									rs2.executeSql("select id,subject from CRM_SellChance where id ="+sellchanceid);
									if(rs2.next()){
								%>
								<div class="relatetitle">相关商机：<a href="javaScript:openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceView.jsp?id=<%=rs2.getString(1) %>')"><%=Util.null2String(rs2.getString(2)) %></a></div>
								<%	}
								 } 
								%>
								<%
								if(!"".equals(contacterid)&&!"0".equals(contacterid)){ 
									rs2.executeSql("select id,firstname from CRM_CustomerContacter where id ="+contacterid);
									if(rs2.next()){
								%>
								<div class="relatetitle">相关联系人：<a href="javaScript:openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=rs2.getString(1) %>')"><%=Util.null2String(rs2.getString(2)) %></a></div>
								<%	}
								 } 
								%>
							</div>
						</div>
					</td>
				</tr>
<%
	    }
	}
	//获取联系记录列表数据
	else if("get_list_contact".equals(operation)){
		String orderby1 = " order by createdate desc,createtime desc";
		String orderby2 = " order by createdate asc,createtime asc";
		String orderby3 = " order by wp.createdate desc,wp.createtime desc";
		
		int ordertype = Util.getIntValue(request.getParameter("ordertype"),1);
		if(ordertype==2){
			orderby1 = " order by createdate asc,createtime asc";
			orderby2 = " order by createdate desc,createtime desc";
			orderby3 = " order by wp.createdate asc,wp.createtime asc";
		}
		
		String showwarn = Util.fromScreen3(request.getParameter("showwarn"),user.getLanguage());
		String keytype = Util.fromScreen3(request.getParameter("keytype"),user.getLanguage());
		String fromcustomer = Util.fromScreen3(request.getParameter("fromcustomer"),user.getLanguage());
		List keynames1 = new ArrayList();
		List keynames2 = new ArrayList();
		List keynames3 = new ArrayList();
		List keynames4 = new ArrayList();
		
		String temptable = "workplantemp_"+ user.getUID() ;//临时表名
		if(showwarn.equals("2")){
			keynames1 = (List)request.getSession().getAttribute("CRM_WARNKEY1");
			keynames2 = (List)request.getSession().getAttribute("CRM_WARNKEY2");
			keynames3 = (List)request.getSession().getAttribute("CRM_WARNKEY3");
			keynames4 = (List)request.getSession().getAttribute("CRM_WARNKEY4");
			
			if(fromcustomer.equals("1")){
				//此处将最近一10天的联系记录插入到临时表中，提高查询性能
				rs.executeSql("if NOT exists (select 1 from sysobjects where id = object_id('"+temptable+"') and type = 'U')"
							+" select p.id,p.description,p.begindate,p.begintime,p.createrid,p.docid,p.requestid,p.projectid,p.createdate,p.createtime,p.relateddoc,p.crmid,p.sellchanceid,p.contacterid"
							+" into "+temptable+" FROM WorkPlan p WHERE p.createrType = '1' AND p.type_n = 3"
							+" and p.begindate <>'' and p.begindate is not NULL"
							+" and p.begindate > '"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-10)+"'"
							+" and p.begindate <= '"+TimeUtil.getCurrentDateString()+"'"
				);
			}
		}
		
		String istitle = Util.fromScreen3(request.getParameter("istitle"),user.getLanguage());
		String showtype = Util.fromScreen3(request.getParameter("showtype"),user.getLanguage());//1:客户 2:商机 3:联系人
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String mark = Util.null2String(request.getParameter("mark"));
		String querysql = "";//URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		//if(querysql.equals("") || querysql.equals("undefined")){
			querysql = Util.null2String((String)request.getSession().getAttribute("CRM_CONTACT_SQL"+mark));
		//}
		String countsql = (String)request.getSession().getAttribute("CRM_CONTACTCOUNT_SQL"+mark);
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		iNextNum = (currentpage-1) * pagesize + ipageset;
		int dcount = 0;
		if(currentpage>1 && ordertype==1){
			rs.executeSql(countsql);
			if(rs.next()) dcount = total - rs.getInt(1);
		}
		sql = "select top " + ipageset +" A.* from (select top "+ (iNextNum-dcount) + querysql + orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		
		//查询预警时删除临时表
		if(showwarn.equals("2") && fromcustomer.equals("1")) rs2.executeSql("drop table "+temptable);
		
		String description = "";
		while(rs.next()){
			description = Util.toHtml(Util.convertDB2Input(rs.getString("description")));
			if(showwarn.equals("2")){
				if(keytype.equals("") || keytype.equals("1")){
					for(int i=0;i<keynames1.size();i++){
						description = description.replaceAll((String)keynames1.get(i),"<font style='background:#0080C0;color:#fff;'>"+(String)keynames1.get(i)+"</font>");
					}
				}
				if(keytype.equals("") || keytype.equals("2")){
					for(int i=0;i<keynames2.size();i++){
						description = description.replaceAll((String)keynames2.get(i),"<font style='background:#0080C0;color:#fff;'>"+(String)keynames2.get(i)+"</font>");//#008000
					}
				}
				if(keytype.equals("") || keytype.equals("3")){
					for(int i=0;i<keynames3.size();i++){
						description = description.replaceAll((String)keynames3.get(i),"<font style='background:#0080C0;color:#fff;'>"+(String)keynames3.get(i)+"</font>");//800040
					}
				}
				if(keytype.equals("") || keytype.equals("0")){
					for(int i=0;i<keynames4.size();i++){
						description = description.replaceAll(((String[])keynames4.get(i))[1],"<font style='background:#0080C0;color:#fff;'>"+((String[])keynames4.get(i))[1]+"</font>");//FF8000
					}
				}
			}
	%>
				<tr>
					<td class="data fbdata1 <%if(istitle.equals("0")){ %>fbdata2<%} %>">
						<div class="feedbackshow">
							<div class="feedbackinfo" >
								<%if(!istitle.equals("0")){ 
									if(showtype.equals("1")){
								%>
								<span style="font-weight: bold;">
								<a class="a1" href="javascript:openFullWindowHaveBar('/CRM/manage/customer/CustomerBaseView.jsp?CustomerID=<%=Util.null2String(rs.getString("customerid")) %>')" title="客户名称：<%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid"))%>"><%=Util.getMoreStr(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),20,"...") %></a>
								</span>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<%	}else if(showtype.equals("2")){ %>
								<span style="font-weight: bold;">
								<a class="a2" href="javascript:openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?id=<%=Util.null2String(rs.getString("mainsellchance")) %>')" title="商机名称：<%=Util.null2String(rs.getString("subject"))%>"><%=Util.getMoreStr(Util.null2String(rs.getString("subject")),10,"...") %></a>
								<font style="font-family: Calibri;font-weight: normal;color: #D1D1D1">--></font> 
								<a class="a1" href="javascript:openFullWindowHaveBar('/CRM/manage/customer/CustomerBaseView.jsp?CustomerID=<%=Util.null2String(rs.getString("customerid")) %>')" title="客户名称：<%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid"))%>"><%=Util.getMoreStr(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),10,"...") %></a>
								</span>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<%	} 
								 }
								%>
								<%=cmutil.getHrm(rs.getString("createrid")) %> <%=Util.null2String(rs.getString("createdate")) %> <%=this.transTime(Util.null2String(rs.getString("createtime"))) %>
							</div>
							<div class="feedbackrelate">
								<div><%=description %></div>
								<%if(!"".equals(Util.null2String(rs.getString("docid")))&&!"0".equals(Util.null2String(rs.getString("docid")))&&!",".equals(Util.null2String(rs.getString("docid")))){ %>
								<div class="relatetitle">相关文档：<%=cmutil.getDocName(rs.getString("docid")) %></div>
								<%} %>
								<%if(!"".equals(Util.null2String(rs.getString("requestid")))&&!"0".equals(Util.null2String(rs.getString("requestid")))&&!",".equals(Util.null2String(rs.getString("requestid")))){ %>
								<div class="relatetitle">相关流程：<%=cmutil.getRequestName(rs.getString("requestid")) %></div>
								<%} %>
								<%if(!"".equals(Util.null2String(rs.getString("taskid")))&&!"0".equals(Util.null2String(rs.getString("taskid")))&&!",".equals(Util.null2String(rs.getString("taskid")))){ %>
								<div class="relatetitle">相关项目：<%=cmutil.getProject(rs.getString("taskid")) %></div>
								<%} %>
								<%	String fileids = Util.null2String(rs.getString("relateddoc"));
									String customerid = Util.null2String(rs.getString("crmid"));
									if(!"".equals(fileids)&&!"0".equals(fileids)&&!",".equals(fileids)){ 
								%>
									<div class="relatetitle">相关附件：
								<%
										List fileidList = Util.TokenizerString(fileids,",");
										for(int i=0;i<fileidList.size();i++){
											if(!"0".equals(fileidList.get(i)) && !"".equals(fileidList.get(i))){
												DocImageManager.resetParameter();
									            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
									            DocImageManager.selectDocImageInfo();
									            DocImageManager.next();
									            String docImagefileid = DocImageManager.getImagefileid();
									            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
									            String docImagefilename = DocImageManager.getImagefilename();
									%>
												<a href="javaScript:openFullWindowHaveBar('/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>')"><%=docImagefilename %></a>
												&nbsp;<a href='/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
												&nbsp;&nbsp;
									<% 		} 
										}
									%>	
									</div>
								<%} %>
								<%
								if(!"".equals(Util.null2String(rs.getString("sellchanceid")))&&!"0".equals(Util.null2String(rs.getString("sellchanceid")))){ 
									rs2.executeSql("select id,subject from CRM_SellChance where id ="+rs.getString("sellchanceid"));
									if(rs2.next()){
								%>
								<div class="relatetitle">相关商机：<a href="javaScript:openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceView.jsp?id=<%=rs2.getString(1) %>')"><%=Util.null2String(rs2.getString(2)) %></a></div>
								<%	}
								 } 
								%>
								<%
								if(!"".equals(Util.null2String(rs.getString("contacterid")))&&!"0".equals(Util.null2String(rs.getString("contacterid")))){ 
									rs2.executeSql("select id,firstname from CRM_CustomerContacter where id ="+rs.getString("contacterid"));
									if(rs2.next()){
								%>
								<div class="relatetitle">相关联系人：<a href="javaScript:openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=rs2.getString(1) %>')"><%=Util.null2String(rs2.getString(2)) %></a></div>
								<%	}
								 } 
								%>
							</div>
						</div>
					</td>
				</tr>
	<%
		} 
	}
	//保存预警关键词
	else if(operation.equals("save_key")){
		String keyname = URLDecoder.decode(Util.null2String(request.getParameter("keyname")),"utf-8");
		String keytype = Util.null2String(request.getParameter("keytype"));
		String hrmid = "0";
		if(keytype.equals("0")) hrmid = user.getUID()+"";
		if(!keyname.equals("")){
			boolean res = rs.executeSql("insert into CRM_WarnConfig (keytype,userid,keyname) values("+keytype+","+hrmid+",'"+keyname+"')");
			if(res){
				rs.executeSql("select max(id) from CRM_WarnConfig");
				if(rs.next()){
					String addid = Util.null2String(rs.getString(1));
				
%>
	<div class="tagitem" style="<%if(keytype.equals("0")){ %>color: #F2F2F2;<%}else{ %>color:#fff;<%} %>" title="<%=keyname %>"><%=keyname %><div class="tagdel" onclick="doDelTag(<%=addid %>,this)" title="删除"></div></div>
<%		
				} 
			}
		}
	}
	//删除预警关键词
	else if(operation.equals("del_key")){
		String keyid = Util.null2String(request.getParameter("keyid"));
		if(!keyid.equals("")){
			rs.executeSql("delete from CRM_WarnConfig where id = "+keyid);
		}
	}

	out.print(restr.toString());
	//out.close();
%>
<%!
private boolean checkRight(String objid,String userid,int type,int level) throws Exception{
	CrmShareBase crmShareBase = new CrmShareBase();
	RecordSet rs = new RecordSet();
	String customerid = "";
	if(type==1){
		customerid = objid;
	}else if(type==2){
		if(!"".equals(objid)){
			rs.executeSql("select t.customerid from CRM_SellChance t where t.id="+objid);
			if(rs.next()) customerid = Util.null2String(rs.getString(1));
		}
	}else{
		if(!"".equals(objid)){
			rs.executeSql("select t.customerid from CRM_CustomerContacter t where t.id="+objid);
			if(rs.next()) customerid = Util.null2String(rs.getString(1)); 
		}
	}
	
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			return false;
		}
		int sharelevel = crmShareBase.getRightLevelForCRM(userid,customerid);
		if(level==1){
			//判断是否有查看该客户商机权限
			if(sharelevel<1){
				return false;
			}
		}else{
			//判断是否有编辑该客户商机权限
			if(sharelevel<2){
				return false;
			}
			if(rs.getInt("status")==7 || rs.getInt("status")==8 || rs.getInt("status")==10){
				return false;
			}
		}
		return true;
	}
	return false;
}
private void updateLastDate2(String sellchanceIds){
	RecordSet rs = new RecordSet();
	RecordSet rs2 = new RecordSet();
	List sellchanceIdList = Util.TokenizerString(sellchanceIds, ",");
	String sellchanceId = "";
	for(int i=0;i<sellchanceIdList.size();i++){
		sellchanceId = (String)sellchanceIdList.get(i);
		if(!"".equals(sellchanceId)){
			rs2.executeSql("delete from CS_LastSellChanceDate where sellchanceId="+sellchanceId);
			rs.executeSql("select top 1 id,startDate,startTime from CS_CustomerContactRecord where sellchanceIds like '%,"+sellchanceId+",%' order by startDate desc,startTime desc");
			if(rs.next()){
				rs2.executeSql("insert into CS_LastSellChanceDate (sellchanceId,recordId,lastDate,lastTime) values("+sellchanceId+","+rs.getString("id")+",'"+rs.getString("startDate")+"','"+rs.getString("startTime")+"')");
			}
		}
	}
}
public String transTime(String timestr){
	timestr = Util.null2String(timestr);
	if(!"".equals(timestr)){
		if(timestr.length()>5) timestr = timestr.substring(0,5);
	}
	return timestr; 
}
%>