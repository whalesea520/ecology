<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
	<head>
		<link rel="stylesheet" type="text/css"
			href="/js/jquery-autocomplete/browser_wev8.css" />
		<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/search.css" />
		<link rel="stylesheet" type="text/css"
			href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<style type="text/css" >
			@IMPORT url("/js/ecology8/jNice/jNice/jNice_wev8.css");
			@IMPORT url("/css/ecology8/request/requestView_wev8.css");
			@IMPORT url("/css/ecology8/request/seachBody_wev8.css");
			@IMPORT url("/js/select/style/selectForK13_wev8.css");
			@IMPORT url("/js/checkbox/jquery.tzCheckbox_wev8.css");
			@IMPORT url("/js/ecology8/selectbox/css/jquery.selectbox_wev8.css");
			@IMPORT url("/css/ecology8/request/searchInput_wev8.css");
			@IMPORT url("/css/commonCss_wev8.css");
		</style>
		<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
		
		
		<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery.table_wev8.js"></script>
		<script language="javascript" type="text/javascript"
			src="/js/init_wev8.js"></script>
		<script language="javascript" src="/js/wbusb_wev8.js"></script>
		<script type="text/javascript"
			src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
		<script type="text/javascript"
			src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<script type='text/javascript'
			src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript'
			src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script language=javascript
			src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript"
			src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script language=javascript src="/js/weaver_wev8.js"></script>
		<script language=javascript
			src="/js/ecology8/docs/docSearchExt_wev8.js"></script>
		<script language=javascript
			src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
		<script language='javascript' type='text/javascript'
			src='/js/xmlextras_wev8.js'></script>
		<script language='javascript' type='text/javascript'
			src='/js/weaverTable_wev8.js'></script>
		<script language='javascript' type='text/javascript'
			src='/js/ArrayList_wev8.js'></script>
			<!-- 日历控件 -->
		<link href="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.css" rel="stylesheet" />
      	<link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs3.css" />
	  	<link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs4.css" />
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.js"></script>
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/moment.js"></script>
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/daterangepicker.js"></script>
	</head>
	<style type="text/css">
		#advancedSearchOuterDiv {
			display: block;
			position: relative;
			border-bottom: none;
			border-right: none;
		}
		.hoverDiv {
		  position: absolute;
		  color: #0071c2;
		  filter: alpha(opacity = 100);
		  -moz-opacity: 1;
		  opacity: 1;
		  text-align: center;
		  background-color: #b6e1fd;
		  overflow: hidden;
		  z-index: 10003;
		}
		.paddingLeft0Table{
			height: 0px !important;
		}
		input.InputStyle,input.Inputstyle,input.inputStyle,input.inputstyle,input[type="text"],input[type="password"],.e8_innerShowContent,textarea,.sbHolder{
			border: none!important;
		}
		.rowinputblock {
		  line-height: 40px!important;
		}
		#outdepartmentiddiv {
		    margin-right: -32px!important;
		  	width: 93%!important;
		}
		.e8_os {
		  width: 198px!important;
		}
		.rowbockImp .e8_os {
			width: 470px !important;
		}
		.table thead>tr>th, .table tbody>tr>th, .table tfoot>tr>th, .table thead>tr>td, .table tbody>tr>td, .table tfoot>tr>td {
		  padding: 8px;
		  line-height: 1.428571429;
		  vertical-align: top;
		  border-top: none!important;
		}
		
		#_cloneWeaverTableDiv {
		background-color: rgb(248,248,248);
		}
		table.ListStyle td a:link {
		  color: #242424;
		  max-width: 90%;
		  text-overflow: ellipsis;
		  display: inline-block;
		  overflow: hidden;
		  vertical-align: middle;
		}
		table.ListStyle tr.Selected td a{
			color:#018efb;
		}
	
		.e8_showNameClass {
  			float: left !important;
  			line-height: 44px;
  			margin-top:-1px!important;
		}
	</style>
	<%
	User user = HrmUserVarify.getUser(request, response);
    String urlType = Util.null2String(request.getParameter("urlType"));
    String offical = "";
    int officalType = -1;
    // 主题
    String docsubject = Util.null2String(request.getParameter("docsubject"));
 	// 创建人
    String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
 	// 创建人部门
 	int departmentid = Util.getIntValue(Util.null2String(request.getParameter("departmentid")),0);
	// 开始时间	    
    String doclastmoddatefrom = Util.toScreenToEdit(request.getParameter("doclastmoddatefrom"),user.getLanguage());
	// 结束时间
    String doclastmoddateto = Util.toScreenToEdit(request.getParameter("doclastmoddateto"),user.getLanguage());	 
	
    // 目录
    int seccategory = Util.getIntValue(Util.null2String(request.getParameter("seccategory")), 0);
    // 自定义查询条件
    String customSearchPara = Util.null2String(request.getParameter("customSearchPara"));
    // 显示方式 列表/缩略图 0/1
    int displayUsage = Util.getIntValue(request.getParameter("displayUsage"), 0);
    // 全部/回复/非回复
    String dspreply = Util.null2String(request.getParameter("dspreply"));
    String searchType = Util.null2String(request.getParameter("searchType")); // 0 最新文档 1 我的文档 2 查询文档 3 文档目录
    
    // 是否显示已阅读项
    String isNew = Util.null2String(request.getParameter("isNew"));
    // 标题名称
    String navName = "";

    if(searchType.equals("0")){
    	navName = SystemEnv.getHtmlLabelName(16397,user.getLanguage());
    	if(seccategory == 0)
    	{
    	    if(doclastmoddatefrom.isEmpty())
        	{
        	    doclastmoddatefrom = TimeUtil.getToday();
        	}
        	
        	if(doclastmoddateto.isEmpty())
        	{
        	    doclastmoddateto = TimeUtil.getToday();
        	}    	    
    	}
    }else if(searchType.equals("1")){
    	navName = SystemEnv.getHtmlLabelName(1212,user.getLanguage());
    }else if(searchType.equals("2")){
    	navName = SystemEnv.getHtmlLabelName(16399,user.getLanguage());
    }
    else if(searchType.equals("3")){
    	if(seccategory != 0)
    	{
    	    navName = SecCategoryComInfo.getAllParentName(""+seccategory,true);
    	}
    	else
    	{
    	    navName = SystemEnv.getHtmlLabelName(16398,user.getLanguage());
    	}
    }
    
	%>
	<script type="text/javascript"
		src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	<%if(true){ %>
		<SCRIPT language="javascript" defer="defer" src="/js/doc/DocCommonExt_wev8.js"></script>
		<%@ include file="/docs/search/ext/DocSearchViewExt.jsp"%>
	<% } %>
	<body>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<div id='DocSearchDiv'>
			<div style="display: none">
				<%
				if(searchType.equals("2"))
				{
					RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onBtnSearchClickRight(),_top} ";
					RCMenuHeight += RCMenuHeightStep;
				}
					String columnUrl = "";
					if (urlType.equals("6")) {
							columnUrl = "/docs/search/ext/DocSearchViewColumnExt.jsp?displayUsage=" + displayUsage;
					        if (displayUsage == 0) {
					            RCMenu += "{" + SystemEnv.getHtmlLabelName(19119, user.getLanguage()) + ",javascript:miniatureDisplay(),_top} ";
					                RCMenuHeight += RCMenuHeightStep;
					        }
					        else
					        {
				    		     RCMenu += "{"+SystemEnv.getHtmlLabelName(15360,user.getLanguage())+",javascript:listDisplay(),_top} " ;
				    		     RCMenuHeight += RCMenuHeightStep ;				            
					        }
					        RCMenu += "{"+SystemEnv.getHtmlLabelNames("27105",user.getLanguage())+",javascript:bacthDownloadImageFile(),_top} " ;
			        		RCMenuHeight += RCMenuHeightStep ;
					    }
					%>
				</div>
				
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td style="">
						</td>
						<td class="rightSearchSpan" style="text-align: right;">
							<%if (urlType.equals("6")) {%>
							<input type="text" id="flowTitle" class="searchInput"
								name="flowTitle" value="<%=docsubject%>"
								onchange="setKeyword('flowTitle','docsubject','frmmain');" />
								 <% if(searchType.equals("0")){%>
								 	<input type="button" value="<%=SystemEnv.getHtmlLabelName(18492,user.getLanguage())%>" class="e8_btn_top" onclick="signReaded()"/>
								 <% } %>
								  <% if(searchType.equals("1")){%>
								  	<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" class="e8_btn_top" onclick="doMuliDelete()"/>
								 <% } %>
							<%}	%>
							<span
								title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"
								class="cornerMenu"></span>
						</td>
					</tr>
				</table>
			<form name="frmmain" id="frmmain" method="post"
				action="DocCommonContent.jsp?searchType=<%= searchType %>&offical=<%=offical%>&officalType=<%=officalType%>">
				<input type="hidden" id="urlType" name="urlType" value="<%=urlType%>" />
				<input type="hidden" name="displayUsage" value="<%=displayUsage%>">
				<input type="hidden" id = "customSearchPara" name="customSearchPara" value="<%= customSearchPara %>">
				<input type="hidden" id = "dspreply" name="dspreply" value="<%= dspreply %>">
				<input type="hidden" id = "isNew" name="isNew" value="<%= isNew %>">
			
				<input type="hidden" name="pageId" id="pageId"  value="<%=PageIdConst.getPageId(urlType)%>"/>
				<div id="content"
					style="display:none;position: absolute; left: 50%; width: 560px; margin-top: 37px; margin-left: -280px;">
					<div class="rowbock rowwidth1">
						<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(25025,user.getLanguage()) %></span> <!-- 25025 主题 -->
						<div class="rowinputblock rowinputblockleft1">
							<input class="rowinputtext" type="text" name="docsubject"
								id="docsubject" value="<%=docsubject%>">
						</div>
					</div>
					<div class="searchline"></div>
					<div class="rowbock rowwidth1 rowbockImp">
						<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage()) %></span> <!-- 882 创建人 -->
						<div class="rowinputblock rowinputblockleft1 rowinputblock-brow-ie8">
							<span id="doccreateridselspan"> <brow:browser viewType="0"
									name="doccreaterid" browserValue="<%= doccreaterid %>"
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									 hasInput="true" isSingle="true"
									hasBrowser="true" isMustInput='1' completeUrl="/data.jsp"
									linkUrl="javascript:openhrm($id$)" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(doccreaterid+""),user.getLanguage())%>'>
								</brow:browser> </span>
							<input type="hidden" name="urlType" value="<%= urlType %>">
						</div>
					</div>
					<div class="searchline"></div>

					<div class="rowbock rowwidth1 rowbockImp">
						<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(33092,user.getLanguage()) %></span> <!-- 33092 目录 -->
						<div class="rowinputblock rowinputblockleft1 rowinputblock-brow-ie8">
							<span> <brow:browser viewType="0" name="seccategory"
									browserValue='<%=""+seccategory%>' idKey="id" nameKey="path"
									browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser="true"
									isMustInput='1'
									completeUrl="/data.jsp?type=categoryBrowser&onlySec=true"
									linkUrl="#" browserSpanValue='<%=SecCategoryComInfo.getAllParentName(""+seccategory,true)%>'></brow:browser> </span>
						</div>
					</div>
					<div class="searchline"></div>

					<div class="rowbock2cell">
						<table width="100%" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="237px">
								<col width="20px">
								<col width="*">
							</colgroup>
							<tr>
								<td>
									<div class="rowbock rowwidth2" style="float: left;">
									<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(31131,user.getLanguage()) %></span> <!-- 文档 30041 日期 31131 -->
										<div class="rowinputblock rowinputblockleft2">
											<input class="rowinputtext" type="text" id="date" readonly="readonly" style="cursor:pointer;">
											<input type="hidden" name="doclastmoddatefrom" id="doclastmoddatefrom" value="<%= doclastmoddatefrom %>">  
								    		<input type="hidden" name="doclastmoddateto" id="doclastmoddateto" value="<%= doclastmoddateto %>">
										</div>
									</div>
								</td>
								<td></td>
								<td>
									<div class="rowbock rowwidth2" style="float: left;">
										<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(81673,user.getLanguage()) %></span> <!-- 81673 创建人部门 -->
										<div class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
											<span id="recid"> <brow:browser viewType="0" 
													name="departmentid" browserValue='<%= "" + departmentid %>'
													browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
													hasInput="true" isSingle="true" hasBrowser="true"
													isMustInput='1' completeUrl="/data.jsp?type=4"
													browserSpanValue='<%=departmentid!=0?Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid+""),user.getLanguage()):""%>'></brow:browser> </span>
										</div>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div class="searchline"></div>
					<div class="searchline"></div>
					<div class="rowbock2cell">
						<table width="100%" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="237px">
								<col width="20px">
								<col width="*">
							</colgroup>
							<tr>
								<td>
									<div class="searchbtn searchbtn_cl" onclick="resetCondtion();">
										<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %> <!-- 2022 重置 -->
									</div>
								</td>
								<td></td>
								<td>
									<div class="searchbtn searchbtn_rht" onclick="onBtnSearchClick();">
										<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage()) %><!-- 82529 搜索 -->
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
		</div>
		</form>
		</div>
		<div id='divContent' style=''>
			<div id='_xTable' style='background: #FFFFFF; width: 100%'
				valign='top'>
			</div>
		</div>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
	</body>

