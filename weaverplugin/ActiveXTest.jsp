
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>ActiveX</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
.STYLE1 {
	color: #000000;
	font-weight: bold;
	font-size: 13px;
}
.STYLE2 {font-size: 13px}
.STYLE3 {
	color: #636363;
	font-size: 12px;
}
.STYLE4 {color: #939393;font-size: 12px}
.STYLE8 {color: #414141;font-size: 12px; font-weight: bold; }

#qid01 {
float:right;
margin-right:60px;
border:0px #ff0 solid;
height:20px;
width:25px;
cursor: pointer;
}
#qid02 {
float:right;
margin-right:60px;
border:0px #ff0 solid;
height:20px;
width:25px;
cursor: pointer;
}

.question01{display:block;}

.question02{display:block;}

img{ vertical-align:middle;margin-top:0px;}
-->
</style>
<script language="javascript" src="/js/activex/ActiveX_wev8.js"></script>
		<script language="javascript">
            <!--
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
try{
if (window.Event)
  document.captureEvents(Event.MOUSEUP);
}catch(e){
	
}

function nocontextmenu()
{
 event.cancelBubble = true
 event.returnValue = false;

 return false;
}

function norightclick(e)
{
 if (window.Event)
 {
  if (e.which == 2 || e.which == 3)
   return false;
 }
 else
  if (event.button == 2 || event.button == 3)
  {
   event.cancelBubble = true
   event.returnValue = false;
   return false;
  }

}

document.oncontextmenu = nocontextmenu;  // for IE5+
document.onmousedown = norightclick;  // for all others
//-->
			// Array(控件名称, ProgID, 版本, 说明)
			var aActiveXs = new Array();

			

			// 插入控件行，创建控件列表
			function insertActiveXRows(language)
			{
                var chasm = screen.availWidth;
                var mount = screen.availHeight;
                if(chasm<650) chasm=650;
                if(mount<700) mount=700;
				var xmlDoc ;
				var xmlUrl = "";
				if(language==8){
                    xmlUrl="/activex/ActiveXEN.xml";
                }
                <%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
		            xmlUrl = "/activex/ActiveXBIG5.xml";
		        <%}else{%>
		        if(language!=8){
		            xmlUrl = "/activex/ActiveX.xml";
		        }
		        <%}%>
		        
		        $.get(xmlUrl,function (data){  
		        
		        	xmlDoc = $(data);
					var xmlGroupNodes = xmlDoc.find("group");
					var xmlActveXNodes;
					var sName, sCLSID, sCLSName, sProgID, sVersion, sCheckPageURL;
					xmlActveXNodes = xmlDoc.find("activex");
					for (var i = 0; i < xmlActveXNodes.length; i++)
					{	
						var xmlActveXNode = xmlActveXNodes[i];
						sName = $(xmlActveXNode).find("name").text();
						sCLSID = $(xmlActveXNode).find("clsid").text();
						sCLSName = $(xmlActveXNode).find("clsname").text();
						sProgID = $(xmlActveXNode).find("progid").text();
						sVersion = $(xmlActveXNode).find("version").text();
						sCheckPageURL = $(xmlActveXNode).find("checkpageurl").text();
						aActiveXs[aActiveXs.length] = new Array(sName, sCLSID, sCLSName, sProgID, sVersion, sCheckPageURL);
					}
					
					// 插入行
					var oTable, oTr, oTd;
					var aProgID, acheckver, bInstalled;

					oTable = document.all("tblActiveXList");
					for (var i = 0; i < aActiveXs.length; i++)
					{
						bInstalled = true;
                        aProgID=aActiveXs[i][3];
						if (!Detect(aProgID))
						{
							bInstalled = false;
						}

						oTr = oTable.insertRow(-1);
						oTr.style.height = 40;

						oTd = oTr.insertCell(0);
                        oTd.width=38;
                        oTd.align = "center";
						oTd.innerHTML = "<span class=STYLE3>"+(i+1).toString(10)+"</span>";
                        oTd = oTr.insertCell(1);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(2);
                        oTd.width=90;
						oTd.innerHTML = "<span class=STYLE3>"+aActiveXs[i][0]+"</span>";
                        oTd = oTr.insertCell(3);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(4);
                        oTd.width=220;
						oTd.innerHTML = "<span class=STYLE3>"+aActiveXs[i][1]+"</span>";
                        oTd = oTr.insertCell(5);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(6);
                        oTd.width=150;
						oTd.innerHTML = "<span class=STYLE3>"+aActiveXs[i][2]+"</span>";
                        oTd = oTr.insertCell(7);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(8);
                        oTd.width=50;
						oTd.innerHTML = "<span class=STYLE3>"+aActiveXs[i][4]+"</span>";
                        oTd = oTr.insertCell(9);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(10);
                        oTd.width=50;
                        oTd.align = "center";
                        oTd.id="oTd10_"+i;
						oTd.innerHTML = bInstalled?"<img src='/images/plugin/hook_wev8.png' width=18 height=18 />":"<img src='/images/plugin/cha_wev8.png' width=18 height=18 />";
                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][4]);
                            if(bInstalled){
                                oTr.cells[10].innerHTML="<img src='/images/plugin/hook_wev8.png' width=18 height=18 /><br><span style='color:#a2a2a2;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
                            }
                        }
                        oTd = oTr.insertCell(11);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(12);
                        oTd.width=50;
						oTd.innerHTML = "<div style='width:65px; height:32px; color:#818181;font-size:10px; cursor:pointer; padding-left:30px;padding-top:5px;line-height:20px;background:url(/images/plugin/check-normal_wev8.png) no-repeat' onmouseover='onMOver(this)' onmouseout='onMOut(this)' onclick=\"Winopen('" + aActiveXs[i][5] + "','','scrollbars=yes,resizable=no,width=690,Height=615,top="+(mount-700)/2+",left="+(chasm-650)/2+"')\"><%=SystemEnv.getHtmlLabelName(130966,user.getLanguage())%></div>";
                        oTr = oTable.insertRow(-1);
                        oTd = oTr.insertCell(-1);
                        oTd.colSpan = 13;
                        oTd.innerHTML="<img src='/images/plugin/line_0_wev8.gif' width='100%' height=1 >";
					}
		        
		        });
				
			}
            // 定时刷新状态
			function refreshState()
			{
				if (aActiveXs)
				{
					var oTable;
					var aProgID, bInstalled;
					var allInstalled=true;
					oTable = document.all("tblActiveXList");
					for (var i = 0; i < aActiveXs.length; i++)
					{
						bInstalled = true;
						aProgID = aActiveXs[i][3];
						if (!Detect(aProgID))
						{
							bInstalled = false;
						}
						document.all("oTd10_"+i).innerHTML = bInstalled?"<img src='/images/plugin/hook_wev8.png' width=18 height=18 />":"<img src='/images/plugin/cha_wev8.png' width=18 height=18 />";

                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][4]);
                            if(bInstalled){
                                document.all("oTd10_"+i).innerHTML="<img src='/images/plugin/hook_wev8.png' width=18 height=18 /><br><span style='color:#a2a2a2;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
                            }
                        }
					}
				}
			}
            
			window.onload = function()
			{
				insertActiveXRows(<%=user.getLanguage()%>);
                window.setInterval("refreshState()", 5000);
			}

