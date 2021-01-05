<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CptDetailColumnUtil" class="weaver.cpt.util.CptDetailColumnUtil" scope="page"/>

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

<style>
        *{ margin:0; padding:0;}
        .help { padding: 20px; line-height: 18px; list-style: none; font-size: 12px;}
        .help td{color:#848585;}
         a{color:#1d98f8;cursor: pointer;} 
        .help .b{ height: 36px; font-weight: bold; line-height:36px;color:#373737;}
        .explain { padding: 10px; list-style: none;background-color: #FFFFFF; font-size: 12px;border-color: #adadad;border-style: solid;border-width: 1px;color:#848585;}

/* The header and footer */
.headfoot {display:block; height:auto; background:#ffffff; color:#000000; text-align:center; padding:5px;font-size:16px;}
.hfoot {display:block; height:auto; background:#ffffff; color:#000000; text-align:left; padding:5px;font-size:12px;}
/* This bit does all the work */
#container {position:relative; display:block; background:#ffffff; border-left:110px solid #ffffff; border-right:200px solid #ffffff;}
#inner {display:block; margin-left:-100px; margin-right:-100px; padding:5px;}
#left {
float:left;
margin-left:1px;
border:0px #ff0 solid;
height:auto;
width:33%;

}
.clear {clear:both;}
#topdiv {
	
}
    </style>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String needcheck="";
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("6002",user.getLanguage())%>'/>
</jsp:include>
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

<FORM id=frmain name=frmain method=post action="/proj/ffield/prjcardtabsetop.jsp"    >
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
			{width:"18%",colname:"<%=SystemEnv.getHtmlLabelNames("18274",user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage()) %>)",itemhtml:"<input type='text' class='InputStyle'  style='width:120px!important;' name='groupnamecn' /><span class='mustinput'></span>"},
			{width:"18%",colname:"<%=SystemEnv.getHtmlLabelNames("18274",user.getLanguage())%>(English)",itemhtml:"<input type='text' class='InputStyle' style='width:120px!important;' name='groupnameen' />"},
			{width:"18%",colname:"<%=SystemEnv.getHtmlLabelNames("18274",user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(33598,user.getLanguage()) %>)",itemhtml:"<input type='text' class='InputStyle' style='width:120px!important;' name='groupnametw' />"},
			{width:"35%",colname:"<span onmouseover='showExplain(this)' onmouseout='hiddenExplain()'><%=SystemEnv.getHtmlLabelNames("16208",user.getLanguage())%> <img src='/wechat/images/remind_wev8.png'  align='absMiddle' title='' /></span>",itemhtml:"<input type='text' class='InputStyle' style='width:400px!important;' name='linkurl' />"},
			{width:"10%",colname:"<span><%=SystemEnv.getHtmlLabelNames("18095",user.getLanguage())%><input type=\"checkbox\" class=\"InputStyle\" id=\"all_isopen\"/></span>",itemhtml:"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' class='InputStyle' name='isopen'  />"}
		];
     var option= {
    		 navcolor:"#00cc00",
    		 basictitle:"<%=SystemEnv.getHtmlLabelNames("6002",user.getLanguage())%>",
    		 openindex:false,
    		 colItems:items,
    		 toolbarshow:false,
    		 optionHeadDisplay:"none",
    		 canDrag:true,
    		 useajax:true,
    		 ajaxurl:'/proj/ffield/prjcardtabsetop.jsp',
    		 ajaxparams:{"src":"loadgroupdata"},
    		 configCheckBox:true,
    		 checkBoxItem:{itemhtml:"<input class='groupselectbox' name='groupid' type='checkbox'><img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelNames("82783",user.getLanguage())%>' />"}
    	};
     var group1=new WeaverEditTable(option);
     $(".subgroupmain").append(group1.getContainer());
     $("#all_isopen").bind("click",function(){
    	 if($(this).attr("checked")){
    		 $(this).closest("table.grouptable").find("input[name=isopen]").attr("checked",true).closest("td").find("span.jNiceCheckbox").addClass("jNiceChecked");
    	 }else{
    		 $(this).closest("table.grouptable").find("input[name=isopen]").removeAttr("checked").closest("td").find("span.jNiceCheckbox").removeClass("jNiceChecked");;
    		 $(this).closest("table.grouptable").find("input[name=isopen][disabled]").attr("checked",true).closest("td").find("span.jNiceCheckbox").addClass("jNiceChecked");
    	 }
    	 
     });
 </script>

<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
<input type="hidden" name="keepgroupids" id="keepgroupids" value=""/>
    
</form>
<div style="width: 280px;position: absolute;display:none;" id="cantent">
	<div style="position: relative;top:1px;display:none;height:17px;" id="topdiv">
		<img src="/images/ecology8/images/tips_wev8.png">
	</div>
	<div class="explain"></div>
	<div style="position: relative;bottom: 1px;display:none;height:7px;line-height:2px;" id="bottomdiv">
		<img src="/images/ecology8/images/tips2_wev8.png">
	</div>
</div>
<div id="remindInfo" style="display:none;">
<%
if(user.getLanguage()==8){
	%>
Custom page link address for network address, such as: <br/>
Http://www.baidu.com<br/>
Can also be internal address, such as: <br/>
/test.jsp?a=1&b=2<br/>
You can take parameter arguments, such as this: <br/>
/test.jsp?a=1&b=2<br/>
Can also like to write a placeholder {#id} project ID,: <br/>
/test.jsp?a=1&prjid={#id}&mypara2={#id}<br/>
If not write placeholder, the default will also receive 2 fixed parameter: <br/>
isfromProjTab=1&projectid=id
	<%
}else if(user.getLanguage()==9){
	%>
自定義頁面鏈接地址可以爲外網地址,如:<br/>
http://www.baidu.com<br/>
也可以是內部地址,如:<br/>
/test.jsp?a=1&b=2<br/>
可以帶上參數傳參,像這樣:<br/>
/test.jsp?a=1&b=2<br/>
也可以寫占位符{#id}傳項目id,像這樣:<br/>
/test.jsp?a=1&prjid={#id}&mypara2={#id}<br/>
即使不寫占位符,默認也會接收到2個固定的參數:<br/>
isfromProjTab=1&projectid=項目id	
	<%
}else{
	%>
自定义页面链接地址可以为外网地址,如:<br/>
http://www.baidu.com<br/>
也可以是内部地址,如:<br/>
/test.jsp?a=1&b=2<br/>
可以带上参数传参,像这样:<br/>
/test.jsp?a=1&b=2<br/>
也可以写占位符{#id}传项目id,像这样:<br/>
/test.jsp?a=1&prjid={#id}&mypara2={#id}<br/>
即使不写占位符,默认也会接收到2个固定的参数:<br/>
isfromProjTab=1&projectid=项目id	
	<%
}

%>





</div>

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

function showExplain(obj,type){
	$(obj).find(".leftspan").addClass("leftspan1");
	$(obj).find(".centerspan").addClass("centerspan1");
	$(obj).find(".rightspan").addClass("rightspan1");

	$("#topdiv").hide();
	$("#bottomdiv").hide();
	var content = "";
	content = $("#remindInfo").html();
	$(".explain").html("").html(content);
	var jqobj = $(obj);
	var offset =  jqobj.offset();
	var left = 0;
	
	if(offset.left>140){
		left = offset.left-140;
		$("#topdiv").css("padding-left",160);
		$("#bottomdiv").css("padding-left",160);
	}else{
		$("#topdiv").css("padding-left",offset.left);
		$("#bottomdiv").css("padding-left",offset.left);
	}
	var top = 0;
	var explainHeght = 	$("#cantent").height();
	var documentHeight =  document.body.scrollHeight;
	if(documentHeight-offset.top<120){
		top = offset.top-explainHeght-5;
		$("#bottomdiv").show();
	}else{
		top = offset.top+5;
		$("#topdiv").show();
	}
	$("#cantent").css("top",top);
	$("#cantent").css("left",left);
	$("#cantent").fadeIn();
}

function hiddenExplain(){
	$("#cantent").hide();
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

