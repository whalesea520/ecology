
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(24266, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	int id = Util.getIntValue(request.getParameter("id"));
	String signName = "";
	String signDesc = "";
	String signContent = "";
	String signType ="";
	String isActive="";
	String showTop = Util.null2String(request.getParameter("showTop"));
	
	String sql = "select * from MailSign where id="+id;
	rs.executeSql(sql);
	if(rs.next()){
		signName = rs.getString("signName");
		signDesc = rs.getString("signDesc");
		signType = rs.getString("signType");
		signContent = rs.getString("signContent");
		isActive = Util.null2String(rs.getString("isActive"),"");
	/* 	rs1.execute("select id ,isfileattrachment,fileContentId from MailResourceFile where signid="+id+" and isfileattrachment=0");
		while(rs1.next()){ 
		    String isfileattrachment = rs1.getString("isfileattrachment");
		    String imgId = rs1.getString("id");
		    String thecontentid = rs1.getString("fileContentId");
		    String oldsrc = "cid:" + thecontentid ;
		    String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId;
		    if(signContent.indexOf(oldsrc)!= -1){
		        signContent = signContent.replace(oldsrc,newsrc);
		    }
		                        
		} */
	}
%>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<%@ include file="/cowork/uploader.jsp" %>
<jsp:include page="MailUtil.jsp"></jsp:include>
<script language="javascript" type="text/javascript">
var lang=<%=(user.getLanguage() == 8) ? "true" : "false"%>;

jQuery(document).ready(function(){
	<%if("0".equals(signType)) { %>
		highEditor("signContent");
	<%}%>
});

function doSubmit(){
	if(check_form(fMailSign,'signName')){
	with(document.getElementById("fMailSign")){
		<%if("0".equals(signType)) { %>
			changeImgToEmail("signContent");
			var remarkValue=getRemarkHtml("signContent");
			$("textarea[name=signContent]").val(remarkValue);
		<%}else{%>
			updateIndexs();
		<%}%>
		submit();
	}}
}

function addIconCallback(url){
	jQuery('#headimg').attr('src', url);
	jQuery('#headimghid').val(url);
    dialog.close();
}

</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSubmit(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<html>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(24266,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailSignOperation.jsp" id="fMailSign" name="fMailSign">
<input type="hidden" name="operation" value="update" />
<input type="hidden" name="id" value="<%=id %>" />
<input type="hidden" name="signType" value="<%=signType%>" />
<input type="hidden" id="headimghid" name="headimg" value="<%=request.getParameter("headimg")%>" />
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item><%=SystemEnv.getHtmlLabelName(20148, user.getLanguage())%><!-- 签名 --></wea:item>
		<wea:item>
			<wea:required id="signNameSpan" required="true" value='<%=signName %>'>
				<input type="text" name="signName" class="inputstyle" style="width: 30%" 
					onChange="checkinput('signName','signNameSpan')" value="<%=signName %>"/>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("20148,63",user.getLanguage())%></wea:item>
		<wea:item>
			<span style="float:left;margin-right:10px;">
				<SELECT  class=InputStyle name="signType" disabled="disabled" id="signType"  style="width: 120px;" onchange="selectSignType(this)">
				  	  <option value="0" <%if("0".equals(signType))out.println("selected='selected'"); %>><%=SystemEnv.getHtmlLabelNames("608,20148",user.getLanguage()) %></option>
					  <option value="1" <%if("1".equals(signType))out.println("selected='selected'"); %>><%=SystemEnv.getHtmlLabelNames("83063,20148",user.getLanguage()) %></option>
				</SELECT>
			</span>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(83064, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" <%if("1".equals(isActive))out.print("checked=true"); %> tzCheckbox="true" name="isActive" id="isActive" value="1" class="inputstyle" />
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="signDesc" class="inputstyle" style="width:30%" value="<%=signDesc %>"/>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></wea:item> 
		<wea:item>
		<%if("1".equals(signType)) {%>
			 <div style='position:relative;height: 320px; <%if("0".equals(signType)) { out.print("display:none;");}%>"' >
				<jsp:include page="/email/new/MailEleSign.jsp" flush="true">     
     				<jsp:param name="userid" value="<%=user.getUID() %>"/> 
     				<jsp:param name="signid" value="<%=id %>"/> 
     				<jsp:param name="isedit" value="1" />
				</jsp:include> 
			</div>
			<%} else{%>
			 <div style="width:98%; <%if("1".equals(signType)) { out.print("display:none;");}%>" >
			 	<textarea id="signContent" _editorid="signContent" _editorName="signContent" style="width:100%;height:250px;border:1px solid #C7C7C7;"><%=signContent %></textarea>
			 </div>
			 <% }%>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</html>
