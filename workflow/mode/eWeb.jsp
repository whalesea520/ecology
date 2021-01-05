
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.conn.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<script language=javascript src="/js/weaver_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

response.setHeader("X-UA-Compatible","IE=EmulateIE8");

User user = HrmUserVarify.getUser (request , response);

String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
int wfid=Util.getIntValue(request.getParameter("wfid"),0);
int formid=Util.getIntValue(request.getParameter("formid"),0);
int nodeid=Util.getIntValue(request.getParameter("nodeid"),0);
int modeid=Util.getIntValue(request.getParameter("modeid"),0);
int isbill=Util.getIntValue(request.getParameter("isbill"),-1);
int isprint=Util.getIntValue(request.getParameter("isprint"),-1);
int isform=Util.getIntValue(request.getParameter("isform"),0);
String ajax=Util.null2String(request.getParameter("ajax"));
// 是否来自流程图形化编辑

String design = Util.null2String(request.getParameter("design"));
int languageid=user.getLanguage();

rs.executeSql("select nodetype from workflow_flownode where nodeid="+nodeid);
String nodetype = "0";
if(rs.next()){
	nodetype = rs.getString("nodetype");
}
String hrmremain="";
String deptremain="";
String subcomremain="";
String loanbalance="";
String oldamount="";
String oldorganizationid = "";
String neworganizationid = "";
if(isbill==1&&(formid==156 ||formid==157 ||formid==158 ||formid==159)){
    rs.executeSql("select fieldname,id,type,fieldhtmltype from workflow_billfield where viewtype=1 and billid="+formid);
    while(rs.next()){
        if("hrmremain".equals(Util.null2String(rs.getString("fieldname")).toLowerCase())){
            hrmremain="field"+rs.getString("id")+"_0_"+rs.getString("type")+"_"+rs.getString("fieldhtmltype");
        }
        if("deptremain".equals(Util.null2String(rs.getString("fieldname")).toLowerCase())){
            deptremain="field"+rs.getString("id")+"_0_"+rs.getString("type")+"_"+rs.getString("fieldhtmltype");
        }
        if("subcomremain".equals(Util.null2String(rs.getString("fieldname")).toLowerCase())){
            subcomremain="field"+rs.getString("id")+"_0_"+rs.getString("type")+"_"+rs.getString("fieldhtmltype");
        }
        if("loanbalance".equals(Util.null2String(rs.getString("fieldname")).toLowerCase())){
            loanbalance="field"+rs.getString("id")+"_0_"+rs.getString("type")+"_"+rs.getString("fieldhtmltype");
        }
        if("oldamount".equals(Util.null2String(rs.getString("fieldname")).toLowerCase())){
            oldamount="field"+rs.getString("id")+"_0_"+rs.getString("type")+"_"+rs.getString("fieldhtmltype");
        }
        if("organizationid".equals(Util.null2String(rs.getString("fieldname")).toLowerCase())){
            oldorganizationid="field"+rs.getString("id")+"_0_1_3";
            neworganizationid="field"+rs.getString("id")+"_0_4_3";
        }
        
    }
}
%>
<html>

<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<!--Style Sheets First one to adjust fonts on input fields.-->
<LINK rel=stylesheet type=text/css HREF="chinaexcel_wev8.css">
<SCRIPT  LANGUAGE=JAVASCRIPT src="/js/characterConv_wev8.js"></SCRIPT>
<SCRIPT  LANGUAGE=VBSCRIPT src="functions.vbs"></SCRIPT>

<SCRIPT  LANGUAGE=JAVASCRIPT src="commands_wev8.js"></SCRIPT>

<style>
html, body, div, table, td, a, input, select {
	font-size:12px!important;
	font-family:'微软雅黑'!important;
}

</style>

<title></title>

