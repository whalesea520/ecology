<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.system.code.*"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="ktm" class="weaver.general.KnowledgeTransMethod" scope="page" />
<%
	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0); 
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
		response.sendRedirect("/notice/noright.jsp");
			return;
	}
%>
<html>
<%
	String ajax=Util.null2String(request.getParameter("ajax"));
	int entryID=Util.getIntValue(Util.null2String(request.getParameter("entryID")),0); 
	String message=Util.null2String(request.getParameter("message"));
	if(message.equals("reset")) message = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
	String isclose = Util.null2String(request.getParameter("isclose"));
	String wfid_isbill = "";
	int wfid_formid=0;
	String triggerName = "";
	String triggerFieldName = "";
	String triggerFieldNameLabel = "";
	String triggerFieldType0 = "0";
	String detailindex0 = "0";
	if(wfid!=0){
    	WFManager.setWfid(wfid);
		WFManager.getWfInfo();
	    wfid_isbill = WFManager.getIsBill();
	    wfid_formid=WFManager.getFormid();
	    
	    if(wfid_formid == 0||"".equals(wfid_isbill)){
		    rs1.executeSql("select formid,isbill from workflow_base where id = " + wfid);
			rs1.next();
			wfid_formid = Util.getIntValue(rs1.getString("formid"),0);	
		    wfid_isbill = rs1.getString("isbill");	
	    }
	}
	
	if(entryID>0){
		rs1.executeSql("select * from Workflow_DataInput_entry where id="+entryID);
		if(rs1.next()){
			triggerName = Util.null2String(rs1.getString("triggerName"));
			triggerFieldName = Util.null2String(rs1.getString("triggerFieldName"));
			triggerFieldName = triggerFieldName.replaceAll("field","");
			triggerFieldType0 =  Util.null2String(rs1.getString("type"));
			triggerFieldNameLabel = ktm.getTriggerFieldName(triggerFieldName,triggerFieldType0+"+"+wfid+"+"+user.getLanguage());
			detailindex0 = Util.null2String(rs1.getString("detailindex"));
		}
	}
	ArrayList pointArrayList = DataSourceXML.getPointArrayList();
	String sql="";
	String wfMainFieldsOptions = "";//主字段
	//String wfDetailFieldsOptions = "";//明细字段
	String wfFieldsOptions = "";//全部字段
	ArrayList<String> wfFieldidlist = new ArrayList<String>();
	ArrayList<String> wfFieldlabellist = new ArrayList<String>();
	if(wfid_isbill.equals("0")){//表单主字段
		sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "+
					" where a.isdetail is null and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+wfid_formid+" and b.langurageid = "+user.getLanguage();
		if(RecordSet.getDBType().equals("oracle")){
			sql += " order by a.isdetail desc,a.fieldorder asc ";
		}else{    
			sql += " order by a.isdetail,a.fieldorder ";
		}
	}else if(wfid_isbill.equals("1")){//单据主字段
		sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="+wfid_formid;
		sql += " order by viewtype,dsporder";
	}
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String fieldname = "";
		if(wfid_isbill.equals("0")) fieldname = RecordSet.getString("fieldlable");
		if(wfid_isbill.equals("1")) fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
		wfMainFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
		wfFieldidlist.add(RecordSet.getString(1));
		wfFieldlabellist.add(fieldname);
	}
	Hashtable detailFiledHST = new Hashtable();
	if(wfid_isbill.equals("0")){//表单明细字段
		sql = "select distinct groupid from workflow_formfield where formid="+wfid_formid;
		ArrayList detaigroupidlist = new ArrayList();
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
		    String tempgroupid = RecordSet.getString("groupid");
		    detaigroupidlist.add(tempgroupid);
		}
		for(int i=0;i<detaigroupidlist.size();i++){
		    String tempgroupid = Util.null2String((String)detaigroupidlist.get(i));
		    if(tempgroupid.equals("")) continue;
		    sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "+
				    	" where a.isdetail=1 and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+wfid_formid+" and b.langurageid = "+user.getLanguage()+" and groupid="+tempgroupid;
		    if(RecordSet.getDBType().equals("oracle")){
			    sql += " order by a.isdetail desc,a.fieldorder asc ";
		    }else{    
		    	sql += " order by a.isdetail,a.fieldorder ";
		    }
		    RecordSet.executeSql(sql);
		    String wfDetailFieldsOptions = "";
		    while(RecordSet.next()){
		        String fieldname = RecordSet.getString("fieldlable");
		        wfDetailFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
		    }
		    detailFiledHST.put(tempgroupid,wfDetailFieldsOptions);
		}
	}else if(wfid_isbill.equals("1")){//单据明细字段
		ArrayList detailtablelist = new ArrayList();
		sql = "select distinct detailtable from workflow_billfield where billid="+wfid_formid;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
		    String tempdetailtable = RecordSet.getString("detailtable");
		    detailtablelist.add(tempdetailtable);
		}
		for(int i=0;i<detailtablelist.size();i++){
		    String tempdetailtable = Util.null2String((String)detailtablelist.get(i));
		    if(tempdetailtable.equals("")) continue;
		    sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=1 and billid="+wfid_formid+" and detailtable='"+tempdetailtable+"'";
		    sql += " order by viewtype,dsporder";
		    RecordSet.executeSql(sql);
		    String wfDetailFieldsOptions = "";
		    while(RecordSet.next()){
		        String fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
		        wfDetailFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
		    }
		    detailFiledHST.put(tempdetailtable,wfDetailFieldsOptions);
		}
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(21848,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage());
	String needfav ="";
	String needhelp ="";
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type="text/javascript" src="/js/dojo_wev8.js"></script>
		<script type="text/javascript" src="/js/tab_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
		<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery-autocomplete/browser_wev8.js"></script>
	    <script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			function btn_cancle(){
				dialog.closeByHand();
			}
			try{
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
			}catch(e){}
			if("<%=isclose%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				parentWin._table.reLoad();
				dialog.close();
			}
			 	jQuery(document).ready(function(){
			 		addRowOfFieldTrigger(0,<%=entryID%>);
			 	});
		</script>
		<style type="text/css">
			.e8tableTable .tablecontainer{
				border:none;
			}
			.e8tableTable .grouptable thead{
				display:none;
			}
		</style>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="flowTriggerSave(this);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("611,31768",user.getLanguage())%>" class="e8_btn_top" onclick="addRowOfFieldTrigger()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowTriggerSave(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="frmTrigger" name="frmTrigger" method=post action="triggerOperation.jsp">
			<input type="hidden" id="txtUserUse" name="txtUserUse" value="1">
			<input type="hidden" id="triggerNum" name="triggerNum" value="1">
			<input type="hidden" id="triggerSettingRows0" name="triggerSettingRows0" value="1">
			<input type="hidden" id="srcfrom" name="srcfrom" value="entry">
			<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
			<input type="hidden" id="entryID" name="entryID" value="<%=entryID%>">
			<input type="hidden" name="dialog" value="1">
			<div style="display: none">
				<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
				</table>
			</div>
			<%
			if(ajax.equals("1"))
			{
			%>
			<input type="hidden" name="ajax" value="1">
			<%
			}
			%>
			<wea:layout attributes="{'formTableId':'LinkageTable'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<wea:required required="true" id="triggerName0span" value='<%=triggerName %>'>
							<input temptitle="<%=SystemEnv.getHtmlLabelNames("21805,22009",user.getLanguage())%>" value="<%=triggerName %>" type=text class=Inputstyle size=40 maxLength=50 id="triggerName0" name="triggerName0" onchange="checkinput('triggerName0','triggerName0span')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></wea:item>
					<wea:item>
					    <span id="triggerField0">
						<%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/fieldBrowser1.jsp?wfid="+wfid; %>
						<brow:browser  name="triggerField0" viewType="0" hasBrowser="true" hasAdd="false" 
					                browserUrl='<%=browserUrl %>' tempTitle='<%= SystemEnv.getHtmlLabelNames("21805,261",user.getLanguage())%>' language='<%=""+user.getLanguage()%>'
					                browserValue='<%= triggerFieldName%>' browserSpanValue='<%=triggerFieldNameLabel %>'
					                _callback="onShowTriggerField" linkUrl="#"
					                isMustInput="2" 
					                isSingle="true" 
					                hasInput="true"
					                completeUrl='<%="/data.jsp?type=fieldBrowser&wfid="+wfid %>'  width="150px" 
					                />
					    </span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(26734,user.getLanguage())%></wea:item>
					<wea:item>
						<select name="triggerFieldType0" id="triggerFieldType0" disabled="disabled">
						    <option value=""></option>
							<option value="0" <%="0".equals(triggerFieldType0)?"selected":"" %>> <%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
							<option value="1" <%="1".equals(triggerFieldType0)?"selected":"" %>> <%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>
						</select>
						<input type="hidden" name="detailindex0" id="detailindex0" value="<%=detailindex0 %>" />
					</wea:item>
				</wea:group>
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'isTableList':'true'}">
						<div id="triggerSetting"></div>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
	</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');checkSubmit();">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');checkSubmit();">
		    	<span class="e8_sep_line">|</span> --%>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
	</body>
	<script type="text/javascript">	
	var triggerFieldOfRowIndex = 0;
	var triggerNum = 0;
	var triggerSettingRows0 = 0;
	function addRowOfFieldTrigger(index,entryID)
	{
		if(!index){
			index = jQuery(".e8triggerSettingDiv").length;
		}
		if(!entryID)entryID=0;
		jQuery.ajax({
			url:"fieldTriggerEntryAjax.jsp",
			type:"post",
			dataType:"html",
			data:{
				wfid:<%=wfid%>,
				entryId:entryID,
				index:index
			},
			beforeSend:function(xhr){
				try{
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(82086, user.getLanguage())%>",true);
				}catch(e){}
			},
			complete:function(xhr){
				e8showAjaxTips("",false);
			},
			success:function(data){
				var div = jQuery("<div class='e8triggerDiv'></div>");
				div.html(data);
				jQuery("#triggerSetting").append(div);
				if(entryID<=0){
					triggerSettingRows0++;
				}else{
					triggerSettingRows0 = jQuery(".e8triggerSettingDiv").length
				}
				jQuery("#triggerSettingRows0").val(triggerSettingRows0);
				initLayout();
				beautySelect();
				jQuery(".addbtn").hover(function(){
					jQuery(this).addClass("addbtn2");
				},function(){
					jQuery(this).removeClass("addbtn2");
				});
				
				jQuery(".delbtn").hover(function(){
					jQuery(this).addClass("delbtn2");
				},function(){
					jQuery(this).removeClass("delbtn2");
				});
				for(var i=0;entryID>0 && i<jQuery(".e8triggerSettingDiv").length;i++){
					jQuery("#parameterGroup"+(i+1)).append(eval("parameterGroup"+(i+1)).getContainer());
					jQuery("#evaluateGroup"+(i+1)).append(eval("evaluateGroup"+(i+1)).getContainer());
					jQuery("#tableTable"+(i+1)).append(eval("tableTable"+(i+1)).getContainer());
				}
				if(entryID<=0){
					jQuery("#parameterGroup"+(index+1)).append(eval("parameterGroup"+(index+1)).getContainer());
					jQuery("#evaluateGroup"+(index+1)).append(eval("evaluateGroup"+(index+1)).getContainer());
					jQuery("#tableTable"+(index+1)).append(eval("tableTable"+(index+1)).getContainer());
					if(eval("needFirstRow"+(index+1))){
						eval("tableTable"+(index+1)).addRow();
					}
				}
				if(dialog)dialog.getPageData(dialog,"initData",0);
			}
		});
	}
	function deleteGroup(obj,index){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			jQuery("#ltable_"+index).parent("div").remove();
			jQuery(".e8groupIndex").each(function(idx,obj){
				jQuery(obj).html(idx+1);
			});
		});
	}
	
	function updateTablename(e,datas,name,param){
		name = name.replace(/formid/,"tablename");
		jQuery("#"+name).val(datas.other1);
	}
	
	function setfieldTableName(e,datas,name,params){
		if(datas){
			if(name.indexOf("parafieldname")!=-1){
				name = name.replace("parafieldname","parafieldtablename");
			}else{
				name = name.replace("evaluatefieldname","evaluatefieldtablename");
			}
			if(datas.id!=""){
				jQuery("#"+name).val(datas.other1);
			}else{
				jQuery("#"+name).val("");
			}
		}
	}
	
	function getTriggerTableField(params){
		var _index = params.split("_")[0];
		var _secIndex = params.split("_")[1];
		var datasourcename = "datasource"+_index+_secIndex;
		var tablenames = "";
		jQuery("input[name^='tablename"+_index+_secIndex+"']").each(function(idx,obj){
			var tablename = jQuery(this).val();
			var inputname = jQuery(this).attr("name");
			var _idx = inputname.substr(inputname.indexOf("_"));
			var formid = jQuery("#formid"+_index+_secIndex+_idx).val();
			var tablediyname = jQuery("#tablebyname"+_index+_secIndex+_idx).val();
			if(tablediyname=='') tablediyname = "-";
			var formidspan = "null";
			try{
				formidspan = jQuery("#formid"+_index+_secIndex+_idx+"span a").html();
				if(formidspan==undefind||formidspan=='') formidspan='null' ;
			}catch(e){
			}
			if(idx>0)	tablenames +=",";
			tablenames += formid+"~"+tablename+"~"+tablediyname+"~"+formidspan;
		});
        tablenames = encodeURI(tablenames);
		var urls="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/triggerTableFieldsBrowser.jsp?datasourceid="+jQuery("#"+datasourcename).val()+"&tablenames="+tablenames;
		return urls;
	}
	
	/*取值字段*/
	function getWorkflowTableField(params){
		var triggerFieldType = jQuery("#triggerFieldType0").val();
		var detailindex = jQuery("#detailindex0").val();
		var urls="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/fieldBrowser4Trigger.jsp?wfid=<%=wfid %>&params="+params+"&FieldType="+triggerFieldType+"&bt=0&detailindex="+detailindex;
		return urls;
	}
	/*赋值字段*/
	function getWorkflowTableField1(params){
		var detailindex = jQuery("#detailindex0").val();
		var triggerFieldType = jQuery("#triggerFieldType0").val();
		var urls="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/fieldBrowser4Trigger.jsp?wfid=<%=wfid %>&params="+params+"&FieldType="+triggerFieldType+"&bt=1&detailindex="+detailindex;
		return urls;
	}
	
	function setIndexValue(event,datas,name,_callbackParams){
		if(name.indexOf("parawfField")!=-1){
			jQuery("input[name=pfieldindex"+_callbackParams+"]").val(datas.isdetail);
		}else{
			jQuery("input[name=fieldindex"+_callbackParams+"]").val(datas.isdetail);
		}
	}
	function changedatasource(obj,tindex,tindex1){
	    var val = jQuery(obj).val();
	    var table = jQuery(obj).closest("table");
	    var obj=table.find("input[name^='formid"+tindex+tindex1+"']")
	    if(val){
	    	obj.closest("table").find("colgroup").find("col:eq(1)").attr("width","55%").next().attr("width","10%");
	    	obj.closest("td").hide();
	    }else{
	    	obj.closest("table").find("colgroup").find("col:eq(1)").attr("width","35%").next().attr("width","30%");
	    	obj.closest("td").show();
	    }
	}
	function addtable(group,tr,entry){
		var _name = tr.find("input[name^='tablebyname']:first").attr("name");
		setRowNum("tablebyname","tableTableRowsNum",_name);
		var iseci = _name.replaceAll("tablebyname","");
		iseci = iseci.substring(0,iseci.indexOf("_"));
		var datasource = jQuery("#datasource"+iseci);
		if(datasource.length>0 && datasource.val()){
			tr.find("input[name^='formid"+iseci+"']").closest("td").hide();
		}
	}
	
	function setRowNum(replacestr,rownumstr,_name){
		var _index = _name.replace(replacestr,"");
		if(_index.indexOf("_")!=-1){
			_index = _index.substring(0,_index.indexOf("_"));
		}
		var tableTableRowsNum = jQuery("#"+rownumstr+_index);
		if(tableTableRowsNum.length==0){
			tableTableRowsNum = jQuery("<input type='hidden' value=0 name='"+rownumstr+_index+"' id='"+rownumstr+_index+"'></input>");
			jQuery("#frmTrigger").append(tableTableRowsNum);
		}
		var val = parseInt(tableTableRowsNum.val())+1;
		tableTableRowsNum.val(val);
	}
	
	function addParameterTable(group,tr,entry){
		triggerFieldType = jQuery("#triggerFieldType0").val();
		triggerFieldId = jQuery("input[name='triggerField0']").val();
		paraFieldsOptions = "";
		var selvalue = "";
		var name = jQuery(tr).find(".browser").eq(1).attr("name");
		
		if(triggerFieldType==0){		//主表
			paraFieldsOptions = "<%=wfMainFieldsOptions%>";
			var select = "<select name='"+name+"' id='"+name+"' style='width:180px;'>"+paraFieldsOptions+"</select>";
			
			if(name.indexOf("parawfField")!=-1){
				setRowNum("parawfField","parameterTableRowsNum",name);
			}else{
				setRowNum("evaluatewfField","evaluateTableRowsNum",name);
			}
		}else{		//明细表
			jQuery.ajax({
				url:"triggerdetailoption.jsp",
				type:"post",
				dataType:"html",
				data:{
					wfid:<%=wfid%>,
					fieldid:triggerFieldId
				},
				beforeSend:function(xhr){
					try{
						e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(82086, user.getLanguage())%>",true);
					}catch(e){}
				},
				complete:function(xhr){
					e8showAjaxTips("",false);
				},
				success:function(data){
					
					if(name.indexOf("parawfField")!=-1){
						setRowNum("parawfField","parameterTableRowsNum",name);
					}else{
						setRowNum("evaluatewfField","evaluateTableRowsNum",name);
					}
				}
			});
		}
	}
	
	function flowTriggerSave(obj){
		if(check_form(jQuery("#frmTrigger").get(0),"triggerName0,triggerField0")){
			var isnotnull = false ;
			isnotnull = c1()&&c2();
			if(!isnotnull){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
				return false ;
			}else{
			    $("#triggerFieldType0").removeAttr("disabled");
				document.frmTrigger.submit();
			}
		}
		
	}
	
	function c1(){
		var r = true ;
		jQuery("input[id^=parawfField]").each(function(){
				if(jQuery(this).val()==''&&jQuery(this).attr("name").indexOf("__")==-1){
					r =  false;
				}
				//if( window.console)console.log(jQuery(this).attr("name")+" = "+jQuery(this).val()+" >> "+r);
		});
		return r ;
	}
	function c2(){
		var r = true ;
		jQuery("input[id^=evaluatewfField]").each(function(){
				if(jQuery(this).val()==''&&jQuery(this).attr("name").indexOf("__")==-1){
					r =  false;
				}
				//if( window.console)console.log(jQuery(this).attr("name")+" = "+jQuery(this).val()+" >> "+r);
		});
		return r ;
	}

	function onShowTriggerField(e,datas,name,params){
		var rowindex=0;
		if (datas != undefined && datas != null) {
			var old_val=jQuery("#triggerFieldType0").val();
			if(datas.id != ''){
			    var html=jQuery("#triggerFieldType0 option[value="+datas.fieldtype+"]").html();
				jQuery("#triggerFieldType0").val(datas.fieldtype);
				jQuery("#triggerFieldType0").next().children().children().last().html(html);
				jQuery("#detailindex0").val(datas.tabletype);				
				jQuery("input[name=triggerField0]").val(datas.id);
			}
			//改变触发字段的时候，如果变更了表类型，则将取值、赋值选择字段下拉框重置
			if(old_val!=datas.fieldtype){
				jQuery("div[id^='parameterGroup']").add("div[id^='evaluateGroup']").find("tr.contenttr").each(function(){
					addParameterTable("",$(this),"");
				});
			}
		}
	}
	String.prototype.replaceAll = function(s1,s2) { 
	    return this.replace(new RegExp(s1,"gm"),s2); 
	}

	function onShowTable(inputname,spanname,hiddenname){
		datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/triggerTableBrowser.jsp?wfid=<%=wfid%>")
		if (datas != undefined && datas != null) {
			if(datas.id != ''){
				inputname.value = datas.id;
				spanname.innerHTML = datas.name;
				hiddenname.value = datas.other1;
			}else{
				inputname.value = "";
				spanname.innerHTML = "";
				hiddenname.value = "";
			}
		}
	}
	function showParaTableFiled(obj,firstindex,secindex,rowindex){
		rows = obj.rows.length;
		tablenames = "";
		for(var s=1;s<=rows;s++){
			tablename = "tablename"+firstindex+secindex+s;
			formid = "formid"+firstindex+secindex+s;
			tablenames = tablenames + $G(formid).value + ":"+ $G(tablename).value + ","
		}
        tablenames = escape(tablenames);
		datasourcename="datasource"+firstindex+secindex;
		urls="/workflow/workflow/triggerTableFieldsBrowser.jsp?datasourceid="+$G(datasourcename).value+"&tablenames="+tablenames;
		urls="/systeminfo/BrowserMain.jsp?url="+encode(urls);
		datas = window.showModalDialog(urls);
		if (datas != undefined && datas != null) {
			if(datas.id != ''){
				$G("parafieldname"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 0);
				$G("parafieldnamespan"+firstindex+secindex+rowindex).innerHTML = wuiUtil.getJsonValueByIndex(datas, 1);
				$G("parafieldtablename"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 2);
			}else{
				$G("parafieldname"+firstindex+secindex+rowindex).value = "";
				$G("parafieldnamespan"+firstindex+secindex+rowindex).innerHTML = "";
				$G("parafieldtablename"+firstindex+secindex+rowindex).value = "";
			}
		}
	}
	
	function showEvaluateTableFiled(obj,firstindex,secindex,rowindex){
		rows = obj.rows.length;
		tablenames = "";
		for(var s=1;s<=rows;s++){
			tablename = "tablename"+firstindex+secindex+s;
			formid = "formid"+firstindex+secindex+s;
			tablenames = tablenames + $G(formid).value + ":"+ $G(tablename).value + ","
		}
		datasourcename="datasource"+firstindex+secindex;
		urls="/workflow/workflow/triggerTableFieldsBrowser.jsp?datasourceid="+$G(datasourcename).value+"&tablenames="+tablenames;
		urls="/systeminfo/BrowserMain.jsp?url="+encode(urls);
		datas = window.showModalDialog(urls);
		if (datas != undefined && datas != null) {
			if(datas.id != ''){
				$G("evaluatefieldname"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 0);
				$G("evaluatefieldnamespan"+firstindex+secindex+rowindex).innerHTML = wuiUtil.getJsonValueByIndex(datas, 1);
				$G("evaluatefieldtablename"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 2);
			}else{
				$G("evaluatefieldname"+firstindex+secindex+rowindex).value = "";
				$G("evaluatefieldnamespan"+firstindex+secindex+rowindex).innerHTML = "";
				$G("evaluatefieldtablename"+firstindex+secindex+rowindex).value = "";
			}
		}
	}
		
	function modeTriggerSave(obj){
		for(var tempTriggerIndex=0;tempTriggerIndex<1;tempTriggerIndex++){
			if($G("triggerField"+tempTriggerIndex)){
				var triggerfield = $G("triggerField"+tempTriggerIndex).value;
				if(triggerfield==""){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return;
				}
			}
		}
		obj.disabled=true;
		document.frmTrigger.submit();
		parentReload();
	}
	
	function parentReload(){
		window.parent.location.reload();
	}
</script>

</html>
