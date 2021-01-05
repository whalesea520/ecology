
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="spc" class="weaver.synergy.SynergyParamsComInfo" scope="page" />
<jsp:useBean id="sgwff" class="weaver.synergy.SynergyGetWFField" scope="page" />
<jsp:useBean id="sowf" class="weaver.synergy.SynergyOperatWorkflow" scope="page" />
<jsp:useBean id="sod" class="weaver.synergy.SynergyOperatDoc" scope="page" />
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page" />
<jsp:useBean id="scdpci" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%@ page import="weaver.synergy.SynergyGetWFField" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<style>
     .zDialog_div_content {
		height: 100%;
	  }
</style>
</HEAD>

<%

String elementbaseid = Util.null2String(request.getParameter("ebaseid"));
String synergybaseid = Util.null2String(request.getParameter("sbaseid"));
String sysparam = Util.null2String(request.getParameter("sysparam"));
String wfformparam = Util.null2String(request.getParameter("wfformparam"));
if(!wfformparam.equalsIgnoreCase("")){
	synergybaseid=wfformparam;
}else if(sysparam.equals("sys"))
{
	elementbaseid = "sysparam";
}
//String linkwfid = wfformparam.split("=")[0];
//if(!linkwfid.equalsIgnoreCase("")){
//	synergybaseid = wfformparam.split("=")[1];
//}
//if(!linkwfid.equalsIgnoreCase("")){
//	elementbaseid = wfformparam.split("=")[2];
//}
//int saddpage = Util.getIntValue(request.getParameter("saddpage"));
//if(sysparam.equalsIgnoreCase("sys"))
//{
//	elementbaseid = "sysparam";
//}
//baseBean.writeLog("wfformparam:"+wfformparam+";linkwfid:"+linkwfid+";elementbaseid:"+elementbaseid+";synergybaseid:"+synergybaseid);
HashMap spcmap = (HashMap)spc.getParamnameList(elementbaseid,Math.abs(Util.getIntValue(synergybaseid)));
ArrayList pidlist = (ArrayList)spcmap.get("paramid");
ArrayList pnamelist = (ArrayList)spcmap.get("paramname");
ArrayList plabellist = (ArrayList)spcmap.get("paramlabel");
ArrayList ptypelist = (ArrayList)spcmap.get("paramtype");
ArrayList pbrowlist = (ArrayList)spcmap.get("browid");
baseBean.writeLog("spcmap:"+spcmap);

String wfid ="";
String stype = Util.null2String(request.getParameter("stype"));
String spagetype = Util.null2String(request.getParameter("spagetype"));
if(!wfformparam.equalsIgnoreCase("") || stype.equals("wf") && spagetype.equals("operat") && (elementbaseid.equals("8") || elementbaseid.equals("reportForm")))
{
	//wfid = sc.getWfidByHpid(Math.abs(Util.getIntValue(synergybaseid))+"");
	RecordSet.execute("select wfid from synergy_base where id = " + Math.abs(Util.getIntValue(synergybaseid)));
	if (RecordSet.next()) {
		wfid  = RecordSet.getString("wfid");
	}
}
String secid = "";
if(stype.equals("doc") && (elementbaseid.equals("7") || elementbaseid.equals("reportForm")) && spagetype.equals("operat"))
{
	//secid = sc.getWfidByHpid(Math.abs(Util.getIntValue(synergybaseid))+"");
	//baseBean.writeLog("SynergyParamBrower.jsp docid:===>"+secid);
	RecordSet.execute("select wfid from synergy_base where id = " + Math.abs(Util.getIntValue(synergybaseid)));
	if (RecordSet.next()) {
		secid  = RecordSet.getString("wfid");
	}
}
ArrayList flist = null;

baseBean.writeLog("wfid==="+wfid);
%>
<BODY>
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SynergyParamBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON  class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
    <TR class=spacing style="height: 1px"> 
      <TD class=line1 colspan=4></TD>
    </TR>
    <TR> 
      <TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=currencyname>
      </TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=currencydesc>
      </TD>
    </TR>
    </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<%if(sysparam.equals("sys")){ %>
	<TR class=DataHeader>
      <TH width=20%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH width=20%><%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%></TH>
      <TH width=30%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
      </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH>
    </TR>
    
    <%
for (int i=0;i<pnamelist.size();i++)
{
	if(i%2 == 0){
%>
<TR class=DataLight>
<%
	}else{
%>
<TR class=DataDark>
<%
}
	String paraname = pnamelist.get(i).toString();
	String paralabel = plabellist.get(i).toString();
	String paratype = ptypelist.get(i).toString();
	String paraid = pidlist.get(i).toString();
%>
	<TD><%=paraname%>
		<input type=hidden name=pval value=<%=paraname %>><input type=hidden name=pid value=<%=paraid %>>
		<input type=hidden name=browerid value=<%="undefined" %> >
		<input type=hidden name=ptype value=<%=paratype %> >
		<input type=hidden name=solo value="undefined" >
		<input type=hidden name=issyid value="-1"></TD>
	<TD><%=SystemEnv.getHtmlLabelName(Util.getIntValue(paralabel),user.getLanguage())%></TD>
	<TD><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(paratype)),user.getLanguage()))%></TD>
	
