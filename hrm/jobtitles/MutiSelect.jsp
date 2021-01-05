<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String tabid = Util.null2String(request.getParameter("tabid"),"0");
String nodeid = Util.null2String(request.getParameter("nodeid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String suibian1 = Util.null2String(request.getParameter("suibian1"));

int uid=user.getUID();
String rem=(String)session.getAttribute("jobtitlesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("jobtitlesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }

if(rem!=null)
  rem=tabid+rem.substring(1);
else
  rem=tabid;
if(!nodeid.equals(""))
  rem=rem.substring(0,1)+"|"+nodeid;


session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(tabid.equals("0")&&atts.length>1){
   nodeid=atts[1];
  if(nodeid.indexOf("com")>-1){
    subcompanyid=nodeid.substring(nodeid.indexOf("_")+1);
    }
  else{
    departmentid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    }
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String jobtitlemark = Util.null2String(request.getParameter("jobtitlemark"));
String jobtitlename = Util.null2String(request.getParameter("jobtitlename"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));
boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
String jobtitles = Util.null2String(request.getParameter("jobtitles"));
%>

<HTML><HEAD>
	<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
	<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.parent.getParentWindow(parent.parent);
			dialog = parent.parent.parent.getDialog(parent.parent);
		}
		catch(e){}
		function showMultiDocDialog(selectids){
			var config = null;
			config= rightsplugingForBrowser.createConfig();
			  config.srchead=["<%=SystemEnv.getHtmlLabelName(399,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(15767,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>"];
			  config.container =$("#colShow");
			  config.searchLabel="";
			  config.hiddenfield="id";
			  config.saveLazy = true;//取消实时保存
			config.srcurl = "/hrm/jobtitles/MultiJobtitlesBrowserAjax.jsp?src=src";
		  	config.desturl = "/hrm/jobtitles/MultiJobtitlesBrowserAjax.jsp?src=dest";
		  config.pagesize = 10;
		  config.formId = "SearchForm";
		  config.target = "frame1";
		  config.parentWin = window.parent.parent;
		  config.selectids = selectids;
			try{
				config.dialog = dialog;
			}catch(e){
				alert(e)
			}
		   	jQuery("#colShow").html("");
		    rightsplugingForBrowser.createRightsPluing(config);
		    jQuery("#btnok").bind("click",function(){
		    	rightsplugingForBrowser.system_btnok_onclick(config);
		    });
		    jQuery("#btnclear").bind("click",function(){
		    	rightsplugingForBrowser.system_btnclear_onclick(config);
		    });
		    jQuery("#btncancel").bind("click",function(){
		    	rightsplugingForBrowser.system_btncancel_onclick(config);
		    });
		    jQuery("#btnsearch").bind("click",function(){
		    	rightsplugingForBrowser.system_btnsearch_onclick(config);
		    });
		}
		
		function btnOnSearch(){
			jQuery("#btnsearch").trigger("click");
		}
	</script>
</HEAD>
<body scroll="no">
<div class="zDialog_div_content">
	<FORM id="SearchForm" NAME="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
		<input type="hidden" name="cmd" value='HrmJobTitlesMultiSelect'>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="tabid" id="tabid" value='<%=tabid%>'>
		<input type="hidden" name="jobtitlemark" id="jobtitlemark" value='<%=jobtitlemark%>'>
		<input type="hidden" name="jobtitlename" id="jobtitlename" value='<%=jobtitlename%>'>
		<input type="hidden" name="subcompanyid" id="subcompanyid" value='<%=subcompanyid%>'>
		<input type="hidden" name="departmentid" id="departmentid" value='<%=departmentid%>'>
		<input type="hidden" name="jobtitles" id="jobtitles" value='<%=jobtitles%>'>
		<div id="dialog" style="height: 225px;">
			<div id='colShow'></div>
		</div>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
	
	function onSearch(){
		jQuery("#btnsearch").click();
	}
	
</script>
</div>

</body>
<SCRIPT language="javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}

function reBindCornerEvent(){
	var corner = jQuery("span.cornerMenu",parent.document);
	if(corner.length==0){
		window.setTimeout(function(){reBindCornerEvent();},500);
	}else{
		window.setTimeout(function(){
			var e8_head = jQuery(".e8_box",parent.document).find("div.e8_boxhead");
			if(e8_head.length==0){
				e8_head = jQuery(".e8_box",parent.document).find("div#rightBox");
			}
			var contentWindow = jQuery("#frame1",parent.document).get(0).contentWindow;
			corner.unbind("click",parent.initBindEvent).bind("click",function(){
				parent.bindCornerMenuEvent(e8_head,contentWindow,null);
			});
		},1000);
	}
		jQuery("#btnsearch").hide();
}

jQuery(document).ready(function(){
	showMultiDocDialog("<%=jobtitles%>");
});
</script>
</html>