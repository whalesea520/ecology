
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.setup.ShareRuleBusiness"%><!DOCTYPE html>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeLayoutUtil" class="weaver.formmode.setup.ModeLayoutUtil" scope="page" />
<jsp:useBean id="ModeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int modeId = Util.getIntValue(request.getParameter("modeid"),0);
	int rightid = Util.getIntValue(request.getParameter("rightid"),0);
	int formId= 0;
	if(modeId > 0){
		RecordSet.executeSql("select formId from modeinfo where id="+modeId);
		if(RecordSet.next()){
			formId = Util.getIntValue(RecordSet.getString("formId"),0);
		}
	}
	ModeLayoutUtil.setUser(user);
	ModeLayoutUtil.setFormId(formId);
	String mainTablename = "";
	RecordSet.executeSql("select tablename from workflow_bill where id="+formId);
	if(RecordSet.next()){
		mainTablename = RecordSet.getString("tablename");
	}
	if(VirtualFormHandler.isVirtualForm(formId)){
		mainTablename = VirtualFormHandler.getRealFromName(mainTablename); 
	}
	
	Map fieldsmap = ModeLayoutUtil.getFormfields(user.getLanguage(),1);
	List mainfields = (List)fieldsmap.get("mainfields");				//主表字段
	List detlfields = (List)fieldsmap.get("detlfields");				//子表字段
	List detailGroup = (List)fieldsmap.get("detailGroup");				//子表组信息
	Map detailMap = new HashMap();
	for(int i=0;i<detailGroup.size();i++){
		Map tempMap = (Map)detailGroup.get(i);
		String detailtable = tempMap.get("detailtable")+"";
		detailMap.put(detailtable,tempMap);
	}
	Map indexMap = ModeLayoutUtil.getIndexMap();
	
	
    
    int ruleid = Util.getIntValue(request.getParameter("ruleid"), 0);
   
    String isnew = Util.null2String(request.getParameter("isnew"));
    if(isnew.equals("1")) ruleid = 0;
    
	IntegratedSapUtil integratedSapUtil = new IntegratedSapUtil();
	BrowserComInfo browserComInfo = new BrowserComInfo();
	String IsOpetype = integratedSapUtil.getIsOpenEcology70Sap();
	
	//***********************
	
	String[] ruleInfoArray = ShareRuleBusiness.getRuleHtmlByRuleId(rightid,user);
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String linkid = Util.null2String(request.getParameter("linkid"));
	int rownum = Util.getIntValue(request.getParameter("rownum"),0);
	
	String sql = "select * from moderightinfo where id="+rightid;
	RecordSet.executeSql(sql);
	int conditiontype = 1;
	String conditionsql = "";
	if(RecordSet.next()){
		conditiontype = Util.getIntValue(RecordSet.getString("conditiontype"),1);
		conditionsql = RecordSet.getString("conditionsql");
	}
	sql = "select count(1) as count from mode_expressions where rightid='"+rightid+"'";
	RecordSet.executeSql(sql);
	int count = 0;
	if(RecordSet.next()){
		count = RecordSet.getInt("count");
	}
	if(count==0){
		count = 1;
	}
%>
<html>
    <head>
        <base href="<%=basePath%>">
		<META http-equiv="X-UA-Compatible" content="IE=8" > </META>
        <title>rule-based design</title>

        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        
        <link rel="stylesheet" type="text/css" href="/formmode/js/ruleDesign/css/ruleDesign_wev8.css">
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script type='text/javascript' src='/formmode/js/ruleDesign/js/jsUUID_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		
		<SCRIPT type="text/javascript" src="/formmode/js/WdatePicker/WdatePicker_wev8.js"></script>
		
