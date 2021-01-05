<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.conn.RecordSet" %>
<html>
	<head>
	<%
		int pid = Util.getIntValue(request.getParameter("pid"),0);
	
		String pname = SystemEnv.getHtmlLabelName(129151,user.getLanguage());
		if(pid > 0){
			RecordSet rs = new RecordSet();
			rs.executeSql("select categoryname from DocPrivateSecCategory where id=" + pid);
		    if(rs.next()){
		        pname = rs.getString("categoryname");
		    }
		}
	%>
	<script>
		var dialog = parent.getDialog(window);
		function doSave(){
			var name = jQuery("#categoryname").val();		
			var parentDialog = parent.getParentWindow(window);
			if(name == ""){
	    		top.Dialog.alert("目录名不能为空!",function(){
	    			jQuery("#categoryname").focus();
	    		});
	    		return;
	    	}else if(/[\\/:*?"<>|]/.test(name)){
	    		top.Dialog.alert("目录名不能包含下列字符：<br/>\\/:*?\"<>|",function(){
	    			jQuery("#categoryname").focus();
	    		});
	    		return;
	    	}
			jQuery.ajax({
            url: "/rdeploy/chatproject/doc/addSeccategory.jsp?foldertype=privateAll&parentid=<%=pid%>&categoryname=" + name,
            type: "post",
            dataType: "json",
            success: function(data) {
           		if(data.exist){
           			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21999,user.getLanguage())%>",function(){
           				jQuery("#categoryname").focus();
           			});
           		}else{
					dialog.close();
           			parentDialog.onRefresh();
           		}
            }
        });
		}
	</script>
	<style>
		td{
			padding:5px 3px;
		}
	</style>
	</head>
	<body>
		<div style="padding-top:30px;font-size:12px;">
			<table style="width:100%;">
				<tr>
					<td style="width:150px;text-align:right"><%=SystemEnv.getHtmlLabelName(81530,user.getLanguage())%>：</td>
					<td><%=pname %></td>
				</tr>
				<tr>
					<td style="width:150px;text-align:right"><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%>：</td>
					<td>
						<input name="categoryname" id="categoryname" style="width:325px;border:1px solid #E9E9E2"  value=""/>
						<img align="absMiddle" src="/images/BacoError_wev8.gif"/>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>