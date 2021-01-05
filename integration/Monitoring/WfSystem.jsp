
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.entity.ComSapSearchList"%>
<%@page import="com.weaver.integration.entity.FieldSystemBean"%>
<%@page import="com.weaver.integration.entity.SapjarBean"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<%@ include file="/integration/integrationinit.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page"/>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<body>
				
				<%
					String threadname=Util.null2String(request.getParameter("threadname")).trim();
					String wfid=Util.null2String(request.getParameter("wfid")).trim();
					String wfname="";
					 if(!"".equals(wfid)){
					 	rs.execute("select workflowname from workflow_base where id='"+wfid+"'");
					 	if(rs.next()){
					 		wfname=rs.getString("workflowname");
					 	}
					 }
					String wftitle=Util.null2String(request.getParameter("wftitle")).trim();
					String titlename=""+SystemEnv.getHtmlLabelName(31674,user.getLanguage()) ;//SAP触发OA流程线程列表
					String imagefilename = "/images/hdMaintenance_wev8.gif";
					String backfields=" name,ID,wfid,wfcreateid,wftitle,(CASE  isopen WHEN 0 THEN '"+SystemEnv.getHtmlLabelName(31675,user.getLanguage())+"'    ELSE  '"+SystemEnv.getHtmlLabelName(31676,user.getLanguage())+"'   end) as isopen,(CASE  wflevel WHEN 0 THEN '"+SystemEnv.getHtmlLabelName(225,user.getLanguage())+"'  WHEN 1 THEN '"+SystemEnv.getHtmlLabelName(15533,user.getLanguage())+"'   ELSE  '"+SystemEnv.getHtmlLabelName(2087,user.getLanguage())+"'   end) as wflevel" ;
					String perpage="10";
					String para1="column:id";
					String para2="column:poolid+column:hpid+column:regserviceid";
					String fromSql=" sap_thread "; 
					String sqlwhere=" 1=1 ";
					if(!"".equals(threadname)){
								sqlwhere+=" and name like '%"+threadname+"%'";
					}
					if(!"".equals(wfid)){
								sqlwhere+=" and  wfid ='"+wfid+"'";
					}
					if(!"".equals(wftitle)){
								sqlwhere+=" and wftitle like '%"+wftitle+"%'";
					}
					
					
					String tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
							"<checkboxpopedom     popedompara=\"column:id\"    showmethod=\"com.weaver.integration.util.IntegratedMethod.publicshowBox\"  />"+
			                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
			                "       <head>"+
			                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(31677,user.getLanguage()) +"\" column=\"name\"   transmethod=\"com.weaver.integration.util.IntegratedMethod.getThreadName\"  otherpara=\""+para1+"\"/>"+
							"           <col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(18624,user.getLanguage()) +"\" column=\"isopen\"  />"+
							"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(23113,user.getLanguage()) +"\" column=\"wfid\"    transmethod=\"com.weaver.integration.util.IntegratedMethod.getThreadWfName\" />"+
							"           <col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(26876,user.getLanguage()) +"\" column=\"wftitle\"    />"+
							"           <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(139,user.getLanguage()) +"\" column=\"wflevel\"    />"+
							"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(28595,user.getLanguage()) +"\" column=\"wfcreateid\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getThreadWfcreateidName\"  />"+
			                "       </head>"+
			                " </table>";
                
			 %>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage()) +",javascript:onNew(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onNew(this);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="doRefresh(this);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this);">
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

				<form action="/integration/Monitoring/WfSystem.jsp" method="post" name="sapserlist" id="sapserlist">
				<input type="hidden" name="checkmenu" value="4">
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(31677,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="text"  name="threadname"  id="threadname"  value="<%=threadname%>"  maxlength="50"  >
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(23113,user.getLanguage())%></wea:item>
    <wea:item>
		<brow:browser viewType='0' name='wfid' browserValue='<%=wfid%>'
			browserOnClick='' browserUrl='/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp'
			hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' linkUrl='#'
			browserSpanValue='<%=wfname %>'></brow:browser>
		<button type='button' class='browser'  onclick="selectForm(this)"></button> 
		<span></span>
		<span><%=wfname %></span>
		<input type='hidden' name='wfid'  id='wfid'  value="<%=wfid%>">
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <input type="text"  name="wftitle"  id="wftitle"  value="<%=wftitle%>" maxlength="50">
    </wea:item>
	</wea:group>
</wea:layout>

<TABLE width="100%">
	<tr>
		<td valign="top">  
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		</td>
	</tr>
</TABLE>

			</form>
	<script type="text/javascript">
		function onUpdate(id){
			var url="/integration/Monitoring/WfSystemNew.jsp?method=update&id="+id;
			var title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>";
			showDialog(title,url,700,500,false);
		}
		function onNew(){
			var url="/integration/Monitoring/WfSystemNew.jsp";
			var title="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>";
			showDialog(title,url,700,500,false);
		}
		
		function showDialog(title,url,width,height,showMax){
			var Show_dialog = new window.top.Dialog();
			Show_dialog.currentWindow = window;   //传入当前window
			Show_dialog.Width = width;
			Show_dialog.Height = height;
			Show_dialog.maxiumnable=showMax;
			Show_dialog.Modal = true;
			Show_dialog.Title = title;
			Show_dialog.URL = url;
			Show_dialog.show();
		}
		
		function doDelete(){
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids){
				alert("<%=SystemEnv.getHtmlLabelName(30678,user.getLanguage()) %>");
				return;
			}else{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>?")){
				window.location.href="/integration/Monitoring/WfSystemOperation.jsp?method=delete&delids="+requestids;
				}
			}		
		}
		
		
	function doRefresh(){
			$("#sapserlist").submit();
	}
	</script>		

</body>
</html>