<!-- 可以抽取js 到jsp中 并 clude -->
<script type="text/javascript">
	//请选择字段 
   	var nothaveFile = "<%=SystemEnv.getHtmlLabelName(82098, user.getLanguage()) %>";
   	var andstr = "<%=SystemEnv.getHtmlLabelName(18760,user.getLanguage())%>";
   	var checkedstr = "<%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%>";
   	var notcheckedstr = "<%=SystemEnv.getHtmlLabelName(22906,user.getLanguage())%>";
   	var levelstr = "<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>";
   	var weaverSplit = "||~WEAVERSPLIT~||";	//切割符
	var splitstr = "-;-";
   	var over_rulesrc = "";
   	var BROWSER_MAPPING = {
   		'1':'17',
   		'17':'1',
   		'165':'166',
   		'166':'165',
   		'4':'57',
   		'57':'4',
   		'167':'168',
   		'168':'167',
   		'164':'194',
   		'194':'164',
   		'169':'170',
   		'170':'169',
   		'7':'18',
   		'18':'7',
   		'9':'37',
   		'37':'9',
   		'8':'135',
   		'135':'8',
   		'16':'152',
   		'152':'16',
   		'161':'162',
   		'162':'161'
   	};

    jQuery(function () {
	
		jQuery(".zd_btn_submit").hover(function(){
			jQuery(this).addClass("zd_btn_submit_hover");
		},function(){
			jQuery(this).removeClass("zd_btn_submit_hover");
		});
		
		jQuery(".zd_btn_cancle").hover(function(){
			jQuery(this).addClass("zd_btn_cancleHover");
		},function(){
			jQuery(this).removeClass("zd_btn_cancleHover");
		});
		
	});	

	function getajaxurl(targetid){
		
	}

	
	
    function paramChangeForRList(){
    	
    }

	//字段选择后的回调函数 selectfiled
	function callbackMeth(evt,data,name,paras,tg){
		
	}
	//字段选择后的回调函数中抽出的方法， 隐藏/显示valuespan 中的Element
	function showValueSpan(parentObj,htmltype,type,selectval){
		
	}

	function isSingle(type) {
		
	}

	//清空 value span 中 browser 的值
	function clearAllElementvalue(parentObj){
		
	}
	
	//隐藏 value span中的Element
	function hideAllValueSpan(parentObj){
		
	}
	
	//（单/多）人力资源 安全级别和具体人员切换
	function setType4hrm(obj){
		
	}

	function getBrowservalueUrl(obj){
		
	}

    
    //获取表达式当前index
    var getExpIndex = function () {
        var expIndex = parseInt($("#expindex").val());
        $("#expindex").val(expIndex + 1);
        return expIndex;
    };
    
    //获取表达式当前index
    var getRlIndex = function () {
        var rlindex = parseInt($("#rlindex").val());
        $("#rlindex").val(rlindex + 1);
        return rlindex;
    };
    
    //选中已追加的条件，以便后续操作
    function switchSelected(e, target) {
		var e = e || window.event;
		var selected = $(target).attr("_selected");
		
		var targetisdiv = $(target).is("div");
		
		var selectedElements = $("[_selected=true]");
		if (selectedElements.length > 0) {
			for (var k=0; k<selectedElements.length; k++) {
				var sltElement = selectedElements[k];
				if ($(target).parent().parent()[0] != $(sltElement).parent().parent()[0]) {
					selectedElements.attr("_selected", "false");
					selectedElements.removeClass("spanselected");
					break ;
				}
			}
		}
		
		if (selected != "true") {
			$(target).attr("_selected", "true");
			$(target).addClass("spanselected");
		} else {
			$(target).attr("_selected", "false");
			$(target).removeClass("spanselected");
		}
		stopBubble(e);
	}
	//阻止事件冒泡函数
	function stopBubble(e) {
	    if (e && e.stopPropagation)
	        e.stopPropagation()
	    else
	        window.event.cancelBubble=true
	}
	
	//删除已有并选中的条件
	function delParam()
	{
		if ($("[_selected=true]").length > 0) {
			top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage())%>', function(){
				$("[_selected=true]").each(function () {
		    		var trgelement = null;
		    		var key = $(this).attr("key");
		           	if ($(this).is("span")) {
						trgelement = $("input[name=child][expindex=" + key + "]");
		           	} else {
		           		trgelement = $("div[rotindex=" + key + "]");
		           	}
		           	//如果只有两个，则删除关系
		    		if ($(this).parent().parent().children(".relationItem").length == 2) {
		    		}
		    		$(this).parent().remove();
		    		
		    		trgelement.remove();
		    		
		        });
		        $("#paramtable input[name='paramcheckbox']").each(function () {
		            if ($(this).attr("checked"))
		                $(this).parent().parent().remove();
		        });
		        if (jQuery("div.relationItem span").length == 0) {
		        	jQuery("#mainBlock").hide();
		        }
			});
		}
		changeModified();
	}

	 //清空
    function onClean() {
    	var _doClean = function () {
    		jQuery.ajax({
    			type:"POST",
    			url:"/formmode/interfaces/shareOperation.jsp?action=cleanCondition",
    			dataType:"json",
    			data:"rightid=<%=rightid%>&modeid=<%=modeId%>",
    			success:function(data){
    				if(data){
    					var rightid = data.rightid;
    					if(rightid&&rightid>0){
    						if(dialog){
	    						var currentWindow = dialog.currentWindow;
	    						//currentWindow.location.href = currentWindow.location.href;
	    						currentWindow.location.reload();
								dialog.close();
    						}
    					}
    				}
    			}
    			
    		});
    		//$("#mainBlock").html("").css("display","none");
	    	//$("#mainExpression").html("");
	    	//$("#mainBlock").html("<div class='verticalblock' onmouseover='relatmouseover(this)' title='双击编辑' onmouseout='relatmouseout(this)' ondblclick='switchRelationEditMode(event,this)'>&nbsp;AND&nbsp;</div><div class='relationStyle outermoststyle' ><div class='relationStyleTop'></div><div class='relationStyleCenter'></div><div class='relationStyleBottom'></div></div>");
    	};
    	if (!!$("#mainExpression").html()) {
    		top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(84545, user.getLanguage()) %>', function() {
    			_doClean();
    		});
    	} else {
    		_doClean();
    	}
    };

    function relatmouseover(obj)
    {
    	if($(obj).find("select").length==0)
    		$(obj).addClass("varticalblockborder");
    }
    
    function relatmouseout(obj)
    {
    	$(obj).removeClass("varticalblockborder");
    }
    
    //添加条件 (0:或/1：与)
    var addbracket = function (relationship) {
        var relationDesc = "&nbsp;AND&nbsp;";
        if (relationship == 0) {
            relationDesc = "&nbsp;OR&nbsp;";
        }
        
        var checkboxarray = [];
        $("[_selected=true]").each(function () {
            checkboxarray.push($(this));
        });
        var childsum = $("[_selected=true]").closest(".relationblock").children(".relationItem").length;
		var selectsum = checkboxarray.length;
		if($("[_selected=true]").is(".relationblock"))
			childsum = $("[_selected=true]").parent(".relationItem").closest(".relationblock").children(".relationItem").length;
		if(childsum == selectsum)
		{
			if (selectsum > 0) {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84546, user.getLanguage()) %>");
			}
			return;
		}
        
        var conditionstr = "";
		if (checkboxarray.length <= 1) {
			return;
		}
		var displayBlock = null;
        var expression = null;
        for (var i = 0; i < checkboxarray.length; i++) {
        	//清除选中
        	checkboxarray[i].attr("_selected", "false");
			checkboxarray[i].removeClass("spanselected");
			
        	var trgelement = null;
            var key = checkboxarray[i].attr("key");
           	if (checkboxarray[i].is("span")) {
				trgelement = $("input[name=child][expindex=" + key + "]");
           	} else {
           		trgelement = $("div[rotindex=" + key + "]");
           	}
            if (i == 0) {
            	var rlindex = getRlIndex();
				//合并后，显示的关系图
				displayBlock = $("#displayTemplate").children(".relationblock").clone();
				displayBlock.attr("key", rlindex);
				displayBlock.attr("title","<%=SystemEnv.getHtmlLabelName(83945, user.getLanguage()) %>")
				displayBlock.children(".verticalblock").html(relationDesc);;
				//displayBlock.children(".verticalblock").mouseover(function(){
				//	relatmouseover($(this));
				//}).mouseout(function(){
				//	relatmouseout($(this));
				//});
				var expressionItemDivObj = $("<div class='relationItem'></div>");
				expressionItemDivObj.append(checkboxarray[i].clone());
				displayBlock.append(expressionItemDivObj);
				
				//合并后，实际的关系结构
				expression = $("<div type='expressions' relation='" + relationship + "' rotindex='" + rlindex + "'></div>");
				expression.append(trgelement.clone());
				
				checkboxarray[i].parent().append(displayBlock);
				//添加关系图
				trgelement.parent().append(expression);
				trgelement.remove();
				checkboxarray[i].remove();
            } else {
                var expressionItemDivObj = $("<div class='relationItem'></div>");
                expressionItemDivObj.append(checkboxarray[i].clone());
				displayBlock.append(expressionItemDivObj);
				
				expression.append(trgelement.clone());
				checkboxarray[i].parent().remove();
				checkboxarray[i].remove();
				trgelement.remove();
				
				
            }
        }
        changeModified();
    };
    
    //拆分条件
    function splitCondition()
    {
    	var checkboxarray = [];
        
        $("[_selected=true]").each(function () {
        	if ($(this).is("div")) {
            	checkboxarray.push($(this));
            }
        });
        
        if (checkboxarray.length == 0) return ;
        
        var children;
        var row;
        var data;
        //分步移除
        for (var i = 0; i < checkboxarray.length; i++) {
            var key = checkboxarray[i].attr("key");
           	var trgelement = $("div[rotindex=" + key + "]"); 
           	
            children = checkboxarray[i].children(".relationItem");
            
            for (var j = 1; j < children.length; j++) {
            	var tktrgeldspelement = $(children[j]).children();
            	var tktrgelement = null;
	            var tky = tktrgeldspelement.attr("key");
	            
	           	if (tktrgeldspelement.is("span")) {
					tktrgelement = $("input[name=child][expindex=" + tky + "]");
	           	} else {
	           		tktrgelement = $("div[rotindex=" + tky + "]");
	           	}
	           	
            	var displayCloneElement = tktrgeldspelement.clone();
            	var cloneElement = tktrgelement.clone();
          		var expressionItemDivObj = $("<div class='relationItem'></div>");	
         		expressionItemDivObj.append(displayCloneElement);
       			$(checkboxarray[i]).parent().parent().append(expressionItemDivObj);
            		
           		tktrgelement.parent().append(cloneElement);
            	
                tktrgelement.remove();
                $(children[j]).remove();
            }
            
            //整理表达式结构
            children = checkboxarray[i].children(".relationItem");
            if (children.length == 1) {
                var expele = null;
               	expele = checkboxarray[i].parent();
              	expele.append(children.children().clone());
                checkboxarray[i].remove();
                
                trgelement.parent().append(trgelement.children().clone());
                trgelement.remove();
            }
            
        }
        changeModified();
    }
    

    function creatBrowservalue(parentObj,isSingle,browservalue,browserspanvalue,type)
    {
		if (!!BROWSER_MAPPING[type]) {
			isSingle = !isSingle;
		}
		if (browservalue.indexOf(',') >= 0) {
			isSingle = false;
		}
    	if (!isSingle) {
    		browserspanvalue = browserspanvalue.replace(/__/g, ',');
    	}
    	parentObj.find("[name=browserSpan]").empty();
		var oDiv = document.createElement("div");
		parentObj.find("[name=browserSpan]").append(oDiv);
		var parentid = $(parentObj).attr("id");
		jQuery(oDiv).e8Browser({
				name:"browservalue",
				viewType:"0",
				browserValue:browservalue,
				isMustInput:"1",
				browserSpanValue:browserspanvalue,
				getBrowserUrlFn:'getBrowservalueUrl',
				getBrowserUrlFnParams:"this",
				hasInput:true,
				isSingle:isSingle,
				completeUrl:"javascript:getajaxurl("+parentid+")",
				browserUrl:"",
				hasAdd:false,
				width:'150px'
		});
		
    }

 	function fillFieldSpan(parentObj, browservalue, browserspanvalue, key)
    {       			
    	var oldFieldSpan = parentObj.find("span[name='fieldspan']");
    	parentObj.empty();
		jQuery(parentObj).e8Browser({
				name:"selectfiled",
				viewType:"0",
				isMustInput:"1",
				getBrowserUrlFn:"getFieldUrl",
				hasInput:true,
				isSingle:true,
				completeUrl:"javascript:getcompleteurl($('#formid').val(),$('#isbill').val(),$('div#editblock_" + key + " #selectfiled__').val())",
				browserUrl:"",
				hasAdd:false,
				width:"150px",
				_callback:"callbackMeth",
				afterDelCallback:"delFieldCallback",
				afterDelParams:key,
				browserValue:browservalue,
				browserSpanValue:browserspanvalue
		});
		parentObj.append('<img style="padding-top:4px;display:none;" src="/images/BacoError_wev8.gif" align="absMiddle">');
    }

	//双击 and/or 更改关系
	function switchRelationEditMode(e,target) {
		var e = e || window.event;
		var parent = $(target).parent();
		var key = parent.attr("key"); 
		var expselement = $("div[rotindex=" + key + "]");
		//if (!!!expselement[0]) return;
		$(target).css("left", "-18px");
		var relation = parseInt(expselement.attr("relation"));
		$(target).html("<select name='tempRelationEle' onblur='cancelRelationEdit(this);' onchange='confirmRelationEdit(this, " + key + ")'><option value='0' " + (relation==0?" selected ":"") + ">OR</option><option value='1'" + (relation==1?" selected ":"") + ">AND</option></select>");
		$(target).find("[name=tempRelationEle]")[0].focus();
	}
	
	function confirmRelationEdit(target, key) {
		var expselement = $("div[rotindex=" + key + "]");
		if (!!!expselement[0]) return;
		expselement.attr("relation", $(target).val());
	}
	
	function cancelRelationEdit(target) {
		var sltval = $(target).val();
		$(target).parent().css("left", "-3px");
		if (sltval == "0") {
			$(target).parent().html("&nbsp;OR&nbsp;");
		} else {
			$(target).parent().html("&nbsp;AND&nbsp;");
		}	
	}
	
    
    function paramChange(obj)
    {
    	var data = $(obj).val();
    	var parentObj = jQuery($(obj).closest("table").parent("div"));
    	parentObj.find("[name=valuetype] option").remove();
    	if(data==="0")
    	{
    		parentObj.find("[name=htmltype]").val("1");
			parentObj.find("[name=fieldtype]").val("1");
   		}else if(data==="1")
   		{
   			parentObj.find("[name=htmltype]").val("1");
			parentObj.find("[name=fieldtype]").val("2");
   		}else if(data==="2")
   		{
   			parentObj.find("[name=htmltype]").val("1");
			parentObj.find("[name=fieldtype]").val("3");
   		}else if(data==="3")
   		{
   			parentObj.find("[name=htmltype]").val("3");
			parentObj.find("[name=fieldtype]").val("1");
   		}
   		hideAllValueSpan(parentObj);
   		var htmltype = parentObj.find("[name=htmltype]").val();
   		var fieldtype = parentObj.find("[name=fieldtype]").val();
   		parentObj.find("select").selectbox("detach");
   		parentObj.find("span[name=compareSpan1]").show();
   		showValueSpan(parentObj,htmltype,fieldtype);
   		parentObj.find("select").selectbox("attach");
    }
    
    /*
    *	valuetype 的 change 事件  只有规则管理新建的rulesrc=3时才有
    */
    function valuetypeChange(obj)
    {
    	var data = $(obj).val();
    	var parentObj = jQuery($(obj).closest("table").parent("div"));
    	var paramtypedata = parentObj.find("[name=paramtype]").val();
    	
    	parentObj.find("span[name=browserSpan]").hide();
    	parentObj.find("span[name=textSpan1]").show();
    	parentObj.find("span[name=selectSpan1]").hide();
    	parentObj.find("[name=textvalue1]").val("");
    	parentObj.find("[name=browservalue]").val("");
    	parentObj.find("span[name=browservaluespan]").html("");
    	if(paramtypedata==="3" && data==="1" || data==="4")
    	{
    		parentObj.find("span[name=browserSpan]").show();
    		parentObj.find("span[name=textSpan1]").hide();
    		parentObj.find("[name=fieldtype]").val("_sysvar");
    	}
    }
    
    function browsertypeChange(obj)
    {
    	var data = $(obj).val();
    	var parentObj = jQuery($(obj).closest("table").parent("div"));
    	parentObj.find("[name=fieldtype]").val(data);
    	showValueSpan(parentObj,"3",data);
    }
    
    function getcompleteurl(formid,isbill,fshowname)
    {
		return "";
    }
    
