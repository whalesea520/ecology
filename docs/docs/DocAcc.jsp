
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />	
<script type="text/javascript" src="/js/doc/upload_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%

String docid = Util.null2String(request.getParameter("docid"));
DocManager.resetParameter();
DocManager.setId(Util.getIntValue(docid));
DocManager.getDocInfoById();
String agent = request.getHeader("user-agent");
boolean isChrome=false;
if(agent.contains(" Chrome")){
	isChrome=true;
}

int isHistory = DocManager.getIsHistory();
boolean canDel = Util.null2String(request.getParameter("canDel")).equals("true");
boolean canDownload = Util.null2String(request.getParameter("canDownload")).equals("true");
int votingId=Util.getIntValue(request.getParameter("votingId"),0); 
int meetingid=Util.getIntValue(request.getParameter("meetingid"),0); 
String mode = Util.null2String(request.getParameter("mode"));
String secid = Util.null2String(request.getParameter("secid"));
if(!"".equals(docid)){
	secid = DocComInfo.getDocSecId(docid);
}

boolean hasRight=false;

if(mode.equals("view")&&!docid.equals("")){
	String sessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
	String right_view=(String)session.getAttribute("right_view_"+sessionPara);
	if("1".equals(right_view)){
		hasRight=true;
	}
}

if(mode.equals("add")&&!secid.equals("")){
	String sessionPara=""+secid+"_"+user.getUID()+"_"+user.getLogintype();
	String right_add=(String)session.getAttribute("right_add_"+sessionPara);
	if("1".equals(right_add)){
		hasRight=true;
	}
}

if(mode.equals("edit")&&!secid.equals("")){
	String sessionPara=""+docid+"_"+user.getUID()+"_"+user.getLogintype();
	String right_edit=(String)session.getAttribute("right_edit_"+sessionPara);
	if("1".equals(right_edit)){
		hasRight=true;
	}
}

if(!hasRight){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}


%>
<script type="text/javascript">
	var votingId="<%=votingId%>";
   var checkimageid="";
	function downloadDocImgsSingle(id){
		if(checkimageid!=""){
		  id=checkimageid;
		}
		downloadDocImgs("<%=docid%>",{id:id,votingId:votingId,_window:parent,downloadBatch:0,emptyMsg:"<%=SystemEnv.getHtmlLabelName(31033,user.getLanguage())%>"});
	    checkimageid="";
	}
	function openTip(flag){
		var dialog = new window.top.Dialog();
		var url="/wui/common/page/sysRemindfordoc.jsp";
		if(flag==1){
			url="/wui/common/page/sysRemindfordoc.jsp?labelid=129755";
		}else if(flag==2){
			url="/wui/common/page/sysRemindfordoc.jsp?labelid=129757";
		}
		dialog.currentWindow = window; 
		dialog.URL = url;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>";
		dialog.Width = 850;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.show();
	}	
	function doExtDocEdit(id,otherpara){
		var otherparas=otherpara.split("+");
		var docid=otherparas[0];
		var versionId=otherparas[1];
		var imagefileId=otherparas[2];
		openFullWindowForXtable("DocEditExt.jsp?id="+docid+"&versionId="+versionId+"&imagefileId="+imagefileId+"&isFromAccessory=true");
	}

	function downloadDocImgsVersion(id,params,obj){
		
		jQuery("#selectVersionBtn").attr("data-imgid",id);
		jQuery("#selectVersionBtn").trigger("click");
		
		
	}
	
	function used4SelectAccVersion(versionId){
		jQuery("#selectAccVersionBtn").attr("data-imgid",versionId);
		jQuery("#selectAccVersionBtn").trigger("click");	
	}
	
	function getBrowserUrl4selectAccVersion(){
		return "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/listVersion.jsp?versionId="+jQuery("#selectAccVersionBtn").attr("data-imgid")+"&docid=<%=docid%>"+"&canDel=<%=canDel%>"+"&canDownload=<%=canDownload%>";	
	}
	
	function afterSelectAccVersion(e,datas,params,name){
		if(datas){			
			if(datas.id!=""){
				parent.window.location="DocDspExt.jsp?id=<%=docid%>&versionId="+datas.id+"&isFromAccessory=true&votingId=<%=votingId%>";
			}
		}	
	}
	function delImage(id){
		var _window = parent;
		if(!_window)_window=window;
		var _document = _window.document;
		var accCount = parseInt(jQuery("#accCount",_document).text());
		if(!accCount){
			accCount=0;
		}
		jQuery.ajax({
					url:"/docs/docs/DocImgsUtil.jsp?method=delImgsOnly&docid=<%=docid%>&delImgIds="+id,
					type:"get",
					beforeSend:function(){
						e8showAjaxTips(SystemEnv.getHtmlNoteName(3513,readCookie("languageidweaver")),true);
					},
					complete:function(){
						e8showAjaxTips("",false);
						if(id && id.match(/,$/)){
							id = id.substring(0,id.length-1);
						}
						var _ids = id.split(",");
						accCount = accCount - _ids.length;
						if(accCount<0)accCount = 0;
						jQuery("#accCount",_document).text(accCount);
						_table.reLoad();
					}
				});
	}
	function downloadMul(){
		var ids = _xtable_CheckedCheckboxId();
		if(!ids){
		_window.top.Dialog.alert(options.emptyMsg);
		return;
		}
		if(ids.match(/,$/)){
			ids = ids.substring(0,ids.length-1);
		}
		if(ids){
			var _ids = ids.split(",");
			for(var i = 0;i < _ids.length;i++){
				var _src = "/weaver/weaver.file.FileDownload?fileid=" + _ids[i] + "&download=1&votingId=<%=votingId%>";
				jQuery("body").append("<iframe src='"+_src+"' style='display:none' ></iframe>");
			}
		}
	}
	function getBrowserUrl(){
		return "/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/listVersion.jsp?docid=<%=docid%>&imgId="+jQuery("#selectVersionBtn").attr("data-imgid")+"&canDel=<%=canDel%>"+"&canDownload=<%=canDownload%>";
	}

	function afterSelectVersion(e,datas,params,name){		
		if(datas){			
			if(datas.id!=""){
				checkimageid=datas.id;
			}
		}
	}
