<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%> 
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@page import="weaver.mobile.rong.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="SocialManageService" class="weaver.social.manager.SocialManageService" scope="page" />
<%@ page import="weaver.social.po.SocialClientProp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(user==null){
    return;
}
String pcClientSettings = SocialClientProp.serialize();
String userid =""+user.getUID();
String username = user.getUsername();
Boolean isOpenfire = SocialOpenfireUtil.getInstanse().isBaseOnOpenfire();
String openfireDomain ="";
String openfireEMobileUrl ="";
String openfireMobileClientUrl ="";
String openfireHttpbindPort ="";
String openfireEmessageClientUrl = "";
String Openfire = "";
//获取udid
String udid = RongService.getRongConfig().getAppUDIDNew().toLowerCase();
String prop = (GCONST.getRootPath()+ "WEB-INF"+ File.separator + "prop").replace("\\","/");
String webinf = (GCONST.getRootPath()+ "WEB-INF").replace("\\","/");
if(isOpenfire){
	String emPropPath = GCONST.getRootPath()+ "WEB-INF/prop/OpenfireModule.properties"; 
	JSONObject result = new JSONObject();
	try{
	    File emPropFile = new File(emPropPath);
	    OrderProperties emProp = new OrderProperties();
	    if(emPropFile.exists()){
	        emProp.load(emPropPath);
	        List<String> it=emProp.getKeys();
	        for(String key  : it){
	            String value = Util.null2String(emProp.get(key));
	            result.put(key,value);
	        }
	    }
	}catch(Exception e){}
	Openfire = result.getString("Openfire");
	openfireDomain = result.getString("openfireDomain");
	openfireEMobileUrl = result.getString("openfireEMobileUrl");
	openfireMobileClientUrl = result.getString("openfireMobileClientUrl");
	openfireHttpbindPort = result.getString("openfireHttpbindPort");
	try{
	    openfireEmessageClientUrl = result.getString("openfireEmessageClientUrl");
	}catch(Exception e){
	    openfireEmessageClientUrl = "";
	}
}else{
    Openfire = "false";
}
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>   
    <title>emessage问题检测页面</title>   
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link type="text/css" href="../css/socialimcheck/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../css/socialimcheck/htmleaf-demo.css">
    <style type="text/css">
        #dataTable table tr:hover td { background-color: palegoldenrod; }
        #loadingModal {
         position: absolute;
        top: 50%;
        left: 50%;
        transform: translateX(-50%) translateY(-50%);
        }
    </style>
  </head>
  
  <body>
    <div class="htmleaf-container">
        <header class="htmleaf-header">
            <h1>emssage问题检测页面</h1>
        </header>
        <div id="checkSum" style="margin:auto; width:80%;padding:2em 0;">
            <div>
            <div id="loginUser" style="float:left;display:inline-block;margin-bottom:10px;margin-right:10px;margin-top:10px;margin-left:10px;"></div>
            <div id="checkButton" style="margin-bottom:10px;float:right;margin-right:10px;margin-top:10px;"><input type="button" onclick="doAllCheck(this)" value="全量检测" class="btn btn-default" /></div>
            </div>
            <div id="dataTable" class="table table-striped table-bordered" cellspacing="0" width="80%">
            </div>
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="modal-header">
			                <button type="button" class="close" data-dismiss="modal" 
			                        aria-hidden="true">×
			                </button>
			                <h4 class="modal-title" id="myModalLabel">
			                    解决方案
			                </h4>
			            </div>
			            <div class="modal-body">
			                文字说明
			            </div>
			            <div class="modal-footer">
			            </div>
			        </div><!-- /.modal-content -->
			    </div><!-- /.modal-dialog -->
			</div><!-- /.modal -->
			</div>
        </div>
    </div>
    
    <script>document.write('<script src="../js/socialimcheck/jquery-1.11.0.min.js"><\/script>')</script>
    <script src="../js/socialimcheck/bootstrap.min.js"></script>
    <script src="../js/socialimcheck/raydreams.js"></script>
    <script type="text/javascript">
            //var jQuery = jQuery.noConflict(true);
            ClientSet=JSON.parse('<%=pcClientSettings%>');
            var userid = "<%=userid%>";
            var username = "<%=username%>";
            var Openfire = "<%=Openfire%>";
            var udid = "<%=udid%>";
            var prop = "<%=prop%>";
            var webinf = "<%=webinf%>";
            var openfireEMobileUrl = "<%=openfireEMobileUrl%>";
            var openfireMobileClientUrl = "<%=openfireMobileClientUrl%>";
            var openfireHttpbindPort = "<%=openfireHttpbindPort%>";
            var openfireEmessageClientUrl = "<%=openfireEmessageClientUrl%>";
            var openfireDomain = "<%=openfireDomain%>";
            var dataTable = null;
            jQuery('#loginUser').html('当前登录用户:'+username);
            jQuery(document).ready(function () {
                dataTable = jQuery("#dataTable").raytable({
                    datasource: { data: [], keyfield: 'id' },
                    columns: [
                        { field:"check", title: "检查项(点击进行单项检查)" },
                        { field: "checkResult", title: "检查结果"},
                        { field: "checkSolve", title: "解决方案" }
                    ],
                    pagesize: 20,
                    maxPageButtons: 5,
                    rowNumbers: true,
                    rowClickHandler: rowAction
                });
                jQuery(".glyphicon").css('cursor', 'pointer');
                doLoad(jQuery("#dataTable"));
            });
            
            //模态窗口显示时候触发
            $('#myModal').on('show.bs.modal', function () {
                var $content = jQuery('#myModal').find('.modal-body');
                var id = $content.attr('id');
                if(id=='checkNinety'){
                    $content.html("1、检查emessage私有云服务是否启动，如未启动请先启动服务</br>2、检查ecology服务器是否可访问地址"+openfireEMobileUrl+"，如无法访问，请调整网络以满足访问请求</br>");
                }else if(id=='checkMessageClient'){
                    $content.html("1、端口"+openfireHttpbindPort+"需映射</br>2、服务器防火墙需添加"+openfireHttpbindPort+"端口的通行规则");
                }else if(id=='checkToken'){
                    if(Openfire=='true'){
                        $content.html("1、重启ecology服务，如果有部署运维平台请从运维平台重启ecology，如果没有请直接服务器端重启。</br>2、升级e-message私有云服务升级包");
                    }else{
                        $content.html("客户使用融云服务，外网登录正常，请检查网络配置：</br>"+
						"1、ecology服务器需要能访问api.cn.ronghub.com</br>"+
						"2、所有的客户端电脑需要能访问nav.cn.ronghub.com</br>"+
						"3、所有的客户端电脑需要能访问融云服务器集群：</br>"+
						"集群地址和相关端口在：http://serivcelist.ronghub.com/service.txt");
                    }
                }else if(id=='checkUdid'){
                    $content.html("1、查询表mobileproperty，查看里面是否有多个rongAppUDID或rongAppUDIDNew，如果有多个，去emessage私有云后台看同步到的是哪个，把其他的删除掉，</br>2、然后重启ecology服务和emessage服务");
                }else if(id=='checkMobileRong'){
                    $content.html("1、"+prop+"目录下新建一个EMobileRong.properties文件，内容如下：</br>AppKey=8w7jv4qb7ucdy</br>AppSecret=");
                }else if(id=='checkMobileClient'){
                    $content.html("1、端口5222需映射</br>2、服务器防火墙需添加5222端口的通行规则");
                }else if(id=='checkSocialFilter'){
                    $content.html("1、在"+webinf+"/web.xml文件里查看有没有filtername为WSessionClusterFilter的过滤器配置，</br>如果有，则在此过滤器的filter-mapping结束后加如下内容：</br>"+
					  "<xmp><filter></xmp>"+
					    "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
					   "<xmp><filter-class>weaver.social.filter.SocialIMFilter</filter-class></xmp>"+
					 "<xmp></filter></xmp>"+
					  "<xmp><filter-mapping></xmp>"+
					    "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
					    "<xmp><url-pattern>/social/im/*.jsp</url-pattern></xmp>"+
					  "<xmp></filter-mapping></xmp>"+
					  "<xmp><filter-mapping></xmp>"+
					    "<xmp><filter-name>SocialIMFilter</filter-name></xmp>"+
					    "<xmp><url-pattern>/weaver/weaver.file.FileDownload</url-pattern></xmp>"+
					  "<xmp></filter-mapping></xmp>"+
					"注意：如果没有WSessionClusterFilter过滤器，则将以上过滤器加在第一个filter开始之前");
                }else if(id=='checkSafeLogin'){
                    $content.html("1、在"+webinf+"目录下找到文件weaver_security_config.xml,</br>2、找到配置项is-login-check，把该项置为false，如下：</br><xmp><is-login-check>false</is-login-check></xmp>");
                }
            })
            
            function doAllCheck(){
                for (var i =0 ; i < dataTable.datasource.data.length; ++i)
				{
				    var id = dataTable.datasource.data[i].id;
                    doCheck(id,i);
				}
				//$('#dataTable').find('table').find('span').each(function(index,obj){
				//    var id = dataTable.datasource.data[index].id;
				//    doCheck(id,index);
				//});
            }
            
            //加载数据
            function doLoad(sender) {
                var myData = [];
                if(Openfire=="true"){
                    var data1 = {"check":"ecology服务器是否能访问emessage服务", "checkResult":"","checkSolve":"","id":"checkNinety"};
                    var data2 = {"check":"检测e-message是否畅通", "checkResult":"","checkSolve":"","id":"checkMessageClient"};
                    var data3 = {"check":"获取token信息是否正常", "checkResult":"","checkSolve":"","id":"checkToken"};
                    var data5 = {"check":"检测Emobile客户端是否畅通", "checkResult":"","checkSolve":"","id":"checkMobileClient"};
                    myData.push(data1);
                    myData.push(data2);
                    myData.push(data3);
                    myData.push(data5);
                }else{
                    var data1 = {"check":"私有云消息服务为关闭状态，检查获取token是否正确", "checkResult":"","checkSolve":"","id":"checkToken"};
                    myData.push(data1);
                }
                var data4 = {"check":"人员UDID检查", "checkResult":"","checkSolve":"","id":"checkUdid"};
                var data6 = {"check":"检查EMobileRong.properties文件是否正常", "checkResult":"","checkSolve":"","id":"checkMobileRong"};
                var data7 = {"check":"检测SocialIMFilter过滤器", "checkResult":"","checkSolve":"","id":"checkSocialFilter"};
                var data8 = {"check":"检测是否开启定时删除附件功能", "checkResult":"","checkSolve":"","id":"checkSocialServlet"};
                var data9 = {"check":"检测安全补丁包是否拦截emessage登录", "checkResult":"","checkSolve":"","id":"checkSafeLogin"};
                myData.push(data4);
                myData.push(data6);
                myData.push(data7);
                myData.push(data8);
                myData.push(data9);
                dataTable.data(myData,'id');
            }
            
            
            function checkNinety(id,index){
                var data = checkLoading(index,id);
                var a = document.createElement('a');  
                a.href = openfireEMobileUrl;  
                var host = a.hostname;
                jQuery.post('/social/manager/SocialManagerOperation.jsp?method=checkPort',{port: 9090,hostname : host}, function(ok){
                    if(jQuery.trim(ok)==='1'){
                        data.checkResult = "检测通过";
                        data.checkSolve = "";
                    }else{
                        data.checkResult = "检查失败";
                        data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkNinety" onclick="setId(this);">解决方案</a>';
                    }
                    dataTable.data(dataTable.datasource.data,id);
                });
            }
            
            function setId(obj){
                var id = $(obj).attr('id');
                $('#myModal').find('.modal-body').attr('id',id);
            }
            
            function checkMobileRong(id,index){
                var data = checkLoading(index,id);
                jQuery.post('/social/manager/SocialManagerOperation.jsp?method=getMobileRong', function(result){
                   var result = JSON.parse(jQuery.trim(result));
                   if(result!=undefined&&result!=''&&result.isExist=="true"){
                       var AppKey = result.AppKey;
                       var AppSecret = result.AppSecret;
                       data.checkResult = "检测通过，文件内容：</br>AppKey="+AppKey;
                       data.checkSolve = "";
                   }else{
                       data.checkResult = "检测失败，无此文件";
                       data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkMobileRong" onclick="setId(this);">解决方案</a>';
                   }
                   dataTable.data(dataTable.datasource.data,id);
              });
            }
            
            function checkUdid(id,index){
                var data = checkLoading(index,id);
                if(udid==''){
                    data.checkResult = "检测失败，获取的UDID值为空";
                    data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkUdid" onclick="setId(this);">解决方案</a>';
                }else{
                    data.checkResult = "检测通过，获取到的UDID值为"+udid;
                    data.checkSolve = "";
                }
                dataTable.data(dataTable.datasource.data,id);
            }
            
            function doCheck(data,index){
                if(data=="checkToken"){
                    checkToken(data,index);
                }else if(data=="checkMessageClient"){
                    checkMessageClient(data,index);
                }else if(data=="checkMobileClient"){
                    checkMobileClient(data,index);
                }else if(data=="checkSocialFilter"){
                    checkSocialFilter(data,index);
                }else if(data=="checkSocialServlet"){
                    checkSocialServlet(data,index);
                }else if(data=="checkSafeLogin"){
                    checkSafeLogin(data,index);
                }else if(data=="checkUdid"){
                    checkUdid(data,index);
                }else if(data=="checkMobileRong"){
                    checkMobileRong(data,index);
                }else if(data=="checkNinety"){
                    checkNinety(data,index);
                }
            }
            //点击图标触发事件
            function iconAction(event)
            {
                var data = jQuery(event.target).data('ray-data');
                var index = dataTable.currentSelection.rowIdx;
                if(data==undefined||data==''){
                    data = dataTable.currentSelection.id;
                    if(data==undefined||data==''){
                       data = dataTable.datasource.data[index].id;
                    }
                }
                if($(event.target).attr('id')!==undefined){
                    return;
                }
                if(data=="checkToken"){
                    checkToken(data,index);
                }else if(data=="checkMessageClient"){
                    checkMessageClient(data,index);
                }else if(data=="checkMobileClient"){
                    checkMobileClient(data,index);
                }else if(data=="checkSocialFilter"){
                    checkSocialFilter(data,index);
                }else if(data=="checkSocialServlet"){
                    checkSocialServlet(data,index);
                }else if(data=="checkSafeLogin"){
                    checkSafeLogin(data,index);
                }else if(data=="checkUdid"){
                    checkUdid(data,index);
                }else if(data=="checkMobileRong"){
                    checkMobileRong(data,index);
                }else if(data=="checkNinety"){
                    checkNinety(data,index);
                }
            }
            
            function checkLoading(index,id){
                var data = dataTable.datasource.data[index];
                data.checkResult = "检查中，请稍后";
                data.checkSolve = "检查中，请稍后";
                dataTable.data(dataTable.datasource.data,id);
                return data;
            }
            
            function checkSocialFilter(id,index){
                var data = checkLoading(index,id);
                var url = "/social/manager/SocialManagerOperation.jsp?method=isBaseFilterConfigured";
                jQuery.post(url,function(flag){
                    var isflag = jQuery.trim(flag);
                    if(isflag=='true'){
                        data.checkResult = "已配置";
		                data.checkSolve = "";
                    }else{
                        data.checkResult = "检测失败：未配置";
                        data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkSocialFilter" onclick="setId(this);">解决方案</a>';
                    }
                    dataTable.data(dataTable.datasource.data,id);
                });
            }
            
            function checkSocialServlet(id,index){
                var data = checkLoading(index,id);
                var isSet = ClientSet.isOpenDeleteFileTask; 
                var url = "/social/manager/SocialManagerOperation.jsp?method=isServletFilterConfigured";
                jQuery.post(url,function(flag){
                    var isflag = jQuery.trim(flag);
                    if(isflag=='true'){
                        if(isSet=="1"){
                            data.checkResult = "功能已开启：检测通过";
                        }else{
                            data.checkResult = "功能没开启：但SocialIMServlet已配置";
                        }
                        data.checkSolve = "";
                    }else{
                        data.checkResult = "检测失败SocialIMServlet未配置";
                        data.checkSolve = '<a href="#" onclick="openUrl()">解决方案</a>';
                    }
                    dataTable.data(dataTable.datasource.data,id);
                });
            }
            
            function openUrl(){
                window.open('http://im.cobiz.cn/html/emessagefile/emessage4%E9%99%84%E4%BB%B6%E5%92%8C%E5%9B%BE%E7%89%87%E8%87%AA%E5%8A%A8%E5%88%A0%E9%99%A4%E5%8A%9F%E8%83%BD%E9%85%8D%E7%BD%AE%E6%89%8B%E5%86%8C.htm','_blank');
            }
            
            function checkSafeLogin(id,index){
                var data = checkLoading(index,id);
                var url = "/social/manager/SocialManagerOperation.jsp?method=isLoginCheckOpen";
                jQuery.post(url,function(flag){
                    var isflag = jQuery.trim(flag);
                    if(isflag=='true'){
                        data.checkResult = "登录安全检测正常";
                        data.checkSolve = "";
                    }else{
                        data.checkResult = "检测失败：未正确配置";
                        data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkSafeLogin" onclick="setId(this);">解决方案</a>';
                    }
                    dataTable.data(dataTable.datasource.data,id);
                });
            }

            function checkToken(id,index){
                var url = "";
			    if(Openfire=="true"){
			       url = "/social/im/SocialIMOperation.jsp?operation=getTokenOfOpenfire&reFreshToken=1";
			    }else{
			       url = "/social/im/SocialIMOperation.jsp?operation=getUserTokenOfRong&userid="+userid;
			    }
			    var data = checkLoading(index,id);
			    jQuery.post(url,function(token){
			          var json = jQuery.trim(token);
			          if(json!==undefined&&json!==''){
			              if(Openfire=='false'){
			                  var result = JSON.parse(json);
			                  data.checkResult = "检测通过，获取到的TOKEN值为"+result.TOKEN;
			              }else{
			                  data.checkResult = "检测通过，获取到的TOKEN值为"+jQuery.trim(token);
			              }
			              data.checkSolve = "";
			          }else{
			              data.checkResult = "检测失败，获取的TOKEN值为空";
                          data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkToken" onclick="setId(this);">解决方案</a>';
			          }
			          dataTable.data(dataTable.datasource.data,id);
			     });
            }
            
            function checkMessageClient(id,index){
		        var data = checkLoading(index,id);
                var hostname = "";
		        if(openfireEmessageClientUrl==""){
		           hostname = openfireMobileClientUrl;
		        }else{
		           hostname = openfireEmessageClientUrl;
		        }
		      jQuery.post('/social/manager/SocialManagerOperation.jsp?method=checkPort',{"port": openfireHttpbindPort,"hostname" : hostname}, function(ok){
		           if(jQuery.trim(ok)==='1'){
		               data.checkResult = "检测通过，配置的地址对应的端口畅通";
                       data.checkSolve = "";
		           }else{
		               data.checkResult = "检测失败，message服务地址的"+openfireHttpbindPort+"端口不通";
                       data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkMessageClient" onclick="setId(this);">解决方案</a>';
		           }
		           dataTable.data(dataTable.datasource.data,id);
		      });
            }
            
            function checkMobileClient(id,index){
                var data = checkLoading(index,id);
                jQuery.post('/social/manager/SocialManagerOperation.jsp?method=checkPort',{port: 5222,hostname : openfireMobileClientUrl}, function(ok){
	                if(jQuery.trim(ok)==='1'){
	                    data.checkResult = "检测通过，"+openfireMobileClientUrl+"的5222端口畅通";
                        data.checkSolve = "";
	                }else{
	                    data.checkResult = "检测失败，"+openfireMobileClientUrl+"的5222端口不通";
                        data.checkSolve = '<a data-toggle="modal" data-target="#myModal" href="#" id="checkMobileClient" onclick="setId(this);">解决方案</a>';
	                }
	                dataTable.data(dataTable.datasource.data,id);
                });
            }
            
            //表格点击事件
            function rowAction(event)
            {
                iconAction(event);
            }
            
            //格式化数据
            function parseDate(item)
            {
                // source is ISO 8601
                var d = new Date(item.birthDate);
                return d.toDateString();
            }
        </script>
  </body>
</html>
