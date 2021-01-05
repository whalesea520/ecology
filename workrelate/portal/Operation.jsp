<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.docs.docs.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.crm.Maint.CustomerInfoComInfo"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.crm.CrmShareBase"%>
<%@ page import="weaver.docs.category.*"%>
<%@ page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="sharemanager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="WorkFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String currentDate = TimeUtil.getCurrentDateString();
	//String currentTime = TimeUtil.getOnlyCurrentTimeString();
	StringBuffer sql =  new StringBuffer();
	StringBuffer countsql =  new StringBuffer();
	StringBuffer restr = new StringBuffer();
	String userid = user.getUID()+"";
	
	if(operation.equals("add_crm")){
		String customerid = Util.null2String(request.getParameter("customerid"));
		if(customerid.startsWith(",")) customerid = customerid.substring(1);
		rs.executeSql("delete from CRM_Common_Attention where operator="+userid+" and operatetype=1 and objid in ("+customerid+")");
		List idList = Util.TokenizerString(customerid,",");
		String cid = "";
		for(int i=0;i<idList.size();i++){
			cid = Util.null2String((String)idList.get(i));
			if(!cid.equals("")) rs.executeSql("insert into CRM_Common_Attention (operatetype,objid,operator,operatedate,operatetime) values(1,"+cid+","+userid+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"')");
		}
	}
	if(operation.equals("del_crm")){
		String customerid = Util.null2String(request.getParameter("customerid"));
		if(!customerid.equals("")){
			rs.executeSql("delete from CRM_Common_Attention where operator="+userid+" and operatetype=1 and objid="+customerid);
		}
	}
	if(operation.equals("get_crmreport")){
		String name = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("name")),"utf-8"),user.getLanguage());
		String type = Util.null2String(request.getParameter("type"));//1为查询重点客户 0为查询所有客户
		
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			sql.append("select t1.status,count(t1.id) as amount from CRM_CustomerInfo t1 where (t1.deleted=0 or t1.deleted is null) ");
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			sql.append("select t1.status,count(distinct t1.id) as amount"
					+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
					+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)");
		}
		if(!name.equals("")){
			sql.append(" and "+this.makeNameWhere(name,"name"));
		}
		if(type.equals("1")){
			sql.append(" and exists(select 1 from CRM_Common_Attention t3 where t1.id=t3.objid and t3.operatetype=1 and t3.operator="+userid+")");
		}
		sql.append(" and t1.status in (1,2,3,4) group by t1.status");
		//System.out.println("reportsql:"+sql.toString());
		rs.executeSql(sql.toString());
		String datastr = "";
		int[] datas = {0,0,0,0};//无效、基础、潜在、成功
		while(rs.next()){
			if(Util.null2String(rs.getString(1)).equals("1")){
				datas[0] = Util.getIntValue(rs.getString(2),0);
			}else if(Util.null2String(rs.getString(1)).equals("2")){
				datas[1] = Util.getIntValue(rs.getString(2),0);
			}else if(Util.null2String(rs.getString(1)).equals("3")){
				datas[2] = Util.getIntValue(rs.getString(2),0);
			}else{
				datas[3] = Util.getIntValue(rs.getString(2),0);
			}
		}
		datastr = "[{name:'无效',y:"+datas[0]+",value:1},{name:'基础',y:"+datas[1]+",value:2},{name:'潜在',y:"+datas[2]+",value:3},{name:'成功',y:"+datas[3]+",value:4}]";
%>
	<div id="crmreportdiv" style="width: 100%;height: 100%"></div>
	<script type="text/javascript" >
			$(document).ready(function() {
				
				var chart = new Highcharts.Chart({
		            chart: {
		                renderTo: 'crmreportdiv',
		                plotBackgroundColor: null,
		                plotBorderWidth: 0,
		                plotShadow: false,
		                backgroundColor: '#fff',
		                borderWidth: 0
		            },
		            title: {
		                text: ''
		            },
		            tooltip: {
		            	enabled: true,
		                formatter: function() {
		                    return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage*100)/100 +' %';
		                }
		            },
		            plotOptions: {
		                pie: {
		            		borderWidth: 0,
		            		shadow: true,
		                    allowPointSelect: true,
		                    cursor: 'pointer',
		                    dataLabels: {
		                        enabled: false,
		                        color: '#000000',
		                        connectorColor: '#616161',
		                        formatter: function() {
		                            return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage*100)/100 +' %';
		                        }
		                    },
		                    events:{//监听点的鼠标事件  
		                    	click: function(event) {
		                    		getCrm(20,1,event.point.value);
		                    	} 
		                	},
		                	showInLegend: true
		                }
		            },
		            series: [{
		                type: 'pie',
		                name: 'Browser share',
		                data: <%=datastr%>
		            }]
		        });
			});
	</script>
<%
	}
	
	
	if(operation.equals("get_crm")){
		String name = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("name")),"utf-8"),user.getLanguage());
		String type = Util.null2String(request.getParameter("type"));//1为查询重点客户 0为查询所有客户
		int status = Util.getIntValue(request.getParameter("crmstatus"),0);
		
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			sql.append(" t1.id,t1.name,t1.createdate,t1.manager from CRM_CustomerInfo t1 where (t1.deleted=0 or t1.deleted is null)");
			countsql.append("select count(distinct t1.id) from CRM_CustomerInfo t1 where (t1.deleted=0 or t1.deleted is null) ");
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			sql.append(" t1.id,t1.name,t1.createdate,t1.manager"
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)");
			countsql.append("select count(distinct t1.id) "
					+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
					+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)");
		}
		if(!name.equals("")){
			sql.append(" and "+this.makeNameWhere(name,"name"));
			countsql.append(" and "+this.makeNameWhere(name,"name"));
		}
		if(type.equals("1")){
			sql.append(" and exists(select 1 from CRM_Common_Attention t3 where t1.id=t3.objid and t3.operatetype=1 and t3.operator="+userid+")");
			countsql.append(" and exists(select 1 from CRM_Common_Attention t3 where t1.id=t3.objid and t3.operatetype=1 and t3.operator="+userid+")");
		}
		if(status!=0){
			sql.append(" and t1.status="+status);
			countsql.append(" and t1.status="+status);
		}
		String orderby1 = " order by createdate desc,id desc";
		String orderby2 = " order by createdate asc,id asc";
		String orderby3 = " order by t1.createdate desc,t1.id desc";
		int total = 0;
		rs.executeSql(countsql.toString());
		if(rs.next()) total = rs.getInt(1);
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),8);
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		String querysql = "select top " + ipageset +" A.id,A.name,A.createdate,A.manager from (select distinct top "+ iNextNum + sql.toString()+ orderby3 + ") A "+orderby2;
		querysql = "select top " + ipageset +" B.id,B.name,B.createdate,B.manager"
				//+",(select top 1 wp.begindate FROM WorkPlan wp,WorkPlanShareDetail sd where wp.id = sd.workid and wp.type_n = 3 and (',' + wp.crmid + ',') like '%,'+convert(varchar,B.id)+',%' and sd.usertype = 1 and wp.createrType='1' and sd.userid="+userid+" order by wp.begindate desc,wp.begintime desc) as contactdate"
				+" from (" + querysql.toString() + ") B "+orderby1;
		//System.out.println(querysql);
		rs.executeSql(querysql);
%>
	<table class="datalist" cellpadding="0" cellspacing="0" border="0">
		<colgroup><col width="10px"/><col width="*"/><col width="44px"/><col width="36px"/><col width="75px"/><col width="28px"/>
		<%if(type.equals("1")){ %>			
			<col width="20px"/>					
		<%} %>
		</colgroup>	
<%		String contactstr = "";
		String contactdate = "";
		String contacttitle = "";
		while(rs.next()){
			//Util.null2String(rs.getString("contactdate"));
			//rs2.executeSql("select top 1 wp.begindate FROM WorkPlan wp where (',' + wp.crmid + ',') like '%,"+rs.getString("id")+",%' and wp.createrType=1 and wp.type_n = '3' order by wp.begindate desc,wp.begintime desc");
			contactdate = "";
			rs2.executeSql(" SELECT top 1 a.begindate FROM WorkPlan a " 
				//+ " AND (',' + a.crmid + ',') LIKE '%," + rs.getString("id") + ",%'" 
				+ " where a.crmid = '" + rs.getString("id") + "'" 
				//+ " AND b.usertype = 1 AND a.createrType='1' AND b.userid = " + userid
				+ " AND a.type_n = 3 "
				+ " ORDER BY a.begindate DESC, a.begintime DESC");
			if(rs2.next()) contactdate = Util.null2String(rs2.getString(1));
			if("".equals(contactdate)){
				contactstr = "未有联系记录";
				contacttitle = "";
			}else{
				int days = TimeUtil.dateInterval(contactdate,TimeUtil.getCurrentDateString());
				if(days==0){
					contactstr = "今天已联系";
				}else{
					contactstr = days+"天未联系";
				}
				contacttitle = "最后联系日期:"+contactdate;
				contactdate = contactdate.substring(5)+",";
			}
%>
			<tr class="tr_data">
				<td class="point"></td>
				<td title="<%=rs.getString("name")%>"><%=this.getCustomer(rs.getString("id"))%></td>
				<td class="info"><%=this.getHrm(rs.getString("manager"))%></td>
				<%if("".equals(contactdate)){ %>
				<td class="info" colspan="2" style="padding-left: 1px;">
						<%=contactstr%>
				</td>
				<%}else{ %>
				<td class="info">
					<a title="<%=contacttitle %>" href="javascript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?activeId=crmContract&log=n&CustomerID=<%=rs.getString("id")%>')" >
						<%=contactdate%>
					</a>
				</td>
				<td class="info"><%=contactstr%></td>
				<%} %>
				<!-- td><a class="btn_feedback" href="javascript:dofeedback('<%=rs.getString("id") %>','<%=rs.getString("name")%>',1)">反馈</a></td -->
			<%if(type.equals("1")){ %>			
				<td><div class="btn_del" title="删除" onclick="onDelCRM('<%=rs.getString("id") %>')"></div></td>				
			<%} %>
			</tr>
<%
		}
		if(type.equals("1")){
			for(int i=0;i<pagesize-rs.getCounts();i++){
%>
			<tr><td colspan="6"><div style="cursor: pointer;font-style: italic;color: #B6B6B6;padding-left: 4px;" onclick="onAddCRM()">点击添加重要客户</div></td></tr>
<%
			}
			
		}
