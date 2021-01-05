
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>


<%

int userid=user.getUID();

String name=Util.null2String(request.getParameter("name")).trim();
String typeid=Util.null2String(request.getParameter("typeid"));
String creater=Util.null2String(request.getParameter("creater"));
String status=Util.null2String(request.getParameter("status"));
String jointype=Util.null2String(request.getParameter("jointype"));
String coworker=Util.null2String(request.getParameter("coworker"));
String startdate=Util.null2String(request.getParameter("startdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String coworkmanager=Util.null2String(request.getParameter("coworkmanager"));

int curcustid=Util.getIntValue(request.getParameter("id"),0);
/**  ==========TD10542 取数据处理移到SearchCoworkLResultInit.jsp============= */
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!-- TD10542 协作区查询优化 开始 -->
<script language="javascript">
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showCoworkResult(){
    var ajax=ajaxinit();
    //中文字符处理
    var name = escape('<%=name%>');
    ajax.open("POST", "SearchCoworkResultInit.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("name="+ name + "&typeid=<%=typeid%>&creater=<%=creater%>&status=<%=status%>&jointype=<%=jointype%>&coworker=<%=coworker%>&startdate=<%=startdate%>&enddate=<%=enddate%>&coworkmanager=<%=coworkmanager%>&id=<%=curcustid%>");

    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("divCoworkResult").innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>
<!-- TD10542 协作区查询优化 结束 -->
</HEAD>
<BODY >
<TABLE ID=BrowseTable class=ListStyle cellspacing=1>
<TBODY>

<COLGROUP>
<COL width=2px>
<COL width="55%">
<COL width="15%">
<COL width="25%">

<TR class=Header>
    <TH></TH>
    <TH><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TH>
</TR>
<TR class=Line><TH colspan="4" ></TH></TR>
<!-- ==========TD10542 表格生成处理移到SearchCoworkREsultInit.jsp============= -->
</TABLE>
<!-- TD10542 数据显示层 -->
<div id="divCoworkResult"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
  <script>
  setTimeout(function()
  {
      showCoworkResult();
  },300)
  </script>
</div>

<script language="javascript">
curcustid = <%=curcustid%>
function browseTable_onclick(){
    var id;
    var e = window.event.srcElement;
    e.style.fontWeight ="normal";
    if(e.tagName == "TD"){
        id = e.parentElement.cells(0).innerText;
        var thetr = document.all("thetr");
        for(var i=0;i<thetr.length;i++){
            thetr[i].style.backgroundColor = "";
        }
        e.parentElement.style.backgroundColor = "#d6d3ce";
    }
    else if(e.tagName == "A"){
        id = e.parentElement.parentElement.cells(0).innerText;
        var thetr = document.all("thetr");
        for(var i=0;i<thetr.length;i++){
            thetr[i].style.backgroundColor = "";
        }
        e.parentElement.parentElement.style.backgroundColor = "#d6d3ce";
    }
    curcustid = id;
    window.parent.frames("frameRight").frames("HomePageIframe2").location="ViewCoWork.jsp?id="+curcustid+"&view=yes";
}

function browseTable_onmouseover(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"){
        e.parentElement.className = "Selected";
    }
    else if(e.tagName == "A"){
        e.parentElement.parentElement.className = "Selected";
    }
}
function browseTable_onmouseout(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"||e.tagName == "A"){
        var p;
        if(e.tagName == "TD"){
            p = e.parentElement;
        }
        else{
            p = e.parentElement.parentElement;
        }
        if(p.rowIndex%2==0){
            p.className = "DataLight";
        }
        else{
            p.className = "DataDark";
        }
    }
}
function actionit(id){
    var XML="<root><id>"+id+"</id><userid><%=userid%></userid></root>"
    var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    var xmlDoc=new ActiveXObject("MSXML.DomDocument");
    xmlHttp.open("post","/cowork/CoworkXMLHTTP.jsp",false);
    xmlHttp.setRequestHeader("context-type","text/xml;charset=utf-8");
    xmlHttp.send(XML);
    var showstr=xmlHttp.responseText;
    var ob= document.getElementById("Img_"+id);
    var ob2 = document.getElementById("Td_"+id);
    if(xmlHttp.readyState == 4){
        // only if "OK"
        if (xmlHttp.status == 200) {
        // ...processing statements go here...
            if(showstr && ob.src.match("notimportent_wev8.gif")){
                ob.src="/cowork/images/importent_wev8.gif";
                ob2.title = "<%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%>";
            }else if(showstr && ob.src.match("importent_wev8.gif")){
                ob.src="/cowork/images/notimportent_wev8.gif";
                ob2.title = "<%=SystemEnv.getHtmlLabelName(19780,user.getLanguage())%>";
            }
        } else {
        alert("There was a problem retrieving the XML data:\n" + req.statusText);
        }
    }
}
</script>

</body>
</html>
