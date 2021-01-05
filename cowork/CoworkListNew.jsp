
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link type="text/css" href="/cowork/css/coworkNew_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/cowork/js/coworkUtil_wev8.js"></script>

<!-- 滚动条控件 -->
<link rel="stylesheet" href="/email/js/jscrollpane/jquery.jscrollpane_wev8.css" />
<script type="text/javascript" src="/email/js/jscrollpane/jquery.mousewheel_wev8.js"></script>
<script type="text/javascript" src="/email/js/jscrollpane/jquery.jscrollpane.min_wev8.js"></script>
</head>

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
int userid=user.getUID();
// 查看类型
String type = Util.null2String(request.getParameter("type"));
//关注的或者直接参与的协作
String viewType = Util.null2String(request.getParameter("viewtype"));
//排序方式
String orderType = Util.null2String(request.getParameter("orderType"),"unread");
//是否是搜索操作
String isSearch = Util.null2String(request.getParameter("isSearch"));
//关键字
String name =URLDecoder.decode( Util.null2String(request.getParameter("name")));
//协作区ID
String typeid = Util.null2String(request.getParameter("typeid"));
//协作状态
String status = Util.null2String(request.getParameter("status"));
//参与类型
String jointype = Util.null2String(request.getParameter("jointype"));
// 创建者
String creater = Util.null2String(request.getParameter("creater"));
//负责人
String principal = Util.null2String(request.getParameter("principal"));
//开始时间
String startdate = Util.null2String(request.getParameter("startdate"));
// 结束时间
String enddate = Util.null2String(request.getParameter("enddate"));

String labelid=Util.null2String(request.getParameter("labelid"));

int index=Util.getIntValue(request.getParameter("index"));                 //下标 
int pagesize=Util.getIntValue(request.getParameter("pagesize"));           //每一次取多少
String disattention=Util.null2String(request.getParameter("disattention"));
String disdirect=Util.null2String(request.getParameter("disdirect"));

String projectid=Util.null2String(request.getParameter("projectid"));
String taskIds=Util.null2String(request.getParameter("taskIds"));
int layout=Util.getIntValue(Util.null2String(request.getParameter("layout"),"1"));

String paramsStr="type="+type+"&orderType="+orderType+"&isSearch="+isSearch+"&name="+name+"&typeid="+typeid
+"&status="+status+"&jointype="+jointype+"&creater="+creater+"&principal="+principal+"&startdate="+startdate+"&enddate="+enddate+"&labelid="+labelid;

