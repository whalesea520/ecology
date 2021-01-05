
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.cowork.CoworkService"%>
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
<jsp:useBean id="CoworkService" class="weaver.cowork.CoworkService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link type="text/css" href="/cowork/css/coworkNew_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/cowork/js/coworkUtil_wev8.js"></script>
<SCRIPT language="javascript" src="/cowork/js/cowork_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.mousewheel-3.0.4.pack_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.css" media="screen" />
<link rel="stylesheet" href="/cowork/js/jquery.fancyboxstyle_wev8.css" />

<style>
.discuss_content{
	word-break:break-all;
	white-space:normal;
}
</style>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
String needfav = "1";
String needhelp = "";
String userid=""+user.getUID();
if( !HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}



String name =URLDecoder.decode( Util.null2String(request.getParameter("name")));//关键字

String mainid = Util.null2String(request.getParameter("mainid"));//主类型
String typeid = Util.null2String(request.getParameter("typeid"));//协作区类型


String status = Util.null2String(request.getParameter("status"));//协作状态
String creater = Util.null2String(request.getParameter("creater"));// 创建者
String layout=Util.null2String(request.getParameter("layout"),"1");
String from=Util.null2String(request.getParameter("from"));


String discussant=Util.null2String(request.getParameter("discussant"));
String delUserId=Util.null2String(request.getParameter("delUserId"));
String remark=Util.null2String(request.getParameter("remark"));
String datetype = Util.null2String(request.getParameter("datetype"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String commentStatus=Util.null2String(request.getParameter("commentStatus"));

String sqlWhere=" 1=1 ";
if(!discussant.equals("")){
	sqlWhere+=" and discussant = "+discussant;
}
if(!remark.equals("")){
	sqlWhere+=" and remark like '%"+remark+"%'";
}
if(!mainid.equals("")){
	sqlWhere += "  and typeid in(select id from cowork_types where departmentid in ("+mainid+"))  ";
}
if(!typeid.equals("")){
	sqlWhere +=" and typeid = '"+typeid+"'";
}
if(!delUserId.equals("")){
    sqlWhere+=" and delUserId = "+delUserId;
}
if("0".equals(commentStatus)){
    if(!"".equals(datetype) && !"6".equals(datetype)){
        sqlWhere += " and createdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
        sqlWhere += " and createdate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
    }
    
    if("6".equals(datetype) && !"".equals(startdate)){
        sqlWhere += " and createdate >= '"+startdate+"'";
    }
    
    if("6".equals(datetype) && !"".equals(enddate)){
        sqlWhere += " and createdate <= '"+enddate+"'";
    }
}else{
    if(!"".equals(datetype) && !"6".equals(datetype)){
        sqlWhere += " and delTime >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
        sqlWhere += " and delTime <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
    }
    
    if("6".equals(datetype) && !"".equals(startdate)){
        sqlWhere += " and delTime >= '"+startdate+"'";
    }
    
    if("6".equals(datetype) && !"".equals(enddate)){
        sqlWhere += " and delTime <= '"+enddate+"'";
    }
}
sqlWhere += " and isDel = '"+commentStatus+"'";

String sqlStr ="";

sqlStr += " cowork_discuss t left join "+
	"( select t1.id as coworid,t4.id as typeid from  cowork_items t1 left join "+
	"(select t2.id , t3.id as mainid from cowork_types  t2 left join cowork_maintypes  t3 on t2.departmentid=t3.id) t4"+
	" on t1.typeid = t4.id) t11 on t.coworkid = t11.coworid";

if("comment".equals(from)){
    sqlWhere +=" and topdiscussid <> 0";
}else if ("content".equals(from)){
    sqlWhere +=" and topdiscussid = 0";
}
String tableString = "";
String backfields = "t.id,t.discussant,t.createdate,t.createtime,t.remark,t.coworkid,t.approvalAtatus,t11.typeid,t.floorNum,t.topdiscussid,t.delUserId,t.delTime,t.remarkback,";
if ("oracle".equals(rs.getDBType())) {
    backfields += " t.createdate||' '||t.createtime discussdate";
} else if ("sqlserver".equals(rs.getDBType())) {
    backfields += " t.createdate+' '+t.createtime discussdate";
} else if ("mysql".equals(rs.getDBType())) {
    backfields += " concat(t.createdate, ' ', t.createtime) discussdate";
}
String fromSql  = sqlStr ;
String cols ="";
if("comment".equals(from)){
    cols = " href=\"javascript:ViewCoworkDiscuss('{0}')\" linkkey=\"id\" linkvaluecolumn=\"topdiscussid\" />";
}else{
    cols = " href=\"javascript:ViewCoworkDiscuss('{0}')\" linkkey=\"id\" linkvaluecolumn=\"id\" />";
}
String remarkname ="";
String pageId ="";
if("0".equals(commentStatus)){
	if("comment".equals(from)){
		remarkname= SystemEnv.getHtmlLabelName(82562,user.getLanguage());
	}else{
		remarkname= SystemEnv.getHtmlLabelName(28199,user.getLanguage());
	}
	pageId = PageIdConst.Cowork_CommentMonitor;
    String orderby = "discussdate";
    tableString = " <table tabletype=\"checkbox\" pageId=\""+pageId+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_CommentMonitor,user.getUID(),PageIdConst.COWORK)+"\" >"+
    " <checkboxpopedom   popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getDiscussCheckBox\"/>"+
    " <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\"" + orderby + "\" sqlprimarykey=\"t.id\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
    " <head>"+
    " <col width=\"35%\"  text=\""+remarkname+"\" column=\"remark\" transmethod=\"weaver.general.CoworkTransMethod.formatContent\" pkey=\"remark+weaver.general.CoworkTransMethod.formatContent\"/>"+
    " <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(26225,user.getLanguage())+"\" orderkey=\"discussant\" column=\"discussant\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\"/>"+
    "<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(27519,user.getLanguage()) +"\" column=\"floorNum\" orderkey=\"floorNum\" otherpara='column:topdiscussid' transmethod=\"weaver.general.CoworkTransMethod.getFloorNum\" pkey=\"remark+weaver.general.CoworkTransMethod.getFloorNum\" "+
    cols + 
    " <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" orderkey=\"coworkid\" column=\"coworkid\" transmethod=\"weaver.cowork.CoworkDAO.getCoworkName\" "+
    " href=\"/cowork/ViewCoWork.jsp\" linkkey=\"id\" linkvaluecolumn=\"coworkid\" />"+ 
    " <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(23066,user.getLanguage())+"\"  column=\"discussdate\" />"
    ;
    tableString+=" </head></table>";
}else{
	if("comment".equals(from)){
		remarkname= SystemEnv.getHtmlLabelName(82562,user.getLanguage());
	}else{
		remarkname= SystemEnv.getHtmlLabelName(28199,user.getLanguage());
	}
	
	pageId = PageIdConst.Cowork_MonitorDelete;
    String orderby = "delTime";
    
    tableString = " <table tabletype='none'  pageId=\""+pageId+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_CommentMonitor,user.getUID(),PageIdConst.COWORK)+"\" >"+
    " <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\"" + orderby + "\" sqlprimarykey=\"t.id\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
    " <head>"+
    " <col width=\"35%\"  text=\""+remarkname+"\" column=\"remarkback\" transmethod=\"weaver.general.CoworkTransMethod.formatContent\" pkey=\"remark+weaver.general.CoworkTransMethod.formatContent\"/>"+
    " <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(26225,user.getLanguage())+"\" orderkey=\"discussant\" column=\"discussant\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\"/>"+
    "<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(27519,user.getLanguage()) +"\" column=\"floorNum\" orderkey=\"floorNum\" otherpara='column:topdiscussid' transmethod=\"weaver.general.CoworkTransMethod.getFloorNum\" pkey=\"remark+weaver.general.CoworkTransMethod.getFloorNum\" "+
    cols +
    " <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" orderkey=\"coworkid\" column=\"coworkid\" transmethod=\"weaver.cowork.CoworkDAO.getCoworkName\" "+
    " href=\"/cowork/ViewCoWork.jsp\" linkkey=\"id\" linkvaluecolumn=\"coworkid\" />"+ 
    " <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(26684,user.getLanguage())+"\" orderkey=\"delUserId\" column=\"delUserId\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename1\"/>"+
    " <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(127003,user.getLanguage())+"\" column=\"delTime\"  />"
    ;
    tableString+=" </head></table>";
}

