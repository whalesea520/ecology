
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="java.text.*" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%	
	String userid = user.getUID()+"";
	String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
	String creater = Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
	String creatertype = Util.fromScreen3(request.getParameter("creatertype"), user.getLanguage());
	String customerid = Util.fromScreen3(request.getParameter("customerid"), user.getLanguage());
	String createDateFrom = Util.fromScreen3(request.getParameter("createDateFrom"), user.getLanguage());
	String createDateTo = Util.fromScreen3(request.getParameter("createDateTo"), user.getLanguage());
	String selltype = Util.fromScreen3(request.getParameter("selltype"), user.getLanguage());
	String sellstatusid = Util.fromScreen3(request.getParameter("sellstatusid"), user.getLanguage());
	String sellstatusid2 = Util.fromScreen3(request.getParameter("sellstatusid2"), user.getLanguage());
	String sellDateFrom = Util.fromScreen3(request.getParameter("sellDateFrom"), user.getLanguage());
	String sellDateTo = Util.fromScreen3(request.getParameter("sellDateTo"), user.getLanguage());
	String attention=Util.null2String(request.getParameter("attention"));
	String subcompanyId = Util.fromScreen3(request.getParameter("subcompanyId"), user.getLanguage());
	String departmentId = Util.fromScreen3(request.getParameter("deptId"), user.getLanguage());
	
	String predate = Util.fromScreen3(request.getParameter("predate"), user.getLanguage());
	String moneymin = Util.fromScreen3(request.getParameter("moneymin"), user.getLanguage());
	String moneymax = Util.fromScreen3(request.getParameter("moneymax"), user.getLanguage());
	String posiblemin = Util.fromScreen3(request.getParameter("posiblemin"), user.getLanguage());
	String posiblemax = Util.fromScreen3(request.getParameter("posiblemax"), user.getLanguage());
	
	String nocontact = Util.fromScreen3(request.getParameter("nocontact"), user.getLanguage());
	String contact = Util.fromScreen3(request.getParameter("contact"), user.getLanguage());
	String contacttype = Util.fromScreen3(request.getParameter("contacttype"), user.getLanguage());
	String keyname = URLDecoder.decode(Util.null2String(request.getParameter("keyname")),"utf-8");
	
	String remind = Util.fromScreen3(request.getParameter("remind"), user.getLanguage());
	
	String endtatusid = "0";
	if("-1".equals(sellstatusid)) endtatusid = "1";
	if("-2".equals(sellstatusid)) endtatusid = "2";
	if("-3".equals(sellstatusid)) endtatusid = "";
	if("-4".equals(sellstatusid)) endtatusid = "3";
	if("-5".equals(sellstatusid)) endtatusid = "4";

	if("0".equals(creatertype) || "-1".equals(creatertype) || "1".equals(attention)){//全部 或 非本人
		if(!creater.equals(userid)){
			userid = creater;
		}
	}
	String condition = "";
	//找到用户能看到的所有客户
	//如果属于总部级的CRM管理员角色，则能查看到所有客户。
	rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
	if (rs.next()) {
		condition = "(select id,name from CRM_CustomerInfo where (deleted=0 or deleted is null)) as customerIds";
	} else {
		String leftjointable = CrmShareBase.getTempTable(userid);
		condition = "(select distinct t1.id,t1.name "
			+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
			+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
	}
	String basesql = " t.id,t.customerid,t.creater,t.subject,t.comefromid,t.sellstatusid,t.endtatusid,t.predate,t.preyield,t.currencyid,t.probability,t.createdate,t.createtime,t.content,t.approver,"
				+ "t.approvedate,t.approvetime,t.approvestatus,t.sufactor,t.defactor,t.departmentId,t.subCompanyId,t.selltype,sa.id as att "
				+ "from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id "
				+"left join CRM_Common_Attention sa on t.id=sa.objid and sa.operatetype=2 and sa.operator="+user.getUID();
	String statsql = " from CRM_SellChance t join "+condition+" on t.customerid = customerIds.id ";
	String sqlwhere = " where 1=1";
	String currentdate = TimeUtil.getCurrentDateString();
	
	String namewhere1 = "";
	String namewhere2 = "";
	if(!keyname.equals("")){
		if(keyname.indexOf("+")>0){
			String[] ands = keyname.split("\\+");
			if(ands.length>0){
				namewhere1 += " ( ";
				namewhere2 += " ( ";
				for(int i=0;i<ands.length;i++){
					if(i == 0){
						namewhere1 += " t.subject like '%" + ands[i] + "%'";
						namewhere2 += " customerIds.name like '%" + ands[i] + "%'";
					}else{
						namewhere1 += " and  t.subject like '%" + ands[i] + "%'";
						namewhere2 += " and  customerIds.name like '%" + ands[i] + "%'";
					}
				}
				namewhere1 += " ) ";
				namewhere2 += " ) ";
			}
		}else{
			String[] ors = keyname.split(" ");
			if(ors.length>0){
				namewhere1 += " ( ";
				namewhere2 += " ( ";
				for(int i=0;i<ors.length;i++){
					if(i == 0){
						namewhere1 += " t.subject like '%" + ors[i] + "%'";
						namewhere2 += " customerIds.name like '%" + ors[i] + "%'";
					}else{
						namewhere1 += " or  t.subject like '%" + ors[i] + "%'";
						namewhere2 += " or  customerIds.name like '%" + ors[i] + "%'";
					}
				}
				namewhere1 += " ) ";
				namewhere2 += " ) ";
			}
		}
		sqlwhere += " and ("+namewhere1+" or "+namewhere2+")";
	}
	
	if(!"".equals(subcompanyId)){
		String subCompanyIds = subcompanyId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subcompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		subCompanyIds = "("+subCompanyIds+")";
		sqlwhere += " and exists(select 1 from HrmResource hrm where hrm.id=t.creater and hrm.subcompanyid1 in "+subCompanyIds+")";
		//sqlwhere += " and t.subCompanyId = "+subcompanyId;
	}
	if(!"".equals(departmentId)){
		String departmentIds = departmentId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		departmentIds = "("+departmentIds+")";
		sqlwhere += " and exists(select 1 from HrmResource hrm where hrm.id=t.creater and hrm.departmentid in "+departmentIds+")";
		//sqlwhere += " and t.departmentId = "+departmentId;
	}
	if(!"".equals(subject)){
		sqlwhere += " and t.subject like '%"+subject+"%'";
	}
	if(!"0".equals(creatertype) && !"1".equals(attention)){//非全部并且非关注
		if("-1".equals(creatertype)){//非本人
			sqlwhere += " and t.creater <> "+creater+" and not exists(select 1 from HrmResource hrm where hrm.id=t.creater and hrm.managerstr like '%,"+creater+",%')";
		}else{
			int subtype = Util.getIntValue(request.getParameter("subtype"),0);
			if(subtype==1){
				sqlwhere += " and t.creater ="+creater;
			}else if(subtype==2){
				sqlwhere += " and exists(select 1 from HrmResource hrm where hrm.id=t.creater and hrm.managerstr like '%,"+creater+",%')";
			}else{
				sqlwhere += " and (t.creater ="+creater+" or exists(select 1 from HrmResource hrm where hrm.id=t.creater and hrm.managerstr like '%,"+creater+",%'))";
			}
		}
	}
	if(!"".equals(predate)){
		sqlwhere += " and t.predate like '"+predate+"%'";
	}
	if(!"".equals(customerid)){
		sqlwhere += " and t.customerid ="+customerid;
	}
	if(!"".equals(createDateFrom)){
		sqlwhere += " and t.createdate >='"+createDateFrom+"'";
	}
	if(!"".equals(createDateTo)){
		sqlwhere += " and t.createdate <='"+createDateTo+"'";
	}
	if(!"".equals(selltype)){
		sqlwhere += " and t.selltype ="+selltype;
	}
	if(!"".equals(sellstatusid) && !"-1".equals(sellstatusid) && !"-2".equals(sellstatusid) && !"-3".equals(sellstatusid) && !"-4".equals(sellstatusid) && !"-5".equals(sellstatusid)){
		sqlwhere += " and t.sellstatusid ="+sellstatusid;
	}
	if(!"".equals(sellstatusid2)){
		sqlwhere += " and t.sellstatusid ="+sellstatusid2;
	}
	if(!"".equals(endtatusid)){
		sqlwhere += " and t.endtatusid ="+endtatusid;
	}
	if(!"".equals(sellDateFrom)){
		sqlwhere += " and t.predate >='"+sellDateFrom+"'";
	}
	if(!"".equals(sellDateTo)){
		sqlwhere += " and t.predate <='"+sellDateTo+"'";
	}
	if(!"".equals(moneymin)){
		sqlwhere += " and t.preyield >="+moneymin;
	}
	if(!"".equals(moneymax)){
		sqlwhere += " and t.preyield <"+moneymax;
	}
	if(!"".equals(posiblemin)){
		sqlwhere += " and t.probability >="+posiblemin;
	}
	if(!"".equals(posiblemax)){
		sqlwhere += " and t.probability <"+posiblemax;
	}
	if("1".equals(attention)){
		sqlwhere += " and exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=2 and t2.operator="+creater+")";
	}
	if("0".equals(attention)){
		sqlwhere += " and not exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=2 and t2.operator="+creater+")";
	}
	if(!"".equals(nocontact)){
		sqlwhere += " and not exists (select 1 from WorkPlan w where w.type_n=3 and w.createrType='1'"
					+" and w.crmid not like '%,%' and w.crmid=t.id and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))"
					+" and w.begindate>='"+nocontact+"'";
		if(contacttype.equals("1")){
			sqlwhere += " and w.createrid=t.creater ";
		}
		sqlwhere += ") and t.createdate<'"+nocontact+"'";
	}
	if(!"".equals(contact)){
		sqlwhere += " and exists (select 1 from WorkPlan w where w.type_n=3 and w.createrType='1'"
					+" and w.crmid not like '%,%' and w.crmid=t.id and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))"
					+" and w.begindate>='"+contact+"'";
		if(contacttype.equals("1")){
			sqlwhere += " and w.createrid=t.creater ";
		}
		sqlwhere += ")";
	}
	if("1".equals(remind)){
		sqlwhere += " and exists (select 1 from CRM_Common_Remind r where r.operatetype=2 and r.objid=t.id)";
	}
	
	//System.out.println(basesql+sqlwhere);
	int _pagesize = 20;
	int _total = 0;//总数
	rs.executeSql("select count(t.id) "+statsql+sqlwhere);
	if(rs.next()){
		_total = rs.getInt(1);
	}
	String totalmoney = "0.00";
	rs.executeSql("select sum(t.preyield) "+statsql+sqlwhere);
	if(rs.next()){
		totalmoney = Util.null2String(rs.getString(1));
	}
	if(!totalmoney.equals("")){
		totalmoney = comma(totalmoney,2);
	}else{
		totalmoney = "0.00";
	}
	
	request.getSession().setAttribute("CRM_LIST_SQL",basesql+sqlwhere);
