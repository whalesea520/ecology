
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	int reporttype = Util.getIntValue(request.getParameter("reporttype"),1);//统计报表类型 1为商机报表
	int detailtype = Util.getIntValue(request.getParameter("detailtype"),1);
	String userid = Util.null2String(request.getParameter("userid"));
	if(userid.equals("") || !ResourceComInfo.isManager(user.getUID(),userid)){
		userid = user.getUID()+"";
	}
	int subtype = Util.getIntValue(request.getParameter("subtype"),0);//是否包含下属类型   1为本人  2为下属  否则为本人及下属
	int showall = Util.getIntValue(request.getParameter("showall"),0);//是否显示所有人员 
	String ym = Util.null2String(request.getParameter("ym"));
	int ordertype = Util.getIntValue(request.getParameter("ordertype"),1);//排序类型
	int stattype = Util.getIntValue(request.getParameter("stattype"),1);//统计类型
	String crmtype = Util.null2String(request.getParameter("crmtype"));
	String crmstatus = Util.null2String(request.getParameter("crmstatus"));
	
	int dp = 0;//小数位数
	int iscommafy = 0;//是否千分位显示：
	String backfield = " e.hrm,d.value,e.place ";
	backfield = " hrm,value";
	String sql = "";
	String cwhere = "";
	String hwhere = " and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)";
	if(subtype==1){
		hwhere += " and h.id ="+userid;
	}else if(subtype==2){
		hwhere += " and h.managerstr like '%,"+userid+",%'";
	}else{
		hwhere += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
	}
	String mainfield = " h.id";
	if(stattype!=1) mainfield = " h.departmentid";
	
	String owhere = "";
	if(reporttype==1){//商机统计
		int sellstatus = Util.getIntValue(request.getParameter("sellstatus"),-1);
		int selllat = Util.getIntValue(request.getParameter("selllat"),1);
		int sellcontact = Util.getIntValue(request.getParameter("sellcontact"),-1);
		String contactdate = Util.null2String(request.getParameter("contactdate"));
		String latfield = "t1.createdate";
		if(selllat==2) latfield = "t1.predate";
		
		cwhere = " and "+latfield+" like '"+ym+"%'";
		if(sellcontact!=-1){
			owhere += " and "+((sellcontact==1)?"not":"")
				+" exists(select 1 from WorkPlan w where convert(varchar,t1.customerid)=convert(varchar,w.crmid)"
				+" and (w.sellchanceid=t1.id or (w.sellchanceid is null and w.contacterid is null))"
				+" and w.type_n='3' and w.begindate is not null and w.begindate<>''";
			if(!contactdate.equals(""))
				owhere += " and w.begindate<='"+TimeUtil.getCurrentDateString()+"' and w.begindate>='"+contactdate+"'";
			owhere += ")";
		}
		if(detailtype==1){//商机数量
			sql = " FROM "
				+ "(select "+mainfield+" as hrm,count(t1.id) as value from HrmResource h "
				+ ((showall==1)?"left":"")+" join CRM_Sellchance t1 on h.id=t1.creater"
				+ " and "+latfield+" like '"+ym+"%'"+((sellstatus!=-1)?" and t1.endtatusid="+sellstatus:"")
				+ " where 1=1 "+hwhere+owhere
				+ " group by "+mainfield+") T";
		}else if(detailtype==2){//预期收益
			iscommafy = 1;
			dp = 2;
			sql = " FROM "
				+ "(select "+mainfield+" as hrm,sum(t1.preyield) as value from HrmResource h "
				+ ((showall==1)?"left":"")+" join CRM_Sellchance t1 on h.id=t1.creater"
				+ " and "+latfield+" like '"+ym+"%'"+((sellstatus!=-1)?" and t1.endtatusid="+sellstatus:"")
				+ " where 1=1 "+hwhere+owhere
				+ " group by "+mainfield+") T";
		}else if(detailtype==3){//完成比例
			backfield = " hrm,value,v1,v2 ";
			if(stattype==1){
				sql = " FROM "
					+ "(select h.id as hrm,d.value as value,d.v1,d.v2 from HrmResource h "
					+ ((showall==1)?"left":"")+" join "
					+ "  (select m.creater,isnull(n.value/m.value*100,0) as value,n.value as v1,m.value as v2 from"
			     	+ "		(select t1.creater,convert(decimal(10,2),count(t1.id)) as value from CRM_Sellchance t1 where 1=1 "+cwhere+" group by t1.creater) m"
			     	+ "		left join (select t1.creater,convert(decimal(10,2),count(t1.id)) as value from CRM_Sellchance t1 where t1.endtatusid =1 "+cwhere+owhere+" group by t1.creater) n"
			     	+ "		on m.creater=n.creater) d"
					+ " on h.id=d.creater"
					+ " where 1=1 "+hwhere
					+ " ) T";
			}else{
				sql = " FROM "
					+ "(select k.id as hrm,d.value as value,d.v1,d.v2 from HrmDepartment k "
					+ ((showall==1)?"left":"")+" join "
					+ "  (select m.departmentid,isnull(n.value/m.value*100,0) as value,n.value as v1,m.value as v2 from"
			     	+ "		(select h.departmentid,convert(decimal(10,2),count(t1.id)) as value from CRM_Sellchance t1,HrmResource h where t1.creater=h.id "+cwhere+hwhere+" group by h.departmentid) m"
			     	+ "		left join (select h.departmentid,convert(decimal(10,2),count(t1.id)) as value from CRM_Sellchance t1,HrmResource h where t1.creater=h.id and t1.endtatusid =1 "+cwhere+hwhere+owhere+" group by h.departmentid) n"
			     	+ "		on m.departmentid=n.departmentid) d"
					+ " on k.id=d.departmentid"
					+ " ) T";
			}
		}
	}else if(reporttype==2 || reporttype==11){//客户联系
		if(reporttype==2){
			if(!crmtype.equals("")) owhere += " and t1.type in("+crmtype+")";
			if(!crmstatus.equals("")) owhere += " and t1.status in("+crmstatus+")";
		}else{
			owhere += " and t1.type=26";
		}
		
		if(detailtype==2){//联系数量
			sql = " FROM "
				+ "(select "+mainfield+" as hrm,count(t1.id) as value from HrmResource h "
				+ ((showall==1)?"left":"")+" join CRM_CustomerInfo t1 on h.id=t1.manager and t1.status<>13 and (t1.deleted=0 or t1.deleted is null)"
				+ " and exists(select 1 from WorkPlan w where convert(varchar,t1.id)=convert(varchar,w.crmid) and w.type_n='3' and w.begindate like '"+ym+"%')"+owhere// and w.createrid=t1.manager
				+ " where 1=1 "+hwhere
				+ " group by "+mainfield+") T";
		}else if(detailtype==1){//新增数量
			sql = " FROM "
				+ "(select "+mainfield+" as hrm,count(t1.id) as value from HrmResource h "
				+ ((showall==1)?"left":"")+" join CRM_CustomerInfo t1 on h.id=t1.manager and t1.status<>13 and (t1.deleted=0 or t1.deleted is null)"
				+ " and t1.createdate like '"+ym+"%'"+owhere
				+ " where 1=1 "+hwhere
				+ " group by "+mainfield+") T";
		}else if(detailtype==3){//联系比例
			cwhere = " and (t1.deleted=0 or t1.deleted is null)";
			backfield = " hrm,value,v1,v2 ";
			if(stattype==1){
				sql = " FROM "
					+ "(select h.id as hrm,d.value as value,d.v1,d.v2 from HrmResource h "
					+ ((showall==1)?"left":"")+" join "
					+ "  (select m.manager,isnull(n.value/m.value*100,0) as value,n.value as v1,m.value as v2 from"
			     	+ "		(select t1.manager,convert(decimal(10,2),count(t1.id)) as value from CRM_CustomerInfo t1 where 1=1 and t1.status<>13 "+cwhere+owhere+" group by t1.manager) m"
			     	+ "		left join (select t1.manager,convert(decimal(10,2),count(t1.id)) as value from CRM_CustomerInfo t1 where 1=1 and t1.status<>13 "+cwhere+owhere
			     	+ "      	and exists(select 1 from WorkPlan w where convert(varchar,t1.id)=convert(varchar,w.crmid) and w.type_n='3' and w.begindate like '"+ym+"%') group by t1.manager) n"// and w.createrid=t1.manager
			     	+ "		on m.manager=n.manager) d"
					+ " on h.id=d.manager"
					+ " where 1=1 "+hwhere
					+ " ) T";
			}else{
				sql = " FROM "
					+ "(select k.id as hrm,d.value as value,d.v1,d.v2 from HrmDepartment k "
					+ ((showall==1)?"left":"")+" join "
					+ "  (select m.departmentid,isnull(n.value/m.value*100,0) as value,n.value as v1,m.value as v2 from"
			     	+ "		(select h.departmentid,convert(decimal(10,2),count(t1.id)) as value from CRM_CustomerInfo t1,HrmResource h where t1.manager=h.id and t1.status<>13 "+cwhere+hwhere+owhere+" group by h.departmentid) m"
			     	+ "		left join (select h.departmentid,convert(decimal(10,2),count(t1.id)) as value from CRM_CustomerInfo t1,HrmResource h where t1.manager=h.id and t1.status<>13 "+cwhere+hwhere+owhere
			     	+ "      	and exists(select 1 from WorkPlan w where convert(varchar,t1.id)=convert(varchar,w.crmid) and w.type_n='3' and w.begindate like '"+ym+"%') group by h.departmentid) n"// and w.createrid=t1.manager
			     	+ "		on m.departmentid=n.departmentid) d"
					+ " on k.id=d.departmentid"
					+ " ) T";
			}
		}else if(detailtype==4){//新增人脉数量
			sql = " FROM "
				+ "(select "+mainfield+" as hrm,count(cc.id) as value from HrmResource h "
				+ ((showall==1)?"left":"")+" join CRM_CustomerInfo t1 on h.id=t1.manager and t1.status<>13 and (t1.deleted=0 or t1.deleted is null)"
				+ " and t1.type=26"
				+ ((showall==1)?"left":"")+" join CRM_CustomerContacter cc on cc.customerid=t1.id and cc.createdate like '"+ym+"%'"
				+ " where 1=1 "+hwhere
				+ " group by "+mainfield+") T";
		}
	}
	//System.out.println("select count(*) "+sql);
	
	int _pagesize = 10;
	int _total = 0;//总数
	rs.executeSql("select count(*) "+sql);
	//System.out.println("select count(t.id) "+statsql+sqlwhere);
	if(rs.next()){
		_total = rs.getInt(1);
	}
	
	request.getSession().setAttribute("CRM_PLACE_SQL",backfield+sql);
	
	//rs.executeSql(sql);
