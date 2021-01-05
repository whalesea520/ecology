
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.DesUtil"%>	
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
//附件上传所需
DesUtil desUtilitem = new DesUtil();
String udesid=desUtilitem.encrypt(user.getUID()+"");
String utype=user.getLogintype();

if(!HrmUserVarify.checkUserRight("DocMouldAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
if(isWorkflowDoc.equals("1")){
	response.sendRedirect("/docs/mould/DocMouldAddExt.jsp?"+request.getQueryString());
	return;
}
%>
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<script>
   window.top.udesid='<%=udesid%>';
   window.top.utype='<%=utype%>';
   window.top.imguploadurl="/docs/docs/DocImgUploadOnly.jsp?userid="+window.top.udesid+"&usertype="+window.top.utype;
</script>  
<!--
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
-->
<!--swfupload相关-->
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
 <!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorextend_wev8.css" rel="stylesheet"></link>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
<!--图片上传插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>


<script language="javascript" type="text/javascript">
var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
var ue;
jQuery(document).ready(function(){

	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
	//FCKEditorExt.initEditor('weaver','mouldtext',lang);
	//CkeditorExt.initEditor('weaver','mouldtext',lang,'',500);
	ue = UE.getEditor('mouldtext',{
	  toolbars: window.UEDITOR_CONFIG.docmoduletoolbars,
	  initialFrameHeight:418,
	  initialFrameWidth:650
	});
});

jQuery("#labellist-1").click(function(e){
     e.stopPropagation();
});

if("<%=isclose%>"=="1"){
	//parentWin.location="DocMould.jsp";
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String docType=Util.null2String(request.getParameter("docType"));
if(docType.equals("")){
    docType=".htm";
}
String  mouldname=Util.null2String(request.getParameter("mouldname"));
String docMouldExistedId=Util.null2String(request.getParameter("docMouldExistedId"));
if(docMouldExistedId==null||"0".equals(docMouldExistedId)) docMouldExistedId = "";
String docMouldExistedName = "";
String docMouldExistedText = "";
int subcompanyid = 0;
if(!docMouldExistedId.equals("")){
	MouldManager.setId(Util.getIntValue(docMouldExistedId,0));
	MouldManager.getMouldInfoById();
	docMouldExistedText = MouldManager.getMouldText();
	docMouldExistedName = MouldManager.getMouldName(); 
	subcompanyid = MouldManager.getSubcompanyid();
	MouldManager.closeStatement();
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
String needfav ="1";
String needhelp ="";
int operatelevel=0;
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
if(detachable==1){
	if(subcompanyid==0){
	String hasRightSub=String.valueOf(session.getAttribute("docdftsubcomid"));
	String hasRightSubFirst="";
	if(!hasRightSub.equals("")){
	  if(hasRightSub.indexOf(',')>-1){  
	      hasRightSubFirst=Util.null2String(hasRightSub.substring(0,hasRightSub.indexOf(',')));
        }else{
          hasRightSubFirst=hasRightSub;
        }
	 subcompanyid=Util.getIntValue(hasRightSubFirst,0);
    }
	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("showMould_subcompanyid")),subcompanyid);
	}
	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocMouldAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("DocMouldAdd:Add", user))
        operatelevel=2;
}
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content" style="overflow:hidden;">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isDialog.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:openHelp(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<wea:layout attributes="{'cw1':'176px','cw2':'*','groupOperDisplay':'none','layoutTableId':'baseInfo'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="mouldnamespan" required="true" value='<%=mouldname%>'>
				<input temptitle="<%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%>" class=InputStyle size=70 name=mouldname value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
			</wea:required>
		</wea:item>
		<wea:item attributes="{'colspan':'full','samePair':'imgfield','display':'none'}">
			<div></div>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></wea:item>
		<wea:item>
			<div >
				<input TYPE="radio" NAME="sdoctype" checked >HTML&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
				<%if("true".equals(isIE)){ %>
				<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('/docs/mould/DocMouldAddExt.jsp','.doc')">WORD&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
				<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('/docs/mould/DocMouldAddExt.jsp','.wps')"><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
				<%} %>
			</div>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19333,user.getLanguage())%></wea:item>
		<wea:item>
			<div >
				<span>
				<%String extraparam = "{'docType':'"+docType+"'}"; %>
				   <brow:browser viewType="0" name="docMouldExistedId" browserValue='<%= ""+docMouldExistedId %>' 
					_callback="afterOnShowMould"
					browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/mould/DocMouldBrowser.jsp?doctype=.htm"
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1' language='<%=""+user.getLanguage() %>'
					completeUrl="/data.jsp?type=-99996" linkUrl="#"  temptitle='<%=SystemEnv.getHtmlLabelName(19333,user.getLanguage())%>'
					browserSpanValue='<%= docMouldExistedName %>' extraParams='<%= extraparam %>'></brow:browser>
			   </span>
			</div>
		</wea:item>
		<%if(detachable==1){ %>
			<wea:item><%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
			<wea:item>
				<span>
					<brow:browser viewType="0" name="subcompanyid" browserValue='<%= ""+subcompanyid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
							hasInput='<%=operatelevel>0?"true":"false" %>' isSingle="true" hasBrowser = "true" isMustInput='<%=operatelevel>0?"2":"0" %>'
							completeUrl="/data.jsp?type=164" width="80%" temptitle='<%= SystemEnv.getHtmlLabelName(17868,user.getLanguage())%>'
							language='<%=""+user.getLanguage() %>'
							browserSpanValue='<%=subcompanyid!=0?Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid+""),user.getLanguage()):""%>'>
					</brow:browser>
				</span>
			</wea:item>
		<%}%>
	</wea:group>
</wea:layout>
		<div id="texteditoritem" style="width:100%;margin-left:176px;">
			<%
				if(!docMouldExistedId.equals("")){
					int oldpicnum = 0;
					int pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload");    
					
					while(pos!=-1){    
						 try {
								pos = docMouldExistedText.indexOf("?fileid=",pos);
								if(pos == -1) {
									pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload",pos+1);
									continue ;
								}
								int endpos = docMouldExistedText.indexOf("\"",pos);
								String tmpid = docMouldExistedText.substring(pos+8,endpos);

							%>
							<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
							<%
								pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload",endpos);
								oldpicnum += 1;    
						}catch(Exception ex){        
							pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload",pos+1);
							continue ;
						}
					}
				%>
				<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
			<% } %>
			<textarea name="mouldtext" id="mouldtext" style="width:100%;height:450px"><%=Util.encodeAnd(docMouldExistedText)%></textarea>
		</div>
		<div id='tdfieldlist' style="top:124px;position:absolute;float:left;width:176px;height:498px;">
			<div style="width:100%;text-align:left;display:none;">
					<%=SystemEnv.getHtmlLabelName(32871,user.getLanguage())%>
			</div>
			<div id="outcontainer"  class="labellist" style="overflow:hidden;">
					<div id="innercontainer">
						<ul id="labellist-1" name="labellist-1" style="border:none;width:100%;">
							<li _value="$DOC_SecCategory" title="$<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></li>
							<li _value="$DOC_Department" title="$<%=SystemEnv.getHtmlLabelName(16227,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16227,user.getLanguage())%></li>
							<li _value="$DOC_Content" title="$<%=SystemEnv.getHtmlLabelName(16228,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16228,user.getLanguage())%></li>
							<li _value="$DOC_CreatedByLink" title="$<%=SystemEnv.getHtmlLabelName(16230,user.getLanguage())%>. (full name with link).">$<%=SystemEnv.getHtmlLabelName(16230,user.getLanguage())%>. (full name with link).</li>
							<li _value="$DOC_CreatedByFull" title="$<%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%>. (full name)">$<%=SystemEnv.getHtmlLabelName(16229,user.getLanguage())%>. (full name)</li>
							<li _value="$DOC_CreatedDate" title="$<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></li>
							<li _value="$DOC_DocId" title="$<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>ID">$<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>ID</li>
							<li _value="$DOC_ModifiedDate" title="$<%=SystemEnv.getHtmlLabelName(16232,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16232,user.getLanguage())%></li>
							<li _value="$DOC_Language" title="$<%=SystemEnv.getHtmlLabelName(16233,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16233,user.getLanguage())%></li>
							<li _value="$DOC_ParentId" title="$<%=SystemEnv.getHtmlLabelName(16234,user.getLanguage())%>ID">$<%=SystemEnv.getHtmlLabelName(16234,user.getLanguage())%>ID</li>
							<li _value="$DOC_Status" title="$<%=SystemEnv.getHtmlLabelName(16235,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16235,user.getLanguage())%></li>
							<li _value="$DOC_Subject" title="$<%=SystemEnv.getHtmlLabelName(16236,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16236,user.getLanguage())%></li>
							<li _value="$DOC_Publish" title="$<%=SystemEnv.getHtmlLabelName(16237,user.getLanguage())%>">$<%=SystemEnv.getHtmlLabelName(16237,user.getLanguage())%></li>
							<li _value="$DOC_ApproveDate"  title="$<%=SystemEnv.getHtmlLabelName(1425,user.getLanguage()) %>" >$<%=SystemEnv.getHtmlLabelName(1425,user.getLanguage())%></li>
						</ul>
					</div>
			</div>
		</div>

<script language=javascript>
    function onChangeDocType(doPage,docType){	
        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18691,user.getLanguage())%>",function(){
            location=doPage+'?isdialog=<%=isDialog%>&mouldname='+document.weaver.mouldname.value+'&docType='+docType;
        },function(){
            weaver.sdoctype[0].checked=true;
		});
        return false;
    }   
