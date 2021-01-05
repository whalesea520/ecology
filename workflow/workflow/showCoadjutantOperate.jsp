
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
String coadjutantpost = Util.null2String(request.getParameter("coadjutantpost"));
String coadjutantclear = Util.null2String(request.getParameter("coadjutantclear"));
int IsCoadjutant = Util.getIntValue(Util.null2String(request.getParameter("iscoadjutant")),0);
int signtype = Util.getIntValue(Util.null2String(request.getParameter("signtype")),2);
String coadjutants=Util.null2String(request.getParameter("coadjutants"));
String coadjutantnames=Util.null2String(ResourceComInfo.getLastname(coadjutants));
int issubmitdesc = Util.getIntValue(Util.null2String(request.getParameter("issubmitdesc")),0);
int ispending=Util.getIntValue(Util.null2String(request.getParameter("ispending")),0);
int isforward=Util.getIntValue(Util.null2String(request.getParameter("isforward")),0);
int ismodify=Util.getIntValue(Util.null2String(request.getParameter("ismodify")),0);
int issyscoadjutant=Util.getIntValue(Util.null2String(request.getParameter("issyscoadjutant")),1);
String coadjutantcn="";
boolean hasrighthead=false;
if(coadjutantpost.equals("1")){
    if(IsCoadjutant==1){
        if(issyscoadjutant==0){
            coadjutantcn+=SystemEnv.getHtmlLabelName(22723,user.getLanguage())+"("+coadjutantnames+")";
        }else{
            coadjutantcn+=SystemEnv.getHtmlLabelName(22723,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22695,user.getLanguage())+")";
        }
        if(signtype==0){
            coadjutantcn+=" "+SystemEnv.getHtmlLabelName(21790,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15556,user.getLanguage())+")";
        }else if(signtype==1){
            coadjutantcn+=" "+SystemEnv.getHtmlLabelName(21790,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15557,user.getLanguage())+")";
        }else{
            coadjutantcn+=" "+SystemEnv.getHtmlLabelName(21790,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22694,user.getLanguage())+")";
        }
        if(issubmitdesc==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22698,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22698,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(ispending==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22699,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22699,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(isforward==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22700,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22700,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(ismodify==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22701,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22701,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(hasrighthead) coadjutantcn+=")";
    }else{
        coadjutantclear="1";
    }
}

if(coadjutantclear.equals("1")){
}
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="shortcut icon" href="http://example.com/favicon.ico" type="image/vnd.microsoft.icon">
<link rel="icon" href="http://example.com/favicon.ico" type="image/vnd.microsoft.icon">

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
var parentWin = parent.parent.getParentWindow(parent);

function onClose(){
	dialog.close();
}

if (<%=coadjutantpost.equals("1")%> ){
	var returnjson = {IsCoadjutant:"<%=IsCoadjutant%>",signtype:"<%=signtype%>",issyscoadjutant:"<%=issyscoadjutant%>",coadjutants:"<%=coadjutants%>",coadjutantnames:"<%=coadjutantnames%>",issubmitdesc:"<%=issubmitdesc%>",ispending:"<%=ispending%>",isforward:"<%=isforward%>",ismodify:"<%=ismodify%>",coadjutantcn:"<%=coadjutantcn%>"};
	if(dialog){
		dialog.close(returnjson);
	}else{
		window.parent.returnValue = returnjson;
		window.parent.close();
	}
}
if (<%=coadjutantclear.equals("1")%>) {
	var returnjson = {IsCoadjutant:"",signtype:"",issyscoadjutant:"",coadjutants:"",coadjutantnames:"",issubmitdesc:"",ispending:"",isforward:"",ismodify:"",coadjutantcn:""};
	if(dialog){
		dialog.close(returnjson);
	}else{
		window.parent.returnValue = returnjson;
		window.parent.close();
	}
}
</script>

<script language=vbs>
    if "<%=coadjutantpost%>" = "1" then
    window.parent.returnvalue = Array("<%=IsCoadjutant%>","<%=signtype%>","<%=issyscoadjutant%>","<%=coadjutants%>","<%=coadjutantnames%>","<%=issubmitdesc%>","<%=ispending%>","<%=isforward%>","<%=ismodify%>","<%=coadjutantcn%>")
    window.parent.close
    end if
    if "<%=coadjutantclear%>" = "1" then
    window.parent.returnvalue = Array("","","","","","","","","","")
    window.parent.close
    end if
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(22673,user.getLanguage())%>"/>
</jsp:include>
<div class="zDialog_div_content">
<FORM name=SearchForm  action="showCoadjutantOperate.jsp" method="post">
<input type=hidden name=coadjutantpost value="">
<input type=hidden name=coadjutantclear value="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22673,user.getLanguage())%>'>
	
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		
<table width=100% class="viewform">
<COLGROUP>
   <COL width="4%">
   <COL width="16%">
   <COL width="40%">
   <COL width="40%">

<TR  class="title">
    	  <Td  colSpan=4 class=field>
              <input type="checkbox" name="iscoadjutant" notBeauty="true" id="iscoadjutant" value="1" <%if(IsCoadjutant==1){%> checked<%}%> onclick="checknodepass(this)"><%=SystemEnv.getHtmlLabelName(22693,user.getLanguage())%></Td>
    	  </TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(21790,user.getLanguage())%></Td>
    <Td colSpan=2 class=field>
        <input type="radio" onclick="$changeOption()" notBeauty="true" name="signtype" id="signtype0" value="0" <%if(signtype==0){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>
        <input type="radio" onclick="$changeOption()" notBeauty="true" name="signtype"  id="signtype1"  value="1" <%if(signtype==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>
        <input type="radio" onclick="$changeOption()" notBeauty="true" name="signtype"   id="signtype2" value="2" <%if(signtype==2){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22694,user.getLanguage())%>
    </Td>
          </TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%></Td>
    <Td colspan=2 class=field>
        <input type="radio"  name="issyscoadjutant" notBeauty="true" value="1" <%if(issyscoadjutant==1){%>checked<%}%> <%if(IsCoadjutant!=1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22695,user.getLanguage())%><br>
        <input type="radio"  name="issyscoadjutant" notBeauty="true" value="0" <%if(issyscoadjutant==0){%>checked<%}%> <%if(IsCoadjutant!=1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22696,user.getLanguage())%>
        <button class=Browser name="coadjutantbrw" id="ShowMutiHrmBtn" style="display:none" onclick="onShowMutiHrm('coadjutantspan','coadjutants','coadjutantnames')"  <%if(IsCoadjutant!=1){%>disabled<%}%>></button>
        <span id="coadjutantbrw_span" style="display:inline-block"><brow:browser name="coadjutantbrw_browser" viewType="0" hasBrowser="true" isMustInput="1" isSingle="true" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
        width="24px"  hasAdd="false" hasInput="false" zDialog="true" _callback="newShowMutiHrm" />
        </span>
        <span name="coadjutantspan" id="coadjutantspan"> <%if(issyscoadjutant==0){%><%=coadjutantnames%><%}%></span>
        <input type=hidden name="coadjutants" id="coadjutants" value="<%=coadjutants%>">
        <input type=hidden name="coadjutantnames" id="coadjutantnames" value="<%=coadjutantnames%>">
    </Td>
    </TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(22697,user.getLanguage())%></Td>
    <Td class=field>
        <input type="checkbox" notBeauty="true" onclick="$changeOptionTwo(0)"    name="issubmitdesc" id ="issubmitdesc"  value="1" <%if(issubmitdesc==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22698,user.getLanguage())%></Td>
    <Td class=field>
	     <span id="ispendspan" style='display: none'>
        <input type="checkbox" notBeauty="true" onclick="$changeOptionTwo(1)" name="ispending" id ="ispending"  value="1" <%if(ispending==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22699,user.getLanguage())%></span></Td>
    </TR>
<TR  class="title">
    <Td></Td>
    <Td></Td>
    <Td style='display: none' class=field>
        <input type="checkbox" notBeauty="true" onclick="$changeOptionTwo(2)" name="isforward" id ="isforward"  value="1" <%if(isforward==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22700,user.getLanguage())%></Td>
    <Td class=field>
        <input type="checkbox" notBeauty="true" onclick="$changeOptionTwo(3)"  name="ismodify" id ="ismodify"  value="1" <%if(ismodify==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22701,user.getLanguage())%>
        </Td>
    </TR>

</table>

		</wea:item>
		
	</wea:group>
</wea:layout>

<BR>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></B>:<BR>
<B><%=SystemEnv.getHtmlLabelName(21790,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(22703,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22704,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22705,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22694,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22706,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(22707,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22695,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22708,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22696,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22709,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(22697,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(22710,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22698,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22711,user.getLanguage())%>
<BR>
<span id="spendexplain" style='display: none'>
<%=SystemEnv.getHtmlLabelName(22699,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22712,user.getLanguage())%>
<BR>
</span>
<%//SystemEnv.getHtmlLabelName(22700,user.getLanguage())%><%//SystemEnv.getHtmlLabelName(22713,user.getLanguage())%>

<%=SystemEnv.getHtmlLabelName(22701,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(22714,user.getLanguage())%>
</TD>
</TR>
</TBODY>
</table>

</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose()" style="width: 60px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>

<SCRIPT language="javascript">

    $(document).ready(function(){
        $(".e8_os").find("#outcoadjutantbrw_browserdiv").css("display","none");
        $(".e8_os").find(".e8_innerShowMust").css("display","none");
        $(".e8_os").find(".e8_innerShow_button").css("float","left");
        <%if(IsCoadjutant!=1){%>
        $("#coadjutantbrw_browser_browserbtn")[0].disabled=true;
        <%}%>
    });
    function newShowMutiHrm(event,datas,name,_callbackParams){
        if(datas != null && datas.id != ""){
            resourceids =datas.id;
            resourcename = datas.name;
            $("#coadjutantspan").html(resourcename);
            $("#coadjutants").val(resourceids);
            $("#coadjutantnames").val(resourcename);
            document.all("issyscoadjutant")[0].checked=false;
            document.all("issyscoadjutant")[1].checked=true;
        }else{
            $("#coadjutantspan").html("");
            $("#coadjutants").val("");
            $("#coadjutantnames").val("");
            document.all("issyscoadjutant")[0].checked=true;
            document.all("issyscoadjutant")[1].checked=false;
        }
    }
    function onShowMutiHrm(spanname,inputename,showname)    {
        /*
        tmpids = document.all(inputename).value;
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
        if (null!=id1) {
            if(id1.id!=""){
                resourceids =id1.id;
                resourcename = id1.name;
                $("#"+spanname).html(resourcename);
                $("#"+inputename).val(resourceids);
                $("#"+showname).val(resourcename);
                document.all("issyscoadjutant")[0].checked=false;
                document.all("issyscoadjutant")[1].checked=true;
            }else{
                $("#"+spanname).html("");
                $("#"+inputename).val("");
                $("#"+showname).val("");
                document.all("issyscoadjutant")[0].checked=true;
                document.all("issyscoadjutant")[1].checked=false;
            }
        }
        */
    }


</script>
<style>
#coadjutantbrw_browser_browserbtn {
    background-image:url(/wui/theme/ecology8/skins/default/general/browser_wev8.png) !important;
    height:16px !important;
    line-height:16px;
}
#coadjutantbrw_span div,#coadjutantbrw_span span{
    height:16px !important;
    line-height:16px;
}
</style>
<script language="javascript">
function submitData()
{
    if (SearchForm.iscoadjutant.checked&&document.all("issyscoadjutant")[1].checked&&document.all("coadjutants").value=="") {
        alert("<%=SystemEnv.getHtmlLabelName(22715,user.getLanguage())%>");
        return;
    }
    document.all("coadjutantpost").value="1";
    document.SearchForm.submit();
}

function submitClear()
{
	document.all("coadjutantclear").value="1";
     document.SearchForm.submit();
}
function checknodepass(obj) {
    if (obj.checked) {
        SearchForm.coadjutantbrw.disabled = false;
        SearchForm.issubmitdesc.disabled = false;
        SearchForm.ispending.disabled = false;
        SearchForm.isforward.disabled = false;
        SearchForm.ismodify.disabled = false;
        document.all("signtype")[0].disabled=false;
        document.all("signtype")[1].disabled=false;
        document.all("signtype")[2].disabled=false;
        document.all("issyscoadjutant")[0].disabled=false;
        document.all("issyscoadjutant")[1].disabled=false;
        $("#coadjutantbrw_browser_browserbtn")[0].disabled=false;
    } else {
        SearchForm.coadjutantbrw.disabled = true;
        SearchForm.issubmitdesc.disabled = true;
        SearchForm.ispending.disabled = true;
        SearchForm.isforward.disabled = true;
        SearchForm.ismodify.disabled = true;
        document.all("signtype")[0].disabled=true;
        document.all("signtype")[1].disabled=true;
        document.all("signtype")[2].disabled=true;
        document.all("issyscoadjutant")[0].disabled=true;
        document.all("issyscoadjutant")[1].disabled=true;
        $("#coadjutantbrw_browser_browserbtn")[0].disabled=true;
    }
}


//issubmitdesc
//ispending
//isforward
//ismodify
function $changeOption(){
    if($("#signtype0").attr("checked")){
       $("#issubmitdesc").attr("checked",true);
        $("#issubmitdesc").attr("disabled",true);
        $("#ispending").attr("checked",false);
		$("#ispendspan").show();
        $("#spendexplain").show(); 
    }else if($("#signtype1").attr("checked")){
       $("#issubmitdesc").attr("checked",false);
       $("#issubmitdesc").attr("disabled",true);
       $("#ispending").attr("checked",false);
       $("#ispendspan").hide();
       $("#spendexplain").hide();
    }else{
        $("#issubmitdesc").attr("disabled",false);
        $("#issubmitdesc").attr("checked",false);
        if(!$("#issubmitdesc").attr("checked")){
            $("#ispendspan").hide();
			$("#spendexplain").hide();
        }
        $("#ispending").attr("checked",false);  
    }
}
function $changeOptionTwo(id){
        if(0==id){
             if($("#signtype2").attr("checked")){
                    if($("#issubmitdesc").attr("checked")){
			            $("#ispendspan").show();
						$("#spendexplain").show();
			        }else{
			            $("#ispendspan").hide();
						$("#spendexplain").hide();
			        }
             }
             if($("#issubmitdesc").attr("checked")){
                 if(!$("#signtype2").attr("checked")){
                     $("#issubmitdesc").attr("checked",false);
                     alert("<%=SystemEnv.getHtmlLabelName(31396,user.getLanguage())%>");
                     return;
                 }
             }
        }else if(1==id){
               if(!$("#ispending").attr("checked")){
                      if($("#signtype1").attr("checked")){
                          $("#ispending").attr("checked",true);
                          alert("<%=SystemEnv.getHtmlLabelName(31397,user.getLanguage())%>");
                          return;
                      }
               }
        }else if(2==id){

        }else{

        }

}
</script>
