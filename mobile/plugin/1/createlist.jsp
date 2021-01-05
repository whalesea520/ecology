
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.mobile.webservices.workflow.*" %>

<jsp:useBean id="wsi" class="weaver.mobile.webservices.workflow.WorkflowServiceImpl" scope="page"/>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
FileUpload fu = new FileUpload(request);

String module = Util.null2String((String)fu.getParameter("module"));
String scope = Util.null2String((String)fu.getParameter("scope"));
String title = Util.null2String((String)fu.getParameter("title"));
String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));

//现已将提交请求方式修改为post，故不需要解码。
String keyword = Util.null2String((String)fu.getParameter("keyword"));

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

char flag=Util.getSeparator() ;

String[] conditions = new String[2];
conditions[0] = keyword;
conditions[1] = weaver.mobile.plugin.ecology.RequestOperation.AVAILABLE_WORKFLOW;

//20151201 多账号对应 Start
//WorkflowExtInfo[] wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions);
String belongtoshow = user.getBelongtoshowByUserId(user.getUID());
WorkflowExtInfo[] wbis;
if("1".equals(belongtoshow)){
  wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions,true);
}else{
  wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions);
}

//20151201 多账号对应 End
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0" /> 
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<style type="text/css">
	.search {
		width: 100%;
		height: 42px;
		text-align: center;
		position: relative;
		background: #7F94AF;
		background: -moz-linear-gradient(0, #A4B0C0, #7F94AF);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(#A4B0C0), to(#7F94AF) );
		border-bottom: 1px solid #5D6875;
	}
	.searchImg {
		width: 25px;
		padding: 2px;
		margin-left: auto;
		margin-right: auto;
		border-top: 1px solid #687D97;
		border-right: 0;
		border-bottom: 1px solid #687D97;
		border-left: 1px solid #687D97;
		background: #fff;
		-moz-border-radius: 5px 0 0 5px;
		-webkit-border-radius: 5px 0 0 5px;
		border-radius: 5px 0 0 5px;
		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	}
	.searchText {
		width: 100%;
		margin-left: auto;
		margin-right: auto;
		border-top: 1px solid #687D97;
		border-right: 1px solid #687D97;
		border-bottom: 1px solid #687D97;
		border-left: 0;
		background: #fff;
		overflow:hidden;
		-moz-border-radius: 0 5px 5px 0;
		-webkit-border-radius: 0 5px 5px 0;
		border-radius: 0 5px 5px 0;
		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	}
	.prompt {
		color: #777878;
	}
	.list {
		width: 100%;
		background: url(/images/bg_w_75_wev8.png);
	}
	.listitem {
		width:100%;
		height:46px;
		background-color:#EFF2F6;
		border-bottom:1px solid #D8DDE4;
	}
	.itemnavpoint {
		height:100%;width:26px;text-align:center;
	}
	.itemnavpoint img {
		width:10px;
		heigth:14px;
	}
	.itemNo {
		height:100%;width:30px;text-align:center;
		font-size: 16px;
		color: #444;
		font-weight: bold;
	}
	.itemcontent {
		width:*;
		height:100%;
		font-size: 16px;
		color: #444;
		font-weight: bold;
		word-break:keep-all;
		text-overflow:ellipsis;
		white-space:nowrap;
		overflow:hidden;
	}
	.item {
		width:100%;
		height:46px;
		background-color:#fff;
		border-bottom:1px solid #c6c6c6;
	}
	
	.itemLeft {
		height:100%;width:45px;text-align:right;color:#c6c6c6;
	}
	.itemRt {
		width:*;height:100%;font-size: 14px;color: #123885;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;
	}
    .itemIcon {
        width:45px;height:100%;font-size: 14px;color: #123885;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;
    }
    .pluralPostImg{
        height:30px;
        margin-top:5px;
        margin-left:5px;
    }
    
    .black_overlay{ 
        display: none; 
        position: fixed; 
        top: 0%; 
        left: 0%; 
        width: 100%; 
        height: 100%; 
        background-color: black; 
        z-index:1001; 
        -moz-opacity: 0.3; 
        opacity:.30; 
        filter: alpha(opacity=88); 
    } 
    .white_content { 
        display: none; 
        position: fixed; 
        top: 100px; 
        width: 280px;
        height: auto; 
        border: 1px solid #ccc; 
        background-color: white; 
        z-index:1002; 
        overflow: none; 
    } 
    #light{
        -webkit-touch-callout:none;
		-webkit-user-select:none;
		-khtml-user-select:none;
		-moz-user-select:none;
		-ms-user-select:none;
		user-select:none;
    }
    #light-top{
        color:rgb(0,170,255);
        height:46px;
        line-height:46px;
        padding-left:15px;
        border-bottom:2px solid rgb(12,177,253);
        font-size:14px;
        font-family:"Microsoft YaHei";
    }
    #light-detail div{
        height:46px;
        line-height:46px;
        font-size:14px;
        font-family:"Microsoft YaHei";
    }
    .mainAccount,.subAccount{
        color:rgb(153,153,153);
        padding-left:15px;
        border-bottom:1px solid rgb(241,241,241);
        background-color:rgb(247,247,247);
    }
    .detailUser{
        color:rgb(51,51,51);
        padding-left:25px;
        border-bottom:1px solid rgb(241,241,241);
        background-color:#fff;
        cursor:pointer;
        padding-right:25px;
        text-overflow:ellipsis;
        white-space:nowrap;
        overflow:hidden;
    }
    .selectedUser{
        color:rgb(0,153,255);
        background-image:url('/mobile/plugin/images/selectedUserIcon.png');
        backfround-color:#fff;
		background-repeat:no-repeat;
		background-position:center right;
    }
    .Button_hover{
        background-color:#aaa !important;
        color:#fff !important;
    }
    #selectButton,#cancelButton{
        height:46px;
        color:rgb(51,51,51);
        line-height:46px;
        font-size:14px;
        width:139px;
        font-family:"Microsoft YaHei";
        cursor:pointer;
        float:left;
        text-align:center;
        background-color:#fff;
    }
    #selectButton{
        border-left:1px solid rgb(241,241,241);
    }
	</style>