</script>
<script>
var parentWin = window.parent.parent.getParentWindow(parent);
var dialog = window.parent.parent.getDialog(parent);
</script>
    </head>
    <body>
		<input type="hidden" id="modeid" value="<%=modeId %>">
		<input type="hidden" id="rightid" value="<%=rightid %>">
		<input type="hidden" id="conditiontext" name="conditiontext"  value=""/>
		<input type="hidden" id="conditionsql" name="conditionsql"  value=""/>
		<input type="hidden" id="expindex" name="expindex"  value="<%=count %>"/>
		<input type="hidden" id="rlindex" name="rlindex"  value="<%=count %>"/>
		<input type="hidden" id="ismodified" name="ismodified"  value="0"/>
    	
		<div id="header" style="background:#f0f2f5;">
			<div class="headblock" style="width:100%;background:#f0f2f5;">
				<table style="width:100%" >
					<colgroup>
			    		<col style="width: 160px;" />
						<col style="width: *" />
			    	</colgroup>
					<tr>
						<td>
							<table  style="border-collapse: separate;border-spacing:0px;">
								<colgroup>
						    		<col style="width: 60px;" />
						    		<col style="width: 110px" />
						    	</colgroup>
		        				<TR >
		        					<td>
		        						<%=SystemEnv.getHtmlLabelName(23243, user.getLanguage()) %>
		        					</td>
		        					<td >
		        						<select class=inputstyle   style="width:80px;" name="conditiontype" id="conditiontype" title="<%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%>" 
											onchange="changeContitionType();">
											<option value="1" <%if(conditiontype==1){%>selected="selected"<%} %> ><%=SystemEnv.getHtmlLabelName(2086, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage()) %></option>
											<option value="2" <%if(conditiontype==2){%>selected="selected"<%} %>>sql</option>
										</select>
		        					</td>
		        				</TR>
		        			</table>
						</td>
						<td>
						
        		<div id="newBlockDiv" style="padding-bottom:2px;width:100%">
        			<table class="table_0"  tableIndex="0" border="0" style="border-collapse: separate;border-spacing:0px;width:100%">
        				<colgroup>
				    		<col style="width: 230px;" />
				    		<col style="width: 120px;" />
				    		<col style="width: 150px;" />
				    		<col style="width: *" />
				    	</colgroup>
        				<TR class="baseTR">
                    		<td class="td_1"  style="padding: 5px;">
                    		<%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%> <!-- 目标字段 -->
                    		<select class=inputstyle  style="width:120px;" name="targetFieldid"  title="<%=SystemEnv.getHtmlLabelName(15620,user.getLanguage())%>" 
								onchange="changeTargetFieldid(this)">
								<option value="" ></option>
								<%
								String splitStr = "_&_";
								for(int i = 0; i < mainfields.size(); i++){
									 Map maps = (Map)mainfields.get(i);
									 String fieldid = (String)maps.get("fieldid");
									 String fieldlabel = (String)maps.get("fieldlabel");
									 String viewtype = (String)maps.get("viewtype");
									 String fieldname = (String)maps.get("fieldname");
									 String fieldhtmltype = (String)maps.get("fieldhtmltype");
									 String type = (String)maps.get("type");
									 String fielddbtype=(String)maps.get("fielddbtype");
									 if(fieldhtmltype.equals("6")||fieldhtmltype.equals("7")){//附件或特殊字段
										 continue;
									 }
									 if(fieldhtmltype.equals("2")&&type.equals("2")){//格式文本
										 continue;
									 }
									 
									 String relationtype = "1";//关系类型---单行文本文本  +  单行文本金额千分位  +  多行文本
									 if(fieldhtmltype.equals("1")&&(type.equals("2")||type.equals("3"))){//整数  +  浮点数
										 relationtype =  "2";
									 }
									 
									 
									 if((fieldhtmltype.equals("1")&&type.equals("4"))||fieldhtmltype.equals("5")){// 单行文本金额转换   +  选择项
										 relationtype = "3";
									 }
									 
									 if(fieldhtmltype.equals("3")){//浏览框
										 if(type.equals("2")||type.equals("19")){//日期  + 时间
											 relationtype = "2";
										 }else{
											 relationtype = "4";
										 }
									 }
									 
									 if(fieldhtmltype.equals("4")){//checkbox
										 relationtype = "4";
									 }
									 
									 String valueshowtype = "1";//单行文本输入框
									 
									 if(fieldhtmltype.equals("3")){
										 if(type.equals("2")){//日期 
											 valueshowtype = "2";
										 }else if(type.equals("19")){//时间
											 valueshowtype = "3";
										 }else{
											 valueshowtype = "4";//浏览框--需动态加载
										 }
									 }
									 
									 if(fieldhtmltype.equals("5")){//select框--需动态加载
										 valueshowtype = "5";
									 }
									 
									 if(fieldhtmltype.equals("4")){//checkbox
										 valueshowtype = "6";//select固定值  0  1  null
									 }
									 
											 
									 String optionValue = mainTablename+"."+fieldname+splitStr+fieldid+splitStr+fieldhtmltype+splitStr+type+splitStr+fielddbtype+splitStr+relationtype+splitStr+valueshowtype;
								 %>
								 	<option value="<%=optionValue%>" ><%=fieldlabel%></option>
								 <%
								 }
								 %>
								 
								<%
								for(int i = 0; i < detlfields.size(); i++){
									 Map maps = (Map)detlfields.get(i);
									 String fieldid = (String)maps.get("fieldid");
									 String fieldlabel = (String)maps.get("fieldlabel");
									 String viewtype = (String)maps.get("viewtype");
									 String fieldname = (String)maps.get("fieldname");
									 String fieldhtmltype = (String)maps.get("fieldhtmltype");
									 String type = (String)maps.get("type");
									 String detailtable = (String)maps.get("detailtable");
									 String fielddbtype=(String)maps.get("fielddbtype");
									 
									 Map detailTempMap = new HashMap();
									 String tablenameStr = "";
									 if(detailMap.containsKey(detailtable)){
										 detailTempMap = (Map)detailMap.get(detailtable);
										 tablenameStr = "("+detailTempMap.get("titles")+")";
									 }
									 if(fieldhtmltype.equals("6")||fieldhtmltype.equals("7")){//附件或特殊字段
										 continue;
									 }
									 if(fieldhtmltype.equals("2")&&type.equals("2")){//格式文本
										 continue;
									 }
									 
									 String relationtype = "1";//关系类型---单行文本文本  +  单行文本金额千分位  +  多行文本
									 if(fieldhtmltype.equals("1")&&(type.equals("2")||type.equals("3"))){//整数  +  浮点数
										 relationtype =  "2";
									 }
									 
									 
									 if((fieldhtmltype.equals("1")&&type.equals("4"))||fieldhtmltype.equals("5")){// 单行文本金额转换   +  选择项
										 relationtype = "3";
									 }
									 
									 if(fieldhtmltype.equals("3")){//浏览框
										 if(type.equals("2")||type.equals("19")){//日期  + 时间
											 relationtype = "2";
										 }else{
											 relationtype = "4";
										 }
									 }
									 
									 if(fieldhtmltype.equals("4")){//checkbox
										 relationtype = "4";
									 }
									 
									 String valueshowtype = "1";//单行文本输入框
									 
									 if(fieldhtmltype.equals("3")){
										 if(type.equals("2")){//日期 
											 valueshowtype = "2";
										 }else if(type.equals("19")){//时间
											 valueshowtype = "3";
										 }else{
											 valueshowtype = "4";//浏览框--需动态加载
										 }
									 }
									 
									 if(fieldhtmltype.equals("5")){//select框--需动态加载
										 valueshowtype = "5";
									 }
									 
									 if(fieldhtmltype.equals("4")){//checkbox
										 valueshowtype = "6";//select固定值  0  1  null
									 }
									 
											 
									 String optionValue = detailtable+"."+fieldname+splitStr+fieldid+splitStr+fieldhtmltype+splitStr+type+splitStr+fielddbtype+splitStr+relationtype+splitStr+valueshowtype;
								 %>
								 	<option value="<%=optionValue%>" ><%=fieldlabel+tablenameStr%></option>
								 <%
								 }
								 %>
							</select>
                    		</td>
                    		
			               	<td class="td_2">
			               		<span class="compareSpan" name="compareSpan1" style="padding-right:2px;display: none;">
				                    <select name="compareoption1"  style="float:left;width: 80px;">
			                        	<option value="4" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>	<!-- 等于 -->
			                        	<option value="5"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 			<!-- 不等于 -->
			                        	<option value="6"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>				<!-- 包含 -->
			                        	<option value="7"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>			<!-- 不包含 -->
				                    </select>
				            	</span>
				            	
				            	<span class="compareSpan" name="compareSpan2" style="padding-right:2px;display: none;">
				                    <select name="compareoption2"  style="float:left;width: 80px;">
				                       	<option value="0"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>			<!-- 大于 -->
										<option value="1"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option> 			<!-- 大于或等于 -->
										<option value="2"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option> 			<!-- 小于 -->
										<option value="3"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option> 			<!-- 小于或等于 -->
			                        	<option value="4" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>	<!-- 等于 -->
			                        	<option value="5"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 			<!-- 不等于 -->
				                    </select>
				            	</span>
				            	
				            	<span class="compareSpan" name="compareSpan3" style="padding-right:2px;display: none;">
				                    <select name="compareoption3"  style="float:left;width: 80px;">
			                        	<option value="4" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>	<!-- 等于 -->
			                        	<option value="5"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 			<!-- 不等于 -->
				                    </select>
				            	</span>
				            	
				            	<span class="compareSpan" name="compareSpan4" style="padding-right:2px;display: none;">
				                    <select name="compareoption4"  style="float:left;width: 80px;">
			                        	<option value="4" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>	<!-- 等于 -->
				                    </select>
				            	</span>
			            	</td> 
			               	
			        		<td class="td_3">
			        			<span class="valueSpan" name="valueSpan1" style="display:none;"><!-- 单行文本输入框 -->
			                    	<span name="textSpan1" style="padding-left:0px;">
			                    		<input type="text" name="textvalue1" style="width:100px">
			                    	</span>
			        			</span>
			        			<span class="valueSpan" name="valueSpan2" style="display:none;"><!-- 日期控件 -->
			                    	<span name="textSpan2" style="padding-left:0px;">
			                    		<input type="text" name="textvalue2" onclick="WdatePicker()" style="width:100px">
			                    	</span>
			        			</span>
			        			<span class="valueSpan" name="valueSpan3" style="display:none;"><!-- 时间控件 -->
			                    	<span name="textSpan3" style="padding-left:0px;">
			                    		<input type="text" name="textvalue3" onclick="WdatePicker({dateFmt:'HH:mm'})" style="width:100px">
			                    	</span>
			        			</span>
			        			<span class="valueSpan" name="valueSpan4" style="display:none;"><!--  浏览框控件 -->
			                    	<span name="textSpan4" style="padding-left:0px;">
			                    		<input  type="hidden"  name="textvalue4" style="width:100px">
			                    		<button name="fieldBrowser" class="Browser" onclick="showPreDBrowser(this);"  type="button"></button>
			                    		<span  name="textvalue4Span" ></span>
			                    	</span>
			        			</span>
			        			
			        			<span class="valueSpan" name="valueSpan5" style="display:none;"><!-- select框控件 -->
			                    	<span name="textSpan5" style="padding-left:0px;">
			                    		<select type="text" name="textvalue5" style="min-width:100px;max-width:200px">
			                    			
			                    		</select>
			                    	</span>
			        			</span>
			        			
			        			<span class="valueSpan" name="valueSpan6" style="display:none;"><!-- checkbox框控件 -->
			                    	<span name="textSpan6" style="padding-left:0px;">
			                    		<select type="text" name="textvalue6" style="width:100px">
			                    			<option value="0" >0</option>
			                    			<option value="1">1</option>
			                    			<option value="null">null</option>
			                    		</select>
			                    	</span>
			        			</span>
        					</td>
        					<td class="td_4" >
        						<span name="editoperatorSpan" style="display:none;" class="editspan">
        							<input type="button" class="operbtn operbtn_ok" name="editOk" id="editOk" title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" onclick="confirmEdit(this)" value=" ">
	                    			<input type="button" class="operbtn operbtn_cancel" name="editCancel" id="editCancel" title="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" onclick="cancelEdit(this)" value=" ">
        						</span>
        					</td>
        				</TR>
        			</table>
        		</div>
        		
        				</td>
					</tr>
				</table>
        		
        		<div id="line_0" style="width:100%;background:#DADADA;height:1px!important;"></div>
        		<!-- 按钮 -->
        		<div id="btndiv_0" style="height:30px;padding-right:20px;padding-top:5px;padding-bottom:3px;">
        			<div style="float:right;">
	        			<input type="button" class="operbtn operbtn_add" name="paramadd" id="paramadd" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" onclick="addParam('newBlockDiv')" value=" ">
	                    <span style="display:inline-block;width:16px"></span>
	                    <input type="button" class="operbtn operbtn_del" name="paramdelete" id="paramdelete" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>" onclick="delParam()" value=" ">
	                    <span style="display:inline-block;width:16px"></span>
	                    <input type="button" class="operbtn operbtn_joinor" name="addorrelation" id="addorrelation" title="<%=SystemEnv.getHtmlLabelName(24542,user.getLanguage()) %>" onclick="addbracket(0)" value=" ">
	                    <span style="display:inline-block;width:16px"></span>
	                    <input type="button" class="operbtn operbtn_joinand" name="addandrelation" id="addandrelation" title="<%=SystemEnv.getHtmlLabelName(24541,user.getLanguage()) %>" onclick="addbracket(1)" value=" ">
	                    <span style="display:inline-block;width:16px"></span>
	                    <input type="button" class="operbtn operbtn_spit" name="rembracket" id="rembracket" title="<%=SystemEnv.getHtmlLabelName(33576,user.getLanguage()) %>" onclick="splitCondition()" value=" ">
                    </div>
        		</div>
	        	<!-- 分割线 -->
	        	<div id="middleLine" style="width:100%;background:#c4e6e1;height:3px!important;float: left;">
	        	</div>
        	</div>
		</div>
		
		<div id="middle">
			<%
				String ruleContentCss = "";
				String sqlContentCss = "";
				if(conditiontype==1){
					sqlContentCss = "display:none";
				}else{
					ruleContentCss = "display:none";
				}
			%>
			<div id="ruleContent" style="width:100%;height:400px;overflow:auto;<%=ruleContentCss %>">
                <div style="margin-top: 15px;margin-bottom: 15px;margin-left:20px;" id="expressionBlock">
					 <%
                    if (ruleInfoArray.length >0 && ruleInfoArray[0].length() > 0) {
                    %>
                    	<%=ruleInfoArray[0]%>
                    	<%=ruleInfoArray[1]%>
                    <%
                    } else {
                    %>
	                <div id="mainBlock" class="relationblock" style="display:none;" key="-9">
						<div class="verticalblock" onmouseover="relatmouseover(this)"  onmouseout="relatmouseout(this)" ondblclick="switchRelationEditMode(event,this)">&nbsp;AND&nbsp;</div>
						<div class="relationStyle outermoststyle" >
							<div class="relationStyleTop"></div>
							<div class="relationStyleCenter"></div>
							<div class="relationStyleBottom"></div>
						</div>
						
					</div>
					<div type='expressions' class="expressions"  relation='1' id="mainExpression" rotindex="-9" >
						
					</div>
					<%
					} %>
                </div>
                <div style="height:20px;">&nbsp;</div>
            </div>
            <div id="sqlContent" style="<%=sqlContentCss %>">
            	<table style="width: 90%;" border="0" align="center">
            		<colgroup>
            			<col style="width: 50px;" />
            			<col style="width: *" />
            		</colgroup>
            		<tr>
            			<td align="center">sql</td>
            			<td>
            				<textarea rows="13" onkeyup="changeModified();" name="conditionsqlText" id="conditionsqlText" style="width: 100%;"><%if(conditiontype==2){out.print(conditionsql);} %></textarea>
            				<br>
            				<%=SystemEnv.getHtmlLabelName(128096, user.getLanguage()) %>
            				<br>
            				<%=SystemEnv.getHtmlLabelName(21778, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(127392, user.getLanguage()) %>&nbsp;&nbsp;<%=mainTablename %>
            				<%
            					List templist = new ArrayList();
								for(int i = 0; i < detlfields.size(); i++){
									 Map maps = (Map)detlfields.get(i);
									 String detailtable = (String)maps.get("detailtable");
									 if(templist.contains(detailtable)){
										 continue;
									 }
									 templist.add(detailtable);
									 Map detailTempMap = new HashMap();
									 String tablenameStr = "";
									 if(detailMap.containsKey(detailtable)){
										 detailTempMap = (Map)detailMap.get(detailtable);
										 tablenameStr = detailTempMap.get("titles")+"";
										 %>
										 	<br><%=tablenameStr+":&nbsp;&nbsp;"+detailtable %>
										 <%
									 }
								}
							%>
							<br>&nbsp;&nbsp;&nbsp;&nbsp;
            			</td>
            		</tr>
            	</table>
            </div>
		</div>
			
		<div id="footer">
			<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="position:static;">
	          <table width="100%" style="margin-top:-8px;">
			      <tr><td style="text-align:center;" colspan="3" id="jmodaloptcontent">
			          <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" class="zd_btn_submit" onclick="closeDialog()" >
			      </td></tr>
			  </table>
		  </div>
		</div>
		
		
		<div id="ruledesc" >
		</div>
		
		<div id="ruledescBtn">
			<input type="button" id="ruledescBtn_btn" class="operbtn operbtn_up" name="paramdelete" style=""  value=" " onclick="showSql();">
		</div>
		
		
        <div id="displayTemplate" style="display:none;">
        	<div class="relationblock displayspan" onclick="switchSelected(event, this)">
				<div class="verticalblock" onmouseover="relatmouseover(this)" onmouseout="relatmouseout(this)" ondblclick="switchRelationEditMode(event,this);"></div>
				<div class="relationStyle" >
					<div class="relationStyleTop"></div>
					<div class="relationStyleCenter"></div>
					<div class="relationStyleBottom"></div>
				</div>
			</div>
        </div>
        
    </body>
<script type="text/javascript">

var urls = new Array();
<%
    String browserSql = "select * from workflow_browserurl order by id desc";
    String idStr = "";
    String urlStr = "";
    RecordSet.executeSql(browserSql);
    while(RecordSet.next()){
%>
        urls[<%=Util.getIntValue(RecordSet.getString("id"),0)%>] = "<%=RecordSet.getString("browserurl")%>";
<%
    }
%>

jQuery(function($){
	changeContitionType(1);
	resizeRuleContentHeight();
	var baseTR = jQuery(".table_0").find(".baseTR");
	changeTargetFieldid(baseTR);
});


function resizeRuleContentHeight(){
	var middle = jQuery("#middle");
	var ruleContent = jQuery("#ruleContent");
	var footer = jQuery("#footer");
	ruleContent.height(middle.height()-footer.height()-10);
}

function showPreDBrowser(obj){
	var tableObj = jQuery(obj).closest("table");
	var index = tableObj.attr("tableIndex");
	var baseTR = tableObj.find(".baseTR");
	var targetFieldid = baseTR.find("[name=targetFieldid]").val();
	var array = targetFieldid.split("_&_");
	var objtype = array[3];
	var tempbrowsertype = array[4]
	var url = urls[objtype];
	 if(objtype=="161"||objtype=="162")
		url = url + "?type="+tempbrowsertype;
	    if(objtype=="256"||objtype=="257")
		url = url + "?type="+tempbrowsertype+"_"+objtype;
   	onShowBrowser(baseTR,url,objtype);
}

function onShowBrowserCustomNew(baseTR,name, url, type1) {
	var obj = baseTR.find("[name="+name+"]");
	var objSpan = baseTR.find("[name="+name+"Span]");
	url+="&iscustom=1";
	if (type1 == 256|| type1==257) {
		tmpids = obj.val();
		url = url + "&selectedids=" + tmpids;
	}else{
		tmpids = obj.val();
		url = url + "|" + name + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, myid) {
		if (myid != null) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
            	var ids = wuiUtil.getJsonValueByIndex(myid,0);
				var names = wuiUtil.getJsonValueByIndex(myid, 1);
				
				if(type1==161){
	            	var href = "";
					if(myid.href&&myid.href!=""){
						href = myid.href+ids;
					}else{
						href = "javascript:void(0);";
					}
					var sHtml = names;
                    obj.val(ids);
                    objSpan.html(sHtml);
                    
				}else{
	                if (wuiUtil.getJsonValueByIndex(myid,0).substr(0,1)==",") {
	                    obj.val(wuiUtil.getJsonValueByIndex(myid,0).substr(1));
	                    objSpan.html(wuiUtil.getJsonValueByIndex(myid,1).substr(1));
	                }else{
	                    obj.val(wuiUtil.getJsonValueByIndex(myid,0));
	                    objSpan.html(wuiUtil.getJsonValueByIndex(myid,1));
	                }
				}
				
            }else{
                obj.val("");
                objSpan.html("");
            }
             objSpan.html(objSpan.text());
	}
		
	   
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}