%>
	</table>
<%
		restr.append("$"+total);
	}
	
	
	if(operation.equals("add_sellchance")){
		String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
		if(sellchanceid.startsWith(",")) sellchanceid = sellchanceid.substring(1);
		rs.executeSql("delete from CRM_Common_Attention where operator="+userid+" and operatetype=2 and objid in ("+sellchanceid+")");
		List idList = Util.TokenizerString(sellchanceid,",");
		String cid = "";
		for(int i=0;i<idList.size();i++){
			cid = Util.null2String((String)idList.get(i));
			//if(!cid.equals("")) rs.executeSql("insert into SP_SellchanceImp (sellchanceid,hrmid) values("+cid+","+userid+")");
			if(!cid.equals("")) rs.executeSql("insert into CRM_Common_Attention (operatetype,objid,operator,operatedate,operatetime) values(2,"+cid+","+userid+",'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"')");
		}
	}
	if(operation.equals("del_sellchance")){
		String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
		if(!sellchanceid.equals("")){
			//rs.executeSql("delete from SP_SellchanceImp where hrmid="+userid+" and sellchanceid="+sellchanceid);
			//rs.executeSql("delete from CRM_SellChance_Attention where userId="+userid+" and sellchanceId="+sellchanceid);
			rs.executeSql("delete from CRM_Common_Attention where objid="+sellchanceid+" and operatetype=2 and operator="+userid);
		}
	}
	if(operation.equals("get_sellchancereport")){
		String name = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("name")),"utf-8"),user.getLanguage());
		String type = Util.null2String(request.getParameter("type"));//1为查询重点 0为查询所有
		
		String condition = this.getCustomerStr(user);
		sql.append("select t.sellstatusid,count(t.id) from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id where t.endtatusid=0");
		
		if(!name.equals("")){
			sql.append(" and "+this.makeNameWhere(name,"t.subject"));
		}
		if(type.equals("1")){
			//sql.append(" and exists(select 1 from SP_SellchanceImp t3 where t.id=t3.sellchanceid and t3.hrmid="+userid+")");
			sql.append(" and exists(select 1 from CRM_Common_Attention t3 where t.id=t3.objid and t3.operatetype=2 and t3.operator="+userid+")");
		}
		sql.append(" group by t.sellstatusid");
		//System.out.println("reportsql:"+sql.toString());
		rs.executeSql(sql.toString());
		String idstr = "";
		String titlestr = "";
		String datastr = "";
		int[] datas = {0,0,0,0};//'成功签约', '商务谈判', '方案沟通', '初步接触
		Map countmap = new HashMap();
		while(rs.next()){
			countmap.put(Util.null2String(rs.getString(1)),Util.null2String(rs.getString(2)));
		}
		
		rs2.executeSql("select id,fullname from CRM_SellStatus order by id");
		int[] ids = new int[rs2.getCounts()];
		int[] counts = new int[rs2.getCounts()];
		String[] names = new String[rs2.getCounts()];
		int temp=0;
		while(rs2.next()){
			ids[temp] = Util.getIntValue(rs2.getString("id"));
			names[temp] = Util.null2String(rs2.getString("fullname"));
			counts[temp] = Util.getIntValue((String)countmap.get(rs2.getString("id")),0);
			temp++;
		}
		for(int i=0;i<ids.length;i++){
			idstr += ","+ids[i];
			datastr += ","+counts[i];
			titlestr += ",'"+names[i]+"'";
		}
		if(!idstr.equals("")) idstr = idstr.substring(1);
		if(!titlestr.equals("")) titlestr = "["+titlestr.substring(1)+"]";
		if(!datastr.equals("")) datastr = "["+datastr.substring(1)+"]";
%>
	<div id="chancereportdiv" style="width: 100%;height: 100%"></div>
	<script type="text/javascript" >
			var _sellstatus = new Array(<%=idstr%>);
			$(document).ready(function() {
				
				var chart = new Highcharts.Chart({
		            chart: {
						borderWidth: 0,
		                renderTo: 'chancereportdiv',
		                type: 'bar'
		            },
		            title: {
		                text: ''
		            },
		            subtitle: {
		                text: ''
		            },
		            xAxis: {
		                categories: <%=titlestr%>,
		                title: {
		                    text: null
		                }
		            },
		            yAxis: {
		                min: 0,
		                title: {
		                    text: '',
		                    align: 'high'
		                },
		                labels: {
		                    overflow: 'justify'
		                }
		            },
		            tooltip: {
		            	enabled: false,
		                formatter: function() {
		                    //return ''+ this.x +'';
		                }
		            },
		            plotOptions: {
		                bar: {
		            		borderWidth: 0,
		                    dataLabels: {
		                        enabled: true
		                    },
		                    events:{//监听点的鼠标事件  
		                    	click: function(event) {
		                    		getChance(20,1,_sellstatus[event.point.x]);
		                    	} 
		                	}
		                }
		            },
		            legend: {
		            	enabled: false
		            },
		            series: [{
		                data: <%=datastr%>,
		                dataLabels: {
		                    enabled: true,
		                    rotation: 0,
		                    color: '#FFFFFF',
		                    align: 'right',
		                    x: 0,
		                    y: 0,
		                    style: {
		                        fontSize: '13px',
		                        fontFamily: 'Verdana, sans-serif'
		                    }
		                }
		            }]
		        });
			});
	</script>
<%
	}
	if(operation.equals("get_sellchance")){
		String name = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("name")),"utf-8"),user.getLanguage());
		String type = Util.null2String(request.getParameter("type"));//1为查询重点机会 0为查询所有机会
		int sellstatus = Util.getIntValue(request.getParameter("sellstatus"),0);
		
		String condition = this.getCustomerStr(user);
		countsql.append("select count(distinct t.id) from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id where t.endtatusid=0");
		sql.append(" t.id,t.customerid,t.creater,t.subject,t.sellstatusid,t.createdate,t.createtime from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id where t.endtatusid=0");
		
		if(!name.equals("")){
			sql.append(" and "+this.makeNameWhere(name,"t.subject"));
			countsql.append(" and "+this.makeNameWhere(name,"t.subject"));
		}
		if(type.equals("1")){
			sql.append(" and exists(select 1 from CRM_Common_Attention t3 where t.id=t3.objid and t3.operatetype=2 and t3.operator="+userid+")");
			countsql.append(" and exists(select 1 from CRM_Common_Attention t3 where t.id=t3.objid and t3.operatetype=2 and t3.operator="+userid+")");
		}
		if(sellstatus!=0){
			sql.append(" and t.sellstatusid="+sellstatus);
			countsql.append(" and t.sellstatusid="+sellstatus);
		}
		String orderby1 = " order by createdate desc,createtime desc";
		String orderby2 = " order by createdate asc,createtime asc";
		String orderby3 = " order by t.createdate desc,t.createtime desc";
		int total = 0;
		rs.executeSql(countsql.toString());
		if(rs.next()) total = rs.getInt(1);
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),8);
		
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		String querysql = "select top " + ipageset +" A.* from (select distinct top "+ iNextNum + sql.toString()+ orderby3 + ") A "+orderby2;
		querysql = "select top " + ipageset +" B.* from (" + querysql.toString() + ") B "+orderby1;
		rs.executeSql(querysql);
%>
	<table class="datalist" cellpadding="0" cellspacing="0" border="0">
		<colgroup><col width="10px"/><col width="*"/><col width="44px"/><col width="80px"/><col width="28px"/>
		<%if(type.equals("1")){ %>			
			<col width="20px"/>					
		<%} %>
		</colgroup>	
<%
		while(rs.next()){
%>
			<tr class="tr_data">
				<td class="point"></td>
				<td title="<%=rs.getString("subject")%>"><a href="javascript:openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?id=<%=rs.getString("id")%>&CustomerID=<%=rs.getString("customerid")%>')" target="_self"><%=Util.null2String(rs.getString("subject"))%></a></td>
				<td class="info"><%=this.getHrm(rs.getString("creater"))%></td>
				<td class="info"><%=SellstatusComInfo.getSellStatusname(Util.null2String(rs.getString("sellstatusid")))%></td>
				<td><a class="btn_feedback" href="javascript:dofeedback('<%=rs.getString("customerid") %>','<%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("customerid")) %>',2)">反馈</a></td>
			<%if(type.equals("1")){ %>			
				<td><div class="btn_del" title="删除" onclick="onDelChance('<%=rs.getString("id") %>')"></div></td>				
			<%} %>
			</tr>
<%
		}
		if(type.equals("1")){
			for(int i=0;i<pagesize-rs.getCounts();i++){
%>
			<tr><td colspan="6"><div style="cursor: pointer;font-style: italic;color: #B6B6B6;padding-left: 4px;" onclick="onAddChance()">点击添加重要商机</div></td></tr>
<%
			}
			
		}
%>
	</table>
