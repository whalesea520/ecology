
<%@page import="weaver.page.HPTypeEnum"%>
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
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
 <style>
    .zDialog_div_content{
	  height:100%;
	}
 </style>
</HEAD>
<%

String elementbaseid = Util.null2String(request.getParameter("ebaseid"));
String synergybaseid = Util.null2String(request.getParameter("sbaseid"));
String stype = Util.null2String(request.getParameter("stype"));
String spagetype = Util.null2String(request.getParameter("spagetype"));
String sysparam = Util.null2String(request.getParameter("sysparam"));
String linkwfid = Util.null2String(request.getParameter("wfid"));
String wfformparam = Util.null2String(request.getParameter("wfformparam"));
String pagetype = Util.null2String(request.getParameter("pagetype"));
String ispagedeal = Util.null2String(request.getParameter("ispagedeal"));

if(!wfformparam.equalsIgnoreCase("")){
	synergybaseid = wfformparam.split("-")[0];
	elementbaseid = wfformparam.split("-")[1];
}
baseBean.writeLog("wfformparam"+wfformparam);
int saddpage = Util.getIntValue(request.getParameter("saddpage"));
if(sysparam.equals("sys"))
{
	elementbaseid = "sysparam";
}

HashMap spcmap = (HashMap)spc.getParamnameList(elementbaseid,Math.abs(Util.getIntValue(synergybaseid)));
ArrayList pidlist = (ArrayList)spcmap.get("paramid");
ArrayList pnamelist = (ArrayList)spcmap.get("paramname");
ArrayList plabellist = (ArrayList)spcmap.get("paramlabel");
ArrayList ptypelist = (ArrayList)spcmap.get("paramtype");
ArrayList pbrowlist = (ArrayList)spcmap.get("browid");
String wfid ="";
if((linkwfid.equals("-1")||linkwfid.equals("")) && stype.equals("wf") && spagetype.equals("operat") && (elementbaseid.equals("8") || elementbaseid.equals("reportForm") )){
	wfid = sc.getWfidByHpid(Math.abs(Util.getIntValue(synergybaseid))+"");
}

if(wfid.equals("") && (elementbaseid.equals("8") || elementbaseid.equals("reportForm"))){
	wfid = linkwfid;
}

String secid = "";
if(stype.equals("doc") && (elementbaseid.equals("7") || elementbaseid.equals("reportForm")) && spagetype.equals("operat") && saddpage == 0)
{
	secid = sc.getWfidByHpid(Math.abs(Util.getIntValue(synergybaseid))+"");
	//baseBean.writeLog("SynergyParamBrower.jsp docid:===>"+secid);
}
ArrayList flist = null;
%>
<BODY>
<div class="zDialog_div_content">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
    <DIV align=right>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