function onShowBrowserCustomNew2(baseTR,name, url, type1) {
	var obj = baseTR.find("[name="+name+"]");
	var objSpan = baseTR.find("[name="+name+"Span]");
	
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, myid) {
		if (myid != null) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
            	var ids = wuiUtil.getJsonValueByIndex(myid,0);
				var names = wuiUtil.getJsonValueByIndex(myid, 1);
				
				if(type1==161){
	            	var href = "";
					if(myid.href&&myid.href!=""){
						href = myid.href+ids;
					}else{
						href = "javascript:void(0);";
					}
					var sHtml = names;
                    obj.val(ids);
                    objSpan.html(sHtml);
                    
				}else{
	                if (wuiUtil.getJsonValueByIndex(myid,0).substr(0,1)==",") {
	                    obj.val(wuiUtil.getJsonValueByIndex(myid,0).substr(1));
	                    objSpan.html(wuiUtil.getJsonValueByIndex(myid,1).substr(1));
	                }else{
	                    obj.val(wuiUtil.getJsonValueByIndex(myid,0));
	                    objSpan.html(wuiUtil.getJsonValueByIndex(myid,1));
	                }
				}
				
            }else{
                obj.val("");
                objSpan.html("");
            }
             objSpan.html(objSpan.text());
	}
		
	   
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}


