
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.dmlaction.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.FieldBase" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css"></HEAD>
<%
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
boolean needcheckds = Util.null2String(request.getParameter("needcheckds")).equals("true");
int dmlformid = Util.getIntValue(Util.null2String(request.getParameter("dmlformid")),0);
int dmlisdetail = Util.getIntValue(Util.null2String(request.getParameter("dmlisdetail")),0);
String dmltablename = Util.null2String(request.getParameter("dmltablename"));

if((needcheckds&&!"".equals(datasourceid))||!needcheckds)
{
	if(!"".equals(dmltablename))
		FieldBase.getDmltableFields(user,RecordSet,datasourceid,dmlformid,dmltablename,dmlisdetail);
}
Map allcolnums = FieldBase.getAllcolnums();
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/dmlaction/dmlTableFieldsBrowser.jsp" method=post>
<input type="hidden" id="datasourceid" name="datasourceid" value="<%=datasourceid%>">
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
			<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" style="width: 100%">
			<TR class=DataHeader>
			<TH width=70%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH><!-- 字段名称 -->
			<TH width=30%><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></TH><!-- 字段类型 -->
			</TR>
			<TR class=Line><TH colspan="2" ></TH></TR> 
			<%
			if(null!=allcolnums&&allcolnums.size()>0)
			{
				String dbtype = DBTypeUtil.getDataSourceDbtype(RecordSet,datasourceid);
				boolean isright = true;
				Set columnSet = allcolnums.keySet();
				for(Iterator i = columnSet.iterator();i.hasNext();)
				{
					String fieldname = Util.null2String((String)i.next());
					String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
					boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
			%>
				<tr height="20px" class=<%if(isright){ %>DataLight<%}else{%>DataDark<%} %>>
					<td><%=fieldname %></td>
					<td><%=fielddbtype %></td>
					<td style="display:none;"><%=iscanhandle %></td>
				</tr>
			<%
					isright = isright?false:true;
				}
			}
			%>
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

</BODY>
</HTML>


<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick1()
	window.parent.returnvalue = Array("","","")
	window.parent.close
End Sub
Sub BrowseTable_onclick1()
	Set e = window.event.srcElement
	If e.TagName = "TD" Then   	
		window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(2).innerText)
		window.parent.Close
	ElseIf e.TagName = "A" Then
		window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(2).innerText)
		window.parent.Close
	End If
End Sub
Sub BrowseTable_onmouseover1()
	Set e = window.event.srcElement
	If e.TagName = "TD" Then
		e.parentelement.className = "Selected"
	ElseIf e.TagName = "A" Then
		e.parentelement.parentelement.className = "Selected"
	End If
End Sub
Sub BrowseTable_onmouseout1()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>
<script language="javascript">
function onClear()
{
	btnclear_onclick() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	var curTr=jQuery(target).parents("tr")[0];
     window.parent.returnValue = {
    		 id:jQuery(curTr.cells[0]).text(),
    		 name:jQuery(curTr.cells[1]).text(),
    		 a1:jQuery(curTr.cells[2]).text()
      };
      window.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.returnvalue ={id:"",name:""}
	window.parent.close();
}

jQuery(function(){
	jQuery("#BrowseTable").mouseover(BrowseTable_onmouseover);
	jQuery("#BrowseTable").mouseout(BrowseTable_onmouseout);
	jQuery("#BrowseTable").click(BrowseTable_onclick);
	
	//$("#btncancel").click(btncancel_onclick);
	//$("#btnsub").click(btnsub_onclick);
	
	jQuery("#btnclear").click(btnclear_onclick);
	
});

</script>