</head>
<body>

<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width:100%;height:40px;font-size:13px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title">选择流程</div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>

	<form id="clform" action="/mobile/plugin/1/createlist.jsp" method="post">
	
	<input type="hidden" name="module" value="<%=module%>">
	<input type="hidden" name="scope" value="<%=scope%>">
	
	<div class="search">
		<div style="height:5px"></div>
		<table style="width:100%;height: 28px;">
			<tr>
				<td>&nbsp;</td>
				<td class="searchImg" onclick="searchClick()"><img src="/images/icon-search.png"></td>
				<td class="searchText"><input type="text" id="keyword" name="keyword" class="prompt" style="border: none;width: 100%;height: 26px;" value="<%=keyword%>"></td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</div>

	<div class="list" id="list">
		<% 
		String wtid = "";
		for(int i=0;wbis!=null&&i<wbis.length;i++) { 
			
			%>
			<%
			if(!wbis[i].getWorkflowTypeId().equals(wtid)) {
			%>
			<div class="listitem">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;">
				<tr>
					<TD class="itemNo">
						<img src="/mobile/plugin/1/images/itemnavimg_wev8.png" width="10px" height="10px" style="margin-top:8px;"> 
					</TD>
					<TD class="itemcontent" >
						<%=wbis[i].getWorkflowTypeName() %>
					</TD>
					<TD class="itemnavpoint">
						
					</TD>
				 </TR>
			</TABLE>
			</div>
			<%
				wtid = wbis[i].getWorkflowTypeId();
			}
			%>
			<div class="item">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;">
				<tr>
					<TD class="itemLeft" ontouchend="goCreate(<%=wbis[i].getWorkflowId()%>,'<%=wbis[i].getF_weaver_belongto_userid()%>','<%=wbis[i].getF_weaver_belongto_usertype()%>')">
					
					</TD>
					<TD class="itemRt" ontouchend="goCreate(<%=wbis[i].getWorkflowId()%>,'<%=wbis[i].getF_weaver_belongto_userid()%>','<%=wbis[i].getF_weaver_belongto_usertype()%>')">
						<%=wbis[i].getWorkflowName() %>
					</TD>
					
                    <% if (wbis[i].getUserList() != null && wbis[i].getUserList().size() > 1){
                        int userCnt = 0;
                        StringBuffer userIds = new StringBuffer();
                        
                        while(userCnt < wbis[i].getUserList().size()){
                            if(userCnt > 0) userIds.append(",");
                            userIds.append(wbis[i].getUserList().get(userCnt).getUID());
                            userCnt++;
                        }
                    %>
                    <TD class="itemIcon">
                        <a href="javascript:(0);" ontouchend ="goChangeAccount(<%=wbis[i].getWorkflowId()%>,'<%=userIds%>','<%=usertype%>')">
                            <img class="pluralPostImg" src="/mobile/plugin/images/changeAccount.png">
                        </a>
                    </TD>
                    <%}%>
				 </TR>
			</TABLE>
			</div>
			
			<div class="blankLines"></div>
		<%
		}
		%>
	</div>
        <div id="light" class="white_content">
            <div id="light-top">
                选择创建身份
            </div>
            <div id="light-detail">
            </div>
            
            <div id="userSelectButton">
                <div id="cancelButton">取消</div>
                <div id="selectButton">确定</div>
            </div>
        </div>
        
        <div id="fade" class="black_overlay">
        </div>
	</form>
</div>

<script type="text/javascript">
var touchmoveflag = false;
$(document).ready(function() {

	$.ajaxSetup({ cache: false });

	$('#keyword').keypress(function(e) {
        if(e.which == 13) {
            jQuery(this).blur();
			$("#clform").submit();
        }
    });
    $(document).bind("touchmove",function(){
        touchmoveflag = true;
    })
    $(".itemLeft").add(".itemRt").bind("touchstart",function(){
        touchmoveflag = false;
    });
});

function searchClick() {
	$("#clform").submit();
}

