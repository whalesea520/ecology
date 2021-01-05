
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="com.weaver.upgrade.FunctionUpgradeUtil" %>

<%@ page import="weaver.system.License" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.lang.reflect.Method" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=SystemEnv.getHtmlLabelName(32213,user.getLanguage()) %></title><!-- 功能集成 -->
<style type="text/css">
html,body,ul,li,ol,dl,dd,dt,form,table,tr,td,p,b,span,a,img,h1,h2,h3,h4,h5,h6,em,input,select,option,textarea,div{margin:0;padding:0;}
body{font-family:Microsoft Yahei; font-size:12px;background:#f7f7fa;background-color: #f7f7fa;}
h1,h2,h3,h4,h5,h6{line-height:100%;}
a{ color:#666; text-decoration:none;}
.fl{ float:left}
.fr{ float:right;}
li{list-style:none;}
img{border:none;}
.clear{clear:both;}
p{ font-size:12px; color:#666;}
.lable th{ width:70px; text-align:right;}

.contenta{ background: url(../images/contenta_wev8.gif) repeat-x; height:132px; width:100%;margin:0px auto; padding-top:20px; padding-bottom:20px;}
ul li{
	cursor:hand;
	width:191px; height:100px;
	float:left;
	margin-top:10px;margin-left: 10px;
}
.content{
	height:100px;
	text-align:left;
	vertical-align:bottom;
	font-family:"微软雅黑"!important;
	font-size:12px;
	color:white;
	font-weight:bold;
	position:relative;
	cursor:pointer!important;cursor:hand;
}
.content span{
	width:100%;
	height:24px;
	vertical-align:bottom;
	text-align:center;
	bottom:0px;
	padding:5px 0px 0px 0px;
	margin:0px;
	color:white;
	position:absolute;
	cursor:pointer!important;cursor:hand;
}
</style>
</head>


<body onload='resetDiv();'>
<div id='content' style="width:100%; margin:0px auto;text-align:center;position:absolute;">
	<ul style="width:862px;margin:0px auto;text-align:center;">
		<%
		String sysCId = new License().getCId();

        MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
        mu.setUser(user);
		//rs.executeSql("SELECT m.id,m.labelId,m.linkAddress FROM MainMenuInfo m where m.parentId = 10110 and not exists(select 1 from menucontrollist i where m.id=i.menuid and i.isopen=-1) ORDER BY m.defaultIndex asc");
		//rs.executeSql("SELECT * FROM MainMenuInfo m where m.parentId = 10110 ORDER BY m.defaultIndex asc");

        ArrayList menuIds = new ArrayList();
		RecordSet rs=mu.getMenuRs(10110);
		while(rs.next())
		{
            int infoid=rs.getInt("infoid");
            if(menuIds.contains(String.valueOf(infoid))){
                continue;
            }
            menuIds.add(String.valueOf(infoid));

			int menuid = rs.getInt("id");
			int needResourcetype=rs.getInt("resourcetype");
			int needResourceid=rs.getInt("resourceid");
			if(!mu.hasShareRight(infoid,needResourceid,needResourcetype)){
				continue;
			}
			boolean _needRightToVisible = rs.getString("needRightToVisible").equals("1") ? true : false;
			boolean _needSwitchToVisible = rs.getString("needSwitchToVisible").equals("1") ? true : false;
			String _rightDetailToVisible = rs.getString("rightDetailToVisible");
			String _switchMethodNameToVisible = rs.getString("switchMethodNameToVisible");
			int _relatedModuleId = rs.getInt("relatedModuleId");

			String visibility = isDisplay(_needRightToVisible,_needSwitchToVisible,_rightDetailToVisible,_switchMethodNameToVisible,_relatedModuleId,user);
			if("hidden".equals(visibility)) {
				continue;
			}

//			int resMenuId = FunctionUpgradeUtil.getMenuId(menuid, Integer.parseInt(sysCId));
//			int isopen = FunctionUpgradeUtil.getMenuStatus(menuid, -1, Integer.parseInt(sysCId));
//			//System.out.println("resMenuId:"+resMenuId);
//			//System.out.println("isopen:"+isopen);
//			rs2.executeSql("select 1 from menucontrollist i where i.menuid="+resMenuId+" and i.isopen="+isopen);
//			if(rs2.next()) {
//				continue;
//			}

            String linkAddress = Util.null2String(rs.getString("linkAddress")).trim();
            int lableid = rs.getInt("lableid");
			/*
			/integration/integrationTab.jsp?urlType=3	数据源设置
			/integration/integrationTab.jsp?urlType=1	WebService注册
			/integration/integrationTab.jsp?urlType=6	集成登录
			/integration/integrationTab.jsp?urlType=2	LDAP集成
			/integration/integrationTab.jsp?urlType=4	HR同步
			/integration/integrationTab.jsp?urlType=7	计划任务
			/integration/integrationTab.jsp?urlType=8	财务凭证
			/integration/icontent.jsp?showtype=12	流程触发集成
			/integration/icontent.jsp?showtype=10	流程流转集成
			/integration/integrationTab.jsp?urlType=10	数据展现集成
			/integration/integrationTab.jsp?urlType=18	IM集成设置
			/integration/integrationTab.jsp?urlType=27	WebSEAL集成设置
			/integration/integrationTab.jsp?urlType=28	CAS集成设置
		     /integration/integrationTab.jsp?urlType=100	流程归档集成
		     /integration/integrationTab.jsp?urlType=101	统一代办中心集成
			*/


		%>
		<%
		if(linkAddress.endsWith("urlType=3"))
		{
		%>
		<li style="background:url(images/a1_wev8.png) no-repeat center;background-color:#019AAC;" onclick="toSetting(1);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(32264,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("urlType=1"))
		{
		%>
		<li style="background:url(images/a12_wev8.png) no-repeat center;background-color:#2C84EE;" onclick="toSetting(17);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(33717,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("urlType=4"))
		{
		%>
		<li style="background:url(images/a4_wev8.png) no-repeat center;background-color:#009F00;" onclick="toSetting(10);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(33719,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("urlType=2"))
		{
		%>
		<li style="background:url(images/a3_wev8.png) no-repeat center;background-color:#BE1E4A;" onclick="toSetting(7);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(33718,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("urlType=6"))
		{
		%>
		<li style="background:url(images/a2_wev8.png) no-repeat center;background-color:#668100;" onclick="toSetting(4);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(20960,user.getLanguage())%></span></div></li>
		<!-- li style="background:url(images/a5_wev8.png) no-repeat;background-color:#92D050;" onclick="toSetting(12);"><div class="content">SAP集成</div></li -->
		<%
		}
		else if(linkAddress.endsWith("urlType=7"))
		{
		%>
		<li style="background:url(images/a7_wev8.png) no-repeat center;background-color:#0097AA;" onclick="toSetting(8);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(16539,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("urlType=8"))
		{
		%>
		<li style="background:url(images/a8_wev8.png) no-repeat center;background-color:#2C84EE;" onclick="toSetting(3);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(32265,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("showtype=12"))
		{
		%>
		<li style="background:url(images/a9_wev8.png) no-repeat center;background-color:#019AAC;" onclick="toSetting(2);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(33720,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("showtype=10"))
		{
		%>
		<li style="background:url(images/a10_wev8.png) no-repeat center;background-color:#633EBF;" onclick="toSetting(6);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(32338,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("urlType=10"))
		{
		%>
		<li style="background:url(images/a11_wev8.png) no-repeat center;background-color:#2C84EE;" onclick="toSetting(9);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(32303,user.getLanguage())%></span></div></li>
		<%
		}
		else if(linkAddress.endsWith("urlType=18"))
		{
		%>
		<li style="background:url(images/a18_wev8.png) no-repeat center;background-color:#668100;" onclick="toSetting(18);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(33387,user.getLanguage())%></span></div></li>
<%
        } else if (linkAddress.endsWith("urlType=28")) {
        %>
        <li style="background:url(images/a28_wev8.png) no-repeat center;background-color:#633EBF;"
            onclick="toSetting(28);">
            <div class="content"><span><%=SystemEnv.getHtmlLabelName(128653, user.getLanguage())%></span></div>
        </li>
		<%
		}
		else if(linkAddress.endsWith("urlType=100"))
		{
			//System.out.println("linkAddress==="+linkAddress);
		%>
        <li style="background:url(images/a100_wev8.png) no-repeat center;background-color:#2C84EE;" onclick="toSetting(100);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(83203,user.getLanguage())%></span></div></li>
		<%

		} else if(linkAddress.endsWith("urlType=28"))
        {
        //QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8
        %>
        <li style="background:url(images/a28_wev8.png) no-repeat center;background-color:#BE1E4A;" onclick="toSetting(28);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(128653,user.getLanguage())%></span></div></li>
        <%
        }
		else if(linkAddress.endsWith("urlType=101"))
		{
		%>
        <li style="background:url(images/a101_wev8.png) no-repeat center;background-color:#BE1E4A;" onclick="toSetting(101);"><div class="content"><span><%=SystemEnv.getHtmlLabelName(127357,user.getLanguage())%></span></div></li>

        <%
            } else {

                boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
                String customName = rs.getString("customName");
                String customName_e = rs.getString("customName_e");
                String customName_t = rs.getString("customName_t");

                boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true  : false;
                String infoCustomName = rs.getString("infoCustomName");
                String infoCustomName_e = rs.getString("infoCustomName_e");
                String infoCustomName_t = rs.getString("infoCustomName_t");
                String text = mu.getMenuText(lableid, useCustomName, customName, customName_e, customName_t, infoUseCustomName, infoCustomName, infoCustomName_e,infoCustomName_t,user.getLanguage());

        %>
        <li style="background:url(images/a8_wev8.png) no-repeat center;background-color:#2C84EE;"
            onclick="toUrl('<%=linkAddress%>');">
            <div class="content"><span><%=text%></span></div>
        </li>
		<%
		}
	}
	%>
		<!-- li style="background:url(images/a13_wev8.png) no-repeat center;background-color:#DA542E;"><div class="content"><span>ecology集成中心</span></div></li -->
	</ul>
</div>

</body>
</html>

<script language="javascript">
function toUrl(url){
    document.location = url;
}
function resetDiv()
{
	 var height = document.body.clientHeight;
	 //alert(document.getElementById("content").offsetHeight);
	 if(height>365)
	 {
	 	document.getElementById("content").style.top = (height-400)/2+"px";
	 }
}
function toSetting(type)
{
	var tourl = "";
	if("1"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=3";
	}
	else if("2"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=12";
	}
	else if("3"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=8";
	}
	else if("4"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=6";
	}
	else if("5"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=6&type=1";
	}
	else if("6"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=10";
	}
	else if("7"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=2";
	}
	else if("8"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=7";
	}
	else if("9"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=10";
	}
	else if("10"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=4";
	}
	else if("11"==type)
	{
		tourl = "http://www.baidu.com";
	}
	else if("12"==type)
	{
		tourl = "/integration/icontent.jsp?type=1&showtype=1";
	}
	else if("13"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=2&type=1";
	}
	else if("14"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=3&type=1";
	}
	else if("15"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=4&type=1";
	}
	else if("16"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=5&type=1";
	}
	else if("17"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=1";
	}
	else if("18"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=18";
	}
    else if ("28" == type) {
        tourl = "/integration/integrationTab.jsp?urlType=28";
    }
	else if("100"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=100";
	}
	else if("101"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=101";
//		QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8
	} else if("28"==type)
    {
        tourl = "/integration/integrationTab.jsp?urlType=28";
    }
	document.location = tourl;
}
</script>
<%!
    String visibility = "";

    private String isDisplay(boolean needRightToVisible,boolean needSwitchToVisible,String rightDetailToVisible,String switchMethodNameToVisible,int relatedModuleId,User user){
        visibility = "visible";
        //通过开关控制可见
        if(needSwitchToVisible){
            try {
                Class cls = Class.forName("weaver.systeminfo.menuconfig.MenuSwitch");
                //some error here, modify by xiaofeng
                Method meth = cls.getMethod(switchMethodNameToVisible,new Class[]{User.class });

                MenuSwitch methobj = new MenuSwitch();
                Object retobj = meth.invoke(methobj,new Object[]{user});
                Boolean retval = (Boolean) retobj;
                boolean switchToVisible = retval.booleanValue();
                //visible = visible&&switchToVisible;
                if(!switchToVisible)
                    visibility = "hidden";
            } catch (Throwable e) {
                System.err.println(e);
            }
        }
        //通过权限控制菜单可见
        if(needRightToVisible){
            ArrayList rightDetails = Util.TokenizerString(rightDetailToVisible,"&&");
            for(int a=0;a<rightDetails.size();a++){
                String rightDetail = (String)rightDetails.get(a);
                //visible = visible&&HrmUserVarify.checkUserRight(rightDetail,user);
                if(!HrmUserVarify.checkUserRight(rightDetail,user)){
                    break;
                }
            }
            visibility = "noright";
        }
        return visibility;
    }
%>