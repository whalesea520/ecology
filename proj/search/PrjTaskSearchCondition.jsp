<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.*"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>

<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<%
String needshowadv = Util.null2String(request.getParameter("needshowadv"));

String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String method=Util.null2String(request.getParameter("method"));
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);	
%>



<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(101,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid = user.getUID();

String taskname = Util.null2String(request.getParameter("taskname"));
String planbegindate = Util.null2String(request.getParameter("planbegindate"));
String planbegindate1 = Util.null2String(request.getParameter("planbegindate1"));
String planenddate = Util.null2String(request.getParameter("planenddate"));
String planenddate1 = Util.null2String(request.getParameter("planenddate1"));
String actualbegindate = Util.null2String(request.getParameter("actualbegindate"));
String actualbegindate1 = Util.null2String(request.getParameter("actualbegindate1"));
String finish = Util.null2String(request.getParameter("finish"));
String finish1 = Util.null2String(request.getParameter("finish1"));
String taskstatus = Util.null2String(request.getParameter("taskstatus"));
String prjname = Util.null2String(request.getParameter("prjname"));
String manager = Util.null2String(request.getParameter("manager"));
String managerdept = Util.null2String(request.getParameter("managerdept"));
String hrmid = Util.null2String(request.getParameter("hrmid"));



%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:onReset(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

if(false && mouldid==0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveas(),_top}";
RCMenuHeight += RCMenuHeightStep;
} 

if(false && mouldid!=0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top}" ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top}" ;
RCMenuHeight += RCMenuHeightStep;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form2" id="form2" method="post"  action="SearchTaskResult.jsp">
<input type="hidden" name="fromassortmenttab_name" value="<%=nameQuery %>" />
<input type="hidden" name="needshowadv" id="needshowadv" value="<%=needshowadv %>" />
<input type="hidden" name="mouldname" value="" />
<input type="hidden" name="operation" value="" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" onclick="onSearch();" />
			<input class="e8_btn_top" type="button" name="btn_reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>" onclick="$('input[name=reset]').trigger('click');" />
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>


	<wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelNames("1352",user.getLanguage())%></wea:item>
			<wea:item><input class="InputStyle" name="taskname" id="taskname" value='<%=taskname %>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("847",user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle style="width:60px!important;" maxlength=3 size=5 value="<%=finish%>" name="finish" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
				-<input class=InputStyle style="width:60px!important;" maxlength=3 size=5 value="<%=finish1%>" name="finish1" onkeypress="return event.keyCode>=4&&event.keyCode<=57">
				%
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("22074",user.getLanguage())%></wea:item>
			<wea:item>
				<select name="taskstatus">
					<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
					<option value="0" <%="0".equals(taskstatus)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("225",user.getLanguage())%></option>
					<option value="1" <%="1".equals(taskstatus)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("2242",user.getLanguage())%></option>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("83796",user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="planbegindate_sel" selectValue="">
					  <input class=wuiDateSel type="hidden" name="planbegindate" value="<%=planbegindate%>">
					  <input class=wuiDateSel  type="hidden" name="planbegindate1" value="<%=planbegindate1%>">
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("22170",user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="planendate_sel" selectValue="">
					  <input class=wuiDateSel type="hidden" name="planenddate" value="<%=planenddate%>">
					  <input class=wuiDateSel  type="hidden" name="planenddate1" value="<%=planenddate1%>">
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("15285",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="hrmid" 
					browserValue='<%=hrmid %>' 
					browserSpanValue='<%=ResourceComInfo.getResourcename (""+hrmid) %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp"  />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelNames("1353",user.getLanguage())%></wea:item>
			<wea:item><input class="InputStyle" name="prjname" id="prjname" value='<%=prjname %>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("16573",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="manager" 
					browserValue='<%=manager %>' 
					browserSpanValue='<%=ResourceComInfo.getResourcename (""+manager) %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp"  />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("83797",user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="managerdept" 
					browserValue='<%=managerdept %>' 
					browserSpanValue='<%=DepartmentComInfo.getDepartmentname(""+managerdept ) %>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=4"  />
			</wea:item>

		</wea:group>
		
		
	</wea:layout>
<div style="height:50px!important;"></div>
	
<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="display:none;">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="查询"/>
	    	<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    	<input class="zd_btn_submit" type="button" name="savetmp" onclick="onSaveas();" value="<%=SystemEnv.getHtmlLabelNames("18418",user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>

<script language="javascript">
function onSearch(){
	$("input[name=submit1]").trigger('click');
}
function onReset(){
	$("input[type=reset]").trigger('click');
}

function onBtnSearchClick(){
	$("input[name=submit1]").trigger('click');
}

function onDelete(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83695",user.getLanguage())%>',function(){
		jQuery.post(
			"/proj/search/SearchMouldOperation.jsp",
			{"operation":"delete","mouldid":'<%=mouldid %>'},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					document.form2.action="PrjSearchCondition.jsp";
					$("input[name=needshowadv]").val('1');
					$("input[name=submit1]").trigger('click');
				});
			}
		);
		
	});
}
function onSave(){
	document.form2.operation.value="update";
	document.form2.target="";
	var params=$("#form2").serialize();
	jQuery.ajax({
		url : "SearchMouldOperation.jsp",
		type : "post",
		async : true,
		data : params,
		dataType : "text",
		contentType: "application/x-www-form-urlencoded;charset=utf-8",
		success: function do4Success(data){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
		}
	});
}

