
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/browser" prefix="brow"%>
<% if(!true) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

	String isclose = Util.null2String(request.getParameter("isclose"));
	String ebaseid = "reportForm";
	String sbaseid = Util.null2String(request.getParameter("sbaseid"));
	String eid = Util.null2String(request.getParameter("eid"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/synergy/js/browser_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'type')){
    	var vtval = $("input[name=valueTypeObj]").val($("#valuetype").val());
    	if(vtval.val() === "0")
    	{
    		$("input[name=paramvalueObj]").val($("#paramvalue").val());
    		$("input[name=paramvaluenameObj]").val("");
    	}else if(vtval.val() === "2")
    	{
    		$("input[name=paramvalueObj]").val($("#selectids").val());
    		$("input[name=paramvaluenameObj]").val($("#selectidsspan").text().substr(0,$("#selectidsspan").text().length-3));
    	}else if(vtval.val() === "4")
    	{
    		$("input[name=paramvalueObj]").val($("#paramselect").val());
    		$("input[name=paramvaluenameObj]").val($("#paramselect").text());
    	}
        weaver.submit();
    }
}
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.location = "ListAddressTypeInner.jsp";
	parentWin.closeDialog();
}

function getBrowserJson(event,datas)
{
	if(datas.id)
	{
		var weaverSplit = "||~WEAVERSPLIT~||";
		var pfs = datas.pfiled.split(weaverSplit);
		var _pname = $("#pname").val(pfs[0]);
		var _ptype = $("#ptype").val(pfs[1]);
		var _pbrowid = $("#pbrowid").val(pfs[2]);
		var _psysid = $("#psysid").val(pfs[4]);
		$("#param_p").text("$P."+_pname.val());
		if(_psysid.val() === "1")
		{
			$("#pformid").val(pfs[5]);
			$("#pisbill").val(pfs[6]);
		}
		setPublicBrow(_pbrowid.val(),_ptype.val(),pfs[3]);
	}
}

function setPublicBrow(browserid,ptype,psolo)
{
	$("#valuetype").find("option").remove();
	
	if(ptype === "1" || ptype === "2")
			{
				
				$("#valuetype").append("<option value=\"0\"><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>");
				//字符串
				$("#paramvalue").show();
				$("#paramselect").hide();
				$("#paramvalue").val("");
				$("#browserSpan").hide();
			}
			else if(ptype === "3")
			{
				//浏览框
				$("#valuetype").append("<option value=\"2\"><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option><option value=\"3\"><%=SystemEnv.getHtmlLabelName(33749,user.getLanguage()) %></option>");
				$("#paramvalue").hide();
				$("#browserSpan").css("display","inline-block");
				$("#browsertype").find("option[value="+browserid+"]").attr("selected",true);
				clearSltValue($("#selectids"), $("#selectidsspan"));
				$("#paramselect").hide();
			}else if(ptype === "4")
			{
				//Check框
			}else if(ptype === "5")
			{
				//选择框
				$("#compareoption").append("<option value='4'><%=SystemEnv.getHtmlLabelName(327,user.getLanguage()) %></option><option value='5'><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage()) %></option>");
				$("#valuetype").append("<option value=\"4\"><%=SystemEnv.getHtmlLabelName(26367,user.getLanguage()) %></option>");
				$("#paramvalue").hide();
				$("#browserSpan").hide();
				if(psolo != "undefined")
				{
					var sevalues = psolo.split("+")[0];
					var selabels = psolo.split("+")[1];
					var seval = sevalues.split(",");
					var selbl = selabels.split("<br>");
					$("#paramselect").find("option").remove();
					
					for(var i=0;i<seval.length;i++)
						$("#paramselect").append("<option value="+seval[i]+">"+selbl[i]+"</option>");
				}
				$("#paramselect").show();
			}
}

