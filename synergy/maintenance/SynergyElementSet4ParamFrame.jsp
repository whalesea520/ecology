
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<jsp:useBean id="sm" class="weaver.synergy.SynergyManage" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    int eid = Util.getIntValue(request.getParameter("eid"), 0);
    String ebaseid = Util.null2String(request.getParameter("ebaseid"));
    String wfid = Util.null2String(request.getParameter("wfid"));
    String from = Util.null2String(request.getParameter("from"));
    String tabid = Util.null2String(request.getParameter("tabid"));
    String sbaseid = Util.null2String(request.getParameter("sbaseid"));
    int saddpage = Util.getIntValue(request.getParameter("saddpage"));
    String[] ruleInfoArray=null;
    if(from.equalsIgnoreCase("wfex")){
    	ruleInfoArray = sm.getRuleHtmlByRuleId(eid,wfid,tabid,user);
    }else{
    	ruleInfoArray = sm.getRuleHtmlByRuleId(eid,user);
   }
   	//System.out.println("eid:"+eid+"ebaseid:"+ebaseid+"sbaseid:"+sbaseid);
%>
<html>
    <head>

        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
		
        <script type="text/javascript" src="/synergy/js/ParamDesign_wev8.js"></script>
        <script type="text/javascript" src="/synergy/js/browser_wev8.js"></script>
        <link rel="stylesheet" type="text/css" href="/workflow/ruleDesign/css/ruleDesign_wev8.css">
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		<style type="text/css">
		    body{
		        margin: 0px;
		    }
			#middle {
				position: absolute!important;
				top: 70px!important;
				height: auto!important;
				position: relative;
				height: 100%;
				bottom: 40px;
				width: 100%;
				overflow: auto;
			}
			
			#ruledesc {
				position: absolute;
				bottom: 0px;
				background: #F6F6F6;
				padding: 5px;
				width: 100%;
				border-top: 1px solid #c6c6c6;
			}
			
			#ruledescBtn {
				position: absolute;
				bottom: 5px;
				left: 20px;
			}
			
			.editBlockClass {
				display: inline-block!important;
				height: 32px;
				border: 1px solid #c6c6c6;
			}
		</style>
        <script type="text/javascript">
    //间距28
    //按钮16
        $(function () {
            initParamSetPanel($("#ruleContent"));
        });
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
	var descisshow = false;
		function showDesc() {
			if (!descisshow) {
			var desc = expressionsToString($("#mainExpression"));
			if (desc == null || desc == "") {
				desc = "<%=SystemEnv.getHtmlLabelName(84304,user.getLanguage()) %>";
			} else {
				desc = "(" + desc + ")";
			}
				$("#ruledesc").html(desc);
				$("#ruledesc").show();
				var hgt = $("#ruledesc").height();
				$("#ruledescBtn_btn").removeClass("operbtn_up");
				$("#ruledescBtn_btn").addClass("operbtn_down");
				$("#ruledescBtn").css("bottom", hgt + 10 + 5);
			} else {
				$("#ruledesc").hide();
				$("#ruledescBtn_btn").removeClass("operbtn_down");
				$("#ruledescBtn_btn").addClass("operbtn_up");
				$("#ruledescBtn").css("bottom", 5);
			}
			descisshow = !descisshow;
		}
		
		function getajaxurl(){
			var selectedOption = $("#browsertype").find("option:selected");
			var typeId = $(selectedOption).val();
			var url = "";
			if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
			   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
				url = "/data.jsp?type=" + typeId;			
			}else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
				url = "/data.jsp";
			}
        	return url;
		}
		
		function pdfclick(pid,plabel,ptype)
		{
			rejson = window.showModalDialog("/synergy/browser/SynergyParamBrowserContent.jsp?ebaseid=<%=ebaseid%>&sbaseid=<%=sbaseid%>&wfid=<%=wfid%>");
			if(rejson){
				if(rejson.id != "")
				{
					$("#"+pid).val(rejson.id);
					$("#"+plabel).val(rejson.name);
					$("#"+ptype).val(rejson.ptype);
				}else
				{
					$("#"+plabel).text("");
					$("#"+plabel).val("");
					$("#"+ptype).val("");
				}
			}
		}
		
		
		function saveSynergyParam() {
			var dialog =  parent.parent.getDialog(parent);
    		var allexprblock = $("#expressionBlock").children("expressions");
    		var result = "";
    	
    		allexprblock.each(function (i, ele) {
				var expsChildrens = $("#mainExpression");
				if (!!expsChildrens[0]) {
					result += getExpItemsXmlString(expsChildrens);
				}
   			});
    	
    		result = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" + result;
    		//return result;
    		dialog.callbackfun(result);
    	}
    	
    	 //获取expressions元素的json
    	function getExpItemsXmlString(expressions) {
        //表达式关系
        	var relationship = parseInt(expressions.attr("relation"));
        	var result = "<expressions relation=\"" + relationship + "\">";
        
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
		}
    	
    	function getExpItemXmlString(expItem) {
		    var children = expItem;
		    if (!!!children[0]) return "";
		    var datatemp = children.val().split("-;-");
		    var datasetfieldinfo = datatemp[0].split(weaverSplit);
		    var filtertype = datatemp[1];
		    var datatype = datatemp[2];
		    var datavalue = datatemp[3];
		    var wffiled = datatemp[4];
		    
		    //变量来源、变量id、变量名
		    var datafieldSource = datasetfieldinfo[0];
		    var datafieldID = datasetfieldinfo[1];
		    var datafield = datasetfieldinfo[2];
		    
		    var browserType = "";
		    var valuevarid = "";
			var valueVariableID = "";
			if (!!datatype && datatype.indexOf(weaverSplit) != -1) {
				var datatypearray = datatype.split(weaverSplit);
				datatype = datatypearray[0];
		        browserType = datatypearray[1];
		        valuetype= datatypearray[2];
		        if (valuetype == "2") {
		        	valueVariableID = browserType;
		        }
		    }
		    //alert(valueVariableID);
		    var sysid = "";
		    var formid = "";
		    var isbill = "";
		    if(!!wffiled && wffiled.indexOf(weaverSplit) != -1)
		    {
		    	var wffiledarray = wffiled.split(weaverSplit);
		    	sysid = wffiledarray[0];
		    	formid = wffiledarray[1];
		    	isbill = wffiledarray[2];
		    }else
		    	sysid = wffiled;
		    var datavaluejson = null;
		    
		    if (!!datavalue && datavalue.indexOf(weaverSplit) != -1) {
		        datavaluejson = {ids: datavalue.split(weaverSplit)[0], names:datavalue.split(weaverSplit)[1]};
		    }
		    
			var result = "<expression id=\"" + datafieldSource + "\" variableID=\"" + datafieldID + "\" variableName=\"" + datafield + "\" ";
	        result += "type=\"" + datatype + "\" ";
	        result += "browsertype=\"" + browserType + "\" ";
	        
	        result += "relation=\"" + filtertype + "\" ";
	        result += "valueType=\"" + valuetype + "\" ";
	        result += "valueVariableID=\"" + valueVariableID + "\" ";
	        
	        if (!!datavaluejson) {
	        	result += "value=\"" + datavaluejson.ids + "\" ";
	        	result += "valueName=\"" + datavaluejson.names + "\" ";
	        } else {
	        	result += "value=\"" + datavalue + "\" ";
	        }
	        result += "sysid=\"" + sysid + "\" ";
	        if(sysid === "1")
	        {
	        	result += "formid=\"" + formid + "\" ";
	        	result += "isbill=\"" + isbill + "\" ";
        	}
	        result += ">";
	        result += "</expression>";
	        
	        return result;
    	}
    	function getBrowserJson(event,datas)
		{
			if(datas.id)
			{
				var weaverSplit = "||~WEAVERSPLIT~||";
				var pfs = datas.pfiled.split(weaverSplit);
				var _pname = $("#pname").val(pfs[0]);
				var _ptype = $("#ptype").val(pfs[1]);
				var _pbrowid = $("#pbrowid").val(pfs[2]);
				var _psysid = $("#psysid").val(pfs[4]);
				if(_psysid.val() === "1")
				{
					$("#pformid").val(pfs[5]);
					$("#pisbill").val(pfs[6]);
				}
				setPublicBrow(_pbrowid.val(),_ptype.val(),pfs[3],_psysid.val());
			}
		}
		function setPublicBrow(browserid,ptype,psolo,sysid)
		{
			$("#compareoption").find("option").remove();
			$("#compareoption").selectbox("detach");
			$("#valuetype").find("option").remove();
			$("#valuetype").selectbox("detach");
			if(ptype === "1" || ptype === "2")
			{
				//单行文本、多行文本
				$("#compareoption").append("<option value='4'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option><option value='5'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option><option value='6'><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option><option value='7'><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>");
				
				$("#valuetype").append("<option value=\"0\"><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>");
				jQuery("#valuetype").selectbox();
				//字符串
				$("#paramvalue").show();
				$("#paramselect").hide();
				$("#paramvalue").val("");
				$("#browserSpan").hide();
			}
			else if(ptype === "3"||ptype === "6")
			{
				//浏览框
				$("#compareoption").append("<option value='8'><%=SystemEnv.getHtmlLabelName(353,user.getLanguage()) %></option><option value='9'><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage()) %></option>");
				$("#valuetype").append("<option value=\"2\"><%=SystemEnv.getHtmlLabelName(28249,user.getLanguage()) %></option><option value=\"3\"><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");
				$("#paramvalue").hide();
				$("#browserSpan").show();
				$("#browsertype").find("option[value="+browserid+"]").attr("selected",true);
				clearSltValue($("#selectids"), $("#selectidsspan"));
				$("#paramselect").hide();
			}else if(ptype === "4")
			{
				//Check框
			}else if(ptype === "5")
			{
				//选择框
				$("#compareoption").append("<option value='4'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option><option value='5'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
				$("#valuetype").append("<option value=\"4\"><%=SystemEnv.getHtmlLabelName(26367,user.getLanguage()) %></option>");
				$("#paramvalue").hide();
				$("#browserSpan").hide();
				if(psolo != "undefined")
				{
					var sevalues = psolo.split("+")[0];
					var selabels = psolo.split("+")[1];
					var seval = sevalues.split(",");
					var selbl = selabels.split("<br>");
					$("#paramselect").find("option").remove();
					
					for(var i=0;i<seval.length;i++)
						$("#paramselect").append("<option value="+seval[i]+">"+selbl[i]+"</option>");
				}
				$("#paramselect").show();
			}
			if(sysid === "1")
				$("#valuetype").append("<option value=\"5\"><%=SystemEnv.getHtmlLabelName(84317,user.getLanguage()) %></option>");
			$("#valuetype").selectbox("attach");
			$("#compareoption").selectbox("attach");
		}
		
		function getEditBrowserJson(event,datas)
		{
			if(datas.id)
			{
				var weaverSplit = "||~WEAVERSPLIT~||";
				var pfs = datas.pfiled.split(weaverSplit);
				var editBlock = $(event.target.parentElement).parents(".editBlockClass");
				var _pname = editBlock.find("input[name=epname]").val(pfs[0]);
				var _ptype = editBlock.find("input[name=eptype]").val(pfs[1]);
				var _pbrowid = editBlock.find("input[name =epbrowid").val(pfs[2]);
				var _psysid = editBlock.find("input[name =epsysid").val(pfs[4]);
				if(_psysid.val() === "1")
				{
					editBlock.find("input[name =epformid").val(pfs[5]);
					editBlock.find("input[name =episbill").val(pfs[6]);
				}
				setEditPublicBrow(editBlock,_pbrowid.val(),_ptype.val(),pfs[3],pfs[4]);
			}
		}
		function onClose(){
			var dialog =  parent.parent.getDialog(parent);
			dialog.callbackfun();
		}
        </script>
    </head>
    <body>
    	<input type="hidden" id="eid" name="eid" value="<%=eid %>">
    	<input type="hidden" id="wfid" name="wfid" value="<%=wfid %>">
		<input type="hidden" id="sbaseid" name="sbaseid" value="<%=sbaseid %>">
		<input type="hidden" id="ebaseid" name="ebaseid" value="<%=ebaseid %>">
    	<input type="hidden" id="expindex" value="<%=sm.getExpIndex() %>">
		<input type="hidden" id="rlindex" value="<%=sm.getRlindex() %>">
    	
		<div id="header" style="display:block;">
			<div class="headblock" style="display:block;width:100%;background:#f0f2f5;padding-top:5px;padding-bottom:5px;">
        		<div style="height:60px;">
        		<%
        			String stype = Util.null2String(request.getParameter("stype"));
        			String spagetype = Util.null2String(request.getParameter("spagetype"));
        			String furl = "/systeminfo/BrowserMain.jsp?url=/synergy/browser/SynergyParamBrowserContent.jsp?ebaseid="+ebaseid+"&sbaseid="+sbaseid+"&stype="+stype+"&spagetype="+spagetype+"&saddpage="+saddpage+"&wfid="+wfid; %>
        			<div style="height:26px;margin-top:2px;float:left;width:680px;padding-left:10px" >
        				<span style="margin-right:5px;">
	        			<brow:browser name="paramdatafield" viewType="0" hasBrowser="true" hasAdd="false" 
	                  			isMustInput="1" isSingle="true" hasInput="true"
	                  			completeUrl="" browserUrl='<%=furl %>'
	                  			width="250px" browserValue="-1" browserSpanValue='<%=SystemEnv.getHtmlLabelName(84282,user.getLanguage()) %>' _callback="getBrowserJson"/>
	                  	</span>
	                  	<input type=hidden name=ptype id=ptype >
	                  	<input type=hidden name=pname id=pname >
	                  	<input type=hidden name=pbrowid id=pbrowid >
	                  	<input type=hidden name=psysid id=psysid >
	                  	<input type=hidden name=pformid id=pformid >
	                  	<input type=hidden name=pisbill id=pisbill >
	        			<!-- 是否为自定义变量 -->
	        			<select name="compareoption" id="compareoption" style="width:80px;margin-left:10px;">
	                        <option value="4"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>
	                        <option value="5"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>
	                        <option value="6"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>
	                        <option value="7"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>
	                    </select>
	                    
	                    <select id="browsertype" name="browsertype" style="display:none;" notBeauty=true>
                        <%
                        
				  		IntegratedSapUtil integratedSapUtil = new IntegratedSapUtil();
				  		BrowserComInfo browserComInfo = new BrowserComInfo();
				  		String IsOpetype = integratedSapUtil.getIsOpenEcology70Sap();
				  		//System.out.println("==========" + browserComInfo.get);
				  		while(browserComInfo.next()){%>
			  			<%
				  			String url = browserComInfo.getBrowserurl(); // 浏览按钮弹出页面的url
		      				String linkurl = browserComInfo.getLinkurl(); // 浏览值点击的时候链接的url
			  				if(url.equals("") || url.lastIndexOf("=") == (url.length() - 1) || "".equals(browserComInfo.getBrowsertablename())){
			  					 continue;
			  				 }
			  				 if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
			  				 	continue;
			  				 }
				  		%>
				  		<option value="<%=browserComInfo.getBrowserid()%>" _url="<%=url %>" _linkurl="<%=linkurl %>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
				  		<%
				  		}
				  		%>
                    </select>
	                    
	                    <select id="valuetype" name="valuetype" style="width:80px;margin-left:10px;">
	                        <option value="0"><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>
			                <option value="2"><%=SystemEnv.getHtmlLabelName(28249,user.getLanguage()) %></option>
			                <option value="3"><%=SystemEnv.getHtmlLabelName(84284,user.getLanguage()) %></option>
			                <option value="4"><%=SystemEnv.getHtmlLabelName(26367,user.getLanguage()) %></option>
			                <option value="5"><%=SystemEnv.getHtmlLabelName(84317,user.getLanguage()) %></option>
	                    </select>
	                    
	                    <input id="paramvalue" name="paramvalue" style="border: #e7e7e7 1px solid;">
	                    <span id="browserSpan" name="browserSpan" style="display:none;float:right;">
	                    	<brow:browser name="selectids" viewType="0" hasBrowser="true" hasAdd="false" 
	                  			isMustInput="1" isSingle="true" hasInput="true"
	                  			browserOnClick="onShowBrowser('selectids','','','17', 0, document.getElementById('browsertype'), document.getElementById('valuetype'))"
	                  			completeUrl="javascript:getajaxurl();" 
	                  			width="203px" browserValue="" browserSpanValue=""/>
                 		</span>
                 		<select id="paramselect" name="paramselect" style="width:105px;height:26px;display:none;">
                 		</select>
        			</div>
                    
                    
                    <span style="display:inline-block;width:100%;background:#e1e4e9;height:1px;position:relative;top:-10px">
                    </span>
                    <div style="position:relative;top:-10px;padding-left:10px">
                    <input type="button" class="operbtn operbtn_add" name="paramadd" id="paramadd" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" value=" ">
                    <span style="display:inline-block;width:10px"></span>
                    <input type="button" class="operbtn operbtn_del" name="paramdelete" id="paramdelete" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>" value=" ">
                    <span style="display:inline-block;width:100px"></span>
                    <input type="button" class="operbtn operbtn_joinor" name="addorrelation" id="addorrelation" title="<%=SystemEnv.getHtmlLabelName(84319,user.getLanguage()) %>" value=" ">
                    <span style="display:inline-block;width:10px"></span>
                    <input type="button" class="operbtn operbtn_joinand" name="addandrelation" id="addandrelation" title="<%=SystemEnv.getHtmlLabelName(84320,user.getLanguage()) %>" value=" ">
                    <span style="display:inline-block;width:10px"></span>
                    <input type="button" class="operbtn operbtn_spit" name="rembracket" id="rembracket" title="<%=SystemEnv.getHtmlLabelName(84321,user.getLanguage()) %>" value=" ">
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
                	<!-- 
                    <table id="paramtable" style="width: 100%;"></table>
                    -->
                    <%
                    if (ruleInfoArray[0].length() > 0) {
                    %>
                    	<%=ruleInfoArray[0]%>
                    	<%=ruleInfoArray[1]%>
                    <%
                    } else {
                    %>
	                <div id="mainBlock" class="relationblock" style="display:none;" key="-9">
						<div class="verticalblock" ondblclick="switchRelationEditMode(this)">&nbsp;AND&nbsp;</div>
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
		<div id="ruledesc" >
		</div>
		<div id="ruledescBtn">
			<input type="button" id="ruledescBtn_btn" class="operbtn operbtn_up" name="paramdelete" style="" title="<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage()) %>" value=" " onclick="showDesc();">
		</div>
        <div id="displayTemplate" style="display:none;">
        	<div class="relationblock displayspan" onclick="switchSelected(event, this)">
				<div class="verticalblock" ondblclick="switchRelationEditMode(this);"></div>
				<div class="relationStyle" >
					<div class="relationStyleTop"></div>
					<div class="relationStyleCenter"></div>
					<div class="relationStyleBottom"></div>
				</div>
			</div>
        </div>
		  <!-- 模板 -->
        <div id="editBlockTemplate" style="display:none;">
        	<div style="height:26px;margin-top:4px;float:left;display:inline-block;width:450px;" >
        		<span style="margin-right:5px;float:left;">
       			<brow:browser name="eparamdatafield" viewType="0" hasBrowser="true" hasAdd="false" 
                 			isMustInput="1" isSingle="true" hasInput="true"
                 			completeUrl="" browserUrl='<%=furl %>' idKey="id" nameKey="name"
                 			width="100px" browserValue="-1" browserSpanValue='<%=SystemEnv.getHtmlLabelName(84282,user.getLanguage()) %>' _callback="getEditBrowserJson"/>
                 			</span>
                 	<input type=hidden name=eptype id=eptype >
                 	<input type=hidden name=epname id=epname >
                 	<input type=hidden name=epbrowid id=epbrowid >
                 	<input type=hidden name=epsysid id=epsysid >
                 	<input type=hidden name=epformid id=epformid >
	                <input type=hidden name=episbill id=episbill >
       			<!-- 是否为自定义变量 -->
       			<select name="ecompareoption" id="ecompareoption"  notBeauty=true  style="width:100px;margin-left:5px;">
                       <option value="4"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option>
                       <option value="5"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>
                       <option value="6"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage()) %></option>
                       <option value="7"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage()) %></option>
                   </select>
                   
                   <select id="ebrowsertype" name="ebrowsertype"  notBeauty=true style="display:none;">
                      <%
                      
                      browserComInfo.setToFirstrow();
		  		//System.out.println("==========" + browserComInfo.get);
		  		while(browserComInfo.next()){%>
	  			<%
		  			String url = browserComInfo.getBrowserurl(); // 浏览按钮弹出页面的url
      				String linkurl = browserComInfo.getLinkurl(); // 浏览值点击的时候链接的url
	  				if(url.equals("") || url.lastIndexOf("=") == (url.length() - 1) || "".equals(browserComInfo.getBrowsertablename())){
	  					 continue;
	  				 }
	  				 if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
	  				 	continue;
	  				 }
		  		%>
		  		<option value="<%=browserComInfo.getBrowserid()%>" _url="<%=url %>" _linkurl="<%=linkurl %>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
		  		<%
		  		}
		  		%>
                  </select>
                   
                   <select id="evaluetype" name="evaluetype" notBeauty=true style="width:100px;margin-left:5px;">
                       <option value="0"><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>
	                <option value="2"><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>
	                <option value="3"><%=SystemEnv.getHtmlLabelName(84284,user.getLanguage()) %></option>
                   </select>
                   
                   <input id="eparamvalue" name="eparamvalue" style="width:100px;float:none;border: #e7e7e7 1px solid;">
                   <span id="ebrowserSpan" name="ebrowserSpan" style="display:none;margin-right:5px;float:right;">
                   <brow:browser name="eselectids" viewType="0" hasBrowser="true" hasAdd="false" 
                 			isMustInput="1" isSingle="true" hasInput="true"
                 			browserOnClick="onShowBrowser('eselectids','','','17', 0, document.getElementById('ebrowsertype'), document.getElementById('evaluetype'))"
                 			completeUrl="javascript:getajaxurl();" 
                 			width="115px" browserValue="-1" browserSpanValue="1"/>
               		</span>
               		<select id="eparamselect" name="eparamselect"  notBeauty=true style="width:105px;height:26px;display:none;float:right;">
                 		</select>
                 	
      			</div>
      			<span>
               		<input type="button" class="operbtn2 operbtn_ok" title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" value=" " onclick="confirmEdit(this);">
            		<input type="button" class="operbtn2 operbtn_cancel" title="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" value=" " onclick="cancelEdit(this);">
            		</span>
        </div>
        <div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align:center;buttom:0px">
		     <input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"  class="zd_btn_cancle" onclick="saveSynergyParam();"/>
		     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="onClose();"/>
		</div>
    </body>
</html>
