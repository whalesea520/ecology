
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>
<jsp:useBean id="hpsc" class="weaver.homepage.cominfo.HomepageStyleCominfo" scope="page"/>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>  
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19440,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>


<%
	if(!HrmUserVarify.checkUserRight("hompage:stylemaint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String seleStyleid = Util.null2String(request.getParameter("seleStyleid"));
	String hpinfoid = Util.null2String(request.getParameter("hpinfoid"));
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage())+",javascript:onAdd(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())+",javascript:onSave(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width=100%  height=100% border="0" cellspacing="0" valign="top">
<colgroup>
<col width="">
<col width="5">
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	  <tr>		
		<td valign="top">  		
		  <TABLE class=Shadow width=100% height="100%" valign="top">
			<tr>
			  <td valign="top">                        
			
														
					<TABLE class="viewform" border="0" cellspacing="0" valign="top" width="100%">
				
					<TR>
                        <TD><B><%=SystemEnv.getHtmlLabelName(19621,user.getLanguage())%></B></TD>
                        <TD><B><%=SystemEnv.getHtmlLabelName(19622,user.getLanguage())%></B></TD>
                        <TD><B><%=SystemEnv.getHtmlLabelName(19623,user.getLanguage())%></B></TD>
                    </TR>
					<TR><td colspan=3 class=line1></td></TR>
					<TR><td colspan=3 height=3px>&nbsp;</td></TR>
					<%
						int rowindex=1;
						hpsc.setTofirstRow();						
						while(hpsc.next()){
							String styleid=hpsc.getId();
							String stylename=hpsc.getStylename();
							String styledesc=hpsc.getStyleDesc();
							String issystemdefualt=hpsc.getIssystemdefualt();
							rowindex++;

					%>
					<TR>				
					

						<TD  valign="top" width="15%">
						    <%
						if(("1".equals(issystemdefualt) && user.getUID()==1) || (!"1".equals(issystemdefualt))){ %>
							    
								<a href="/homepage/style/HomepageStyleAdd.jsp?styleid=<%=styleid%>&hpinfoid=<%=hpinfoid%>&from=list">					
								<%=stylename%>
								</a>
							<%} else {%>
								<%=stylename%>
							<%}%>
						</TD>
						<TD  valign="top" width="30%"><%=styledesc%></TD>
						<TD  valign="top" width="*" ><%=hpsu.getNavgateShape1(hpsu.getHpsb(styleid))%><br><%=hpsu.getElementShape(hpsu.getHpsb(styleid))%></TD>
					</TR>
					<TR><td colspan=3 class=line></td></TR>
					<%}%>
					
					</TABLE>
					
			  </td>
			</tr>
		  </TABLE>        
		</td>
		<td></td>
	  </tr>
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	</table>

</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function onAdd(){
	window.location="HomepageStyleSele.jsp";
}
function onSave(){
   
   var value=getRadioValue("rdiStyleid")

   if(value!=0)		   	window.location="/homepage/maint/HomepageMaintOperate.jsp?method=savestyleid&hpinfoid=<%=hpinfoid%>&seleStyleid="+value;
}

function getRadioValue(rdiname){
	radValue=0;
	var objs = document.getElementsByName(rdiname);
	for(i=0;i<objs.length;i++){
		var obj=objs[i];
		if(obj.checked==true){			
			radValue=obj.value;
			break;
		}

	}
	return radValue;
}
/*首页导航栏设置*/
   var lastestSubDiv;
    /*
       cObj:Current Object
       pObj:Pervious Sibling Object
       sObj:Sub Menu Object
    */
    function onShowSubMenu(cObj,sObj){
       
        if (sObj.style.display=="none")    {
            /*初始化其显示的位置及大小*/
            var pObj=cObj.previousSibling;

            sObj.style.position="absolute";
			sObj.style.width=100;
            sObj.style.posLeft=pObj.offsetLeft;
            sObj.style.posTop=pObj.offsetTop+pObj.offsetHeight;
            
            if(lastestSubDiv!=null) lastestSubDiv.style.display="none";
            lastestSubDiv=sObj;
            sObj.style.display="";
            
        } else {
            sObj.style.display="none";
        }
    } 
</SCRIPT>