</DIV>
<wea:layout type="table"  attributes="{'formTableId':'BrowseTable','cols':'4'}" needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
	<%if(sysparam.equals("sys"))
	{ %>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage()) %></wea:item>    
      	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84276,user.getLanguage()) %></wea:item>
      	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(81710,user.getLanguage()) %></wea:item>
      	<wea:item type="thead"></wea:item>
	    <%
		for (int i=0;i<pnamelist.size();i++)
		{
			String paraname = pnamelist.get(i).toString();
			String paralabel = plabellist.get(i).toString();
			String paratype = ptypelist.get(i).toString();
			String paraid = pidlist.get(i).toString();
		%>
		<wea:item><%=paraname%>
		<input type=hidden name=pval value=<%=paraname %>><input type=hidden name=pid value=<%=paraid %>>
		<input type=hidden name=browerid value=<%="undefined" %> >
		<input type=hidden name=ptype value=<%=paratype %> >
		<input type=hidden name=solo value="undefined" >
		<input type=hidden name=issyid value="-1"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(paralabel),user.getLanguage())%></wea:item>
		<wea:item><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(paratype)),user.getLanguage()))%></wea:item>
		<wea:item></wea:item>
		<%}%>
	<%}else{ %>
      	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></wea:item> 
      	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
      	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>
      	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></wea:item>
		<%
		
		for (int i=0;i<pnamelist.size();i++)
		{
			String paraname = pnamelist.get(i).toString();
			String paralabel = plabellist.get(i).toString();
			String paratype = ptypelist.get(i).toString();
			String paraid = pidlist.get(i).toString();
			String parabrowid = pbrowlist.get(i).toString();
			String _label = sowf.getFieldType(parabrowid,paratype+"+"+paraname+"+"+user.getLanguage()+"+"+"sysfield");
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(paralabel),user.getLanguage())%>
			<input type=hidden name=pval value=<%=paraname %>>
			<input type=hidden name=pid value=<%=paraid %>>
			<input type=hidden name=browerid value=<%=parabrowid %> >
			<input type=hidden name=ptype value=<%=paratype %> >
			<input type=hidden name=solo value="<%=parabrowid+"+"+_label %>" >
			<input type=hidden name=issyid value="0"></wea:item>
		<wea:item><%=paraname%></wea:item>
		<wea:item><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(paratype)),user.getLanguage()))%></wea:item>
		<wea:item><%=_label %></wea:item>
		<%}%>
		<%
	
		//流程表单字段
		if(!wfid.equals(""))
		{
			
			//baseBean.writeLog("SynergyParamBrower.jsp 获取关于流程表单的自定义字段");
			flist = sowf.getWFFieldByWFID(wfid,user);
			
			if(flist !=null && flist.size() > 0)
			{
				for(int j=0;j<flist.size();j++)
				{
					
					
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
					<wea:item><%=paralabel%>
						<input type=hidden name=pval value=<%=paraname %>>
						<input type=hidden name=pid value=<%=paraid %>>
						<input type=hidden name=browerid value="<%=paratype %>">
						<input type=hidden name=ptype value=<%=parahtmltype %> >
						<input type=hidden name=solo value="<%=lv %>" >
						<input type=hidden name=issyid value="1"><!-- 流程为1 -->
						<input type=hidden name=isbill value="<%=parabill %>" >
						<input type=hidden name=formid value="<%=paraformid %>" >
					</wea:item>
					<wea:item><%=paraname%></wea:item>
					<wea:item><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(parahtmltype)),user.getLanguage()))%></wea:item>
					<wea:item><%=_label %></wea:item>
					<%}
				}
			}%>
			
			
			<%
		//流程表单字段(且为处理页面)
		if(!linkwfid.equals("") && ispagedeal.equals("1"))
		{
				
			//baseBean.writeLog("SynergyParamBrower.jsp 获取关于流程表单的自定义字段");
			flist = sowf.getWFFieldByWFID(linkwfid,user);

			
			///return;

			if(flist !=null && flist.size() > 0)
			{
				for(int j=0;j<flist.size();j++)
				{
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
					if(parahtmltype.equals("5") && !"".equals(lv)  && !"+".equals(lv))
						_label = Util.TokenizerString2(lv,"+")[1];
					else
						_label = lv;
					%>
					<wea:item><%=paralabel%>
						<input type=hidden name=pval value=<%=paraname %>>
						<input type=hidden name=pid value=<%=paraid %>>
						<input type=hidden name=browerid value="<%=paratype %>">
						<input type=hidden name=ptype value=<%=parahtmltype %> >
						<input type=hidden name=solo value="<%=lv %>" >
						<input type=hidden name=issyid value="1"><!-- 流程为1 -->
						<input type=hidden name=isbill value="<%=parabill %>" >
						<input type=hidden name=formid value="<%=paraformid %>" >
					</wea:item>
					<wea:item><%=paraname%></wea:item>
					<wea:item><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(parahtmltype)),user.getLanguage()))%></wea:item>
					<wea:item><%=_label %></wea:item>
					<%}
				}
			}%>
			
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
						if(parahtmltype.equals("5"))
							_label = Util.TokenizerString2(lv,"+")[1];
						else
							_label = lv;
				%>
					<wea:item><%=paralabel%>
					<input type=hidden name=pval value=<%=paraname %>>
					<input type=hidden name=pid value=<%=key %>>
					<input type=hidden name=browerid value="<%=paratype %>">
					<input type=hidden name=ptype value=<%=parahtmltype %> >
					<input type=hidden name=solo value="<%=lv %>" >
					<input type=hidden name=issyid value="2">	<!-- 文档为2 -->
					</wea:item>
					<wea:item><%=paraname%></wea:item>
					<!-- 跟流程通用 -->
					<wea:item><%=Util.null2String(SystemEnv.getHtmlLabelName(sowf.transLabel4FieldbyHtmltype(Util.getIntValue(parahtmltype)),user.getLanguage()))%></wea:item>
					<wea:item><%=_label%></wea:item>
				
				<%}
			}
		}
	}%>
<%}%>
</wea:group>
</wea:layout>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</div> 
<script type="text/javascript">
	var weaverSplit = "||~WEAVERSPLIT~||";
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.parent.getParentWindow(parent.parent);
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(e){}
	
	
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
	
	function BrowseTable_onclick(){
		var e=e||event;
   		var target=e.srcElement||e.target;

   		if( target.nodeName =="TD"||target.nodeName =="A"  ){
   		
		 	var _pval = $(target).parent("TR").find("input[name=pval]").val();
		 	var _ptype = $(target).parent("TR").find("input[name=ptype]").val();
		 	var _browerid = $(target).parent("TR").find("input[name=browerid]").val();
		 	var _solo = $(target).parent("TR").find("input[name=solo]").val();
		 	var _issyid = $(target).parent("TR").find("input[name=issyid]").val();
		 	var _formid = "";
		 	var _isbill = "";
		 	var _stype = "<%=stype%>";
		 	var pfieldstr = _pval + weaverSplit + _ptype + weaverSplit + _browerid + weaverSplit + _solo + weaverSplit + _issyid;
		 	if(_issyid === "1" && (_stype === "wf" || <%=HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(stype)%>))
		 	{
		 		_formid = $(target).parent("TR").find("input[name=formid]").val();
		 		_isbill = $(target).parent("TR").find("input[name=isbill]").val();
		 		pfieldstr = pfieldstr + weaverSplit + _formid + weaverSplit + _isbill;
		 	}
		 	var returnjson;
		 	if(_issyid==="-1")
		 	{
		 		returnjson = 
				{
					id:$(target).parent("TR").find("input[name=pid]").val(),
					name:jQuery($(target).parent("TR")[0].cells[1]).text(),
					pfiled:pfieldstr
				};
		 	}else
		 	{
		 		returnjson = 
				{
					id:$(target).parent("TR").find("input[name=pid]").val(),
					name:jQuery($(target).parent("TR")[0].cells[0]).text(),
					pfiled:pfieldstr
				};
		 	}
			if(dialog){
				dialog.callback(returnjson);
			}else{
		        window.parent.returnValue  = returnjson;
		        window.parent.close();
		    }
	    }
	}
		
	function replaceToHtml(str){
		var re = str;
		var re1 = "<";
		var re2 = ">";
		do{
			re = re.replace(re1,"&lt;");
			re = re.replace(re2,"&gt;");
	        re = re.replace(",","，");
		}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
		return re;
	}

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