</script>
<style type="text/css">
	.e8searchSpan{
		display:inline-block;
		border:1px solid #f5f2f2;
		width:90px;
		height:22px;
		text-align:left;
		line-height:22px;
	}
	
	.e8searchSpan:hover{
		border:1px solid #dadada;
	}
	
	.toolbar{
		float:right;
	}
	#DocDivAcc .ListStyle td a.titleA{
		height:30px;
		line-height:26px;
	}
	#DocDivAcc .ListStyle td span.titleSpan{
		display:inline-block;
		line-height:30px;
		height:30px;
		vertical-align:middle;
	}
	html{
		width:100%;
		overflow-x:hidden;
	}
</style>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

boolean isEditionOpen = SecCategoryComInfo.isEditionOpen(Util.getIntValue(secid));
if(!"".equals(docid)){
	secid = DocComInfo.getDocSecId(docid);
}
isEditionOpen = SecCategoryComInfo.isEditionOpen(Util.getIntValue(secid));
String pagename = Util.null2String(request.getParameter("pagename"));
String qname = Util.null2String(request.getParameter("flowTitle"));
String operation = Util.null2String(request.getParameter("operation"));
int maxUploadImageSize = Util.getIntValue(Util.null2String(request.getParameter("maxUploadImageSize")),-1);
if(maxUploadImageSize==-1){
	maxUploadImageSize = DocUtil.getMaxUploadImageSize(Util.getIntValue(secid));
}
int bacthDownloadFlag = Util.getIntValue(Util.null2String(request.getParameter("bacthDownloadFlag")),0);
String canShare = Util.null2String(request.getParameter("canShare"));
boolean canEdit = Util.null2String(request.getParameter("canEdit")).equals("true");
String isrequest = Util.null2String(request.getParameter("isrequest"));
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);

int language = user.getLanguage();

