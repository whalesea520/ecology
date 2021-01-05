<%@ page import="weaver.general.Util,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String supmoduleid  = Util.null2String(request.getParameter("supmoduleid"));
String moudleid = Util.null2String(request.getParameter("moudleid"));
String inputid = Util.null2String(request.getParameter("inputid"));
String userid = "" + user.getUID() ;
String moudlename = "" ;
String moudletablename = "" ;
String needconfirm = "" ;
String isrootmoudle = "" ;

String inputsubject = "" ;
String createrid = "" ;
String confirmid = "" ;
String createdate = "" ;
String confirmdate = "" ;
String inputstatus = "" ;

boolean canEdit = false ;
boolean canConfirm = false ;
boolean hasvalue = false ;
boolean canSubmit = false ;

char separator = Util.getSeparator() ;
String para = inputid + separator + moudleid ;
rs.executeProc("SystemMoudle_SBySelMoudleID",para);
if(rs.next()) {
    moudlename = Util.toScreenToEdit(rs.getString("moudlename"),user.getLanguage()) ;
    moudletablename = Util.null2String(rs.getString("moudletablename")) ;
    needconfirm = Util.null2String(rs.getString("needconfirm")) ;
    isrootmoudle = Util.null2String(rs.getString("isrootmoudle")) ;
    createrid = Util.null2String(rs.getString("moudlecreater")) ;
}


if( isrootmoudle.equals("0") ) supmoduleid = moudleid ;

rs.executeSql(" select * from " + moudletablename + " where inputid = " + inputid ) ;
if( rs.next() ) {
    inputsubject = Util.toScreen(rs.getString("inputsubject"),user.getLanguage()) ;
    createrid = Util.null2String(rs.getString("createrid")) ;
    confirmid = Util.null2String(rs.getString("confirmid")) ;
    createdate = Util.null2String(rs.getString("createdate")) ;
    confirmdate = Util.null2String(rs.getString("confirmdate")) ;
    inputstatus = Util.null2String(rs.getString("inputstatus")) ;

    hasvalue = true ;
}


if( ( inputstatus.equals("") || inputstatus.equals("0") || inputstatus.equals("3") ) && createrid.equals(userid) ) canSubmit = true ;
if( inputstatus.equals("1") && confirmid.equals(userid) ) {
    canConfirm = true ;
}
if( canSubmit || canConfirm ) canEdit = true ;

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = Util.toScreen("任务编辑",user.getLanguage(),"0") + "-" + moudlename;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id=frmMain name=frmMain action="TaskOperation.jsp" method=post onsubmit="return check_form(this,'inputsubject')">
<input type="hidden" name="moudleid" value="<%=moudleid%>">
<input type="hidden" name="supmoduleid" value="<%=supmoduleid%>">
<input type="hidden" name="inputid" value="<%=inputid%>">
<input type="hidden" name="oldinputstatus" value="<%=inputstatus%>">
<input type="hidden" name=operation>