<script type="text/javascript">
	
	try{
		parent.setTabObjName("<%= navName %>");
	}catch(e){
		if(window.console)console.log(e);
	}
	
	$(function(){
		// 当urlType为6时，显示查询结果层，隐藏搜索层
		<%if(urlType.equals("6")){%>
			parent.rebindNavEvent(null,null,null,parent.parent.loadLeftTree,{_window:window,hasLeftTree:true});
			 $("#content").hide();
			jQuery("ul.tab_menu",parent.document).css("visibility","");
		<%} else if(urlType.equals("14")){%>
			$("#docsubject")[0].focus();
			__jNiceNamespace__.beautySelect();
			$("span[id^=sbHolderSpan_]").css("max-width", "95%");
			
			if(!!$("#doclastmoddatefrom").val())
			{
				$("#date").val($("#doclastmoddatefrom").val() + " - " + $("#doclastmoddateto").val());
			}
			
			$("#date").daterangepicker({separator : " - "}, function(start, end, label) {
	         	  $("#doclastmoddatefrom").val(start);
	              $("#doclastmoddateto").val(end);
	         });
	          
	          $(".rowtitle").on("click", function (e) {
                	var inputobj = $(this).next().children("input");
                	var sltobj = $(this).next().children("span[id^=sbHolderSpan_]").find("[id^=sbToggle_]");
                	var browobj = $(this).next().find("div[id^=inner][id$=div]");
                	if (!!browobj[0]) {
                		browobj[0].click();
                	}
                	inputobj.trigger("focus");
                	sltobj.trigger("click");
                	if (!!inputobj[0]) {
                		inputobj[0].click();
                	}
                	e.stopPropagation();
                });
			$("#content").show();
		<%}%>
	});
	
	// 右键搜索
	function onBtnSearchClickRight(){
		<%if(urlType.equals("14")){%>
				$("#urlType").val("6");
		<%}%>
		search();
	}

	// 搜索按钮
	function onBtnSearchClick(){
		<%if(urlType.equals("14")){%>
			$("#urlType").val("6");
		<%}%>
		search();
	}
	
	//确认搜索提交按钮
	function search(){
		jQuery("ul.tab_menu",parent.document).css("visibility","");
		var docSearchForm =$GetEle("frmmain");
		$GetEle("customSearchPara").value = getSearchPara();
		docSearchForm.submit();
	}
	
	// 帮助
	function showHelp(){
	 	var pathKey = window.location.pathname;
	    if(pathKey!=""){
	        pathKey = pathKey.substr(1);
	    }
	    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
	    var screenWidth = window.screen.width*1;
	    var screenHeight = window.screen.height*1;
	    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
	 }
	 
	 // 批量下载
	 function bacthDownloadImageFile(){
    	var btdocids = "";
    	var displayUsage="<%=displayUsage%>";
		btdocids =_xtable_CheckedCheckboxId();
    	if(btdocids==null ||btdocids==''){
     		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(27694,user.getLanguage())%>");
     		return false;
    	}else{
     		window.location="/weaver/weaver.file.FileDownload?fieldvalue="+btdocids+"&displayUsage="+displayUsage+"&download=1&downloadBatch=1&docSearchFlag=1&urlType=<%=urlType%>&requestid=";
    	}
	}
	
	// 清空表单
	function resetCondtion() {
		//清空文本框
		jQuery("#content").find("input[type='text']").val("");
		//清空文本框
		jQuery("#content").find("input[type='hidden']").val("");
		//清空浏览按钮及对应隐藏域
		jQuery("#content").find(".Browser").siblings("span").html("");
		jQuery("#content").find(".e8_outScroll .e8_innerShow span").html("");
		$("#docsubject")[0].focus();
	}
	
	var sessionId="";		
	var colInfo;
	var seccategory = '<%= seccategory %>';
	var displayUsage = '<%=displayUsage%>';
	var customSearchPara = '<%=customSearchPara%>';
	function URLencode(sStr) 
	{
		 return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
	}

	function getSearchPara(){
		var docSearchForm = document.forms.frmmain;
		var searchPara ='';
		for(i=0;i<docSearchForm.elements.length;i++)
		{
			if(docSearchForm.elements[i].type=='checkbox'){
				if(docSearchForm.elements[i].checked==false){
					continue;
				}
			}
			if(docSearchForm.elements[i].name=='customSearchPara'){
				continue;
			}
			if(docSearchForm.elements[i].name=='seccategory'&& seccategory !='0'){
				searchPara+='&seccategory='+jQuery("#seccategory").val();
			}else if(docSearchForm.elements[i].name!= ''){
				if(docSearchForm.elements[i].value!=''){
					searchPara+='&'+docSearchForm.elements[i].name+'='+URLencode(docSearchForm.elements[i].value);
				}
			}
		}
		searchPara='sessionId='+sessionId+'&list=all'+searchPara;
		return searchPara;
	}	


	function getGridInfo(){
			var url = '<%=columnUrl%>';
			if(customSearchPara==''){
				url =url+'&'+getSearchPara();
			}else{
				url =url+'&'+customSearchPara;
			}
			var obj; 
		
		    if (window.ActiveXObject) { 
		        obj = new ActiveXObject('Microsoft.XMLHTTP'); 
		    } 
		    else if (window.XMLHttpRequest) { 
		        obj = new XMLHttpRequest(); 
		    } 	
		    
			obj.open('GET', url+"&b="+new Date().getTime(), false); 
		    obj.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
		    obj.send(null); 
		    if (obj.status == "200") {
		    	var tmpcolInfo =  obj.responseText;
		    	var posTemp=tmpcolInfo.indexOf("^^");
				if(posTemp!=-1){
			    	colInfo=tmpcolInfo.substring(0,posTemp);
			    	sessionId=tmpcolInfo.substring(posTemp+2,tmpcolInfo.length);
				}else{
					colInfo=tmpcolInfo;
				}
			}
	}
	<%if(urlType.equals("6")){%>
		getGridInfo();	
	<%}%>
	eval(colInfo);
	var _xtable_checkedList = new ArrayList();
	var _xtalbe_checkedValueList = new ArrayList();
	var _xtalbe_radiocheckId =""; 
	var _xtalbe_radiocheckValue = "";
	var _table;
	
	function setFavPageName()
	{
		return <%=SystemEnv.getHtmlLabelName(16399,user.getLanguage()) %>; //16399 查询文档
	}
	function setFavUri()
	{
		return "/rdeploy/doc/search/DocSearchTab.jsp";
	}
	function setFavQueryString()
	{
		var favquerystring =  getSearchPara();
		favquerystring = escape(favquerystring); 
		return favquerystring;
	}
	
