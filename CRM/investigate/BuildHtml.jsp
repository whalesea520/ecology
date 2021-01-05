<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
    int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
    rs.executeProc("T_SurveyItem_SelectByInprepid",""+inprepid);
    rs.next() ;

    String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
    String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
    String urlname = Util.null2String(rs.getString("urlname")) ;
    String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(15165,user.getLanguage()) ;
    String needfav ="1";
    String needhelp ="";
    String sql = "" ;
    String submit = SystemEnv.getHtmlLabelName(615,user.getLanguage());
    String cancelresion = SystemEnv.getHtmlLabelName(15166,user.getLanguage());
    String cancel = SystemEnv.getHtmlLabelName(15167,user.getLanguage());
    String itemid = "" ;
    String itemdspname = "" ;
    String itemfieldname = "" ;
    String itemfieldtype = "" ;
    String itemdsp = "" ;
    String year = SystemEnv.getHtmlLabelName(26577,user.getLanguage()) ;
    String month = SystemEnv.getHtmlLabelName(33452,user.getLanguage()) ;
    String date = SystemEnv.getHtmlLabelName(82920,user.getLanguage()) ;
    String nextpageur1 = "/CRM/investigate/InputReportEdit.jsp?inprepid="+inprepid ;
    Calendar todaycal = Calendar.getInstance ();
    String reportdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +year+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +month+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2)+date ;
    
    
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %><BR>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:button1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON language=VBS class=BtnNew id=button1 accessKey=F name=button1 style="display:none"  onclick="location='InputReportEdit.jsp?inprepid=<%=inprepid%>'"><U>F</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
<br><br>
<font color=red><%=SystemEnv.getHtmlLabelName(15168,user.getLanguage())%>：</font><%=SystemEnv.getHtmlLabelName(15169,user.getLanguage())%>。
<br><br>
<%
    String tohtml = "" ;
    String toohtml = "" ;
    ArrayList itemids = new ArrayList() ;
    ArrayList itemdspnames = new ArrayList() ;
    ArrayList itemfieldnames = new ArrayList() ;
    ArrayList itemfieldtypes = new ArrayList() ;
    sql = " select * from T_fieldItem where inprepid="+""+inprepid+" order by itemid ";
    rs.executeSql(sql) ;
    while(rs.next()){
        itemid = Util.null2String(rs.getString("itemid")) ;
        itemdspname = Util.toScreenToEdit(rs.getString("itemdspname"),user.getLanguage()) ;
        itemfieldname = Util.null2String(rs.getString("itemfieldname")) ;
        itemfieldtype = Util.null2String(rs.getString("itemfieldtype")) ;
        itemids.add(itemid) ;
        itemdspnames.add(itemdspname) ;
        itemfieldnames.add(itemfieldname) ;
        itemfieldtypes.add(itemfieldtype) ;
    }

    if(itemids.size()!=0){
        for(int i=0;i<itemids.size();i++){
            itemid = (String)itemids.get(i);
            itemdspname = (String)itemdspnames.get(i);
            itemfieldname = (String)itemfieldnames.get(i);
            itemfieldtype = (String)itemfieldtypes.get(i);
            
            if(itemfieldtype.equals("1"))
                toohtml = "&lt;tr&gt;&lt;td&gt;"+itemdspname+"&lt;/td&gt;&lt;td bgcolor='#efefef'&gt;" + " &lt;input type='text' name="+itemfieldname+"&gt;&lt;/td&gt;&lt;/tr&gt;" ;

            if(itemfieldtype.equals("2"))
                toohtml = "&lt;tr&gt;&lt;td&gt;"+itemdspname  +"&lt;/td&gt;&lt;td bgcolor='#efefef'&gt;" + " &lt;input type='text' name="+itemfieldname+"&gt;&lt;/td&gt;&lt;/tr&gt;" ;

            if(itemfieldtype.equals("3"))
                toohtml = "&lt;tr&gt;&lt;td&gt;"+itemdspname  + "&lt;/td&gt;&lt;td bgcolor='#efefef'&gt;" + " &lt;input type='text' name="+itemfieldname+"&gt;&lt;/td&gt;&lt;/tr&gt;" ;
            
            if(itemfieldtype.equals("4")){
                sql = " select * from T_fieldItemDetail where itemid="+itemid ;
                rs1.executeSql(sql) ;
                while(rs1.next()){
                    itemdsp = Util.toScreenToEdit(rs1.getString("itemdsp"),user.getLanguage()) ;
                    toohtml += " &lt;input type='radio' name="+itemfieldname+" value="+itemdsp+"&gt;"+itemdsp+"<br>" ;
                }
                toohtml = "&lt;tr&gt;&lt;td&gt;"+itemdspname + "&lt;/td&gt;&lt;td bgcolor='#efefef'&gt;<br>" + toohtml + "&lt;/td&gt;&lt;/tr&gt;" ;
            }
                
            if(itemfieldtype.equals("5")){
                sql = " select * from T_fieldItemDetail where itemid="+itemid ;
                rs1.executeSql(sql) ;
                while(rs1.next()){
                    itemdsp = Util.toScreenToEdit(rs1.getString("itemdsp"),user.getLanguage()) ;
                    toohtml += " &lt;input type='checkbox' name="+itemfieldname+" value="+itemdsp+"&gt;"+itemdsp + "<br>" ;;
                }
                
                toohtml = "&lt;tr&gt;&lt;td&gt;" + itemdspname + "&lt;/td&gt;&lt;td bgcolor='#efefef'&gt;<br>" + toohtml + "&lt;/td&gt;&lt;/tr&gt;" ;
                
            }

            
            if(itemfieldtype.equals("6"))
                toohtml = "&lt;tr&gt;&lt;td&gt;"+ itemdspname + "&lt;/td&gt;&lt;td bgcolor='#efefef'&gt;" + " &lt;textarea name="+itemfieldname+"&gt;&lt;/textarea&gt;&lt;/td&gt;&lt;/tr&gt;" ;
            
            if(!toohtml.equals("")) tohtml += toohtml + "<br>" ;
            toohtml = "" ;
       }
        
            

        String html=" &lt;HTML&gt;<br>"+
                    " &lt;HEAD&gt;<br>"+
                    " &lt;TITLE&gt;"+reportdate+inprepname+"&lt;/TITLE&gt;<br>" +
                    " &lt;/HEAD&gt;<br>"+
                    " &lt;BODY&gt<br>"+
                    " &lt;br&gt;&lt;br&gt;<br>"+
                    " &lt;center&gt;&lt;font size=5 color=red&gt;"+reportdate+inprepname+"&lt;/font&gt;&lt;/center&gt;<br>"+
                    " &lt;form name='form1' method='post' action='http://"+urlname+"/CRM/investigate/FormOperation.jsp'&gt;<br>"+
                    " &lt;input type=hidden name=crmid value=$Cust_crmid&gt;<br>"+
                    " &lt;input type=hidden name= inputid value=$Cust_inputid&gt;<br>"+
                    " &lt;input type=hidden name=contactid value=$Cust_contactid&gt;<br>"+
                    " &lt;input type=hidden name=operation value='add'&gt;<br>"+
                    " &lt;table border=1 bordercolor='black'&gt;<br>" +
                    tohtml+"&lt;/table&gt;<br><br>"+
                    " &lt;table width='80%'&gt;&lt;tr&gt;&lt;td height=20 colspan=2&gt;&lt;/td&gt;&lt;/tr&gt;<br> " + 
                    " &lt;tr&gt;&lt;td align=center&gt;&lt;input type='submit' name='Submit' value='"+submit+"'&gt;&lt;/td&gt;<br> " +
	                " &lt;td align=center&gt;&lt;nobr&gt;"+cancelresion+"&lt;a  href= 'http://"+urlname+"/CRM/investigate/CancelOperation.jsp?crmid=$Cust_crmid&inputid=$Cust_inputid&contactid=$cust_contactid'&gt;" + cancel + "&lt;/a&gt;<br>" +
                    " &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt; <br> " + 
                    " &lt;/form&gt;<br>"+
                    " &lt;/BODY&gt;<br>"+
                    " &lt;/HTML&gt;<br>" ;
%>
<table>
<tr><td>s
<%=html%>
</td></tr>
</table>
<br><br>
<%
    }else{
    
%>
<script>
    alert("<%=SystemEnv.getHtmlLabelName(15170,user.getLanguage())%>！") ;
    window.location = "<%=nextpageur1%>";
</script>
<%
}    
%>


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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
