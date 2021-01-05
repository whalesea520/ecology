
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<STYLE>
	.vis1	{ visibility:visible }
	.vis2	{ visibility:hidden }
	.vis3   { display:inline}
	.vis4   { display:none }
	#loading{
	    position:absolute;
	    left:45%;
	    background:#ffffff;
	    top:40%;
	    padding:8px;
	    z-index:20001;
	    height:auto;
	    border:1px solid #ccc;
	}
	#loading2{
	    position:absolute;
	    left:45%;
	    background:#ffffff;
	    top:40%;
	    padding:8px;
	    z-index:20001;
	    height:auto;
	    border:1px solid #ccc;
	}
</style>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:webserivcesetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "WebService"+SystemEnv.getHtmlLabelName(31691,user.getLanguage());//WebService注册
String needfav ="1";
String needhelp ="";

String customname = "";
String webserviceurl = "";
String id = Util.null2String(request.getParameter("id"));
String check=Util.null2String(request.getParameter("check"));
String sql = "";

if(!"".equals(id))
{
	sql = "select * from wsregiste where id="+id;
	rs.executeSql(sql);
	if(rs.next())
	{
		webserviceurl = Util.null2String(rs.getString("webserviceurl"));
		customname = Util.null2String(rs.getString("customname"));
	}
}

String isDialog = Util.null2String(request.getParameter("isdialog"));
String isdelete = new weaver.general.SplitPageTransmethod().getWebserviceCheckBox(id);
//282349[80][90]WebService注册-新建页面建议取消【删除】按钮
SplitPageTransmethod splitPageTransmethod= new SplitPageTransmethod();
if("".equals(id)){
	isdelete="false";
}else{
  isdelete=(String)splitPageTransmethod.getWebservicePopedom(id).get(1);
}
%>

<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/integration/webserivcesettingList.jsp,_self} " ;//返回
//RCMenuHeight += RCMenuHeightStep ;
if(isdelete.equals("true"))
{
	RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<%if(isdelete.equals("true")){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="deleteData()"/>
			<%}%>
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
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/integration/WSsettingOperation.jsp">
<input type="hidden" id="id" name="id" value="<%=id %>">
<input type="hidden" id="operator" name="operator" value="">
<input type="hidden" id="invoketype" name="invoketype" value="1">
<%if("1".equals(isDialog)){ %>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%} %>
<div id="loading" style="display:none;">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle">&nbsp;<%=SystemEnv.getHtmlLabelName(32395, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25007, user.getLanguage())%></span>
</div>
<div id="loading2" style="display:none;">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle">&nbsp;<%=SystemEnv.getHtmlLabelName(32396, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25007, user.getLanguage())%></span>
</div>
<wea:layout>
	<wea:group attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}" context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage()) %></wea:item><!-- 自定义名称 -->
	  <wea:item>
	  	 <wea:required id="customnameimage" required="true" value='<%=customname %>'>
		 	<input class="InputStyle" style='width:280px!important;' type=text id="customname" maxLength="50" name="customname" value="<%=customname %>" onchange='checkinput("customname","customnameimage")' onblur="isExist()">
		 </wea:required>
	  </wea:item>
	  <wea:item>WEBSERVICE<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %></wea:item><!-- 地址 -->
	  <wea:item>
	  	<wea:required id="webserviceurlimage" required="true" value='<%=webserviceurl %>'>
		 	<input class="InputStyle" style='width:380px!important;' type=text size=50 id="webserviceurl" name="webserviceurl" value="<%=webserviceurl %>" onchange='javascript:changeWSDL();checkinput("webserviceurl","webserviceurlimage")'>
		</wea:required>
	  	<input type=hidden size=50 id="oldwebserviceurl" name="oldwebserviceurl" value="<%=webserviceurl %>">
	  	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32395,user.getLanguage()) %>WSDL" onClick="ParseWSDL(1);" class="e8_btn_submit"/><!-- 解析 -->
	  	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32396,user.getLanguage()) %>" onClick="ParseWSDL(2);" class="e8_btn_submit"/><!-- 检查更新 -->
	  </wea:item>
	</wea:group>
