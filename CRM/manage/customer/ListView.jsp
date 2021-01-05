
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="java.text.*" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%	
	String userid = user.getUID()+"";
	int maintype = Util.getIntValue((String)request.getSession().getAttribute("CRM_MAINTYPE"),1);
	String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
	String creater = Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
	String creatertype = Util.fromScreen3(request.getParameter("creatertype"), user.getLanguage());
	String createDateFrom = Util.fromScreen3(request.getParameter("createDateFrom"), user.getLanguage());
	String createDateTo = Util.fromScreen3(request.getParameter("createDateTo"), user.getLanguage());
	String type = Util.fromScreen3(request.getParameter("type"), user.getLanguage());
	String statusid = Util.fromScreen3(request.getParameter("statusid"), user.getLanguage());
	String statusid2 = Util.fromScreen3(request.getParameter("statusid2"), user.getLanguage());
	String attention=Util.null2String(request.getParameter("attention"));
	String subcompanyId = Util.fromScreen3(request.getParameter("subcompanyId"), user.getLanguage());
	String departmentId = Util.fromScreen3(request.getParameter("deptId"), user.getLanguage());
	
	String desc = Util.fromScreen3(request.getParameter("desc"), user.getLanguage());
	String size = Util.fromScreen3(request.getParameter("size"), user.getLanguage());
	String sector = Util.fromScreen3(request.getParameter("sector"), user.getLanguage());
	String source = Util.fromScreen3(request.getParameter("source"), user.getLanguage());
	
	String province = Util.fromScreen3(request.getParameter("province"), user.getLanguage());
	String city = Util.fromScreen3(request.getParameter("city"), user.getLanguage());
	
	String nocontact = Util.fromScreen3(request.getParameter("nocontact"), user.getLanguage());
	String contact = Util.fromScreen3(request.getParameter("contact"), user.getLanguage());
	String contacttype = Util.fromScreen3(request.getParameter("contacttype"), user.getLanguage());
	String keyname = URLDecoder.decode(Util.null2String(request.getParameter("keyname")),"utf-8");
	String tagstr = URLDecoder.decode(Util.null2String(request.getParameter("tagstr")),"utf-8");
	
	String remind = Util.fromScreen3(request.getParameter("remind"), user.getLanguage());
	String isnew = Util.fromScreen3(request.getParameter("isnew"), user.getLanguage()); 
	
	String currentdate = TimeUtil.getCurrentDateString();
	
	if("0".equals(creatertype) || "-1".equals(creatertype) || "1".equals(attention)){//全部 或 非本人
		if(!creater.equals(userid)){
			userid = creater;
		}
	}
	String backfields = "t.id,t.name,t.manager,t.type,t.status,t.createdate,t.phone,t.rating,t.city,t.county,sa.id as att";
	String sqlwhere = " where (t.deleted=0 or t.deleted is null)";
	if(maintype==1){
		sqlwhere += " and t.type in (1,3,4,5)";
	}else if(maintype==2){
		sqlwhere += " and t.type in (11,12,13,14,15,16,17,18,20,21,25,19)";
	}else if(maintype==3){
		sqlwhere += " and (t.type = 26 or exists(select 1 from CRM_CustomerContacter cc where cc.customerid=t.id and cc.isperson=1))";
	}
	
	String basesql = "";
	String condition = " from CRM_CustomerInfo t ";
	if(!"0".equals(creatertype) && !"1".equals(attention)){//非全部并且非关注
		if("-1".equals(creatertype)){//非本人
			rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
			if (!rs.next()){
				String leftjointable = CrmShareBase.getTempTable(userid);
				condition = " from CRM_CustomerInfo t join " + leftjointable + " t2 on t.id = t2.relateditemid ";
			}
			sqlwhere += " and t.manager <> "+creater+" and not exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%')";
		}else{//本人
			if(!ResourceComInfo.isManager(user.getUID(),creater)){
				rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
				if (!rs.next()){
					String leftjointable = CrmShareBase.getTempTable(userid);
					condition = " from CRM_CustomerInfo t join " + leftjointable + " t2 on t.id = t2.relateditemid ";
				}
			}
			int subtype = Util.getIntValue(request.getParameter("subtype"),0);
			if(subtype==1){
				sqlwhere += " and t.manager ="+creater;
			}else if(subtype==2){
				sqlwhere += " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%')";
			}else{
				sqlwhere += " and (t.manager ="+creater+" or exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.managerstr like '%,"+creater+",%'))";
			}
		}
	}else{//全部或关注
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
		if (!rs.next()){
			String leftjointable = CrmShareBase.getTempTable(userid);
			condition = " from CRM_CustomerInfo t join " + leftjointable + " t2 on t.id = t2.relateditemid ";
		}
	}
	basesql = backfields + condition +" left join CRM_Common_Attention sa on t.id=sa.objid and sa.operatetype=1 and sa.operator="+user.getUID();
	String statsql = condition;
	String statsql2 = condition + " join CRM_CustomerContacter cc on t.id=cc.customerid and cc.isperson=1";
	
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
						namewhere1 += " t.name like '%" + ands[i] + "%'";
						namewhere2 += " customerIds.name like '%" + ands[i] + "%'";
					}else{
						namewhere1 += " and  t.name like '%" + ands[i] + "%'";
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
						namewhere1 += " t.name like '%" + ors[i] + "%'";
						namewhere2 += " customerIds.name like '%" + ors[i] + "%'";
					}else{
						namewhere1 += " or  t.name like '%" + ors[i] + "%'";
						namewhere2 += " or  customerIds.name like '%" + ors[i] + "%'";
					}
				}
				namewhere1 += " ) ";
				namewhere2 += " ) ";
			}
		}
		sqlwhere += " and ("+namewhere1+" or exists (select 1 from CRM_CustomerTag ct where ct.customerid=t.id and ct.tag like '%"+keyname+"%'))";
	}
	
	if(!"".equals(subcompanyId)){
		String subCompanyIds = subcompanyId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subcompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		subCompanyIds = "("+subCompanyIds+")";
		sqlwhere += " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.subcompanyid1 in "+subCompanyIds+")";
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
		sqlwhere += " and exists(select 1 from HrmResource hrm where hrm.id=t.manager and hrm.departmentid in "+departmentIds+")";
		//sqlwhere += " and t.departmentId = "+departmentId;
	}
	if(!"".equals(subject)){
		sqlwhere += " and t.name like '%"+subject+"%'";
	}
	
	if(!"".equals(type)){
		sqlwhere += " and t.type ="+type;
	}
	if(!"".equals(statusid)){
		sqlwhere += " and t.status ="+statusid;
	}
	if(!"".equals(statusid2)){
		sqlwhere += " and t.status ="+statusid2;
	}
	if(!"".equals(desc)){
		sqlwhere += " and t.description ="+desc;
	}
	if(!"".equals(size)){
		sqlwhere += " and t.size_n ="+size;
	}
	if(!"".equals(source)){
		sqlwhere += " and t.source ="+source;
	}
	if(!"".equals(sector)){
		sqlwhere += " and t.sector ="+sector;
	}
	if(!"".equals(province)){
		sqlwhere += " and t.province ="+province;
	}
	if(!"".equals(city)){
		sqlwhere += " and t.city ="+city;
	}
	if(!"".equals(createDateFrom)){
		sqlwhere += " and t.createdate >='"+createDateFrom+"'";
	}
	if(!"".equals(createDateTo)){
		sqlwhere += " and t.createdate <='"+createDateTo+"'";
	}
	
	if("1".equals(attention)){
		sqlwhere += " and exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=1 and t2.operator="+creater+")";
	}
	if("0".equals(attention)){
		sqlwhere += " and not exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=1 and t2.operator="+creater+")";
	}
	if(!"".equals(nocontact)){
		sqlwhere += " and t.status in (1,2,3,12)";
		sqlwhere += " and not exists (select 1 from WorkPlan w where w.type_n=3 and w.crmid not like '%,%' and w.crmid=t.id and w.begindate>='"+nocontact+"'";
		if(contacttype.equals("1")){
			sqlwhere += " and w.createrid=t.manager ";
		}
		sqlwhere += ") and t.createdate<'"+nocontact+"'";
	}
	if(!"".equals(contact)){
		sqlwhere += " and t.status in (1,2,3,12)";
		sqlwhere += " and exists (select 1 from WorkPlan w where w.type_n=3 and w.crmid not like '%,%' and w.crmid=t.id and w.begindate>='"+contact+"'";
		if(contacttype.equals("1")){
			sqlwhere += " and w.createrid=t.manager ";
		}
		sqlwhere += ")";
	}
	if("1".equals(remind)){
		sqlwhere += " and exists (select 1 from CRM_Common_Remind r where r.operatetype=1 and r.objid=t.id)";
	}
	if("1".equals(isnew)){
		sqlwhere += " and exists (select 1 from CRM_ViewLog2 v where v.customerid=t.id)";
	}
	if(!"".equals(tagstr)){
		sqlwhere += " and exists (select 1 from CRM_CustomerTag ct where ct.customerid=t.id and ct.tag='"+tagstr+"')";
	}
	
	//System.out.println(basesql+sqlwhere);
	int _pagesize = 20;
	int _total = 0;//总数
	int _total2 = 0;//人脉总数
	rs.executeSql("select count(distinct t.id) "+statsql+sqlwhere);
	if(rs.next()){
		_total = rs.getInt(1);
	}
	if(maintype==3){
		rs.executeSql("select count(distinct cc.id) "+statsql2+sqlwhere);
		if(rs.next()) _total2 = rs.getInt(1);
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
				<colgroup><col width="23"/><col width="*"/><col width="90px"/><%if(maintype==1){ %><col width="65px"/><%}else{ %><col width="75px"/><%} %><col width="60px"/><col width="15px"/><col width="1px"/><col width="45px"/></colgroup>
				<%if(_total==0){ %>
				<tr class=""><td class='td_move'></td><td colspan="7" style="padding-left: 4px;font-style: italic">暂无相关数据</td></tr>
				<%}else{ %>
				<jsp:include page="Operation.jsp">
					<jsp:param value="get_list_data" name="operation"/>
					<jsp:param value="1" name="currentpage"/>
					<jsp:param value="<%=_pagesize %>" name="pagesize"/>
					<jsp:param value="<%=_total %>" name="total"/>
				</jsp:include>
				<%} %>
			</table>
			<div id="listmore" class="listmore" style="<%if(_pagesize>=_total){ %>display: none;<%} %>" onclick="getListData(this)" _datalist="datalist" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql=""  title="显示更多数据">更多</div>	
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
				<%if(maintype==3){%>
					$("#stat").html("总计销售伙伴 <%=_total%> 个,人脉 <%=_total2%> 个");
				<%}else{%>
					$("#stat").html("总计 <%=_total%> 个");
				<%}%>
			});

			//读取列表更多记录
			function getListData(obj){
				var _datalist = $(obj).attr("_datalist");
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				var _querysql = $(obj).attr("_querysql");
				$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_list_data","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"querysql":filter(encodeURI(_querysql))}, 
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