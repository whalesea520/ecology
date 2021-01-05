<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.DesUtil"%>
<%@ page import="org.json.JSONObject" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page" />
<jsp:useBean id="CptCardGroupComInfo" class="weaver.cpt.util.CptCardGroupComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//附件上传所需
DesUtil desUtilitem = new DesUtil();
String udesid=desUtilitem.encrypt(user.getUID()+"");
String utype=user.getLogintype();

if(!HrmUserVarify.checkUserRight("Cpt:LabelPrint", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String operation = Util.null2String(request.getParameter("operation"));
%>
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>

<script>
   window.top.udesid='<%=udesid%>';
   window.top.utype='<%=utype%>';
   window.top.imguploadurl="/docs/docs/DocImgUploadOnly.jsp?userid="+window.top.udesid+"&usertype="+window.top.utype;
</script>  

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
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
<!--图片上传插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorextend_wev8.css" rel="stylesheet" />
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent); 
var parentWin = parent.parent.getParentWindow(parent);
var ue;
jQuery(document).ready(function(){

	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;

	ue = UE.getEditor('mouldtext',{
	  toolbars:window.UEDITOR_CONFIG.docmoduletoolbars,
	  initialFrameHeight:418,
	  initialFrameWidth:650
	});

});
if("<%=isclose%>"=="1"){
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}
</script>
</head>
<%
    int id = -1;
	int subcompanyid = -1;
    String mouldtext="";
    rs.executeSql("select * from CPT_PRINT_Mould where id=-1");
    if (rs.next()){
        mouldtext=rs.getString("mouldtext");
    }

	int operatelevel=0;
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(16450,user.getLanguage());
String needfav ="1";
String needhelp ="";
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
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" />
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">

	<div id="texteditoritem" style="width:100%;margin-left:176px;">
			<%
				int oldpicnum = 0;
				int pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload");    

				while(pos!=-1){    
					 try {
					   
							pos = mouldtext.indexOf("?fileid=",pos);
							if(pos == -1) {
								pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
								continue ;
							}
							int endpos = mouldtext.indexOf("\"",pos);
							String tmpid = mouldtext.substring(pos+8,endpos);

						%>
						<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
						<%
							pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",endpos);
							oldpicnum += 1;    
					}catch(Exception ex){        
						new weaver.general.BaseBean().writeLog(ex);   
						pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
						continue ;
					}
				}

				%>
				<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
			<textarea name="mouldtext" id="mouldtext" style="width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>
		</div>
		<div id='tdfieldlist' style="top:0px;position:absolute;float:left;width:176px;height:498px;">
			<div style="width:100%;text-align:left;display:none;">
					<%=SystemEnv.getHtmlLabelName(32871,user.getLanguage())%>
			</div>
			<div id="outcontainer"  class="labellist" style="overflow:hidden;">
			<div id="innercontainer">
				<ul id="labellist-1" name="labellist-1" style="border:none;width:100%;">
                    <li  title="" style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></li>
					<li _value="#[1d-barcode]" title="<%=SystemEnv.getHtmlLabelNames("126575",user.getLanguage())%>"><%=SystemEnv.getHtmlLabelNames("126575",user.getLanguage())%></li>
					<li _value="#[2d-barcode]" title="<%=SystemEnv.getHtmlLabelNames("126576",user.getLanguage())%>"><%=SystemEnv.getHtmlLabelNames("126576", user.getLanguage())%></li>



                        <%
                            int fieldcount=0;//用来定位插图片
                            String needHideField=",";//用来隐藏字段

                            TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap();
                            CptCardGroupComInfo.setTofirstRow();
                            while(CptCardGroupComInfo.next()){
                                String groupid=CptCardGroupComInfo.getGroupid();
                                TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
                                if(openfieldMap==null||openfieldMap.size()==0){
                                    continue;
                                }
                                int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);

                        %>
                        <li  title="" style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%></li>


                            <%
                                if(!openfieldMap.isEmpty()){
                                    Iterator it=openfieldMap.entrySet().iterator();
                                    while(it.hasNext()){
                                        Map.Entry<String,JSONObject> entry=(Map.Entry<String,JSONObject>)it.next();
                                        String k= entry.getKey();
                                        JSONObject v= entry.getValue();
                                        int fieldlabel=v.getInt("fieldlabel");
                                        String fieldName=v.getString("fieldname");


                                        if("barcode".equalsIgnoreCase(fieldName)){
                                            continue;
                                        }
                                        fieldcount++;

                            %>
                            <li _value="<%="#["+fieldName+"]" %>" title="<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></li>
                            <%



                                    }
                                }

                            %>
                        <%
                            }
                        %>





				</ul>
		</div>
			</div>
		</div>
<input type=hidden name=operation id="operation">
<input type=hidden name=id value="<%=id%>" id="id">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
</form>
<script type="text/javascript">


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
	jQuery("#tdfieldlist").height(winH-jQuery("#baseInfo").height());
	jQuery("#tdfieldlist").css("top",jQuery("#baseInfo").height()+"px");
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
	
	var oEditor = CKEDITOR.instances.mouldtext;
	oEditor.execCommand("source");
}

jQuery(document).ready(function(){
	jQuery("#labellist-1").find("li").bind("click",function(){
		 cool_webcontrollabel(this);
	}).bind("selectstart",function(){return false;});
});

//往左边Fck编辑框里加一个字段显示名
function cool_webcontrollabel(obj){
    var fckHtml = ue.getContent();
	var html = jQuery(obj).attr("_value");
	/*if(fckHtml.indexOf(html) != -1){
		return;
	}*/
	var labelhtml = html;
	 ue.execCommand('inserthtml', labelhtml);
}
function onSave(){
	if(check_form(document.weaver,'')){
		var editor_data = ue.getContent();
        document.weaver.operation.value="edit";
		document.weaver.submit();
	}
}


function openHelp(){
    window.open('tag_help.jsp',null,'height=600,width=500,scrollbar=true')
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