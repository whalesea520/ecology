
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@page import="java.net.URLDecoder"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link type="text/css" href="/cowork/css/coworkNew_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/cowork/js/coworkUtil_wev8.js"></script>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
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
String mainid = Util.null2String(request.getParameter("mainid"));
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
String layout=Util.null2String(request.getParameter("layout"),"2");

String datetype=Util.null2String(request.getParameter("datetype"));


String sqlWhere="id != 0 ";
if(!name.equals("")){
	sqlWhere += " and name like '%"+name+"%' "; 
}
if(!typeid.equals("")){
	sqlWhere += "  and t1.typeid = '"+typeid+"'";
}
if(!mainid.equals("")){
	sqlWhere += "  and t1.typeid in(select id from cowork_types where departmentid in ("+mainid+"))  ";
}
if(!status.equals("")){
	sqlWhere += " and status ="+status+"";
}

if(!creater.equals("")){
	sqlWhere += " and creater='"+creater+"'  ";
}
if(!principal.equals("")){
	sqlWhere += " and principal='"+principal+"'  "; 
}
if(!startdate.equals("")){
	sqlWhere +=" and begindate >='"+startdate+"'  ";
}
if(!enddate.equals("")){
	sqlWhere +=" and enddate <='"+enddate+"'  ";
}

String tableString = "";
int perpage=10;                                 
String backfields = " id,name,status,t1.typeid,creater,principal,begindate,enddate,replyNum,readNum,lastdiscussant,lastupdatedate,lastupdatetime,isApproval,approvalAtatus,isTop, t4.mainid ";
String fromSql  = " cowork_items t1 left join (select t2.id as typeid, t3.id as mainid from cowork_types  t2 left join cowork_maintypes  t3 on t2.departmentid=t3.id) t4"+
" on t1.typeid = t4.typeid " ;


if(datetype.equals("principal")){
   sqlWhere += " and (select max(createdate) from cowork_discuss where coworkid=t1.id and discussant=principal) <= '"+TimeUtil.getDateByOption("5","0")+"'";
}else if(datetype.equals("partner")){   
   sqlWhere += " and (select max(createdate) from cowork_discuss where coworkid=t1.id) <= '"+TimeUtil.getDateByOption("5","0")+"'";
}
   
String orderby = "";

tableString = " <table tabletype=\"checkbox\" pageId=\""+PageIdConst.Cowork_themeMonitor+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_themeMonitor,user.getUID(),PageIdConst.COWORK)+"\" >"+
			  " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getCoworkMonitorCheckbox\" />"+
			  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
              " <head>"+
              "	<col width='10%' text='ID' column=\"id\" orderkey=\"id\" />"+
              "	<col width=\"*\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" orderkey=\"name\" column=\"name\" otherpara='column:id+column:isnew+"+userid+"+column:approvalAtatus+column:isTop+"+layout+"' transmethod=\"weaver.general.CoworkTransMethod.getCoworkName\"/>";
 if(layout.equals("2")){
	tableString+="	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" orderkey=\"principal\" column=\"principal\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\"/>"+
				 "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" orderkey=\"creater\" column=\"creater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\"/>"+
				 "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" orderkey=\"status\" column=\"status\" transmethod=\"weaver.general.CoworkTransMethod.getCoworkStatus\"/>"+
      			 "	<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(83227,user.getLanguage())+"\" column=\"lastdiscussant\" otherpara='column:lastupdatedate+column:lastupdatetime' transmethod=\"weaver.general.CoworkTransMethod.getLastUpdate\"/>";	 
 }
 tableString+="	</head></table>";
%>


