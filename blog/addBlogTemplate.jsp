
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

int isSystem =Util.getIntValue(request.getParameter("isSystem"),0);
if (isSystem == 1 && !HrmUserVarify.checkUserRight("blog:templateSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(28051,user.getLanguage()); //新建模版
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));
int tempid=Util.getIntValue(request.getParameter("tempid"),0);


String tempName="";
String tempDesc = "";
String isUsed="1";
String tempContent="";

String sqlstr="select * from blog_template where id="+tempid;
RecordSet.execute(sqlstr);

if(RecordSet.next()){
	tempName=RecordSet.getString("tempName");
	isUsed=RecordSet.getString("isUsed");
	tempContent=RecordSet.getString("tempContent");
	tempDesc =RecordSet.getString("tempDesc");
}


%>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	
	<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
	<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
	<script type="text/javascript" charset="utf-8" src="/weaverEditor/kindeditor-Lang_wev8.js"></script>
	
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
  </head>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:490px;">
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform">
    <input type="hidden" value="addTemp" name="operation"/> 
    <input type="hidden" value="<%=tempid%>" name="tempid"/>
    <input type="hidden" value="<%=isSystem%>" name="isSystem"/>
   
    <wea:layout>
    	<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="tempNamespan" required="true">
					<input type="text" style="width: 60%"  maxlength="50" id="tempName" value="<%=tempName%>" name="tempName" 
						onChange="checkinput('tempName','tempNamespan')" />
				</wea:required>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" style="width: 60%"  maxlength="200" id="tempDesc" value="<%=tempDesc%>" name="tempDesc" />
			</wea:item>
		
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<input tzCheckbox="true" type="checkbox" name="isUsed" <%if(isUsed.equals("1")){%>checked="checked"<%}%> value="1" />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(28053,user.getLanguage())%></wea:item>
			<wea:item>
				<textarea style="height: 150px;width: 100%" name="tempContent" id="tempContent"><%=tempContent%></textarea>
			</wea:item>
    	</wea:group>
    </wea:layout>
</form>  
</div>

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
</body>
 <script type="text/javascript">
  jQuery(document).ready(function(){
       highEditor("tempContent",300);
  });
  function doSave(){
   if(check_form(mainform,"tempName")){
   	 jQuery("#tempContent").val(KE.html("tempContent"));
     jQuery("#mainform").submit();
   }  
  }
  
   /*高级编辑器*/
	function highEditor(remarkid,height){
	    height=!height||height<150?150:height;
	    if(jQuery("#"+remarkid).is(":visible")){
			
			var  items=[
							'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
							'formatblock', 'fontname', 'fontsize',  'forecolor', 'bold','italic',  'strikethrough', 'image', 'table'
					   ];
				 
		    K.createEditor({
						id : remarkid,
						height :height+'px',
						width:'600px',
						resizeType:1,
						uploadJson : '/kindeditor/jsp/upload_json.jsp',
					    allowFileManager : false,
		                newlineTag:'br',
		                filterMode:false,
		                langType:KE.util.getLangType(languageid), 
		                imageTabIndex:1,
		                items : items,
					    afterCreate : function(id) {
							//KE.util.focus(id);
							this.focus();
					    }
		    });
		    //KE.create(remarkid);
		}
	}
 jQuery(document).ready(function(){
 	 checkinput('tempName','tempNamespan');
	 jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   	jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
}); 
 </script>
</html>
