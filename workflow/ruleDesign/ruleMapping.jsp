<!DOCTYPE html>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = ""+SystemEnv.getHtmlLabelName(84547,user.getLanguage());
	String needfav = "";
	String needhelp = "";
	String isclose = Util.null2String(request.getParameter("isclose"));
	int linkid = Util.getIntValue(request.getParameter("linkid"));
	int formid = Util.getIntValue(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	int mapid = Util.getIntValue(request.getParameter("mapid"),0);
	
	int detailid = Util.getIntValue(request.getParameter("detailid"), -1);
	int isnotenc = Util.getIntValue(request.getParameter("isnotenc"), -1);
	String rulename = "";
	String ruleid = "";
	String condit = "";
	String maplistids = "";
	String rulecondits = "";
	String ruleids = "";
	int ruleRel = 1;
	maplistids = Util.null2String(request.getParameter("maplistids"));
	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	//System.out.println(maplistids);
	if(!maplistids.equals("")){
	    
	    
	    if (rulesrc.equals("7") || rulesrc.equals("8")) {
	        Map<String, String> ruleinfokv = RuleBusiness.getRuleInfoByRIds(Util.getIntValue(rulesrc), linkid + "");
	        ruleids = ruleinfokv.get(RuleBusiness.RULE_ID_KEY);
	        rulecondits = ruleinfokv.get(RuleBusiness.RULE_DESC_KEY);
	    } else {
		//if(!maplistids.contains(","))maplistids+=",";
			String[] _rids = Util.TokenizerString2(maplistids,",");
			for(int i =0;i<_rids.length;i++)
			{
				//if(_rids[i].equals(""))break;
				RecordSet1.executeSql(" select t1.id,t1.condit from rule_base t1, rule_maplist t2 where t1.id = t2.ruleid and t2.id="+_rids[i]);
				if(RecordSet1.first()){
					if(i==_rids.length-1)
					{
						rulecondits += Util.null2String(RecordSet1.getString("condit")) ;
						ruleids += Util.null2String(RecordSet1.getString("id")) ;
					}
					else
					{
						ruleids += Util.null2String(RecordSet1.getString("id"))+"," ;
						RecordSet relationrs = new RecordSet();
						
						relationrs.executeSql("select ruleRelationship from workflow_flownode where nodeid = " + linkid);
		 				if(relationrs.next()){
		 					ruleRel = Util.getIntValue(relationrs.getString("ruleRelationship"), 1);
		 				}
		 				
			 			if(ruleRel == 1){
							rulecondits += Util.null2String(RecordSet1.getString("condit")) + " AND " ;
			 				//condits += condrs.getString("condit") + "AND";
			 			}else{
							rulecondits += Util.null2String(RecordSet1.getString("condit")) + " OR " ;
			 				//condits += condrs.getString("condit") + "OR";
			 			}
						
					}
				}
			}
	    }
	}
	if(mapid >0)
	{
		ruleid = Util.null2String(request.getParameter("ruleid"));
		RecordSet1.executeSql(" select rulename,condit from rule_base where id="+ruleid);
		if(RecordSet1.first()){
			rulename = Util.null2String(RecordSet1.getString("rulename"));
			condit = Util.null2String(RecordSet1.getString("condit"));
		}
	}
	
	String wfid = Util.null2String(request.getParameter("wfid"));
//	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	//System.out.println("nodeid"+nodeid);
	String rownum = Util.null2String(request.getParameter("rownum"));
	String wfname = "";
	if(rulesrc.equals("4"))
		wfname = WorkflowComInfo.getWorkflowname(linkid+"");
	else
		wfname = WorkflowComInfo.getWorkflowname(wfid);
	String formname = "";
	if(isbill.equals("0"))
		formname = FormComInfo.getFormname(formid+"");
	else if(isbill.equals("1"))
		formname = SystemEnv.getHtmlLabelName(Util.getIntValue(BillComInfo.getBillLabel(formid+""),0),user.getLanguage());
	String isen = Util.null2String(request.getParameter("isen"));
	%>
<html>
    <head>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
		var isclose = "<%=isclose%>";
		var dialog;
		 	dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
		if(isclose === "1")
		{
			if(parentWin.parent.setRuleRelation){
				parentWin.parent.setRuleRelation("<%=ruleRel%>");
			}
			if(parentWin.parent.setParentPic){
				parentWin.parent.setParentPic("<%=linkid%>",true,"<%=rulesrc%>","<%=ruleids%>","<%=rulecondits%>","<%=maplistids%>");
			}
			parentWin._table.reLoad();
			dialog.close();
		}
   		$(document).ready(function(){
	  		resizeDialog(document);
	  		if(<%=mapid%> > 0)
	  			getMapDetail("<%=ruleid%>","<%=rulename%>","<%=condit%>");
		});
		
		function callbackMeth(evt,data,name,paras,tg)
		{
			if(data.id)
			{
				var _data = "ruleid="+data.id+"&linkid=<%=linkid%>&formid=<%=formid%>&isbill=<%=isbill%>&rownum=<%=rownum%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>";
				_data += "&detailid=<%=detailid %>";
				jQuery("[name=rulename]").html(data.name);
				jQuery("[name=rulecondit]").html(data.condit);
				jQuery("[name=ruleid]").val(data.id);
				jQuery.ajax({
					type: "POST",
				  	url: "/workflow/ruleDesign/ruleMappingField.jsp",
				  	data:_data,
				  	success:function(fieldHtml)
				  	{
				  		jQuery("#mapfield").html(fieldHtml);
				  		jQuery("#mapfield").find("select").selectbox("attach");
				  		
				  	}
				});
			}else{
				delRule();
			}
		}
		
		function getMapDetail(ruleid,rulename,condit)
		{
			var _data = "ruleid="+ruleid+"&linkid=<%=linkid%>&formid=<%=formid%>&isbill=<%=isbill%>&rownum=<%=rownum%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>";
			if(<%=mapid%> > 0)
			{
				_data += "&mapid=<%=mapid%>";
			}
			_data += "&detailid=<%=detailid %>";
			jQuery("[name=rulename]").html(rulename);
			jQuery("[name=rulecondit]").html(condit);
			jQuery("[name=ruleid]").val(ruleid);
			jQuery.ajax({
				type: "POST",
			  	url: "/workflow/ruleDesign/ruleMappingField.jsp",
			  	data:_data,
			  	success:function(fieldHtml)
			  	{
			  		jQuery("#mapfield").html(fieldHtml);
			  		jQuery("#mapfield").find("select").selectbox("attach");
			  	}
			});
		}
		
		function onSave()
		{
			jQuery("input[name='nodeid']").val(jQuery("#nodeSelect").val());			
			jQuery("input[name='meetCondition']").val(jQuery("#meetSelect").val());
			if(check_form(mpform,'ruleid')){
				mpform.submit();
			}
		}
		
		function delRule(){
			jQuery("[name=rulename]").html('');
			jQuery("[name=rulecondit]").html('');
			jQuery("[name=ruleid]").val('');		
			jQuery("#mapfield").html('');
			return true;
		}
        </script>
    </head>
    <body>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <jsp:include page="/systeminfo/commonTabHead.jsp">
   		<jsp:param name="mouldID" value="workflow"/>
   		<jsp:param name="navName" value="<%=titlename%>"/>
	</jsp:include>
    <div id="container" class="zDialog_div_content">
    <table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onSave();"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
    <form action="/workflow/ruleDesign/ruleMappingOperation.jsp" id="mpform" name="mpform" method="post">
    	<input type="hidden" name="linkid" value="<%=linkid %>" >
    	<input type="hidden" name="formid" value="<%=formid %>" >
    	<input type="hidden" name="isbill" value="<%=isbill %>" >
    	<input type="hidden" name="rulesrc" value="<%=rulesrc %>" >
    	<input type="hidden" name="wfid" value="<%=wfid %>" >
    	<input type="hidden" name="mapid" value="<%=mapid %>">
    	<input type="hidden" name="ruleid" value="<%=ruleid %>" >
    	<input type="hidden" name="rownum" value="<%=rownum %>">
    	<input type="hidden" name="nodeid" >
    	<input type="hidden" name="meetCondition" >
    	
    	<input type="hidden" name="detailid" value="<%=detailid %>">
    	<wea:layout type="2col">
    		<wea:group context='<%=SystemEnv.getHtmlLabelName(84548,user.getLanguage())%>' >
    			<wea:item><%=SystemEnv.getHtmlLabelName(84548,user.getLanguage())%></wea:item>
    			<wea:item>
    				<%if(mapid>0){ %>
    					<span name="rulename"><%=rulename %></span>
    				<%} else{%>
    				<brow:browser name="selectrule" viewType="0" hasBrowser="true" hasAdd="false" 
			        					browserUrl="/workflow/ruleDesign/ruleBrowser.jsp" 
			                  			isMustInput="2" isSingle="true" hasInput="true"
			                  			_callback ="callbackMeth"
			                  			beforeDelCallback="delRule"
			                  			completeUrl="/data.jsp?type=ruleBrowser"  width="250px" browserValue="" browserSpanValue="" />
			    	<%} %>
    			</wea:item>
    			<wea:item><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>  <!-- 条件 -->
    			<wea:item><span name="rulecondit"></span></wea:item>
    		</wea:group>
    		<wea:group context='<%=SystemEnv.getHtmlLabelName(84549,user.getLanguage())%>'  attributes="{'groupDisplay':'none'}"> <!-- 映射关系 -->
    			<wea:item attributes="{'isTableList':'true','id':'mapfield'}"></wea:item>
    		</wea:group>
    	</wea:layout>
	</form>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="height:30px;">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
    </body>
</html>
