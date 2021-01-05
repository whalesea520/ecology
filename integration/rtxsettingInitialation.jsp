
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<link href="/integration/css/jquery-ui-1.10.4.custom.css" rel="stylesheet">
<script src="/integration/js/jquery-1.10.2.js"></script>
<script src="/integration/js/jquery-ui-1.10.4.custom.js"></script>
<script src="/integration/js/jquery-migrate-1.2.1.js"></script>

<STYLE>
	<style>
	#divprogressbar{
	    width:300px;
	    height:30px;
	   }
	   
	   .ui-widget-header{
	   	background-color:#9DDBAD;
	   }
	   .progress-label_company{
		    float:left;
		    margin-left:30%;
		    margin-top:3px;
		    text-align:right;
   		}
   		.progress-label_hrm{
		    float:left;
		    margin-left:30%;
		    margin-top:3px;
		    text-align:right;
   		}
	</style>
</STYLE>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:rtxsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String test = Util.null2String(request.getParameter("test"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33387,user.getLanguage());//集成
String needfav ="1";
String needhelp ="";

int isusedtx = Util.getIntValue(Util.null2String(request.getParameter("isusedtx")),0);
String rtxserverurl = Util.null2String(request.getParameter("rtxserverurl"));
String rtxserverouturl = Util.null2String(request.getParameter("rtxserverouturl"));
String rtxserverport = Util.null2String(request.getParameter("rtxserverport"));
String rtxOrElinkType = Util.null2String(request.getParameter("rtxOrElinkType"));
String rtxVersion = Util.null2String(request.getParameter("rtxVersion"));
String rtxOnload = Util.null2String(request.getParameter("rtxOnload"));
String rtxDenyHrm = Util.null2String(request.getParameter("rtxDenyHrm"));
String rtxAlert = Util.null2String(request.getParameter("rtxAlert"));
String domainName = Util.null2String(request.getParameter("domainName"));
String rtxConnServer = Util.null2String(request.getParameter("rtxConnServer"));
String userattr = Util.fromScreen(request.getParameter("userattr1"),user.getLanguage());
String rtxLoginToOA = Util.null2String(request.getParameter("rtxLoginToOA"));
String impwd = Util.null2String(request.getParameter("impwd"));
String isDownload = Util.null2String(request.getParameter("isDownload"));

//String uuid = UUID.randomUUID().toString().replaceAll("-", "");
String uuid = "";
boolean isDoingRtxop = false;

boolean dept_flag = OrganisationCom.isRtxDeptOpFlag();
boolean hrm_flag = OrganisationCom.isRtxHrmOpFlag();
boolean rtxop_flag = OrganisationCom.isRtxOpFlag();

isDoingRtxop = rtxop_flag && (dept_flag || hrm_flag);


if("".equals(uuid)){
	uuid = UUID.randomUUID().toString().replaceAll("-", "");
}
%>

<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value='<%="IM"+SystemEnv.getHtmlLabelNames("20873,847" ,user.getLanguage()) %>'/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<table style="width:100%">
<tr><td><%=SystemEnv.getHtmlLabelNames("16455,18240" ,user.getLanguage()) %></td></tr>
<tr><td>
	<div id="divprogressbar_company"><div class="progress-label_company"><%=SystemEnv.getHtmlLabelNames("126134" ,user.getLanguage()) %>...</div></div>
</td></tr>
<tr><td><%=SystemEnv.getHtmlLabelNames("1867,18240" ,user.getLanguage()) %></td></tr>
<tr><td>
	<div id="divprogressbar_hrm" style="hi"><div class="progress-label_hrm"><%=SystemEnv.getHtmlLabelNames("126134" ,user.getLanguage()) %>...</div></div>
</td></tr>
</table>


</BODY>
<iframe name="ajaxUpload" id="ajaxUpload" src="" style="display:none" ></iframe>
<script language="javascript">
var uuid = "<%=uuid%>";
jQuery(document).ready(function(){
	  jQuery('#divprogressbar_company').progressbar({value:0});
	  jQuery('#divprogressbar_company').progressbar({
          value:0,
          change:function(){
              jQuery(".progress-label_company").text($("#divprogressbar_company").progressbar("value")+"%");
          },
          complete:function(){
        	  jQuery(".progress-label_company").text("100% <%=SystemEnv.getHtmlLabelNames("20873,555" ,user.getLanguage()) %>!");
          }

       });
	  
	  jQuery('#divprogressbar_hrm').progressbar({value:0});
	  jQuery('#divprogressbar_hrm').progressbar({
          value:0,
          change:function(){
        	  jQuery(".progress-label_hrm").text($("#divprogressbar_hrm").progressbar("value")+"%");
          },
          complete:function(){
        	  jQuery(".progress-label_hrm").text("100% <%=SystemEnv.getHtmlLabelNames("20873,555" ,user.getLanguage()) %>!");
          }

       });
      initProgressBar();
});

function initProgressBar(){
	loadFnaBudgetEditSaveFnaLoadingAjax(uuid);
	
	<%if(!isDoingRtxop){%>
		var isusedtx = "<%=isusedtx%>";
		var rtxserverurl = "<%=rtxserverurl%>";
		var rtxserverouturl = "<%=rtxserverouturl%>";
		
		var rtxserverport = "<%=rtxserverport%>";
		var rtxOrElinkType = "<%=rtxOrElinkType%>";
		var rtxVersion = "<%=rtxVersion%>";
		
		var rtxOnload = "<%=rtxOnload%>";
		var rtxDenyHrm = "<%=rtxDenyHrm%>";
		var rtxAlert = "<%=rtxAlert%>";
		
		var domainName = "<%=domainName%>";
		var rtxConnServer = "<%=rtxConnServer%>";
		var userattr = "<%=userattr%>";
		
		var rtxLoginToOA = "<%=rtxLoginToOA%>";
		var impwd = "<%=impwd%>";
		var isDownload = "<%=isDownload%>";
		
		var _data = "method=syn&fromProcessBar=1"+
					"&isusedtx="+isusedtx+"&rtxserverurl="+rtxserverurl+"&rtxserverouturl="+rtxserverouturl+
					"&rtxserverport="+rtxserverport+"&rtxOrElinkType="+rtxOrElinkType+"&rtxVersion="+rtxVersion+
					"&rtxOnload="+rtxOnload+"&rtxDenyHrm="+rtxDenyHrm+"&rtxAlert="+rtxAlert+
					"&domainName="+domainName+"&rtxConnServer="+rtxConnServer+"&userattr="+userattr+
					"&rtxLoginToOA="+rtxLoginToOA+"&impwd="+impwd+"&uuid="+uuid+"&isDownload="+isDownload;;
		jQuery.ajax({
			url : "/integration/rtxsettingOperation.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(fnainfo){
			}
		});
	<%}%>
}

