<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
    <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/common.css">
    
    <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
    
    <script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" rel="stylesheet" type="text/css">
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
	
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
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
	
	<!-- 高级搜索样式 -->
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/chatsearch.css">
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/wf/requestshow.css">
    
    
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
			
			<!-- swfupload -->
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/js/swfupload/swfupload.queue_wev8.js"></script>

		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/rdeploy_handlers_wev8.js"></script>

		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/rdeploy_doc_swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/fileprogress_wev8_new.js"></script>
	
	<script type='text/javascript' src='/rdeploy/chatproject/doc/index_init_wev8.js'></script>
	<script type='text/javascript' src='/rdeploy/chatproject/doc/uploadfile_wev8.js'></script>
	
	<script type="text/javascript">
		var dataJson;
		var privateDataJson;
		var publicIds = new Array();
		var privateIds = new Array();
		var userLoginId = "<%= user.getLoginid() %>";
	</script>
	<style type="text/css">
	a {
	cursor:pointer;
}
	.e8MenuNav{
	    position: absolute;
	    width: 478px;
	    height: 30px;
	    color: #939d9e;
	    vertical-align: middle;
	    border: 1px solid #dadada;
	    right: 38%;
	    top: 67px;
	}
	.e8MenuNav .e8Home{
		background-repeat:no-repeat;
		background-position:50% 5px;
		background-image:url(/images/ecology8/newdoc/home_wev8.png);
		height:100%;
		width:30px;
		cursor:pointer;
		top:0px;
		left:0px;
		position:absolute;
	}
	
	.e8MenuNav .e8Expand{
		background-repeat:no-repeat;
		background-position:50% 9px;
		background-image:url(/images/ecology8/newdoc/expand_wev8.png);
		height:100%;
		width:30px;
		cursor:pointer;
		top:0px;
		right:0px;
		position:absolute;
		display:none;
	}
	
	.e8MenuNav .e8ParentNav{
		width:100%;
		height:100%;
		padding-left:30px;
	}
	.e8MenuNav .e8ParentNav .e8ParentNavLine{
		background-image:url(/images/ecology8/newdoc/line_wev8.png);
		background-repeat: no-repeat;
		background-position: 50% 50%;
		width: 20px;
		height:30px;
		float:left;
	}
	.e8MenuNav .e8ParentNav .e8ParentNavContent{
		height:30px;
		line-height:30px;
		float:left;
	}
    	.opBtn {
		    background-color: #f2f2f2;
		    color: #cdcdcd;
			text-align: center;
			border-radius: 3px;
		}
		
		.newFolder {
			width: 78px;height: 25px;position: absolute;left: -221px;top:2px;cursor:pointer;
		}
		
		.uploadOpBtn {
			width: 60px;height: 25px;position: absolute;left: -130px;top:2px;cursor:pointer;
		}
		.downloadOpBtn {
			width: 60px;height: 25px;top:2px;position: absolute;left: -58px;cursor:pointer;
		}
		.fimg {
			float: left; width: 30%; margin-top: 6px;margin-left: 3px;
		}
		.ftext {
			float: left; width: 70%; margin-left: -6px;margin-top: 4px;
		}
		.uimg {
			float: left; width: 20%; margin-top: 4px;margin-left: 11px;
		}
		.utext {
			float: left; width: 80%; margin-left: -11px;margin-top: 4px;
		}
		.dimg {
			float: left; width: 20%; margin-top: 4px;margin-left: 11px;
		}
		.dtext {
			float: left; width: 80%; margin-left: -11px;margin-top: 4px;
		}
		.swfUploadBtn {
			    float: right;
    width: 59px;
    margin-top: -34px;
    right: 95px;
    display: none; 
    position: absolute;
		}
		.uploadImg {
			float: left;
    		margin-top: 5px;
    		margin-left: 6px;
		}
		
		.downloadImg {
			float: left;
		}
		.nava {
			color: #8e9598;
		}
		.nava:hover {
			color: #474f60;
		}
		
		
		.closesearch {
    width: 18px;
    height: 18px;
    float: right;
    margin: 6px 20px 6px 10px;
    cursor: pointer;
    background-image: url("/rdeploy/assets/img/wf/searchclose.png");
    background-repeat: no-repeat;
    background-position: center;
}
	.closesearch:hover {
	 width: 18px;
    height: 18px;
    float: right;
    margin: 6px 20px 6px 10px;
    cursor: pointer;
    background-image: url("/rdeploy/assets/img/wf/searchclosehot.png");
     background-repeat: no-repeat;
    background-position: center;
}
    </style>
  </head>
  
  <body>
  <div id="contentall">
    <div class="width100 title-bg">
      <table width="100%" height="60px" cellpadding="0" cellspacing="0">
          <colgroup><col width="60px"><col width="*"><col width="280px"></colgroup>
          <tr>
            <td style="padding:0 10px;">
              <img src="/rdeploy/assets/img/cproj/doc/icon.png" width="40px"
							height="40px">
            </td>
            <td>
               <div class="margin-top--4">
	            <span class="size14"> 网盘 </span>
				<div class="h2"></div>
				<span class="color-2"> 方便快捷地分享文件 </span>
               </div>
            </td>
            <td class="padding-right-20">
                <div class="input-group">
                    <input type="text" name="keyword" id="keyword" class="searchinput" placeholder="搜索文档">
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
     		<input type="hidden" name="loadFolderType" id="loadFolderType" value="publicAll" />
     		<input type="hidden" id="fpid" name="fpid" value='0' />
     		<input type="hidden" id="publicId" name="publicId" value='0' />
     		<input type="hidden" id="privateId" name="privateId" value='privateAll' />
     		
     		<input type="hidden" id="ownerid" name="ownerid" value='<%=user.getUID() %>' />
     		<input type="hidden" id="doclangurage" name="doclangurage" value='<%=user.getLanguage() %>' />
     		<input type="hidden" id="docdepartmentid" name="docdepartmentid" value='<%= user.getUserDepartment() %>' />
     		
	    	<ul>
	          <li>
	            <a class="selected">
	              <input type="hidden" name="model" value="publicAll">
	              <span class="nav-text-spacing "></span>
	              <span class="nav-text-spacing-center"></span>
	                	公共目录
	            </a>
	          </li>
	          <li>
	            <a>
	              <input type="hidden" name="model" value="privateAll">
	              <span class="nav-text-spacing "></span>
	              <span class="nav-text-spacing-center"></span>
	                	私人目录
	            </a>
	          </li>
	        </ul>
        </div>
        <div class="e8MenuNav">
			<div class="e8ParentNav" id="e8ParentNav">
				<div class="e8Home" onclick=""></div>
				<div class="e8Expand" onclick=""></div>
				<div id="navItem"></div>
			</div>
		</div>
       	<div class="requestviewselect" id="requestviewselect" style="top:70px;">
       	<div id="downloadDiv" name="downloadDiv" class="opBtn downloadOpBtn"><div class="dimg"><img class="downloadImg" id="downloadDivImg" name="downloadDivImg" src="/rdeploy/assets/img/cproj/doc/download_no.png"></div><div class="dtext">下载</div></div>
       	</div>
        <div style="clear: both;"></div>
        <div class="showrequestline"> </div>
        <div class="moveline"> </div>
    </div>
    <div id="swfuploadbtn" class="swfuploadBtn">
										<span id="uploadButton"></span>
										</div>
    <div style="position:absolute;top:110px;width:100%;bottom:0px;overflow:hidden;">
	      <iframe name="contentFrame" id="contentFrame" border="0" frameborder="no" noresize="noresize" 
	          width="100%" height="100%" scrolling="auto" src="/rdeploy/chatproject/doc/seccategoryViewList.jsp"></iframe> 
    </div>
    <div class="hiddensearch">
    	<div class="advancedSearch">
			<div class="rowbock rowwidth1">
				<span class="rowtitle">标题</span>
				<div class="rowinputblock rowinputblockleft1">
					<INPUT type="text" class="rowinputtext" name="doctitle" id="doctitle" tabindex="0">
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
				<span class="rowtitle">创建人部门</span>
				<div class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
					<span>
						<brow:browser viewType="0" name="departmentid"
								browserValue=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue=""></brow:browser>
					</span>
				</div>
			</div>
			<div class="searchline"></div>
			<div class="rowbock rowwidth1">
				<span class="rowtitle">目录</span>
				<div class="rowinputblock rowinputblockleft2 rowinputblock-brow-ie8">
					<span>
						<brow:browser viewType="0" name="seccategory"
								browserValue=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue=""></brow:browser>
					</span>
				</div>
			</div>
			<div class="searchline"></div>
			<div class="rowbock rowwidth1">
				<span class="rowtitle" style="cursor:pointer;">文档日期</span>
				<div class="rowinputblock rowinputblockleft2">
					<input class="rowinputtext" type="text" id="date" readonly="readonly" style="cursor:pointer;">
					<INPUT type="hidden" name="createdatefrom" id="createdatefrom" value="">  
				    <INPUT type="hidden" name="createdateto" id="createdateto" value="">
				</div>
			</div>
			<div class="searchline"></div>
			
			<div style="width:323px;margin-top:7px;display:inline-block;">
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
    		<div class="resultshow">搜索结果(共22条记录)</div>
    		<div class="closesearch"></div>
    	</div>
    	<iframe name="searchFrame" id="searchFrame" border="0" frameborder="no" noresize="noresize" 
	          width="100%" height="100%" scrolling="auto" src=""></iframe> 
    </div>
    </div>
  </body>
</html>