%>
						<table id="table1" class="placetable" style="width: 100%;margin-top: 0px;" cellpadding="0" cellspacing="0" border="0">
							<colgroup><col width="*"/></colgroup>
							<tr>
								<td valign="top">
									<table id="placetable" class="listtable" cellpadding="0" cellspacing="0" border="0">
										<colgroup><col width="50%"/><col width="50%"/></colgroup>
										<%if(_total==0){ %>
											<tr><td colspan="2" style="text-align: left;padding-left: 5px;color: #808080;">暂无数据！</td></tr>
										<%}else{ %>
											<jsp:include page="Operation.jsp">
												<jsp:param value="get_place" name="operation"/>
												<jsp:param value="1" name="currentpage"/>
												<jsp:param value="<%=_pagesize %>" name="pagesize"/>
												<jsp:param value="<%=_total %>" name="total"/>
												<jsp:param value="<%=dp %>" name="dp"/>
												<jsp:param value="<%=ym %>" name="ym"/>
												<jsp:param value="<%=iscommafy %>" name="iscommafy"/>
												<jsp:param value="<%=detailtype %>" name="detailtype"/>
												<jsp:param value="<%=reporttype %>" name="reporttype"/>
												<jsp:param value="<%=ordertype %>" name="ordertype"/>
												<jsp:param value="<%=stattype %>" name="stattype"/>
												
											</jsp:include>
										<%} %>
									</table>
									<div id="placemore" class="listmore" style="<%if(_pagesize>=_total){ %>display: none;<%} %>" 
										onclick="getPlaceData(this)" _datalist="placetable" _currentpage="1" _pagesize="<%=_pagesize %>" 
										_total="<%=_total %>" _querysql="" _iscommafy="<%=iscommafy %>" _dp="<%=dp %>" _ym="<%=ym %>" 
										_detailtype="<%=detailtype %>" _reporttype="<%=reporttype %>" _ordertype="<%=ordertype %>" _stattype="<%=stattype %>" title="显示更多数据">更多</div>	
								</td>
							</tr>
						</table>
						
						<script type="text/javascript">
							
						</script>
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
/**
 * 对金额加入千分位符号
 * @param s
 * @param len
 * @return
 */
public static String comma(String s,int len) {
	
	if (s == null || s.length() < 1) {
		return "";
	}
	NumberFormat formater = null;
	double num = Double.parseDouble(s);
	if (len == 0) {
		formater = new DecimalFormat("###,##0");
	} else {
		StringBuffer buff = new StringBuffer();
		buff.append("###,##0.");
		for (int i = 0; i < len; i++) {
			buff.append("0");
		}
		formater = new DecimalFormat(buff.toString());
	}

    return formater.format(num);
}
%>