function onSaveas(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 330;
	dialog.Height = 88;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("19468",user.getLanguage())%>";
	dialog.URL ="/proj/search/PrjSaveAsMould.jsp?isdialog=0";
	dialog.OKEvent = function(){
		document.form2.mouldname.value=dialog.innerFrame.contentWindow.document.getElementById('assortmentname').value;
		if(document.form2.mouldname.value==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			return;
		}else{
			document.form2.operation.value="add";
			document.form2.target="";
			var params=$("#form2").serialize();
			jQuery.ajax({
				url : "SearchMouldOperation.jsp",
				type : "post",
				async : true,
				data : params,
				dataType : "text",
				contentType: "application/x-www-form-urlencoded;charset=utf-8",
				success: function do4Success(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
					dialog.close();
					
				}
			});	
		}
		
	};
	dialog.show();
}

$(function(){
	$("#mouldid").bind('change',function(){
		document.form2.action="PrjSearchCondition.jsp";
		$("input[name=needshowadv]").val('1');
		$("input[name=submit1]").trigger('click');
	});
	
});


jQuery(document).ready(function(){
	
	/**hideGroup("moreKeyWord");
	
	var showText = "显示";
	var hideText = "隐藏";
	var languageid=readCookie("languageidweaver");
	if(languageid==8){
		showText = "Display";
		hideText = "Hide";
	}else if(languageid==9){
		showText = "顯示";
		hideText = "隐藏";
	}

	jQuery("#moreSearch_Span").unbind("click").bind("click", function () {
		var _status = jQuery(this).attr("_status");
		var currentTREle = jQuery(this).closest("table").closest("TR");
		if (!!!_status || _status == "0") {
			jQuery(this).attr("_status", "1");
			jQuery(this).html(showText+"<image src='/wui/theme/ecology8/templates/default/images/1_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").hide();
			hideGroup("moreKeyWord");
		} else {
			jQuery(this).attr("_status", "0");
			jQuery(this).html(hideText+"<image src='/wui/theme/ecology8/templates/default/images/2_wev8.png'>");
			currentTREle.next("TR.Spacing").next("TR.items").show();
			showGroup("moreKeyWord");
		}
	}).hover(function(){
		$(this).css("color","#000000");
	},function(){
		$(this).css("color","#cccccc");
	});**/
});

$(function(){
	try{
		parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(24457,user.getLanguage()) %>');
	}catch(e){}
});


$(function(){
	//setTimeout("hideLeftTree()",10);
});

function hideLeftTree(){
	$('#oTd1', parent.parent.document).slideLeftHide(200);
}
</script>

<script type="text/javascript">
	jQuery.fn.slideLeftHide = function( speed, callback ) {
		this.animate({
			width : "hide",
			paddingLeft : "hide",
			paddingRight : "hide",
			marginLeft : "hide",
			marginRight : "hide"
		}, speed, callback );
	};
	jQuery.fn.slideLeftShow = function( speed, callback ) {
		this.animate({
			width : "show",
			paddingLeft : "show",
			paddingRight : "show",
			marginLeft : "show",
			marginRight : "show"
		}, speed, callback );
	};
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