<BODY>
	
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.weaver.submit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83246,user.getLanguage())+",javascript:batchEnd(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83247,user.getLanguage())+",javascript:markItemAsType('toTop'),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(24675,user.getLanguage())+",javascript:markItemAsType('cancelTop'),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	

	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="batchDel()" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="batchEnd()" value="<%=SystemEnv.getHtmlLabelName(83246,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="markItemAsType('toTop')" _markType="toTop" value="<%=SystemEnv.getHtmlLabelName(83247,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="markItemAsType('cancelTop')" _markType="cancelTop" value="<%=SystemEnv.getHtmlLabelName(24675,user.getLanguage())%>"></input>
			
		    <input type="text" class="searchInput" name="flowTitle"  value="<%=name %>"/>
       		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
		<td></td>
	</tr>
</table>
	
<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form id="mainform" name="weaver" action="CoworkMonitorList.jsp" method="post" >
		<input type="hidden" name="jointype" id="jointype" value="<%=jointype%>"/>
		<input type="hidden" name="orderType" id="orderType" value="<%=orderType%>"/>
		<input type="hidden" name="type" id="type" value="<%=type%>"/>
		<input type="hidden" name="layout" id="layout" value="<%=layout%>"/>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
			        <wea:item>
			        	<input class=inputstyle type=text name="name" id="name" value="<%=name%>" style="width: 200px;" maxlength=25 
			        		onkeydown="if(window.event.keyCode==13) return false;">      
			        </wea:item> 
			        <wea:item><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></wea:item>
			        <wea:item>
				        <select name="typeid" size=1 style="width: 177px;">
				    	<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				        <%
				            String typesql="select * from cowork_types" ;
				           
				            RecordSet.executeSql(typesql);
				            while(RecordSet.next()){
				                String tmptypeid=RecordSet.getString("id");
				                String typename=RecordSet.getString("typename");
				        %>
				            <option value="<%=tmptypeid%>" <%=tmptypeid.equals(typeid)?"selected":"" %>><%=typename%></option>
				        <%
				            }
				        %>
				        </select>
			        </wea:item>
	
			      <wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
				  <wea:item>
				       <brow:browser viewType="0" name="principal" 
				       			browserValue='<%=principal%>' 
				        		browserSpanValue = '<%=ResourceComInfo.getResourcename(principal)%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="230px" >
					  </brow:browser>
				  </wea:item>
				  
			      <wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
			      <wea:item>
				       <brow:browser viewType="0" name="creater" 
				       			browserValue='<%=creater%>' 
				        		browserSpanValue = '<%=ResourceComInfo.getResourcename(creater)%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="230px" >
					   </brow:browser>
			      </wea:item>   
	
			      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			      <wea:item>
				      <select name=status style="width: 177px;">
				      <option value=""  <%if(status.equals("")){ %>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				      <option value="1" <%if(status.equals("1")){ %>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
				      <option value="2" <%if(status.equals("2")){ %>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
				      </select>
			      </wea:item>
			      
			      <wea:item></wea:item><wea:item></wea:item>
				</wea:group>
				
				<wea:group context="" attributes="{'Display':'none'}">
					<wea:item type="toolbar">
						<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
						<input type="button" name="reset" onclick="resetCondition()" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
					</wea:item>
				</wea:group>
			</wea:layout>
	</form>
</div>
   
<div>	
	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_themeMonitor%>">
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" /> 
</div>
			
<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:searchCoworkName});
		jQuery("#hoverBtnSpan").hoverBtn();
	});
	
	function searchCoworkName(){
		var name =$(".searchInput").val();
		jQuery("#name").val(name);
		$("#mainform").submit();
	}
	
	function showMenu(obj,target,e){
		$(".drop_list").hide();
		$("#"+target).css({
			"left":$(obj).position().left+"px",
			"top":($(obj).position().top+30)+"px"
		}).show();
		
		stopBubble(e);
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
	
	function viewCowork(obj){
		var coworkid=$(obj).attr("_coworkid");
		var url="/cowork/ViewCoWork.jsp?id="+coworkid;
		if("1"=="<%=layout%>")
			$("#ifmCoworkItemContent",window.parent.document).attr("src",url);
		else
			openFullWindowForXtable(url);	
		$(obj).css("font-weight","normal");
	}
	
	//标记协作状态  type:{read:已读,unread:未读,hidden:隐藏,show:取消隐藏,important:重要(加星),normal:一般(不加星)} 
	function markItemAsType(type){
		var coworkids=_xtable_CheckedCheckboxId();
		if(coworkids==""){
			jQuery(".dropDown").hide();
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25430,user.getLanguage())%>");
			return ;
		}
		
		jQuery.post("/cowork/CoworkItemMarkOperation.jsp", {coworkid:coworkids,type:type},function(data){
			_xtable_CleanCheckedCheckbox();
	        _table. reLoad();
	    	return true; 
	    });
	    
		return true;
	}
	
</script>	
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
