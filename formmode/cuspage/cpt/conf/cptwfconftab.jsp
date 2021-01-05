<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptDetailColumnUtil" class="weaver.cpt.util.CptWfConfColumnUtil" scope="page"/>

<%
if(!HrmUserVarify.checkUserRight("Cpt:CusWfConfig", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


String wftype = Util.null2String(request.getParameter("wftype"));
//不能选的wf
String notwfid="";
RecordSet.executeSql("select wfid from uf4mode_cptwfconf where wftype!='"+wftype+"' ");
while(RecordSet.next()){
	notwfid+=","+RecordSet.getString("wfid");
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/interface/CptDwrUtil.js'></script>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
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
String titlename = SystemEnv.getHtmlLabelNames("81546",user.getLanguage());
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
//RCMenu += "{"+SystemEnv.getHtmlLabelNames("77",user.getLanguage())+",javascript:group1.copyRows(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmain name=frmain method=post action="/formmode/cuspage/cpt/conf/cptwfconfop.jsp"    >

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="group1.addRow()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top"  onclick="group1.deleteRows()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top" style="display:none;" onclick="group1.copyRows()"/>
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
function initNodeSelect(container,tr,entry){
	var wfidEle=tr.find("input[name^=wfid]");
	var wfid=wfidEle.val();
	var idx=wfidEle.attr("id").split("_")[1];
	$('#acttype_'+idx).val('');
	$('#actnode_'+idx).empty();
	$('#actlink_'+idx).empty();
	if(wfid>0){
		$('#acttype_'+idx).show();
	}
	
	CptDwrUtil.getCptWfNodeItem(wfid,function(data){
		$('#actnode_'+idx).append(data);
		CptDwrUtil.getCptWfLinkItem(wfid,function(data){
			$('#actlink_'+idx).append(data);
			if(entry){
				$('#acttype_'+idx).val(entry[11].value);
				$('#actnode_'+idx).val(entry[12].value);
				$('#actlink_'+idx).val(entry[13].value);
				$('#actmethod_'+idx).val(entry[14].value);
			}else{
				/**
				$('#acttype_'+idx).val(1);
				$('#actnode_'+idx).find("option[nodetype='3']").attr("selected",true);
				$('#actlink_'+idx).val('');
				$('#actmethod_'+idx).val(1);
				**/
			}
			if($('#acttype_'+idx).val()=='1'){
				$("#actnode_"+idx).show();
				$("#actmethod_"+idx).show();
				$("#actlink_"+idx).hide();
			}else if($('#acttype_'+idx).val()=='0'){
				$("#actnode_"+idx).hide();
				$("#actmethod_"+idx).hide();
				$("#actlink_"+idx).show();
			}else{
				$("#actnode_"+idx).hide();
				$("#actmethod_"+idx).hide();
				$("#actlink_"+idx).hide();
			}
			
		});
	});
	
}
 	var items=<%=CptDetailColumnUtil.getDetailColumnConf(wftype, user) %>;
     var option= {
    		 navcolor:"#00cc00",
    		 basictitle:"<%=SystemEnv.getHtmlLabelNames("81546",user.getLanguage()) %>",
    		 openindex:true,
    		 colItems:items,
    		 toolbarshow:false,
    		 optionHeadDisplay:"none",
    		 addrowCallBack:initNodeSelect,
    		 //canDrag:true,
    		 useajax:true,
    		 ajaxurl:'/formmode/cuspage/cpt/conf/cptwfconfop.jsp',
    		 ajaxparams:{"src":"loadgroupdata","wftype":"<%=wftype %>"},
    		 configCheckBox:true,
    		 checkBoxItem:{itemhtml:"<input class='groupselectbox' name='groupid' type='checkbox'>"}
    	};
     var group1=new WeaverEditTable(option);
     $(".subgroupmain").append(group1.getContainer());
 </script>

<input type="hidden" name="dtinfo" id="dtinfo" value=""/>
<input type="hidden" name="dtrowcount" id="dtrowcount" value=""/>
<input type="hidden" name="keepgroupids" id="keepgroupids" value=""/>
<input type="hidden" name="wftype" value="<%=wftype %>" />    
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
<div id="remindInfo" style="display:none;z-index:99999;">
<%=SystemEnv.getHtmlLabelName(127965,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(127966,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(127967,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(127968,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(127969,user.getLanguage())%>
</div>

<script language="javascript">
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;
var currentdate = "<%=currentdate%>";


function doSave(obj)
{
	var wftype="<%=wftype %>";
	var dtinfo= group1.getTableSeriaData();	
	var dtjson= group1.getTableJson();
   	if(true||dtinfo){
   		var jsonstr= JSON.stringify(dtjson);
   		var dtmustidx=[0];
   		if(wftype=="apply"){
   			dtmustidx=[0,1,2,4];
   		}else{
   			dtmustidx=[0,1,3,4];
   		}
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
   		jQuery("#dtrowcount").val(group1.count);
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



function loadinfo(event,data,name){
	if(data&&name){
		var idx=name.split("_")[1];
		var wfid=$('#'+name).val();
		$('#acttype_'+idx).val('');
		$('#actnode_'+idx).empty();
		$('#actlink_'+idx).empty();
		if(wfid>0){
			try{
				$('#acttype_'+idx).show();
				CptDwrUtil.getCptWfNodeItem(wfid,function(data){
					$('#actnode_'+idx).append(data);
					CptDwrUtil.getCptWfLinkItem(wfid,function(data){
						$('#actlink_'+idx).append(data);
						$('#acttype_'+idx).val(1);
						$('#actnode_'+idx).find("option[nodetype='3']").attr("selected",true);
						$('#actnode_'+idx).show();
						$('#actlink_'+idx).val('');
						$('#actlink_'+idx).hide();
						$('#actmethod_'+idx).val(1);
						$('#actmethod_'+idx).show();
					});
				});
			}catch(e){}
			
		}else{
			$('#acttype_'+idx).val('');
			$('#actnode_'+idx).val('');
			$('#actmethod_'+idx).val('');
			$('#actlink_'+idx).val('');
			
			$('#acttype_'+idx).hide();
			$("#actnode_"+idx).hide();
			$("#actmethod_"+idx).hide();
			$("#actlink_"+idx).hide();
		}
		//beautySelect("#acttype_"+idx+",#actnode_"+idx+",#actmethod_"+idx+",#actlink_"+idx);
		
	}
}
function loadinfo2(event,data,name){
	if(name){
		
	}
}

function getWfBrowserUrl(data){
	var td=$(data).parents("td").first();
	var nowwfid=td.find("input[name^=wfid]").val();
	var wftype="<%=wftype %>";
	var type=161;
	var fielddbtype=wftype=="apply"?"browser.cptcapital":"browser.cptcapitalinfo";
	var notwfid="-1<%=notwfid %>";
	$("div.subgroupmain").find("input[name^=wfid]").each(function(){
		var val=$(this).val();
		if(val!=""&&val!=","&&val!=nowwfid){
			notwfid+=","+val;
		}
	});
	
	var sqlwhere="where isbill=1 and exists ( select 1 from workflow_billfield t2 where t2.billid=workflow_base.formid and t2.fieldhtmltype=3 and t2.type="+type+" and t2.fielddbtype='"+fielddbtype+"' and workflow_base.id not in("+notwfid+") and formid not in(14,18,19,201,220,221,222,224) )";
	
	return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+sqlwhere;
}

function getBrowserUrlFn(data){
	var td=$(data).parents("td").first();
	var wfid= td.parents("tr").first().find("td:eq(1)") .find("input[name^=wfid]").val();
	var sqlwhere="where 1=1 ";
	var url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/fieldBrowser.jsp?wfid="+wfid;
	var fieldname=td.find("input[type=hidden]").attr("id");
	fieldname=fieldname.substring(0, fieldname.lastIndexOf("_"));
	switch(fieldname){
		case "sqr":
			url+="%26htmltype=3%26type=1";
			break;
		case "zczl":
			url+="%26htmltype=3%26type=161%26fielddbtype=browser.cptcapital";
			break;
		case "zc":
			url+="%26htmltype=3%26type=161%26fielddbtype=browser.cptcapitalinfo";
			break;
		case "sl":
			url+="%26htmltype=1%26type=2,3";
			break;
		case "jg":
			url+="%26htmltype=1%26type=3";
			break;
		case "rq":
			url+="%26htmltype=3%26type=2";
			break;
		case "ggxh":
			url+="%26htmltype=1%26type=1";
			break;
		case "cfdd":
			url+="%26htmltype=1%26type=1";
			break;
		case "bz":
			url+="%26htmltype=1,2%26type=1";
			break;
		case "wxqx":
			url+="%26htmltype=3%26type=2";
			break;
		case "wxdw":
			url+="%26htmltype=3%26type=161%26fielddbtype=browser.unitCompany";
			break;
		default:
			break;
	}
	//console.log("url:"+url);
	return url;
}


$(function(){
	$("img.remindImg").attr("title",$("#remindInfo").text());
	
	$("select[name^=acttype]").live('change',function(){
		var val= $(this).val();
		var elename=$(this).attr("id");
		var idx=elename.substring(elename.lastIndexOf("_")+1,elename.length);
		if(val=="1"){//节点
			$("#actnode_"+idx).show();
			$("#actmethod_"+idx).show();
			$("#actlink_"+idx).hide();
		}else if(val=="0"){//出口
			$("#actnode_"+idx).hide();
			$("#actmethod_"+idx).hide();
			$("#actlink_"+idx).show();
		}else{
			$("#actnode_"+idx).hide();
			$("#actmethod_"+idx).hide();
			$("#actlink_"+idx).hide();
		}
	});
	
});
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

