<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.social.po.SocialRemind"%>
<%@ include file="/social/im/SocialIMInit.jsp" %>
<%
user = HrmUserVarify.getUser (request , response) ;
if(user == null){
    return;	
}
String userid = user.getUID() + "";

String action = Util.null2String(request.getParameter("action"));
if(action.equals("save")){
	SocialRemind.typeMapping[] enumTypes = SocialRemind.typeMapping.values();
	String ifOn = null, ifDeskRemind = null;
	String insertSql = "insert into social_sysremindsetting (remindtype, ifon, ifDeskRemind, userid) values (?,?,?,?);";
	String updateSql = "update social_sysremindsetting set remindtype = ?, ifon = ?, ifDeskRemind = ? where userid = ?";
	String curSql = null;
	List<String> params = new ArrayList<String>();
	char sepr = Util.getSeparator();
	RecordSet saveRecordSet = new RecordSet();
	saveRecordSet.execute("select count(*) from social_sysremindsetting where userid = '"+userid+"'");
	saveRecordSet.next();
	int size = saveRecordSet.getInt(1);
	//没有初始化
	if(size == 0){
		curSql = insertSql;
	}else{
		curSql = updateSql;
		if(size != enumTypes.length){
			System.err.println("当前用户["+userid+"]的推送类型数目不匹配,："+(size < enumTypes.length ? "缺少":"多出")+(Math.abs(size - enumTypes.length)) + "条");
		}
	}
	if(curSql != null){
		List<String> unInitTypeList = new ArrayList<String>();
		for(SocialRemind.typeMapping remindType : enumTypes){
			int type = remindType.type;
			ifOn = Util.null2String(request.getParameter("ifOn_"+type));
			ifDeskRemind = Util.null2String(request.getParameter("ifDeskRemind_"+type));
			if(!ifOn.equals("") && !ifDeskRemind.equals("")){
				params.add(type+sepr+ifOn+sepr+ifDeskRemind+sepr+userid);
			}else{
				unInitTypeList.add(type+"");
			}
		}
		saveRecordSet.executeUpdate(curSql, params);
		//处理未初始化的类型
		if(unInitTypeList.size() > 0){
			//TODO: xxxx
		}
	}
}
%>
<div class="zDialog_div_content" style="overflow:hidden; height: 556px;">

<form id="mainForm" action="/social/im/SocialSysRemindSetting.jsp?action=save" method="post">
	<div class="fixHeader">
		<table class="ListStyle">
			<colgroup><col width="34%"><col width="30%"><col width="*"></colgroup>
 			<tr class="HeaderForXtalbe">
 				<th>提醒类型</th>
 				<th><input type='checkbox' name='ifOn' value='0'>启用</th>
 				<th><input type='checkbox' name='ifDeskRemind' value='0'>启用屏幕右下角提醒</th>
 			</tr>
		</table>
	</div>
	<div id="content">
		<%
		  	RecordSet recordSet = new RecordSet();
		  	String sql = "select t2.remindtype remindtype,  " +
			  	"t2.remindname remindname, " +
			  	"t1.ifon ifon, t1.ifDeskRemind ifDeskRemind " +
			  	"from social_sysremindsetting t1 " +
			  	"LEFT JOIN social_sysremindtype t2 " +
			  	"ON t1.remindtype = t2.remindtype " +
			  	"where t1.userid = '"+userid+"' " +
			  	"ORDER BY remindtype ";
		  	//判断当前用户有无初始化数据
		  	recordSet.execute(sql);
		  	String remindType, remindName;
		  	boolean ifOn = true, ifDeskRemind = true;
		  	if(recordSet.getCounts() <= 0){
		  		sql = "select remindtype, remindname from social_sysremindtype order by remindtype";
		  		recordSet.execute(sql);
		  		while(recordSet.next()){
		  			remindType = recordSet.getString("remindtype");
		  			remindName = recordSet.getString("remindname");
		  			%>
		  			<div class="item">
			  			<table class="ListStyle">
			  				<colgroup><col width="34%"><col width="30%"><col width="*"></colgroup>
				  			<tr>
				  				<td><input type='hidden' name='remindtype' value='<%=remindType %>'><%=remindName %></td>
				  				<td><input type='checkbox' name='ifOn_<%=remindType %>' value='<%=ifOn?"1":"0" %>' <%=ifOn?"checked":"" %>></td>
				  				<td><input type='checkbox' name='ifDeskRemind_<%=remindType %>' value='<%=ifDeskRemind?"1":"0" %>' <%=ifDeskRemind?"checked":"" %>></td>
				  			</tr>
			  			</table>
		  			</div>
		  			<%
		  		}
		  	}else{
		  		while(recordSet.next()){
		  			remindType = recordSet.getString("remindtype");
		  			remindName = recordSet.getString("remindname");
		  			ifOn = recordSet.getBoolean("ifon");
		  			ifDeskRemind = recordSet.getBoolean("ifDeskRemind");
		  			%>
		  			<div class="item">
			  			<table class="ListStyle">
			  				<colgroup><col width="34%"><col width="30%"><col width="*"></colgroup>
				  			<tr>
				  				<td><input type='hidden' name='remindtype' value='<%=remindType %>'><%=remindName %></td>
				  				<td><input type='checkbox' name='ifOn_<%=remindType %>' value='<%=ifOn?"1":"0" %>' <%=ifOn?"checked":"" %>></td>
				  				<td><input type='checkbox' name='ifDeskRemind_<%=remindType %>' value='<%=ifDeskRemind?"1":"0" %>' <%=ifDeskRemind?"checked":"" %>></td>
				  			</tr>
			  			</table>
		  			</div>
		  			<%
		  		}
		  	}
		  %>
	</div>
