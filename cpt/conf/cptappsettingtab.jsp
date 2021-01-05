<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int userid=user.getUID();
if(!HrmUserVarify.checkUserRight("Cpt:AppSettings", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
  
%>
<%
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
    
    RecordSet.executeSql("select * from cpt_barcodesettings where id=-1");
    RecordSet.next();
    
    String isopen=Util.null2String(RecordSet.getString("isopen"));
    String isopen2=Util.null2String(RecordSet.getString("isopen2"));
    String content2type=Util.null2String(RecordSet.getString("content2type"));
    String link2=Util.null2String(RecordSet.getString("link2"));
    String content2=Util.null2String(RecordSet.getString("content2"));
    String barType=Util.null2String(RecordSet.getString("barType"));
    String barType2=Util.null2String(RecordSet.getString("barType2"));
    String code=Util.null2String(RecordSet.getString("code"));
    String width=Util.null2String(RecordSet.getString("width"));
    String width2=Util.null2String(RecordSet.getString("width2"));
    String height=Util.null2String(RecordSet.getString("height"));
    String height2=Util.null2String(RecordSet.getString("height2"));
    String st=Util.null2String(RecordSet.getString("st"));
    String st2=Util.null2String(RecordSet.getString("st2"));
    String textFont=Util.null2String(RecordSet.getString("textFont"));
    String textFont2=Util.null2String(RecordSet.getString("textFont2"));
    String fontColor=Util.null2String(RecordSet.getString("fontColor"));
    String barColor=Util.null2String(RecordSet.getString("barColor"));
    String backColor=Util.null2String(RecordSet.getString("backColor"));
    String rotate=Util.null2String(RecordSet.getString("rotate"));
    String barHeightCM=Util.null2String(RecordSet.getString("barHeightCM"));
    String x=Util.null2String(RecordSet.getString("x"));
    String n=Util.null2String(RecordSet.getString("n"));
    String leftMarginCM=Util.null2String(RecordSet.getString("leftMarginCM"));
    String topMarginCM=Util.null2String(RecordSet.getString("topMarginCM"));
    String checkCharacter=Util.null2String(RecordSet.getString("checkCharacter"));
    String checkCharacterInText=Util.null2String(RecordSet.getString("checkCharacterInText"));
    String Code128Set=Util.null2String(RecordSet.getString("Code128Set"));
    String UPCESytem=Util.null2String(RecordSet.getString("UPCESytem"));

    
	String title="";

    String[] tooltip=new String[30];
    tooltip[0]=SystemEnv.getHtmlLabelName(128246,user.getLanguage());
    tooltip[1]=SystemEnv.getHtmlLabelName(128247,user.getLanguage());
    tooltip[2]=SystemEnv.getHtmlLabelName(128247,user.getLanguage());
    tooltip[3]=SystemEnv.getHtmlLabelName(128248,user.getLanguage());
    tooltip[4]=SystemEnv.getHtmlLabelName(128249,user.getLanguage());
    tooltip[5]="";
    tooltip[6]="";
    tooltip[7]="";
    tooltip[8]="";
    tooltip[9]=SystemEnv.getHtmlLabelName(128250,user.getLanguage());
    tooltip[10]=SystemEnv.getHtmlLabelName(128251,user.getLanguage());
    tooltip[11]=SystemEnv.getHtmlLabelName(128252,user.getLanguage());
    tooltip[12]=SystemEnv.getHtmlLabelName(128253,user.getLanguage());
    tooltip[13]=SystemEnv.getHtmlLabelName(128254,user.getLanguage());
    tooltip[14]=SystemEnv.getHtmlLabelName(128255,user.getLanguage());
    tooltip[15]=SystemEnv.getHtmlLabelName(128255,user.getLanguage());
    tooltip[16]=SystemEnv.getHtmlLabelName(128256,user.getLanguage());
    tooltip[17]=SystemEnv.getHtmlLabelName(128257,user.getLanguage());

    tooltip[18]=SystemEnv.getHtmlLabelName(128258,user.getLanguage());
    tooltip[19]=SystemEnv.getHtmlLabelName(128259,user.getLanguage());
    tooltip[20]=SystemEnv.getHtmlLabelName(128259,user.getLanguage());
    tooltip[21]=SystemEnv.getHtmlLabelName(128260,user.getLanguage());
    tooltip[22]=SystemEnv.getHtmlLabelName(128261,user.getLanguage());
    tooltip[23]=SystemEnv.getHtmlLabelName(128262,user.getLanguage());
    tooltip[24]="";
    tooltip[25]="";
    
%>
<HTML>
<HEAD>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
    <style type="text/css">
        .InputStyle{width:40%!important;}
        .inputstyle{width:40%!important;}
        .Inputstyle{width:40%!important;}
        .inputStyle{width:40%!important;}
        .e8_os{width:30%!important;}
        select.InputStyle{width:10%!important;}
        select.inputstyle{width:10%!important;}
        select.inputStyle{width:10%!important;}
        select.Inputstyle{width:10%!important;}
        textarea.InputStyle{width:70%!important;}
    </style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=weaver name=weaver action="cptappsettingop.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="submitData()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		
<div class="advancedSearchDiv" id="advancedSearchDiv" >
</div>
<wea:layout type="2col">

	<wea:group context='<%=SystemEnv.getHtmlLabelNames("126575,1362,68",user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
		<wea:item><%=SystemEnv.getHtmlLabelNames("18095",user.getLanguage()) %></wea:item>
		<wea:item><input type="checkbox" tzCheckbox="true" name='isopen' value='1' <%="1".equals(isopen)?"checked":"" %> onclick='onchangeacc(this)' /></wea:item>


        <%--码制--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126408,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <select name="barType" id="barType">
                <option value="CODE39" <%="CODE39".equals(barType)?"selected":"" %> >CODE39</option>
                <option value="CODE39EXT" <%="CODE39EXT".equals(barType)?"selected":"" %> >CODE39EXT</option>
                <option value="INTERLEAVED25" <%="INTERLEAVED25".equals(barType)?"selected":"" %> >INTERLEAVED25</option>
                <option value="CODE11" <%="CODE11".equals(barType)?"selected":"" %> >CODE11</option>
                <option value="CODABAR" <%="CODABAR".equals(barType)?"selected":"" %> >CODABAR</option>
                <option value="MSI" <%="MSI".equals(barType)?"selected":"" %> >MSI</option>
                <option value="UPCA" <%="UPCA".equals(barType)?"selected":"" %> >UPCA</option>
                <option value="IND25" <%="IND25".equals(barType)?"selected":"" %> >IND25</option>
                <option value="MAT25" <%="MAT25".equals(barType)?"selected":"" %> >MAT25</option>
                <option value="CODE93" <%="CODE93".equals(barType)?"selected":"" %> >CODE93</option>
                <option value="EAN13" <%="EAN13".equals(barType)?"selected":"" %> >EAN13</option>
                <option value="EAN8" <%="EAN8".equals(barType)?"selected":"" %> >EAN8</option>
                <option value="UPCE" <%="UPCE".equals(barType)?"selected":"" %> >UPCE</option>
                <option value="CODE128" <%="CODE128".equals(barType)?"selected":"" %> >CODE128</option>
                <option value="CODE93EXT" <%="CODE93EXT".equals(barType)?"selected":"" %> >CODE93EXT</option>
                <option value="POSTNET" <%="POSTNET".equals(barType)?"selected":"" %> >POSTNET</option>
                <option value="PLANET" <%="PLANET".equals(barType)?"selected":"" %> >PLANET</option>
                <option value="UCC128" <%="UCC128".equals(barType)?"selected":"" %> >UCC128</option>

            </select>
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[0] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>


        <%--图片宽度--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="width" id="width" value="<%=width %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[1] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--图片高度--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="height" id="height" value="<%=height %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[2] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--是否显示条码内容--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126409,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="checkbox" name="st" id="st" value="y"  <%="y".equals(st)?"checked":"" %> />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[3] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--条码文本的字体--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126410,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="textFont" id="textFont" value="<%=textFont %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[4] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--条码文本的颜色--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126411,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <select name="fontColor" id="fontColor">
                <option value="RED" <%="RED".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126615,user.getLanguage()) %></option>
                <option value="BLUE" <%="BLUE".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126616,user.getLanguage()) %></option>
                <option value="GREEN" <%="GREEN".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126617,user.getLanguage()) %></option>
                <option value="BLACK" <%="BLACK".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126618,user.getLanguage()) %></option>
                <option value="GRAY" <%="GRAY".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126619,user.getLanguage()) %></option>
                <option value="LIGHTGRAY" <%="LIGHTGRAY".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126620,user.getLanguage()) %></option>
                <option value="WHITE" <%="WHITE".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126621,user.getLanguage()) %></option>
                <option value="DARKGRAY" <%="DARKGRAY".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126622,user.getLanguage()) %></option>
                <option value="YELLOW" <%="YELLOW".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126623,user.getLanguage()) %></option>
                <option value="ORANGE" <%="ORANGE".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126624,user.getLanguage()) %></option>
                <option value="CYAN" <%="CYAN".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126625,user.getLanguage()) %></option>
                <option value="MAGENTA" <%="MAGENTA".equals(fontColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126626,user.getLanguage()) %></option>
            </select>
        </wea:item>

        <%--条码的颜色--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126412,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <select name="barColor" id="barColor">
                <option value="RED" <%="RED".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126615,user.getLanguage()) %></option>
                <option value="BLUE" <%="BLUE".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126616,user.getLanguage()) %></option>
                <option value="GREEN" <%="GREEN".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126617,user.getLanguage()) %></option>
                <option value="BLACK" <%="BLACK".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126618,user.getLanguage()) %></option>
                <option value="GRAY" <%="GRAY".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126619,user.getLanguage()) %></option>
                <option value="LIGHTGRAY" <%="LIGHTGRAY".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126620,user.getLanguage()) %></option>
                <option value="WHITE" <%="WHITE".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126621,user.getLanguage()) %></option>
                <option value="DARKGRAY" <%="DARKGRAY".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126622,user.getLanguage()) %></option>
                <option value="YELLOW" <%="YELLOW".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126623,user.getLanguage()) %></option>
                <option value="ORANGE" <%="ORANGE".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126624,user.getLanguage()) %></option>
                <option value="CYAN" <%="CYAN".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126625,user.getLanguage()) %></option>
                <option value="MAGENTA" <%="MAGENTA".equals(barColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126626,user.getLanguage()) %></option>
            </select>
        </wea:item>

        <%--图片背景颜色--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126413,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <select name="backColor" id="backColor">
                <option value="RED" <%="RED".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126615,user.getLanguage()) %></option>
                <option value="BLUE" <%="BLUE".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126616,user.getLanguage()) %></option>
                <option value="GREEN" <%="GREEN".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126617,user.getLanguage()) %></option>
                <option value="BLACK" <%="BLACK".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126618,user.getLanguage()) %></option>
                <option value="GRAY" <%="GRAY".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126619,user.getLanguage()) %></option>
                <option value="LIGHTGRAY" <%="LIGHTGRAY".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126620,user.getLanguage()) %></option>
                <option value="WHITE" <%="WHITE".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126621,user.getLanguage()) %></option>
                <option value="DARKGRAY" <%="DARKGRAY".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126622,user.getLanguage()) %></option>
                <option value="YELLOW" <%="YELLOW".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126623,user.getLanguage()) %></option>
                <option value="ORANGE" <%="ORANGE".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126624,user.getLanguage()) %></option>
                <option value="CYAN" <%="CYAN".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126625,user.getLanguage()) %></option>
                <option value="MAGENTA" <%="MAGENTA".equals(backColor)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126626,user.getLanguage()) %></option>
            </select>
        </wea:item>

        <%--条码旋转角度--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126414,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <select name="rotate" id="rotate">
                <option value="0" <%="0".equals(rotate)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126424,user.getLanguage()) %></option>
                <option value="90" <%="90".equals(rotate)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126425,user.getLanguage()) %></option>
                <option value="180" <%="180".equals(rotate)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126426,user.getLanguage()) %></option>
                <option value="270" <%="270".equals(rotate)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(126427,user.getLanguage()) %></option>
            </select>
        </wea:item>

        <%--条码的高度--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126415,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="barHeightCM" id="barHeightCM" value="<%=barHeightCM %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[9] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--标称尺寸--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126416,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="x" id="x" value="<%=x %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[10] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--宽窄比--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126417,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="n" id="n" value="<%=n %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[11] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--左边距--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126418,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="leftMarginCM" id="leftMarginCM" value="<%=leftMarginCM %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[12] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>


        <%--上边距--%>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}"><%=SystemEnv.getHtmlLabelName(126419,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td1','display':'none'}">
            <input type="text" class="InputStyle" name="topMarginCM" id="topMarginCM" value="<%=topMarginCM %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[13] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--校验字符--%>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}"><%=SystemEnv.getHtmlLabelName(126420,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}">
            <input type="checkbox" name="checkCharacter" id="checkCharacter" value="y"  <%="y".equals(checkCharacter)?"checked":"" %> />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[14] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--文本校验字符--%>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}"><%=SystemEnv.getHtmlLabelName(126421,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}">
            <input type="checkbox" name="checkCharacterInText" id="checkCharacterInText" value="y"  <%="y".equals(checkCharacterInText)?"checked":"" %> />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[15] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--CODE128使用的字符集--%>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}"><%=SystemEnv.getHtmlLabelName(126422,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}">
            <select name="Code128Set" id="Code128Set">
                <option value="0" <%="0".equals(Code128Set)?"selected":"" %> >0</option>
                <option value="A" <%="A".equals(Code128Set)?"selected":"" %> >A</option>
                <option value="B" <%="B".equals(Code128Set)?"selected":"" %> >B</option>
                <option value="C" <%="C".equals(Code128Set)?"selected":"" %> >C</option>
            </select>
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[16] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--UPCE使用的编码系统--%>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}"><%=SystemEnv.getHtmlLabelName(126423,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td3','display':'none'}">
            <select name="UPCESytem" id="UPCESytem">
                <option value="0" <%="0".equals(UPCESytem)?"selected":"" %> >0</option>
                <option value="1" <%="1".equals(UPCESytem)?"selected":"" %> >1</option>
            </select>
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[17] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>




	</wea:group>





    <wea:group context='<%=SystemEnv.getHtmlLabelNames("126576,1362,68",user.getLanguage()) %>' attributes="{'itemAreaDisplay':'true'}">
        <wea:item><%=SystemEnv.getHtmlLabelNames("18095",user.getLanguage()) %></wea:item>
        <wea:item><input type="checkbox" tzCheckbox="true" name='isopen2' value='1' <%="1".equals(isopen2)?"checked":"" %> onclick='onchangeacc2(this)' /></wea:item>


        <%--码制--%>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}"><%=SystemEnv.getHtmlLabelName(126408,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}">
            <select name="barType2" id="barType2">

                    <%--其他码制--%>
                    <%--<option value="ITF" <%="ITF".equals(barType)?"selected":"" %> >ITF</option>--%>
                    <%--<option value="AZTEC" <%="AZTEC".equals(barType)?"selected":"" %> >AZTEC</option>--%>
                    <%--<option value="DATA_MATRIX" <%="DATA_MATRIX".equals(barType)?"selected":"" %> >DATAMATRIX</option>--%>
                    <%--<option value="MAXICODE" <%="MAXICODE".equals(barType)?"selected":"" %> >MAXICODE</option>--%>
                    <%--<option value="PDF_417" <%="PDF_417".equals(barType)?"selected":"" %> >PDF417</option>--%>
                <option value="QR_CODE" <%="QR_CODE".equals(barType2)?"selected":"" %> >QRCODE</option>
                    <%--<option value="RSS_14" <%="RSS_14".equals(barType)?"selected":"" %> >RSS14</option>--%>
                    <%--<option value="RSS_EXPANDED" <%="RSS_EXPANDED".equals(barType)?"selected":"" %> >RSSEXPANDED</option>--%>
                    <%--<option value="UPC_EAN_EXTENSION" <%="UPC_EAN_EXTENSION".equals(barType)?"selected":"" %> >UPCEANEXTENSION</option>--%>
            </select>
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[18] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>


        <%--图片宽度--%>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}"><%=SystemEnv.getHtmlLabelName(22924,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}">
            <input type="text" class="InputStyle" name="width2" id="width2" value="<%=width2 %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[19] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--图片高度--%>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}"><%=SystemEnv.getHtmlLabelName(22925,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}">
            <input type="text" class="InputStyle" name="height2" id="height2" value="<%=height2 %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[20] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--是否显示居中小图标--%>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}"><%=SystemEnv.getHtmlLabelName(126577,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}">
            <input type="checkbox" name="st2" id="st2" value="y"  <%="y".equals(st2)?"checked":"" %> />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[21] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--居中小图标指定--%>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}"><%=SystemEnv.getHtmlLabelName(126579,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}">
            <input type="text" name="textFont2" id="textFont2" value="<%=textFont2 %>" />
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[22] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>

        <%--条码内容配置--%>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}"><%=SystemEnv.getHtmlLabelName(126578,user.getLanguage()) %></wea:item>
        <wea:item attributes="{'samePair':'tsk_approval_td2','display':'none'}">
            <select name="content2type" id="content2type" onchange="switchLink(this);">
                <option value="link" <%="link".equals(content2type)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage()) %></option>
                <option value="text" <%="text".equals(content2type)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(20749,user.getLanguage()) %></option>
            </select>
            <input type="text" name="link2" id="link2" value="<%=link2 %>" style="display: <%=!"link".equals(content2type)?"none":"" %>;"/>
            <textarea type="text" name="content2" id="content2"  rows="8" style="display: <%=!"text".equals(content2type)?"none":"" %>;"><%=content2 %></textarea>
            &nbsp;&nbsp;<span mytooltip title="<%=tooltip[23] %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>




    </wea:group>