%>
<style type="text/css">
	
</style>
<div style="width: auto;height:100%;position: relative;">
	
	<!-- 数据列表 -->
	<div id="list" style="position: relative;width: 100%;height:100%;background-color: #fff;background: url('../images/line_wev8.png') left repeat-y;">
		<div style="width: 100%;height:100%;position: relative;">
			<table id="datalist" class="datalist" cellpadding="0" cellspacing="0" border="0">
				<colgroup><col width="23"/><col width="*"/><%if(endtatusid.equals("0")){ %><col width="60px"/><%}else{ %><col width="0px"/><%} %><col width="40px"/><col width="80px"/><col width="90px"/><col width="50px"/><col width="45px"/></colgroup>
				<%if(_total==0){ %>
				<tr class=""><td class='td_move'></td><td colspan="7" style="padding-left: 4px;font-style: italic">暂无相关数据</td></tr>
				<%}else{ %>
				<jsp:include page="Operation.jsp">
					<jsp:param value="get_list_data" name="operation"/>
					<jsp:param value="1" name="currentpage"/>
					<jsp:param value="<%=_pagesize %>" name="pagesize"/>
					<jsp:param value="<%=_total %>" name="total"/>
					<jsp:param value="<%=endtatusid %>" name="endtatusid"/>
				</jsp:include>
				<%} %>
			</table>
			<div id="listmore" class="listmore" style="<%if(_pagesize>=_total){ %>display: none;<%} %>" onclick="getListData(this)" _datalist="datalist" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" _endtatusid="<%=endtatusid %>" title="显示更多数据">更多</div>	
		</div>
	</div>