<DIV class=HdrProps></DIV>
<DIV>
<% if( canSubmit ) {%>
<BUTTON class=btnSave accessKey=C onclick="doDraft()"><U>C</U>-草稿</BUTTON>
<BUTTON class=btnSave accessKey=S onclick="doSubmit()"><U>S</U>-提交</BUTTON>
<%} if( canConfirm ) { %>
<BUTTON class=btnSave accessKey=S onclick="doDraft()"><U>S</U>-保存</BUTTON>
<%}%>
<BUTTON class=Btn id=button1 accessKey=R name=button1 onclick="location.href='TaskView.jsp?inputid=<%=inputid%>&moudleid=<%=supmoduleid%>'"><U>R</U>-返回</BUTTON>
</DIV>
<br>
<% if ( canEdit ) { %>
  <table class=form>
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
    <tbody> 
    <tr class=Section>
      <td><nobr><b><%=moudlename%></font></b></td>
      <td align=right colspan=2></td>
    </tr>
	<tr class=separator> 
      <td class=Sep2 colspan=2></td>
    </tr>
    <% if( isrootmoudle.equals("0") ) { %>
    <TR> 
      <TD>任务主题</TD>
      <TD class=Field> 
        <INPUT type=text size=50 name="inputsubject" onchange='checkinput("inputsubject","inputsubjectimage")' value="<%=inputsubject%>">
        <SPAN id=inputsubjectimage></SPAN></TD>
    </TR>
    <%}%>
	<% 
	rs1.executeProc("SysModItemDsp_SByModid",""+moudleid);
	while(rs1.next()) {
		String itemid = Util.null2String(rs1.getString("itemid")) ;
		String itemdspname = Util.toScreen(rs1.getString("itemdspname"),user.getLanguage()) ;
        String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
        String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
        String itembroswertype = Util.null2String(rs1.getString("itembroswertype")) ;
        String fieldvalue = "" ;
        if( hasvalue ) fieldvalue = Util.toScreenToEdit(rs.getString(itemfieldname),user.getLanguage()) ;
	%>
	<TR>
      <td <%if(itemfieldtype.equals("6")){%> valign=top <%}%>><%=itemdspname%></td>
      <td class=Field>
      <%
        if(itemfieldtype.equals("1")){                          // 单行文本框中的文本
      %>
        <input type=text name="field_<%=itemid%>" size=50 value="<%=fieldvalue%>">
      <%
        } else if(itemfieldtype.equals("2")){                     // 单行文本框中的整型
      %>
        <input type=text name="field_<%=itemid%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this)" value="<%=fieldvalue%>">
       <%
        } else if(itemfieldtype.equals("3")){                     // 单行文本框中的浮点型
       %>
        <input type=text name="field_<%=itemid%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)" value="<%=fieldvalue%>">
       <%
	    } else if(itemfieldtype.equals("6")){                     // 多行文本框
       %>
        <textarea name="field_<%=itemid%>" rows="4" cols="40" style="width:80%"><%=fieldvalue%></textarea>
       <%
	    } else if(itemfieldtype.equals("5")){                         // 浏览按钮 (涉及workflow_broswerurl表)
		    String url=BrowserComInfo.getBrowserurl(itembroswertype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(itembroswertype);    // 浏览值点击的时候链接的url

            String showname = "" ;
            String sql = "" ;
            if(itembroswertype.equals("2") || itembroswertype.equals("19") )  showname=fieldvalue; // 日期时间
            else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(itembroswertype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(itembroswertype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(itembroswertype);   //浏览框对应的表值字段
                
                if(itembroswertype.equals("17")|| itembroswertype.equals("18")||itembroswertype.equals("27")||itembroswertype.equals("37")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                rs2.executeSql(sql);
                while(rs2.next()) showname += Util.toScreen(rs2.getString(2),user.getLanguage()) + " " ;
            }
	   %>
        <button class=Browser onclick="onShowBrowser('<%=itemid%>','<%=url%>','<%=linkurl%>','<%=itembroswertype%>')" title="选择"></button> 
        <input type=hidden name="field_<%=itemid%>" value="<%=fieldvalue%>">
        <span id="field_<%=itemid%>span"><%=showname%></span> 
       <%
	    } else if(itemfieldtype.equals("4")){                     // 选择框   select
	   %>
        <select name="field_<%=itemid%>">
	   <%
            // 查询选择框的所有可以选择的值
            rs2.executeProc("SystemModItemDetail_SByItemid",itemid);
            while(rs2.next()){
                String tmpselectvalue = Util.toScreenToEdit(rs2.getString("itemvalue"),user.getLanguage());
	   %>
	    <option value="<%=tmpselectvalue%>" <% if(tmpselectvalue.equals(fieldvalue)){%>selected<%}%>><%=tmpselectvalue%></option>
	   <%
            }
       %>
	    </select>
       <%   
        }                                          // 选择框条件结束 所有条件判定结束
       %>
       </td>
    </tr>
	<%}%>
    </tbody>
  </table>
<%} else {%>
  <table class=form>
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
    <tbody> 
    <tr class=Section>
      <td><nobr><b><%=moudlename%></font></b></td>
      <td align=right colspan=2></td>
    </tr>
	<tr class=separator> 
      <td class=Sep2 colspan=2></td>
    </tr>
    <% if( isrootmoudle.equals("0") ) { %>
    <TR> 
      <TD>任务主题</TD>
      <TD class=Field><%=inputsubject%></TD>
    </TR>
    <% }%>
	<% 
	rs1.executeProc("SysModItemDsp_SByModid",""+moudleid);
	while(rs1.next()) {
		String itemid = Util.null2String(rs1.getString("itemid")) ;
        String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
		String itemdspname = Util.toScreen(rs1.getString("itemdspname"),user.getLanguage()) ;
        String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
        String itembroswertype = Util.null2String(rs1.getString("itembroswertype")) ;
	%>
	<TR>
      <td <%if(itemfieldtype.equals("6")){%> valign=top <%}%>><%=itemdspname%></td>
      <td class=Field>
      <%
        if(!itemfieldtype.equals("5")){                          // 文本
      %>
        <%=Util.toScreen(rs.getString(itemfieldname),user.getLanguage())%>
      <%
        } else {                                                // 浏览按钮 (涉及workflow_broswerurl表)
            String showname = "" ;
            String sql = "" ;
            String fieldvalue = Util.null2String(rs.getString(itemfieldname)) ;
            if(itembroswertype.equals("2") || itembroswertype.equals("19") )  showname=fieldvalue; // 日期时间
            else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(itembroswertype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(itembroswertype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(itembroswertype);   //浏览框对应的表值字段
                String linkurl=BrowserComInfo.getLinkurl(itembroswertype);    // 浏览值点击的时候链接的url
                
                if(itembroswertype.equals("17")|| itembroswertype.equals("18")||itembroswertype.equals("27")||itembroswertype.equals("37")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                rs2.executeSql(sql);
                while(rs2.next()) {
                    String tempshowid = Util.null2String(rs2.getString(1)) ;
                    String tempshowname = Util.toScreen(rs2.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals("")){
                        showname += "<a href='"+linkurl+tempshowid+"'>"+tempshowname+"</a> " ;
                    }
                    else 
                        showname += tempshowname + " " ;
                }
            }
      %>
        <%=showname%>
      <%
        } 
      %>
       </td>
    </tr>
	<%}%>
    </tbody>
  </table>
<% } %>

<% if( isrootmoudle.equals("0") && canEdit ) { %>
<br>
<TABLE class=ListShort>
  <COLGROUP>
  <COL width="5%">
  <COL width="50%">
  <COL width="45%">
  <TBODY>
  <tr class=Section> 
      <th colspan=3>选择需要执行的任务及负责人</th>
    </tr>
  <TR class=separator>
    <TD class=Sep1 colSpan=3 ></TD>
  </TR>
  <TR class=Header>
  <th>选择</th>
  <th>任务名称</th>
  <th>负责人</th>
  </tr>
<%
    boolean isLight = false;
    ArrayList selectmoduleids = new ArrayList() ;
    ArrayList selectcreaterids = new ArrayList() ;

    rs.executeProc("SystemMoudle_SBySelID",inputid);
    while(rs.next()) {
        String submoudleid = Util.null2String(rs.getString("moudleid")) ;
        String submoudlecreater = Util.null2String(rs.getString("moudlecreater")) ;
        selectmoduleids.add(submoudleid) ;
        selectcreaterids.add(submoudlecreater) ;
    }

    rs.executeProc("SystemMoudle_SBySupID",moudleid);
    while(rs.next()) {
        String submoudleid = Util.null2String(rs.getString("moudleid")) ;
        String submoudletablename = Util.null2String(rs.getString("moudletablename")) ;
        String submoudlename = Util.toScreen(rs.getString("moudlename"),user.getLanguage()) ;
        String submoudlecreater = Util.null2String(rs.getString("moudlecreater")) ;
        int selectindex = selectmoduleids.indexOf(submoudleid) ;
        String selectmoudlecreater = "" ;
        if( selectindex != -1 ) selectmoudlecreater = (String) selectcreaterids.get(selectindex) ; 
    %>
       <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
         <TD><input type=checkbox name="checkmoduleid" value="<%=submoudleid%>" <% if( selectindex != -1 ) {%>checked<%}%>></TD>
         <td><%=submoudlename%></td>
         <td>
          <select name="checkmoudlecreater_<%=submoudleid%>">
           <%
                // 查询选择框的所有可以选择的值
                String[]  submoudlecreaters = Util.TokenizerString2(submoudlecreater, ",") ;
                for( int i=0 ; i< submoudlecreaters.length ; i++ ) {
                    String tempmoudlecreater = submoudlecreaters[i] ;
                    String tempmoudlecreatername =  Util.toScreen(ResourceComInfo.getResourcename(tempmoudlecreater),user.getLanguage()) ;
           %>
            <option value="<%=tempmoudlecreater%>" <% if(tempmoudlecreater.equals(selectmoudlecreater)) {%> selected <%}%>><%=tempmoudlecreatername%></option>
           <%
                }
           %>
            </select>
         </TD>
	  </TR>
<%  } %>
    </tbody> 
 </table>
<br>
<% } %>
</form>

<script language=javascript>

function doDraft(){
    <% if( isrootmoudle.equals("0") ) { %>
        if( check_form(document.frmMain,"inputsubject")) {
            document.frmMain.operation.value="editdraft";
            document.frmMain.submit();
        }
    <% } else {
            if( hasvalue ) {
    %>
            document.frmMain.operation.value="editdraft";
            document.frmMain.submit();
    <%
            } else { 
    %>
            document.frmMain.operation.value="adddraft";
            document.frmMain.submit();
    <%
            }
       }
    %>
}


function doSubmit(){
    <% if( isrootmoudle.equals("0") ) { %>
        if( check_form(document.frmMain,"inputsubject")) {
            document.frmMain.operation.value="editnew";
            document.frmMain.submit();
        }
    <% } else {
            if( hasvalue ) {
    %>
            document.frmMain.operation.value="editnew";
            document.frmMain.submit();
    <%
            } else { 
    %>
            document.frmMain.operation.value="addnew";
            document.frmMain.submit();
    <%
            }
       }
    %>
}
</script>
 
<script language=vbs>
 
sub onShowBrowser(id,url,linkurl,type1)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		
		document.all("field_"+id+"span").innerHtml = id1
		document.all("field_"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field_"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("field_"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("field_"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("field_"+id+"span").innerHtml = sHtml
					
				else
					document.all("field_"+id+"span").innerHtml = empty
					document.all("field_"+id).value=""
				end if
				
			else	
			   if  id1(0)<>""  and id1(0)<> "0"  then
			        if linkurl = "" then 
						document.all("field_"+id+"span").innerHtml = id1(1)
					else 
						document.all("field_"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("field_"+id).value=id1(0)
				else
					document.all("field_"+id+"span").innerHtml = empty
					document.all("field_"+id).value=""
				end if
			end if
		end if
	end if
end sub

</script>
 
</BODY></HTML>
