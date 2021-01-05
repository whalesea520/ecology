
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/cowork_wev8.js"></script>
</HEAD>
<%
int userid=user.getUID();
String userseclevel=user.getSeclevel();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))   usertype= 1;
String name= Util.null2String(request.getParameter("name"));
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=weaver id=weaver>

<TABLE class=viewform width=100% id=oTable1>
  <COLGROUP>
  <COL width="30%"><COL width="70%">
  <TBODY>
    <tr><td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
        <td class=field>
        <input class=inputstyle type=text name="name" value="<%=name%>" style="width:90%" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
        </td> 
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
	<tr> 
      <td><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%>
      </td><td class=field>
        <select name="typeid" size=1 style="width:70%">
    	<option value="">&nbsp;</option>
        <%
            String typesql="select * from cowork_types" ;
           
            RecordSet.executeSql(typesql);
            while(RecordSet.next()){
                String tmptypeid=RecordSet.getString("id");
                String typename=RecordSet.getString("typename");
        %>
            <option value="<%=tmptypeid%>"><%=typename%></option>
        <%
            }
        %>
        </select>
        </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
      <td class=field>
      <select name=status >
      <option value="">&nbsp;</option>
      <option value="1" selected="selected"><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
      <option value="2"><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
      </select>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(18873,user.getLanguage())%></td>
      <td class=field>
      <select name="jointype">
      <option value=""></option>
      <option value="1"><%=SystemEnv.getHtmlLabelName(18874,user.getLanguage())%></option>
      <option value="2"><%=SystemEnv.getHtmlLabelName(18875,user.getLanguage())%></option>
      </select>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
    <tr> 
      <TD><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%></TD>
      <TD class=Field>
          <BUTTON type="button" class=Calendar onclick="getDate(startdatespan,startdate)"></BUTTON> 
              <SPAN id=startdatespan></SPAN> 
              <input type="hidden" name="startdate" id="startdate" >
              <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp&nbsp
           <BUTTON type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
              <SPAN id=enddatespan></SPAN> 
              <input type="hidden" name="enddate" id="enddate" >
          </TD>   
	</tr>
	<TR style="height: 1px;"><TD class=Line colspan=4></TD></TR>
	<tr><td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
      </td>
      <td class=field>
       <BUTTON type="button" class=Browser id=SelectCreaterID onClick="onShowResourceOnly('creater','createrspan')"></BUTTON> 
              <span id=createrspan></span> 
              <INPUT class=saveHistory id=creater type=hidden name=creater>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
	<tr><td><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>
      </td>
      <td class=field>
       <BUTTON type="button" class=Browser id=SelectPrincipalID onClick="onShowResourceOnly('principal','principalspan')"></BUTTON> 
              <span id=principalspan></span> 
              <INPUT class=saveHistory id=principal type=hidden name=principal>
      </td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colspan=4></TD></TR> 
	</table>  

</form>

<script language="javascript">

jQuery(document).ready(function(){
  if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
   //左侧下拉框处理
   jQuery(document.body).bind("mouseup",function(){
	   parent.jQuery("html").trigger("mouseup.jsp");	
    });
    jQuery(document.body).bind("click",function(){
		jQuery(parent.document.body).trigger("click");		
    });
   }
});


function doSearch(){
  var startdate=jQuery("#startdate").val();
  var enddate=jQuery("#enddate").val();
  if(startdate!=""&&enddate!=""&& startdate>enddate){
	 alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
     return ;
  }	 
  var searchStr="isSearch=true&"+jQuery("#weaver").serialize();
  searchStr = decodeURIComponent(searchStr,true);
  var type="";
  parent.loadCoworkItemList(type,searchStr);
}
</script>
 </body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
</html>