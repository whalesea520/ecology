
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	int templateId = Util.getIntValue(request.getParameter("templateid"));
	


	//System.out.println("extendtempletid:"+extendtempletid);
	
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";   
	

	String init =Util.null2String(request.getParameter("init"));	
	//初始化数据
	if(init.equals("true")){
		String clearSql = "drop table SystemTemplateTemp ";	
		rs.executeSql(clearSql);
		String copySql = "SELECT * into SystemTemplateTemp from SystemTemplate where id="+templateId;	
		if("oracle".equals((rs.getDBType())))
			copySql = "create table SystemTemplateTemp as select * from SystemTemplate where id="+templateId;
		rs.executeSql(copySql);
		
		
	}
	String initsql = "select * from extendHpWebCustom where templateId="+templateId;
	rs.executeSql(initsql);
	if(!rs.next()){
		initsql = "insert into extendHpWebCustom (templateid) values('"+templateId+"')";
		rs.executeSql(initsql);
	}
	
	String clearSql = "drop table extendHpWebCustomTemp ";
	rs.executeSql(clearSql);
	String copySql = "SELECT * into extendHpWebCustomTemp from extendHpWebCustom where templateId="+templateId;
	if("oracle".equals((rs.getDBType())))
		copySql = "create table extendHpWebCustomTemp as select * from extendHpWebCustom where templateId="+templateId;
	rs.executeSql(copySql);
	
	
		String templateName="",templateTitle="",logo="",isOpen="";
		int extendHpWeb1Id=0;
		int extendtempletid =0;
		boolean saved=false;
		String sql = "SELECT * FROM SystemTemplateTemp WHERE id="+templateId;
		rs.executeSql(sql);
		
		if(rs.next()){
			templateName = rs.getString("templateName");
			templateTitle = rs.getString("templateTitle");								
			isOpen = rs.getString("isOpen").equals("1") ? "1" : "0";
			extendtempletid = rs.getInt("extendtempletid");
			
			String tempextendtempletid = Util.null2String(rs.getString("extendtempletid"));	
			String tempextendtempletvalueid = Util.null2String(rs.getString("extendtempletvalueid"));	

			//System.out.println("tempextendtempletid:"+tempextendtempletid);
			//System.out.println("tempextendtempletvalueid:"+tempextendtempletvalueid);
			if("1".equals(tempextendtempletid)&&!"".equals(tempextendtempletvalueid)) saved=true;
		}

		
		String extendHpWebCustomId="";
		String pagetemplateid="";;	
		String menuid="";
		String menustyleid="";
		String menutype="";
		String useVoting="";
		String useRTX="";
		String useWfNote="";
		String useBirthdayNote="";
		String defaultshow  ="";
		String floatwidth="";
		String floatheight ="";
		String docId ="";
		String docName="";
		String leftmenuid="";
		String leftmenustyleid="";
		String useDoc="";
		rsExtend.executeSql("select * from extendHpWebCustomTemp where templateId="+templateId);
		if(rsExtend.next()){
			extendHpWebCustomId=Util.null2String(rsExtend.getString("id"));
			pagetemplateid=Util.null2String(rsExtend.getString("pagetemplateid"));
			menuid=Util.null2String(rsExtend.getString("menuid"));
			menustyleid=Util.null2String(rsExtend.getString("menustyleid"));
			menutype = Util.null2String(rsExtend.getString("menutype"));
			useVoting=Util.null2String(rsExtend.getString("useVoting"));
			useRTX=Util.null2String(rsExtend.getString("useRTX"));
			useWfNote=Util.null2String(rsExtend.getString("useWfNote"));
			useBirthdayNote=Util.null2String(rsExtend.getString("useBirthdayNote"));
			defaultshow = Util.null2String(rsExtend.getString("defaultshow"));
			floatwidth = Util.null2String(rsExtend.getString("floatWidth"));
			floatheight = Util.null2String(rsExtend.getString("floatHeight"));
			docId = Util.null2String(rsExtend.getString("docId"));
			leftmenuid = Util.null2String(rsExtend.getString("leftmenuid"));
			leftmenustyleid = Util.null2String(rsExtend.getString("leftmenustyleid"));
            useDoc = Util.null2String(rsExtend.getString("useDoc"));
			
			if(!docId.equals("")){
				docName = DocComInfo.getDocname(docId);
			}
		}
		
		
		
	int userid= user.getUID();
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<FORM name="frmAdd" method="post"   action="operation.jsp">
<input  name="method" type="hidden" value="edit"/>
<input name="templateId" type="hidden" value="<%=templateId%>"/>
<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" name="extendtempletid"  value="<%=extendtempletid%>"/>
<input type="hidden" name="fieldname"/>




				
						
						<input type="hidden" name="extendHpWebCustomId"  value="<%=extendHpWebCustomId%>"/>
						
						<wea:layout type="2Col">
						     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
						      <wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
						      <wea:item>
						      		 <input type="hidden" id="oldTemplateName" value="<%=templateName%>">											
											<INPUT class=InputStyle  tblname='SystemTemplate' style="width:50%" id="templateName" name="templateName" value="<%=templateName%>" onchange="updateTemp(this);checkinput('templateName','templateNameImage')">
											<SPAN id="templateNameImage"></SPAN>
						      </wea:item>
						      
						       <wea:item><%=SystemEnv.getHtmlLabelName(18795,user.getLanguage())%></wea:item>
						      <wea:item>
						      		 <INPUT class=InputStyle  style="width:50%"  tblname='SystemTemplate' id="templateTitle" name="templateTitle" value="<%=templateTitle%>" onchange="updateTemp(this)">
						      </wea:item>
						      
						        <wea:item><%=SystemEnv.getHtmlLabelName(23140,user.getLanguage())%></wea:item>
						      <wea:item>
						      		 <select name="pagetemplateid" tblname='extendHpWebCustom' style="" onchange="updateTemp(this)" >
													<%
													int index =0;
													
													
													rs.executeSql("select * from pagetemplate order by id");
													while (rs.next()){
														String selected="";
														if(pagetemplateid.equals("")&&index==0){
															selected = "selected";
														}else if(pagetemplateid.equals(rs.getString("id"))){
															selected = "selected";
														}
														
													%>
													<option value="<%=rs.getString("id")%>" <%=selected%> ><%=rs.getString("templatename")%></option>
													<%
														index++;
													}%>
												</select>
												<%
													if(rs.getCounts()==0){
														%>
														<SPAN id=pagetemplateidSpan><IMG align=absMiddle src="/images/BacoError_wev8.gif"></SPAN>
														<%
													}
												%>
						      </wea:item>
						      
						       <wea:item><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())%></wea:item>
						      <wea:item>
						      		 <select name="menuid" tblname='extendHpWebCustom' style="" onchange="updateTemp(this)">
													<%
													MenuCenterCominfo.setTofirstRow();						
													while(MenuCenterCominfo.next()){	
														if(MenuCenterCominfo.getMenutype().equals("1")){
															continue;
														}
													%>
													<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(menuid)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
													<%}%>
												</select>
						      </wea:item>
						      
						      
						        <wea:item><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage()) + SystemEnv.getHtmlLabelName(1014,user.getLanguage())%></wea:item>
						      <wea:item>
						      	<brow:browser viewType="0" name="menustyleid" browserValue='<%=menustyleid %>' 
									browserOnClick="" _callback="updateTempData" browserUrl="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuh&isDialog=1" 
									hasInput="true" browserDialogWidth="600" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
									
									browserSpanValue='<%=mhsc.getTitle(menustyleid) %>' ></brow:browser>
				
						      		
						      </wea:item>
						      
						      
						          <wea:item><%=SystemEnv.getHtmlLabelName(17596,user.getLanguage())%></wea:item>
						      <wea:item>
						      		 <select name="leftmenuid"  tblname='extendHpWebCustom' style="" onchange="updateTemp(this)">
													<%
													MenuCenterCominfo.setTofirstRow();						
													while(MenuCenterCominfo.next()){	
														if(MenuCenterCominfo.getMenutype().equals("sys")||MenuCenterCominfo.getMenutype().equals("1")){
															continue;
														}
													%>
													<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(leftmenuid)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
													<%}%>
												</select>
						      </wea:item>
						      
						            <wea:item><%=SystemEnv.getHtmlLabelName(17596,user.getLanguage()) +SystemEnv.getHtmlLabelName(1014,user.getLanguage())%></wea:item>
						      <wea:item>
						      		
													<INPUT id="templeftMenuType" type=hidden value="menuv" name="templeftMenuType">
													<brow:browser viewType="0" name="leftmenustyleid" browserValue='<%=leftmenustyleid %>' 
															browserOnClick="" _callback="updateTempData" browserUrl="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuv&isDialog=1" 
															hasInput="true" browserDialogWidth="600" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
															
															browserSpanValue='<%=mvsc.getTitle(leftmenustyleid) %>' ></brow:browser>
				
												
						      </wea:item>
						      
						            <wea:item><%=SystemEnv.getHtmlLabelName(23103,user.getLanguage())%></wea:item>
						      <wea:item>
						      		
											<brow:browser viewType="0" name="defaultshow" browserValue='<%=defaultshow %>'
														browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/HomepageTabs.jsp?_fromURL=pageContent&menutype=2" 
														hasInput="true" _callback="updateTempData" browserDialogWidth="600" isSingle="true" hasBrowser = "true" isMustInput='1'  width="300px"
														  
														browserSpanValue='<%=defaultshow %>'></brow:browser>						
						      </wea:item>
						      
						             <wea:item><%=SystemEnv.getHtmlLabelName(23835,user.getLanguage())%></wea:item>
						      <wea:item>
						      		<input type="checkbox" onclick="updateCheckInfo(this)" name="useVoting" value="1"  <%=useVoting.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%><!--网上调查-->
												<input type="checkbox" onclick="updateCheckInfo(this)" name="useRTX" value="1" <%=useRTX.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(23041,user.getLanguage())%><!--RTX自启动-->
												<input type="checkbox" onclick="updateCheckInfo(this)" name="useWfNote" value="1" <%=useWfNote.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(23042,user.getLanguage())%><!--流程提醒-->
												<input type="checkbox" onclick="updateCheckInfo(this)" name="useBirthdayNote"  value="1" <%=useBirthdayNote.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(17534,user.getLanguage())%><!--生日提醒-->								
												<input type="checkbox" onclick="updateCheckInfo(this)" name="useDoc"  value="1" <%=useDoc.equals("1")?" checked ":""%>><%=SystemEnv.getHtmlLabelName(25881,user.getLanguage())%><!--文档弹出框-->											
						      </wea:item>
						      
						    </wea:group>
						</wea:layout>
									
								

					