</wea:layout>
<wea:layout>
	<wea:group attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}" context='<%=SystemEnv.getHtmlLabelName(32397, user.getLanguage())%>'>
	  <wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow()" ACCESSKEY="A" disabled class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow()" ACCESSKEY="G" class="delbtn"/>
		  </div>
	  </wea:item>
	  <wea:item attributes="{'colspan':'2','isTableList':'true'}">
	  	<div id="outtersetting">
			<TABLE class="ListStyle" id="oTable" name="oTable">
			  	<COLGROUP>
			    <COL width="5%">
			    <COL width="15%">
			    <COL width="15%">
			    <COL width="20%">
			    <COL width="20%">
			    <COL width="15%">
			    <COL width="10%">
			    <TR class="header">
			        <Th><INPUT type="checkbox" id="chkAll" name="chkAll" onClick="chkAllClick(this)"></Th>
					<Th><%=SystemEnv.getHtmlLabelName(32398,user.getLanguage()) %></ThTh><!-- 方法名 -->
					<Th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage()) %></Th><!-- 描述 -->
					<Th><%=SystemEnv.getHtmlLabelName(32399,user.getLanguage()) %></Th><!-- 返回值类型 -->
				 	<Th><%=SystemEnv.getHtmlLabelName(23481,user.getLanguage()) %></Th><!-- 参数名称 -->
				 	<Th><%=SystemEnv.getHtmlLabelName(32400,user.getLanguage()) %></Th><!-- 参数类型 -->
				 	<Th><%=SystemEnv.getHtmlLabelName(32392,user.getLanguage()) %></Th><!-- 是否数组 -->
				</TR>		
			</TABLE>
		</div>
	  </wea:item>
	</wea:group>
</wea:layout>
<br>
</FORM>
</BODY>
<script type="text/javascript">
var tishi="<%=check%>";

if(tishi=="1"){
top.Dialog.alert("名称已存在，请重新填写!");
}
</script>
<script type="text/javascript">

