<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
int layouttype = Util.getIntValue(request.getParameter("layouttype"));
int formid = Util.getIntValue(request.getParameter("formid"));
int isbill = Util.getIntValue(request.getParameter("isbill"));
int detailindex = Util.getIntValue(request.getParameter("detailindex"));	//从1开始
int viewonly = Util.getIntValue(request.getParameter("viewonly"));
int nodetype = 0;
rs.executeSql("select nodetype from workflow_flownode where nodeid="+nodeid);
if(rs.next())
	nodetype = Util.getIntValue(rs.getString(1));
boolean viewdisabled = false,editdisabled = false;
if(layouttype == 2)
	viewdisabled = true;
if(viewonly == 1 || (layouttype == 0 && nodetype == 3) || (layouttype == 1 || layouttype == 2))
	editdisabled = true;
StringBuilder sql = new StringBuilder();
if(isbill == 1){
	sql.append("select a.id as fieldid,c.labelname as fieldlable,b.isview,b.isedit,b.ismandatory from workflow_billfield a")
		.append(" left join workflow_nodeform b on a.id=b.fieldid and nodeid="+nodeid)
		.append(" left join htmllabelinfo c on a.fieldlabel=c.indexid and c.languageid="+user.getLanguage())
		.append(" where billid="+formid+" and viewtype=1 and a.detailtable=(select tablename from workflow_billdetailtable d where d.billid="+formid+" and d.orderid="+detailindex+")")
		.append(" order by b.orderid,a.dsporder,a.id");
}else if(isbill == 0){
	sql.append("select a.fieldid,c.fieldlable,b.isview,b.isedit,b.ismandatory from workflow_formfield a")
		.append(" left join workflow_nodeform b on a.fieldid=b.fieldid and nodeid="+nodeid)
		.append(" left join workflow_fieldlable c on a.fieldid=c.fieldid and a.formid=c.formid and c.langurageid="+user.getLanguage())
		.append(" where a.formid="+formid+" and isdetail=1 and a.groupid="+(detailindex-1))
		.append(" order by b.orderid,a.fieldorder,a.fieldid");
}
rs.executeSql(sql.toString());
%>
<html>
<head>
	<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
	<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<input type="hidden" id="excelStyle" name="excelStyle" value="" >
<input type="hidden" id="excelIssys" name="excelIssys" value="" >
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
			<table class="ListStyle" cellspacing="0" id="wtable">
				<colgroup>
					<col width="5%"/>
					<col width="22%"/>
					<col width="22%"/>
					<col width="22%"/>
					<col />
				</colgroup>
				<tr class="header notMove">
					<td></td>
					<td><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
					<td><input type="checkbox" id="viewall" name="viewall" <%=viewdisabled?"disabled":"" %> onclick="javascript:checkAllClick(this);"/>&nbsp;<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%></td>
					<td><input type="checkbox" id="editall" name="editall" <%=editdisabled?"disabled":"" %> onclick="javascript:checkAllClick(this);"/>&nbsp;<%=SystemEnv.getHtmlLabelName(31836,user.getLanguage())%></td>
					<td><input type="checkbox" id="manall" name="manall" <%=editdisabled?"disabled":"" %> onclick="javascript:checkAllClick(this);"/>&nbsp;<%=SystemEnv.getHtmlLabelName(31837,user.getLanguage())%></td>
				</tr>
				<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft0"><div class="intervalDivClass"></div></td></tr>
				<%
				while(rs.next()){
					String fieldid="",viewchecked="",editchecked="",manchecked="";
					fieldid = rs.getString("fieldid");
					if(Util.getIntValue(rs.getString("isview")) == 1)
						viewchecked = " checked";
					if(!editdisabled && Util.getIntValue(rs.getString("isedit")) == 1)
						editchecked = " checked";
					if(!editdisabled && Util.getIntValue(rs.getString("ismandatory")) == 1)
						manchecked = " checked";
				%>
				<tr fieldid="<%=fieldid %>" style="height:32px;">
					<td><img src="/proj/img/move_wev8.png" title="<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>" /></td>
					<td><%=rs.getString("fieldlable") %></td>
					<td><input type="checkbox" id="view_<%=fieldid %>" name="viewsingle" <%=viewchecked %> <%=viewdisabled?"disabled":"" %> onclick="javascript:checkSingleClick(this);"/></td>
					<td><input type="checkbox" id="edit_<%=fieldid %>" name="editsingle" <%=editchecked %> <%=editdisabled?"disabled":"" %> onclick="javascript:checkSingleClick(this);"/></td>
					<td><input type="checkbox" id="man_<%=fieldid %>" name="mansingle" <%=manchecked %> <%=editdisabled?"disabled":"" %> onclick="javascript:checkSingleClick(this);"/></td>
				</tr>
				<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft0"><div class="intervalDivClass"></div></td></tr>
				<%} %>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>
