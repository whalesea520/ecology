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
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfAgentCondition" class="weaver.workflow.request.wfAgentCondition" scope="page" />
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
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 
<%
String ownerdepartmentid="";
String bname="";
String helpdocid="";
String hrmcreaterid="";
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body  >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="frmmain" action="/workflow/request/wfAgentConditionOperator.jsp" method="post">
<%
//System.out.println("=====start："+new Date().toLocaleString());
ArrayList arr = new ArrayList();
int userid=user.getUID();
String isDialog = Util.null2String(request.getParameter("isdialog"));
 String types= Util.null2String(request.getParameter("types"));
String checked="";

int agentid = Util.getIntValue(request.getParameter("agentid"),-1);//主键
boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}

String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
int infoKey=Util.getIntValue(request.getParameter("infoKey"),0);;
int agenterid=0;
int beagenterid=0;
String workflowid="";
String _beginDate="";
String _beginTime="";
String _endDate="";
String _endTime="";
String _isCreateAgenter="";
String _isProxyDeal="";
String _isPendThing="";
String _agenttype="";
rs.executeSql("select workflowid,agenterid,beagenterid,beginDate,beginTime,endDate,endTime,ispending,isCreateAgenter,agenttype from workflow_Agent  where agentId="+agentid);
if(rs.next()){
	workflowid=Util.null2String(rs.getString("workflowid"));
	agenterid=Util.getIntValue(rs.getString("agenterid"),0);
	beagenterid=Util.getIntValue(rs.getString("beagenterid"),0);
	_beginDate=Util.null2String(rs.getString("beginDate"));
	_beginTime=Util.null2String(rs.getString("beginTime"));
	_endDate=Util.null2String(rs.getString("endDate"));
	_endTime=Util.null2String(rs.getString("endTime"));
	_isPendThing=Util.null2String(rs.getString("ispending"));
	//_isProxyDeal=Util.null2String(rs.getString("isProxyDeal"));
	_isCreateAgenter=Util.null2String(rs.getString("isCreateAgenter"));
	_agenttype=Util.null2String(rs.getString("agenttype"));
}
_isProxyDeal=wfAgentCondition.isProxyDeal(""+agentid,""+_agenttype);

String workflowname=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid));
String formid="";
String isbill="";
rs.executeSql("select formid,isbill from workflow_base where id='"+workflowid+"'");
if(rs.next()){//formid,isbill
	formid=Util.null2String(rs.getString("formid"));
	isbill=Util.null2String(rs.getString("isbill"));
}
 