Map = function(){   
    var mapAddM = {   
        /**  
         * entry函数  
         * @param {Object} key  
         * @param {Object} val  
         */  
        entry: function(key, val){   
            this.key = key;   
            this.value = val;   
        },   
        //put方法   
        put: function(key, val){   
            this.store[this.store.length] = new this.entry(key, val);   
        },   
        //get方法   
        get: function(key){   
            for (var i = 0; i < this.store.length; i++) {   
                if (this.store[i].key === key)    
                    return this.store[i].value;   
            }   
        },   
        //remove方法   
        remove: function(key){   
            for (var i = 0; i < this.store.length; i++) {   
                this.store[i].key === key && this.store.splice(i, 1);   
            }   
        },   
        //keyset   
        keySet: function(){   
            var keyset = new Array;   
            for (var i = 0; i < this.store.length; i++)    
                keyset.push(this.store[i].key);   
            return keyset;   
        },   
        //valset   
        valSet: function(){   
            var valSet = new Array;   
            for (var i = 0; i < this.store.length; i++)    
                valSet.push(this.store[i].value);   
            return valSet;   
        },   
        //clear   
        clear: function(){   
            this.store.length = 0;   
        },   
        //size    
        size: function(){   
            return this.store.length;   
        },   
        /**  
         *  迭代子  
         */  
        iterator : function(){   
            //TODO 待实现   
            var obj = this.keySet();//所有的key集合   
            var idx = 0;   
            var me = {   
                /**  
                 * 当前key  
                 */  
                current : function(){   
                    return obj[idx-1];   
                },   
                /**  
                 * 第一个key  
                 */  
                first : function(){   
                    return obj[0];   
                },   
                /**  
                 * 最后一个key  
                 */  
                last : function(){   
                    return obj[obj.length-1];   
                },   
                /**  
                 * 是否还有下一个元素  
                 */  
                hasNext : function(){   
                    idx++;   
                    if(idx > obj.length||null==obj[obj.length-1])return false;   
                    return true;   
                }   
            };   
            return me;   
        }   
    };   
    for (var method in mapAddM) {   
        this.store = new Array;   
        Map.prototype[method] = mapAddM[method];   
    }   
}
var methodmap = new Map;
var methodreturnmap = new Map;
var isload = false;
function ParseWSDL(type)
{
        var webserviceurl = jQuery("#webserviceurl").val();
        var oldwebserviceurl = jQuery("#oldwebserviceurl").val();
       
    
    //alert("test : "+webserviceurl);
    
    if(""!=webserviceurl)
    {
    	if(type==2)
    	{
    		jQuery("#addbutton").attr("disabled","true");
    	}
	    var timestamp = (new Date()).valueOf();
	    var params = "operator=getinfo&webserviceurl="+webserviceurl+"&ts="+timestamp;
	    //alert(params);
	    if(type==2)
	    {
	    	jQuery("#loading2").show();
	    }
	    else if(type==1)
	    {
	    	jQuery("#loading").show();
	    }
	    jQuery.ajax({
	        type: "POST",
	        url: "/integration/WSsettingOperation.jsp",
	        data: params,
	        success: function(msg){
	        	var result = jQuery.trim(msg);
				if(result=="exception"){//解析异常输出
					if(type==2)
					{
						jQuery("#loading2").hide();
					}
					else if(type==1)
					{
						jQuery("#loading").hide();
					}
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32394,user.getLanguage()) %>");//获取wsdl描述存在问题，请检查webservice url是否正确!
					return;
				}else{
	        	if(type==2)
			    {
			    	jQuery("#loading2").hide();
			    }
			    else if(type==1)
			    {
			    	jQuery("#loading").hide();
			    }
	            if(result!="")
	            {
	            	if(type==2)
				    {
				    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("32396,25008",user.getLanguage()) %>");//检查更新成功
				    }
				    else if(type==1)
				    {
				    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("32395,25008",user.getLanguage()) %>");//解析成功
				    }
	            	
	            	//alert(result)
	            	var jsonarrs = eval(result);
	            	//alert(jsonarrs.length);
	            	methodmap.clear();
	            	for(var i = 0;i<jsonarrs.length;i++)
	            	{
	            		var methodname = jsonarrs[i].name;
	            		//alert(jsonarrs[i].params.length);
	            		methodmap.put(methodname,jsonarrs[i].inparams);
	            		methodreturnmap.put(methodname,jsonarrs[i].outparamtype);
	            	}
	            	//alert("oldwebserviceurl : "+oldwebserviceurl+" webserviceurl : "+webserviceurl);
	            	if(""!=oldwebserviceurl&&oldwebserviceurl!=webserviceurl)
	            	{
	            		//alert(document.getElementById("chkAll"));
	            		document.getElementById("chkAll").checked = true;
	            		chkAllClick(document.getElementById("chkAll"));
	            		removeRowNoTip();
	            	}
	            	if(isload)
	            	{
	            		init();
	            		isload = false;
	            	}
	            	jQuery("#addbutton").removeAttr("disabled");
	            	if(type==2)
	            		updateMethodParams();
	            }
	            else
	            {
	            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32394,user.getLanguage()) %>");//获取wsdl描述存在问题，请检查webservice url是否正确!
	            }
				}
	        }/*,
	        error:function(msg)
	        {
	        	if(type==2)
			    {
			    	jQuery("#loading2").hide();
			    }
			    else if(type==1)
			    {
			    	jQuery("#loading").hide();
			    }
	        	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32394,user.getLanguage()) %>");//获取wsdl描述存在问题，请检查webservice url是否正确!
	        	return;
	        }*/
	    });
    }
}


