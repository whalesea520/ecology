
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%

if (!HrmUserVarify.checkUserRight("blog:baseSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(26760,user.getLanguage()); //微博基本设置
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String allowRequest="";   //允许关注申请
String enableDate="";     //微博启用时间
String isSingRemind="";   //签到提交提醒
String isManagerScore=""; //启用上级评分
String allowExport = ""; //允许导出微博
String isSendBlogNote= "";//将选中内容发送至微博便签
String attachmentDir="";  //微博附件上传目录
String pathcategory = "";
String isAttachment="0";
String makeUpTime="";  //可补交时间
String canEditTime="";  //可编辑时间

String sqlstr="select * from blog_sysSetting";
RecordSet.execute(sqlstr);
RecordSet.next();

allowRequest=RecordSet.getString("allowRequest");
enableDate=RecordSet.getString("enableDate");
isSingRemind=RecordSet.getString("isSingRemind");
isManagerScore=RecordSet.getString("isManagerScore");
attachmentDir=RecordSet.getString("attachmentDir");
allowExport=RecordSet.getString("allowExport");
isSendBlogNote = RecordSet.getString("isSendBlogNote");
makeUpTime = RecordSet.getString("makeUpTime");
canEditTime = RecordSet.getString("canEditTime");

if(attachmentDir!=null&&!attachmentDir.equals("")){
    String attachmentDirs[]=null;
    if(attachmentDir.indexOf("|")!=-1){
    	attachmentDirs = Util.TokenizerString2(attachmentDir,"|");
    	pathcategory = SecCategoryComInfo.getAllParentName(attachmentDirs[2],true);
    }else{
    	attachmentDirs = Util.TokenizerString2(attachmentDir,",");
    	pathcategory = SecCategoryComInfo.getAllParentName(attachmentDir,true);
    }
}
	
RecordSet.execute("select isActive from blog_app WHERE appType='attachment'");
if(RecordSet.next())
	isAttachment=RecordSet.getString("isActive");
%>
<!DOCTYPE HTML>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <script language="javascript"  defer="defer" src="/js/weaver_wev8.js"></script>
    <script language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
	<script language="javascript"  src="/js/selectDateTime_wev8.js"></script>
	<script language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(26760,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form action="BlogSettingOperation.jsp" method="post"  id="mainform">
<input type="hidden" value="editBaseSetting" name="operation"/> 
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())+SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></wea:item> <!-- 允许申请关注 -->
		<wea:item>
			<input type="checkbox" tzCheckbox="true" <%=allowRequest.equals("1")?"checked=checked":""%> name="allowRequest"  value="1" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(1046,user.getLanguage())%></wea:item> <!-- 微博启用时间 -->
		<wea:item>
			<BUTTON type="button" class=calendar  onclick="onShowDate(enableDatespan,enableDate)"></BUTTON> 
			<input type="hidden"  name="enableDate" id="enableDate" value=<%=enableDate%>>
			<SPAN id=enableDatespan style="font-weight:normal !important;color:#000000 !important;"><%=enableDate%></SPAN>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(27033,user.getLanguage())%></wea:item> <!-- 启用签到提醒 -->
		<wea:item>
			<input type="checkbox" tzCheckbox="true" <%=isSingRemind.equals("1")?"checked=checked":""%> name="isSingRemind"  value="1" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31562,user.getLanguage())%></wea:item> <!-- 启用上级评分 -->
		<wea:item>
			<input type="checkbox" tzCheckbox="true"  <%=isManagerScore.equals("1")?"checked=checked":""%> name="isManagerScore"  value="1" />
		</wea:item>
		<!-- 导出微博 -->
		<!-- 
			<%=SystemEnv.getHtmlLabelNames("17416,28420",user.getLanguage())%>
			<input type="checkbox" tzCheckbox="true"  <%=allowExport.equals("1")?"checked=checked":""%> name="allowExport"  value="1" />
		-->
		 
		<wea:item><%=SystemEnv.getHtmlLabelName(83154,user.getLanguage())%></wea:item> <!-- 将选中内容发送到微博便签 -->
		<wea:item>
			<input type="checkbox" tzCheckbox="true"  <%=isSendBlogNote.equals("1")?"checked=checked":""%> name="isSendBlogNote"  value="1" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(22210,user.getLanguage())%></wea:item> <!-- 附件上传目录 -->
		<wea:item>
			 <brow:browser viewType="0" name="attachmentDir" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
	         browserValue='<%=attachmentDir %>' idKey="id" nameKey="path"
	         browserSpanValue = '<%=pathcategory%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput="2" 
	         completeUrl="/data.jsp?type=categoryBrowser" width="50%" ></brow:browser>
		</wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(129963,user.getLanguage())%></wea:item> <!-- 微博可补交时间 -->
        <wea:item>
            <wea:required id="makeUpTimeSpan" required="false" >
                <input type="text" id="makeUpTime" name="makeUpTime" value="<%=makeUpTime %>"  onKeyPress="ItemPlusCount_KeyPress()" 
                    class="InputStyle" style="width: 100px;" />
                <%=SystemEnv.getHtmlLabelName(1925, user.getLanguage())%>
                
                &nbsp;&nbsp;&nbsp;&nbsp;
                <%=SystemEnv.getHtmlLabelName(131715, user.getLanguage())%>
                <!-- 说明：1、不设置为不限制补交时间; 2、0表示不能补交; 3、正数表示可补交天数（自然日）; -->
            </wea:required>
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(129964,user.getLanguage())%></wea:item> <!-- 微博可编辑时间 -->
        <wea:item>
            <wea:required id="canEditTimeSpan" required="false" >
                <input type="text" id="canEditTime" name="canEditTime" value="<%=canEditTime %>" onKeyPress="ItemPlusCount_KeyPress()" 
                    class="InputStyle" style="width: 100px;" />
                <%=SystemEnv.getHtmlLabelName(1925, user.getLanguage())%>
                
                &nbsp;&nbsp;&nbsp;&nbsp;
                <%=SystemEnv.getHtmlLabelName(129966, user.getLanguage())%>
                <!-- 说明：1、不设置为不限制修改时间; 2、0表示不能修改; 3、正数表示可修改天数（从微博提交时间算起）; -->
            </wea:required>
        </wea:item>
	</wea:group>
</wea:layout>
</form>  
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>

<script type="text/javascript">
	function doSave() {
		if (jQuery("#enableDate").val() == "") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())+SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(1046,user.getLanguage())%>");
			return;
		}

		if ("<%=isAttachment%>" == "1" && jQuery("#attachmentDir").val() == "") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25449,user.getLanguage())%>！");
			return;
		};
        
        if(!check_blogtime('makeUpTime')){
            top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("129963,27685",user.getLanguage())%>');
            return;
        }
        
        if(!check_blogtime('canEditTime')) {
    		top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("129964,27685",user.getLanguage())%>');
            return;
        }
        
        jQuery("#mainform").submit();
	}
    
    function check_blogtime(objectname) {
        var obj = document.getElementById(objectname);
        return obj.value == undefined || obj.value == '' || !checkPlusnumber1(obj);
    }

	function onShowCatalog() {
		var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
		if (result != null) {
			if (wuiUtil.getJsonValueByIndex(result, 0) > 0) {
				jQuery("#mypathspan").html(wuiUtil.getJsonValueByIndex(result, 2));
				//result[2] 路径字符串   result[3] maincategory result[4] subcategory  result[1] seccategory
				jQuery("#attachmentDir").val(wuiUtil.getJsonValueByIndex(result, 3) + "|" + wuiUtil.getJsonValueByIndex(result, 4) + "|" + wuiUtil.getJsonValueByIndex(result, 1));
			} else {
				if ("<%=isAttachment%>" == "1") jQuery("#mypathspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				else jQuery("#mypathspan").html("");
				jQuery("#attachmentDir").val("");
			}
		}
	}

	jQuery(document).ready(function() {
		jQuery("input[type=checkbox]").each(function() {
			if (jQuery(this).attr("tzCheckbox") == "true") {
				jQuery(this).tzCheckbox({
					labels: ['', '']
				});
			}
		});
        
        //checkinput('makeUpTime','makeUpTimeSpan');
        //checkinput('canEditTime','canEditTimeSpan');
	});
</script>
</html>