function onShowBrowser(baseTR,url,objtype){
	if (objtype=="161" || objtype=="162"||objtype=="256" || objtype=="257") {
		onShowBrowserCustomNew(baseTR,"textvalue4", url, objtype);
		return;
	}else{
		onShowBrowserCustomNew2(baseTR,"textvalue4", url, objtype);
		return;
	}
	var name = "textvalue4";
	var obj = baseTR.find("[name="+name+"]").get(0);
	var objSpan = baseTR.find("[name="+name+"Span]").get(0);
	url= url+"&selectedids="+obj.value;
	var unitspan = objSpan;
	
    if (objtype==165 || objtype==166 || objtype==167 || objtype==168) {
        var temp=escape("&fieldid="+curfieldid+"&isdetail="+curisdetail);
        var myid = window.showModalDialog(url+temp);
        if (myid) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != ""){
                unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,1).substr(0,1)==",") {
                    obj.value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1).substr(1);
                }else{
                    obj.value =wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                }
            }else{
                unitspan.innerHTML = ""
                obj.value = ""
            }
        }
    }else{
        myid = window.showModalDialog(url);
        if (myid) {
            if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
                unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1);
                if (wuiUtil.getJsonValueByIndex(myid,0).substr(0,1)==",") {
                    obj.value =wuiUtil.getJsonValueByIndex(myid,0).substr(1);
                    unitspan.innerHTML =wuiUtil.getJsonValueByIndex(myid,1).substr(1);
                }else{
                    obj.value = wuiUtil.getJsonValueByIndex(myid,0);
                    unitspan.innerHTML = wuiUtil.getJsonValueByIndex(myid,1);
                }
            }else{
                unitspan.innerHTML = ""
                obj.value = ""
            }
        }
    }
    var objSpan = jQuery(unitspan);
    objSpan.html(objSpan.text());
}

