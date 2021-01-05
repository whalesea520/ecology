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
	String condtype = Util.null2String(request.getParameter("condtype"));
	int sorttype = Util.getIntValue(request.getParameter("sorttype"),2);//分类排序类型
	int hrmid = Util.getIntValue(request.getParameter("hrmid"),0);
	int status = Util.getIntValue(request.getParameter("status"),1);
	String userid = user.getUID()+"";
	int period = Util.getIntValue(request.getParameter("period"),3);
	int periody = Util.getIntValue(request.getParameter("periody"),Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4)));
	int periodm = Util.getIntValue(request.getParameter("periodm"),Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7)));
	int periods = Util.getIntValue(request.getParameter("periods"),Integer.parseInt(TimeUtil.getCurrentSeason()));
	if(sorttype==4){
%>
	<iframe id="treeframe" name="treeframe" style="width: 100%;height: 100%;" frameborder="0" scrolling="no" 
		src="TreeShow.jsp?condtype=<%=condtype %>&hrmid=<%=hrmid %>&period=<%=period %>&periody=<%=periody%>&periodm=<%=periodm%>&periods=<%=periods%>&status=<%=status %>&<%=System.currentTimeMillis()%>"></iframe>
	<div id="frameload" style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp.png) repeat;' align='center'>
	<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1.gif) center no-repeat'></div>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			var iframe1 = document.getElementById("treeframe");
			if (iframe1.attachEvent){ 
				iframe1.attachEvent("onload", function(){ 
					$("#frameload").remove();
					//setTime(reload,50000);
				}); 
			} else { 
				iframe1.onload = function(){ 
					$("#frameload").remove();
				}; 
			} 
		});
	</script>
