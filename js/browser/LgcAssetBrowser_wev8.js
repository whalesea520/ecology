/**
'*********************************
'Show the lgc selecting browser.
'@author	lupeng
'@version	04/08/03
'*********************************

'****************************************************************************************
'Show the lgc selecting browser, not need.
'@param	inputname	the hidden or not input object name, it stores the selected lgc's id.
'@param	spanname	the span object name, it shows the selected lgc's name.
'****************************************************************************************
*/
function onShowLgcAsset(inputname, spanname) {
	onShowLgcAssetBase(inputname, spanname, false);
}
/**
'****************************************************************************************
'Show the lgc selecting browser, need.
'@param	inputname	the hidden or not input object name, it stores the selected lgc's id.
'@param	spanname	the span object name, it shows the selected lgc's name.
'****************************************************************************************
*/
function onShowLgcAssetNeeded(inputname, spanname) {
	onShowLgcAssetBase(inputname, spanname, true);
}
/**
'****************************************************************************************
'Show the lgc selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected lgc's id.
'@param	spanname	the span object name, it shows the selected lgc's name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
*/
function onShowLgcAssetBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$G(spanname).innerHTML = "<A href='/lgc/asset/LgcAsset.jsp?paraid=" + wuiUtil.getJsonValueByIndex(retValue, 0) + "'>" + wuiUtil.getJsonValueByIndex(retValue, 1) + "</A>";
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