<!DOCTYPE html>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    int ruleid = Util.getIntValue(request.getParameter("ruleid"), 0);
   
    String isnew = Util.null2String(request.getParameter("isnew"));
    if(isnew.equals("1")) ruleid = 0;
    
    //System.err.println("ruleid:"+ruleid);
    //RuleBusiness rulebs = new RuleBusiness();
    
    
	IntegratedSapUtil integratedSapUtil = new IntegratedSapUtil();
	BrowserComInfo browserComInfo = new BrowserComInfo();
	String IsOpetype = integratedSapUtil.getIsOpenEcology70Sap();
	
	//***********************
	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	
	String[] ruleInfoArray = RuleBusiness.getRuleHtmlByRuleId(ruleid,user);
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String linkid = Util.null2String(request.getParameter("linkid"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	List<String> nodesOptions = new ArrayList<String>();
	int rownum = Util.getIntValue(request.getParameter("rownum"),0);
	if(nodeid !=null && !nodeid.equals("")){
		String sql="SELECT nodeid, nodename FROM workflow_nodebase a INNER JOIN " +
		"(SELECT nodeid,nodetype FROM  workflow_flownode WHERE workflowid="+
		"(SELECT workflowid FROM workflow_flownode WHERE nodeid=" + nodeid + "))b "
		+"ON a.id=b.nodeid WHERE (a.IsFreeNode is null or a.isfreenode<>'1') and b.nodeType <> '3' order by nodeid";
		//System.out.println("=================sql1=" + sql);
		rs.executeSql(sql);
		while(rs.next()){
			nodesOptions.add("<option value="+rs.getInt("nodeId")+">"+Util.null2String(rs.getString("nodename"))+"</option>");
		}
	}else{
		String sql="SELECT id, nodename FROM workflow_nodebase a,workflow_flownode b "+
			"WHERE a.id=b.nodeid and b.workflowid="+wfid+" and (a.IsFreeNode IS NULL OR a.isfreenode <>'1') and b.nodeType <> '3' "+
			"ORDER BY id ASC";	
		//System.out.println("=================sql2=" + sql);
		rs.executeSql(sql);
		while(rs.next()){
			nodesOptions.add("<option value="+rs.getInt("id")+">"+Util.null2String(rs.getString("nodename"))+"</option>");
		}	    
	}
%>
<html>
    <head>
		<META http-equiv="X-UA-Compatible" content="IE=8" > </META>
        <title>rule-based design</title>

        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        
        <link rel="stylesheet" type="text/css" href="/workflow/ruleDesign/css/ruleDesign_wev8.css">
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script type='text/javascript' src='/workflow/ruleDesign/js/jsUUID_wev8.js'></script>
		<script type='text/javascript' src='/js/weaver_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		
<!-- 可以抽取js 到jsp中 并 clude -->
<script type="text/javascript">
	//请选择字段 
   	var nothaveFile = "<%=SystemEnv.getHtmlLabelName(82098,user.getLanguage())%>";

   	var andstr = "<%=SystemEnv.getHtmlLabelName(18760,user.getLanguage())%>";
   	var checkedstr = "<%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%>";
   	var notcheckedstr = "<%=SystemEnv.getHtmlLabelName(22906,user.getLanguage())%>";
   	var levelstr = "<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>";
   	var weaverSplit = "||~WEAVERSPLIT~||";	//切割符

	var splitstr = "-;-";
   	var over_rulesrc = "<%=rulesrc%>";
   
   	var BROWSER_MAPPING = {
   		'1':'17',
   		'17':'1',
   		'165':'166',
   		'166':'165',
   		'4':'57',
   		'57':'4',
   		'24':'278',
   		'278':'24',
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

   	//动态获取 选择字段浏览框的地址和参数

   	function getFieldUrl(parames)
	{
		return "/systeminfo/BrowserMain.jsp?url=/workflow/ruleDesign/showFieldBrowser.jsp?formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&pagetype=<%=rulesrc%>";
	}
	function getLocationUrl(parames){
		//return "/systeminfo/BrowserMain.jsp?url=/workflow/ruleDesign/showLocateOffline.jsp?formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&pagetype=<%=rulesrc%>";
		return "/systeminfo/BrowserMain.jsp?url=/workflow/ruleDesign/showLocateOnline.jsp?formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&pagetype=<%=rulesrc%>";
		
	}
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
		if(over_rulesrc==="3")
		{
			var parentObj = jQuery("#newBlockDiv");
			parentObj.find("[name=valuetype] option").remove();
			parentObj.find("[name=htmltype]").val("1");
			parentObj.find("[name=fieldtype]").val("1");
			parentObj.find("select").selectbox("detach");
			showValueSpan(parentObj,"1","1");
			parentObj.find("select").selectbox("attach");
		}
		
	});	
	var descisshow = false;
	function showDesc() {
		if (!descisshow) {
		var desc = expressionsToString($("#mainExpression"));
		if (desc == null || desc == "") {
			desc = "<%=SystemEnv.getHtmlLabelName(84304,user.getLanguage())%>";
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
            
            var _keyhtml = $("span[key=" + key + "]").html();
            if(childnum>1)
            	result += "(" + _keyhtml.replace("&nbsp;", " ") + ")";
            else if(childnum==1)
            	result += "" + _keyhtml.replace("&nbsp;", " ") + "";
        }
        return result;
    };
	
	function convertVar2xml(str) {
		str = str.replace("&", "&amp;");
		str = str.replace("'", "&apos;");
		str = str.replace("\"", "&quot;");
		str = str.replace(">", "&gt;");
		str = str.replace("<", "&lt;");
		str = str.replace("\\", "");
		return str;
	}
	
	function getajaxurl(targetid){
		var parentObj = jQuery(targetid);
		var selectedOption = parentObj.find("[name=browsertype]").find("option:selected");
		var typeId = $(selectedOption).val();
		var url = "";
		if(typeId==1 || typeId==165 || typeId==166 || typeId==17 || typeId==160){
			url = "/data.jsp";
		} else {
			url = "/data.jsp?type=" + typeId;
		}
       	return url;
	}

	function delFieldCallback(text, fieldid, params) {
		var parentObj = '';
		if (!!params) {
			parentObj = jQuery("div#editblock_" + params);
		} else {
			parentObj = jQuery("div#newBlockDiv");
		}
		parentObj.find("img").show();
		//先隐藏所有的value span
		hideAllValueSpan(parentObj);
		parentObj.find("span[name=multitype4hrmspan]").hide();
		//rulesrc 3
		<%if("3".equals(rulesrc)){%>
		paramChangeForRList();
		<%}%>
	}
	
    function paramChangeForRList(){
    	$("#paramtype").selectbox("detach");
    	jQuery("#paramtype").val("0");
        $("#paramtype").selectbox("attach");
    	var parentObj = jQuery($($G("paramtype")).closest("table").parent("div"));
    	parentObj.find("[name=valuetype] option").remove();
   		parentObj.find("[name=htmltype]").val("1");
		parentObj.find("[name=fieldtype]").val("1");
   		hideAllValueSpan(parentObj);
   		var htmltype = parentObj.find("[name=htmltype]").val();
   		var fieldtype = parentObj.find("[name=fieldtype]").val();
   		parentObj.find("select").selectbox("detach");
   		parentObj.find("span[name=compareSpan1]").show();
   		parentObj.find("input[name=selectfiled]").show();
   		showValueSpan(parentObj,htmltype,fieldtype);
   		parentObj.find("select").selectbox("attach");
    }

	//字段选择后的回调函数 selectfiled
	function callbackMeth(evt,data,name,paras,tg)
	{
		var parentObj = jQuery($(tg).closest("table").parent("div"));
		if(!tg){
			var _target = evt.srcElement || evt.target;
			parentObj = jQuery($(_target).closest("table").parent("div"));
		}
		
		if(data.id)
		{
			parentObj.find("select").selectbox("detach");
			parentObj.find("span[name=fieldspan]").find("img").hide();
			var htmltype = data.pfiled.split(weaverSplit)[0];
			var type = data.pfiled.split(weaverSplit)[1];
			var dbtype = data.pfiled.split(weaverSplit)[2];
			var selectVal = "";
			
			if(htmltype ==="5")selectVal = data.pfiled.split(weaverSplit)[3];
			parentObj.find("[name=htmltype]").val(htmltype);
			parentObj.find("[name=fieldtype]").val(type);
			parentObj.find("[name=dbtype]").val(dbtype);
			parentObj.find("[name=multitype4hrmselect] option:eq(0)").attr('selected','selected');
			
		
			if(htmltype==="3" && (type==="1" || type==="17"))
				parentObj.find("span[name=multitype4hrmspan]").show();
			else
				parentObj.find("span[name=multitype4hrmspan]").hide();
			
			//先隐藏所有的value span
			
			hideAllValueSpan(parentObj);
			//只有当checkbox 时 不显示比较span
			//if(htmltype != "4")
			 parentObj.find("span[name=compareSpan1]").show();
			showValueSpan(parentObj,htmltype,type,selectVal);
			parentObj.find("select").selectbox("attach");
			
		} else {
			var divId = parentObj.attr('id');
			var reg = /^editblock_([0-9])+$/gi;
			if (reg.test(divId)) {
				var key = divId.replace(reg, '$1');
				delFieldCallback("","",key);
			} else {
				delFieldCallback();
			}
		}
	}
	var addr = "";
	var jingdu   = "";
	var weidu 	 = "";
	function locationBrowerCallback(evt,data,name,paras,tg){
		addr = data.addr;
		jingdu = data.jingdu;
		weidu = data.weidu;
	}
	function locationDelCallback(){
	}
	//字段选择后的回调函数中抽出的方法， 隐藏/显示valuespan 中的Element
	function showValueSpan(parentObj,htmltype,type,selectval)
	{
		//alert("htmltype = "+htmltype);
		//alert("type = "+type);
		//alert("selectval = "+selectval);
		//移出再加入

		parentObj.find("[name=compareoption1] option").remove();
		clearAllElementvalue(parentObj);	//清除所有value span 中element 的值  
		parentObj.find("select[name=compareoption1]").selectbox("detach");
		if((htmltype==="1" && type==="1") || htmltype==="2")	//字符串

		{
			parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='9'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='10'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
			parentObj.find("span[name=textSpan1]").show();			
			if(over_rulesrc==="3")
			{
				parentObj.find("[name=valuetype]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");
				parentObj.find("[name=rediusSpan]").css("display","none");
				parentObj.find("font[name='varName']").css("display","none");
				parentObj.find("span[name='valueSpan1']").css("display", "");
			}
			jQuery("span[name='locationSpan']").css("display", "none");
		} else if((htmltype==="1" && type!="1") || (htmltype==="3" && (type==="2" || type==="19" || type==="_level")))	//数值 或 日期 或时间 人员的安全级别比较特殊
		{
			parentObj.find("[name=compareoption1]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='2'><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
           	parentObj.find("span[name=textSpan1]").show();
           	if(over_rulesrc==="1" || over_rulesrc==="2"|| over_rulesrc==="6" || over_rulesrc==="7" || over_rulesrc==="8")
           	{
	           	parentObj.find("[name=compareoption2] option").remove();
	           	parentObj.find("[name=compareoption2]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption2]").append("<option value='2'><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption2]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption2]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option>");
	           	parentObj.find("[name=compareoption2]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
	           	parentObj.find("[name=compareoption2]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
	           	parentObj.find("span[name=compareSpan2]").show();
	           	parentObj.find("span[name=textSpan2]").show();
           	}else
           	{
           		parentObj.find("[name=valuetype]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");
           		parentObj.find("[name=rediusSpan]").css("display","none");
           		parentObj.find("font[name='varName']").css("display","none");
           		parentObj.find("span[name='valueSpan1']").css("display", "");
           	}
           	jQuery("span[name='locationSpan']").css("display", "none");
		} else if(htmltype==="4")		//checkbox			
		{
			parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
			parentObj.find("span[name=checkSpan1]").show();
			jQuery("span[name='locationSpan']").css("display", "none");
		} else if(htmltype==="5")		//下拉框

		{
			parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
			parentObj.find("span[name=selectSpan1]").show();
			var sv = jQuery.parseJSON(selectval);
			for(var jl in sv)
			{
				if(typeof(sv[jl].value) != "undefined")
					parentObj.find("select[name=selectvalue1]").append("<option value='"+sv[jl].value+"'>"+sv[jl].label+"</option>");
			}
			jQuery("span[name='locationSpan']").css("display", "none");
		} else if(htmltype==="3")
		{
			if(type!="152" && type!="37" && type!="9" && type!="135" 
					&& type!="8" && type!="16" && type!="169" && type!="7" && type!="1" 
					&& type!="2" && type!="18" && type!="19" && type!="17" && type!="24" 
					&& type!="160" && type!="4" && type!="57" && type!="164" &&type!="166"
					&& type!="168" && type!="170" && type!="142" && type!="165" &&type!="169"
					&& type!="65" && type!="146" && type!="167" && type!="117" && type!="194" && type!="256" && type!="257" && type!="278"){
				if(type==="162")
				{
					parentObj.find("[name=compareoption1]").append("<option value='9'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>");
					parentObj.find("[name=compareoption1]").append("<option value='10'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
					creatBrowservalue(parentObj,false,"","",type);
				}else
				{
					parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
                    parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
					creatBrowservalue(parentObj,true,"","",type);
				}	
			}else if(type==="9" || type==="8" || type==="16" || type==="7" || type==="1"  
					|| type==="165" || type==="169" || type==="4" || type==="164" || type==="146" || type==="167"
					|| type==="24" || type==="256") //单选

			{
				parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
                parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
				if(type==="4" || type==="164" || type==="167" || type==="169")
				{
					parentObj.find("[name=compareoption1]").append("<option value='11'><%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %></option>");
					parentObj.find("[name=compareoption1]").append("<option value='12'><%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %></option>");
				}
               creatBrowservalue(parentObj,true,"","",type); 
			}else if(type==="57" || type==="168" || type==="142" || type==="17" || type==="18"
					|| type==="135" || type==="37" || type==="152" || type==="65" || type==="160" || type==="166"
					|| type==="170" || type==="194" || type==="257" || type==="278"){//多选

				parentObj.find("[name=compareoption1]").append("<option value='9'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption1]").append("<option value='10'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
				//if(type==="142")
				//{
					//parentObj.find("[name=compareoption1]").append("<option value='11'><%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %></option>");
					//parentObj.find("[name=compareoption1]").append("<option value='12'><%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %></option>");
				//}
				creatBrowservalue(parentObj,false,"","",type);
			}
			parentObj.find("[name=browsertype]").val(type);
			parentObj.find("span[name=browserSpan]").show();
			if(over_rulesrc==="3")
			{
				parentObj.find("[name=valuetype]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(33747,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");
				parentObj.find("span[name=browsertypeSpan1]").show();
				parentObj.find("[name=rediusSpan]").css("display","none");
				parentObj.find("font[name='varName']").css("display","none");
			}
		} else if(htmltype==="9"){
			if(over_rulesrc==="3"){  //规则管理中的规则选择位置字段
				parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
	            parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='0'><%=SystemEnv.getHtmlLabelName(33747,user.getLanguage()) %></option>");	//选择值
				parentObj.find("[name=rediusSpan]").css("display","");
				parentObj.find("font[name='varName']").css("display","");   			
   				jQuery("span[name='valuetype']").css("display", "none");
			}else{
				parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
	            parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
	            //parentObj.find("[name=compareoption1]").css("width","50");
				creatBrowservalue(parentObj,true,"","",type);
				jQuery("span[name='locationSpan']").css("display", "");
				jQuery("#nodes").empty();			
				<%
				for(String node : nodesOptions){
				%>
					jQuery("#nodes").append("<%=node%>");
				<%}%>
			}

		}
		/*
		if(type==="_sysvar")
		{
			parentObj.find("span[name=textSpan1]").hide();
			parentObj.find("span[name=browserSpan]").show();
			creatBrowservalue(parentObj,true,"","",type);
		}
		*/
	}
	//字段选择后的回调函数中抽出的方法， 隐藏/显示valuespan 中的Element
	function showValueSpanNew(parentObj,htmltype,type,selectval,addvaluetype)
	{
		//alert("htmltype = "+htmltype);
		//alert("type = "+type);
		//alert("selectval = "+selectval);
		//移出再加入

		parentObj.find("[name=compareoption1] option").remove();
		clearAllElementvalue(parentObj);	//清除所有value span 中element 的值
		parentObj.find("[name=rediusSpan]").hide();
		parentObj.find("[name=varName]").hide();
		parentObj.find("[name=valuetype1]").show();
		if((htmltype==="1" && type==="1") || htmltype==="2")	//字符串
		{
		    
			parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='9'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='10'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
			parentObj.find("span[name=textSpan1]").show();
			if(over_rulesrc==="3")
			{
				parentObj.find("[name=valuetype]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");
			}
		} else if((htmltype==="1" && type!="1") || (htmltype==="3" && (type==="2" || type==="19" || type==="_level")))	//数值 或 日期 或时间 人员的安全级别比较特殊

		{
			parentObj.find("[name=compareoption1]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='2'><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
           	parentObj.find("span[name=textSpan1]").show();
           	if(over_rulesrc==="1" || over_rulesrc==="2"|| over_rulesrc==="6" || over_rulesrc==="7" || over_rulesrc==="8")
           	{
	           	parentObj.find("[name=compareoption2] option").remove();
	           	parentObj.find("[name=compareoption2]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption2]").append("<option value='2'><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption2]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption2]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option>");
	           	parentObj.find("[name=compareoption2]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
	           	parentObj.find("[name=compareoption2]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
	           	parentObj.find("span[name=compareSpan2]").show();
	           	parentObj.find("span[name=textSpan2]").show();
           	}else
           	{
           		parentObj.find("[name=valuetype]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>");
				parentObj.find("[name=valuetype]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");
           	}
		} else if(htmltype==="4")		//checkbox			
		{
			parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
			parentObj.find("span[name=checkSpan1]").show();
		} else if(htmltype==="5")		//下拉框

		{
			parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
			parentObj.find("span[name=selectSpan1]").show();
			var sv = jQuery.parseJSON(selectval);
			for(var jl in sv)
			{
				if(typeof(sv[jl].value) != "undefined")
					parentObj.find("select[name=selectvalue1]").append("<option value='"+sv[jl].value+"'>"+sv[jl].label+"</option>");
			}
		} else if(htmltype==="3")
		{
			if(type!="152" && type!="37" && type!="9" && type!="135" 
					&& type!="8" && type!="16" && type!="169" && type!="7" && type!="1" 
					&& type!="2" && type!="18" && type!="19" && type!="17" && type!="24" 
					&& type!="160" && type!="4" && type!="57" && type!="164" &&type!="166"
					&& type!="168" && type!="170" && type!="142" && type!="165" &&type!="169"
					&& type!="65" && type!="146" && type!="167" && type!="117" && type!="194" && type!="256" && type!="257" && type!="278"){
				if(type==="162")
				{
					parentObj.find("[name=compareoption1]").append("<option value='9'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>");
					parentObj.find("[name=compareoption1]").append("<option value='10'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
					creatBrowservalueNew(parentObj,false,"","",type);
				}else
				{
					parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
                    parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
                    creatBrowservalueNew(parentObj,true,"","",type);
				}	
			}else if(type==="9" || type==="8" || type==="16" || type==="7" || type==="1"  
					|| type==="165" || type==="169" || type==="4" || type==="164" || type==="146" || type==="167"
					|| type==="24" || type==="256") //单选

			{
				parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
                parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
				if(type==="4" || type==="164" || type==="167" || type==="169")
				{
					parentObj.find("[name=compareoption1]").append("<option value='11'><%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %></option>");
					parentObj.find("[name=compareoption1]").append("<option value='12'><%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %></option>");
				}
				creatBrowservalueNew(parentObj,true,"","",type); 
			}else if(type==="57" || type==="168" || type==="142" || type==="17" || type==="18"
					|| type==="135" || type==="37" || type==="152" || type==="65" || type==="160" || type==="166"
					|| type==="170" || type==="194" || type==="257" || type==="278"){//多选

				parentObj.find("[name=compareoption1]").append("<option value='9'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption1]").append("<option value='10'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
				//if(type==="142")
				//{
					//parentObj.find("[name=compareoption1]").append("<option value='11'><%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %></option>");
					//parentObj.find("[name=compareoption1]").append("<option value='12'><%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %></option>");
				//}
				creatBrowservalueNew(parentObj,false,"","",type);
			}
			parentObj.find("[name=browsertype]").val(type);
			if(addvaluetype == "3"){
				parentObj.find("span[name=textSpan1]").show();
			}else{
				parentObj.find("span[name=browserSpan]").show();
			}
			if(over_rulesrc==="3")
			{
				parentObj.find("[name=valuetype]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(33747,user.getLanguage()) %></option>");	//选择值
				parentObj.find("[name=valuetype]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>");	//变量
				parentObj.find("[name=valuetype]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");	//系统变量
				parentObj.find("span[name=browsertypeSpan1]").show();
			}			
		}else if(htmltype === "9"){
			parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
            parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
            parentObj.find("[name=compareoption1]").show();
            parentObj.find("[name=locationSpan]").show();
            
            if(over_rulesrc==="3"){
				parentObj.find("[name=rediusSpan]").show(); 
				parentObj.find("font[name='varName']").css("display",""); 
				parentObj.find("[name=valueTypeSpan1]").hide();         	
            }

		}
		/*
		if(type==="_sysvar")
		{
			parentObj.find("span[name=textSpan1]").hide();
			parentObj.find("span[name=browserSpan]").show();
			creatBrowservalueNew(parentObj,true,"","",type);
		}
		*/
	}

	function isSingle(type) {
		if (type==="57" || type==="168" || type==="142" || type==="17" || type==="18"
				|| type==="135" || type==="37" || type==="152" || type==="65" || type==="160" || type==="166"
				|| type==="170" || type==="194" || type==='162') {//多选

			return false;
		} else {
			return true;
		}
	}

	//清空 value span 中 browser 的值

	function clearAllElementvalue(parentObj)
	{
		parentObj.find("[name=browservaluespan]").find(".e8_showNameClass").remove();
		parentObj.find("[name=browservalue]").val("");
		parentObj.find("[name=textvalue1]").val("");
		parentObj.find("[name=textvalue2]").val("");
		parentObj.find("[name=checkboxvalue1]").removeAttr("checked");
		parentObj.find("[name=selectvalue1] option").remove();
		parentObj.find("[name=varName]").val("");
		parentObj.find("[name=browserLocate]").val("");
		parentObj.find("[name=browserLocatespan]").find("span").find("a").text("");
		parentObj.find("[name=redius]").val("2");
		if(over_rulesrc === "3")
			parentObj.find("[name=valuetype] option").remove();
	}
	
	//隐藏 value span中的Element
	function hideAllValueSpan(parentObj)
	{
		parentObj.find("span[name=compareSpan1]").hide();
		parentObj.find("span[name=browserSpan]").hide();
		parentObj.find("span[name=textSpan1]").hide();
		parentObj.find("span[name=selectSpan1]").hide();
		parentObj.find("span[name=checkSpan1]").hide();
		parentObj.find("span[name=compareSpan2]").hide();
		parentObj.find("span[name=textSpan2]").hide();
		parentObj.find("span[name=locationSpan]").hide();
		parentObj.find("font[name='varName']").hide();
		jQuery("#redius").val("2");
		jQuery("#meetCondition").val("2");
		//$("#redius").find("option[text='300米']").attr("selected",true);
		//$("#redius").find("option[text='300米']").attr("selected",true);
		if(over_rulesrc === "3")
			parentObj.find("span[name=browsertypeSpan1]").hide();
	}
	
	//（单/多）人力资源 安全级别和具体人员切换

	function setType4hrm(obj)
	{
		var parentObj = jQuery($(obj).closest("table").parent("div"));
		//移出再加入

		parentObj.find("[name=compareoption1] option").remove();
		hideAllValueSpan(parentObj);
		parentObj.find("select").selectbox("detach");
		parentObj.find("span[name=compareSpan1]").show();
		var type = parentObj.find("[name=browsertype]").val();
		if(jQuery(obj).val() === "1")
		{
			if(type==="1"){
				parentObj.find("[name=compareoption1]").append("<option value='7'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>");
            	parentObj.find("[name=compareoption1]").append("<option value='8'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
            }else{
            	parentObj.find("[name=compareoption1]").append("<option value='9'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>");
				parentObj.find("[name=compareoption1]").append("<option value='10'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
            }
			parentObj.find("span[name=browserSpan]").show();
			parentObj.find("[name=fieldtype]").val(type);

		}else
		{
			parentObj.find("[name=compareoption1]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='2'><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption1]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption1]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
           	parentObj.find("span[name=textSpan1]").show();
           	parentObj.find("[name=compareoption2] option").remove();
           	parentObj.find("[name=compareoption2]").append("<option value='1'><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption2]").append("<option value='2'><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption2]").append("<option value='3'><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option>");
			parentObj.find("[name=compareoption2]").append("<option value='4'><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption2]").append("<option value='5'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>");
           	parentObj.find("[name=compareoption2]").append("<option value='6'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
           	parentObj.find("span[name=compareSpan2]").show();
           	parentObj.find("span[name=textSpan2]").show();
           	parentObj.find("span[name=valueSpan2]").show();
           	parentObj.find("[name=fieldtype]").val("_level");
		}
		parentObj.find("select").selectbox("attach");
	}

	//value span 中 browservalue 获取URL
	function getBrowservalueUrl(obj)
	{
		var parentObj = jQuery(obj).closest("table").parent("div");
		var url = "";
		if(parentObj.find("[name=valuetype]")&&parentObj.find("[name=valuetype]").val()=="4")
		{
			return "/systeminfo/BrowserMain.jsp?url=/workflow/ruleDesign/systemVarBrowser.jsp";
		}
		var selectedOption = parentObj.find("[name=browsertype]").find("option:selected");
		var type = selectedOption.val();
		if ('161' == type) {
			var dbtype = parentObj.find("[name=dbtype]").val();
			var selectfiled =  parentObj.find("[name=selectfiled").val();
			var tmpids = parentObj.find("#browservalue").val();
			var dbtype = parentObj.find("[name=dbtype]").val();
			url += '/systeminfo/BrowserMain.jsp?url=/interface/MultiCommonBrowser.jsp?type=' + dbtype+'%26isreport=1';
			if(!!tmpids){
				url = url +"|"+selectfiled+ "&beanids=" + tmpids;
			}

		    return url;
		} else if ('162' == type) {
			var dbtype = parentObj.find("[name=dbtype]").val();
			return '/systeminfo/BrowserMain.jsp?url=/interface/CommonBrowser.jsp?type=' + dbtype+'%26isreport=1';
		}else if("226"==type||"227"==type){
			var dbtype = parentObj.find("[name=dbtype]").val();
			var selectfiled =  parentObj.find("[name=selectfiled").val();
			var urlTemp = $(selectedOption).attr("_url");
			var fromNode ="1";
			urlTemp+="?type="+dbtype+"|"+selectfiled+"&fromNode="+fromNode;
			return urlTemp;
		}
        //如果字段是多角色，则这里只能选单个角色qc175562
        if('65' ==  type){
           return "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
        }
		
		if (!!BROWSER_MAPPING[type]) {
			selectedOption = parentObj.find("[name=browsertype]").find("option[value='"+BROWSER_MAPPING[type]+"']");
		}
		var url = $(selectedOption).attr("_url");
		
		var dialogurl = url;
		var type1 = parseInt(type);
		if (type1 == 135) {
		    tmpids = parentObj.find("[name=browservalue]").val();
		    if (url.indexOf("?") > -1 && !(url.substring((url.length - 4), url.length).indexOf(".jsp") > -1)) {
		        dialogurl = url + "&projectids=" + tmpids;
		    } else {
		        dialogurl = url + "?projectids=" + tmpids;
		    }
		    //id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		    //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) { 
		    //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
		    //type1 = 167 是:分权单部门 与 部门合并  韩宝龙 2015-07-22 修改
		} else if (type1 == 4 || type1 == 164 || type1 == 167 || type1 == 169 || type1 == 170 || type1 == 194) {
		    tmpids = parentObj.find("[name=browservalue]").val();
		    if ((url.indexOf("%3F") > -1 || url.indexOf("?") > -1) && !(url.substring((url.length - 4), url.length).indexOf(".jsp") > -1)) {
		        dialogurl = url + "&selectedids=" + tmpids;
		    } else {
		        dialogurl = url + "?selectedids=" + tmpids;
		    }
			dialogurl += "&isruledesign=true";
		    //id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		} else if (type1 == 37) {
		    tmpids = parentObj.find("[name=browservalue]").val();
		    if (url.indexOf("?") > -1 && !(url.substring((url.length - 4), url.length).indexOf(".jsp") > -1)) {
		        dialogurl = url + "&documentids=" + tmpids;
		    } else {
		        dialogurl = url + "?documentids=" + tmpids;
		    }
		    //id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		} else if (type1 == 142) {
		    tmpids = parentObj.find("[name=browservalue]").val();
		    if (url.indexOf("?") > -1 && !(url.substring((url.length - 4), url.length).indexOf(".jsp") > -1)) {
		        dialogurl = url + "&receiveUnitIds=" + tmpids;
		    } else {
		        dialogurl = url + "?receiveUnitIds=" + tmpids;
		    }
		    //id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		} else if (type1 == 162) {
		    tmpids = parentObj.find("[name=browservalue]").val();
		
		    if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
		        url = url + "&beanids=" + tmpids;
		        url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		        dialogurl = url;
		        //id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
		    } else {
		        url = url + "|" + id + "&beanids=" + tmpids;
		        url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		        dialogurl = url;
		        //id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
		    }
		} else if (type1 == 256) {
		    tmpids = parentObj.find("[name=browservalue]").val();
		    //url = url + "_" + type1 + "&selectedids=" + tmpids;
		    //url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		    var zdydbtype = parentObj.find("[name=dbtype]").val();
		    url = url + "?type="+zdydbtype+"_257&selectedids=" + tmpids;
		    dialogurl = url;
		    //id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
		} else if (type1 == 257) {
		    tmpids = parentObj.find("[name=browservalue]").val();
		    //url = url + "_" + type1 + "&selectedids=" + tmpids;
		    //url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		    var zdydbtype = parentObj.find("[name=dbtype]").val();
		    url = url + "?type="+zdydbtype+"_256&selectedids=" + tmpids;
		    dialogurl = url;
		    //id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
		}else if (type1 == 87) {
			url = "/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutilMeetingRoomBrowser.jsp"
			tmpids = parentObj.find("[name=browservalue]").val();
		    if (url.indexOf("?") > -1 && !(url.substring((url.length - 4), url.length).indexOf(".jsp") > -1)) {
		        dialogurl = url + "&resourceids=" + tmpids;
		    } else {
		        dialogurl = url + "?resourceids=" + tmpids;
		    }
			dialogurl += "&isruledesign=true";		    
		} else if (type1 == 184) {
			url = "/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingRoomBrowser.jsp"
			tmpids = parentObj.find("[name=browservalue]").val();
		    if (url.indexOf("?") > -1 && !(url.substring((url.length - 4), url.length).indexOf(".jsp") > -1)) {
		        dialogurl = url + "&resourceids=" + tmpids;
		    } else {
		        dialogurl = url + "?resourceids=" + tmpids;
		    }
			dialogurl += "&isruledesign=true";		    
		}else {   //分权单人力，分权多人力，分权多部门 type分别为165,166，168 合并到else， 韩宝龙 2015-07-22 修改
		
		    tmpids = parentObj.find("[name=browservalue]").val();
		    if (url.indexOf("?") > -1 && !(url.substring((url.length - 4), url.length).indexOf(".jsp") > -1)) {
		        dialogurl = url + "&resourceids=" + tmpids;
		    } else {
		        dialogurl = url + "?resourceids=" + tmpids;
		    }
			dialogurl += "&isruledesign=true";
		}		
		
		
		return dialogurl;
	}

	var rulevarAry= [];
	//增加条件
	function addParam(fatherObj)
	{
		var parentObj = jQuery("#"+fatherObj);
		var selectfiled = parentObj.find("[name=selectfiled]").val();  // 字段类型：如单行文本框、移动交互
		if ($.trim(selectfiled) === "-1" || $.trim(selectfiled)==="") {
        	msg = nothaveFile+"!";
        	window.top.Dialog.alert(msg);
        	return;
        }
                
        var hiddenarea = getValue4Obj(parentObj);   //从标签中提取规则信息
        //console.log(hiddenarea);
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
				$("#mainExpression").append(hiddenElement);
			else
				$("#mainExpression").find("expressions[rotindex="+rotindex+"]").append(hiddenElement);
        }else
        {
        	 $("#mainBlock").append(item);
        	 $("#mainExpression").append(hiddenElement);
        }
        $("#mainBlock").show();
        if(over_rulesrc === "3")
        {
        	var row={value:"-1",label:selectfiled};
        	rulevarAry.push(row);
        	parentObj.find("[name=selectvalue1]").selectbox("detach");
       		parentObj.find("[name=selectvalue1]").append("<option value='"+rulevarAry[rulevarAry.length-1].value+"."+(rulevarAry.length-1)+"'>"+rulevarAry[rulevarAry.length-1].label+"</option>");
       		parentObj.find("[name=selectvalue1]").selectbox("attach");
        }
        _writeBackData('selectfiled', 1, {id:'',name:''});
        delFieldCallback();
	}
	
	//从parentObj中抽取Element 中的 value
	function getValue4Obj(parentObj)
	{
		//抽取值

       	var datafield = ""
       	var datafieldlabel = ""
       	var compareoption2 = "-1";	
       	var compareoptionlabel2 = "";
       	var type4hrm = "-1";
       	var textvalue2 = "";
       	var paramtype = "-1";
       	var valuetype = "-1";
       	var valuevarid = "-1";
       	var redius = "-1";
       	var nodeId = "-1";
       	var nodeName = "-1";
       	var meetCondition = "-1";
       	if(over_rulesrc==="3")
       	{
       		datafieldlabel = parentObj.find("[name=selectfiled]").val();
       		datafield = parentObj.find("[name=selectfileduuid]").val();
       		paramtype = parentObj.find("[name=paramtype]").val();
       		valuetype = parentObj.find("[name=valuetype]").val();
       		valuevarid = parentObj.find("[name=valuevarid]").val();
       	}else if(over_rulesrc==="1" || over_rulesrc==="2" || over_rulesrc==="4"||over_rulesrc==="5"||over_rulesrc==="6" ||over_rulesrc==="7" || over_rulesrc==="8")
       	{
       		datafield = parentObj.find("[name=selectfiled]").val();
       		datafieldlabel = parentObj.find("[name=selectfiledspan]").find("a").text();
       		compareoption2 = parentObj.find("[name=compareoption2]").val();	
        	compareoptionlabel2 = parentObj.find("[name=compareoption2]").find("option:selected").text();
        	type4hrm = parentObj.find("[name=multitype4hrmselect]").val();	//人力资源 选择具体人员或安全级别

        	textvalue2 = parentObj.find("[name=textvalue2]").val();
       	}
       	
       	
//       	var htmltype = ""; //大类型
//       	if(over_rulesrc==="3" && parentObj.find("[name=paramtype]").val()==="9"){ //规则管理中，选择位置字段
//       		htmltype = "9"; //大类型
//       	}else{
//       		htmltype = parentObj.find("[name=htmltype]").val(); //大类型
//       	}
       	var htmltype = parentObj.find("[name=htmltype]").val(); //大类型
       	var fieldtype = parentObj.find("[name=fieldtype]").val();	//小类型

       	var dbtype = parentObj.find("[name=dbtype]").val();//数据库类型

       	// 二元符号 值、文本

       	var compareoption1 = parentObj.find("[name=compareoption1]").val();	
        var compareoptionlabel1 = parentObj.find("[name=compareoption1]").find("option:selected").text();
        
        //value span 取值
        var browservalue = "";	//browser value
	    var browserspantext = "";
	    var browserspanlabel = "";
	    var browseranum = "";
		if(over_rulesrc === "3"){
			if(htmltype === "9"){
				browservalue = parentObj.find("[name=browserLocate]").val();	//browser value
		       	browseranum = parentObj.find("[name=browserLocatespan]").find("span").find("a").length;
		       	if(browseranum == 1)	//单选
		       	{
		       		browserspantext = parentObj.find("[name=browserLocatespan]").find("span").find("a").text();
		       		browserspanlabel = parentObj.find("[name=browserLocatespan]").find("span").find("a").text();
		       	}else if(browseranum>1){	//多选
			        parentObj.find("[name=browserLocatespan]").find("span").find("a").each(function(){
			        	browserspantext += jQuery(this).text() + "__";
			        	browserspanlabel += jQuery(this).text() + ",";
			        });	//browser text
			        browserspantext = browserspantext.substring(0,browserspantext.lastIndexOf('__'));
			        browserspanlabel = browserspanlabel.substring(0,browserspanlabel.lastIndexOf(','));
		        }
			}else{
				browservalue = parentObj.find("[name=browservalue]").val();	//browser value
		       	browseranum = parentObj.find("[name=browservaluespan]").find("span").find("a").length;
		       	if(browseranum == 1)	//单选
		       	{
		       		browserspantext = parentObj.find("[name=browservaluespan]").find("span").find("a").text();
		       		browserspanlabel = parentObj.find("[name=browservaluespan]").find("span").find("a").text();
		       	}else if(browseranum>1){	//多选
			        parentObj.find("[name=browservaluespan]").find("span").find("a").each(function(){
			        	browserspantext += jQuery(this).text() + "__";
			        	browserspanlabel += jQuery(this).text() + ",";
			        });	//browser text
			        browserspantext = browserspantext.substring(0,browserspantext.lastIndexOf('__'));
			        browserspanlabel = browserspanlabel.substring(0,browserspanlabel.lastIndexOf(','));
		        }			
			}

		}else{
	        browservalue = parentObj.find("[name=browservalue]").val();	//browser value
	       	browseranum = parentObj.find("[name=browservaluespan]").find("span").find("a").length;
	       	if(browseranum == 1 && htmltype != "9")	//单选 或者 对于位置字段只能单选
	       	{
	       		browserspantext = parentObj.find("[name=browservaluespan]").find("span").find("a").text();
	       		browserspanlabel = parentObj.find("[name=browservaluespan]").find("span").find("a").text();
	       	}else if(browseranum>1 && htmltype != "9"){	//多选
		        parentObj.find("[name=browservaluespan]").find("span").find("a").each(function(){
		        	browserspantext += jQuery(this).text() + "__";
		        	browserspanlabel += jQuery(this).text() + ",";
		        });	//browser text
		        browserspantext = browserspantext.substring(0,browserspantext.lastIndexOf('__'));
		        browserspanlabel = browserspanlabel.substring(0,browserspanlabel.lastIndexOf(','));
	        }
        }
        var textvalue1 = parentObj.find("[name=textvalue1]").val();
        var selectvalue1 = parentObj.find("[name=selectvalue1]").val();
        var selecttext1 = parentObj.find("[name=selectvalue1] option:selected").text();
        if(!!!selectvalue1) selectvalue1 = "-1";
        var checkboxvalue1 = parentObj.find("[name=checkboxvalue1]").val();
       	
       	var selectoptionjson;
        if(htmltype === "5")
        {
        	var selectval = "[";
        	parentObj.find("[name=selectvalue1] option").each(function(i){
        		if(!!$(this).val())
        			selectval +='{"label":"'+$(this).text()+'","value":"'+$(this).val()+'"}'; 
        		if(i<parentObj.find("[name=selectvalue1] option").length-1)selectval +=","
        	});
        	selectval+="]";
        	selectoptionjson = jQuery.parseJSON(selectval);
        }
        if(htmltype == "9"){
        	redius = parentObj.find("[name='redius']").val();
        	if(over_rulesrc!="3"){
	        	nodeId = parentObj.find("[name='nodes']").val();
	        	nodeName = parentObj.find("[name='nodes']").find("option:selected").text();
	        	meetCondition = parentObj.find("[name='meetCondition']").val(); 
	        	browservalue = parentObj.find("[name=browserLocate]").val();
	        	browserspantext = parentObj.find("[name=browserLocatespan]").find("span").children("a:first").text();
	       		browserspanlabel = parentObj.find("[name=browserLocatespan]").find("span").children("a:first").text();
        		//parentObj.find("[name=browservaluespan]").eq(1).remove();
        	}  
        	if(browserspanlabel!=null && browserspanlabel!=undefined && browserspanlabel!=""){
	        	textvalue1 = browserspanlabel;         	
        	}else{
        		redius = "-1";
        	}
        }
        //组装字符串 显示和后台所需
        var hiddenarea = {datafield:datafield,
        				datafieldlabel:datafieldlabel,
        				type4hrm:type4hrm,
        				htmltype:htmltype,
        				fieldtype:fieldtype,
        				compareoption1:compareoption1,
        				compareoptionlabel1:compareoptionlabel1,
        				compareoption2:compareoption2,
        				compareoptionlabel2:compareoptionlabel2,
        				browservalue:browservalue,
        				browserspantext:browserspantext,
        				browserspanlabel:browserspanlabel,
        				textvalue1:textvalue1,
        				selectvalue1:selectvalue1,
        				selecttext1:selecttext1,
        				checkboxvalue1:checkboxvalue1,
        				textvalue2:textvalue2,
        				paramtype:paramtype,
        				valuetype:valuetype,
        				dbtype:dbtype,
        				selectval:selectoptionjson,
        				valuevarid:valuevarid,
        				redius:redius,
        				nodeId:nodeId,
        				nodeName:nodeName,
        				meetCondition:meetCondition,
        				jingdu:jingdu,
        				weidu:weidu
        			};
        return hiddenarea;
	}
	
	//返回表达式显示文字

    var expressdescElement = function (inputele,udpateflag) {
    	var areaJson = jQuery.parseJSON(inputele.val());
        
        var displayspan = showDisplaySpan(areaJson)
        
        var expIndex = inputele.attr("expindex");
        
        if (!!!udpateflag) {
            expIndex = getExpIndex();
        }
        
        inputele.attr("expindex", expIndex);
        return "<span class='displayspan' key='" + expIndex + "' onclick='switchSelected(event, this)' ondblclick='switchEditMode(this);'>" + displayspan + "</span>"
    };
    
    //拼接条件显示 方法
    function showDisplaySpan(areaJson)
    {
    	var datafieldlabel = areaJson.datafieldlabel;
        var htmltype = areaJson.htmltype;
        var fieldtype = areaJson.fieldtype;
        var displayspan = datafieldlabel;
        if((htmltype==="1" && fieldtype==="1") || htmltype==="2")	//字符串

		{
			displayspan += " "+ areaJson.compareoptionlabel1 + " '" + areaJson.textvalue1 +"'";
		} else if((htmltype==="1" && fieldtype!="1") || (htmltype==="3" && (fieldtype==="2" || fieldtype==="19" || fieldtype==="_level")))	//数值 或 日期 或时间 ,选择人员的安全级别

		{
			if(fieldtype==="_level")
				displayspan += " " + levelstr;
			if (areaJson.textvalue1 != "")
				displayspan += " "+ areaJson.compareoptionlabel1 + " " + areaJson.textvalue1;
			if (areaJson.textvalue2 != "") {
				if (areaJson.textvalue1 != "") {
					displayspan += " "+ andstr;
				}
				displayspan += " " + areaJson.compareoptionlabel2 + " " + areaJson.textvalue2;
			}
		} else if(htmltype==="4")		//checkbox			
		{
			if(areaJson.checkboxvalue1==="1")
				displayspan += " "+ areaJson.compareoptionlabel1 + " '" + checkedstr +"'";
			else
				displayspan += " "+ areaJson.compareoptionlabel1 + " '" + notcheckedstr +"'";
		} else if(htmltype==="5")		//下拉框

		{
			displayspan += " "+ areaJson.compareoptionlabel1 + " '" + areaJson.selecttext1 +"'";
		} else if(htmltype==="3")
		{
			displayspan += " "+ areaJson.compareoptionlabel1 + " '" + areaJson.browserspanlabel +"'";
		}else if(htmltype==="9"){
			var rediusStr = "";			
			switch(areaJson.redius){
				case "1":
					rediusStr = "50" + "<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage()) + SystemEnv.getHtmlLabelName(125874,user.getLanguage())%>";
					break;
				case "2":
					rediusStr = "300" +  "<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage()) + SystemEnv.getHtmlLabelName(125874,user.getLanguage())%>";
					break;
				case "3":
					rediusStr = "500" + "<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage()) + SystemEnv.getHtmlLabelName(125874,user.getLanguage())%>";
					break;
				case "4":
					rediusStr = "1000" + "<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage()) + SystemEnv.getHtmlLabelName(125874,user.getLanguage())%>" ;
					break;
			}
			if(over_rulesrc !="3"){
				var meetConditionStr = "";
				switch(areaJson.meetCondition){
					case "1":
						meetConditionStr = "<%=SystemEnv.getHtmlLabelName(125878,user.getLanguage())%>" ;
						break;
					case "2":
						meetConditionStr = "<%=SystemEnv.getHtmlLabelName(125879,user.getLanguage())%>";
						break;							
				}			
				displayspan += " "+ areaJson.compareoptionlabel1 + " '" + areaJson.browserspanlabel +" "
				+rediusStr+"' ['" + areaJson.nodeName + "'<%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%> " + meetConditionStr + "]"; //节点
			}else{
				displayspan += " "+ areaJson.compareoptionlabel1 + " '" 
					+ areaJson.browserspanlabel +" " +rediusStr+"'";  
			}
			
									
		} 
		
		/*
		else if(fieldtype==="_sysvar")
			displayspan += " "+ areaJson.compareoptionlabel1 + " '" + areaJson.browserspanlabel +"'";
		*/
		//位置 类型的字段 是不需要判断是否是变量的
		if(htmltype!="9"){
			var valuetype = areaJson.valuetype;
			if(valuetype === "3") //当然 值是变量时
				displayspan = datafieldlabel + " "+ areaJson.compareoptionlabel1 + " '" + areaJson.textvalue1 + "' ";
			else if(valuetype ==="4") //系统变量
				displayspan = datafieldlabel + " "+ areaJson.compareoptionlabel1 + " '" + areaJson.browserspanlabel + "' ";
		}
		return displayspan;
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
		           		trgelement = $("expressions[rotindex=" + key + "]");
		           	}
		           	//如果只有两个，则删除关系
		           	var $parentdiv = $(this).parent().parent();
		           	var $trgelementParent = trgelement.parent();
		    		if ($(this).parent().parent().children(".relationItem").length == 2) {
		    		}
		    		$(this).parent().remove();
		    		
		    		trgelement.remove();
		    		
                    //如果只剩个，则删除左边的关系
                    if ($parentdiv.children(".relationItem").length == 1) {
                        if($parentdiv.children(".relationItem").children(".relationblock").length > 0){
	                        var relationItemHtml = $parentdiv.children(".relationItem").children(".relationblock").html();
	                        $parentdiv.html($(relationItemHtml));
                        }else{
                            var relationItemHtml = $parentdiv.children(".relationItem").html();
                            if($parentdiv.parent().attr("class").indexOf("relationItem") >= 0){
                                $parentdiv.parent().html($(relationItemHtml));
                            }
                        }
                    }
                    //删除保存用的html
                    if($trgelementParent.children("expressions").length == 1 && $trgelementParent.children("input[name=child]").length == 0){
                        var relationItemHtml = $trgelementParent.children("expressions").html();
                        var relationType = $trgelementParent.children("expressions").attr("relation");
                        $trgelementParent.html($(relationItemHtml));
                        $trgelementParent.attr("relation",relationType);
                    }else if($trgelementParent.attr("id") != "mainExpression" && $trgelementParent.attr("rotindex") != 1 && $trgelementParent.children("expressions").length == 0 && $trgelementParent.children("input[name=child]").length == 1){
                        var relationItemHtml = $trgelementParent.children("input[name=child]")[0].outerHTML;
                        $trgelementParent[0].outerHTML = relationItemHtml;
                    }
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
	}

	 //清空
    function onClean() {
    	var _doClean = function () {
    		$("#mainBlock").html("").css("display","none");
	    	$("#mainExpression").html("");
	    	$("#mainBlock").html("<div class='verticalblock' onmouseover='relatmouseover(this)' title='<%=SystemEnv.getHtmlLabelName(83945,user.getLanguage())%>' onmouseout='relatmouseout(this)' ondblclick='switchRelationEditMode(event,this)'>&nbsp;AND&nbsp;</div><div class='relationStyle outermoststyle' ><div class='relationStyleTop'></div><div class='relationStyleCenter'></div><div class='relationStyleBottom'></div></div>");
    	};
    	if (!!$("#mainExpression").html()) {
    		top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(84545,user.getLanguage())%>', function() {
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
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84546,user.getLanguage())%>");
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
           		trgelement = $("expressions[rotindex=" + key + "]");
           	}
            if (i == 0) {
            	var rlindex = getRlIndex();
				//合并后，显示的关系图
				displayBlock = $("#displayTemplate").children(".relationblock").clone();
				displayBlock.attr("key", rlindex);
				displayBlock.attr("title","<%=SystemEnv.getHtmlLabelName(83945,user.getLanguage())%>")
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

				expression = $("<expressions type='expressions' relation='" + relationship + "' rotindex='" + rlindex + "'></expressions>");
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
           	var trgelement = $("expressions[rotindex=" + key + "]"); 
           	
            children = checkboxarray[i].children(".relationItem");
            
            for (var j = 1; j < children.length; j++) {
            	var tktrgeldspelement = $(children[j]).children();
            	var tktrgelement = null;
	            var tky = tktrgeldspelement.attr("key");
	            
	           	if (tktrgeldspelement.is("span")) {
					tktrgelement = $("input[name=child][expindex=" + tky + "]");
	           	} else {
	           		tktrgelement = $("expressions[rotindex=" + tky + "]");
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
		//克隆完立即美化 整个过程应该不会闪

		$("#newBlockDiv").find("select").selectbox("attach");
        var areaJson = jQuery.parseJSON(encodejs(children.val()));
	    
		//*******展现形式  start **********
		var parentObj = editBlock;
		parentObj.find("select").selectbox("detach");
		parentObj.find("span[name=fieldspan]").find("img").hide();
		var htmltype = areaJson.htmltype;
		var type = areaJson.fieldtype;
		parentObj.find("[name=htmltype]").val(htmltype);
		parentObj.find("[name=fieldtype]").val(type);
		if(htmltype==="3" && (type==="1" || type==="17" || type==="_level"))
			parentObj.find("span[name=multitype4hrmspan]").show();
		else
			parentObj.find("span[name=multitype4hrmspan]").hide();
		//先隐藏所有的value span
		hideAllValueSpan(parentObj);
		//只有当checkbox 时 不显示比较span
		//if(htmltype != "4")
		parentObj.find("span[name=compareSpan1]").show();
		//当值是变量时，展现形式在赋值方法上有修改

		//showValueSpan(parentObj,htmltype,type);
		var addvaluetype = areaJson.valuetype;
		showValueSpanNew(parentObj,htmltype,type,"",addvaluetype);
		//********展现形式 end********
		
		//**********赋值 start ****************
	    setEditBlockValue(editBlock,areaJson);
	    //**********赋值 end ****************
	    parentObj.find("select").selectbox("attach");
	    parentObj.find("[name=editoperatorSpan]").show();
	    //隐藏span
	    $this.hide();
	    //clean fieldspan
		fillFieldSpan(editBlock.find("span[name='fieldspan']"), areaJson.datafield, areaJson.datafieldlabel, key);
	    $this.parent().append(editBlock);
	}
	
	//给双击后的条件 Element 赋值[不用判断，有值只管赋]
	function setEditBlockValue(parentObj,areaJson)
	{
		if(!!areaJson)
		{
			//清除value span中的值

			if(over_rulesrc==="1" || over_rulesrc==="2" || over_rulesrc==="4"||over_rulesrc==="5"||over_rulesrc==="6" || over_rulesrc==="7" || over_rulesrc==="8")
			{
				parentObj.find("[name=selectfiled]").val(areaJson.datafield);
				var _selectfiledspan = $("<span class='e8_showNameClass'></span>");
				var _selectfileda = $("<a href=#"+areaJson.datafield+" onclick='return false;' title='"+areaJson.datafieldlabel+"' style='max-width: 135px;'>"+areaJson.datafieldlabel+"</a>");
				_selectfiledspan.append(_selectfileda);
				parentObj.find("[name=selectfiledspan]").find(".e8_showNameClass").remove();
				parentObj.find("[name=selectfiledspan]").append(_selectfiledspan);
			}else if(over_rulesrc==="3")
			{
				parentObj.find("[name=selectfiled]").val(areaJson.datafieldlabel);
				parentObj.find("[name=selectfileduuid]").val(areaJson.datafield);
				parentObj.find("[name=paramtype]").val(areaJson.paramtype);
				parentObj.find("[name=valuetype]").val(areaJson.valuetype);
				parentObj.find("[name=valuevarid]").val(areaJson.valuevarid);
			}
			parentObj.find("[name=htmltype]").val(areaJson.htmltype);
			parentObj.find("[name=fieldtype]").val(areaJson.fieldtype);
			parentObj.find("[name=dbtype]").val(areaJson.dbtype);
			parentObj.find("[name=multitype4hrmselect]").val(areaJson.type4hrm);
			parentObj.find("[name=compareoption1]").val(areaJson.compareoption1);
			parentObj.find("[name=compareoption2]").val(areaJson.compareoption2);
            parentObj.find("[name=textvalue1]").val(decodejs(areaJson.textvalue1));
			parentObj.find("[name=textvalue2]").val(areaJson.textvalue2);
			if(!!areaJson.checkboxvalue1)
				parentObj.find("[name=checkboxvalue1]").attr("checked",true);
			if(areaJson.htmltype === "3")
				jQuery("#browsertype").val(areaJson.fieldtype);
			else if(areaJson.htmltype === "5")
			{
				for(var jl in areaJson.selectval)
				{
					if(typeof(areaJson.selectval[jl].value) != "undefined"){
						parentObj.find("select[name=selectvalue1]").append("<option "+(areaJson.selectvalue1===areaJson.selectval[jl].value?"selected":"") +" value='"+areaJson.selectval[jl].value+"'>"+areaJson.selectval[jl].label+"</option>");
					}	
				}
			}else if(areaJson.htmltype === "4")
			{
				parentObj.find("select[name=checkboxvalue1]").val(areaJson.checkboxvalue1);
				
			}else if(areaJson.htmltype === "9"){
				parentObj.find("select[name=redius]").val(areaJson.redius);
				if(over_rulesrc === "3"){
					jingdu = areaJson.jingdu;
					weidu  = areaJson.weidu;
					parentObj.find("[name=browserLocate]").val(areaJson.jingdu +"#"+ areaJson.weidu);  //浏览框隐藏域的值
					var _browserLocatespan = $("<span class='e8_showNameClass'></span>");
					var _browserLocatea = $("<a href=#"+ " onclick='return false;' title='"+areaJson.textvalue1+"' style='max-width: 100px;'>"+areaJson.textvalue1+"</a>");
						//		"<span id='" + areaJson.jingdu + "' class='e8_delClass' onclick='del(this)' style='visibility: hidden; opacity: 1;'>x</span>");
					_browserLocatespan.append(_browserLocatea);
					parentObj.find("[name=browserLocatespan]").find(".e8_showNameClass").remove();
					parentObj.find("[name=browserLocatespan]").append(_browserLocatespan);

				}else{
					parentObj.find("select[name=nodes]").empty();			
					<%for(String node : nodesOptions){%>
						parentObj.find("select[name=nodes]").append("<%=node%>");
					<%}%>
					parentObj.find("select[name=nodes]").val(areaJson.nodeId);
					parentObj.find("select[name=meetCondition]").val(areaJson.meetCondition);
					
					jingdu = areaJson.jingdu;
					weidu  = areaJson.weidu;
					parentObj.find("[name=browserLocate]").val(areaJson.jingdu +"#"+ areaJson.weidu);  //浏览框隐藏域的值
					var _browserLocatespan = $("<span class='e8_showNameClass'></span>");
					var _browserLocatea = $("<a href=#"+ " onclick='return false;' title='"+areaJson.textvalue1+"' style='max-width: 100px;'>"+areaJson.textvalue1+"</a>");
							//	"<span id='" + areaJson.jingdu + "' class='e8_delClass' onclick='del(this)' style='visibility: hidden; opacity: 1;'>x</span>");
					_browserLocatespan.append(_browserLocatea);
					parentObj.find("[name=browserLocatespan]").find(".e8_showNameClass").remove();
					parentObj.find("[name=browserLocatespan]").append(_browserLocatespan);

				}
			}
			if(areaJson.browservalue)
			{
				creatBrowservalue(parentObj,isSingle(areaJson.fieldtype),areaJson.browservalue,areaJson.browserspantext,areaJson.fieldtype);
			}
		}
	}
	
	/*function del(obj){
		jQuery(obj).prev().html("");
	}*/
	
	function creatBrowservalueNew(parentObj,isSingle,browservalue,browserspanvalue,type)
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
		//parentObj.find("select[name=compareoption1]").selectbox("detach");
    	//parentObj.find("select[name=compareoption1]").selectbox("attach");
		parentObj.find("[name=browserSpan]").append(oDiv);
		var parentid = $(parentObj).attr("id");
		if(type != 161 && type != 162){
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
		}else{
			var dbtype = parentObj.find("[name=dbtype]").val();
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
				completeUrl:'/data.jsp?isreport=1&type='+type+'&fielddbtype='+dbtype,
				browserUrl:"",
				hasAdd:false,
				width:'150px'
			});
		}
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
    	
    	if(type == 278){
    		isSingle = true;
    	}
    	parentObj.find("[name=browserSpan]").empty();
		var oDiv = document.createElement("div");
		//parentObj.find("select[name=compareoption1]").selectbox("detach");
    	parentObj.find("select[name=compareoption1]").selectbox("attach");
		parentObj.find("[name=browserSpan]").append(oDiv);
		var parentid = $(parentObj).attr("id");
		if(type != 161 && type != 162){
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
		}else{
			var dbtype = parentObj.find("[name=dbtype]").val();
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
				completeUrl:'/data.jsp?isreport=1&type='+type+'&fielddbtype='+dbtype,
				browserUrl:"",
				hasAdd:false,
				width:'150px'
			});
		}
		
    }

 	function fillFieldSpan(parentObj, browservalue, browserspanvalue, key)
    {      
    browserspanvalue = decodejs(browserspanvalue);
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

	//取消编辑
	function cancelEdit(target) {
		var editBlock = $(target).closest("table").parent("div");
		if (!!!editBlock) return ;
		var displaySpan = editBlock.parent().children("span");
		editBlock.remove();
	 	displaySpan.show();
	}
	
	//双击条件后 确定修改的操作

	function confirmEdit(target)
	{
		var editBlock = jQuery(target).closest("table").parent("div");
		if(!!!editBlock) return;
		var displaySpan = editBlock.parent().children("span");
    	var key = displaySpan.attr("key");
    	var children = $("input[name=child][expindex=" + key + "]");
    	if (!!!children[0]) return;
    	
    	//从parentObj中的Element 中抽取值 转换成 并返回json
    	var hiddenarea = getValue4Obj(editBlock);
    	if (!hiddenarea['datafield'] && !hiddenarea['datafieldlabel']) {
    		msg = nothaveFile+"!";
        	window.top.Dialog.alert(msg);
    		return;
    	}else if (hiddenarea['htmltype']=="9" && (hiddenarea['datafieldlabel']==null || hiddenarea['datafieldlabel']=="")){
    		msg = nothaveFile+"!";
        	window.top.Dialog.alert(msg);
    		return;
    	}
    	var hiddenareastr = JSON.stringify(hiddenarea)
        children.val(decodejs(hiddenareastr));
    	var displayspan = showDisplaySpan(hiddenarea);
        displaySpan.html(decodejs(displayspan));
    	editBlock.remove();
 		displaySpan.show();
    	
	}
	
	//双击 and/or 更改关系
	function switchRelationEditMode(e,target) {
		var e = e || window.event;
		var parent = $(target).parent();
		var key = parent.attr("key"); 
		var expselement = $("expressions[rotindex=" + key + "]");
		//if (!!!expselement[0]) return;
		$(target).css("left", "-18px");
		var relation = parseInt(expselement.attr("relation"));
		$(target).html("<select name='tempRelationEle' onblur='cancelRelationEdit(this);' onchange='confirmRelationEdit(this, " + key + ")'><option value='0' " + (relation==0?" selected ":"") + ">OR</option><option value='1'" + (relation==1?" selected ":"") + ">AND</option></select>");
		$(target).find("[name=tempRelationEle]")[0].focus();
	}
	
	function confirmRelationEdit(target, key) {
		var expselement = $("expressions[rotindex=" + key + "]");
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
	
	//保存
	function onSave()
	{
		if (!!!$("#mainExpression").html()) {
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>');
			return;
		}
		
		enableAllmenu();
		var allexprblock = $("#expressionBlock").children("expressions");
    	
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
			expression = "<%=SystemEnv.getHtmlLabelName(84304,user.getLanguage())%>";
		} else {
			expression = "(" + expression + ")";
		}
        expression = decodejs(expression);
    	$.ajax({
			type: "post",
		    url: "/workflow/ruleDesign/ruleOperation.jsp?_" + new Date().getTime() + "=1&",
		    data: {
		    	rulexml: result, 
		    	ruleid: jQuery("#ruleid").val(),
		    	rulesrc:jQuery("#rulesrc").val(),
		    	formid: jQuery("#formid").val(),
		    	linkid: jQuery("#linkid").val(),
		    	isbill: jQuery("#isbill").val(),
		    	rownum: jQuery("#rownum").val(),
		    	wfid  : '<%=wfid%>',
		    	condit:	expression
		    	},
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    	displayAllmenu();
		    } , 
		    success:function (data, textStatus) {
		    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83551,user.getLanguage())%>");
                var _data = jQuery.parseJSON(encodejs(data));
		    	setRuleDesign(_data.ruleRelationship);
		    	setConditionElement(_data.name,_data.id,_data.src,_data.ruleids,_data.condits,_data.maplistids);
		    } 
	    });
	}
	
	//获取expressions元素的json
    var getExpItemsXmlString = function (expressions) {
        //表达式关系

        var relationship = parseInt(expressions.attr("relation"));
        var result = "<expressions relation='" + relationship + "'>";
        
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
        
        result += "</expressions>";
        return result;
    };
    
    //单项表达式的json字符串

    var getExpItemXmlString = function (expItem) {
	    var children = expItem;
	    if (!!!children[0]) return "";
        var areaJson = jQuery.parseJSON(encodejs(children.val()));
	   	if(!!!areaJson.exitemid) areaJson.exitemid = -1;
        var result = "<expression id='" + areaJson.exitemid + "' datafield='" + areaJson.datafield + "' datafieldlabel='" + encodejs(areaJson.datafieldlabel) + "' ";
        result += "typehrm='" + areaJson.type4hrm + "' ";
        result += "htmltype='" + areaJson.htmltype + "' ";
        result += "fieldtype='" + areaJson.fieldtype + "' ";
        result += "dbtype='" + areaJson.dbtype + "' ";
        result += "compareoption1='" + areaJson.compareoption1 + "' ";
        result += "compareoption2='" + areaJson.compareoption2 + "' ";
        result += "browservalue='" + areaJson.browservalue + "' ";
        result += "browserspantext='" + areaJson.browserspantext + "' ";
        result += "browserspanlabel='" + areaJson.browserspanlabel + "' ";
        result += "textvalue1='" + encodejs(areaJson.textvalue1) + "' ";
        result += "selectvalue1='" + areaJson.selectvalue1 + "' ";
        result += "checkboxvalue1='" + areaJson.checkboxvalue1 + "' ";
        result += "textvalue2='" + areaJson.textvalue2 + "' ";
        result += "paramtype='" + areaJson.paramtype + "' ";
        result += "valuetype='" + areaJson.valuetype + "' ";
       	result += "redius='" + areaJson.redius + "' ";
       	result += "nodeId='" + areaJson.nodeId + "' ";
       	result += "meetCondition='" + areaJson.meetCondition + "' ";
       	result += "jingdu='" + areaJson.jingdu + "' ";
       	result += "weidu='" + areaJson.weidu + "' ";
        result += ">";
        result += "</expression>";
        return result;
    };
    
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
   		}else if(data == "9"){
   		   	parentObj.find("[name=htmltype]").val("9");
			parentObj.find("[name=fieldtype]").val("2");
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
    	if(paramtypedata != "9"){
    		parentObj.find("span[name=textSpan1]").show();
    	}
    	parentObj.find("span[name=selectSpan1]").hide();
    	parentObj.find("[name=textvalue1]").val("");
    	parentObj.find("[name=browservalue]").val("");
    	parentObj.find("span[name=browservaluespan]").html("");
    	if(paramtypedata==="3" && (data==="1" || data==="4"))
    	{
    		parentObj.find("span[name=browserSpan]").show();
    		parentObj.find("span[name=textSpan1]").hide();
    		/*
    		if (data == "4") {
    			parentObj.find("[name=fieldtype]").val("_sysvar");
    		} else {
    			parentObj.find("[name=fieldtype]").val(parentObj.find("[name=browsertype]").val());
    		}
    		*/
    		parentObj.find("[name=fieldtype]").val(parentObj.find("[name=browsertype]").val());
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
    	//var ajaxUrl = "/workflow/ruleDesign/getCompleteUrl.jsp?formid="+formid+"&isbill="+isbill+"&fshowname="+fshowname;
		return "";
    }
    function decodejs(str){
        return str.replace(/\\\\/g,"\\");
    }
    function encodejs(str){
        str =  str.replace(/\r\n/g,' ');
        str =  str.replace(/\n/g,' ');
        str =  str.replace(/\t/g,' ');
        str =  str.replace(/\\\\/g,'\\');
        return str.replace(/\\/g,'\\\\');
    }
    
   /* function onSave1()
	{
		$.ajax({
			type: "post",
		    url: "/workflow/ruleDesign/ruleOperation.jsp?_" + new Date().getTime() + "=1&",
		    data: {
		    	testrule:"1"
		    	},
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success:function (data, textStatus) {
		    	alert("保存成功！");
		    	window.location.reload();
		    } 
	    });
	}*/
</script>
    </head>
    <body>
    	<input type="hidden" id="ruleid" name="ruleid" value="<%=ruleid %>">
    	<input type="hidden" id="rulesrc" name="rulesrc" value="<%=rulesrc %>" >
    	<input type="hidden" id="formid" name="formid" value="<%=formid %>" >
    	<input type="hidden" id="isbill" name="isbill" value="<%=isbill %>" >
    	<input type="hidden" id="linkid" name="linkid" value="<%=linkid %>" >
    	<input type="hidden" id="rownum" name="rownum" value="<%=rownum %>" >
    	<input type="hidden" id="expindex" value="<%=RuleBusiness.getExpIndex() %>">
		<input type="hidden" id="rlindex" value="<%=RuleBusiness.getRlindex() %>">
    	
		<div id="header">
			<div class="headblock" style="width:100%;background:#f0f2f5;">
        		<div id="newBlockDiv" style="padding-left:20px;padding-bottom:2px;">
        			<%if(rulesrc.equals("1") || rulesrc.equals("2") || rulesrc.equals("4")||rulesrc.equals("5")||rulesrc.equals("6") ||rulesrc.equals("7") || rulesrc.equals("8")){  %>
        			<table style="border-collapse: separate;border-spacing:0px;">
        				<tr style="overflow:auto;">
        					<td>
			        			<span name="fieldspan" style="padding-right:2px;">
			        				<!-- 字段类型：如单行文本框、移动交互 -->
			        				<brow:browser name="selectfiled" viewType="0" hasBrowser="true" hasAdd="false"  
			        					browserUrl="" getBrowserUrlFn="getFieldUrl"
			                  			isMustInput="1" isSingle="true" hasInput="false"
			                  			_callback ="callbackMeth"
			                  			afterDelCallback="delFieldCallback"
			                  			completeUrl="javascript:getcompleteurl($('#formid').val(),$('#isbill').val(),$('#selectfiled__').val())"  width="150px" browserValue="-1" browserSpanValue='<%=SystemEnv.getHtmlLabelName(82098,user.getLanguage())%>' />
			                  			<img style="padding-top:4px;" src="/images/BacoError_wev8.gif" align="absMiddle">
			        			</span>
			        			<input type="hidden" name="htmltype" >
			        			<input type="hidden" name="fieldtype" >
			        			<input type="hidden" name="dbtype" >
        					</td>
        					<td>
			        			<span name="multitype4hrmspan" style="display:none;padding-right:2px;">
			        				<select name="multitype4hrmselect" style="width:65px;" onchange="setType4hrm(this)">
			        					<option value="1"><%=SystemEnv.getHtmlLabelName(33568,user.getLanguage()) %></option> 	<!-- 具体人员 -->
			        					<option value="2"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage()) %></option> 	<!-- 安全级别 -->
			        				</select>
			        			</span>
        					</td>
        					<td>
			        			<span name="compareSpan1" style="display:none;padding-right:2px;">
			        				<!-- 数值类型/日期/时间：大于、大于或等于、小于、小于或等于、等于、不等于 -->
			        				<!-- 浏览框(单)：属于、不属于 -->
			        				<!-- 浏览框(多)：包含、不包含 -->
			        				<!-- 字符串：等于、不等于、包含、不包含 -->
			        				<!-- 下拉框：等于、不等于 -->
									<select name="compareoption1" style="width: 95px;" >
										<option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>		<!-- 大于 -->
										<option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option> 		<!-- 大于或等于 -->
										<option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option> 		<!-- 小于 -->
										<option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option> 		<!-- 小于或等于 -->
			                        	<option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option> 		<!-- 等于 -->
			                        	<option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 		<!-- 不等于 -->
			                        	<option value="7"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>			<!-- 属于 -->
			                        	<option value="8"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>		<!-- 不属于 -->
			                        	<option value="9"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>			<!-- 包含 -->
			                        	<option value="10"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>		<!-- 不包含 -->
			                        	<option value="11"><%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %></option>		<!-- 属于（含下级） -->
			                        	<option value="12"><%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %></option>		<!-- 不属于（含下级） -->
			                    	</select>
			        			</span>
        					</td>
        					<td>
			        			<span name="valueSpan1" style="letter-spacing: 0px;">
			        				<select name="browsertype" notBeauty=true style="display:none">
									<%while(browserComInfo.next()){%>
							 			<%
							  			String url = browserComInfo.getBrowserurl(); // 浏览按钮弹出页面的url
							    		String linkurl = browserComInfo.getLinkurl(); // 浏览值点击的时候链接的url
										if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
											continue;
										}
										if("160".equals(browserComInfo.getBrowserid())){
											url= "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
											linkurl="/hrm/resource/HrmResource.jsp?id=";
										}
							  		%>
							  			<option value="<%=browserComInfo.getBrowserid()%>" _url="<%=url %>" _linkurl="<%=linkurl %>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
							  		<%
							  		}
							  		%>
							        </select>
			                    	<span id="locationSpan" name="locationSpan" style="display:none;">	  
			                		&nbsp;<span id="locatebrowserSpan" name="locatebrowserSpan" style="display:'';"> 
			                				<!-- 位置浏览框 -->		                    		
					                    	<brow:browser  name="browserLocate" viewType="0" hasBrowser="true" hasAdd="false" 
					                 				getBrowserUrlFn="getLocationUrl" getBrowserUrlFnParams="this"
					                  				isMustInput="1" isSingle="true" hasInput="true" 
					                  				browserDialogWidth="900px" _callback="locationBrowerCallback" afterDelCallback="locationDelCallback"
					                  				completeUrl="javascript:getajaxurl('title')" width="120px" browserValue="" browserSpanValue='' />
			                    		</span>			                    		
			                    		<wea:item><%=SystemEnv.getHtmlLabelName(125673,user.getLanguage())%></wea:item>   <!-- 识别半径 -->
			                    		<select id="redius" name="redius" style="width:54px;">
			                    			<option value="1">50<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                    			<option value="2" selected>300<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                    			<option value="3">500<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                    			<option value="4">1000<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                    		</select>
			                    		&nbsp;<wea:item><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage()) %></wea:item>
			                    		<select id="nodes" name="nodes" style="width:50px;"></select>
			                    		<select id="meetCondition" name="meetCondition" style="width:70px;float:right;" >			                    		    
			                    			<option value="2" selected><%=SystemEnv.getHtmlLabelName(125879,user.getLanguage())%></option> <!-- 全部满足 -->
			                    			<option value="1"><%=SystemEnv.getHtmlLabelName(125878,user.getLanguage())%></option>  <!-- 任意满足 -->
			                    		</select>			                    		
			                    	</span>
			                    	
			                		<span id="browserSpan" name="browserSpan" style="display:none;">
				                    	<brow:browser name="browservalue" viewType="0" hasBrowser="true" hasAdd="false" 
				                 				getBrowserUrlFn="getBrowservalueUrl" getBrowserUrlFnParams="this"
				                  				isMustInput="1" isSingle="true" hasInput="true"
				                  				completeUrl="javascript:getajaxurl('title')" width="150px" browserValue="" browserSpanValue="" />
			                    	</span>
			                    	
			                    	<span name="textSpan1" style="display:none;padding-left:0px;padding-right:2px;">
			                    		<input type="text" name="textvalue1" style="width:100px">
			                    	</span>
			                    	<span name="selectSpan1" style="display:none;">
			                    		<select name="selectvalue1" style="width:60px"></select>
			                    	</span>
			                    	<span name="checkSpan1" style="display:none;">
			                    		<select name="checkboxvalue1" style="width:60px">
			                    			<option value="1"><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage()) %></option>
			                    			<option value="0"><%=SystemEnv.getHtmlLabelName(22906,user.getLanguage()) %></option>
			                    		</select>
			                    	</span>
			        			</span>
		        			</td>
		        			<td>
			        			<span name="compareSpan2" style="display:none;padding-right:2px;">
			        				<!-- 数值类型/日期/时间：大于、大于或等于、小于、小于或等于、等于、不等于 -->
			        				<!-- 浏览框(单)：属于、不属于 -->
			        				<!-- 浏览框(多)：包含、不包含 -->
			        				<!-- 字符串：等于、不等于、包含、不包含 -->
			        				<!-- 下拉框：等于、不等于 -->
									<select name="compareoption2" style="width: 80px;" >
										<option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>		<!-- 大于 -->
										<option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option> 		<!-- 大于或等于 -->
										<option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option> 		<!-- 小于 -->
										<option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option> 		<!-- 小于或等于 -->
			                        	<option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option> 		<!-- 等于 -->
			                        	<option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 		<!-- 不等于 -->
			                        	<option value="7"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>			<!-- 属于 -->
			                        	<option value="8"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>		<!-- 不属于 -->
			                        	<option value="9"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>			<!-- 包含 -->
			                        	<option value="10"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>		<!-- 不包含 -->
			                    	</select>
			        			</span>
			        		</td>
			        		<td>
			        			<span name="valueSpan2">
			                    	<span name="textSpan2" style="display:none;padding-left:0px;">
			                    		<input type="text" name="textvalue2" style="width:100px">
			                    	</span>
			        			</span>
        					</td>
        					<td>
        						<span name="editoperatorSpan" style="display:none;" class="editspan">
        							<input type="button" class="operbtn operbtn_ok" name="editOk" id="editOk" title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" onclick="confirmEdit(this)" value=" ">
	                    			<input type="button" class="operbtn operbtn_cancel" name="editCancel" id="editCancel" title="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" onclick="cancelEdit(this)" value=" ">
        						</span>
        					</td>
        				</tr>
        			</table>
        			<%}else{%>
        			<table style="border-collapse: separate;border-spacing:0px;">
        				<TR>
                    		<td>
			                    <select id="paramtype" name="paramtype" onchange="paramChange(this)" style="float:left;width: 70px;">
			                        <option value="0"><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) %></option>
			                        <option value="1"><%=SystemEnv.getHtmlLabelName(696,user.getLanguage()) %></option>
			                        <option value="2"><%=SystemEnv.getHtmlLabelName(697,user.getLanguage()) %></option>
			                        <option value="3"><%=SystemEnv.getHtmlLabelName(32306,user.getLanguage()) %></option>
			                        <option value="9"><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage()) %></option>
			                    </select>
			                    <input type="hidden" name="htmltype" >
			        			<input type="hidden" name="fieldtype" >
                    		</td>
                    		<td>
			               		<span name="browsertypeSpan1" style="letter-spacing: 0px;display:none;">
				               		<select name="browsertype" style="width:100px;" onchange="browsertypeChange(this)">
										<%while(browserComInfo.next()){%>
								 			<%
								  			String url = browserComInfo.getBrowserurl(); // 浏览按钮弹出页面的url
								    		String linkurl = browserComInfo.getLinkurl(); // 浏览值点击的时候链接的url
								 			if(url.equals("") || url.lastIndexOf("=") == (url.length() - 1) || "".equals(browserComInfo.getBrowsertablename())){
								 				continue;
											}
											if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
												continue;
											}
											if("160".equals(browserComInfo.getBrowserid())){
												url= "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
												linkurl="/hrm/resource/HrmResource.jsp?id=";
											}
								  		%>
								  			<option value="<%=browserComInfo.getBrowserid()%>" _url="<%=url %>" _linkurl="<%=linkurl %>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
								  		<%
								  		}
								  		%>
							        </select>
								</span>
			               	</td> 
                    		
                    		<td>
			                    <!-- 变量 -->
	                    		<font name="varName" style="display:none;"><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%> </font> <!-- 变量名称 -->
			                    <input type="text" name="selectfiled" id="selectfiled" style="width:120px;">
			                    <input type="hidden" name="selectfileduuid" id="selectfileduuid" value="-1">
			               	</td>
			               	           	
			               	<td>
			               		<span name="compareSpan1" style="padding-right:2px;">
				                    <select name="compareoption1" id="compareoption1" style="float:left;width: 115px;">
				                       	<option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>		<!-- 大于 -->
										<option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option> 		<!-- 大于或等于 -->
										<option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option> 		<!-- 小于 -->
										<option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option> 		<!-- 小于或等于 -->
			                        	<option value="5" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option> 		<!-- 等于 -->
			                        	<option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 		<!-- 不等于 -->
			                        	<option value="7"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>			<!-- 属于 -->
			                        	<option value="8"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>		<!-- 不属于 -->
			                        	<option value="9"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>			<!-- 包含 -->
			                        	<option value="10"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>		<!-- 不包含 -->
			                        	<option value="11"><%=SystemEnv.getHtmlLabelName(82763,user.getLanguage()) %></option>		<!-- 属于（含下级） -->
			                        	<option value="12"><%=SystemEnv.getHtmlLabelName(82764,user.getLanguage()) %></option>		<!-- 不属于（含下级） -->
				                    </select>
				            	</span>
			            	</td> 
			            	<td>
			            		<span name="valueTypeSpan1" style="letter-spacing: 0px;" >
				                    <select id="valuetype" name="valuetype" style="float:left;width: 80px;" onchange="valuetypeChange(this)">
				                        <option value="1"><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option> 	<!-- 输入值 -->
				                        <option value="2"><%=SystemEnv.getHtmlLabelName(33747,user.getLanguage()) %></option>	<!-- 选择值 -->
						                <option value="3"><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>	<!-- 变量 -->
						                <option value="4"><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>	<!-- 系统变量 -->
				                    </select>
			                    </span>
			               	</td>
			               	
			               	<td>
			        			<span name="valueSpan1" style="letter-spacing: 0px;">
			                    	<span id="browserSpan" name="browserSpan" style="display:none;">
				                    	<brow:browser name="browservalue" viewType="0" hasBrowser="true" hasAdd="false" 
				                 				getBrowserUrlFn="getBrowservalueUrl" getBrowserUrlFnParams="this"
				                  				isMustInput="1" isSingle="true" hasInput="true"
				                  				completeUrl="javascript:getajaxurl('title')"  width="150px" browserValue="" browserSpanValue="" />
			                    	</span>
			                    	<span name="textSpan1" style="padding-left:0px;padding-right:2px;">
			                    		<input type="text" name="textvalue1" style="width:150px">
			                    		<input type="hidden" name="valuevarid" value="-1" />
			                    	</span>
			                    	<span name="selectSpan1" style="display:none;">
			                    		<select name="selectvalue1" style="width:60px"></select>
			                    	</span>
			                    	<span name="checkSpan1" style="display:none;">
			                    		<select name="checkboxvalue1" style="width:60px">
			                    			<option value="1"><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage()) %></option>
			                    			<option value="0"><%=SystemEnv.getHtmlLabelName(22906,user.getLanguage()) %></option>
			                    		</select>
			                    	</span>
			        			</span>
		        			</td>
		        			
		        			<td>
		        				<span name="rediusSpan" id="rediusSpan" style="display:none">
        							<!-- 位置浏览框 -->		                    		
			                    	&nbsp;<brow:browser  name="browserLocate" viewType="0" hasBrowser="true" hasAdd="false" 
			                 				getBrowserUrlFn="getLocationUrl" getBrowserUrlFnParams="this"
			                  				isMustInput="1" isSingle="true" hasInput="true" 
			                  				browserDialogWidth="900px" _callback="locationBrowerCallback" afterDelCallback="locationDelCallback"
			                  				completeUrl="javascript:getajaxurl('title')" width="150px" browserValue="" browserSpanValue='' />
				                    		
				       				&nbsp;<wea:item><%=SystemEnv.getHtmlLabelName(125673,user.getLanguage())%></wea:item>   <!-- 识别半径 -->
			                   		<select id="redius" name="redius" style="width:54px;">
			                   			<option value="1">50<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                   			<option value="2" selected>300<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                   			<option value="3">500<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                   			<option value="4">1000<%=SystemEnv.getHtmlLabelName(125675,user.getLanguage())%></option>
			                   		</select>
		                   		</span>
		        			</td>
		        			<td>
			        			<span name="compareSpan2" style="display:none;padding-right:2px;">
			        				<!-- 数值类型/日期/时间：大于、大于或等于、小于、小于或等于、等于、不等于 -->
			        				<!-- 浏览框(单)：属于、不属于 -->
			        				<!-- 浏览框(多)：包含、不包含 -->
			        				<!-- 字符串：等于、不等于、包含、不包含 -->
			        				<!-- 下拉框：等于、不等于 -->
									<select name="compareoption2" style="width: 80px;" >
										<option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage()) %></option>		<!-- 大于 -->
										<option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage()) %></option> 		<!-- 大于或等于 -->
										<option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage()) %></option> 		<!-- 小于 -->
										<option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage()) %></option> 		<!-- 小于或等于 -->
			                        	<option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option> 		<!-- 等于 -->
			                        	<option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option> 		<!-- 不等于 -->
			                        	<option value="7"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option>			<!-- 属于 -->
			                        	<option value="8"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>		<!-- 不属于 -->
			                        	<option value="9"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>			<!-- 包含 -->
			                        	<option value="10"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>		<!-- 不包含 -->
			                    	</select>
			        			</span>
			        		</td>
			        		<td>
			        			<span name="valueSpan2">
			                    	<span name="textSpan2" style="display:none;padding-left:0px;">
			                    		<input type="text" name="textvalue2" style="width:100px">
			                    	</span>
			        			</span>
        					</td>
        					<td>
        						<span name="editoperatorSpan" style="display:none;" class="editspan">
        							<input type="button" class="operbtn operbtn_ok" name="editOk" id="editOk" title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" onclick="confirmEdit(this)" value=" ">
	                    			<input type="button" class="operbtn operbtn_cancel" name="editCancel" id="editCancel" title="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" onclick="cancelEdit(this)" value=" ">
        						</span>
        					</td>
        				</TR>
        			</table>
        			<%} %>
        		</div>
        		<!-- 分割线 -->
        		<div style="width:100%;background:#DADADA;height:1px!important;"></div>
        		<div style="height:30px;padding-right:20px;padding-top:5px;padding-bottom:3px;">
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
        	</div>
        		
        	<!-- 分割线 -->
        	<div style="width:100%;background:#c4e6e1;height:3px!important;">
        	</div>
        	
		</div>
		
		<div id="middle">
			<div id="ruleContent">
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
						<div class="verticalblock" onmouseover="relatmouseover(this)" title="<%=SystemEnv.getHtmlLabelName(83945,user.getLanguage())%>" onmouseout="relatmouseout(this)" ondblclick="switchRelationEditMode(event,this)">&nbsp;AND&nbsp;</div>
						<div class="relationStyle outermoststyle" >
							<div class="relationStyleTop"></div>
							<div class="relationStyleCenter"></div>
							<div class="relationStyleBottom"></div>
						</div>
						
					</div>
					<expressions type='expressions'  relation='1' id="mainExpression" rotindex="-9"></expressions>
					<%
					} %>
                </div>
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
			<input type="button" id="ruledescBtn_btn" class="operbtn operbtn_up" name="paramdelete" style="" title="<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%>" value=" " onclick="showDesc();">
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
</html>
