
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
	function registerClickEvent(ifrm,_document){
		if(ifrm){
			_document = ifrm.contentWindow.document;
		}
		if(!_document)_document = document;
		jQuery("#baseInfoTab").unbind("click.custom").bind("click.custom",function(){
			jQuery("#contentInfo",_document).hide();
			jQuery("#showInfo",_document).hide();
			jQuery("#baseInfo",_document).show();
			return false;
		});
		
		jQuery("#contentInfoTab").unbind("click.custom").bind("click.custom",function(){
			jQuery("#baseInfo",_document).hide();
			jQuery("#contentInfo",_document).show();
			jQuery("#showInfo",_document).hide();
			return false;
		});
		
		jQuery("#showInfoTab").unbind("click.custom").bind("click.custom",function(){
			jQuery("#baseInfo",_document).hide();
			jQuery("#contentInfo",_document).hide();
			jQuery("#showInfo",_document).show();
			return false;
		});
	}
	
	function registerClickEventForOffical(ifrm,_document){
		if(ifrm){
			_document = ifrm.contentWindow.document;
		}
		if(!_document)_document = document;
		jQuery("#wfBaseInfoTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfBaseInfo",_document).show();
			return false;
		});
		jQuery(".weihu",_document).unbind("click.custom").bind("click.custom",function(){
			jQuery("#wfBaseInfoTab").click();
		});

		
		jQuery("#wfTaoHongTab").unbind("click.custom").bind("click.custom",function(){
			if(jQuery("#pathCategoryDocument",_document).val()!=""){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfTaoHong",_document).show();
			}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19373,user.getLanguage())%>");
			
			}
			return false;
		});
		
		jQuery("#wfEditMouldTab").unbind("click.custom").bind("click.custom",function(){
			if(jQuery("#pathCategoryDocument",_document).val()!=""){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfEditMould",_document).show();
			}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19373,user.getLanguage())%>");
			}
			return false;
		});
		
		jQuery("#wfDocPropTab").unbind("click.custom").bind("click.custom",function(){
			if(jQuery("#pathCategoryDocument",_document).val()!=""){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfDocProp",_document).show();
			}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19373,user.getLanguage())%>");
			}
			return false;
		});
		
		jQuery("#wfSignatureTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfSignature",_document).show();
			return false;
		});
		
		jQuery("#wfPrintTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfPrint",_document).show();
			return false;
		});
		
		jQuery("#wfTraceTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfTrace",_document).show();
			return false;
		});
		
		jQuery("#wfActionTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfAction",_document).show();
			return false;
		});
		
		jQuery("#wfPDFTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfPDF",_document).show();
			return false;
		});
		
		
		jQuery("#wfProcessTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfProcess",_document).show();
			return false;
		});

		jQuery("#wfTracePropTab").unbind("click.custom").bind("click.custom",function(){
			jQuery(".wfOfficalDoc",_document).hide();
			jQuery("#wfTraceProp",_document).show();
			return false;
		});
	}
	
	function registerClickEventForOfficalChange(ifrm,_document){
		if(ifrm){
			_document = ifrm.contentWindow.document;
		}
		if(!_document)_document = document;
		jQuery("#ftpInfoTab").unbind("click.custom").bind("click.custom",function(){
			jQuery("#exchangeInfo",_document).hide();
			jQuery("#ftpTestBtn").show();
			jQuery("#ftpInfo",_document).show();
			return false;
		});
		
		jQuery("#exchangeInfoTab").unbind("click.custom").bind("click.custom",function(){
			jQuery("#ftpInfo",_document).hide();
			jQuery("#ftpTestBtn").hide();
			jQuery("#exchangeInfo",_document).show();
			return false;
		});
	}
	
	function registerClickEventForSendDoc(ifrm,_document,_window){
		if(ifrm){
			_document = ifrm.contentWindow.document;
			_window = ifrm.contentWindow;
		}
		if(!_document)_document = document;
		jQuery("#unSendTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("0");
			_window.statusChange(0);
			return false;
		});
		
		jQuery("#sentTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("1");
			_window.statusChange(1);
			return false;
		});
		
		jQuery("#rejectTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("2");
			_window.statusChange(2);
			return false;
		});
		
		jQuery("#returnTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("3");
			_window.statusChange(3);
			return false;
		});
	}
		
	function registerClickEventForReceiveDoc(ifrm,_document,_window){
		if(ifrm){
			_document = ifrm.contentWindow.document;
			_window = ifrm.contentWindow;
		}
		if(!_document)_document = document;
		jQuery("#unSendTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("0");
			_window.doRefresh(0);
			return false;
		});
		
		jQuery("#sentTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("1");
			_window.doRefresh(1);
			return false;
		});
		
		jQuery("#rejectTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("2");
			_window.doRefresh(2);
			return false;
		});
		
		jQuery("#returnTab").unbind("click.custom").bind("click.custom",function(){
			var status = jQuery("#status",_document);
			status.val("3");
			_window.doRefresh(3);
			return false;
		});
	}