function changeWSDL()
{
 
        var webserviceurl = jQuery("#webserviceurl").val();
        var oldwebserviceurl = jQuery("#oldwebserviceurl").val();
      if(""!=oldwebserviceurl){
    		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129870,user.getLanguage())%>?", function (){
    		if(oldwebserviceurl!=webserviceurl)
	            	{
	            		document.getElementById("chkAll").checked = true;
	            		chkAllClick(document.getElementById("chkAll"));
	            		removeRowNoTip();
	            	}
    		
			}, function () {
				jQuery("#webserviceurl").val(oldwebserviceurl);
				return;
			}, 320, 90);
		}
    
   
}

function updateMethodParams()
{
	var methodnames = document.getElementsByName("methodname");
	if(null!=methodnames&&methodnames.length>0)
	{
		for(var i = 0;i<methodnames.length;i++)
		{
			var methodname = methodnames[i];
			changemethodname(methodname);
		}
	}
}
	function addRow()
    {
    	var rownum = oTable.rows.length;
        var oRow = oTable.insertRow(rownum);
        var oRowIndex = oRow.rowIndex;

        if (0 == oRowIndex % 2)
        {
            oRow.className = "DataLight";
        }
        else
        {
            oRow.className = "DataDark";
        }
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(0);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='paramid'><INPUT type='hidden' name='methodid' value='-1'>";                        
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();
        
        oCell = oRow.insertCell(1);
        oDiv = document.createElement("div");
        
        var selectstr="<select id=\"methodname\" name=\"methodname\" onchange='changemethodname(this);changecheckValue(this);' style='width:180px;'><option value=\"\"></option>";
        var methods = methodmap.keySet();
        if(null!=methods&&methods.length>0)
        {
        	for(var i = 0;i<methods.length;i++)
        	{
        		var methodname = methods[i];
				selectstr += "	<option value=\""+methodname+"\" title=\""+methodname+"\">"+methodname+"</option>";
			}
		}
		selectstr += "</select><span ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
		oDiv.innerHTML=selectstr;
        oCell.appendChild(oDiv);
        jQuery(oCell).find("select").selectbox("detach");
        jQuery(oCell).find("select").selectbox();
        
        oCell = oRow.insertCell(2);
        oDiv = document.createElement("div");
        /*QC331056 [80][90][优化]WebService注册-解决接口方法描述中带有特殊字符造成按钮失效，显示错乱的问题-优化 start */
        oDiv.innerHTML="<INPUT class='InputStyle' type='text' name='methoddesc' maxLength=100 value='' onblur='checkmethoddesc(this)'>";
        /*QC331056 [80][90][优化]WebService注册-解决接口方法描述中带有特殊字符造成按钮失效，显示错乱的问题-优化 end */
        oCell.appendChild(oDiv);
        
        oCell = oRow.insertCell(3);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='InputStyle' size=20 type='text' name='methodreturntype' maxLength=100 value='' readonly style='border:0px;'>";
        oCell.appendChild(oDiv);
        
        oCell = oRow.insertCell(4);
        oCell.colSpan = 3;
        oDiv = document.createElement("div");
        oDiv.id="methodparamdetaildiv";
        oDiv.innerHTML="<table><COLGROUP><COL width='37%' align='left'><COL width='38%' align='left'><COL width='25%' align='left'></table>";
        oCell.appendChild(oDiv);
    }
        
    function removeRow()
    {
		var count = 0;//删除数据选中个数
		jQuery("#outtersetting input[name='paramid']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
		});
		//alert(v+":"+count);
		if(count==0){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		}else{
    	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	        var chks = document.getElementsByName("paramid");
	        var hasselect = false;
	        for (var i = chks.length - 1; i >= 0; i--)
	        {
	            var chk = chks[i];
	            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
	            if (chk.checked)
	            {
	            	hasselect = true;
	            	break;
	            }
	        }
	        if(hasselect)
	        {
	        	for (var i = chks.length - 1; i >= 0; i--)
		        {
		            var chk = chks[i];
		            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
		            if (chk.checked)
		            {
		                oTable.deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex)
		            }
		        }
	        }
	        else
	        {
	        	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
				return ;
	        }
	    }, function () {}, 320, 90);
		}
    }
    function removeRowNoTip()
    {
        var chks = document.getElementsByName("paramid");
        // alert(chks.length);
        for (var i = chks.length - 1; i >= 0; i--)
        {
            var chk = chks[i];
            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
            if (chk.checked)
            {
                oTable.deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex)
            }
        }
    }
    function chkAllClick(obj)
    {
        var chks = document.getElementsByName("paramid");
        
        for (var i = 0; i < chks.length; i++)
        {
            var chk = chks[i];
            
            if(false == chk.disabled)
            {
            	chk.checked = obj.checked;
            	try
            	{
            		if(chk.checked)
            			jQuery(chk.nextSibling).addClass("jNiceChecked");
            		else
            			jQuery(chk.nextSibling).removeClass("jNiceChecked");
            	}
            	catch(e)
            	{
            	}
            }
        }
    }
    function changemethodname(obj)
    {
    	var methodname = obj.value;
    	if(""!=methodname)
    	{
    		var paramlist = methodmap.get(methodname);
    		var methodreturntype = methodreturnmap.get(methodname);
    		//alert(paramlist.length);
    		if(null!=paramlist&&paramlist.length>0)
    		{
    			var methodreturn = obj.parentElement.parentElement.nextSibling.nextSibling.firstChild.firstChild;
    			if(null!=methodreturntype&&methodreturntype!="")
    				methodreturn.value = methodreturntype;
    			else
    				methodreturn.value = "";
    			var methoddiv = obj.parentElement.parentElement.nextSibling.nextSibling.nextSibling.firstChild;
    			//alert(methoddiv.innerHTML);
    			var htmlstr = "<table width='100%'><COLGROUP><COL width='45%' align='left'><COL width='33%' align='left'><COL width='22%' align='left'>";
    			for(var i = 0;i<paramlist.length;i++)
    			{
    				var params = paramlist[i];
    				var name = params.name;
    				var kind = params.kind;
    				htmlstr += "<tr><td><INPUT class='InputStyle' size=10 type='hidden' name='parammethod' value='"+methodname+"'><INPUT class='InputStyle' size=10 type='text' name='paramname' value='"+name+"' readonly style='border:0px;'></td><td><INPUT class='InputStyle' size=10 type='text' name='paramtype'  value='"+kind+"' readonly style='border:0px;'></td><td><INPUT class='InputStyle' type='checkbox' name='tempisarray' onclick=\"if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT type='hidden' name='isarray' value='0'></td></tr>"
    				//alert(params.name)
    			}
    			
    			htmlstr += "</table>";
    			methoddiv.innerHTML = htmlstr;
    			jQuery(methoddiv).jNice();
    		}else {
    			var methodreturn = obj.parentElement.parentElement.nextSibling.nextSibling.firstChild.firstChild;
    			if(null!=methodreturntype&&methodreturntype!="")
    				methodreturn.value = methodreturntype;
    			else
    				methodreturn.value = "";
    			var methoddiv = obj.parentElement.parentElement.nextSibling.nextSibling.nextSibling.firstChild;
    			//alert(methoddiv.innerHTML);
    			var htmlstr = "<table width='100%'><COLGROUP><COL width='45%' align='left'><COL width='33%' align='left'><COL width='22%' align='left'>";
    			for(var i = 0;i<paramlist.length;i++)
    			{
    				var params = paramlist[i];
    				var name = params.name;
    				var kind = params.kind;
    				htmlstr += "<tr><td><INPUT class='InputStyle' size=10 type='hidden' name='parammethod' value='"+methodname+"'><INPUT class='InputStyle' size=10 type='text' name='paramname' value='"+name+"' readonly style='border:0px;'></td><td><INPUT class='InputStyle' size=10 type='text' name='paramtype'  value='"+kind+"' readonly style='border:0px;'></td><td><INPUT class='InputStyle' type='checkbox' name='tempisarray' onclick=\"if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT type='hidden' name='isarray' value='0'></td></tr>"
    				//alert(params.name)
    			}
    			
    			htmlstr += "</table>";
    			methoddiv.innerHTML = htmlstr;
    			jQuery(methoddiv).jNice();
    			}
    	} else {
    		var methoddesc = obj.parentElement.parentElement.nextSibling.firstChild.firstChild;
    		methoddesc.value = "";
    		
    		var methodreturn = obj.parentElement.parentElement.nextSibling.nextSibling.firstChild.firstChild;
    		methodreturn.value = "";
    		
    		var methoddiv = obj.parentElement.parentElement.nextSibling.nextSibling.nextSibling.firstChild;
    		methoddiv.innerHTML = "<table width='100%'><COLGROUP><COL width='45%' align='left'><COL width='33%' align='left'><COL width='22%' align='left'></table>";
    	}
    }