</script>
<script FOR=window EVENT=onload LANGUAGE='JavaScript'>
		var isShowThumbnail = "";
		if(displayUsage==1){
			isShowThumbnail="1";
		}
		
		<%if(urlType.equals("6")){%>
			var url = '/weaver/weaver.common.util.taglib.SplitPageXmlServlet';
			<%if(seccategory!=0){%>
				url = url + '?__objId=<%= ""+seccategory%>&__mould=doccategory'
			<%}%>
	     _table = new weaverTable(url,0, '',sessionId,'run','', 'null', '', '', '', isShowThumbnail, '5', '', '');
		 var showTableDiv  = document.getElementById('_xTable');
	     showTableDiv.appendChild(_table.create());
	     //提示窗口
	     var message_table_Div = document.createElement("div")
	     message_table_Div.id="message_table_Div";
	     message_table_Div.className="xTable_message"; 
	     showTableDiv.appendChild(message_table_Div); 
	     var message_table_Div  = document.getElementById("message_table_Div"); 
	     message_table_Div.style.display=""; 
		 message_table_Div.innerHTML = SystemEnv.getHtmlNoteName(3403,readCookie("languageidweaver"));
	     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;   
	     var pLeft= document.body.offsetWidth/2-50;   
	     message_table_Div.style.position="absolute"
	     jQuery(message_table_Div).css({
	     	"top":pTop,
	     	"left":pLeft,
	     	"position":"absolute"
	     }).show();
	   <%}%>
	</script>
</html>