<%
		return;		
	}
	String principalid = userid;
	String basesql = "";
	if("oracle".equals(rs.getDBType())){
		basesql = " t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.attribute,t1.begindate,t1.enddate,t1.createdate,t1.createtime "
				+",(select count(tfb.id) from GM_GoalFeedback tfb where tfb.goalid=t1.id) as fbcount"
				+",(select v.viewdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as viewdate,goalid from GM_GoalLog where type=0 and operator="+userid +" order by operatedate desc,operatetime desc) v where v.goalid=t1.id and rownum=1) as lastviewdate"
				+",(select v.lastfbdate from (select CONCAT(CONCAT(createdate,' '),createtime) as lastfbdate,goalid from GM_GoalFeedback where hrmid<>"+userid+" order by createdate desc,createtime desc) v where v.goalid=t1.id and rownum=1) as lastfbdate"
				+",nvl((select distinct 1 from GM_GoalSpecial tts where tts.goalid=t1.id and tts.userid="+userid+"),0) as special"
				+",(select v.lastoperatedate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as lastoperatedate,goalid from GM_GoalLog where type not in (0,11,12) order by operatedate desc,operatetime desc) v where v.goalid=t1.id and rownum=1) as lastoperatedate"
				+" from GM_GoalInfo t1 "
				+" where (t1.deleted=0 or t1.deleted is null)";
	}else{
		basesql = " t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.attribute,t1.begindate,t1.enddate,t1.createdate,t1.createtime "
				+",(select count(tfb.id) from GM_GoalFeedback tfb where tfb.goalid=t1.id) as fbcount"
				+",(select top 1 tlog.operatedate+' '+tlog.operatetime from GM_GoalLog tlog where tlog.goalid=t1.id and tlog.type=0 and tlog.operator="+userid+" order by tlog.operatedate desc,tlog.operatetime desc) as lastviewdate"
				+",(select top 1 fb.createdate+' '+fb.createtime from GM_GoalFeedback fb where fb.goalid=t1.id and fb.hrmid<>"+userid+" order by fb.createdate desc,fb.createtime desc) as lastfbdate"
				+",isnull((select distinct 1 from GM_GoalSpecial tts where tts.goalid=t1.id and tts.userid="+userid+"),0) as special"
				+",(select top 1 tlog.operatedate+' '+tlog.operatetime from GM_GoalLog tlog where tlog.goalid=t1.id and tlog.type not in (0,11,12) order by tlog.operatedate desc,tlog.operatetime desc) as lastoperatedate"
				+" from GM_GoalInfo t1 "
				+" where (t1.deleted=0 or t1.deleted is null)";
	}
	String countsql = "select count(t1.id) as amount from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null)";
	String typewhere = "";
	StringBuffer sqlwhere = new StringBuffer();
	String orderby = " order by lastoperatedate desc";
	String currentdate = TimeUtil.getCurrentDateString();
	
	if(sorttype==5) status=1;//Todolist视图是显示进行中
	
	
	//String datatype = Util.null2String(request.getParameter("datatype"));
	String tag = Util.null2String(URLDecoder.decode(request.getParameter("tag"),"utf-8"));
	if(condtype.equals("7")){
		status=2;//新完成的目标 状态为完成
		sorttype=1;//列表展示
	}
	String datefrom = "";
	String dateto = "";
	if(period==1){//月度
		datefrom = TimeUtil.getYearMonthFirstDay(periody,periodm);
		dateto = TimeUtil.getYearMonthEndDay(periody,periodm);
	}else if(period==2){//季度
		if(periods==1){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,1);
			dateto = TimeUtil.getYearMonthEndDay(periody,3);
		}else if(periods==2){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,4);
			dateto = TimeUtil.getYearMonthEndDay(periody,6);
		}else if(periods==3){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,7);
			dateto = TimeUtil.getYearMonthEndDay(periody,9);
		}else if(periods==4){
			datefrom = TimeUtil.getYearMonthFirstDay(periody,10);
			dateto = TimeUtil.getYearMonthEndDay(periody,12);
		}
	}else if(period==3){//年度
		datefrom = TimeUtil.getYearMonthFirstDay(periody,1);
		dateto = TimeUtil.getYearMonthEndDay(periody,12);
	}else if(period==4){//三年
		
	}else if(period==5){//五年
		
	}
	if(period!=0){
		sqlwhere.append(" and t1.period="+period);
	}
	if(!datefrom.equals("")){
		sqlwhere.append(" and t1.enddate>='"+datefrom+"'");
	}
	if(!dateto.equals("")){
		sqlwhere.append(" and t1.enddate<='"+dateto+"'");
	}
	
	if(condtype.equals("1")){//我的目标即我负责的目标
		sqlwhere.append(" and t1.principalid="+userid);
	}else if(condtype.equals("2")){//公司目标
	}else if(condtype.equals("3")){//本人创建
		sqlwhere.append(" and t1.creater="+userid);
	}else if(condtype.equals("4")){//本人参与
		sqlwhere.append(" and exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+")");
	}else if(condtype.equals("5")){//被分享
		sqlwhere.append(" and exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+userid+")");
	}else if(condtype.equals("6")){//标记关注
		sqlwhere.append(" and exists (select 1 from GM_GoalSpecial special where special.goalid=t1.id and special.userid="+userid+")");
	}else if(condtype.equals("7")){//新完成
		sqlwhere.append(" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
				+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+user.getUID()+")"
				+ " or exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+user.getUID()+")"
				+ " or exists (select 1 from GM_GoalSpecial special where special.goalid=t1.id and special.userid="+userid+")"
				+ ")");
		
		if("oracle".equals(rs.getDBType())){
			sqlwhere.append(" and (nvl((select v.showdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as showdate,goalid from GM_GoalLog where type=6 and operator<>"+userid+" order by createdate desc,createtime desc) v where v.goalid=t1.id and rownum=1),'')"
					+">nvl((select v.showdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as showdate,taskid from GM_GoalLog where type=0 and operator="+userid+" order by operatedate desc,operatetime desc) v where v.goalid=t1.id and rownum=1),''))");
		}else{
			sqlwhere.append(" and ((select top 1 t3.operatedate+' '+t3.operatetime from GM_GoalLog t3 where t3.goalid=t1.id and t3.type=6 and t3.operator<>"+userid+" order by t3.operatedate desc,t3.operatetime desc)"
					+">(select top 1 t2.operatedate+' '+t2.operatetime from GM_GoalLog t2 where t2.goalid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc))");
		}
	}else if(condtype.equals("0")){//能查看的所有
		//判断后台是否开放所有目标或是否为目标维护人
		if(cmutil.getGoalMaint(userid)[0]==0){
			sqlwhere.append(" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
					+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+user.getUID()+")"
					+ " or exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+user.getUID()+")"
					+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
					+ " or exists (select 1 from HrmResource hrm,GM_GoalPartner tp where tp.goalid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
					+ ")");
		}
		if(hrmid!=0){
			principalid = hrmid + "";
			sqlwhere.append(" and (t1.principalid="+hrmid+" or t1.creater="+hrmid
						+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+hrmid+"))");
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
	boolean canMaint = false;
	boolean canCreate = false;
	boolean canEdit = true;
	boolean canDrag = true;
	int right = 0;
	int index = 0;
	
	String enddate = "";
	
	int _pagesize = 10;
	int _total = 0;//总数
	
	int fbcount = 0;//反馈数
	boolean noreadfb = false;//是否有未读反馈
	boolean isnew = false;//最后未查看
	int special = 0;//是否标记为重要
	String lastviewdate = "";
	String lastfbdate = "";
	String creater = "";
	
	String tododate = "";
	int todotype = 4;
	String todoname = "";
	String taskid = "";
	
	canMaint = cmutil.getGoalMaint(userid)[0]==2?true:false;
	canCreate = cmutil.getGoalMaint(userid)[1]==1?true:false;
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
	<div id="listscroll" class="scroll1" style="width: 100%;height:100%;position: relative;top: 0px;left: 0px;background: url('../images/line.png') left repeat-y;">
		<%
			String[] datetype = {""};
			String[] datetitle = {""};
			String titlecolor = "";
			_pagesize = 30;
			if(sorttype==1){//列表
				_pagesize = 30;
			}else if(sorttype==2){//到日期
				datetype = new String[]{"已延期","今天到期","明天到期","以后到期","无到期日"};
				datetitle = new String[]{"结束日期小于今天的目标","结束日期为今天的目标","结束日期为明天的目标","结束日期大于明天的目标","未设置结束日期的目标"};
				titlecolor = "#008040";
			}else if(sorttype==3){//紧急程度
				datetype = new String[]{"财务效益类","客户运营类","内部经营类","学习成长类","备忘类"};
				datetitle = new String[]{"财务效益类","客户运营类","内部经营类","学习成长类","备忘类"};
			}else if(sorttype==4){//层级
				_pagesize = 30;
			}else if(sorttype==5){//Todolist
				datetype = new String[]{"今天","明天","即将","不标记","备忘"};
				datetitle = new String[]{"标记为【今天】的目标","标记为【明天】的目标","标记为【即将】的工作","无标记的目标","标记为【备忘】的工作"};
				titlecolor = "blue";
			}
			
			for(int i=0;i<datetype.length;i++){
		%>
		<%if(datetype.length>1){ %>
		<div id="sorttitle<%=i %>" class="sorttitle" style="<%=(!titlecolor.equals("")?"color:"+titlecolor:"") %>" title="点击收缩"><div class="sorticon"></div><div class="sorthead" title="<%=datetitle[i] %>"><%=datetype[i] %></div><div class="sortmore">...</div></div>
		<%} %>
		<table id="datalist<%=i %>" class="datalist" cellpadding="0" cellspacing="0" border="0" _datetype="<%=i+1%>">
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 44px;"></td><td style="width: 44px;"></td>
			</tr>
			<tr class="tr_blank">
				<td style="width: 23px;background: #EFEFEF;"></td><td style="width: 20px;"></td><td></td>
				<td style="width: 22px;"></td><td style="width: 44px;"></td><td style="width: 44px;"></td>
			</tr>
		<%
				if(sorttype==1){//列表
					_pagesize = 50;
				}else if(sorttype==2){//到日期
					if(i==0){
						typewhere = " and t1.enddate<>'' and t1.enddate is not null and t1.enddate<'"+currentdate+"'";
					}else if(i==1){
						typewhere = " and t1.enddate='"+currentdate+"'";
					}else if(i==2){
						typewhere = " and t1.enddate='"+TimeUtil.dateAdd(currentdate,1)+"'";
					}else if(i==3){
						typewhere = " and t1.enddate<>'' and t1.enddate is not null and t1.enddate>'"+TimeUtil.dateAdd(currentdate,1)+"'";
					}else{
						typewhere = " and (t1.enddate='' or t1.enddate is null)";
					}
				}else if(sorttype==3){//分类
					typewhere = " and t1.cate='"+datetype[i]+"'";
				}
				rs.executeSql(countsql+sqlwhere.toString()+typewhere);
				if(rs.next()){
					_total = rs.getInt(1);
				}
				String listsql = "";
				if("oracle".equals(rs.getDBType())){
					listsql = "select * from (select "+basesql+sqlwhere.toString()+typewhere+orderby+") t where rownum<="+_pagesize;
				}else{
					listsql = "select top "+_pagesize+basesql+sqlwhere.toString()+typewhere+orderby;
				}
				rs.executeSql(listsql);
				//System.out.println("select top "+_pagesize+basesql+sqlwhere.toString()+typewhere+orderby);
				while(rs.next()){
					if(canMaint){
						canEdit = true;
					}else{
						right = cmutil.getGoalRight(rs.getString("id"),user);
						if(right==2) canEdit = true; else canEdit = false;
					}
					
					if(sorttype==1){
						canDrag = false;
					}else{
						canDrag = canEdit;
					}
					_status = Util.getIntValue(rs.getString("status"),1);
					if(canEdit){
						if(_status==1){
							statustitle = "标记完成";
						}else if(_status==2 || _status==3){
							statustitle = "标记进行";
						}
					}else{
						if(_status==1) _status=0;
					}
					//_level = Util.getIntValue(rs.getString("level"),0);
					enddate = Util.null2String(rs.getString("enddate"));
					fbcount = Util.getIntValue(rs.getString("fbcount"),0);
					special = Util.getIntValue(rs.getString("special"),0);
					//isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
					//noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
					lastviewdate = Util.null2String(rs.getString("lastviewdate"));//最后查看时间
					lastfbdate = Util.null2String(rs.getString("lastfbdate"));//最后反馈时间
					creater = Util.null2String(rs.getString("creater"));
					if(creater.equals(userid)){
						isnew = false;
					}else{
						if(lastviewdate.equals("")){
							isnew = true;
						}else{
							isnew = false;
						}
					}
					if(!lastfbdate.equals("")){
						if(lastviewdate.equals("") || TimeUtil.dateInterval(lastviewdate,lastfbdate)>0){
							noreadfb = true;
						}else{
							noreadfb = false;
						}
					}else{
						noreadfb = false;
					}
					
					
					tododate = Util.null2String(rs.getString("tododate"));
					todotype = 4;
					todoname = "标记todo";
					if(!tododate.equals("")){
						if(tododate.equals("1")){
							todotype = 5;
							todoname = "备忘";
						}else if(TimeUtil.dateInterval(tododate,currentdate)>=0){
							todotype = 1;
							todoname = "今天";
						}else if(tododate.equals(TimeUtil.dateAdd(currentdate,1))){
							todotype = 2;
							todoname = "明天";
						}else{
							todotype = 3;
							todoname = "即将";
						}
					}	
					
					taskid = Util.null2String(rs.getString("id"));
		%>
			<tr id="item_tr_<%=taskid%>" class="item_tr" _taskid="<%=taskid%>">
				<td class='td_move<%if(canDrag){%> td_drag<%}%>' <%if(!canEdit){%>title="无权限编辑"<%}%>><div>&nbsp;</div></td>
				<td width="20px">
					<div id="status_<%=taskid %>" class="status status<%=_status%>">&nbsp;</div>
					<div id="todo_<%=taskid %>" class="<%if(_status==1 || _status==0){ %>div_todo<%} %>" style="" onclick="showTodo2(this)"
						title="<%=todoname %>" _val="<%=todotype%>" _taskid="<%=taskid %>"></div>
				</td>
				<td class='item_td'>
					<input type="text" <%if(!canEdit){%> readonly="readonly"<%}%> onfocus="doClickItem(this)" onblur='doBlurItem(this)' class="disinput <%if(isnew){%>newinput<%}%>" 
						id="<%=taskid %>" name="" <%if(sorttype==4){ %>_pid="-1"<%} %> title="<%=Util.null2String(rs.getString("name")) %>" 
						value="<%=Util.null2String(rs.getString("name")) %>" _index="<%=index++ %>"/>
				</td>
				<td class='item_count <%if(noreadfb){%>item_count_new<%}%>' _fbcount="<%=fbcount %>" <%if(noreadfb){%>title='有新反馈'<%}else if(fbcount>0){%>title='<%=fbcount %>条反馈'<%}%>>
					<%if(fbcount>0){%>(<%=fbcount %>)<%}else{%>&nbsp;<%}%>
				</td>
				<td style="text-align: center;">
					<div id="enddate_<%=taskid %>" class="div_enddate" title='<%=enddate%>'><%=this.convertdate(enddate) %></div>
				</td>
				<td class='item_hrm' title='责任人'><%=this.getHrmLink(rs.getString("principalid")) %></td>
			</tr>
			<div id="operate_<%=taskid %>" class="operatediv" _taskid="<%=taskid%>">
				<div class="operatebtn item_fb" onclick="quickfb(this)">反馈</div>
				<div class="operatebtn item_att" _special="<%=special %>" title="<%if(special==0){%>添加关注<%}else{%>取消关注<%}%>"><%if(special==0){%>添加关注<%}else{%>取消关注<%}%></div>
				<%if(canEdit){ %>
					<div class="operatebtn item_status" _status="<%=_status%>" onclick="changestatus(this)" title="<%=statustitle%>"><%=statustitle%></div>
				<%} %>
			</div>
		<%if(sorttype==4){ %>
			<%=this.getSubTask(rs.getString("id"),user,6,canEdit) %>
		<%} %>
		<%			
				}
		%>
		
		<%if(canCreate){ %>
			<tr id="" class='item_tr item_tr_blank' _taskid="">
				<td class="td_blank"><div>&nbsp;</div></td>
				<td width='20px'>
					<div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div>
					<div id='' class="div_todo" style='display:none' onclick='showTodo2(this)' title='' _val='' _taskid=''>&nbsp;</div>
				</td>
				<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' class='disinput addinput definput' type='text' name='' value='新建目标' id='' _index="<%=index++ %>"/></td>
				<td class='item_count'>&nbsp;</td>
				<td style="text-align: center;"><div id="" class="div_enddate" title=''>&nbsp;</div></td>
				<td class='item_hrm'>&nbsp;</td>
			</tr>
		<%} %>	
		</table>
		<%
				if(_total>_pagesize){
					request.getSession().setAttribute("TM_LIST_SQL_"+i,basesql+sqlwhere.toString()+typewhere);
		%>
			<div id="listmore<%=i+1 %>" class="listmore" onclick="getListMore(this)" _datalist="datalist<%=i %>" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _index="<%=i %>" _excludeids="" title="显示更多数据">更多</div>	
		<%		} %>
		<%
			}
		%>
		<div style="width: 100%;height: 30px;overflow: hidden;"></div>
	</div>
	<div id="floattitle" _index="" class="dtitle" onclick="showtitle()" style="position: absolute;top: 0px;left: 0px;display: none;background: #FCFCFC;">
		<div class="sorticon" style="background: none;"></div><div id="floathead" class="sorthead" style="<%=(!titlecolor.equals("")?"color:"+titlecolor:"") %>" title=""></div>
	</div>
	<script type="text/javascript">
			
			var searchstatus = "<%=status%>";
			var sorttype = "<%=sorttype%>";
			
			var index = <%=index++%>;

			principalid = "<%=principalid%>";
			tag = "<%=tag%>";

			createmain = <%=canCreate%>;

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
						dragStart:function(){
							$("div.operatediv").hide();
							dragstatus=1;
						},
						dragEnd: function(){
							dragstatus=0;
							if(sorttype==2 || sorttype==3 || sorttype==5){
								var dragobj = $(this).find("input.disinput");
								var newdatetype = $(this).parent().parent().attr("_datetype");
								var dragid = dragobj.attr("id");
								if(olddatetype!=newdatetype){
									$.ajax({
										type: "post",
									    url: "/workrelate/goal/data/Operation.jsp",
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
									    //if(newdatetype>5) newdatetype = 0;
								    	//$("#period_"+dragid).css("background","url('../images/level_0"+newdatetype+".png') center no-repeat").attr("title",leveltitle[newdatetype]);
									}
									//设置到期日
								    if(sorttype==2){
									    var enddate = "";
									    if(newdatetype==1){
									    	enddate = yesterday;
										}else if(newdatetype==2){
									    	enddate = currentdate;
										}else if(newdatetype==3){
									    	enddate = tomorrow;
										}else if(newdatetype==4){
									    	enddate = nextweek;
										}
									    $("#enddate_"+dragid).html(convertdate(enddate)).attr("title",enddate);
									}
									//更改标todo记
									if(sorttype==5){
										var todoname = "标记todo";
										if(newdatetype==1){
											todoname = "今天";
										}else if(newdatetype==2){
											todoname = "明天";
										}else if(newdatetype==3){
											todoname = "即将";
										}
										$("#todo_"+dragid).attr("_val",newdatetype).attr("title",todoname);
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
					if($(this).nextAll("table:first").css("display")=="none"){
						$(this).nextAll("table:first").show().next("div.listicon").show().next("div.listmore").show();
						$(this).attr("title","点击收缩");
						$(this).find("div.sortmore").hide();
						$(this).nextAll("div.listmore:first").show();
					}else{
						$(this).nextAll("table:first").hide().next("div.listicon").hide().next("div.listmore").hide();
						$(this).attr("title","点击展开");
						$(this).find("div.sortmore").show();
						$(this).nextAll("div.listmore:first").hide();
					}
					
				});

				/**
				$("div.listmore").bind("mouseover",function(){
					$(this).addClass("listmore_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("listmore_hover");
				});*/
				
				$('#listscroll').perfectScrollbar({"wheelSpeed": 40});
				$("#listscroll").scroll(function(){
					if($('#ltodopanel').css("display")=="block"){
						$('#ltodopanel').hide();
						//var todotaskid = $('#ltodopanel').attr("_taskid");
						//showTodo2($("#todo_"+todotaskid));
					}

					<%if(datetype.length>1){%>
					
					//var scrollh = $(this).scrollTop();
					//$("#floattitle").css("top",scrollh);
					var tp = 0;
					for(var i=<%=datetype.length%>-1;i>-1;i--){
						if(tp>=0){
							tp = $("#sorttitle"+i).position().top;
							if(tp<0){
								$("#floathead").html($("#sorttitle"+i).children("div.sorthead").html());
								$("#floattitle").attr("_index",i).show();
							}
						}
					}
					if(tp>=0) $("#floattitle").hide();
					<%}%>
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
	public String getSubTask(String maintaskid,User user,int colspan,boolean canEdit) throws Exception{
		String userid = user.getUID()+"";
		StringBuffer res = new StringBuffer();
		RecordSet rs = new RecordSet();
		CommonTransUtil cmutil = new CommonTransUtil();
		String basesql = "";
		if(rs.getDBType().equals("oracle")){
			basesql = "select t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.attribute,t1.begindate,t1.enddate,t1.createdate,t1.createtime "
					+",(select count(tfb.id) from GM_GoalFeedback tfb where tfb.taskid=t1.id) as fbcount"
					+",(select v.viewdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as viewdate,goalid from GM_GoalLog where type=0 and operator="+userid +" order by operatedate desc,operatetime desc) v where v.goalid=t1.id and rownum=1) as lastviewdate"
					+",(select v.lastfbdate from (select CONCAT(CONCAT(createdate,' '),createtime) as lastfbdate,goalid from GM_GoalFeedback where hrmid<>"+userid+" order by createdate desc,createtime desc) v where v.goalid=t1.id and rownum=1) as lastfbdate"
					+",nvl((select distinct 1 from GM_GoalSpecial tts where tts.goalid=t1.id and tts.userid="+userid+"),0) as special"
					+",(select v.lastoperatedate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as lastoperatedate,goalid from GM_GoalLog where type<>0 order by operatedate desc,operatetime desc) v where v.goalid=t1.id and rownum=1) as lastoperatedate"
					+" from GM_GoalInfo t1 "
					+" where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid
					+ " and (t1.principalid="+userid+" or t1.creater="+userid
					+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+"))"
					+ " order by lastoperatedate desc";
		}else{
			basesql = "select t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.attribute,t1.begindate,t1.enddate,t1.createdate,t1.createtime "
					+",(select count(tfb.id) from GM_GoalFeedback tfb where tfb.taskid=t1.id) as fbcount"
					+",(select top 1 tlog.operatedate+' '+tlog.operatetime from GM_GoalLog tlog where tlog.goalid=t1.id and tlog.type=0 and tlog.operator="+userid+" order by tlog.operatedate desc,tlog.operatetime desc) as lastviewdate"
					+",(select top 1 fb.createdate+' '+fb.createtime from GM_GoalFeedback fb where fb.goalid=t1.id and fb.hrmid<>"+userid+" order by fb.createdate desc,fb.createtime desc) as lastfbdate"
					+",isnull((select distinct 1 from GM_GoalSpecial tts where tts.goalid=t1.id and tts.userid="+userid+"),0) as special"
					+",(select top 1 tlog.operatedate+' '+tlog.operatetime from GM_GoalLog tlog where tlog.goalid=t1.id and tlog.type<>0 order by tlog.operatedate desc,tlog.operatetime desc) as lastoperatedate"
					+" from GM_GoalInfo t1 "
					+" where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid
					+ " and (t1.principalid="+userid+" or t1.creater="+userid
					+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+"))"
					+ " order by lastoperatedate desc";
		}	
		rs.executeSql(basesql);
		//if(rs.getCounts()>0){
			res.append("<tr class='subtable_tr'>"+(colspan==6?"<td class='td_blank' style='padding:0px;border:0px;height:auto'></td>":"")+"<td colspan='"+(colspan==6?colspan-1:colspan)+"' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'>"
				+"<colgroup><col width='20px'/><col width='*'/><col width='22px'/><col width='40px'/><col width='40px'/></colgroup>");
					
			String statustitle = "";
			int _status = 0;
			//boolean canEdit = true;
			int right = 0;
			int index = 0;
			String enddate = "";
			
			int fbcount = 0;//反馈数
			boolean noreadfb = false;//是否有未读反馈
			boolean isnew = false;//最后未查看
			int special = 0;//是否标记为重要
			String specialname = "";
			String lastviewdate = "";
			String lastfbdate = "";
			String creater = "";
			String taskid = "";
			String tododate = "";
			int todotype = 4;
			String todoname = "";
			String currentdate = TimeUtil.getCurrentDateString();
			while(rs.next()){
				taskid = Util.null2String(rs.getString("id"));
				//right = cmutil.getGoalRight(taskid,user);
				//if(right==2) canEdit = true; else canEdit = false;
				
				_status = rs.getInt("status");
				if(canEdit){
					if(_status==1){
						statustitle = "标记完成";
					}else if(_status==2 || _status==3){
						statustitle = "标记进行";
					}
				}else{
					if(_status==1) _status=0;
				}
				enddate = Util.null2String(rs.getString("enddate"));
				fbcount = Util.getIntValue(rs.getString("fbcount"),0);
				special = Util.getIntValue(rs.getString("special"),0);
				if(special==0){
					specialname = "添加关注";
				}else{
					specialname = "取消关注";
				}
				//isnew = (Util.getIntValue(rs.getString("viewtag"),0)==0)?true:false;
				//noreadfb = (Util.getIntValue(rs.getString("noreadtag"),0)==1)?true:false;
				lastviewdate = Util.null2String(rs.getString("lastviewdate"));//最后查看时间
				lastfbdate = Util.null2String(rs.getString("lastfbdate"));//最后反馈时间
				creater = Util.null2String(rs.getString("creater"));
				if(creater.equals(userid)){
					isnew = false;
				}else{
					if(lastviewdate.equals("")){
						isnew = true;
					}else{
						isnew = false;
					}
				}
				if(!lastfbdate.equals("")){
					if(lastviewdate.equals("") || TimeUtil.dateInterval(lastviewdate,lastfbdate)>0){
						noreadfb = true;
					}else{
						noreadfb = false;
					}
				}else{
					noreadfb = false;
				}
				tododate = Util.null2String(rs.getString("tododate"));
				todotype = 4;
				todoname = "标记todo";
				if(!tododate.equals("")){
					if(TimeUtil.dateInterval(tododate,currentdate)>=0){
						todotype = 1;
						todoname = "今天";
					}else if(tododate.equals(TimeUtil.dateAdd(currentdate,1))){
						todotype = 2;
						todoname = "明天";
					}else{
						todotype = 3;
						todoname = "即将";
					}
				}
				
				res.append("<tr id='item_tr_"+taskid+"' class='item_tr' _taskid='"+taskid+"'>");
				//res.append("<td class='' "+(!canEdit?"title='无权限编辑'":"")+"><div>&nbsp;</div></td>");
				res.append("<td width='20px' class='td_status'><div id=\"status_"+taskid+"\" class=\"status status"+_status+"\">&nbsp;</div>");
				res.append("<div id='todo_"+taskid+"' class='"+((_status==1 || _status==0)?"div_todo":"")+"'  onclick='showTodo2(this)'"
						+" title='"+todoname+"' _val='"+todotype+"' _taskid='"+taskid+"'></div></td>");
				res.append("<td class='item_td'><input "+(!canEdit?" readonly='readonly'":"")+" onfocus=\"doClickItem(this)\" onblur='doBlurItem(this)' class=\"disinput "+(isnew?"newinput":"")+"\" type=\"text\" name=\"\" id=\""+taskid+"\" _pid=\""+maintaskid+"\" title=\""+Util.null2String(rs.getString("name"))+"\" value=\""+Util.null2String(rs.getString("name"))+"\" _index=\""+(index++)+"\"/></td>");
				res.append("<td class='item_count "+(noreadfb?"item_count_new":"")+"' _fbcount=\""+fbcount+"\" ");
				if(noreadfb){
					res.append("title='有新反馈'");
				}else if(fbcount>0){
					res.append("title='"+fbcount+"条反馈'");
				}
				res.append(">"+(fbcount>0?"("+fbcount+")":"&nbsp;")+"</td>");
				res.append("<td style='text-align: center;'>");
				res.append("<div id='enddate_"+taskid+"' class='div_enddate' title='"+enddate+"'>"+this.convertdate(enddate)+"</div>");
				res.append("</td>");
				//res.append("<td><div id=\"today_"+rs.getString("id")+"\" class=\"div_today\" "+(isToday?"title='今天的目标'":"")+" >"+(isToday?"今天":"&nbsp;")+"</div></td>");
				res.append("<td class='item_hrm' title='责任人'>"+this.getHrmLink(rs.getString("principalid"))+"</td>");
				res.append("</tr>");
				res.append("<div id='operate_"+taskid+"' class='operatediv' _taskid='"+taskid+"'>");
				res.append("<div class='operatebtn item_fb' onclick='quickfb(this)'>反馈</div>");
				res.append("<div class='operatebtn item_att' _special='"+special+"' title='"+specialname+"'>"+specialname+"</div>");
				if(canEdit){
					res.append("<div class='operatebtn item_status' _status='"+_status+"' onclick='changestatus(this)' title='"+statustitle+"'>"+statustitle+"</div>");
				}
				res.append("</div>");
				res.append(this.getSubTask(taskid,user,5,canEdit));
			}
			res.append("</table></td></tr>");
		//}
		
		return res.toString();
	}
	private String convertdate(String datestr){
		datestr = Util.null2String(datestr);
		if(datestr.length()==10){
			datestr = datestr.substring(5).replace("-",".");
		}
		return datestr;
	}
%>