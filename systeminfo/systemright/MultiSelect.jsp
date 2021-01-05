
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String selectids = Util.null2String(request.getParameter("selectids"));
	String resourceids = Util.null2String(request.getParameter("resourceids"));
	if(selectids.length()==0)selectids = resourceids;
	String rightname = Util.null2String(request.getParameter("rightname"));
	String rightdesc = Util.null2String(request.getParameter("rightdesc"));
	String righttype = Util.null2String(request.getParameter("righttype"));
	String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(385,user.getLanguage());
	String needfav ="1";
	String needhelp ="1";
%>
<HTML>
	<HEAD>
		<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/dragBox/e8browser_wev8.css">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
		<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			try{
				dialog = parent.parent.parent.getDialog(parent.parent);
			}catch(ex1){}
			
			function showMultiDocDialog(selectids){
				var config = null;
				config= rightsplugingForBrowser.createConfig();
				config.srchead=["<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>"];
				config.container =$("#colShow");
				config.searchLabel="";
				config.hiddenfield="id";
				config.saveLazy = true;
				config.srcurl = encodeURI(encodeURI("/systeminfo/systemright/MultiSystemRightBrowserAjax.jsp?src=src"));
				config.desturl = "/systeminfo/systemright/MultiSystemRightBrowserAjax.jsp?src=dest";
				config.pagesize = 10;
				config.formId = "SearchForm";
				config.selectids = selectids;
				try{
					config.dialog = dialog;
				}catch(e){
					alert(e)
				}
				jQuery("#colShow").html("");
				rightsplugingForBrowser.createRightsPluing(config);
				jQuery("#btnok").bind("click",function(){
					var dest = config.container.find("table.e8_box_target tbody tr");
					var ids = config.container.find("#systemIds").val();
					var names = "";
					if(!!ids){
						dest.each(function(){
							var name = jQuery(this).children("td").eq(1).text();
							if(names==""){
								names = name;
							}else{
								names=names + ","+name;
							}
						});
					}
					window.parent.setValue({id:ids,name:names});
				});
				jQuery("#btnclear").bind("click",function(){
					window.location.reload();
				});
				jQuery("#btncancel").bind("click",function(){
					rightsplugingForBrowser.system_btncancel_onclick(config);
				});
			}

			function btnOnSearch(){
				jQuery("#btnsearch").trigger("click");
			}
			
			var resourceids =""
			var resourcenames = ""
			function reset_onclick(){
				document.all("rightname").value="";
				document.all("rightdesc").value="";
			}
			function btnclear_onclick(){
				window.location.reload();
			}

			function btnok_onclick(){
				setResourceStr();
				replaceStr();
				window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
				window.parent.parent.close();
			}
			function btncancel_onclick(){
				 window.close();
			}

			var resourceids="";
			function btnsearch_onclick(){
				setResourceStr() ;
				$("input[name=selectids]").val($("input[name=systemIds]").val());
				$("#SearchForm").submit();
			}

			function setResourceStr(){
				
				var resourceids1 =""
					var resourcenames1 = ""
				 try{   
				for(var i=0;i<parent.frame2.resourceArray.length;i++){
					resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;
					
					resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
				}
				resourceids=resourceids1
				resourcenames=resourcenames1
				 }catch(err){}
			}

			function replaceStr(){
				var re=new RegExp("[ ]*[|][^|]*[|]","g")
				resourcenames=resourcenames.replace(re,"|")
				re=new RegExp("[|][^,]*","g")
				resourcenames=resourcenames.replace(re,"")
			}
		</script>
	</head>
	<body scroll="no">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
				RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsearch_onclick(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div class="zDialog_div_content">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
							<input type=button class="e8_btn_top" onclick="btnsearch_onclick();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
						<wea:item><input class=inputstyle name=rightname value='<%=rightname%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
						<wea:item><input class=inputstyle name=rightdesc value='<%=rightdesc%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item>
							<select style="width:65%" id=righttype name=righttype >
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value=0 <%=righttype.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></option>
								<option value=1 <%=righttype.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
								<option value=2 <%=righttype.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></option>
								<option value=3 <%=righttype.equals("3")?"selected":""%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
								<option value=8 <%=righttype.equals("8")?"selected":""%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
								<option value=5 <%=righttype.equals("5")?"selected":""%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></option>
								<option value=6 <%=righttype.equals("6")?"selected":""%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
								<option value=7 <%=righttype.equals("7")?"selected":""%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></option>
								<option value=9 <%=righttype.equals("9")?"selected":""%>><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
				</wea:layout>
				<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
				<input type="hidden" name="selectids" id="selectids" value='<%=selectids%>'>
				<input type="hidden" name="pagenum" value=''>
				<div id="dialog" style="height: 250px;">
					<div id='colShow'></div>
				</div>
			</FORM>
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
			</script>
		</div>
		<SCRIPT language="javascript">
			jQuery(document).ready(function(){
				showMultiDocDialog("<%=selectids%>");
			});
		</script>
	</body>
</html>