<%
		restr.append("$"+total);
	}
	
	//获取工作成果
	if(operation.equals("get_result")){
		String begindate = Util.null2String(request.getParameter("begindate"));
		String enddate = Util.null2String(request.getParameter("enddate"));
		if(begindate.equals("")) begindate = TimeUtil.getCurrentDateString();
		if(enddate.equals("")) enddate = TimeUtil.getCurrentDateString();
		//流程
		int wf_create = 0;
		int wf_deal = 0;
		rs.executeSql("select count(requestid) as amount from workflow_requestbase where creater="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"'"
				+"union all select count(requestid) as amount from workflow_requestLog where operator="+userid+" and operatedate>='"+begindate+"' and operatedate<='"+enddate+"'");
		if(rs.next()) wf_create = rs.getInt(1);
		if(rs.next()) wf_deal = rs.getInt(1);
		//文档
		int doc_create = 0;
		int doc_view = 0;
		int doc_replay = 0;
		rs.executeSql("select count(id) as amount from DocDetail where isreply<>1 and doccreaterid="+userid+" and doccreatedate>='"+begindate+"' and doccreatedate<='"+enddate+"'"
				+"union all select count(docid) as amount from DocDetailLog where operateuserid="+userid+" and operatedate>='"+begindate+"' and operatedate<='"+enddate+"'"
				+"union all select count(id) as amount from DocDetail where isreply=1 and doccreaterid="+userid+" and doccreatedate>='"+begindate+"' and doccreatedate<='"+enddate+"'");
		if(rs.next()) doc_create = rs.getInt(1);
		if(rs.next()) doc_view = rs.getInt(1);
		if(rs.next()) doc_replay = rs.getInt(1);
		//协助
		int cwork_create = 0;
		int cwork_view = 0;
		int cwork_replay = 0;
		rs.executeSql("select count(coworkid) as amount from cowork_log where type=1 and modifier="+userid+" and modifydate>='"+begindate+"' and modifydate<='"+enddate+"'"
				+"union all select count(coworkid) as amount from cowork_log where type=2 and modifier="+userid+" and modifydate>='"+begindate+"' and modifydate<='"+enddate+"'"
				+"union all select count(coworkid) as amount from cowork_discuss where discussant="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"'");
		if(rs.next()) cwork_create = rs.getInt(1);
		if(rs.next()) cwork_view = rs.getInt(1);
		if(rs.next()) cwork_replay = rs.getInt(1);
		//日程
		int workplan_create = 0;
		int workplan_view = 0;
		int workplan_replay = 0;
		rs.executeSql("select count(workPlanId) as amount from WorkPlanViewLog where viewType=1 and userType=1 and userId="+userid+" and logDate>='"+begindate+"' and logDate<='"+enddate+"'"
				+"union all select count(workPlanId) as amount from WorkPlanViewLog where viewType=3 and userType=1 and userId="+userid+" and logDate>='"+begindate+"' and logDate<='"+enddate+"'"
				+"union all select count(sortid) as amount from Exchange_Info where type_n='WP' and creater="+userid+" and createDate>='"+begindate+"' and createdate<='"+enddate+"'");
		if(rs.next()) workplan_create = rs.getInt(1);
		if(rs.next()) workplan_view = rs.getInt(1);
		if(rs.next()) workplan_replay = rs.getInt(1);
		//客户
		int crm_create = 0;
		int crm_contact = 0;
		rs.executeSql("select count(customerid) as amount from CRM_Log where logtype='n' and submiter="+userid+" and submitdate>='"+begindate+"' and submitdate<='"+enddate+"'"
				+"union all select count(id) as amount from WorkPlan where type_n='3' and createrid="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"'");
		if(rs.next()) crm_create = rs.getInt(1);
		if(rs.next()) crm_contact = rs.getInt(1);
		//商机
		int sellchance_create = 0;
		rs.executeSql("select count(id) as amount from CRM_SellChance where creater="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"'");
		if(rs.next()) sellchance_create = rs.getInt(1);
%>
	<table style="width: 100%;" cellpadding="0" cellspacing="2" border="0">
		<colgroup><col width="33%"/><col width="34%"/><col width="33%"/></colgroup>
		<tr>
			<td class="result1">
				<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup><col width="*"/><col width="1px"/><col width="45%"/></colgroup>
					<tr>
						<td class="result_data1" valign="bottom" _title1="创建" _title2="流程" _typeone="0" _typetwo="0"><%=wf_create %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data2" valign="bottom" _title1="处理" _title2="流程" _typeone="0" _typetwo="1"><%=wf_deal %></td>
					</tr>
					<tr><td colspan="3" class="result_title">流程</td></tr>
				</table>
			</td>
			<td class="result2">
				<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup><col width="28%"/><col width="1px"/><col width="*"/><col width="1px"/><col width="28%"/></colgroup>
					<tr>
						<td class="result_data2" valign="bottom" _title1="新建" _title2="文档" _typeone="1" _typetwo="0"><%=doc_create %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data1" valign="bottom" _title1="查阅" _title2="文档" _typeone="1" _typetwo="1"><%=doc_view %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data2" valign="bottom" _title1="回复" _title2="文档" _typeone="1" _typetwo="2"><%=doc_replay %></td>
					</tr>
					<tr><td colspan="5" class="result_title">文档</td></tr>
				</table>
			</td>
			<td class="result1">
				<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup><col width="28%"/><col width="1px"/><col width="28%"/><col width="1px"/><col width="*"/></colgroup>
					<tr>
						<td class="result_data2" valign="bottom" _title1="发起" _title2="协助" _typeone="2" _typetwo="0"><%=cwork_create %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data2" valign="bottom" _title1="查阅" _title2="协助" _typeone="2" _typetwo="1"><%=cwork_view %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data1" valign="bottom" _title1="回复" _title2="协助" _typeone="2" _typetwo="2"><%=cwork_replay %></td>
					</tr>
					<tr><td colspan="5" class="result_title">协助</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="result2">
				<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup><col width="*"/><col width="1px"/><col width="28%"/><col width="1px"/><col width="28%"/></colgroup>
					<tr>
						<td class="result_data1" valign="bottom" _title1="发起" _title2="日程" _typeone="3" _typetwo="0"><%=workplan_create %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data2" valign="bottom" _title1="查阅" _title2="日程" _typeone="3" _typetwo="1"><%=workplan_view %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data2" valign="bottom" _title1="反馈" _title2="日程" _typeone="3" _typetwo="2"><%=workplan_replay %></td>
					</tr>
					<tr><td colspan="5" class="result_title">日程</td></tr>
				</table>
			</td>
			<td class="result1">
				<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup><col width="*"/><col width="1px"/><col width="45%"/></colgroup>
					<tr>
						<td class="result_data1" valign="bottom" _title1="新建" _title2="客户" _typeone="4" _typetwo="0"><%=crm_create %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data2" valign="bottom" _title1="联系" _title2="客户" _typeone="4" _typetwo="1"><%=crm_contact %></td>
					</tr>
					<tr><td colspan="3" class="result_title">客户</td></tr>
				</table>
			</td>
			<td class="result2">
				<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
					<colgroup><col width="*"/><col width="1px"/><col width="45%"/></colgroup>
					<tr>
						<td class="result_data1" valign="bottom" _title1="新建" _title2="商机" _typeone="5" _typetwo="0"><%=sellchance_create %></td>
						<td style="height: 40px;" valign="bottom"><div class="result_line"></div></td>
						<td class="result_data2" valign="bottom" _title1="联系" _title2="商机" _typeone="5" _typetwo="1"><%=crm_contact %></td>
					</tr>
					<tr><td colspan="3" class="result_title">商机</td></tr>
				</table>
			</td>
		</tr>
	</table>
	<script type="text/javascript">
		$("td.result_data1,td.result_data2").bind("mouseenter",function(){
			$("#result_txt").html("你今天"+$(this).attr("_title1")+"了"+" <font style='font-size:20px'>"+$(this).html()+"</font> 个"+$(this).attr("_title2"));
			$("#result_btn").attr("_typeone",$(this).attr("_typeone")).attr("_typetwo",$(this).attr("_typetwo"));
			var t = $(this).offset().top+40;
			var l = $(this).offset().left+$(this).width()/2-84;
			$("#result_float").css({"top":t,"left":l}).show();
		}).bind("mouseleave",function(){
			$("#result_float").hide();
		});
	</script>
<%
	}
	
	//获取工作成果明细
	if(operation.equals("get_result_detail")){
		String begindate = Util.null2String(request.getParameter("begindate"));
		String enddate = Util.null2String(request.getParameter("enddate"));
		int type = Util.getIntValue(request.getParameter("type"),0);
		int showindex = Util.getIntValue(request.getParameter("showindex"),0);
		
		if(begindate.equals("")) begindate = TimeUtil.getCurrentDateString();
		if(enddate.equals("")) enddate = TimeUtil.getCurrentDateString();
		if(type==0){//流程
			int count1 = 0;
			int count2 = 0;
%>
		<div id="his<%=type%>_<%=begindate %>" class="hisdetail">
			<div class="his_list">
				<div class="his_scroll">
				<table class="tab_table">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
				<%
					rs.executeSql("select requestid,requestname,createdate,createtime,creater from workflow_requestbase where creater="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"' order by createdate desc,createtime desc");
					while(rs.next()){
						count1++;
				%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("createtime")) %></td><td title="<%=rs.getString("requestname") %>"><a href="javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=<%=rs.getString("requestid")%>')" ><%=rs.getString("requestname") %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
				<% 	}
					if(count1==0){
				%>
					<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
				<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
				<%
					rs.executeSql("select t1.requestid,t2.requestname,t2.creater,t2.createdate,t2.createtime from workflow_requestLog t1 join workflow_requestbase t2 on t1.requestid=t2.requestid where t1.operator="+userid+" and t1.operatedate>='"+begindate+"' and t1.operatedate<='"+enddate+"' order by t1.operatedate desc,t1.operatetime desc");
					while(rs.next()){
						count2++;
				%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("createtime")) %></td><td title="<%=rs.getString("requestname") %>"><a href="javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=<%=rs.getString("requestid")%>')" ><%=rs.getString("requestname") %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
				<% 	}
					if(count2==0){
				%>
					<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
				<%	} %>
				</table>
				</div>
			</div>
			<div class="his_tab2 his_tab2_click" style="" _index="0">发起(<%=count1 %>)</div>
			<div class="his_tab2" style="top: 39px;" _index="1">处理(<%=count2 %>)</div>
		</div>
<% 		}else if(type==1){//文档
			int count1 = 0;
			int count2 = 0;
			int count3 = 0;
%>
		<div id="his<%=type%>_<%=begindate %>" class="hisdetail">
			<div class="his_list">
				<div class="his_scroll">
				<table class="tab_table">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select id,doccreaterid as creater,doccreatetime as time from DocDetail where isreply<>1 and doccreaterid="+userid+" and doccreatedate>='"+begindate+"' and doccreatedate<='"+enddate+"' order by doccreatedate desc,doccreatetime desc");
						while(rs.next()){
							count1++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=DocComInfo.getDocname(rs.getString("id")) %>"><a href="javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=rs.getString("id")%>')" ><%=DocComInfo.getDocname(rs.getString("id")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count1==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select docid as id,doccreater as creater,operatetime as time from DocDetailLog where operateuserid="+userid+" and operatedate>='"+begindate+"' and operatedate<='"+enddate+"' order by operatedate desc,operatetime desc");
						while(rs.next()){
							count2++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=DocComInfo.getDocname(rs.getString("id")) %>"><a href="javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=rs.getString("id")%>')" ><%=DocComInfo.getDocname(rs.getString("id")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count2==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select id,doccreaterid as creater,doccreatetime as time from DocDetail where isreply=1 and doccreaterid="+userid+" and doccreatedate>='"+begindate+"' and doccreatedate<='"+enddate+"' order by doccreatedate desc,doccreatetime desc");
						while(rs.next()){
							count3++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=DocComInfo.getDocname(rs.getString("id")) %>"><a href="javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=rs.getString("id")%>')" ><%=DocComInfo.getDocname(rs.getString("id")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count3==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				</div>
			</div>
			<div class="his_tab2 his_tab2_click" style="" _index="0">新建(<%=count1 %>)</div>
			<div class="his_tab2" style="top: 39px;" _index="1">查阅(<%=count2 %>)</div>
			<div class="his_tab2" style="top: 78px;" _index="2">回复(<%=count3 %>)</div>
		</div>
<%		}else if(type==2){ //协助
			int count1 = 0;
			int count2 = 0;
			int count3 = 0;
%>
		<div id="his<%=type%>_<%=begindate %>" class="hisdetail">
			<div class="his_list">
				<div class="his_scroll">
				<table class="tab_table">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select t2.id,t2.name,t2.creater,t1.modifytime as time from cowork_log t1 left join cowork_items t2  on t1.coworkid=t2.id where type=1 and modifier="+userid+" and modifydate>='"+begindate+"' and modifydate<='"+enddate+"' order by t1.modifydate desc,t1.modifytime desc");
						while(rs.next()){
							count1++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/cowork/ViewCoWork.jsp?id=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count1==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select t2.id,t2.name,t2.creater,t1.modifytime as time from cowork_log t1 left join cowork_items t2 on t1.coworkid=t2.id where t1.type=2 and t1.modifier="+userid+" and t1.modifydate>='"+begindate+"' and t1.modifydate<='"+enddate+"' order by t1.modifydate desc,t1.modifytime desc");
						while(rs.next()){
							count2++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/cowork/ViewCoWork.jsp?id=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count2==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select t1.coworkid as id,t2.name,t2.creater,t1.createtime as time from cowork_discuss t1 left join cowork_items t2 on t1.coworkid=t2.id where t1.discussant="+userid+" and t1.createdate>='"+begindate+"' and t1.createdate<='"+enddate+"' order by t2.createdate desc,t2.createtime desc");
						while(rs.next()){
							count3++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/cowork/ViewCoWork.jsp?id=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count3==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				</div>
			</div>
			<div class="his_tab2 his_tab2_click" style="" _index="0">发起(<%=count1 %>)</div>
			<div class="his_tab2" style="top: 39px;" _index="1">查阅(<%=count2 %>)</div>
			<div class="his_tab2" style="top: 78px;" _index="2">回复(<%=count3 %>)</div>
		</div>
<%		}else if(type==3){//日程
			int count1 = 0;
			int count2 = 0;
			int count3 = 0;
%>
		<div id="his<%=type%>_<%=begindate %>" class="hisdetail">
			<div class="his_list">
				<div class="his_scroll">
				<table class="tab_table">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select t1.workPlanId as id,t1.userId as creater,t2.name,t1.logTime as time from WorkPlanViewLog t1 join WorkPlan t2 on t1.workPlanId=t2.id where t1.viewType=1 and t2.type_n<>3 and t1.userType=1 and t1.userId="+userid+" and t1.logDate>='"+begindate+"' and t1.logDate<='"+enddate+"' order by t1.logDate desc,t1.logTime desc");
						while(rs.next()){
							count1++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/workplan/data/WorkPlanDetail.jsp?workid=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count1==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select t1.workPlanId as id,t1.userId as creater,t2.name,t1.logTime as time from WorkPlanViewLog t1 join WorkPlan t2 on t1.workPlanId=t2.id where t1.viewType=3 and t2.type_n<>3 and t1.userType=1 and t1.userId="+userid+" and t1.logDate>='"+begindate+"' and t1.logDate<='"+enddate+"' order by t1.logDate desc,t1.logTime desc");
						while(rs.next()){
							count2++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/workplan/data/WorkPlanDetail.jsp?workid=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count2==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select t1.sortid as id,t1.creater,t2.name,t1.createTime as time from Exchange_Info t1 join WorkPlan t2 on t1.sortid=t2.id where t1.type_n='WP' and t2.type_n<>3 and t1.creater="+userid+" and t1.createDate>='"+begindate+"' and t1.createdate<='"+enddate+"' order by t1.createDate desc,t1.createTime desc");
						while(rs.next()){
							count3++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/workplan/data/WorkPlanDetail.jsp?workid=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count3==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				</div>
			</div>
			<div class="his_tab2 his_tab2_click" style="" _index="0">发起(<%=count1 %>)</div>
			<div class="his_tab2" style="top: 39px;" _index="1">查阅(<%=count2 %>)</div>
			<div class="his_tab2" style="top: 78px;" _index="2">反馈(<%=count3 %>)</div>
		</div>
<%			
		}else if(type==4){ //客户
			int count1 = 0;
			int count2 = 0;
%>
		<div id="his<%=type%>_<%=begindate %>" class="hisdetail">
			<div class="his_list">
				<div class="his_scroll">
				<table class="tab_table">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select customerid as id,submiter as creater,submittime as time from CRM_Log where logtype='n' and submiter="+userid+" and submitdate>='"+begindate+"' and submitdate<='"+enddate+"' order by submitdate desc,submittime desc");
						while(rs.next()){
							count1++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=CustomerInfoComInfo.getCustomerInfoname(rs.getString("id")) %>"><%=this.getCustomer(rs.getString("id")) %></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count1==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select id,createrid as creater,name,createtime as time from WorkPlan where type_n=3 and createrid="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"' order by createdate desc,createtime desc");
						while(rs.next()){
							count2++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/workplan/data/WorkPlanDetail.jsp?workid=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count2==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				</div>
			</div>
			<div class="his_tab2 his_tab2_click" style="" _index="0">新建(<%=count1 %>)</div>
			<div class="his_tab2" style="top: 39px;" _index="1">联系(<%=count2 %>)</div>
		</div>
<%			
		}else if(type==5){ //商机
			int count1 = 0;
			int count2 = 0;
%>
		<div id="his<%=type%>_<%=begindate %>" class="hisdetail">
			<div class="his_list">
				<div class="his_scroll">
				<table class="tab_table">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select id,subject,creater,customerid,createtime as time from CRM_SellChance where creater="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"' order by createdate desc,createtime desc");
						while(rs.next()){
							count1++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("subject")) %>"><a href="javaScript:openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?id=<%=rs.getString("id")%>&CustomerID=<%=rs.getString("customerid")%>')" ><%=Util.null2String(rs.getString("subject")) %></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count1==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				<table class="tab_table" style="display: none;">
					<colgroup><col width="10px"/><col width="55px"/><col width="*"/><col width="50px"/></colgroup>
					<%
						rs.executeSql("select id,createrid as creater,name,createtime as time from WorkPlan where type_n=3 and createrid="+userid+" and createdate>='"+begindate+"' and createdate<='"+enddate+"' order by createdate desc,createtime desc");
						while(rs.next()){
							count2++;
					%>
					<tr><td class="tab_icon2"></td><td><%=Util.null2String(rs.getString("time")) %></td><td title="<%=Util.null2String(rs.getString("name")) %>"><a href="javaScript:openFullWindowHaveBar('/workplan/data/WorkPlanDetail.jsp?workid=<%=rs.getString("id")%>')" ><%=Util.null2String(rs.getString("name"))%></a></td><td><%=this.getHrm(rs.getString("creater")) %></td></tr>
					<% 	}
						if(count2==0){
					%>
						<tr><td class="tab_none" colspan="4">无相关数据！</td></tr>
					<%	} %>
				</table>
				</div>
			</div>
			<div class="his_tab2 his_tab2_click" style="" _index="0">新建(<%=count1 %>)</div>
			<div class="his_tab2" style="top: 39px;" _index="1">联系(<%=count2 %>)</div>
		</div>
<%			
		}
%>
		<script type="text/javascript">
			$(document).ready(function(){
				$("div.his_tab2").bind("click",function(){
					var _index = $(this).attr("_index");
					$(this).parent().children("div.his_tab2").removeClass("his_tab2_click");
					$(this).addClass("his_tab2_click");
					$(this).prevAll("div.his_list").find(".tab_table").hide();
					$($(this).prevAll("div.his_list").find(".tab_table")[_index]).show();
				});
				<%if(showindex>0){%>
					$("div.his_tab2")[<%=showindex%>].click();
				<%}%>
			});
		</script>
<%
	}
	
	//获取资源
	if(operation.equals("get_resource")){
		String[] titles = {"行业构建库","销售工具","第三方资料","产品demo","客户案例","标准方案","行业方案"};
		String[][] category = {{"64","",""},{"","273",""},{"","273",""},{"64","",""},{"","273",""},{"","","940"},{"","","940"}};
		//客户资源
		int crm_new = 0;
		int crm_all = 0;
		String condition = this.getCustomerStr(user);
		rs.executeSql("select count(distinct t1.id) from CRM_CustomerInfo t1,CRM_ViewLog2 t2 where (t1.deleted=0 or t1.deleted is null) and t1.id=t2.customerid and t1.manager="+userid+" and t1.type not in (3,4,11,12,13,14,15,16,17,18,20,21,25)");
		if(rs.next()) crm_new = rs.getInt(1);
		rs.executeSql("select count(distinct customerIds.id) from "+condition+" where (customerIds.deleted=0 or customerIds.deleted is null) and customerIds.type not in (3,4,11,12,13,14,15,16,17,18,20,21,25)");
		if(rs.next()) crm_all = rs.getInt(1);
		//伙伴资源
		int partner_new = 0;
		int partner_all = 0;
		rs.executeSql("select count(distinct t1.id) from CRM_CustomerInfo t1,CRM_ViewLog2 t2 where (t1.deleted=0 or t1.deleted is null) and t1.id=t2.customerid and t1.manager="+userid+" and t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)");
		if(rs.next()) partner_new = rs.getInt(1);
		rs.executeSql("select count(distinct customerIds.id) from "+condition+" where (customerIds.deleted=0 or customerIds.deleted is null) and customerIds.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)");
		if(rs.next()) partner_all = rs.getInt(1);
		
		//文档
		String tables=sharemanager.getShareDetailTableByUser("doc",user);
		String sql_new = "select count(distinct t1.id) from (select a.*, tt.sharelevel from docdetail a, "+tables+" tt where a.id=tt.sourceid) t1 "
			+"left join docReadTag t2 on t1.id=t2.docid where ((docstatus = 7 and ( (t1.sharelevel>1 or doccreaterid="+userid+" or ownerid="+userid+"))) or docstatus in ('1','2','5')) and ( ( t1.doccreaterid = "+userid+" and t1.usertype ='1')  or ( t2.userid="+userid+" and t2.usertype=1))";
		String sql_all = "select count(t1.id) from DocDetail t1,"+tables+" t2 where ((docstatus = 7 and (sharelevel>1 or (doccreaterid="+userid+" or ownerid="+userid+"))) or docstatus in ('1','2','5')) and t1.id=t2.sourceid";
		
		int[] newcount = new int[category.length];
		int[] allcount = new int[category.length];
		String[] urls = new String[category.length];//isNew=yes
		String _url = "/docs/search/DocSearchTemp.jsp?loginType=1&toView=1&docstatus=6";
		for(int i=0;i<category.length;i++){
			String qsql = "";
			String urltemp = "";
			if(!"".equals(category[i][0])){
				qsql += " and t1.maincategory="+category[i][0];
				urltemp += "&maincategory="+category[i][0];
			}
			if(!"".equals(category[i][1])){
				qsql += " and t1.subcategory="+category[i][1];
				urltemp += "&subcategory="+category[i][1];
			}
			if(!"".equals(category[i][2])){
				qsql += " and t1.seccategory="+category[i][2];
				urltemp += "&seccategory="+category[i][2];
			}
			urls[i] = _url+urltemp;
			rs.executeSql(sql_all+qsql);
			if(rs.next()) allcount[i] = rs.getInt(1);
			rs.executeSql(sql_new+qsql);
			if(rs.next()) newcount[i] = allcount[i] - rs.getInt(1);
		}
		/**
		int doc_new1 = 0;
		int doc_all1 = 0;
		rs.executeSql(sql_new+" and t1.maincategory=83 and t1.subcategory=366");
		if(rs.next()) doc_new1 = rs.getInt(1);
		rs.executeSql(sql_all+" and t1.maincategory=83 and t1.subcategory=366");
		if(rs.next()) doc_all1 = rs.getInt(1);
		doc_new1 = doc_all1-doc_new1;
		
		int doc_new2 = 0;
		int doc_all2 = 0;
		rs.executeSql(sql_new+" and t1.maincategory=94 and t1.subcategory=432");
		if(rs.next()) doc_new2 = rs.getInt(1);
		rs.executeSql(sql_all+" and t1.maincategory=94 and t1.subcategory=432");
		if(rs.next()) doc_all2 = rs.getInt(1);
		doc_new2 = doc_all2-doc_new2;*/
%>
		<table class="resource" style="width: 100%" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="50%"/><col width="50%"/></colgroup>
			<tr>
				<td style="line-height: 24px;">我的客户资源(
				<%if(crm_new>0){%><a href="/CRM/data/NewCustomerList.jsp" target="_blank" style="font-weight: bold;color: red;"><%=crm_new%></a><%}else{%><%=crm_new%><%}%>/
				<%if(crm_all>0){%><a href="/CRM/search/SearchOperation.jsp" target="_blank"><%=crm_all%></a><%}else{%><%=crm_all%><%}%>)
				</td>
				<td style="line-height: 24px;">行业构建库(
				<%if(newcount[0]>0){%><a href="<%=urls[0] %>&isNew=yes" target="_blank" style="font-weight: bold;color: red;"><%=newcount[0]%></a><%}else{%><%=newcount[0]%><%}%>/
				<%if(allcount[0]>0){%><a href="<%=urls[0] %>" target="_blank" style=""><%=allcount[0]%></a><%}else{%><%=allcount[0]%><%}%>)
				</td>
			</tr>
			<%
				int index=0;
				for(int i=1;i<titles.length;i++){ 
					if(index%2==0){
			%>
				<tr>
			<%		} %>
				<td style="line-height: 24px;"><%=titles[i] %>(
				<%if(newcount[i]>0){%><a href="<%=urls[i] %>&isNew=yes" target="_blank" style="font-weight: bold;color: red;"><%=newcount[i]%></a><%}else{%><%=newcount[i]%><%}%>/
				<%if(allcount[i]>0){%><a href="<%=urls[i] %>" target="_blank"><%=allcount[i]%></a><%}else{%><%=allcount[i]%><%}%>)
				</td>
				<%	if(index%2!=0 || i==titles.length-1){ %>
				</tr>
				<%	} %>
			<%		index++;
				} %>
		</table>
<%
	}
	//获取合同及回款额
	if(operation.equals("get_contract")){
		if(userid.equals("1239") || userid.equals("2") || userid.equals("33") || userid.equals("369") || userid.equals("897")) userid = "27";//韦、袁、熊 取王的数据
		String tablename = "formtable_main_133";
		int type = Util.getIntValue(request.getParameter("type"));
		String field1 = "yxhtzb";
		String field2 = "yxhte";
		if(type==2){
			field1 = "yxhkzb";
			field2 = "yxhke";
		}
		
		int year = Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4));
		int month = Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7));
		int month2 = month+1;
		String ym1 = (year-1) + "-" + ((month2<10)?("0"+month2):(""+month2));
		String ym2 = year + "-" + ((month<10)?("0"+month):(""+month));
		String ym11 = (year-2) + "-" + ((month2<10)?("0"+month2):(""+month2));
		String ym22 = (year-1) + "-" + ((month<10)?("0"+month):(""+month));
		
		String hrmtype = "";
		rs.executeSql("select top 1 rylx from "+tablename+" where xsry="+userid+" order by id desc");
		if(rs.next()){
			hrmtype = Util.null2String(rs.getString(1));
		}
		double max = 100;
		Map datamap = new HashMap();
		for(int i=0;i<3;i++){
			sql.setLength(0);
			sql.append("select substring(khyf,1,7) as yf,isnull(MAX(");
			if(i==0){
				sql.append(field1);
			}else{
				sql.append(field2);
			}
			sql.append("),0) as money FROM "+tablename+" where xsry="+userid);
			if(month==12){
				sql.append(" and khyf like '"+year+"%'");
			}else{
				if(i==2){
					sql.append(" and khyf>='"+ym11+"' and khyf<='"+ym22+"'");
				}else{
					sql.append(" and khyf>='"+ym1+"' and khyf<='"+ym2+"'");
				}
			}
			sql.append(" group by khyf order by khyf");
			//System.out.println(sql);
			rs.executeSql(sql.toString());
			while(rs.next()){
				double money = Util.getDoubleValue(rs.getString(2),0);
				if(i!=0){if(hrmtype.equals("0")||hrmtype.equals("5")) money = money*2;}//大区经理数据乘2(指标不乘2)
				if(money>max) max = money;
				datamap.put(i+"_"+Util.null2String(rs.getString(1)),money+"");
			}
		}
		String maxvalue = this.round(max/10000+"",0);
		
		String[] datas = {"","",""};
		String[][] datass = new String[12][3];
		String titles = ""; 
		for(int i=0;i<3;i++){
			String data = "";
			String[] ss = new String[12];
			rs.next();
			String ymstr = "";
			int index = 0;
			int y = 0;
			for(int j=month2;j<=12;j++){
				if(i==2){
					y = year - 2;
				}else{
					y = year - 1;
				}
				if(j<10){
					ymstr = i+"_"+y+"-0"+j;
				}else{
					ymstr = i+"_"+y+"-"+j;
				}
				data += "," + this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)/10000+"",2);
				ss[index] = this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)/10000+"",2);
				if(i==0){ titles += ",'" + ymstr.substring(7) + "'";}
				index++;
			}
			for(int j=1;j<=month;j++){
				if(i==2){
					y = year - 1;
				}else{
					y = year;
				}
				if(j<10){
					ymstr = i+"_"+y+"-0"+j;
				}else{
					ymstr = i+"_"+y+"-"+j;
				}
				data += "," + this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)/10000+"",2);
				ss[index] = this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)/10000+"",2);
				if(i==0){ titles += ",'" + ymstr.substring(7) + "'";}
				index++;
			}
			datas[i] = "[" + data.substring(1) + "]";
			datass[i] = ss;
		}
		titles = "[" + titles.substring(1) + "]";