%>
	<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
	</div>
 
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/> 
	   <jsp:param name="navName" value="<%=workflowname %>"/>
	</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0"  >
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave(this)">
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
	</table> 
	</div>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(82595,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">	
			<table  id="table" class="ListStyle"  width="100%">
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
		     <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 代理人  -->
			 <%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%>
			 </td>
			 <td	class="field"  colspan="3">
			 <brow:browser viewType="0" name="agenterId" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="185px" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"  browserSpanValue=""></brow:browser></td>
		     </tr>
		   
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 代理创建权限 -->
			 	<%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%>
			 </td>
			 <td	class="field" colspan="3">
			 <INPUT class=InputStyle tzCheckbox="true" type=checkbox value=1 name='isCreateAgenter'>
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 代理流程处理 -->
			 	<%=SystemEnv.getHtmlLabelName(82585,user.getLanguage())%>
			 </td>
			 <td	class="field" >
			 <INPUT class=InputStyle   checked  tzCheckbox="true" type=checkbox value=1 style="display:" name='isProxyDeal' onclick="ShowFnaHidden(this,'isPendThing')" >
			 </td>
			 
			 <td height="44" colspan="2"   class="field" id="isPendThingtr" ><!-- 代理已有待办事宜 -->
			 	 <div style="margin-left:190px">
			 	<%=SystemEnv.getHtmlLabelName(33250,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <INPUT class=InputStyle tzCheckbox="true" type=checkbox value="1"  id="isPendThing" name="isPendThing" >
				 </div>
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
		   </table>	
		</wea:item>	
		</wea:group>
	</wea:layout>
	
	<wea:layout  >
		<wea:group context='<%=SystemEnv.getHtmlLabelName(82596,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">	
		<table  id="table" class="ListStyle"  width="100%">
	     <tr >
	       <td height="44" class="fieldName"	width="160px" ><!-- 条件 -->
	       	<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage()) %>
	       </td>
	       <td  class="field" width="265px">
	    	    <button type=button  class=Browser1 onclick="onShowBrowsers()"></button>
	    	  	<input type=hidden name=fromsrc id=fromsrc value="2">
	    	  	<input type=hidden name=conditionss id=conditionss>
	    	  	<input type="hidden" name="conditioncn" id="conditioncn"  >
	    	  	<input type="hidden" name="conditionkeyid" id="conditionkeyid"  >
	    	  	<input type=hidden name=rulemaplistids id=rulemaplistids>
	    	  	<input type=hidden name=ruleRelationship id=ruleRelationship>
			  	<span id="conditions">
			   	</span>
	       </td>
	        <td height="44" class="fieldName"	width="160px"  ><!-- 批次 -->
			 	<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>  
			
			 </td>
			 <td  class="field"  >
				 <INPUT  type=text    name='agentbatch'  style ="width:130px;"  onchange="check_number('agentbatch');checkDigit(this,1000,2)"   >
			 </td>
	     </tr>
	     <tr >
		 <td height="44" ></td>
		 <td></td>
	     </tr>
	   </table>	
		</wea:item>
		</wea:group>
	</wea:layout>
	 	 
		 	<wea:layout type="table" attributes="{'cols':'7','cws':'5%,10%,10%,10%,10%,10%,10%','formTableId':'oTable4op'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(82601,user.getLanguage())%>'>
					<wea:item type="thead"><input type="checkbox" name="checkall" onclick="checkAllChkBox();"></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(82585,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(33250,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(82596,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></wea:item>
					<wea:item type="groupHead">
						<button type=button id="addBtn" Class=addbtn type=button accessKey=A onclick="addRow();" title="A-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"></BUTTON>
						<button type=button id="deleteBtn" Class=delbtn type=button accessKey=D onclick="deleteRow4op()" title="D-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"></BUTTON></div>
					</wea:item>	
					<%
					int rowsum=0;
					rs.executeSql(" select * from workflow_agentConditionSet where agentid='"+agentid+"' and agenttype='"+_agenttype+"'  order by agentbatch asc ");
					while(rs.next()){
						String agentconditid=rs.getString("id");
						String bagentuid_code=rs.getString("bagentuid");
						String agentuid_code=rs.getString("agentuid");
						String conditionss_code=rs.getString("conditionss");
						String conditioncn_code=rs.getString("conditioncn");
						String conditionkeyid_code=rs.getString("conditionkeyid");
						String ruleRelationship_code=rs.getString("ruleRelationship");
						
						
						String beginDate_code=rs.getString("beginDate");
						String beginTime_cond=rs.getString("beginTime");
						String endDate_cond=rs.getString("endDate");
						String endTime_cond=rs.getString("endTime");
						String agentbatch_cond=rs.getString("agentbatch");
						String isCreateAgenter_cond=rs.getString("isCreateAgenter");
						String isProxyDeal_cond=rs.getString("isProxyDeal");
						String isPendThing_cond=rs.getString("isPendThing");
						String workflowid_cond=rs.getString("workflowid");
					
					%>
					<wea:item>
					<input type='checkbox' name='check_node' value='<%=rowsum%>' rowindex='<%=rowsum%>' >
					<input type='hidden' name='group_<%=rowsum%>_agenterId'  value='<%=agentuid_code %>'>
					<input type='hidden'  name='group_<%=rowsum%>_isCreateAgenter' value='<%=isCreateAgenter_cond %>'>
					<input type='hidden'  name='group_<%=rowsum%>_isProxyDeal' id='group_<%=rowsum%>_isProxyDeal' value='<%=isProxyDeal_cond %>'>
					<input type='hidden'  name='group_<%=rowsum%>_isPendThing' value='<%=isPendThing_cond %>'>
					<input type='hidden' name='group_<%=rowsum%>_conditionss' id='group_<%=rowsum%>_conditionss' value='<%=conditionss_code %>'><!-- 条件id值 -->
					<input type='hidden' id='group_<%=rowsum%>_conditioncn' name='group_<%=rowsum%>_conditioncn' value='<%=conditioncn_code %>'><!-- 条件名字 -->
				    <input type='hidden' name='group_<%=rowsum%>_conditionkeyid' id='group_<%=rowsum%>_conditionkeyid' value='<%=conditionkeyid_code %>'><!-- 条件名字 -->
				 	<input type='hidden' name='group_<%=rowsum%>_ruleRelationship' id='group_<%=rowsum%>_ruleRelationship' value='<%=ruleRelationship_code %>'><!-- 条件名字 -->
				
					<input type='hidden' name='group_<%=rowsum%>_agentid' value='<%=agentid%>'>
					<input type='hidden' name='group_<%=rowsum%>_beagenterid' value='<%=beagenterid%>'>
					<input type='hidden' name='group_<%=rowsum%>_beginDate' value='<%=beginDate_code%>'>
					<input type='hidden' name='group_<%=rowsum%>_beginTime' value='<%=beginTime_cond%>'>
					<input type='hidden' name='group_<%=rowsum%>_endDate' value='<%=endDate_cond%>'>
					<input type='hidden' name='group_<%=rowsum%>_endTime' value='<%=endTime_cond%>'>
					</wea:item>
					<wea:item>
					  <%=ResourceComInfo.getLastname(agentuid_code) %>
					</wea:item>
					<wea:item>
					 <%
						if(isCreateAgenter_cond.equals("1")){
							out.println(SystemEnv.getHtmlLabelName(82677,user.getLanguage()));
						}else{
							out.println(SystemEnv.getHtmlLabelName(82676,user.getLanguage()));
						}
					 %>
					</wea:item>
					
					<wea:item>
					 <%
						if(isProxyDeal_cond.equals("1")){
							out.println(SystemEnv.getHtmlLabelName(82677,user.getLanguage()));
						}else{
							out.println(SystemEnv.getHtmlLabelName(82676,user.getLanguage()));
						}
					 %>
					</wea:item>
					<wea:item>
					  <%
						if(isPendThing_cond.equals("1")){
							out.println(SystemEnv.getHtmlLabelName(82677,user.getLanguage()));
						}else{
							out.println(SystemEnv.getHtmlLabelName(82676,user.getLanguage()));
						}
					 %>
					</wea:item>
					<wea:item>
					 <%=conditioncn_code %>
					</wea:item>
			 		<wea:item>
					 <input type='text' name='group_<%=rowsum%>_agentbatch' id='group_<%=rowsum%>_agentbatch' value='<%=agentbatch_cond%>'>
					</wea:item>
					<%
					rowsum++;
					
					} %>
				
				</wea:group>
			</wea:layout>
	
	
	<div style="height:100px!important"></div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0 !important;">
		<div style="padding:5px 0px;">
			<wea:layout needImportDefaultJsAndCss="true">
				<wea:group context=""  attributes="{groupDisplay:none}">
					<wea:item type="toolbar">
			    	 <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeCancle()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</div>
</div>
</div>

<br>
<%
//System.out.println("=====end："+new Date().toLocaleString());
String unophrmid="";
%>
 
<center>
     
	<input type="hidden" value="<%=haveAgentAllRight%>" name="haveAgentAllRight">
  	<input type="hidden" value="<%=workflowid%>" name="workflowid">
  	<input type="hidden" value="addAgent" name="method">
    <INPUT type="hidden" name="agentid" value="<%=agentid%>">
  	<INPUT type="hidden" name="beagenterId" value="<%=beagenterid%>">
  	<INPUT type="hidden" name="types" value="<%=types%>">
  	
  	 <input type="hidden" value="0" name="overlapAgenttypes" id="overlapAgenttypes">
 	 <input type="hidden" value="0" name="overlapagentstrids" id="overlapagentstrids">
 	 
	 <INPUT type="hidden" name="beginDate" id="beginDate" value="<%=_beginDate %>">
	 <INPUT type="hidden" name="beginTime" id="beginTime" value="<%=_beginTime %>">
 	 <INPUT type="hidden" name="endDate"  value="<%=_endDate %>">
     <INPUT type="hidden" name="endTime"  value="<%=_endTime %>">
 	 <input type="hidden" value="0" name="groupnum" id="groupnum">
 	 
 	
 	  
<center>
</div>
</div>
</form>
</body>
  
<script language=javascript>
  var dialog =parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	var iscolse = "<%=infoKey%>";
	<%if(types.equals("editcondition")){
	%>
		if(iscolse === "1")
		{
		   parent.parent.getDialog(window).close();
		   parent.parent.getDialog(parent.window).reLoad();
		}
	<%}else{%>
		if(iscolse === "1")
		{
		    parentWin._table.reLoad();
			dialog.close();
		}
	<%}%>
	
		function closeCancle(){
	 	parent.getDialog(window).close();
		}
</script>
 <script language="javascript"> 
function deleteRow4op()
{
	var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}

	}
    if(flag) {
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    	top.Dialog.confirm(str, function () {
			len = document.frmmain.elements.length;
			var i=0;
			var rows = jQuery('#oTable4op tr');
			var rowsum1 = rows.length;//包含横线行
			for(i=len-1; i >= 0;i--) {
				if (document.frmmain.elements[i].name=='check_node') {
					rowsum1 -= 1;
					if (jQuery(rows[rowsum1]).is('.Spacing')) {
						rowsum1 -= 1;//如果是横线行继续递减
	                }
					if(document.frmmain.elements[i].checked==true) {
		            
		                if ((rowsum1 + 1) < rows.length && jQuery(rows[rowsum1 + 1]).is('.Spacing')) {
							oTable4op.deleteRow(rowsum1 + 1);//横线单独占一行，随行删除
		                }
						oTable4op.deleteRow(rowsum1);
					}
				}
			}
    	}, function () {}, 320, 90,true);
    }else{
    	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
  
 function ShowFnaHidden(obj,tdname){
	var tzCheckBox = $("input[name='"+tdname+"']").next(".tzCheckBox");
    if(obj.checked){
        $G(tdname).disabled=false;
        tzCheckBox.attr("disabled",false);
         $("#isPendThingtr").css("display",""); 
    }else{
        $G(tdname).checked=false;
        $G(tdname).disabled=true;
        var isChecked = tzCheckBox.hasClass("checked");
        if(isChecked){
        	tzCheckBox.toggleClass("checked");
        }
        tzCheckBox.attr("disabled",true);
         $("#isPendThingtr").css("display","none"); 
    }
}
  function RepeatStr(str){  
   return /(\x0f[^\x0f]+)\x0f[\s\S]*\1/.test("\x0f"+str.join("\x0f\x0f") +"\x0f");
   
   }
   
   

 
 
function checkString(str){
	var arrStr=str.split(",");
	var hash = {};
	for(var i=0;i<arrStr.length;i++){
		if(!hash[arrStr[i]])
		{
			hash[arrStr[i]]=true;
		}
		else{
		   return true;
		}
	}
	return false;
}
function doSave(obj1){
                
	var isnotchecked="0";     
	var rowindex4op =0;
    var len=document.frmmain.elements.length;
    var rowsum1 =0;
    var rowindex=0;
    var obj;
    for (i = 0; i < len; i++) {
       if (document.frmmain.elements[i].name == 'check_node') {
             rowsum1 += 1;
             obj = document.frmmain.elements[i];
          }
       }
      if (rowsum1 > 0) {
          rowindex4op =(parseInt(obj.getAttribute("rowindex"))+1);
       }
       
	 if(parseInt(rowindex4op)==0){
	    	 Dialog.alert("<%=SystemEnv.getHtmlLabelName(82681,user.getLanguage()) %>!");
	    	 return ;
	  }
       
    var isProxyDeal1="0";
      //检测明细是否存在开启 代理流程处理 
    var verifyAgent="";
     for(var i=0;i<rowindex4op;i++){
     	if($("#group_"+i+"_isProxyDeal").length>0){
     	   var _conditionss="";
     	   var _agentbatch="";
	       var _isProxyDeal=$("#group_"+i+"_isProxyDeal").val();
	       if(_isProxyDeal=='1'){
          	if($("#group_"+i+"_conditioncn").length>0){ 
		       _conditionss=$("#group_"+i+"_conditioncn").val();
		       if(_conditionss==''){
		         _conditionss="0";
		       }
	        }
	        if($("#group_"+i+"_agentbatch").length>0){ 
			    _agentbatch=$("#group_"+i+"_agentbatch").val();
		    }
	         if(verifyAgent==''){
	           verifyAgent=_conditionss+"_"+_agentbatch;
	         }else{
	            verifyAgent+=","+_conditionss+"_"+_agentbatch;
	         }
	         
	        isProxyDeal1="1";
	       }else{
	          isnotchecked="1";
	       }
       }
     }  
        
         
        var isChongFu=checkString(verifyAgent);
		if(isChongFu){
		 	Dialog.alert("<%=SystemEnv.getHtmlLabelName(82859,user.getLanguage())%>");
	    	return ;
		} 
	
	  $G("groupnum").value= parseInt(rowindex4op);
	  $G("method").value="addAgent";
 
	  <% if(_agenttype.equals("1")) {%>
	  if(isProxyDeal1=='1'){
	    var returnstrs=wfoverlapAgent(isnotchecked);//为2标示当前代理设置没有叠加重复项。为1标示有 ，如果有则需要另外处理
	     if(returnstrs=='2'){
	      e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33113,user.getLanguage())%>",true); 
	     $("#zd_btn_submit").attr("disabled","disabled"); 
	      obj1.disabled = true;	 
		  
		  window.document.frmmain.submit();
		  }
	  }else{
		 e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33113,user.getLanguage())%>",true); 
	     $("#zd_btn_submit").attr("disabled","disabled"); 
	      obj1.disabled = true;	 
	  	window.document.frmmain.submit();
	  }
	  <%}else{%>
	  	  e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33113,user.getLanguage())%>",true); 
	      $("#zd_btn_submit").attr("disabled","disabled"); 
	      obj1.disabled = true;	 
	  	  window.document.frmmain.submit();
	  <%}%>
}


function wfoverlapAgent(isnotchecked){
		var beagenterId="<%=beagenterid%>";
		var agenterId="<%=agenterid%>";
		var beginDate="<%=_beginDate%>";
		var beginTime="<%=_beginTime%>";
		var endDate="<%=_endDate%>";
		var endTime="<%=_endTime%>";
		var workflowid="<%=workflowid%>";
		var isCreateAgenter="<%=_isCreateAgenter%>";
		var isProxyDeal="1";//上面已经验证了 
		var isPendThing="<%=_isPendThing%>";
		var returnstr="2";
		jQuery.ajax({
			 type: "POST",
			 url: "/workflow/request/WFAgentConditeAjax.jsp",
			 data: "beagenterId="+beagenterId+"&workflowid="+workflowid+"&usertype=0&agenterId="+agenterId+"&beginDate="+beginDate+"&beginTime="+beginTime+"&endDate="+endDate+"&endTime="+endTime+"&isCreateAgenter="+isCreateAgenter+"&isProxyDeal="+isProxyDeal+"&isPendThing="+isPendThing+"&agentid=<%=agentid%>",
			 cache: false,
			 async:false,
			 dataType: 'json',
			    success: function(msg){
				if(msg.done.success=="success"){
				  	 if(msg["data0"]){
				 	  var _data = msg["data0"];
				 	    if(_data.overlapAgent!=undefined&&_data.overlapAgent!='undefined'){
						  if(_data.overlapAgent>0){
						  	returnstr="1";
							dialog = new window.top.Dialog();
							dialog.currentWindow = window; 
							var url = "/workflow/request/wfAgentCDBackConfirmCondt.jsp?isnotchecked="+isnotchecked+"&overlapagentstrid="+_data.agentids+"&overlapAgent="+_data.overlapAgent+"&beagenterId="+beagenterId+"&workflowid="+workflowid+"&usertype=0&agenterId="+agenterId+"&beginDate="+beginDate+"&beginTime="+beginTime+"&endDate="+endDate+"&endTime="+endTime+"&isCreateAgenter="+isCreateAgenter+"&isProxyDeal="+isProxyDeal+"&isPendThing="+isPendThing+"&agentid=<%=agentid%>";
							dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage()) %>";
							dialog.URL = url;
						    dialog.Width="355px";
							dialog.show();
						  }else{
						 	returnstr="2";
						  }
				 	    }
				 	 }
				}else{
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);
				   	returnstr="2";
				}
			 }
		 });
		 	return returnstr;
}



