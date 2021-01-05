<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String bdf_wfid=Util.null2String(request.getParameter("bdf_wfid"));
String bdf_fieldid=Util.null2String(request.getParameter("bdf_fieldid"));
String bdf_viewtype=Util.null2String(request.getParameter("bdf_viewtype"));
String bdf_departmentid=Util.null2String(request.getParameter("bdf_departmentid"));
String stateid = Util.null2String(request.getParameter("cptstateid"));//资产状态
String sptcount = Util.null2String(request.getParameter("cptsptcount")); //是否单独核算
String isdata = Util.null2String(request.getParameter("isdata")); //资产Or资产资料
//资产流转情况页面 可以查看数量是0的资产，默认都能查看，如果是系统表单流程，自定义资产流程，资产卡片中的资产都传递0，不让其查看
String inculdeNumZero = Util.null2s(request.getParameter("inculdeNumZero"), "1");
String isCapital="0";
String billid=Util.null2String(request.getParameter("billid"));
String wfid = Util.null2String(request.getParameter("wfid"));
String reqid = Util.null2String(request.getParameter("reqid"));
if (!billid.equals("")){
    int billids=Util.getIntValue(billid);
    switch (billids) {
		 case 220: //资产借用
		     sqlwhere1=" where isdata='2'  ";
			 sptcount="1";
			 stateid="1";
			 inculdeNumZero = "0";
			 break;
		 case 222: //资产送修
		     sqlwhere1=" where isdata='2'  ";
			 sptcount="1";
			 stateid="1,2,3";
			 inculdeNumZero = "0";
			 break;
		 case 224: //资产归还
		     sqlwhere1=" where isdata='2'  ";
			 //sptcount="1";
			 stateid="4,2,3";
			 inculdeNumZero = "0";
		     break;
	     case 221: //资产减损
	         sqlwhere1=" where isdata='2'  ";
	         stateid="1,2,3,4";
	         inculdeNumZero = "0";
		 	 break;
	     case 201: //资产报废
	         sqlwhere1=" where isdata='2'  ";
	         stateid="1,2,3,4";
	         inculdeNumZero = "0";
		 	 break;
    }
}
if(!"".equals(wfid)){//自定义资产流程
	String wftype=CptWfUtil.getWftype(wfid);
	if (!"".equals(wftype)) {
		if("fetch".equalsIgnoreCase(wftype)){
			stateid="1";
		}else if("lend".equalsIgnoreCase(wftype)){
			stateid="1";
			sptcount="1";
		}else if("move".equalsIgnoreCase(wftype)){
			stateid="2";
			if (sqlwhere1.indexOf("where") > -1) {
				sqlwhere1 += " and resourceid='"+user.getUID()+"'";
			} else {
				sqlwhere1 += " where resourceid='"+user.getUID()+"'";
			}
		}else if("back".equalsIgnoreCase(wftype)){
			stateid="2,3,4";
			if (sqlwhere1.indexOf("where") > -1) {
				sqlwhere1 += " and resourceid='"+user.getUID()+"'";
			} else {
				sqlwhere1 += " where resourceid='"+user.getUID()+"'";
			}
		}else if("discard".equalsIgnoreCase(wftype)){
			stateid="1,2,3,4";
			if (sqlwhere1.indexOf("where") > -1) {
				sqlwhere1 += " and resourceid='"+user.getUID()+"'";
			} else {
				sqlwhere1 += " where resourceid='"+user.getUID()+"'";
			}
		}else if("mend".equalsIgnoreCase(wftype)){
			stateid="1,2,3";
			sptcount="1";
		}else if("loss".equalsIgnoreCase(wftype)){
	        stateid="1,2,3,4";
		}
		inculdeNumZero = "0";
	}
}
//以sqlwhere1中isdata优先判断
if(sqlwhere1.indexOf("isdata")!=-1){ 
    if(sqlwhere1.substring(sqlwhere1.indexOf("isdata='")+8,sqlwhere1.indexOf("isdata='")+9).equals("2")){
		isCapital = "1";
    }else if(sqlwhere1.substring(sqlwhere1.indexOf("isdata=")+7,sqlwhere1.indexOf("isdata=")+8).equals("2")){
		isCapital = "1";
    }
}else{
    //isdata参数为空或2时是资产
    if (isdata.equals("") || isdata.equals("2")){
        isCapital = "1"; 
    }
}
String tab1url = "/cpt/capital/CapitalBrowserTree.jsp?isCapital="+isCapital+"&cptstateid="+stateid+"&cptsptcount="+sptcount+"&inculdeNumZero="+inculdeNumZero+"&wfid="+wfid+"&sqlwhere="+xssUtil.put(sqlwhere1)+"&bdf_wfid="+bdf_wfid+"&bdf_fieldid="+bdf_fieldid+"&bdf_viewtype="+bdf_viewtype+"&bdf_departmentid="+bdf_departmentid;
String tab2url = "/cpt/capital/CapitalBrowserTab2.jsp?isCapital="+isCapital+"&cptstateid="+stateid+"&cptsptcount="+sptcount+"&inculdeNumZero="+inculdeNumZero+"&wfid="+wfid+"&sqlwhere="+xssUtil.put(sqlwhere1)+"&bdf_wfid="+bdf_wfid+"&bdf_fieldid="+bdf_fieldid+"&bdf_viewtype="+bdf_viewtype+"&bdf_departmentid="+bdf_departmentid;
%>
<HTML>
<HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	//form内容转json
	$.fn.serializeObject = function()  
	{
	 var o = {};
	 var a = this.serializeArray();  
	 $.each(a, function() {  
	     if (o[this.name]) {  
	         if (!o[this.name].push) {  
	             o[this.name] = [o[this.name]];  
	         }  
	         o[this.name].push(this.value || '');  
	     } else {  
	         o[this.name] = this.value || '';  
	     }  
	 });  
	 return o;  
	};
