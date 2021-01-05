<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String nameKey = Util.null2String((String)request.getParameter("fav_pagename"));
	String uri2 = Util.null2String((String)request.getParameter("fav_uri"));
	uri2 = java.net.URLDecoder.decode(uri2);
	String querystring2 = Util.null2String((String)request.getParameter("fav_querystring"));
	if(!"".equals(querystring2)){
		querystring2 = java.net.URLDecoder.decode(querystring2);
	}
	String pagename2 = "";
	if(!"".equals(nameKey)){
		pagename2 = Util.null2String(session.getAttribute(nameKey));
		session.removeAttribute(nameKey);
	}

	if("".equals(pagename2))
	{
		pagename2 = Util.null2String((String) session.getAttribute("fav_pagename"));
	}
	pagename2 = Util.replace(pagename2,"<[^>]+>","",0);
	if("".equals(uri2))
	{
		uri2 = Util.null2String((String) session.getAttribute("fav_uri"));
	}
	if(uri2.indexOf("ManageRequestNoForm.jsp")>0)
	{
		uri2 = uri2.replaceFirst("ManageRequestNoForm.jsp","ViewRequest.jsp");
	}
	else if(uri2.indexOf("ManageRequestNoFormBill.jsp")>0)
	{
		
		uri2 = uri2.replaceFirst("ManageRequestNoFormBill.jsp","ViewRequest.jsp");
	}
	else if(uri2.indexOf("ManageRequestNoFormMode.jsp")>0)
	{
		
		uri2 = uri2.replaceFirst("ManageRequestNoFormMode.jsp","ViewRequest.jsp");
	}
	if("".equals(querystring2))
	{
		querystring2 = Util.null2String((String) session.getAttribute("fav_querystring"));
	}
	String getpagename = request.getParameter("currentpagename");
	String getpurl = request.getParameter("currenturl");
	
	String action = request.getParameter("action");
	if("".equals(action)||null==action)
	{
		action = "addpage";
	}
	String sysfavouriteids =Util.null2String(request.getParameter("sysfavouriteids"));
	//out.println("sysfavouriteids : "+sysfavouriteids);
	//System.out.println("getpurl : "+getpurl);
	String urlname = "";
	
	if (!querystring2.equals(""))
	{
		querystring2 = Util.replaceChar(querystring2, '^', '&');
		if(querystring2.indexOf("?")==0)
		{
			urlname = uri2 + querystring2+"&addfavourite=1";
		}
		else
		{
			urlname = uri2 + "?" + querystring2+"&addfavourite=1";
		}
	}
	else
	{
		urlname = uri2;
	}
	if(!"".equals(getpurl)&&null!=getpurl)
	{
		urlname = getpurl;
		if(!"".equals(getpagename)&&null!=getpagename)
		{
			pagename2 = getpagename;
		}
		else
		{
			pagename2 = "";
		}
	}
	String favtype = "5";   //默认是其他
	/**根据url判断收藏的类型  start*/
	if(urlname != null && !"".equals(urlname)){
		if(urlname.startsWith("/docs/")){   //文档
			favtype = "1";
		}else if(urlname.startsWith("/workflow/")){  //流程
			favtype = "2";
		}else if(urlname.startsWith("/proj/")){ //项目
			favtype = "3";
		}else if(urlname.startsWith("/CRM/")){  //客户
			favtype = "4";
		}else{   //其他
			favtype = "5";
		}
	}
	/**根据url判断收藏的类型  end*/
	String imageStyle = "";
	if("".equals(pagename2))
	{
		imageStyle = "visible";
	}
	else
	{
		imageStyle = "hidden";
	}
	//pagename = Util.toHtml10(pagename);
	//System.out.println("pagename : "+pagename);

	String imagefilename = "/images/hdReport.gif";
	String titlename = "";
	String needfav ="1";
	String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<HTML>
	<HEAD>
		<%if(user.getLanguage()==7) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-cn-gbk_wev8.js'></script>
		<%
		}
		else if(user.getLanguage()==8) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-en-gbk_wev8.js'></script>
		<%
		}
		else if(user.getLanguage()==9) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-tw-gbk_wev8.js'></script>
		<%
		}
		%>
		<link rel="stylesheet" type="text/css"
			href="/js/extjs/resources/css/ext-all_wev8.css" />
		<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
		<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
		function checkPageName()
		{
			var pagename = document.getElementById("pagename").value;
			var checkPageName = document.getElementById("checkPageNameimg");
			pagename = pagename.replace(/(^\s*)|(\s*$)/g, "");
			if(pagename=="")
			{
				checkPageName.style.visibility = "visible";
			}
			else
			{
				checkPageName.style.visibility = "hidden";
			}
		}
		try{
			var tabObjName = "<%=SystemEnv.getHtmlLabelName(28111,user.getLanguage())%>";//收藏管理
			parent.setTabObjName(tabObjName);
		}catch(e){
			if(window.console)console.log(e);
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
		//alert("parentWin : "+parentWin);
		function closeDialog(){
			//alert(dialog);
			if(dialog)
			{
				if(parentWin.reloadTree){
					parentWin.reloadTree();  //弹出窗口，关闭时，刷新左侧的树，因为可能新建了收藏夹目录
				}
				dialog.close();
			}else{
			    window.parent.close();
			}
		}
		</script>
		<style>
			input{
				font-family:Verdana;
    			font-size:11px;
			}
		</style>
		<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
	</HEAD>
	<BODY onload="initFavouriteDiv();">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" onclick="submitData()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())%>"></input>
					<input type="button" onclick="addfavourite()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(20002,user.getLanguage())%>"></input>
					<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
	
		<div class="zDialog_div_content">
		<SPAN id=BacoTitle style="display:none;"><%=pagename2%></SPAN>
		<FORM NAME=SearchForm STYLE="margin-bottom: 0;" action="javascript:void(0);" method=post>
			<%if(!"append".equals(action)&&!"appendanddel".equals(action)){ %>
				<wea:layout>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
							<wea:item><span style="vertical-align:middle"><%=SystemEnv.getHtmlLabelName(22426, user.getLanguage())%></span></wea:item>
							<wea:item>
									<input name=pagename id=pagename value='' width="100%" style="width:60%" onblur="javascript:checkPageName();"><img id="checkPageNameimg" src="/images/BacoError_wev8.gif" align="absmiddle" style="visibility:<%=imageStyle %>">
							</wea:item>
							<wea:item><span style="vertical-align:middle"><%=SystemEnv.getHtmlLabelName(18178, user.getLanguage())%></span></wea:item>
							<wea:item>		
									<INPUT id="importlevel" type=radio name="importlevel" checked=true value="1"><%=SystemEnv.getHtmlLabelName(154, user.getLanguage())%>
									<INPUT id="importlevel" type=radio name="importlevel" value="2"><%=SystemEnv.getHtmlLabelName(25436, user.getLanguage())%>
									<INPUT id="importlevel" type=radio name="importlevel" value="3"><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%>
							</wea:item>
							<wea:item><span style="vertical-align:middle"><%=SystemEnv.getHtmlLabelName(22242, user.getLanguage())%></span></wea:item>
							<wea:item>	
									<INPUT id="favouritetype" type=radio name="favouritetype" <%if("1".equals(favtype)){out.println("checked=true");} %> value="1"><%=SystemEnv.getHtmlLabelName(22243, user.getLanguage())%>
									<INPUT id="favouritetype" type=radio name="favouritetype" <%if("2".equals(favtype)){out.println("checked=true");} %> value="2"><%=SystemEnv.getHtmlLabelName(22244, user.getLanguage())%>
									<INPUT id="favouritetype" type=radio name="favouritetype" <%if("3".equals(favtype)){out.println("checked=true");} %> value="3"><%=SystemEnv.getHtmlLabelName(22245, user.getLanguage())%>
									<INPUT id="favouritetype" type=radio name="favouritetype" <%if("4".equals(favtype)){out.println("checked=true");} %> value="4"><%=SystemEnv.getHtmlLabelName(21313, user.getLanguage())%>
									<INPUT id="favouritetype" type=radio name="favouritetype" <%if("5".equals(favtype)){out.println("checked=true");} %> value="5"><%=SystemEnv.getHtmlLabelName(375, user.getLanguage())%>
							</wea:item>
					   </wea:group>
				</wea:layout>
			<%
			}
			%>
			
		
		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(22246,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
				<wea:item attributes="{'colspan':'2'}">
						<INPUT TYPE=radio ID=favouriteid value="-1" name=favouriteid title="<%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%>" <%if(!"append".equals(action)&&!"appendanddel".equals(action)){ %>checked<%} %>>
						<img align="absmiddle" src="/images/folder.fav_wev8.png">
						<span>
							<%=SystemEnv.getHtmlLabelName(18030, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22247, user.getLanguage())%>
						</span>
				</wea:item>
				<wea:item attributes="{'colspan':'2'}">
					<div id="favouritediv" style="overflow-y:scroll;width:100%;height:370px">
						<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%">
							<%
								String sql = " select * from favourite where resourceid="
										+ user.getUID() + " order by displayorder,adddate desc ";
								
								rs.executeSql(sql);
								List idsList = new ArrayList();
								List namesList = new ArrayList();
								while (rs.next())
								{
									String id = rs.getString("id");
									String name = rs.getString("favouritename");
									idsList.add(id);
									namesList.add(name);
								}
								int count = idsList.size();
								//System.out.println("count : " + count + " -- trcount : " + trcount);
								if (count > 0)
								{
									for (int i = 0; i < count; i++)
									{
								%>
										<TR class=DataLight width="100%">
											<td width="100%" title="<%=namesList.get(i)%>">
												<INPUT TYPE=radio name="favouriteid"
													value="<%=idsList.get(i)%>">
												<img align="absmiddle"  src="/images/folder.fav_wev8.png">
												<input type="text" value="<%=namesList.get(i)%>"
													id="favouritename" name="favouritename" readonly="true"
													style="background-color: transparent; border: 0px; width: 50%"
													width="50%" ondblclick="javascript:editfavourite('<%=idsList.get(i)%>',this);" _noMultiLang="true">
											</td>
										</tr>
								<%
									}
								}
								%>
						</TABLE>
					</div>
				</wea:item>
			</wea:group>
		</wea:layout>
			<input type="hidden" name="sysfavouriteids" value="<%=sysfavouriteids %>" id="sysfavouriteids">
			<input type="hidden" name="action" value="<%=action %>" id="action">
			<input type="hidden" name="urlname" value="<%=urlname %>" id="urlname">
		</FORM>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='closeDialog();'></input>
					</wea:item>
				</wea:group>
			</wea:layout>
			<script type="text/javascript">
				jQuery(document).ready(function(){
					resizeDialog(document);
				});
			</script>
		</div>
		</div>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

		<%
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(16631, user.getLanguage())
					+ ",javascript:submitData(),_top} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(20002, user.getLanguage())
					+ ",javascript:addfavourite(),_top} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	</BODY>
</HTML>
<script language="javascript">
if (window.addEventListener){
    window.addEventListener("load", removeFavouriteMenu, false);
}else if (window.attachEvent){
    window.attachEvent("onload", removeFavouriteMenu);
}else{
    window.onload=removeFavouriteMenu;
}
function removeFavouriteMenu(){
	try
	{
		//alert(document.getElementById("rightMenuIframe").contentWindow.document.body.innerHTML);
		//alert(jQuery(document.getElementById("rightMenuIframe").contentWindow.document).html());
		jQuery(window.frames["rightMenuIframe"].document.getElementById("menuTable")).find("button[onclick*='openFavouriteBrowser']").parent().parent().parent().remove();
	}
	catch(e)
	{
		//alert(e);
	}
}
function initFavouriteDiv()
{
	var action = "<%=action %>";
	if(action == "append"||action == "appendanddel")
	{
		 var favouritediv = document.getElementById("favouritediv");
		 favouritediv.style.height = "384px";
	}
	else
	{
		var favouritediv = document.getElementById("favouritediv");
		 favouritediv.style.height = "260px";
	}
	var BacoTitle = jQuery("#BacoTitle");
	if(BacoTitle)
	{
		var pagename = BacoTitle.html();
		var pagenameele = document.getElementById("pagename");
		if(pagenameele)
		{
			pagenameele.value=pagename;
		}
	}
}

function checkPageNameLen(elementname,len,fieldname,msg,msg1){
    len = len*1;
    var str = $GetEle(elementname).value;
    // 处理$GetEle可能找不到对象时的情况，通过id查找对象
    if(str == undefined) {
        str = document.getElementById(elementname).value;
    }

    if(len!=0 && realLength(str) > len){
        window.top.Dialog.alert(fieldname + msg + len + "," + "(" + msg1 + ")");
        while(true){
            str = str.substring(0, str.length - 1);
            if(realLength(str) <= len){
                $GetEle(elementname).value = str;
                break;
            }
        }
        return false;
    }
    return true;
}

function submitData()
{
	var action = document.getElementById("action").value;
	var urlname = "";
	var pagename = "";
	var importlevel = "";
	var favouritetype = "";
	if(action=="addpage")
	{
		urlname = document.getElementById("urlname").value;
		//alert("urlname : "+urlname);
		pagename = document.getElementById("pagename").value;
		pagename = pagename.replace(/(^\s*)|(\s*$)/g, "");
		if(pagename=="")
		{
			top.Dialog.alert(favourite.other.pagenamenull);
			document.getElementById("pagename").focus();
			return;
		}
		importlevel = document.getElementsByName("importlevel");
		favouritetype = document.getElementsByName("favouritetype");
		for(var i=0;i<importlevel.length;i++)
		{
			if(importlevel[i].checked)
			{
				importlevel =importlevel[i].getAttribute("value");
				break;
	   		}
		}
		for(var i=0;i<favouritetype.length;i++)
		{
			if(favouritetype[i].checked)
			{
				favouritetype =favouritetype[i].getAttribute("value");
				break;
	   		}
		}
	}

    var checkResult = checkPageNameLen('pagename','150','<%=SystemEnv.getHtmlLabelName(22426,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');
	if(!checkResult){
	    return;
	}

	var checkfavouriteids = document.getElementsByName("favouriteid");
	var savefavouriteid = "";
	var sysfavouriteids = document.getElementById("sysfavouriteids").value;
	if(checkfavouriteids.length>0)
	{
		for(var i=0;i<checkfavouriteids.length;i++)
		{
			if(checkfavouriteids[i].checked==true)
			{
				savefavouriteid =savefavouriteid+","+checkfavouriteids[i].getAttribute("value");
	   		}
		}
		if(savefavouriteid =="")
		{
			top.Dialog.alert(favourite.other.selectfavourite); 
			return;
		}
		//alert("ddddddddddddddd dialog : "+dialog+" action : "+action );
		//alert("savefavouriteid : "+savefavouriteid);
		Ext.Ajax.request({
       		url: '/favourite/SysFavouriteOperationAjax.jsp',
       		method: 'POST',
       		params: 
       		{
       		 	action: action,
       		 	favouriteid: savefavouriteid,
       		 	link: urlname,
       		 	title: pagename,
       		 	importlevel: importlevel,
       		 	favouritetype:favouritetype,
       		 	sysfavouriteid:sysfavouriteids
       		},
       		success: function(response, request)
			{
				//alert("eeeeeeeeeeeeeee dialog : "+dialog);
				var data = eval('(' + response.responseText + ')');
			    var flag = data.flag;
		      	var errorInfo = data.errorInfo;
				if(action=="append")
				{
					if(flag != undefined && flag != null && flag == false){
			        	Dialog.alert(errorInfo);
			        	return;
				  	}
					top.Dialog.alert(favourite.maingrid.copy+favourite.window.success);
				}
				else if(action=="appendanddel")
				{
					if(flag != undefined && flag != null && flag == false){
			        	Dialog.alert(errorInfo);
			        	return;
				  	}
					top.Dialog.alert(favourite.maingrid.move+favourite.window.success);
				}
				else
				{
					if(flag != undefined && flag != null && flag == false){
			        	Dialog.alert(errorInfo);
			        	return;
				  	}
					top.Dialog.alert(favourite.other.savetopic,null,null,null,null,{_autoClose:2});  //添加收藏成功后，提示框2s自动关闭
				}
				//window.parent.close();
				if(dialog)
				{
				    try
				    {
				    	closeDialog();
				    	parentWin.reloadTable();
				    }
				    catch(e)
				    {
				    	
				    }
				}else{
				    window.parent.returnValue  = 1;
				    window.parent.close();
				}
			},
       		failure: function ( result, request) 
       		{
       			if(action=="append")
				{
					top.Dialog.alert(favourite.maingrid.copy+favourite.window.failure);
				}
				else if(action=="appendanddel")
				{
					top.Dialog.alert(favourite.maingrid.move+favourite.window.failure);
				}
				else
					top.Dialog.alert(favourite.other.addfailure); 
				if(dialog)
				{
				    try
				    {
				    	closeDialog();
				    	parentWin.reloadTable();
				    }
				    catch(e)
				    {
				    	
				    }
				}else{
				    window.parent.returnValue  = 1;
				    window.parent.close();
				}
			},
       		scope: this
   		  });
	}
}
function addfavourite()
{
	var BrowseTable = document.getElementById("BrowseTable");
	var currentcount = BrowseTable.rows.length;
	var newtr = BrowseTable.insertRow(currentcount);
	newtr.setAttribute("class","DataLight");
						
	var newtd = document.createElement("td");
	var newcinput = document.createElement("input");
	newcinput.setAttribute("type","radio");
	newcinput.setAttribute("id","newcinput");
	newcinput.setAttribute("name","favouriteid");
	newcinput.setAttribute("value","");
	newcinput.style.marginRight ="10px"; 
	var newimg = document.createElement("img");
	newimg.setAttribute("src","/images/folder.fav_wev8.png");
	newimg.setAttribute("align","absmiddle");
	newimg.style.paddingLeft ="6px";
	
	
	var newinput = document.createElement("input");
	newinput.setAttribute("type","text");
	newinput.setAttribute("id","newfavourite");
	newinput.setAttribute("name","newfavourite");
	newinput.setAttribute("_noMultiLang","true");
	//newinput.setAttribute("maxLength","20");  //设置最多输入的字符数
	
	newinput.onblur = Function("return savefavourite();");
	newinput.setAttribute("value",favourite.other.newfa);
	newinput.setAttribute("_value",favourite.other.newfa);
	newinput.setAttribute("width","50%");
	newinput.style.width="60%";
	newinput.style.paddingLeft ="5px";
	newtd.appendChild(newcinput);
	newtd.appendChild(newimg);
	newtd.appendChild(newinput);
	newtr.appendChild(newtd);
	jQuery(newtr).jNice();
	newinput.focus(); 
}
function editfavourite(favouriteid,input)
{
	input.focus();
	var oldid = input.id;
	var oldname = input.name;
	var oldvalue = input.value;
	input.readOnly = false;
	input.style.backgroundColor ="";
	input.style.border = "1px inset #00008B";
	input.style.width = "60%";
	input.id="editfavourite";
	input.name="editfavourite";
	//input.setAttribute("maxLength","20");  //设置最多输入的字符数
	input.ondblclick=Function("return void(0);");
	input.setAttribute("name","editfavourite");
	input.onblur =function saveFavourite()
				  {
						checkLength('editfavourite','150','<%=SystemEnv.getHtmlLabelName(28111,user.getLanguage())+SystemEnv.getHtmlLabelName(32452,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');
					  	var name = input.value;
					  	name = name.replace(/(^\s*)|(\s*$)/g, "");
						if(name=="")
						{
							top.Dialog.alert(favourite.other.fanamenull);
							input.value = oldvalue;
							input.focus(); 
							input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
							return;
						}
						else if(name==oldvalue)
						{
							input.setAttribute("id",oldid);
           					input.setAttribute("name",oldname);
           					input.style.backgroundColor = "transparent";
           					input.style.border = "0px";
           					input.style.width = "60%";
           					input.readOnly = "true";
           					input.focus(); 
           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
           					input.onblur = "";
           					return;
						}
						else
						{
							var oldfavourites = document.getElementsByName("favouritename");
							if(oldfavourites.length>0)
							{
								for(var i=0;i<oldfavourites.length;i++)
								{
									if(oldfavourites[i].getAttribute("value")==name&&oldfavourites[i]!=input)
									{
										top.Dialog.alert(favourite.other.fanameexist);
										input.focus(); 
										input.value = name+oldfavourites.length;
										input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
										return;
									}
								}
							}
						}
						Ext.Ajax.request({
			       		url: '/favourite/FavouriteOperationAjax.jsp',
			       		method: 'POST',
			       		params: 
			       		{
			       		 	action: "editname",
			       		 	favouriteid:favouriteid,
			       		 	favouritename:name
			       		},
			       		success: function(response, request)
						{
			   				try
			   				{
			   					var responseArray = Ext.decode(response.responseText);
				   				var flag = responseArray.flag;
				  		        var errorInfo = responseArray.errorInfo;
				  		        if(flag != undefined && flag != null && flag == false){
				  		        	Dialog.alert(errorInfo);
				  		        	return;
				  			    }
							 	if(responseArray.databody.length>0)
							 	{
		           					input.setAttribute("id",oldid);
		           					input.setAttribute("name",oldname);
		           					input.style.backgroundColor = "transparent";
		           					input.style.border = "0px";
		           					input.style.width = "60%";
		           					input.readOnly = "true";
		           					input.focus(); 
		           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
		           					input.onblur = "";
							 	}
			    				else
			    				{
			    					input.value = oldvalue;
									input.setAttribute("id",oldid);
		           					input.setAttribute("name",oldname);
		           					input.style.backgroundColor = "transparent";
		           					input.style.border = "0px";
		           					input.style.width = "60%";
		           					input.readOnly = "true";
		           					input.focus(); 
		           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
		           					input.onblur = "";
			    					top.Dialog.alert(favourite.window.failure);
			    				}
			   				 }
			   				 catch(e)
			   				 {
			   
			   				 }
						},
			       		failure: function ( result, request) 
			       		{ 
							input.value = oldvalue;
							input.setAttribute("id",oldid);
           					input.setAttribute("name",oldname);
           					input.style.backgroundColor = "transparent";
           					input.style.border = "0px";
           					input.style.width = "60%";
           					input.readOnly = "true";
           					input.focus(); 
           					input.ondblclick=Function("return editfavourite("+favouriteid+",this);");
           					input.onblur = "";
           					top.Dialog.alert(favourite.window.failure); 
						},
			       		scope: this
			   		  });
				  };
}
function savefavourite()
{
	var favouritename = document.getElementById("newfavourite");
	checkLength('newfavourite','150','<%=SystemEnv.getHtmlLabelName(28111,user.getLanguage())+SystemEnv.getHtmlLabelName(32452,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');
	var name = document.getElementById("newfavourite").value;
	var _oldvalue = favouritename.getAttribute("_value");
	name = name.replace(/(^\s*)|(\s*$)/g, "");
	if(name=="")
	{
		favouritename.value = _oldvalue;
		top.Dialog.alert(favourite.other.fanamenull);
		favouritename.focus(); 
		return;
	}
	else
	{
		var oldfavourites = document.getElementsByName("favouritename");
		if(oldfavourites.length>0)
		{
			for(var i=0;i<oldfavourites.length;i++)
			{
				if(oldfavourites[i].getAttribute("value")==name)
				{
					top.Dialog.alert(favourite.other.fanameexist);
					favouritename.focus(); 
					document.getElementById("newfavourite").value = name+oldfavourites.length;
					document.getElementById("newfavourite").setAttribute("_value",name+oldfavourites.length);
					return;
				}
			}
		}
	}
	Ext.Ajax.request({
           		url: '/favourite/FavouriteOperationAjax.jsp',
           		method: 'POST',
           		params: 
           		{
           		 	action: "add",
           		 	favouritename:name
           		},
           		success: function(response, request)
   				{
       				try
       				{
           				var result = response.responseText;
           				var responseArray = Ext.decode(response.responseText);
           				var flag = responseArray.flag;
		  		        var errorInfo = responseArray.errorInfo;
		  		        if(flag != undefined && flag != null && flag == false){
		  		        	Dialog.alert(errorInfo);
		  		        	return;
		  			    }
					 	if(responseArray.databody.length>0)
					 	{
					 		var favouriteid = responseArray.databody[0].id;
           					favouritename.onblur = "";
           					favouritename.ondblclick=Function("return editfavourite("+favouriteid+",this);");
           					var newcinput = document.getElementById("newcinput");
           					newcinput.setAttribute("id","favouriteid");
           					newcinput.setAttribute("name","favouriteid");
           					newcinput.setAttribute("value",favouriteid);
           					
           					var newinput = document.getElementById("newfavourite");
           					newinput.setAttribute("id","favouritename");
           					newinput.setAttribute("name","favouritename");
           					newinput.parentNode.title = name;
           					newinput.style.backgroundColor = "transparent";
           					newinput.style.border = "0px";
           					newinput.style.width = "60%";
           					newinput.readOnly = "true";
           					newinput.focus();
           				}
       				 }
       				 catch(e)
       				 {
       
       				 }
   				},
           		failure: function ( result, request) 
           		{ 
   					top.Dialog.alert(favourite.other.addfafailure); 
				},
           		scope: this
       		  });
}

function checkLength(elementname,len,fieldname,msg,msg1) {
    len = len*1;
    var str = $GetEle(elementname).value;
    // 处理$GetEle可能找不到对象时的情况，通过id查找对象
    if(str == undefined) {
        str = document.getElementById(elementname).value;
    }
    
    if(len!=0 && realLength(str) > len){
    	top.Dialog.alert(fieldname + msg + len + "," + "(" + msg1 + ")");
        while(true){
            str = str.substring(0, str.length - 1);
            if(realLength(str) <= len){
                $GetEle(elementname).value = str;
                return;
            }
        }
    }
}
</script>
