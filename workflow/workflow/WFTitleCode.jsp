<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %> 
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowSearchCustom" class="weaver.workflow.search.WorkflowSearchCustom" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="dateutil" class="weaver.general.DateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 
<%
String ownerdepartmentid="";
String formid="";
String bname="";
String helpdocid="";
String hrmcreaterid="";
%>
    
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
String ajax=Util.null2String(request.getParameter("ajax"));
int wfid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
if(wfid != 0){
  dateutil.InitializationWFTitle(""+wfid);
}
%>
 
<body  >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
 
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:WFCodeSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:WFShow(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

  
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmCoder" name="frmCoder" method=post action="WFTitleCode.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}

//本次增加内容，将原来的总开关去掉【由于相关逻辑用的较多 目前先将此开关默认开启 做成隐藏瑜】
String txtUserUse=Util.null2String(request.getParameter("txtUserUse"));//标题启用
%>
 
	
<%
 
    String workflowtielt=Util.null2String(WorkflowComInfo.getWorkflowname(""+wfid));
    String medth=Util.null2String(request.getParameter("medth"));// 
    String showhtml=Util.null2String(request.getParameter("showhtml"));// 
	
	String txtUserTitle=Util.null2String(request.getParameter("txtUserTitle"));//流程标题
	String subtype=Util.null2String(request.getParameter("subtype"));//分部
	String subvalue=Util.null2String(request.getParameter("subvalue"));//分部value
	String subtypevalue=Util.null2String(request.getParameter("subtypevalue"));//分部浏览按钮
	String depmarttype=Util.null2String(request.getParameter("depmarttype"));//部门
	String depmartvalue=Util.null2String(request.getParameter("depmartvalue"));//部门value
	String depmarttypevalue=Util.null2String(request.getParameter("depmarttypevalue"));//部门value
	String resourcetype=Util.null2String(request.getParameter("resourcetype"));//人员
	String resourcevalue=Util.null2String(request.getParameter("resourcevalue"));//人员value
	String resourcetypevalue=Util.null2String(request.getParameter("resourcetypevalue"));//人员value
	String txtUserYear=Util.null2String(request.getParameter("txtUserYear"));//当前年
	String txtUserMouth=Util.null2String(request.getParameter("txtUserMouth"));//当前月
	String txtUserDate=Util.null2String(request.getParameter("txtUserDate"));//当前日期
	String txtName[]=request.getParameterValues("txtName");//字符串value
	String fieldtrRow[]=request.getParameterValues("fieldtrRow");//字符串所属tr
	
	String xh[]=request.getParameterValues("xh");
	if(medth.equals("add")){
	 RecordSet.executeSql("delete Workflow_SetTitle where workflowid='"+wfid+"'");
	if(!"null".equals(""+xh)){
		int j=0;
		for(int i=0;i<xh.length;i++){
			String xhstr=Util.null2String(""+xh[i]);
			if(!xhstr.equals("")){
				String xhvalus[]=xhstr.split("_");
				String xhvalue=Util.null2String(""+xhvalus[0]);
				String xhtype=Util.null2String(""+xhvalus[1]);
				String xhname=Util.null2String(""+xhvalus[2]);
				
				//out.println("==="+xhvalue+"=="+xhtype+"==="+xhname+"<br>");
				if(xhtype.equals("main")){//表示是主字段
				    if(xhname.toLowerCase().equals("txtusertitle")){//流程标题
				    	dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+txtUserTitle,"","txtUserTitle","",""+wfid,"",txtUserUse,showhtml);
				    }if(xhname.toLowerCase().equals("subtype")){//分部 【序号、类型、值、】
				    	dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+subvalue,""+subtypevalue,"subtype",""+subtype,""+wfid,"",txtUserUse,showhtml);
				    }if(xhname.toLowerCase().equals("depmarttype")){//部门
				    	dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+depmartvalue,""+depmarttypevalue,"depmarttype",""+depmarttype,""+wfid,"",txtUserUse,showhtml);
				    }if(xhname.toLowerCase().equals("resourcetype")){//人员
				    	dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+resourcevalue,""+resourcetypevalue,"resourcetype",""+resourcetype,""+wfid,"",txtUserUse,showhtml);
				    }if(xhname.toLowerCase().equals("txtuseryear")){//当前年
				    	dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+txtUserYear,"","txtUserYear","",""+wfid,"",txtUserUse,showhtml);
				    }if(xhname.toLowerCase().equals("txtusermouth")){//当前月
				    	dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+txtUserMouth,"","txtUserMouth","",""+wfid,"",txtUserUse,showhtml);
				    }if(xhname.toLowerCase().equals("txtuserdate")){//当前日期
				    	dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+txtUserDate,"","txtUserDate","",""+wfid,"",txtUserUse,showhtml);
				    }
				}else{//表示是自定义添加字段
			   	//out.println("==="+xhvalue+"=="+xhtype+"==="+xhname+"<br>" +  Util.null2String(request.getParameter("txtName"+xhname))  );
				  String zifustr="";
				  zifustr=Util.null2String(request.getParameter("txtName"+xhname));
				  dateutil.insertWFTileSet(""+xhvalue,""+xhtype,""+zifustr,"","txtName","",""+wfid,xhname,txtUserUse,showhtml); 

				}
			}
		}
	}
	}
%>
  
    
<%

if (rs.getDBType().equalsIgnoreCase("oracle")) {
	rs.executeSql("select * from Workflow_SetTitle where workflowid='"+wfid+"' order by  to_number(xh) asc ");
}else{
	rs.executeSql("select * from Workflow_SetTitle where workflowid='"+wfid+"' order by  convert(int,xh) asc ");
} 
if(rs.next()){
	txtUserUse=Util.null2String(rs.getString("txtUserUse"));	
}


