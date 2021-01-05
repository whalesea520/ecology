
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workrelate.util.*"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.crm.Maint.ContactWayComInfo"%>
<%@ page import="weaver.crm.sellchance.SellstatusComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="cmutil2" class="weaver.cs.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="logMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	//获取列表数据
	if("get_list_data".equals(operation)){
		String orderby1 = " order by createdate desc,createtime desc";
		String orderby2 = " order by createdate asc,createtime asc";
		String orderby3 = " order by t.createdate desc,t.createtime desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String endtatusid = Util.null2String(request.getParameter("endtatusid"));
		String querysql = URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		int index = (currentpage-1) * pagesize;
		String _sellType = "";
		String _att = "";
		String _createdate = "";
		String _customerid = "";
		int _days = 0;
		int _nods = 0;
		while(rs.next()){
			index++;
			_sellType = Util.null2String(rs.getString("sellType"));
			_att = Util.null2String(rs.getString("att"));
			if(_sellType.equals("1")){
				_sellType = "新签";
			}else if(_sellType.equals("2")){
				_sellType = "二次";
			}else{
				_sellType = "&nbsp;";
			}
			_customerid = Util.null2String(rs.getString("customerid"));
			_createdate = Util.null2String(rs.getString("createdate"));
			_days = TimeUtil.dateInterval(_createdate,TimeUtil.getCurrentDateString())+1;
			if(endtatusid.equals("0")){
				rs2.executeSql("select begindate from WorkPlan where type_n='3' and crmid ='"+_customerid+"' and begindate>='"+_createdate+"' group by begindate");
				_nods = _days - rs2.getCounts();
			}
	%>
		<tr id="item<%=rs.getString("id")%>" class="item_tr" _sellchanceid="<%=rs.getString("id")%>" _sellchancename="<%=rs.getString("subject")%>" _customerid="<%=rs.getString("customerid")%>" _lastdate="<%=rs.getString("createdate")%>">
			<%if(!_att.equals("")){%>
				<td class='td_move td_att' _index="<%=index%>" title="取消关注" _special="0" _sellchanceid="<%=rs.getString("id")%>">&nbsp;</td>
			<%}else{ %>
				<td class='td_move td_noatt' _index="<%=index%>" title="标记关注" _special="1" _sellchanceid="<%=rs.getString("id")%>"><%=index %></td>
			<%} %>
			<td class='item_td'><input readonly="readonly" onfocus="" onblur='' class="disinput" type="text" name="" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("subject")) %>--><%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")) %>" value="<%=Util.null2String(rs.getString("subject")) %>" _index="<%=index %>"/></td>
			<%if(endtatusid.equals("0")){ %>
			<td class=''><div><%if(_nods>0){%><font style="color: red" title="<%=_nods %>天未有联系记录"><%=_nods %></font>/<%}%><font style="" title="商机已建立<%=_days %>天"><%=_days %></font></div></td>
			<%} %>
			<td><div><%=_sellType %></div></td>
			<td><div><%=Util.null2String(rs.getString("preyield"))%></div></td>
			<td><div><%=SellstatusComInfo.getSellStatusname(Util.null2String(rs.getString("sellstatusid")))%></div></td>
			<td><div><%=Util.getDoubleValue(rs.getString("probability"),0)*100%>%</div></td>
			<td class='item_hrm' title=''><%=this.getHrmLink(rs.getString("creater")) %></td>
		</tr>
	<%
		} 
	}
	
	//获取商机联系记录
	if("get_chance_contact".equals(operation)){
		String[] week={SystemEnv.getHtmlLabelName(16106,user.getLanguage()),SystemEnv.getHtmlLabelName(16100,user.getLanguage()),SystemEnv.getHtmlLabelName(16101,user.getLanguage()),SystemEnv.getHtmlLabelName(16102,user.getLanguage()),SystemEnv.getHtmlLabelName(16103,user.getLanguage()),SystemEnv.getHtmlLabelName(16104,user.getLanguage()),SystemEnv.getHtmlLabelName(16105,user.getLanguage())};
		int pagesize = 10;
		int length = pagesize;
		String today = TimeUtil.getCurrentDateString();
		String yesterday = TimeUtil.dateAdd(today,-1);
		String begindate = Util.fromScreen3(request.getParameter("begindate"),user.getLanguage());
		String lastdate = Util.fromScreen3(request.getParameter("lastdate"),user.getLanguage());
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		if(begindate.equals("")) begindate = TimeUtil.getCurrentDateString();
		boolean hasnext = true;
		if(TimeUtil.dateInterval(lastdate,begindate)<pagesize){
			length = TimeUtil.dateInterval(lastdate,begindate)+1;
			hasnext = false;
			
		}
		Map dataMap = new HashMap();
		rs.executeSql("select description,begindate,begintime,createrid,docid,requestid,projectid,createdate,createtime from WorkPlan where type_n='3' and crmid ='"+customerid+"' and begindate>='"+lastdate+"' order by begindate desc,begintime desc,id desc");
		while(rs.next()){
			List dataList = (List)dataMap.get(Util.null2String(rs.getString("begindate")));
			String[] data = {Util.null2String(rs.getString("description")),Util.null2String(rs.getString("begindate")),Util.null2String(rs.getString("begintime"))
					,Util.null2String(rs.getString("createrid")),Util.null2String(rs.getString("docid")),Util.null2String(rs.getString("requestid"))
					,Util.null2String(rs.getString("projectid")),Util.null2String(rs.getString("createdate")),
					Util.null2String(rs.getString("createtime")).equals("")?Util.null2String(rs.getString("createtime")):Util.null2String(rs.getString("createtime")).substring(0,5)};
			if(dataList==null){
				dataList = new ArrayList();
				dataList.add(data);
				dataMap.put(Util.null2String(rs.getString("begindate")),dataList);
			}else{
				dataList.add(data);
			}
		}
		String daystr = "";
		for(int i=0;i<length;i++){
			daystr = TimeUtil.dateAdd(begindate,i*-1);
			List dataList = (List)dataMap.get(daystr);
			if(!HrmScheduleDiffUtil.getIsWorkday(daystr,1,"") && dataList==null) continue;//非工作日并且无记录
%>
<tr>
	<td class="data fbdata" >
		<div class="feedbackshow">
			<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
				<colgroup><col width="45px"/><col width="*"/></colgroup>
				<tr>
					<td valign="top">
						<div class=dateArea title="<%=daystr+" "+week[TimeUtil.dateWeekday(daystr)]%>"
								<%if(daystr.equals(today)){ %>
									style="background: #C00000;"
								<%}else if(daystr.equals(yesterday)){ %>
									style="background: #3ABE3E;"
								<%}%>
						>
							<div class=day>
								<%if(daystr.equals(today)){ %>
									今天
								<%}else if(daystr.equals(yesterday)){ %>
									昨天
								<%}else{ %>
									<%=week[TimeUtil.dateWeekday(daystr)] %>
								<%} %>
							</div>
							<div class=yearAndMonth><%=daystr.substring(5,7)+"."+daystr.substring(8) %></div>
						</div>
					</td>
					<td id="contact<%=daystr %>" >
					<%
						if(dataList!=null){
							for(int j=0;j<dataList.size();j++){ 
								String[] data = (String[])dataList.get(j);
					%>
						<div class="feedbackshow">
							<div class="feedbackinfo">
								<%=cmutil.getHrm(data[3]) %> <%=data[1] %> <%=data[2] %>
								<%if(!data[1].equals(data[7])){ %>
									<font style="font-family: Calibri;font-weight: normal;color: #D1D1D1">--></font> 
									<font style="color: #D1D1D1;font-style: italic">补填时间：<%=data[7] %> <%=data[8] %></font>
								<%} %>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.toScreen(data[0],user.getLanguage()) %></div>
								<%if(!"".equals(data[4])&&!",".equals(data[4])&&!"0".equals(data[4])){ %>
								<div class="relatetitle">相关文档：<%=cmutil.getDocName(data[4]) %></div>
								<%} %>
								<%if(!"".equals(data[5])&&!",".equals(data[5])&&!"0".equals(data[5])){ %>
								<div class="relatetitle">相关流程：<%=cmutil.getRequestName(data[5]) %></div>
								<%} %>
								<%if(!"".equals(data[6])&&!",".equals(data[6])&&!"0".equals(data[6])){ %>
								<div class="relatetitle">相关项目：<%=cmutil.getProject(data[6]) %></div>
								<%} %>
							</div>
						</div>
					<%  	}
						}else{
					%>
						<div style="background: #E46C0A;color: #D9D9D9;width: 98%;line-height: 35px;margin-top: 5px;">
							&nbsp;&nbsp;&nbsp;&nbsp;未填写联系记录
							<a href="javascript:writeFB('<%=daystr %>')" class="wfb" style="float: right;color: #D9D9D9;margin-right: 10px;">填写</a>
						</div>
					<%	
						} 
					%>
					</td>
				</tr>
			</table>
		</div>
	</td>
</tr>
<%
		}
		if(hasnext){
%>
	<tr id="contactmore">
		<td align="center" class="datamore" style="height:25px;background: url('../images/more_bg_wev8.png') center repeat-x;cursor: pointer;color: #595959;font-family: '微软雅黑'"
	 		onclick="getMore('<%=TimeUtil.dateAdd(begindate,pagesize*-1) %>','<%=lastdate %>',<%=customerid %>)">更多>></td></tr>
<%
		}
	}
	//获取某天联系记录
	if("get_contactbyday".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		String date = Util.fromScreen3(request.getParameter("date"),user.getLanguage());
		rs.executeSql("select description,begindate,begintime,createrid,docid,requestid,projectid,createdate,createtime from WorkPlan where type_n='3' and crmid ='"+customerid+"' and begindate='"+date+"' order by begindate desc,begintime desc");
		while(rs.next()){ 
		%>
			<div class="feedbackshow">
				<div class="feedbackinfo">
					<%=cmutil.getHrm(rs.getString("createrid")) %> <%=Util.null2String(rs.getString("begindate")) %> <%=Util.null2String(rs.getString("begintime")) %>
					<%if(!rs.getString("begindate").equals(rs.getString("createdate"))){ %>
						<font style="font-family: Calibri;font-weight: normal;color: #D1D1D1">--></font> 
						<font style="color: #D1D1D1;font-style: italic">补填时间：<%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")).equals("")?Util.null2String(rs.getString("createtime")):Util.null2String(rs.getString("createtime")).substring(0,5) %></font>
					<%} %>
				</div>
				<div class="feedbackrelate">
					<div><%=Util.toScreen(rs.getString("description"),user.getLanguage()) %></div>
					<%if(!"".equals(Util.null2String(rs.getString("docid")))&&!",".equals(Util.null2String(rs.getString("docid")))&&!"0".equals(Util.null2String(rs.getString("docid")))){ %>
					<div class="relatetitle">相关文档：<%=cmutil.getDocName(Util.null2String(rs.getString("docid"))) %></div>
					<%} %>
					<%if(!"".equals(Util.null2String(rs.getString("requestid")))&&!",".equals(Util.null2String(rs.getString("requestid")))&&!"0".equals(Util.null2String(rs.getString("requestid")))){ %>
					<div class="relatetitle">相关流程：<%=cmutil.getRequestName(Util.null2String(rs.getString("requestid"))) %></div>
					<%} %>
					<%if(!"".equals(Util.null2String(rs.getString("taskid")))&&!",".equals(Util.null2String(rs.getString("taskid")))&&!"0".equals(Util.null2String(rs.getString("taskid")))){ %>
					<div class="relatetitle">相关项目：<%=cmutil.getProject(Util.null2String(rs.getString("taskid"))) %></div>
					<%} %>
				</div>
			</div>
		<%
		} 
	}
	//获取联系记录列表数据
	if("get_list_contact".equals(operation)){
		String orderby1 = " order by begindate desc,begintime desc,id desc";
		String orderby2 = " order by begindate asc,begintime asc,id asc";
		String orderby3 = " order by wp.begindate desc,wp.begintime desc,wp.id desc";
		String istitle = Util.fromScreen3(request.getParameter("istitle"),user.getLanguage());
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String querysql = Util.null2String(URLDecoder.decode(request.getParameter("querysql"),"utf-8"));//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		while(rs.next()){
	%>
				<tr>
					<td class="data fbdata1 <%if(istitle.equals("0")){ %>fbdata2<%} %>">
						<div class="feedbackshow">
							<div class="feedbackinfo" >
								<%if(!istitle.equals("0")){ %>
								<span style="font-weight: bold;">
								<a class="a2" href="javascript:openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?id=<%=Util.null2String(rs.getString("sellchanceid")) %>')" title="商机名称：<%=Util.null2String(rs.getString("subject"))%>"><%=Util.getMoreStr(Util.null2String(rs.getString("subject")),10,"...") %></a>
								<font style="font-family: Calibri;font-weight: normal;color: #D1D1D1">--></font> 
								<a class="a1" href="javascript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=Util.null2String(rs.getString("customerid")) %>')" title="客户名称：<%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid"))%>"><%=Util.getMoreStr(CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")),10,"...") %></a>
								</span>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<%} %>
								<%=cmutil.getHrm(rs.getString("createrid")) %> <%=Util.null2String(rs.getString("begindate")) %> <%=Util.null2String(rs.getString("begintime")) %>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.toHtml(Util.convertDB2Input(rs.getString("description"))) %></div>
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
												<a href="javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>')"><%=docImagefilename %></a>
												&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
												&nbsp;&nbsp;
									<% 		} 
										}
									%>	
									</div>
								<%} %>
								
							</div>
						</div>
					</td>
				</tr>
	<%
		} 
	}
	//设置商机数量及新商机提醒
	if("check_new".equals(operation)){
%>
		<script type="text/javascript">
			newMap = new Map();
<%
		String userid = user.getUID()+"";
		String condition = cmutil2.getCustomerStr(user);
		String base = "select count(t.id) as amount from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id and (customerIds.deleted=0 or customerIds.deleted is null)";
		String where1 = base+" and t.endtatusid=0";
		sql = where1 + " and t.creater="+userid
			+" union all "+where1+" and exists (select 1 from CRM_SellChance_Attention t2 where t.id=t2.sellchanceId and t2.userId="+userid+")"
			+" union all "+where1+" and t.subCompanyId = "+user.getUserSubCompany1()
			+" union all "+where1+" and t.departmentId = "+user.getUserDepartment()
			+" union all "+where1
			+" union all "+where1+" and t.creater<>"+userid;
		SellstatusComInfo.setTofirstRow();
		while(SellstatusComInfo.next()){
			sql += " union all "+where1+" and t.sellstatusid="+SellstatusComInfo.getSellStatusid();
		}
		sql += " union all "+base+" and t.endtatusid=1"+" union all "+base+" and t.endtatusid=2";
		//联系
		sql += " union all "+where1+" and not exists (select 1 from WorkPlan w where w.type_n=3 and w.crmid=convert(varchar,t.customerid) and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"'";
		sql += " union all "+where1+" and not exists (select 1 from WorkPlan w where w.type_n=3 and w.crmid=convert(varchar,t.customerid) and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"'";
		sql += " union all "+where1+" and not exists (select 1 from WorkPlan w where w.type_n=3 and w.crmid=convert(varchar,t.customerid) and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"')"
			+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"'";
		rs.executeSql(sql);
		//System.out.println(sql);
		int index = 1;
		while(rs.next()){
%>
			newMap.put("cond<%=index%>","<%=rs.getInt(1)%>");
<%		
			index++;
		}
%>
		</script>
<%			
	}
	//添加联系记录
	if("addquick".equals(operation)){
		String userId = user.getUID()+"";
		String CustomerID = Util.null2String(request.getParameter("CustomerID"));
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
		
		//插入日志
		String[] logParams = new String[]{String.valueOf(workPlan.getWorkPlanID()),
									WorkPlanLogMan.TP_CREATE,
									userId,
									request.getRemoteAddr()};
		logMan.writeViewLog(logParams);

	    //客户联系共享给能够查看到该客户的所有人
	    CrmShareBase.setCRM_WPShare_newContact(CustomerID,""+workPlan.getWorkPlanID());
	    
	    //添加相关附件
	    String relatedfile = Util.null2String(request.getParameter("relatedfile"));
	    relatedfile = cmutil.cutString(relatedfile,",",3);
	    if(!relatedfile.equals("")){
	    	rs.executeSql("update WorkPlan set relateddoc=',"+relatedfile+",' where id="+workPlan.getWorkPlanID());
	    }
%>
				<tr>
					<td class="data fbdata1 fbdata2">
						<div class="feedbackshow">
							<div class="feedbackinfo" >
								<%=cmutil.getHrm(user.getUID()+"") %> <%=currDate %> <%=currTime %>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.convertDB2Input(description) %></div>
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
												<a href="javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>')"><%=docImagefilename %></a>
												&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&customerid=<%=customerid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
												&nbsp;&nbsp;
									<% 		} 
										}
									%>	
									</div>
								<%} %>
							</div>
						</div>
					</td>
				</tr>
