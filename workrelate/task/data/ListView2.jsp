<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workrelate.util.CommonTransUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%	
	String userid = user.getUID()+"";
	String principalid = userid;
	String basesql = " t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.level,t1.begindate,t1.enddate,t1.createdate,t1.createtime "
				+",(select count(tfb.id) from TM_TaskFeedback tfb where tfb.taskid=t1.id) as fbcount"
				//+",(select top 1 tlog.operatedate+' '+tlog.operatetime from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type=0 and tlog.operator="+userid+" order by tlog.operatedate desc,tlog.operatetime desc) as viewdate"
				//+",(select top 1 fb.createdate+' '+fb.createtime from TM_TaskFeedback fb where fb.taskid=t1.id and fb.hrmid<>"+userid+" order by fb.createdate desc,fb.createtime desc) as fbdate"
				+",isnull((select top 1 1 from TM_TaskLog tlog2 where tlog2.taskid=t1.id and tlog2.type=0 and tlog2.operator="+userid+" order by tlog2.operatedate desc,tlog2.operatetime desc),0) as viewtag"
				+",isnull((select distinct 1 from TM_TaskSpecial tts where tts.taskid=t1.id and tts.userid="+userid+"),0) as special"
				
				+", case when (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
				+">(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) then 1 else 0 end as noreadtag"
				
				+" from TM_TaskInfo t1 "
				+" where (t1.deleted=0 or t1.deleted is null)";
	String countsql = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)";
	String querysql = "";
	StringBuffer sqlwhere = new StringBuffer();
	String orderby = " order by viewtag,noreadtag desc,special desc,t1.createdate desc,t1.createtime desc";
	String currentdate = TimeUtil.getCurrentDateString();
	int sorttype = Util.getIntValue(request.getParameter("sorttype"),2);//分类排序类型
	int status = Util.getIntValue(request.getParameter("status"),1);
	//String datatype = Util.null2String(request.getParameter("datatype"));
	String condtype = Util.null2String(request.getParameter("condtype"));
	int hrmid = Util.getIntValue(request.getParameter("hrmid"),0);
	String tag = Util.null2String(URLDecoder.decode(request.getParameter("tag"),"utf-8"));
	
	if(condtype.equals("1")){//本人相关的任务
		sqlwhere.append(" and (t1.principalid="+userid+" or t1.creater="+userid
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))");
	}if(condtype.equals("2")){//本人创建的任务
		sqlwhere.append(" and t1.creater="+userid);
	}if(condtype.equals("3")){//本人负责的任务
		sqlwhere.append(" and t1.principalid="+userid);
	}if(condtype.equals("4")){//本人参与的任务
		sqlwhere.append(" and exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")");
	}if(condtype.equals("5")){//本人关注的任务
		sqlwhere.append(" and exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")");
	}if(condtype.equals("6")){//标记重要的任务
		sqlwhere.append(" and exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")");
	}else if(condtype.equals("0")){//能查看的所有任务
		sqlwhere.append(" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
		+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
		+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
		+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
		+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
		+ ")");
		if(hrmid!=0){
			principalid = hrmid + "";
			sqlwhere.append(" and (t1.principalid="+hrmid+" or t1.creater="+hrmid
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+hrmid+"))");
		}
		if(!tag.equals("")){
			sqlwhere.append(" and t1.tag like '%,"+tag+",%'");
		}
	}
	if(status!=0) sqlwhere.append(" and t1.status="+status);
	
	if(sorttype==4) sqlwhere.append(" and (t1.parentid='' or t1.parentid is null)");
	
	//System.out.println(basesql+sqlwhere+orderby);
	String statustitle = "";
	int _status = 0;
	boolean canEdit = true;
	int right = 0;
	int index = 0;
	
	int _level = 0;
	String[] leveltitle = {"未设置紧急程度","重要紧急","重要不紧急","不重要紧急","不重要不紧急"};
	String begindate = "";
	String enddate = "";
	boolean isToday = false;//是否今天
	
	int _pagesize = 10;
	int _total = 0;//总数
	
	int fbcount = 0;//反馈数
	boolean noreadfb = false;//是否有未读反馈
	boolean isnew = false;//最后未查看
	int special = 0;//是否标记为重要