</body>
</html>
<script>
jQuery(document).ready(function(){
	//jQuery("#wtable").parent().css("cssText", "padding-left:0px !important");
	registerDragEvent();
	jQuery("#wtable tr.notMove,tr.Spacing").bind("mousedown", function() {
		return false;
	});
});

function registerDragEvent() {
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
		    $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了
		    $(this).height($(this).height());
		});
		return ui;
	};
	var copyTR = null;
	var startIdx = 0;
	var idStr = "#wtable";
	jQuery(idStr + " tbody tr").bind("mousedown", function(e) {
		copyTR = jQuery(this).next("tr.Spacing");
	});
    jQuery(idStr + " tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
            	e.stopPropagation && e.stopPropagation();
            	e.cancelBubble = true;
            }
            if(copyTR) {
       			copyTR.hide();
       		}
       		startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
        	if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方
                if(copyTR) {
           			copyTR.show();
           		}
        		return false;
        	}
           	if(copyTR) {
				if(ui.item.prev("tr").attr("class") == "Spacing") {
					ui.item.after(copyTR.clone().show());
				}else {
					ui.item.before(copyTR.clone().show());
				}
	       	  	copyTR.remove();
	       	  	copyTR = null;
       		}
           	return ui;
        }
    });
}

function checkAllClick(vthis){
	var objname = jQuery(vthis).attr("name");
	var mark = objname.replace("all","");
	if(jQuery(vthis).is(":checked")){		//全选
		jQuery("input[name='"+mark+"single']:enabled").attr("checked", true).next().addClass("jNiceChecked");
		if(mark === "edit" || mark === "man"){
			jQuery("input[name='viewall']:enabled").attr("checked", true).next().addClass("jNiceChecked");
			jQuery("input[name='viewsingle']:enabled").attr("checked", true).next().addClass("jNiceChecked");
		}
		if(mark === "man"){
			jQuery("input[name='editall']:enabled").attr("checked", true).next().addClass("jNiceChecked");
			jQuery("input[name='editsingle']:enabled").attr("checked", true).next().addClass("jNiceChecked");
		}
	}else{		//取消全选
		jQuery("input[name='"+mark+"single']:enabled").attr("checked", false).next().removeClass("jNiceChecked");
		if(mark === "view"){
			jQuery("input[name='editall']:enabled").attr("checked", false).next().removeClass("jNiceChecked");
			jQuery("input[name='editsingle']:enabled").attr("checked", false).next().removeClass("jNiceChecked");
		}
		if(mark === "view" || mark === "edit"){
			jQuery("input[name='manall']:enabled").attr("checked", false).next().removeClass("jNiceChecked");
			jQuery("input[name='mansingle']:enabled").attr("checked", false).next().removeClass("jNiceChecked");
		}
	}
}

function checkSingleClick(vthis){
	var fieldid = jQuery(vthis).closest("tr").attr("fieldid");
	var mark = jQuery(vthis).attr("name").replace("single","");
	if(jQuery(vthis).is(":checked")){		//勾选
		if(mark === "edit" || mark === "man")
			jQuery("input#view_"+fieldid+":enabled").attr("checked", true).next().addClass("jNiceChecked");
		if(mark === "man")
			jQuery("input#edit_"+fieldid+":enabled").attr("checked", true).next().addClass("jNiceChecked");
	}else{		//取消勾选
		if(mark === "view")
			jQuery("input#edit_"+fieldid+":enabled").attr("checked", false).next().removeClass("jNiceChecked");
		if(mark === "view" || mark === "edit")
			jQuery("input#man_"+fieldid+":enabled").attr("checked", false).next().removeClass("jNiceChecked");
	}
}

//点下一步判断是否选择了字段
function judgeHavaCheckField(){
	if(jQuery("input[name='viewsingle']:checked").size() == 0){
		window.top.Dialog.alert("请选择需要显示的字段!");
		return true;
	}
	return false;
}

function confirmInitDetail(){
	var retjson = {};
	retjson["styleissys"] = jQuery("#excelIssys").val();
	retjson["styleid"] = jQuery("#excelStyle").val();
	var fieldArr = new Array();
	jQuery("table#wtable").find("tr[fieldid]").each(function(){
		var fieldid = jQuery(this).attr("fieldid");
		var fieldattr = 0;
		if(jQuery("#man_"+fieldid).is(":checked"))
			fieldattr = 3;
		else if(jQuery("#edit_"+fieldid).is(":checked"))
			fieldattr = 2;
		else if(jQuery("#view_"+fieldid).is(":checked"))
			fieldattr = 1;
		fieldArr.push({"fieldid":fieldid,"fieldattr":fieldattr});
	});
	retjson["fieldinfo"] = fieldArr;
	if(window.console)	console.log(JSON.stringify(retjson));
	var dialog = window.top.getDialog(window);
	dialog.close(retjson);
}
</script>