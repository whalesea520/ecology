<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<HTML><HEAD>
<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:searchInfo});
		jQuery("#hoverBtnSpan").hoverBtn();
	});
	
	function searchInfo(){
		jQuery("#name").val(jQuery("#searchName").val());
		weaver.submit();	
	}
	
	// stauts:-1为未审批 0为拒绝，1为通过
	function approveInfo(applyid , status){
		jQuery.post("CoworkApplyOperation.jsp",{"method":"approve","applyid":applyid , "status":status},function(count){
			jQuery("#approveCount",parent.document).html(jQuery.trim(count));
			_table. reLoad();
		});
	}
	
	function batchApproveInfo(obj,status){
		var ids = _xtable_CheckedCheckboxId();
		if("" == ids){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
			return;
		}
		obj.disabled = false;
		ids = ids.substring(0 ,ids.length-1);
		approveInfo(ids , status);
	}
</script>

</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	String name = Util.null2String(request.getParameter("name"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String deparentment = Util.null2String(request.getParameter("deparentment"));
	String subdeparentment = Util.null2String(request.getParameter("subdeparentment"));
	String sqlWhere = "";
	if(!"".equals(name)){
		sqlWhere +=" and t1.name like '%"+name+"%'";
	}
	if(!"".equals(resourceid)){
		sqlWhere +=" and t2.resourceid = '"+resourceid+"'";
	}
	if(!"".equals(deparentment)){
		sqlWhere +=" and t3.departmentid = '"+deparentment+"'";
	}
	if(!"".equals(subdeparentment)){
		sqlWhere +=" and t3.subcompanyid1 = '"+subdeparentment+"'";
	}
	
	
	int pagesize = 10;
	String orderby = " t2.applydate";
	String fromSql = "cowork_items  t1  JOIN cowork_apply_info t2 ON t1.id = t2.coworkid left join hrmresource t3 on t2.resourceid = t3.id";
	String backfields = "t1.name , t2.id ,t2.resourceid , t2.applydate, t3.departmentid  ";
	sqlWhere = "t1.principal = "+user.getUID()+" and t2.status = -1 "+sqlWhere;
	
	String operateString= "<operates width=\"15%\">";
	       operateString+=" <popedom transmethod=\"weaver.cowork.CoworkApplayTrans.getCoworkApprovePopedom\"></popedom> ";
	       operateString+="     <operate href=\"javascript:approveInfo()\"  otherpara=\"1\" text=\""+SystemEnv.getHtmlLabelName(142,user.getLanguage())+"\" index=\"0\"/>";
	       operateString+="     <operate href=\"javascript:approveInfo()\"  otherpara=\"0\" text=\""+SystemEnv.getHtmlLabelName(25659,user.getLanguage())+"\" index=\"1\"/>";
	       operateString+="</operates>";
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.Cowork_ApplyApprove+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_ApplyApprove,user.getUID(),PageIdConst.COWORK)+"\" tabletype=\"checkbox\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlWhere+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t2.id\" sqlsortway=\"Desc\"/>"+
    "<head>"+
    "<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(368,user.getLanguage()) +"\" column=\"resourceid\""+
    	" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\""+
    	" href=\"/hrm/resource/HrmResource.jsp\" linkkey=\"id\" linkvaluecolumn=\"resourceid\"/>"+ 
   	"<col width=\"25%\"  text=\""+ SystemEnv.getHtmlLabelName(17895,user.getLanguage()) +"\" column=\"departmentid\""+
    	" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\""+
    	" href=\"/hrm/company/HrmDepartmentDsp.jsp\" linkkey=\"id\" linkvaluecolumn=\"departmentid\"/>"+ 
   	"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(129,user.getLanguage())+SystemEnv.getHtmlLabelName(26686,user.getLanguage()) +"\" column=\"name\""+
   		" transmethod=\"weaver.cowork.CoworkApplayTrans.getCoworkName\"/>"+ 
  	"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(855,user.getLanguage()) +"\" column=\"applydate\"/>"+ 
	"</head>"+operateString+   			
	"</table>";
	
	// System.err.println("select "+backfields+" from "+ fromSql+" where "+sqlWhere);
%>

<BODY>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="batchApproveInfo(this,1)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(83212,user.getLanguage())%>"/>
			<input class="e8_btn_top middle" onclick="batchApproveInfo(this,0)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(83213,user.getLanguage())%>"/>
	    	<input type="text" class="searchInput" name="searchName" id="searchName"  value="<%=name %>"/>
       		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
			
<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id="weaver" name="weaver" action="CoworkApplyApprove.jsp" method="post">
	<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
		
			<wea:item><%=SystemEnv.getHtmlLabelName(22235,user.getLanguage())%></wea:item>
			<wea:item>
		       <brow:browser viewType="0" name="resourceid" 
		       			browserValue='<%=resourceid%>' 
		        		browserSpanValue = '<%=ResourceComInfo.getResourcename(resourceid)%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" width="180px" >
			  </brow:browser>
			</wea:item>
			
       
			<wea:item><%=SystemEnv.getHtmlLabelName(17895,user.getLanguage())%></wea:item>
			<wea:item>
		       <brow:browser viewType="0" name="deparentment" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			         browserValue='<%=deparentment%>' 
			         browserSpanValue = '<%=DepartmentComInfo.getDepartmentName(deparentment)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=4" width="180px" ></brow:browser> 
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(18602,user.getLanguage())%></wea:item>
			<wea:item>
		       <brow:browser viewType="0" name="subdeparentment" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
			         browserValue='<%=subdeparentment%>' 
			         browserSpanValue = '<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subdeparentment),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=164" width="180px" ></brow:browser> 
			</wea:item>
	      
	      <wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
	      <wea:item>
	        	<input class=inputstyle type=text name="name" id="name" value="<%=name %>" style="width:180px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
          </wea:item> 
         </wea:group>
          
		<wea:group context="" attributes="{'Display':'none'}">
			<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
				<input type="button" name="reset" onclick="resetCondition()	" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>	
</div>
	
	
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_ApplyApprove%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

</BODY>

</HTML>
