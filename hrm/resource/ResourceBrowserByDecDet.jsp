
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
    String sqlwhere = "";
	String rightStr = Util.null2String(request.getParameter("rightStr"));
    int uid = user.getUID();
    int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
    if(beagenter <= 0){
    	beagenter = uid;
    }
    String resourcesingle=(String)session.getAttribute("decresourcemulti");
    if(resourcesingle==null){
    Cookie[] cks= request.getCookies();
    
    for(int i=0;i<cks.length;i++){
    //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
    if(cks[i].getName().equals("decresourcemulti"+uid)){
    resourcesingle=cks[i].getValue();
    break;
    }
    }
    }
String tabid="0";
if(resourcesingle!=null&&resourcesingle.length()>0){
String[] atts=Util.TokenizerString2(resourcesingle,"|");
tabid=atts[0];

}
    int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(beagenter, rightStr,fieldid,isdetail,isbill);
    
    
    
    boolean isall=CheckSubCompanyRight.getIsall();
    String departments=CheckSubCompanyRight.getDepartmentids();
    String subcompanyids=CheckSubCompanyRight.getSubcompanyids();
    
   
   
   if(!isall){
      //System.out.println("+++++++++++sql=where subcompanyid1 in("+subcompanyids+")");
      sqlwhere=" where subcompanyid1 in("+subcompanyids+")";
   }

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE type=text/css>PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
</STYLE>
</HEAD>
<body>
<TABLE class=form width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  </colgroup>
  <TBODY>
  <tr>
  <td  height=30 colspan=3 background="/images/tab/bg1_wev8.gif" align=left>
  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  >
  <tr align="left">
  <td nowrap background="/images/tab/bg1_wev8.gif" width=15px height=100% align=center></td>
  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(0)" ><b><%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%></b></td>
  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(1)" ><b><%=SystemEnv.getHtmlLabelName(18771,user.getLanguage())%></b></td>
  <td nowrap name="oTDtype_2"  id="oTDtype_2" background="/images/tab/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(2)" ><b><%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%></b></td>
  <td nowrap name="oTDtype_3"  id="oTDtype_3" height="100%" >&nbsp</td>
  </tr>
  </table>
  </td>
  </tr>
<tr>
<td  id=oTd1 name=oTd1 width=100% height=40% colspan="3">
<IFRAME name=frame1 id=frame1  width=100%  height=100% frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
</IFRAME>
</td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100% height=60% width="100%" colspan=3>
<IFRAME name=frame2 id=frame2 src="/hrm/resource/SelectByDec.jsp?tabid=<%=tabid%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" width=100%  height=100% frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
</IFRAME>
</td>
</tr>
</TBODY>
</table>
<script language=javascript>
	function resetbanner(objid){

		for(i=0;i<=2;i++){
			$("#oTDtype_"+i).attr("background","/images/tab/bgdark_wev8.gif");
		}
		$("#oTDtype_"+objid).attr("background","/images/tab/bglight_wev8.gif");
		if(objid == 0 ){
		        window.frame1.location="/hrm/resource/SingleSearchByOrganDecDet.jsp?onlyselfdept=<%=onlyselfdept%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&departments=<%=departments%>&subcompanyids=<%=subcompanyids%>&isall=<%=isall%>";
		        try{
		        window.frame2.btnsub.style.display="none"
		        }catch(err){}
		        }
		else if(objid == 1){
			window.frame1.location="/hrm/resource/SingleSearchByGroupDec.jsp?sqlwhere=<%=sqlwhere%>";
			try{
			window.frame2.btnsub.style.display="none"
			}catch(err){}
			}
		else if(objid == 2){
			window.frame1.location="/hrm/resource/SingleSearchDec.jsp?sqlwhere=<%=sqlwhere%>";
			try{
			window.frame2.btnsub.style.display="inline"
			}catch(err){}
			}
	}
resetbanner(<%=tabid%>);
</script>
</body>
</html>