function clearSltValue(obj,objspan)
{
	obj.val("");
	objspan.html("");
}
</script>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<FORM id=weaver action="/synergy/maintenance/SynergyES4RPFrameOperation.jsp" method=post>
	<input type="hidden" name="method" value="add">
	<input type="hidden" name="eid" value="<%=eid %>" >
	<input type="hidden" name="valueTypeObj" >
	<input type="hidden" name="paramvaluenameObj" >
	<input type="hidden" name="paramvalueObj" >
	<input type="hidden" name="browsidObj" value="-1">
	<TABLE class=ViewForm>
    	<COLGROUP>
  			<COL width="20%">
  			<COL width="80%">
  		</COLGROUP>
        <TBODY>
	        <TR>
	          	<TD><%=SystemEnv.getHtmlLabelName(84281,user.getLanguage()) %></TD>
	          	<TD class=Field>
	          	<%String furl = "/systeminfo/BrowserMain.jsp?url=/synergy/browser/SynergyParamBrowserContent.jsp?ebaseid="+ebaseid+"&sbaseid="+sbaseid; %>
	          	<brow:browser name="paramdatafield" viewType="0" hasBrowser="true" hasAdd="false" 
	                  			isMustInput="1" isSingle="true" hasInput="true"
	                  			completeUrl="" browserUrl='<%=furl %>'
	                  			width="267px" browserValue="-1" browserSpanValue='<%=SystemEnv.getHtmlLabelName(84282,user.getLanguage()) %>' _callback="getBrowserJson"/>
	                  	<input type=hidden name=ptype id=ptype >
	                  	<input type=hidden name=pname id=pname >
	                  	<input type=hidden name=pbrowid id=pbrowid >
	                  	<input type=hidden name=psysid id=psysid >
	                  	<input type=hidden name=pformid id=pformid >
	                  	<input type=hidden name=pisbill id=pisbill >
	            <select id="browsertype" name="browsertype" style="display:none;float:left;">
                        <%
                        
				  		IntegratedSapUtil integratedSapUtil = new IntegratedSapUtil();
				  		BrowserComInfo browserComInfo = new BrowserComInfo();
				  		String IsOpetype = integratedSapUtil.getIsOpenEcology70Sap();
				  		//System.out.println("==========" + browserComInfo.get);
				  		while(browserComInfo.next()){%>
			  			<%
				  			String url = browserComInfo.getBrowserurl(); // 浏览按钮弹出页面的url
		      				String linkurl = browserComInfo.getLinkurl(); // 浏览值点击的时候链接的url
			  				if(url.equals("") || url.lastIndexOf("=") == (url.length() - 1) || "".equals(browserComInfo.getBrowsertablename())){
			  					 continue;
			  				 }
			  				 if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
			  				 	continue;
			  				 }
				  		%>
				  		<option value="<%=browserComInfo.getBrowserid()%>" _url="<%=url %>" _linkurl="<%=linkurl %>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
				  		<%
				  		}
				  		%>
                    </select>      			
    			</TD>
	        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        	<TR>
          		<TD><%=SystemEnv.getHtmlLabelName(561,user.getLanguage()) %></TD>
          		<TD class=Field><label id=param_p></label></TD>
         	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>    
         	<TR>
          		<TD><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage()) %></TD>
          		<TD class=Field>
					<select id="valuetype" name="valuetype">
                        <option value="0"><%=SystemEnv.getHtmlLabelName(33746,user.getLanguage()) %></option>
		                <option value="2"><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage()) %></option>
		                <option value="3"><%=SystemEnv.getHtmlLabelName(84284,user.getLanguage()) %></option>
                    </select>
				</TD>
         	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>     
         	<TR>
          		<TD><%=SystemEnv.getHtmlLabelName(20969,user.getLanguage()) %></TD>
          		<TD class=Field>
					<input type="text" id="paramvalue" name="paramvalue">
                    <span id="browserSpan" name="browserSpan" style="display:none;">
                    <brow:browser name="selectids" viewType="0" hasBrowser="true" hasAdd="false" 
                  			isMustInput="1" isSingle="true" hasInput="true"
                  			browserOnClick="onShowBrowser('selectids','','','17', 0, document.getElementById('browsertype'), document.getElementById('valuetype'))"
                  			completeUrl="javascript:getajaxurl();" 
                  			width="103px" browserValue="" browserSpanValue=""/>
               		</span>
               		<select id="paramselect" name="paramselect" style="width:105px;height:28px;display:none;">
				</TD>
         	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
         	<TR>
          		<TD>备注</TD>
          		<TD class=Field><INPUT class=InputStyle maxLength=150 size=45 name="desc" ></TD>
         	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
        </TBODY>
	</TABLE>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="zd_btn_submit" onclick="checkSubmit();">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    </td></tr>
	</table>
</div>
</table>
</BODY>
</HTML>
