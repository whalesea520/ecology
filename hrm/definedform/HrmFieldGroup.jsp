
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<%
String userid =""+user.getUID();
/*权限判断,人力资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql ="select resourceid from HrmRoleMembers where roleid in (select roleid from SystemRightRoles where rightid=22)";
RecordSet.executeSql(tempsql);
while(RecordSet.next()){
    String tempid = RecordSet.getString("resourceid");
    allCanView.add(tempid);
}// end while
for (int i=0;i<allCanView.size();i++){
    if(userid.equals((String)allCanView.get(i))){
        canView = true;
    }
}
if(!canView) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
/*权限判断结束*/
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = ""+SystemEnv.getHtmlLabelName(34105,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck="";

String grouptype = Util.null2String(request.getParameter("grouptype"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:group1.addRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:group1.deleteRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:group1.copyRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmain name=frmain method=post action="/hrm/definedform/HrmFieldGroupOperation.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="group1.addRow()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.deleteRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.copyRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top"  onclick="doSave(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
 
<div class="subgroupmain" style="width: 100%;margin-left:0px;"></div>
 <script>
 
 	var items=[
			{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(30127,user.getLanguage()) %>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage()) %>)",itemhtml:"<input type='text' class='InputStyle'  style='width:220px!important;' name='groupnamecn' /><span class='mustinput'></span>"},
			{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(30127,user.getLanguage()) %>(English)",itemhtml:"<input type='text' class='InputStyle' style='width:220px!important;' name='groupnameen' />"},
			{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(30127,user.getLanguage()) %>(<%=SystemEnv.getHtmlLabelName(33598,user.getLanguage()) %>)",itemhtml:"<input type='text' class='InputStyle' style='width:220px!important;' name='groupnametw' />"},
		];
     var option= {
    		 navcolor:"#00cc00",
    		 basictitle:"<%=SystemEnv.getHtmlLabelName(34105,user.getLanguage()) %>",
    		 openindex:false,
    		 colItems:items,
    		 toolbarshow:false,
    		 optionHeadDisplay:"none",
    		 canDrag:true,
    		 useajax:true,
    		 ajaxurl:'/hrm/definedform/HrmFieldGroupOperation.jsp?grouptype=<%=grouptype%>',
    		 ajaxparams:{"src":"loadgroupdata"},
    		 configCheckBox:true,
    		 checkBoxItem:{itemhtml:"<input class='groupselectbox' name='groupid' type='checkbox'><img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage()) %>' />"}
    	};
     var group1=new WeaverEditTable(option);
     $(".subgroupmain").append(group1.getContainer());
 </script>

<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
<input type="hidden" name="keepgroupids" id="keepgroupids" value=""/>
<input type="hidden" name="grouptype" id="grouptype" value="<%=grouptype %>"/>
</form>


<script language="javascript">
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;

function checkform()
{
	var fieldlables = document.getElementsByName("groupnamecn");
	var array = new Array();
	var idx = 0;
	for(var i=0;fieldlables!=null&&i<fieldlables.length;i++){
		if(fieldlables[i].value!="")array[idx++]=fieldlables[i].value;
	}
	
	var array=array.sort();
	for(var i=0;i<array.length;i++){
	 if (array[i]==array[i+1]){
	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83375,user.getLanguage()) %>");
	  return false;
	 }
	}
	return true;
}

function doSave(obj)
{
	if(!checkform())return false;
	var dtinfo= group1.getTableSeriaData();
	var dtjson= group1.getTableJson();
   	if(dtinfo){
   		var jsonstr= JSON.stringify(dtjson);
   		var dtmustidx=[0];
   		if(checkdtismust(dtjson,dtmustidx)==false){//明细必填验证
   			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
   			return;
   		}
   		
   		$("input[type=checkbox][name^=groupid]").each(function(){
   			keepidval+=$(this).val()+",";
   		});
   		
   		var keepidval="";
   		$("input[type=checkbox][name^=groupid]").each(function(){
   			keepidval+=$(this).val()+",";
   		});
   		$("#keepgroupids").val(keepidval);
   		//obj.disabled=true;
   		
   		var form=jQuery("#frmain");
   		jQuery("#dtinfo").val(jsonstr);
		var form_data=form.serialize();
		var form_url=form.attr("action")+"?src=editgroupbatch";
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : false,
			data : form_data,
			dataType : "json",
			success: function do4Success(data){
				if(data.__result__===false){
					window.top.Dialog.alert(data.__msg__);
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82933,user.getLanguage()) %>");
				}
				//这个方法有问题  会在原来的基础上追加
				group1.reload();
			}
		});
   	}else{
   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33027,user.getLanguage()) %>");
   	}
}

$(function(){
	$(function(){
		$("div.subgroupmain").find("tr")
		.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
		.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
	});
});
</script>
</BODY>
</HTML>