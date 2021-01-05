
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	int subtype = Util.getIntValue(request.getParameter("subtype"),0);//是否包含下属类型   1为本人  2为下属  否则为本人及下属
	String ym = Util.null2String(request.getParameter("ym"));
	String userid = Util.null2String(request.getParameter("userid"));
	int reporttype = Util.getIntValue(request.getParameter("reporttype"),1);
	int viewtype = Util.getIntValue(request.getParameter("viewtype"),1);
	int detailtype = Util.getIntValue(request.getParameter("detailtype"),1);
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	int condtype = Util.getIntValue(request.getParameter("condtype"),-1);
	if(userid.equals("") || !ResourceComInfo.isManager(user.getUID(),userid)){
		userid = user.getUID()+"";
	}
	
	String syear = Util.null2String(request.getParameter("syear"));
	String smonth = Util.null2String(request.getParameter("smonth"));
	String sdate1 = Util.null2String(request.getParameter("sdate1"));
	String sdate2 = Util.null2String(request.getParameter("sdate2"));
	String datewhere = "";
	if(!syear.equals("")){
		if(smonth.equals("")){
			datewhere += " and t.createdate like '"+syear+"%'";
		}else{
			List mlist = Util.TokenizerString(smonth,",");
			for(int i=0;i<mlist.size();i++){
				datewhere += " "+((i==0)?"":"or")+" t.createdate like '"+syear+"-"+mlist.get(i)+"%'";
			}
			if(!datewhere.equals("")) datewhere = " and ("+datewhere+")";
		}
	}else{
		if(!sdate1.equals("")) datewhere += " and t.createdate>='"+sdate1+"'";
		if(!sdate2.equals("")) datewhere += " and t.createdate<='"+sdate2+"'";
	}
	
	String operation = "";
	String basesql = "";
	String sqlfrom = "";
	String sqlwhere = "";
	if(reporttype==1){
		int selllat = Util.getIntValue(request.getParameter("selllat"),1);
		String latfield = "t.createdate";
		if(selllat==2) latfield = "t.predate";
		operation = "get_sellchance";
		basesql = " t.id,t.customerid,t.creater,t.subject,t.sellstatusid,t.endtatusid,t.predate,t.preyield,t.createdate,t.createtime,t.selltype ";
		sqlfrom = " from CRM_SellChance t,HrmResource h";
		sqlwhere = " where t.creater=h.id and "+latfield+" like '"+ym+"%'";
		if(detailtype==3){
			sqlwhere += " and t.endtatusid=1";
		}else{
			int sellstatus = Util.getIntValue(request.getParameter("sellstatus"),-1);
			if(sellstatus!=-1) sqlwhere += " and t.endtatusid="+sellstatus;
		}
		//增加联系日期的条件
		int sellcontact = Util.getIntValue(request.getParameter("sellcontact"),-1);
		String contactdate = Util.null2String(request.getParameter("contactdate"));
		if(sellcontact!=-1){
			sqlwhere += " and "+((sellcontact==1)?"not":"")
				+" exists(select 1 from WorkPlan w where convert(varchar,t.customerid)=convert(varchar,w.crmid)"
				+" and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))"
				+" and w.type_n='3' and w.begindate is not null and w.begindate<>''";
			if(!contactdate.equals(""))
				sqlwhere += " and w.begindate<='"+TimeUtil.getCurrentDateString()+"' and w.begindate>='"+contactdate+"'";
			sqlwhere += ")";
		}
	}else if(reporttype==2 || reporttype==11){
		operation = "get_customer";
		basesql = " t.id,t.manager,t.name,t.createdate";
		sqlfrom = " from CRM_CustomerInfo t,HrmResource h";
		sqlwhere = " where t.manager=h.id and t.status<>13 and (t.deleted=0 or deleted is null)";
		if(detailtype==2 || detailtype==3){
			sqlwhere += " and exists(select 1 from workplan w where t.id=convert(varchar,w.crmid)  and w.type_n='3' and w.begindate like '"+ym+"%')";//and t.manager=w.createrid
		}else if(detailtype==1){
			sqlwhere += " and t.createdate like '"+ym+"%'";
		}else if(detailtype==4){//人脉
			operation = "get_contacter";
			basesql = " cc.id,cc.manager,cc.firstname,cc.customerid";
			sqlfrom = " from CRM_CustomerContacter cc,CRM_CustomerInfo t,HrmResource h";
			sqlwhere = " where cc.customerid=t.id and t.manager=h.id and (t.deleted=0 or deleted is null)";
			sqlwhere += " and t.type=26 and cc.createdate like '"+ym+"%'";
		}
		if(reporttype==2){
			String crmtype = Util.null2String(request.getParameter("crmtype"));
			String crmstatus = Util.null2String(request.getParameter("crmstatus"));
			if(!crmtype.equals("")) sqlwhere += " and t.type in("+crmtype+")";
			if(!crmstatus.equals("")) sqlwhere += " and t.status in("+crmstatus+")";
		}else{
			if(detailtype!=4) sqlwhere += " and t.type=26";
		}
		
	}else if(reporttype==3 || reporttype==4 || reporttype==10){
		detailtype = viewtype;
		operation = "get_customer";
		basesql = " t.id,t.manager,t.name,t.createdate";
		sqlfrom = " from CRM_CustomerInfo t,HrmResource h";
		sqlwhere = " where t.manager=h.id and t.status<>13 and (t.deleted=0 or deleted is null)"+datewhere;
		if(reporttype==4){
			sqlwhere += " and t.type in (11,12,13,14,15,16,17,18,20,21,25,19)";
		}else if(reporttype==10){
			sqlwhere += " and t.type in (1,3,4,5)";
		}
		if(condtype!=-1){
			if(detailtype==1){//类型
				sqlwhere += " and t.type="+condtype;
			}else if(detailtype==2){//状态
				sqlwhere += " and t.status="+condtype;
			}else if(detailtype==3){//获取方式
				sqlwhere += " and t.source="+condtype;
			}else if(detailtype==4 || detailtype==5){//联系
				int[] days = {-7,-14,-30,-60,-90,-180};
				sqlwhere += " and "+((detailtype==5)?"not":"")+" exists(select 1 from WorkPlan w where convert(varchar,t.id)=convert(varchar,w.crmid)  and w.type_n='3' and w.begindate is not null and w.begindate<>''";//and w.createrid=t.manager
				sqlwhere += " and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[condtype])+"')";
			}
		}
	}else if(reporttype==5){
		detailtype = viewtype;
		operation = "get_customer";
		basesql = " t.id,t.manager,t.name,t.createdate";
		sqlfrom = " from CRM_CustomerInfo t,HrmResource h";
		sqlwhere = " where t.manager=h.id and t.status<>13 and (t.deleted=0 or deleted is null)"+datewhere;
		sqlwhere += " and t.type=26";
		if(condtype!=-1){
			if(detailtype==1){
				if(condtype==2){
					operation = "get_contacter";
					basesql = " cc.id,cc.manager,cc.firstname,cc.customerid";
					sqlfrom = " from CRM_CustomerContacter cc,CRM_CustomerInfo t,HrmResource h";
					sqlwhere = " where cc.customerid=t.id and t.manager=h.id and (t.deleted=0 or deleted is null)"+datewhere;
					sqlwhere += " and t.type=26";
					if(!datewhere.equals("")){
						sqlwhere += datewhere.replaceAll("t.createdate","cc.createdate");
						/**
						sqlwhere += " and exists (select 1 from CRM_Log t1,CRM_Modify t2"
							+ "  where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
							+ "  and t1.logtype='nc' and t1.customerid=t.id and t2.type=cc.id"
							+ datewhere.replaceAll("t.createdate","t1.submitdate")+")"; 
						
						sqlwhere += " and (exists (select 1 from CRM_Log t1,CRM_Modify t2"
							+ "  where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
							+ "  and t1.logtype='nc' and t1.customerid=t.id and t2.type=cc.id"
							+ datewhere.replaceAll("t.createdate","t1.submitdate")+")"
							+ " or (1=1 "+datewhere+"))"; 
						*/
					}
				}
			}else if(detailtype==3 || detailtype==2){//联系
				int[] days = {-7,-14,-30,-60,-90,-180};
				sqlwhere += " and "+((detailtype==2)?"not":"")+" exists(select 1 from WorkPlan w where convert(varchar,t.id)=convert(varchar,w.crmid)  and w.type_n='3' and w.begindate is not null and w.begindate<>''";//and w.createrid=t.manager
				sqlwhere += " and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[condtype])+"')";
			}
		}
	}else if(reporttype==6){
		detailtype = viewtype;
		operation = "get_sellchance";
		basesql = " t.id,t.customerid,t.creater,t.subject,t.sellstatusid,t.endtatusid,t.predate,t.preyield,t.createdate,t.createtime,t.selltype ";
		sqlfrom = " from CRM_SellChance t,HrmResource h";
		sqlwhere = " where t.creater=h.id"+datewhere;
		if(condtype!=-1){
			if(detailtype==1){//阶段
				sqlwhere += " and t.selltype=1 and t.sellstatusid="+condtype;
			}else if(detailtype==2){//状态
				sqlwhere += " and t.endtatusid="+condtype;
			}else if(detailtype==3){//预期收益
				int[][] days = {{0,20},{20,50},{50,100},{100,1000}};
				sqlwhere += " and t.preyield>="+days[condtype][0]*10000+" and t.preyield<"+days[condtype][1]*10000;
			}else if(detailtype==4 || detailtype==5){//联系
				int[] days = {-7,-14,-30,-60,-90,-180};
				if(detailtype==5) sqlwhere += " and t.endtatusid=0";
				sqlwhere += " and "+((detailtype==5)?"not":"")+" exists(select 1 from WorkPlan w where convert(varchar,t.customerid)=convert(varchar,w.crmid)"
					+" and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))"
					+" and w.type_n='3' and w.begindate is not null and w.begindate<>''";// and w.createrid=t.creater
				sqlwhere += " and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[condtype])+"')";
			}else if(detailtype==6){//建立
				int[] days = {-7,-14,-30,-60,-90,-180};
				sqlwhere += " and t.createdate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[condtype])+"'";
			}
		}
	}
	
	sqlwhere += " and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)";
	
	if(!departmentid.equals("")){
		sqlwhere += " and h.departmentid="+departmentid;
	}else{
		if(subtype==1){
			sqlwhere += " and h.id ="+userid;
		}else if(subtype==2){
			sqlwhere += " and h.managerstr like '%,"+userid+",%'";
		}else{
			sqlwhere += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
		}	
	}
	
	
	//System.out.println("detailtype:"+detailtype);
	int _pagesize = 20;
	int _total = 0;//总数
	rs.executeSql("select count(t.id) "+sqlfrom+sqlwhere);
	//System.out.println("select count(t.id) "+sqlfrom+sqlwhere);
	if(rs.next()){
		_total = rs.getInt(1);
	}
	
	request.getSession().setAttribute("CRM_LIST_SQL",basesql+sqlfrom+sqlwhere);
	
