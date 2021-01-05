
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

int userId = Util.getIntValue(request.getParameter("userid"));
if(userId==-1){
	userId = user.getUID();
}

int defaultTemplateId = -1;
String templateType = "-1";
rs.executeSql("SELECT templateType, templateId FROM MailTemplateUser WHERE userId="+user.getUID());
if(rs.next()){
	templateType = Util.null2o(rs.getString("templateType"));//0:个人模板 1:公司模板
	defaultTemplateId = rs.getInt("templateId");
}
%>

<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
    <script type="text/javascript">
        function doSubmit(){
        	var radios = document.getElementsByName("isDefault");
        	for(var i=0;i<radios.length;i++){
        		if(radios[i].checked){
        			fMailTemplate.templateType.value = radios[i].getAttribute("templateType");
        			fMailTemplate.defaultTemplateId.value = radios[i].value;
        			break;
        		}
        	}
        	document.forms[0].submit();
        }
        
        var dialog = null;
        function closeDialog(){
        	if(dialog)
        		dialog.close();
        	_table.reLoad();
        }
        
        function editInfo(id){
        	dialog = new window.top.Dialog();
        	dialog.currentWindow = window;
        	var url = "/email/MailTemplateEdit.jsp?id="+id;
        	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16218",user.getLanguage())%>";
        	dialog.Width = 800;
        	dialog.Height = 600;
        	dialog.Drag = true;
        	dialog.URL = url;
        	dialog.show();
        }
        
        function deleteInfo(id){
        	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
        		jQuery.post("/email/MailTemplateOperation.jsp",{"id":id},function(){
        			_table.reLoad();
        		});
        	});
        }
        
        function addInfo(){
        	dialog = new window.top.Dialog();
        	dialog.currentWindow = window;
        	var url = "/email/MailTemplateAdd.jsp?userid=<%=user.getUID()%>";
        	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16218",user.getLanguage())%>";
        	dialog.Width = 800;
        	dialog.Height = 600;
        	dialog.Drag = true;
        	dialog.URL = url;
        	dialog.show();
        }
        
        function viewInfo(id){
        	dialog = new window.top.Dialog();
        	dialog.currentWindow = window;
        	var url = "/email/maint/DocMouldDsp.jsp?id="+id;
        	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("367,16218",user.getLanguage())%>";
        	dialog.Width = 800;
        	dialog.Height = 600;
        	dialog.Drag = true;
        	dialog.URL = url;
        	dialog.show();
        }
        
        // 编辑 -- 系统模版
        function editInfo_sys(id){
            dialog = new window.top.Dialog();
            dialog.currentWindow = window;
            var url = "/email/maint/DocMouldEdit.jsp?id="+id;
            dialog.Title = "<%=SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>"; //编辑模版
            dialog.Width = 800;
            dialog.Height = 600;
            dialog.Drag = true;
            dialog.URL = url;
            dialog.show();
        }
        
        // 预览 -- 系统模版
        function viewInfo_sys(id){
            dialog = new window.top.Dialog();
            dialog.currentWindow = window;
            var url = "/email/maint/DocMouldDsp.jsp?id="+id;
            dialog.Title = "<%=SystemEnv.getHtmlLabelName(129751,user.getLanguage())%>";  //预览模板
            dialog.Width = 800;
            dialog.Height = 600;
            dialog.Drag = true;
            dialog.URL = url;
            dialog.show();
        }
        
        // 删除 -- 系统模版
        function deleteInfo_sys(id){
        	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
        		jQuery.post("/email/maint/UploadDoc.jsp",{"operation":"delete","ids":id},function(){
        			_table.reLoad();
        		});
        	});
        }
        
        // 可以不选择任何一个模块为默认
        var defaultType = <%= templateType %> ;
        var defaultId = <%= defaultTemplateId %> ;
        
        var isClear = false;
        
        function detectRadioStatus(obj) {
            console.info(obj);
            console.info(isClear);
            console.info(defaultId);
        	if (defaultId == obj.value && defaultType == obj.getAttribute("templateType") && !isClear) {
        		isClear = true;
        		jQuery("#isclear").val("1");
        		clearRadioSelected();
        	} else {
        		isClear = false;
        		jQuery("#isclear").val("0");
        		defaultId = obj.value;
        		defaultType = obj.getAttribute("templateType");
        		changeRadioStatus(obj, true);
        	}
        }
        
        function clearRadioSelected() {
        	var radios = document.getElementsByName("isDefault");;
        	for (var i = 0; i < radios.length; i++) {
        		changeRadioStatus(radios[i], false);
        	}
        }
    </script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<style type="text/css">.href{color:blue;text-decoration:underline;cursor:hand}</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if(userId!=0){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
        RCMenuHeight += RCMenuHeightStep;
    }
    if("".equals(showTop)) {
       RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addInfo(),_self} " ;    
    } else if("show800".equals(showTop)) {
	   RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",MailTemplateAdd.jsp?showTop=show800&userid="+userId+",_self} " ;    
    }
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
    int perpage = 10;
    String hashSystemTemplOp = String.valueOf(HrmUserVarify.checkUserRight("email:templateSetting", user));
    String backFields = "t.id , t.name , t.description , t.tempType ";
    String orderBy = "tempType desc, name";
    String sqlFrom = "(SELECT id , mouldname name ,moulddesc description , 1 tempType   FROM DocMailMould "+
    			" UNION ALL SELECT id ,templateName name , templateDescription description , 0 tempType FROM MailTemplate WHERE userId = "+user.getUID()+") t";
    String sqlwhere = "1=1";
    String operateString= "<operates width=\"15%\">";
               operateString+=" <popedom transmethod=\"weaver.email.MailSettingTransMethod.getTemplateOpratePopedom\" column=\"tempType\" otherpara=\""+hashSystemTemplOp+"\"></popedom> ";
               operateString+="     <operate href=\"javascript:editInfo_sys()\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
           	   operateString+="     <operate href=\"javascript:viewInfo_sys()\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
        	   operateString+="     <operate href=\"javascript:deleteInfo_sys()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
               operateString+="     <operate href=\"javascript:editInfo()\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"3\"/>";
           	   operateString+="     <operate href=\"javascript:deleteInfo()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>";
           operateString+="</operates>";
    String tableString="<table  pageId=\""+PageIdConst.Email_Template+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Template,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"none\">";
           tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
           tableString+="<head>";
           tableString+="<col width=\"30%\"  target=\"_self\" text=\""+ SystemEnv.getHtmlLabelName(18151,user.getLanguage()) +"\" column=\"name\""+
          	 " otherpara = \"column:id+column:tempType\" transmethod=\"weaver.email.MailSettingTransMethod.getTemplateAccountNameInfo\"/>";
           tableString+="<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(85,user.getLanguage()) +"\" column=\"description\"/>";
           tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(149,user.getLanguage()) +"\" column=\"id\"  "+
           				" otherpara = \"column:tempType+"+templateType+"+"+defaultTemplateId+"\" transmethod=\"weaver.email.MailSettingTransMethod.getTemplateDefaultInfo\"/>";
           tableString+="</head>"+operateString;
           tableString+="</table>";
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			
			<input class="e8_btn_top middle" onclick="doSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="addInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>"/>
			
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form id="fMailTemplate" method="post" action="MailTemplateOperation.jsp">
    <input type="hidden" name="operation" value="default" />
    <input type="hidden" name="isclear" id="isclear" value="0">
    <input type="hidden" name="templateType" value="" />
    <input type="hidden" name="defaultTemplateId" value="" />
    <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Template%>">
    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
</form>

</body>
</html>