function init()
{
	
<%
	if(!"".equals(id))
	{
		rs.executeSql("SELECT * FROM wsregistemethod where mainid="+id+" order by methodname,id");
		
		while (rs.next()) 
		{
	        String methodid = Util.null2String(rs.getString("id"));
	        String methodname = Util.null2String(rs.getString("methodname"));
	        String methodreturntype = Util.null2String(rs.getString("methodreturntype"));
	        String methoddesc = Util.null2String(rs.getString("methoddesc"));
	        //System.out.println("methodid : "+methodid);
	  
%>
			
			
			
	    	var rownum = oTable.rows.length;
	        var oRow = oTable.insertRow(rownum);
	        var oRowIndex = oRow.rowIndex;
	
	        if (0 == oRowIndex % 2)
	        {
	            oRow.className = "DataLight";
	        }
	        else
	        {
	            oRow.className = "DataDark";
	        }
			
			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(0);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='checkbox' name='paramid'><INPUT type='hidden' name='methodid' value='<%=methodid%>'>";                        
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        oCell = oRow.insertCell(1);
	        oDiv = document.createElement("div");
	        
	        var selectstr="<INPUT class='InputStyle' type='text' style='width:200px;border:0px;' name='methodname' value='<%=methodname%>' readonly>";
			oDiv.innerHTML=selectstr;
	        oCell.appendChild(oDiv);
	        
	        oCell = oRow.insertCell(2);
	        oDiv = document.createElement("div");
	        /*QC331056 [80][90][优化]WebService注册-解决接口方法描述中带有特殊字符造成按钮失效，显示错乱的问题-优化 start */
	        oDiv.innerHTML="<INPUT class='InputStyle' type='text' name='methoddesc' maxLength=100 value='<%=methoddesc%>' onblur='checkmethoddesc(this)'>";
	        /*QC331056 [80][90][优化]WebService注册-解决接口方法描述中带有特殊字符造成按钮失效，显示错乱的问题-优化 end */
	        oCell.appendChild(oDiv);
	        
	        oCell = oRow.insertCell(3);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='InputStyle' type='text' size=20 name='methodreturntype' maxLength=100 value='<%=methodreturntype%>' readonly style='border:0px;'>";
	        oCell.appendChild(oDiv);
	        
	        oCell = oRow.insertCell(4);
	        oCell.colSpan = 3;
	        oDiv = document.createElement("div");
	        oDiv.id="methodparamdetaildiv";
	        var htmlstr = "<table width='100%'><COLGROUP><COL width='45%' align='left'><COL width='33%' align='left'><COL width='22%' align='left'>";
	        
	        <%
	        rs1.executeSql("select * from wsregistemethodparam where methodid = "+methodid +" order by paramname,id");
	        while (rs1.next()) 
			{
		        String paramname = Util.null2String(rs1.getString("paramname"));
		        String paramtype = Util.null2String(rs1.getString("paramtype"));
		        String isarray = Util.null2String(rs1.getString("isarray"));
		    %>
		    	htmlstr += "<tr><td width='45%'><INPUT class='InputStyle' type='hidden' name='parammethod' value='<%=methodname%>'><INPUT class='InputStyle' size=10 type='text' name='paramname' value='<%=paramname%>' readonly style='border:0px;'></td><td width='33%'><INPUT class='InputStyle' size=10 type='text' name='paramtype'  value='<%=paramtype%>' readonly style='border:0px;'></td><td width='22%'><INPUT class='InputStyle' type='checkbox' name='tempisarray' onclick=\"if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\" <%if("1".equals(isarray)) out.print("checked");%>><INPUT class='InputStyle' type='hidden' name='isarray' value='<%=isarray%>'></td></tr>"
		    <%
	        }
	        %>
	        oDiv.innerHTML=htmlstr+"</table>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
<%
		}
	}
%>
	reshowCheckBox();
}
$(document).ready(function(){
	ParseWSDL(1);
	isload = true;
});
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
function onSubmit(){
	var checkfields = "customname,webserviceurl,methodname";
	
	if(check_form(frmMain,checkfields)) {
		var methodnameMap = new Map();
		var methodnameList = document.getElementsByName("methodname");
		for(i=0;i<methodnameList.length;i++) {
			if(methodnameMap.get(methodnameList[i].value)==null||methodnameMap.get(methodnameList[i].value)=='undefined') {
				methodnameMap.put(methodnameList[i].value,methodnameList[i].value);
			} else {
				top.Dialog.alert(methodnameList[i].value+'<%=SystemEnv.getHtmlLabelName(26603,user.getLanguage())%>');
				return;
			}
		}
		
		frmMain.operator.value = "save";
		frmMain.submit();
	}
	
}
/*QC294509 [80][90]WebService注册-解决注册名称中带有特殊字符造成乱码的问题 start*/
//检查是否是特殊字符
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
function isExist(){
	var customename = document.getElementById("customname").value;
	newvalue = $.trim(customename);	
	if(isSpecialChar(newvalue)){
		//标识包含特殊字段，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128458,user.getLanguage())%>");
		document.getElementById("customname").value = "";
		checkinput("customname","customnameimage");
		return false;
	}
	return true;
}
/*QC294509 [80][90]WebService注册-解决注册名称中带有特殊字符造成乱码的问题 end*/
function onBack()
{
	document.location.href='/integration/webserivcesettingList.jsp';
}
function onClose()
{
	parentWin.closeDialog();
}
function deleteData()
{
   	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>?", function (){
		document.frmMain.operator.value="delete";
       	document.frmMain.submit();
	}, function () {}, 320, 90);
}