%>


<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
		
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<form id="mainform" name="weaver" action="CoworkCommentList.jsp" method="post" >
	<input type="hidden" name="layout" id="layout" value="<%=layout%>"/>
    <input type="hidden" name="from" id="from" value="<%=from%>"/>
    <input type="hidden" name="commentStatus" value="<%=commentStatus %>">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
                    <%if("0".equals(commentStatus)&&"comment".equals(from)){ %>
					<input type=button class="e8_btn_top" onclick="doBatchDelComment()" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>"></input>
                    <%} %>
                    <%if("0".equals(commentStatus)&&"content".equals(from)){ %>
                    <input type=button class="e8_btn_top" onclick="doBatchDelContent()" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>"></input>
                    <%} %>
				    <input type="text" class="searchInput" name="flowTitle"  value="<%=remark%>"/>
	         		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
			<td></td>
		</tr>
	</table>
	
	<!-- 高级搜索 -->
	<div class="advancedSearchDiv" id="advancedSearchDiv" style="width: 100%">
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(33368,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<input class=inputstyle type="text" name="remark" id="remark" value="<%=remark%>" style="width:180px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
		        </wea:item> 
		        <wea:item><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></wea:item>
		        <wea:item>
			        <select name="typeid" size=1 style="width: 150px;">
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
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(26225 ,user.getLanguage()) %></wea:item>
			  <wea:item>
			       <brow:browser viewType="0" name="discussant" 
	       			browserValue='<%=discussant%>' 
	        		browserSpanValue ='<%=ResourceComInfo.getLastname(discussant)%>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" width="210px" >
	               </brow:browser>
			  </wea:item>
              <%if ("0".equals(commentStatus)){%>
                <wea:item><%=SystemEnv.getHtmlLabelName(23066,user.getLanguage())%></wea:item>
                <wea:item>
                    <span>
                        <SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
                          <option value=""  <%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                          <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
                          <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
                          <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
                          <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
                          <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
                          <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
                        </SELECT>
                    </span>     
                    
                    <span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
                        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,startdate)" value="<%=startdate%>"></button>
                        <span id="startdatespan"><%=startdate%></span>
                        <input type="hidden" id="startdate" name="startdate">
                        －
                        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
                        <span id="enddatespan"><%=enddate%></span>
                        <input type="hidden" id="enddate" name="enddate">
                    </span>
                </wea:item>
              <%}else{ %>
                <wea:item><%=SystemEnv.getHtmlLabelName(26684 ,user.getLanguage()) %></wea:item>
                <wea:item>
                   <brow:browser viewType="0" name="delUserId" 
                    browserValue='<%=delUserId%>' 
                    browserSpanValue ='<%=ResourceComInfo.getLastname(delUserId)%>'
                    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                    hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                    completeUrl="/data.jsp" width="210px" >
                   </brow:browser>
              </wea:item>
              
               <wea:item><%=SystemEnv.getHtmlLabelName(127003,user.getLanguage())%></wea:item>
                <wea:item>
                    <span>
                        <SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
                          <option value=""  <%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                          <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
                          <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
                          <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
                          <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
                          <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
                          <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
                        </SELECT>
                    </span>     
                    
                    <span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
                        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,startdate)" value="<%=startdate%>"></button>
                        <span id="startdatespan"><%=startdate%></span>
                        <input type="hidden" id="startdate" name="startdate">
                        －
                        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
                        <span id="enddatespan"><%=enddate%></span>
                        <input type="hidden" id="enddate" name="enddate">
                    </span>
                </wea:item>
              <%} %>
              
			</wea:group>
			
			<wea:group context="" attributes="{'Display':'none'}">
				<wea:item type="toolbar">
					<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" id="searchBtn"/>
					<input type="button" name="button" onclick="resetCondition()" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</form>