</script>
</HEAD>
<BODY>
<FORM ID=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="/cpt/capital/CapitalBrowserList.jsp" method=post target="optFrame">
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input type=hidden id=cptstateid name=cptstateid value="<%=stateid%>">
<input type=hidden id=cptsptcount name=cptsptcount value="<%=sptcount%>">
<input type=hidden id=isCapital name=isCapital value="<%=isCapital%>">
<input type=hidden id=billid name=billid value="<%=billid%>">
<input type=hidden id=inculdeNumZero name=inculdeNumZero value="<%=inculdeNumZero%>">
<input type=hidden id=capitalgroupid name=capitalgroupid> <!--Only for CapitalBrowserTree-->
<input type=hidden id=isInit name=isInit value="1">
<input type=hidden id=reqid name=reqid value="<%=reqid %>">
<input type="hidden" id=queryformjsoninfo name=queryformjsoninfo value="">
<input type="hidden" id=bdf_wfid name=bdf_wfid value="<%=bdf_wfid %>">
<input type="hidden" id=bdf_fieldid name=bdf_fieldid value="<%=bdf_fieldid %>">
<input type="hidden" id=bdf_viewtype name=bdf_viewtype value="<%=bdf_viewtype %>">
<input type="hidden" id=bdf_departmentid name=bdf_departmentid value="<%=bdf_departmentid %>">
</FORM>
<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
		    		<li class="current">
			        	<a id="tabId1" href="<%=tab1url %>" target="tabcontentframe1">
			        		<%=SystemEnv.getHtmlLabelName(18692,user.getLanguage())%><!-- 按结构 --> 
			        	</a>
			        </li>
		    		<li class="">
			        	<a id="tabId2" href="<%=tab2url %>" target="tabcontentframe1">
			        		<%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%><!-- 组合查询 --> 
			        	</a>
			        </li>
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
    <div class="tab_box">
        <div>
            <iframe src="<%=tab1url %>" onload="update();" id="tabcontentframe1" name="tabcontentframe1" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
       
    </div>
</div> 
<script type="text/javascript">	
jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"tabcontentframe1",
    mouldID:"<%=MouldIDConst.getID("assest") %>",
    objName:<%=JSONObject.quote( SystemEnv.getHtmlLabelNames(("1".equals(isCapital)?"535":"1509" ), user.getLanguage()) ) %>,
	staticOnLoad:true
});
function btnclear_onclick(){
    if(dialog){
    	var returnjson = {id:"", name:""};
    	var returnjson={id:"",name:""};
		try{
            dialog.callback(returnjson);
       }catch(e){}
	  	try{
	       dialog.close(returnjson);
	   }catch(e){}
    }else{
	    window.parent.returnValue = {id:"", name:""};
	    window.parent.close();
	}
}
function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
     	window.parent.close();
	}
}
function onSubmitClick()
{
	jQuery("#isInit").val("1");
	var queryform= $("#tabcontentframe1").contents().find("#capitalqueryform");
	var reqid= queryform.find("input[name=reqid]").val();
	if(reqid){jQuery("#reqid").val(reqid);}else{jQuery("#reqid").val('')}
	var jsoninfo = queryform.serializeObject();
	jQuery("#queryformjsoninfo").val(JSON.stringify(jsoninfo));
	onSubmit();
}
function onSubmit()
{
	jQuery("#capitalgroupid").val("");
    $("#SearchForm").submit();
}
</script>
</BODY>
</HTML>
