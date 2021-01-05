/**
'*********************************
'Show the lgc asset unit selecting browser.
'@author	lupeng
'@version	04/08/03
'*********************************

'****************************************************************************************
'Show the lgc asset unit selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected unit's id.
'@param	spanname	the span object name, it shows the selected unit's name.
'****************************************************************************************
*/
function onShowLgcAssetUnit(inputname, spanname) {
	onShowLgcAssetUnitBase(inputname, spanname, false);
}

/**
'****************************************************************************************
'Show the lgc asset unit selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected unit's id.
'@param	spanname	the span object name, it shows the selected unit's name.
'****************************************************************************************
*/
function onShowLgcAssetUnitNeeded(inputname, spanname) {
	onShowLgcAssetUnitBase(inputname, spanname, true);
}

/**
'****************************************************************************************
'Show the department selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected unit's id.
'@param	spanname	the span object name, it shows the selected unit's name.
'@param	needed		the flag that whether or not need to input.
'****************************************************************************************
*/
function onShowLgcAssetUnitBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 2);
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