function changeContitionType(isfirst){
	var index = 0;
	var tableObj = jQuery(".table_0");
	var baseTR = tableObj.find(".baseTR");
	var conditiontype = jQuery("#conditiontype").val();
	var line = jQuery("#line_"+index);
	var btndiv = jQuery("#btndiv_"+index);
	var td1 = baseTR.find(".td_1");
	var td2 = baseTR.find(".td_2");
	var td3 = baseTR.find(".td_3");
	if(conditiontype==1){//普通类型
		td1.show();
		line.show();
		btndiv.show();
		jQuery("#ruleContent").show();
		jQuery("#ruledescBtn").show();
		var ruledescBtn_btn = jQuery("#ruledescBtn_btn");
		if(ruledescBtn_btn.hasClass("operbtn operbtn_up")){
			jQuery("#ruledesc").hide();
		}else{
			jQuery("#ruledesc").show();
		}
		jQuery("#sqlContent").hide();
		jQuery("#middle").css("top","74px");
	}else{//sql类型
		line.hide();
		btndiv.hide();
		td1.hide();
		td2.hide();
		td3.hide();
		jQuery("#ruleContent").hide();
		jQuery("#ruledescBtn").hide();
		jQuery("#ruledesc").hide();
		jQuery("#sqlContent").show();
		jQuery("#middle").css("top","40px");
		jQuery("#conditionsqlText").get(0).focus();
	}
	if(isfirst&&isfirst==1){
		// do nothing
	}else{
		changeModified();
	}
}

function changeTargetFieldid(obj,flagStr,fieldvalue){
	var tableObj = jQuery(obj).closest("table");
	var index = tableObj.attr("tableIndex");
	var baseTR = tableObj.find(".baseTR");
	var targetFieldid = baseTR.find("[name=targetFieldid]").val();
	var td2 = baseTR.find(".td_2");
	var td3 = baseTR.find(".td_3");
	baseTR.find(".compareSpan").hide();
	baseTR.find(".valueSpan").hide();
	if(targetFieldid==""){
		td2.hide();
		td3.hide();
	}else{
		var array = targetFieldid.split("_&_");
		var fieldid = array[1];
		var relationtype = array[5];
		var valetype = array[6];
		
		tableObj.find(".compareSpan").hide();
		var compareSpan = baseTR.find("span[name=compareSpan"+relationtype+"]");
		var valueSpan = baseTR.find("span[name=valueSpan"+valetype+"]");
		
		var textvalueObj = baseTR.find("[name=textvalue"+valetype+"]");
		var textvalueSpan = baseTR.find("span[name=textvalue"+valetype+"Span]");
		if(!flagStr){
			textvalueObj.val("");
			textvalueSpan.html("");
		}
		if(valetype==5){
			changeSelectItem(fieldid,textvalueObj.get(0),fieldvalue);
		}
		td2.show();
		td3.show();
		compareSpan.show();
		valueSpan.show();
	}
}


var rulevarAry= [];
//增加条件
function addParam(fatherObj){
	var parentObj = jQuery("#"+fatherObj);
	var baseTR = parentObj.find(".baseTR");
	var targetFieldid = parentObj.find("[name=targetFieldid]").val();
	if (targetFieldid=="") {
		msg = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage()) %>" + "<%=SystemEnv.getHtmlLabelName(15620, user.getLanguage()) %>";
		window.top.Dialog.alert(msg);
		return;
	}
	
	var array = targetFieldid.split("_&_");
	var relationtype = array[5];
	var valetype = array[6];
	
	var fieldvalue = baseTR.find("[name=textvalue"+valetype+"]").val();
	if(fieldvalue==""){
		msg = "<%=SystemEnv.getHtmlLabelName(15642, user.getLanguage()) %>";
		window.top.Dialog.alert(msg);
		return;
	}  
    
       var hiddenarea = getValue4Obj(parentObj,array);
       var hiddenareastr = JSON.stringify(hiddenarea);	//把json转成字符串
       var hiddenElement = $("<input name='child' type='hidden' value='" + hiddenareastr + "'>"); 
       var item = $("<div class='relationItem'></div>");
       item.append($(expressdescElement(hiddenElement)));
       
      
       var selectBlock = $("[_selected=true]");
       if(selectBlock.length > 0)
       {
		var selectBlockParent = $($("[_selected=true]")[0]).closest(".relationblock");
		if($($("[_selected=true]")[0]).is(".relationblock"))
			selectBlockParent = $($("[_selected=true]")[0]).parent(".relationItem").closest(".relationblock");
		selectBlockParent.append(item);
		var rotindex = selectBlockParent.attr("key");
		if(rotindex == 1)
			jQuery("#mainExpression").append(hiddenElement.get(0).outerHTML);
		else
			jQuery("#mainExpression").find("div[rotindex="+rotindex+"]").append(hiddenElement.get(0).outerHTML);
       }else
       {
       	 $("#mainBlock").append(item);
       	 $("#mainExpression").append(hiddenElement.get(0).outerHTML);
       }
       $("#mainBlock").show();
       changeModified();
}


//从parentObj中抽取Element 中的 value
function getValue4Obj(parentObj,array){
	var baseTR = parentObj.find(".baseTR");
	var targetField = baseTR.find("[name=targetFieldid]");
	var fieldlabel = targetField.find("option:selected").text();
	
	var fieldname = array[0];
	var fieldid = array[1];
	var fieldhtmltype = array[2];
	var type = array[3];
	var fielddbtype = array[4];
	var relationtype = array[5];
	var valetype = array[6];
			
	var htmltype = fieldhtmltype; //大类型
	var fieldtype = type;	//小类型
	var dbtype = fielddbtype;//数据库类型
	//
	var compareoption = baseTR.find("[name=compareoption"+relationtype+"]").val();	
	if(dbtype=="text"||dbtype=="clob"){
		compareoption = "100";
	}
	var compareoptionlabel = baseTR.find("[name=compareoption"+relationtype+"]").find("option:selected").text();
	
	//value span 取值
	var fieldvalue = baseTR.find("[name=textvalue"+valetype+"]").val();
	var fieldtext = fieldvalue;
	if(valetype==4){//浏览框
		fieldtext = baseTR.find("[name=textvalue4Span]").html();
	}else if(valetype==5) {//下拉框
		fieldtext = baseTR.find("[name=textvalue"+valetype+"]").find("option:selected").text();
	}
	
	//组装字符串 显示和后台所需
	var hiddenarea = {
		fieldid:fieldid,
		fieldname:fieldname,
		fieldlabel:fieldlabel,
		htmltype:htmltype,
		fieldtype:fieldtype,
		fielddbtype:fielddbtype,
		compareoption:compareoption,
		compareoptionlabel:compareoptionlabel,
		fieldvalue:fieldvalue,
		fieldtext:fieldtext,
		relationtype:relationtype,
		valetype:valetype
	};
	return hiddenarea;
}


//返回表达式显示文字
var expressdescElement = function(inputele, udpateflag) {
	var areaJson = jQuery.parseJSON(inputele.val());

	var displayspan = showDisplaySpan(areaJson)

	var expIndex = inputele.attr("expindex");

	if (!!!udpateflag) {
		expIndex = getExpIndex();
	}

	inputele.attr("expindex", expIndex);
	return "<span class='displayspan' key='"
			+ expIndex
			+ "' onclick='switchSelected(event, this)' ondblclick='switchEditMode(this);'>"
			+ displayspan + "</span>"
};

