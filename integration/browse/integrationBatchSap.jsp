<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionImportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionExportParams"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionBaseParamBean"%>
<%@page import="com.weaver.integration.datesource.SAPFunctionAllParams"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet02" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML>
<base target="_self">
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%

		
		//Z_OSAP_MATERIAL_GETALL有输入字段的函数
		//BAPI_ROUTING_CREATE有输入结构,有输出结构,有输出参数
		//BAPI_MATERIAL_SAVEDATA多个结构体的
		String poolid="";
		String functionName="";
		String regservice=Util.null2String(request.getParameter("regservice"));//注册服务的id
		
		//查出该产品下的数据源的连接池id和SAP-ABAP函数名
		RecordSet02.execute("select * from sap_service where id='"+regservice+"'");
		while(RecordSet02.next())
		{
			poolid=RecordSet02.getString("poolid");
			functionName=RecordSet02.getString("funname");
		}
		//用于判断是远程获取参数还是本地获取参数，1是本地获取参数，2是远程获取参数
		String  islocal=Util.null2String(request.getParameter("islocal"));
		String type=Util.null2String(request.getParameter("type"));
		String stuortablevalue=Util.null2String(request.getParameter("stuortablevalue"));//如果type=3,表示输入结构的名称,type=6表示输出结构的名称,type=8表示输出表的名称
		String checkvalue=Util.null2String(request.getParameter("checkvalue"));//选中的一项值
		String operation=Util.null2String(request.getParameter("operation")); //operation操作类型1表示批量添加,2表示单个添加或修改
		if("".equals(operation)){operation="1";}
		//System.out.println("-----------页面日志------------");
		//System.out.println("连接池的id="+poolid);
		//System.out.println("函数的名字="+functionName);
		//System.out.println("类型type="+type);
		//System.out.println("(operation操作类型1表示批量添加,2表示单个添加或修改)="+operation);
		//System.out.println("选中的一项值="+checkvalue);
		//System.out.println("(如果type=3,表示输入结构的名称,type=6表示输出结构的名称,type=8表示输出表的名称)="+stuortablevalue);
		//System.out.println("获取参数的方式[1本地、2远程]"+islocal);
		//System.out.println("------------------------");
		
		String se_fieldname=Util.null2String(request.getParameter("se_fieldname")).toUpperCase().trim();
		String  se_fielddesc=Util.null2String(request.getParameter("se_fielddesc")).toUpperCase().trim();
%>
<BODY>

<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="integration"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84095,user.getLanguage()) %>"/>
		</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="onseach()">						
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;

