
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workrelate.util.*"%>
<%@ page import="weaver.crm.Maint.ContactWayComInfo"%>
<%@ page import="weaver.crm.sellchance.SellstatusComInfo"%>
<%@ page import="weaver.crm.base.ProductTypeComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SptmForCrmModiRecord" class="weaver.crm.SptmForCrmModiRecord" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page" />
<%
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	String currentdate = TimeUtil.getCurrentDateString();
	String currenttime = TimeUtil.getOnlyCurrentTimeString();
	
	//获取列表数据
	if("get_list_data".equals(operation)){
		String orderby1 = " order by createdate desc,id desc";
		String orderby2 = " order by createdate asc,id asc";
		String orderby3 = " order by t.createdate desc,t.id desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		//String querysql = URLDecoder.decode(Util.null2String(request.getParameter("querysql")),"utf-8");//.replaceAll("t3.createdate ' ' t3.createtime","t3.createdate+' '+t3.createtime").replaceAll("t2.operatedate ' ' t2.operatetime","t2.operatedate+' '+t2.operatetime");
		String querysql = (String)request.getSession().getAttribute("CRM_LIST_SQL");
		int iTotal =total; 
		int iNextNum = currentpage * pagesize;
		int ipageset = pagesize;
		if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
		if(iTotal < pagesize) ipageset = iTotal;
		sql = "select top " + ipageset +" A.* from (select distinct top "+ iNextNum + querysql+ orderby3 + ") A "+orderby2;
		sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
		//System.out.println(total+"---"+sql);
		rs.executeSql(sql);
		int index = (currentpage-1) * pagesize;
		String _att = "";
		String contactdate = "";
		String contactstr = "";
		String contacttitle = "";
		String _customerid = "";
		String _manager = "";
		while(rs.next()){
			index++;
			_att = Util.null2String(rs.getString("att"));
			_customerid = Util.null2String(rs.getString("id"));
			_manager = Util.null2String(rs.getString("manager"));
			
			rs2.executeSql("select top 1 begindate from WorkPlan a "
					+" where a.crmid ='"+_customerid+"' and a.createrType='1' and a.type_n=3 "
					+" order by a.id desc");
			if(rs2.next()){
				contactdate = Util.null2String(rs2.getString("begindate"));
			}else{
				contactdate = "";
			}
			if("".equals(contactdate)){
				contactstr = "<font style='color:red' title='无联系记录'>无记录</font>";
				contacttitle = "";
			}else{
				int days = TimeUtil.dateInterval(contactdate,TimeUtil.getCurrentDateString());
				if(days==0){
					contactstr = "<font style='color:green' title='今天已联系'>已联系</font>";
				}else{
					contactstr = "<font style='color:red' title='"+days+"天未联系'>"+days+"</font>";
				}
				//客户经理最后联系日期
				rs2.executeSql("select top 1 begindate from WorkPlan a"
						+" where a.crmid ='"+_customerid+"' and a.createrType='1' and a.type_n=3 and a.createrid="+_manager
						+" order by a.id desc");
				if(rs2.next()){
					int days2 = TimeUtil.dateInterval(rs2.getString(1),TimeUtil.getCurrentDateString());
					if(days2!=days){
						contactstr += "(<font style='color:red' title='负责人"+days2+"天未联系'>"+days2+"</font>)";
					}
				}else{
					contactstr += "(<font style='color:red' title='无负责人联系记录'>-</font>)";
				}
				
				contacttitle = "最后联系日期:"+contactdate;
				contactdate = contactdate.substring(5)+"|";
			}
	%>
		<tr id="item<%=_customerid%>" class="item_tr" _customerid="<%=_customerid%>" _lastdate="<%=rs.getString("createdate")%>" _status="">
			<%if(!_att.equals("")){%>
				<td class='td_move td_att' _index="<%=index%>" title="取消关注" _special="0" _customerid="<%=rs.getString("id")%>">&nbsp;</td>
			<%}else{ %>
				<td class='td_move td_noatt' _index="<%=index%>" title="标记关注" _special="1" _customerid="<%=rs.getString("id")%>"><%=index %></td>
			<%} %>
			<td class='item_td'>
				<div class="item_check" _val="<%=_customerid %>"></div>
				<div class="disinput" name="" id="<%=_customerid %>" title="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index %>"><%=Util.null2String(rs.getString("name")) %></div></td>
			<td><font title="<%=contacttitle %>"><%=contactdate%></font><%=contactstr%></td>
			<td colspan="4"><div title="电话:<%=Util.null2String(rs.getString("phone")) %>"><%=Util.null2String(rs.getString("phone"))%></div></td>
			<td class='item_hrm' title=''><%=this.getHrmLink(_manager) %></td>
		</tr>
		<tr id="load<%=_customerid%>" style="display: none">
			<td class='td_blank'>&nbsp;</td>
			<td colspan="7"><div style='width:20px;height:14px;background:url(../images/loading2_wev8.gif) center no-repeat'>&nbsp;</div></td>
		</tr>
	<%
		} 
	}
	//设置数量
	if("check_new".equals(operation)){
		
%>
		<script type="text/javascript">
			newMap = new Map();
<%		
		int maintype = Util.getIntValue((String)request.getSession().getAttribute("CRM_MAINTYPE"),1);
		String creater = Util.null2String(request.getParameter("creater"));
		String userid = user.getUID()+"";
		
		String base = "select count(t.id) as amount from CRM_CustomerInfo t where (t.deleted=0 or t.deleted is null)";
		String base2 = "";
		String base3 = "";
		
		String condition = "";
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (rs.next()) {
			base2 = "select count(t.id) as amount from CRM_CustomerInfo t where (t.deleted=0 or t.deleted is null)";
			base3 = "select t.id from CRM_CustomerInfo t where (t.deleted=0 or t.deleted is null)";
		} else {
			String leftjointable = CrmShareBase.getTempTable(userid);
			condition = "(select distinct t1.id,t1.name,t1.type,t1.manager,t1.status,t1.createdate "
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as t";
			base2 = "select count(t.id) as amount from "+condition+" where 1=1 ";
			base3 = "select t.id from "+condition+" where 1=1 ";
		}
		if(!(user.getUID()+"").equals(creater) && !ResourceComInfo.isManager(user.getUID(),creater)){
			base = base2;
		}
		//String base = "select count(t.id) as amount from CRM_CustomerInfo t join "+condition+" on t.id = customerIds.id";
		if(maintype==1){
			base += " and t.type in (1,3,4,5)";
			base2 += " and t.type in (1,3,4,5)";
		}else if(maintype==2){
			base += " and t.type in (11,12,13,14,15,16,17,18,20,21,25,19)";
			base2 += " and t.type in (11,12,13,14,15,16,17,18,20,21,25,19)";
		}else if(maintype==3){
			base += " and t.type = 26";
			base2 += " and t.type = 26";
		}
		String self = " and (t.manager ="+creater+" or exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%'))";
		String where1 = base+self;
		List sqllist = new ArrayList();
		sqllist.add(where1);//本人
		sqllist.add(where1+" and exists (select 1 from CRM_Common_Remind r where r.operatetype=1 and r.objid=t.id)");//被提醒
		sqllist.add(base2+" and exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=1 and t2.operator="+userid+")");//关注
		if(creater.equals(userid)){
			sqllist.add(base2+" and t.manager <> "+creater+" and not exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%')");//非本人
			sqllist.add(base2); //全部
		}else{
			sqllist.add("0");
			sqllist.add("0");
		}
		sqllist.add(where1+" and exists (select 1 from CRM_ViewLog2 v where v.customerid=t.id)");
		/**
		CustomerStatusComInfo.setTofirstRow();
		while(CustomerStatusComInfo.next()){
			sqllist.add(where1+" and t.status="+CustomerStatusComInfo.getCustomerStatusid());
		}
		//联系
		String wpcond = " and not exists (select 1 from WorkPlan a where a.crmid not like '%,%' and a.crmid=t.id and a.type_n=3 and a.createrType='1'";
		String wpcond1 = wpcond + " and a.createrid=t.manager and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"'";
		String wpcond2 = wpcond + " and a.createrid=t.manager and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"'";
		String wpcond3 = wpcond + " and a.createrid=t.manager and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"'";
		String wpcond4 = wpcond + " and a.createrid=t.manager and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"'";
		String wpcond5 = wpcond + " and a.createrid=t.manager and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"'";
		
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond1
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond1
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond2
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond2
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond3
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond3
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond4
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond4
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond5
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond5
				+ ") as tt");
		
		
		String wpcond11 = wpcond + " and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-7)+"'";
		String wpcond22 = wpcond + " and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-14)+"'";
		String wpcond33 = wpcond + " and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-30)+"'";
		String wpcond44 = wpcond + " and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-90)+"'";
		String wpcond55 = wpcond + " and a.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"')"
				+" and t.createdate<'"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-180)+"'";
		
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond11
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond11
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond22
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond22
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond33
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond33
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond44
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond44
				+ ") as tt");
		sqllist.add("select count(tt.id) as amount from (" 
				+ base3 + " and t.manager ="+creater+" and t.status in (1,2,3,12)"+wpcond55
				+ " union all "
				+ base3 + " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%') and t.status in (1,2,3,12)"+wpcond55
				+ ") as tt");
		*/
		String sqlstr = "";
		int amount = 0;
		for(int i=0;i<sqllist.size();i++){
			sqlstr = Util.null2String((String)sqllist.get(i));
			if(sqlstr.equals("0")){
%>
				newMap.put("cond<%=i+1%>","0");
<%					
			}else{
				amount = 0;
				rs.executeSql(sqlstr);
				if(rs.next()) amount = Util.getIntValue(rs.getString(1),0);
				//System.out.println(amount+":"+sqlstr);
%>
				newMap.put("cond<%=i+1%>","<%=amount%>");
<%		
			}
		}
%>
		</script>
<%			
	}
	
	Map fn = new HashMap();
	fn.put("name","名称");
	fn.put("city","城市");
	fn.put("county","区县（二级城市）");
	fn.put("address1","地址1");
	fn.put("zipcode","邮政编码");
	fn.put("phone","电话");
	fn.put("fax","传真");
	fn.put("email","邮箱");
	fn.put("website","网址");
	fn.put("type","类型");
	fn.put("status","状态");
	fn.put("rating","级别");
	fn.put("description","描述");
	fn.put("size_n","规模");
	fn.put("source","获得途径");
	fn.put("sector","行业");
	fn.put("manager","客户经理");
	fn.put("agent","中介机构");
	fn.put("crmcode","客户编号");
	fn.put("engname","简称（英文）");
	fn.put("address2","地址2");
	fn.put("address3","地址3");
	fn.put("country","国家");
	fn.put("province","省");
	fn.put("language","语言");
	fn.put("introduction","介绍");
	fn.put("evaluation","客户价值");
	fn.put("principalIds","客服负责人");
	fn.put("exploiterIds","开拓人员");
	fn.put("parentid","上级单位");
	fn.put("documentid","文档");
	fn.put("introductionDocid","背景资料");
	fn.put("seclevel","安全级别");
	fn.put("CreditAmount","信用额度");
	fn.put("CreditTime","信用期间");
	fn.put("bankName","开户银行");
	fn.put("accountName","帐户");
	fn.put("accounts","银行帐号");
	fn.put("othername","正式名称");
	
	//新建客户
	if("add_customer".equals(operation)){
		
%>
		<script type="text/javascript">
			if(opener != null && opener.onRefresh != null){opener.onRefresh();}
			window.location="";
		</script>
<%
		//response.sendRedirect("SellChanceView.jsp?id="+sellchanceid);
		return;
	}
	
	char flag = 2; 
	String ProcPara = "";
	//编辑客户字段
	if("edit_customer_field".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		String fieldname = URLDecoder.decode(Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage()),"utf-8");
		//判断是否有客户编辑权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<2){
			return;
		}
		if(!fieldname.equals("status") && (CustomerInfoComInfo.getCustomerInfostatus(customerid).equals("7") || CustomerInfoComInfo.getCustomerInfostatus(customerid).equals("8") || CustomerInfoComInfo.getCustomerInfostatus(customerid).equals("10"))){
			return;
		}
		
		String oldvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("oldvalue"),"utf-8"));
		String newvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("newvalue"),"utf-8"));
		String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
		
		String addvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("addvalue"),"utf-8"));
		String delvalue = Util.convertInput2DB(URLDecoder.decode(request.getParameter("delvalue"),"utf-8"));
		
		//System.out.println("fieldname==========="+fieldname);
		//System.out.println("fieldtype==========="+fieldtype);
		//System.out.println("delvalue==========="+delvalue);
		
		if(fieldname.equals("manager")){
			rs.executeSql("update CRM_CustomerInfo set manager="+newvalue+" where id="+customerid);
			
			//通知变更前后的客户经理
			String operators = newvalue;
			/**
			String SWFAccepter=operators;
			String SWFTitle=SystemEnv.getHtmlLabelName(15159,user.getLanguage());
			SWFTitle += CustomerInfoComInfo.getCustomerInfoname(customerid);
			SWFTitle += "-"+user.getUsername();
			SWFTitle += "-"+TimeUtil.getCurrentDateString();
			String SWFRemark="";
			String SWFSubmiter = user.getUID()+"";
			SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(customerid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			*/
			rs.executeSql("delete from CRM_shareinfo where contents="+operators+" and sharetype=1 and relateditemid="+customerid);
			
			//修改客户经理重置客户共享
			CrmShareBase.setCRM_WPShare_newCRMManager(customerid);
			//添加新客户标记
			CustomerModifyLog.modify(customerid,oldvalue,newvalue);
			
		}if(fieldname.equals("exploiterIds")){//开拓人员
			if(!addvalue.equals("")){//添加人员
				List idList = Util.TokenizerString(addvalue, ",");
				for(int i=0;i<idList.size();i++){
					if(!"".equals(idList.get(i))){
						rs.executeSql("insert into CRM_CustomerExploiter (customerId,exploiterId) values ("+customerid+","+idList.get(i)+")");
					}
				}
			}
			if(!delvalue.equals("")){//删除人员
				rs.executeSql("delete from CRM_CustomerExploiter where exploiterId in (" + delvalue + ") and customerid="+customerid);
			}
		}if(fieldname.equals("principalIds")){//客服负责人
			if(!addvalue.equals("")){//添加人员
				List idList = Util.TokenizerString(addvalue, ",");
				for(int i=0;i<idList.size();i++){
					if(!"".equals(idList.get(i))){
						rs.executeSql("insert into CS_CustomerPrincipal (customerId,principalId) values ("+customerid+","+idList.get(i)+")");
					}
				}
			}
			if(!delvalue.equals("")){//删除人员
				rs.executeSql("delete from CS_CustomerPrincipal where principalId in (" + delvalue + ") and customerid="+customerid);
			}
		}if(fieldname.equals("othername")){//正式名称
			rs.executeSql("update CRM_OtherName set customername='"+newvalue+"' where customerid="+customerid);
		}else{
			
			//System.out.println("fieldtype========="+fieldtype);
			//System.out.println("newvalue========="+newvalue);
			
			if(fieldtype.equals("attachment")){
				rs.execute("select "+fieldname+" from CRM_CustomerInfo where id = "+customerid);
				rs.next();
				String att = rs.getString(1);
				if(att.equals(delvalue)){
					att = "";
				}else{
					att = (","+att+",").replace((","+delvalue+","), "");
					att = att.indexOf(",")==0?att.substring(1):att;
					att = att.lastIndexOf(",")==att.length()-1?att.substring(0,att.length()-1):att;
				}
				rs.execute("update CRM_CustomerInfo set "+fieldname+" = '"+att +"' where id = "+customerid);
				rs.execute("select filerealpath from ImageFile where imagefileid = "+delvalue);
				while(rs.next()){
					File file = new File(rs.getString("filerealpath"));
					if(file.exists()) file.delete();
				}
				rs.execute("delete from ImageFile where imagefileid = "+delvalue);
				
			}else if(fieldtype.equals("num")){
				sql = "update CRM_CustomerInfo set "+fieldname+"='"+newvalue+"' where id="+customerid;
			}else if(fieldtype.equals("str")){
				sql = "update CRM_CustomerInfo set "+fieldname+"='"+newvalue+"' where id="+customerid;
			}
			rs.executeSql(sql);
		}
		
		if(fieldname.equals("rating")){
			//通知客户经理的经理
			/**
			String operators = ResourceComInfo.getManagerID(CustomerInfoComInfo.getCustomerInfomanager(customerid));
			String SWFAccepter=operators;
			String SWFTitle=SystemEnv.getHtmlLabelName(15158,user.getLanguage());
			SWFTitle += CustomerInfoComInfo.getCustomerInfoname(customerid);
			SWFTitle += "-"+user.getUsername();
			SWFTitle += "-"+TimeUtil.getCurrentDateString();
			String SWFRemark="";
			String SWFSubmiter=user.getUID()+"";;
			SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(customerid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
			*/
		}
		if(fieldname.equals("status")){
			//设置成功客户默认共享
			if(newvalue.equals("4") || oldvalue.equals("4") || newvalue.equals("5") || oldvalue.equals("5")
					|| newvalue.equals("6") || oldvalue.equals("6") || newvalue.equals("8") || oldvalue.equals("8")){
				CrmShareBase.resetStatusShare(customerid);
			}
		}
		if(fieldname.equals("type")){
			//调整为人脉时更新联系人的创建时间
			if(newvalue.equals("26")){
				String contacterid = "";
				String creater = "";
				String createdate = "";
				String createtime = "";
				int count = 0;
				rs.executeSql("select id,creater,createdate,createtime from CRM_CustomerContacter where (createdate='' or createdate is null) and customerid="+customerid);
				while(rs.next()){
					count++;
					if(count>20) break;//超过20个联系人将不进行处理
					contacterid = Util.null2String(rs.getString("id"));
					creater = "";createdate = "";createtime = "";
					rs2.executeSql("select t1.submiter,t1.submitdate,t1.submittime from CRM_Log t1,CRM_Modify t2"
							  +" where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
							  +" and t1.logtype='nc' and t1.customerid="+customerid+" and t2.type="+contacterid);
					if(rs2.next()){
						creater = Util.null2String(rs2.getString("submiter"));
						createdate = Util.null2String(rs2.getString("submitdate"));
						createtime = Util.null2String(rs2.getString("submittime"));
					}else{
						rs2.executeSql("select t1.submiter,t1.submitdate,t1.submittime from CRM_Log t1 where t1.customerid="+customerid+" and t1.logtype='n'");
						if(rs2.next()){
							creater = Util.null2String(rs2.getString("submiter"));
							createdate = Util.null2String(rs2.getString("submitdate"));
							createtime = Util.null2String(rs2.getString("submittime"));
						}
					}
					if(!createdate.equals("")){
						rs2.executeSql("update CRM_CustomerContacter set creater='"+creater+"',createdate='"+createdate+"',createtime='"+createtime+"' where id="+contacterid);
					}
				}
			}
		}
		
		//重置缓存
		CustomerInfoComInfo.updateCustomerInfoCache(customerid);
		
		//记录日志
		ProcPara = customerid+flag+"1"+flag+"0"+flag+"0";
		ProcPara += flag+(String)fn.get(fieldname)+flag+currentdate+flag+currenttime+flag+oldvalue+flag+newvalue;
		ProcPara += flag+(user.getUID()+"")+flag+(user.getLogintype()+"")+flag+request.getRemoteAddr();
		rs.executeProc("CRM_Modify_Insert",ProcPara);
		System.err.println(request.getRemoteAddr()+"===");
		ProcPara = customerid;
		ProcPara += flag+"m";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+currentdate;
		ProcPara += flag+currenttime;
		ProcPara += flag+(user.getUID()+"");
		ProcPara += flag+(user.getLogintype()+"");
		ProcPara += flag+request.getRemoteAddr();
		rs.executeProc("CRM_Log_Insert",ProcPara);
	}	
	
	//添加查看日志
	if("add_log_view".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		//判断是否有查看该客户权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<1) return;
		
		ProcPara = customerid;
		ProcPara += flag+"v";
		ProcPara += flag+"";
		ProcPara += flag+"";
		ProcPara += flag+currentdate;
		ProcPara += flag+currenttime;
		ProcPara += flag+(user.getUID()+"");
		ProcPara += flag+(user.getLogintype()+"");
		ProcPara += flag+request.getRemoteAddr();
		rs.executeProc("CRM_Log_Insert",ProcPara);
	}
	//读取日志明细
	if("get_log_count".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		rs.executeSql("select count(*) from CRM_Log where customerid="+customerid);
		int count = 0;
		if(rs.next()) count = Util.getIntValue(rs.getString(1),0);
		restr.append(count);
	}
	if("get_log_list".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		//判断是否有查看该客户权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<1) return;
		
		String orderby1 = " order by submitdate desc,submittime desc";
		String orderby2 = " order by submitdate asc,submittime asc";
		String orderby3 = " order by submitdate desc,submittime desc";
		int currentpage = Util.getIntValue(request.getParameter("currentpage"),0);
		int pagesize = Util.getIntValue(request.getParameter("pagesize"),0);
		int total = Util.getIntValue(request.getParameter("total"),0);
		String querysql = "logtype,documentid,logcontent,submitdate,submittime,submiter,clientip,submitertype from CRM_Log where customerid="+customerid;
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
		String contentmp = "";
		String modifytime = "";
		String modifydata = "";
		String logtype = "";
		String submitertype = "";
		
		String fieldname = "";
		String original = "";
		String modified = "";
		String oldstr = "";
		String newstr = "";
		while(rs.next()){
			contentmp = "";
			modifytime = rs.getString("submittime");
			modifydata = rs.getString("submitdate");
			logtype = Util.null2String(rs.getString("logtype"));
			submitertype = Util.null2String(rs.getString("submitertype"));
			if(logtype.startsWith("v")){
				logtxt="<font class='log_txt'>查看客户";
			}else if(logtype.startsWith("r")){
				logtxt="<font class='log_txt'>提醒客户";
			}else if(logtype.startsWith("n")){
				logtxt="<font class='log_txt'>新建";
			}else if(logtype.startsWith("d")){
				logtxt="<font class='log_txt'>删除";
			}else if(logtype.startsWith("a")){
				logtxt="<font class='log_txt'>状态";
			}else if(logtype.startsWith("p")){
				logtxt="<font class='log_txt'>门户";
			}else if(logtype.startsWith("m")){
				logtxt="<font class='log_txt'>编辑";
			}else if(logtype.startsWith("u")){
				logtxt="<font class='log_txt'>合并";
				String unitcrm = rs.getString("logcontent");
				try { 
					contentmp="相关客户(";
				    unitcrm=unitcrm.substring(unitcrm.indexOf(": ")+1);
					ArrayList crmnameArray=Util.TokenizerString(unitcrm,",");
					for(int k=0;k<crmnameArray.size();k++){
						String tempcrmname=""+crmnameArray.get(k);
						if("1".equals(tempcrmname.trim())) continue;
						if(k>50) break;
		             	rs2.execute("select id from crm_customerinfo where deleted = '1' and name='"+tempcrmname.trim()+"' ");
					 	while (rs2.next()){ 
					 		String temcrmid=rs2.getString(1);
							contentmp+=("<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+temcrmid+"' target='_news'>"+tempcrmname+"</a> 　");
						}
					}
				   	contentmp+=")";
				}catch (Exception ee){}
			}else{
				logtxt="<font class='log_txt'>";
			}
			if(logtype.length()>1){
				if(logtype.substring(1).equals("c")){
					logtxt += ": "+SystemEnv.getHtmlLabelName(572,user.getLanguage());
				}else if(logtype.substring(1).equals("a")){
					logtxt += ": "+SystemEnv.getHtmlLabelName(110,user.getLanguage());
				}else if(logtype.substring(1).equals("s")){
					logtxt += ": "+SystemEnv.getHtmlLabelName(119,user.getLanguage());
				}
			}
			logtxt += "</font> ";
			
			rs2.executeSql("select fieldname,original,modified from CRM_Modify where customerid = "+customerid+" and modifydate='"+modifydata+"' and modifytime='"+modifytime+"' and fieldname <> '中介机构' order by modifydate,modifytime desc");
	        while (rs2.next()) {
				fieldname = Util.null2String(rs2.getString("fieldname"));
                original = rs2.getString("original");
				modified = rs2.getString("modified");
				oldstr = "";
				newstr = "";
				if(!"".equals(original)) {
					oldstr = SptmForCrmModiRecord.getCrmModiInfo(fieldname,original);
					if(fieldname.equals("状态")) oldstr = CustomerStatusComInfo.getCustomerStatusname(original);
				}
				if(!"".equals(modified)) {
				    newstr = SptmForCrmModiRecord.getCrmModiInfo(fieldname,modified);
				    if(fieldname.equals("状态")) newstr = CustomerStatusComInfo.getCustomerStatusname(modified);
				}
				if(!"".equals(oldstr) || !"".equals(newstr)) {
					if("".equals(oldstr)) oldstr = "&nbsp;&nbsp;";
                	contentmp += "<font class='log_txt'>将</font> <font class='log_field'>"+fieldname+"</font> <font class='log_txt'>由</font> <font class='log_value'>'"+oldstr+"'</font> <font class='log_txt'>更新为</font> <font class='log_value'>'"+ newstr +"\"</font>";
				} else {
					if("".equals(original)) original = "&nbsp;&nbsp;";
					//contentmp += fieldname +"由:<font color=red>\"" + original + "\"</font>改成:<font color=red>\""+ modified +"\"</font> </br>";
					contentmp += "<font class='log_txt'>将</font> <font class='log_field'>"+fieldname+"</font> <font class='log_txt'>由</font> <font class='log_value'>'"+original+"'</font> <font class='log_txt'>更新为</font> <font class='log_value'>'"+ modified +"\"</font>";
				}
			}
	        logtxt += contentmp;
%>
	<div class='logitem'>
		<%=submitertype.equals("2")?cmutil.getCustomer(rs.getString("submiter")):cmutil.getHrm(rs.getString("submiter")) %>&nbsp;&nbsp;<font class='datetxt'><%=modifydata+" "+modifytime %></font>&nbsp;&nbsp;
		<%=logtxt %>
	</div>
<%
			
		} 
	}
	if("add_signname".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		String addname = URLDecoder.decode(Util.fromScreen3(request.getParameter("addname"),user.getLanguage()),"utf-8");
		//判断是否有客户编辑权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<2){
			return;
		}
		rs.executeSql("insert into CRM_OtherName(nametype,customerid,customername) values(2,"+customerid+",'"+addname+"')");
		rs.executeSql("select max(id) from CRM_OtherName");
		String addid = "";
		if(rs.next()) addid = Util.null2String(rs.getString(1));
%>
								<tr id="tr_<%=addid %>">
									<td class="data">
										<input type="text" class="item_input" _id="<%=addid %>" value="<%=addname %>"/>
										<div class="btn_delete" _id="<%=addid %>"></div>
									</td>
								</tr>
<%		
	}
	if("edit_signname".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		String editid = Util.fromScreen3(request.getParameter("editid"),user.getLanguage());
		String editname = URLDecoder.decode(Util.fromScreen3(request.getParameter("editname"),user.getLanguage()),"utf-8");
		//判断是否有客户编辑权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<2){
			return;
		}
		rs.executeSql("update CRM_OtherName set customername='"+editname+"' where id="+editid);
	}
	if("delete_signname".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		String deleteid = Util.fromScreen3(request.getParameter("deleteid"),user.getLanguage());
		//判断是否有客户编辑权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<2){
			return;
		}
		rs.executeSql("delete from CRM_OtherName where id="+deleteid);
	}
	//添加标签
	if("save_tag".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		//判断权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<1) return;
		
		String tagstr = URLDecoder.decode(Util.null2String(request.getParameter("tag")),"utf-8").replaceAll(",","");
		if(!tagstr.equals("")){
			rs.executeSql("insert into CRM_CustomerTag (customerid,tag,creater,createdate,createtime)"
					+" select '"+customerid+"','"+tagstr+"','"+user.getUID()+"','"+currentdate+"','"+currenttime+"'"
					+" where not exists(select 1 from CRM_CustomerTag where customerid='"+customerid+"' and tag='"+tagstr+"' and creater='"+user.getUID()+"')");
%>
	<div class="tagitem" _val="<%=tagstr %>" title="<%=tagstr %>-<%=user.getUsername()+" "+currentdate+" "+currenttime %>"><%=tagstr %><div class="tagdel" onclick="doDelTag('<%=tagstr %>',this)" title="删除"></div></div>
<%		}
	}
	//添加标签
	if("batch_save_tag".equals(operation)){
		String customerids = Util.fromScreen3(request.getParameter("customerids"),user.getLanguage());
		String tagstr = Util.convertDB2Input(request.getParameter("tag"));
		List crmidList = Util.TokenizerString(customerids,",");
		String customerid = "";
		if(!tagstr.equals("")){
			for(int i=0;i<crmidList.size();i++){
				customerid = Util.null2String((String)crmidList.get(i));
				//判断权限
				int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
				if(sharelevel<1) continue;
			
				rs.executeSql("insert into CRM_CustomerTag (customerid,tag,creater,createdate,createtime)"
						+" select '"+customerid+"','"+tagstr+"','"+user.getUID()+"','"+currentdate+"','"+currenttime+"'"
						+" where not exists(select 1 from CRM_CustomerTag where customerid='"+customerid+"' and tag='"+tagstr+"' and creater='"+user.getUID()+"')");
			}
		}
	}
	//删除标签
	if("del_tag".equals(operation)){
		String customerid = Util.fromScreen3(request.getParameter("customerid"),user.getLanguage());
		//判断权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		if(sharelevel<1) return;
		String tagstr = URLDecoder.decode(Util.null2String(request.getParameter("tag")),"utf-8").replaceAll(",","");
		rs.executeSql("delete from CRM_CustomerTag where customerid="+customerid+" and tag='"+tagstr+"' and creater="+user.getUID());
	}
	out.print(restr.toString());
	//out.close();
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
		}else if("producttype".equals(field)){
			ProductTypeComInfo productTypeComInfo = null;
			try{
				productTypeComInfo = new ProductTypeComInfo();
			}catch(Exception e){
				
			}
			return productTypeComInfo.getName(value);
		}else{
			return value;
		}
	}
%>