<SCRIPT LANGUAGE="javascript">
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
var language=null;
try {
	language = readCookie("languageidweaver");
} catch (e) {}
function stop () {
    /*if(language==8){
        alert("ShangHai Weaver Software Report Editor!");
    }
    else if(language==9){ 
        alert ('上海泛微軟件報表設計器！'); 
    }
    else{
        alert ('上海泛微软件报表设计器！');
    }*/
	alert(SystemEnv.getHtmlNoteName(3474,language));
return false;
}
document.oncontextmenu=stop;
var loaded=false;
function deleteA(){    
    var StartRow=CellWeb1.GetSelectRegionStartRow();
    var StartCol=CellWeb1.GetSelectRegionStartCol();
    var EndRow=CellWeb1.GetSelectRegionEndRow();
    var EndCol=CellWeb1.GetSelectRegionEndCol();
    var uservalue="";
    var k=StartRow;
    var j=StartCol;
    for(k; k <= EndRow ; k++){
        j=StartCol;
        for(j; j <= EndCol; j++){            
            uservalue=CellWeb1.GetCellUserStringValue(k,j);
            if(uservalue!=null && uservalue!=""){
<%if(isbill==1 && formid==156) {%>
            if(uservalue == '<%=oldorganizationid%>') uservalue = "<%=neworganizationid%>";
<%}%>
                CellWeb1.SetCellProtect(k,j,k,j,false);
                CellWeb1.SetCellNormalType(k,j);
                CellWeb1.DeleteCellImage(k,j,k,j);
                //CellWeb1.HorzTextAlign = 1;
                CellWeb1.SetCellUserValue(k,j,k,j,0);
                try{
                parent.fieldlist.document.getElementById(uservalue).style.display='';
                }catch(e){}
                if(uservalue.indexOf("_head")>0 || uservalue.indexOf("_end")>0 || uservalue.indexOf("_isprintbegin")>0 || uservalue.indexOf("_isprintend")>0){
                    CellWeb1.DeleteRow(k,k);
                    EndRow--;
                    k--;
                    break;
                }
                CellWeb1.SetCellUserStringValue(k,j,k,j,"");
                CellWeb1.SetCellDigitShowStyle(k,j,k,j,-1,2);
                CellWeb1.SetCellVal(k,j,"");
            }            
        }
    }
    CellWeb1.RefreshViewSize();
}
function hidefield(){
    var maxrow=CellWeb1.GetMaxRow();
    var maxcol=CellWeb1.GetMaxCol();
    var userstr="";
    var userval=0; 
    var hiderowstart=0;
    var hiderowend=0;
    var mandatoryfield="";
    var showfield="";
    var editfield="";
    for(var i=1;i<=maxrow;i++){        
        for(var j=1;j<=maxcol;j++){
            userstr=CellWeb1.GetCellUserStringValue(i,j);
            userval=CellWeb1.GetCellUserValue(i,j);
            if(userstr.indexOf("field")>-1){
                if(userval==0){
                    showfield+=userstr.substring(5,userstr.indexOf("_"))+",";
                }
                if(userval==1){
                    editfield+=userstr.substring(5,userstr.indexOf("_"))+",";
                }
                if(userval==2){
                    mandatoryfield+=userstr.substring(5,userstr.indexOf("_"))+",";
                }
            }
            if(userstr=="requestname"){//模板中设置标题

            		if(userval==0){
                    showfield+="-1,";
                }
                if(userval==1){
                    editfield+="-1,";
                }
                if(userval==2){
                    mandatoryfield+="-1,";
                }
            }
            if(userstr=="requestlevel"){//模板中设置紧急程度

            		if(userval==0){
                    showfield+="-2,";
                }
                if(userval==1){
                    editfield+="-2,";
                }
                if(userval==2){
                    mandatoryfield+="-2,";
                }
            }
            if(userstr=="messageType"){//模板中设置短信类型

            		if(userval==0){
                    showfield+="-3,";
                }
                if(userval==1){
                    editfield+="-3,";
                }
                if(userval==2){
                    mandatoryfield+="-3,";
                }
            }
            if(userstr=="qianzi"){//模板中设置签字

            		if(userval==0){
                    showfield+="-4,";
                }
                if(userval==1){
                    editfield+="-4,";
                }
                if(userval==2){
                    mandatoryfield+="-4,";
                }
            }
             if(userstr=="chatsType"){//模板中微信提醒

            		if(userval==0){
                    showfield+="-5,";
                }
                if(userval==1){
                    editfield+="-5,";
                }
                if(userval==2){
                    mandatoryfield+="-5,";
                }
            }
            if(userstr.indexOf("_isneed")>0||userstr.indexOf("_isdefault")>0){
            	
            }
            if(userval>0){                
                CellWeb1.SetCellProtect(i,j,i,j,false);
            }else{
                if(userstr.indexOf("_sel")<0){
                    CellWeb1.SetCellProtect(i,j,i,j,true);
                }
            }
            if(userstr.length>0){
                //表头表尾标识
                /*
                var htmltype=userstr.substring(userstr.lastIndexOf("_")+1);                
                if(htmltype=="3" || htmltype=="6"){
                    CellWeb1.SetCellProtect(i,j,i,j,true);
                }
                */
                if(userstr.indexOf("_head")>0 || userstr.indexOf("_end")>0 || userstr.indexOf("_isprintbegin")>0 || userstr.indexOf("_isprintend")>0){
                    if(userstr.indexOf("_head")>0) hiderowstart=i;
                    if(userstr.indexOf("_end")>0) hiderowend=i;
                    if(hiderowstart>0 && hiderowend>0){
                        CellWeb1.SetRowHide(hiderowstart,hiderowend,true);
                        hiderowstart=0;
                        hiderowend=0;
                    }
                    if(userstr.indexOf("_isprintbegin")>0) hiderowstart=i;
                    if(userstr.indexOf("_isprintend")>0) hiderowend=i;
                    if(hiderowstart>0 && hiderowend>0){
                        CellWeb1.SetRowHide(hiderowstart,hiderowend,true);
                        hiderowstart=0;
                        hiderowend=0;
                    }
                    break;
                }else{
                    if(userstr.indexOf("_add")<0 && userstr.indexOf("_del")<0&& userstr.indexOf("_showKeyword")<0&& userstr.indexOf("_createCodeAgain")<0){
                        var cellval=CellWeb1.GetCellValue(i,j);
                        if(cellval.indexOf("@")<0){
                            CellWeb1.SetCellVal(i,j,"");
                        }
                    }
                }
            }
        }
    }
    if(mandatoryfield.length>1){
       mandatoryfield=mandatoryfield.substring(0,mandatoryfield.length-1);
    }
    if(showfield.length>1){
       showfield=showfield.substring(0,showfield.length-1);
    }
    if(editfield.length>1){
       editfield=editfield.substring(0,editfield.length-1);
    }
    form1.mandatoryfields.value=mandatoryfield;
    form1.editfields.value=editfield;
    form1.viewfields.value=showfield;
}
function showfield(){
    var maxrow=CellWeb1.GetMaxRow();
    var maxcol=CellWeb1.GetMaxCol();
    var userstr="";
    var userval=0;
    var hiderowstart=0;
    var hiderowend=0;
    for(var i=1;i<=maxrow;i++){
        for(var j=1;j<=maxcol;j++){
            userstr=CellWeb1.GetCellUserStringValue(i,j);             
<%if(isbill==1 && formid==156) {%>
            if(userstr == '<%=oldorganizationid%>') userstr = "<%=neworganizationid%>";
<%}%>
            if(userstr.length>0){
                if(userstr.indexOf("_sel")<0){
                    CellWeb1.SetCellProtect(i,j,i,j,true);
                }
                //表头表尾标识
                if(userstr.indexOf("_head")>0 || userstr.indexOf("_end")>0 || userstr.indexOf("_isprintbegin")>0 || userstr.indexOf("_isprintend")>0){
                    if(userstr.indexOf("_head")>0) hiderowstart=i;
                    if(userstr.indexOf("_end")>0) hiderowend=i;
                    if(hiderowstart>0 && hiderowend>0){
                        CellWeb1.SetRowHide(hiderowstart,hiderowend,false);
                        hiderowstart=0;
                        hiderowend=0;
                    }
                    if(userstr.indexOf("_isprintbegin")>0) hiderowstart=i;
                    if(userstr.indexOf("_isprintend")>0) hiderowend=i;
                    if(hiderowstart>0 && hiderowend>0){
                        CellWeb1.SetRowHide(hiderowstart,hiderowend,false);
                        hiderowstart=0;
                        hiderowend=0;
                    }
                    try{
                        parent.fieldlist.document.getElementById(userstr).style.display='none';
                    }catch(e){}
                    break;
                }else{
                    if(userstr.indexOf("_add")<0 && userstr.indexOf("_del")<0 && userstr.indexOf("_sel")<0&& userstr.indexOf("_showKeyword")<0&& userstr.indexOf("_createCodeAgain")<0){
                        try{
                            var cellval=CellWeb1.GetCellValue(i,j);
                            if(cellval.indexOf("@")<0){
                                CellWeb1.SetCellVal(i,j,"【$"+getChangeField(parent.fieldlist.document.getElementById(userstr).value)+"】");
                            }else{
                                CellWeb1.SetCellProtect(i,j,i,j,false);
                            }
                        }catch(e){}
                    }
                }
                try{
                    parent.fieldlist.document.getElementById(userstr).style.display='none';
                }catch(e){}
            }else{
                CellWeb1.SetCellProtect(i,j,i,j,false);
            }
        }
    }
}
function testSave(){
    if(currentver>systemver){
        if(language==8){
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
        else if(language==9){ 
             alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>"); 
        }
        else{
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
        return;
    }
    if(currentver<systemver){
        if(language==8){
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
        else if(language==9){ 
             alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>"); 
        }
        else{
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
        return;
    }

   
    
    CellWeb1.ShowHeader=false;
    CellWeb1.ShowGrid =false;
    hidefield();
    //alert(form1.modestring.value)
    if('<%=design%>'!='1'){
  
	    form1.modestring.value=CellWeb1.SaveDataAsZipText();
		document.form1.submit();
	}else{
		
		// 在流程图形化编辑时，通过ajax方式提交数据，不再刷新本页面
		hidefield();
		var url = getFormUrl();
		
		var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		xmlHttp.onreadystatechange = function(){
			
			if (xmlHttp.readyState == 4) {
				try{
					var result = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
					if(result=='0'){
						alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
					}else{
						alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");
						
						if(window.dialogArguments!=null){
							//window.dialogArguments.designOnClose();
						}
						<%if(design.equals("1")){%>
						try{
							parent.dialogArguments.window.document.location.href = parent.dialogArguments.window.document.location.href + "&randnum=" + new Date().getTime();
						}catch(e){}
						<%}%>
					}
					CellWeb1.ShowHeader=true;
   					CellWeb1.ShowGrid =true;
					showfield();
				}catch(e){
					alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				}
		    }
		}
		xmlHttp.open("POST", url, true);
		xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var modestring = CellWeb1.SaveDataAsZipText();
		modestring = myescapecode(modestring);
		xmlHttp.send("modestring="+modestring);
	}
}
// 获取form信息
function getFormUrl(){
	var url = document.form1.action;
	var _paras = "";
	for(var i=0;i<document.form1.elements.length;i++ ){
		if(document.form1.elements[i].name == "modestring"){
			continue;
		}
		_paras+="&"+document.form1.elements[i].name+"="+document.form1.elements[i].value;
	}
	
	return url+"?"+_paras.substring(1,_paras.length);
}

function InitFontname(){
	strFontnames = CellWeb1.GetDisplayFontNames();
	var arrFontname = strFontnames.split('|');
	arrFontname.sort();
	var i;
	var sysFont;
	sysFont = "宋体";
		
	for( i =0; i < arrFontname.length;i++ ){
		if(arrFontname[i] != "")
		{
			var oOption = document.createElement("OPTION");
			FontNameSelect.options.add(oOption);
			oOption
			oOption.innerText = arrFontname[i];
			oOption.value = arrFontname[i];
			if( arrFontname[i] == sysFont ) oOption.selected = true;
		}
	}
}

function menu_init()
{
	var nMenuID;
	var bPrint;
	
	nMenuID = MenuOcx.GetMenuID("SetRowAutoSize");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.IsRowAutoSize());
	if(CellWeb1.GetJumpStyle() ==1)
	{
		nMenuID = MenuOcx.GetMenuID("JumpNextCol");
		MenuOcx.SetMenuChecked(nMenuID,true);
		nMenuID = MenuOcx.GetMenuID("JumpNextRow");
		MenuOcx.SetMenuChecked(nMenuID,false);
	}
	else
	{
		nMenuID = MenuOcx.GetMenuID("JumpNextCol");
		MenuOcx.SetMenuChecked(nMenuID,false);
		nMenuID = MenuOcx.GetMenuID("JumpNextRow");
		MenuOcx.SetMenuChecked(nMenuID,true);
	}
	nMenuID = MenuOcx.GetMenuID("SetAutoJumpNextRowCol");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.IsAutoJumpNextRowCol());
	nMenuID = MenuOcx.GetMenuID("ShowErrorMsgBox");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.ShowErrorMsgBox);
	nMenuID = MenuOcx.GetMenuID("DesignMode")
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.DesignMode);
	nMenuID = MenuOcx.GetMenuID("ShowGrid");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.ShowGrid);
	nMenuID = MenuOcx.GetMenuID("ShowHeader");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.ShowHeader);
	nMenuID = MenuOcx.GetMenuID("FormProtect");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.FormProtect);
	nMenuID = MenuOcx.GetMenuID("SetProtectFormShowCursor");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.GetProtectFormShowCursor());
	nMenuID = MenuOcx.GetMenuID("SetShowPopupMenu");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.GetShowPopupMenu());
	nMenuID = MenuOcx.GetMenuID("SetAllowRowResizing");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.IsAllowRowResizing());
	nMenuID = MenuOcx.GetMenuID("SetAllowColResizing");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.IsAllowColResizing());
	nMenuID = MenuOcx.GetMenuID("SetDClickLabelCanSort");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.GetDClickLabelCanSort());
	bPrint = CellWeb1.IsCellCanPrint(CellWeb1.Row,CellWeb1.Col);
	nMenuID = MenuOcx.GetMenuID("SetCellCanPrint");
	MenuOcx.SetMenuChecked(nMenuID,bPrint);
	bPrint = CellWeb1.IsCellOnlyPrintText(CellWeb1.Row,CellWeb1.Col);
	nMenuID = MenuOcx.GetMenuID("SetCellOnlyPrintText");
	MenuOcx.SetMenuChecked(nMenuID,bPrint);
	nMenuID = MenuOcx.GetMenuID("SetRowLabel");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.GetRowLabel());
	nMenuID = MenuOcx.GetMenuID("SetColLabel");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.GetColLabel());
	nMenuID = MenuOcx.GetMenuID("SetPrintFormBackground");
	MenuOcx.SetMenuChecked(nMenuID,CellWeb1.IsPrintFormBackground());
	nMenuID = MenuOcx.GetMenuID("SetNotPrintFormBackground");
	MenuOcx.SetMenuChecked(nMenuID,!CellWeb1.IsPrintFormBackground());
    CellWeb1.GetFocus();
}