%>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
	<BODY>
	
	<style>
		<%if(layout==1){%>
			TABLE.ListStyle TR.HeaderForXtalbe{
				display:none;
			}
			.xTable_info{position:fixed;bottom:0px;width:100%}
		<%}%>
	</style>
	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<form id="mainform" action="CoworkListNew.jsp" method="post" >
			<input type="hidden" name="jointype" id="jointype" value="<%=jointype%>"/>
			<input type="hidden" name="orderType" id="orderType" value="<%=orderType%>"/>
			<input type="hidden" name="type" id="type" value="<%=type%>"/>
			<input type="hidden" name="typeid" id="typeid" value="<%=typeid%>"/>
			<input type="hidden" name="layout" id="layout" value="<%=layout%>"/>
			
		</form>
		<div id="listoperate">
		
			<div id="checkType"  class="main_btn menuitem1" style="width:45px;" onclick="showMenu(this,'checkTypeMenu',event)">
				<div class="menuitem1-l">
					<span id="checkBox"><input id="chkALL" type="checkbox"/></span>
					<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
				</div>
			</div>
		
			<div id="joinType"  class="main_btn menuitem1" style="width:75px;" onclick="showMenu(this,'joinTypeMenu',event)">
				<div class="menuitem1-l" style="padding-left: 10px;">
					<span id="joinTypeName"><%=SystemEnv.getHtmlLabelName(83228,user.getLanguage())%></span>
					<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
				</div>
			</div>
			
			<div id="sortType"  class="main_btn menuitem1" style="width:75px;" onclick="showMenu(this,'orderTypeMenu',event)">
				<div class="menuitem1-l" style="padding-left: 10px;">
					<span id="orderTypeName"><%=SystemEnv.getHtmlLabelName(83229,user.getLanguage())%></span>
					<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
				</div>
			</div>
			
			<div id="markType"  class="main_btn menuitem1" style="width:80px;margin-right: 3px;" onclick="showMenu(this,'markTypeMenu',event)">
				<span id="sortTypeName"><%=SystemEnv.getHtmlLabelName(81293,user.getLanguage())%>...</span>
				<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
			</div>
			
			<div id="layout" class="main_btn menuitem2" style="width:70px;">
				<div class="userLayout<%=layout%>" style="background: url('');" id="changeBk" _xuhao=0>
					<div class="layout" value="1" _currentLayout="<%=layout%>" style="background:url('/cowork/images/layout<%=layout==1?"_a":""%>_1_wev8.png') no-repeat center center;"></div>
					<div class="layout" value="2" _currentLayout="<%=layout%>" style="background:url('/cowork/images/layout<%=layout==2?"_a":""%>_2_wev8.png') no-repeat center center;"></div>
				</div>
			</div>
			
	    </div>
	    
	    <div id="checkTypeMenu" class="drop_list" style="width:65px;">
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType=""><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%></div><!-- 全部 -->
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType="1"><%=SystemEnv.getHtmlLabelName(83230,user.getLanguage())%></div><!-- 全部 -->
		    <div class="btn_add_type" onclick="changeJoinType(this)" _joinType="2"><%=SystemEnv.getHtmlLabelName(25425,user.getLanguage())%></div><!-- 全部 -->
		    <div class="btn_add_type" onclick="changeJoinType(this)" _joinType="3"><%=SystemEnv.getHtmlLabelName(25426,user.getLanguage())%></div><!-- 任务 -->
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType="4"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></div><!-- 流程 -->
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType="5"><%=SystemEnv.getHtmlLabelName(2088,user.getLanguage())%></div><!-- 流程 -->			
		</div>
	    
	    <div id="joinTypeMenu" class="drop_list" style="width:75px;">
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType=""><%=SystemEnv.getHtmlLabelName(83228,user.getLanguage())%></div><!-- 全部 -->
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType="1"><%=SystemEnv.getHtmlLabelName(83231,user.getLanguage())%></div><!-- 全部 -->
		    <div class="btn_add_type" onclick="changeJoinType(this)" _joinType="2"><%=SystemEnv.getHtmlLabelName(26933,user.getLanguage())%></div><!-- 全部 -->
		    <div class="btn_add_type" onclick="changeJoinType(this)" _joinType="3"><%=SystemEnv.getHtmlLabelName(83232,user.getLanguage())%></div><!-- 任务 -->
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType="4"><%=SystemEnv.getHtmlLabelName(83233,user.getLanguage())%></div><!-- 流程 -->
			<div class="btn_add_type" onclick="changeJoinType(this)" _joinType="5"><%=SystemEnv.getHtmlLabelName(83234,user.getLanguage())%></div><!-- 流程 -->	    
		</div>
		
		<div id="orderTypeMenu" class="drop_list" style="width:75px;">
				<div class="btn_add_type" onclick="changeOrderType(this)" _orderType="unread"><%=SystemEnv.getHtmlLabelName(83229,user.getLanguage())%></div><!-- 全部 -->
				<div class="btn_add_type" onclick="changeOrderType(this)" _orderType="important"><%=SystemEnv.getHtmlLabelName(83235,user.getLanguage())%></div><!-- 全部 -->
			    <div class="btn_add_type" onclick="changeOrderType(this)" _orderType="replyNum"><%=SystemEnv.getHtmlLabelName(83236,user.getLanguage())%></div><!-- 全部 -->
			    <div class="btn_add_type" onclick="changeOrderType(this)" _orderType="readNum"><%=SystemEnv.getHtmlLabelName(83237,user.getLanguage())%></div><!-- 任务 -->		
		</div>
		
		<div id="markTypeMenu" class="drop_list" style="width:120px;">
				<div class="btn_add_type" onclick="markItemAsType(this)" _markType="read"><%=SystemEnv.getHtmlLabelName(25425,user.getLanguage())%></div><!-- 全部 -->
				<div class="btn_add_type" onclick="markItemAsType(this)" _markType="unread"><%=SystemEnv.getHtmlLabelName(25426,user.getLanguage())%></div><!-- 全部 -->
				<div class="line-1"><div></div></div>
			    <div class="btn_add_type" onclick="markItemAsType(this)" _markType="important"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></div><!-- 全部 -->
			    <div class="btn_add_type" onclick="markItemAsType(this)" _markType="normal"><%=SystemEnv.getHtmlLabelName(25422,user.getLanguage())%></div><!-- 任务 -->
			    <div class="line-1"><div></div></div>
			    <div class="btn_add_type" onclick="markItemAsType(this)" _markType="hidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%></div><!-- 全部 -->
			    <div class="btn_add_type" onclick="markItemAsType(this)" _markType="show"><%=SystemEnv.getHtmlLabelName(25424,user.getLanguage())%></div><!-- 任务 -->		
			    <div class="line-1"><div></div></div>
			    <%
			    RecordSet.execute("select id,name,labelColor,textColor from cowork_label where userid="+userid+" and labelType='label' order by labelOrder ");
			    while(RecordSet.next()){
			    	String labelId=RecordSet.getString("id");
			    	String labelName=RecordSet.getString("name");
			    	String labelColor =RecordSet.getString("labelColor");
			    %>
			    <div onclick="stopBubble(event)" class="btn_add_label" _markType="label" _labelid="<%=labelId%>">
			    	<input type="checkbox" value="<%=labelId%>" name="labelcheck">
			    	<span  style="background-color:<%=labelColor%>;color: white;padding-left:5px;padding-right:5px;line-height: 22px;"><%=labelName%></span>
			    </div>
			    <%}%>
			    <div class="btn_add_label">
			    	<div style="float: left;" onclick="applyLabels()"><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></div>
			    	<div style="float: right;" onclick="openLabelSet()"><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></div>
			    	<div style="clear: left;"></div>
			    </div>
		</div>
	    
		<div>	
			<%
			String searchStr=" 1=1 ";
			if(!name.equals("")){
				searchStr += " and name like '%"+name+"%' "; 
			}
			if(!typeid.equals("")){
				searchStr += "  and typeid in("+typeid+")  ";
			}
			if(!status.equals("")){
				searchStr += " and status ="+status+"";
			}else
				searchStr += " and status =1";
			
			if(jointype.equals("")){        //参与 关注
				searchStr += " and jointype is not null";
			}else if(jointype.equals("1")){ //关注
				searchStr += " and jointype=1";
			}else if(jointype.equals("2")){ //参与
				searchStr += " and jointype=0";
			}else if(jointype.equals("3")){ //负责
				searchStr += " and principal="+userid;
			}else if(jointype.equals("4")){ //创建
				searchStr += " and creater="+userid;
			}else if(jointype.equals("5")){ //审批 approvalAtatus=0 表示需要审批但还未审批，协作管理员才有审批权限
				searchStr += " and (isApproval=1 and approvalAtatus=1 and cotypeid is not null) ";
			}
			
			if(!creater.equals("")){
				searchStr += " and creater='"+creater+"'  ";
			}
			if(!principal.equals("")){
				searchStr += " and principal='"+principal+"'  "; 
			}
			if(!startdate.equals("")){
				searchStr +=" and begindate >='"+startdate+"'  ";
			}
			if(!enddate.equals("")){
				searchStr +=" and enddate <='"+enddate+"'  ";
			}
			    
			  
			  if(!projectid.equals("")){
				   if ("oracle".equals(RecordSet.getDBType())) {
				       searchStr +=" and mutil_prjs||',' like '%"+projectid+",%'";
				   } else if ("sqlserver".equals(RecordSet.getDBType())) {
				       searchStr +=" and mutil_prjs+',' like '%"+projectid+",%'";
				   } else if ("mysql".equals(RecordSet.getDBType())) {
				       searchStr +=" and concat(mutil_prjs, ',') like '%"+projectid+",%'";
				   }
			  }
			  if(!CustomerID.equals("")){
				   if ("oracle".equals(RecordSet.getDBType())) {
				       searchStr += " and relatedcus||',' like '%"+CustomerID+",%'";
				   } else if ("sqlserver".equals(RecordSet.getDBType())) {
				       searchStr += " and relatedcus+',' like '%"+CustomerID+",%'";
				   } else if ("mysql".equals(RecordSet.getDBType())) {
				       searchStr +=" and concat(relatedcus, ',') like '%"+CustomerID+",%'";
				   }
			  }
			 if(!taskIds.equals("")){
					 searchStr +=" and id in ("+taskIds+")";
			   } 
			   
			String sqlStr ="";
			
			int departmentid=user.getUserDepartment();   //用户所属部门
			int subCompanyid=user.getUserSubCompany1();  //用户所属分部
			String seclevel=user.getSeclevel();          //用于安全等级
			
			int iTotal =Util.getIntValue(request.getParameter("total"),0);
			int iNextNum =index;
			int ipageset = pagesize;
			if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
			if(iTotal < pagesize) ipageset = iTotal;
			sqlStr="("+
					" select t1.id,t1.name,t1.status,t1.typeid,t1.creater,t1.principal,t1.begindate,t1.enddate,t1.replyNum,t1.readNum,t1.lastdiscussant,t1.lastupdatedate,t1.lastupdatetime,t1.isApproval,t1.approvalAtatus,t1.isTop,t2.cotypeid,"+
					" case when  t3.sourceid is not null then 1 when t2.cotypeid is not null then 0 end as jointype,"+
					" case when  t4.coworkid is not null then 0 else 1 end as isnew,"+
					" case when  t5.coworkid is not null then 1 else 0 end as important,"+
					" case when  t6.coworkid is not null then 1 else 0 end as ishidden"+
					(type.equals("label")?" ,case when  t7.coworkid is not null then 1 else 0 end as islabel":"")+
					" from cowork_items  t1 left join "+
					//关注的协作
					" (select distinct cotypeid from  cotype_sharemanager where (sharetype=1 and sharevalue like '%,"+userid+",%' )"+
					" or (sharetype=2 and sharevalue like '%,"+departmentid+",%' and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax) "+
					" or (sharetype=3 and sharevalue like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
					" or (sharetype=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and  sharevalue=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
					" or (sharetype=5 and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
					" )  t2 on t1.typeid=t2.cotypeid left join "+
			        //直接参与的协作
					" (select distinct sourceid from coworkshare where"+
					" (type=1 and  (content='"+userid+"' or content like '%,"+userid+",%') )"+
					" or (type=2 and content like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax) "+
					" or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
					" or (type=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and content=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
					" or (type=5 and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
					" )  t3 on t3.sourceid=t1.id"+
			        //阅读|重要|隐藏
					" left join (select distinct coworkid,userid from cowork_read where userid="+userid+")  t4 on t1.id=t4.coworkid"+       //阅读状态
					" left join (select distinct coworkid,userid from cowork_important where userid="+userid+" )  t5 on t1.id=t5.coworkid"+ //重要性
					" left join (select distinct coworkid,userid from cowork_hidden where userid="+userid+" )  t6 on t1.id=t6.coworkid"+    //是否隐藏
					(type.equals("label")?" left join (select distinct coworkid from cowork_item_label where labelid="+labelid+") t7 on t1.id=t7.coworkid":"")+ 
					" ) t ";
			
					if("unread".equals(type)){
						searchStr=searchStr+" and isnew=1 and ishidden<>1";
					}else if("important".equals(type)){
						searchStr=searchStr+" and important=1 and ishidden<>1";
					}else if("hidden".equals(type)){
						searchStr=searchStr+" and ishidden=1";
					}else if("all".equals(type)){
						searchStr=searchStr+" and ishidden<>1";
					}else if("label".equals(type)){
			        	searchStr=searchStr+" and ishidden<>1 and islabel=1";
			        }
					searchStr=searchStr+" and (approvalAtatus=0 or (approvalAtatus=1 and (creater="+userid+" or principal="+userid+" or cotypeid is not null))) ";
			
			String total="0";
			String totalSql="select count(*) as total from "+sqlStr+" where "+searchStr;
			RecordSet.execute(totalSql);
			if(RecordSet.next()){
				total=RecordSet.getString("total");
			}
					
			String tableString = "";
			int perpage=20;                                 
			String backfields = " id,name,status,typeid,creater,principal,begindate,enddate,jointype,isnew,important,ishidden,replyNum,readNum,lastdiscussant,lastupdatedate,lastupdatetime,isApproval,approvalAtatus,isTop,cotypeid ";
			String fromSql  = sqlStr ;
			String sqlWhere = searchStr;
			String orderby = " isTop desc,jointype desc,isnew desc,important desc ";
			if(orderType.equals("important")){	
				orderby=" isTop desc,jointype desc,important desc,isnew desc";
			}else if(orderType.equals("replyNum"))
				orderby=" isTop desc,jointype desc,replyNum desc,isnew desc";
			else if(orderType.equals("readNum"))
				orderby=" isTop desc,jointype desc,readNum desc,isnew desc";
			
			session.setAttribute("backfields",backfields);
			session.setAttribute("searchStr",searchStr);
			session.setAttribute("sqlStr",sqlStr);
			session.setAttribute("orderby",orderby);
			
			tableString = " <table tabletype=\"checkbox\" checkboxwidth='6%' pagesize=\""+perpage+"\" >"+
						  //" <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getResultCheckBox\" />"+
						  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
			              " <head>"+
			              "	<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" orderkey=\"name\" column=\"name\" otherpara='column:id+column:isnew+"+userid+"+column:approvalAtatus+column:isTop' transmethod=\"weaver.general.CoworkTransMethod.getCoworkName\"/>"+
						  " <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" orderkey=\"principal\" column=\"principal\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
	             		  "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(117,user.getLanguage())+"\" orderkey=\"replyNum\" column=\"replyNum\" />"+
	              		  "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" orderkey=\"readNum\" column=\"readNum\" />"+
	              		  "	<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(83227,user.getLanguage())+"\" column=\"lastdiscussant\" otherpara='column:lastupdatedate+column:lastupdatetime' transmethod=\"weaver.general.CoworkTransMethod.getLastUpdate\"/>"+
			 			  "	<col rowClass='test1' tdClass=\"test\" width='8%' text='' column=\"important\" otherpara='column:id' transmethod=\"weaver.general.CoworkTransMethod.getImportant\"/>"+
			              "	</head></table>";
			%>
			<%if(layout==2){%>
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
			<%}else{%>
				<div id="listdiv" style="width: 100%;height: 100%;overflow:auto">
				  <table id='list' class="ListStyle" cellspacing="1" style="margin:0px;width:100%">
					 	<colgroup>
						<col width="18px">
						<col width="*">
						<col width="18px">
						</colgroup>
						<tbody id="list_body">
						
						</tbody>
				  </table>
				  <div id="loadingdiv" style="position:relative;width: 100%;height: 30px;margin-bottom: 15px;">
				      <div class='loading' style="position: absolute;top: 10px;left: 20%;">
				         <img src='/images/loadingext_wev8.gif' align="absMiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
				      </div>
				  </div>		
				</div>
			<%}%>
		</div>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(18363, user.getLanguage()) + ",javascript:_table.firstPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(1258, user.getLanguage()) + ",javascript:_table.prePage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(1259, user.getLanguage()) + ",javascript:_table.nextPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(18362, user.getLanguage()) + ",javascript:_table.lastPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
	
		$(document.body).bind("click",function(){
			$(".drop_list").hide();
		})
		$(".btn_add_type").hover(function(){
			$(this).addClass("btn_add_type_hover");
		},function(){
			$(this).removeClass("btn_add_type_hover");
		});
		
		$(".label").live("mouseenter",function(){
			var obj = $(this);
			t=setTimeout(function(){
				$(obj).find(".closeLb").show();
			},500);
		}).live("mouseleave",function(){
			var obj = $(this);
			$(obj).find(".closeLb").hide();
			clearTimeout(t);
		});
		
		$(".closeLb").live("click",function(){
			var labelitemid=$(this).attr("_labelitemid");
			var labeldiv=$(this).parent();
			jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {labelitemid:labelitemid,type:"delItemLable"},function(data){
        		labeldiv.remove();
			});
		});
		
		$(".layout").click(function(){
			var _currentLayout=$(this).attr("_currentLayout");
			var layout=$(this).attr("value");
			if(_currentLayout!=layout){
				window.parent.parent.parent.location.href="/cowork/CoworkViewFrame.jsp?jointype=<%=jointype%>&layout="+layout;
			}
		});
		
		initdata();
		
		jQuery("#topTitle").topMenuTitle({searchFn:showMenu});
		jQuery("#hoverBtnSpan").hoverBtn();
		
		if("<%=layout%>"=="1"){
			$("#listdiv").height(document.body.clientHeight-32).css("overflow","auto");
			/*
			$('#listdiv').jScrollPane({
			    autoReinitialise: true  //内容改变后自动计算高度 
			})
			*/
		}	
	});
	
	function showMenu(obj,target,e){
		$(".drop_list").hide();
		$("#"+target).css({
			"left":$(obj).position().left+"px",
			"top":($(obj).position().top+30)+"px"
		}).show();
		
		stopBubble(e);
	}
	
	function changeJoinType(obj){
	
		var jointype=$(obj).attr("_joinType")
		$("#jointype").val(jointype);
		if(jointype=="5")
		   $("#batchApproval",parent.parent.document).show();
		else
		   $("#batchApproval",parent.parent.document).hide();   
		$("#mainform").submit();
		
	}
	
	function changeOrderType(obj){
		var orderType=$(obj).attr("_orderType")
		$("#orderType").val(orderType);
		$("#mainform").submit();
	}
	
	//阻止事件冒泡函数
	 function stopBubble(e)
	 {
	     if (e && e.stopPropagation){
	         e.stopPropagation()
	     }else{
	         window.event.cancelBubble=true
	     }
	}
	
	function initdata(){
		var joinTypeDiv=$("#joinTypeMenu").find("div[_joinType='<%=jointype%>']").addClass("choose_type");
		$("#joinTypeName").html(joinTypeDiv.html());
		
		var orderTypeDiv=$("#orderTypeMenu").find("div[_orderType='<%=orderType%>']").addClass("choose_type");
		$("#orderTypeName").html(orderTypeDiv.html());
	}
	
	function viewCowork(obj){
		var coworkid=$(obj).attr("_coworkid");
		var url="/cowork/ViewCoWork.jsp?id="+coworkid;
		if("1"=="<%=layout%>")
			$("#ifmCoworkItemContent",window.parent.document).attr("src",url);
		else
			openFullWindowForXtable(url);	
		$(obj).find("span").css("font-weight","normal");
	}
	
	//应用标签
	function applyLabels(){
	
		var coworkids =_xtable_CheckedCheckboxId();
		if(coworkids==""){
			alert("<%=SystemEnv.getHtmlLabelName(25430,user.getLanguage()) %>");
			return true;
		}
		coworkids=coworkids.substr(0,coworkids.length-1);
		
		var labelids='';
		$("input[name=labelcheck]:checked").each(function(){
			labelids=labelids+","+$(this).val();
		});
		labelids=labelids.length>0?labelids.substr(1):labelids;
		
		jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:coworkids,type:"addLabel",labelids:labelids},function(data){
        	_xtable_CleanCheckedCheckbox();
        	_table. reLoad();
		});
	}
	
	function openLabelSet(){
		window.parent.parent.labelManage();
	}
	
