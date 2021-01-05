
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.request.Browsedatadefinition" %>
<%@ page import="weaver.workflow.browserdatadefinition.Condition" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%-- 
<%@ include file="/systeminfo/init_wev8.jsp" %>
--%>

<script type="text/javascript">
	var _CACHE = new Object();
<%List<Browsedatadefinition> datas = Browsedatadefinition.readAll(Util.null2String(request.getParameter("workflowid")));
	for (Browsedatadefinition data : datas) {%>
		_CACHE['<%=data.getFieldid()%>'] = {};
		<%if ("3".equals(data.getCreatetype()) && !"".equals(data.getCreatetypeid())) {%>
		_CACHE['<%=data.getFieldid()%>'].cre = '<%=data.getCreatetypeid()%>';
		<%}%>
		<%if ("3".equals(data.getCreatedepttype()) && !"".equals(data.getDepartment())) {%>
		_CACHE['<%=data.getFieldid()%>'].dep = '<%=data.getDepartment()%>';
		<%}%>
		<%if ("3".equals(data.getCreatesubtype()) && !"".equals(data.getCreatesubid())) {%>
		_CACHE['<%=data.getFieldid()%>'].sub = '<%=data.getCreatesubid()%>';
		<%}%>
		<%if ("8".equals(data.getCreatedatetype()) && !"".equals(data.getCreatedatefieldid())) {%>
		_CACHE['<%=data.getFieldid()%>'].date = '<%=data.getCreatedatefieldid()%>';
		<%}%>
		<%if ("3".equals(data.getXgxmtype()) && !"".equals(data.getXgxmid())) {%>
		_CACHE['<%=data.getFieldid()%>'].xgxm = '<%=data.getXgxmid()%>';
		<%}%>
		<%if ("3".equals(data.getXgkhtype()) && !"".equals(data.getXgkhid())) {%>
		_CACHE['<%=data.getFieldid()%>'].xgkh = '<%=data.getXgkhid()%>';
		<%}%>
<%}%>

<%List<Condition> conditions = Condition.readAll(Util.null2String(request.getParameter("workflowid")));
	for (Condition condition : conditions) {
		String key = condition.getFieldId() + "_" + ("1".equals(condition.getViewType()) ? "1" : "0");
	%>
		_CACHE['<%=key%>'] = {};
	<%for (ConditionField field : condition.getFields()) {
		if (field.isGetValueFromFormField()) {%>
		<%if (!"".equals(field.getValue())) {%>
		_CACHE['<%=key%>']['bdf_<%=field.getFieldName()%>'] = '<%=field.getValue()%>';
		<%}%>
<%}}}%>
	function getFieldId(inputIdOrName) {
		var reg = /^field([0-9]+)(_[0-9]+)?$/gi;
		if (reg.test(inputIdOrName)) {
			fieldId = inputIdOrName.replace(reg, '$1');
		}
		return fieldId;
	}

	function getViewType(inputIdOrName) {
		var reg = /^field[0-9]+_[0-9]+?$/gi;
		if (reg.test(inputIdOrName)) {
			return '1';
		} else {
			return '0';
		}
	}

	function isCanConfigType(type) {
		return ',<%=Condition.getConfigFieldTypes()%>,'.indexOf(',' + type + ',') >= 0;
	}

	function getUserDefinedRequestParam(inputIdOrName) {
		var fieldId = getFieldId(inputIdOrName);
		var param = 'currworkflowid=<%=Util.null2String(request.getParameter("workflowid"))%>&fieldid=' + fieldId;

		if (!!fieldId) {
			var config = _CACHE[fieldId];
			if (!config) {
				var viewType = getViewType(inputIdOrName);
				var fieldIdAndViewType = fieldId + '_' + viewType;
				config = _CACHE[fieldIdAndViewType];
				param = 'bdf_wfid=<%=Util.null2String(request.getParameter("workflowid"))%>&bdf_fieldid=' + fieldId + '&bdf_viewtype=' + viewType;
			}
			if (!!config) {
				for (var ele in config) {
					var targetFieldId = config[ele];
					var targetInputIdOrName = inputIdOrName.replace(fieldId, targetFieldId);
					var targetObj = $G(targetInputIdOrName);
					if (!targetObj) {
						<%//尝试取得主表字段%>
						targetObj = $G('field' + targetFieldId);
					}
					if (!!targetObj) {
						var val = jQuery(targetObj).val();
						if (!!val) {
							param += '&' + ele + '=' + val;
						}
					}
				}
			}
		}
		try{
			if(window._____guid1 && window.__requestid){
				if(param!=""){
					param += "&";
				}
				param += "__requestid="+window.__requestid;
			}
		}catch(ex1){}
		return param;
	}

</script>