function menu_onload()
{
	MenuOcx.style.left = 0;
	MenuOcx.style.top = 0;

	var lWidth = document.body.offsetWidth;
	if( lWidth <= 0) lWidth = 1;
	MenuOcx.style.width = "100%";

	var href = window.document.location;//取得完整的url路径
	var  re;         // 声明变量。

	s = href.toString();
	//alert(s);
    re = /http/;    // 创建正则表达式模式。

    if( ! s.search(re) )   // 尝试匹配搜索字符串。是web上

    {
   		href = unescape(href);
		end = href.lastIndexOf("/");
		href = href.substring(0, end + 1);//web服务器的情况下

        if(language==8){
            href = href + "menu_en.xml";
        }
        <%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
            href = href + "menu_tw.xml";
        <%}else{%>
        if(language!=8){
            href = href + "menu.xml";
        }
        <%}%>
        //alert("web")
    }
    else
    {
    	href = window.location.pathname; //取得本地路径或相对的url路径
   		href = unescape(href);
		start = href.indexOf("/");
		end = href.lastIndexOf("\\");
		href = href.substring(start + 1, end + 1);
		if(language==8){
            href = href + "menu_en.xml";
        }
        <%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
            href = href + "menu_tw.xml";
        <%}else{%>
        if(language!=8){
            href = href + "menu.xml";
        }
        <%}%>
	 	//alert("disk");
    }	
	//alert(href);
	MenuOcx.SetMenuFromXML(href);
    CellWeb1.GetFocus();
}

function mouseout(){
  try{
	var x = oPopup.document.parentWindow.event.clientX;
	var y = oPopup.document.parentWindow.event.clientY
	if(x<0 || y<0) oPopup.hide();
  }catch(e){}	
}

var oPopup;
try{
   oPopup = window.createPopup()
}catch(e){}

