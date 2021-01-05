
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

<%
	String layout=Util.null2String(request.getParameter("layout"),"1");
	//查看类型
	String type = Util.null2String(request.getParameter("type"));
	//协作区ID
	String typeid = Util.null2String(request.getParameter("typeid"));
	String mainid = Util.null2String(request.getParameter("mainid"));
	//参与类型
	String jointype=Util.null2String(request.getParameter("jointype"));
	//标签id
	String labelid=Util.null2String(request.getParameter("labelid"));
	//协作名称
	String name=Util.null2String(request.getParameter("name"));
	//协作主键
	String coworkid=Util.null2String(request.getParameter("coworkid"));
	
%>
<head>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link type="text/css" href="/cowork/css/coworkNew_wev8.css" rel=stylesheet>
<SCRIPT language="javascript" src="/cowork/js/coworkUtil_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/cowork_wev8.js"></script>

<link type="text/css" href="/cowork/css/coworkNew_wev8.css" rel=stylesheet>
</head>
<style>

</style>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
    String IsHasRoot="";//是否有新建协作版块和类别的权限
    
	if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
	    IsHasRoot="No";
	}
%>
	<BODY style="overflow: hidden;">
	
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<form id="mainForm" action="/cowork/CoworkList.jsp" method="post" target="listFrame">
	<input type="hidden" name="layout" value="<%=layout%>">	
	<input type="hidden" name="from" value="cowork">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
                    <% if(!"No".equals(IsHasRoot)){%>
                    <input type=button class="e8_btn_top" onclick="parent.addCoworkType();" value="<%=SystemEnv.getHtmlLabelName(83198,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="parent.addmaintype();" value="<%=SystemEnv.getHtmlLabelName(129747,user.getLanguage())%>"></input>
                    <%} %>
					<input type=button class="e8_btn_top" onclick="parent.addCowork();" value="<%=SystemEnv.getHtmlLabelName(18034,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="parent.labelManage();" value="<%=SystemEnv.getHtmlLabelName(30884,user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" id="batchApproval" onclick="batchApproval()" style="<%=jointype.equals("5")?"":"display:none"%>" value="<%=SystemEnv.getHtmlLabelName(19615,user.getLanguage())%>"></input>
				    <input type="text" class="searchInput" name="flowTitle"  value="<%=name%>"/>
	         		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
			<td></td>
		</tr>
	</table>
			
	<!-- 高级搜索 -->
	<div class="advancedSearchDiv" id="advancedSearchDiv" name="advancedSearchDiv" style="display:none;" >
		<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<input class=inputstyle type=text name="name" id="name" value="<%=name%>" style="width:175px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
		        </wea:item> 
		        <wea:item><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></wea:item>
		        <wea:item>
			        <select name="typeid" size=1 style="width:150px">
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

		      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		      <wea:item>
			      <select name=status style="width:150px">
			      <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			      <option value="1"  selected="selected"><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
			      <option value="2"><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
			      </select>
		      </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(18873,user.getLanguage())%></wea:item>
		      <wea:item>
			      <select name="jointype" style="width:150px">
			      <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			      <option value="1"><%=SystemEnv.getHtmlLabelName(18874,user.getLanguage())%></option>
			      <option value="2"><%=SystemEnv.getHtmlLabelName(18875,user.getLanguage())%></option>
			      </select>
		      </wea:item>

		      <wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
			  <wea:item>
			       <brow:browser viewType="0" name="principal" browserValue="" 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" width="205px;" 
							browserSpanValue="">
				   </brow:browser>
			       
			  </wea:item>
		      <wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		      <wea:item>
			       <brow:browser viewType="0" name="creater" browserValue="" 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl="/data.jsp" width="205px" 
							browserSpanValue="">
				   </brow:browser>
		      </wea:item>   
			</wea:group>
			
			<wea:group context="" attributes="{'Display':'none'}">
				<wea:item type="toolbar">
					<input type="button" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn" onclick="doSearch()"/>
					<input type="button" name="reset" onclick="resetCondition(advancedSearchDiv)" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
		
	</div>
	</form>		
	
	<div style="position: relative;height:100%;width:100%" id="maindiv">
	 	<div id="leftdiv" class="northDiv left" style="border-right:1px solid #BDBDBD;height:100%;<%=layout.equals("1")?"width:350px;":"width:100%;"%>">
	 		<iframe src="/cowork/CoworkList.jsp?from=cowork&layout=<%=layout%>&mainid=<%=mainid %>&typeid=<%=typeid%>&type=<%=type%>&jointype=<%=jointype%>&labelid=<%=labelid%>&name=<%=name%>" id="listFrame" name="listFrame" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	 	</div>
	 	 
	 	<%if(layout.equals("1")){%> 
	    <div id="rightdiv" class="centerDiv left" style="width:680px;overflow: hidden;height:100%">
	    	<%if(coworkid.equals("")){ %>
	    	<iframe id='ifmCoworkItemContent' src='/cowork/ViewReplay.jsp?jointype=<%=jointype%>' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
	    	<%}else{ %>
	    	<iframe id='ifmCoworkItemContent' src='/cowork/ViewCoWork.jsp?id=<%=coworkid%>' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
	    	<%} %>
	    </div> 
	    <div id="btn_center" class="btn_center btn_center_left" onclick="showLeft(this)" _status="1" title="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>"></div>
	    <%}%> 
	</div>    
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>		
		
		<script type="text/javascript">
			var layout="<%=layout%>";
			$(document).ready(function(){
				jQuery("#topTitle").topMenuTitle({searchFn:searchCoworkName});
				jQuery("#hoverBtnSpan").hoverBtn();
				
				initWidth();
				
				$(".btn_center").hover(function(){
					$(this).addClass("btn_center_hover");
				},function(){
					$(this).removeClass("btn_center_hover");
				});
			});
			
			function showLeft(obj){
				var mainWidth=document.body.clientWidth;
				var status=$(obj).attr("_status");
				if(status=="1"){
				
					$("#leftdiv").animate({width:0},200,null,function(){});
					$("#rightdiv").animate({width:mainWidth-2},200,null,function(){});
					$(obj).attr("_status","0").addClass("btn_center_right").removeClass("btn_center_left").attr("title","<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>");
					
				}else{
				
					$("#leftdiv").animate({width:350},200,null,function(){});
					$("#rightdiv").animate({width:mainWidth-350-2},200,null,function(){});
					
					$(obj).attr("_status","1").addClass("btn_center_left").removeClass("btn_center_right").attr("title","<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>");
					
				}
			}
			
			
			function searchCoworkName(){
				var name =$(".searchInput").val();
				jQuery("#name").val(name);
				$("#mainForm").submit();
			}
			
			window.onresize=function(){
				setTimeout(function(){
					initWidth(); 
				},500);
			}
			
			function initWidth(){
				setTimeout(function(){
					var mainWidth=document.body.clientWidth;
					$("#maindiv").width(mainWidth);
					var leftWidth=$("#leftdiv").width();
					$("#rightdiv").animate({width:mainWidth-leftWidth-2},200,null,function(){
					
					});
				},1000);
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
			function doSearch(e){
				e=e?e:window.event;
				$(parent.document).find("#advancedSearch").click();
				$("#mainForm").submit();
			}
			
			function reLoadCoworkList(){
				$("#listFrame")[0].contentWindow.reLoadCoworkList();
			}
			
			function batchApproval(){
				$("#listFrame")[0].contentWindow.batchApproval();
			}
			
		</script>	
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>