</script>

<input type=hidden name=operation>
</form>

<script>

jQuery(document).ready(function(){
	window.setTimeout(function(){
		setEditorHeight(true);
	},10);
});

jQuery(window).resize(function(){
	window.setTimeout(function(){
		setEditorHeight();
	},10);
});

function setEditorHeight(isinit){
	var winH = jQuery(".zDialog_div_content").height();
	var winW = jQuery(".zDialog_div_content").width();
	jQuery("#tdfieldlist").height(winH-jQuery("#baseInfo").height()).css("top",jQuery("#baseInfo").height());
	jQuery("#outcontainer").height(winH-jQuery("#baseInfo").height());
	jQuery("#innercontainer").height(jQuery("#labellist-1").height());
	if(isinit){
		jQuery("#outcontainer").perfectScrollbar();
	}else{
		jQuery("#outcontainer").perfectScrollbar("update");
	}
	jQuery("#edui1").width(winW-jQuery("#tdfieldlist").width());
	jQuery("#edui1_iframeholder").width(winW-jQuery("#tdfieldlist").width());
	jQuery("#edui1_iframeholder").height(jQuery("#tdfieldlist").height()-jQuery("#edui1_toolbarbox").height());
}

function switchEditMode(ename){
	
	//var oEditor = CKEDITOR.instances.mouldtext;
	//oEditor.execCommand("source");
	 ue.execCommand("source");
}
var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"yes",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;