%>
	<div id="contractreportdiv" style="width: 100%;height: 100%"></div>
	<script type="text/javascript" >
		$(document).ready(function() {
	        var chart = new Highcharts.Chart({
	            chart: {
	        		borderWidth: 0,
	        		backgroundColor: 'none',
	                renderTo: 'contractreportdiv',
	                zoomType: 'xy'
	            },
	            title: {
	                text: ''
	            },
	            subtitle: {
	                text: ''
	            },
	            xAxis: [{
	                categories: <%=titles%>
	            }],
	            yAxis: [{ // Primary yAxis
	            	//tickInterval:50,
	            	max:<%=maxvalue%>,
	                min:0,
	                labels: {
	            	 	enabled: true
	                },
	                title: {
	                    text: ''
	                }
	            }, { // Secondary yAxis
	            	//tickInterval:50,
	            	max:<%=maxvalue%>,
	                min:0,
	            	labels: {
	            	 	enabled: false
	                },
	                title: {
	                    text: ''
	                }
	            }, { // Tertiary yAxis
	            	//tickInterval:50,
	            	max:<%=maxvalue%>,
	                min:0,
	            	labels: {
	            	 	enabled: false
	                },
	                title: {
	                    text: ''
	                }
	            }],
	            tooltip: {
	                formatter: function() {
	                    var unit = {
	                        '目标': 'w',
	                        '业绩': 'w',
	                        '同期': 'w'
	                    }[this.series.name];
	    
	                    return ''+
	                        this.x +': '+ this.y +' '+ unit;
	                }
	            },
	            legend: {
	            },
	            series: [{
	            	borderWidth: 0,
	                name: '目标',
	                color: '#4572A7',
	                type: 'column',
	                yAxis: 0,
	                data: <%=datas[0]%>
	            }, {
	                name: '业绩',
	                type: 'spline',
	                color: '#AA4643',
	                yAxis: 1,
	                data: <%=datas[1]%>,
	                marker: {
	                    enabled: false
	                }
	    
	            }, {
	                name: '同期',
	                color: '#89A54E',
	                yAxis: 2,
	                type: 'spline',
	                data: <%=datas[2]%>,
	                dashStyle: 'shortdot'
	            }]
	        });
	    });
	</script>
