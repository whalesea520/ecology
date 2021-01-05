
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
boolean NoCheck=false;
RecordSet.executeSql("select NoCheckPlugin from SysActivexCheck where NoCheckPlugin='1' and userid="+user.getUID());
if(RecordSet.next()) NoCheck=true;

String acceptlanguage = Util.null2String(request.getHeader("Accept-Language"));
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%=SystemEnv.getHtmlLabelName(22037,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22967,user.getLanguage())%></title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
.STYLE1 {
	display:block;
	vertical-align:middle;
	color: #000000;
	font-weight: bold;
	font-size: 13px;
}
.STYLE2 {font-size: 13px}
.STYLE3 {
	color: #646464;
	font-size: 12px;
}
.STYLE4 {font-size: 12px;color: #4f4f4f;}
.STYLE5 {
	color: #0000FF;
	font-weight: bold;
}
.STYLE7 {
display:block;
font-size: 12px; 
color: #e9950a;
width:220px;
height:58px;
text-align:center;
vertical-align:middle;
line-height:50px;
background:url("/images/plugin/bottom03_wev8.png");
}

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

//document.oncontextmenu = nocontextmenu;  // for IE5+
//document.onmousedown = norightclick;  // for all others
//-->
			// Array(控件名称, ProgID1;ProgID2;..., 安装文件地址, 文件大小, 说明)
			var aActiveXs = new Array();
			
			
			jQuery(document).ready(function(){
			
					insertActiveXRows(<%=user.getLanguage()%>);

				window.setInterval("refreshState()", 5000);
			
			})

			// 插入控件行，创建控件列表
			function insertActiveXRows(language)
			{
				//var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
				
				//xmlDoc.async = false;
				//xmlDoc.resolveExternals = false;
				
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
		        
		        var xmlDoc 
		        $.get(xmlUrl,function (data){
					if(typeof data == 'string'){
						var xmlData;
						if($.browser.msie){
							xmlData = new ActiveXObject("Microsoft.XMLDOM");
							xmlData.async = false;
							xmlData.loadXML(data);
					   }else{
						   xmlData = new DOMParser().parseFromString(data, "text/xml");
						}
						xmlDoc = $(xmlData);	
					}else{
						xmlDoc = $(data);	
					}
					
					var xmlGroupNodes = xmlDoc.find("group");
				
					var xmlActveXNodes;
					var sGroupID, sName, sProgIDs, sInstallURL, sSize, sExplain,version;
					
					for (var i = 0; i < xmlGroupNodes.length; i++){
							var xmlGroupNode=xmlGroupNodes[i];
							sName = $(xmlGroupNode).find("name").text();
							sGroupID = $(xmlGroupNode).attr("id");
							sProgIDs="";
							sInstallURL = $(xmlGroupNode).find("install").find("url").text();
							sSize = $(xmlGroupNode).find("install").find("size").text();
							sExplain = $(xmlGroupNode).find("explain").text();
							version = $(xmlGroupNode).find("version").text();
							
							xmlActveXNodes = xmlDoc.find("activex[groupid=" + sGroupID + "]");
							for (var j = 0; j < xmlActveXNodes.length; j++)
							{
								var xmlActveXNode = xmlActveXNodes[j];
								if (sProgIDs == "")
									sProgIDs = $(xmlActveXNode).find("progid").text();
								else
									sProgIDs += ";" +$(xmlActveXNode).find("progid").text();
							}
							
							aActiveXs[aActiveXs.length] = new Array(sName, sProgIDs, sInstallURL, sSize, sExplain,version);
							//alert(sInstallURL)
					}
					
					// 处理没有分组的控件
					xmlActveXNodes = xmlDoc.find("activex[groupid='']");
					//alert(xmlActveXNodes.length)
					for (var i = 0; i < xmlActveXNodes.length; i++)
					{
						var xmlActveXNode=xmlActveXNodes[i];
						sName = $(xmlActveXNode).find("name").text();
						sProgIDs = $(xmlActveXNode).find("progid").text();
						sInstallURL = $(xmlActveXNode).find("install").find("url").text();
						sSize = $(xmlActveXNode).find("install").find("size").text();
						sExplain =$(xmlActveXNode).find("explain").text();
                        version =$(xmlActveXNode).find("version").text();
						aActiveXs[aActiveXs.length] = new Array(sName, sProgIDs, sInstallURL, sSize, sExplain,version);
					}
					
					
					
					// 插入行
					var oTable, oTr, oTd;
					var aProgID, acheckver, bInstalled;
					var allInstalled=true;
					oTable = document.getElementById("tblActiveXList");
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

						oTr = oTable.insertRow(-1);
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
						oTd.innerHTML = bInstalled?"<img src='/images/plugin/hook_wev8.png' width=18 height=18 />":"<img src='/images/plugin/cha_wev8.png' width=18 height=18 />";
                        if(i>0&&allInstalled&&!bInstalled&&aProgID!="JavaWebStart.isInstalled") allInstalled=false;
                        oTd = oTr.insertCell(9);
                        oTd.width=2;
						oTd.innerHTML ="";
						oTd = oTr.insertCell(10);
                        oTd.width=80;
						oTd.align = "center";
                        oTd.id="oTd10_"+i;
						oTd.innerHTML = "<a style='font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>";
                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][5]);
                            if(bInstalled){
                                oTr.cells[8].innerHTML="<img src='/images/plugin/hook_wev8.png' width=18 height=18 /><br><span style='color:#a2a2a2;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
			                    oTr.cells[10].innerHTML="<a style='font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><br><span style='color:#ff9a31;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22008,user.getLanguage())%>)</span></a>";
                            }
                        }
                        oTr = oTable.insertRow(-1);
						oTd = oTr.insertCell(-1);
                        oTd.colSpan = 11;
                        oTd.innerHTML="<img src='/images/plugin/line_0_wev8.gif' width=100%  height=1 >";
					}
					
					document.getElementById("oTd_0").innerHTML = allInstalled?"<img src='/images/plugin/hook_wev8.png' width=18 height=18 />":"<img src='/images/plugin/cha_wev8.png' width=18 height=18 />";
					
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
					oTable = document.getElementById("tblActiveXList");
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
						document.getElementById("oTd_"+i).innerHTML = bInstalled?"<img src='/images/plugin/hook_wev8.png' width=18 height=18 />":"<img src='/images/plugin/cha_wev8.png' width=18 height=18 />";
                        if(i>0&&allInstalled&&!bInstalled&&aProgID!="JavaWebStart.isInstalled") allInstalled=false;
						document.getElementById("oTd10_"+i).innerHTML = "<a style='font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>";
                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][5]);
                            if(bInstalled){
                                document.getElementById("oTd_"+i).innerHTML="<img src='/images/plugin/hook_wev8.png' width=18 height=18 /><br><span style='color:#a2a2a2;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
			                    document.getElementById("oTd10_"+i).innerHTML="<a style='font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;' href='" + aActiveXs[i][2] + "'>&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><br><span style='color:#ff9a31;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22008,user.getLanguage())%>)</span></a>";
                            }
                        }
					}
                    document.getElementById("oTd_0").innerHTML = allInstalled?"<img src='/images/plugin/hook_wev8.png' width=18 height=18 />":"<img src='/images/plugin/cha_wev8.png' width=18 height=18 />";
				}
			}

            //改变登录检查
            function ChangeCheck(checkvalue){
            	var NoCheckPlugin="";
                if(checkvalue){
                    NoCheckPlugin="0";
                }else{
                     NoCheckPlugin="1";
                }
                $.post("/weaverplugin/PluginMaintenanceOperation.jsp?NoCheckPlugin="+NoCheckPlugin);
            }
		</script>
