
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.*" %>


<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String type = Util.null2String(request.getParameter("type"));

String url = "";
if("1".equals(type))
{
	url = "/servicesetting/datasourcesetting.jsp";
}
else if("2".equals(type))
{
	url = "/workflow/automaticwf/automaticsetting.jsp";
}
else if("3".equals(type))
{
	url = "/integration/financelist.jsp";
}
else if("4".equals(type))
{
	url = "/interface/outter/OutterSysTab.jsp";
}
else if("5".equals(type))
{
	url = "/integration/icontent.jsp?showtype=6&type=1";
}
else if("6".equals(type))
{
	url = "/integration/actioncontent.jsp";
}
else if("7".equals(type))
{
	url = "/integration/ldapsetting.jsp";
}
else if("8".equals(type))
{
	url = "/servicesetting/schedulesetting.jsp";
}
else if("9".equals(type))
{
	url = "/integration/showcontent.jsp";
}
else if("10".equals(type))
{
	url = "/integration/hrsetting.jsp";
}
else if("11".equals(type))
{
	url = "http://www.baidu.com";
}
else if("12".equals(type))
{
	url = "/integration/icontent.jsp?type=1&showtype=1";
}
else if("13".equals(type))
{
	url = "/integration/icontent.jsp?showtype=2&type=1";
}
else if("14".equals(type))
{
	url = "/integration/icontent.jsp?showtype=3&type=1";
}
else if("15".equals(type))
{
	url = "/integration/icontent.jsp?showtype=4&type=1";
}
else if("16".equals(type))
{
	url = "/integration/icontent.jsp?showtype=5&type=1";
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title></title>
		<!--For Base-->
		<link rel="stylesheet" type="text/css" href="/wui/common/css/base_wev8.css" />
		<script type="text/javascript" language="javascript" src="/js/jquery/jquery_dialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>

        <STYLE TYPE="text/css">
            
            body{
                 margin: 0px; 
                /*可以被动态更改的值*/
                /*background:url('images/body-bg_wev8.png') repeat-y;*/
                font-size: 9pt;font-family: verdana;
                
            }
            TABLE {
			    FONT-SIZE: 9pt; FONT-FAMILY: Verdana
			}
            .xTable_message{
			    border:1px solid #8888AA;
			    background:white;
			    position:absolute;
			    padding:5px;
			    z-index:100;
			    display:none;
			    FONT-SIZE: 9pt; 
			    MARGIN: 0px; 
			    FONT-FAMILY: Verdana; 
			    LIST-STYLE-TYPE: circle; 
            }   
            
            table td{
                padding:0px;
            }
            #container{
                width:100%;height:100%;    border-collapse:collapse;
            }
            


            #contentContainer{
                WIDTH:100%;height:100%;
                border-collapse:collapse;
            }
            #contentContainer #content{
                WIDTH:100%;height:100%;
                border-collapse:collapse;
            }
            #footer{
				
            }
            #shadown-content{background:#fff;}
            
            
            /*可更改区域  左侧菜单*/
            /*左侧菜单下*/
            #menucontainer{
            	border:1px solid #8888AA;
            	width:100%!important;
            	height:100%;
            }
            /*左侧菜单上*/
            #menucontainer-top{
                height:8px;
            }

            #leftmenu-top{
                height:86px;
            } 
            #leftmenu-bottom{
                
                height:250px;                
            }
            #leftmenu-bottom-bottom{
                height:7px;
            }
			#leftmenu-bottom {
				position:absolute;
				width:128;
				height:0px;
				z-index:0;
			}
			
			
			#leftBlockTd {
				background:none;
				
			}
			
			#mainFrame1 {
				height:100%!important;
			}
			/*IE6 fixed*/
			ul,li{ margin:0px; padding:0px; list-style:none;width:100%;}
			body a{ color:#333333; font-size:14px;width:100%;}
			a{ text-decoration:none;}
			/*两级菜单树jquery插件特效 懒人建站*/
			#menubox{ width:200px; overflow:hidden;}
			#menubox ul li{line-height:30px;background-color: #F0F0F0; border-bottom:#CCC solid 1px;width:100%;}
			#menubox a{padding-left:6px; padding-right:6px;width:100%;}
			
			#menubox .thismenu{ background-color:#030; color:#ffffff; border:none;}
			#menubox .thismenu a{ color:#ffffff; }
			
			#menubox .submenu{ display:none; background-color:#ffffff;}
			#menubox .submenu a{ height:26px; line-height:26px; color:#030; display:block;border-bottom:#CCC dashed 1px;}
			.hoverclass{ background-color:#589456; color:#ffffff;}

        </STYLE>
		<script type="text/javascript">
		$(document).ready(function(){
			$('#mainFrame1').attr("src","<%=url%>");
			jQuery.jqmenu = function(menuboxid,submenu,type){
				var menuboxli = $(menuboxid+" li");
				menuboxli.eq(type).find(submenu).show();
				menuboxli.eq(type).addClass("thismenu");
				//menuboxli.find("a:first").attr("href","javascript:;");
				menuboxli.click( function () {
					$(this).addClass("thismenu").find(submenu).show().end().siblings("li").removeClass("thismenu").find(submenu).hide();
				});
			};
			//调用方法，可重用
			<%if(Util.getIntValue(type,0)<11){%>
			$.jqmenu("#menubox","div.submenu",0);
			<%}else{%>
			$.jqmenu("#menubox","div.submenu",1);
			<%}%>
			
			try
			{
				$("#link<%=type%>").addClass("hoverclass");
			}
			catch(e)
			{
			}
		});
		function changeclass(obj)
		{
			try
			{
				$(".hoverclass").removeClass("hoverclass");
				$(obj).addClass("hoverclass");
			}
			catch(e)
			{
			}
		}
		function changeclass2(obj)
		{
			try
			{
				$(".hoverclass").removeClass("hoverclass");
			}
			catch(e)
			{
			}
		}
		</script>
    </head>
        
    
<!-- 锁定整个界面的CSS2011/5/19 -->

    <body id="mainBody" scroll="no"  style="">
			
			<!-- 签到签退用div -->
            <div id='divShowSignInfo' style='background:#FFFFFF;padding:0px;width:100%;display:none;' valign='top'></div>            
            <div id='message_Div' style='display:none;'></div>    
            <table id="container"  height="70px" cellspacing="0" cellpadding="0">
                <tr height="*"><td>
                    <table id="contentcontainer">
                        <tr height="*">
                            <td  width="100%">
                                <table id="content">
	                                <tr>
	                                    <td width="129px" id="leftBlockTd" style="padding-top:1px;">
	                                        <!--放置左侧菜单区-->
	                                        <div id="menucontainer" style="width:100%!important;overflow:hidden;"> 
	                                            <div>
	                                                <table width="100%" cellpadding="0px" cellspacing="0px">
	                                                    <tr>
	                                                    	<td style="position:relative;">
		                                                    	<div id="leftmenu-bottom"></div>
		                                                        <!--放置左侧菜单区-->
		                                                        <div id="menubox" style="margin-top:8px;">
																	<ul>
																    	<li><a href="http://www.baidu.com" target='mainFrame1' onclick='changeclass2(this);'><%=SystemEnv.getHtmlLabelName(32213 ,user.getLanguage())%><!-- 功能集成 --></a>
																        	<div class="submenu">
																            	<a id="link4" href="/interface/outter/OutterSysTab.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(20960 ,user.getLanguage())%><!-- 集成登录 --></a>
																                <a id="link7" href="/integration/ldapsetting.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(33718 ,user.getLanguage())%><!-- LDAP集成 --></a>
																                <a id="link1" href="/servicesetting/datasourcesetting.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(32264 ,user.getLanguage())%><!-- 数据源设置 --></a>
																                <a id="link10" href="/integration/hrsetting.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(33719 ,user.getLanguage())%><!-- HR同步 --></a>
																                <a id="link5" href="/integration/icontent.jsp?showtype=6&type=1" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(23082 ,user.getLanguage())%><!-- 公文交换 --></a>
																                <a id="link8" href="/servicesetting/schedulesetting.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(16539 ,user.getLanguage())%><!-- 计划任务 --></a>
																                <a id="link2" href="/workflow/automaticwf/automaticsetting.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(33720 ,user.getLanguage())%><!-- 流程触发集成 --></a>
																                <a id="link3" href="/integration/financelist.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(32265 ,user.getLanguage())%><!-- 财务凭证 --></a>
																                <a id="link6" href="/integration/actioncontent.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(32338 ,user.getLanguage())%><!-- 流程流转集成 --></a>
																                <a id="link9" href="/integration/WsShowEditSetList.jsp" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(32303 ,user.getLanguage())%><!-- 数据展现集成 --></a>
																            </div>
																        </li>
																        <li><a href="http://www.baidu.com" target='mainFrame1' onclick='changeclass2(this);'><%=SystemEnv.getHtmlLabelName(32300 ,user.getLanguage())%><!-- 产品集成 --></a>
																        	<div class="submenu">
																                <a id="link12" href="/integration/icontent.jsp?type=1&showtype=1" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(26968 ,user.getLanguage())%><!-- SAP集成 --></a>
																                <a id="link13" href="/integration/icontent.jsp?showtype=2&type=1" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(33721 ,user.getLanguage())%><!-- NC集成 --></a>
																                <a id="link14" href="/integration/icontent.jsp?showtype=3&type=1" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(33722 ,user.getLanguage())%><!-- EAS集成 --></a>
																                <a id="link16" href="/integration/icontent.jsp?showtype=4&type=1" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(33723 ,user.getLanguage())%><!-- U8集成 --></a>
																                <a id="link15" href="/integration/icontent.jsp?showtype=5&type=1" target='mainFrame1' onclick='changeclass(this);'><%=SystemEnv.getHtmlLabelName(33724 ,user.getLanguage())%><!-- K3集成 --></a>
																            </div>
																        </li>
																    </ul>
																</div>
		                                                        <div id="leftmenu-bottom-bottom">
		                                                        	<div class="leftMenuBottomLeft"></div>
		                                                        	<div id="leftMenuBottomCenter"></div>
		                                                        	<div class="leftMenuBottomRight"></div>
		                                                        </div>
	                                                    	</td>
	                                                    </tr>
	                                                </table>
	                                            </div>
	                                        </div>
	                                        
	                                    </td>
	                                    <td  width="*">
	                                        <TABLE width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	                                        <TR>
	                                            <TD id="shadown-corner"></TD>
	                                            <TD width="*"  id="shadown-x">
	                                            	<!-- 顶部菜单隐藏用block -->
	                                            	<TABLE width="100%" height="100%" cellpadding="0px" cellspacing="0px"><TR><TD align="center">
	                                            		<table border="0" width="502px" height="5px" align="center" cellpadding="0px" cellspacing="0px"><tr><td style="position:relative;width:502px;">
	   														<div id="topBlockHiddenContr">
			                                            	</div>
	        										</td></tr></table></TD></TR></TABLE>
	                                            </TD>
	                                        </TR>
	                                        <TR>
	                                            <TD id="shadown-y" align="center">
	                                            	<!-- 左侧菜单隐藏用block -->
	                                            	<TABLE width="100%" height="100%" cellpadding="0px" cellspacing="0px"><TR><TD align="center">
	                                            		<table border="0" width="100%" height="502px" width="0" align="center" cellpadding="0px" cellspacing="0px"><tr><td style="position:relative;">
	   														<div id="leftBlockHiddenContr">
			                                            	</div>
	        										</td></tr></table></TD></TR></TABLE>
	                                            </TD>
	                                            <TD  id="shadown-content" valign="top">
	                                            	<iframe name="mainFrame1" id="mainFrame1" border="0"
				                                        frameborder="no" noresize="noresize"  width="100%"
				                                        scrolling="auto" src="" style="height:100%;"></iframe> 
	                                            </TD>
	                                        </TR>
	                                        </TABLE>
	                                    </td>
	                                </tr>
                                </table>
                            </td>
                            <td  width="5px"></td>
                        </tr>
                    </table>                
                </td></tr>
            </table>
    </body>
</html>
