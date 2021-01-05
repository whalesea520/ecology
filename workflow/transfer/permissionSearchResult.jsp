<!DOCTYPE html>
<%@ page import="weaver.general.Util"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.hrm.check.JobComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo"
	scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("Workflow:permission", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
    String objtype = Util.null2String(request.getParameter("objtype"));
    String objid = Util.null2String(request.getParameter("objid"));
    String wftype = Util.null2String(request.getParameter("wftypeid"));
    String wfname = Util.null2String(request.getParameter("wfname"));
    String wfnodetype = Util.null2String(request.getParameter("wfnodetype"));
    String wfnodename = Util.null2String(request.getParameter("wfnodename")); 
    
    String sltgidsql = "";
    String sltwfidsql = "";
    String sltcountsql = "";
    
    String objidspanvalue = "";
    int shareobjtype = 0;
    int count = 0;
    String sqlfrom = "";
    String sqlWhere = "1=1";
    if (!"".equals(objtype) && !"".equals(objid)) {
        //1,4,54,164
        if ("1".equals(objtype)) {
            shareobjtype = 3;
            
            ResourceComInfo resourceComInfo = new ResourceComInfo();
            objidspanvalue = resourceComInfo.getLastname(objid);
        } else if ("4".equals(objtype)) {
            shareobjtype = 1;
            
            DepartmentComInfo dc = new DepartmentComInfo() ;
            objidspanvalue = dc.getDepartmentname(objid);
        } else if ("65".equals(objtype)) {
            shareobjtype = 2;
            
            RolesComInfo rc = new RolesComInfo();
            objidspanvalue = rc.getRolesname(objid);
        } else if ("164".equals(objtype)) {
            shareobjtype = 30;
            
            DepartmentComInfo dc = new DepartmentComInfo() ;
            objidspanvalue = dc.getSubcompanyid1(objid);
        }
        else if ("58".equals(objtype)) {
            shareobjtype = 58;
            
            JobComInfo jobComInfo = new JobComInfo();
            objidspanvalue = jobComInfo.getJobName(objid);
        }
    }
%>


<HTML>
	<HEAD>
	<style type="text/css">
.btstyle01{
display:block;
width:111px;
height:39px;
text-align:center;
line-height:39px;
cursor:pointer;
background:#70a9ff;
color:#FFFFFF;
}

.btstyle02{
display:block;
width:111px;
height:39px;
text-align:center;
line-height:39px;
cursor:pointer;
background:#4891ff;
color:#FFFFFF;
}

.operateimages0{
width:32px; 
height:32px;
background:url('/images/ecology8/workflow/permissionc_wev8.png');
margin:0 auto;
}
.operateimages1{
width:32px; 
height:32px;
background:url('/images/ecology8/workflow/permissionr_wev8.png');
margin:0 auto;
}
.operateimages2{
width:32px; 
height:32px;
background:url('/images/ecology8/workflow/permissiond_wev8.png');
margin:0 auto;
}
	</style>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>		
		<script type="text/javascript" src="/mobile/plugin/login/jquery.animate-colors-min_wev8.js"></script>
		<script type="text/javascript">
			var timerID = null;
			var timerID2 = null;
			var uptcount = 0;
			$(function () {
				//execute(10);
				$("#objtype").change(function () {
					//$("#objid").val("");
					//$("#objidspan").html("");
					_writeBackData('objid', 2, {id:'',name:''});
					//$("#newobjid").val("");
					//$("#newobjidspan").html("");
					_writeBackData('newobjid', 2, {id:'',name:''});
					var url = "/workflow/transfer/permissionSearchResultIframe.jsp?objtype=" + $("#objtype").val() + "&objid=" + $("#objid");
					$("#contentframe").attr("src", url);
					//$("#frmmain")[0].submit();
				});
				
				$("#optflag").change(function () {
					var showval = $(this).val() + "";
					//alert(showval);
					if (showval == "0") {
						$("#objidDiv").show();
						jQuery("#operateimages").removeClass();
						jQuery("#operateimages").addClass("operateimages0");
					}else if (showval == "1") {
						$("#objidDiv").show();
						jQuery("#operateimages").removeClass();
						jQuery("#operateimages").addClass("operateimages1");
					}else if (showval == "2") {
						$("#objidDiv").hide();
						jQuery("#operateimages").removeClass();
						jQuery("#operateimages").addClass("operateimages2");
					} else {
						$("#objidDiv").show();
						jQuery("#operateimages").removeClass();
						jQuery("#operateimages").addClass("operateimages0");
					}
				});
				
				
				
				$("#startSearch").click(function () {
					var objid = $("#objid").val();
					if (!!!objid) {
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83065,user.getLanguage())%>");
						return;
					}
					//$("#frmmain")[0].submit();
					$("#contentframe").attr("src", url);
				});
				
				$("#startExecute").bind("click", function () {
					execute();
					if (true ) return;
					uptcount = Number($("#count").html());
					$("#count").animate({backgroundColor: "#AECED8"}, 1000)
					$("#updatecount").animate({backgroundColor: "#003C98"}, 1000)
					//$("#count").html("0");
					timerID2 = setInterval("num2('count')", 1); 
	            	timerID = setInterval("num('updatecount')", 1); 
	            	
				});
			});
			
	        function num(eleid) {
	        	console.log("==" + $("#" + eleid).html());
	            if (Number($("#" + eleid + "").html()) >= uptcount) {
	                clearInterval(timerID)
	            } else {
	                $("#" + eleid).html(Number($("#" + eleid + "").html()) + 1);
	            }
	        }
	        
	        function num2(eleid) {
	            if (Number($("#" + eleid + "").html()) <= 0) {
	                clearInterval(timerID2)
	            } else {
	                $("#" + eleid).html(Number($("#" + eleid + "").html()) - 1);
	            }
	        }
        
        	//获取url
        	function getajaxurl() {
        		var objtype = $("#objtype").val();
        		var url = "";
        		if(objtype == "58"){
        			url = "/data.jsp?type=24";
        		}else{
        			url = "/data.jsp?type=" + $("#objtype").val();
        		}
        		return url;
        	}
        	
        	function showBrowser(type, objid, objspanid) {
        		var url = "";
        		if (type === "1") {
        			url = "/";
        		} else if (type === "4") {
        		} else if (type === "65") {
        		} else if (type === "164") {
        		}
        	}
        	var dialog;
        	function execute() {
        		if ($("#optflag").val() != "2" && !!!$("#newobjid").val()) {
        			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84568,user.getLanguage())%>");
        			return;
        		}
        		if ($("#optflag").val() != "2" && $("#newobjid").val() == $("#objid").val()) {
        			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84569,user.getLanguage())%>");
        			return;
        		}
        		var checkboxids = "";
				$("[name=chkInTableTag]", $("#contentframe")[0].contentWindow.document).each(function (i, item) {
					if ($(this).attr("checked") == true || $(this).attr("checked") == "checked") {
						var checkboxid = $(this).attr("checkboxid");
						checkboxids += checkboxid + ",";
					}
				});
				
				if (checkboxids.length > 0) {
					checkboxids = checkboxids.substring(0, checkboxids.length - 1);
					if (window.top) {
	        			dialog = new window.top.Dialog();
	        		} else {
	        			dialog = new Dialog();
	        		}
					
					dialog.currentWindow = window; 
					var url = "/workflow/transfer/permissionExecute.jsp?gids=" + checkboxids + "&optflag=" + $("#optflag").val() + "&objtype=" + $("#objtype").val() + "&objid=" + $("#objid").val() + "&rlcobjid=" + $("#newobjid").val() + "&date=" + new Date().getTime();
					//alert(url);
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(16379,user.getLanguage())%>";
					dialog.Width = 350;
					dialog.Height = 170;
					dialog.URL = url;
					
					dialog.show();
				} else {
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84570,user.getLanguage())%>");
				}
        		
			}

			function flushData() {
				uptcount = Number($("#count").html());
				$("#updatecount").animate({backgroundColor: "#6586B8"}, 1000)
				if($("#optflag").val() != "1"){
					$("#count").animate({backgroundColor: "#AECED8"}, 1000)
					timerID2 = setInterval("num2('count')", 1); 
				}
				//$("#count").html("0");
				timerID = setInterval("num('updatecount')", 1);
				//$("#contentframe")[0].contentWindow._table.reLoad();
				search(document.getElementById('objid').value);
			}

			function closeDialog() {
				dialog.close();
			}

			function objChanged(obj, dataObj) {
				search(dataObj.id);
			}

			function objDeleted() {
				search('');
			}

			function search(val) {
				if (val == "") {
					//$("#contentframe")[0].contentWindow._table.reLoad();			
					uptcount = Number($("#count").html());
					//$("#count").html("0");
					$("#count").animate({backgroundColor: "#6586B8"}, 1000)
					$("#updatecount").animate({backgroundColor: "#AECED8"}, 1000)
					//$("#count").html("0");
					
					var timerID3 = setInterval(function () {
						if (Number($("#count").html()) <= 0) {
			                clearInterval(timerID3)
			            } else {
			                $("#count").html(Number($("#count").html()) - 1);
			            }
					}, 1); 
					timerID2 = setInterval("num2('updatecount')", 1); 
					
	            	//timerID = setInterval("num('updatecount')", 1); 
					//return ;
				}
				//$("#frmmain")[0].submit();
				
				var url = "/workflow/transfer/permissionSearchResultIframe.jsp?objtype=" + $("#objtype").val() + "&objid=" + $("#objid").val();
				$("#contentframe").attr("src", url);
			}
			
			function viewDetail(groupid) {
				var url = "/workflow/workflow/editoperatorgroup.jsp?isview=1&id=" + groupid;
				window.open(url)
			}
			
			function initCount(tempCount) {
				uptcount = tempCount;
//				$("#count").html("");
				clearInterval(timerID2)
				clearInterval(timerID)
				//初始化总数
				$("#count").animate({backgroundColor: "#6586B8"}, 1000)
				timerID = setInterval(function () {
		            if (Number($("#count").html()) == uptcount) {
		                clearInterval(timerID)
		            } else if (Number($("#count").html()) > uptcount){
		                $("#count").html(Number($.trim($("#count").html())) - 1);
		            } else if (Number($("#count").html()) < uptcount){
		                $("#count").html(Number($.trim($("#count").html())) + 1);
		            }
				}, 1);
			}
			
		</script>
	</head>
	<%
	    String imagefilename = "/images/hdMaintenance_wev8.gif";
	    String titlename = SystemEnv.getHtmlLabelName(70, user.getLanguage())+ ":" + SystemEnv.getHtmlLabelName(68, user.getLanguage());
	    String needfav = "1";
	    String needhelp = "";
	    String rulename = Util.null2String(request.getParameter("rulename"));
	    //String depid = Util.null2String(request.getParameter("depid"));
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<form action="/workflow/transfer/permissionSearchResult.jsp" name="frmmain" id="frmmain">
		<div id="top" style="position: absolute!important;width:99.5%;height:118px;border:1px solid #d6dde8;background:#f7f7fa;">
			<div style="display:block;float:left;width:288px;height:101px;border:1px solid #d6dde8;background:#ffffff;margin-top:8px;margin-left:7px;">
				<div id="count" style="float:left;width:77px;height:77px;background:url('/images/ecology8/workflow/permission1_wev8.png');text-align: center;line-height:77px;color:#fff;font-size:22px;margin:0 auto;margin-top:12px;margin-left:20px;">
					0
				</div>
				<div style="float:left;width:129px;height:62px;margin-top:21px;margin-left:39px;">
					<div style="margin:0 auto;">
						<select id="objtype" name="objtype" style="height:28px;width:101px;">
							<option value="1" <%="1".equals(objtype) ? " selected ": "" %>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage()) %></option>
							<option value="4" <%="4".equals(objtype) ? " selected ": "" %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) %></option>
							<option value="65" <%="65".equals(objtype) ? " selected ": "" %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage()) %></option>
							<option value="164" <%="164".equals(objtype) ? " selected ": "" %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></option>
							<option value="58" <%="58".equals(objtype) ? " selected ": "" %>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage()) %></option>
						</select>
					</div>
					<div style="margin:0 auto;margin-top:16px;">
						<brow:browser name="objid" viewType="0" hasBrowser="true" hasAdd="false" 
	                    	getBrowserUrlFn="onshowBrowser" isMustInput="2" isSingle="true" hasInput="true" 
	                    	completeUrl="javascript:getajaxurl()" _callback="objChanged" afterDelCallback="objDeleted" width="129px" browserValue='<%=objid %>' browserSpanValue='<%=objidspanvalue %>' />
					</div>
				</div>
			
			</div>

			<div style="float:left;width:119px;height:101px;margin-top:8px;">
				<div style="width:104px; height:25px;background:url('/images/ecology8/workflow/permissionto_wev8.png');margin:0 auto;margin-top:24px;"></div>
				<div id="operateimages" name="operateimages" class="operateimages0"></div>
			</div>
		

			<div style="float:left;width:288px;height:101px;border:1px solid #d6dde8;background:#ffffff;margin-top:8px;">
				<div id="updatecount" style="float:left;width:77px;height:77px;background:url('/images/ecology8/workflow/permission2_wev8.png');text-align: center;line-height:70px;color:#fff;font-size:22px;margin:0 auto;margin-top:12px;margin-left:20px;">
					0
				</div>
				<div style="float:left;width:129px;height:62px;margin-top:21px;margin-left:39px;">
					<div style="margin:0 auto;">
						<select id="optflag" name="optflag" style="height:28px;width:101px;">
							<option value="0"><%=SystemEnv.getHtmlLabelName(83020,user.getLanguage()) %></option>
							<option value="1"><%=SystemEnv.getHtmlLabelName(125350,user.getLanguage()) %></option>
							<option value="2"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %></option>
						</select>
					</div>
					<div id="objidDiv" style="margin:0 auto;margin-top:16px;">
					 	<brow:browser name="newobjid" viewType="0" hasBrowser="true" hasAdd="false" 
		                    getBrowserUrlFn="onshowBrowser2" isMustInput="2" isSingle="true" hasInput="true"
		                    completeUrl="javascript:getajaxurl()" onPropertyChange="" width="129px" browserValue="" browserSpanValue="" />
					</div>
				</div>
			</div>
			<div style="float:left;width:111px;height:39px;margin-top:68px;margin-left:39px;">
				<a id="startExecute" onmouseover="showBt(this)" onmouseout="hiddenBt(this)"  href="#" style="vertical-align:middle;"><span class="btstyle01"><%=SystemEnv.getHtmlLabelName(83073,user.getLanguage()) %></span></a>
			</div>
					
					<!-- 
						<div style="height:100%;width:100px;background:#2597F0;float:left;line-height:70px;font-size:20px;text-align: center;">
						复制
						</div>
						
						&nbsp;
						<div style="height:100%;width:100px;background:#2597permissionSearchResult.jspF0;float:left;line-height:70px;font-size:20px;text-align: center;">
						替换
						
						</div>&nbsp;
					 	<div style="height:100%;width:100px;background:#2597F0;float:left;line-height:70px;font-size:20px;text-align: center;">
						删除
						</div>
					 &nbsp;
			<div style="width:100%;background:#E5E5E5;height:2px!important;display:inline-block;"></div>
					  -->


	</div>
	
	<div id="main" style="position: absolute!important;top:120px!important;height:auto!important;position: relative;height:100%;bottom:4px;width:100%;overflow: auto;">
		<iframe src="/workflow/transfer/permissionSearchResultIframe.jsp?objtype=<%=objtype %>&objid=<%=objid %>" id="contentframe" name="" contentframe" class="flowFrame" frameborder="0" height="100%" width="100%"></iframe>
	</div>
		</form>
	</BODY>
	