var isLightBool = false ;
var rowBgValue = "" ;
function getRowBg()
{	
	isLightBool = !isLightBool ;
	if (isLightBool)
	{
		rowBgValue = "rgb(245, 250, 250)";//"#e7e7e7" ;
	}
	else
	{	
		rowBgValue = "rgb(245, 250, 250)";
	}
	return rowBgValue ;
}
//全选
function checkAllChkBox(){
	len = document.frmmain.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.frmmain.elements[i].name=='check_node' && jQuery("input[name=checkall]").attr("checked")==true){
			document.frmmain.elements[i].checked=true;
			changeCheckboxStatus(document.frmmain.elements[i],true);
		}else if(document.frmmain.elements[i].name=='check_node' && jQuery("input[name=checkall]").attr("checked")==false){
			document.frmmain.elements[i].checked=false;
			changeCheckboxStatus(document.frmmain.elements[i],false);
		}
	}
}
function addRow(){

	var agenterId=$G("agenterId").value;//代理人
	var isCreateAgenter=$G("isCreateAgenter");//是否代理创建
	var isProxyDeal=$G("isProxyDeal");//是否代理流转
	var isPendThing=$G("isPendThing");//是否代理流转【已流转】
	var agentbatch=$G("agentbatch").value;//批次
	var conditionss=$G("conditionss").value;//批次条件【条件id】
	var conditioncn=$G("conditioncn").value;//批次条件名称[中文]
	var conditionkeyid=$G("conditionkeyid").value;
 	var ruleRelationship=$G("ruleRelationship").value;
   	conditioncn =conditioncn.replace(/\"/g, "“");  
	conditioncn =conditioncn.replace(/\'/g, "’"); 
	 
	var beagenterId=$G("beagenterId").value;//被代理人
	var beginDate=$G("beginDate").value;//开始日期
	var beginTime=$G("beginTime").value;//开启时间
	var endDate=$G("endDate").value;//结束日期
	var endTime=$G("endTime").value;//结束时间
	var randtime=getTimeAndRandom();
	 
	if(parseFloat(agentbatch)<1||agentbatch==''){
		agentbatch="0.00";
	}
	 
	if(agenterId=="<%=beagenterid%>"){
	   Dialog.alert("<%=SystemEnv.getHtmlLabelName(82680,user.getLanguage()) %>!");
	   return;
	}
	
	if(agenterId==''){
	 Dialog.alert("<%=SystemEnv.getHtmlLabelName(82679,user.getLanguage()) %>!");
	 return;
	}

	if(!isCreateAgenter.checked&&!isProxyDeal.checked){
	 Dialog.alert("<%=SystemEnv.getHtmlLabelName(82678,user.getLanguage()) %>!");
	 return;
	}
     
   
	var rowindex4op = 0;
   	var rows=document.getElementsByName('check_node');
    var len = document.frmmain.elements.length;
    var rowsum1 = 0;
    var obj;
    for(i=0; i < len;i++) {
		if(document.frmmain.elements[i].name=='check_node'){
			rowsum1 += 1;
            obj=document.frmmain.elements[i];
         }
    }
  	//frmmain
  	if(rowsum1>0) {
    	rowindex4op=parseInt(obj.getAttribute("rowIndex"))+1;
    }
    
	rowColor = getRowBg();
	ncol = oTable4op.rows[0].cells.length
	oRow = oTable4op.insertRow(-1);
	oRow.className="DataLight";
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= "#fff";
		switch(j) {
			case 0://复选框
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex4op+"' rowindex="+rowindex4op+" >";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 1://代理人
				var oDiv = document.createElement("div");
				var sHtml="";
					sHtml=""+$G("agenterIdspan").innerHTML;
                oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='hidden' name='group_"+rowindex4op+"_agenterId'  value='"+agenterId+"'>";
				oDiv1.innerHTML = sHtml1;
				jQuery(oCell).append(oDiv1);
				break;
			case 2://代理创建流程
				var oDiv = document.createElement("div");
				var sHtml ="<%=SystemEnv.getHtmlLabelName(82676,user.getLanguage()) %>";
				var sval="0";
				if(isCreateAgenter.checked){
					sHtml="<%=SystemEnv.getHtmlLabelName(82677,user.getLanguage()) %>";
					sval="1";
				}
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				var oDiv2= document.createElement("div");
	           	var sHtml1;
               		sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_isCreateAgenter' value='"+sval+"'>";
				oDiv2.innerHTML = sHtml1;
				jQuery(oCell).append(oDiv2);
				break;
			case 3://代理流程处理
				var oDiv = document.createElement("div");
				var sval="0";
				var sHtml ="<%=SystemEnv.getHtmlLabelName(82676,user.getLanguage()) %>";
				if(isProxyDeal.checked){
					sHtml="<%=SystemEnv.getHtmlLabelName(82677,user.getLanguage()) %>";
					sval="1";
				}
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				var oDiv3 = document.createElement("div");
				oDiv3.innerHTML = "<input type='hidden' id='group_"+rowindex4op+"_isProxyDeal'   name='group_"+rowindex4op+"_isProxyDeal' value='"+sval+"'>";
				jQuery(oCell).append(oDiv3);
				break;
			case 4://已有待办事宜
				var oDiv = document.createElement("div");
				var sval="0";
				var sHtml ="<%=SystemEnv.getHtmlLabelName(82676,user.getLanguage()) %>";
				if(isProxyDeal.checked&&isPendThing.checked){
					sHtml="<%=SystemEnv.getHtmlLabelName(82677,user.getLanguage()) %>";
					sval="1";
				}
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				
			    var oDiv4 = document.createElement("div");
				oDiv4.innerHTML = "<input type='hidden'  name='group_"+rowindex4op+"_isPendThing' value='"+sval+"'>";
				jQuery(oCell).append(oDiv4);
				break;
			case 5://代理条件
			
				var oDiv = document.createElement("div");
				var sHtml =conditioncn;
			    oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				var oDiv5 = document.createElement("div");
				var sHtml1="<input type='hidden' id='group_"+rowindex4op+"_conditionss' name='group_"+rowindex4op+"_conditionss' value='"+conditionss+"'>";
				sHtml1+="<input type='hidden' id='group_"+rowindex4op+"_conditioncn' name='group_"+rowindex4op+"_conditioncn' value='"+conditioncn+"'>";
				sHtml1+="<input type='hidden' id='group_"+rowindex4op+"_conditionkeyid' name='group_"+rowindex4op+"_conditionkeyid' value='"+conditionkeyid+"'>";
	         	sHtml1+="<input type='hidden' id='group_"+rowindex4op+"_ruleRelationship' name='group_"+rowindex4op+"_ruleRelationship' value='"+ruleRelationship+"'>";
	            sHtml1+="<input type='hidden' name='group_"+rowindex4op+"_agentid' value='<%=agentid%>'>"; //主键     
	            sHtml1+="<input type='hidden' name='group_"+rowindex4op+"_beagenterid' value='<%=beagenterid%>'>"; //被代理人 
	            sHtml1+="<input type='hidden' name='group_"+rowindex4op+"_beginDate' value='"+beginDate+"'>"; //开始日期     
	            sHtml1+="<input type='hidden' name='group_"+rowindex4op+"_beginTime' value='"+beginTime+"'>"; //开始时间      
	            sHtml1+="<input type='hidden' name='group_"+rowindex4op+"_endDate' value='"+endDate+"'>"; //结束日期     
	            sHtml1+="<input type='hidden' name='group_"+rowindex4op+"_endTime' value='"+endTime+"'>"; //结束时间
				oDiv5.innerHTML = sHtml1;
				jQuery(oCell).append(oDiv5);
				break;
				
			case 6://批次
				var oDiv = document.createElement("div");
				var sHtml="<input type='text' id='group_"+rowindex4op+"_agentbatch' name='group_"+rowindex4op+"_agentbatch' value='"+agentbatch+"'>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
		}
	}
	
	$("#agenterId").val("");
	$("#agenterIdspan").html("");
	$("#agenterIdspanimg").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'/>");
	$G("conditionss").value="";//批次条件【条件id】
	$G("conditioncn").value="";//批次条件名称[中文]
	$G("rulemaplistids").value="";
	$("#conditions").html("");
	$G("ruleRelationship").value="";
	$G("conditionkeyid").value="";
	$G("agentbatch").value="";
	rowindex4op = rowindex4op*1 +1;
}

	
function checkDigit(elementName,p,s){
	tmpvalue = elementName.value;
    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }
	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    elementName.value=newValue;
}	
 

