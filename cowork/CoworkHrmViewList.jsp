
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page"/>

<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link type="text/css" href="/cowork/css/coworkNew_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/cowork/js/coworkUtil_wev8.js"></script>
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
String name =Util.null2String(request.getParameter("name"));
//协作区ID
String typeid = Util.null2String(request.getParameter("typeid"));
//协作状态
String status = Util.null2String(request.getParameter("status"),"1");
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

String searchHrmid=Util.null2String(request.getParameter("searchHrmid"));
%>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
	<BODY>
	
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
		
		
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<form id="mainform" action="CoworkHrmViewList.jsp" method="post" >
			<input type="hidden" name="jointype" id="jointype" value="<%=jointype%>"/>
			<input type="hidden" name="orderType" id="orderType" value="<%=orderType%>"/>
			<input type="hidden" name="type" id="type" value="<%=type%>"/>
			<input type="hidden" name="typeid" id="typeid" value="<%=typeid%>"/>
			<input type="hidden" name="layout" id="layout" value="<%=layout%>"/>
			<input type="hidden" name="searchHrmid" id="searchHrmid" value="<%=searchHrmid%>"/>
			
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right;">
						    <input type="text" class="searchInput" name="flowTitle"  value="<%=name %>"/>
			         		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
							<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
					<td></td>
				</tr>
			</table>
			
			<!-- 高级搜索 -->
			<!-- 高级搜索 -->
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
				        <wea:item>
				        	<input class=inputstyle type=text name="name" id="name" value="<%=name%>" style="width:180px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
				        </wea:item> 
				        <wea:item><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></wea:item>
				        <wea:item>
					        <select name="typeid" size=1 style="width:155px">
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
									completeUrl="/data.jsp" width="210px" >
						  </brow:browser>
					  </wea:item>
					  
				      <wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
				      <wea:item>
					       <brow:browser viewType="0" name="creater" 
					       			browserValue='<%=creater%>' 
					        		browserSpanValue = '<%=ResourceComInfo.getResourcename(creater)%>'
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="210px" >
						   </brow:browser>
				      </wea:item>   

				      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
				      <wea:item>
					      <select name=status style="width:155px">
				      		  <option <%=status.equals("")?"selected":"" %> value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						      <option <%=status.equals("1")?"selected":"" %> value="1"><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
						      <option <%=status.equals("2")?"selected":"" %> value="2"><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
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
		</div>
	    
		<div>	
			<%
			String searchStr="";
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
			
			String tableString = "";
			int perpage=10;                                 
			String backfields = " id,name,status,typeid,creater,principal,begindate,enddate,replyNum,readNum,lastdiscussant,lastupdatedate,lastupdatetime,isApproval,approvalAtatus,isTop ";
			String fromSql  = " from (select a.* from ("+CoworkShareManager.getCoworkSql(searchHrmid)+")  a join ("+CoworkShareManager.getCoworkSql(user.getUID()+"")+") b on a.id = b.id where a.status=1 ) t" ;
			String sqlWhere = "where 1=1 ";
			//System.err.println("select "+backfields+" "+fromSql+" "+sqlWhere);
			
			sqlWhere+=searchStr;   
			   
			String orderby = "";
			
			tableString = " <table tabletype=\"none\" pagesize=\""+perpage+"\" >"+
						  " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getCoworkMonitorCheckbox\" />"+
						  " <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
			              " <head>"+
			              "	<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" orderkey=\"name\" column=\"name\" otherpara='column:id+column:isnew+"+userid+"+column:approvalAtatus+column:isTop+2' transmethod=\"weaver.general.CoworkTransMethod.getCoworkName\"/>"+
						  "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" orderkey=\"principal\" column=\"principal\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
						  "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" orderkey=\"creater\" column=\"creater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
						  "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" orderkey=\"status\" column=\"status\" transmethod=\"weaver.general.CoworkTransMethod.getCoworkStatus\"/>"+
	              		  "	<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(83227,user.getLanguage())+"\" column=\"lastdiscussant\" otherpara='column:lastupdatedate+column:lastupdatetime' transmethod=\"weaver.general.CoworkTransMethod.getLastUpdate\"/>"+
			              "	</head></table>";
			%>	
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" /> 
		</div>
			
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
				
				jQuery("#topTitle").topMenuTitle({searchFn:searchCoworkName});
				jQuery("#hoverBtnSpan").hoverBtn();
				
				initdata();
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
			
			
		</script>	
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>
