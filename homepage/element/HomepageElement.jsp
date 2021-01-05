
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.homepage.HomepageBean" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/js/homepage/Homepage_js.jsp" %>
<jsp:useBean id="hpsb" class="weaver.homepage.style.HomepageStyleBean" scope="page"/>
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpbed" class="weaver.homepage.cominfo.HomepageBaseElementCominfo" scope="page" />
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String hpid = Util.null2String(request.getParameter("hpid"));
String from = Util.null2String(request.getParameter("from"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String opt = Util.null2String(request.getParameter("opt"));
HomepageBean hpb=hpu.getHpb(hpid);
String layoutid=hpb.getLayoutid();
String styleid=hpb.getStyleid();

hpsb = hpsu.getHpsb(styleid);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19100,user.getLanguage())+":"+ SystemEnv.getHtmlLabelName(19408,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/homepage/drag_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/homepage/Element_wev8.js"></script>
	<%@ include file="/homepage/HpCss.jsp" %>
  </head>
  
<body onload="init()">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

    int nodelUserid=hpu.getHpUserId(hpid,""+subCompanyId,user);
    int nodelUsertype=hpu.getHpUserType(hpid,""+subCompanyId,user);
	boolean isALlLocked=false;
    if(hpc.getIsLocked(hpid).equals("1"))  isALlLocked=true;

    if((nodelUsertype==3||nodelUsertype==4) && !isALlLocked){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19744,user.getLanguage())+",javascript:doSynize(this),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }

    RCMenu += "{<span>"+SystemEnv.getHtmlLabelName(18466,user.getLanguage())+"</span>,javascript:onChanageAllStatus(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{<span>"+SystemEnv.getHtmlLabelName(19614,user.getLanguage())+"</span>,javascript:onShowHideBaseE(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
  if("addElement".equals(from)) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

  } else if("setElement".equals(from)) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBackList(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
  }else {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onOk(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
  }

 

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
		<FORM name="frmAdd" method="post" action="\homepage\maint\HomepageMaintOperate.jsp?hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>">
		<input type="hidden" name="method" value="">
		<input type="hidden" name="hpid" value="<%=hpid%>">
		<TABLE width="100%">	
				<TR valign="top"  width="100%">
					<TD width="16%" id=tdBaseElement status="show">					
					    <div style="overflow:auto;width:95%;border:1px solid #808080;">
							<TABLE width="100%">
							<%
								//rs.executeSql("select * from hpBaseElement where id!=14 order by id ");
							//是否启用计划任务模块
							    int isusedworktask = Util.getIntValue(BaseBean.getPropValue("worktask","isusedworktask"), 0);
								while (hpbed.next()){
									String ebaseid=Util.null2String(hpbed.getId());
									if(isgoveproj==1){
										if(ebaseid.equals("10")||ebaseid.equals("11")||ebaseid.equals("19")||ebaseid.equals("31")) continue;
									}
									if(isusedworktask==0 && ebaseid.equals("32")) continue;  //32 计划任务元素
									String ebasetitle=Util.null2String(hpbed.getTitle());
									String ebasedesc=Util.null2String(hpbed.getElementdesc());	
									String logo=Util.null2String(hpbed.getLogo());
							%>
							
							<TR width="100%">
								<TD title="<%=ebasedesc%>" id="tdElement"><img src="<%=logo%>">
									<A HREF="javascript:onAddElement('<%=ebaseid%>','<%=hpb.getStyleid()%>')">&nbsp;<%=ebasetitle%></A>	
								</TD>
							</TR>
							<%}%>
						</TABLE>
						<div>						
					</TD>
					 <%
						String strStyle="style=\"height:150px;";
						if(!"".equals(hpsb.getHpbgimg())) strStyle+="background:url('"+hpsb.getHpbgimg()+"')";
						strStyle+="\"";

						String strBgcolor="";						
						if(!"".equals(hpsb.getHpbgcolor())) strBgcolor+=" bgcolor='"+hpsb.getHpbgcolor()+"' ";	
					  %>
									
					<TD width="*" id="tdContentElement" valign=top <%=strBgcolor%> <%=strStyle%> >
							<div>
							<%=hpu.getBaseHpStr(hpid,layoutid,styleid,user,"",Util.getIntValue(subCompanyId))%>
							<div>				
					</TD>					
				</TR>
				
		 </TABLE>
		 </FORM>
		
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	</table>
	<input type="hidden" id="txtStatus" value="show">
	<TABLE style="display='none'">
	<TR id="trTemp">
		<TD></TD>
	</TR>
	</TABLE>

	<TABLE id="tblMove" style="display='none';border:1px dotted #FF3300"  width="100%" height="20px"><TR><TD>&nbsp;</TD></TR></TABLE>
   <div id="divCenter" style="border:1px solid #8888AA; background:white;	position:absolute;padding:5px;	z-index:100;"></div>
   <input type="hidden" value="btnWfCenterReload" name="btnWfCenterReload" onclick="elmentReLoad(8)">
</body>
</html>


<SCRIPT LANGUAGE="JavaScript">
<!--
var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
var pLeft= document.body.offsetWidth/2-50;
divCenter.style.posTop=pTop;
divCenter.style.posLeft=pLeft;
divCenter.style.display='none';

function onSave(){
	frmAdd.submit()
}
	
function onShowHideBaseE(obj){
	var trTemp=document.getElementById("trTemp");
	var tdBaseElement=document.getElementById("tdBaseElement");
	var tdContentElement=document.getElementById("tdContentElement");

	if(tdBaseElement.status=="show") {
		tdBaseElement.status="hidden";
		trTemp.appendChild(tdBaseElement);
		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19613,user.getLanguage())%>";
	} else {
		tdBaseElement.status="show";
		tdContentElement.insertAdjacentElement("beforeBegin",tdBaseElement);
		obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(19614,user.getLanguage())%>";
	}	
}

function onBack(){
	window.location='/homepage/base/HomepageBase.jsp?hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&opt=<%=opt%>';
}

function onOk(){
	window.location="/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>";
}

 function onBackList(){
	window.location='/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>';
}


function onAddElement(ebaseid,styleid){		
	tblInfo.style.display='';
	url="/homepage/element/ElementPreview.jsp?ebaseid="+ebaseid+"&styleid="+styleid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&layoutflag=A";
	//alert(url)
	GetContent(tdInfo,url,true);
}
function onESetting(divSettingobj,eid,ebaseid){	
	//isSetting=true;
	divSettingobj.style.display='';
	url="/homepage/element/ElementSetting.jsp?eid="+eid+"&ebaseid="+ebaseid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
	
    GetContent(divSettingobj,url,false);
}
function onDel(eid){	
    if(!confirm("<%=SystemEnv.getHtmlLabelName(19747,user.getLanguage())%>")) return;
	var oEdel=document.getElementById("_elementTable_"+eid);
	var oEdelTD=oEdel.parentNode;
	var oEdelTDFlag=oEdelTD.areaflag;
	var oEdelTDElements="";

	oEdel.parentNode.removeChild(oEdel);

	
	for(i=0;i<oEdelTD.childNodes.length;i++){
		var tempNode=oEdelTD.childNodes[i];		
		if (tempNode.className!="ElementTable") continue;
		
		oEdelTDElements+=tempNode.eid+",";
	}
	url="/homepage/element/EsettingOperate.jsp?method=delElement&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&eid="+eid+"&delFlag="+oEdelTDFlag+"&delAreaElement="+oEdelTDElements;
	//alert(url)
	GetContent(tdInfo,url,false);
	
}
function doWorkflowEleSet(eid){
    try{
		document.frames["ifrmViewType_"+eid].document.getElementById("btnSave").click();		
 	}catch(e){}
}


function onUseSetting(eid,ebaseid){	
	/*对流程中心元素进行特殊处理*/
	if(ebaseid==8) {
		doWorkflowEleSet(eid);
		//return;
	}
	var ePerpageValue=5;
	var eShowMoulde='0';
	var eBackground='';
	try{
	    ePerpageValue=document.getElementById("_ePerpage_"+eid).value;
	    eShowMoulde=document.getElementById("_eShowMoulde_"+eid).value;
	    eBackground=document.getElementById("_eBackground_"+eid).value;
	} catch(e){
	}
	try{
		var eLinkmodeValue=document.getElementById("_eLinkmode_"+eid).value;
		var esharelevel=document.getElementById("_esharelevel_"+eid).value;
		var eFieldsVale="";

		var chkFields=document.getElementsByName("_chkField_"+eid);
		if (chkFields!=null){
			for(var i=0;i<chkFields.length;i++){
				var chkField=chkFields[i];
				if(chkField.checked) eFieldsVale+=chkField.value+",";
			}
			if(eFieldsVale!="") eFieldsVale=eFieldsVale.substring(0,eFieldsVale.length-1);
		}
		
		var imsgSizeStr="";
		if(document.getElementById("_imgWidth"+eid)!=null){
			var imgWidth = document.getElementById("_imgWidth"+eid).value;
			var imgHeight = document.getElementById("_imgHeight"+eid).value;
			
			if(imgWidth.replace(/(^\s*)|(\s*$)/g, "") == ""){
				imgWidth = "0";
			}
			if(imgHeight.replace(/(^\s*)|(\s*$)/g, "")==""){
				imgHeight = "0";
			}
			var imgSize = imgWidth+"*"+imgHeight;
			
			imsgSizeStr = "&imgSize_"+document.getElementById("_imgWidth"+eid).basefield+"="+imgSize;
		}
		//得到上传时的字数标准
		var wordcountStr="";
		var _wordcountObjs=document.getElementsByName("_wordcount_"+eid);
		for(var j=0;j<_wordcountObjs.length;j++){
			var wordcountObj=_wordcountObjs[j];
			var basefield=wordcountObj.basefield;
			wordcountStr+="&wordcount_"+basefield+"="+wordcountObj.value;
		}

		

		var eTitleValue="";
		var whereKeyStr="";

		if(esharelevel=="2"){
			var eTitleValue=document.getElementById("_eTitel_"+eid).value;
			var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
			if(eTitleValue.indexOf('%')!=-1) {
				alert("<%=SystemEnv.getHtmlLabelName(20858,user.getLanguage())%>");
				return;
			}
			document.getElementById("spanEtitle"+eid).innerHTML=eTitleValue;	
			//得到上传的SQLWhere语句
			for(var k=0;k<_whereKeyObjs.length;k++){
				var _whereKeyObj=_whereKeyObjs[k];	
				if(_whereKeyObj.tagName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;
				whereKeyStr+=_whereKeyObj.value+"^,^";			
			}
		}
		

		if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);
		
		eTitleValue=eTitleValue.replace(/&/g, "%26");//把eTitleValue中的&换成%26;
		var postStr="eid="+eid+"&method=editSetting&ebaseid="+ebaseid+"&eShowMoulde="+eShowMoulde+"&eBackground="+eBackground+"&eTitleValue="+eTitleValue+"&ePerpageValue="+escape(ePerpageValue)+"&eLinkmodeValue="+escape(eLinkmodeValue)+"&eFieldsVale="+escape(eFieldsVale)+wordcountStr+imsgSizeStr+"&whereKeyStr="+escape(whereKeyStr)+"&esharelevel="+esharelevel+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
		//alert(postStr)


		var divSetting=document.getElementById("_divESetting_"+eid);
		var divContent=document.getElementById("_divEcontent_"+eid);
		url="/homepage/element/ElementContent.jsp?eid="+eid+"&ebaseid="+ebaseid+"&styleid=<%=hpb.getStyleid()%>&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
		divSetting.innerHTML="<img src=/images/loading2_wev8.gif> <%=SystemEnv.getHtmlLabelName(83700,user.getLanguage())%>...";

		
		var xmlHttp = XmlHttp.create();	
		xmlHttp.open("post","/homepage/element/EsettingOperate.jsp", true);

		xmlHttp.onreadystatechange = function () {	
			switch (xmlHttp.readyState) {		           
			   case 4 : 	
				   divSetting.style.display='none';
					new Element(eid,ebaseid,"<%=styleid%>","<%=hpid%>","<%=subCompanyId%>").reLoad();
					//eval("objE"+eid+".reLoad()");
				   //GetContent(divContent,url,false);
				   //isSetting=false;
				   break;
			} 
		}	
		xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded")	
		postStr=URLEncoding(postStr);
		xmlHttp.send(postStr);
	} catch(e){}
}
function onRefresh(eid,ebaseid){
    try{
        new Element(eid,ebaseid,"<%=styleid%>","<%=hpid%>","<%=subCompanyId%>").reLoad();
        //eval("objE"+eid+".reLoad()");
    }catch (e){}
}


function onLockOrUn(eid,ebaseid,obj){
    if(confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")){
        divCenter.style.display='inline';
        var code="divCenter.style.display=\"none\";";
        if(obj.status=="unlocked"){
            obj.status="locked";
            obj.src='<%=hpsb.getElockimg1()%>';

            url="/homepage/element/EsettingOperate.jsp?method=locked&eid="+eid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
            //alert(url)
            GetContent(divCenter,url,false,code);
        } else {
            obj.status="unlocked";
            obj.src='<%=hpsb.getEunlockimg1()%>';

            url="/homepage/element/EsettingOperate.jsp?method=unlocked&eid="+eid+"&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>";
            //alert(url)
            GetContent(divCenter,url,false,code);
        }
    }
}

function moveElement(moveEid,srcFlagObj){

	var oEmove=document.getElementById("_elementTable_"+moveEid);
	var targetFlagObj=oEmove.parentNode;

	var srcFlag=srcFlagObj.areaflag;
	var targetFlag=targetFlagObj.areaflag;
	
	//alert(moveEid+":"+srcFlag+":"+targetFlag)

	//if(srcFlag==targetFlag) return;

	var srcStr="";
	var targetStr="";

	for(i=0;i<srcFlagObj.childNodes.length;i++){
		var tempNode=srcFlagObj.childNodes[i];		
		if (tempNode.className!="ElementTable") continue;
		
		srcStr+=tempNode.eid+",";
	}

	for(i=0;i<targetFlagObj.childNodes.length;i++){
		var tempNode=targetFlagObj.childNodes[i];		
		if (tempNode.className!="ElementTable") continue;
		
		targetStr+=tempNode.eid+",";
	}

	//alert(srcFlag+": "+srcStr+"  "+targetFlag+": "+targetStr);	
	url="/homepage/element/EsettingOperate.jsp?method=editLayout&hpid=<%=hpid%>&subCompanyId=<%=subCompanyId%>&srcFlag="+srcFlag+"&targetFlag="+targetFlag+"&srcStr="+srcStr+"&targetStr="+targetStr;
    //alert(url)
	GetContent(tdInfo,url,false);	
}
function   doSynize(obj){
     if(confirm("<%=SystemEnv.getHtmlLabelName(19745,user.getLanguage())%>")){
            //obj.disabled=true;
            divCenter.style.display='inline';
            var code="divCenter.style.display=\"none\";";
            var url='/homepage/maint/HomepageMaintOperate.jsp?method=synihp&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>'
            GetContent(divCenter,url,false,code);
     }
}
function openMaginze(obj,url,linkmode){
  url=url+obj.value;
  if(linkmode=="1") window.location=url; 
  if(linkmode=="2") openFullWindowForXtable(url);
}
function showUnreadNumber(accountId){
	var oSpan = document.getElementById("span"+accountId);
	var oIframe = document.getElementById("iframe"+accountId);
	var unreadMailNumber = trim(oIframe.contentWindow.document.body.innerText);
	oSpan.innerHTML = unreadMailNumber==-1 ? "<img src='/images/BacoError_wev8.gif' align='absmiddle' alt='<%=SystemEnv.getHtmlLabelName(20266,user.getLanguage())%>'>" : "(<b>"+unreadMailNumber+"</b>)";
}
//-->
</SCRIPT>