</script>
<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String url = "";
	String navName = "";
	String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
	String mouldID = MouldIDConst.getID(isWorkflowDoc.equals("1")?"offical":"doc");
	String cmd = Util.null2String(request.getParameter("cmd"));
	
	boolean fromProj ="1".equals( Util.null2String(request.getParameter("fromProj")));
	String proTypeId = Util.null2String(request.getParameter("proTypeId"));
	if(fromProj){
		mouldID=MouldIDConst.getID("proj");
	}
	
	if(_fromURL.equals("58")||_fromURL.equals("59")){
		mouldID = MouldIDConst.getID("offical");
	}
	String callback = "";
	
	if(_fromURL.equals("1")){//新建主目录
		url = "/docs/category/DocMainCategoryAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelName(65,user.getLanguage());
	}else if(_fromURL.equals("2")){//编辑主目录
		url = "/docs/category/DocMainCategoryBaseInfoEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("3")){//日志
		url = "/systeminfo/SysMaintenanceLog.jsp?"+request.getQueryString();
		mouldID = "";
		String operateitem = Util.null2String(request.getParameter("operateitem"));
	    String relatedid = Util.null2String(request.getParameter("relatedid"));
	    if(operateitem.equals("418")||operateitem.equals("419")||operateitem.equals("420")){
	    	if(!relatedid.equals("")){
	    		mouldID = MouldIDConst.getID("setting");
	    	}
	    }
	}else if(_fromURL.equals("4")){//新建分目录
		url = "/docs/category/DocSubCategoryAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelName(66,user.getLanguage());
	}else if(_fromURL.equals("5")){//主目录维护权限
		url="/docs/category/DocMainCategoryRightEdit.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("32452,60,385",user.getLanguage());
	}else if(_fromURL.equals("6")){//编辑分目录
		url="/docs/category/DocSubCategoryBaseInfoEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("7")){//分目录维护权限
		url="/docs/category/DocSubCategoryRightEdit.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("32452,60,385",user.getLanguage());
	}else if(_fromURL.equals("8")){//新建子目录
		url="/docs/category/DocSecCategoryAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelName(16398,user.getLanguage());
	}else if(_fromURL.equals("9")){//编辑子目录
		url="/docs/category/DocSecCategoryBaseInfoEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("10")){//子目录存为模板...
		url="/docs/category/DocSecCategorySaveAsTmpl.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("11")){//子目录维护权限
		url="/docs/category/DocSecCategoryRightEdit.jsp?from=tab&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("32452,60,385",user.getLanguage());
	}else if(_fromURL.equals("12")){//新建虚拟目录
		url="/docs/category/DocTreeDocFieldAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelName(20482,user.getLanguage());
	}else if(_fromURL.equals("13")){//编辑虚拟目录
		url="/docs/category/DocTreeDocFieldEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("14")){//新建新闻设置
		url="/docs/news/DocNewsAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelName(70,user.getLanguage());
	}else if(_fromURL.equals("15")){//编辑新闻设置
		url="/docs/news/DocNewsEdit.jsp?"+request.getQueryString();
		//callback = "registerClickEvent";
	}else if(_fromURL.equals("16")){//新闻页预览
		url="/docs/news/NewsDsp.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("17")){//新建新闻图片
		url="/docs/tools/DocPicUploadAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("74",user.getLanguage());
	}else if(_fromURL.equals("18")){//编辑新闻图片
		url="/docs/tools/DocPicUploadEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("19")){//新建/编辑新闻类型
		url="/docs/news/type/newstypeAdd.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("20")){//新建文档显示模板html
		url="/docs/mould/DocMouldAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames(isWorkflowDoc.equals("1")?"19511":"16370",user.getLanguage());
	}else if(_fromURL.equals("21")){//编辑文档显示模板html
		url="/docs/mould/DocMouldEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("22")){//编辑文档显示模板word
		url="/docs/mould/DocMouldEditExt.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("47")){//书签排序
		url="/docs/mould/DocMouldLabelOrder.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("55")){//书签排序
		url="/docs/mouldfile/DocMouldLabelOrder.jsp?"+request.getQueryString();
		if(cmd.equals("resource")){
			mouldID = MouldIDConst.getID("resource");
			navName = SystemEnv.getHtmlLabelName(15786,user.getLanguage());
		}
	}else if(_fromURL.equals("23")){//查看文档显示模板
		url="/docs/mould/DocMouldDsp.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("24")){//新建文档编辑模板html
		url="/docs/mouldfile/DocMouldAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames(isWorkflowDoc.equals("1")?"16449":"16369",user.getLanguage());
		if(cmd.equals("resource")){
			mouldID = MouldIDConst.getID("resource");
			navName = SystemEnv.getHtmlLabelName(15786,user.getLanguage());
		}
	}else if(_fromURL.equals("25")){//编辑文档编辑模板html
		url="/docs/mouldfile/DocMouldEdit.jsp?"+request.getQueryString();
		if(cmd.equals("resource")){
			mouldID = MouldIDConst.getID("resource");
			navName = SystemEnv.getHtmlLabelName(15786,user.getLanguage());
		}
	}else if(_fromURL.equals("26")){//编辑文档编辑模板word
		url="/docs/mouldfile/DocMouldEditExt.jsp?"+request.getQueryString();
		if(cmd.equals("resource")){
			mouldID = MouldIDConst.getID("resource");
			navName = SystemEnv.getHtmlLabelName(15786,user.getLanguage());
		}
	}else if(_fromURL.equals("27")){//查看文档编辑模板
		url="/docs/mouldfile/DocMouldDsp.jsp?"+request.getQueryString();
		if(cmd.equals("resource")){
			mouldID = MouldIDConst.getID("resource");
			navName = SystemEnv.getHtmlLabelName(15786,user.getLanguage());
		}
	}else if(_fromURL.equals("28")){//新建邮件模板
		url="/docs/mail/DocMouldAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("16218",user.getLanguage());
	}else if(_fromURL.equals("29")){//编辑邮件模板
		url="/docs/mail/DocMouldEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("30")){//查看邮件模板
		url="/docs/mail/DocMouldDsp.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("31")){//文档弹窗设置
		url="/docs/search/PopUpDocSet.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelName(21885,user.getLanguage());
	}else if(_fromURL.equals("32")){//新建/编辑发文字号
		url="/docs/sendDoc/docNumberAdd.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("33")){//新建/编辑秘密等级
		url="/docs/sendDoc/docSecretLevelAdd.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("34")){//新建/编辑紧急程度
		url="/docs/sendDoc/docInstancyLevelAdd.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("35")){//新建/编辑公文种类
		url="/docs/sendDoc/docKindAdd.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("36")){//新建收（发）文单位
		url="/docs/sendDoc/DocReceiveUnitAdd.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
		navName = SystemEnv.getHtmlLabelNames("19309",user.getLanguage());
	}else if(_fromURL.equals("37")){//编辑收（发）文单位
		url="/docs/sendDoc/DocReceiveUnitEdit.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("38")){//新建主题词
		url="/docs/sendDoc/WorkflowKeywordAdd.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
		navName = SystemEnv.getHtmlLabelNames("16978",user.getLanguage());
	}else if(_fromURL.equals("39")){//编辑主题词
		url="/docs/sendDoc/WorkflowKeywordEdit.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("40")){//新建期刊
		url="/web/webmagazine/WebMagazineTypeAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("31516",user.getLanguage());
	}else if(_fromURL.equals("41")){//编辑期刊
		url="/web/webmagazine/WebMagazineTypeEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("42")){//新建刊号
		url="/web/webmagazine/WebMagazineAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("31518",user.getLanguage());
	}else if(_fromURL.equals("44")){//编辑刊号
		url="/web/webmagazine/WebMagazineEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("43")){//预览期刊
		url="/tom_magazine.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("45")){//批量调整共享
		url="/docs/docs/ShareManageDocTo.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("18037",user.getLanguage());
	}else if(_fromURL.equals("46")){//文档共享
		url="/docs/docs/DocShareGetNew.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("1985",user.getLanguage());
	}else if(_fromURL.equals("48")){//添加公文流程
		url="/workflow/workflow/addOfficalWf.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("32485",user.getLanguage());
	}else if(_fromURL.equals("49")){//公文流程设置
		url="/workflow/workflow/CreateDocumentByWorkFlow.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("32485",user.getLanguage());
		//callback = "registerClickEventForOffical";
	}else if(_fromURL.equals("50")){//关联默认模板设置
		url="/workflow/workflow/attachMould.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("33325",user.getLanguage());
	}else if(_fromURL.equals("51")){//模板数据对应
		url="/workflow/workflow/CreateDocumentDetailByWorkFlow.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("33338",user.getLanguage());
	}else if(_fromURL.equals("52")){//系统设置
		url="/system/SystemSetEdit.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("774",user.getLanguage());
		mouldID = MouldIDConst.getID("setting");
	}else if(_fromURL.equals("53")){//选择文档属性设置
		url="/workflow/workflow/WorkflowDocPropDetail.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage());
	}else if(_fromURL.equals("54")){//模板数据对应
		url="/workflow/workflow/CreateDocumentDetailByWorkFlowEdit.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("33338",user.getLanguage());
	}else if(_fromURL.equals("56")){//新建自定义字段
		url="/docs/category/DocSecCategoryDocCustomProperties.jsp?"+request.getQueryString();
		navName=SystemEnv.getHtmlLabelNames("82,17037",user.getLanguage());
	}else if(_fromURL.equals("57")){//编辑自定义字段
		url="/docs/category/DocSecCategoryDocCustomPropertiesEdit.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("58")){//公文管理-公文交换-系统设置
		url="/docs/change/DocChangeSystemSet.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("774",user.getLanguage());
	}else if(_fromURL.equals("59")){//公文管理-公文交换-流程设置
		url="/docs/change/DocChangeSetting.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("21954",user.getLanguage());
	}else if(_fromURL.equals("60")){//公文管理-公文交换-流程设置-新建公文交換流程
		url="/docs/change/WorkflowSelect.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33481",user.getLanguage());
	}else if(_fromURL.equals("61")){//公文管理-公文交换-流程设置-交換字段設置
		url="/docs/change/DocChangeField.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33487",user.getLanguage());
	}else if(_fromURL.equals("62")){//子流程-添加触发设置
		url="/workflow/workflow/WorkflowSubwfSetAdd.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("workflow");
		navName = SystemEnv.getHtmlLabelNames("31768",user.getLanguage());
	}else if(_fromURL.equals("63")){//子流程-主子流程意见查看设置
		url="/workflow/workflow/WorkflowSubwfSetAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33503",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("64")){//子流程-子流程详细设置（相同子流程）
		url="/workflow/workflow/WorkflowSubwfSetDetail.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33504",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("65")){//子流程-子流程详细设置（不同子流程）
		url="/workflow/workflow/WorkflowTriDiffWfSubWf.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("31829",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("66")){//子流程-子流程详细设置（不同子流程）-具体设置
		url="/workflow/workflow/WorkflowTriDiffWfSubWfField.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33504",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("67")){//字段联动-添加触发设置
		url="/workflow/workflow/fieldTriggerEntry.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("21848,33508",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("68")){//流程转日程
		url="/workflow/workflow/WorkplanAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33526",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("69")){//流程转日程-详细设置
		url="/workflow/workflow/CreateWorkplanByWorkflowDetail.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("24086,19342",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("70")){//公文交换-发送公文
		url="/docs/change/SendDoc.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("23024",user.getLanguage());
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("71")){//公文交换-接收公文
		url="/docs/change/ReceiveDoc.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("23083",user.getLanguage());
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("72")){//回复文档
		url="/docs/docs/DocReply.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("73")){//接收公文-流程配置
		url="/docs/change/WorkflowFieldConfig.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33569,724",user.getLanguage());
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("74")){//拒收/退回公文
		url="/docs/change/DocReject.jsp?"+request.getQueryString();
		String src = Util.null2String(request.getParameter("src"));
		if(src.equals("reject")){
			navName = SystemEnv.getHtmlLabelNames("33424,23048",user.getLanguage());
		}else if(src.equals("back")){
			navName = SystemEnv.getHtmlLabelNames("33424,236",user.getLanguage());
		}
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("75")){//文档审批详细设置
		url="/docs/category/DocSecCategoryApproveWfDetailEdit.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("19342",user.getLanguage());
	}else if(_fromURL.equals("76")){//新建公文流程
		url="/workflow/workflow/newOfficalWf.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("23167",user.getLanguage());
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("77")){//过程定义
		url="/workflow/workflow/processList.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33688",user.getLanguage());
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("78")){//新建/编辑过程定义
		url="/workflow/workflow/addProcess.jsp?"+request.getQueryString();
		int linkType = Util.getIntValue(kv.get("linktype"),1);
		mouldID = MouldIDConst.getID("offical");
		String id = Util.null2String(kv.get("id"));
		if(!id.equals("")){
			url="/workflow/workflow/editProcess.jsp?"+request.getQueryString();
		}
		navName = SystemEnv.getHtmlLabelNames((linkType==1?"26528":(linkType==2?"33682":"33683"))+",33691",user.getLanguage());
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("79")){//常用批示语设置
		url="/workflow/workflow/processInstSet.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("offical");
	}else if(_fromURL.equals("80")){//多语言授权设置
		url="/system/multiLangPermissionSet.jsp?"+request.getQueryString();
		mouldID = MouldIDConst.getID("setting");
		navName = SystemEnv.getHtmlLabelNames("18599,33508",user.getLanguage());
	}else if(_fromURL.equals("81")){//流程转计划任务
		url="/workflow/workflow/WorktaskAdd.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("33526",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("82")){//流程转计划任务-详细设置
		url="/workflow/workflow/CreateWorktaskByWorkflowDetail.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("22118,19342",user.getLanguage());
		mouldID = MouldIDConst.getID("workflow");
	}else if(_fromURL.equals("83")){//页面标签
		url="/systeminfo/label/ManageLabel.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("81486",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("84")){//提示信息
		url="/systeminfo/note/ManageNote.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("24960",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("85")){//错误信息
		url="/systeminfo/errormsg/ManageErrorMsg.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("25700",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("86")){//新建页面标签
		url="/systeminfo/label/AddLabel.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("81486",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("87")){//编辑页面标签
		url="/systeminfo/label/EditLabel.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("81486",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("88")){//新建提示信息
		url="/systeminfo/note/AddNote.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("24960",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("89")){//编辑提示信息
		url="/systeminfo/note/EditNote.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("24960",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("90")){//新建错误信息
		url="/systeminfo/errormsg/AddErrorMsg.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("25700",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("91")){//编辑错误信息
		url="/systeminfo/errormsg/EditErrorMsg.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("25700",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("92")){//模板内容设置
		url="/docs/category/ContentSetting.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("19480",user.getLanguage());
		mouldID=MouldIDConst.getID("doc");
	}else if(_fromURL.equals("93")){//订阅无权限查看的文档
		url="/docs/docsubscribe/DocSubscribe.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("32121",user.getLanguage());
		mouldID=MouldIDConst.getID("doc");
	}else if(_fromURL.equals("94")){//语言管理
		url="/systeminfo/language/managelanguage.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("82685",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("95")){//添加语言
		url="/systeminfo/language/addlanguage.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("82685",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("96")){//编辑语言
		url="/systeminfo/language/editlanguage.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("82685",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("97")){//导入页面标签
		url="/systeminfo/label/importLabel.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("81486,32935",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("98")){//导入提示信息
		url="/systeminfo/note/importNote.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("24960,32935",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("99")){//导入错误信息
		url="/systeminfo/errormsg/importErrorMsg.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("25700,32935",user.getLanguage());
		mouldID=MouldIDConst.getID("setting");
	}else if(_fromURL.equals("100")){//文档目录导入...
		navName = SystemEnv.getHtmlLabelNames("16398,18596",user.getLanguage());
		url="/docs/category/SecCategoryImport.jsp?"+request.getQueryString();
	}else if(_fromURL.equals("1101")){//pdf设置
		url="/workflow/workflow/TextToPdf.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("126326,68",user.getLanguage());
		mouldID=MouldIDConst.getID("offical");
	}else if(_fromURL.equals("1102")){//编辑pdf设置
		url="/workflow/workflow/TextToPdfEdit.jsp?hasTab=1&"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("126326,68",user.getLanguage());
		mouldID=MouldIDConst.getID("offical");
	}else if(_fromURL.equals("1103")){
		url = "/docs/docs/docVersionsList.jsp?"+request.getQueryString();
		navName = SystemEnv.getHtmlLabelNames("16384",user.getLanguage());
		mouldID=MouldIDConst.getID("offical");
	}

	
