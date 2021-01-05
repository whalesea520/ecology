<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
boolean NoCheck=false;
RecordSet.executeSql("select NoCheckPlugin from SysActivexCheck where NoCheckPlugin='1' and userid="+user.getUID());
if(RecordSet.next()) NoCheck=true;

String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>控件页面</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
.STYLE1 {
	color: #3169ce;
	font-weight: bold;
	font-size: 13px;
}
.STYLE2 {font-size: 13px}
.STYLE3 {
	color: #3169ce;
	font-size: 12px;
}
.STYLE4 {font-size: 12px}
.STYLE5 {
	color: #0000FF;
	font-weight: bold;
}
.STYLE7 {font-size: 12px; color: #FF0000; }
-->
</style>
<script language="javascript" src="/js/activex/ActiveX.js"></script>
		<script language="javascript">
        <!--
/*function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}*/
if (window.Event)
  document.captureEvents(Event.MOUSEUP);

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
			// Array(控件名称, ProgID1;ProgID2;..., 安装文件地址, 文件大小, 说明)
			var aActiveXs = new Array();

			jQuery(document).ready(function(){

			try{	   
				insertActiveXRows(<%=user.getLanguage()%>);
			}catch(e){
                alert('<%=SystemEnv.getHtmlLabelName(32983,user.getLanguage())%>!');
                window.close();//暂时处理办法
			}
				window.setInterval("refreshState()", 5000);
			
       		}); 
           


	/*		
			function window.onload()
			{  
				insertActiveXRows(<%=user.getLanguage()%>);
				window.setInterval("refreshState()", 5000);
			}
			
	*/
			// 插入控件行，创建控件列表
			function insertActiveXRows(language)
			{
				var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");

				xmlDoc.async = false;
				xmlDoc.resolveExternals = false;
				if(language==8){
                    xmlDoc.load("/activex/ActiveXEN.xml");
                }
                <%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
		            xmlDoc.load("/activex/ActiveXBIG5.xml");
		        <%}else{%>
		        if(language!=8){
		            xmlDoc.load("/activex/ActiveX.xml");
		        }
		        <%}%>
				if (xmlDoc.parseError.errorCode != 0)
				{
					var myError = xmlDoc.parseError;
					alert("You have error " + myError.reason);
				}
				else
				{
					var xmlGroupNodes = xmlDoc.selectNodes("//group");
					var xmlActveXNodes;
					var sGroupID, sName, sProgIDs, sInstallURL, sSize, sExplain,version;

					// 找出分组打包在一起的控件
					for (var i = 0; i < xmlGroupNodes.length; i++)
					{
						sName = xmlGroupNodes[i].selectSingleNode("name").text;
						sGroupID = xmlGroupNodes[i].attributes.getNamedItem("id").text;
						sProgIDs = "";
						sInstallURL = xmlGroupNodes[i].selectSingleNode("install/url").text;
						sSize = xmlGroupNodes[i].selectSingleNode("install/size").text;
						sExplain = xmlGroupNodes[i].selectSingleNode("explain").text;
                        version = xmlGroupNodes[i].selectSingleNode("version").text;

						xmlActveXNodes = xmlDoc.selectNodes("//activex[@groupid=" + sGroupID + "]");
						for (var j = 0; j < xmlActveXNodes.length; j++)
						{
							if (sProgIDs == "")
								sProgIDs = xmlActveXNodes[j].selectSingleNode("progid").text;
							else
								sProgIDs += ";" + xmlActveXNodes[j].selectSingleNode("progid").text;
						}

						aActiveXs[aActiveXs.length] = new Array(sName, sProgIDs, sInstallURL, sSize, sExplain,version);
					}


					// 处理没有分组的控件
					xmlActveXNodes = xmlDoc.selectNodes("//activex[@groupid='']");
					for (var i = 0; i < xmlActveXNodes.length; i++)
					{
						sName = xmlActveXNodes[i].selectSingleNode("name").text;
						sProgIDs = xmlActveXNodes[i].selectSingleNode("progid").text;
						sInstallURL = xmlActveXNodes[i].selectSingleNode("install/url").text;
						sSize = xmlActveXNodes[i].selectSingleNode("install/size").text;
						sExplain = xmlActveXNodes[i].selectSingleNode("explain").text;
                        version = xmlActveXNodes[i].selectSingleNode("version").text;
						aActiveXs[aActiveXs.length] = new Array(sName, sProgIDs, sInstallURL, sSize, sExplain,version);
					}


					// 插入行
					var oTable, oTr, oTd;
					var aProgID, acheckver, bInstalled;
					var allInstalled=true;
					oTable = document.all("tblActiveXList");
					for (var i = 0; i < aActiveXs.length; i++)
					{
						bInstalled = true;
						aProgID = aActiveXs[i][1].split(";");
						for (var j = 0; j < aProgID.length; j++)
						{
							if (!Detect(aProgID[j]))
							{
								bInstalled = false;
								break;
							}
						}

						oTr = oTable.insertRow();
						oTr.style.height = 40;

						oTd = oTr.insertCell(0);
                        oTd.width=40;
                        oTd.align="center";
						oTd.innerHTML = "<span class=STYLE4>"+(i+1).toString(10)+"</span>";
                        oTd = oTr.insertCell(1);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(2);
                        oTd.width=90;
						oTd.innerHTML = "<span class=STYLE4>"+aActiveXs[i][0]+"</span>";
                        oTd = oTr.insertCell(3);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(4);
                        oTd.width=280;
						oTd.innerHTML = "<span class=STYLE4>"+aActiveXs[i][4]+"</span>";
                        oTd = oTr.insertCell(5);
						oTd.innerHTML ="";

						oTd = oTr.insertCell(6);
                        oTd.width=30;
                        oTd.align="right";
						oTd.innerHTML = "<span class=STYLE4>"+aActiveXs[i][3]+"</span>";
                        oTd = oTr.insertCell(7);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(8);
                        oTd.width=50;
                        oTd.align = "center";
                        oTd.id="oTd_"+i;

                        if(i>0)
						oTd.innerHTML = bInstalled?"<img src='/images/plugin/status.gif' width=14 height=14 />":"<img src='/images/plugin/wrong.gif' width=14 height=14 />";
                        if(i>0&&allInstalled&&!bInstalled&&aProgID!="JavaWebStart.isInstalled") allInstalled=false;
                        oTd = oTr.insertCell(9);
                        oTd.width=2;
						oTd.innerHTML ="";
						oTd = oTr.insertCell(10);
                        oTd.width=80;
						oTd.align = "center";
                        oTd.id="oTd10_"+i;
						oTd.innerHTML = "<img src='/images/plugin/downloads.gif' width=12 height=12 align='absmiddle' /><a style='font-size: 12px;cursor:hand;color:black;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>";
                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][5]);
                            if(bInstalled){
                                oTr.cells[8].innerHTML="<img src='/images/plugin/status.gif' width=14 height=14 /><br><span style='color:red;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
			                    oTr.cells[10].innerHTML="<img src='/images/plugin/downloads.gif' width=12 height=12 align='absmiddle' /><a style='font-size: 12px;cursor:hand;color:black;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><br><span style='color:red;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22008,user.getLanguage())%>)</span></a>";
                            }
                        }
                        oTr = oTable.insertRow();
						oTd = oTr.insertCell();
                        oTd.colSpan = 11;
                        oTd.innerHTML="<img src='/images/plugin/line_0.gif'  height=1 >";
					}
                    document.all("oTd_0").innerHTML = allInstalled?"<img src='/images/plugin/status.gif' width=14 height=14 />":"<img src='/images/plugin/wrong.gif' width=14 height=14 />";
				}
                delete(xmlDoc);
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
						aProgID = aActiveXs[i][1].split(";");
						for (var j = 0; j < aProgID.length; j++)
						{
							if (!Detect(aProgID[j]))
							{
								bInstalled = false;
								break;
							}
						}
                        if(i>0)
						document.all("oTd_"+i).innerHTML = bInstalled?"<img src='/images/plugin/status.gif' width=14 height=14 />":"<img src='/images/plugin/wrong.gif' width=14 height=14 />";
                        if(i>0&&allInstalled&&!bInstalled&&aProgID!="JavaWebStart.isInstalled") allInstalled=false;
						document.all("oTd10_"+i).innerHTML = "<img src='/images/plugin/downloads.gif' width=12 height=12 align='absmiddle' /><a style='font-size: 12px;cursor:hand;color:black;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>";
                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][5]);
                            if(bInstalled){
                                document.all("oTd_"+i).innerHTML="<img src='/images/plugin/status.gif' width=14 height=14 /><br><span style='color:red;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
			                    document.all("oTd10_"+i).innerHTML="<img src='/images/plugin/downloads.gif' width=12 height=12 align='absmiddle' /><a style='font-size: 12px;cursor:hand;color:black;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><br><span style='color:red;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22008,user.getLanguage())%>)</span></a>";
                            }
                        }
					}
                    document.all("oTd_0").innerHTML = allInstalled?"<img src='/images/plugin/status.gif' width=14 height=14 />":"<img src='/images/plugin/wrong.gif' width=14 height=14 />";
				}
			}

            //改变登录检查
            function ChangeCheck(checkvalue){
                if(checkvalue){
                    document.all("Pluginfrm").src="/weaverplugin/PluginMaintenanceOperation.jsp?NoCheckPlugin=0";
                }else{
                    document.all("Pluginfrm").src="/weaverplugin/PluginMaintenanceOperation.jsp?NoCheckPlugin=1";
                }
            }
		</script>