function goCreate(wid,belongUserId,belongUserType) {
    if(touchmoveflag){
        return false;
    }
	if(belongUserId != 'null' && belongUserId > 0){
       location = "/mobile/plugin/1/view.jsp?workflowid="+wid+"&method=create&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&f_weaver_belongto_userid=" + belongUserId + "&f_weaver_belongto_usertype=" + belongUserType;
	}else{
       location = "/mobile/plugin/1/view.jsp?workflowid="+wid+"&method=create&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>";
	}
}

function ajaxinit(){
	var ajax=false;
	try {
	    ajax = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
	    try {
	        ajax = new ActiveXObject("Microsoft.XMLHTTP");
	    } catch (E) {
	        ajax = false;
	    }
	}
	if (!ajax && typeof XMLHttpRequest!='undefined') {
	    ajax = new XMLHttpRequest();
	}
	return ajax;
}
function goChangeAccount(wid,userIds,belongUserType){
    var userId = '<%=user.getUID()%>';
    jQuery.ajax({
         type: "get",
         url: "/mobile/plugin/1/changeAccountAjax.jsp",
         data: "userIds="+userIds,
         contentType : "application/x-www-form-urlencoded; charset=UTF-8",
         cache: false,
         async:false,
         dataType: 'json',
         success: function(data){
            if(data.length > 0){
                jQuery("body").css({overflow:"hidden"}); 
                var tempbelongtype = "";
                jQuery("#light-detail").html("");
                for(var i = 0; i < data.length; i++){
                    var item = data[i];
                    var strHtml = "";
                    var belongFlag = false;
                    var belongtype = "";
                    if(userId != item.id){
                        belongFlag = true;
                        belongtype = "1";
                    }else{
                        belongtype = "0";
                    }
                    if(!belongFlag){
                        tempbelongtype = belongtype;
                        continue;
                    }else if(tempbelongtype != belongtype){
                        strHtml += '<div class="subAccount">次账号';
                        strHtml += '</div>';
                        jQuery("#light-detail").append(jQuery(strHtml));
                    }
                    strHtml = "";
                    strHtml += '<div _userid="' + item.id + '" _wid="' + wid + '" _belongUserType="' + belongUserType + '" class="detailUser" ontouchend="changeselected(this)">';
                    strHtml += item.departmentmark + ' / ' + item.jobtitlename;
                    strHtml += '</div>';
                    jQuery("#light-detail").append(jQuery(strHtml));
                    
                    tempbelongtype = belongtype;
                }
                jQuery('#fade').show();
                jQuery('#light').css("left",parseInt(jQuery("body").width()-jQuery('#light').width())/2 + "px");
                jQuery('#light').css("top",parseInt(jQuery("body").height()-jQuery('#light').height())/2 + "px");
	            jQuery('#light').show();
            }
         },
         error:function(){
            alert("error");
         }
     });
}

//禁止文字选中
document.getElementById("light").onselectstart = document.getElementById("light").ondrag = function(){
    return false;
}
document.getElementById("fade").onselectstart = document.getElementById("fade").ondrag = function(){
    return false;
}
function changeselected(obj){
if(touchmoveFlag){
    return false;
}
    jQuery(obj).addClass("selectedUser");
    jQuery(".selectedUser").not(jQuery(obj)).each(function(){
        jQuery(this).removeClass("selectedUser");
    });
}
var touchmoveFlag = false;
jQuery(document).bind("touchmove",function(){
    touchmoveFlag = true;
});
jQuery(document).bind("touchstart",function(){
    touchmoveFlag = false;
});
jQuery("#selectButton").bind("touchstart",function(event){
    jQuery(this).addClass("Button_hover");
    if(jQuery("#light-detail").find(".selectedUser").length <= 0){
        touchmoveFlag = true;
        jQuery(this).removeClass("Button_hover");
        jQuery(this).blur();
        event.stopPropagation();
        alert("请选择岗位");
        return false;
    }
    jQuery("body").css({overflow:"auto"}); 
    $selectedUser = jQuery("#light-detail").find(".selectedUser")
    var wid = $selectedUser.attr("_wid");
    var belongUserId = $selectedUser.attr("_userid");
    var belongUserType = $selectedUser.attr("_belongUserType");
    location = "/mobile/plugin/1/view.jsp?workflowid="+wid+"&method=create&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&f_weaver_belongto_userid=" + belongUserId + "&f_weaver_belongto_usertype=" + belongUserType;
    jQuery('#light').hide();
    jQuery('#fade').hide();
    jQuery("body").css({overflow:"auto"}); 
    jQuery(this).removeClass("Button_hover");
});
function selectButtonTouchend(obj){


}
jQuery("#cancelButton").bind("touchend",function(){
if(touchmoveFlag){
    return false;
}
    jQuery(this).addClass("Button_hover");
    jQuery('#light').hide();
    jQuery('#fade').hide();
    jQuery("body").css({overflow:"auto"}); 
    jQuery("#light-detail").find(".selectedUser").each(function (){
        $(this).removeClass("selectedUser");
    });
    jQuery(this).removeClass("Button_hover");
});



function goBack() {
	location = "/list.do?module=<%=module%>&scope=<%=scope%>";
}

</script>

</body>
</html>