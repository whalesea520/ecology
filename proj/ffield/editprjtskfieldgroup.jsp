<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />

<%
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String rightStr = "";
if(!HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;




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
String titlename = "";
String needfav ="1";
String needhelp ="";
String needcheck="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("611",user.getLanguage())+",javascript:group1.addRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+",javascript:group1.deleteRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("77",user.getLanguage())+",javascript:group1.copyRows(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmain name=frmain method=post action="/proj/ffield/prjtskgroupoperation.jsp"    >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="group1.addRow()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.deleteRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.copyRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top"  onclick="doSave(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
 
<div class="subgroupmain" style="width: 100%;margin-left:0px;"></div>
 <script>
 
 	var items=[
			{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("30127",user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage()) %>)",itemhtml:"<input type='text' class='InputStyle'  style='width:220px!important;' name='groupnamecn' /><span class='mustinput'></span>"},
			{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("30127",user.getLanguage())%>(English)",itemhtml:"<input type='text' class='InputStyle' style='width:220px!important;' name='groupnameen' />"},
			{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("30127",user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(33598,user.getLanguage()) %>)",itemhtml:"<input type='text' class='InputStyle' style='width:220px!important;' name='groupnametw' />"},
		];
     var option= {
    		 navcolor:"#00cc00",
    		 basictitle:"<%=SystemEnv.getHtmlLabelNames("34105",user.getLanguage())%>",
    		 openindex:false,
    		 colItems:items,
    		 toolbarshow:false,
    		 optionHeadDisplay:"none",
    		 canDrag:true,
    		 useajax:true,
    		 ajaxurl:'/proj/ffield/prjtskgroupoperation.jsp',
    		 ajaxparams:{"src":"loadgroupdata"},
    		 configCheckBox:true,
    		 checkBoxItem:{itemhtml:"<input class='groupselectbox' name='groupid' type='checkbox'><img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelNames("82783",user.getLanguage())%>' />"}
    	};
     var group1=new WeaverEditTable(option);
     $(".subgroupmain").append(group1.getContainer());
 </script>

<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
<input type="hidden" name="keepgroupids" id="keepgroupids" value=""/>
    
</form>


<script language="javascript">
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;
var currentdate = "<%=currentdate%>";


function doSave(obj)
{
	var dtinfo= group1.getTableSeriaData();	
	var dtjson= group1.getTableJson();
   	if(dtinfo){
   		var jsonstr= JSON.stringify(dtjson);
   		//console.log("dtinfo:"+jsonstr);
   		var dtmustidx=[0];
   		if(checkdtismust(dtjson,dtmustidx)==false){//明细必填验证
   			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
   			return;
   		}
   		
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
			async : true,
			data : form_data,
			dataType : "json",
			success: function do4Success(msg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("82933",user.getLanguage())%>");
				//group1.reload();
				window.location.href=window.location.href;
				//obj.disabled=false;
			}
		});
   		
   		
   		
   	}else{
   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33027,user.getLanguage()) %>");
   	}
}

function back(){
    window.history.back(-1);
}


$(function(){
	//setTimeout("group1.addRow();",100);
	$(function(){
		$("div.subgroupmain").find("tr")
		.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
		.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
	});
});


</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

