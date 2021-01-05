<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.JSONObject" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page" />
<jsp:useBean id="CptCardGroupComInfo" class="weaver.cpt.util.CptCardGroupComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("Cpt:LabelPrint", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String operation = Util.null2String(request.getParameter("operation"));


    if (request.getParameter("defcol")!=null) {
        int defcol = Util.getIntValue(request.getParameter("defcol"), -1);
        int defrow = Util.getIntValue(request.getParameter("defrow"), -1);
        int cols = Util.getIntValue(request.getParameter("col"), -1);
        int rows = Util.getIntValue(request.getParameter("row"), -1);
        String forcepages = Util.null2String(request.getParameter("forcepage"));

        if (defcol>8 && cols==-1) {
            cols=defcol;
        }
        if (defrow>5 && rows==-1) {
            rows=defrow;
        }
        if (cols==-1) {
            cols=1;
        }
        if (rows==-1) {
            rows=1;
        }

        rs.executeSql("update CPT_PRINT_SET set forcepage='"+forcepages+"',col='"+cols+"',row1='"+rows+"' where id=-1");
    }


%>
<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>

<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
var parentWin = parent.parent.getParentWindow(parent);
if("<%=isclose%>"=="1"){
    try{
        parentWin.location.href=parentWin.location.href;
        parentWin.closeDialog();
    }catch(e){}

}
</script>
</head>
<%



    int id = -1;
	int subcompanyid = -1;
    String forcepage="";
    int row=1;
    int col=1;
    rs.executeSql("select * from CPT_PRINT_SET where id=-1");
    if (rs.next()){
        forcepage=rs.getString("forcepage");
        row=rs.getInt("row1");
        col=rs.getInt("col");
    }
    if (row<1){row=1;}
    if (col<1){col=1;}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content" style="overflow:hidden;">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" />
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id=weaver name=weaver action="printset.jsp" method=post >

<input type=hidden name=id value="<%=id%>" id="id" />
<input type="hidden" name="isdialog" value="<%=isDialog%>" />
<input type="hidden" name="isclose" id="isclose" value="<%=isclose%>" />

    <wea:layout type="2col">
        <wea:group context='<%=SystemEnv.getHtmlLabelNames("19407",user.getLanguage())%>'>
            <wea:item><%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%></wea:item>
            <wea:item>
                <input type="radio" name="col" value="1" <%=col==1?"checked":"" %>  />1
                <input type="radio" name="col" value="2" <%=col==2?"checked":"" %>  />2
                <input type="radio" name="col" value="3" <%=col==3?"checked":"" %>  />3
                <input type="radio" name="col" value="4" <%=col==4?"checked":"" %>  />4
                <input type="radio" name="col" value="5" <%=col==5?"checked":"" %>  />5
                <input type="radio" name="col" value="6" <%=col==6?"checked":"" %>  />6
                <input type="radio" name="col" value="7" <%=col==7?"checked":"" %>  />7
                <input type="radio" name="col" value="8" <%=col==8?"checked":"" %>  />8
                <input type="radio" name="col" value="-1" <%=col>8?"checked":"" %>  />自定义 <input class="InputStyle" style="width: 40px;" type="text" value="<%=col>8?""+col:"" %>"  name="defcol" id="defcol" maxlength="3" size="3" onkeypress="ItemCount_KeyPress();" />

            </wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(126639,user.getLanguage())%></wea:item>
            <wea:item>
                <input type="radio" name="row" value="1" <%=row==1?"checked":"" %>  />1
                <input type="radio" name="row" value="2" <%=row==2?"checked":"" %>  />2
                <input type="radio" name="row" value="3" <%=row==3?"checked":"" %>  />3
                <input type="radio" name="row" value="4" <%=row==4?"checked":"" %>  />4
                <input type="radio" name="row" value="5" <%=row==5?"checked":"" %>  />5
                <input type="radio" name="row" value="-1" <%=row>5?"checked":"" %>  />自定义 <input class="InputStyle" style="width: 40px;" type="text" value="<%=row>5?""+row:"" %>"  name="defrow" id="defrow" maxlength="3" size="3" onkeypress="ItemCount_KeyPress();" />
            </wea:item>

            <wea:item><%=SystemEnv.getHtmlLabelName(126640,user.getLanguage())%></wea:item>
            <wea:item>
                <input type="checkbox" name="forcepage" id="forcepage" value="1" <%="1".equals(forcepage)?"checked":"" %> />
            </wea:item>
        </wea:group>
    </wea:layout>


</form>
<script type="text/javascript">

function onSave(){
	if(check_form(document.weaver,'')){
        document.getElementById("isclose").value=1;
		document.weaver.submit();
	}
}


</script>
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
        <wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
            <wea:item type="toolbar">
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
            </wea:item>
        </wea:group>
    </wea:layout>
</div>
<script type="text/javascript">
    jQuery(document).ready(function(){
        resizeDialog(document);
    });
</script>
<%} %>
</body>