function showPopup()
{
  try{
    var lefter =CellWeb1.GetMousePosX();	
    var topper =CellWeb1.GetMousePosY();
    var fieldname=CellWeb1.GetCellUserStringValue(CellWeb1.Row,CellWeb1.Col);
    var specialfield = fieldname.split("_");
    var htmltype = 0;
    if(specialfield.length==3) htmltype = specialfield[2];

    if(fieldname=="requestname"){
    	<%
	    if(nodetype.equals("0")){
    	%>
    		var html = "<DIV id='ocontextReqName' name='ocontextReqName' style='width:100%' >";
    		html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
    		html += "<tr><td colspan=6  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
    		html += "<input type=radio value='2' checked name='showtypeReqName' id='showtypeReqName' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18019,languageid)%>";
    		html += "</td></tr></table></DIV>";
	    	ocontextReqName.style.display='';
	    	//showtypeReqName.checked=true;
	    	CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,2);
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextReqName.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextReqName.offsetHeight, document.CellWeb1);
		    ocontextReqName.style.display='none';
	  	<%}else if(nodetype.equals("3")){%>
	  		var html = "<DIV id='ocontextReqName1' name='ocontextReqName1' style='width:100%' >";
	  		html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	  		html += "<tr><td colspan=6 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	  		html += "<input type=radio value='0' checked name='showtypeReqName1' id='showtypeReqName1' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%>";
	  		html += "</td></tr></table></DIV>";
	  		ocontextReqName1.style.display='';
	    	//showtypeReqName1.checked=true;
	    	CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextReqName1.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextReqName1.offsetHeight, document.CellWeb1);
		    ocontextReqName1.style.display='none';
	  	<%}else{%>
	    	ocontextReqName2.style.display='';
	    	var tempvalue=CellWeb1.GetCellUserValue(CellWeb1.Row,CellWeb1.Col);
	    	var html = "<DIV id='ocontextReqName2' name='ocontextReqName2' style='width:100%' >";
	    	html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	    	html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:15px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	    	if(tempvalue<=0){
		        //showtypeReqName2[0].checked=true;
		        //showtypeReqName2[1].checked=false;
		        html += "<input type=radio checked value='0' name='showtypeReqName2' id='showtypeReqName2' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
		        html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
		        html += "<input type=radio value='2' name='showtypeReqName2' id='showtypeReqName2' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18019,languageid)%>";
		        CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
	    	}else{
		        //showtypeReqName2[0].checked=false;
		        //showtypeReqName2[1].checked=true;
		        html += "<input type=radio value='0' name='showtypeReqName2' id='showtypeReqName2' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
		        html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
		        html += "<input type=radio checked value='2' name='showtypeReqName2' id='showtypeReqName2' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18019,languageid)%>";
		        CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,2);
	    	}
	    	html += "</td></tr></table></DIV>";
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextReqName2.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextReqName2.offsetHeight, document.CellWeb1);
		    ocontextReqName2.style.display='none';
	  	<%}%>
    }else if(fieldname=="requestlevel"||fieldname=="messageType"||fieldname=="chatsType"){
    	<%if(nodetype.equals("3")){%>
    		ocontextReqName1.style.display='';
    		var html = "<DIV id='ocontextReqName1' name='ocontextReqName1' style='width:100%' >";
	  		html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	  		html += "<tr><td colspan=6 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	  		html += "<input type=radio value='0' checked name='showtypeReqName1' id='showtypeReqName1' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%>";
	  		html += "</td></tr></table></DIV>";
	    	//showtypeReqName1.checked=true;
	    	CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextReqName1.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextReqName1.offsetHeight, document.CellWeb1);
		    ocontextReqName1.style.display='none';
    	<%}else{%>
	    	ocontextCombox.style.display='';
	    	var html = "<DIV id='ocontextCombox' name='ocontextCombox' style='width:100%' >";
	    	html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	    	html += "<tr><td colspan=2 STYLE='font-family:verdana; font-size:12; height:15px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	    	var tempvalue=CellWeb1.GetCellUserValue(CellWeb1.Row,CellWeb1.Col);
	    	if(tempvalue<=0){
		        //showtypeCombox[0].checked=true;
		        //showtypeCombox[1].checked=false;
		        html += "<input type=radio notBeauty=true value='0' name='showtypeCombox' id='showtype' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
		        html += "<tr><td colspan=2 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
		        html += "<input type=radio notBeauty=true value='1' name='showtypeCombox' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18018,languageid)%>";
		        CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
	    	}else{
		        //showtypeCombox[0].checked=false;
		        //showtypeCombox[1].checked=true;
		        html += "<input type=radio notBeauty=true value='0' name='showtypeCombox' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
		        html += "<tr><td colspan=2 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
		        html += "<input type=radio notBeauty=true value='1' name='showtypeCombox' id='showtype' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18018,languageid)%>";
		        CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,1);
	    	}
	    	html += "</td></tr></table></DIV>";
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextCombox.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextCombox.offsetHeight, document.CellWeb1);
		    ocontextCombox.style.display='none';
	  	<%}%>
    }else if(fieldname=="qianzi"){
    	<%if(nodetype.equals("3")){%>
    		ocontextReqName1.style.display='';
    		var html = "<DIV id='ocontextReqName1' name='ocontextReqName1' style='width:100%' >";
	  		html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	  		html += "<tr><td colspan=6 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	  		html += "<input type=radio value='0' checked name='showtypeReqName1' id='showtypeReqName1' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%>";
	  		html += "</td></tr></table></DIV>";
	    	//showtypeReqName1.checked=true;
	    	CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextReqName1.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextReqName1.offsetHeight, document.CellWeb1);
		    ocontextReqName1.style.display='none';
    	<%}else{%>
	    	ocontextCombox.style.display='';
	    	var tempvalue=CellWeb1.GetCellUserValue(CellWeb1.Row,CellWeb1.Col);
	    	var html = "<DIV id='ocontextCombox' name='ocontextCombox' style='width:100%' >";
	    	html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	    	html += "<tr><td colspan=2 STYLE='font-family:verdana; font-size:12; height:15px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	    	if(tempvalue<=0){
		        //showtypeCombox[0].checked=true;
		        //showtypeCombox[1].checked=false;
		        html += "<input type=radio notBeauty=true value='0' name='showtypeCombox' id='showtype' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
		        html += "<tr><td colspan=2 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
		        html += "<input type=radio notBeauty=true value='1' name='showtypeCombox' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18018,languageid)%>";
		        CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
	    	}else{
		        //showtypeCombox[0].checked=false;
		        //showtypeCombox[1].checked=true;
		        html += "<input type=radio notBeauty=true value='0' name='showtypeCombox' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
		        html += "<tr><td colspan=2 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
		        html += "<input type=radio notBeauty=true value='1' name='showtypeCombox' id='showtype' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18018,languageid)%>";
		        CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,1);
	    	}
	    	html += "</td></tr></table></DIV>";
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextCombox.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextCombox.offsetHeight, document.CellWeb1);
		    ocontextCombox.style.display='none';
	  	<%}%>
    }else if(htmltype == 7||fieldname.indexOf("wfl")==0||fieldname=="<%=hrmremain%>"||fieldname=="<%=deptremain%>"||fieldname=="<%=subcomremain%>"||fieldname=="<%=loanbalance%>"||fieldname=="<%=oldamount%>"){//特殊字段，控制鼠标右键无可编辑和必填
    		ocontextReqName1.style.display='';
    		var html = "<DIV id='ocontextReqName1' name='ocontextReqName1' style='width:100%' >";
	  		html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	  		html += "<tr><td colspan=6 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	  		html += "<input type=radio value='0' checked name='showtypeReqName1' id='showtypeReqName1' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%>";
	  		html += "</td></tr></table></DIV>";
	    	//showtypeReqName1.checked=true;
	    	CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextReqName1.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextReqName1.offsetHeight, document.CellWeb1);
		    ocontextReqName1.style.display='none';            
    /*}else if(htmltype ==9){
    		ocontextReqName1.style.display='';
    		var html = "<DIV id='ocontextReqName1' name='ocontextReqName1' style='width:100%' >";
	  		html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	  		html += "<tr><td colspan=6 STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	  		html += "<input type=radio value='0' checked name='showtypeReqName1' id='showtypeReqName1' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%>";
	  		html += "</td></tr></table></DIV>";
	    	//showtypeReqName1.checked=true;
	    	CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
		    oPopup.document.body.attachEvent("onmouseout",mouseout);
		    //oPopup.document.body.innerHTML = ocontextReqName1.innerHTML; 
		    oPopup.document.body.innerHTML = html; 
		    oPopup.show(lefter,topper,120,ocontextReqName1.offsetHeight, document.CellWeb1);
		    ocontextReqName1.style.display='none'; */
    }
    
    else if(fieldname.indexOf("_isneed")>0||fieldname.indexOf("_isdefault")>0){//特殊字段，控制鼠标右键无可编辑和必填
    		ocontextReqName1.style.display='none';
	    	CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
		    ocontextReqName1.style.display='none';
    }
    else{
	//alert(lefter+","+topper);	
	ocontext.style.display='';
    var tempvalue=CellWeb1.GetCellUserValue(CellWeb1.Row,CellWeb1.Col);

    var html = "<DIV id='ocontext' name='ocontext' style='width:100%' >";
	html += "<table id=otable cellpadding='0' width=120 cellspacing='0'>";
	html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:15px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";

    if(tempvalue<=0){
        //showtype[0].checked=true;
        //showtype[1].checked=false;
        //showtype[2].checked=false;
        html += "<input type=radio value='0' name='showtype' id='showtype' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
	    html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
	    html += "<input type=radio value='1' name='showtype' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18018,languageid)%>";
	    if(htmltype !=9){
			html += "</td></tr>";
			html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
			html += "<input type=radio value='2' name='showtype' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18019,languageid)%>";
		}
        if(tempvalue<0){
           CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,0);
        }
    }else{
        if(tempvalue==1){
            //showtype[1].checked=true;
            //showtype[0].checked=false;
            //showtype[2].checked=false;
        	 html += "<input type=radio value='0' name='showtype' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
             html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
             html += "<input type=radio value='1' name='showtype' id='showtype' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18018,languageid)%>";
             if(htmltype !=9){
				 html += "</td></tr>";
				 html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
				 html += "<input type=radio value='2' name='showtype' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18019,languageid)%>";
			 }
        }else{
            if(tempvalue>=2){
                //showtype[2].checked=true;
                //showtype[0].checked=false;
                //showtype[1].checked=false;
                html += "<input type=radio value='0' name='showtype' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>";
                html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
                html += "<input type=radio value='1' name='showtype' id='showtype' onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18018,languageid)%>";
                if(htmltype !=9){
					html += "</td></tr>";
					html += "<tr><td colspan=2  STYLE='font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid' >";
					html += "<input type=radio value='2' name='showtype' id='showtype' checked onclick='parent.setuservalue(this)'><%=SystemEnv.getHtmlLabelName(18019,languageid)%>";
				}
                if(tempvalue>2){
                    CellWeb1.SetCellUserValue(CellWeb1.Row,CellWeb1.Col,CellWeb1.Row,CellWeb1.Col,2);
                }
            }
        }
    }
    
    html += "</td></tr></table></DIV>";
    oPopup.document.body.attachEvent("onmouseout",mouseout);
    //alert(html);
    //oPopup.document.body.innerHTML = ocontext.innerHTML; 
    oPopup.document.body.innerHTML = html; 

    oPopup.show(lefter,topper,120,ocontext.offsetHeight, document.CellWeb1);
    ocontext.style.display='none';
  }
  
  }catch(e){}
  
}