</wea:layout>




</FORM>
<div style="height:30px;"></div>
<script language=javascript>  
function onchangeacc(obj){
	if(obj.checked==true){
		showEle('tsk_approval_td1');
	}else{
		hideEle('tsk_approval_td1');
	}
}
function onchangeacc2(obj){
	if(obj.checked==true){
		showEle('tsk_approval_td2');
	}else{
		hideEle('tsk_approval_td2');
	}
}
function switchLink(obj){
    if(jQuery(obj).val()=="text"){
        jQuery("#content2").show();
        jQuery("#link2").hide();
    }else{
        jQuery("#content2").hide();
        jQuery("#link2").show();
    }
}


jQuery(document).ready(function(){
	jQuery('.e8_box').Tabs({
	    	getLine:1,
	    	image:false,
	    	needLine:false,
	    	needTopTitle:false,
	    	needInitBoxHeight:false,
	    	needFix:true,
	    	containerHide:true
	});
	jQuery("input[type=checkbox][name=isopen]").each(function(){
		if(jQuery(this).attr("checked")==true){
            showEle('tsk_approval_td1');
		}else {
            hideEle('tsk_approval_td1');
        }
	});
    jQuery("input[type=checkbox][name=isopen2]").each(function(){
        if(jQuery(this).attr("checked")==true){
            showEle('tsk_approval_td2');
        }else {
            hideEle('tsk_approval_td2');
        }
    });
});


function submitData(){
	var form=jQuery("#weaver");
	var form_data=form.serialize();
	var form_url=form.attr("action");
	jQuery.ajax({
		url : form_url,
		type : "post",
		async : true,
		data : form_data,
		dataType : "html",
		contentType: "application/x-www-form-urlencoded; charset=utf-8", 
		success: function do4Success(msg){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
			
		}
	});
}

function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	jQuery("span[mytooltip]").wTooltip({html:true});
});
</script>
</BODY>
</HTML>