<div id="listoperate" style="display:none;">
	<div id="sortType"  class="main_btn menuitem1" style="width:75px;" onclick="showMenu(this,'orderTypeMenu',event)">
		<div class="menuitem1-l" style="padding-left: 10px;">
			<span id="orderTypeName"><%=SystemEnv.getHtmlLabelName(83229 ,user.getLanguage()) %></span>
			<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
		</div>
	</div>
   </div>
   
<div id="orderTypeMenu" class="drop_list" style="width:75px;">
		<div class="btn_add_type" onclick="changeOrderType(this)" _orderType="unread"><%=SystemEnv.getHtmlLabelName(23066 ,user.getLanguage()) %></div><!-- 全部 -->
		<div class="btn_add_type" onclick="changeOrderType(this)" _orderType="important"><%=SystemEnv.getHtmlLabelName(18831 ,user.getLanguage()) %></div><!-- 全部 -->
	    <div class="btn_add_type" onclick="changeOrderType(this)" _orderType="replayNum"><%=SystemEnv.getHtmlLabelName(26225 ,user.getLanguage()) %></div><!-- 全部 -->
</div>
		
<div>	
	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_ContentApproval%>">
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" /> 
</div>
		
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
	
		jQuery("#topTitle").topMenuTitle({searchFn:searchKeyword});
		jQuery("#hoverBtnSpan").hoverBtn();
		
    	$(".discuss_content img").live("click",function(){
    		var _init=$(this).attr("_init");
    		if(_init!="1"){
    			$(this).fancybox({
    				'overlayShow'	: false,
    				'titleShow':false,
    				'transitionIn'	: 'elastic',
    				'transitionOut'	: 'elastic',
    				'type':'image'
    			});
    			$(this).attr("_init","1");
    			$(this).click();
    		}
    	});
    		
        if("<%=datetype%>" == 6){
            jQuery("#dateTd").show();
        }else{
            jQuery("#dateTd").hide();
        }    
	});
	
	function searchKeyword(){
		var name =$(".searchInput").val();
		jQuery("#remark").val(name);
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
	
	function changeJoinType(obj){
		var jointype=$(obj).attr("_joinType")
		$("#jointype").val(jointype);
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
	
	function viewCowork(obj){
		var coworkid=$(obj).attr("_coworkid");
		var url="/cowork/ViewCoWork.jsp?id="+coworkid;
		if("1"=="<%=layout%>")
			$("#ifmCoworkItemContent",window.parent.document).attr("src",url);
		else
			openFullWindowForXtable(url);	
		$(obj).css("font-weight","normal");
	}
    
    function onChangetype(obj){
        if(obj.value == 6){
            jQuery("#dateTd").show();
        }else{
            jQuery("#dateTd").hide();
        }
    }
    
    //打开楼层
    function ViewCoworkDiscuss(id){
        diag=getCoworkDialog("楼层信息",600,480);
        diag.URL = "/cowork/ViewCoWorkDiscuss.jsp?discussids="+id;
        diag.show();
    }
</script>
<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>	
</body>
</html>
