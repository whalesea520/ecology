<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%	
	String userid = user.getUID()+"";
	String principalid = userid;
	String basesql = "";
	
	String func1 = "";
	String operatedt = "";
	String createdt = "";
	if(!"oracle".equals(rs.getDBType())){
		func1 = "isnull";
		operatedt = "max(operatedate+' '+operatetime)";
		createdt = "max(createdate+' '+createtime)";
	}else{
		func1 = "nvl";
		operatedt = "max(CONCAT(CONCAT(operatedate,' '),operatetime))";
		createdt = "max(CONCAT(CONCAT(createdate,' '),createtime))";
	}
	
	basesql = " t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.lev,t1.begindate,t1.enddate,t1.createdate,t1.createtime,t1.showallsub "
			+",(select count(tfb.id) from TM_TaskFeedback tfb where tfb.taskid=t1.id) as fbcount"
			+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type=0 and tlog.operator="+userid+") as lastviewdate"
			+",(select "+createdt+" from TM_TaskFeedback fb where fb.taskid=t1.id and fb.hrmid<>"+userid+") as lastfbdate"
			+","+func1+"((select distinct 1 from TM_TaskSpecial tts where tts.taskid=t1.id and tts.userid="+userid+"),0) as special"
			+",(select max(tt.tododate) from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+user.getUID()+") as tododate"
			+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type not in (0,11,12)) as lastoperatedate"
			+" from TM_TaskInfo t1 "
			+" where (t1.deleted=0 or t1.deleted is null)";
	
	String countsql = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)";
	String typewhere = "";
	StringBuffer sqlwhere = new StringBuffer();
	//String orderby = " order by lastoperatedate desc";
	String currentdate = TimeUtil.getCurrentDateString();
	int sorttype = Util.getIntValue(request.getParameter("sorttype"),2);//分类排序类型
	int status = Util.getIntValue(request.getParameter("status"),1);
	if(sorttype==5) status=1;//Todolist视图是显示进行中
	
	//String datatype = Util.null2String(request.getParameter("datatype"));
	String condtype = Util.null2String(request.getParameter("condtype"));
	int hrmid = Util.getIntValue(request.getParameter("hrmid"),0);
	String tag = Util.null2String(URLDecoder.decode(request.getParameter("tag"),"utf-8"));
	if(condtype.equals("7")){
		status=2;//新完成的任务 状态为完成
		sorttype=1;//列表展示
	}
	
	if(condtype.equals("1")){//本人相关的任务
		sqlwhere.append(" and (t1.principalid="+userid//+" or t1.creater="+userid
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))");
	}else if(condtype.equals("2")){//本人创建的任务
		sqlwhere.append(" and t1.creater="+userid);
	}else if(condtype.equals("3")){//本人负责的任务
		sqlwhere.append(" and t1.principalid="+userid);
	}else if(condtype.equals("4")){//本人参与的任务
		sqlwhere.append(" and exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")");
	}else if(condtype.equals("5")){//被分享的任务
		sqlwhere.append(" and exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")");
	}else if(condtype.equals("6")){//标记关注的任务
		sqlwhere.append(" and exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")");
	}else if(condtype.equals("7")){//已完成新反馈的任务
		sqlwhere.append(" and t1.status=2 and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
				+ " or exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")"
				+ ")");
	
		sqlwhere.append(" and ("+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))");
		
	}else if(condtype.equals("8")){//我分配的任务
		sqlwhere.append(" and t1.creater="+userid+" and t1.principalid<>"+userid);
	}else{//能查看的所有任务
		sqlwhere.append(" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
		+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
		+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
		+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
		+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
		+ ")");
		if(hrmid!=0){
			principalid = hrmid + "";
			sqlwhere.append(" and (t1.principalid="+hrmid //+" or t1.creater="+hrmid
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+hrmid+"))");
		}
		if(!tag.equals("")){
			sqlwhere.append(" and t1.tag like '%,"+tag+",%'");
		}
	}
	if(status!=0) sqlwhere.append(" and t1.status="+status);
	
	if(sorttype==4) sqlwhere.append(" and (t1.parentid='' or t1.parentid is null)");
	
	int index = 0;
	
	int _pagesize = 10;
	int _total = 0;//总数
