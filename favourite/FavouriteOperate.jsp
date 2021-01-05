
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%if(user.getLanguage()==7) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-cn-gbk_wev8.js'></script>
<%
}
else if(user.getLanguage()==8) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-en-gbk_wev8.js'></script>
<%
}
else if(user.getLanguage()==9) 
{
%>
	<script type='text/javascript' src='js/favourite-lang-tw-gbk_wev8.js'></script>
<%
}
%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
</head>
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));
int favouriteid = Util.getIntValue(Util.null2String((String)request.getParameter("favouriteid")),0);
String success = Util.null2String(request.getParameter("success"));  //从处理页面返回，会带有处理的结果
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23663,user.getLanguage());
String needfav ="1";
String needhelp ="";

String tempid = "";
String favouritename = "";
String favouritedesc = "";
String displayorder = "";
String action = "add";
if(favouriteid>0)
{
	action = "edit";
}
String pointids = ",";
String sql = " select * from favourite where resourceid="+user.getUID()+" order by displayorder,adddate desc ";
//System.out.println("select sql : "+sql);
rs.executeSql(sql);
while (rs.next())
{
	String fid = rs.getString("id");
	String tempfavouritename = rs.getString("favouritename");
	if(fid.equals(""+favouriteid))
	{
		tempid = fid;
		favouritename = tempfavouritename;
		favouritedesc = rs.getString("favouritedesc");
		displayorder = rs.getString("displayorder");
	}
	
	pointids += tempfavouritename+",";
}
%>

<BODY>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit(this);"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/favourite/FavouriteOperation.jsp">
	<input type="hidden" id="favouriteid" name="favouriteid" value="<%=favouriteid %>">
	<input type="hidden" name="isdialog" value="<%=isDialog%>">
	<input type="hidden" name="action" value="<%=action%>">
	
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		  <wea:item><script language=javascript>document.write(favourite.window.name);</script></wea:item><!-- 目录名称 -->
		  <wea:item>
		  	<wea:required id="favouritenamespan" required="true" value='<%=favouritename %>'>
		  		<input class="inputstyle" type=text style='width:280px!important;' id="favouritename" maxLength=20 name="favouritename" value='<%=favouritename %>' onChange="checkinput('favouritename','favouritenamespan')">
		  	</wea:required>
		  </wea:item>
		  <wea:item><script language=javascript>document.write(favourite.window.desc);</script></wea:item><!-- 目录描述 -->
		  <wea:item>
		  	<input class="inputstyle" type=text style='width:280px!important;' id="favouritedesc" name="favouritedesc" value='<%=favouritedesc %>' maxLength=20 size=50>
		  </wea:item>
		  <wea:item><script language=javascript>document.write(favourite.window.displayorder);</script></wea:item><!-- 显示顺序 -->
		  <wea:item>
		  	<!--<wea:required id="favouriteorderspan" required="true" value='<%=displayorder %>'> -->
		  		<input class="inputstyle" type=text style='width:140px!important;' id="favouriteorder" name="favouriteorder" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber1(this);" value='<%=displayorder %>' onChange="checkinput('favouriteorder','favouriteorderspan')" maxLength=2 size=10>
		  	<!--</wea:required>-->
		  </wea:item>
	
	</wea:group>
	</wea:layout>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
  </FORM>
  <%if("1".equals(isDialog)){ %>
<script type="text/javascript">
	jQuery(document).ready(function(){
		//var success = "<%=success%>";  //从处理界面返回，会带有此值
		//if(success == "2")
		//{
			 //Dialog.alert(favourite.other.fanameexist);//"该目录名称已存在，请重新输入!" 
		//}
		resizeDialog(document);
	});
</script>	
<%} %>
</BODY>
<script language="javascript">
function onSubmit(obj){
	/*if(isExist(document.getElementById("favouritename").value))
	{
    	if(check_form(frmMain,"favouritename")) frmMain.submit();
    }*/
    /**改成如下ajax方式，避免重复提交数据*/
    if(check_form(frmMain,"favouritename")){
    	if(obj)
    	{
    		jQuery(obj).attr("disabled","disabled");  //将按钮置为disabled，防止重复提交
    	}
	    var params = {};  //发送请求的参数
	    params.favouriteid = $("#favouriteid").val();
	    params.action = $("input[name=action]").val();
	    params.favouritename = $("#favouritename").val();
	    params.favouritedesc = $("#favouritedesc").val();
	    params.favouriteorder = $("#favouriteorder").val();
	    var rurl = "/favourite/FavouriteOperation.jsp";   //请求的url
	    var success = function(data){    //回调方法
		    jQuery(obj).removeAttr("disabled");  //执行成功后，释放按钮
			if(data){
		        data = eval('(' + data + ')');
		        var flag = data.flag;
		        var errorInfo = data.errorInfo;
		        if(flag != undefined && flag != null && flag == false){
		        	Dialog.alert(errorInfo);
		        	return;
			    }
		        var result = data.success;   //是否成功
		        if(result == 2)  //有重名
		        {
		        	 Dialog.alert(favourite.other.fanameexist);
			    }else{
			    	 var parentWin = parent.parent.getParentWindow(parent);
			    	 parentWin.reloadTree();   //刷新树窗口
					 parentWin.closeDialog();  //关闭窗口
				}
			}
	    };
	    jQuery.post(rurl,params,success);
    }
}
function onBack()
{
	parentWin.closeDialog();
}
function isExist(newvalue){
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>-1&&(newvalue!="<%=favouritename %>")){
        Dialog.alert(favourite.other.fanameexist);//"该目录名称已存在，请重新输入!"
        document.getElementById("favouritename").value = "<%=favouritename %>";
        if("<%=favouritename %>"=="")
        {
        	document.getElementById("favouritenamespan").innerHTML = "<IMG align=absMiddle src='/images/BacoError.gif'>";
        }
        return false;
    }
    return true;
}
</script>

</HTML>