//拼接条件显示 方法
function showDisplaySpan(areaJson) {
	var datafieldlabel = areaJson.fieldlabel;
	var htmltype = areaJson.htmltype;
	var fieldtype = areaJson.fieldtype;
	var displayspan = datafieldlabel+" " + areaJson.compareoptionlabel + " '"+ areaJson.fieldtext + "'";
	return displayspan;
}

 //双击以有条件后 给对应的Element 赋值
function switchEditMode(target) {
	if (!!!target) return;
	
	var $this = $(target);
    var key = $this.attr("key");
    var children = $("input[name=child][expindex=" + key + "]");
    if (!!!children[0]) return;
    var editBlock = $("<div id='editblock_" + key + "' class='editBlockClass'></div>");
    //克隆之前先解除下拉美化
    $("#newBlockDiv").find("select").selectbox("detach");
	editBlock.append($("#newBlockDiv").children().clone());
	var table = editBlock.find(".table_0");
	table.attr("tableIndex",key);
	table.removeClass("table_0");
	table.addClass("table_"+key);
	//克隆完立即美化 整个过程应该不会闪
	$("#newBlockDiv").find("select").selectbox("attach");
    var areaJson = jQuery.parseJSON(children.val());
    
	var parentObj = editBlock;
	parentObj.find("select").selectbox("detach");
	//**********赋值 start ****************
    var obj = setEditBlockValue(table,areaJson);
	
    parentObj.find("select").selectbox("attach");
    parentObj.find("[name=editoperatorSpan]").show();
    //隐藏span
    $this.hide();
    //clean fieldspan
	fillFieldSpan(editBlock.find("span[name='fieldspan']"), areaJson.datafield, areaJson.datafieldlabel, key);
    $this.parent().append(editBlock);
    changeTargetFieldid(obj,1,"nosel");
    var obj0 = jQuery(".table_0").find(".baseTR");
    changeTargetFieldid(obj0,1,"nosel");
    changeModified();
}
 
//给双击后的条件 Element 赋值--恢复的过程
function setEditBlockValue(table,areaJson){
	var fieldid = areaJson.fieldid;
	var fieldname = areaJson.fieldname;
	var fieldlabel = areaJson.fieldlabel;
	var htmltype = areaJson.htmltype;
	var fieldtype = areaJson.fieldtype;
	var fielddbtype = areaJson.fielddbtype;
	var compareoption = areaJson.compareoption;
	var compareoptionlabel = areaJson.compareoptionlabel;
	var fieldvalue = areaJson.fieldvalue;
	var fieldtext = areaJson.fieldtext;
	var relationtype = areaJson.relationtype;
	var valetype = areaJson.valetype;
	
	var baseTR = table.find(".baseTR");
	var targetField = baseTR.find("[name=targetFieldid]");
	var splitStr = "<%=splitStr%>";
	var optionValue = fieldname+splitStr+fieldid+splitStr+htmltype+splitStr+fieldtype+splitStr+fielddbtype+splitStr+relationtype+splitStr+valetype;
	targetField.val(optionValue);
	changeTargetFieldid(targetField.get(0),0,fieldvalue);
	
	var compareoptionObj = baseTR.find("[name=compareoption"+relationtype+"]");
	compareoptionObj.val(compareoption);
	var textvalueObj = baseTR.find("[name=textvalue"+valetype+"]");
	if(valetype==4){//浏览框
		baseTR.find("[name=textvalue"+valetype+"Span]").html(fieldtext);
	}else if(valetype==5){
		changeSelectItem(fieldid,textvalueObj.get(0),fieldvalue);
		//---------------------
	}
	textvalueObj.val(fieldvalue);
	
	baseTR.find(".td_4").show();
	return targetField.get(0);
}

/**
 * 动态改变选择框的值
 * @param {Object} fieldid   workflow_billfield  id
 * @param {Object} objname     选择框name
 */
function changeSelectItem(fieldid,obj,objvalue){
	 if(objvalue&&objvalue=="nosel"){
		 return;
	 }
	jQuery.ajax({
	   type: "POST",
	   dataType:"json",
	   url:"/formmode/interfaces/shareOperation.jsp?action=getSelectItem&fieldid="+fieldid,
	   success: function(data){
	     	if(data&&data.length){
				var selObj = jQuery(obj);
				selObj.selectbox("detach");
				selObj.find("option").remove();
				selObj.append("<option></option>");
				for(var i=0;i<data.length;i++){
					var selectedStr = "";
					if(objvalue&&objvalue==data[i].selectvalue+""){
						selectedStr = "selected";
					}
					selObj.append("<option "+selectedStr+" value='"+data[i].selectvalue+"'>"+data[i].selectname+"</option>");
				}
				selObj.selectbox("attach");
			}
	   }
	});

}
 
 //取消编辑
function cancelEdit(target) {
	var editBlock = $(target).closest("table").parent("div");
	if (!!!editBlock) return ;
	var displaySpan = editBlock.parent().children("span");
	editBlock.remove();
 	displaySpan.show();
}

//双击条件后 确定修改的操作
function confirmEdit(target){
	var editBlock = jQuery(target).closest("table").parent("div");
	if(!!!editBlock) return;
	var displaySpan = editBlock.parent().children("span");
   	var key = displaySpan.attr("key");
   	var children = $("input[name=child][expindex=" + key + "]");
   	if (!!!children[0]) return;
   	
   var parentObj = jQuery(".table_"+key);
	var baseTR = parentObj.find(".baseTR");
	var targetFieldid = parentObj.find("[name=targetFieldid]").val();
	if (targetFieldid=="") {
		msg = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage()) %>" + "<%=SystemEnv.getHtmlLabelName(15620, user.getLanguage()) %>";
		window.top.Dialog.alert(msg);
		return;
	}
	
	var array = targetFieldid.split("_&_");
	var relationtype = array[5];
	var valetype = array[6];
	
	var fieldvalue = baseTR.find("[name=textvalue"+valetype+"]").val();
	if(fieldvalue==""){
		msg = "<%=SystemEnv.getHtmlLabelName(15642, user.getLanguage()) %>";
		window.top.Dialog.alert(msg);
		return;
	}  
    
    var hiddenarea = getValue4Obj(parentObj,array);
   	
   	var hiddenareastr = JSON.stringify(hiddenarea)
   	children.val(hiddenareastr);
   	var displayspan = showDisplaySpan(hiddenarea);
   	displaySpan.html(displayspan);
   	editBlock.remove();
	displaySpan.show();
   	
}

//获取expressions元素的json
var getExpItemsXmlString = function (expressions) {
    //表达式关系
    var relationship = parseInt(expressions.attr("relation"));
    var result = "<div relation='" + relationship + "'>";
    
    //继续查找expressions
    var children = expressions.children();
    for (var i = 0; i < children.length; i++) {
        if ($(children[i]).attr("type") == "expressions") {
        	result += getExpItemsXmlString($(children[i]))
            continue;
        } 
        //input 表达式单项xml
        result += getExpItemXmlString($(children[i]));
    }
    
    result += "</div>";
    return result;
};


 //单项表达式的json字符串
var getExpItemXmlString = function (expItem) {
  var children = expItem;
  if (!!!children[0]) return "";
  var areaJson = jQuery.parseJSON(children.val());
 	if(!!!areaJson.exitemid) areaJson.exitemid = -1;
	var result = "<expression id='" + areaJson.exitemid + "' fieldid='" + areaJson.fieldid + "' fieldlabel='" + areaJson.fieldlabel + "' ";
     result += "fieldname='" + areaJson.fieldname + "' ";
     result += "htmltype='" + areaJson.htmltype + "' ";
     result += "fieldtype='" + areaJson.fieldtype + "' ";
     result += "fielddbtype='" + areaJson.fielddbtype + "' ";
     result += "compareoption='" + areaJson.compareoption + "' ";
     result += "compareoptionlabel='" + areaJson.compareoptionlabel + "' ";
     result += "fieldvalue='" + areaJson.fieldvalue + "' ";
     result += "fieldtext='" + areaJson.fieldtext + "' ";
     result += "relationtype='" + areaJson.relationtype + "' ";
     result += "valetype='" + areaJson.valetype + "' ";
     result += "rightid='<%=rightid%>' ";
     result += ">";
     result += "</expression>";
     
     return result;
};

function getSql(){
	var sql = getSqlStr($("#mainExpression"));
	if(sql!=""){
		sql = "("+sql+")";
	}
	jQuery("#conditionsql").val(sql);
}

function getDesc(){
	var desc = expressionsToString($("#mainExpression"));
	if(desc!=""){
		desc = "("+desc+")";
	}
	jQuery("#conditiontext").val(desc);
}