</TR>
<%}
%>
    
<%}else{ %>
<TR class=DataHeader>
      <TH width=35%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH>  
      <TH width=30%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TH>
      <TH width=19%><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></TH>
      <TH width=19%><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></TH>
      </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH>
    </TR>
     
<%
for (int i=0;i<pnamelist.size();i++)
{
	if(i%2 == 0){
%>
<TR class=DataLight>
<%
	}else{
%>
<TR class=DataDark>
<%
}
	String paraname = pnamelist.get(i).toString();
	String paralabel = plabellist.get(i).toString();
	String paratype = ptypelist.get(i).toString();
	String paraid = pidlist.get(i).toString();
	String parabrowid = pbrowlist.get(i).toString();
	String _label = sowf.getFieldType(parabrowid,paratype+"+"+paraname+"+"+user.getLanguage()+"+"+"sysfield");
%>
	<TD><%=SystemEnv.getHtmlLabelName(Util.getIntValue(paralabel),user.getLanguage())%>
		<input type=hidden name=pval value=<%=paraname %>><input type=hidden name=pid value=<%=paraid %>>
		<input type=hidden name=browerid value=<%=parabrowid %> >
		<input type=hidden name=ptype value=<%=paratype %> >
		<input type=hidden name=solo value="<%=parabrowid+"+"+_label %>" >
		<input type=hidden name=issyid value="0"></TD>
	<TD><%=paraname%></TD>
	<TD><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(paratype)),user.getLanguage()))%></TD>
	<TD><%=_label %></TD>
</TR>
<%}
%>
<%
//流程表单字段
if(!wfid.equals(""))
{
	flist = sowf.getWFFieldByWFID(wfid,user);
	if(flist !=null && flist.size() > 0)
	{
		for(int j=0;j<flist.size();j++)
		{
			if(j%2 == 0){
			%>
			<TR class=DataLight>
			<%
				}else{
			%>
			<TR class=DataDark>
			<%
			}
			sgwff = (SynergyGetWFField)flist.get(j);
			String paraname = sgwff.getFieldname();
			String paralabel = sgwff.getFieldlable();
			String paraid = sgwff.getFieldid();
			String parahtmltype = sgwff.getFieldhtmltype();
			String paratype = sgwff.getFieldtype();
			String paravalue = sgwff.getFieldvalue();
			String paraformid = sgwff.getFieldformid();
			String parabill = sgwff.getFieldbill();
			String lv = sowf.getFieldType(paratype,parahtmltype+"+"+paraid+"+"+user.getLanguage()+"+"+"formfield");
			String _label = "";
			if(parahtmltype.equals("5") && !"".equals(lv) && !"+".equals(lv))
				_label = Util.TokenizerString2(lv,"+")[1];
			else
				_label = lv;
			%>
			<TD><%=paralabel%>
				<input type=hidden name=pval value=<%=paraname %>>
				<input type=hidden name=pid value=<%=paraid %>>
				<input type=hidden name=browerid value="<%=paratype %>">
				<input type=hidden name=ptype value=<%=parahtmltype %> >
				<input type=hidden name=solo value="<%=lv %>" >
				<input type=hidden name=issyid value="1"><!-- 流程为1 -->
				<input type=hidden name=isbill value="<%=parabill %>" >
				<input type=hidden name=formid value="<%=paraformid %>" >
			</TD>
			<TD><%=paraname%></TD>
			<TD><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(parahtmltype)),user.getLanguage()))%></TD>
			<TD><%=_label %></TD>
			</TR>
<%
		}
	}
}
%>