String showhtml01="";
int count=0;
int count2=0;
boolean isshow=false;
%>    

	<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
	</div>
	<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:217px;position:absolute;z-index:9999;font-size:12px;">
		<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(124847,user.getLanguage()) %></span>
	</span>
	
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>31844
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31844,user.getLanguage()) %>"/>
	</jsp:include>

	<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="WFCodeSave(this)">
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
	</table> 
 <wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
		 
			
		 <%
		    String  groupShow = "{'samePair':'groupShow','groupDisplay':'' }";
		    if("1".equals(txtUserUse)) groupShow = "{'samePair':'groupShow','groupDisplay':''}";
			
			
				String  itemShow = "{'samePair':'itemShow','display':'','isTableList':'true'}";
			if("1".equals(txtUserUse)) itemShow = "{'isTableList':'true','samePair':'itemShow','display':''}";
	     %>
	
			
			<wea:group context='<%=SystemEnv.getHtmlLabelName(81816,user.getLanguage())+"  " +SystemEnv.getHtmlLabelName(124821,user.getLanguage())%>'  attributes="<%=groupShow%>">
				<wea:item  attributes='<%=itemShow %>'>
		  <table  id="table" class="ListStyle"  width="100%">
		     
		     <%
			 if (rs.getDBType().equalsIgnoreCase("oracle")) {
			     rs.executeSql("select * from Workflow_SetTitle where workflowid='"+wfid+"' order by to_number(xh) asc ");
			 }else{
		        rs.executeSql("select * from Workflow_SetTitle where workflowid='"+wfid+"' order by  convert(int,xh) asc ");
			  }
			  
		      while(rs.next()){
		    	  isshow=true;
		    	  String xhs=Util.null2String(rs.getString("xh"));
		          String fieldtype=Util.null2String(rs.getString("fieldtype"));
		          String fieldvalue=Util.null2String(rs.getString("fieldvalue"));
		          String fieldlevle=Util.null2String(rs.getString("fieldlevle"));
		          String fieldname=Util.null2String(rs.getString("fieldname"));
		          String fieldzx=Util.null2String(rs.getString("fieldzx"));
		          String trrowids=Util.null2String(rs.getString("trrowid"));
		           showhtml01=Util.null2String(rs.getString("showhtml"));
		          String tr01="";
		          if(fieldtype.equals("main")){
		        	  if(fieldname.toLowerCase().equals("txtusertitle")){//流程标题
		        		  tr01="tr1";
		        	%>
				        <tr id="tr1" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
					        <td class="6"><input customer1='main_txtUserTitle' type="hidden" name="xh" id="xh" value="" size="6">
					        	<span movingicon style="display:inline-block;width:20px;"></span>
					            <%=SystemEnv.getHtmlLabelName(81651,user.getLanguage()) %>
					       	</td>
						    <td>
					     		<input class="inputStyle" tzCheckbox="true" <% if(fieldvalue.equals("1")) {%> checked <%}%> type="checkbox" id="txtUserTitle" name="txtUserTitle" value="1" >
					     	</td>
				         	<td colspan="3"></td>
				         	<td align="right"></td>
				        </tr>
		        	  <%}if(fieldname.toLowerCase().equals("subtype")){//分部
		        		  tr01="tr0";
		        		  %>
					       <tr id="tr0"  height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
					         	<td width="10%"><input customer1='main_subtype' type="hidden" name="xh" id="xh" value="" size="6">
					         		<span movingicon style="display:inline-block;width:20px;"></span>
					         		       <%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %>
					         	</td>
					         	<td width="10%">
							        <select style="width:150px"  id="subtype" name="subtype" onchange="onChangsub()">
								        <option value="0" <%if ("0".equals(fieldzx)) out.println("selected");%> ></option>
								        <option value="1" <%if ("1".equals(fieldzx)) out.println("selected");%> >  <%=SystemEnv.getHtmlLabelName(19437,user.getLanguage()) %></option>
								        <option value="2" <%if ("2".equals(fieldzx)) out.println("selected");%> ><%=SystemEnv.getHtmlLabelName(22788,user.getLanguage()) %></option>
							        </select>
					         	</td>
					          	<td align="left" width="18%">  
					          		<span id="showsub01" <% if(!"1".equals(fieldzx)){ %>style="display:none;" <%} %>>
					           			 <brow:browser viewType="0" name="subtypevalue" browserValue='<%=fieldlevle %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=!fieldlevle.equals("0")?Util.toScreen(SubCompanyComInfo.getSubCompanyname(fieldlevle+""),user.getLanguage()):""%>'> </brow:browser> 
			           			
					         		</span>
					         	</td>
						        <td align="right" width="8%"> 
						        	<span id="showsub02" <% if(fieldzx.equals("0")){ %>style="display:none;" <%} %>>
					        	  		  <%=SystemEnv.getHtmlLabelName(15935,user.getLanguage()) %>
					        	 	</span>
						        </td>
						        <td width="10%"> 
						            <span id="showsub03" <% if(fieldzx.equals("0")){ %>style="display:none;" <%} %>>
						        	 	<select   id="subvalue" name="subvalue" class=inputstyle  style="width: 150px;">
							        		<option value="0" <%if ("0".equals(fieldvalue)) out.println("selected");%>> <%=SystemEnv.getHtmlLabelName(81807,user.getLanguage()) %></option>
							        		<option value="1" <%if ("1".equals(fieldvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81808,user.getLanguage()) %></option>
							        		<option value="2" <%if ("2".equals(fieldvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81809,user.getLanguage()) %></option>
						        	  	</select>
						        	</span>
						        </td>
						   		<td align="right" width="8%"> 
						   		</td>
					        </tr>
		        		    
		        	  <% }if(fieldname.toLowerCase().equals("depmarttype")){//部门
		        		  tr01="tr2";
		        		  %>
					       <tr id="tr2" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
					         	<td class="2">
					         		<input customer1='main_depmarttype' type="hidden" name="xh" id="xh" value="" size="6">
					         		<span movingicon style="display:inline-block;width:20px;"></span>
					         		 <%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>
					         	</td>
					         	<td>
					          		<select style="width: 150px" id="depmarttype" name="depmarttype" onchange="onChangdept()">
								        <option value="0" <%if ("0".equals(fieldzx)) out.println("selected");%>></option>
								        <option value="1" <%if ("1".equals(fieldzx)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage()) %></option>
								        <option value="2" <%if ("2".equals(fieldzx)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81673,user.getLanguage()) %></option>
						          	</select>
					         	</td>
					          	<td align="left"> 
					           		<span id="depmarttype01" <% if(!"1".equals(fieldzx)){ %>style="display:none;" <%} %>>
					              		
								<brow:browser viewType="0" name="depmarttypevalue" browserValue='<%=fieldlevle %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=!fieldlevle.equals("0")?Util.toScreen(DepartmentComInfo.getDepartmentname(fieldlevle+""),user.getLanguage()):""%>'> </brow:browser> 
			             	
					             	</span>
					        	</td>
					            <td align="right"> 
					              	<span id="depmarttype02" <% if(fieldzx.equals("0")){ %> style="display:none;" <%} %>>
					        	  		 <%=SystemEnv.getHtmlLabelName(15935,user.getLanguage()) %>
					        		</span>
					         	</td>
					            <td width="10%"> 
						           <span id="depmarttype03" <% if(fieldzx.equals("0")){ %> style="display:none;" <%} %>>
							          	<select style="width: 150px" id="depmartvalue" name="depmartvalue">
							        		<option value="1" <%if ("1".equals(fieldvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(32107,user.getLanguage()) %></option>
											<option value="0" <%if ("0".equals(fieldvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81810,user.getLanguage()) %></option>
	
							        		<option value="2" <%if ("2".equals(fieldvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(22290,user.getLanguage()) %></option>
						        	  	</select> 
					        		</span>
					        	</td>
						    	<td align="right"> 
						    	</td>
					        </tr>
		        		  
		       		  <% }if(fieldname.toLowerCase().equals("resourcetype")){//人员
		       			  tr01="tr3";
		       			%>
					       <tr id="tr3" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
					         	<td class="3">
						         	<input customer1='main_resourcetype' type="hidden" name="xh" id="xh" value="" size="6">
						         	<span movingicon style="display:inline-block;width:20px;"></span>
						         	<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %>
					         	</td>
					         	<td>
						         	<select style="width: 150px" id="resourcetype" name="resourcetype" onchange="onChangresource()" >
							            <option value="0" <%if ("0".equals(fieldzx)) out.println("selected");%>></option>
							            <option value="1" <%if ("1".equals(fieldzx)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81811,user.getLanguage()) %></option>
							            <option value="2" <%if ("2".equals(fieldzx)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(882,user.getLanguage()) %></option>
						          	</select>
					         	</td>
					           <td align="left"> 
					             	<span  id="resourcetype01" <% if(!"1".equals(fieldzx)){ %>style="display:none;" <%} %>>
					                	<brow:browser viewType="0" name="resourcetypevalue" browserValue='<%= ""+fieldlevle %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=!fieldlevle.equals("0")?Util.toScreen(ResourceComInfo.getResourcename(fieldlevle+""),user.getLanguage()):""%>'> </brow:browser>	               
					         		</span>
					         	</td>
					       		<td align="right"> 
					        		<span  id="resourcetype02" <% if(fieldzx.equals("0")){ %>style="display:none;" <%} %>>
					        	  		 <%=SystemEnv.getHtmlLabelName(15935,user.getLanguage()) %>
					        	  	</span>
					         	</td>
					            <td>
					            	<span  id="resourcetype03" <% if(fieldzx.equals("0")){ %>style="display:none;" <%} %>>
							        	<select style="width: 150px" id="resourcevalue" name="resourcevalue">
								        	<option value="0" <%if ("0".equals(fieldvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81812,user.getLanguage()) %></option>
								        	<option value="1" <%if ("1".equals(fieldvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(27940,user.getLanguage()) %></option>
							        	</select> 
					        	    </span>
					        	</td>
						    	<td align="right"> 
						    	</td>
					        </tr>
		       			
		     		  <% }if(fieldname.toLowerCase().equals("txtuseryear")){//当前年
		     			 tr01="tr4";
		     			 %>

				       <tr id="tr4" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
				         	<td class="4">
				         		<input customer1='main_txtUserYear' type="hidden" name="xh" id="xh" value="" size="6">
				         		<span movingicon style="display:inline-block;width:20px;"></span>
				         		<%=SystemEnv.getHtmlLabelName(22793,user.getLanguage()) %>
				         	</td>
				         	<td>
				         		<input class="inputStyle" <% if(fieldvalue.equals("1")) {%> checked <%}%> tzCheckbox="true" type="checkbox" name="txtUserYear" id="txtUserYear" value="1" >
				     		</td>
					    	<td colspan="3"></td>
				         	<td align="right"></td>
				        </tr>
				       
		        	  <%}if(fieldname.toLowerCase().equals("txtusermouth")){//当前月
		        		  tr01="tr5";
		        		  %>
					       <tr id="tr5" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
					         	<td class="5">
					         		<input customer1='main_txtUserMouth' type="hidden" name="xh" id="xh" value="" size="6">
					         		<span movingicon style="display:inline-block;width:20px;"></span>
					         		 <%=SystemEnv.getHtmlLabelName(81717,user.getLanguage()) %>
					         	</td>
					        	<td>
					         		<input class="inputStyle" tzCheckbox="true"  <% if(fieldvalue.equals("1")) {%> checked <%}%> type="checkbox" name="txtUserMouth" id="txtUserMouth" value="1" >
					         	</td>
					         	<td colspan="3"></td>
					         	<td align="right"></td>
					        </tr>
		        		  
		        	  <%}if(fieldname.toLowerCase().equals("txtuserdate")){//当前日期
		        		  tr01="tr6";
		        		  %>
				       <tr  height="50px" class="DataLight" style="cursor:move;" id="tr6" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
				         	<td class="6">
				         		<input customer1='main_txtUserDate' type=hidden name="xh" id="xh" value="" size="6">
				         		<span movingicon style="display:inline-block;width:20px;"></span>
				         		  <%=SystemEnv.getHtmlLabelName(15625,user.getLanguage()) %>
				         	</td>
					    	<td>
					    		<input class="inputStyle" tzCheckbox="true" type="checkbox"  <% if(fieldvalue.equals("1")) {%> checked <%}%>  name="txtUserDate" id="txtUserDate" value="1" >
					    	</td>
				         	<td colspan="3"></td>
				         	<td align="right"></td>
				        </tr>
		        	 <% }
		          }else{ 
		        	  //if(!trrowids.equals("")){
		        	    // String trrowstr[]=trrowids.split("_");
		        	     String rowID="";//trrowstr[0];
		        	     String rowID2="";//trrowstr[1];
		        	     StringBuffer sb=new StringBuffer();
		        	     count++;
		        	     sb.append(" <tr class='DataLight' style='cursor:move;' onmouseover='showMoveIcon(this)' onmouseout='hideMoveIcon(this, event)'  height=50px id='zfc"+rowID+"_"+rowID2+"'><td><input customer1='sub_"+trrowids+"' type='hidden' name='xh' id='xh' size='6' rowtr='"+trrowids+"'><span movingicon style='display:inline-block;width:20px;'></span>&nbsp;"+SystemEnv.getHtmlLabelName(27903,user.getLanguage())+""+count+"</td><td> <input name='fieldtrRow' id='fieldtrRow' type='hidden' size='6'  value='"+trrowids+"'><input name='txtName"+trrowids+"' id='txtName"+trrowids+"' type='text' size='100' style='width:180px' value='"+fieldvalue+"'></td><td colspan=3></td><td align=right></td></tr>");
		        	     out.println(sb.toString());
		        	     count2=Util.getIntValue(trrowids,100)*100;
		        	  //}
		          }

		      }
		      
		      if(!isshow){
		     %>
			        <tr id="tr1" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
				        <td class="6"><input customer1='main_txtUserTitle' type="hidden" name="xh" id="xh" value="" size="6">
				        	<span movingicon style="display:inline-block;width:20px;"></span>
				            <%=SystemEnv.getHtmlLabelName(81651,user.getLanguage()) %>
				       	</td>
					    <td>
				     		<input class="inputStyle" tzCheckbox="true" <% if(txtUserTitle.equals("1")) {%> checked <%}%> type="checkbox" id="txtUserTitle" name="txtUserTitle" value="1" >
				     	</td>
			         	<td colspan="3"></td>
			         	<td align="right"></td>
			        </tr>
			        <tr id="tr0"  height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
			         	<td width="10%"><input customer1='main_subtype' type="hidden" name="xh" id="xh" value="" size="6">
			         		<span movingicon style="display:inline-block;width:20px;"></span>
			         		  <%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %>
			         	</td>
			         	<td width="10%">
					        <select style="width:150px"  id="subtype" name="subtype" onchange="onChangsub()">
						        <option value="0" <%if ("0".equals(subtype)) out.println("selected");%> ></option>
						        <option value="1" <%if ("1".equals(subtype)) out.println("selected");%> > <%=SystemEnv.getHtmlLabelName(19437,user.getLanguage()) %></option>
						        <option value="2" <%if ("2".equals(subtype)) out.println("selected");%> ><%=SystemEnv.getHtmlLabelName(22788,user.getLanguage()) %></option>
					        </select>
			         	</td>
			          	<td align="left" width="18%"> 
			          		<span id="showsub01"   style="display:none;"  >
							
							    <brow:browser viewType="0" name="subtypevalue" browserValue='<%=subtypevalue %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue='<%=!subtypevalue.equals("0")?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subtypevalue+""),user.getLanguage()):""%>'> </brow:browser> 
			           			
			         		</span>
			         	</td>
				        <td align="right" width="8%"> 
						<span id="showsub02" style="display:none;"  >
			        	  	 <%=SystemEnv.getHtmlLabelName(15935,user.getLanguage()) %>
							</span>
				        </td>
				        <td width="10%"> 
				            <span id="showsub03"   style="display:none;"  >
				        	 	<select   id="subvalue" name="subvalue" class=inputstyle  style="width: 150px;">
					        		<option value="0" <%if ("0".equals(subvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81807,user.getLanguage()) %></option>
					        		<option value="1" <%if ("1".equals(subvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81808,user.getLanguage()) %></option>
					        		<option value="2" <%if ("2".equals(subvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81809,user.getLanguage()) %></option>
				        	  	</select>
				        	</span>
				        </td>
				   		<td align="right" width="8%"> 
				   		</td>
			        </tr>
			        <tr id="tr2" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
			         	<td class="2">
			         		<input customer1='main_depmarttype' type="hidden" name="xh" id="xh" value="" size="6">
			         		<span movingicon style="display:inline-block;width:20px;"></span>
			         		<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>
			         	</td>
			         	<td>
			          		<select style="width: 150px" id="depmarttype" name="depmarttype" onchange="onChangdept()">
						        <option value="0" <%if ("0".equals(depmarttype)) out.println("selected");%>></option>
						        <option value="1" <%if ("1".equals(depmarttype)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage()) %></option>
						        <option value="2" <%if ("2".equals(depmarttype)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81673,user.getLanguage()) %></option>
				          	</select>
			         	</td>
			          	<td align="left"> 
			           		<span id="depmarttype01"  style="display:none;"  >
			              		  
								
								<brow:browser viewType="0" name="depmarttypevalue" browserValue='<%=depmarttypevalue %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue='<%=!depmarttypevalue.equals("0")?Util.toScreen(DepartmentComInfo.getDepartmentname(depmarttypevalue+""),user.getLanguage()):""%>'> </brow:browser> 
			             	
							</span>
			        	</td>
			            <td align="right"> 
			              	<span id="depmarttype02"  style="display:none;">
			        	  	<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage()) %>
			        		</span>
			         	</td>
			            <td width="10%"> 
				           <span id="depmarttype03"  style="display:none;"  >
					          	<select style="width: 150px" id="depmartvalue" name="depmartvalue">
					        		<option value="1" <%if ("1".equals(depmartvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(32107,user.getLanguage()) %></option>
					        		<option value="0" <%if ("0".equals(depmartvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81810,user.getLanguage()) %></option>
					        		<option value="2" <%if ("2".equals(depmartvalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(22290,user.getLanguage()) %></option>
				        	  	</select> 
			        		</span>
			        	</td>
				    	<td align="right"> 
				    	</td>
			        </tr>
			       
			        <tr id="tr3" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
			         	<td class="3">
				         	<input customer1='main_resourcetype' type="hidden" name="xh" id="xh" value="" size="6">
				         	<span movingicon style="display:inline-block;width:20px;"></span>
				         	 <%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %>
			         	</td>
			         	<td>
				         	<select style="width: 150px" id="resourcetype" name="resourcetype" onchange="onChangresource()" >
					            <option value="0" <%if ("0".equals(resourcetype)) out.println("selected");%>></option>
					            <option value="1" <%if ("1".equals(resourcetype)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81811,user.getLanguage()) %></option>
					            <option value="2" <%if ("2".equals(resourcetype)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(882,user.getLanguage()) %></option>
				          	</select>
			         	</td>
			           <td align="left"> 
			             	<span  id="resourcetype01"  style="display:none;"  >
			                	<brow:browser viewType="0" name="resourcetypevalue" browserValue='<%= ""+resourcetypevalue %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp" width="80%" browserSpanValue='<%=!resourcetypevalue.equals("0")?Util.toScreen(ResourceComInfo.getResourcename(resourcetypevalue+""),user.getLanguage()):""%>'> </brow:browser>	               
			         		</span>
			         	</td>
			       		<td align="right"> 
			        		<span  id="resourcetype02"  style="display:none;"  >
			        	  		  <%=SystemEnv.getHtmlLabelName(15935,user.getLanguage()) %>
			        	  	</span>
			         	</td>
			            <td>
			            	<span  id="resourcetype03"  style="display:none;"  >
					        	<select style="width: 150px" id="resourcevalue" name="resourcevalue">
						        	<option value="0" <%if ("0".equals(resourcevalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(81812,user.getLanguage()) %></option>
						        	<option value="1" <%if ("1".equals(resourcevalue)) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(27940,user.getLanguage()) %></option>
					        	</select> 
			        	    </span>
			        	</td>
				    	<td align="right"> 
				    	</td>
			        </tr>
			       
			        <tr id="tr4" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
			         	<td class="4">
			         		<input customer1='main_txtUserYear' type="hidden" name="xh" id="xh" value="" size="6">
			         		<span movingicon style="display:inline-block;width:20px;"></span>
			         		<%=SystemEnv.getHtmlLabelName(22793,user.getLanguage()) %>
			         	</td>
			         	<td>
			         		<input class="inputStyle" <% if(txtUserYear.equals("1")) {%> checked <%}%> tzCheckbox="true" type="checkbox" name="txtUserYear" id="txtUserYear" value="1" >
			     		</td>
				    	<td colspan="3"></td>
			         	<td align="right"></td>
			        </tr>
			       
			        <tr id="tr5" height="50px" class="DataLight" style="cursor:move;" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
			         	<td class="5">
			         		<input customer1='main_txtUserMouth' type="hidden" name="xh" id="xh" value="" size="6">
			         		<span movingicon style="display:inline-block;width:20px;"></span>
			         		 <%=SystemEnv.getHtmlLabelName(81717,user.getLanguage()) %>
			         	</td>
			        	<td>
			         		<input class="inputStyle" tzCheckbox="true"  <% if(txtUserMouth.equals("1")) {%> checked <%}%> type="checkbox" name="txtUserMouth" id="txtUserMouth" value="1" >
			         	</td>
			         	<td colspan="3"></td>
			         	<td align="right"></td>
			        </tr>
			        <tr  height="50px" class="DataLight" style="cursor:move;" id="tr6" onmouseover="showMoveIcon(this)" onmouseout="hideMoveIcon(this, event)">
			         	<td class="6">
			         		<input customer1='main_txtUserDate' type="hidden" name="xh" id="xh" value="" size="6">
			         		<span movingicon style="display:inline-block;width:20px;"></span>
			         		<%=SystemEnv.getHtmlLabelName(81813,user.getLanguage()) %>
			         	</td>
				    	<td>
				    		<input class="inputStyle" tzCheckbox="true" type="checkbox"  <% if(txtUserDate.equals("1")) {%> checked <%}%>  name="txtUserDate" id="txtUserDate" value="1" >
				    	</td>
			         	<td colspan="3"></td>
			         	<td align="right"></td>
			        </tr>
		       <%} %>
			   
			   
			 
		   </table>		
				</wea:item>
			 
			</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(81814,user.getLanguage()) %>' attributes="<%=groupShow%>">
					
					<wea:item  attributes='<%=itemShow %>' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<div style="overflow: auto; width: 99%">
						<label id="lab"> 
						 
						<%= showhtml01%>
						
						</label> 
						</div>
					</wea:item>
				</wea:group>
				
				
				 
			</wea:layout>
	<div style="height:100px!important"></div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0 !important;">
		<div style="padding:5px 0px;">
			<wea:layout needImportDefaultJsAndCss="true">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
			    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClose()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</div>
</div>
</div>

<br>
<%
String unophrmid="";
%>
 
<center>
     <input  type="hidden" name="txtUserUse" value="1"   >
     <input type="hidden" value="<%=showhtml01 %>" name="showhtml" id="showhtml"> 
     <input type="hidden" value="<%=wfid%>" name="workflowid">
     <input type="hidden" value="<%=user.getLoginid()%>" name="userlogin" id="userlogin">
      <input type="hidden" name="substring" id="substring">
      <input type="hidden"   name="deptstring" id="deptstring">
      <input type="hidden"   name="userstring" id="userstring">
      <input type="hidden"  id="medth" name="medth">
      <input type="hidden"  id="workflowtielt" name="workflowtielt" value="<%=workflowtielt %>">
     <input name='txtTRLastIndex2' type='hidden' id='txtTRLastIndex2' value="<%=count2 %>" />
     <input name='txtTRLastIndex' type='hidden' id='txtTRLastIndex' value="<%=count %>" />
<center>
</div>
</div>
</form>
</body>
  
 <script language="javascript"> 
 
 function toShowGroup(obj){
	var isChecked = obj.checked;
	   if(isChecked){
		  showGroup("groupShow");
		  showEle("itemShow");

	   }else{
		  hideGroup("groupShow");
		   hideEle("itemShow");
	   }
	}
	
	
 function onShowManagerID(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if (data.id!=""){
			//update by liaodong for qc57566 in 20130906 start
			  //spanname.innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>";
			  spanname.innerHTML = data.name;
			//end
			inputname.value=data.id;
		}else{
			spanname.innerHTML = "";
			inputname.value="";
		}
	}
}
 
  function onChangsub(){
	  var subtype=$("#subtype").val();
	  if(subtype=="0"){
		  $("#showsub01").css('display','none');
		  $("#showsub02").css('display','none');
		  $("#showsub03").css('display','none');
	  }if(subtype=="1"){
		   $("#showsub01").css('display','block');
		  $("#showsub02").css('display','block');
		  $("#showsub03").css('display','block');
	  }if(subtype=="2"){
		  $("#showsub01").css('display','none');
		  $("#showsub02").css('display','block');
		  $("#showsub03").css('display','block');
		 
	  }
  }
  
    function onChangdept(){
	  var subtype=$("#depmarttype").val();
	  if(subtype=="0"){
		  $("#depmarttype01").css('display','none');
		  $("#depmarttype02").css('display','none');
		  $("#depmarttype03").css('display','none');
	  }if(subtype=="1"){
		  $("#depmarttype01").css('display','block');
		  $("#depmarttype02").css('display','block');
		  $("#depmarttype03").css('display','block');
	  }if(subtype=="2"){
		  $("#depmarttype01").css('display','none');
		  $("#depmarttype02").css('display','block');
		  $("#depmarttype03").css('display','block');
	  }
  }
      function onChangresource(){
	  var subtype=$("#resourcetype").val();
	  if(subtype=="0"){
		  $("#resourcetype01").css('display','none');
		  $("#resourcetype02").css('display','none');
		  $("#resourcetype03").css('display','none');
	  }if(subtype=="1"){
		  $("#resourcetype01").css('display','block');
		  $("#resourcetype02").css('display','block');
		  $("#resourcetype03").css('display','block');
	  }if(subtype=="2"){
		  $("#resourcetype01").css('display','none');
		  $("#resourcetype02").css('display','block');
		  $("#resourcetype03").css('display','block');
	  }
  }
   
 function showTable(tablename,tablevalue){
	    var tablenames= new Array(); //定义一数组 
	  	var tablevalues= new Array(); //定义一数组 
	 	tablenames=tablename.split(","); //字符分割 
	    tablevalues=tablevalue.split(","); //字符分割 #
	   
		var tablestring=" <table width=90%' align='center'  style='color:#59BDFF;border-width: 1px;border-color: #59BDFF;border-collapse: collapse;'>"  ;	
		var tr01="<tr>";
		var tr02="<tr>";
		for (i=0;i<tablenames.length ;i++ ) 
		{ 
			if(tablenames[i]!=''){
				tr01+="<td width='151' align='center' valign='middle'	style='bgcolor:#EEF9FF;border-width: 1px;padding: 8px;border-style: solid;background-color: #eef9ff;'>";
				tr01+=tablenames[i];
				tr01+="</td>";
				
				tr02+="<td width='151' align='center' valign='middle'	style='border-width: 1px;padding: 8px;border-style: solid;'>";
				tr02+=tablevalues[i];
				tr02+="</td>";
			}
		}
		 if(tablenames.length>0){
	           tr01+="<td width='151' rowspan='2' align='center' valign='middle'  ><img src='/images/ecology8/meeting/refish_s_wev8.png' style='cursor:pointer' onclick='WFShow()' title='<%=SystemEnv.getHtmlLabelName(221,user.getLanguage()) %>'></td>";
	  
	  }
		
	  tr01+="</tr>";
	  tr02+="</tr>";
	  tablestring+=tr01+tr02;
	 
	  
	  tablestring+="</table>";
	 document.getElementById("lab").innerHTML=tablestring;
	// document.getElementById("showhtml").value=tablestring;
   }  
  
   
  function WFShow(p1, p2, p3, flag){
	
	  
	  
	  var myDate = new Date();
	  var yearst=myDate.getFullYear();    //获取完整的年份(4位,1970-????)
	  var monthst=myDate.getMonth()+1;       //获取当前月份(0-11,0代表1月)
	  var datest=myDate.getDate();     
       if(monthst<10){
	      monthst="0"+monthst;
	   }
	   
		if(datest<10){
	      datest="0"+datest;
	   }
	  
      var userlogin=document.getElementById("userlogin").value;  
	  SetXhTr();
	 var returstr="";   
	 var table =document.getElementById("table");
     var rows = table.rows.length;
	 var tablename="";
     var tablevalue="";
     var _i = 0;
     if (!!flag) {
     	_i = window.__i;
		returstr = window.__returstr;
   		tablename = window.__tablename;
   		tablevalue = window.__tablevalue;
     } else {
     	__displayloaddingblock();
     }
     
    for(var i=_i;i<table.rows.length;i++){
    	if (window.__isajax == false) {
    		setTimeout(function () {
    			WFShow(p1, p2, p3, true);
    		}, 500);
    		return;
    	}
    	
      	if(table.rows[i].style.display!="none"){//判断当前行是否有隐藏属性，处理删除自定义字符时顺序问题
	    	var textinputs = table.rows[i].cells[0];//获取当前行第一列
	    	var aInput = textinputs.getElementsByTagName("input");//查找第一行第一列是否有input元素
	    	if (aInput[0]) {//如果存在input属性 则将input中赋值 这个主要是从新根据input获取tr的顺序
	    		   var customer1=aInput[0].getAttribute("customer1");
	    	       var rowtr=aInput[0].getAttribute("rowtr");
	    	       str = new Array;
                   str = customer1.split("_");
                   if(str.length>0){
                	   if(str[0]=='main'){
                		   if(str[1].toLocaleLowerCase()=='txtusertitle'){//流程标题
                			  if(document.getElementById("txtUserTitle").checked){
                				  var workflowtielt=document.getElementById("workflowtielt").value;
                			      returstr+=""+workflowtielt;
								  tablename+=",<%=SystemEnv.getHtmlLabelName(81651,user.getLanguage()) %>";
                			      				tablevalue+=","+workflowtielt;
                			   }
                		   }if(str[1].toLocaleLowerCase()=='subtype'){//分部
	                			var subtype=document.getElementById("subtype").value;
	                		    var subtypevalue=document.getElementById("subtypevalue").value;
		  					    var subvalue=document.getElementById("subvalue").value;
	                		    if(subtype=='1'){//判断是指定分部 通过异步将它对应的类型下面的 【简称、全称、编号】获取过来
	                		    	window.__isajax = false;
	                		    	   jQuery.ajax({
										 type: "POST",
										 url: "/workflow/workflow/WFTitleCodeAjax.jsp",
										 data: "types=sub&valuetype="+subvalue+"&valuestr="+subtypevalue,
										 cache: false,
										 /*async:false,*/
										 dataType: 'json',
										    success: function(msg){
											if(msg.done.success=="success"){
										 	 if(msg["data0"]){
										 	  var _data = msg["data0"];
										 	    if(_data.retustr!=undefined&&_data.retustr!='undefined'){
										 	       returstr+=_data.retustr;//将获取的数据赋给预览
												   tablename+=",<%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %>";
               			      					   tablevalue+=","+_data.retustr;
										 	    }
										 	 }
											}else{
												alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);
											}
											__next(i, returstr, tablename, tablevalue );
										 }
									 });
	                		    }if(subtype=='2'){
	                		    	if(userlogin.toLocaleLowerCase()=='sysadmin'){
	                		    	  if(subvalue=='0'){
	                		    		 returstr+="<%=SystemEnv.getHtmlLabelName(81807,user.getLanguage()) %>";
										 tablename+=",<%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %>";
               			      			 tablevalue+=",<%=SystemEnv.getHtmlLabelName(81807,user.getLanguage()) %>";
	                		    	  }if(subvalue=='1'){
	                		    		 returstr+="<%=SystemEnv.getHtmlLabelName(81808,user.getLanguage()) %>";	
										 tablename+=",<%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %>";
			               			     tablevalue+=",<%=SystemEnv.getHtmlLabelName(81808,user.getLanguage()) %>";
	                		    	  }if(subvalue=='2'){
	                		    		 returstr+="<%=SystemEnv.getHtmlLabelName(81809,user.getLanguage()) %>";	
										 tablename+=",<%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %>";
			               			    tablevalue+=",<%=SystemEnv.getHtmlLabelName(81809,user.getLanguage()) %>";
	                		    	  }
	                		    	}else{
	                		    	window.__isajax = false;
	                		    	 jQuery.ajax({
										 type: "POST",
										 url: "/workflow/workflow/WFTitleCodeAjax.jsp",
										 data: "types=sub&valuetype="+subvalue+"&valuestr="+subtypevalue,
										 cache: false,
										 /*async:false,*/
										 dataType: 'json',
										    success: function(msg){
											if(msg.done.success=="success"){
										 	 if(msg["data0"]){
										 	  var _data = msg["data0"];
										 	    if(_data.retustr!=undefined&&_data.retustr!='undefined'){
										 	       returstr+=_data.retustr;//将获取的数据赋给预览
												   tablename+=",<%=SystemEnv.getHtmlLabelName(33553,user.getLanguage()) %>";
			              			      		   tablevalue+=","+_data.retustr;
										 	    }
										 	 }
											}else{
												alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);
											}
											__next(i, returstr, tablename, tablevalue );
										 }
									 });
	                		    	}
	                		     }
                		   }if(str[1].toLocaleLowerCase()=='depmarttype'){//部门
	                			 var depmarttype=document.getElementById("depmarttype").value;
								 var depmarttypevalue=document.getElementById("depmarttypevalue").value;
								 var depmartvalue=document.getElementById("depmartvalue").value;
								
								  if(depmarttype=='1'){
								  window.__isajax = false;
		                		      jQuery.ajax({
										 type: "POST",
										 url: "/workflow/workflow/WFTitleCodeDeptAjax.jsp",
										 data: "types=dept&valuetype="+depmartvalue+"&valuestr="+depmarttypevalue,
										 cache: false,
										 /*async:false,*/
										 dataType: 'json',
										    success: function(msg){
											if(msg.done.success=="success"){
										 	 if(msg["data0"]){
										 	  var _data = msg["data0"];
										 	    if(_data.retustr!=undefined&&_data.retustr!='undefined'){
										 	       returstr+=_data.retustr;//将获取的数据赋给预览
												   tablename+=",<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>";
              			      					   tablevalue+=","+_data.retustr;
										 	    }
										 	 }
											}else{
												alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);
											}
											__next(i, returstr, tablename, tablevalue );
										 }
									 });
	                			 }
	                			 if(depmarttype=='2'){
	                		    	if(userlogin.toLocaleLowerCase()=='sysadmin'){//判断当前用户是否管理员
	                		    	  if(depmartvalue=='0'){
	                		    		 returstr+="<%=SystemEnv.getHtmlLabelName(81810,user.getLanguage()) %>";
										 tablename+=",<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>";
               			      			 tablevalue+=",<%=SystemEnv.getHtmlLabelName(81810,user.getLanguage()) %>"; 
	                		    	  }if(depmartvalue=='1'){
	                		    		 returstr+="<%=SystemEnv.getHtmlLabelName(32107,user.getLanguage()) %>";	
										  tablename+=",<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>";
               			      			 tablevalue+=",<%=SystemEnv.getHtmlLabelName(32107,user.getLanguage()) %>"; 
	                		    	  }if(depmartvalue=='2'){
	                		    		 returstr+="<%=SystemEnv.getHtmlLabelName(22290,user.getLanguage()) %>";	
										  tablename+=",<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>";
               			      			 tablevalue+=",<%=SystemEnv.getHtmlLabelName(22290,user.getLanguage()) %>"; 
	                		    	  }
	                		    	}else{
	                		    	window.__isajax = false;
	                		    		 jQuery.ajax({
										 type: "POST",
										 url: "/workflow/workflow/WFTitleCodeDeptAjax.jsp",
										 data: "types=dept&valuetype="+depmartvalue+"&valuestr="+depmarttypevalue,
										 cache: false,
										 /*async:false,*/
										 dataType: 'json',
										    success: function(msg){
											if(msg.done.success=="success"){
										 	 if(msg["data0"]){
										 	  var _data = msg["data0"];
										 	    if(_data.retustr!=undefined&&_data.retustr!='undefined'){
										 	       returstr+=_data.retustr;//将获取的数据赋给预览
												    tablename+=",<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>";
              			      					   tablevalue+=","+_data.retustr;
										 	    }
										 	 }
											}else{
												alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);
											}
											__next(i, returstr, tablename, tablevalue );
										 }
									 });
	                		    	}
	                			 }
                		   }
                		   if(str[1].toLocaleLowerCase()=='resourcetype'){//人员
                			    var resourcetype=document.getElementById("resourcetype").value;
							    var resourcetypevalue=document.getElementById("resourcetypevalue").value;
	 							var resourcevalue=document.getElementById("resourcevalue").value;
                			    if(resourcetype=='1'){
                			    window.__isajax = false;
			                		   jQuery.ajax({
										 type: "POST",
										 url: "/workflow/workflow/WFTitleCodeUserAjax.jsp",
										 data: "types=resource&valuetype="+resourcevalue+"&valuestr="+resourcetypevalue,
										 cache: false,
										 /*async:false,*/
										 dataType: 'json',
										    success: function(msg){
											if(msg.done.success=="success"){
										 	 if(msg["data0"]){
										 	  var _data = msg["data0"];
										 	    if(_data.retustr!=undefined&&_data.retustr!='undefined'){
										 	       returstr+=_data.retustr;//将获取的数据赋给预览
												    tablename+=",<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %>";
               			      					   tablevalue+=","+_data.retustr; 
										 	    }
										 	 }
											}else{
												alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);
											}
											__next(i, returstr, tablename, tablevalue );
										 }
									 });
                			    }if(resourcetype=='2'){
                			    	if(userlogin.toLocaleLowerCase()=='sysadmin'){//判断当前用户是否管理员
	                		    	  if(resourcevalue=='0'){
	                		    		 returstr+="<%=SystemEnv.getHtmlLabelName(81812,user.getLanguage()) %>";
										 tablename+=",<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %>";
               			      			 tablevalue+=",<%=SystemEnv.getHtmlLabelName(81812,user.getLanguage()) %>"; 
	                		    	  }if(resourcevalue=='1'){
	                		    		  returstr+="<%=SystemEnv.getHtmlLabelName(27940,user.getLanguage()) %>";	
										  tablename+=",<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %>";
               			      			  tablevalue+=",<%=SystemEnv.getHtmlLabelName(27940,user.getLanguage()) %>"; 	
	                		    	  } 
	                		    	}else{
	                		    		window.__isajax = false;
	                		    		jQuery.ajax({
										 type: "POST",
										 url: "/workflow/workflow/WFTitleCodeUserAjax.jsp",
										 data: "types=resource&valuetype="+resourcevalue+"&valuestr=",
										 cache: false,
										 /*async:false,*/
										 dataType: 'json',
										    success: function(msg){
											if(msg.done.success=="success"){
										 	 if(msg["data0"]){
										 	  var _data = msg["data0"];
										 	    if(_data.retustr!=undefined&&_data.retustr!='undefined'){
										 	       returstr+=_data.retustr;//将获取的数据赋给预览
												   tablename+=",<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage()) %>";
               			      			 		   tablevalue+=","+_data.retustr; 	
										 	    }
										 	 }
											}else{
												alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);
											}
											__next(i, returstr, tablename, tablevalue );
										 }
									 });
	                		    	}
                			    }
                			   
                		   }if(str[1].toLocaleLowerCase()=='txtuseryear'){//当前年
                			   if(document.getElementById("txtUserYear").checked){
                				   returstr+=""+yearst;
								    tablename+=",<%=SystemEnv.getHtmlLabelName(22793,user.getLanguage()) %>";
               			      	   tablevalue+=","+yearst; 
                			   }
                		   }if(str[1].toLocaleLowerCase()=='txtusermouth'){//当前月
                			  if(document.getElementById("txtUserMouth").checked){
                				   returstr+=""+monthst;
								   tablename+=",<%=SystemEnv.getHtmlLabelName(81717,user.getLanguage()) %>";
               			      	   tablevalue+=","+monthst; 
                			   }
                		   }if(str[1].toLocaleLowerCase()=='txtuserdate'){//当前日期
                			  if(document.getElementById("txtUserDate").checked){
                				   returstr+=""+datest;
								    tablename+=",<%=SystemEnv.getHtmlLabelName(15625,user.getLanguage()) %> ";
               			      	    tablevalue+=","+datest; 
                			   }
                		   }
                	   }else{
                		    var zfc=document.getElementById("txtName"+rowtr).value;
                		    returstr+=""+zfc;
							tablename+=","+table.rows[i].cells[0].innerText;
               			    tablevalue+=","+zfc; 
                	   }
                   }
	    		   //document.getElementById("lab").innerHTML+="<br>==="+table.rows[i].cells[0].innerHTML+"==value:"+value+"==customer1:"+customer1;
	    	 }
    	}else{
		 
    	  table.deleteRow(i);
    	}
    }
    
	 __hidloaddingblock();
    //
   // document.getElementById("lab").innerHTML=returstr;
	  showTable(tablename,tablevalue);
  }
   
  function SetXhTr(){
	var table =document.getElementById("table");
    var rows = table.rows.length;
    for(var i=0;i<table.rows.length;i++){
      	if(table.rows[i].style.display!="none"){//判断当前行是否有隐藏属性，处理删除自定义字符时顺序问题
	    	var textinputs = table.rows[i].cells[0];//获取当前行第一列
	    	var aInput = textinputs.getElementsByTagName("input");//查找第一行第一列是否有input元素
	    	 if (aInput[0]) {//如果存在input属性 则将input中赋值 这个主要是从新根据input获取tr的顺序
	    		   var customer1=aInput[0].getAttribute("customer1");
	    		    aInput[0].value=(i+1)+"_"+customer1;
	    		 //  document.getElementById("lab").innerHTML+="<br>==="+table.rows[i].cells[0].innerHTML;
	    	 }
    	}
    }
  }
  /**
   *保存当前配置项 
   */
  function WFCodeSave(obj){
	//obj.disabled=true;
	//本次增加开发内容【分部、部门、人员选择指定类型时，增加必填控制】
	  if(jQuery("#subtype").val()=='1'||jQuery("#depmarttype").val()=='1'||jQuery("#resourcetype").val()=='1'){
	 var  checkstrs="";
	 if(jQuery("#subtype").val()=='1'){
		checkstrs="subtypevalue"; 
	 }
	  if(jQuery("#depmarttype").val()=='1'){
		  if(checkstrs==''){
			checkstrs="depmarttypevalue";   
		  }else{
			  checkstrs+=",depmarttypevalue"; 
		  }
	 }
	  if(jQuery("#resourcetype").val()=='1'){
		   if(checkstrs==''){
			 checkstrs="resourcetypevalue"; 
		  }else{
			  checkstrs+=",resourcetypevalue"; 
		  }
 
	 }
	  if(!check_form(frmCoder,checkstrs)){
	 	return;
	 }
	}
 
	 WFShow();
	 //SetXhTr();
     document.getElementById("medth").value="add";
     frmCoder.submit();
  }
  
  /**
   * 添加行（添加自定义字符行）
   * @param {Object} trObj
   */
  function onAddTR(me) 
  { 
    var txtTRLastIndex = findObj("txtTRLastIndex",document);
    var rowID = parseInt(txtTRLastIndex.value)+1;
    var txtTRLastIndex2 = findObj("txtTRLastIndex2",document);
    var rowID2 = parseInt(txtTRLastIndex2.value)+1;

    $(me).parent().parent().after("<tr class='DataLight' height=50px id='zfc"+rowID+"_"+rowID2+"' style='cursor:move;display:none;' onmouseover=\"showMoveIcon(this)\" onmouseout=\"hideMoveIcon(this, event)\"><td><input customer1='sub_"+rowID+""+rowID2+"' type='hidden' name='xh' id='xh' size='6' rowtr='"+rowID+""+rowID2+"'><span movingicon style='width:20px;display:inline-block;'></span>&nbsp;<%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) %>"+rowID+"</td><td><input name='fieldtrRow' id='fieldtrRow' type='hidden' size='6'  value='"+rowID+""+rowID2+"'><input name='txtName"+rowID+""+rowID2+"' id='txtName"+rowID+""+rowID2+"' type='text' class='inputStyle' style='width:180px;' size='100' value=''></td><td colspan=3></td><td align=right></td></tr>"); 

    $(me).parent().parent().next().fadeIn();

    txtTRLastIndex.value = (rowID).toString() ;
    txtTRLastIndex2.value = (rowID2 ).toString() ;
	

  } 
  
    /**
     * 鼠标移入当前行，切换当前行的背景
     * @param {Object} obj
     */
  function checkTrColor(obj){ 
    	 if(document.all){ 
 	        obj.style.backgroundColor=obj.style.backgroundColor.toLowerCase()=='#f3f7df'?"":"#f3f7df" ;//fcfdf7
 	  }else{
 		    
 		  if(obj.style.backgroundColor.indexOf("rgb(")>-1){
    		obj.style.backgroundColor='' ;//fcfdf7
    	}else{
    		obj.style.backgroundColor='#f3f7df' ;//fcfdf7
    	}
 		  
 	  }
 }
     
 function checkTrColor01(obj){ 
 	  obj.style.backgroundColor=obj.style.backgroundColor.toLowerCase()=='#e4fbff'?"":"#e4fbff" ;//fcfdf7
 }
 
 function showRGB(obj){
 red=obj.red.value;
 green=obj.green.value
 blue=obj.blue.value;
 //将RGB转换为16进制Hex值
 hexcode="#"+toHex(red)+toHex(green)+toHex(blue);
 document.bgColor=obj.hexval.value=hexcode;
}
 
 /**
  * 获取元素值
  * @param {Object} theObj
  * @param {Object} theDoc
  * @return {TypeName} 
  */
 function findObj(theObj, theDoc)
 {
  var p, i, foundObj;
 
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++)
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++)
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
 
  return foundObj;
}

function showMoveIcon(me, e){
	e = e || window.event;
    var o = e.relatedTarget || e.toElement;

    if( o.tagName != 'IMG'){
    	$(me).find('span[movingicon]').html("<img src='/proj/img/move-hot_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage()) %>'/>");

    	if( me && me.id.indexOf('zfc') < 0 ){
    		$(me).find('td:last-child').html("<img class='toolpic additem' style='cursor:default;' title='<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage()) %>' src='/wui/theme/ecology8/weaveredittable/img/add2_wev8.png'>");

			$(me).find('td:last-child > img').click(function(){
				onAddTR(this);
			});
    	}else{
    		$(me).find('td:last-child').html("<img class='toolpic additem' style='cursor:default;' title='<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage()) %>' src='/wui/theme/ecology8/weaveredittable/img/delete2_wev8.png'>");

			$(me).find('td:last-child > img').click(function(){
			
		 
			//$(me).parent().remove();
			 	 onDelTr(this);
				
				
				
			});
    	}
    }
}
 /**
    * 删除自定义行，此时是假删除 即隐藏当前行
    * @param {Object} zfc
    * @param {Object} trrowid
    */
  function onDelTr(me){
    $(me).parent().parent().remove(); 
	// me.value = "del";
	// me.disabled = true;
	// $(me).parent().parent().fadeOut();

	  var txtTRLastIndex = findObj("txtTRLastIndex",document);
	  var rowID = parseInt(txtTRLastIndex.value);
	  txtTRLastIndex.value = (rowID-1).toString() ;
  }
function hideMoveIcon(me, e){
	e = e || window.event;
    var o = e.relatedTarget || e.toElement;

    if( o == null || o.tagName != 'IMG'){
    	$(me).find('span[movingicon]').html("");
		$(me).find('td:last-child').html("");
    }
}
   
function registerDragEvent(){
	var fixHelper = function(e, ui) {
	    ui.children().each(function() { 
	        $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了
	        $(this).height($(this).height());  
	    });  
	    return ui;  
	};
  
	var copyTR = null;
	var startIdx = 0;
	  
	jQuery("#table tbody tr").bind("mousedown",function(e){
		copyTR = jQuery(this).next("tr.Spacing");
	});
	  
	jQuery("#table tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
	    helper: fixHelper,                  //调用fixHelper  
	    axis:"y",  
	    start:function(e, ui){
           	ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
           	if(ui.item.hasClass("notMove")){
           		e.stopPropagation();
           	}
           	if(copyTR){
      			copyTR.hide();
      		}
      		startIdx = ui.item.get(0).rowIndex;
        	return ui;  
	    },  
	    stop:function(e, ui){
	        ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行  
	        if(copyTR){
		      	if(ui.item.get(0).rowIndex>startIdx){
		       		ui.item.before(copyTR.clone().show());
		       	}else{
		       		ui.item.after(copyTR.clone().show());
		       	}
	      	  	copyTR.remove();
	      	  	copyTR = null;
	      	}
	       	return ui;  
	    }  
	});
};

function doClose(){
	parent.getDialog(window).close();
}

jQuery(document).ready(function($) {
 
    WFShow();
	registerDragEvent();

	jQuery('.e8_box demo2').height(100);
});
      
      
      
      function __displayloaddingblock() {
			try {
				var pTop= document.body.offsetHeight/2+document.body.scrollTop - 50 + jQuery(".e8_boxhead", document).height()/2 ;
     			var pLeft= document.body.offsetWidth/2 - (40);
     			
				jQuery("#submitloaddingdiv", document).css({"top":pTop, "left":pLeft, "display":"inline-block;"});
				jQuery("#submitloaddingdiv", document).show();
				jQuery("#submitloaddingdiv_out", document).show();
			} catch (e) {}
		}
		
		function __hidloaddingblock( ) {
			try {
				//var __top = (jQuery(document.body).height())/2 - 40;
				//var __left = (jQuery(document.body).width() - parseInt(157))/2
				//jQuery("#submitloaddingdiv", parent.document).css({"top":__top, "left":__left, "display":"inline-block;"});
				jQuery("#submitloaddingdiv", document).hide();
				jQuery("#submitloaddingdiv_out", document).hide();
			} catch (e) {}
		}
		
		function __next(i, returstr, tablename, tablevalue ) {
			window.__isajax = true;
			window.__i = i;
			window.__returstr = returstr;
    		window.__tablename = tablename;
    		window.__tablevalue = tablevalue;
		}
      	
    </script>
</html>
