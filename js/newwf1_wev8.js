function initNewRequestFrame1(viewdoc)
{
	//document.body.scroll ="no";
	jQuery(document.body).attr("scroll", "no");
	jQuery(document.body).css("overflow", "hidden");
	jQuery(document.body).addClass("ext-ie");
	//document.body.className += " ext-ie";

//	document.getElementById("WfBillIframeDiv").appendChild(document.getElementById("divBill"));
//	document.getElementById("WfBillIframeDiv").style.display = "none";
//    document.getElementById("WfPicIframeDiv").style.display = "none"
//    document.getElementById("WfLogIframeDiv").style.display = "none"
    //document.getElementById("divWfBill").style.display = "";
	//document.getElementById("divWfPic").style.display = "none";
	//document.getElementById("divWfLog").style.display = "none";
	if(viewdoc==1){
		jQuery("#divWfText").css("display", "");
		jQuery("#divWfTextTab").click();	
	}else{
		jQuery("#divWfBill").css("display", "");
	}
	jQuery("#divWfPic").css("display", "none");
	jQuery("#divWfLog").css("display", "none");
	setToolBarMenu1();
}
function setToolBarMenu1()
{
//	var toolbarmenu = document.getElementById("toolbarmenu");
	var toolbarmenudiv = document.getElementById("toolbarmenudiv");
//	var newtd = document.createElement("td");
//	jQuery(toolbarmenu).append(newtd);

	//jQuery(toolbarmenudiv).html("");
	
	jQuery(toolbarmenudiv).css("background","#eaeaea");

	var div1=jQuery("<div></div>");

	var div10;
	if((typeof requestlevalicon)!=='undefined')
	div10=jQuery("<div  style='float:left;margin-top: -3px;margin-left: -3px;margin-right: 8px;'>"+requestlevalicon+"</div>");
	var div11=jQuery("<div id='BacoTitle'>"+wftitle+"</div>");
	var div12=jQuery("<div></div>");
	var div13=jQuery("<div></div>");
	
	var div14=jQuery("<div unselectable='on' class='b-m-mpanel' style='background-color:#fff;width:120px;'></div>");//菜单

	//jQuery(toolbarmenudiv).append(div1);

    if((typeof requestlevalicon)!=='undefined')
	div1.append(div10);
	div1.append(div11);
	div1.append(div13);
	div1.append(div12);

	div11.css("float","left");
	div12.css("float","right");
	div13.css("float","right");
	
	div11.css("height","26px");
	div11.css("line-height","26px");


    var aplit;
	if(bar!="" && bar != undefined && bar != null){
		var rightClientMenublock = jQuery("#rightclickcornerMenu");
		for(var i = 0;i<bar.length;i++){
			var bare = bar[i];
			//alert(bare.text + ", " + bare.iconCls);
			if(btnIsShow(bare.iconCls)){
				try {
					var btnclass = " class='e8_btn_top_disabled' ";
					if (i == 0) {
						btnclass = " class='e8_btn_top_first_disabled' _disabled='true' ";
					}
					
					var temphandler = (bare.handler + "").replace("function (){", "");
					var temphandler = temphandler.replace("function(){", "");
					var temphandler = temphandler.replace("}", "");
					var menuItem = "<input type='button' " + btnclass + " value='" + bare.text + "' onclick='" + temphandler + "'/>	";
					rightClientMenublock.before(menuItem);
				} catch (e) {}
			}
			/*
			var newSpan= jQuery("<div><TABLE style='WIDTH: auto' class='x-btn  x-btn-text-icon' onmouseout='resetButtonClass(this,1);' onmouseover='resetButtonClass(this,2);' onclick='new "+bare.handler+"' cellSpacing=0>"+
							  "		<TBODY class='x-btn-small x-btn-icon-small-left'>"+
							  "			<TR><TD class=x-btn-tl><I>&nbsp;</I></TD><TD class=x-btn-tc></TD><TD class=x-btn-tr><I>&nbsp;</I></TD></TR>"+
							  "			<TR><TD class=x-btn-ml><I>&nbsp;</I></TD>"+
							  "				<TD class=x-btn-mc><EM unselectable='on'><BUTTON class='x-btn-text "+bare.iconCls+"'>"+bare.text+"</BUTTON></EM></TD>"+
							  "				<TD class=x-btn-mr><I>&nbsp;</I></TD>"+
							  "			</TR>"+
							  "			<TR><TD class=x-btn-bl><I>&nbsp;</I></TD><TD class=x-btn-bc></TD><TD class=x-btn-br><I>&nbsp;</I></TD></TR>"+
							  "		</TBODY>"+
							  "	</TABLE><div>");
			if(btnIsShow(bare.iconCls)){
				newSpan= jQuery("<a href='javascript:new "+bare.handler+"'>"+bare.text+"</a>");
				aplit=jQuery("<font color='#ddd' style='float:left;margin-right:9px;'>|</font>");
                
				div12.append(newSpan);
                div12.append(aplit);
                newSpan.css("float","left");
				newSpan.css("margin-right","10px");
			}else{
				newSpan=jQuery("<div unselectable='on' class='b-m-item' onmouseover=\"this.className='b-m-ifocus'\" onmouseout=\"this.className='b-m-item'\">"+
							   "	<div class='b-m-ibody' unselectable='on'>"+
							   "		<nobr unselectable='on'>"+
							   "			<img width='16' src="+btnImage(bare.iconCls)+" align='absmiddle'/>"+
							   "			<button style='width:120px;'>"+bare.text+"</button>"+
							   "		</nobr>"+
							   "	</div>"+
							   "</div>");
				div14.append(newSpan);
				
				newSpan.click(bare.handler);

				// onclick='new "+bare.handler
				//newSpan.css("margin","5px");
			}
			*/
		}
	}
/**	var image=["btn_draft","btn_edit","btn_doReopen","btn_doViewModifyLog","btn_newWFName","btn_newSMSName","btn_relateCwork","btn_next"];
	var text=["编辑","流转设定","重新打开","表单日志","新建流程","新建短信","触发子流程","启用"];
	for(var k=0;k<image.length;k++){
		newSpan= jQuery("<div><TABLE style='WIDTH: auto' class='x-btn  x-btn-text-icon' onmouseout='resetButtonClass(this,1);' onmouseover='resetButtonClass(this,2);' cellSpacing=0>"+
							  "		<TBODY class='x-btn-small x-btn-icon-small-left'>"+
							  "			<TR><TD class=x-btn-tl><I>&nbsp;</I></TD><TD class=x-btn-tc></TD><TD class=x-btn-tr><I>&nbsp;</I></TD></TR>"+
							  "			<TR><TD class=x-btn-ml><I>&nbsp;</I></TD>"+
							  "				<TD class=x-btn-mc><EM unselectable='on'><BUTTON class='x-btn-text "+image[k]+"'>"+text[k]+"("+image[k]+")</BUTTON></EM></TD>"+
							  "				<TD class=x-btn-mr><I>&nbsp;</I></TD>"+
							  "			</TR>"+
							  "			<TR><TD class=x-btn-bl><I>&nbsp;</I></TD><TD class=x-btn-bc></TD><TD class=x-btn-br><I>&nbsp;</I></TD></TR>"+
							  "		</TBODY>"+
							  "	</TABLE><div>");
			div14.append(newSpan);
			newSpan.css("margin","5px");
	}
**/
//	div12.append("<font color='#888888'>|</font>");
	div12.css("height","26px");
	div12.css("line-height","26px");
	div12.css("margin-right","0px");

	div13.css("width","26px").css("height","26px").css("cursor","pointer").css("background-image","url(/images/ecology8/request/cornerMenu_wev8.png)").css("background-repeat","no-repeat").css("background-position","center center");
	div13.css("margin-right","5px");

	var div=jQuery("<div></div>");
	jQuery(document.body).append(div);
	var iframe=jQuery("<iframe id='modeTitle' name='modeTitle' frameborder='0' marginheight='0' marginwidth='0' hspace='0' vspace='0' scrolling='no' src='/workflow/request/WorkflowBlank.jsp'></iframe>");
	div.append(iframe);
	div.css("position","absolute").css("top","32px").css("left",jQuery(toolbarmenudiv).width()-120);
	//console.dir(jQuery('#modeTitle').contents().body);
	iframe.load(function (){
		load(div14);
	});
	div.css("height","auto");
	div.css("display","none");
	div.css("height",div14.find("img").length*22+10);
	iframe.css("height",div14.find("img").length*22+10);

	div13.click(function (e){
		if(div.css("display")=="none"){
			div.css("display","")
		}else{
			div.css("display","none");
		}
		e.stopPropagation();
	});

//	bodyiframe


	//jQuery(jQuery('#modeTitle').contents().body).append(div14);
	//iframe.contents().find("#temp").append(div14);
/**
	//if(document.all){
	if(window.navigator.appName == "Microsoft Internet Explorer"){
		jQuery(document.body).append(div14);
		div14.css("position","absolute")
	}else{
		div1.append(div14);
		div14.css("position","fixed")
	}**/
	div14.css("background-color","#fff").css("border","1px solid #ccc");
	jQuery(toolbarmenudiv).css("display", "");
		
/**	if(bar!="" && bar != undefined && bar != null)
	{
	//	console.dir(bar);
	//	console.log("wftitle:"+wftitle);
		for(var i = 0;i<bar.length;i++)
		{
			var bare = bar[i];
			var newtd = document.createElement("td");
			newtd.className = "";
			//newtd.innerHTML = "<BUTTON class='nx-btn-text "+bare.iconCls+"' onmouseout='resetButtonClass(this,1);' onmouseover='resetButtonClass(this,2);' onclick='new "+bare.handler+"'>"+bare.text+"</BUTTON>";
			newtd.innerHTML = "<TABLE style='WIDTH: auto' class='x-btn  x-btn-text-icon' onmouseout='resetButtonClass(this,1);' onmouseover='resetButtonClass(this,2);' onclick='new "+bare.handler+"' cellSpacing=0>"+
							  "		<TBODY class='x-btn-small x-btn-icon-small-left'>"+
							  "			<TR><TD class=x-btn-tl><I>&nbsp;</I></TD><TD class=x-btn-tc></TD><TD class=x-btn-tr><I>&nbsp;</I></TD></TR>"+
							  "			<TR><TD class=x-btn-ml><I>&nbsp;</I></TD>"+
							  "				<TD class=x-btn-mc><EM unselectable='on'><BUTTON class='x-btn-text "+bare.iconCls+"'>"+bare.text+"</BUTTON></EM></TD>"+
							  "				<TD class=x-btn-mr><I>&nbsp;</I></TD>"+
							  "			</TR>"+
							  "			<TR><TD class=x-btn-bl><I>&nbsp;</I></TD><TD class=x-btn-bc></TD><TD class=x-btn-br><I>&nbsp;</I></TD></TR>"+
							  "		</TBODY>"+
							  "	</TABLE>"
			//toolbarmenu.appendChild(newtd);
			jQuery(toolbarmenu).append(newtd);
		}
		if(toolbarmenudiv)
		{
			//toolbarmenudiv.style.display="";
			jQuery(toolbarmenudiv).css("display", "");
		}
	}
	else
	{
		//toolbarmenudiv.style.display="none";
		jQuery(toolbarmenudiv).hide();
	}
	**/
}
function load(div14){
	//alert(112);
	//console.dir(jQuery('#modeTitle').contents()[0]);
	jQuery(jQuery('#modeTitle').contents().get(0).body).append(div14);
}
function btnIsShow(icon){
	var iconList=["btn_submit", "btn_draft","btn_subbackName","btn_wfSave","btn_freeWf","btn_subnobackName","btn_forward","btn_forwardback3","btn_rejectName","btn._doDelete","btn_print","btn_Supervise", "btn_doIntervenor"];
	//var iconList=["btn_submit", "btn_draft","btn_subbackName","btn_wfSave","btn_subnobackName","btn_doDrawBack","btn_doRetract","btn_rejectName","btn_doDelete","btn_print","btn_Supervise", "btn_doIntervenor"];
	for(var i=0;i<iconList.length;i++){
		if(iconList[i]==icon){
			return true;
		}
	}
	return false;
}
function btnImage(iconCls){
	var src="";
	switch(iconCls){
		case "btn_draft":src="/images/wf/title/draft_wev8.png";break;
		case "btn_edit":src="/images/wf/title/edit_wev8.png";break;
		case "btn_doReopen":src="/images/wf/title/doreopen_wev8.png";break;
		case "btn_doViewModifyLog":src="/images/wf/title/log_wev8.png";break;
		case "btn_newWFName":src="/images/wf/title/newWFNName_wev8.png";break;
		case "btn_newSMSName":src="/images/wf/title/newSMSNName_wev8.png";break;
		case "btn_relateCwork":src="/images/wf/title/relateCwork_wev8.png";break;
		case "btn_back":src="/wui/theme/ecology8/skins/default/contextmenu/CM_icon7_wev8.png";break;
		case "btn_end":src="/wui/theme/ecology8/skins/default/contextmenu/default/3_wev8.png";break;
		case "btn_backSubscrible":src="/wui/theme/ecology8/skins/default/contextmenu/default/4_wev8.png";break;
		case "btn_next":src="/images/wf/title/next_wev8.png";break;
		case "btn_collect":src="/wui/theme/ecology8/skins/default/contextmenu/default/1_wev8.png";break;
		case "btn_help":src="/wui/theme/ecology8/skins/default/contextmenu/default/2_wev8.png";break;
	}
	return src;
}