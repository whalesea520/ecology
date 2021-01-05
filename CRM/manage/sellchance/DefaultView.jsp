
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
	String contacttype = Util.fromScreen3(request.getParameter("contacttype"), user.getLanguage());
	String keyname = Util.fromScreen3(request.getParameter("keyname"), user.getLanguage());
	String isself = Util.fromScreen3(request.getParameter("isself"), user.getLanguage());
	
	String remind = Util.fromScreen3(request.getParameter("remind"), user.getLanguage());
	
	String mtitle = Util.fromScreen3(request.getParameter("mtitle"), user.getLanguage());
	
	String endtatusid = "0";
	if("-1".equals(sellstatusid)) endtatusid = "1";
	if("-2".equals(sellstatusid)) endtatusid = "2";
	if("-3".equals(sellstatusid)) endtatusid = "";
	if("-4".equals(sellstatusid)) endtatusid = "3";
	
	boolean iswarn = false;
	if(creatertype.equals(userid) || ("0".equals(creatertype) && !keyname.equals(""))) iswarn = true;
	/**
	String minworkplanid = "";//查询比较的日程id，提高查询性能
	if(isself.equals("2")){//查询风险预警
		rs.executeSql("SELECT TOP 1 id FROM WorkPlan WHERE begindate='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-31)+"' ORDER BY wp.id DESC");
		if(rs.next()) minworkplanid = Util.getIntValue(rs.getString(1),0)+"";
	}*/

	if("0".equals(creatertype) || "-1".equals(creatertype) || "1".equals(attention)){//全部 或 非本人
		if(!creater.equals(userid)){
			userid = creater;
		}
	}
	String condition = "";
	boolean crmadmin = false; 
	//找到用户能看到的所有客户
	//如果属于总部级的CRM管理员角色，则能查看到所有客户。
	rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
	if (rs.next()) {
		condition = "CRM_CustomerInfo as c";
		crmadmin = true;
	} else {
		String leftjointable = CrmShareBase.getTempTable(userid);
		condition = "(select distinct t1.id,t1.name "
			+ " from CRM_CustomerInfo t1," + leftjointable + " t2"
			+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as c";
	}
	String fromsql = " from (select p.id,p.description,p.begindate,p.begintime,p.createrid,p.docid,p.requestid,p.projectid,p.createdate,p.createtime,p.relateddoc,p.crmid,p.sellchanceid,p.contacterid "
			+"from WorkPlan p where p.createrType = '1' and p.type_n = 3) w,"+condition+",CRM_SellChance t";
	String backfield = " w.id,w.description,w.begindate,w.begintime,w.createrid,w.docid,w.requestid,w.projectid,w.createdate,w.createtime,w.relateddoc,w.crmid as customerid,w.sellchanceid,w.contacterid,t.id as mainsellchance,t.subject";

	String sqlwhere = " where t.customerid=c.id and w.crmid=convert(varchar,c.id) and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))";	
	String hrmwhere1 = "";
	String hrmwhere2 = "";
	if(!"0".equals(creatertype) && !"1".equals(attention)){//非全部并且非关注
		fromsql += ",hrmresource hrm";
		sqlwhere += " and hrm.id=t.creater";
		if("-1".equals(creatertype)){//非本人
			hrmwhere1 = " and t.creater > "+creater+" and hrm.managerstr not like '%,"+creater+",%'";
			hrmwhere2 = " and t.creater < "+creater+" and hrm.managerstr not like '%,"+creater+",%'";
		}else{
			hrmwhere1 += " and t.creater ="+creater;
			hrmwhere2 += " and hrm.managerstr like '%,"+creater+",%'";
		}
	}else{
		hrmwhere1 = " and t.creater>0";
		hrmwhere2 = " and t.creater<0";
	}
	
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
						namewhere2 += " c.name like '%" + ands[i] + "%'";
					}else{
						namewhere1 += " and  t.subject like '%" + ands[i] + "%'";
						namewhere2 += " and  c.name like '%" + ands[i] + "%'";
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
						namewhere2 += " c.name like '%" + ors[i] + "%'";
					}else{
						namewhere1 += " or  t.subject like '%" + ors[i] + "%'";
						namewhere2 += " or  c.name like '%" + ors[i] + "%'";
					}
				}
				namewhere1 += " ) ";
				namewhere2 += " ) ";
			}
		}
		sqlwhere += " and ("+namewhere1+" or "+namewhere2+")";
	}
	
	if("1".equals(isself)){ 
		sqlwhere += " and w.createrid = t.creater";
	}
	if("0".equals(isself)){ 
		sqlwhere += " and w.createrid <> t.creater";
	}
			
	if(!"".equals(sellstatusid) && !"-1".equals(sellstatusid) && !"-2".equals(sellstatusid) && !"-3".equals(sellstatusid) && !"-4".equals(sellstatusid)){
		sqlwhere += " and t.sellstatusid ="+sellstatusid;
	}
	if(!"".equals(sellstatusid2)){
		sqlwhere += " and t.sellstatusid ="+sellstatusid2;
	}
	if(!"".equals(endtatusid)){
		sqlwhere += " and t.endtatusid ="+endtatusid;
	}
	if("1".equals(attention)){
		sqlwhere += " and exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=2 and t2.operator="+creater+")";
	}
	if("0".equals(attention)){
		sqlwhere += " and not exists (select 1 from CRM_Common_Attention t2 where t.id=t2.objid and t2.operatetype=2 and t2.operator="+creater+")";
	}
	if(!"".equals(nocontact)){
		sqlwhere += " and not exists (select 1 from WorkPlan t3 where t3.type_n=3 and t3.createrType = '1' and t3.crmid=convert(varchar,c.id) and (t3.sellchanceid=t.id or (t3.sellchanceid is null and t3.contacterid is null)) and t3.begindate>='"+nocontact+"'";
		if(contacttype.equals("1")){
			sqlwhere += " and t3.createrid=t.creater ";
		}
		sqlwhere += ") and t.createdate<'"+nocontact+"'";
	}
	if("1".equals(remind)){
		sqlwhere += " and exists (select 1 from CRM_Common_Remind r where r.operatetype=2 and r.objid=t.id)";
	}
	if(crmadmin) sqlwhere += " and (c.deleted=0 or c.deleted is null)";

	String querysql = " from (" 
		+"select "+backfield+fromsql+sqlwhere+hrmwhere1
		+" union all "
		+"select "+backfield+fromsql+sqlwhere+hrmwhere2
		+") as wp";
	
	String keytype = Util.fromScreen3(request.getParameter("keytype"), user.getLanguage());
	String keyword = Util.fromScreen3(request.getParameter("keyword"), user.getLanguage());
	
	List keynames1 = new ArrayList();
	List keynames2 = new ArrayList();
	List keynames3 = new ArrayList();
	List keynames4 = new ArrayList();
	if(isself.equals("2")){
		String _ktype = "";
		String _kname = "";
		rs.executeSql("select id,keytype,keyname from CRM_WarnConfig where (keytype in (1,2,3) or (keytype=0 and userid="+user.getUID()+"))");
		while(rs.next()){
			_ktype = Util.null2String(rs.getString("keytype"));
			_kname = Util.null2String(rs.getString("keyname"));
			if(_ktype.equals("1")){
				keynames1.add(_kname);
			}else if(_ktype.equals("2")){
				keynames2.add(_kname);
			}else if(_ktype.equals("3")){
				keynames3.add(_kname);
			}else if(_ktype.equals("0")){
				String[] ks = {rs.getString("id"),_kname};
				keynames4.add(ks);
			}
		}
		
		if(!keyword.equals("")){
			querysql += " where wp.description like '%"+keyword+"%'";
		}else{
			querysql += " where EXISTS(SELECT 1 FROM CRM_WarnConfig wc WHERE wp.description LIKE '%'+wc.keyname+'%'";
			if(keytype.equals("")){
				querysql += " and (wc.keytype in (1,2,3) or (wc.keytype=0 and wc.userid="+user.getUID()+"))";
			}else if(keytype.equals("0")){
				querysql += " and (wc.keytype=0 and wc.userid="+user.getUID()+")";
			}else{
				querysql += " and wc.keytype="+keytype;
			}
			
			querysql += ")";
		}
		
		request.getSession().setAttribute("CRM_WARNKEY1",keynames1);
		request.getSession().setAttribute("CRM_WARNKEY2",keynames2);
		request.getSession().setAttribute("CRM_WARNKEY3",keynames3);
		request.getSession().setAttribute("CRM_WARNKEY4",keynames4);
	}
	
	
	int _pagesize = 10;
	int _total = 0;//总数
			
	//System.out.println("select count(wp.id) "+querysql);
	if(!isself.equals("2") || keynames1.size()>0 || keynames2.size()>0 || keynames3.size()>0 || keynames4.size()>0){
		rs.executeSql("select count(wp.id) "+querysql);
		if(rs.next()){
			_total = rs.getInt(1);
		}
	}
	
	request.getSession().setAttribute("CRM_CONTACT_SQL"," wp.*"+querysql);