<script type="text/javascript">
$(document).ready(function(){
	$("#objtype").selectbox();
	$("#optflag").selectbox();

	//$(".explain").hover(function () {}, function () {
	//	hiddenExplain();
	//	hiddenExplain1();
	//} );
});
function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			if (rid.indexOf(",") == 0) {
				rid = rid.substr(1);
				rname = rname.substr(1);
			}
			curl = "#";
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ rid + "'>"
						+ rname + "</a>";
			} else {
				spanobj.innerHTML = rname;
			}
			inputobj.value = rid;
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function showBt(obj){
	$(obj).find(".btstyle01").addClass("btstyle02");
}

function hiddenBt(obj){
	$(obj).find(".btstyle01").removeClass("btstyle02");
}


</script>

<script type="text/javascript">
function onshowBrowser() {
	var type = Number($("#objtype").val());
	var objid = "objid";
	var objspan = "objidspan";
	var url = "";
	if (type == 1) {
		url = onShowResource(objspan, objid);
	} else if (type == 4) {
		url = onShowDepartment(objspan, objid);
	} else if (type == 65) {
		url = onShowRole(objspan, objid);
	} else if (type == 164) {
		url = onShowSubcompany(objspan, objid);
	}else if (type == 58) {
		url = onShowJob(objspan, objid);
	}
	search(document.getElementById("objid").value);
	return url;
}

function onshowBrowser2() {
	var type = Number($("#objtype").val());
	var objid = "newobjid";
	var objspan = "newobjidspan";
	var url = "";
	if (type == 1) {
		url = onShowResource(objspan, objid);
	} else if (type == 4) {
		url = onShowDepartment(objspan, objid);
	} else if (type == 65) {
		url = onShowRole(objspan, objid);
	} else if (type == 164) {
		url = onShowSubcompany(objspan, objid);
	}else if (type == 58) {
		url = onShowJob(objspan, objid);
	}
	return url;
}

function onShowJob(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids="+ $G(inputename).value;
	return url;
}

function onShowDepartment(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $G(inputename).value;
	return url;
}

function onShowMutiDepartment(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids=" + $G(inputename).value + "&selectedDepartmentIds=" + $G(inputename).value
	disModalDialog(url, $G(tdname), $G(inputename), false);
}

function onShowSubcompany(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G(inputename).value;
	return url;
}
function onShowResource(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	return url;
}


function onShowRole(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
	return url;
}

function submitData()
{
	if (check_form(weaver,'PrjName,PrjType,WorkType,hrmids02,SecuLevel,PrjManager,PrjDept'))
		weaver.submit();
}
</script>
</HTML>