var flag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(uuid){
	if(!flag){
		jQuery.ajax({
			url : "/integration/rtxsettingOperationAjax.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : "uuid="+uuid,
			dataType : "json",
			success: function do4Success(_html){
			    try{
			    	var _html_company_flag = _html.companyFlag;
			    	var _html_hrm_flag = _html.hrmFlag;
			    	var _html_rtxop_flag = _html.hasComplished;
			    	var _html_rtxop_Errorflag = _html.rtxOpErrorFlag;
			    	var _html_rtxop_Errorinfo = _html.rtxOpErrorInfo;
			    	
			    	if(_html_rtxop_Errorflag){
			    		jQuery("#divprogressbar_hrm").find(".progress-label_hrm").html(_html_rtxop_Errorinfo);
			    		jQuery("#divprogressbar_company").find(".progress-label_company").html(_html_rtxop_Errorinfo);
			    		flag = true;
			    	}else{
			    		if(_html_company_flag){
				    		var _html_company_process = _html.company;
				    		jQuery('#divprogressbar_company').progressbar("option","value",_html_company_process*1.0);
				    	}
				    	
				    	if(_html_hrm_flag){
				    		var _html_hrm_process = _html.hrm;
				    		jQuery('#divprogressbar_hrm').progressbar("option","value",_html_hrm_process*1.0);
				    	}
				    	
				    	if(_html_rtxop_flag){
				    		flag = true;
				    	}
				    	setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(uuid)", "100");
			    	}
			    }catch(e1){alert(e1);}
			}
		});	
	}
}

$(".cornerMenu").remove();
</script>

</HTML>