function onMOver(obj){
	$(obj).attr("src","/images/plugin/check-hot_wev8.png");

}

function onMOut(obj){
	$(obj).attr("src","/images/plugin/check-normal_wev8.png");
}
			
function showHidden(obj,type){
	var display = $("tr."+type).css("display");
	$("tr."+type).slideToggle("normal");
	if(display=="none"){
		$(obj).attr("src","/images/plugin/retract01_wev8.png");
	}else{
		$(obj).attr("src","/images/plugin/retract02_wev8.png");
	}
}

function Winopen(url,winname,nstyle){
		var theme_imp = new window.top.Dialog();
		theme_imp.currentWindow = window;   //传入当前window
	 	theme_imp.Width = 650;
	 	theme_imp.Height = 400;
	 	theme_imp.maxiumnable=true;
	 	theme_imp.Modal = true;
	 	theme_imp.Title = winname; 
	 	theme_imp.URL =url;
	 	theme_imp.show();
}
		</script>
</head>

<body>

<table style="width:100%;">
      <tr >
        <td height="40" background="/images/plugin/back_wev8.gif">
        <table width="100%" height="24" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="40" height="32" rowspan="2" align="right" valign="middle"><img src="/images/plugin/control_wev8.png" width="32" height="32" align="absmiddle" /></td>
            <td  height="32" align="left" ><span class="STYLE1"><span class="STYLE2">&nbsp;<%=SystemEnv.getHtmlLabelName(22006,user.getLanguage())%></span></span></td>
          </tr>
        </table></td>
        </tr>
      <tr>
        <td  height="40" align="center" valign="middle" style="border-collapse:collapse;border:1px solid #40ABF6;border-bottom:none;border-left:none;border-right:none;">
            <table id="tblActiveXList" height="100%" width="98%" style="border-collapse:collapse;border:0px;" cellpadding="0" cellspacing="0">
          <tr style="border:1px  solid #e7e7e7;border-left:none;border-right:none;border-top:none;height:40px;">
            <td width="38" align="center" valign="middle" bgcolor=#f3f3f3 ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></span></td>
            <td width="2" valign="middle" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="90" align="center" valign="middle" bgcolor=#f3f3f3 ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="220" align="center" valign="middle" bgcolor=#f3f3f3 ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22037,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="150" align="center" valign="middle" bgcolor=#f3f3f3 ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22037,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="50" align="center" valign="middle" bgcolor=#f3f3f3 ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="45" align="center" valign="middle" bgcolor=#f3f3f3 ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="55" align="center" valign="middle" bgcolor=#f3f3f3 ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22011,user.getLanguage())%></span></td>
          </tr>
        </table></td>
        </tr>

      <tr>
        <td height="10" align="center" valign="middle"></td>
      </tr>
      <tr>
        <td width="32" height="32" align="left" style="border:1px  solid #e7e7e7;border-left:none;border-right:none;border-top:none;">&nbsp;&nbsp;<img src="/images/plugin/question1_wev8.png" width="32" height="32" align="absmiddle" /><span class="STYLE8">&nbsp;<%=SystemEnv.getHtmlLabelName(22019,user.getLanguage())%></span><div id="qid01" ><img src="/images/plugin/retract01_wev8.png" onclick="showHidden(this,'question01')"/></div></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/plugin/step01_wev8.png" width="32" height="32" align="absmiddle" /><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22020,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%> C:\WINDOWS\Downloaded Program Files<%=SystemEnv.getHtmlLabelName(22024,user.getLanguage())%></span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/plugin/step02_wev8.png" width="32" height="32" align="absmiddle" /><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22021,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22025,user.getLanguage())%></span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/plugin/step03_wev8.png" width="32" height="32" align="absmiddle" /><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22022,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22026,user.getLanguage())%></span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" ><span class="STYLE4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1、<%=SystemEnv.getHtmlLabelName(22027,user.getLanguage())%> regedit.exe；</span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" ><span class="STYLE4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2、<%=SystemEnv.getHtmlLabelName(22028,user.getLanguage())%> {23739A7E-5741-4D1C-88D5-</span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="STYLE4">D50B18F7C347}；</span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" ><span class="STYLE4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3、<%=SystemEnv.getHtmlLabelName(22029,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22027,user.getLanguage())%>“regsvr32 /u</span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" ><span class="STYLE4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;<%=SystemEnv.getHtmlLabelName(22030,user.getLanguage())%>&gt;”<%=SystemEnv.getHtmlLabelName(22031,user.getLanguage())%></span></td>
      </tr>
      <tr class="question01">
        <td height="22" align="left" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/plugin/step04_wev8.png" width="32" height="32" align="absmiddle" /><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22023,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())%>  <%=SystemEnv.getHtmlLabelName(22032,user.getLanguage())%></span><button style="width:32px;height:32px;background:#FFFFFF;" onclick="OnCheckPage('/weaverplugin/PluginMaintenance.jsp',730,600)"><img src="/images/plugin/detail02_wev8.png" width="32px" height="32px" /></button></td>
      </tr>
      <tr>
        <td height="10" align="left"><span class="STYLE4"></span></td>
      </tr>
      <tr>
        <td height="22" align="left" style="border:1px  solid #e7e7e7;border-left:none;border-right:none;border-top:none;">&nbsp;&nbsp;<img src="/images/plugin/question2_wev8.png" width="32" height="32" align="absmiddle" /><span class="STYLE8">&nbsp;<%=SystemEnv.getHtmlLabelName(22033,user.getLanguage())%></span><div id="qid02" ><img src="/images/plugin/retract01_wev8.png" onclick="showHidden(this,'question02')"/></div></td>
      </tr>
      <tr class="question02">
        <td height="22" align="left" ><span class="STYLE4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(22034,user.getLanguage())%></span></td>
      </tr>

      <tr>
        <td height="20" align="left">&nbsp;</td>
      </tr>
    </table>

<div style="DISPLAY:none">
			<OBJECT id="ChinaExcel" height="0" hspace="0" width="0" vspace="0" classid="clsid:15261F9B-22CC-4692-9089-0C40ACBDFDD8"></OBJECT>
        </div>
</body>
</html>
