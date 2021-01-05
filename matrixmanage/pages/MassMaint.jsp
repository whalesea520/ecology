<!DOCTYPE html>
<%@ page import="weaver.general.Util"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
   
//数据批量维护权限
boolean canmaint = HrmUserVarify.checkUserRight("Matrix:MassMaint",user);
if (!canmaint) {
	response.sendRedirect("/notice/noright.jsp");
	return;
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
		<script type="text/javascript">
			var timerID = null;
			var timerID2 = null;
			var uptcount = 0;
			$(function () {			
			
			    $("#objtype").change(function () {
					if($("#objid").val()){
					   queryrecord($("#objid").val(),1);
					}
				});
				
				$("#optflag").change(function () {
					var showval = $(this).val() + "";
					//alert(showval);
					if (showval == "0") {
						$("#newobjid").parents(".e8_os").show();
						jQuery("#operateimages").removeClass();
						jQuery("#operateimages").addClass("operateimages0");
					}else if (showval == "1") {
						$("#newobjid").parents(".e8_os").hide();
						jQuery("#operateimages").removeClass();
						jQuery("#operateimages").addClass("operateimages2");
					}
					
					$("#newobjid").val("");
					$("#newobjidspan").html("");
				});
				
				
				
				$("#startSearch").click(function () {
					var objid = $("#objid").val();
					if (!!!objid) {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83065, user.getLanguage()) %>");
						return;
					}
					//$("#frmmain")[0].submit();
					$("#contentframe").attr("src", url);
				});
				
				$("#startExecute").bind("click", function () {
				    startExec();
				});
			});
			
			//开始执行
			function  startExec(){
			
				if (!!!$("#objid").val()) {
					    if($("#optflag").val() === '1'){
					        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83066, user.getLanguage()) %>");
					    }else
	        			    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83067, user.getLanguage()) %>");
	        			return;
	        		}
	        		if ($("#count").html() == 0) {
	        			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83068, user.getLanguage()) %>");
	        			return;
	        		}
	        		if ($("#optflag").val() != "1" && !!!$("#newobjid").val()) {
	        			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83069, user.getLanguage()) %>");
	        			return;
	        		}
					
					window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83070, user.getLanguage()) %>',function(){
				       execute();	 
				   });
			
			
			}
			
	       
        	function execute() {
        	    loading(0);
        	    $.ajax({
                    data: null,
                    type: "POST",
                    url: "/matrixmanage/pages/MassMaintOperation.jsp?matrixid=" + $("#objtype").val() + "&olduserid=" + $("#objid").val()+"&newuserid="+$("#newobjid").val()+"&method=replacerecord",
                    timeout: 20000,
                    success: function (rs) {
                        loading(1);
                        if (rs.trim() ==1) {//成功
                            $("#updatecount").html($("#count").html());
                            queryrecord($("#newobjid").val(),0);
                        } else {
                            window.top.Dialog.alert(rs);
                        }
                    }, fail: function () {
                       window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83071, user.getLanguage()) %>');
                    }
                });
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
			
			function initUpdateCount(count) {
				$("#updatecount").html(count);
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
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%

             RCMenu += "{"+SystemEnv.getHtmlLabelName(530,user.getLanguage())+SystemEnv.getHtmlLabelName(1338,user.getLanguage())+",javascript:startExec(),_self} " ;    
             RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="/workflow/transfer/permissionSearchResult.jsp" name="frmmain" id="frmmain">
		<div id="top" style="position: absolute!important;width:99.5%;height:118px;border:1px solid #d6dde8;background:#f7f7fa;">
			<div style="display:block;float:left;width:288px;height:101px;border:1px solid #d6dde8;background:#ffffff;margin-top:8px;margin-left:7px;">
				<div id="count" title="<%=SystemEnv.getHtmlLabelName(83935,user.getLanguage())%>" style="float:left;width:77px;height:77px;background:url('/images/ecology8/workflow/permission1_wev8.png');text-align: center;line-height:77px;color:#fff;font-size:22px;margin:0 auto;margin-top:12px;margin-left:20px;">
					0
				</div>
				<div style="float:left;width:129px;height:62px;margin-top:21px;margin-left:39px;">
					<div style="margin:0 auto;">
						<select id="objtype" name="objtype" title="<%=SystemEnv.getHtmlLabelName(83936 ,user.getLanguage())%>" style="height:28px;width:101px;">
							 <% 
					          RecordSet.executeSql("select * from MatrixInfo ");
					          while(RecordSet.next()) {
					        	  int matrixid = RecordSet.getInt("id");
					         %>
				               <option value="<%=matrixid%>" ><%=RecordSet.getString("name")%></option>
				             <%}%>
						</select>
					</div>
					<div style="margin:0 auto;margin-top:16px;">
						<brow:browser viewType="0" name="objid" browserValue="" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' _callback="afterCallBack"
			completeUrl="/data.jsp" linkUrl="" width="100%"
			browserSpanValue=""></brow:browser>
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
							<option value="0"><%=SystemEnv.getHtmlLabelName(83020, user.getLanguage()) %></option>
							<option value="1"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %></option>
						</select>
					</div>
					<div style="margin:0 auto;margin-top:16px;">
								 	<brow:browser viewType="0" name="newobjid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" linkUrl="" width="100%"
						browserSpanValue=""></brow:browser>
					</div>
				</div>
			</div>
			<div style="float:left;width:111px;height:39px;margin-top:68px;margin-left:39px;">
				<a id="startExecute" onmouseover="showBt(this)" onmouseout="hiddenBt(this)"  href="#" style="vertical-align:middle;"><span class="btstyle01"><%=SystemEnv.getHtmlLabelName(83073, user.getLanguage()) %></span></a>
			</div>
					

	</div>
	
	<div id="main" style="position: absolute!important;top:120px!important;height:auto!important;position: relative;height:100%;bottom:4px;width:100%;overflow: auto;">
		<iframe src="" id="contentframe" name="" contentframe" class="flowFrame" frameborder="0" height="100%" width="100%"></iframe>
	</div>
		</form>
	</BODY>
	
<script type="text/javascript">
$(document).ready(function(){
	$("#objtype").selectbox();
	$("#optflag").selectbox();

	var url = "/matrixmanage/pages/MassMaintIframe.jsp?matrixid=" + $("#objtype").val() +"&method=queryrecord&countinit=1&objid=-1";
	$("#contentframe").attr("src", url);
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

 function afterCallBack(e,data,name){
       queryrecord($("#objid").val(),1);
  }
  
 function queryrecord(objid, countinit){
      var url = "/matrixmanage/pages/MassMaintIframe.jsp?matrixid=" + $("#objtype").val() + "&objid=" + objid+"&method=queryrecord&countinit="+countinit;
	  $("#contentframe").attr("src", url);
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
	} 
	search(document.getElementById("objid").value);
	return url;
}


var dialog = null;
function loading(method){
    if(method==0){//展示
		if(dialog==null){
			dialog = new window.top.Dialog();
		}
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(19611, user.getLanguage()) %>...";
	    dialog.InnerHtml="<div style='text-align:center;color:red;font-size:14px;line-height:102px'><img src='/voting/surveydesign/images/loading_wev8.gif'></div>";
		dialog.Width = 140;
		dialog.Height = 90;
		dialog.Drag = true;
		dialog.hideDraghandle = true;
		dialog.textAlign = "center";
		dialog.show();
   }else{//关闭
        dialog.close();
   }
}


</script>
</HTML>
