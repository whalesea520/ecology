
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.homepage.HomepageBean" %>
<%@ page import="weaver.homepage.cominfo.HomepageBaseLayoutCominfo" %>
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="esc"	class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="mhc"	class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />

<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  </head>
  
<body>
<%
String hpid = Util.null2String(request.getParameter("hpid"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String opt = Util.null2String(request.getParameter("opt"));


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19100,user.getLanguage())+":"+ SystemEnv.getHtmlLabelName(61,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(19650,user.getLanguage())+",javascript:onSaveAndElement(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
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
		<td ></td>
		<td valign="top">
        <table class="Shadow">
        <tr>
        <td valign="top">
        <div id=divMessage></div>
		<FORM name="frmAdd" method="post" action="/homepage/maint/HomepageMaintOperate.jsp?subCompanyId=<%=subCompanyId%>&opt=<%=opt%>">
		<input type="hidden" name="method" value="savebase">
		<input type="hidden" name="hpid" value="<%=hpid%>">		
        <input type="hidden" name="txtOnlyOnSave">     	
		<TABLE class=viewform cellspacing=1>		
				<TR>
					<td  colspan=2><%=SystemEnv.getHtmlLabelName(19484,user.getLanguage())%>:</td>							
				</TR>
				<TR style="height:2px;"><td class=line1 colspan=2></td></TR>
				
				<%		
                    String infoname="";
                    String infodesc="";
                    String styleid="";
                    String layoutid="";		
                    String menuStyleid = "";
					if(pc.isHaveThisHp(hpid)){
                        HomepageBean hpb=hpu.getHpb(hpid);                    
    					infoname=hpb.getInfoname();
    					infodesc=hpb.getInfodesc();
    					styleid=hpb.getStyleid();
    					layoutid=hpb.getLayoutid();
    					menuStyleid = hpb.getMenuStyleid();
                    } else{
                        rs.executeSql("select * from hpinfo where id="+hpid);
                        if(rs.next()){
                            infoname=Util.null2String(rs.getString("infoname"));
                            infodesc=Util.null2String(rs.getString("infodesc"));
                            styleid=Util.null2String(rs.getString("styleid"));
                            layoutid=Util.null2String(rs.getString("layoutid"));
                            menuStyleid = Util.null2String(rs.getString("menustyleid"));
                        }                        
                    }
			    %>

			
				<TR>					
					<TD width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
					<TD width="80%" class=field>
						<INPUT TYPE="text" NAME="infoname"  value="<%=infoname%>" onChange="checkinput('infoname','infonameSpan')" class="inputstyle" size=40>
						<span id=infonameSpan name=infonameSpan>
						<%if("".equals(infoname)){out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");}%>
						</span>
					</TD>					
				</TR>
				<TR style="height:1px;"><td colspan=2 class=line></td></TR>


				<TR>					
					<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
					<TD class=field><INPUT TYPE="text" NAME="infodesc" value="<%=infodesc%>"  class="inputstyle"  size=40></TD>					
				</TR>
				<TR style="height:1px;"><td colspan=2 class=line></td></TR>

				<TR>					
					<TD><%=SystemEnv.getHtmlLabelName(22913,user.getLanguage())%></TD>
					<TD class=field>
					<SELECT NAME="seleStyleid" style="width:30%">
					<%			
					esc.setTofirstRow();
					while (esc.next()){
							String tempStyleid = esc.getId();
							String tempStylename = Util.toHtml5(esc.getTitle());
						
							String strSelected="";
							if(styleid.equals(tempStyleid)) strSelected=" selected ";							
					%>						
						<option value="<%=tempStyleid%>" <%=strSelected%>><%=tempStylename%></option>						
					<%}%>
					</SELECT>	
					</TD>					
				</TR>
				<TR  style="height:1px;"><td colspan=2 class=line></td></TR>
				
				<TR>					
					<TD><%=SystemEnv.getHtmlLabelName(22916,user.getLanguage())%></TD>
					<TD class=field>
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
					</TD>					
				</TR>
				<TR  style="height:1px;"><td colspan=2 class=line></td></TR>
				

				<TR>					
					<TD><%=SystemEnv.getHtmlLabelName(19407,user.getLanguage())%></TD> 
					<TD class=field>
					<%
					ArrayList areflagList=new ArrayList();
				    ArrayList sizeList=new ArrayList();
					rs.executeSql("select areaflag,areasize from hplayout where hpid="+hpid+" and userid="+hpu.getHpUserId(hpid,subCompanyId,user)+" and usertype="+hpu.getHpUserType(hpid,subCompanyId,user));
					while(rs.next()){
						areflagList.add(Util.null2String(rs.getString("areaflag")));
						sizeList.add(Util.null2String(rs.getString("areasize")));
					}
					
					%>
					<SELECT NAME="seleLayoutid"  style="width:30%" onchange="onLayoutidChanage(this)">
					<%
						HomepageBaseLayoutCominfo hpblc=new HomepageBaseLayoutCominfo();						
						String strArea="";
						String strLayoutimage="";
						String strLayoutdesc="";
						String strLayoutType="";
						while(hpblc.next()){
							String tempLayoutid=Util.null2String(hpblc.getId());
							String tempLayoutname=Util.null2String(hpblc.getLayoutname());							
							String allowArea=Util.null2String(hpblc.getAllowArea());
							String layoutimage=Util.null2String(hpblc.getLayoutimage());
							
							String layoutType = Util.null2String(hpblc.getLayoutType());
							String layoutdesc="";
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

					%>						
						<option value="<%=tempLayoutid%>" <%=strSelected%>  layoutImg="<%=layoutimage%>" layoutdesc="<%=layoutdesc%>" allowArea="<%=allowArea%>" layouttype="<%=layoutType%>"><%=tempLayoutname%></option>						
					<%}%>
					</SELECT>
					</TD>					
				</TR>
				<input type=hidden value="<%=strArea%>" name=txtLayoutFlag>
				<TR  style="height:1px;"><td colspan=2 class=line></td></TR>

				<%
				String display = "";
				if(strLayoutType.equals("cus")){
					display = "none";
				}
				
				%>
					
				<TR id="trSetLayout" valign="top" style="display:<%=display%>">					
					<TD valign="top">
					<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>
					</TD>
					<TD  id="tdSetLayout">
						<TABLE width="100%"  valign="top">
						<TR  valign="top">
							<TD width="25%"><img src="/<%=strLayoutimage%>"></TD>
							<TD width="75%" valign="top">
							<%
								//写出布局								
								if(!"".equals(strArea)){
									ArrayList tempList=Util.TokenizerString(strArea,",");
									for(int i=0;i<tempList.size();i++){
										String tempArea=(String)tempList.get(i);
										String tempSizeValue=hpu.getAreaSize(tempArea,areflagList,sizeList);
										out.println(tempArea+SystemEnv.getHtmlLabelName(15114,user.getLanguage())+SystemEnv.getHtmlLabelName(203,user.getLanguage())+":"+"<input type=text size=5 class=inputStyle onkeypress=\"ItemCount_KeyPressNoHen()\" name='txtArea_"+tempArea+"' value='"+tempSizeValue+"'>%<br>");
									}									
								}					
					        %>

							
							</TD>
						</TR>
						</TABLE>
					</TD>					
				</TR>
				
				<TR id='trSetLayoutLine'  style="display:<%=display%>;height:1px;">		<td colspan=2 class=line></td></TR>
				<TR><td colspan=2><span id=spanLayoutdesc><%=strLayoutdesc%></span></td></TR>	
		 </TABLE>
		 </FORM>
         </TR>
		  </table>
		</td> 
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	</table>
</body>
</html>
<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function saveAndSubmit(){
    if(check_form(document.frmAdd,'infoname')){
        var xmlHttp = XmlHttp.create(); 
        var strUrl="/homepage/style/HomepageCheckname.jsp?subcompanyid=<%=subCompanyId%>&method=checkHomepagename&hpid=<%=hpid%>&name="+frmAdd.infoname.value
        //document.write(strUrl);
        xmlHttp.open("GET",strUrl, true);
    
        xmlHttp.onreadystatechange = function () {  
            switch (xmlHttp.readyState) {                  
               case 4 :
                    var strTemp=xmlHttp.responseText.replace(/^\s*|\s*$/g,'');
                   // alert(strTemp)
                   if(strTemp!="use"){   
                                        
                     frmAdd.submit();
                   } else{
                     divMessage.innerHTML="<font  color=#FF0000><%=SystemEnv.getHtmlLabelName(19648,user.getLanguage())%></font>";
                   }                
                   break;
           } 
        }     
         xmlHttp.send(null);    
    }  
}
function onSaveAndElement(){
 hiddenThisPage();        
 saveAndSubmit();
}
function onSave(){
    frmAdd.txtOnlyOnSave.value="true";
    saveAndSubmit();
}
function onBack(){
	if("edit"=="<%=opt%>"){	
		window.location="/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>";
	} else {
		window.location="/homepage/maint/HomepageTempletSele.jsp?subCompanyId=<%=subCompanyId%>";
	}
}

function onLayoutidChanage(_this){	
	var target=_this.options[_this.selectedIndex];
	if(""!=$(target).attr("allowArea")){
		if($(target).attr("layouttype")=="sys"){
			$("#trSetLayout").css("display","");
			$("#trSetLayoutLine").css("display","");
			var tempStrs = $(target).attr("allowArea").split(",");
			var innerStr="<TABLE width=\"100%\"  valign=\"top\"><TR  valign=\"top\"><TD width=\"25%\"><img src=\"/"+$(target).attr("layoutImg")+"\"></TD><TD width=\"75%\" valign=\"top\">";
	
			for(var i=0;i<tempStrs.length;i++){
				var tempArea=tempStrs[i];			innerStr+=tempArea+"<%=SystemEnv.getHtmlLabelName(15114,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:<input type=text size=5 class=inputStyle name='txtArea_"+tempArea+"' onkeypress=\"ItemCount_KeyPressNoHen()\" >%<br>";
			}
			innerStr+="</TD></TR></TABLE>";
			$("#tdSetLayout").html(innerStr);
		}else{
			$("#trSetLayout").css("display","none");
			$("#trSetLayoutLine").css("display","none");
			$("#tdSetLayout").html("");
		}
		$("#spanLayoutdesc").html($(target).attr("layoutdesc"));
		$("input[name=txtLayoutFlag]").val($(target).attr("allowArea"));
	}		
}

function hiddenThisPage(){
	if(window.parent.oTd1!=undefined){
	    window.parent.oTd1.style.display='none';
    }
}


function ItemCount_KeyPressNoHen(){
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
  {
     window.event.keyCode=0;
  }
}
//-->
</SCRIPT>



								
