<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String outrepid = "";
String itemrow = "";
int itemcolumn=0;
String sql="";
String operation = Util.null2String(request.getParameter("operation"));
String retrunvalue="";
if(!operation.equals("")){
    outrepid = Util.null2String(request.getParameter("outrepid"));
    itemrow = Util.null2String(request.getParameter("itemrow"));
    itemcolumn = Util.getIntValue(Util.null2String(request.getParameter("itemcolumn")),0);
    for(int i=1;i<=itemcolumn;i++){
        String itemdesc_=Util.null2String(request.getParameter("itemdesc_"+i));
        String itemexpress_=Util.null2String(request.getParameter("itemexpress_"+i));
        int itemid=-1;
        sql="select itemid from T_OutReportItem where outrepid="+outrepid+" and  itemrow="+itemrow+" and itemcolumn="+i;
        rs.executeSql(sql);
        if(rs.next()) itemid=rs.getInt("itemid");
        if(!itemdesc_.trim().equals("") || !itemexpress_.trim().equals("")){
            if(itemid>0){
                sql="update T_OutReportItem set itemdesc='"+itemdesc_+"',itemexpress='"+itemexpress_+"' where itemid="+itemid;
            }else{
                sql="insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemdesc,itemexpress) values("+
                        outrepid+","+itemrow+","+i+",'1','"+itemdesc_+"','"+itemexpress_+"')";
            }
            rs.executeSql(sql);
            if(retrunvalue.equals("")) retrunvalue=i+"_"+itemdesc_+"_1";
            else retrunvalue+=","+i+"_"+itemdesc_+"_1";
        }else{
            if(itemid>0){
                rs.executeProc("T_OutReportItem_Delete",""+itemid);
            }
            if(retrunvalue.equals("")) retrunvalue=i+"__0";
            else retrunvalue+=","+i+"__0";
        }
    }
%>
<script language="vbs">
    window.parent.returnvalue = "<%=retrunvalue%>"
	window.parent.close
</script>
<%
}
String allid = Util.null2String(request.getParameter("allid"));
if(!allid.equals("")) {
    String allids[] = Util.TokenizerString2(allid , "_") ;
    outrepid = allids[0] ;
    itemrow = allids[1] ;
}
else {
    outrepid = Util.null2String(request.getParameter("outrepid"));
    itemrow = Util.null2String(request.getParameter("itemrow"));
}

sql="select outrepcolumn from T_OutReport where outrepid="+outrepid;
rs.executeSql(sql);
if(rs.next()){
    itemcolumn=Util.getIntValue(rs.getString("outrepcolumn"),0);
}
ArrayList columnlist=new ArrayList();
ArrayList itemdesclist=new ArrayList();
ArrayList itemexpresslist=new ArrayList();
sql="select itemcolumn,itemdesc,itemexpress from T_OutReportItem where outrepid="+outrepid+" and itemrow="+itemrow+" order by itemcolumn";   
rs.executeSql(sql);
while(rs.next()){
    columnlist.add(rs.getString("itemcolumn"));
    itemdesclist.add(rs.getString("itemdesc"));
    itemexpresslist.add(rs.getString("itemexpress"));
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20743,user.getLanguage()) + itemrow    ;

String needfav ="1";
String needhelp ="";
%>


<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name=frmMain action="OutReportRowItems.jsp" method=post>
<input type="hidden" name=operation value="editall">
<input type=hidden name=outrepid value="<%=outrepid%>">
<input type=hidden name=itemrow value="<%=itemrow%>">
<input type=hidden name=itemcolumn value="<%=itemcolumn%>">
<div id=loadDiv style="padding-top:5; padding-left:10;display:none">
    <table border="1" cellpadding="1" cellspacing="1">
        <tr><td>ÕýÔÚ±£´æ£¬ÇëÉÔºò<span id="loading"></span></td></tr>
    </table>
</div>
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

  <table class=liststyle>
    <colgroup> <col width="10%"> <col width="40%"><col width="50%"><tbody>
      <tr class=header>
        <th ><%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%></th>
        <th ><%=SystemEnv.getHtmlLabelName(20745,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></th>
      </tr>
      <tr class=line>
        <td colspan=3></td>
      </tr>
      <%
      for(int i=1;i<=itemcolumn;i++){
          String thechar = Util.getCharString(i) ;
          String itemdesc="";
          String itemexpress="";
          int indx=columnlist.indexOf(""+i);
          if(indx>-1){
              itemdesc=(String)itemdesclist.get(indx);
              itemexpress=(String)itemexpresslist.get(indx);
          }
      %>
      <tr <%if(i%2==0){%>bgcolor=#f5f5f5<%}else{%>bgcolor=#e7e7e7<%}%>>
        <td><%=i+"("+thechar+")"%></td>
        <td class=Field>
        <input type="text" class="inputstyle" name="itemdesc_<%=i%>" size=40 value="<%=itemdesc%>">
        </td>
        <td class=Field>
        <input type="text" class="inputstyle" name="itemexpress_<%=i%>" size=40 value="<%=itemexpress%>">
        </td>
      </tr>
      <%}%>
  </table>

</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


</form>
<br>
<script language=javascript>

 function onSave(obj){
    document.all("loadDiv").style.display='';
    var setInterval1 = setInterval("loading.innerText += '.'", 1000);
    var setInterval2 = setInterval("loading.innerText = ''", 15000);
    document.frmMain.submit();
    obj.disabled=true;     
 }
</script>

</BODY></HTML>