</head>

<body>
<iframe  id="Pluginfrm" name="Pluginfrm" src="" frameborder="0" style="height:0px;"></iframe>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="1" colspan="3"></td>
</tr>
<tr>
	<td width="10"></td>
	<td valign="top">
		<TABLE border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="57759F">
		<tr>
		<td >

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
      <tr>
        <td height="64" background="/images/plugin/back.gif"><table width="231" height="24" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="35" height="24" rowspan="2" align="right" valign="middle"><img src="/images/plugin/icon_1.gif" width="24" height="24" align="absmiddle" /></td>
            <td width="196" height="22" valign="bottom"><span class="STYLE1"><span class="STYLE2">&nbsp;<%=SystemEnv.getHtmlLabelName(22005,user.getLanguage())%></span></span></td>
          </tr>
          <tr>
            <td height="2" valign="bottom">&nbsp;<img src="/images/plugin/line_1.gif" width="80" height="2" align="absmiddle" /></td>
          </tr>
        </table></td>
        </tr>
      <tr>
        <td height="21" align="center" valign="middle">
            <table id="tblActiveXList" width="100%" height="21" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="40" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></span></td>
            <td width="2" valign="middle" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="90" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="280" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="30" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="50" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="80" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22010,user.getLanguage())%></span></td>
          </tr>
          <tr>
              <td colspan="11"><img src='/images/plugin/line_0.gif'  height=1 ></td>
          </tr>
        </table></td>
        </tr>
      
      <tr>
        <td height="50" align="right" valign="middle"><img src="/images/plugin/hands.gif" width="18" height="12" align="absmiddle" /><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())%> <u><span class="STYLE5"><a href="#"  style="color:blue;" onclick="OnCheckPage('ActiveXTest.jsp',700,700)"><%=SystemEnv.getHtmlLabelName(22012,user.getLanguage())%></a></span></u> <%=SystemEnv.getHtmlLabelName(22013,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="50"><table width="231" height="29" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="35" height="29" align="right" valign="middle"><img src="/images/plugin/icon_2.gif" width="27" height="27" align="absmiddle" /></td>
            <td width="196" valign="middle"><span class="STYLE1"><span class="STYLE2">&nbsp;<%=SystemEnv.getHtmlLabelName(22014,user.getLanguage())%></span></span></td>
          </tr>

        </table></td>
      </tr>
      <tr>
        <td  align="center" valign="middle"><table width="580" height="15" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="40" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></span></td>
            <td width="2" valign="middle" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="90" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="280" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="30" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="50" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="80" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22010,user.getLanguage())%></span></td>
          </tr>
          <tr>
              <td colspan="11"><img src='/images/plugin/line_0.gif'  height=1 ></td>
          </tr>
		  <%
		   RTXConfig rtxConfig = new RTXConfig();
		   String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
		   if("ELINK".equals(RtxOrElinkType)){ 
		  %>
		  <tr>
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">1</span></td>
            <td align="left" valign="middle" colspan="2"><span class="STYLE4">OCS <%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></span></td>
            <td height="20" align="left" colspan="2"><span class="STYLE4">OCS <%=SystemEnv.getHtmlLabelName(22015,user.getLanguage())%></span></td>
            <td align="right"  colspan="2"><span class="STYLE4">7.78M </span></td>
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">6.1</span></td>
            <td align="center" valign="middle"><img src="/images/plugin/downloads.gif" width="12" height="12" align="absmiddle" ><a href="/resource/ChinaElink6.1.2.8.exe" style="font-size: 12px;cursor:hand;color:black;text-decoration:none;">&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a></td>
          </tr>
		  <%} else {%>
          <tr>
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">1</span></td>
            <td align="left" valign="middle" colspan="2"><span class="STYLE4">RTX <%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></span></td>
            <td height="20" align="left" colspan="2"><span class="STYLE4">RTX <%=SystemEnv.getHtmlLabelName(22015,user.getLanguage())%></span></td>
            <td align="right"  colspan="2"><span class="STYLE4">14.1M </span></td>
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">v2006</span></td>
            <td align="center" valign="middle"><img src="/images/plugin/downloads.gif" width="12" height="12" align="absmiddle" ><a href="/resource/RTX2006SP1Client.exe" style="font-size: 12px;cursor:hand;color:black;text-decoration:none;">&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a></td>
          </tr>
		  <%}%>
        </table></td>
      </tr>
      <tr>
        <td height="11"><img src="/images/plugin/line_0.gif" width="656" height="1" /></td>
      </tr>
      <tr>
        <td height="40" align="right" valign="middle"><span class="STYLE7"><%=SystemEnv.getHtmlLabelName(22016,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="22" align="right" valign="middle"><form id="form1" name="form1" method="post" action="">
          <label>
            <input type="checkbox" name="NoCheckPlugin" value="1" onclick="ChangeCheck(this.checked)" <%if(!NoCheck){%>checked<%}%> />
            <span class="STYLE4"><%=SystemEnv.getHtmlLabelName(22017,user.getLanguage())%></span></label>&nbsp;
        </form>
        </td>
      </tr>
      <tr>
        <td height="22" align="right" valign="middle"><span class="STYLE4"><%=SystemEnv.getHtmlLabelName(22018,user.getLanguage())%>&nbsp;<img src="/images/plugin/icon_3.gif" width="14" height="16" align="absmiddle"  title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>"/>&nbsp;</span></td>
      </tr>
    </table>

</td>
		</tr>
	</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<div style="DISPLAY:none">
    <OBJECT id="ChinaExcel" height="0" hspace="0" width="0" vspace="0"  classid="clsid:15261F9B-22CC-4692-9089-0C40ACBDFDD8"></OBJECT>
</div>
</body>
</html>
