
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.homepage.HomepageBean,org.json.*"%>
<%@ page import="weaver.homepage.cominfo.HomepageBaseLayoutCominfo"%>
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="mhc"	class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="esp" class="weaver.page.style.ElementStylePriview" scope="page" />
<jsp:useBean id="scc" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String layouttablestr="";
String layouttypestr="";
Map<String,String> layouttables=new HashMap<String,String>();
Map<String,String> layouttypes=new HashMap<String,String>();
//获取所有的模板布局
rs.execute("select id,layouttable,layouttype  from pagelayout");
while(rs.next()){
   layouttables.put(rs.getString("id"),Util.null2String(rs.getString("layouttable")));   
   layouttypes.put(rs.getString("id"),Util.null2String(rs.getString("layouttype")));   
}
JSONObject obj=new JSONObject(layouttables);
layouttablestr=obj.toString();
obj=new JSONObject(layouttypes);
layouttypestr=obj.toString();

String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
%>
<html>
<head>
	<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<LINK href="/css/ecology8/interface_wev8.css" type="text/css" rel=STYLESHEET>
	<!-- for tzcheckbox -->
	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
	<!-- for tabs -->
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	
	<link rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>	
		
	<style>
    
		.layouttable {
			width: 150px;
			border-collapse: collapse;
			height: 100%;
			table-layout: fixed;
			cursor: pointer;
			height: 150px !important;
			margin: auto;
		}
		.layouttable thead tr{
			height:1px;
		}
		.layouttable thead th{
			height:0px;
		}
		.layouttable tr {
			height: 25%;
		}
		 .layouttable  thead tr{
			height: 0;
		}
		  .layouttable td {
			border: 1px dashed #E7971F;
			vertical-align: middle !important;
			text-align: center !important;
			font-weight: bold;
			color: #ff9701 !important;
		}

	</style>
	<script>
	      var layouttables=<%=layouttablestr%>;
		  var layouttypes=<%=layouttypestr%>;
		  var lettersall = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
	</script>