<%
	}
	
	//获取待办工作
	if(operation.equals("get_todo")){
		int size = 100;
		//流程
		int wf_count = 0;
		rs.executeSql("select count(distinct t1.requestid)"
				+" from workflow_requestbase t1,workflow_currentoperator t2"
				+" where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and (t1.deleted=0 or t1.deleted is null)"
				+" and t1.requestid = t2.requestid"
				+" and t1.workflowid<>1"
				+" and t2.userid = "+userid+" and t2.usertype=0" 
				+" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1"
				+" and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+userid+"))");
		if(rs.next()) wf_count = rs.getInt(1);
		//任务
		int task_count = 0;
		rs.executeSql("select count(distinct t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
				+" and (((t1.creater = "+userid+" or t1.principalid = "+userid
				+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
				+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
				+")"
				+" and (not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")"
				+" or (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
				+" >(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc)))"
				+" or ( (t1.creater = "+userid+" or t1.principalid = "+userid
				+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
				+" and ((t1.begindate<>'' and t1.begindate is not null and t1.enddate<>'' and t1.enddate is not null and t1.begindate<='"+currentDate+"' and t1.enddate>='"+currentDate+"')"
				+" or (t1.begindate<>'' and t1.begindate is not null and (t1.enddate='' or t1.enddate is null) and t1.begindate<='"+currentDate+"')"
				+" or (t1.enddate<>'' and t1.enddate is not null and (t1.begindate='' or t1.begindate is null) and t1.enddate>='"+currentDate+"'))) )");
		if(rs.next()) task_count = rs.getInt(1);
		//计划
		int plan_count = 0;
		rs.executeSql("select count(id)"
					+" FROM WorkPlan"
					+" WHERE createrType = '1'"
					+" AND deleted <> 1"
					+" AND (status = '0' OR status = '6')"
					+" AND (endDate = ''"
					+" OR endDate IS null"
					+" OR (enddate>='"+currentDate+"' and enddate <= convert(char,dateadd(day,2,'"+currentDate+"'),23)))"
					+" AND (','+CONVERT(varchar(2000), resourceId)+',') LIKE '%,"+userid+",%'");
		if(rs.next()) plan_count = rs.getInt(1);
		//协助
		int cwork_count = 0;
		int departmentid=user.getUserDepartment();   //用户所属部门
        int subCompanyid=user.getUserSubCompany1();  //用户所属分部
        String seclevel=user.getSeclevel();          //用于安全等级
        String sqlStr="("+
		" select t1.id,t1.createdate,t1.createtime,t1.name,t1.status,t1.typeid,t1.creater,t1.principal,t1.begindate,t1.enddate,t1.remark,t1.lastdiscussant,"+
		" case when  t3.sourceid is not null then 1 when t2.cotypeid is not null then 0 end as jointype,"+
		" case when  t4.coworkid is not null then 0 else 1 end as isnew,"+
		" case when  t5.coworkid is not null then 1 else 0 end as important,"+
		" case when  t6.coworkid is not null then 1 else 0 end as ishidden"+
		" from cowork_items  t1 left join "+
		//关注的协作
		" (select distinct cotypeid from  cotype_sharemanager where (sharetype=1 and sharevalue like '%,"+userid+",%' )"+
		" or (sharetype=2 and sharevalue like '%,"+departmentid+",%' and "+seclevel+">=seclevel) "+
		" or (sharetype=3 and sharevalue like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel)"+
		" or (sharetype=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and  sharevalue=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel)"+
		" or (sharetype=5 and "+seclevel+">=seclevel)"+
		" )  t2 on t1.typeid=t2.cotypeid left join "+
        //直接参与的协作
		" (select distinct sourceid from coworkshare where"+
		" (type=1 and  (content='"+userid+"' or content like '%,"+userid+",%') )"+
		" or (type=2 and content like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel) "+
		" or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel)"+
		" or (type=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and content=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel)"+
		" or (type=5 and "+seclevel+">=seclevel)"+
		" )  t3 on t3.sourceid=t1.id"+
        //阅读|重要|隐藏
		" left join (select distinct coworkid,userid from cowork_read where userid="+userid+")  t4 on t1.id=t4.coworkid"+       //阅读状态
		" left join (select distinct coworkid,userid from cowork_important where userid="+userid+" )  t5 on t1.id=t5.coworkid"+ //重要性
		" left join (select distinct coworkid,userid from cowork_hidden where userid="+userid+" )  t6 on t1.id=t6.coworkid"+    //是否隐藏
		" ) t ";
        
        rs.executeSql("select count(id) from "+sqlStr+" where isnew=1 and status=1 and ishidden<>1 and jointype=1");
        if(rs.next()) cwork_count = rs.getInt(1);
        
        int allcount = 0;
        String allstr = "";