%>
<style type="text/css">
	
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div id="contacttitle" style="width: 100%;height: 30px;position: relative;overflow:hidden;
	background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: auto;z-index: 2;">
			<div class="detailtitle" title="">
				<%if(reporttype==1 || reporttype==6){ 
					String totalmoney = "0.00";
					rs.executeSql("select sum(t.preyield) "+sqlfrom+sqlwhere);
					if(rs.next()){
						totalmoney = Util.null2String(rs.getString(1));
					}
					if(!totalmoney.equals("")){
						totalmoney = comma(totalmoney,2);
					}else{
						totalmoney = "0.00";
					}	
				%>
					总计 <%=_total%> 个商机，预期收益 <%=totalmoney%>
				<%}else if(reporttype==4){ %>
					总计 <%=_total%> 个渠道伙伴
				<%}else if(reporttype==5){%>
					总计 <%=_total%> 个<%=(detailtype==1&&condtype==2)?"销售人脉":"销售伙伴" %>
				<%}else if(reporttype==11){%>
					总计 <%=_total%> 个<%=(detailtype==4)?"销售人脉":"销售伙伴" %>
				<%}else{ %>
					总计 <%=_total%> 个客户
				<%} %>
			</div>
		</div>
	</div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:30px;left:0px;bottom:0px;border-top:1px #E8E8E8 solid;background: #F8F8F8;" class="scroll1" align="center">
  		<div style="width: auto;height: 99%;position: relative;">
  		<table id="datalist" class="detaillist" style="width: 100%;margin: 0px auto;text-align: left;margin-bottom: 3px;" cellpadding="0" cellspacing="0" border="0">
				<%if(_total==0){ %>
				<tr id="noinfo">
					<td class="data fbdata1">
						<div class="feedbackshow">
							<div class="feedbackinfo" style="font-style: italic;color:#999999">
								暂无相关数据
							</div>
						</div>
					</td>
				</tr>
				<%}else{ %>
				<jsp:include page="Operation.jsp">
					<jsp:param value="<%=operation %>" name="operation"/>
					<jsp:param value="1" name="currentpage"/>
					<jsp:param value="<%=_pagesize %>" name="pagesize"/>
					<jsp:param value="<%=_total %>" name="total"/>
				</jsp:include>
				<%} %>
		</table>
		<div id="listmore" class="listmore" style="<%if(_pagesize>=_total){ %>display: none;<%} %>" onclick="getListData(this)" _datalist="datalist" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" title="显示更多数据">更多</div>	
		</div>
	</div>
</div>
<script language=javascript defer>
	
</script>
<script language="javascript">
	var tempval = "";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var begindate = "<%=TimeUtil.getCurrentDateString()%>";
	$(document).ready(function(){

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
		    data:{"operation":"<%=operation %>","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"querysql":filter(encodeURI(_querysql))}, 
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

</script>
<%!
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
