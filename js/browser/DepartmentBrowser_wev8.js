/**
'*********************************
'Show the department selecting browser.
'@author	lupeng
'@version	04/08/03
'*********************************

'****************************************************************************************
'Show the lgc selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected department's id.
'@param	spanname	the span object name, it shows the selected department's name.
'****************************************************************************************
*/
function onShowDepartment(inputname, spanname) {
	onShowDepartmentBase(inputname, spanname, false);
}

/**
'****************************************************************************************
'Show the lgc selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected department's id.
'@param	spanname	the span object name, it shows the selected department's name.
'****************************************************************************************
*/
function onShowDepartmentNeeded(inputname, spanname) {
	onShowDepartmentBase(inputname, spanname, true);
}

/**
'****************************************************************************************
'Show the department selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected department's id.
'@param	spanname	the span object name, it shows the selected department's name.
'@param	needed		the flag that whether or not need to input.
'****************************************************************************************
*/
function onShowDepartmentBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $G(inputname).value, "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$G(spanname).innerHTML = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id=" + wuiUtil.getJsonValueByIndex(retValue, 0) + "'>" + wuiUtil.getJsonValueByIndex(retValue, 1) + "</A>";
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
		} else { 
			$G(inputname).value = "";
			if (needed) {
				$G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			} else {
				$G(spanname).innerHTML = "";
			}
		}
	}
}