%>
	<div style="width: 100%;height: 25px;background: #fff;overflow: hidden;position: relative;">
		<div class="tab" _index="0">最新</div>
		<div class="tab" _index="1">待办<%if(wf_count>0){%>(<%=wf_count %>)<%}%></div>
		<div class="tab" _index="2">任务<%if(task_count>0){%>(<%=task_count %>)<%}%></div>
		<div class="tab" _index="3">日程<%if(plan_count>0){%>(<%=plan_count %>)<%}%></div>
		<div class="tab" _index="4">协助<%if(cwork_count>0){%>(<%=cwork_count %>)<%}%></div>
		<div class="tab" _index="5">微博</div>
		<div id="tab_icon" class="tab_icon"></div>
	</div>
	<div id="tabdata1" style="width: 100%;position: absolute;top: 30px;left: 100%;height: 132px;">
		<%if(wf_count==0){%>
			<div style="font-style: italic;padding-left: 15px;color: #9B9B9B;">暂无待办流程</div>
		<%}else{ 
			rs.executeSql("select top 5 t1.requestid,t1.requestname,t1.creater,t1.createdate,t1.createtime,t1.workflowid,t2.viewtype,t2.nodeid,t2.isremark,t2.agentorbyagentid,t2.agenttype,t2.isprocessed,t2.receivedate,t2.receivetime"
					+" from workflow_requestbase t1,workflow_currentoperator t2"
					+" where (t1.deleted <> 1 or t1.deleted is null or t1.deleted='') and (t1.deleted=0 or t1.deleted is null)"
					+" and t1.requestid = t2.requestid"
					+" and t1.workflowid<>1"
					+" and t2.userid = "+userid+" and t2.usertype=0" 
					+" and t2.isremark in( '0','1','5','8','9','7') and t2.islasttimes=1"
					+" and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+userid+"))"
					+" order by t2.receivedate desc,t2.receivetime desc");
		%>
		<table class="datatable2" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="*"/><col width="50px"/><col width="80px"/></colgroup>
			<%while(rs.next()){ 
				String para= Util.null2String(rs.getString("requestid"))+"+"
		 			+ Util.null2String(rs.getString("workflowid"))+"+"
		 			+ Util.null2String(rs.getString("viewtype"))+"+0+"
		 			+ user.getLanguage()+"+"
		 			+ Util.null2String(rs.getString("nodeid"))+"+"
		 			+ Util.null2String(rs.getString("isremark"))+"+"
		 			+ userid+"+"
		 			+ Util.null2String(rs.getString("agentorbyagentid"))+"+"
		 			+ Util.null2String(rs.getString("agenttype"))+"+"
		 			+ Util.null2String(rs.getString("isprocessed"));
				allcount++;
				allstr+="<tr><td class='tabicon1' title='流程'>"
					+"<td title=\""+rs.getString("requestname")+"\">"+WorkFlowTransMethod.getWfNewLinkWithTitle(Util.getMoreStr(rs.getString("requestname"),size,"..."),para)+"</td>"
					+"<td class=\"info2\">"+this.getHrm(rs.getString("creater"))+"</td>"
					+"<td class=\"info2\">"+Util.null2String(rs.getString("receivedate"))+"</td>"
					+"</tr>";
			%>
			<tr>
				<td title="<%=rs.getString("requestname")%>"><%=WorkFlowTransMethod.getWfNewLinkWithTitle(Util.getMoreStr(rs.getString("requestname"),size,"..."),para) %></td>
				<td class="info2"><%=this.getHrm(rs.getString("creater"))%></td>
				<td class="info2"><%=Util.null2String(rs.getString("receivedate"))%></td>
			</tr>
			<%} %>
			<tr><td colspan="3" align="right" style="padding-right: 10px;"><a class="btn" style="float: right;" href="javascript:openFullWindowHaveBar('/workflow/request/RequestView.jsp')">更多>></a></td></tr>
		</table>
		<%} %>
	</div>
	<div id="tabdata2" style="width: 100%;position: absolute;top: 30px;left: 100%;height: 132px;">
		<table class="datatable2" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><iframe width="100%" height="60px;" src="/workrelate/task/data/Remind.jsp" scrolling="no" frameborder="0" style="margin-top: 10px;"></iframe></td>
			</tr>
			<tr><td align="right" style="padding-right: 10px;"><a class="btn" style="float: right;" href="javascript:openFullWindowHaveBar('/workrelate/task/data/Main.jsp')">更多>></a></td></tr>
		</table>
	</div>
	<div id="tabdata3" style="width: 100%;position: absolute;top: 30px;left: 100%;height: 132px;">
		<%if(plan_count==0){ %>
			<div style="font-style: italic;padding-left: 15px;color: #9B9B9B;">暂无计划</div>
		<%}else{ 
			rs.executeSql("select top 5 id,name,begindate,begintime,endDate,endTime,urgentLevel,createrid"
					+" FROM WorkPlan"
					+" WHERE createrType = '1'"
					+" AND deleted <> 1"
					+" AND (status = '0' OR status = '6')"
					+" AND (endDate = ''"
					+" OR endDate IS null"
					+" OR (enddate>='"+currentDate+"' and enddate <= convert(char,dateadd(day,2,'"+currentDate+"'),23)))"
					+" AND (','+CONVERT(varchar(2000), resourceId)+',') LIKE '%,"+userid+",%' order by begindate,begintime");
		%>
		<table class="datatable2" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="*"/><col width="80px"/></colgroup>
			<%while(rs.next()){
				if(allcount<5){
					allcount++;
					allstr+="<tr><td class='tabicon3' title='日程'>"
						+"<td title=\""+rs.getString("name")+"\"><a href=\"javascript:openFullWindowHaveBar('/workplan/data/WorkPlanDetail.jsp?workid="+rs.getString("id")+"')\">"+rs.getString("name")+"</a></td>"
						+"<td class=\"info2\">"+this.getHrm(rs.getString("createrid"))+"</td>"
						+"<td class=\"info2\">"+Util.null2String(rs.getString("begindate"))+"</td>"
						+"</tr>";
				}
			%>
			<tr>
				<td title="<%=rs.getString("name")%>"><a href="javascript:openFullWindowHaveBar('/workplan/data/WorkPlanDetail.jsp?workid=<%=rs.getString("id")%>')"><%=rs.getString("name")%></a></td>
				<td class="info2"><%=Util.null2String(rs.getString("begindate"))%></td>
			</tr>
			<%} %>
			<tr><td colspan="2" align="right" style="padding-right: 10px;"><a class="btn" style="float: right;" href="javascript:openFullWindowHaveBar('/workplan/data/WorkPlan.jsp')">更多>></a></td></tr>
		</table>
		<%} %>
	</div>
	<div id="tabdata4" style="width: 100%;position: absolute;top: 30px;left: 100%;height: 132px;">
		<%if(cwork_count==0){ %>
			<div style="font-style: italic;padding-left: 15px;color: #9B9B9B;">暂无未读协助</div>
		<%}else{ 
			rs.executeSql("select top 5 id,name,important,creater,createdate,createtime,lastdiscussant"
	        		+" from "+sqlStr
	        		+" where isnew=1 and status=1 and ishidden<>1 and jointype=1 order by important desc");
		%>
		<table class="datatable2" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="*"/><col width="50px"/><col width="80px"/></colgroup>
			<%while(rs.next()){ 
				if(allcount<5){
					allcount++;
					allstr+="<tr><td class='tabicon4' title='协助'>"
						+"<td title=\""+rs.getString("name")+"\"><a href=\"javascript:openFullWindowHaveBar('/cowork/ViewCoWork.jsp?id="+rs.getString("id")+"')\">"+rs.getString("name")+"</a></td>"
						+"<td class=\"info2\">"+this.getHrm(rs.getString("lastdiscussant"))+"</td>"
						+"<td class=\"info2\">"+Util.null2String(rs.getString("createdate"))+"</td>"
						+"</tr>";
				}
			%>
			<tr>
				<td title="<%=rs.getString("name")%>"><a href="javascript:openFullWindowForXtable('/cowork/ViewCoWork.jsp?id=<%=rs.getString("id")%>')"><%=rs.getString("name")%></a></td>
				<td class="info2"><%=this.getHrm(rs.getString("lastdiscussant"))%></td>
				<td class="info2"><%=Util.null2String(rs.getString("createdate"))%></td>
			</tr>
			<%} %>
			<tr><td colspan="3" align="right" style="padding-right: 10px;"><a class="btn" style="float: right;" href="javascript:openFullWindowHaveBar('/cowork/coworkview.jsp')">更多>></a></td></tr>
		</table>
		<%} %>
	</div>
	<div id="tabdata0" style="width: 100%;position: absolute;top: 30px;left: 0px;height: 132px;">
		<%if(allcount==0){ %>
			<div style="font-style: italic;padding-left: 15px;color: #9B9B9B;">暂无新待办工作</div>
		<%}else{ %>
			<table class="datatable2" cellpadding="0" cellspacing="0" border="0">
				<colgroup><col width="20px"/><col width="*"/><col width="50px"/><col width="80px"/></colgroup>
				<%=allstr %>
			</table>
		<%} %>
	</div>
	<script type="text/javascript" >
		var currenttab = 0;
		$(document).ready(function(){
			$("div.tab").bind("click",function(){
				var _index = $(this).attr("_index");
				if(_index==5){
					openFullWindowHaveBar('/blog/blogView.jsp');
					return;
				}
				if(currenttab==_index) return; 
				var l = $(this).position().left+19+"px";
				var w = $("#tabdata"+_index).width();
				$("#tab_icon").animate({ left:l},200,null,function(){});
				if(_index<currenttab){
					$("#tabdata"+_index).css("left",w-2*w).animate({ left:0},200,null,function(){});
					$("#tabdata"+currenttab).animate({ left:w},200,null,function(){});
				}else{
					$("#tabdata"+_index).css("left",w).animate({ left:0},200,null,function(){});
					$("#tabdata"+currenttab).animate({ left:w-2*w},200,null,function(){});
				}
				currenttab = _index;
			});
		});
	</script>
