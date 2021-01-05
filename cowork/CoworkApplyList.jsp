<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CoworkApplayTrans" class="weaver.cowork.CoworkApplayTrans" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<style>
.discuss_content{
	word-break:break-all;
	white-space:normal;
}
.e8_btn{
	padding-left: 0px !important;
    padding-right: 0px !important;
}
</style>

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
	
	
	function applayInfo(coworkid){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83217,user.getLanguage())%>",function(){
			jQuery.post("CoworkApplyOperation.jsp",{"method":"apply","coworkid":coworkid},function(){
				_table. reLoad();
			});
		})
	}
	
	function bitchApplayInfo(obj){
		var ids = _xtable_CheckedCheckboxId();
		if("" == ids){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
			return;
		}
		obj.disabled = false;
		ids = ids.substring(0 ,ids.length-1);
		applayInfo(ids);
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
	String type = Util.null2String(request.getParameter("type"));
	String status = Util.null2String(request.getParameter("status"));
	String jointype = Util.null2String(request.getParameter("jointype"));
	String principal = Util.null2String(request.getParameter("principal"));
	String creater = Util.null2String(request.getParameter("creater"));
	String sqlWhere = "";
	if(!"".equals(name)){
		sqlWhere +=" and t1.name like '%"+name+"%'";
	}
	if(!"".equals(type)){
		sqlWhere +=" and t1.typeid = '"+type+"'";
	}
	if(!"".equals(status)){
		sqlWhere +=" and t1.status = '"+status+"'";
	}
	if(!"".equals(principal)){
		sqlWhere +=" and t1.principal = '"+principal+"'";
	}
	if(!"".equals(creater)){
		sqlWhere +=" and t1.creater = '"+creater+"'";
	}
	
	String orderby = "t1.id";
	String fromSql = " cowork_items t1 ";
	String backfields = "t1.*";
	// status !=-1 排除正在审批中 ，0为驳回 1为通过
	sqlWhere = CoworkApplayTrans.getWhereSql(user.getUID()+"")+" and "+
				" t1.id NOT IN (SELECT coworkid FROM cowork_apply_info WHERE resourceid = "+user.getUID()+" AND status IN (-1,1)) "+
				" and t1.isapply=1 and t1.principal != "+user.getUID()+sqlWhere;
	
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.Cowork_ApplyList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_ApplyList,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlWhere+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
    "<head>"+
    "<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(2097,user.getLanguage()) +"\" column=\"principal\""+
    	" transmethod=\"weaver.cowork.CoworkApplayTrans.getPersonPicture\"/>"+ 
   	"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(344,user.getLanguage()) +"\" column=\"name\" pkey=\"name\"/>"+ 
  	"<col width=\"35%\"  text=\""+ SystemEnv.getHtmlLabelName(85,user.getLanguage()) +"\" column=\"remark\""+
   		" transmethod=\"weaver.general.CoworkTransMethod.formatContent\"/>"+ 
   	"<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(18470,user.getLanguage()) +"\" column=\"replyNum\"/>"+ 
   	"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(83218,user.getLanguage())+"\" column=\"id\""+
    	" transmethod=\"weaver.cowork.CoworkApplayTrans.getCoworkShareNumber\"/>"+ 
   	"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(30585,user.getLanguage())+"\" column=\"id\""+
    	" transmethod=\"weaver.cowork.CoworkApplayTrans.getCoworkApply\" otherpara = \""+user.getLanguage()+"\" />"+ 
	"</head>"+   			
	"</table>";
	
%>

<BODY>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="bitchApplayInfo(this)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(83219,user.getLanguage())%>"/>
	    	<input type="text" class="searchInput" name="searchName" id="searchName"  value="<%=name %>"/>
       		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
			
<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id="weaver" name="weaver" action="CoworkApplyList.jsp" method="post">
	<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
	        <wea:item>
	        	<input class=inputstyle type=text name="name" id="name" value="<%=name %>" style="width:180px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
	        </wea:item> 
	        <wea:item><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></wea:item>
	        <wea:item>
		        <select name="type" size=1 style="width:155px">
		    	<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		        <%
		            String typesql="select * from cowork_types" ;
		           
		            RecordSet.executeSql(typesql);
		            while(RecordSet.next()){
		                String tmptypeid=RecordSet.getString("id");
		                String typename=RecordSet.getString("typename");
		        %>
		            <option value="<%=tmptypeid%>" <%=tmptypeid.equals(type)?"selected":"" %>><%=typename%></option>
		        <%
		            }
		        %>
		        </select>
	        </wea:item>

	      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
	      <wea:item>
		      <select name=status style="width:155px">
		      <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		      <option value="1" <%=status.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
		      <option value="2" <%=status.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
		      </select>
	      </wea:item>
	      <wea:item><%=SystemEnv.getHtmlLabelName(18873,user.getLanguage())%></wea:item>
	      <wea:item>
		      <select name="jointype" style="width:155px">
		      <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		      <option value="1" <%=jointype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18874,user.getLanguage())%></option>
		      <option value="2" <%=jointype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18875,user.getLanguage())%></option>
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
	
	
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_ApplyList%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

</BODY>

</HTML>