</div>
	<script type="text/javascript">
			var defaultname = "";
			var foucsobj = null;
			var detailid = "";
			var currentdate = "<%=currentdate%>";
			var olddatetype = null;

			//初始绑定事件
			$(document).ready(function(){
				$("#stat").html("总计 <%=_total%> 个商机，预期收益 <%=totalmoney%>");
			});


			//读取列表更多记录
			function getListData(obj){
				var _datalist = $(obj).attr("_datalist");
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				var _querysql = $(obj).attr("_querysql");
				var _endtatusid = $(obj).attr("_endtatusid");
				$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_list_data","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"querysql":filter(encodeURI(_querysql)),"endtatusid":_endtatusid}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	var records = $.trim(data.responseText);
				    	$("#"+_datalist).append(records);
				    	if(_currentpage*_pagesize>=_total){
				    		$(obj).hide();
					    }else{
					    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
						}
					}
			    });
			}

			//设置序号
			function setIndex(){
				$("table.datalist").each(function(){
					var index=1;
					$(this).find(".td_move").each(function(){
						if(!$(this).hasClass("td_att")){
							$(this).html(index);
						}else{

						}
						index++;
					});
				});
			}

			//键盘上下移动事件
			function moveUpOrDown(d,cobj){
				var inputs = $("input.disinput");
				var len = inputs.length;
				var showobj;
				if(len>1){
					for(var i=0;i<len;i++){
						if($(inputs[i]).attr("_index")==cobj.attr("_index")){
							if(d==2){
								if(i==0) i=len;
								showobj = $(inputs[i-1]);
							}
							if(d==1){
								if(i==(len-1)) i=-1;
								showobj = $(inputs[i+1]);
							}

							showobj.parent().parent().click();
							//showobj.focus();
							
							var obj = showobj.get(0);
						    if (obj.createTextRange) {//IE浏览器
						       var range = obj.createTextRange();
						       range.moveStart("character", showobj.val().length);
						       range.collapse(true);
						       range.select();
						    } else {//非IE浏览器
						       obj.setSelectionRange(showobj.val().length, showobj.val().length);
						       obj.focus();
						    }
							return;
						}
					}
				}
			}
			function URLencode(sStr) 
			{
			    return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
			}
		</script>
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