%>
<style type="text/css">
	<%if(sorttype!=0){%>
	.td_drag{cursor: move !important;}
	.tr_hover .td_drag{background: url('../images/sprite.png') no-repeat -97px -748px;background-color: #F9F9F9 !important;}
	.tr_hover .td_move,.tr_hover .td_blank{background-color: #F9F9F9 !important;border-right-color: #F9F9F9;border-top-color: #fff !important;}
	.tr_hover .td_drag div{display: none;}
	
	.tr_select .td_drag{background: url('../images/sprite.png') no-repeat -97px -748px;background-color: #CEE4FF !important;border-right-color: #CEE4FF;border-top-color: #fff !important;border-bottom-color: #75B4FF !important;}
	.tr_select .td_move,.tr_select .td_blank{background-color: #CEE4FF !important;border-right-color: #CEE4FF;border-top-color: #fff !important;border-bottom-color: #75B4FF !important;}
	.tr_select .td_drag div{display: none;}
	.tr_select div.status1{background: url('../images/ing.png') center no-repeat;}
	<%}%>
</style>
<div style="width: 100%;position: absolute;height: auto;top: 41px;bottom: 0px;left: 0px;right: 0px;">
	
	<!-- 数据列表 -->
	<div id="list" style="position: absolute;top: 0px;bottom: 0px;left: 0;width: 100%;background-color: #fff;background: url('../images/line.png') left repeat-y;">
		<div class="scroll1" style="overflow: auto;width: 100%;height:100%;">
		<%if(sorttype==1){//列表视图 %>
			<table id="datalist" class="datalist" cellpadding="0" cellspacing="0" border="0">
				<tr class="tr_blank">
					<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
					<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
				</tr>
				<tr class="tr_blank">
					<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
					<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
				</tr>
			<%
					_pagesize = 30;
					rs.executeSql(countsql+sqlwhere.toString());
					if(rs.next()){
						_total = rs.getInt(1);
					}
					rs.executeSql("select top "+_pagesize+basesql+sqlwhere.toString()+orderby);
					while(rs.next()){
						right = cmutil.getRight(rs.getString("id"),user);
						if(right==2) canEdit = true; else canEdit = false;
						_status = rs.getInt("status");
						if(canEdit){
							if(_status==1){
								statustitle = "设置为完成";
							}else if(_status==2 || _status==3){
								statustitle = "设置为进行中";
							}
						}else{
							if(_status==1) _status=0;
						}
						_level = Util.getIntValue(rs.getString("level"),0);
						
						//判断是否今天
						begindate = Util.null2String(rs.getString("begindate"));
						enddate = Util.null2String(rs.getString("enddate"));
						/**
						if((!begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0 && TimeUtil.dateInterval(currentdate,enddate)>=0)
								|| (!begindate.equals("") && enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0)
								|| (begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(currentdate,enddate)>=0)){
							isToday = true;
						}else{
							isToday = false;
						}*/
						
						fbcount = Util.getIntValue(rs.getString("fbcount"),0);
						/**
						fbdate = Util.null2String(rs.getString("fbdate"));
						noreadfb = false;
						if(!fbdate.equals("")){
							if(viewdate.equals("")){
								noreadfb = true;
							}else{
								if(TimeUtil.timeInterval(viewdate,fbdate)>0){
									noreadfb = true;
								}
							}
						}*/
						special = Util.getIntValue(rs.getString("special"),0);
						isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
						noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
				%>
				<tr class="item_tr">
					<td class='td_move' <%if(!canEdit){%>title="无权限编辑"<%}%>><div>&nbsp;</div></td>
					<td width="20px"><div id="status_<%=rs.getString("id") %>" class="<%if(canEdit){%>status_do <%}%>status status<%=_status%>" _taskid="<%=rs.getString("id") %>" _status="<%=_status%>" <%if(canEdit){%>title="<%=statustitle%>" onclick="changestatus(this)"<%}%>>&nbsp;</div></td>
					<td width="20px"><div id="level_<%=rs.getString("id") %>" class="div_level" style="background: url('../images/level_0<%=_level %>.png') center no-repeat;" title="<%=leveltitle[_level] %>"></div></td>
					<td class='item_td'><input <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" type="text" name="" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("name")) %>" value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/></td>
					<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>><%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%></td>
					<td><div id="enddate_<%=rs.getString("id") %>" class="div_today" title='<%if(!enddate.equals("")){%>结束日期：<%=enddate%><%}else{%>无结束日期<%} %>' ><%if(!enddate.equals("")){%><%=enddate%><%}else{%>&nbsp;<%}%></div></td>
					<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
					<td class='item_att item_att<%=special %>' title="<%if(special==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=special %>">&nbsp;</td>
				</tr>
				<%
					} 
				%>
				<tr class='item_tr'>
					<td class="td_blank"><div>&nbsp;</div></td>
					<td width='20px'><div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div></td>
					<td width="20px"><div id='' class="div_level" title=''>&nbsp;</div></td>
					<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' class='disinput addinput definput' type='text' name='' value='新建任务' id='' _index="<%=index++ %>"/></td>
					<td class='item_count'>&nbsp;</td>
					<td><div id="" class="div_today" title=''>&nbsp;</div></td>
					<td class='item_hrm'>&nbsp;</td>
					<td class='item_att'>&nbsp;</td>
				</tr>
			</table>
			<%
				if(_total>_pagesize){
					request.getSession().setAttribute("TM_LIST_SQL",basesql+sqlwhere.toString());
			%>
				<div class="listicon">&nbsp;</div>
				<div id="listmore" class="listmore" onclick="getListMore(this)" _datalist="datalist" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" _excludeids="" title="显示更多数据">更多</div>	
			<%	} %>
		<%}else if(sorttype==5){//Todolist视图
			String[] datetype = {"今天","明天","即将","不标记"};
			String[] datetitle = {"标记为【今天】的任务","标记为【明天】的任务","标记为【即将】的工作","无标记的任务"};
			_pagesize = 10;
			for(int i=0;i<datetype.length;i++){
		%>
		<div class="sorttitle" title="点击收缩"><div class="sorticon"></div><div class="sorthead" title="<%=datetitle[i] %>"><%=datetype[i] %></div></div>
		<table id="datalist<%=i %>" class="datalist" cellpadding="0" cellspacing="0" border="0" _datetype="<%=i+1%>">
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
			</tr>
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
			</tr>
		<%
				if(i==0){
					isToday = true;
					querysql = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+userid+" and tt.tododate<='"+currentdate+"')" + sqlwhere.toString();
				}else if(i==1){
					isToday = false;
					querysql = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+userid+" and tt.tododate='"+TimeUtil.dateAdd(currentdate,1)+"')" + sqlwhere.toString();
				}else if(i==2){
					isToday = false;
					querysql = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+userid+" and tt.tododate>'"+TimeUtil.dateAdd(currentdate,1)+"')" + sqlwhere.toString();
				}else if(i==3){
					isToday = false;
					querysql = " and not exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+userid+")" + sqlwhere.toString();
				}
				rs.executeSql(countsql+querysql);
				if(rs.next()){
					_total = rs.getInt(1);
				}
				rs.executeSql("select top "+_pagesize+basesql+querysql+orderby);
				//System.out.println("select top "+_pagesize+basesql+querysql+orderby);
				while(rs.next()){
					right = cmutil.getRight(rs.getString("id"),user);
					if(right==2) canEdit = true; else canEdit = false;
					_status = rs.getInt("status");
					if(canEdit){
						if(_status==1){
							statustitle = "设置为完成";
						}else if(_status==2 || _status==3){
							statustitle = "设置为进行中";
						}
					}else{
						if(_status==1) _status=0;
					}
					_level = Util.getIntValue(rs.getString("level"),0);
					
					fbcount = Util.getIntValue(rs.getString("fbcount"),0);
					special = Util.getIntValue(rs.getString("special"),0);
					isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
					noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
		%>
			<tr class="item_tr">
				<td class='td_move td_drag'><div>&nbsp;</div></td>
				<td width="20px"><div id="status_<%=rs.getString("id") %>" class="<%if(canEdit){%>status_do <%}%>status status<%=_status%>" _taskid="<%=rs.getString("id") %>" _status="<%=_status%>" <%if(canEdit){%>title="<%=statustitle%>" onclick="changestatus(this)"<%}%>></div></td>
				<td width="20px"><div id="level_<%=rs.getString("id") %>" class="div_level" style="background: url('../images/level_0<%=_level %>.png') center no-repeat;" title="<%=leveltitle[_level] %>"></div></td>
				<td class='item_td'><input <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" type="text" name="" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("name")) %>"  value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/></td>
				<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>><%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%></td>
				<td><div id="today_<%=rs.getString("id") %>" class="div_today" <%if(isToday){%>title='今天的任务'<%}%> ><%if(isToday){%>今天<%}else{%>&nbsp;<%}%></div></td>
				<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
				<td class='item_att item_att<%=special %>' title="<%if(special==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=special %>">&nbsp;</td>
			</tr>
		<%			
				}
		%>
			<tr class='item_tr'>
				<td class="td_blank"><div>&nbsp;</div></td>
				<td width='20px'><div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div></td>
				<td width="20px"><div id='' class="div_level" title=''>&nbsp;</div></td>
				<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' class='disinput addinput definput' type='text' name='' value='新建任务' id='' _index="<%=index++ %>"/></td>
				<td class='item_count'>&nbsp;</td>
				<td><div id="" class="div_today" title=''>&nbsp;</div></td>
				<td class='item_hrm'>&nbsp;</td>
				<td class='item_att'>&nbsp;</td>
			</tr>
		</table>
		<%
				if(_total>_pagesize){
					request.getSession().setAttribute("TM_LIST_SQL",basesql+querysql);
		%>
			<div class="listicon">&nbsp;</div>
			<div id="listmore<%=i+1 %>" class="listmore" onclick="getListMore(this)" _datalist="datalist<%=i %>" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" _excludeids="" title="显示更多数据">更多</div>	
		<%		} %>
		<%
			}
		%>
		<%}else if(sorttype==2){//日期视图 
			String[] datetype = {"已延期","今天到期","明天到期","以后到期","无到期日"};
			String[] datetitle = {"结束日期小于今天的任务","结束日期为今天的任务","结束日期为明天的任务","结束日期大于明天的任务","未设置结束日期的任务"};
			_pagesize = 10;
			for(int i=0;i<datetype.length;i++){
		%>
		<div class="sorttitle" title="点击收缩"><div class="sorticon"></div><div class="sorthead" title="<%=datetitle[i] %>"><%=datetype[i] %></div></div>
		<table id="datalist<%=i %>" class="datalist" cellpadding="0" cellspacing="0" border="0" _datetype="<%=i+1%>">
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
			</tr>
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
			</tr>
		<%
				if(i==0){
					isToday = false;
					querysql = " and t1.enddate<>'' and t1.enddate is not null and t1.enddate<'"+currentdate+"'" + sqlwhere.toString();
				}else if(i==1){
					isToday = true;
					querysql = " and t1.enddate='"+currentdate+"'" + sqlwhere.toString();
				}else if(i==2){
					isToday = false;
					querysql = " and t1.enddate='"+TimeUtil.dateAdd(currentdate,1)+"'" + sqlwhere.toString();
				}else if(i==3){
					isToday = false;
					querysql = " and t1.enddate<>'' and t1.enddate is not null and t1.enddate>'"+TimeUtil.dateAdd(currentdate,1)+"'" + sqlwhere.toString();
				}else{
					isToday = false;
					querysql = " and (t1.enddate='' or t1.enddate is null)" + sqlwhere.toString();
				}
				rs.executeSql(countsql+querysql);
				if(rs.next()){
					_total = rs.getInt(1);
				}
				rs.executeSql("select top "+_pagesize+basesql+querysql+orderby);
				//System.out.println("select top "+_pagesize+basesql+querysql+orderby);
				while(rs.next()){
					right = cmutil.getRight(rs.getString("id"),user);
					if(right==2) canEdit = true; else canEdit = false;
					_status = rs.getInt("status");
					if(canEdit){
						if(_status==1){
							statustitle = "设置为完成";
						}else if(_status==2 || _status==3){
							statustitle = "设置为进行中";
						}
					}else{
						if(_status==1) _status=0;
					}
					_level = Util.getIntValue(rs.getString("level"),0);
					
					fbcount = Util.getIntValue(rs.getString("fbcount"),0);
					special = Util.getIntValue(rs.getString("special"),0);
					isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
					noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
		%>
			<tr class="item_tr">
				<td class='td_move<%if(canEdit){%> td_drag<%}%>' <%if(!canEdit){%>title="无权限编辑"<%}%>><div>&nbsp;</div></td>
				<td width="20px"><div id="status_<%=rs.getString("id") %>" class="<%if(canEdit){%>status_do <%}%>status status<%=_status%>" _taskid="<%=rs.getString("id") %>" _status="<%=_status%>" <%if(canEdit){%>title="<%=statustitle%>" onclick="changestatus(this)"<%}%>></div></td>
				<td width="20px"><div id="level_<%=rs.getString("id") %>" class="div_level" style="background: url('../images/level_0<%=_level %>.png') center no-repeat;" title="<%=leveltitle[_level] %>"></div></td>
				<td class='item_td'><input <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" type="text" name="" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("name")) %>"  value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/></td>
				<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>><%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%></td>
				<td><div id="today_<%=rs.getString("id") %>" class="div_today" <%if(isToday){%>title='今天的任务'<%}%> ><%if(isToday){%>今天<%}else{%>&nbsp;<%}%></div></td>
				<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
				<td class='item_att item_att<%=special %>' title="<%if(special==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=special %>">&nbsp;</td>
			</tr>
		<%			
				}
		%>
			<tr class='item_tr'>
				<td class="td_blank"><div>&nbsp;</div></td>
				<td width='20px'><div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div></td>
				<td width="20px"><div id='' class="div_level" title=''>&nbsp;</div></td>
				<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' class='disinput addinput definput' type='text' name='' value='新建任务' id='' _index="<%=index++ %>"/></td>
				<td class='item_count'>&nbsp;</td>
				<td><div id="" class="div_today" title=''>&nbsp;</div></td>
				<td class='item_hrm'>&nbsp;</td>
				<td class='item_att'>&nbsp;</td>
			</tr>
		</table>
		<%
				if(_total>_pagesize){
					request.getSession().setAttribute("TM_LIST_SQL",basesql+querysql);
		%>
			<div class="listicon">&nbsp;</div>
			<div id="listmore<%=i+1 %>" class="listmore" onclick="getListMore(this)" _datalist="datalist<%=i %>" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" _excludeids="" title="显示更多数据">更多</div>	
		<%		} %>
		<%
			}
		%>
		<%}else if(sorttype==3){//紧急程度视图
			String[] leveltype = {"重要紧急","重要不紧急","不重要紧急","不重要不紧急","未设置"};
			String[] leveltitles = {"紧急程度为重要紧急的任务","紧急程度为重要不紧急的任务","紧急程度为不重要紧急的任务","紧急程度为不重要不紧急的任务","未设置紧急程度的任务"};
			_pagesize = 10;
			for(int i=0;i<leveltype.length;i++){
				if(i==4){
					querysql = " and (t1.level=0 or t1.level is null)" + sqlwhere;
				}else{
					querysql = " and t1.level="+(i+1) + sqlwhere;
				}
		%>
		<div class="sorttitle" title="点击收缩"><div class="sorticon"></div><div class="sorthead" title="<%=leveltitles[i] %>"><%=leveltype[i] %></div></div>
		<table id="datalist<%=i %>" class="datalist" cellpadding="0" cellspacing="0" border="0" _datetype="<%=i+1%>">
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
			</tr>
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
			</tr>
		<%
				rs.executeSql(countsql+querysql);
				if(rs.next()){
					_total = rs.getInt(1);
				}
				rs.executeSql("select top "+_pagesize+basesql+querysql+orderby);
				while(rs.next()){
					right = cmutil.getRight(rs.getString("id"),user);
					if(right==2) canEdit = true; else canEdit = false;
					_status = rs.getInt("status");
					if(canEdit){
						if(_status==1){
							statustitle = "设置为完成";
						}else if(_status==2 || _status==3){
							statustitle = "设置为进行中";
						}
					}else{
						if(_status==1) _status=0;
					}
					_level = Util.getIntValue(rs.getString("level"),0);
					
					//判断是否今天
					begindate = Util.null2String(rs.getString("begindate"));
					enddate = Util.null2String(rs.getString("enddate"));
					if((!begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0 && TimeUtil.dateInterval(currentdate,enddate)>=0)
							|| (!begindate.equals("") && enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0)
							|| (begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(currentdate,enddate)>=0)){
						isToday = true;
					}else{
						isToday = false;
					}
					
					fbcount = Util.getIntValue(rs.getString("fbcount"),0);
					special = Util.getIntValue(rs.getString("special"),0);
					isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
					noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
		%>
			<tr class="item_tr">
				<td class='td_move<%if(canEdit){%> td_drag<%}%>' <%if(!canEdit){%>title="无权限编辑"<%}%>><div>&nbsp;</div></td>
				<td width="20px"><div id="status_<%=rs.getString("id") %>" class="<%if(canEdit){%>status_do <%}%>status status<%=_status%>" _taskid="<%=rs.getString("id") %>" _status="<%=_status%>" <%if(canEdit){%>title="<%=statustitle%>" onclick="changestatus(this)"<%}%>></div></td>
				<td width="20px"><div id="level_<%=rs.getString("id") %>" class="div_level" style="background: url('../images/level_0<%=_level %>.png') center no-repeat;" title="<%=leveltitle[_level] %>"></div></td>
				<td class='item_td'><input <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" type="text" name="" id="<%=rs.getString("id") %>" title="<%=Util.null2String(rs.getString("name")) %>"  value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/></td>
				<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>><%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%></td>
				<td><div id="today_<%=rs.getString("id") %>" class="div_today" <%if(isToday){%>title='今天的任务'<%}%> ><%if(isToday){%>今天<%}else{%>&nbsp;<%}%></div></td>
				<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
				<td class='item_att item_att<%=special %>' title="<%if(special==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=special %>">&nbsp;</td>
			</tr>
		<%			
				}
		%>
			<tr class='item_tr'>
				<td class="td_blank"><div>&nbsp;</div></td>
				<td width='20px'><div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div></td>
				<td width="20px"><div id='' class="div_level" title=''>&nbsp;</div></td>
				<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' class='disinput addinput definput' type='text' name='' value='新建任务' id='' _index="<%=index++ %>"/></td>
				<td class='item_count'>&nbsp;</td>
				<td><div id="" class="div_today" title=''>&nbsp;</div></td>
				<td class='item_hrm'>&nbsp;</td>
				<td class='item_att'>&nbsp;</td>
			</tr>
		</table>
		<%
				if(_total>_pagesize){
					request.getSession().setAttribute("TM_LIST_SQL",basesql+querysql);
		%>
			<div class="listicon">&nbsp;</div>
			<div id="listmore<%=i+1 %>" class="listmore" onclick="getListMore(this)" _datalist="datalist<%=i %>" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" _excludeids="" title="显示更多数据">更多</div>	
		<%		} %>
		<%
			}
		  }else if(sorttype==4){//层级视图
		%>
			<table id="datalist" class="datalist" cellpadding="0" cellspacing="0" border="0">
				<tr class="tr_blank">
					<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
					<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
				</tr>
				<tr class="tr_blank">
					<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td style="width: 20px;"></td><td></td>
					<td style="width: 22px;"></td><td style="width: 30px;"></td><td style="width: 40px;"></td><td style="width: 18px;"></td>
				</tr>
			<%
					_pagesize = 30;
					rs.executeSql(countsql+sqlwhere);
					if(rs.next()){
						_total = rs.getInt(1);
					}
					rs.executeSql("select top "+_pagesize+basesql+sqlwhere+orderby);
					while(rs.next()){
						right = cmutil.getRight(rs.getString("id"),user);
						if(right==2) canEdit = true; else canEdit = false;
						_status = rs.getInt("status");
						if(canEdit){
							if(_status==1){
								statustitle = "设置为完成";
							}else if(_status==2 || _status==3){
								statustitle = "设置为进行中";
							}
						}else{
							if(_status==1) _status=0;
						}
						_level = Util.getIntValue(rs.getString("level"),0);
						
						//判断是否今天
						begindate = Util.null2String(rs.getString("begindate"));
						enddate = Util.null2String(rs.getString("enddate"));
						if((!begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0 && TimeUtil.dateInterval(currentdate,enddate)>=0)
								|| (!begindate.equals("") && enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0)
								|| (begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(currentdate,enddate)>=0)){
							isToday = true;
						}else{
							isToday = false;
						}
						
						fbcount = Util.getIntValue(rs.getString("fbcount"),0);
						/**
						fbdate = Util.null2String(rs.getString("fbdate"));
						noreadfb = false;
						if(!fbdate.equals("")){
							if(viewdate.equals("")){
								noreadfb = true;
							}else{
								if(TimeUtil.timeInterval(viewdate,fbdate)>0){
									noreadfb = true;
								}
							}
						}*/
						special = Util.getIntValue(rs.getString("special"),0);
						isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
						noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
				%>
				<tr class="item_tr">
					<td class='td_move' <%if(!canEdit){%>title="无权限编辑"<%}%>><div>&nbsp;</div></td>
					<td width="20px"><div id="status_<%=rs.getString("id") %>" class="<%if(canEdit){%>status_do <%}%>status status<%=_status%>" _taskid="<%=rs.getString("id") %>" _status="<%=_status%>" <%if(canEdit){%>title="<%=statustitle%>" onclick="changestatus(this)"<%}%>>&nbsp;</div></td>
					<td width="20px"><div id="level_<%=rs.getString("id") %>" class="div_level" style="background: url('../images/level_0<%=_level %>.png') center no-repeat;" title="<%=leveltitle[_level] %>"></div></td>
					<td class='item_td'><input <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" type="text" name="" id="<%=rs.getString("id") %>" _pid="-1" title="<%=Util.null2String(rs.getString("name")) %>" value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/></td>
					<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>><%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%></td>
					<td><div id="today_<%=rs.getString("id") %>" class="div_today" <%if(isToday){%>title='今天的任务'<%}%> ><%if(isToday){%>今天<%}else{%>&nbsp;<%}%></div></td>
					<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
					<td class='item_att item_att<%=special %>' title="<%if(special==0){%>标记关注<%}else{%>取消关注<%}%>" _special="<%=special %>">&nbsp;</td>
				</tr>
				<%=this.getSubTask(rs.getString("id"),user,2) %>
				<%
					} 
				%>
				<tr class='item_tr'>
					<td class="td_blank"><div>&nbsp;</div></td>
					<td width='20px'><div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div></td>
					<td width="20px"><div id='' class="div_level" title=''>&nbsp;</div></td>
					<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' class='disinput addinput definput' type='text' name='' value='新建任务' id='' _index="<%=index++ %>"/></td>
					<td class='item_count'>&nbsp;</td>
					<td><div id="" class="div_today" title=''>&nbsp;</div></td>
					<td class='item_hrm'>&nbsp;</td>
					<td class='item_att'>&nbsp;</td>
				</tr>
			</table>
			<%
				if(_total>_pagesize){
					request.getSession().setAttribute("TM_LIST_SQL",basesql+sqlwhere.toString());
			%>
				<div class="listicon">&nbsp;</div>
				<div id="listmore" class="listmore" onclick="getListMore(this)" _datalist="datalist" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" _excludeids="" title="显示更多数据">更多</div>	
			<%	} %>
		
		
		<%} %>
		</div>
	</div>
</div>
	<script type="text/javascript">
			
			var searchstatus = "<%=status%>";
			var sorttype = "<%=sorttype%>";
			
			var index = <%=index++%>;

			principalid = "<%=principalid%>";

			//初始绑定事件
			$(document).ready(function(){
				
				if(sorttype!=0){
					$("table.datalist").dragsort({
						itemSelector: "tr",
						dragSelector: ".td_drag", 
						dragBetween: true, 
						dragStart: function(){
						//$(this).find(".disinput").blur();
							olddatetype = $(this).parent().parent().attr("_datetype");
						},
						dragEnd: function(){
							if(sorttype==2 || sorttype==3 || sorttype==5){
								var dragobj = $(this).find("input.disinput");
								var newdatetype = $(this).parent().parent().attr("_datetype");
								var dragid = dragobj.attr("id");
								if(olddatetype!=newdatetype){
									$.ajax({
										type: "post",
									    url: "/workrelate/task/data/Operation.jsp",
									    data:{"operation":"edit_field","taskId":dragid,"fieldname":sorttype,"fieldvalue":newdatetype}, 
									    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
									    complete: function(data){
									    	if(dragobj.attr("id")==detailid){
												refreshDetail(dragobj.attr("id"));
											}
										}
								    });
								    //更改紧急程度时重置图标
								    if(sorttype==3){
									    if(newdatetype>4) newdatetype = 0;
								    	$("#level_"+dragid).css("background","url('../images/level_0"+newdatetype+".png') center no-repeat").attr("title",leveltitle[newdatetype]);
									}
									//设置是否显示今天
								    if(sorttype==2){
									    if(newdatetype==1){
									    	$("#today_"+dragid).show();
										}else{
											$("#today_"+dragid).hide();
										}
									}
									//设置读取更多数据时排除的ID
									$("#listmore"+newdatetype).attr("_excludeids",$("#listmore"+newdatetype).attr("_excludeids")+dragid+",");
								}
							}
							setIndex();//重置序号
						},
						placeHolderTemplate: "<tr><td style='width:15px'></td><td style='width:20px'></td><td style=''></td></tr>",
						scrollSpeed: 5
					});
				}

				$("div.sorttitle").bind("click",function(){
					if($(this).next("table").css("display")=="none"){
						$(this).next("table").show().next("div.listicon").show().next("div.listmore").show();
						$(this).css("color","#000").attr("title","点击收缩");
					}else{
						$(this).next("table").hide().next("div.listicon").hide().next("div.listmore").hide();
						$(this).css("color","#0080FF").attr("title","点击展开");
					}
					
				});

				$("div.listmore").bind("mouseover",function(){
					$(this).css("color","#004080");
				}).bind("mouseout",function(){
					$(this).css("color","#696969");
				});

				setIndex()
			});

			
			
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
	public String getSubTask(String maintaskid,User user,int type) throws Exception{
		String userid = user.getUID()+"";
		StringBuffer res = new StringBuffer();
		RecordSet rs = new RecordSet();
		CommonTransUtil cmutil = new CommonTransUtil();
		String basesql = "select t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.level,t1.begindate,t1.enddate,t1.createdate,t1.createtime "
			+",(select count(tfb.id) from TM_TaskFeedback tfb where tfb.taskid=t1.id) as fbcount"
			+",isnull((select top 1 1 from TM_TaskLog tlog2 where tlog2.taskid=t1.id and tlog2.type=0 and tlog2.operator="+userid+" order by tlog2.operatedate desc,tlog2.operatetime desc),0) as viewtag"
			+",isnull((select distinct 1 from TM_TaskSpecial tts where tts.taskid=t1.id and tts.userid="+userid+"),0) as special"
			+", case when (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+">(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) then 1 else 0 end as noreadtag"
			+" from TM_TaskInfo t1 "
			+" where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid
			+ " and (t1.principalid="+userid+" or t1.creater="+userid
			+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
			+ " order by id";
			//+ " order by viewtag,noreadtag desc,special desc,t1.createdate desc,t1.createtime desc";
		rs.executeSql(basesql);
		//if(rs.getCounts()>0){
			if(type==2) res.append("<tr class='subtable_tr'><td colspan='8' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'>"
				+"<colgroup><col width='23px'/><col width='20px'/><col width='20px'/><col width='*'/><col width='22px'/><col width='30px'/><col width='40px'/><col width='18px'/></colgroup>");
					
			String currentdate = TimeUtil.getCurrentDateString();
			String statustitle = "";
			int _status = 0;
			boolean canEdit = true;
			int right = 0;
			int index = 0;
			String[] leveltitle = {"未设置紧急程度","重要紧急","重要不紧急","不重要紧急","不重要不紧急"};
			int _level = 0;
			String begindate = "";
			String enddate = "";
			boolean isToday = false;//是否今天
			
			int fbcount = 0;//反馈数
			boolean noreadfb = false;//是否有未读反馈
			boolean isnew = false;//最后未查看
			int special = 0;//是否标记为重要
			while(rs.next()){
				right = cmutil.getRight(rs.getString("id"),user);
				if(right==2) canEdit = true; else canEdit = false;
				_status = rs.getInt("status");
				if(canEdit){
					if(_status==1){
						statustitle = "设置为完成";
					}else if(_status==2 || _status==3){
						statustitle = "设置为进行中";
					}
				}else{
					if(_status==1) _status=0;
				}
				_level = Util.getIntValue(rs.getString("level"),0);
				
				//判断是否今天
				begindate = Util.null2String(rs.getString("begindate"));
				enddate = Util.null2String(rs.getString("enddate"));
				if((!begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0 && TimeUtil.dateInterval(currentdate,enddate)>=0)
						|| (!begindate.equals("") && enddate.equals("") && TimeUtil.dateInterval(begindate,currentdate)>=0)
						|| (begindate.equals("") && !enddate.equals("") && TimeUtil.dateInterval(currentdate,enddate)>=0)){
					isToday = true;
				}else{
					isToday = false;
				}
				
				fbcount = Util.getIntValue(rs.getString("fbcount"),0);
				special = Util.getIntValue(rs.getString("special"),0);
				isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
				noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
				
				
				res.append("<tr class='item_tr'>");
				res.append("<td class='' "+(!canEdit?"title='无权限编辑'":"")+"><div>&nbsp;</div></td>");
				res.append("<td width='20px'><div id=\"status_"+rs.getString("id")+"\" class=\""+(canEdit?"status_do ":"")+"status status"+_status+"\" _taskid=\""+rs.getString("id")+"\" _status=\""+_status+"\" "+(canEdit?"title='"+statustitle+"' onclick='changestatus(this)'":"")+">&nbsp;</div></td>");
				res.append("<td width='20px'><div id=\"level_"+rs.getString("id")+"\" class=\"div_level\" style=\"background: url('../images/level_0"+_level+".png') center no-repeat;\" title=\""+leveltitle[_level]+"\"></div></td>");
				res.append("<td class='item_td'><input "+(!canEdit?" readonly='readonly'":"")+" onfocus=\"doClickItem(this)\" onblur='doBlurItem(this)' class=\"disinput "+(isnew?"newinput":"")+"\" type=\"text\" name=\"\" id=\""+rs.getString("id")+"\" _pid=\""+maintaskid+"\" title=\""+Util.null2String(rs.getString("name"))+"\" value=\""+Util.null2String(rs.getString("name"))+"\" _index=\""+(index++)+"\"/></td>");
				res.append("<td class='item_count "+(noreadfb?"item_count_new":"")+"' _fbcount=\""+fbcount+"\" ");
				if(noreadfb){
					res.append("title='有新反馈'");
				}else if(fbcount>0){
					res.append("title='"+fbcount+"条反馈'");
				}
				res.append(">"+(fbcount>0?"("+fbcount+")":"&nbsp;")+"</td>");
				res.append("<td><div id=\"today_"+rs.getString("id")+"\" class=\"div_today\" "+(isToday?"title='今天的任务'":"")+" >"+(isToday?"今天":"&nbsp;")+"</div></td>");
				res.append("<td class='item_hrm' title='责任人'>"+this.getHrmLink(rs.getString("principalid"))+"</td>");
				res.append("<td class='item_att item_att"+special+"' title=\""+(special==0?"标记关注":"取消关注")+"\" _special=\""+special+"\">&nbsp;</td>");
				res.append("</tr>");
				res.append(this.getSubTask(rs.getString("id"),user,2));
			}
			if(type==2) res.append("</table></td></tr>");
		//}
		
		return res.toString();
	}
%>