String formmode_authorize = Util.null2String(request.getParameter("formmode_authorize"));
String formmodeparamsStr = "";
if(formmode_authorize.equals("formmode_authorize")){
	int modeId = 0;
	int formmodebillId = 0;
	int fieldid = 0;
	int formModeReplyid = 0;
	modeId = Util.getIntValue(request.getParameter("authorizemodeId"),0);
	formmodebillId = Util.getIntValue(request.getParameter("authorizeformmodebillId"),0);
	fieldid = Util.getIntValue(request.getParameter("authorizefieldid"),0);
	formModeReplyid = Util.getIntValue(request.getParameter("authorizeformModeReplyid"),0);
	String fMReplyFName = Util.null2String(request.getParameter("authorizefMReplyFName"));
	
	formmodeparamsStr="+formmode_authorize:"+formmode_authorize+"+authorizemodeId:"+modeId+"+authorizeformmodebillId:"+formmodebillId+"+authorizefieldid:"+fieldid+
		"+authorizeformModeReplyid:"+formModeReplyid+"+authorizefMReplyFName:"+fMReplyFName;
	
}

String sourceParams = "docid:"+docid+"+isEditionOpen:"+isEditionOpen+"+canDownload:"+canDownload+"+showType:"+mode+"+canEdit:"+(mode.equals("add")?true:canEdit)+"+isrequest:"+isrequest+"+requestid:"+requestid+"+desrequestid:"+desrequestid+"+attachname:"+qname+"+meetingid:"+meetingid+"+votingId:"+votingId+formmodeparamsStr;
String tableString=""+
	   "<table  needPage=\"false\" datasource=\"weaver.docs.docs.DocDataSource.getDocImgList\" sourceparams=\""+sourceParams+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCIMG,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
	   "<browser returncolumn=\"name\"/>"+
	   "<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"imgid\"  sqlprimarykey=\"imgid\" sqlsortway=\"asc\"  />";
	  String operateString = "";
	  	if(canDownload){
			   operateString += "<operates width=\"20%\">";
		       operateString+=" <popedom column=\"imgid\" otherpara=\""+docid+"_"+isHistory+"_"+isIE+"_"+canEdit+"_"+canDel+"\"  transmethod=\"weaver.splitepage.operate.SpopForDoc.getImageOpt4IEEdit\"></popedom> ";
		       operateString+="     <operate otherpara=\""+docid+"+column:versionid+column:imgid\" href=\"javascript:doExtDocEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			   operateString+="     <operate href=\"javascript:downloadDocImgsSingle()\"  text=\""+SystemEnv.getHtmlLabelName(31156,user.getLanguage())+"\" index=\"1\"/>";
			   operateString+="     <operate otherpara=\"column:imgid\"  href=\"javascript:downloadDocImgsVersion()\"  text=\""+SystemEnv.getHtmlLabelName(16384,user.getLanguage())+"\" index=\"2\"/>";  
			   operateString+="     <operate href=\"javascript:delImage()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
		       operateString+="</operates>";
	  	}
		//分离改造	21006改为16384
	  	tableString += operateString;
	  	tableString += "<head>";
			if(mode.equals("edit")||mode.equals("view")){
				tableString += "<col width=\"10%\" labelid=\"22969\"  text=\""+SystemEnv.getHtmlLabelName(22969,user.getLanguage())+"\" column=\"icon\"/>";
			}
			tableString+=	 "<col width=\"50%\" labelid=\"23752\"  text=\""+SystemEnv.getHtmlLabelName(23752,user.getLanguage())+"\" column=\"name\" />";
			tableString += "<col width=\"30%\" labelid=\"19998\"  text=\""+SystemEnv.getHtmlLabelName(19998,user.getLanguage())+"\" column=\"size\"/>";
			tableString += "</head></table>";
			String options = "{mode:'"+mode+"',docid:'"+docid+"',maxUploadImageSize:'"+maxUploadImageSize+"',title:'"+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"'}";
String uploadUrl="/docs/docs/DocUploadCommNew.jsp?isAutoStart=1&mode=" +mode+"&docid="+docid+"&maxUploadImageSize="+maxUploadImageSize;
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCIMG %>"/>
	 <brow:browser name="versionId" viewType="0" display="none"  browserBtnID="selectVersionBtn" getBrowserUrlFn="getBrowserUrl"  isMustInput="1"  _callback="afterSelectVersion"/>
	 <brow:browser name="_selectAccVersionBtn" viewType="0" display="none"  browserBtnID="selectAccVersionBtn" getBrowserUrlFn="getBrowserUrl4selectAccVersion"  isMustInput="1"  _callback="afterSelectAccVersion"/>