function onShowBrowsers(){
   var randid="";
    var conditionkeyid=document.getElementById("conditionkeyid").value;
    if(conditionkeyid!=''){
      randid=conditionkeyid;
    }else{
	   randid=getTimeAndRandom();
	 document.getElementById("conditionkeyid").value=randid;
	}
	var url = "/formmode/interfaces/showconditionContent.jsp?rulesrc=6&formid=<%=formid%>&isbill=<%=isbill%>&linkid="+randid+"&isnew=1&wfid=<%=workflowid%>&rownum=";
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(81951,user.getLanguage()) %>";
	dialog.Width = 850;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function changeRange(obj)
{
	if($(obj).val()==0)
		$("span[name=rangeSpan]").css("display","none");
	else
		$("span[name=rangeSpan]").removeAttr("style");
	
}
<!--added by xwj for td2551 20050822 begin-->
function selecAll(){
var flag = document.all('selectAll').checked;
var len = document.frmmain.elements.length;
var i=0;
var mainKey;
var subKey;

<%for(int h=0; h<arr.size(); h++){%>
mainKey = "t"+<%=arr.get(h)%>;
document.all(mainKey).checked=flag;
if(flag)
{
  $(document.all(mainKey)).next("span").addClass("jNiceChecked");
}else
{
 $(document.all(mainKey)).next("span").removeClass("jNiceChecked");
}
for( i=0; i<len; i++) {
   subKey = "w"+<%=arr.get(h)%>;
   if (document.frmmain.elements[i].name==subKey) {
        document.frmmain.elements[i].checked= flag ;
			if(flag)
			{
			  $(document.frmmain.elements[i]).next("span").addClass("jNiceChecked");
			}else
			{
			 $(document.frmmain.elements[i]).next("span").removeClass("jNiceChecked");
			}
      } 
  }

<%}%> 
}


function goBack() {
	
	document.location.href="/workflow/request/wfAgentStatistic.jsp" //xwj for td3218 20051201
}


function checkMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("t"+id).checked ;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id) {
            document.frmmain.elements[i].checked= mainchecked ;
			 if(mainchecked)
            $(document.frmmain.elements[i]).next("span").addClass("jNiceChecked");  
			 else
            $(document.frmmain.elements[i]).next("span").removeClass("jNiceChecked");  
        } 
    } 
}


