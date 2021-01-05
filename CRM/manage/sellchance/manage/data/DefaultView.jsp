
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%
	String userid = user.getUID()+"";

	String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
	String creater = Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
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
	String keyname = Util.fromScreen3(request.getParameter("keyname"), user.getLanguage());
	String isself = Util.fromScreen3(request.getParameter("isself"), user.getLanguage());
	
	String mtitle = Util.fromScreen3(request.getParameter("mtitle"), user.getLanguage());
	
	String endtatusid = "0";
	if("-1".equals(sellstatusid)) endtatusid = "1";
	if("-2".equals(sellstatusid)) endtatusid = "2";

	String condition = "";
	//找到用户能看到的所有客户
	//如果属于总部级的CRM管理员角色，则能查看到所有客户。
	rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
	if (rs.next()) {
		condition = "(select id,name from CRM_CustomerInfo where (deleted=0 or deleted is null)) as customerIds";
	} else {
		String leftjointable = CrmShareBase.getTempTable(userid);
		condition = "(select t1.id,t1.name "
			+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
			+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
	}
	String sql = " wp.id,wp.description,wp.begindate,wp.begintime,wp.createrid,wp.docid,wp.requestid,wp.projectid,wp.createdate,wp.createtime,t.id as sellchanceid,t.subject,t.customerid"
			+" from WorkPlan wp,CRM_SellChance t,"+condition
			+" where wp.crmid=convert(varchar,t.customerid) and t.customerid = customerIds.id "
			+" and wp.type_n=3";
	String statsql = " from WorkPlan wp,CRM_SellChance t,"+condition+" where wp.crmid=convert(varchar,t.customerid) and t.customerid = customerIds.id "
			+" and wp.type_n=3";
	String sqlwhere = "";	
	
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
	
	if("1".equals(isself)){ 
		sqlwhere += " and wp.createrid = "+userid;
	}
	if("0".equals(isself)){ 
		sqlwhere += " and wp.createrid <> "+userid;
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
			if(!"".equals(creater)){
				if(creater.indexOf("-")>-1) sqlwhere += " and t.creater <> "+creater.substring(1)+"";
				else sqlwhere += " and t.creater ="+creater+"";
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
			if(!"".equals(sellstatusid) && !"-1".equals(sellstatusid) && !"-2".equals(sellstatusid)){
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
				sqlwhere += " and exists (select 1 from CRM_SellChance_Attention t2 where t.id=t2.sellchanceId and t2.userId="+user.getUID()+")";
			}
			if("0".equals(attention)){
				sqlwhere += " and not exists (select 1 from CRM_SellChance_Attention t2 where t.id=t2.sellchanceId and t2.userId="+user.getUID()+")";
			}
			if(!"".equals(nocontact)){
				sqlwhere += " and not exists (select 1 from WorkPlan w where w.type_n=3 and w.crmid=convert(varchar,t.customerid) and w.begindate>='"+nocontact+"')"
						+" and t.createdate<'"+nocontact+"'";
			}
			int _pagesize = 10;
			int _total = 0;//总数
			rs.executeSql("select count(wp.id) "+statsql+sqlwhere);
			if(rs.next()){
				_total = rs.getInt(1);
			}
	//System.out.println(sql+sqlwhere+orderby);
%>
<style type="text/css">
	
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div style="width: 100%;height: 30px;position: relative;
		background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div style="margin-left: 5px;margin-top: 3px;width: auto;text-align: left;font-family: '微软雅黑 ' !important;float: left;">
				<font title="所有相关联系反馈" style="font-family: '微软雅黑 ';cursor:pointer;margin-left:10px;margin-right:3px;color:#B7B7B7;font-weight: bold;<%if(isself.equals("")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','')">全部</font>|
				<font title="本人创建的联系反馈" style="font-family: '微软雅黑 ';cursor:pointer;margin-left:3px;margin-right:3px;color:#B7B7B7;font-weight: bold;<%if(isself.equals("1")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','1')">本人</font>|
				<font title="非本人创建的联系反馈" style="font-family: '微软雅黑 ';cursor:pointer;margin-left:3px;margin-right:3px;color:#B7B7B7;font-weight: bold;<%if(isself.equals("0")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','0')">非本人</font>
			</div>
			<div style="margin-right: 10px;margin-top: 3px;width: auto;text-align: left;font-family: '微软雅黑 ' !important;float: right;color: #939393;">
				<%=mtitle %>联系反馈
			</div>
		</div>
	</div>
	<div id="" style="width:100%;height: auto;position:absolute;top:30px;left:0px;bottom:0px;border-top:1px #E8E8E8 solid;
		line-height: 40px;font-size: 14px;" class="scroll1" align="center">
		<table id="feedbacktable" class="datatable" style="width: 100%;margin: 0px auto;text-align: left;" cellpadding="0" cellspacing="0" border="0">
				
				<%if(_total==0){ %>
				<tr>
					<td class="data fbdata1">
						<div class="feedbackshow">
							<div class="feedbackinfo" style="font-style: italic;color:#999999">
								暂无相关反馈信息！
							</div>
						</div>
					</td>
				</tr>
				<%} %>
		</table>
		<div id="listmore2" class="datamore" style="display: none;" onclick="getListContact(this)" _datalist="datalist" _currentpage="0" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="<%=sql+sqlwhere %>" title="显示更多数据">更多</div>	
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("#feedbacktable").find(".data").live("mouseover",function(){
			$(this).css("background-color","#F7FBFF");
		}).live("mouseout",function(){
			$(this).css("background-color","#fff");
		});
		<%if(_total>0){ %>$("#listmore2").click();<%}%>
	});
	//读取列表更多记录
	function getListContact(obj){
		var _datalist = $(obj).attr("_datalist");
		var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
		var _pagesize = $(obj).attr("_pagesize");
		var _total = $(obj).attr("_total");
		var _querysql = $(obj).attr("_querysql");
		$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
		$.ajax({
			type: "post",
		    url: "Operation.jsp",
		    data:{"operation":"get_list_contact","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"querysql":filter(encodeURI(_querysql))}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	var records = $.trim(data.responseText);
		    	$("#feedbacktable").append(records);
		    	if(_currentpage*_pagesize>=_total){
		    		$(obj).hide();
			    }else{
			    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
				}
			}
	    });
	}
</script>