<form name="searchFrm" id="searchFrm">
	<input type="hidden" name="mode" id="mode" value="<%=mode %>">
	<input type="hidden" name="docid" id="docid" value="<%=docid %>">
	<input type="hidden" name="secid" id="secid" value="<%=secid %>">
	<input type="hidden" name="pagename" id="pagename" value="<%=pagename %>">
	<input type="hidden" name="operation" id="operation" value="<%=operation %>">
	<input type="hidden" name="maxUploadImageSize" id="maxUploadImageSize" value="<%=mode %>">
	<input type="hidden" name="bacthDownloadFlag" id="bacthDownloadFlag" value="<%=bacthDownloadFlag %>">
	<input type="hidden" name="canShare" id="canShare" value="<%=mode %>">
	<input type="hidden" name="canDownload" id="canDownload" value="<%=canDownload %>">
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21704,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
			<wea:item type="groupHead">
				<span class="noHide">
					<%if(mode.equals("view")){ %>
						<span id="searchSpan" class="e8searchSpan" style="float:left;margin-right:10px;">
							<span>
							<input type="text" style="width:68px;height:19px;" class="searchInput" name="flowTitle"  value="<%=qname %>"></input>
							</span>
							<span class="e8searchImg">
								<img onclick="javascript:jQuery('#searchFrm').submit();" src="/images/ecology8/request/search-input_wev8.png" style="vertical-align:middle;"/>
							</span>
						</span>
					<%} %>
					<%if(!(maxUploadImageSize==0||mode.equals("view"))){%>
						<%--<input onclick="loadUploadSrc(<%=options%>)" type="button" class="addbtn" title="<%=SystemEnv.getHtmlLabelName(25838,user.getLanguage())+maxUploadImageSize+"M)"%>"></input> --%>
						<span id="uploadDiv" class="addbtn" title="<%=SystemEnv.getHtmlLabelName(25838,user.getLanguage())+maxUploadImageSize+"M)"%>" style="height:19px;margin-left:10px;position:relative;display:inline-block;float:left;margin-top:6px;" mode="<%=mode%>" docid="<%=docid%>" maxsize="<%=maxUploadImageSize%>"></span>
					<%}%>
					<span>
					<%if(!mode.equals("view")){%>
						<input onclick="removeDocImgs('<%=docid %>',{mode:'<%=mode %>',emptyMsg:'<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>',confirmMsg:'<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>',_window:parent})" type="button" class="delbtn" title="<%=SystemEnv.getHtmlLabelName(32083,user.getLanguage())%>"></input>
					<%}%>
					<%if(!isChrome&&!(mode.equals("add") || bacthDownloadFlag==1) && canDownload){%>
						<input onclick="downloadDocImgs(<%=docid %>,{emptyMsg:'<%=SystemEnv.getHtmlLabelName(31033,user.getLanguage())%>',_window:parent})" type="button" class="downloadbtn" title="<%=SystemEnv.getHtmlLabelName(32407,user.getLanguage())%>"></input>
					<%}%>
					<%if(isChrome&&!(mode.equals("add") || bacthDownloadFlag==1) && canDownload){%>
						<input onclick="downloadMul()" type="button" class="downloadbtn" title="<%=SystemEnv.getHtmlLabelName(32407,user.getLanguage())%>"></input>
					<%}%>
					</span>
				</span>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<div id="DocDivAcc" style="width:100%;height:100%;">
					<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
				</div>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<script type="text/javascript">
<%if(!(maxUploadImageSize==0||mode.equals("view"))){%>
	jQuery(document).ready(function(){
		bindUploaderDiv(jQuery("#uploadDiv"));
	});
<%}%>
</script>
<%if(!(maxUploadImageSize==0||mode.equals("view"))){%>
<%@ include file="uploader.jsp" %>
<%}%>
