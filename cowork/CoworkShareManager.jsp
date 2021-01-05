
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<%
	int coworkid=Util.getIntValue(request.getParameter("id"),0);
	String from=Util.null2String(request.getParameter("from"));
	
	//System.out.println("coworkid:"+coworkid);
	boolean isAdd="add".equals(from);
	boolean isEdit="edit".equals(from);
	boolean isView="view".equals(from);
%>

<link href="/js/jquery/plugins/weavertabs/weavertabs_wev8.css" type="text/css" rel=stylesheet>
<script type="text/javascript" src="/js/jquery/plugins/weavertabs/jquery.weavertabs_wev8.js"></script>



<style type="text/css">
a.spanConfirm,a.spanDelete{
	margin:0 5;
	cursor:hand;
}

.tbl tr td{
	padding:5px;
	vertical-align:top;
}
body{overflow:none;}
</style>
<body>
<div  class="weavertabs" style="border:none;">
<%if(isEdit&&false) {%>
	<table  class="weavertabs-nav" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td target="weavertabs-condition" title="<%=SystemEnv.getHtmlLabelName(430,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:79px;"><%=SystemEnv.getHtmlLabelName(430,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></span></td><!--条件-->
			<td target="weavertabs-hrm" title="<%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:79px;"><%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%></span></td><!--参与人员-->
			<td target="weavertabs-noread" title="<%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:79px;"><%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%></span></td><!--未查看者-->
		</tr>
	</table>	
<%}%>

<%if(isView) {%>
  <table cellpadding="0" cellspacing="0" width="100%"> 
     <tr>
         <td class="normal_tab active_tab" nowrap="nowrap" align="center" id="condition" target="weavertabs-condition" onclick="changeJoinTab(id,'target')" title="<%=SystemEnv.getHtmlLabelName(430,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:79px;"><%=SystemEnv.getHtmlLabelName(430,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></span></td><!--条件-->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap"  align="center" id="hrm" target="weavertabs-hrm"  onclick="changeJoinTab(id,'target')" title="<%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:79px;"><%=SystemEnv.getHtmlLabelName(18605,user.getLanguage())%></span></td><!--参与人员-->
		 <td class="seprator_tab">&nbsp;</td>
         <td class="normal_tab" nowrap="nowrap" align="center" id="noread" target="weavertabs-noread" onclick="changeJoinTab(id,'target')" title="<%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%>"><span style="text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:79px;"><%=SystemEnv.getHtmlLabelName(17696,user.getLanguage())%></span></td><!--未查看者-->
         <td width="100%" style="border-bottom: 1px solid #CDCDCD;">&nbsp;</td>
     </tr>
  </table>

<%} %>

<div  class="">
		<div id="weavertabs-condition" style="display:inline;">		
			<%if(isAdd||isEdit) {%>
				    <input type="hidden" name="isChangeCoworker" value="0" id="isChangeCoworker"/>
				    <input type="hidden" name="shareOperation" value="<%=isAdd?"add":"edit"%>"/>
				    <input type="hidden" name="deleteShareids" id="deleteShareids" value="""/>
			<%}%> 
			<TABLE id="tbl" class="ListStyle" cellspacing="1" width="100%" style="margin:3px 0 5px 0">
				<COLGROUP>
					<COL width="5%">
					<COL width="15%">
					<COL width="35%">
					<COL width="50%">
				</COLGROUP>
					<tr class="HeaderForXtalbe">
						<th><input type="checkbox" name="seclevel_total" onclick="setCheckState(this)"/></th>
						<th><%=SystemEnv.getHtmlLabelName(18873,user.getLanguage())%></th>
						<th><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th>
						<th colspan="<%if(!(isAdd||isEdit)) out.print("2");%>"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th>
					</tr>								
				
					<%
						List alist=csm.getShareConditionStrList(""+coworkid);
						int index = 0;
					    for(int i=0;i<alist.size();i++){
						    HashMap hm=(HashMap)alist.get(i);
							int typelabel=Util.getIntValue((String)hm.get("typeName"));
							String shareid=(String)hm.get("shareid");
							String scopeid = (String)hm.get("scopeid");
							boolean isManager=typelabel==2097||typelabel==271;
							index--;
					%>	
							<tr shareid="<%=hm.get("shareid")%>" CLASS=DataLight>
								<td>
									<%if(!isManager){%>
										<input type='checkbox' name='shareid_ck' shareid='<%=shareid%>'/>
									<%}%>
								</td>
								<td><%=SystemEnv.getHtmlLabelName(typelabel, user.getLanguage())%></td>
								<td style='word-break:break-all'>
								   <%if((isAdd||isEdit)&&((String)hm.get("type")).equals("1")&&typelabel!=2097&&typelabel!=271){ %>
								   <%} %>
								   <%
								   		String content=(String)hm.get("content");
								   		String contentName=(String)hm.get("contentName");
								   		if(!"".equals(content) && content.indexOf(",")!=-1){
										  	content = content.substring(1,content.length()-1);
									  	}
								   		
								   %>
								   <%if(!isManager){ //不是创建者，也不是参与者%>
									   <input type="hidden" name="sharetype" value="<%=hm.get("type")%>">
								       <input type="hidden" name="shareid" value="<%=hm.get("shareid")%>">
								       <input type="hidden" name=relatedshareid value="<%=","+content+","%>" class="relatedshareid_<%=index %>">
								       <input name='jobtitlescopeid' type='hidden' value="<%=","+scopeid+","%>" class="jobtitlescopeid_<%=index %>">
								       <input type="hidden" name="jobtitlelevel" value="<%=hm.get("joblevel")%>">
								   <%}
								   if(typelabel==1867||typelabel==141||typelabel==124 ||typelabel == 122){ //人员分部部门角色
								  		String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=";
								  		String completeUrlStr = "/data.jsp";
								   		if(typelabel == 141) {
								   			browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=";
								   			completeUrlStr = "/data.jsp?type=164";
								   		} else if(typelabel == 124) {
								   			browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=";	
								   			completeUrlStr = "/data.jsp?type=57";
								   		}else if(typelabel == 122) {//角色
								   			browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids=";	
								   			completeUrlStr = "/data.jsp?type=65";
								   		}
								   		
								   %>
								   	  <brow:browser viewType="0" name="relatedshareid" browserValue='<%=content%>' 
								   	  		browserSpanValue='<%=contentName%>'
    										browserUrl='<%=browserUrl%>'
    										hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' index='<%=index+"" %>'
    										completeUrl='<%=completeUrlStr%>' width="90%"
    										_callback="callBackSelectUpdate" afterDelCallback="callBackDelUpdate">
									  </brow:browser>
								   <%
								   }else{%>
									   <span class="showrelatedsharename" id="showrelatedsharename_<%=hm.get("shareid")%>" name="showrelatedsharename">
									      <%=hm.get("contentName")%>
									   </span>
								   <%} %>
								</td>
								<td align="center"  colspan="<%if(!(isAdd||isEdit)) out.print("2");%>">
								    <%if(typelabel!=2097&&typelabel!=271&&typelabel!=6086){ //不是创建者，也不是参与者%>
								      <%if(((String)hm.get("type")).equals("1")){ %>
								        <input type="hidden" value="<%=hm.get("seclevel")%>" name="seclevel" style="display:none"/>
								        <input type="hidden" value="<%=hm.get("seclevelMax")%>" name="seclevelMax" style="display:none"/>
								      <%}else {%>
								         <%=hm.get("seclevel")+" - "+hm.get("seclevelMax")%> 
								         <input type="hidden" value="<%=hm.get("seclevel")%>" name="seclevel"/>
								         <input type="hidden" value="<%=hm.get("seclevelMax")%>" name="seclevelMax" style="display:none"/>
								      <%} 
								      }else if(typelabel==6086){ 
								    	    String jobsope = "";
											if("1".equals(hm.get("joblevel"))&&!"".equals(scopeid)&&scopeid!=null){
												jobsope = "指定部门("+departmentComInfo.getDeptnames(scopeid)+")";
											}
											if("2".equals(hm.get("joblevel"))&&!"".equals(scopeid)&&scopeid!=null){
												jobsope = "指定分部("+subCompanyComInfo.getSubcompanynames(scopeid)+")";
											}
								      %>
								    	  <%=jobsope %>
								      <%}%>
								   
								</td>
							</tr>
					<% }%>
			</TABLE>
			</div>
	</div>
</div>

</body>
<SCRIPT LANGUAGE="JavaScript">

	function onRowConfirm(obj){
		var tr=jQuery(obj).parents("tr:first");
		
		if(beforeConfirm(tr)){
			tr[0].disabled=true;
			tr.find("button").remove();
			tr.find("button").remove();
			tr.find(".shareSecLevel").attr("readOnly",true);
			
			//save data to server
			var valueSelect=tr.find(".sharetype").val();
			var content=tr.find(".relatedshareid").val();
			var seclevel=tr.find(".shareSecLevel").val();
			jQuery.get("/cowork/CoworkShareOperate.jsp",{method:'add',coworkid:'<%=coworkid%>',type:valueSelect,content:content,seclevel:seclevel},function(data){				
				tr.attr("shareid",jQuery.trim(data));
			});
			tr.find(".spanConfirm").remove();
		} else {
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		}		
		return false;
	}

	function beforeConfirm(tr){
		var valueSelect=tr.find(".sharetype").val();
		var content=tr.find(".relatedshareid").val();
		var seclevel=tr.find(".shareSecLevel").val();
		
		if(valueSelect==1){
			if(content=='') return false;
		}	else if(valueSelect==5){
			if(seclevel=='') return false;
		}	 else {
			if(content==''||seclevel=='') return false;
		}
		return true;
	}

	function onRowDelete(obj,shareid){
	    jQuery("#isChangeCoworker").val("1");
	    if(shareid!=undefined)
	       jQuery("#deleteShareids").val(jQuery("#deleteShareids").val()+shareid+",");
		var tr=jQuery(obj).parents("tr:first");
		var shareid=tr.attr("shareid");
		tr.remove();		
		return false;
	}

	var index=0;
	function addUser(){
	
		jQuery("#isChangeCoworker").val("1");
		var str="<tr CLASS=DataLight>"+
		"	<td>"+getCheckBoxStr()+"</td>"+
		"	<td>"+getShareTypeStr()+"</td>"+
		"	<td>"+getShareContentStr("relatedshareid_"+index)+"</td>"+
		"	<td align='left'>"+getSecLevel()+"</td>"+		
		"</tr>";	
		jQuery("#tbl tbody").append(str);	
		beautySelect();
		jQuery('body').jNice(); 
		
		$("#relatedshareid"+index+"_span_n").e8Browser({
		   name:"relatedshareid",
		   viewType:"0",
		   browserValue:"0",
		   isMustInput:"1",
		   browserSpanValue:"",
		   hasInput:true,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp",
		   browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=",
		   width:"90%",
		   hasAdd:false,
		   isSingle:false,
		   index:index,
		   _callback:'callBackSelectUpdate'
		  });	
		index++;	
	}
	
	function delUser(){
		var checkboxs = jQuery("input[name='shareid_ck']:checked");
		if(checkboxs.length>0){
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83062,user.getLanguage())%>",function(){
				checkboxs.each(function(){
					 var shareid=$(this).attr("shareid");
					 if(shareid!="0")
	       				jQuery("#deleteShareids").val(jQuery("#deleteShareids").val()+shareid+",");
					$(this).parents("tr:first").remove();
					jQuery("#isChangeCoworker").val("1");
			 	});
			});
	 	}else{
	 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	 	}
	}
	
	function getCheckBoxStr(){
		return "<input type='checkbox' name='shareid_ck' shareid='0'/>";
	}
	
	function getShareTypeStr(){
	
		return  "<select class='sharetype inputstyle'  name='sharetype' number="+index+" onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>" +
        "	<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>" +
        "	<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>" +
        "	<option value='4'><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>" +
        "	<option value='6'><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>"+
        "	<option value='5'><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>"+
        "</select>";        
	}
	
	function getShareContentStr(fieldId){
		return "<input name='relatedshareid' type='hidden' class='relatedshareid_"+index+"'>"+
		"<input type='hidden' name='shareid' value='0'>"+
		"<span id='relatedshareid"+index+"_span_n'></span>";
	}
	function callBackSelectUpdate(event,data,fieldId,oldid){
		jQuery("#isChangeCoworker").val("1");
		var sharetype=$("#"+fieldId).parents("tr:first").find("select[name=sharetype]").val();
		var content=jQuery("#"+fieldId).val();
		if(sharetype!="4"){
			content=","+jQuery("#"+fieldId).val()+",";
		}
		jQuery("."+fieldId).val(content);
	}
	
	function callBackDelUpdate(text,fieldId,params){
		jQuery("#isChangeCoworker").val("1");
		var sharetype=$("#"+fieldId).parents("tr:first").find("select[name=sharetype]").val();
		var content=jQuery("#"+fieldId).val();
		if(sharetype!="4"){
			content=","+jQuery("#"+fieldId).val()+",";
		}
		jQuery("."+fieldId).val(content);
	}
		
	
	function getSecLevel(){ 
		return "<span class='shareSecLevel' style='display:none;'><input class='inputstyle' style='width:30px;text-align:center' name='seclevel' value='10'  onblur='checkcount(this)'/>"+
			"-<input class='inputstyle' style='width:30px;text-align:center' name='seclevelMax' value='100'  onblur='checkcount(this)'/>"+
			"</span>"+
			"<SELECT class=jobtitlelevel style='display:none;' name='jobtitlelevel' onchange='onjobtitlelevelChange(this)' style='float: left;'>"+
			"	<option value='0' selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>"+
			"	<option value='1'><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>"+
			"	<option value='2'><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>"+
			"</SELECT>"+
			"<input name='jobtitlescopeid' type='hidden' class='jobtitlescopeid_"+index+"'>"+
			"<span id='showjobtitle_"+index+"' style='isplay:none'></span>";
	}
	function getOptStr(){
		//return "<a onclick='return onRowConfirm(this)' href='void(0)' class='spanConfirm'><%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></a>"+
		<%if(isAdd||isEdit) {%>
			return 	   "<a onclick='return onRowDelete(this)' href='void(0)' class='spanDelete'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
		<%} else {%>
			return "";
		<%}%>
	}  

	jQuery(document).ready(function(){	
		<%if(isEdit&&false) {%>
				jQuery(".weavertabs").weavertabs({selected:0,call:function(divId){
			}});		
		<%} else if(!isView) {%>
			jQuery("#weavertabs-condition").show(); 
		<%}%>
		jQuery('body').jNice();
	});	          

	function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var number = jQuery(obj).closest("tr").find(".sharetype").attr("number");
		var completeUrlStr = "";
		var browserUrlStr = "";
		if(thisvalue == 1){
			completeUrlStr = "/data.jsp";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=";
		}
		if(thisvalue == 2){
			completeUrlStr = "/data.jsp?type=164";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=";
		}
		if(thisvalue == 3){
			completeUrlStr = "/data.jsp?type=57";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=";
		}	
		if(thisvalue == 4){
			completeUrlStr = "/data.jsp?type=65";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids=";
		}	
		if(thisvalue == 6){
			completeUrlStr = "/data.jsp?type=24";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids=";		
		}
		if(thisvalue !=5){		
			$("#relatedshareid"+number+"_span_n").show();
			$("#relatedshareid"+number+"_span_n").e8Browser({
			   name:"relatedshareid",
			   viewType:"0",
			   browserValue:"0",
			   isMustInput:"1",
			   browserSpanValue:"",
			   hasInput:true,
			   linkUrl:"#",
			   isSingle:true,
			   completeUrl:completeUrlStr,
			   browserUrl:browserUrlStr,
			   width:"90%",
			   hasAdd:false,
			   isSingle:false,
			   index:number,
			   _callback:'callBackSelectUpdate'
			  });	
		}else{
			$("#relatedshareid"+number+"_span_n").hide();
		}
		
		
		var jQuerytr=jQuery(obj.parentNode.parentNode);
		jQuerytr.find(".shareSecLevel").hide();
		
		if(thisvalue!=1){
			jQuerytr.find(".shareSecLevel").show();
		}	
		if(thisvalue==6){
			jQuerytr.find(".shareSecLevel").hide();
			jQuerytr.find(".jobtitlelevel").show();
		}else{
			jQuerytr.find(".jobtitlelevel").hide();
			$("#showjobtitle_"+number).hide();
		}
	}
	
	function setCheckState(obj){
		var checkboxs = jQuery("input[name='shareid_ck']").each(function(){
			changeCheckboxStatus(this,obj.checked);
	 	});
	}
	
	function onjobtitlelevelChange(obj){
		var number = jQuery(obj).closest("tr").find(".sharetype").attr("number");
		var selvalue = jQuery(obj).val();
		
		if(selvalue == 1){
			completeUrlStr = "/data.jsp?type=4";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=";			
		}else if(selvalue == 2){
			completeUrlStr = "/data.jsp?type=164";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=";			
		}else{
			$("#showjobtitle_"+number).hide();	
			return;
		}
		
		$("#showjobtitle_"+number).show();
		$("#showjobtitle_"+number).e8Browser({
		   name:"jobtitlescopeid",
		   viewType:"0",
		   browserValue:"0",
		   isMustInput:"1",
		   browserSpanValue:"",
		   hasInput:true,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:completeUrlStr,
		   browserUrl:browserUrlStr,
		   width:"80%",
		   hasAdd:false,
		   isSingle:false,
		   index:number,
		   _callback:'callBackSelectjobtitle'
		  });		
	}
	
	function callBackSelectjobtitle(event,data,fieldId,oldid){
		jQuery("#isChangeCoworker").val("1");
		var sharetype=$("#"+fieldId).parents("tr:first").find("select[name=sharetype]").val();
		var content=jQuery("#"+fieldId).val();
		if(sharetype!="4"){
			content=","+jQuery("#"+fieldId).val()+",";
		}
		jQuery("."+fieldId).val(content);
	}
	
</script>