<%
//文档目录自定义字段
if(!secid.equals(""))
{
	baseBean.writeLog("SynergyParamBrower.jsp 获取关于文档的自定义字段");
	flist = sod.getDocFieldByDocid(secid,user);
	if(flist != null && flist.size() > 0)
	{
		for(int k=0;k<flist.size();k++)
		{
			if(k%2 == 0){
				%>
				<TR class=DataLight>
				<%
					}else{
				%>
				<TR class=DataDark>
				<%}
			String key = flist.get(k)+"";
			String paralabel = "";
			if(!scdpci.getVisible(key).equals("0") && scdpci.getIsCustom(key).equals("1"))
			{
				paralabel = Util.null2String(scdpci.getLabelId(key));
				if(Util.getIntValue(paralabel) == -1)
					paralabel = Util.null2String(scdpci.getCustomName(key));
				else
					paralabel = SystemEnv.getHtmlLabelName(Util.getIntValue(paralabel),user.getLanguage());
				CustomFieldManager cfm = new CustomFieldManager(scdpci.getScope(key),Util.getIntValue(scdpci.getScopeId(key)));
				cfm.getCustomFields(Util.getIntValue(scdpci.getFieldId(key)));
				cfm.next();
				String parahtmltype = cfm.getHtmlType();
				String paraname = cfm.getLable();
				String paratype = cfm.getType()+"";
				String lv = sod.getFieldType(paratype,parahtmltype+"+"+scdpci.getFieldId(key)+"+"+user.getLanguage()+"+"+"formfield");
				String _label = "";
				if(parahtmltype.equals("5") && !"".equals(lv) && !"+".equals(lv))
					_label = Util.TokenizerString2(lv,"+")[1];
				else
					_label = lv;
				%>
					<TD><%=paralabel%>
					<input type=hidden name=pval value=<%=paraname %>>
					<input type=hidden name=pid value=<%=key %>>
					<input type=hidden name=browerid value="<%=paratype %>">
					<input type=hidden name=ptype value=<%=parahtmltype %> >
					<input type=hidden name=solo value="<%=lv %>" >
					<input type=hidden name=issyid value="2">	<!-- 文档为2 -->
					</TD>
					<TD><%=paraname%></TD>
					<!-- 跟流程通用 -->
					<TD><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(parahtmltype)),user.getLanguage()))%></TD>
					<TD><%=_label%></TD>
				</TR>
				
				<%
			}
		}
	}
}
%>
<%}%>

</TABLE>
  
</FORM>
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
<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
	</script>
<script type="text/javascript">
jQuery(document).ready(function(){
	var weaverSplit = "||~WEAVERSPLIT~||";
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind
		("click",
		 function(){
		 	var _pval = $(this).find("td:first").find("input[name=pval]").val();
		 	var _ptype = $(this).find("td:first").find("input[name=ptype]").val();
		 	var _browerid = $(this).find("td:first").find("input[name=browerid]").val();
		 	var _solo = $(this).find("td:first").find("input[name=solo]").val();
		 	var _issyid = $(this).find("td:first").find("input[name=issyid]").val();
		 	var _formid = "";
		 	var _isbill = "";
		 	var _stype = "<%=stype%>";
		 	var pfieldstr = _pval + weaverSplit + _ptype + weaverSplit + _browerid + weaverSplit + _solo + weaverSplit + _issyid;
		 	if(_issyid === "1" && _stype === "wf" || "<%=wfid%>" != "" )
		 	{
		 		_formid = $(this).find("td:first").find("input[name=formid]").val();
		 		_isbill = $(this).find("td:first").find("input[name=isbill]").val();
		 		pfieldstr = pfieldstr + weaverSplit + _formid + weaverSplit + _isbill;
		 		//alert("pfieldstr1:"+pfieldstr);
		 	}
		 	var returnjson;
		 	if(_issyid==="-1")
		 	{
		 		returnjson = 
				{
					id:$(this).find("td:first").find("input[name=pid]").val(),
					name:$(this).find("td:first").next().text(),
					pfiled:pfieldstr
				};
		 	}else
		 	{
		 		returnjson = 
				{
					id:$(this).find("td:first").find("input[name=pid]").val(),
					name:$(this).find("td:first").text(),
					pfiled:pfieldstr
				};
		 	}
			if(dialog){
				dialog.callback(returnjson);
			}else{
		        window.parent.returnValue  = returnjson;
		        window.parent.close();
		    }
		});
})

function submitClear()
{
	var returnValue = {id:"",name:""};
	if(dialog){
		dialog.callback(returnValue);
	}else{ 
	    window.parent.returnValue  = returnValue;
	    window.parent.close();
	 }
}

</script>
</BODY></HTML>

