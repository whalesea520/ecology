export const openFullWindowHaveBar = (url,callBack) => {

    var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    //dialog.callbackfunParam = null;
    dialog.URL = url;
    dialog.callbackfun = function (paramobj, id1) {
        console.log(paramobj, id1)
    }
    dialog.Title = "请选择";//请选择
    dialog.Width = 550;
    if (url.indexOf("/MutiResourceBrowser.jsp") != -1) {
        dialog.Width = 648;
    }
    dialog.Height = 600;
    dialog.Drag = true;
    //dialog.maxiumnable = true;
    dialog.show();
}
window.openFullWindowHaveBar = openFullWindowHaveBar;