</head>
<body>
<%
	
	String hpid = Util.null2String(request.getParameter("hpid"));
	String opt = Util.null2String(request.getParameter("opt"));
	String method = Util.null2String(request.getParameter("method"));
	
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	String closeDialog = Util.null2String(request.getParameter("closeDialog"));
	
	int userid = user.getUID();
	hpid = "".equals(hpid)?"0":hpid;
	String titlename = SystemEnv.getHtmlLabelName(23017, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(61, user.getLanguage());
	

	String infoname = "";
	String infodesc = "";
	String styleid = "";
	String layoutid = "";
	String isuse = "";
	String islocked = "";
	String menuStyleid = "";
	String bgcolor="#ffffff";
	String isRedirectUrl ="";
	String redirectUrl ="";

	rs.executeSql("select * from hpinfo where id=" + hpid);
	if (rs.next())
	{
		infoname = Util.null2String(rs.getString("infoname"));
		infodesc = Util.null2String(rs.getString("infodesc"));
		styleid = Util.null2String(rs.getString("styleid"));
		layoutid = Util.null2String(rs.getString("layoutid"));
		isuse = Util.null2String(rs.getString("isuse"));
		islocked = Util.null2String(rs.getString("islocked"));
		subCompanyId = Util.null2String(rs.getString("Subcompanyid"));
		menuStyleid = Util.null2String(rs.getString("menuStyleid"));
		bgcolor = Util.null2String(rs.getString("bgcolor"));
		isRedirectUrl = Util.null2String(rs.getString("isRedirectUrl"));
		redirectUrl = Util.null2String(rs.getString("redirectUrl"));
	}

%>

	<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=infoname %>"/> 
		</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:onSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep;

	//RCMenu += "{" + SystemEnv.getHtmlLabelName(19650, user.getLanguage()) + ",javascript:onSaveAndElement(),_self} ";
	//RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:onCancel(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	//RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:onBack(),_self} ";
	//RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onSave()">
						<%if("savebase".equals(method)){ %>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(19650,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSetElement()">
						
						<%} %>		
						<%if("ref".equals(method) && false){ %>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(33824,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onSaveAndSetting()">
						
						<%} %>					
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
<div class="zDialog_div_content" style="overflow-y: hidden;">
    
  
        
<FORM name="frmAdd" method="post" action="/homepage/maint/HomepageMaintOperate.jsp?opt=<%=opt%>">
	<input type="hidden" name="method" value="<%=method %>">
	<input type="hidden" name="hpid" value="<%=hpid%>">
	<input type="hidden" name="txtOnlyOnSave">
	<%="saveNew".equals(method)?"<input type=\"hidden\" name=\"srchpid\" value=\""+hpid+"\">":"" %>
		
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
		<wea:item>
				<INPUT TYPE="text" NAME="infoname" value="<%=infoname%>"
					onChange="checkinput('infoname','infonameSpan')"
					class="inputstyle" size=46>
				<span id=infonameSpan name=infonameSpan> 
				<%
				 	if ("".equals(infoname))
				 	{
				 		out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				 	}
				 %>
				</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
		<wea:item>
				<INPUT TYPE="text" NAME="infodesc" value="<%=infodesc%>"
					class="inputstyle" size=46>
		</wea:item>
		<%if("ref".equals(method)){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(17868, user.getLanguage())%></wea:item>
		<wea:item>
				<span id="showsubcompany" style="display:'';">
		        <brow:browser viewType="0" name="subCompanyId" id="subCompanyId" browserValue='<%=subCompanyId%>' browserSpanValue='<%=scc.getSubCompanyname(subCompanyId)%>' 
		        		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=homepage:Maint"
		                browserOnClick="" tempTitle='<%=SystemEnv.getHtmlLabelName(17868, user.getLanguage())%>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
		                completeUrl="/data.jsp?type=164" width="150px">
		        </brow:browser>
				</span>
			</wea:item>
		
		<%}else{%>
			<wea:item><%=SystemEnv.getHtmlLabelName(17868, user.getLanguage())%></wea:item>
			<wea:item>
					<span id="showsubcompany" style="display:'';">
			        <brow:browser viewType="0" name="subCompanyId" browserValue='<%=subCompanyId%>' browserSpanValue='<%=scc.getSubCompanyname(subCompanyId)%>' 
			        		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=homepage:Maint"
			                browserOnClick="" tempTitle='<%=SystemEnv.getHtmlLabelName(17868, user.getLanguage())%>'
			                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
			                completeUrl="/data.jsp?type=164" width="150px">
			        </brow:browser>
					</span>
				</wea:item>
		<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(18095, user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT type="checkbox" tzCheckbox="true" onclick="settingLock(this)" class=InputStyle name="isuse" id="isuse" value="1" <%if("1".equals(isuse)){%>checked<%}%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(129977, user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT type="checkbox" tzCheckbox="true" class=InputStyle id="isRedirectUrl" name="isRedirectUrl" value="1" <%if("1".equals(isRedirectUrl)){%>checked<%}%> >
			<%
			String redirectUrlSpanDisplay ="";
			if(!"1".equals(isRedirectUrl)){
				redirectUrlSpanDisplay ="none";
			}else{
				redirectUrlSpanDisplay ="";
			}
			%>
			<span  id="redirectUrlSpan" style="display:<%=redirectUrlSpanDisplay%>;padding:0 10px 0;">
				<%=SystemEnv.getHtmlLabelName(22967, user.getLanguage())+"URL"%>
				<input type="text" id="redirectUrl" name="redirectUrl" class="inputstyle" size=46  value="<%=redirectUrl%>" onChange="checkinput('redirectUrl','redirectUrlValSpan')">
				<span id="redirectUrlValSpan" name="redirectUrlValSpan"> 
				<%
				 	if ("".equals(redirectUrl))
				 	{
				 		out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				 	}
				 %>
				</span>
			</span>
		</wea:item> 
		<wea:item><%=SystemEnv.getHtmlLabelName(16213, user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT type="checkbox" tzCheckbox="true" class=InputStyle onclick="settingUse(this)" id="islocked" name="islocked" value="1" <%if("1".equals(islocked)){%>checked<%}%> >
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(22916, user.getLanguage())%></wea:item>
		<wea:item>
				<SELECT NAME="seleMenuStyleid" style="width:30%">
					<%			
					mhc.setTofirstRow();
					while (mhc.next()){
							String temMenuStyleid = mhc.getId();
							String temMenuStylename = Util.toHtml5(mhc.getTitle());
						
							String strSelected="";
							if(menuStyleid.equals(temMenuStyleid)) strSelected=" selected ";							
					%>						
						<option value="<%=temMenuStyleid%>" <%=strSelected%>><%=temMenuStylename%></option>						
					<%}%>
					</SELECT>	
		</wea:item>
		
	</wea:group>
<%
HomepageBaseLayoutCominfo hpblc=new HomepageBaseLayoutCominfo();						
String strArea="";
String strLayoutimage="";
String strLayoutdesc="";

String strLayoutType="";
ArrayList areflagList = new ArrayList();
ArrayList sizeList = new ArrayList();

%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19440,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(19407, user.getLanguage())%></wea:item>
		<wea:item>
				<%
				rs.executeSql("select areaflag,areasize from hplayout where hpid=" + hpid + " and userid=" + hpu.getHpUserId(hpid,subCompanyId,user) + " and usertype="+hpu.getHpUserType(hpid,subCompanyId,user));
				while (rs.next())
					{
						areflagList.add(Util.null2String(rs.getString("areaflag")));
						sizeList.add(Util.null2String(rs.getString("areasize")));
					}
				%>
				<SELECT NAME="seleLayoutid" 
					onchange="onLayoutidChanage(this)" <%if("saveNew".equals(method)){ %> disabled="true" <%} %>>
					<%
					while(hpblc.next()){
						String tempLayoutid=Util.null2String(hpblc.getId());
						String tempLayoutname=Util.null2String(hpblc.getLayoutname());							
						String allowArea=Util.null2String(hpblc.getAllowArea());
						String layoutimage=Util.null2String(hpblc.getLayoutimage());
						
						String layoutType = Util.null2String(hpblc.getLayoutType());
						String layoutdesc="";
						if(layoutid.equals("")){
							layoutid = tempLayoutid;
						}
						if("sys".equals(layoutType)){
							layoutdesc=SystemEnv.getHtmlLabelName(Util.getIntValue(hpblc.getLayoutdesc()),user.getLanguage());
						}else{
							layoutdesc=Util.null2String(hpblc.getLayoutdesc());
						}
						String strSelected="";							
						if(layoutid.equals(tempLayoutid)) {
							strSelected=" selected ";
							strArea=allowArea;
							strLayoutimage=layoutimage;
							strLayoutdesc=layoutdesc;
							strLayoutType = layoutType;
						}
						strLayoutimage = "".equals(strLayoutimage)?"/images/homepage/layout/layout_01_wev8.png":strLayoutimage.replaceAll("\\\\","/");
						layoutimage = layoutimage.replaceAll("\\\\","/");
					%>
					<option value="<%=tempLayoutid%>" <%=strSelected%>
						layoutImg="<%=layoutimage%>" layoutdesc="<%=layoutdesc%>"
						allowArea="<%=allowArea%>" layouttype="<%=layoutType%>"><%=tempLayoutname%></option>
					<%
						}
					%>
				</SELECT>
				<input type=hidden value="<%=strArea%>" name=txtLayoutFlag>
				
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(22913, user.getLanguage())%></wea:item>
		<wea:item>
				<SELECT NAME="seleStyleid"  onchange="changeStyle(this.value);"  >
					<%
						//esc.setTofirstRow();
					    rs.execute("select * from hpMenuStyle where menustyletype='element'");
						while (rs.next())
						{
							String tempStyleid = rs.getString("styleid");
							String tempStylename = Util.toHtml5(rs.getString("menustylename"));
							String strSelected = "";
							if (styleid.equals(tempStyleid))
								strSelected = " selected ";
					%>
					<option value="<%=tempStyleid%>" <%=strSelected%>><%=tempStylename%></option>
					<%
						}
					%>
				</SELECT>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(19407, user.getLanguage())+SystemEnv.getHtmlLabelName(221, user.getLanguage())%>
		</wea:item>
		<wea:item>
			<span id="tdSetLayout" style="float:left;padding:5px;">
				<img src="<%=basePath+strLayoutimage%>" onerror="javascript:this.src='<%=basePath%>/images/ecology8/homepage/layout_wev8.png';">
			</span>
			<span id="tdSetLayoutWidth" style="float:left;padding-left:15px;<%=!"sys".equals(strLayoutType) ?"display:none":"" %>">
				<%
				if(!"".equals(strArea)){
					ArrayList tempList=Util.TokenizerString(strArea,",");
					for(int i=0;i<tempList.size();i++){
						String tempArea=(String)tempList.get(i);
						String tempSizeValue=hpu.getAreaSize(tempArea,areflagList,sizeList);
						%>
						<%=tempArea %><%=SystemEnv.getHtmlLabelName(15114,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:<input type=text size=5 style="width:30px;" class=inputStyle  name='txtArea_<%=tempArea %>' <%if("saveNew".equals(method)){ %> disabled="true" <%} %> value='<%=tempSizeValue %>'>%
						<br>
						<%
					}									
				}
				%>
				</span>
				
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(1014, user.getLanguage())+SystemEnv.getHtmlLabelName(221, user.getLanguage())%>
		</wea:item>
		<wea:item>
			<span id="tdElementStyle" style="height:100%;width:96%;"><%=esp.getContainerForStyle("".equals(styleid)?"template":styleid) %></span>
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(2077, user.getLanguage())%>
		</wea:item>
		<wea:item>
			
			<input  id='bgcolor' name="bgcolor" class='inputstyle' style="background:<%=bgcolor %>;width:50px;" value="<%=bgcolor %>"  ></input><img class="color" src='/js/jquery/plugins/farbtastic/color_wev8.png' style='cursor:hand;margin-left:5px;margin-top:3px;'  align="absmiddle" border=0/>
		</wea:item>
	</wea:group>
</wea:layout> 
</FORM>
    
</div>
<div style="height:50px;">
&nbsp;
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<table width="100%">
    <tr><td style="text-align:center;" colspan="3">
     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
    </td></tr>
</table>
</div>

<script>
     
    var tablestrnow=layouttables['<%=layoutid%>'];
	var tablelayouttype=layouttypes['<%=layoutid%>'];
	if(tablestrnow!==undefined &&  tablestrnow!=='' && (tablelayouttype==='design' || tablelayouttype==='sys')){
	       showTableLayout(tablestrnow,tablelayouttype);
	}
    
	//展示自定义布局
	function  showTableLayout(tablestrnow,tablelayouttype){
		    var container=$("#tdSetLayout");
			var layout=$(tablestrnow);
			tds=layout.find("td");
			var count=0;
			for(var i=0;i<tds.length;i++){
				 tdtemp=$(tds[i]);
				 if(tdtemp.css("display")!=='none'){
					tdtemp.html(lettersall[count]);
					count++;
				 }
			 }
            container.css("line-height","0px");
			container.html("");
			container.append(layout);
			if(tablelayouttype==='design')
			  $("#tdSetLayoutWidth").hide();
			else
              $("#tdSetLayoutWidth").show();
	}
	
	

</script>

</body>
</html>
<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">


<%
  //保存成功，刷新父界面
  if("savebase".equals(method)){ %>
	//parent.getParentWindow(window).location.reload();			
	parent.getParentWindow(window)._table.reLoad();		
						
<%} %>		


<!--
var hpid="<%=hpid%>";
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"hpElement_Maint",
        staticOnLoad:true
    });
    
    var language ="<%=user.getLanguage()%>";
    var color=$("#bgcolor").val();
      $(".color").spectrum({
					showPalette:true,
					showInput:true,
					allowEmpty:false,
					preferredFormat: "hex",
					chooseText:SystemEnv.getHtmlNoteName(3451,language),
					cancelText:SystemEnv.getHtmlNoteName(3516,language),
					color:color,
					noclickhide:true,
					hide: function(color) {
	                		color = color.toHexString(); // #ff0000
							$("#bgcolor").css("backgroud-color",color);
							$("#bgcolor").val(color);
					},
					move: function(color) {
						    //console.dir(this);
							color = color.toHexString(); // #ff0000
							$("#bgcolor").css("background-color",color);
							$("#bgcolor").val(color);
							
					},
					palette: [
							["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
							["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
							["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
							["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
							["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
							["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
							["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
							["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
						]
				});
});

function switchTab(type,obj){
	if(type==0){
		jQuery("#infoDiv").show();
		jQuery("#styleDiv").hide();
	}else{
		jQuery("#infoDiv").hide();
		jQuery("#styleDiv").show();
	}
}

function settingUse(obj){
   if(obj.checked == true){
      $("#isuse").attr("checked",true);
      jQuery(document.getElementById("isuse")).next("span.tzCheckBox").addClass("checked");
   }
}

function settingLock(obj){
   if(obj.checked == false){
      $("#islocked").attr("checked",false);
      jQuery(document.getElementById("islocked")).next("span.tzCheckBox").removeClass("checked");
   }
}


function changeStyle(styleid){
	jQuery.post("/page/maint/style/MenuStylePriviewE.jsp?styleid="+styleid,
	function(data){
		jQuery("#tdElementStyle").html(data);
		jQuery(".content").css({"padding":"0"});
	})
}

function onCancel(){
	var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
	dialog.close();
}

$(document).ready(function(){
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox")=="true"){
			jQuery(this).tzCheckbox({labels:['','']});
		}
	});
	
	jQuery(".content").css({"padding":"0"});
	
	$("#isRedirectUrl").click(function(){
		//alert($(this).is(':checked'));
		if($(this).is(':checked')){
			$(this).val("1");
			$(this).attr("checked",true);
			$("#redirectUrlSpan").show();
			$("#homepageStyle").hide();
			hideTr();
		}else{
			$(this).val("0");
			$(this).attr("checked",false);
			$("#redirectUrlSpan").hide();
			$("#homepageStyle").show();
			$("tr").show();
		}
	});
	
	if($("#isRedirectUrl").is(":checked")){
		hideTr();
	}
	
	function hideTr(){
		var i = 0;
		var j = 0;
		$("tr").each(function(){
			if($(this).find("#islocked").length==1){
				j=i;
			}
			i++;
		});
		$("table tr").eq(j).hide();
		$("table tr").eq(j+1).hide();
		$("table tr").eq(j+2).hide();
		$("table tr").eq(j+3).hide();
		$("table tr").eq(j+4).hide();
		$("table tr").eq(j+5).hide();
		$("table tr").eq(j+6).hide();
		$("table tr").eq(j+7).hide();
	}
	
	
});

function doClearElement(){
	if(hpid==''||hpid==0)return;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(127882,user.getLanguage())%>",function(){
		jQuery.post("/homepage/maint/HomepageMaintOperate.jsp?method=clearElement&subCompanyId=<%=subCompanyId%>&hpid="+hpid,
		function(data){
			if(data.indexOf("OK")!=-1)jQuery("#hpElement_Maint").attr("src","/homepage/Homepage.jsp?hpid="+hpid+"&isSetting=true&subCompanyId=<%=subCompanyId%>&isfromportal=1&isfromhp=0&e="+new Date().getTime()).show();
		})
	})
}

function saveAndSubmit()
{
	var checkfield = "infoname";
	if($("#isRedirectUrl").is(":checked")){
		checkfield = "infoname,redirectUrl";
	}
	if("<%=method %>"=="ref")checkfield+=",subCompanyId";
    if(check_form(document.frmAdd,checkfield))
    {
        var xmlHttp = XmlHttp.create(); 
        var strUrl="/homepage/style/HomepageCheckname.jsp?subcompanyid="+frmAdd.subCompanyId.value+"&method=checkHomepagename&hpid=<%=hpid%>&name="+frmAdd.infoname.value
        //document.write(strUrl);
        strUrl = encodeURI(strUrl);
        xmlHttp.open("GET",strUrl, true);
    
        xmlHttp.onreadystatechange = function () 
        {  
            switch (xmlHttp.readyState) 
            {                  
               case 4 :
                    var strTemp=xmlHttp.responseText.replace(/^\s*|\s*$/g,'');
                   // alert(strTemp)
                   if(strTemp!="use")
                   {   
                     //alert($GetEle("method").value)                  
                     frmAdd.submit();
                   } 
                   else
                   {
                     top.Dialog.alert("<font  color=#FF0000><%=SystemEnv.getHtmlLabelName(19648, user.getLanguage())%></font>");
                   }                
                   break;
           } 
        }     
         xmlHttp.send(null);    
    }  
}
function onSaveAndElement()
{
 hiddenThisPage();        
 saveAndSubmit();
}
function onSave()
{
    frmAdd.txtOnlyOnSave.value="true";
    saveAndSubmit();
}
function onBack()
{
	window.location="/homepage/maint/HomepageRight.jsp";
}

function onLayoutidChanage(_this,layoutImg,layoutArea,layoutdesc,layoutType)
{	
	var target=_this.options[_this.selectedIndex];
    var ctarget=$(target); 
	var clayouttype=ctarget.attr("layouttype");
	if(clayouttype=="sys" || clayouttype=="design"){
	      showTableLayout(layouttables[ctarget.attr("value")],clayouttype);
	      $("input[name=txtLayoutFlag]").val($(target).attr("allowArea"));
		  if(clayouttype=="sys"){
		    $("#tdSetLayoutWidth").css("display","");
			$("#trSetLayoutLine").css("display","");
			var tempStrs = $(target).attr("allowArea").split(",");
			var innerStr="";
	        for(var i=0;i<tempStrs.length;i++){
				var tempArea=tempStrs[i];			innerStr+=tempArea+"<%=SystemEnv.getHtmlLabelName(15114,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:<input type=text size=5 style='width:30px;' class=inputStyle name='txtArea_"+tempArea+"' onkeypress=\"ItemCount_KeyPressNoHen()\" >%<br>";
			}
			$("#tdSetLayoutWidth").html(innerStr);
		  }
		  return;
	}
	if(""!=$(target).attr("allowArea")){
		$("#tdSetLayout").html("<img src=\"<%=basePath%>"+$(target).attr("layoutImg")+"\"onerror=\"javascript:this.src='<%=basePath%>/images/ecology8/homepage/layout_wev8.png';\">");
		$("#spanLayoutdesc").html($(target).attr("layoutdesc"));
		$("input[name=txtLayoutFlag]").val($(target).attr("allowArea"));
		
		if($(target).attr("layouttype")=="sys"){
			$("#tdSetLayoutWidth").css("display","");
			$("#trSetLayoutLine").css("display","");
			var tempStrs = $(target).attr("allowArea").split(",");
			var innerStr="";
	
			for(var i=0;i<tempStrs.length;i++){
				var tempArea=tempStrs[i];			innerStr+=tempArea+"<%=SystemEnv.getHtmlLabelName(15114,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:<input type=text size=5 style='width:30px;' class=inputStyle name='txtArea_"+tempArea+"' onkeypress=\"ItemCount_KeyPressNoHen()\" >%<br>";
			}
			
			$("#tdSetLayoutWidth").html(innerStr);
		}else{
		    
			$("#tdSetLayoutWidth").css("display","none");
		}
		
	}			
}

function hiddenThisPage()
{
    //window.parent.oTd1.style.display='none';
    //window.parent.middleframe.LeftHideShow.src = "/cowork/images/hide_wev8.gif";
    //window.parent.middleframe.LeftHideShow.title = '<%=SystemEnv.getHtmlLabelName(89, user.getLanguage())%>'
}

function doSetElement(hpid){
 	var title = "<%=SystemEnv.getHtmlLabelName(19650,user.getLanguage())%>"; 
 	var url = "/homepage/maint/HomepageTabs.jsp?_fromURL=ElementSetting&isSetting=true&hpid=<%=hpid%>&from=setElement&pagetype=&opt=edit&subCompanyId=<%=subCompanyId%>";
 	//alert(url);
 	showDialog(title,url,top.document.body.clientWidth,top.document.body.clientHeight,true);
}

function showDialog(title,url,width,height,showMax){
		var Show_dialog = new window.top.Dialog();
		Show_dialog.currentWindow = window;   //传入当前window
	 	Show_dialog.Width = width;
	 	Show_dialog.Height = height;
	 	Show_dialog.maxiumnable=showMax;
	 	Show_dialog.Modal = true;
	 	Show_dialog.Title = title;
	 	Show_dialog.URL = url;
	 	Show_dialog.show();
	}
		
function ItemCount_KeyPressNoHen()
{
  if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
  {
     window.event.keyCode=0;
  }
}
//-->
</SCRIPT>




