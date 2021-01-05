<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ page import="weaver.docs.rdeploy.util.PrivateCategoryTree" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String mid = Util.null2String(request.getParameter("mid"));
	String id = Util.null2String(request.getParameter("id"));
	String guid = Util.null2String(request.getParameter("guid"));
	String hostname = Util.null2String(request.getParameter("hostname"));
	
	if(!id.isEmpty()){
	    rs.executeSql("select * from RdeploySyncSetting where id=" + id);
	}
	
	String localPath = "";
	String categoryid = "";
	String categoryName = "";
	if(rs.next()){
	    localPath = Util.null2String(rs.getString("localPath"));
	    categoryid = Util.null2String(rs.getString("categoryid"));
	}
	
	if(!categoryid.isEmpty()){
	    PrivateCategoryTree categoryTree = new PrivateCategoryTree();
	    categoryName = categoryTree.getPathById(categoryid);
	}
%>
<html>
	<head>
		<style>
			*{
				font-size:14px;
			}
			td{
				padding:5px;
			}
			#content{
				padding-top:25px;
			}
		</style>
		
		<script>
			var dialog = parent.getDialog(window);
			function doSave(){
				var categoryid = jQuery("#privateCategoryId").val();
				var localPath = jQuery("#localPath").val();
				
				if(localPath == ""){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129282,user.getLanguage())%>!");
					return;
				}else if(!/^[a-zA-Z]:(\\[^\\/<>|:*?"]+)+$/.test(localPath)){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129283,user.getLanguage())%>!");
					return;
					
				}else if(categoryid == ""){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129284,user.getLanguage())%>!");
					return;
				}
				
				jQuery.ajax({
					url : "/rdeploy/setting/settingSaveAjax.jsp",
					type : "post",
					data : {
							opType : "pathSave",
							categoryid : categoryid,
							localPath : localPath,
							mid : "<%=mid%>", 
							id : "<%=id%>",
							guid : "<%=guid%>",
							hostname : "<%=hostname%>"
						},
					dataType : "json",
					success : function(data){
						if(data && data.flag == "1"){
							var parentDialog = parent.getParentWindow(window);
							parentDialog._table.reLoad();
							dialog.close();
						}else{
							alert("error");
						}
					}
				});
			}
			
			function afterSelectCategory(e,datas,name,params){
				jQuery("#categoryidspan").html(datas.path);
				jQuery("#privateCategoryId").val(datas.id);
			}
			
			jQuery(function(){
				jQuery("#localPath").blur(function(){
					if(this.value.replace(/^ | $/g,"") == ""){
						jQuery(this).next("img").show();
					}else{
						jQuery(this).next("img").hide();
						if(!/^[a-zA-Z]:(\\[^\\/<>|:*?"]+)+$/.test(this.value)){
							var that = this;
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129283,user.getLanguage())%>!", function(){
								jQuery(that).focus();
							});
						}
					}
				});
			});
			
		
		function chooseLocal(){
			var e_dialog = parent.window.Electron.remote.dialog;
				e_dialog.showOpenDialog(parent.window.Electron.currentWindow, {properties : ['openDirectory']}, function(choosed){
	           if(choosed) {
				   jQuery("#localPath").val(choosed);
				   jQuery("#localPathImg").hide();
	           }
			   else
			   {
				   if(jQuery("#localPath").val() == '')
				   {
					   jQuery("#localPathImg").show();
				   }
			   }
	       });
        }
		
		
		</script>
	</head>
	<body>
		<div id="content">
			<table style="width:100%">
				<tbody>
					<tr>
						<td align="right" style="width:150px"><%=SystemEnv.getHtmlLabelName(129285,user.getLanguage())%>：</td>
						<td>
							<input readonly="readonly" name="localPath" id="localPath" style="margin-left:1px;width:326px;border:1px solid #E9E9E2;float:left"  value="<%=localPath %>"/>
							<div style="float:left;width:7px;height:14px">
							<img id="localPathImg" align="absMiddle" src="/images/BacoError_wev8.gif" style="float:left;margin-top:4px;<%=localPath == null || localPath.trim().isEmpty() ? "" : "display:none"%>"/>
							</div>
						
							<button class="e8_browflow" onclick="chooseLocal()" style="float:left;margin-left:5px"></button>
								
							<div style="clear:both"></div>
						</td>
					</tr>
					<tr>
						<td align="right">云盘目录：</td>
						<td>
							<span>
								<brow:browser  viewType="0" name="categoryid" idKey="id" nameKey="path" browserValue="<%=categoryid %>" 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=networkdisk&url=/rdeploy/setting/MultiCategorySingleBrowser.jsp" tempTitle="<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>"
								 needHidden="false" _callback="afterSelectCategory"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="2"
								browserSpanValue="<%=categoryName %>"></brow:browser>
							</span>
							<input type="hidden" name="privateCategoryId" id="privateCategoryId" value="<%=categoryid %>"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</body>
</html>
