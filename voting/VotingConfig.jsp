
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%

boolean canmaint = HrmUserVarify.checkUserRight("Voting:Maint",user);
if(user.getUID() == 1  ) canmaint = true;//管理员才有权限
if (!canmaint) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}


//获取 调查应用设置
RecordSet.executeSql("select * from votingconfig where id=0");
RecordSet.next();
String doc=RecordSet.getString("doc");
String flow=RecordSet.getString("flow");
String customer=RecordSet.getString("customer");
String project=RecordSet.getString("project");
String annex=RecordSet.getString("annex");
String annexcatalogpath=RecordSet.getString("annexcatalogpath");
String mainid=RecordSet.getString("mainid");
String subid=RecordSet.getString("subid");
String seccateid=RecordSet.getString("seccateid");
String votingid=RecordSet.getString("votingid");

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24111, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    //RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
    //RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33700,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelNames("82753",user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="VotingConfigOperation.jsp" method=post>
<input type=hidden name=method value="add">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		     //相关文档
	         <wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="doc" id="doc" <% if(!"".equals(doc)){ %> checked <%} %> />
	         </wea:item>
	         //相关流程
	         <wea:item><%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="flow" id="flow" <% if(!"".equals(flow)){ %> checked <%} %> />
	         </wea:item>
	         //相关客户
	         <wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" id="customer" name="customer" <% if(!"".equals(customer)){ %> checked <%} %> />
	         </wea:item>
	         //相关项目
	         <wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name=project id="project" <% if(!"".equals(project)){ %> checked <%} %> />
	         </wea:item>
	         //相关附件
	        <%--  
	         <wea:item><%=SystemEnv.getHtmlLabelName(22194, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name=annex id="annex" <% if(!"".equals(annex)){ %> checked <%} %> />
	         </wea:item>
	         //附件上传目录 
	         <wea:item><%=SystemEnv.getHtmlLabelName(22210, user.getLanguage())%></wea:item>
	         <wea:item>
	            <span>
			      <brow:browser viewType="0" name="pathbrowser"
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1' _callback="afterBackCatalogData"
					completeUrl="/data.jsp?type=categoryBrowser" 
					browserValue='<%=annexcatalogpath%>' browserSpanValue='<%=annexcatalogpath %>'  width="30%">
			       </brow:browser> 	
			     </span>
			        <input type=hidden id='annexcatalogpath' name='annexcatalogpath' value="<%=annexcatalogpath %>">
				    <input type=hidden id='mainid' name='mainid' value="<%=mainid %>">
				    <input type=hidden id='subid' name='subid' value="<%=subid %>">
				    <input type=hidden id='seccateid' name='seccateid' value="<%=seccateid %>">	
	         </wea:item>
		--%>
	</wea:group>
</wea:layout>
</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language="javascript">

function doSubmit() {	
	if($("#annex").attr("checked") == true && jQuery("#mainid").val() == ""){
	     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18214,22210", user.getLanguage())%>!");
	     return false;
	}
	document.frmMain.submit();
}



function afterBackCatalogData(event,datas,name){
	if (datas) {
        if (datas.tag>0)  {
           $("#pathbrowserspan").html("<a href='#"+datas.id+"'>"+datas.path+"</a>");
           $("#annexcatalogpath").val(datas.path);
           $("#mainid").val(datas.mainid);
           $("#subid").val(datas.subid);
           $("#seccateid").val(datas.id);
        }else{
           $("#pathbrowserspan").html("");
           $("#annexcatalogpath").val("");
           $("#mainid").val("");
           $("#subid").val("");
           $("#seccateid").val("");
        }
    }
}
 


</script>




</BODY></HTML>