%>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= mouldID%>",
        staticOnLoad:true,
        objName:"<%=navName%>",
        <%if(_fromURL.equals("15")||_fromURL.equals("49")||_fromURL.equals("58")){%>
        notRefreshIfrm:true,
        <%}%>
        ifrmCallback:<%=callback.equals("")?null:callback%>
    });
 
 }); 
 
</script>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
		    <ul class="tab_menu">
		    	<%if(_fromURL.equals("11")){ %>
		    		<li class="current">
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=1&from=tab&id=<%=kv.get("id") %>" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(21945,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li>
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=2&from=tab&id=<%=kv.get("id") %>" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
		        	</a>
		        </li>
		         <li>
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=3&from=tab&id=<%=kv.get("id") %>" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())+SystemEnv.getHtmlLabelName(385,user.getLanguage()) %>
		        	</a>
		        </li>
		        <li>
		        	<a href="/docs/category/DocSecCategoryRightEdit.jsp?_fromURL=4&from=tab&id=<%=kv.get("id") %>" target="tabcontentframe">
		        		<%=SystemEnv.getHtmlLabelName(15059,user.getLanguage()) %>
		        	</a>
		        </li>
		    	<%}else if(_fromURL.equals("15")){%>
		    		<li class="current">
			        	<a href="#" id="baseInfoTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>
			        	</a>
			        </li>
			         <li>
			        	<a href="#"  id="contentInfoTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="showInfoTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(30747,user.getLanguage()) %>
			        	</a>
			        </li>
		    	<%}else if(_fromURL.equals("49")){%>
		    		<li class="current">
			        	<a href="#" id="wfBaseInfoTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(19103,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfTaoHongTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(33316,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfEditMouldTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelNames("16449,30747",user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfDocPropTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfSignatureTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(16473,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfPrintTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(20756,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfTraceTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(33317,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfActionTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(33085,user.getLanguage())%>
			        	</a>
			        </li>
					 <li>
			        	<a href="#" id="wfPDFTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(125964,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="wfProcessTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelNames("33733,33508",user.getLanguage())%>
			        	</a>
			        </li>
					<li>
						<a href="#" id="wfTracePropTab" onclick="return false;">
							<%=SystemEnv.getHtmlLabelName(129067,user.getLanguage())%>
						</a>
					</li>
		    	<%} else if(_fromURL.equals("58")){%>
		    		<li class="current">
			        	<a href="#" id="ftpInfoTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="exchangeInfoTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(23098,user.getLanguage())%>
			        	</a>
			        </li>
		    	<%} else if(_fromURL.equals("77")){/*过程定义*/%>
		    		<li class="current"><!-- 发文环节 -->
			        	<a href="/workflow/workflow/processList.jsp?linktype=1" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("26528,33691",user.getLanguage())%>
			        	</a>
			        </li>
			        <li><!-- 签报环节 -->
			        	<a href="/workflow/workflow/processList.jsp?linktype=3" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("33683,33691",user.getLanguage())%>
			        	</a>
			        </li>
			        <li><!-- 收文环节 -->
			        	<a href="/workflow/workflow/processList.jsp?linktype=2" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelNames("33682,33691",user.getLanguage())%>
			        	</a>
			        </li>
		    	<%} else if(_fromURL.equals("70")){%>
		    		<li class="current">
			        	<a href="#" id="unSendTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(22347,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="sentTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(19558,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="rejectTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(22946,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="returnTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(21983,user.getLanguage())%>
			        	</a>
			        </li>
		    	<%} else if(_fromURL.equals("71")){%>
		    		<li class="current">
			        	<a href="#" id="unSendTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(23079,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="sentTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(23078,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="rejectTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(33566,user.getLanguage())%>
			        	</a>
			        </li>
			        <li>
			        	<a href="#" id="returnTab" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(33567,user.getLanguage())%>
			        	</a>
			        </li>
		    	<%}else{ %>
			        <li class="defaultTab">
			        	<a href="#" target="tabcontentframe">
			        		<%=TimeUtil.getCurrentTimeString() %>
			        	</a>
			        </li>
			    <%} %>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="try{update();}catch(e){if(window.console)console.log(e,'/docs/tabs/DocCommonTab.jsp');}" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