<%		
		
	}
	
	//添加常用流程
	if(operation.equals("add_workflowtype")){
		String workflowid = Util.null2String(request.getParameter("workflowid"));
		int showorder = 0;
		rs.executeSql("select max(showorder) from SP_WorkflowType where hrmid="+userid);
		if(rs.next()) showorder = Util.getIntValue(rs.getString(1),0)+1;
		rs.executeSql("insert into SP_WorkflowType (hrmid,workflowid,showorder) values("+userid+","+workflowid+","+showorder+")");
	}
	//获取常用流程
	if(operation.equals("get_workflowtype")){
		rs.executeSql("select workflowid from SP_WorkflowType where hrmid="+userid+" order by showorder");
		if(rs.getCounts()==0){
			rs.executeSql("insert into SP_WorkflowType (hrmid,workflowid,showorder)"
			 +"select "+userid+",workflowid,showorder from SP_WorkflowType where hrmid=1");
			rs.executeSql("select workflowid from SP_WorkflowType where hrmid="+userid+" order by showorder");
		}
		int temp=0;
%>
	<ul id="wttable" class="drag_ul">
<%
		while(rs.next()){
%>
			<li id="wt_<%=rs.getString(1)%>" _id="<%=rs.getString(1)%>" class="drag_li">
				<div class="drag_btn"></div>
				<div class="drag_data" title="<%=WorkflowComInfo.getWorkflowname(rs.getString(1))%>"><a href="javascript:openFullWindowHaveBar('/workflow/request/AddRequest.jsp?workflowid=<%=rs.getString(1) %>&isagent=0&beagenter=0')">
					<%=WorkflowComInfo.getWorkflowname(rs.getString(1)) %></a>
				</div>
				<div class="drag_del" title="删除" onclick="delWorkflowType('<%=rs.getString(1)%>')"></div>
			</li>
<%
			temp++;
		}
%>
	</ul>
	<script type="text/javascript" >
		$("document").ready(function(){
			$("#wttable").dragsort({
				itemSelector: "li",
				dragSelector: ".drag_btn", 
				dragBetween: false, 
				dragStart: function(){},
				dragEnd: function(){
					var cid = $(this).attr("_id");
					var pid = 0;
					if($(this).prev("li").length>0) pid = $(this).prev("li").attr("_id");
					$.ajax({
						type: "post",
						url: "Operation.jsp",
						contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						data:{"operation":"order_workflowtype","cid":cid,"pid":pid}, 
						complete: function(data){}
					});
				},
				placeHolderTemplate: "<li class='drag_li_blank'><div></div></li>",
				scrollSpeed: 5
			});
		});
		
	</script>
<%
	}
	
	//常用流程排序
	if(operation.equals("order_workflowtype")){
		String cid = Util.null2String(request.getParameter("cid"));
		String pid = Util.null2String(request.getParameter("pid"));
		if(pid.equals("0")){
			rs.executeSql("update SP_WorkflowType set showorder=(showorder+1) where hrmid="+userid);
			rs.executeSql("update SP_WorkflowType set showorder=1 where workflowid="+cid+" and hrmid="+userid);
		}else{
			int showorder = 0;
			rs.executeSql("select showorder  from SP_WorkflowType where hrmid="+userid+" and workflowid="+pid);
			if(rs.next()) showorder = rs.getInt(1);
			rs.executeSql("update SP_WorkflowType set showorder=(showorder+1) where hrmid="+userid+" and showorder>"+showorder);
			rs.executeSql("update SP_WorkflowType set showorder="+(showorder+1)+" where workflowid="+cid+" and hrmid="+userid);
		}
	}
	//删除常用流程
	if(operation.equals("del_workflowtype")){
		String workflowid = Util.null2String(request.getParameter("workflowid"));
		rs.executeSql("delete from SP_WorkflowType where workflowid="+workflowid+" and hrmid="+userid); 
	}
	
	//添加常用文档
	if(operation.equals("add_docdir")){
		String dirid = Util.null2String(request.getParameter("dirid"));
		int showorder = 0;
		rs.executeSql("select max(showorder) from SP_DocDir where hrmid="+userid);
		if(rs.next()) showorder = Util.getIntValue(rs.getString(1),0)+1;
		List diridList = Util.TokenizerString(dirid,",");
		for(int i=0;i<diridList.size();i++){
			String id = Util.null2String((String)diridList.get(i));
			if(!id.equals("")){
				rs.executeSql("select id from SP_DocDir where hrmid="+userid+" and dirid="+id);
				if(!rs.next()){
					rs.executeSql("insert into SP_DocDir (hrmid,dirid,showorder) values("+userid+","+id+","+showorder+")");
					showorder++;
				}
			}
		}
	}
	//获取常用文档
	if(operation.equals("get_docdir")){
		rs.executeSql("select dirid from SP_DocDir where hrmid="+userid+" order by showorder");
		if(rs.getCounts()==0){
			rs.executeSql("insert into SP_DocDir (hrmid,dirid,showorder)"
			 +"select "+userid+",dirid,showorder from SP_DocDir where hrmid=1");
			rs.executeSql("select dirid from SP_DocDir where hrmid="+userid+" order by showorder");
		}
		int temp=0;
%>
	<ul id="ddtable" class="drag_ul">
<%
		while(rs.next()){
%>
			<li id="dd_<%=rs.getString(1)%>" _id="<%=rs.getString(1)%>" class="drag_li">
				<div class="drag_btn"></div>
				<div class="drag_data" title="<%=SecCategoryComInfo.getSecCategoryname(rs.getString(1))%>"><a href="javascript:openFullWindowHaveBar('/docs/docs/DocAdd.jsp?secid=<%=rs.getString(1) %>&showsubmit=1')">
					<%=SecCategoryComInfo.getSecCategoryname(rs.getString(1)) %></a>
				</div>
				<div class="drag_del" title="删除" onclick="delDocDir('<%=rs.getString(1)%>')"></div>
			</li>
<%
			temp++;
		}
%>
	</ul>
	<script type="text/javascript" >
		$("document").ready(function(){
			$("#ddtable").dragsort({
				itemSelector: "li",
				dragSelector: ".drag_btn", 
				dragBetween: false, 
				dragStart: function(){},
				dragEnd: function(){
					var cid = $(this).attr("_id");
					var pid = 0;
					if($(this).prev("li").length>0) pid = $(this).prev("li").attr("_id");
					$.ajax({
						type: "post",
						url: "Operation.jsp",
						contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						data:{"operation":"order_docdir","cid":cid,"pid":pid}, 
						complete: function(data){}
					});
				},
				placeHolderTemplate: "<li class='drag_li_blank'><div></div></li>",
				scrollSpeed: 5
			});
		});
		
	</script>
<%
	}
	
	//常用文档排序
	if(operation.equals("order_docdir")){
		String cid = Util.null2String(request.getParameter("cid"));
		String pid = Util.null2String(request.getParameter("pid"));
		if(pid.equals("0")){
			rs.executeSql("update SP_DocDir set showorder=(showorder+1) where hrmid="+userid);
			rs.executeSql("update SP_DocDir set showorder=1 where dirid="+cid+" and hrmid="+userid);
		}else{
			int showorder = 0;
			rs.executeSql("select showorder  from SP_DocDir where hrmid="+userid+" and dirid="+pid);
			if(rs.next()) showorder = rs.getInt(1);
			rs.executeSql("update SP_DocDir set showorder=(showorder+1) where hrmid="+userid+" and showorder>"+showorder);
			rs.executeSql("update SP_DocDir set showorder="+(showorder+1)+" where dirid="+cid+" and hrmid="+userid);
		}
	}
	//删除常用文档
	if(operation.equals("del_docdir")){
		String dirid = Util.null2String(request.getParameter("dirid"));
		rs.executeSql("delete from SP_DocDir where dirid="+dirid+" and hrmid="+userid); 
	}
	
	//提交问题支持
	if(operation.equals("submit_q")){
		String title = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("title")),"utf-8"),user.getLanguage());
		String remark = Util.fromScreen3(URLDecoder.decode(Util.null2String(request.getParameter("remark")),"utf-8"),user.getLanguage());
		if(!title.equals("") && !remark.equals("")){
			this.createDoc(user,"60","256","899",title,remark);
		}
		
	}
	
	//获取历史日期
	if(operation.equals("get_historydate")){
		int cannext = 1;
		String lastdate = Util.null2String(request.getParameter("lastdate"));
		if(lastdate.equals(currentDate)){
			cannext = 0;
		}
%>
		<input type="hidden" id="prevdate" value="<%=TimeUtil.dateAdd(lastdate,18)%>"/>
		<input type="hidden" id="nextdate" value="<%=TimeUtil.dateAdd(lastdate,-18)%>"/>
<%		
		String datestr = "";
		for(int i=1;i<19;i++){ 
			datestr = TimeUtil.dateAdd(lastdate,i*-1);
%>
			<div class="btn_date" title="<%=datestr%>" onmouseover="datehover(this)" onmouseout="dateout(this)" onclick="showResult('<%=datestr%>',0,0)"><%=datestr.substring(5,7)+"."+datestr.substring(8,10) %></div>
<%
		} 
%>		
		$<%=cannext %>
<%
	}
	
	out.print(restr.toString());
	//out.close();