<%
	}
	
	Map fn = new HashMap();
	fn.put("manager","客户经理");
	fn.put("subject","商机名称");
	fn.put("customerid","相关客户");
	fn.put("content","中介机构");
	fn.put("source","商机来源");
	fn.put("selltype","商机类型");
	fn.put("endtatusid","商机状态");
	fn.put("predate","销售预期");
	fn.put("preyield","预期收益");
	fn.put("probability","可能性");
	fn.put("sellstatusid","商机阶段");
	fn.put("description","综合性描述");
	fn.put("remark","成功关键因素(风险)");
	fn.put("fileids","启动原因及需求");
	fn.put("fileids2","复盘文件");
	fn.put("fileids3","报价书/合同书");
	fn.put("product","产品");

	
	//新建商机
	if("add_sellchance".equals(operation)){
		String subject = Util.null2String(request.getParameter("subject"));
		String customerid = Util.null2String(request.getParameter("customer"));
		String creater = Util.null2String(request.getParameter("creater"));
		String content = Util.null2String(request.getParameter("agent"));
		String source = Util.null2String(request.getParameter("source"));
		String preselldate = Util.null2String(request.getParameter("preselldate"));
		double preyield = Util.getDoubleValue(request.getParameter("preyield"),0)*10000;
		double probability = Util.getDoubleValue(request.getParameter("probability"),0)/100;
		String fileids = Util.fromScreen(request.getParameter("relatedacc"),user.getLanguage());
		fileids = cutString(fileids,",",3);
		String remark = Util.convertInput2DB(request.getParameter("remark"));
		String sellstatusid = "1";
		String endtatusid = "0";
		int selltype = Util.getIntValue(request.getParameter("selltype"),1);
		String sellchanceid="";
		
		sql = "insert into CRM_SellChance (subject,customerid,creater,content,source,predate,preyield,probability,fileids,remark,sellstatusid,endtatusid,selltype,createuserid,createdate,createtime,updatedate,updatetime)"
			+" values('"+subject+"',"+customerid+","+creater+",'"+content+"',"+source+",'"+preselldate+"',"+preyield+","+probability+",'"+fileids+"','"+remark+"',"+sellstatusid+","+endtatusid+","+selltype+","+user.getUID()+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"','"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"')";
		boolean success = rs.executeSql(sql);
		if(success){
			rs.executeSql("select max(id) from CRM_SellChance");
			if(rs.next()){
				sellchanceid = rs.getString(1);
				this.writeLog(user,1,sellchanceid,"","","",fn);
			}
		}
%>
		<script type="text/javascript">
			if(opener != null && opener.onRefresh != null){opener.onRefresh();}
			window.location="SellChanceView.jsp?id=<%=sellchanceid%>";
		</script>
<%
		//response.sendRedirect("SellChanceView.jsp?id="+sellchanceid);
		return;
	}
	//编辑商机字段
	if("edit_sellchance_field".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String fieldname = URLDecoder.decode(Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage()),"utf-8");
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		String setid = Util.fromScreen3(request.getParameter("setid"),user.getLanguage());
		if(fieldname.equals("agent")) fieldname = "content";
		if(newvalue.endsWith("ids") && newvalue.equals(",")){
			newvalue = "";
		}
		if(fieldname.equals("manager")){
			rs.executeSql("update CRM_SellChance set creater="+newvalue+" where id="+sellchanceid);
			//记录日志
			restr.append(this.writeLog(user,2,sellchanceid,"manager",oldvalue,newvalue,fn));
		}else if(fieldname.equals("fileids") || fieldname.equals("fileids2") || fieldname.equals("fileids3") || !setid.equals("")){//附件
			String oldfileids = "";
			if(setid.equals("")){
				rs.executeSql("select "+fieldname+" from CRM_SellChance where id="+sellchanceid);
			}else{
				rs.executeSql("select remark from CRM_SellChance_Other where type=4 and setid="+setid+" and sellchanceid="+sellchanceid);
			}
			if(rs.next()){
				oldfileids = Util.null2String(rs.getString(1));
			}
			if(fieldtype.equals("del")){
				int docid = Util.getIntValue(newvalue); 
				String delfilename = "";
				
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(docid);
	            DocImageManager.selectDocImageInfo();
	            if(DocImageManager.next()) delfilename = DocImageManager.getImagefilename();
				
				DocManager dm = new DocManager();
				dm.setId(docid);
				dm.setUserid(user.getUID());
				dm.DeleteDocInfo();
				
				int index = oldfileids.indexOf(","+newvalue+",");
				if(index>-1){
					oldfileids = oldfileids.substring(0,index+1)+ oldfileids.substring(index+newvalue.length()+2);
					if(setid.equals("")){
						rs.executeSql("update CRM_SellChance set "+fieldname+"='"+oldfileids+"' where id="+sellchanceid);
					}else{
						rs.executeSql("update CRM_SellChance_Other set remark='"+oldfileids+"' where type=4 and setid="+setid+" and sellchanceid="+sellchanceid);
					}
					//记录日志
					this.writeLog(user,4,sellchanceid,fieldname,"",delfilename,fn);
				}
			}else{
				newvalue = cmutil.cutString(newvalue,",",3);
				if(!"".equals(newvalue)) {
					if("".equals(oldfileids)) oldfileids = ",";
					oldfileids = oldfileids + newvalue + ",";
					rs.executeSql("update CRM_SellChance set "+fieldname+"='"+oldfileids+"' where id="+sellchanceid);
					//记录日志
					this.writeLog(user,9,sellchanceid,fieldname,"",newvalue,fn);
				}
			}
			List fileidList = Util.TokenizerString(oldfileids,",");
			for(int i=0;i<fileidList.size();i++){
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
	            DocImageManager.selectDocImageInfo();
	            DocImageManager.next();
	            String docImagefileid = DocImageManager.getImagefileid();
	            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
	            String docImagefilename = DocImageManager.getImagefilename();
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>");
				restr.append("<a href=javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&sellchanceid="+sellchanceid+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id="+fileidList.get(i)+"&sellchanceid="+sellchanceid+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>");
				restr.append("</div>");
				restr.append("<div class='btn_del' onclick=doDelItem('"+fieldname+"','"+fileidList.get(i)+"','"+setid+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
			
		}else{
			if(fieldname.equals("preyield")||fieldname.equals("probability")||fieldtype.equals("num")){
				if(fieldname.equals("preyield")){
					newvalue = Util.getDoubleValue(newvalue,0)*10000+"";
					oldvalue = Util.getDoubleValue(oldvalue,0)*10000+"";
				}
				if(fieldname.equals("probability")){
					newvalue = Util.getDoubleValue(newvalue,0)/100+"";
					oldvalue = Util.getDoubleValue(oldvalue,0)/100+"";
				}
				sql = "update CRM_SellChance set "+fieldname+"="+newvalue+" where id="+sellchanceid;
			}else if(fieldtype.equals("str")){
				sql = "update CRM_SellChance set "+fieldname+"='"+newvalue+"' where id="+sellchanceid;
			}
			//System.out.println(sql);
			rs.executeSql(sql);
			
			String addvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("addvalue"),"utf-8"));
			String delvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
			if(!addvalue.equals("")){
				//记录日志
				restr.append(this.writeLog(user,3,sellchanceid,fieldname,"",cmutil.cutString(addvalue,",",3),fn));
			}else if(!delvalue.equals("")){
				//记录日志
				restr.append(this.writeLog(user,4,sellchanceid,fieldname,"",cmutil.cutString(delvalue,",",3),fn));
			}else{
				//记录日志
				restr.append(this.writeLog(user,2,sellchanceid,fieldname,oldvalue,newvalue,fn));
			}
		}
	}
	
	//添加人员关系
	if("add_contacter_rel".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String relid = Util.fromScreen3(request.getParameter("relid"),user.getLanguage());
		String reltitle = Util.convertInput2DB(URLDecoder.decode(request.getParameter("reltitle"),"utf-8"));
		String contacterid = Util.fromScreen3(request.getParameter("contacterid"),user.getLanguage());
		String oldvalue = "";
		String newvalue = "";
		if(!sellchanceid.equals("") && !relid.equals("") && !contacterid.equals("")){
			rs.executeSql("select t1.contacterid,t2.fullname from CRM_SellChance_Rel t1,CRM_CustomerContacter t2 where t1.contacterid=t2.id and t1.id="+relid+" and t1.sellchanceid="+sellchanceid);
			if(rs.next()){oldvalue = Util.null2String(rs.getString("fullname"));}
			rs.executeSql("update CRM_SellChance_Rel set contacterid="+contacterid+" where id="+relid+" and sellchanceid="+sellchanceid);
			rs.executeSql("select id,title as gender,fullname,jobtitle,lastname,textfield1,email,phoneoffice,mobilephone,projectrole,attitude,attention from CRM_CustomerContacter where id="+contacterid);
			if(rs.next()){
				newvalue = Util.null2String(rs.getString("fullname"));
			%>
				<td class="info" title="姓名:<%=Util.toScreen(rs.getString("fullname"),user.getLanguage())%>">
					<a href="###" onclick="openFullWindowForXtable('/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=rs.getString("id")%>&canedit=true>&frombase=1')" target="_self">
						<%=Util.toScreen(rs.getString("fullname"),user.getLanguage())%>
					</a>
				</td>
				<td class="info" title="称呼:<%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("gender")),user.getLanguage())%>"><%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("gender")),user.getLanguage())%></td>
				<td class="info" title="岗位:<%=Util.null2String(rs.getString("jobtitle"))%>"><%=Util.null2String(rs.getString("jobtitle"))%></td>
				<td class="info" title="部门:<%=Util.null2String(rs.getString("textfield1"))%>">
					<%if(Util.null2String(rs.getString("textfield1")).equals("")){ %>
						<div class="input_blur">部门</div>
					<%}else{ %><%=Util.null2String(rs.getString("textfield1"))%><%} %>
				</td>
				<td class="info" title="联系方式:<%=Util.null2String(rs.getString("mobilephone"))%>">
					<%if(Util.null2String(rs.getString("mobilephone")).equals("")){ %>
						<div class="input_blur">联系方式</div>
					<%}else{ %><%=Util.null2String(rs.getString("mobilephone"))%><%} %>
				</td>
				<td class="info" title="关注点:<%=Util.null2String(rs.getString("attention"))%>">
					<%if(Util.null2String(rs.getString("attention")).equals("")){ %>
						<div class="input_blur">关注点</div>
					<%}else{ %><%=Util.null2String(rs.getString("attention"))%><%} %>
				</td>
				<td class="info" title="意向判断:<%=Util.null2String(rs.getString("attitude"))%>">
					<%if(Util.null2String(rs.getString("attitude")).equals("")){ %>
						<div class="input_blur">意向判断</div>
					<%}else{ %><%=Util.null2String(rs.getString("attitude"))%><%} %>
				</td>													
			<%
			}
			restr.append(this.writeLog(user,2,sellchanceid,reltitle,oldvalue,newvalue,fn));
		}
	}
	//编辑人员关系对应策略
	if("edit_sellchance_detail".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String relid = Util.fromScreen3(request.getParameter("relid"),user.getLanguage());
		String type = Util.fromScreen3(request.getParameter("type"),user.getLanguage());
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String reltitle = Util.convertInput2DB(URLDecoder.decode(request.getParameter("reltitle"),"utf-8"));
		if(type.equals("contacter")){
			rs.executeSql("update CRM_SellChance_Rel set remark='"+newvalue+"' where id="+relid+" and sellchanceid="+sellchanceid);
			
		}
		restr.append(this.writeLog(user,2,sellchanceid,reltitle+"应对策略",oldvalue,newvalue,fn));
	}
	//编辑其他信息
	if("edit_sellchance_other".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String batchid = Util.fromScreen3(request.getParameter("batchid"),user.getLanguage());
		String setid = Util.fromScreen3(request.getParameter("setid"),user.getLanguage());
		String type = Util.fromScreen3(request.getParameter("type"),user.getLanguage());
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String item = Util.convertInput2DB(URLDecoder.decode(request.getParameter("item"),"utf-8"));
		String index = Util.fromScreen3(request.getParameter("index"),user.getLanguage());
		String fieldname = "remark";
		if(index.equals("4")) fieldname = "remark2";
		
		String _type = type.substring(0,1);
		String sqlwhere = "";
		if(!batchid.equals("")) sqlwhere = " and batchid="+batchid;
		rs.executeSql("update CRM_SellChance_Other set "+fieldname+"='"+newvalue+"' where setid="+setid+" and sellchanceid="+sellchanceid+" and type="+_type+sqlwhere);
			
		restr.append(this.writeLog(user,2,sellchanceid,item,oldvalue,newvalue,fn));
	}
	//添加友商信息
	if("add_oppt".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String opptid = Util.fromScreen3(request.getParameter("opptid"),user.getLanguage());
		String opptname = URLDecoder.decode(Util.null2String(request.getParameter("opptname")),"utf-8");
		String default1 = URLDecoder.decode(Util.null2String(request.getParameter("default1")),"utf-8");
		String default2 = URLDecoder.decode(Util.null2String(request.getParameter("default2")),"utf-8");
		int batchid = 0;
		rs.executeSql("select max(batchid) from CRM_SellChance_Other");
		if(rs.next()){
			batchid = Util.getIntValue(rs.getString(1)) + 1;
		}
		rs.executeSql("select t1.id as setid,t1.item from CRM_SellChance_Set t1 where t1.infotype=2 order by id");
		while(rs.next()){
			String setid = Util.null2String(rs.getString("setid"));
			rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,setid,type,remark,remark2,opptid,opptname,batchid)"
					+" values("+sellchanceid+","+setid+",6,'','',"+opptid+",'',"+batchid+")");
			%>
			<tr class="opptitem oppt<%=batchid %>">
				<td class="title2">
					<%=Util.null2String(rs.getString("item")).trim() %>优势
				</td>
				<td>
					<textarea id="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="6" _setid="<%=setid %>" _index="3" class="other_input input_blur" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
					><%=default1 %></textarea>
				</td>
				<td class="title2">
					<%=Util.null2String(rs.getString("item")).trim() %>劣势
				</td>
				<td>
					<textarea id="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" name="apply2_<%=setid %>_<%=opptid %>_<%=batchid %>" _batchid="<%=batchid %>" _type="61" _setid="<%=setid %>" _index="4" class="other_input input_blur" style="width:95%;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
					><%=default2 %></textarea>
				</td>
			</tr>
			<%
		}
			
		this.writeLog(user,3,sellchanceid,"友商优劣势分析","",opptname,fn);
		restr.append("$"+batchid);
	}
	
	//编辑友商名称信息
	if("edit_opptname".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String batchid = Util.fromScreen3(request.getParameter("batchid"),user.getLanguage());
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		
		rs.executeSql("update CRM_SellChance_Other set opptname='"+newvalue+"' where sellchanceid="+sellchanceid+" and batchid="+batchid);
			
		restr.append(this.writeLog(user,2,sellchanceid,"友商名称",oldvalue,newvalue,fn));
	}
	//删除友商信息
	if("del_oppt".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String batchid = Util.fromScreen3(request.getParameter("batchid"),user.getLanguage());
		String opptname = URLDecoder.decode(Util.null2String(request.getParameter("opptname")),"utf-8");
		
		rs.executeSql("delete from CRM_SellChance_Other where sellchanceid="+sellchanceid+" and batchid="+batchid);
			
		restr.append(this.writeLog(user,4,sellchanceid,"友商优劣势分析","",opptname,fn));
	}
	
	//编辑产品明细
	if("edit_product_detail".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String redid = Util.fromScreen3(request.getParameter("redid"),user.getLanguage());
		String productid = Util.fromScreen3(request.getParameter("productid"),user.getLanguage());
		String assetunitid = Util.fromScreen3(request.getParameter("assetunitid"),user.getLanguage());
		String currencyid = Util.fromScreen3(request.getParameter("currencyid"),user.getLanguage());
		double salesprice = Util.getDoubleValue(request.getParameter("salesprice"),0);
		double salesnum = Util.getDoubleValue(request.getParameter("salesnum"),0);
		double totelprice = salesprice*salesnum;
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		
		if(redid.equals("")){//新增
			sql = "insert into CRM_ProductTable(sellchanceid,productid,assetunitid,currencyid,salesprice,salesnum,totelprice)"
				+" values("+sellchanceid+","+productid+","+assetunitid+","+currencyid+","+salesprice+","+salesnum+","+totelprice+")";
			rs.executeSql(sql);
			rs.executeSql("select max(id) from CRM_ProductTable where sellchanceid="+sellchanceid);
			if(rs.next()) redid = Util.null2String(rs.getString(1));
			this.writeLog(user,2,sellchanceid,"product",oldvalue,newvalue,fn);
%>
												<tr id="product_<%=redid %>" class="oppttitle">
													<td class="title3" colspan="2">
														<div class="btn_browser3" onclick="onShowProduct('<%=redid%>')"></div>
														<div class="txt_browser" id='productidSpan_<%=redid %>'><a href="/lgc/asset/LgcAsset.jsp?paraid=<%=productid%>" target="_blank">
															<%=Util.toScreen(AssetComInfo.getAssetName(productid),user.getLanguage())%></a>
														</div>
														<input type=hidden id='productid_<%=redid%>' name='productid_<%=redid%>' value='<%=productid%>' />
													</td>
													<td>
														<span id='assetunitidSpan_<%=redid %>'><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></span>         			
             											<input type=hidden id='assetunitid_<%=redid%>' name='assetunitid_<%=redid%>' value='<%=assetunitid%>' />
								             		</td>
								             		<td>
								             			<div class="btn_browser3" onclick="onShowCurrency('<%=redid%>'')"></div>
														<div class="txt_browser" id='currencyidSpan_<%=redid %>'>
															<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>
														</div>
														<input type=hidden id='currencyid_<%=redid%>' name='currencyid_<%=redid%>' value='<%=currencyid%>' />
								             		</td>
								             		<td>
								             			<input class='pro_input' id='salesprice_<%=redid%>' name='salesprice_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesprice" value='<%=salesprice%>'/>
								             		</td>
								             		<td>
								             			<input class='pro_input' id='salesnum_<%=redid%>' name='salesnum_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesnum" value='<%=salesnum%>'/>
								             		</td>
								             		<td>
								             			<span id='totelprice_<%=redid%>' name='totelprice_<%=redid%>'>
								             				<%=totelprice%>
								             			</span>
								             		</td>
								             		<td align="right">
								             			<div class="opptdel" onclick="delProduct('<%=redid %>',this)" title="删除"></div>	
								             		</td>
								             	</tr>
<%
		}else{//编辑
			sql = "update CRM_ProductTable set productid="+productid+",assetunitid="+assetunitid+",currencyid="+currencyid+",salesprice="+salesprice+",salesnum="+salesnum+",totelprice="+totelprice
				+" where sellchanceid="+sellchanceid+" and id="+redid;
			rs.executeSql(sql);
			this.writeLog(user,2,sellchanceid,"product",oldvalue,newvalue,fn);
		}
	}
	//编辑产品明细字段
	if("edit_product_field".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String redid = Util.fromScreen3(request.getParameter("redid"),user.getLanguage());
		String fieldname = Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage());
		String fieldvalue = Util.fromScreen3(request.getParameter("fieldvalue"),user.getLanguage());
		String totalvalue = Util.fromScreen3(request.getParameter("totalvalue"),user.getLanguage());
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String where = "";
		if(!totalvalue.equals("")){
			where += ",totelprice="+totalvalue;
		}
		rs.executeSql("update CRM_ProductTable set "+fieldname+"="+fieldvalue+where+" where sellchanceid="+sellchanceid+" and id="+redid);
		this.writeLog(user,2,sellchanceid,"product",oldvalue,newvalue,fn);
	}
	//删除产品明细
	if("del_product_detail".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		String redid = Util.fromScreen3(request.getParameter("redid"),user.getLanguage());
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		rs.executeSql("delete from CRM_ProductTable where sellchanceid="+sellchanceid+" and id="+redid);
		this.writeLog(user,4,sellchanceid,"product","",newvalue,fn);
	}
	//添加查看日志
	if("add_log_view".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		this.writeLog(user,0,sellchanceid,"","","",fn);
	}
	//读取日志明细
	if("get_log_count".equals(operation)){
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		rs.executeSql("select count(id) from CRM_SellChanceLog where sellchanceid="+sellchanceid);
		int count = 0;
		if(rs.next()) count = Util.getIntValue(rs.getString(1),0);
		restr.append(count);
	}
	if("get_log_list".equals(operation)){
		String orderby1 = " order by operatedate desc,operatetime desc,id desc";
		String orderby2 = " order by operatedate asc,operatetime asc,id asc";
		String orderby3 = " order by operatedate desc,operatetime desc,id desc";
		String sellchanceid = Util.fromScreen3(request.getParameter("sellchanceid"),user.getLanguage());
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String querysql = "id,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue from CRM_SellChanceLog where sellchanceid="+sellchanceid;
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		String logtxt = "";
		String fieldtxt = "";
		int type = 0;
		while(rs.next()){
			String fieldname = Util.null2String(rs.getString("operatefield"));
			String oldvaltxt = Util.toHtml(Util.convertDbInput(rs.getString("oldvalue")));
			oldvaltxt = getLink(fieldname,oldvaltxt);
			String newvaltxt = Util.toHtml(Util.convertDbInput(rs.getString("newvalue")));
			newvaltxt = getLink(fieldname,newvaltxt);
			fieldtxt = Util.null2String((String)fn.get(fieldname));
			if(fieldtxt.equals("")) fieldtxt = fieldname;
			type = Util.getIntValue(rs.getString("type"));
			switch(type){
				case 0:logtxt="<font class='log_txt'>查看商机</font>";break;
				case 1:logtxt="<font class='log_txt'>新建商机</font>";break;
				case 2:logtxt="<font class='log_txt'>将</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_txt'>由</font> <font class='log_value'>'"+oldvaltxt+"'</font> <font class='log_txt'>更新为</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
				case 3:logtxt="<font class='log_txt'>添加</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
				case 4:logtxt="<font class='log_txt'>删除</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
				case 5:logtxt="设置为进行中";break;
				case 6:logtxt="设置为成果";break;
				case 7:logtxt="设置为失败";break;
				case 8:logtxt="删除任务";break;
				case 9:logtxt="<font class='log_txt'>上传</font> <font class='log_field'>"+fieldtxt+"</font> <font class='log_value'>'"+newvaltxt+"'</font>";break;
			}
%>
	<div class='logitem'>
		<%=cmutil.getHrm(rs.getString("operator")) %>&nbsp;&nbsp;<font class='datetxt'><%=Util.null2String(rs.getString("operatedate"))+" "+Util.null2String(rs.getString("operatetime")) %></font>&nbsp;&nbsp;
		<%=logtxt %>
	</div>
<%
			
		} 
	}
	out.print(restr.toString());
	out.close();
