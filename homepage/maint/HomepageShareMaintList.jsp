
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="SptmForHomepage" class="weaver.splitepage.transform.SptmForHomepage" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<% 	
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		ArrayList shareList = hpu.getShareMaintListByUser(user.getUID()+"");
		if(shareList.size()==0){
			 response.sendRedirect("/notice/noright.jsp");
			 return;
		}
	}
%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23018,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//得到分部ID
boolean isDetachable=hpu.isDetachable(request);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);

String message = Util.null2String(request.getParameter("message"));

//页标题
int operatelevel=0;

if(isDetachable){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
}else{
    if(HrmUserVarify.checkUserRight("homepage:Maint", user))       operatelevel=2;
}

boolean canEdit=false;
if(operatelevel>0&&subCompanyId!=0) canEdit=true;
if(canEdit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:onNew(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

}
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width=100% height=95% border="0" cellspacing="0" class='Shadow'>
<colgroup>
<col width="">
<col width="5">
  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
		  <tr>
		<td valign="top">
		<form name="frmAdd" method="post" action="HomepageMaintOperate.jsp?subCompanyId=<%=subCompanyId%>">
		  <input name="method" type="hidden">
		  <TEXTAREA id="areaResult" NAME="areaResult" ROWS="2" COLS="30" style="display:none"></TEXTAREA>
		  <TABLE class=liststyle width=100%>
			  <TR class="header">
					<TH width="10%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage()) %></TH>
					<TH width="10%"><%=SystemEnv.getHtmlLabelName(22916,user.getLanguage())%></TH>
					<TH width="10%"><%=SystemEnv.getHtmlLabelName(22913,user.getLanguage())%></TH>
					<TH width="15%"><%=SystemEnv.getHtmlLabelName(19407,user.getLanguage())%></TH>
					<!-- <TH width="15%"><%=SystemEnv.getHtmlLabelName(19909,user.getLanguage())%></TH> --><!--操作-->
					<!-- <TH width="15%"><%=SystemEnv.getHtmlLabelName(19910,user.getLanguage())%></TH> -->
					<TH width="15%"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><!--操作--></TH>
					<TH width="15%"><%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%><!--操作--></TH>
					<TH width="15%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!--操作--></TH>
			  </TR>
			<tr>
			  <td valign="top">
					 <%
					 
					 ArrayList shareList = hpu.getShareMaintListByUser(user.getUID()+"");
					 String hpid  = "";
					 for(int i=0;i<shareList.size();i++){
						 hpid = (String)shareList.get(i);
						 %>
						<TR class="<%=i%2==0?"datadark":"datalight"%>">
						 	<td><%=pc.getInfoname(hpid) %></td>
						 	<td><%=SptmForHomepage.getMenuStyleNameNoLink(pc.getMenuStyleid(hpid)) %> </td>
						 	<td><%=SptmForHomepage.getStyleNameNoLink(pc.getStyleid(hpid)) %> </td>
						 	<td><%=SptmForHomepage.getLayoutName(pc.getLayoutid(hpid)) %> </td>
						 	<td><%=SptmForHomepage.getIsUseStr(pc.getIsUse(hpid),hpid) %> </td>
						 	<td><%=SptmForHomepage.getIsLockedStr(pc.getIsLocked(hpid),hpid) %> </td>
						 	<td>
						 		<a  href="javascript:doEdit('<%=hpid %>','<%=pc.getSubcompanyid(hpid) %>')" ><%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %></a>
                                <a  href="javascript:doSetElement('<%=hpid %>','<%=pc.getSubcompanyid(hpid) %>')"><%=SystemEnv.getHtmlLabelName(19650,user.getLanguage()) %></a>
                                <a  href="javascript:doPrivew('<%=hpid %>','<%=pc.getSubcompanyid(hpid) %>')"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage()) %></a>
                             </td>
						 </TR>						 
						 <%
					 }
					 %>
					 
			  </td>
			</tr>
		  </TABLE>
        </form>
		</td>
		<td></td>
	  </tr>
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	</table>
  </BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
    if("<%=message%>"=="noDel")  alert('<%=SystemEnv.getHtmlLabelName(19660,user.getLanguage())%>');
	function clearAppoint(){
		var rdoObjs = document.getElementsByName("rdiInfoAppoint");
		for(var i=0;i<rdoObjs.length;i++) {
			var rdoObj = rdoObjs[i];
			rdoObj.checked = false ;
		}
    }

	function onNew(){
		window.location="HomepageTempletSele.jsp?subCompanyId=<%=subCompanyId%>";
	}


	function onSave(){
		//得到所设置的结果    hpid_isuse_ischecked||hpid_isuse_ischecked||...
		var chkUses=document.getElementsByName("chkUse");
		var returnStr="";
		for(var i=0;i<chkUses.length;i++) {
			var tmepChkUse=chkUses[i];
			var hpid=tmepChkUse.hpid;
			var tempIsLocked=document.getElementById("chkLocked_"+hpid);

			var isuse=tmepChkUse.checked?1:0;
			var ischecked=tempIsLocked.checked?1:0;

			returnStr+=hpid+"_"+isuse+"_"+ischecked+"||"
		}		
		if (returnStr!="") returnStr=returnStr.substr(0,returnStr.length-2);
		//alert(returnStr)
		frmAdd.areaResult.value=returnStr;

		frmAdd.method.value="save";
		frmAdd.submit()
	}

	function doPrivew(hpid,subCompanyId){
		window.open("/homepage/Homepage.jsp?hpid="+hpid+"&subCompanyId="+subCompanyId+"&opt=privew","") ;
    }

	function doEdit(hpid,subCompanyId){
		window.location="/homepage/base/HomepageBase.jsp?subCompanyId="+subCompanyId+"&opt=edit&hpid="+hpid;
    }

	


    function doSetElement(hpid,subCompanyId){
       window.location="/homepage/Homepage.jsp?isSetting=true&hpid="+hpid+"&subCompanyId="+subCompanyId+"&from=setElement";
    }
    function doShare(hpid){
        var id=window.showModalDialog("/docs/DocBrowserMain.jsp?url=/homepage/maint/HomepageShare.jsp?hpid="+hpid);
        if (id==1) _table. reLoad();
    }
	function doMaint(hpid){
        var id=window.showModalDialog("/docs/DocBrowserMain.jsp?url=/homepage/maint/HomepageMaint.jsp?hpid="+hpid);
        if (id==1) _table. reLoad();
    }
	function doLocation(hpid){
        var id=window.showModalDialog("/docs/DocBrowserMain.jsp?url=/homepage/maint/HomepageLocation.jsp?hpid="+hpid);
        if (id==1) _table. reLoad();
    }
	
	function onUse(obj){
		if(!obj.checked){
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			document.getElementById("chkLocked_"+tempid).checked=false;			
		}

	}

	function onLock(obj){
		if(obj.checked){
			var id=obj.id;
			var temppos=id.indexOf ("_");
			var tempid=id.substring(temppos+1,id.length);
			document.getElementById("chkUse_"+tempid).checked=true;			
		}
	}	


//-->
</SCRIPT>
<SCRIPT LANGUAGE="VBSCRIPT">
	sub onTran2(subid,hpid)
		 onTran hpid,subid
	end sub
	
	sub onTran(hpid,subid)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp")
		
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				'msgbox(id(0)+"_"+id(1))
				targetSubid=id(0)
				url="/homepage/maint/HomepageMaintOperate.jsp?method=tran&srcSubid="&subid&"&tranHpid="&hpid&"&targetSubid="&targetSubid&"&fromSubid=<%=subCompanyId%>&subCompanyId=<%=subCompanyId%>"
				window.location.replace(url)		
			end if
		end if
	end sub
</SCRIPT>