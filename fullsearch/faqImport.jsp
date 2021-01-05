<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
    String importtype = Util.null2String(request.getParameter("importtype"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/js/jquery/ui/jquery-ui_wev8.css" type="text/css" rel=stylesheet>
<script language="javascript" src="/js/checkinput_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/hrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
    //jQuery("#searchfrm").submit();
}
</script>
<STYLE type=text/css>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display:none;
}
</STYLE>

</head>
<%
    String imagefilename = "/images/hdHRMCard_wev8.gif";
    String title = Util.null2String(request.getParameter("title"));
    String titlename = SystemEnv.getHtmlLabelNames(title, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
    String isDialog = Util.null2String(request.getParameter("isdialog"));

    List<String> lsPromptLabel = new ArrayList<String>(); //提示信息
    lsPromptLabel.add(SystemEnv.getHtmlLabelName(34275,user.getLanguage()));
    lsPromptLabel.add(SystemEnv.getHtmlLabelName(128520,user.getLanguage()));
    lsPromptLabel.add(SystemEnv.getHtmlLabelName(128735,user.getLanguage()));
    lsPromptLabel.add(SystemEnv.getHtmlLabelName(128736,user.getLanguage()));
    lsPromptLabel.add(SystemEnv.getHtmlLabelName(128737,user.getLanguage()));
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
        <jsp:param name="mouldID" value="eAssistant" />
        <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(24419,user.getLanguage()) %>" />
    </jsp:include>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
    <tr>
    <td></td>
    <td class="rightSearchSpan" style="text-align:right;">
        <input type=button class="e8_btn_top" onClick="dosubmit(this)" value="<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>">
        <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
    </td>
    </tr>
</table>
<FORM id=frmMain name=frmMain action="FaqBasicDataImportProcess.jsp" method=post enctype="multipart/form-data" target="subframe">
<input id="importtype" name="importtype" type="hidden" value="<%=importtype %>">
<input id="creater" name="creater" type="hidden" value="<%=user.getUID() %>">
<input id="userlanguage" name="userlanguage" type="hidden" value="<%=user.getLanguage() %>">
    <wea:layout type="2col">
        <wea:group context="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>" attributes="{'groupOperDisplay':'none','itemAreaDisplay':'block','groupSHBtnDisplay':'none'}">
      <wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item>
      <wea:item><a href='<%=importtype %>.xls' class="templetfile" style="color: #30b5ff"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage())%></a></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(16699, user.getLanguage())%></wea:item>
      <wea:item>
        <input class=inputstyle style="width: 360px" type="file" name="excelfile" accept="application/vnd.ms-excel" onchange='checkinput("excelfile","excelfilespan");this.value=trim(this.value)'><SPAN id=excelfilespan>
         <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
        </SPAN>
      </wea:item>
        </wea:group>
    </wea:layout> 
    
    <wea:layout>
        <wea:group context="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(85,user.getLanguage())%>" attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block','groupSHBtnDisplay':'none'}">
          <wea:item attributes="{'colspan':'2'}">
            <%for(int i=0;i<lsPromptLabel.size();i++){ %>
            <span style="display:block;width: 780px;line-height:25px;"><%=(i+1)+"、"+lsPromptLabel.get(i)%>
                <%if(i==0){ %>
                <a href='<%=importtype %>.xls' class="templetfile" style="color: #30b5ff"><%=SystemEnv.getHtmlLabelName(28576, user.getLanguage()) %></a>
                <%} %>
            </span>
            <%} %>
        </wea:item>
        </wea:group>
    </wea:layout>   
    <!-- 隐藏提交iframe -->
    <iframe name='subframe' id="subframe" style='display:none'></iframe>
  <div id="zDialog_div_bottom" class="zDialog_div_bottom">
        <wea:layout type="2col">
        <wea:group context="">
            <wea:item type="toolbar">
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="javascript:parentWin.closeDialog();">
            </wea:item>
        </wea:group>
      </wea:layout>
    </div>
    <script type="text/javascript">
        jQuery(document).ready(function(){
            resizeDialog(document);
        });
    </script>
</form>
</div>
<script language=javascript>
var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(parent);

function closeDialog(){
    dialog.close();
}

function check_form(frm)
{
    if(document.frmMain.excelfile.value==""){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
        return false;
    }
    return true;
}

function dosubmit(obj) {
  if(check_form(document.frmMain)) {
        dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.Title = "<%=SystemEnv.getHtmlLabelNames(title, user.getLanguage())%>";
        dialog.Width = 650;
        dialog.Height = 400;
        dialog.Drag = true;
        dialog.URL = "/fullsearch/FaqBasicDataImportLog.jsp?isdialog=1&importtype="+jQuery("#importtype").val();
        dialog.show();
    document.frmMain.submit() ; 
  }
}

function afterreload(){
    var parentWin = parent.parent.getParentWindow(parent);
    try{
        parentWin.reloadTable();
    }catch(e){
    }
}

</script>
</BODY>
</HTML>