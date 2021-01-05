<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ConditionComInfo" class="weaver.datacenter.ConditionComInfo" scope="page" />


<%
String id = Util.null2String(request.getParameter("id"));
String systemset = Util.null2String(request.getParameter("systemset"));

// 查询模板信息
String outrepid="";
String modulename="";
String moduleenname="";
String moduledesc="";

rs.executeSql("select * from outrepmodule where id= "+id );
if (rs.next()){
    modulename=Util.toScreen(rs.getString("modulename"),user.getLanguage()) ;
    moduleenname=Util.null2String(rs.getString("moduleenname")) ;
    moduledesc=Util.toScreen(rs.getString("moduledesc"),user.getLanguage()) ;
    outrepid=Util.null2String(rs.getString("outrepid")) ;
}

// 查询模板条件信息


ArrayList conditionids = new ArrayList() ;
ArrayList conditionnames = new ArrayList() ;
ArrayList isuserdefines = new ArrayList() ;
ArrayList conditionvalues = new ArrayList() ;

rs.executeSql("select * from modulecondition where moduleid= "+id );
while (rs.next()){
    String conditionid=Util.null2String(rs.getString("conditionid")) ;
    String conditionname=Util.null2String(rs.getString("conditionname")) ;
    String isuserdefine=Util.null2String(rs.getString("isuserdefine")) ;
    String conditionvalue=Util.toScreen(rs.getString("conditionvalue"),user.getLanguage()) ;
    
    conditionids.add(conditionid) ;
    conditionnames.add(conditionname) ;
    isuserdefines.add(isuserdefine) ;
    conditionvalues.add(conditionvalue) ;
}





Calendar today = Calendar.getInstance();
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
String currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currentdate = currentyear + "-" + currentmonth + "-" + currentday ;