if("1".equals(operation))
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311 ,user.getLanguage())+",javascript:onClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(82529,user.getLanguage())+",javascript:onseach(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div style="display:none">
<button type=button  class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O1</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
</div>

<form action="/integration/browse/integrationBatchSap.jsp" method="post"  id="SearchForm">

<input type='hidden'   name="regservice"  value='<%=regservice%>'>
<input type='hidden'   name="islocal"  value='<%=islocal%>'>
<input type='hidden'   name="type"  value='<%=type%>'>
<input type='hidden'   name="stuortablevalue"  value='<%=stuortablevalue%>'>
<input type='hidden'   name="checkvalue"  value='<%=checkvalue%>'>
<input type='hidden'   name="operation"  value='<%=operation%>'>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="*">
<col width="10">

<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" width="100%">
<wea:layout type="4Col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(23481,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<input type='text' name='se_fieldname' value='<%=se_fieldname%>'>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(30667,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<input type='text' name='se_fielddesc' value='<%=se_fielddesc%>'>
				</wea:item>
			</wea:group>
		
		</wea:layout>




<%
	if("1".equals(type)||"3".equals(type)||"4".equals(type)||"6".equals(type)||"8".equals(type)||"11".equals(type)||"12".equals(type))
	{
		if("1".equals(operation))
		{
		
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<th width=10% ><input type='checkbox' value='1' name='selectAll' id='selectAll' onclick='selectAllBox(this)'></th>");
			 out.println("<TH width=40% >"+SystemEnv.getHtmlLabelName(23481 ,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30667 ,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='3' ></Th></TR> ");
		}else
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(23481 ,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30667 ,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
		}
	}else if("2".equals(type)||"5".equals(type))
	{
		if("1".equals(operation))
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<th width=10% ><input type='checkbox' value='1' name='selectAll' id='selectAll' onclick='selectAllBox(this)'></th>");
			 out.println("<TH width=40% >"+SystemEnv.getHtmlLabelName(30668 ,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30670 ,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='3' ></Th></TR> ");
		}else
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30668 ,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30670 ,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
		}
	}else if("7".equals(type)||"10".equals(type))
	{
		if("1".equals(operation))
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<th width=10% ><input type='checkbox' value='1' name='selectAll' id='selectAll' onclick='selectAllBox(this)'></th>");
			 out.println("<TH width=40% >"+SystemEnv.getHtmlLabelName(30671 ,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30674 ,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='3' ></Th></TR> ");
		}else
		{
			 out.println("<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' width='100%'>");
			 out.println("<TR class=DataHeader>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30671 ,user.getLanguage())+"</TH>");
			 out.println("<TH width=50% >"+SystemEnv.getHtmlLabelName(30674 ,user.getLanguage())+"</TH>");
			 out.println("</tr>");
			 out.println("<TR class=Line  style='height:1px;'><th colspan='2' ></Th></TR> ");
		}
	}
	
	LogInfo li=new LogInfo();
	SAPFunctionAllParams sa=new SAPFunctionAllParams();
	SAPInterationOutUtil spout=new SAPInterationOutUtil();
	List list=new ArrayList();
	if("1".equals(islocal))//本地获取参数
	{
		//System.out.println("从本地抓取了参数............");
		list=spout.getLocallyParameters(regservice,type,stuortablevalue);
	}else//直接访问sap获取参数
	{
		//System.out.println("从远程抓取了参数............");
		sa=spout.getALLParamsByFunctionName(poolid,functionName,li);
		SAPFunctionImportParams saimport=sa.getSip();//得到所有的输入参数
		SAPFunctionExportParams saexp=sa.getSep();//得到所有的输出参数
		if("1".equals(type)){
			list=saimport.getStrList();//得到输入参数里面的所有项
		}else if("2".equals(type)){
			list=saimport.getStructList();//获取输入结构的名称集合
		}else if("3".equals(type)){
			list=spout.getParamsByFuncNameCompSty(poolid,functionName,"import",true,stuortablevalue,li);//获取某个输入结构的里面的参数
		}else if("4".equals(type)){
			list=saexp.getStrList();//得到输出参数里面的所有项
		}else if("5".equals(type)){
			list=saexp.getStructList();//获取输出结构结构的名称集合
		}else if("6".equals(type)){
			list=spout.getParamsByFuncNameCompSty(poolid,functionName,"export",true,stuortablevalue,li);//获取输出结构里面的输出参数
		}else if("7".equals(type)){
			list=saexp.getTableList();//获取输出表的名称集合
		}else if("8".equals(type)||"12".equals(type)){
			list=spout.getParamsByFuncNameCompSty(poolid,functionName,"export",false,stuortablevalue,li);//获取输出表里面的输出参数
		}else if("10".equals(type)){
			list=saimport.getTableList();//获取输入表的名称集合
		}else if("11".equals(type)){
			list=spout.getParamsByFuncNameCompSty(poolid,functionName,"import",false,stuortablevalue,li);//获取某个输入表下面的所有的参数
		}	
	}
	if(null!=list)
	{
		for(int h=0;h<list.size();h++) {
				SAPFunctionBaseParamBean sbpb = (SAPFunctionBaseParamBean)list.get(h);
				
				String  zh_Fieldname=sbpb.getParamName().toUpperCase().trim();
				String  zh_Fielddesc=sbpb.getParamDesc().toUpperCase().trim();
				if(zh_Fieldname.indexOf(se_fieldname)==-1){
					continue;
				}
				if(zh_Fielddesc.indexOf(se_fielddesc)==-1){
					continue;
				}
				if(h%2==0){
					out.println("<tr class=DataDark>");
				}else{
					out.println("<tr class=DataLight>");
				}
				if("1".equals(operation)){
					if(checkvalue.equals(sbpb.getParamName())){
						out.println("<td style='width:50px' style='padding-left:20px;'><input type=checkbox name='check_per' checked=checked></td>");
					}else{
						out.println("<td style='width:50px' style='padding-left:20px;'><input type=checkbox name='check_per'></td>");
					}
				}
			out.println("<td>"+zh_Fieldname+"</td>");
			out.println("<td>"+zh_Fielddesc+"</td>");
			out.println("</tr>");
		}
	}
	out.println("</TABLE>");
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
</form>
<div style="height:50px;"></div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
		 <input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClear();"/>
		
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</BODY></HTML>

<SCRIPT LANGUAGE="javascript">
var ids = "";
var names = "";
var dialog = top.getDialog(parent);

function btnok_onclick() {
	if(dialog){
		try{
	  	dialog.callback({id: ids, name: names});
	  	}catch(e){alert(e)}
	  	
	  	try{
		     dialog.close({id: ids, name: names});
		
		 }catch(e){alert(e)}
		dialog.callback();
	}else{
		window.parent.returnValue = {id: ids, name: names};//Array(documentids,documentnames)
    	window.parent.close();
	}
	
}
//多选
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if($(this)[0].tagName=="TR"&&event.target.tagName!="INPUT"){
			
			<%
				if("1".equals(operation))
				{
			%>
					var obj = jQuery(this).find("input[name=check_per]");
				   	if (obj.attr("checked") == true){
				   		   obj.attr("checked", false);
				   		   changeCheckboxStatus(obj,false);
				   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
				   		names = names.replace("," + replaceALL(jQuery(this).find("td:eq(2)").text(),",",""), "")
		
				   	}else{
				   		    obj.attr("checked", true);
				   		    changeCheckboxStatus(obj,true);
				   		ids = ids + "," + jQuery(this).find("td:eq(1)").text();
				   		names = names + "," + replaceALL(jQuery(this).find("td:eq(2)").text(),",","");
				   	}
			  <%
				}else
				{
			%>		
					ids = ","+jQuery(this).find("td:eq(0)").text()
			   		names =","+replaceALL(jQuery(this).find("td:eq(1)").text(),",","");
			   		submitData();
			<%		
				}
			%>

		}
		//点击checkbox框
	    if(event.target.tagName=="INPUT"){
	       var obj = jQuery(this).find("input[name=check_per]");
		   	if (obj.attr("checked") == true){
		   	    ids = ids + "," + jQuery(this).find("td:eq(1)").text();
		   		names = names + "," + replaceALL(jQuery(this).find("td:eq(2)").text(),",","");
		   	}else{
		   		ids = ids.replace("," + jQuery(this).find("td:eq(1)").text(), "")
		   		names = names.replace("," + replaceALL(jQuery(this).find("td:eq(2)").text(),",",""), "")
		   	}
	    }
		
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	})

});
function onSubmit() {
		$G("SearchForm").submit()
}
function onReset() {
		$G("SearchForm").reset()
}
function submitData()
{
	btnok_onclick();
}

function onCancel()
{
	if(dialog){
	  	dialog.close();
    }else{
	    window.parent.close();
    }
}

function onClear()
{
	if(dialog){
		try{
	  	dialog.callback({id: "0",name: ""});
	  	}catch(e){alert(e)}
	  	
	  	try{
		     dialog.close({id: "0",name: ""});
		
		 }catch(e){alert(e)}
    }else{
    	 window.parent.returnValue = {id: "0",name: ""};
     window.parent.close();
    }
	
}
function replaceALL(str,oldstr,newstr) 
{ 
   re=new RegExp(oldstr,"g"); 
   var newstart=str.replace(re,newstr); 
   return newstart;
   // 解释：re=new RegExp("l","g")中的第一个参数是你要替换的字符串，第二个参数指替换所有的，
   //其中，第二参数也可以设置为("i"),表示只替换第一个字符串。 
   //str.replace(re,"t")中第二个参数你要修改的字符串。
} 
function selectAllBox(obj){
		$("[name='check_per']").attr("checked",obj.checked);//全选或反选
		changeCheckboxStatus($("[name='check_per']"),obj.checked);
	    if (obj.checked == true){
	    	 ids=names="";
	    	 jQuery("#BrowseTable").find("input[name='check_per']").each(function (){
	    	 	 	  ids = ids + "," + jQuery(this).parents('tr:first').find("td:eq(1)").text();
			   		  //names = names + "," + replaceALL( jQuery(this).parent().parent().find("td:eq(2)").text(),",","");
				 names = names + "," + replaceALL( jQuery(this).parents('tr:first').find("td:eq(2)").text(),",","");
	    	 });
	   	}else{
	   		 //jQuery("#BrowseTable > input[name='check_per'] ").each(function (){
	   		  jQuery("#BrowseTable").find("input[name='check_per']").each(function (){
	    	 		 ids = ids.replace("," +  jQuery(this).parents('tr:first').find("td:eq(1)").text(), "");
		   			//names = names.replace("," + replaceALL( jQuery(this).parent().parent().find("td:eq(2)").text(),",",""), "");
				  names = names.replace("," + replaceALL( jQuery(this).parents('tr:first').find("td:eq(2)").text(),",",""), "");
	    	 });
	   	}

	   	//alert("ids---"+ids);
		//alert("names---"+names);

}
function onseach(){
	$("#SearchForm").submit()
}
</script>
