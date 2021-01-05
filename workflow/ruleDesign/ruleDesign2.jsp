
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    int ruleid = Util.getIntValue(request.getParameter("ruleid"), 0);
    
    RuleBusiness rulebs = new RuleBusiness();
    String[] ruleInfoArray = RuleBusiness.getRuleHtmlByRuleId(ruleid);
%>
<html>
    <head>
        <base href="<%=basePath%>">
		<META http-equiv="X-UA-Compatible" content="IE=8" > </META>
        <title>rule-based design</title>

        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
		<%@ include file="/systeminfo/init_wev8.jsp" %>
        <script type="text/javascript" src="/workflow/ruleDesign/js/jquery-1.8.3.min_wev8.js"></script>
        <script type="text/javascript" src="/workflow/ruleDesign/js/ruleDesign_wev8.js"></script>
        <script type="text/javascript" src="/workflow/ruleDesign/js/browser_wev8.js"></script>
        <script type="text/javascript" src="/wui/common/jquery/plugin/customSelect/jquery.customSelect_wev8.js"></script>
		
        <link rel="stylesheet" type="text/css" href="/workflow/ruleDesign/css/ruleDesign_wev8.css">
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<link rel="Stylesheet" type="text/css" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" />
		
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		
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
		
		
		
		//$('select').customSelect();
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
		
		function getajaxurl() {
			return "/browserData.jsp?formid=" + $("#formid").val() + "&isbill=" + $("#isbill").val();
		}
        </script>
    </head>
    <body>
    	<input type="hidden" id="ruleid" name="ruleid" value="<%=ruleid %>">
    	<input type="hidden" id="expindex" value="<%=RuleBusiness.getExpIndex() %>">
		<input type="hidden" id="rlindex" value="<%=RuleBusiness.getRlindex() %>">
    	
		<div id="header">
			<div class="headblock" style="width:100%;background:#f0f2f5;padding-top:20px;padding-bottom:20px;">
        		<div style="height:30px;padding-left:20px;">
        			<!-- 是否为自定义变量 -->
        			<select id="variabletype" name="variabletype">
                        <option value="0"><%=SystemEnv.getHtmlLabelName(129393, user.getLanguage())%></option>
                        <option value="1"><%=SystemEnv.getHtmlLabelName(21740, user.getLanguage())%></option>
                    </select>
                    
                    <select id="paramtype" name="paramtype">
                        <option value="0"><%=SystemEnv.getHtmlLabelName(27903, user.getLanguage())%></option>
                        <option value="1"><%=SystemEnv.getHtmlLabelName(129394, user.getLanguage())%></option>
                        <option value="2"><%=SystemEnv.getHtmlLabelName(15203, user.getLanguage())%></option>
                        <option value="3"><%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%></option>
                    </select>
                    
                    <select id="browsertype" name="browsertype" style="display:none;" onchange="clearSltValue('selectids', 'selectidsspan');">
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
                    
                    <input type="hidden" name="formid" id="formid" value="-59">
                    <input type="hidden" name="isbill" id="isbill" value="1">
                    <brow:browser name="paramdatafield" viewType="0" hasBrowser="true" hasAdd="false" 
                    browserOnClick="" isMustInput="1" isSingle="true" hasInput="true"
                    completeUrl="javascript:getajaxurl()" onPropertyChange="javascript:alert(1);"/>
                    <!-- 变量 -->
                    <input type="text" name="paramdatafield" id="paramdatafield">
                    <select name="compareoption" id="compareoption">
                        <option value="4"><%=SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
                        <option value="5"><%=SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
                        <option value="6"><%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%></option>
                        <option value="7"><%=SystemEnv.getHtmlLabelName(15507, user.getLanguage())%></option>
                    </select>
                    
                    <select id="valuetype" name="valuetype">
                        <option value="0"><%=SystemEnv.getHtmlLabelName(33746, user.getLanguage())%></option>
		                <option value="2"><%=SystemEnv.getHtmlLabelName(33748, user.getLanguage())%></option>
		                <option value="3"><%=SystemEnv.getHtmlLabelName(84284, user.getLanguage())%></option>
                    </select>
                    
                    <input type="text" id="paramvalue" name="paramvalue" >
                    <span id="browserSpan" name="browserSpan" style="display:none;">
	                    <button type="button" class=browser onClick="onShowBrowser('selectids','','','17', 0, document.getElementById('browsertype'), document.getElementById('valuetype'))"></button>
	                    <span id="selectidsspan" name="selectidsspan"></span>
	                    <input id="selectids" name="selectids" type="hidden" value="">
                    </span>
                    
                    <span style="display:inline-block;width:40px">
                    </span>
                    <span style="display:inline-block;width:1px;background:#e1e4e9;height:70px;position:absolute;top:0px;">
                    </span>
                    <span style="display:inline-block;width:40px">
                    </span>
                    <input type="button" class="operbtn operbtn_add" name="paramadd" id="paramadd" title="<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage())%>" value=" ">
                    <span style="display:inline-block;width:16px"></span>
                    <input type="button" class="operbtn operbtn_del" name="paramdelete" id="paramdelete" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" value=" ">
                    <span style="display:inline-block;width:16px"></span>
                    <input type="button" class="operbtn operbtn_joinor" name="addorrelation" id="addorrelation" title="<%=SystemEnv.getHtmlLabelName(84319,user.getLanguage())%>" value=" ">
                    <span style="display:inline-block;width:16px"></span>
                    <input type="button" class="operbtn operbtn_joinand" name="addandrelation" id="addandrelation" title="<%=SystemEnv.getHtmlLabelName(84320,user.getLanguage())%>" value=" ">
                    <span style="display:inline-block;width:16px"></span>
                    <input type="button" class="operbtn operbtn_spit" name="rembracket" id="rembracket" title="<%=SystemEnv.getHtmlLabelName(84321,user.getLanguage())%>" value=" ">
        		</div>
        	</div>
        	<!-- 分割线 -->
        	<div style="width:100%;background:#c4e6e1;height:3px!important;display:inline-block;">
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
			
		<div id="footer">
			<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="position:static;">
	          <table width="100%">
			      <tr><td style="text-align:center;" colspan="3" id="jmodaloptcontent">
			          <input type="button" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" class="zd_btn_submit" id="savebtn">
			          <input type="button" value="<%=SystemEnv.getHtmlLabelName(15504,user.getLanguage())%>" class="zd_btn_cancle" id="btncancel">
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
        	<select name="variabletype">
                <option value="0"><%=SystemEnv.getHtmlLabelName(129393, user.getLanguage())%></option>
                <option value="1"><%=SystemEnv.getHtmlLabelName(33749, user.getLanguage())%></option>
            </select>
            <!-- 变量 -->
            <input type="text" name="paramdatafield" id="paramdatafield">
            
            <select name="paramtype">
                <option value="0"><%=SystemEnv.getHtmlLabelName(27903, user.getLanguage())%></option>
                <option value="1"><%=SystemEnv.getHtmlLabelName(129394, user.getLanguage())%></option>
                <option value="2"><%=SystemEnv.getHtmlLabelName(15203, user.getLanguage())%></option>
                <option value="3"><%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%></option>
            </select>
            
            
            <select name="browsertype" style="display:none;" onchange="clearSltValue('eselectids', 'eselectidsspan');">
                <%
                browserComInfo.setToFirstrow();
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
            
            <select name="compareoption">
                <option value="4"><%=SystemEnv.getHtmlLabelName(327, user.getLanguage())%></option>
                <option value="5"><%=SystemEnv.getHtmlLabelName(15506, user.getLanguage())%></option>
                <option value="6"><%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%></option>
                <option value="7"><%=SystemEnv.getHtmlLabelName(15507, user.getLanguage())%></option>
            </select>
            <!-- 0：输入值，1：选择值 2：变量，3：系统参数（系统提供，如Manager） -->
            <select name="valuetype">
                <option value="0"><%=SystemEnv.getHtmlLabelName(33746, user.getLanguage())%></option>
                <option value="2"><%=SystemEnv.getHtmlLabelName(33748, user.getLanguage())%></option>
                <option value="3"><%=SystemEnv.getHtmlLabelName(84284, user.getLanguage())%></option>
            </select>
            
            <input type="text" name="paramvalue">
            <span name="ebrowserSpan" style="display:none;">
	            <button type="button" class=browser onClick="onShowBrowser('eselectids','','','', 0, null, null, this)"></button>
	            <span id="eselectidsspan" name="eselectidsspan"></span>
	            <input id="eselectids" name="eselectids" type="hidden" value="">
            </span>
            <input type="button" class="operbtn2 operbtn_ok" title="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" value=" " onclick="confirmEdit(this);">
            <input type="button" class="operbtn2 operbtn_cancel" title="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" value=" " onclick="cancelEdit(this);">
        </div>
    </body>
</html>