function checkSub(id) {
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='w'+id) {
    	if(!document.frmmain.elements[i].checked){
    		document.all("t"+id).checked = false;
			$(document.all("t"+id)).next("span").removeClass("jNiceChecked");  
    		return;
    		}
    	} 
    }
    document.all("t"+id).checked = true; 
   $(document.all("t"+id)).next("span").removeClass("jNiceChecked"); 
   $(document.all("t"+id)).next("span").addClass("jNiceChecked"); 
}

function submitData()
{
	if (check_form(weaver,''))
		weaver.submit();
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
function show(obj,usertype){
    var imgs="img"+obj;
    var sss="s"+obj; 
    if(document.all(sss).style.display=="none"){
    	//added by cyril on 2008-08-25 for td:9236
    	document.all("scrollarea").style.display = "";
    	document.all("mainarea").style.display = "";
    	var req;
    	if (window.XMLHttpRequest) {
        	req = new XMLHttpRequest(); 
    	}
    	else if (window.ActiveXObject){ 
        	req = new ActiveXObject("Microsoft.XMLHTTP"); 
        }
        if(req){
            req.open("GET","wfAgentAddAjax.jsp?typeid="+obj+"&usertype="+usertype, true);
            req.onreadystatechange = function() {
            	if (req.readyState == 4 && req.status == 200) {
                	//alert(req.responseText);
                	document.all(sss).innerHTML = req.responseText;
                	document.all(sss).style.display="";
                	document.all(imgs).src="/images/btnDocCollapse_wev8.gif";
                	document.all("t"+obj).checked = true;
                    $(document.all("t"+obj)).next("span").removeClass("jNiceChecked");  
                    $(document.all("t"+obj)).next("span").addClass("jNiceChecked");    
                	req = null
                	stopBar(scrollarea,mainarea);
					$('body').jNice();
            	}
            }; 
            req.send(null);
        }
    	//end by cyril on 2008-08-25 for td:9236
    }else{
        document.all(sss).style.display="none";
        document.all(imgs).src="/images/btnDocExpand_wev8.gif";
    }
}

function onShowHrmBeAgent(spanname,inputename){
  var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if (results){
	  if (results.id!="") {
	    spanname.innerHTML= "<A href='javaScript:openhrm("+results.id+");' onclick='pointerXY(event);'>"+results.name+"</A>"
	    inputename.value=results.id
	    location.href = "/workflow/request/wfAgentAdd.jsp?changeBeagentId="+results.id;
	  }else{ 
	    spanname.innerHTML= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	    inputename.value=""
	  }
  }
}
function onShowHrmAgent(spanname,inputename){
  var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if (results){
	  if (results.id!="") {
	    spanname.innerHTML= "<A href='javaScript:openhrm("+results.id+");' onclick='pointerXY(event);'>"+results.name+"</A>"
	    inputename.value=results.id
	  }else{ 
	    spanname.innerHTML= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	    inputename.value=""
	  }
  }
}
 

function curDateTime() {
var d = new Date();
var year = d.getFullYear()+"";
var month = d.getMonth() + 1;
var date = d.getDate();
var day = d.getDay();
var Hours=d.getHours(); //获取当前小时数(0-23)
var Minutes=d.getMinutes(); //获取当前分钟数(0-59)
var Seconds=d.getSeconds(); //获取当前秒数(0-59)
var curDateTime = Seconds+Seconds;//先设置小一点 分秒
 
return d.getMilliseconds();
}
//curDateTime();


function RndNum(n){
 var rnd="";
 for(var i=0;i<n;i++){
    rnd+=Math.floor(Math.random()*10);
  }
 return rnd;
 }
 　//输出指定位数的随机数的随机整数
 function getTimeAndRandom(){
 
  return curDateTime()+RndNum(2);
 }

      	
    </script>
    <script type="text/javascript">
 

jQuery(document).ready(function($) {
	jQuery('.e8_box demo2').height(100);
});
</script>
</html>