function getSqlStr(expressions) {
	var result = "";
    var relationship = expressions.attr("relation");
    var relation = " AND ";
    if (relationship == '0') {
        relation = " OR ";
    }
    //继续查找expressions
    var children = expressions.children();
    for (var i = 0; i < children.length; i++) {
        if (i != 0) {
            result += relation;
        }
        var childnum = children.length;
        if ($(children[i]).attr("type") == "expressions") {
        	if(childnum>1){
        		result += "(" + getSqlStr($(children[i])) + ")";
        	}else if(childnum==1){
        		result += "" + getSqlStr($(children[i])) + "";
        	}
            continue;
        } 
        var key = $(children[i]).attr("expindex");
        var value = $(children[i]).val();
        var areaJson = jQuery.parseJSON(value);
        
        var fieldname = areaJson.fieldname;
        var compareoption = areaJson.compareoption;
        var fieldvalue = areaJson.fieldvalue;
        var htmltype = areaJson.htmltype;
        var fieldtype = areaJson.fieldtype;
        
        var relationAndVal = "";
        if(fieldvalue=="null"&&(htmltype==5||htmltype==4)){//select或者checkbox 框为null
        	if(compareoption==4){//等于
        		relationAndVal = " is null ";
        	}else{//不等于
        		relationAndVal = " is not null ";
        	}
        }else{
        	if(compareoption==6){//包含
        		relationAndVal = " like "+"'%"+fieldvalue+"%'";
        	}else if(compareoption==7){//不包含
        		relationAndVal = " not like '%"+fieldvalue+"%'";
        	}else {
        		var isneedf = true;
		        if(htmltype==4){//checkbox
		        	isneedf = false;
		        }else if(htmltype==1&&(fieldtype==2||fieldtype==3)){//整数浮点数
		        	isneedf = false;
		        }else if(htmltype==5){//select框
		        	isneedf = false;
		        }
	        
        		if(isneedf){
		        	relationAndVal = " $#"+compareoption+"#$ '"+fieldvalue+"'";
        		}else{
		        	relationAndVal = " $#"+compareoption+"#$ "+fieldvalue;
        		}
        	}
        }
        if(childnum>1)
        	result += "( " + fieldname+relationAndVal+ " )";
        else if(childnum==1)
        	result += "" + fieldname+relationAndVal + "";
    }
    return result;
}
  
var sqlisshow = false;
function showSql() {
	if (!sqlisshow) {
		var sqlStr = getSqlStr($("#mainExpression"));
            
	if (sqlStr == null || sqlStr == "") {
		sqlStr = "<%=SystemEnv.getHtmlLabelName(84304, user.getLanguage()) %>";
	} else {
		sqlStr = ReplaceAll(sqlStr,"$#0#$", ">");
		sqlStr = ReplaceAll(sqlStr,"$#1#$", ">=");
		sqlStr = ReplaceAll(sqlStr,"$#2#$", "<");
		sqlStr = ReplaceAll(sqlStr,"$#3#$", "<=");
		sqlStr = ReplaceAll(sqlStr,"$#4#$", "=");
		sqlStr = ReplaceAll(sqlStr,"$#5#$", "!=");
		sqlStr = ReplaceAll(sqlStr,"$#100#$", "like");
		
		sqlStr = "(" + sqlStr + ")";
	}
		$("#ruledesc").html(sqlStr);
		$("#ruledesc").show();
		var hgt = $("#ruledesc").height();
		$("#ruledescBtn_btn").removeClass("operbtn_up");
		$("#ruledescBtn_btn").addClass("operbtn_down");
		$("#ruledescBtn").css("bottom", hgt + 8 + 50);
	} else {
		$("#ruledesc").hide();
		$("#ruledescBtn_btn").removeClass("operbtn_down");
		$("#ruledescBtn_btn").addClass("operbtn_up");
		$("#ruledescBtn").css("bottom", 50);
	}
	sqlisshow = !sqlisshow;
}

function ReplaceAll(str, sptr, sptr1){
        while (str.indexOf(sptr) >= 0){
           str = str.replace(sptr, sptr1);
        }
        return str;
}

var descisshow = false;
function showDesc() {
	if (!descisshow) {
	var desc = expressionsToString($("#mainExpression"));
	if (desc == null || desc == "") {
		desc = "<%=SystemEnv.getHtmlLabelName(84304, user.getLanguage()) %>";
	} else {
		desc = "(" + desc + ")";
	}
		$("#ruledesc").html(desc);
		$("#ruledesc").show();
		var hgt = $("#ruledesc").height();
		$("#ruledescBtn_btn").removeClass("operbtn_up");
		$("#ruledescBtn_btn").addClass("operbtn_down");
		$("#ruledescBtn").css("bottom", hgt + 8 + 50);
	} else {
		$("#ruledesc").hide();
		$("#ruledescBtn_btn").removeClass("operbtn_down");
		$("#ruledescBtn_btn").addClass("operbtn_up");
		$("#ruledescBtn").css("bottom", 50);
	}
	descisshow = !descisshow;
}

//获取expressions元素的desc
function expressionsToString(expressions) {
    var result = "";
    var relationship = expressions.attr("relation");
    var relationDesc = "&nbsp;AND&nbsp;";
    if (relationship == '0') {
        relationDesc = "&nbsp;OR&nbsp;";
    }
    //继续查找expressions
    var children = expressions.children();
    for (var i = 0; i < children.length; i++) {
        if (i != 0) {
            result += relationDesc;
        }
        var childnum = children.length;
        if ($(children[i]).attr("type") == "expressions") {
        	if(childnum>1)
        		result += "(" + expressionsToString($(children[i])) + ")";
        	else if(childnum==1)
        		result += "" + expressionsToString($(children[i])) + "";
            continue;
        } 
        var key = $(children[i]).attr("expindex");
        if(childnum>1)
        	result += "(" + $("span[key=" + key + "]").html().replace("&nbsp;", " ") + ")";
        else if(childnum==1)
        	result += "" + $("span[key=" + key + "]").html().replace("&nbsp;", " ") + "";
    }
    return result;
};

//保存
function onSave(flag){
	var conditiontype = jQuery("#conditiontype").val();
	if(conditiontype==2){
		if ($("#conditionsqlText").val()=="") {
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>');
			return;
		}
	}else{
		
		if ($("[name=child]").length==0) {
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>');
			return;
		}
	}
	if(!flag){
		setTimeout(function(){
			onSave(true);
		},500);
		return;
	}
	var allexprblock = $("#expressionBlock").children(".expressions");
   	
   	//if (allexprblock.children().length == 0) {
   	//	alert("没有任何表达式, 不需要保存");
   	//	return;
   	//}
   	var result = "";
   	
   	allexprblock.each(function (i, ele) {
		var expsChildrens = $("#mainExpression");
		if (!!expsChildrens[0]) {
			result += getExpItemsXmlString(expsChildrens);
		}
   	});
   	result = "<?xml version='1.0' encoding='utf-8'?>" + result;
   	//console.dir(result);
   	var expression = expressionsToString($("#mainExpression"));
	if (expression == null || expression == "") {
		expression = "<%=SystemEnv.getHtmlLabelName(84304, user.getLanguage()) %>";
	} else {
		expression = "(" + expression + ")";
	}
	getSql();
	getDesc();
   	$.ajax({
		type: "post",
	    url: "/formmode/interfaces/shareOperation.jsp?_" + new Date().getTime() + "=1&action=saveCondition",
	    data: {
	    	rulexml: result, 
	    	modeid: jQuery("#modeid").val(),
	    	rightid:jQuery("#rightid").val(),
	    	conditiontext:jQuery("#conditiontext").val(),
	    	conditionsql:jQuery("#conditionsql").val(),
	    	conditiontype:jQuery("#conditiontype").val(),
	    	conditionsqlText:jQuery("#conditionsqlText").val(),
	    	condit:	expression
	    	},
	    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
	    complete: function(){
		},
	    error:function (XMLHttpRequest, textStatus, errorThrown) {
	    } , 
	    success:function (data, textStatus) {
	    	if(dialog){
				var currentWindow = dialog.currentWindow;
				//currentWindow.location.href = currentWindow.location.href;
				currentWindow.location.reload();
				dialog.close();
			}
	    } 
    });
}


function onCheckSQL(){
	var ismodified = jQuery("#ismodified").val();
	if(ismodified=="1"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82692,user.getLanguage())%>");
		return;
	}
	$.ajax({
	   type: "POST",
	   url: "/formmode/interfaces/shareOperation.jsp?action=checkSQL",
	   data: "rightid=<%=rightid%>",
	   dataType:"json",
	   success: function(data){
	      if(data&&data.msg){
	    	  window.top.Dialog.alert(data.msg);
	      }
	   }
	});
}

function changeModified(){
	jQuery("#ismodified").val("1");
}

function delFieldCallback(text, fieldid, params) {
		
}
</script>
</html>
