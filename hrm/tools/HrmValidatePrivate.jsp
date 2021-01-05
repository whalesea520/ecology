<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />

<%
 if(!HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
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
String titlename = SystemEnv.getHtmlLabelName(6002,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck="";
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
<div id="remindInfo" style="display:none;">
<%=SystemEnv.getHtmlLabelName(82922,user.getLanguage())+SystemEnv.getHtmlLabelName(82928,user.getLanguage()) %>
</div>
<FORM id=frmain name=frmain method=post action="/hrm/tools/HrmValidateOperation.jsp"    >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="group1.addRow()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.deleteRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.copyRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top"  onclick="doSave(this)"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
 
<div class="subgroupmain" style="width: 100%;margin-left:0px;"></div>
 <script>
 
 	var items=[
			{width:"18%",colname:"<%=SystemEnv.getHtmlLabelName(18274,user.getLanguage()) %>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage()) %>)",itemhtml:"<input type='text' class='InputStyle'  style='width:120px!important;' name='groupnamecn' /><span class='mustinput'></span>"},
			{width:"18%",colname:"<%=SystemEnv.getHtmlLabelName(18274,user.getLanguage()) %>(English)",itemhtml:"<input type='text' class='InputStyle' style='width:120px!important;' name='groupnameen' />"},
			{width:"18%",colname:"<%=SystemEnv.getHtmlLabelName(18274,user.getLanguage()) %>(<%=SystemEnv.getHtmlLabelName(33598,user.getLanguage())%>)",itemhtml:"<input type='text' class='InputStyle' style='width:120px!important;' name='groupnametw' />"},
			{width:"35%",colname:"<%=SystemEnv.getHtmlLabelName(16208,user.getLanguage()) %> <img id='remindImg' src='/wechat/images/remind_wev8.png' align='absMiddle' title='' />",itemhtml:"<input type='text' class='InputStyle' style='width:380px!important;' name='linkurl' /><span class='mustinput'></span>"},
			{width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage()) %>",itemhtml:"<input type='checkbox' class='InputStyle' name='isopen'  />"}
		];
     var option= {
    		 navcolor:"#00cc00",
    		 basictitle:"<%=SystemEnv.getHtmlLabelName(6002,user.getLanguage()) %>",
    		 openindex:false,
    		 colItems:items,
    		 toolbarshow:false,
    		 optionHeadDisplay:"none",
    		 canDrag:true,
    		 useajax:true,
    		 ajaxurl:'/hrm/tools/HrmValidateOperation.jsp',
    		 ajaxparams:{"src":"loadgroupdata"},
    		 configCheckBox:true,
    		 checkBoxItem:{itemhtml:"<input class='groupselectbox' name='groupid' type='checkbox'><img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage()) %>' />"}
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
   		var jsonstr= JSON.stringify(dtjson);
   		//console.log("dtinfo:"+jsonstr);
   		var dtmustidx=[0,3];
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
			success: function do4Success(data){
				if(data.__result__===false){
					window.top.Dialog.alert(data.__msg__);
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82933,user.getLanguage()) %>");
				}
				//group1.reload();
				window.location.href=window.location.href;
				//obj.disabled=false;
			}
		});
   		
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

$(function(){
	$("#remindImg").attr("title",$("#remindInfo").text());
});

</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
