
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	</HEAD>
	<%
		
	    String imagefilename = "/images/hdMaintenance_wev8.gif";
	    String titlename = SystemEnv.getHtmlLabelName(17599, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(16140, user.getLanguage());
	    String needfav = "1";
	    String needhelp = "";
	    
	    String guid = Util.null2String(request.getParameter("guid"));
	    String hostname = Util.null2String(request.getParameter("hostname"));
	    
	   // String sql = "select id from RdeploySyncSettingMain where loginid='" + user.getLoginid() + "'";
	    
	  //  RecordSet.executeSql(sql);
	    
	  //  String mid = "";
	    
	   // if(RecordSet.next()){
		//    mid = Util.null2String(RecordSet.getString("id"));
	   // }
	    
	%>
	<BODY>

		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="rdeploy" />
			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(21952,user.getLanguage()) %>" />
		</jsp:include>
		<div class="isOpen" style='position:absolute;right:10px;top:30px'>
			<span style="width:30px;display:inline-block" class="middle e8_btn_top_first" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="doAdd()" >
			     <%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></span>
			<span style="width:30px;display:inline-block" class="e8_btn_top middle" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="doDelAll()" >
			     <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
		</div>
		


		<%
			String backfields = "id,computerName,localPath,categoryid,isUse,case when guid='" + guid + "' then '1' else '0' end flag";
			String fromSql = "from RdeploySyncSetting";
			String sqlWhere = "loginid='" + user.getLoginid() + "'";
		    String tableString = "<table  needPage=\"false\" tabletype=\"checkbox\" popedompara = \"column:id\">"
		             + "<sql backfields=\"" + backfields + "\"  sqlform=\"" + fromSql + "\" sqlwhere=\"" + sqlWhere + "\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  />";
		    String operateString = "";
		    operateString += "<operates width=\"5%\">";
		    operateString += "     <operate otherpara=\"id\" href=\"javascript:doEdit()\"  text=\"" + SystemEnv.getHtmlLabelName(93,user.getLanguage()) + "\" index=\"0\"/>";
		    operateString += "     <operate otherpara=\"1\" href=\"javascript:doUse()\"   text=\"" + SystemEnv.getHtmlLabelName(31676,user.getLanguage()) + "\" index=\"1\"/>";
		    operateString += "     <operate otherpara=\"0\" href=\"javascript:doUse()\"   text=\"" + SystemEnv.getHtmlLabelName(18096,user.getLanguage()) + "\" index=\"2\"/>";
		    operateString += "     <operate otherpara=\"id\" href=\"javascript:doDel()\"   text=\"" + SystemEnv.getHtmlLabelName(91,user.getLanguage()) + "\" index=\"3\"/>";
		    operateString += "     <operate otherpara=\"id\" href=\"javascript:doSync()\"   text=\"同步\" index=\"4\"/>";
		    operateString += "	   <popedom column=\"isuse\" otherpara=\"1_2_5+column:flag+0+column:id\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getUseOperateList\"></popedom> ";
		    operateString += "</operates>";

		    tableString += operateString;
		    tableString += "<head>";
		    tableString += "<col width=\"15%\" labelid=\"22969\"  text=\"" + SystemEnv.getHtmlLabelName(129288,user.getLanguage()) + "\" column=\"computerName\"/>";
		    tableString += "<col width=\"33%\" labelid=\"23752\"  text=\"" + SystemEnv.getHtmlLabelName(129285,user.getLanguage()) + "\" column=\"localPath\" />";
		    tableString += "<col width=\"33%\" labelid=\"19998\"  text=\"云盘目录\" column=\"categoryid\" transmethod=\"weaver.docs.rdeploy.util.PrivateCategoryTree.getPathById\"/>";
		    tableString += "<col width=\"10%\" labelid=\"602\"  text=\"" + SystemEnv.getHtmlLabelName(602,user.getLanguage()) + "\" column=\"isuse\" name='isuse' transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getSettingUse\" otherpara=\""+user.getLanguage()+"\"/>";
		    tableString += "</head></table>";
		%>

		<div class="dataList" style="overflow:auto;height:260px;">
			<wea:SplitPageTag tableString='<%=tableString%>'
				isShowTopInfo="false" mode="run" />
		</div>
		
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		    <wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
				    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
					</wea:item>
				</wea:group>
			</wea:layout>
			<script type="text/javascript">
				jQuery(document).ready(function(){
					resizeDialog(document);
				});
				function onClose(){
					try{
						var topWi = window;
						var curWi = window;
						while(topWi != topWi.parent){
							curWi = topWi;
							topWi = topWi.parent;
						}
						topWi.getDialog(curWi).close();
					}catch(e){}
				}
			</script>
		</div>

		<script language=javascript>
		
			
			var dialog = null;
			function closeDialog(){
				if(dialog)
					dialog.close();
			}
			
			//新增一个映射
			function doAdd(id){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/rdeploy/setting/localPath.jsp?guid=<%=guid%>&hostname=<%=hostname%>&mid=" + (id ? ("&id=" + id) : "");
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(129289,user.getLanguage())%>";
				dialog.Width = 600;
				dialog.normalDialog = false;
				dialog.Height = 150;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.OKEvent = function(){
					dialog.innerWin.doSave();
				};
				dialog.show();
				dialog.okButton.value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>";
			}
			
			
			
			//批量删除
			function doDelAll(){
				var $objs = jQuery("table.ListStyle tbody .jNiceHidden:checked");
				if($objs.length == 0){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!");
					return;
				}
				var ids = "";
				$objs.each(function(){
					ids += "," + jQuery(this).attr("checkboxid");
				})
				ids = ids.substring(1);
				doDel(ids);
			}
			
			//删除
			function doDel(ids){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(30952,user.getLanguage())%>?",function(){
					jQuery.ajax({
						url : "/rdeploy/setting/settingSaveAjax.jsp",
						type : "post",
						data : {opType : "delete",ids : ids},
						dataType : "json",
						success : function(data){
							if(data && data.flag == "1"){
								_table.reLoad();
							}else{
								alert("error");
							}
						}
					});
				});
			}
			
			//编辑
			function doEdit(id){
				doAdd(id);
			} 
			
			//开启、禁用映射
			function doUse(id,isuse){
				jQuery.ajax({
					url : "/rdeploy/setting/settingSaveAjax.jsp",
					type : "post",
					data : {opType : "use",id : id,isuse : isuse},
					dataType : "json",
					success : function(data){
						if(data && data.flag == "1"){
							_table.reLoad();
						}else{
							alert("error");
						}
					}
				});
			}
			
			//表格加载完成之后的回调
			function getRate(){
				jQuery("td[name='isuse']").each(function(){
					if(jQuery(this).text() == "<%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%>"){
						jQuery(this).closest("tr").find("td").css({
							"background-color" : "#f7f7f7",
							"color" : "#999999"
						});
					}
				});
			}
			
			function doSync(id){
				parent.onSyncDownload(id);
			}
		</script>

	</body>
</html>