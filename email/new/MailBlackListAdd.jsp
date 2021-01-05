
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>


<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete_wev8.js"></script>
<link href="/email/js/autocomplete/jquery.autocomplete_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/weaver_wev8.js"></script> 
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript" src="/email/js/progressbar/jquery.progressbar_wev8.js"/></script>
<link type='text/css' rel='stylesheet'  href='/blog/js/treeviewAsync/eui.tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
 <script type="text/javascript" src="/email/js/easyui/jquery.easyui.min_wev8.js"></script>  
 <script type="text/javascript" src="/js/init_wev8.js"></script>
 <link rel="stylesheet" type="text/css" href="/css/weaver_wev8.css" />
 
</head>
<style >
 .tabContent{
 	width: 200;
 	border-bottom: 1px solid #cccccc;
 	border-left: 1px solid #cccccc;
 	border-right: 1px solid #cccccc;
 	
 	overflow-y: scroll;
 	overflow-x: hidden;
 }
  .searchFrom{
 	background: url('/email/images/search_wev8.png') no-repeat;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	left: 330px;
 	top:15px;
 }
 </style>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31859,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailOperation.jsp" id="fMailblackList" name="fMailblackList">
<input type="hidden" name="operation" value="saveblacklist" />
<input type="hidden" name="userId" value="<%=user.getUID() %>" />

		<table style="margin-top:20px;margin-left:30px;">
			<tr>
				<td><span style="font-weight:bold"><%=SystemEnv.getHtmlLabelName(83102,user.getLanguage())%></span></td>
			</tr>
			<tr>
				<td><wea:required id="mailAddressSpan" required="true">
				<input type="text" id="mailaddress" name="mailaddress" class="inputstyle" style="width:90%" maxlength="80" onchange="checkinput('mailaddress','mailAddressSpan')" />
				</wea:required></td>
			</tr>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(83103,user.getLanguage())%>：mail@example.com, example.com</td>
			</tr>
		</table>
<div id="MailAccountInfo"></div>
</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<input type="hidden" id="contactList" value="0"/>
<script language="javascript">

jQuery(document).ready(function(){
	loadContactsTree();
});

function loadContactsTree(){
	//加载联系人列表
	var keyword =encodeURI(jQuery("#fromSearch").val())
	
	jQuery("div#contactsContent div#contactsTree").html("");
	jQuery("div#contactsContent div#contactsTree").load("/email/new/MailAddContactsGroupTree.jsp?keyword="+keyword,function(data){
		  jQuery(".contactsTree-item").hover(
		        function () {
		           jQuery(this).find("span[name=SH]").show();
		          }, 
		          function () {
		          		jQuery(this).find("span[name=SH]").hide();
		          }
  		);
		jQuery('.contactsItem').hover(
	            function () {
	              jQuery(this).addClass("contactsItemOver");
	            }, 
	            function () {
	            	jQuery(this).removeClass("contactsItemOver");
	            }
	    );
	});
}

//显示或着隐藏联系人列表
function showOrHideContactList(himself,_pagenum) {
	if($(himself).parent().find(".contactsGroupContent").children().length<1){
		var keyword =encodeURI($("#fromSearch").val())
		
		var groupid=$(himself).attr("groupid");
		$(himself).parent().find(".contactsGroupContent").load("/email/new/MailAddContactsTree.jsp?groupid="+groupid+"&onlyNum="+_pagenum+"&keyword="+keyword,function(data){
			$('.contactsItem').hover(
		            function () {
		              $(this).addClass("contactsItemOver");
		            }, 
		            function () {
		            	$(this).removeClass("contactsItemOver");
		            }
		    );
		});
	}
	$(himself).next("#customGroup").toggle();
	$(himself).find("b").each(function(){
		if($(this).hasClass("hide")) {
			$(this).removeClass("hide");
		} else {
			$(this).addClass("hide");
		}
	});
	
}

function addAddress(address){
	var addressVal = '';
	if(address.indexOf('<') != -1&&address.indexOf('>') != -1) {
		addressVal = address.substring(address.indexOf('<')+1,address.indexOf('>'));
	}
	$('#mailaddress').val(addressVal);
}

function showContactList(){
	if($("#contactList").val() == '1'){
		hideGroup("contactList");
		$("#contactList").val('0');				
	} 	
	else {
	 	showGroup("contactList");
		$("#contactList").val('1');
	}

}
var parentWin = parent.getParentWindow(window);
function saveInfo(){
	var address = jQuery('#mailaddress').val();
	if(address == '' || address == null) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83104,user.getLanguage())%>！");
		return;
	}
	
	jQuery.post("/email/MailOperation.jsp",jQuery("form").serialize(),function(e){
		if(e){
	 		parentWin.closeDialog();
		}else
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21809,user.getLanguage())%>");
	});	

}


	function Mtrim(str){ //删除左右两端的空格
		 return str.replace(/(^\s*)|(\s*$)/g, "");
	}

 //检测邮箱账号信息
 var diag = null;
function closeDialog(){
	if(diag){
		diag.close();
	}
	parent.getParentWindow(window).closeDialog();
}

function refreshInfo(){
	parent.getParentWindow(window)._table.reLoad();
}


</script>
<style>
	#rightMenuIframe{
		background-color: transparent; height:<%=RCMenuHeight+6%>!important;
	}
</style>
</body>