</form>

</div>
<!-- 底部按钮组 -->
<div id="zDialog_div_bottom" class="zDialog_div_bottom">	
 	<wea:layout>
 		<wea:group context="" attributes="{groupDisplay:none}">
 			<wea:item type="toolbar">
 				 <input type="button" value="确定" id="zd_btn_confirm" class="zd_btn_cancle" onclick="RemindHandle.doSave();">
                 <input type="button" value="取消" id="zd_btn_cancle" class="zd_btn_cancle" onclick="top.getDialog(window).close()">
 			</wea:item>
 		</wea:group>
 	</wea:layout>
 </div>
 
 
 <style>
 	*{
 		font-family: "Microsoft YaHei"!important;
 		font-size: 12px;
 	}
 	#mainForm .fixHeader{
 		position: fixed;
    	width: 100%;
        z-index: 1;
 	}
 	
 	#content{
 		height: 525px;
 		position: relative;
	    top: 34px;
	    overflow: auto;
 	}
 </style>
 <script>
 	$(function(){
 		$("#content").perfectScrollbar();
 		//console.error($("#content .jNiceCheckbox").length);
 		$("#content .jNiceCheckbox").bind('click', function(){
 			var self = this;
 			var chk = $(self).prev("input[type='checkbox']");
 			chk.val(1 - parseInt(chk.val()));
 			var valueCnd = chk.val();
 			if(valueCnd == '1'){
 				chk.next('.jNiceCheckbox').addClass('jNiceChecked');
 			}else{
 				chk.next('.jNiceCheckbox').removeClass('jNiceChecked');
 			}
 		}); 
 		
 		$(".fixHeader .jNiceCheckbox").bind('click', function(){
 			var self = this;
 			var chk = $(self).prev("input[type='checkbox']");
 			chk.val(1 - parseInt(chk.val()));
 			var valueCnd = chk.val();
 			var name = chk.attr('name');
 			chk = $("#content input[name^='"+name+"']").val(valueCnd).next('.jNiceCheckbox');
 			if(valueCnd == '1'){
 				chk.addClass('jNiceChecked');
 			}else{
 				chk.removeClass('jNiceChecked');
 			}
 			
 		});
 	});
 	var RemindHandle = {
 		doSave: function(){
 			$('#mainForm').submit();
 		}
 	};
 </script>