%>
<%!
	/**
	 * 获取所有具有查看权限的客户sql字符串
	 * @return
	 */
	public String getCustomerStr(User user) throws Exception{
		String condition = "";
		//找到用户能看到的所有客户
		String userid = "" + user.getUID();
		RecordSet rs = new RecordSet();
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid;
		rs.executeSql(sql);
		if (rs.next()) {
			condition = " (select id,deleted,type from CRM_CustomerInfo where deleted=0 or deleted is null) as customerIds ";
		} else {
			CrmShareBase crmShareBase = new CrmShareBase();
			String leftjointable = crmShareBase.getTempTable(userid);
			condition = " (select distinct t1.id,t1.deleted,t1.type "
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
		}
		return condition;
	}
	private String makeNameWhere(String key_word,String name){
		String sqlWhere = "";
		if(!key_word.equals("")){
			if(key_word.indexOf("+")>0){
				String[] ands = key_word.split("\\+");
				if(ands.length>0){
					sqlWhere += " ( ";
					for(int i=0;i<ands.length;i++){
						if(i == 0){
							sqlWhere += " "+name+" like '%" + ands[i] + "%'";
						}else{
							sqlWhere += " and "+name+" like '%" + ands[i] + "%'";
						}
					}
					sqlWhere += " ) ";
				}
			}else{
				String[] ors = key_word.split(" ");
				if(ors.length>0){
					sqlWhere += " ( ";
					for(int i=0;i<ors.length;i++){
						if(i == 0){
							sqlWhere += " "+name+" like '%" + ors[i] + "%'";
						}else{
							sqlWhere += " or "+name+" like '%" + ors[i] + "%'";
						}
					}
					sqlWhere += " ) ";
				}
			}
		}
		return sqlWhere;
	}
	public String getCustomer(String ids) throws Exception{
		String names = "";
		CustomerInfoComInfo ci = new CustomerInfoComInfo();
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				names += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID=" + (String)idList.get(i)+"')>"+ ci.getCustomerInfoname((String)idList.get(i))+"</a>";
			}
		}
		return names;
	}
	public String getHrm(String ids) throws Exception{
		String names = "";
		ResourceComInfo rc = new ResourceComInfo();
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				names += "<a href='/hrm/resource/HrmResource.jsp?id="+idList.get(i)+"' target='_blank'>"
					+ rc.getResourcename((String)idList.get(i))+ "</a> ";
			}
		}
		return names;
	}
	/**
	 * 创建文档
	 * @param imageIdName
	 * @param user
	 * @return
	 */
	public int createDoc(User user,String mainId,String subId,String secId,String title,String remark){
		try {
			SecCategoryComInfo scc = new SecCategoryComInfo();
			DocComInfo dc = new DocComInfo();
			DocManager dm = new DocManager();
			DocViewer dv = new DocViewer();
			DocImageManager imgManger = new DocImageManager();
			// get doc id
			RecordSet rs = new RecordSet();
			int docId = dm.getNextDocId(rs);
			// upload
			// upload image file and modify table
	
			// upload doc and modify table
			String now = "";
			String date = "";
			String time = "";
	        date=TimeUtil.getCurrentDateString();
	        time=TimeUtil.getOnlyCurrentTimeString();
	
	        dm.setId(docId);
			dm.setMaincategory(Util.getIntValue(mainId,0));
			dm.setSubcategory(Util.getIntValue(subId,0));
			dm.setSeccategory(Util.getIntValue(secId,0));
			dm.setLanguageid(user.getLanguage());
			dm.setDoccontent(remark);
			dm.setDocstatus("1");
			dm.setDocsubject(title);
			dm.setDoccreaterid(user.getUID());
			dm.setDocCreaterType(user.getLogintype());
			dm.setUsertype(user.getLogintype());
			dm.setOwnerid(user.getUID());
			dm.setOwnerType(user.getLogintype());
			dm.setDoclastmoduserid(user.getUID());
			dm.setDocLastModUserType(user.getLogintype());
			dm.setDoccreatedate(date);
			dm.setDoclastmoddate(date);
			dm.setDoccreatetime(time);
			dm.setDoclastmodtime(time);
			dm.setDoclangurage(user.getLanguage());
			dm.setKeyword(title);
			dm.setIsapprover("0");
			dm.setIsreply("");
			dm.setDocdepartmentid(user.getUserDepartment());
			dm.setDocreplyable("1");
			dm.setAccessorycount(0);
			dm.setParentids("" + docId);
			dm.setOrderable("" + scc.getSecOrderable(Util.getIntValue(secId,0)));
			dm.setClientAddress("");
													
			dm.setUserid(user.getUID()); 
											
			DocCoder docCoder = new DocCoder();
			dm.setDocCode(docCoder.getDocCoder(secId));
			int docEdition = -1;
			int docEditionId = -1;
			 if(scc.isEditionOpen(Util.getIntValue(secId))) {//如果版本管理开启
	             if(docEditionId == -1){// 如果不存在历史版本
	                 docEditionId = dm.getNextEditionId(rs);
	             } else {
	                 //新建文档不存在以前有版本
	             }
	             docEdition = dc.getEdition(docEditionId)+1;
	         }
			dm.setDocEditionId(docEditionId);
			dm.setDocEdition(docEdition);
			
			dm.AddDocInfo();
			// set share
			dm.AddShareInfo();
			dc.addDocInfoCache("" + docId);
			dv.setDocShareByDoc("" + docId);
	
			return docId;
		} catch (Exception ex) {
			return -1;
		}
	}
%>
<%!
/**
 * 对金额进行四舍五入
 * @param s 金额字符串
 * @param len 小数位数
 * @return
 */
public static String round(String s,int len){
	if (s == null || s.length() < 1) {
		return "";
	}
	NumberFormat formater = null;
	double num = Double.parseDouble(s);
	if (len == 0) {
		formater = new DecimalFormat("##0");
	} else {
		StringBuffer buff = new StringBuffer();
		buff.append("##0.");
		for (int i = 0; i < len; i++) {
			buff.append("0");
		}
		formater = new DecimalFormat(buff.toString());
	}
	return formater.format(num);
}
%>