</script>
<%if(layout==1){%>		
<script type="text/javascript">
var index=30;           //起始读取下标
var hght=0;             //初始化滚动条总长
var stop=0;              //初始化滚动条的当前位置
var preTop=0;           //滚动条前一个位置，向上滚动时不加载数据
var pagesize=30;        //每一次读取数据记录数
var total=<%=total%>;   //记录总数
var disdirect=true;    //是否显示直接参与默认显示
var disattention=true; //是否显示关注默认显示
var flag=false;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
var timeid; //定时器
var pageindex=1;
$(document).ready(function(){//DOM的onload事件
    var paramStr="<%=paramsStr%>"+"&name="+decodeURIComponent(decodeURIComponent("<%=name%>"))+"&CustomerID=<%=CustomerID%>";
    $.post("CoworkListInit.jsp?"+paramStr,{total:<%=total%>,pageindex:pageindex,index:index,pagesize:index,disdirect:disdirect,disattention:disattention},function(data){//利用jquery的get方法得到table.html内容
		    $("#list_body").append(data);
		    $(".loading", window.parent.document).hide(); //隐藏加载图片
		    hght=0;//恢复滚动条总长，因为$("#mypage").scroll事件一触发，又会得到新值，不恢复的话可能会造成判断错误而再次加载……
		    stop=0;//原因同上。
		    flag=true;
		    jQuery('body').jNice();
		    $("#loadingdiv").hide();
	});
    
	$("#listdiv").scroll( function() {//定义滚动条位置改变时触发的事件。
	    hght=this.scrollHeight;//得到滚动条总长，赋给hght变量
	    stop=this.scrollTop;//得到滚动条当前值，赋给top变量
	});
	
	if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
	     //左侧下拉框处理
	    jQuery(document.body).bind("mouseup",function(){
		   parent.jQuery("html").trigger("mouseup.jsp");	
	    });
	    jQuery(document.body).bind("click",function(){
			jQuery(parent.document.body).trigger("click");		
	    });
    }
    
   if(total>index){ 
   	timeid=setInterval("cando();",500);
   }
	
});

function cando(){ 
	if(stop>parseInt(hght/6)&&preTop<stop){//判断滚动条当前位置是否超过总长的1/3，parseInt为取整函数,向下滚动时才加载数据
	    show();
	}
    preTop=stop;//记录上一个位置
}

function show(){
    if(flag){
		index=index+pagesize;
		if(index>total){                    //当读取数量大于总数时
		   pagesize=total-(index-pagesize); 
		   index=total;                     //页面数据量等于数据总数
		   window.clearInterval(timeid);    //清除定时器
		}
		flag=false;
		var paramStr="<%=paramsStr%>"+"&name="+decodeURIComponent(decodeURIComponent("<%=name%>"))+"&CustomerID=<%=CustomerID%>";         
        $("#loadingdiv").show();
        pageindex++;         
	    $.post("CoworkListInit.jsp?"+paramStr,{pageindex:pageindex,orderType:"<%=orderType%>",total:<%=total%>,index:index,pagesize:pagesize,disdirect:disdirect,disattention:disattention},function(data){
			    $("#list_body").append(data);
			    $("#loadingdiv").hide();
			    hght=0;
			    stop=0;
			    flag=true;
			    jQuery('body').jNice();
		});
	}
}
</script>
<%}%>
	</body>
</html>