</FORM>

</body>
</html>
<script language="javascript">

function updateTemp(obj){
	var name = $(obj).attr("name");
	var value = $(obj).val();
	var tablename = $(obj).attr("tblname")
	
	doUpdateTempData(tablename,name,value);
}
function updateTempData(event,datas,name,_callbackParams){
	doUpdateTempData("extendHpWebCustom",name,datas.id);
}

function updateCheckInfo(obj){
	//alert($(obj).attr("checked"))
	var name = $(obj).attr("name")
	var value = 0;
	
	if($(obj).attr("checked")){
	
		value = 1;
	}
	doUpdateTempData("extendHpWebCustom",name,value);
}



function doUpdateTempData(tbname,field,value){
//alert(tbname+"$"+field+"$"+value)
	$.post("/systeminfo/template/SystemTemplateTempOperation.jsp"
	,{method:'update',tbname:tbname,field:field,value:value},function(data){
	
	})
}


function checkMumber(o)
{
	var value = o.value;
	var r = /^-?[0-9]+$/g;　　//整数 
    var flag = r.test(value);
    if(!flag)
    {
    	alert("<%=SystemEnv.getHtmlLabelName(23086,user.getLanguage())%>!");
    	o.value="";
    	o.focus(true,100);
		return;
    }
}
function chkExtendClick(obj,url){
	if(obj.checked){
		window.location=url;	
	}
}