%>
<style type="text/css">
	<%if(sorttype!=0){%>
	.td_drag{cursor: move !important;}
	.tr_hover .td_drag{background: url('/workrelate/task/images/sprite.png') no-repeat -97px -748px;background-color: #F9F9F9 !important;}
	.tr_hover .td_move,.tr_hover .td_blank{background-color: #F9F9F9 !important;border-right-color: #F9F9F9;border-top-color: #fff !important;}
	.tr_hover .td_drag div{display: none;}
	
	.tr_select .td_drag{background: url('/workrelate/task/images/sprite.png') no-repeat -97px -748px;background-color: #CEE4FF !important;border-right-color: #CEE4FF;border-top-color: #fff !important;border-bottom-color: #75B4FF !important;}
	.tr_select .td_move,.tr_select .td_blank{background-color: #CEE4FF !important;border-right-color: #CEE4FF;border-top-color: #fff !important;border-bottom-color: #75B4FF !important;}
	.tr_select .td_drag div{display: none;}
	.tr_select div.status1{background: url('/workrelate/task/images/ing.png') center no-repeat;}
	<%}%>
</style>
	<div id="listscroll" class="scroll1" style="width: 100%;height:100%;position: relative;top: 0px;left: 0px;">
		<%
			String[] datetype = {""};
			String[] datetitle = {""};
			String titlecolor = "";
			_pagesize = 20;
			if(sorttype==1){//列表
				_pagesize = 10;
			}else if(sorttype==2){//到日期
				datetype = new String[]{"已延期","今天到期","明天到期","以后到期","无到期日"};
				datetitle = new String[]{"结束日期小于今天的任务","结束日期为今天的任务","结束日期为明天的任务","结束日期大于明天的任务","未设置结束日期的任务"};
				titlecolor = "#008040";
			}else if(sorttype==3){//紧急程度
				datetype = new String[]{"非常高","高","中","低","未设置"};
				datetitle = new String[]{"紧急程度为重要紧急的任务","紧急程度为重要不紧急的任务","紧急程度为不重要紧急的任务","紧急程度为不重要不紧急的任务","未设置紧急程度的任务"};
			}else if(sorttype==4){//层级
				_pagesize = 10;
			}else if(sorttype==5){//Todolist
				datetype = new String[]{"今天","明天","即将","不标记","备忘"};
				datetitle = new String[]{"标记为【今天】的任务","标记为【明天】的任务","标记为【即将】的工作","无标记的任务","标记为【备忘】的工作"};
				titlecolor = "#3c4350";
			}
			for(int i=0;i<datetype.length;i++){
		%>
		<%if(datetype.length>1){ %>
		<div id="sorttitle<%=i %>" class="sorttitle" style="<%=(!titlecolor.equals("")?"color:"+titlecolor:"") %>" title="点击收缩">
		<div class="sorthead" title="<%=datetitle[i] %>"><%=datetype[i] %></div>
		<div class="sortmore">...</div></div>
		<%} %>
		<table id="datalist<%=i %>" class="datalist" cellpadding="0" cellspacing="0" border="0" _datetype="<%=i+1%>">
		<%
				if(sorttype==1){//列表
					_pagesize = 10;
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
				}else if(sorttype==3){//紧急程度
					if(i==4){
						typewhere = " and (t1.lev=0 or t1.lev is null)";
					}else{
						typewhere = " and t1.lev="+(i+1);
					}
				}else if(sorttype==4){//层级
					_pagesize = 10;
				}else if(sorttype==5){//Todolist
					if(i==0){
						typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+principalid+" and tt.tododate<='"+currentdate+"')";
					}else if(i==1){
						typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+principalid+" and tt.tododate='"+TimeUtil.dateAdd(currentdate,1)+"')";
					}else if(i==2){
						typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+principalid+" and tt.tododate>'"+TimeUtil.dateAdd(currentdate,1)+"')";
					}else if(i==3){
						typewhere = " and not exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+principalid+")";
					}else if(i==4){
						typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate='1' and tt.userid="+principalid+")";
					}
				}
				
				rs.executeSql(countsql+sqlwhere.toString()+typewhere);
				if(rs.next()){
					_total = rs.getInt(1);
				}
		%>
			<tr id="" class='item_tr_blank' _taskid="">
				<td class='item_td'>
					<div class="newInputDiv">
						<input onfocus='doClickItem(this)' onblur='doBlurItem(this)' 
							class='disinput addinput definput' type='text' name='' value='新建任务' id='' _index="<%=index++ %>"/>
					</div>
				</td>
			</tr>
			
		</table>
		<%
				if(_total>0){
					request.getSession().setAttribute("TM_LIST_SQL_"+i,basesql+sqlwhere.toString()+typewhere);
					request.getSession().setAttribute("TM_COUNT_SQL_"+i,countsql+sqlwhere.toString()+typewhere);
		%>
			<div id="listmore<%=i+1 %>" class="listmore" onclick="getListMore(this)" _datalist="datalist<%=i %>" _currentpage="0" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _index="<%=i %>" _excludeids="" title="显示更多数据">更多</div>	
			<script type="text/javascript">getListMore("#listmore<%=i+1 %>")</script>
		<%		} %>
		<%
			}
		%>
		<div style="width: 100%;height: 30px;overflow: hidden;background:#fff;"></div>
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

			//初始绑定事件
			$(document).ready(function(){
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
				$('#listscroll').perfectScrollbar({"wheelSpeed": 40});
				setIndex();
			});
		</script>