function hidePopup()
{
  try{
	ocontext.style.display='none';
    parent.oPopup.hide();
  }catch(e){}  
}

function window_onresize() {
	var lWidth = document.body.offsetWidth;
	if( lWidth <= 0) lWidth = 1;
	CellWeb1.style.width = lWidth;

	var lHeight = document.body.offsetHeight - parseInt(CellWeb1.style.top);
	if( lHeight <= 0 ) lHeight = 1;
	CellWeb1.style.height = lHeight;
}
var lWidth=1;
var currentver=0;
var systemver=0;
function window_onload() {
    try{
        currentver=getCurrentVer();
        systemver=CellVersion.value;
    }catch(e){}
    if(currentver>systemver){
        if(language==8){
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
        else if(language==9){ 
             alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>"); 
         }
        else{
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
    }
    if(currentver<systemver){
        if(language==8){
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
        else if(language==9){ 
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>"); 
        }
        else{
            alert("<%=SystemEnv.getHtmlLabelName(83972,user.getLanguage())%>");
        }
    }
    cellregedit();
    menu_onload();
	menu_init();
	var aw = screen.availWidth; 
	var ah = screen.availHeight;
	//self.moveTo(0,0);
	//self.resizeTo(aw, ah);

	CellWeb1.border = 0;
	CellWeb1.style.left = 0;	
	
	CellWeb1.style.top = idTBDesign.offsetTop + idTBDesign.offsetHeight+27;
	lWidth = document.body.offsetWidth;
	if( lWidth <= 0)
		lWidth = 1;
	//CellWeb1.style.width = "100%";
	
	var lHeight = document.body.offsetHeight - parseInt(CellWeb1.style.top);
	if( lHeight <= 0 ) lHeight = 1;
	CellWeb1.style.height = lHeight;

	CellWeb1.style.display="";
    //CellWeb1.SetMaxRows(20);
    //CellWeb1.SetMaxCols(10);
    CellWeb1.SetShowPopupMenu(false);
    CellWeb1.DesignMode=true;        
    InitFontname();
}

</SCRIPT>

<!--BUTTON-->
<SCRIPT FOR="cbButton" EVENT="onmousedown()"	LANGUAGE="JavaScript" >
	return onCbMouseDown(this);
</SCRIPT>

<SCRIPT FOR="cbButton" EVENT="onclick()"		LANGUAGE="JavaScript" >
	return onCbClickEvent(this);
</SCRIPT>

<SCRIPT FOR="cbButton" EVENT="oncontextmenu()"	LANGUAGE="JavaScript" >
	return(event.ctrlKey);
</SCRIPT>

<SCRIPT FOR="CellWeb1" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
    showRightMenu();
    //var userstring=CellWeb1.GetCellUserStringValue(CellWeb1.Row,CellWeb1.Col);
    //if(userstring!=null && userstring!="" && userstring.indexOf("_add")<0 && userstring.indexOf("_del")<0 && userstring.indexOf("_head")<0 && userstring.indexOf("_end")<0 && userstring.indexOf("_sel")<0)
	//    showPopup();
	//return false;
</SCRIPT>
<SCRIPT FOR="CellWeb1" EVENT="CellContentChanged()"	LANGUAGE="JavaScript" >
	
</SCRIPT>

<SCRIPT ID=clientEventHandlersVBS LANGUAGE=vbscript>
</SCRIPT>
</HEAD>
<BODY id="mainbody" class="mainBody" LANGUAGE=javascript onresize="return window_onresize()" onload="return window_onload()">

<script language=javascript src="/workflow/mode/chinaexcelmenu_wev8.js"></script>
<div id=toptable style="width:100%">
<TABLE class="cbToolbar" id="idTBGeneral" cellpadding='0' cellspacing='0' width="100%">
	<TR>
	<TD NOWRAP><A class=tbButton id=cmdFileNew <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/new_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdFileOpen <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83984,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(83984,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/open_wev8.gif" width="16" height="16"></A></TD>
    <TD NOWRAP><A class=tbButton id=StyleCheck <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83985,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(83985,user.getLanguage())%>"<%}%> href="#" onclick="mnuStyleCheck_click()"><IMG align=absMiddle src="/images/icon_balancelist_wev8.gif" width="16" height="16"></A></TD>
    <TD NOWRAP><A class=tbButton id=CMDFILESAVEAS <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83986,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(83986,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/savexml_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A  id=testsave href="#" <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(19718,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(19718,user.getLanguage())%>"<%}%> onclick="testSave()" ><IMG align=absMiddle src="images/save_wev8.gif" width="16" height="16"></A></TD>
	<!--TD NOWRAP><A class=tbButton id=cmdFilePrintPaperSet title=打印页设置 href="#" name=cbButton><IMG align=absMiddle src="images/printpapaerset_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdFilePrintSetup title=打印设置 href="#" name=cbButton><IMG align=absMiddle src="images/printsetup_wev8.gif" width="16" height="16"></A></TD-->
	<TD NOWRAP><A class=tbButton id=cmdFilePrint <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/print_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdFilePrintPreview <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/printpreview_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdEditCut <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(16179,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(16179,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/cut_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdEditCopy <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/copy_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdEditPaste <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/paste_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdEditFind <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(15100,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(15100,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/find_wev8.gif" width="16" height="16"></A></TD>
	<!--TD NOWRAP><A class=tbButton id=cmdEditUndo title=撤消 href="#" name=cbButton><IMG align=absMiddle src="images/undo_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdEditRedo title=重做 href="#" name=cbButton  sticky="true"><IMG align=absMiddle src="images/redo_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdStatWizard title=报表统计向导 href="#" name=cbButton><IMG align=absMiddle src="images/databasewizard_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdFunctionList title=函数列表 href="#" name=cbButton><IMG align=absMiddle src="images/formula_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdUserFunctionGuide title=自定义函数向导 href="#" name=cbButton><IMG align=absMiddle src="images/formulaS_wev8.gif" width="16" height="16"></A></TD-->
	
	<!--TD NOWRAP><A class=tbButton id=cmdChartWzd title=图表向导 href="#" name=cbButton><IMG align=absMiddle src="images/chartw_wev8.gif" width="16" height="16"></A></TD-->
	<TD NOWRAP><A class=tbButton id=cmdInsertPic <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83991,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(83991,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/insertpic_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdInsertCellPic <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83993,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(83993,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/insertcellpic_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdHyperlink <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83994,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(83994,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/hyperlink_wev8.gif" width="16" height="16"></A></TD>
    <TD NOWRAP id="cmdBoderType" <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83996,user.getLanguage())%>"<%}else{%>Title="<%=SystemEnv.getHtmlLabelName(83996,user.getLanguage())%>"<%}%>>
		<SELECT name="BorderTypeSelect" ACCESSKEY="v" size="1">
          <option value="0" selected><%if(languageid==8){%>Filament<%}else{%>细线<%}%></option>
          <option value="1"><%if(languageid==8){%>Midline<%}else{%>中线<%}%></option>
          <option value="2"><%if(languageid==8){%>Broad<%}else{%>粗线<%}%></option>
          <option value="3"><%if(languageid==8){%>Dot<%}else{%>点线<%}%></option>
          <option value="4"><%if(languageid==8){%>Dashed<%}else{%>虚线<%}%></option>
          <option value="5"><%if(languageid==8){%>Dot Line<%}else{%>点划线<%}%></option>
          <option value="6"><%if(languageid==8){%>Dot Dot Line<%}else{%>点点划线<%}%></option>
        </SELECT>
	</TD>
    <TD NOWRAP id="cmdDrawColor" <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83997,user.getLanguage())%>"<%}else{%>Title="<%=SystemEnv.getHtmlLabelName(83997,user.getLanguage())%>"<%}%>>
		<SELECT name="BorderColor" ACCESSKEY="v" size="1" onchange="cmdDrawType.focus()">
          <option value="0" selected style="background-color:#000000">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="16711680" style="background-color:blue">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="32768" style="background-color:#008000">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="16776960" style="background-color:#00FFFF">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="255" style="background-color:red">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="16711935" style="background-color:#FF00FF">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="65535" style="background-color:#FFFF00">&nbsp;&nbsp;&nbsp;&nbsp;</option>  
          <option value="16777215" style="background-color:#FFFFFF">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="128" style="background-color:#800000">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="65280" style="background-color:#00FF00">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="32896" style="background-color:#808000">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="8388608" style="background-color:#000080">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="8388736" style="background-color:#800080">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="8421376" style="background-color:#008080">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="12632256" style="background-color:#C0C0C0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
          <option value="8421504" style="background-color:#808080">&nbsp;&nbsp;&nbsp;&nbsp;</option>
        </SELECT>
	</TD>
    <!--TD NOWRAP><A class=tbButton id=cmdDrawColor title=框线颜色 href="#" name=cbButton><IMG align=absMiddle src="images/bordercolor_wev8.bmp" width="16" height="16"></A></TD-->
    <TD NOWRAP id="cmdDrawType" <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83998,user.getLanguage())%>"<%}else{%>Title="<%=SystemEnv.getHtmlLabelName(83998,user.getLanguage())%>"<%}%>>
		<SELECT name="DrawTypeSelect" ACCESSKEY="v" size="1">
          <option value="0" selected><%if(languageid==8){%>All Border<%}else{%>画所有框线<%}%></option>
          <option value="1"><%if(languageid==8){%>Outer Border<%}else{%>画外框线<%}%></option>
          <option value="2"><%if(languageid==8){%>Up Border<%}else{%>画上框线<%}%></option>
          <option value="3"><%if(languageid==8){%>Down Border<%}else{%>画下框线<%}%></option>
          <option value="4"><%if(languageid==8){%>Left Border<%}else{%>画左框线<%}%></option>
          <option value="5"><%if(languageid==8){%>Right Border<%}else{%>画右框线<%}%></option>
          <option value="6"><%if(languageid==8){%>Up-Down Border<%}else{%>画上下框线<%}%></option>
          <option value="7"><%if(languageid==8){%>Left-right Border<%}else{%>画左右框线<%}%></option>
          <option value="8"><%if(languageid==8){%>Inner Border<%}else{%>画内框线<%}%></option>
          <option value="9"><%if(languageid==8){%>Horizontal Border<%}else{%>画横框线<%}%></option>
          <option value="10"><%if(languageid==8){%>Vertical Border<%}else{%>画竖框线<%}%></option>
        </SELECT>
	</TD>
    <TD NOWRAP><A class=tbButton id=cmdDrawBorder <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(84000,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(84000,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/border_wev8.gif" width="16" height="16"></A></TD>
    <TD NOWRAP id="cmdEraseType" <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(83999,user.getLanguage())%>"<%}else{%>Title="<%=SystemEnv.getHtmlLabelName(83999,user.getLanguage())%>"<%}%>>
		<SELECT name="EraseTypeSelect" ACCESSKEY="v" size="1">
          <option value="0" selected><%if(languageid==8){%>All Border<%}else{%>抹所有框线<%}%></option>
          <option value="1"><%if(languageid==8){%>Outer Border<%}else{%>抹外框线<%}%></option>
          <option value="2"><%if(languageid==8){%>Up Border<%}else{%>抹上框线<%}%></option>
          <option value="3"><%if(languageid==8){%>Down Border<%}else{%>抹下框线<%}%></option>
          <option value="4"><%if(languageid==8){%>Left Border<%}else{%>抹左框线<%}%></option>
          <option value="5"><%if(languageid==8){%>Right Border<%}else{%>抹右框线<%}%></option>
          <option value="6"><%if(languageid==8){%>Up-Down Border<%}else{%>抹上下框线<%}%></option>
          <option value="7"><%if(languageid==8){%>Left-right Border<%}else{%>抹左右框线<%}%></option>
          <option value="8"><%if(languageid==8){%>Inner Border<%}else{%>抹内框线<%}%></option>
          <option value="9"><%if(languageid==8){%>Horizontal Border<%}else{%>抹横框线<%}%></option>
          <option value="10"><%if(languageid==8){%>Vertical Border<%}else{%>抹竖框线<%}%></option>
        </SELECT>
	</TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdEraseBorder <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(84001 ,user.getLanguage())%>"<%}else{%>title="<%=SystemEnv.getHtmlLabelName(84001 ,user.getLanguage())%>"<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/erase_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="100%"></TD>
	</TR>
</TABLE>
<TABLE class="cbToolbar" id="idTBFormat" cellpadding='0' cellspacing='0' width="100%">
	<TR>
	<TD NOWRAP id="cmdFontName" <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(16189 ,user.getLanguage())%>"<%}else{%>Title="<%=SystemEnv.getHtmlLabelName(16189 ,user.getLanguage())%>"<%}%>>
		<SELECT name="FontNameSelect" style="WIDTH: 225px; HEIGHT: 23px" onChange="changeFontName(FontNameSelect.value)" ACCESSKEY="v" size="1">
        &nbsp; </SELECT>
	</TD>
	<TD NOWRAP class="tbDivider" id="cmdFontSize" <%if(languageid==8){%>title="<%=SystemEnv.getHtmlLabelName(16197 ,user.getLanguage())%>"<%}else{%>Title="<%=SystemEnv.getHtmlLabelName(16197 ,user.getLanguage())%>"<%}%>>
		<SELECT name="FontSizeSelect" onChange="changeFontSize(FontSizeSelect.value)" ACCESSKEY="v" size="1">
          <option value="5">5</option>
          <option value="6">6</option>
          <option value="7">7</option>
          <option value="8">8</option>
          <option value="9">9</option>
          <option selected value="10">10</option>
          <option value="11">11</option>
          <option value="12">12</option>
          <option value="14">14</option>
          <option value="16">16</option>
          <option value="18">18</option>
          <option value="20">20</option>
          <option value="22">22</option>
          <option value="24">24</option>
          <option value="26">26</option>
          <option value="28">28</option>
          <option value="30">30</option>
          <option value="36">36</option>
          <option value="42">42</option>
          <option value="48">48</option>
          <option value="72">72</option>
          <option value="100">100</option>
          <option value="150">150</option>
          <option value="300">300</option>
          <option value="500">500</option>
          <option value="800">800</option>
          <option value="1200">1200</option>
          <option value="2000">2000</option>
        </SELECT>
	</TD>

	<TD NOWRAP><A class=tbButton id=cmdBold <%if(languageid==8){%>title="Bold"<%}else{%>title=粗体<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/bold_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdItalic <%if(languageid==8){%>title="Italic"<%}else{%>title=斜体<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/italic_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdUnderline <%if(languageid==8){%>title="Underline"<%}else{%>title=下划线<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/underline_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdBackColor <%if(languageid==8){%>title="Background Color"<%}else{%>title=背景色<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/backcolor_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdForeColor <%if(languageid==8){%>title="Font Color"<%}else{%>title=前景色<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/forecolor_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdWordWrap <%if(languageid==8){%>title="Auto Wrap"<%}else{%>title=自动折行<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/wordwrap_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdAlignLeft <%if(languageid==8){%>title="Flush Left"<%}else{%>title=居左对齐<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/alignleft_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdAlignCenter <%if(languageid==8){%>title="Flush Center"<%}else{%>title=居中对齐<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/aligncenter_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdAlignRight <%if(languageid==8){%>title="Flush Right"<%}else{%>title=居右对齐<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/alignright_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdAlignTop <%if(languageid==8){%>title="Flush Top"<%}else{%>title=居上对齐<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/aligntop_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdAlignMiddle <%if(languageid==8){%>title="Flush Middle"<%}else{%>title=垂直居中<%}%> href="#" name=cbButton  sticky="true"><IMG align=absMiddle src="images/alignmiddle_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdAlignBottom <%if(languageid==8){%>title="Flush Bootom"<%}else{%>title=居下对齐<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/alignbottom_wev8.gif" width="16" height="16"></A></TD>
    <TD NOWRAP><A class=tbButton id=cmdFinanceType <%if(languageid==8){%>title="Finance Show"<%}else{%>title=财务表览<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/finance_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdFinanceHeaderType <%if(languageid==8){%>title="Finance Header"<%}else{%>title=财务表头<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/financeheader_wev8.gif" width="16" height="16"></A></TD>
    <TD class="tbDivider" NOWRAP width="100%"></TD>
	</TR>
</TABLE>
<TABLE class="cbToolbar" id="idTBDesign" cellpadding='0' cellspacing='0' width="100%">
	<TR>    
	<TD NOWRAP width="21"><A class=tbButton id=cmdInsertCol <%if(languageid==8){%>title="Insert Col"<%}else{%>title=插入列<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/insertcol_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="21"><A class=tbButton id=cmdInsertRow <%if(languageid==8){%>title="Insert Row"<%}else{%>title=插入行<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/insertrow_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="21"><A class=tbButton id=cmdInsertCell <%if(languageid==8){%>title="Insert Cell"<%}else{%>title=插入单元<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/insertcell_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP width="21"><A class=tbButton id=cmdDeleteCell <%if(languageid==8){%>title="Del Cell"<%}else{%>title=删除单元<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/deletecell_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="21"><A class=tbButton id=cmdDeleteCol <%if(languageid==8){%>title="Del Col"<%}else{%>title=删除列<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/deletecol_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="21"><A class=tbButton id=cmdDeleteRow <%if(languageid==8){%>title="Del Row"<%}else{%>title=删除行<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/deleterow_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP width="21"><A class=tbButton id=cmdMaxRowCol <%if(languageid==8){%>title="Max Col"<%}else{%>title=设置表格行列数<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/sheetsize_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="21"><A class=tbButton id=cmdMergeCell <%if(languageid==8){%>title="Merge Cell"<%}else{%>title=组合单元格<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/mergecell_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP width="21"><A class=tbButton id=cmdUnMergeCell <%if(languageid==8){%>title="UnMerge Cell"<%}else{%>title=取消单元格组合<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/unmergecell_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="21"><A class=tbButton id=cmdReCalcAll <%if(languageid==8){%>title="Recalculation"<%}else{%>title=重算计算全表<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/calculateall_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP width="21"><A class=tbButton id=cmdFormProtect <%if(languageid==8){%>title="Form Protect"<%}else{%>title=设置/取消整表保护<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/formprotect_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP width="21"><A class=tbButton id=cmdReadOnly <%if(languageid==8){%>title="Read Only"<%}else{%>title=单元格只读<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/readonly_wev8.gif" width="16" height="16"></A></TD>
    <TD NOWRAP><A class=tbButton id=cmdFormulaSumH <%if(languageid==8){%>title="SumH"<%}else{%>title=水平求和<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/sumh_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdFormulaSumV <%if(languageid==8){%>title="SumV"<%}else{%>title=垂直求和<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/sumv_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdFormulaSumHV <%if(languageid==8){%>title="SumHV"<%}else{%>title=双向求和<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/sum_wev8.gif" width="16" height="16"></A></TD>
    <TD class="tbDivider" NOWRAP><A class=tbButton id=SETCCINCELLS <%if(languageid==8){%>title="no-main cell of combined cell attend calculate"<%}else{%>title=组合单元中的非主单元参于计算<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/sumcell_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdCurrency <%if(languageid==8){%>title="￥"<%}else{%>title=货币符号<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/currency_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdPercent <%if(languageid==8){%>title="％"<%}else{%>title=百分号<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/percent_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdThousand <%if(languageid==8){%>title="，"<%}else{%>title=千分位<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/thousand_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdShowGridline <%if(languageid==8){%>title="Grid Line"<%}else{%>title=显示/隐藏背景表格线<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/gridline_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdShowHeader <%if(languageid==8){%>title="Form Header"<%}else{%>title=显示/隐藏系统表头<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/header_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdShape3D <%if(languageid==8){%>title="Shape 3D"<%}else{%>title=设置/取消单元3维显示<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/shape3D_wev8.gif" width="16" height="16"></A></TD>
	<TD NOWRAP><A class=tbButton id=cmdRowLabel <%if(languageid==8){%>title="Row Label"<%}else{%>title=设置/取消行表头<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/rowlabel_wev8.gif" width="16" height="16"></A></TD>
	<TD class="tbDivider" NOWRAP><A class=tbButton id=cmdColLabel <%if(languageid==8){%>title="Col Label"<%}else{%>title=设置/取消列表头<%}%> href="#" name=cbButton><IMG align=absMiddle src="images/collabel_wev8.gif" width="16" height="16"></A></TD>
	
    <TD class="tbDivider" NOWRAP><A class=tbButton id=delaxtive href="#" <%if(languageid==8){%>title="Del Fields"<%}else{%>title="删除字段"<%}%> onclick="deleteA()" ><IMG align=absMiddle src="/images/BacoCross_wev8.gif" width="13" height="13"></A></TD>
	<TD NOWRAP width="100%"></TD>
	</TR>
</TABLE>
</div>
<div id=divtest style="width:100%;LEFT: 0px;POSITION: relative;"><%if(languageid==8){%>Loading<%}else{%>正在装载报表设计器插件<%}%>......</div>

<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelweb_tw_wev8.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelweb_wev8.js"></script>
<%} %>
<div id='divshowCheck' name='divshowCheck' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<DIV id="ocontext" name="ocontext" style="display:none;width:100%" >
<table id=otable cellpadding='0' width=120 cellspacing='0'>
<tr><td colspan=2 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:15px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="0" name="showtype" id="showtype" checked onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>
<tr><td colspan=2 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="1" name="showtype" id="showtype" onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(18018,languageid)%>
</td></tr>
<tr><td colspan=2 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="2" name="showtype" id="showtype" onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(18019,languageid)%>
</td></tr>
</table>
</DIV>
<DIV id="ocontextReqName" name="ocontextReqName" style="display:none;width:100%" >
<table id=otable cellpadding='0' width=120 cellspacing='0'>
<tr><td colspan=6 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="2" name="showtypeReqName" id="showtypeReqName" onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(18019,languageid)%>
</td></tr>
</table>
</DIV>
<DIV id="ocontextReqName1" name="ocontextReqName1" style="display:none;width:100%" >
<table id=otable cellpadding='0' width=120 cellspacing='0'>
<tr><td colspan=6 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="0" name="showtypeReqName1" id="showtypeReqName1" onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(89,languageid)%>
</td></tr>
</table>
</DIV>
<DIV id="ocontextReqName2" name="ocontextReqName2" style="display:none;width:100%" >
<table id=otable cellpadding='0' width=120 cellspacing='0'>
<tr><td colspan=2 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:15px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="0" name="showtypeReqName2" id="showtypeReqName2" checked onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>
<tr><td colspan=2 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="2" name="showtypeReqName2" id="showtypeReqName2" onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(18019,languageid)%>
</td></tr>
</table>
</DIV>
<DIV id="ocontextCombox" name="ocontextCombox" style="display:none;width:100%" >
<table id=otable cellpadding='0' width=120 cellspacing='0'>
<tr><td colspan=2 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:15px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="0" name="showtypeCombox" id="showtype" checked onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(89,languageid)%></td></tr>
<tr><td colspan=2 onmouseover="this.style.background='#1397D4'" onmouseout="this.style.background='#3081BB'" STYLE="font-family:verdana; font-size:12; height:20px; background:#3081BB; border:1px solid black; padding:4px; cursor:hand; border-top:0px solid black;color:#ffffff;BORDER-RIGHT: #000000 1px solid;BORDER-TOP: #ffffff 1px solid;BORDER-LEFT: #ffffff 1px solid;BORDER-BOTTOM: #000000 1px solid" >
<input type=radio notBeauty=true value="1" name="showtypeCombox" id="showtype" onclick="parent.setuservalue(this)"><%=SystemEnv.getHtmlLabelName(18018,languageid)%>
</td></tr>
</table>
</DIV>
<script language=javascript>
function readmode(){
    CellWeb1.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
    showfield();
}
</script>
<script language=vbs>
        readmode()
        CellWeb1.ShowHeader=true
        CellWeb1.ShowGrid =true
        parent.showlist()
</script>
<form name="form1" method="post" action="eweb_operation.jsp" >
<input type=hidden id="modestring" name="modestring" value="">
<input type=hidden id="wfid" name="wfid" value="<%=wfid%>">
<input type=hidden id="formid" name="formid" value="<%=formid%>">
<input type=hidden id="nodeid" name="nodeid" value="<%=nodeid%>">
<input type=hidden id="modeid" name="modeid" value="<%=modeid%>">
<input type=hidden id="isbill" name="isbill" value="<%=isbill%>">
<input type=hidden id="isprint" name="isprint" value="<%=isprint%>">
<input type=hidden id="isform" name="isform" value="<%=isform%>">
<input type=hidden id="mandatoryfields" name="mandatoryfields" value="">
<input type=hidden id="viewfields" name="viewfields" value="">
<input type=hidden id="editfields" name="editfields" value="">
<input type=hidden id="ajax" name="ajax" value="<%=ajax%>">    
<input type=hidden id ="design" name ="design" value="<%=design%>">
</form>
<script language=javascript>
function setuservalue(obj){
    var chinacel=CellWeb1;
    var startrow=chinacel.GetSelectRegionStartRow();
    var endrow=chinacel.GetSelectRegionEndRow();
    var startcol=chinacel.GetSelectRegionStartCol();
    var endcol=chinacel.GetSelectRegionEndCol();
    for(var i=startrow;i<=endrow;i++){
        for(var j=startcol;j<=endcol;j++){
            var uservalue=chinacel.GetCellUserStringValue(i,j);
            if(uservalue!=null && uservalue!="" && uservalue.indexOf("_add")<0 && uservalue.indexOf("_del")<0 && uservalue.indexOf("_head")<0 && uservalue.indexOf("_end")<0 && uservalue.indexOf("_sel")<0&& uservalue.indexOf("_showKeyword")<0&& uservalue.indexOf("_isprintbegin")<0&& uservalue.indexOf("_isprintend")<0){
                var index=uservalue.lastIndexOf("_");
                var htmltype=0;
                if(index>0){
                    htmltype=uservalue.substr(index+1);
                }
                chinacel.SetCellProtect(i,j,i,j,false);
                chinacel.SetCellUserValue(i,j,i,j,obj.value);
                if(obj.value=="2"){
                    if(htmltype==3 || htmltype==6 || uservalue=="qianzi"){
                        chinacel.ReadHttpImageFile("/images/BacoBrowser_b_wev8.gif",i,j,true,true);
                    }else{
                        chinacel.ReadHttpImageFile("/images/BacoError_wev8.gif",i,j,true,true);
                    }
                }else if(obj.value=="1"){
                    if(htmltype==3 || htmltype==6 || uservalue=="qianzi"){
                        chinacel.ReadHttpImageFile("/images/BacoBrowser_wev8.gif",i,j,true,true);
                    }else{
                        chinacel.DeleteCellImage(i,j,i,j);
                    }
                }else{
                    chinacel.DeleteCellImage(i,j,i,j);
                }
                chinacel.SetCellProtect(i,j,i,j,true);
            }
        }
    }
}
</script>

</BODY>
</HTML>