function checkSubmit(obj){
	if(check_form(frmAdd,"templateName,pagetemplateid")){
		obj.disabled=true;
		document.frmAdd.submit();	
	}
}
function saveAs(obj){
	if(check_form(frmAdd,"templateName,pagetemplateid")){
		//document.getElementById("method").value = "saveas";
		//obj.disabled=true;
		//document.frmAdd.submit();
		if(document.getElementById("templateName").value==document.getElementById("oldTemplateName").value){
			var str="<%=SystemEnv.getHtmlLabelName(18971,user.getLanguage())%>";
			if(confirm(str)){
				document.getElementById("method").value = "saveas";
				obj.disabled=true;
				document.frmAdd.submit();
			}
		}else{
			document.getElementById("method").value = "saveas";
			obj.disabled=true;
			document.frmAdd.submit();
		}		
	}
}
function del(obj){
	if("<%=isOpen%>"=="1"){
		alert("<%=SystemEnv.getHtmlLabelName(18970,user.getLanguage())%>");
		return false;
	}else{
		if(isdel()){
			document.getElementById("method").value = "delete";
			obj.disabled=true;
			document.frmAdd.submit();
		}		
	}
}
function clearMenuType(o)
{	
	var menuType = document.getElementById("menustyleid");
	var spanMenuType = document.getElementById("spanMenuTypeId");
	var tempMenuType = document.getElementById("tempMenuType");
	var mTypes = document.getElementById("menuType");

	menuType.value = "";
	spanMenuType.innerHTML = "";
	tempMenuType.value = o.value;
}
function onShowHpPages(input,span,eid){
     datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=2");
	 if(datas){
		  if(datas.id!= ""){
			   span.innerHTML = "<a href='"+datas.name+"' target='_blank'>" + datas.id +"</a>";
			   input.value=datas.name;
		  }else{
			   span.innerHTML = "";
			   input.value="#";
		  }
	 }
}
function onShowDocs(input,span){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp");
	 if(datas){
		  if(datas.id!= ""){
			   span.innerHTML = "<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"' target='_blank'>" + datas.name +"</a>";
			   input.value=datas.id;
		  }else{
			   span.innerHTML = "";
			   input.value="0";
		  }
	 }
}

</script>
<!--  
<script language=vbs>
sub onShowHpPages(input,span,eid)
		
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=2")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			span.innerHtml = "<a href='"&id(1)&"' target='_blank'>" & id(0) &"</a>"
			input.value=id(1)
		else 
			span.innerHtml = ""
			input.value="#"
		end if
	end if
end sub
sub onShowDocs(input,span)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			span.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
			input.value=id(0)
		else 
			span.innerHtml = ""
			input.value="0"
		end if
	end if
end sub
sub onShowMenuTypes(input,span,menutype)
		menutype = menutype.value
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type="&menutype)
		menulink = ""
		if menutype = "element" then
			menulink = "ElementStyleEdit.jsp"
		ElseIf menutype = "menuh" Then
			menulink = "MenuStyleEditH.jsp"
		else
			menulink = "MenuStyleEditV.jsp"
		end if
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "MenuStyleEditH.jsp<a href='/page/maint/style/"&menulink&"?styleid="&id(0)&"&type="&menutype&"&from=list' target='_blank'>"&id(1)&"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub
</script>
-->