%>
<%!
	private String getHrmLink(String id) throws Exception{
		String returnstr = "";
		if(!"".equals(id) && !"0".equals(id)){
			ResourceComInfo rc = new ResourceComInfo();
			returnstr = "<a href=javascript:searchList("+id+",'"+rc.getLastname(id)+"')>"+rc.getLastname(id)+"</a>";
		}else{
			returnstr = "&nbsp;";
		}
		return returnstr;
	}
	public String cutString(String str,String temp,int type){
		str = Util.null2String(str);
		temp = Util.null2String(temp);
		if(str.equals("") || temp.equals("")){
			return str;
		}
		if(type == 1 || type == 3){
			if(str.startsWith(temp)){
				str = str.substring(temp.length());
			}
		}
		if(type == 2 || type == 3){
			if(str.endsWith(temp)){
				str = str.substring(0,str.length()-temp.length());
			}
		}
		return str;
	}
	/**
	* type  1:新建  2:编辑内容  3:新增内容  4:删除内容 5:进行 6:成功  7:失败  8:删除
	*/
	private String writeLog(User user,int type,String sellchanceid,String field,String oldvalue,String newvalue,Map fn){
		RecordSet rs = new RecordSet();
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		rs.executeSql("update CRM_SellChance set updateuserid="+user.getUID()+",updatedate='"+currentdate+"',updatetime='"+currenttime+"' where id="+sellchanceid);
		rs.executeSql("insert into CRM_SellChanceLog (sellchanceid,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue)"
				+" values("+sellchanceid+","+type+","+user.getUID()+",'"+currentdate+"','"+currenttime+"','"+field+"','"+oldvalue+"','"+newvalue+"')");
		return getlogtext(user.getUID()+"",currentdate+" "+currenttime,type,field,oldvalue,newvalue,fn);
	}
	private String getlogtext(String userid,String datetime,int type,String field,String oldvalue,String newvalue,Map fn){
		String logtxt = "<div class='logitem'>"+getLink("hrmid",userid+"")+"&nbsp;&nbsp;<font class='datetxt'>"+datetime+"</font>&nbsp;&nbsp;";
		String oldvaltxt = getLink(field,oldvalue);
		String newvaltxt = getLink(field,newvalue);
		switch(type){
			case 0:logtxt+="查看商机";break;
			case 1:logtxt+="新建商机";break;
			case 2:logtxt+="将"+fn.get(field)+"由为'"+oldvaltxt+"'更新为'"+newvaltxt+"'";break;
			case 3:logtxt+="添加"+fn.get(field)+"&nbsp;&nbsp;"+newvaltxt;break;
			case 4:logtxt+="删除"+fn.get(field)+"&nbsp;&nbsp;"+newvaltxt;break;
			case 5:logtxt+="设置为进行中";break;
			case 6:logtxt+="设置为成功";break;
			case 7:logtxt+="设置为失败";break;
			case 8:logtxt+="删除商机";break;
			case 9:logtxt+="上传"+fn.get(field)+"&nbsp;&nbsp;"+newvaltxt;break;
		}
		logtxt += "</div>";
		return logtxt;
	}
	private String getLink(String field,String value){
		String returnstr = "";
		CommonTransUtil cmutil = new CommonTransUtil();
		if("hrmid".equals(field)||"manager".equals(field)){
			return cmutil.getHrm(value);
		}else if("customer".equals(field)||"content".equals(field)){
			return cmutil.getCustomer(value);
		}else if("source".equals(field)){
			ContactWayComInfo contactWayComInfo = null;
			try{
				contactWayComInfo = new ContactWayComInfo();
			}catch(Exception e){
				
			}
			return contactWayComInfo.getContactWayname(value);
		}else if("selltype".equals(field)){
			if("1".equals(value)) returnstr = "新签";
			if("2".equals(value)) returnstr = "二次";
			return returnstr;
		}else if("endtatusid".equals(field)){
			if("0".equals(value)) returnstr = "进行中";
			if("1".equals(value)) returnstr = "成功";
			if("2".equals(value)) returnstr = "失败";
			return returnstr;
		}else if("sellstatusid".equals(field)){
			SellstatusComInfo sellstatusComInfo = null;
			try{
				sellstatusComInfo = new SellstatusComInfo();
			}catch(Exception e){
				
			}
			return sellstatusComInfo.getSellStatusname(value);
		}else{
			return value;
		}
	}
%>