String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(16367,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name= frmMain action="ReportSearchModuleOperation.jsp" method=post>

<input type="hidden" name="operation" value="">
<input type="hidden" name="modileid" value="<%=id%>">
<input type="hidden" name="outrepid" value="<%=outrepid%>">
<input type="hidden" name="systemset" value="<%=systemset%>">

</p>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
      
      <TABLE class=viewform>
      <COLGROUP>
      <COL width="20%">
      <COL width="80%">
      <TBODY>
       <TR>
       <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
       <TD> <input class=InputStyle  name="modulename" onChange='checkinput("modulename","assortmentnameimage")' value="<%=modulename%>">
                <span id=assortmentnameimage><%if("".equals(modulename)){%><img src="/images/BacoError.gif" align=absMiddle><%}%></span>
       </TD>
       </TR>
       <TR>
       <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>)</TD>
       <TD> <input class=InputStyle  name="moduleenname" value="<%=moduleenname%>"></TD>
       </TR>
       <TR>
       <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
       <TD><input class=InputStyle  name="moduledesc" value="<%=moduledesc%>"></td>
       </TR>
       </tbody>
       </table>
      <p> 

	  <TABLE class=liststyle cellspacing=1 >
        <COLGROUP>
		<COL width="10%">
  		<COL width="20%">
        <COL width="70%">
        <TBODY>
        <TR class=Header>
		<TH><%=SystemEnv.getHtmlLabelName(166,user.getLanguage())%></TH>
        <TH><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>
        <TH><%=SystemEnv.getHtmlLabelName(15214,user.getLanguage())%></TH>
        </TR>
		<% 
        boolean notfromdate = true ;
        boolean nottodate = true ;

        ArrayList  tempfieldnames = new ArrayList() ;

        rs.executeProc("T_OutRC_SelectByOutrepid",""+outrepid);
        while(rs.next()) {
            String tempconditionid = Util.null2String(rs.getString("conditionid")) ;
            String tempfieldname = ConditionComInfo.getConditionitemfieldnames(tempconditionid) ;
            tempfieldnames.add(tempfieldname) ;
        }

        rs.beforFirst() ; 
        while(rs.next()) {
            String tempconditionid = Util.null2String(rs.getString("conditionid")) ;
            String conditioncnname = Util.null2String(rs.getString("conditioncnname")) ;
            String conditionenname = Util.null2String(rs.getString("conditionenname")) ;

            String issystemdef = Util.null2String(ConditionComInfo.getIssystemdef(tempconditionid)) ;
            String conditionname = Util.toScreen(ConditionComInfo.getConditionname(tempconditionid),user.getLanguage()) ;
            String tempfieldname = ConditionComInfo.getConditionitemfieldnames(tempconditionid) ;
            String tempconditiontype = ConditionComInfo.getConditiontype(tempconditionid) ;
            
            if(!conditioncnname.equals("")) conditionname = conditioncnname ;
            if(user.getLanguage() == 8 && !conditionenname.equals("")) conditionname = conditionenname ;

            String isuserdefine = "0" ;
            String theconditionvalue = "" ;
            String userdefinechecked = "" ;

            

            int moduleindex = conditionnames.indexOf(tempfieldname) ;
            if( moduleindex != -1 ) {
                isuserdefine = (String) isuserdefines.get(moduleindex) ; 
                theconditionvalue = (String) conditionvalues.get(moduleindex) ; 

                if( isuserdefine.equals("1") ) userdefinechecked = "checked" ;
            }

            if(!issystemdef.equals("1")) {
      %>
        <TR>
          <TD>
            <input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>>
          </TD>
          <TD><%=conditionname%></TD>
          <TD class=Field>
		  <%    if(tempconditiontype.equals("1")) { %>
          <INPUT type=text class="InputStyle" size=50 name="<%=tempfieldname%>" value="<%=theconditionvalue%>">
          <%    } else { 
                    String mutiselect = "" ;
                    ArrayList theconditionvalues = new ArrayList() ;

                    if((tempfieldname.toUpperCase()).indexOf("CRM")==0 ) {
                        mutiselect="size=6 multiple" ;
                        theconditionvalues = Util.TokenizerString(theconditionvalue, ",") ;
                    }
                    else theconditionvalues.add(theconditionvalue) ;
          %>
		  <select class="InputStyle" name="<%=tempfieldname%>" style="width:30%" <%=mutiselect%>>
		  <% 
                    rs1.executeProc("T_CDetail_SelectByConditionid",tempconditionid);
                    while(rs1.next()) {
                        String conditiondsp = Util.null2String(rs1.getString("conditiondsp")) ;
                        String conditionendsp = Util.null2String(rs1.getString("conditionendsp")) ;
                        if(user.getLanguage() == 8 && !conditionendsp.equals("")) conditiondsp = conditionendsp ;
                        String conditionvalue = Util.null2String(rs1.getString("conditionvalue")) ;
		  %>
          <option value="<%=conditionvalue%>" <%if(theconditionvalues.indexOf(conditionvalue)!=-1)                         {%> selected <%}%>><%=conditiondsp%></option>
		  <%        } %>
		  </select>
          <%    } %>
          </td>
        </tr>
        <TR><TD class=Line colSpan=3 style="padding:0;"> </TD></TR> 
       <%   } else {              // issystemdef = 1 
                if(tempfieldname.indexOf("crm") >= 0) {
                    String nameconditionvalue = "" ;
                    int namemoduleindex = conditionnames.indexOf("name_"+tempfieldname) ;
                    if( namemoduleindex != -1 ) {
                        nameconditionvalue = (String) conditionvalues.get(namemoduleindex) ; 
                    }
       %>
        <TR>
           <TD>
            <input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>>
          </TD>
		  <TD><%=conditionname%></TD>
          <td class=Field id=txtLocation> 
              <button class=Browser onClick="onShowCustomer('span_<%=tempfieldname%>','<%=tempfieldname%>','name_<%=tempfieldname%>','<%=theconditionvalue%>')"></button><SPAN id=span_<%=tempfieldname%>><%=nameconditionvalue%> </SPAN>
            <input type="hidden" id="<%=tempfieldname%>" name="<%=tempfieldname%>" value="<%=theconditionvalue%>">
            <input type="hidden" id="name_<%=tempfieldname%>" name="name_<%=tempfieldname%>" value="<%=nameconditionvalue%>">
            </TD>
            </TR>
            <TR><TD class=Line colSpan=3 style="padding:0;"></TD></TR> 
        <%      } 
                else if( notfromdate && (tempfieldname.equals("yearf") || tempfieldname.equals("monthf") || tempfieldname.equals("dayf")) ) {
                    notfromdate = false ;
        %>
        <TR>
		   <TD>
            <input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>>
          </TD>
          <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></TD>
		   
          <TD class=Field>
		<%          if(tempfieldnames.indexOf("yearf")>=0) { 
                        int datemoduleindex = conditionnames.indexOf("yearf") ;
                        if( datemoduleindex != -1 ) {
                            theconditionvalue = (String) conditionvalues.get(datemoduleindex) ; 
                        }
        %>
		  <select class="InputStyle" name="yearf"> 
		  <%            for(int i=5 ; i>-5;i--) {
                            int tempyear = Util.getIntValue(currentyear) - i ;
                            String selected = "" ;
                            if( theconditionvalue.equals(""+tempyear) ) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%            } %>
		  </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("monthf")>=0) { 
                        int datemoduleindex = conditionnames.indexOf("monthf") ;
                        if( datemoduleindex != -1 ) {
                            theconditionvalue = (String) conditionvalues.get(datemoduleindex) ; 
                        }
          %>
		  <select class="InputStyle" name="monthf">
          <option value="01" <%if(theconditionvalue.equals("01")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(theconditionvalue.equals("02")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(theconditionvalue.equals("03")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(theconditionvalue.equals("04")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(theconditionvalue.equals("05")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(theconditionvalue.equals("06")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(theconditionvalue.equals("07")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(theconditionvalue.equals("08")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(theconditionvalue.equals("09")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(theconditionvalue.equals("10")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(theconditionvalue.equals("11")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(theconditionvalue.equals("12")) {%>selected<%}%>>12</option>
		  </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("dayf")>=0) { 
                        int datemoduleindex = conditionnames.indexOf("dayf") ;
                        if( datemoduleindex != -1 ) {
                            theconditionvalue = (String) conditionvalues.get(datemoduleindex) ; 
                        }
          %>
		  <select class="InputStyle" name="dayf">
                  <%    for( int i=1 ; i<32; i++) {  %>
                  <option value="<%=Util.add0(i,2)%>" <%if(theconditionvalue.equals(Util.add0(i,2))) {%>selected<%}%>><%=i%></option>
                  <%    } %>
		      </select><%=SystemEnv.getHtmlLabelName(16889,user.getLanguage())%>&nbsp;
          <%        } %>
		  </TD>
        </TR><TR><TD class=Line colSpan=3 style="padding:0;"></TD></TR> 
	  <%        } 
                else if(nottodate && (tempfieldname.equals("yeart") || tempfieldname.equals("montht") || tempfieldname.equals("dayt")) ) {
                    nottodate = false ;
        %>
        <TR>
		 <TD>
            <input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>>
          </TD>
          <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%></TD>
          <TD class=Field>
		  <%        if(tempfieldnames.indexOf("yeart")>=0) { 
                        int datemoduleindex = conditionnames.indexOf("yeart") ;
                        if( datemoduleindex != -1 ) {
                            theconditionvalue = (String) conditionvalues.get(datemoduleindex) ; 
                        }
          
          %>
		  <select class="InputStyle" name="yeart">
		  <%            for(int i=5 ; i>-5;i--) {
                            int tempyear = Util.getIntValue(currentyear) - i ;
                            String selected = "" ;
                            if( theconditionvalue.equals(""+tempyear) ) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%            } %>
		  </select><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("montht")>=0) { 
                        int datemoduleindex = conditionnames.indexOf("montht") ;
                        if( datemoduleindex != -1 ) {
                            theconditionvalue = (String) conditionvalues.get(datemoduleindex) ; 
                        }
          %>
		  <select class="InputStyle" name="montht">
          <option value="01" <%if(theconditionvalue.equals("01")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(theconditionvalue.equals("02")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(theconditionvalue.equals("03")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(theconditionvalue.equals("04")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(theconditionvalue.equals("05")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(theconditionvalue.equals("06")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(theconditionvalue.equals("07")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(theconditionvalue.equals("08")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(theconditionvalue.equals("09")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(theconditionvalue.equals("10")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(theconditionvalue.equals("11")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(theconditionvalue.equals("12")) {%>selected<%}%>>12</option>
		  </select><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;
          <%        } 
                    if(tempfieldnames.indexOf("dayt")>=0) { 
                        int datemoduleindex = conditionnames.indexOf("dayt") ;
                        if( datemoduleindex != -1 ) {
                            theconditionvalue = (String) conditionvalues.get(datemoduleindex) ; 
                        }
          %>
		  <select class="InputStyle" name="dayt">
          <%            for( int i=1 ; i<32; i++) {%>
                  <option value="<%=Util.add0(i,2)%>" <%if(theconditionvalue.equals(Util.add0(i,2))) {%>selected<%}%>><%=i%></option>
          <%            } %>
		      </select><%=SystemEnv.getHtmlLabelName(16889,user.getLanguage())%> 
          <%        } %>
		  </TD>
        </TR><TR><TD class=Line colSpan=3 style="padding:0;"></TD></TR> 
	      <%    }
                else if(tempfieldname.equals("modify")) { %>
        <TR>
          <TD><input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>></TD>
          <TD><%=SystemEnv.getHtmlLabelName(17030,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="modify" name="modify" value=1 <%if(theconditionvalue.equals("1")) {%>checked<%}%>>
          </TD>
        </TR><TR><TD class=Line colSpan=3 style="padding:0;"></TD></TR> 
        <%      }
                else if(tempfieldname.equals("monthmodify")) { %>
        <TR>
          <TD><input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>></TD>
          <TD><%=SystemEnv.getHtmlLabelName(17031,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="monthmodify" name="monthmodify" value=1 <%if(theconditionvalue.equals("1")) {%>checked<%}%>>
          </TD>
        </TR><TR><TD class=Line colSpan=3 style="padding:0;"></TD></TR> 
        <%      }
                else if(tempfieldname.equals("yearmodify")) { %>
        <TR>
          <TD><input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>></TD>
          <TD><%=SystemEnv.getHtmlLabelName(17032,user.getLanguage())%></TD>
          <td> 
           <input type="checkbox" id="yearmodify" name="yearmodify" value=1 <%if(theconditionvalue.equals("1")) {%>checked<%}%>>
          </TD>
        </TR><TR><TD class=Line colSpan=3 style="padding:0;"></TD></TR> 
        <%      }
                else if(tempfieldname.equals("isonebyone")) { %>
        <TR>
          <TD>
            <input type="checkbox" name="isuserdefine"  value="<%=tempconditionid%>" <%=userdefinechecked%>>
          </TD>
          <TD>分别汇总</TD>
          <td class=Field id=txtLocation> 
           <input type="checkbox" id="isonebyone" name="isonebyone" value=1 <%if(theconditionvalue.equals("1")) {%>checked<%}%>>
          </TD>
        </TR><TR><TD class=Line1 colSpan=3  style="padding:0;"></TD></TR> 
        <%      }
            }
        }
        %>
	  </TBODY>
	 </TABLE>

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


</FORM>


          
<script language=vbs>
sub onShowCustomer(tdname,inputename,inputename2,thevalue)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&thevalue)
	if NOT isempty(id) then
        if id(0)<> "" then
		document.all(tdname).innerHtml = right(id(1),len(id(1))-1)
		document.all(inputename).value = right(id(0),len(id(0))-1)
        document.all(inputename2).value = right(id(1),len(id(1))-1)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value =""
        document.all(inputename2).value =""
		end if
	end if
end sub

</script>


<script language=javascript>

function onSave(){
    if(check_form(document.frmMain,'modulename')){
        document.frmMain.operation.value="edit";
        document.frmMain.submit();
    }
}

function onDelete(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.frmMain.operation.value="delete";
        document.frmMain.submit();
    }
}

function onBack(){
    document.frmMain.action="ReportSearchModule.jsp" ;
    document.frmMain.submit();
}


</script>


</BODY>
</HTML>