%>
<style type="text/css">
	
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div id="righttitle" style="width: 100%;height: 30px;position: relative;
		background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div style="margin-left: 5px;margin-top: 3px;width: auto;text-align: left;font-family: 微软雅黑  !important;float: left;">
				<font title="所有人创建的联系反馈" style="font-family: 微软雅黑 ;cursor:pointer;margin-left:10px;margin-right:3px;color:#B7B7B7;font-weight: bold;<%if(isself.equals("")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','')">全部反馈</font>|
				<font title="客户经理创建的联系反馈" style="font-family: 微软雅黑 ;cursor:pointer;margin-left:3px;margin-right:3px;color:#B7B7B7;font-weight: bold;<%if(isself.equals("1")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','1')">本人反馈</font>|
				<font title="非客户经理创建的联系反馈" style="font-family: 微软雅黑 ;cursor:pointer;margin-left:3px;margin-right:3px;color:#B7B7B7;font-weight: bold;<%if(isself.equals("0")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','0')">他人指导
				</font><%if(iswarn){ %>|
				<font title="联系记录风险预警" style="font-family: 微软雅黑  !important;cursor:pointer;margin-left:3px;margin-right:3px;color:#B7B7B7;font-weight: bold;<%if(isself.equals("2")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','2')">风险预警</font>
				<%} %>
			</div>
			<div style="margin-right: 10px;margin-top: 3px;width: auto;text-align: left;font-family: 微软雅黑  !important;float: right;color: #939393;">
				<%=mtitle %>联系反馈
			</div>
		</div>
		<%if(isself.equals("2")){ %>
		<div id="warncontent" style="position: absolute;top: 26px;left:0px;height: auto;width: 100%;border-top: 1px #C2C2C2 dashed;">
			<div style="line-height: 22px;margin-left: 5px;">
				<font style="font-family: 微软雅黑  !important;cursor:pointer;margin-left:10px;margin-right:8px;color:#B7B7B7;font-weight: bold;<%if(keytype.equals("1")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','2',1)">对手类</font>
				<font style="font-family: 微软雅黑  !important;cursor:pointer;margin-left:10px;margin-right:8px;color:#B7B7B7;font-weight: bold;<%if(keytype.equals("2")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','2',2)">动作类</font>
				<font style="font-family: 微软雅黑  !important;cursor:pointer;margin-left:10px;margin-right:8px;color:#B7B7B7;font-weight: bold;<%if(keytype.equals("3")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','2',3)">时间类</font>
				<font style="font-family: 微软雅黑  !important;cursor:pointer;margin-left:10px;margin-right:8px;color:#B7B7B7;font-weight: bold;<%if(keytype.equals("0")){ %>color:#4F4F4F;<%} %>" onclick="loadDefault('<%=mtitle %>','2',0)">自定义</font>
			</div>
			<%if(keytype.equals("0") && keynames4.size()<16){ %>
			<div id="tagpanel_1" class="tagpanel">
				<div style="width: 80px;height: 18px;background: #fff;float:left;">
					<input type="text" id="addtag_1" _index="1" style="width: 100%;border: 0px;height: 18px;line-height: 18px;margin: 0px;padding: 0px;color: #5B5B5B;font-family: 微软雅黑  !important;"/>
				</div>
				<div id="addtagbtn_1" class="addbtn" onclick="doSaveTag(1)" title="添加">+</div>
			</div>
			<div id="tagfloat_1" class="tagfloat"></div>
			<%} %>
			<div style="width:auto;height:auto;line-height: 20px;color: #828282;font-family: 微软雅黑  !important;font-size:11px !important;
				margin-left: 15px;">
				
				<%if(keytype.equals("1")){ %>
				<div class="keytitle">关键词：</div>
				<%for(int i=0;i<keynames1.size();i++){%>
					<div class="keyitem <%if(keyword.equals((String)keynames1.get(i))){ %>keyitem_click<%} %>" onclick="loadDefault('<%=mtitle %>','2',1,'<%=keynames1.get(i) %>')" title="<%=keynames1.get(i) %>"><%=keynames1.get(i) %></div>
				<%} %>
				<%}else if(keytype.equals("2")){ %>
				<div class="keytitle">关键词：</div>
				<%for(int i=0;i<keynames2.size();i++){%>
					<div class="keyitem <%if(keyword.equals((String)keynames2.get(i))){ %>keyitem_click<%} %>" onclick="loadDefault('<%=mtitle %>','2',2,'<%=keynames2.get(i) %>')" title="<%=keynames2.get(i) %>"><%=keynames2.get(i) %></div>
				<%} %>
				<%}else if(keytype.equals("3")){ %>
				<div class="keytitle">关键词：</div>
				<%for(int i=0;i<keynames3.size();i++){%>
					<div class="keyitem <%if(keyword.equals((String)keynames3.get(i))){ %>keyitem_click<%} %>" onclick="loadDefault('<%=mtitle %>','2',3,'<%=keynames3.get(i) %>')" title="<%=keynames3.get(i) %>"><%=keynames3.get(i) %></div>
				<%} %>
				<%}else if(keytype.equals("0")){ %>
				<div id="tagdiv_1" class="tagdiv">
				<div class="keytitle">关键词：</div>
				<%for(int i=0;i<keynames4.size();i++){
				%>
					<div class="tagitem" title="<%=((String[])keynames4.get(i))[1] %>">
						<div class="keyitem <%if(keyword.equals(((String[])keynames4.get(i))[1])){ %>keyitem_click<%} %>" onclick="loadDefault('<%=mtitle %>','2',0,'<%=((String[])keynames4.get(i))[1] %>')" title=""><%=((String[])keynames4.get(i))[1] %></div>
						<div class="tagdel" onclick="doDelTag(<%=((String[])keynames4.get(i))[0] %>,this)" title="删除"></div>
					</div>
				<%} %>
				</div>
				<%}%>
			</div>
		</div>
		<%} %>
	</div>
	<div id="rightcontent" style="width:100%;height: auto;position:absolute;top:30px;left:0px;bottom:0px;border-top:1px #E8E8E8 solid;
		line-height: 40px;font-size: 14px;" class="scroll1" align="center">
		<div style="width: auto;height: 100%;position: relative;">
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
				<%}else{ %>
				<jsp:include page="/CRM/manage/util/Operation.jsp">
					<jsp:param value="get_list_contact" name="operation"/>
					<jsp:param value="2" name="showtype"/>
					<jsp:param value="1" name="currentpage"/>
					<jsp:param value="<%=isself %>" name="showwarn"/>
					<jsp:param value="<%=keytype %>" name="keytype"/>
					<jsp:param value="<%=_pagesize %>" name="pagesize"/>
					<jsp:param value="<%=_total %>" name="total"/>
				</jsp:include>
				<%} %>
		</table>
		<div id="listmore2" class="datamore" style="<%if(_pagesize>=_total){ %>display: none;<%} %>" onclick="getListContact(this)" _datalist="datalist" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" title="显示更多数据">更多</div>	
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function() {
		$("div.tagitem").bind("mouseover",function(){
			$(this).find("div.tagdel").show();
		}).bind("mouseout",function(){
			$(this).find("div.tagdel").hide();
		});
	
		<%if(isself.equals("2")){ %>
			var hh = $("#warncontent").height()+24;
			$("#righttitle").height(hh);
			$("#rightcontent").css("top",hh);
		<%}%>
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
		    url: "/CRM/manage/util/Operation.jsp",
		    data:{"operation":"get_list_contact","showtype":2,"showwarn":"<%=isself%>","keytype":"<%=keytype%>","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"querysql":filter(encodeURI(_querysql))}, 
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
	<%if(keynames4.size()<16){ %>
	function doSaveTag(index){
		var tagstr = $.trim($("#addtag_"+index).val());
		if(tagstr!=""){
			var hastag = false;
			$("div.tagitem").each(function(){
				if($(this).attr("title")==tagstr){
					hastag = true;
					return;
				}
			});
			if(hastag){
				$("#addtag_"+index).val("");
				return;
			}
			$.ajax({
				type: "post",
			    url: "/CRM/manage/util/Operation.jsp",
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    data:{"operation":"save_key","keytype":0,"keyname":filter(encodeURI(tagstr))}, 
			    complete: function(data){ 
				    var txt = $.trim(data.responseText);
				    $("#tagdiv_"+index).append(txt);
				    var t = $("#tagpanel_"+index).position().top;
				    var l = $("#tagpanel_"+index).position().left;

				    var _t = 0;
				    var _l = 0;
				    var last = $("#tagdiv_"+index).find("div.tagitem:last");
				    if(last.length>0){
					    _t = last.position().top-4;
						_l = last.position().left;
					}
					
				    $("#tagfloat_"+index).html(tagstr).css({top:t,left:l}).show().animate({ top:_t,left:_l},300,null,function(){
					    $(this).hide();
					    last.css({color:'#000'});
					    loadDefault('<%=mtitle %>','2',0);
					});
				}
		    });
		}
	}
	<%}%>
	function doDelTag(keyid,obj){
		if(keyid!=""){
			if(confirm("确定删除此标签?")){
				$.ajax({
					type: "post",
				    url: "/CRM/manage/util/Operation.jsp",
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    data:{"operation":"del_key","keyid":keyid}, 
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    //$(obj).parent().remove();
					    loadDefault('<%=mtitle %>','2',0);
					}
			    });
			}
		}
	}
</script>
