<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.mobile.webservices.workflow.WorkflowRequestInfo" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="workflowServiceImpl" class="weaver.mobile.webservices.workflow.WorkflowServiceImpl" scope="session"/>
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="session"/>
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="session"/>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String [] sqlConditions = new String[]{};
int userid = user.getUID();
String viewtype = workflowServiceImpl.getToDoWorkflowRequestTypeIds(userid, true, sqlConditions);
String handletype = workflowServiceImpl.getMyWorkflowRequestTypeIds(userid,sqlConditions);
String []arrayview = Util.TokenizerString2(viewtype, ",");

int recordCount = workflowServiceImpl.getToDoWorkflowRequestCount(userid, true, sqlConditions);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
    <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
    <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/common.css">
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
    
    <script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" rel="stylesheet" type="text/css">
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
	
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	
	<link rel="stylesheet" type="text/css" href="/js/poshytip-1.2/tip-yellowsimple/tip-yellowsimple_wev8.css" />
	
	<!-- 日历控件 -->
    <link href="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs3.css" />
  	<link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs4.css" />
    <script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.js"></script>
    <script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/moment.js"></script>
    <script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/daterangepicker.js"></script>
    
	<script language="javascript" src="/rdeploy/assets/js/jquery.easing.1.3.js"></script>
	<link rel="stylesheet" href="/js/jquery/ui/jquery-ui_wev8.css">
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
    <!-- 高级搜索样式 -->
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/chatsearch.css">
    <!-- 流程样式 -->
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/wf/requestshow.css">
    <script>
    $(function(){
    	jQuery(".divtab_menu ul li").on("click", function () {
    		if (!$(this).find("a").hasClass("selected")) {
                var oldselectedele = $(".divtab_menu ul li a.selected");
                oldselectedele.removeClass("selected");
                $(this).find("a").addClass("selected");
                showmodel($(this).find("input[name=model]").val(),$(this).find("a").width());
            }
    	});
    	
    	jQuery(".divtab_menu ul li").bind("mouseover",function(e){
    		$(this).find("a").css("color","#626671");
    	});
    	
    	jQuery(".divtab_menu ul li").bind("mouseout",function(e){
    		if($(this).find("a").attr("class") != "selected"){
	    		$(this).find("a").css("color","#939d9e");
    		}
    	});
    	
    	jQuery(".searchspan").on("click", function () {
    		onSearchResult();
    	});
    	
    	jQuery(".closesearch").on("click", function () {
    		jQuery(".searchshow").css("display","none");
    	});
    	
    	jQuery(".closesearch").bind("mouseover",function(e){
    		$(this).css("background-image","url('/rdeploy/assets/img/wf/searchclosehot.png')");
    	});
    	
    	jQuery(".closesearch").bind("mouseout",function(e){
	    	$(this).css("background-image","url('/rdeploy/assets/img/wf/searchclose.png')");
    	});
    	
    	jQuery(".adspan").on("click", function () {
    		advancedSearch();
    	});
    	
    	$("#requestname")[0].focus();
    	__jNiceNamespace__.beautySelect();
    	
    	$("span[id^=sbHolderSpan_]").css("max-width", "95%");
    	jQuery(".weatable_wfstatu").parent().css("width","100%");
    	jQuery(".divtab_menu ul li").find(".selected").css("color","#626671");
		$("#date").daterangepicker({separator : " - "}, function(start, end, label) {
            //console.log(start, end, label);
            $("#createdatefrom").val(start);
            $("#createdateto").val(end);
        });
    	
    	jQuery(".requestviewselect").css("top","-200px");
        jQuery(".requesthandleselect").css("top","-200px");
        
        //sbOptions_54265461
        jQuery("#sbOptions_"+jQuery("select[name=wfstatu]").attr("sb")).css("width","100%");
        jQuery("#sbOptions_"+jQuery("select[name=wfstatu]").attr("sb")).parent().addClass("selectstatus");
        jQuery("#sbOptions_"+jQuery("select[name=wfstatu]").attr("sb")).find("li").each(function(){
        	jQuery(this).css({"height":"35px","line-height":"25px"});
        	jQuery(this).find("a").css({"color":"#3c4350"});
        });
        //jQuery(".hiddensearch").find(".ac_input").css({"height":"43px"});
        
        jQuery("html").mousedown(function (e){ 
        	if(!!!jQuery(e.target).closest(".hiddensearch")[0] && !!!jQuery(e.target).closest(".adspan")[0] && !!!jQuery(e.target).closest(".opensright")[0] && !!!jQuery(e.target).closest(".ac_results")[0]){
				$(".hiddensearch").animate({ 
					height: 0
					}, 200,null,function() {
					jQuery(".hiddensearch").hide();
					//jQuery(".advancedSearch").hide();
				}); 
			}
        });
        
        /*jQuery("html").live('mouseup', function (e) {
        	if(!!!jQuery(e.target).closest(".hiddensearch")[0] && !!!jQuery(e.target).closest(".adspan")[0]){
				$(".hiddensearch").animate({ 
					height: 0
					}, 200,null,function() {
					jQuery(".hiddensearch").hide();
					//jQuery(".advancedSearch").hide();
				}); 
			}
			e.stopPropagation();
		});*/
    });
    
    /**
	*清空搜索条件
	*/
	function __resetCondtion(){
		jQuery(".advancedSearch").find("#begindate, #enddate").val("");
		jQuery(".advancedSearch").find("select").val("");
		jQuery(".advancedSearch").find("select").trigger("change");
		jQuery(".advancedSearch").find("select").selectbox('detach');
		jQuery(".advancedSearch").find("select").selectbox('attach');
		jQuery(".advancedSearch").find("span[id^=sbHolderSpan_]").css("max-width", "95%");
		//清空文本框
		jQuery(".advancedSearch").find("input[type='text']").val("");
		//清空浏览按钮及对应隐藏域
		jQuery(".advancedSearch").find(".Browser").siblings("span").html("");
		jQuery(".advancedSearch").find(".Browser").siblings("input[type='hidden']").val("");
		jQuery(".advancedSearch").find(".e8_os").find("input[type='hidden']").val("");
		jQuery(".advancedSearch").find(".e8_outScroll .e8_innerShow span").html("");
		jQuery(".advancedSearch").find("#requestname")[0].focus();
	}
    
    /**
     * 根据model元素的值，变更iframe的src
     */
    function showmodel(modelstr,width) {
        var iframesrc = "";
        var left = 0;
        switch(modelstr) {
            case "requestadd":
                iframesrc = "/rdeploy/chatproject/workflow/requestAddList.jsp?_" + new Date().getTime() + "=1&";
                left=29;
                jQuery(".requestviewselect").css("top","-200px");
                jQuery(".requesthandleselect").css("top","-200px");
                break;
            case "requestview":
            	var viewtype = jQuery("#viewtype").val();
                iframesrc = "/rdeploy/chatproject/workflow/requestViewList.jsp?_" + new Date().getTime() + "=1&viewtype=0";
                left=118;
                jQuery(".requestviewselect").css("top","68px");
                jQuery(".requesthandleselect").css("top","-200px");
                break;
            case "requesthandle":
            	var handlestatus = jQuery("#handlestatus").val();
            	var handletype = jQuery("#handletype").val();
            	var viewwidth = jQuery(".viewtypenum").parent().parent().width();
                iframesrc = "/rdeploy/chatproject/workflow/requestHandleList.jsp?_" + new Date().getTime() + "=1&handlestatus=0&handletype=0";
                left=157+viewwidth;
                jQuery(".requestviewselect").css("top","-200px");
                jQuery(".requesthandleselect").css("top","68px");
                break;
            default:
                iframesrc = "";
        }
        jQuery(".divtab_menu ul li").each(function(){
	        if($(this).find("a").attr("class") != "selected"){
	    		$(this).find("a").css("color","#939d9e");
			}
        });
        slideline(left,width);
        $("#contentFrame").attr("src", iframesrc);
    }
    
    /**
    * 线条跟随滑动
    ***/
    function slideline(left,width){
    	jQuery(".moveline").animate({ 
			left: left,
			width:width+16
		}, 5,null,function() {
		}); 
    }
    
    function onChangeView(){
    	var viewtype = jQuery("#viewtype").val();
    	var iframesrc = "/rdeploy/chatproject/workflow/requestViewList.jsp?_" + new Date().getTime() + "=1&viewtype="+viewtype;
    	$("#contentFrame").attr("src", iframesrc);
    }
    
    function onChangeHandle(){
    	var handlestatus = jQuery("#handlestatus").val();
    	var handletype = jQuery("#handletype").val();
    	var iframesrc = "/rdeploy/chatproject/workflow/requestHandleList.jsp?_" + new Date().getTime() + "=1&handlestatus="+handlestatus+"&handletype="+handletype;
    	$("#contentFrame").attr("src", iframesrc);
    }
    
    function onSearchResult(){
    	//jQuery(".searchshow").css("display","block");
    	//////
    	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%>",true,"xTable_message");
    	var width = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
		var height = window.innerHeight || (window.document.documentElement.clientHeight || window.document.body.clientHeight);
    	jQuery(".searchshow").animate({ 
    		opacity : "show",
		    width:width,
			height:height-60
			}, 10, null, function() {
				e8showAjaxTips("",false);
		});
    	//////
    	var iframesrc = "/rdeploy/chatproject/workflow/searchResult.jsp?_" + new Date().getTime() + "=1&requestname="+jQuery("input[name=requestname1]").val();
    	$("#searchFrame").attr("src", iframesrc);
    }
    
    function advancedSearch(){
    	jQuery(".hiddensearch").show();
    	//jQuery(".advancedSearch").show();
    	jQuery(".hiddensearch").animate({ 
		    //width:[185, 'easeOutBounce']
			height:[300, 'easeInQuad']
		},200); 
    }
    
    function doSearch(){
    	$(".hiddensearch").animate({ 
			height: 0
			}, 10,null,function() {
			jQuery(".hiddensearch").hide();
			//jQuery(".advancedSearch").hide();
		}); 
    	//jQuery(".searchshow").css("display","block");
    	//jQuery(".searchshow").show('slow');
    	//////
    	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%>",true,"xTable_message");
    	var width = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
		var height = window.innerHeight || (window.document.documentElement.clientHeight || window.document.body.clientHeight);
    	jQuery(".searchshow").animate({ 
    		opacity : "show",
		    width:width,
			height:height-60
			}, 10, null, function() {
				e8showAjaxTips("",false);
		});
    	//////
    	var requestname = jQuery("input[name=requestname]").val();
    	var typeid = jQuery("input[name=typeid]").val();
    	var createrid = jQuery("input[name=createrid]").val();
    	var createdatefrom = jQuery("input[name=createdatefrom]").val();
    	var createdateto = jQuery("input[name=createdateto]").val();
    	var wfstatu = jQuery("input[name=wfstatu]").val();
    	var iframesrc = "/rdeploy/chatproject/workflow/searchResult.jsp?_" + new Date().getTime() + "=1&requestname="+requestname+"&typeid="+typeid+"&createrid="+createrid+"&createdatefrom="+createdatefrom+"&createdateto="+createdateto+"&wfstatu="+wfstatu;
    	$("#searchFrame").attr("src", iframesrc);
    }
    </script>
  </head>
  
  <body>
    <div class="width100 title-bg">
      <table width="100%" height="60px" cellpadding="0" cellspacing="0">
          <colgroup><col width="60px"><col width="*"><col width="280px"></colgroup>
          <tr>
            <td style="padding:0 10px;">
              <img src="/rdeploy/assets/img/cproj/wf/title.png" width="40px" height="40px">
            </td>
            <td>
               <div class="margin-top--4">
	               <span class="size14">
	                   流程
	               </span>
	               <div class="h2"></div>
	               <span class="color-2">
	                   有效管理公司内部各项事务的办理
	               </span>
               </div>
            </td>
            <td class="padding-right-20">
                <div class="input-group">
                    <input type="text" name="requestname1" class="searchinput" placeholder="搜索流程">
                    <span class="searchspan" title="搜索">
                    </span>
                    <span class="adspan">
                        高级搜索
                    </span>
                </div>
            </td>
          </tr>
        </table>
    </div>
    <div>
     	<div class="divtab_menu" style="width:70%;height:36px;position: relative;">
	    	<ul>
	          <li>
	            <a href="javascript:return false;" class="selected">
	              <input type="hidden" name="model" value="requestadd">
	              <span class="nav-text-spacing "></span>
	              <span class="nav-text-spacing-center"></span>
	                	新建流程
	            </a>
	          </li>
	          <li>
	            <a href="javascript:return false;">
	              <input type="hidden" name="model" value="requestview">
	              <span class="nav-text-spacing "></span>
	              <span class="nav-text-spacing-center"></span>
	                	待办事宜
	              <span class="viewtypenum">
	                	<%="（"+recordCount+"）"%>
	              </span>
	            </a>
	          </li>
	          <li>
	            <a href="javascript:return false;">
	              <input type="hidden" name="model" value="requesthandle">
	              <span class="nav-text-spacing "></span>
	              <span class="nav-text-spacing-center"></span>
	                	我的请求
	            </a>
	          </li>
	        </ul>
        </div>
        
       	<div class="requestviewselect">
       		<select class="viewtype" id="viewtype" name="viewtype" onChange="onChangeView()">
       			<option value="0" >全部类型</option>
       			<% 
       				List viewList = new ArrayList();
       				for(int h=0;h<arrayview.length;h++){
       					String activewfid = WorkflowVersion.getActiveVersionWFID(arrayview[h]);
       					if(!viewList.contains(workflowComInfo.getWorkflowtype(activewfid))){
       						viewList.add(workflowComInfo.getWorkflowtype(activewfid));
       					}else{
       						continue;
       					}
       					
       			%>
       				<option value="<%=workflowComInfo.getWorkflowtype(activewfid)%>" ><%=workTypeComInfo.getWorkTypename(workflowComInfo.getWorkflowtype(activewfid)) %></option>
       			<%}%>
       		</select>
       	</div>
       	<div class="requesthandleselect">
       		<select class="handlestatus" id="handlestatus" name="handlestatus" onChange="onChangeHandle()">
       			<option value="0" >全部状态</option>
       			<option value="1" >未归档</option>
       			<option value="2" >已归档</option>
       		</select>
       		&nbsp;
       		<select class="handletype" id="handletype" name="handletype" onChange="onChangeHandle()">
       			<option value="0" >全部类型</option>
       			<% 
       				String []arrayhandle = Util.TokenizerString2(handletype, ",");
       				List handleList = new ArrayList();
       				for(int j=0;j<arrayhandle.length;j++){
       					String activewfid = WorkflowVersion.getActiveVersionWFID(arrayhandle[j]);
       					if(!handleList.contains(workflowComInfo.getWorkflowtype(activewfid))){
       						handleList.add(workflowComInfo.getWorkflowtype(activewfid));
       					}else{
       						continue;
       					}
       			%>
       				<option value="<%=workflowComInfo.getWorkflowtype(activewfid)%>" ><%=workTypeComInfo.getWorkTypename(workflowComInfo.getWorkflowtype(activewfid)) %></option>
       			<%}%>
       		</select>
       	</div>
        
        <div class="showrequestline"> </div>
        <div class="moveline"> </div>
    </div>
    <div style="position:absolute;top:110px;width:100%;bottom:0px;overflow:hidden;">
	      <iframe name="contentFrame" id="contentFrame" border="0" frameborder="no" noresize="noresize" 
	          width="100%" height="100%" scrolling="auto" src="/rdeploy/chatproject/workflow/requestAddList.jsp" style=""></iframe> 
    </div>
    <div class="hiddensearch">
    	<div class="advancedSearch">
			<div class="rowbock rowwidth1">
				<span class="rowtitle">标题</span>
				<div class="rowinputblock rowinputblockleft1">
					<INPUT type="text" class="rowinputtext" name="requestname" id="requestname" tabindex="0">
				</div>
			</div>
			<div class="searchline"></div>
			
			<div class="rowbock rowwidth1">
				<span class="rowtitle">所属路径</span>
				<div class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
					<span>
						<brow:browser viewType="0" name="typeid"
								browserValue=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue=""></brow:browser>
					</span>
				</div>
			</div>
			<div class="searchline"></div>
			<div class="rowbock rowwidth1">
				<span class="rowtitle">创建人</span>
				<div class="rowinputblock rowinputblockleft4 rowinputblock-brow-ie8">
					<span id="createridspanshow">
						<brow:browser viewType="0" name="createrid" browserValue="" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue=""></brow:browser>
					</span>
				</div>
			</div>
			<div class="searchline"></div>
			<div class="rowbock rowwidth1">
				<span class="rowtitle" style="cursor:pointer;">创建日期</span>
				<div class="rowinputblock rowinputblockleft2">
					<input class="rowinputtext" type="text" id="date" readonly="readonly" style="cursor:pointer;">
					<INPUT type="hidden" name="createdatefrom" id="createdatefrom" value="">  
				    <INPUT type="hidden" name="createdateto" id="createdateto" value="">
				</div>
			</div>
			<div class="searchline"></div>
			<div class="rowbock rowwidth1" style="float:left;">
				<span class="rowtitle">处理状态</span>
				<div class="rowinputblock rowinputblockleft2">
					<select class=inputstyle size=1 style="width:100%;" name="wfstatu">
						<option value="0" >全部</option>
						<option value="1" >待办</option>
						<option value="2" >已办</option>
					</select>
				</div>
			</div>
			<div class="searchline"></div>
			<div style="width:323px;margin-top:15px;display:inline-block;">
				<span class="searchbtn searchbtn_cl" onclick="__resetCondtion()">
					重 置
				</span>
				
				<span class="searchbtn searchbtn_rht" onclick="doSearch();">
					搜 索		
				</span>
			</div>
    	</div>
    </div>
    <div class="searchshow">
    	<div class="itemshow">
    		<div class="resultshow"></div>
    		<div class="closesearch"></div>
    	</div>
    	<iframe name="searchFrame" id="searchFrame" border="0" frameborder="no" noresize="noresize" 
	          width="100%" height="100%" scrolling="auto" src="/rdeploy/chatproject/workflow/searchResult.jsp?viewtype=0" style=""></iframe> 
    </div>
  </body>
</html>
