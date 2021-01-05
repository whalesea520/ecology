
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="subcompany" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<body style="margin: 0px;">  
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

int subcompanyId = Util.getIntValue(request.getParameter("id"));
String subcompanyName = subcompany.getSubCompanyname(""+subcompanyId);
double albumSize=0,albumSizeUsed=0.0,albumSizeFree=0.0;
double albumSizePercent=0.00;
String strAlbumSize = "0";
String _albumSizeUsed = "0.00";
String _albumSizePercent = "0.00";
if(subcompanyId>0){
	rs.executeSql("SELECT * FROM AlbumSubcompany WHERE subcompanyId="+subcompanyId+"");
	if(rs.next()){
		_albumSizeUsed = Util.null2String(rs.getString("albumSizeUsed"));
		albumSize = Double.parseDouble(rs.getString("albumSize"))/1000;
		strAlbumSize = String.valueOf(albumSize);
		strAlbumSize = strAlbumSize.substring(0,strAlbumSize.indexOf("."));
		albumSizeUsed = _albumSizeUsed.equals("") ? 0.00 : Double.parseDouble(rs.getString("albumSizeUsed"))/1000;
		albumSizeFree = albumSize-albumSizeUsed;
		albumSizePercent = (albumSize>0?( Double.parseDouble(String.valueOf(albumSizeUsed))/Double.parseDouble(String.valueOf(albumSize))*100):0);
		_albumSizePercent = Util.round(String.valueOf(albumSizePercent), 2);
	}
%>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<table class="ViewForm">
<colgroup>
<col width="20%">
<col width="80%">
</colgroup>
<tbody>
<!-- <tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
</tr> -->
<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(20003,user.getLanguage())%></td>
	<td class="Field"><%=subcompanyName%></td>
</tr>
<tr style="height:2px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(20004,user.getLanguage())%>(MB)</td>
	<td class="Field">
		<span id="albumSize"><%=strAlbumSize%></span>
		<%if(user.getUID()==1){%>
		<button type="button" id="btnEdit" class="btnEdit" style="" accesskey="E" onclick="editAlbumSize()"><u>E</u>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></button>
		<button type="button" id="btnSave" class="btnSave" style="display:none" accesskey="S" onclick="saveAlbumSize()"><u>S</u>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
		<button type="button" id="btnCancel" class="btnDelete" style="display:none" accesskey="C" onclick="cancelAlbumSize()"><u>C</u>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
		<%}%>
	</td>
</tr>
<tr style="height:2px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(20005,user.getLanguage())%>(MB)</td>
	<td class="Field"><%=Util.round(String.valueOf(albumSizeUsed),3)%></td>
</tr>
<tr style="height:2px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(20006,user.getLanguage())%>(MB)</td>
	<td class="Field"><%=Util.round(String.valueOf(albumSizeFree),3)%></td>
</tr>
<tr style="height:2px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(20007,user.getLanguage())%></td>
	<td class="Field">
		<%=_albumSizePercent%>%
		<table style="width:300px;border:1px solid #000;height:14px;border-collapse:collapse;margin-top:3px">
		<tr>
			<td style="background-image:url(/images/percentBarGreen_wev8.gif)" width="<%=albumSizePercent%>%"></td>
			<td style="background-color:#FFF" width="<%=100-albumSizePercent%>%"></td>
		</tr>
		</table>
	</td>
</tr>
<tr style="height:2px"><td class="Line" colspan="2"></td></tr>
</tbody>
</table>

<script type="text/javascript">
var asize=<%=strAlbumSize%>;

function editAlbumSize(){
	
	$("albumSize").innerHTML = "<input type='text' id='txtAlbumSize' maxlength='5' class='inputstyle' value='"+asize+"' onkeypress='ItemCount_KeyPress()'/>";
	toggleButton("none","inline","inline");
}
function saveAlbumSize(){
	var albumSize = $("txtAlbumSize").value;
	if(albumSize==""){
		alert("<%=SystemEnv.getHtmlLabelName(20000,user.getLanguage())%>");
		$("txtAlbumSize").focus();
		return false;
	}
	asize=albumSize;
	if(albumSize>=<%=albumSizeUsed%>){
		location.href = "PhotoOperation.jsp?operation=updateAlbumSize&id=<%=subcompanyId%>&albumSize="+albumSize+"";
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(20000,user.getLanguage())%>");
		$("txtAlbumSize").focus();
		return false;
	}
}
function cancelAlbumSize(){
	$("albumSize").innerHTML = "<%=strAlbumSize%>";
	toggleButton("inline","none","none");	
}
function toggleButton(){
	$("btnEdit").style.display = arguments[0];
	$("btnSave").style.display = arguments[1];
	$("btnCancel").style.display = arguments[2];
}
</script>
<%}%>
</body>