function changecheckValue(obj)
{
var tmpvalue = $(obj).val();

	// 处理$GetEle可能找不到对象时的情况，通过id查找对象
  if(tmpvalue==undefined)
	 tmpvalue = $GetEle(elementname).value;
    if(tmpvalue==undefined)
        tmpvalue=document.getElementById(elementname).value;

	while(tmpvalue.indexOf(" ") >= 0){
		tmpvalue = tmpvalue.replace(" ", "");
	}
	if(tmpvalue != ""){
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue != ""){
			
			 $(obj).closest("td").find("span").eq(1).html("");
		}else{
		$(obj).closest("td").find("span").eq(1).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
	}else{
		$(obj).closest("td").find("span").eq(1).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	}
}
/*QC331056 [80][90][优化]WebService注册-解决接口方法描述中带有特殊字符造成按钮失效，显示错乱的问题-优化 start */
/*function limitmethoddesc(value,object){
   object.value = object.value.replace(/[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/g,'');
}*/
function checkmethoddesc(object){
     if(isSpecialChar(object.value)){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132008,user.getLanguage())%>");//描述包含特殊字符，请重新输入！
        object.value="";
     }
}
//检验特殊字符
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
/*QC331056 [80][90][优化]WebService注册-解决接口方法描述中带有特殊字符造成按钮失效，显示错乱的问题-优化 end */
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick="onClose();"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</HTML>