</head>

<body>
<table style="width:100%;height:100%;"  >
      <tr>
        <td height="40" background="/images/plugin/back_wev8.gif">
        <table width="100%" height="32" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="40" height="32" rowspan="2" align="right" valign="middle"><img src="/images/plugin/control_wev8.png" width="32" height="32" align="absmiddle" /></td>
            <td height="32" ><span class="STYLE1"><span class="STYLE2">&nbsp;<%=SystemEnv.getHtmlLabelName(22005,user.getLanguage())%></span></span></td>
          </tr>
        </table>
        </td>
      </tr>
      <tr>
        <td height="40" align="center" valign="middle">
            <table id="tblActiveXList" width="100%"  style="border-collapse:collapse;border:1px solid #40ABF6;border-bottom:none;border-left:none;border-right:none;" cellpadding="0" cellspacing="0">
          <tr style="border:1px  solid #e7e7e7;border-left:none;border-right:none;border-top:none;">
            <td height="60" width="40" align="center" valign="middle" ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></span></td>
            <td width="2" valign="middle" ><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="90" align="center" valign="middle" ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" ><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="280" align="center" valign="middle" ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></span></td>
            <td width="2" ><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="30" align="center" valign="middle" ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></span></td>
            <td width="2" ><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="50" align="center" valign="middle" ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></span></td>
            <td width="2" ><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="80" align="center" valign="middle" ><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22010,user.getLanguage())%></span></td>
          </tr>
        </table></td>
        </tr>

      <tr>
        <td height="50">
        <table width="231" height="32" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="40" height="32" align="right" valign="middle"><img src="/images/plugin/controlother_wev8.png" width="32" height="32" align="absmiddle"/></td>
            <td align="left" valign="middle"><span class="STYLE1"><span class="STYLE2">&nbsp;<%=SystemEnv.getHtmlLabelName(22014,user.getLanguage())%></span></span></td>
          </tr>

        </table></td>
      </tr>
      
      <tr>
        <td  align="center" height="50" valign="middle" style="border-collapse:collapse;border:1px solid #40ABF6;border-bottom:none;border-left:none;border-right:none;">
        <table width="100%"  height="100%" style="border-collapse:collapse;border:0px;" cellpadding="0" cellspacing="0">
          <tr style="border:1px  solid #e7e7e7;border-left:none;border-right:none;border-top:none;height:40px;">
            <td width="50" align="center" valign="middle" bgcolor=#f3f3f3><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></span></td>
            <td width="2" valign="middle" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="90" align="center" valign="middle" bgcolor=#f3f3f3><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="280" align="center" valign="middle" bgcolor=#f3f3f3><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="30" align="center" valign="middle" bgcolor=#f3f3f3><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="50" align="center" valign="middle" bgcolor=#f3f3f3><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></span></td>
            <td width="2" bgcolor=#f3f3f3><img src="/images/plugin/line_2_wev8.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="80" align="center" valign="middle" bgcolor=#f3f3f3><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22010,user.getLanguage())%></span></td>
          </tr>

		  <%
		   RTXConfig rtxConfig = new RTXConfig();
		    String isDownload = rtxConfig.getPorp(RTXConfig.RTX_ISDownload);
		   String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
		   int i=1;
		   if("ELINK".equals(RtxOrElinkType)&&isDownload.equals("1")){ 
			   i++;
		  %>
		  <tr style="height:50px;">
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">1</span></td>
            <td align="left" valign="middle" colspan="2"><span class="STYLE4">OCS <%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></span></td>
            <td height="20" align="left" colspan="2"><span class="STYLE4">OCS <%=SystemEnv.getHtmlLabelName(22015,user.getLanguage())%></span></td>
            <td align="right"  colspan="2"><span class="STYLE4">28.7M </span></td>
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">7.4.1.239</span></td>
            <td align="center" valign="middle"><a href="/resource/OCS2013V7.4.1.239.exe" style="font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;">&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a></td>
          </tr>
		  <%} else if("RTX".equals(RtxOrElinkType)&&isDownload.equals("1")) {
		  i++;%>
          <tr style="height:50px;">
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">1</span></td>
            <td align="left" valign="middle" colspan="2"><span class="STYLE4">RTX <%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></span></td>
            <td height="20" align="left" colspan="2"><span class="STYLE4">RTX <%=SystemEnv.getHtmlLabelName(22015,user.getLanguage())%></span></td>
            <td align="right"  colspan="2"><span class="STYLE4">23.7M </span></td>
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">v2013</span></td>
            <td align="center" valign="middle"><a href="/resource/rtxclient2013formal.exe" style="font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;">&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a></td>
          </tr>
		  <%}%>
		  <%
		  String sql = "select * from ldapset";
		  RecordSet.executeSql(sql);
		  if(RecordSet.next()){
		   if("1".equals(Util.null2String(RecordSet.getString("isuseldap"))) && !"".equals(Util.null2String(RecordSet.getString("ldaplogin")))){ 
		  %>
		  <tr style="height:50px;">
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4"><%=i%></span></td>
            <td align="left" valign="middle" colspan="2"><span class="STYLE4">nlsetup</span></td>
            <td height="20" align="left" colspan="2"><span class="STYLE4"><%=SystemEnv.getHtmlLabelName(125407,user.getLanguage())%></span></td>
            <td align="right"  colspan="2"><span class="STYLE4">91K </span></td>
            <td  align="center" valign="middle" colspan="2"><span class="STYLE4">1.0</span></td>
            <td align="center" valign="middle"><a href="/resource/nlsetup.exe" style="font-size: 12px;cursor:hand;color:#007adc;text-decoration:none;">&nbsp;<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a></td>
          </tr>		   
          <%}}%>
        </table></td>
      </tr>

      <tr>
        <td height="23px" align="left" valign="middle"><form id="form1" name="form1" method="post" action="">
          <span style="display:block;float:left;height:23px;">&nbsp;&nbsp;&nbsp;
            <input type="checkbox" style="vertical-align:middle;" name="NoCheckPlugin" value="1" onclick="ChangeCheck(this.checked)" <%if(!NoCheck){%>checked<%}%> />
          </span>
          <span style="display:block;float:left;height:23px;line-height:23px;font-size:12px;">
            <%=SystemEnv.getHtmlLabelName(22017,user.getLanguage())%>
          </span>
        </form>
        </td>
      </tr>
      
      <tr>
        <td height="32" align="right" valign="middle"><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22013,user.getLanguage())%></span><button style="width:32px;height:32px;background:#FFFFFF;" onclick="OnCheckPage('ActiveXTest.jsp',730,600)"><img src="/images/plugin/detail01_wev8.png" width="32px" height="32px"/></button>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      </tr>
      
       <tr>
        <td align="right" valign="middle"><span class="STYLE7"><%=SystemEnv.getHtmlLabelName(22016,user.getLanguage())%></span></td>
      </tr>
    </table>

<div style="DISPLAY:none">
    <OBJECT id="ChinaExcel" height="0" hspace="0" width="0" vspace="0"  classid="clsid:15261F9B-22CC-4692-9089-0C40ACBDFDD8"></OBJECT>
</div>
</body>
</html>