function afterOnShowMould(e,data,fieldid,params){
	if(data!=null){
		location="/docs/mould/DocMouldAdd.jsp?isdialog=<%=isDialog%>&mouldname="+document.weaver.mouldname.value+"&docMouldExistedId="+data.id;
	}
}

function onShowMould(){
	data = window.showModalDialog("DocMouldBrowser.jsp?doctype=.htm","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data!=null){
		
		document.weaver.docMouldExistedId.value = data.id
		jQuery("#docMouldExistedIdspan").html("<a href='#"+data.id+"'>"+data.name+"</a>");
		
		location="/docs/mould/DocMouldAdd.jsp?isdialog=<%=isDialog%>&mouldname="+document.weaver.mouldname.value+"&docMouldExistedId="+data.id;
	}
}

jQuery(document).ready(function(){
	jQuery("#labellist-1").find("li").bind("click",function(){
		 cool_webcontrollabel(this);
	}).bind("selectstart",function(){return false;});
});

//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
	//var fckHtml = FCKEditorExt.getHtml("newstemptext");
//	console.dir(arguments);
	//var fckHtml = CKEDITOR.instances.mouldtext.getData();
	var fckHtml = ue.getContent();
	//var html = obj.options.item(obj.selectedIndex).text;
	var html = jQuery(obj).attr("_value");
	if(fckHtml.indexOf(html) != -1){
		//obj.options.item(obj.selectedIndex).text = html+"               已添加";
		//alert("<%=SystemEnv.getHtmlLabelName(23723, user.getLanguage())%>");
		return;
	}
	//obj.options.item(obj.selectedIndex).style.color="#bfbfbf";
	
	var labelhtml = html;
	//FCKEditorExt.insertHtml(labelhtml, "mouldtext");
	//alert(obj);
	 ue.execCommand('inserthtml', labelhtml); 

}

function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid')){
		//var editor_data = CKEDITOR.instances.mouldtext.getData();
		var editor_data = ue.getContent();
		jQuery("#mouldname").val(editor_data);
		
		document.weaver.operation.value='add';
		document.weaver.submit();
	}//End if.
	
}

function openHelp(){
    window.open('/docs/mould/tag_help.jsp',"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
}
</script>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</body>
