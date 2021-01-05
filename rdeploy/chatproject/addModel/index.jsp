<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";



/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}


RecordSet rs = new RecordSet();

int fslf = Util.getIntValue(request.getParameter("fslf"), -1);
if (fslf == 1) {
    rs.executeSql("delete from user_model_config where userid=" + user.getUID());
    String[] modelids = request.getParameterValues("modelid");
    for (int i=0; i<modelids.length; i++) {
        rs.executeSql("insert into user_model_config(userid, modelid, orderindex) values (" + user.getUID() + ", " + modelids[i] + ", " + i + ")");
    }
    //session.setAttribute("frommodel", "addModel");
}


Map<String, Map<String, String>> models = new HashMap<String, Map<String, String>>();
List<String> modellist = new ArrayList<String>();
rs.executeSql("select * from system_model_base");
while (rs.next()) {
    Map<String, String> bean = new HashMap<String, String>();
    bean.put("id", rs.getString("id"));
    bean.put("name", Util.null2String(rs.getString("modelname")));
    bean.put("desc", Util.null2String(rs.getString("modeldesc")));
    bean.put("detaildesc", Util.null2String(rs.getString("modeldetaildesc")));
    bean.put("icosrc", Util.null2String(rs.getString("modelicosrc")));
    bean.put("mgrpage", Util.null2String(rs.getString("mgrpage")));
    String sicosrc = "";
    String sicosltsrc = "";
    String modelid = Util.null2String(rs.getString("id"));
    switch (Util.getIntValue(modelid)) {
    case 1:
        sicosrc = "/rdeploy/assets/img/cproj/task.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/task_slt.png";
        break;
    case 2:
        sicosrc = "/rdeploy/assets/img/cproj/workflow.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/workflow_slt.png";
        break;
    case 3:
        sicosrc = "/rdeploy/assets/img/cproj/doc.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/doc_slt.png";
        break;
    case 4:
        sicosrc = "/rdeploy/assets/img/cproj/bing.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/bing_slt.png";
        break;
    case 5:
        sicosrc = "/rdeploy/assets/img/cproj/custom.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/custom_slt.png";
        break;
    case 6:
        sicosrc = "/rdeploy/assets/img/cproj/schedule.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/schedule_slt.png";
        break;
    case 7:
        sicosrc = "/rdeploy/assets/img/cproj/log.png";
        sicosltsrc = "/rdeploy/assets/img/cproj/log_slt.png";
        break;
    default:
    }
    
    bean.put("ico", sicosrc);
    bean.put("icoslt", sicosltsrc);
    
    models.put(rs.getString("id"), bean);
    modellist.add(rs.getString("id"));
}
List<String> usemodellist = new ArrayList<String>();
String sql = "select modelid from user_model_config where userid=" + user.getUID();
rs.executeSql(sql);
while (rs.next()) {
    usemodellist.add(rs.getString(1));
}
if (usemodellist.size() == 0) {
    usemodellist.add("1");
}
%>

<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/common.css">
    <script type="text/javascript" src="/page/element/imgSlide/resource/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
    <link href="/page/element/imgSlide/resource/js/jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
    <LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
    <script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
    <link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
    <style>
    .itemsplitline {
        height:1px!important;background:#e4e4e4;
    }
    
    .item {
        width:100%;position:relative;
        background:#fff;
    }
    
    .itemico {
        padding:0 18px;
    }
    .itembtnblock {
        position:absolute;right:0px;top:30px;display:none;
    }
    
    .itemdetaildesc {
        background:#f4f7f9;border-top:1px solid #e4e4e4;border-bottom:1px solid #e4e4e4;padding:15px 86px; 
    }
    .movebtn {
         display:inline-block;
         width:15px;height:15px;
         background:url('/page/element/imgSlide/resource/image/move.png') 0 0 no-repeat;
         cursor:pointer;
     }
     
     .movebtn:hover {
         background:url('/page/element/imgSlide/resource/image/move_slt.png') 0 0 no-repeat;
     }
     .itemborder {
        border-bottom:1px solid #e4e4e4;
     }
     
     .itemborder0 {
        border-bottom:0px solid #e4e4e4;
     }
     
     .btn-add {
        float:right;
        margin-right:16px;
     }
     
     .iteminfoblock {
        display:none;
     }
     .inrsplitline-dis {
        background:#e4e4e4;
     }
     
     .inrsplitline-dis0 {
        background:none!important;
     }
     
     .inrsplitline {
        height:1px!important; margin:0 20px;
     }
     
     .arrowsclass {
        position:absolute;left:90px;top:-10px;background:url('/rdeploy/assets/img/cproj/arrows.png') 0 0 no-repeat;width:13px;height:13px;
     }
     
     .itemdetailblock {
        position:relative;
     }
    </style>
    
    <script>
    
    $(function () {
        <%=fslf == 1 ? "$('#navblock', parent.parent.window.document).html($('#navblock').html())" : "" %>
        
        <%
        if (fslf == 1) { 
             Map<String, String> bean = null;
             
                 if (usemodellist.indexOf("3") != -1) {
                     %>
                     $("#docli", parent.parent.window.document).show();
                     <%
                 } else {
                     %>
                     $("#docli", parent.parent.window.document).hide();
                     if ($("#searchtype", parent.parent.window.document).val() == "1") {
                        $("#searchtype", parent.parent.window.document).val("2");
                        $("#searchDesc", parent.parent.window.document).html("人员");
                     }
                     <%
                 }
                 if (usemodellist.indexOf("2") != -1) {
                     %>
                     $("#wfli", parent.parent.window.document).show();
                     <%
                 } else {
                     %>
                     $("#wfli", parent.parent.window.document).hide();
                     if ($("#searchtype", parent.parent.window.document).val() == "5") {
                        $("#searchtype", parent.parent.window.document).val("2");
                        $("#searchDesc", parent.parent.window.document).html("人员");
                     }
                     <%
                 }
                 
                 if (usemodellist.indexOf("5") != -1) {
                     %>
                     $("#ctmli", parent.parent.window.document).show();
                     <%
                 } else {
                     %>
                     $("#ctmli", parent.parent.window.document).hide();
                     if ($("#searchtype", parent.parent.window.document).val() == "3") {
                        $("#searchtype", parent.parent.window.document).val("2");
                        $("#searchDesc", parent.parent.window.document).html("人员");
                     }
                     <%
                 }
        }
         %>
        
        $("#content").on("mouseenter", ".item", function () {
            $(this).find(".itembtnblock").show();
        }).on("mouseleave", ".item", function () {
            $(this).find(".itembtnblock").hide();
        });
        $("#content, #content2").on("click", ".item", function () {
            $(this).parent().children().not($(this)).find(".itemdetailblock").hide();
            $(this).parent().children().not($(this)).find(".inrsplitline").removeClass("inrsplitline-dis0");
            $(this).find(".itemdetailblock").toggle();
            //if ($(this).hasClass("itemborder")) {
            $(this).find(".inrsplitline").toggleClass("inrsplitline-dis0");
            //}
            
            //$(this).next("div.itemsplitline").toggle();
            //$(this).hasClass("")
        });
        
        $("#content, #content2").on("click", ".itembtnblock, .itemdetaildesc", function () {
            return false;
        });
        
        //添加应用
        $("#content2").on("click", ".btn-add", function () {
            var itemobj = $(this).closest(".item");
            var addobj = $("#template-1").children().clone();
            addobj.find(".itemico img").attr("src", itemobj.find(".itemico img").attr("src"));
            addobj.find(".size14").html(itemobj.find(".size14").html());
            addobj.find(".color-2").html(itemobj.find(".color-2").html());
            addobj.find(".itemdetaildesc").html(itemobj.find(".itemdetaildesc").html());
            addobj.find("input[name=modelid]").val(itemobj.find("input[name=modelid]").val());
            
            var mrgpageval = itemobj.find("input[name=mgrpage]").val();
            addobj.find("input[name=mgrpage]").val(mrgpageval);
            if (mrgpageval == '' || !!!mrgpageval) {
                addobj.find(".btn-mgr").hide();
            }
            
            $("#content .item").find(".inrsplitline").addClass("inrsplitline-dis");
            $("#content").append(addobj);
            $(itemobj).remove();
            /*
            if ($("#content2 .item").length == 0) {
                $("#content2").html("无可添加应用");
            }
            */
            var itemcount = $("#content2 .item").length;
            $("#content2 .item").each(function (i, e) {
                if (i < itemcount - 1) {
                    //$(this).addClass("itemborder"); 
                    $(this).find(".inrsplitline").addClass("inrsplitline-dis");
                } else {
                    //$(this).removeClass("itemborder");
                    $(this).find(".inrsplitline").removeClass("inrsplitline-dis");
                }
            });
            save();
            return false;
        });
        
        //删除应用
        $("#content").on("click", ".btn-del", function () {
            var itemobj = $(this).closest(".item");
            var addobj = $("#template-2").children().clone();
            addobj.find(".itemico img").attr("src", itemobj.find(".itemico img").attr("src"));
            addobj.find(".size14").html(itemobj.find(".size14").html());
            addobj.find(".color-2").html(itemobj.find(".color-2").html());
            addobj.find(".itemdetaildesc").html(itemobj.find(".itemdetaildesc").html());
            
            //$("#content2 .item").addClass("itemborder");
            $("#content2 .item").find(".inrsplitline").addClass("inrsplitline-dis");
            $("#content2").append(addobj);
            $(itemobj).remove();
            
            var itemcount = $("#content .item").length;
            $("#content .item").each(function (i, e) {
                if (i < itemcount - 1) {
                    //$(this).addClass("itemborder"); 
                    $(this).find(".inrsplitline").addClass("inrsplitline-dis");
                } else {
                    //$(this).removeClass("itemborder");
                    $(this).find(".inrsplitline").removeClass("inrsplitline-dis");
                }
            });
            
            save();
            return false;
        });
        
        
        $("#content").sortable({
            revert: true,
            axis: "y",
            handle: ".movebtn",
            stop : function () {
                var itemcount = $("#content .item").length;
                $("#content .item").each(function (i, e) {
                    if (i < itemcount - 1) {
                        //$(this).addClass("itemborder"); 
                        $(this).find(".inrsplitline").addClass("inrsplitline-dis");
                    } else {
                        //$(this).removeClass("itemborder");
                        $(this).find(".inrsplitline").removeClass("inrsplitline-dis");
                    }
                });
                save();
            }
        });
        
        
        $("#saveappbtn").on("click", function () {
            $("#mainform").submit();
        });
        
        //弹出设置界面
            $("#content").on("click",  ".btn-mgr",  function () {
                var mgrpage = $(this).closest(".item").find("input[name=mgrpage]").val();
                var dialog = new window.top.Dialog();
                dialog.currentWindow = window;
                dialog.URL = mgrpage;
                dialog.Title = "管理";
                dialog.maxiumnable = true;
                dialog.Width = window.top.window.document.body.offsetWidth*0.9 ;
                dialog.Height = window.top.window.document.body.offsetHeight*0.8 ;;
                dialog.callbackfun = function (paramobj, id1) {
                };
                dialog.Drag = true;
                dialog.show();
            });
    });
    
    function save() {
        $("#mainform").submit();
    }
    </script>
  </head>
  
  <body>
    <div class="width100 title-h40 title-bg">
      <span class="padding-left-18">已添加应用</span>
      <div style="float:right;padding-right:18px;">
       <!-- 
        <span class="btn-base btn-border-radius btn-bg-blue" id="saveappbtn">
          保&nbsp;存
         </span>
       -->
      </div>
    </div>
    
    <form action="/rdeploy/chatproject/addModel/index.jsp" method="post" id="mainform" target="targetframe">
    <input type="hidden" name="fslf" value="1">
    <div id="content">
    
    <%
    for (int i=0; i<usemodellist.size(); i++) {
        String modelid = usemodellist.get(i);
        Map<String, String> bean = models.get(modelid);
        modellist.remove(modellist.indexOf(modelid));
        
        String mgrpage = bean.get("mgrpage");
        
        String bbdstr = "";
        if (i < usemodellist.size() - 1) {
            bbdstr = "inrsplitline-dis";
        }
    %>
      <!-- item -->
      <div class="item">
        
        <input type="hidden" name="modelid" value="<%=modelid %>">
        <input type="hidden" name="mgrpage" value="<%=mgrpage %>">
        
        <div class="itembtnblock">
          <%
          if (!"".equals(mgrpage)) {
          %>
          <span class="btn-base btn-border-radius btn-bg-gray margin-left-18 btn-mgr">管&nbsp;理</span>
          <%
          }
          if (!modelid.equals("1")) {
          %>
          <span class="btn-base btn-border-radius btn-bg-gray margin-left-18 btn-del">删&nbsp;除</span>
          <%
          }
          %>
          <span class="movebtn margin-left-18 margin-right-18" title="移动"></span>
        </div>
        <table width="100%" height="76px" cellpadding="0" cellspacing="0">
          <colgroup><col width="86px"><col width="*"></colgroup>
          <tr>
            <td class="itemico">
              <img src="<%=bean.get("icosrc") %>" width="50px" height="50px">
            </td>
            <td>
                <div class="margin-top--4">
                    <span class="size14">
                      <%=bean.get("name") %>
                    </span>
                    <div class="h5"></div>
                    <span class="color-2">
                      <%=bean.get("desc") %>
                    </span>
                </div>
            </td>
          </tr>
        </table>
        <div class="itemdetailblock" style="display:none;">
          <div class="arrowsclass"></div>
          <div class="itemdetaildesc">
             <%=bean.get("detaildesc") %>
          </div>
        </div>
        
        <div class="inrsplitline <%=bbdstr %>" style=""></div>
        
      </div>
    <%
    }
    %>
    </div>
    </form>
    
    <div class="width100 title-h40 title-bg">
      <span class="padding-left-18">可添加应用</span>
    </div>
    
    <div id="content2">
    
      
      
      <%
      
      for (int i=0; i<modellist.size(); i++) {
          String modelid = modellist.get(i);
          Map<String, String> bean = models.get(modelid);
          String mgrpage = bean.get("mgrpage");
          String bbdstr = "";
          if (i < modellist.size() - 1) {
              bbdstr = "inrsplitline-dis";
          }
      %>
      
      <!-- item -->
      <div class="item">
        <input type="hidden" name="modelid" value="<%=modelid %>">
        <input type="hidden" name="mgrpage" value="<%=mgrpage %>">
        <table width="100%" height="76px" cellpadding="0" cellspacing="0">
          <colgroup><col width="86px"><col width="*"><col width="100px"></colgroup>
          <tr>
            <td class="itemico">
              <img src="<%=bean.get("icosrc") %>" width="50px" height="50px">
            </td>
            <td>
                <div class="margin-top--4">
                    <span class="size14">
                        <%=bean.get("name") %>
                    </span>
                    <div class="h5"></div>
                    <span class="color-2">
                        <%=bean.get("desc") %>
                    </span>
                </div>
            </td>
            <td>
                <span class="btn-add btn-base btn-border-radius margin-left-18 btn-bd-gray">添加</span>
            </td>
          </tr>
        </table>
        <div class="itemdetailblock" style="display:none;">
          <div class="arrowsclass"></div>
          <div class="itemdetaildesc">
                <%=bean.get("detaildesc") %>
          </div>
        </div>
        <div class="inrsplitline <%=bbdstr %>" style=""></div>
      </div>
      <%
      }
      %>
    </div>
    
    
    
    
    
    
    
    <div id="template-1" style="display:none;">
      <!-- item -->
      <div class="item">
        <input type="hidden" name="modelid" value="">
        <input type="hidden" name="mgrpage" value="">
        <div class="itembtnblock">
          <span class="btn-base btn-border-radius btn-bg-gray margin-left-18 btn-mgr">管&nbsp;理</span>
          <span class="btn-base btn-border-radius btn-bg-gray margin-left-18 btn-del">删&nbsp;除</span>
          <span class="movebtn margin-left-18 margin-right-18" title="移动"></span>
        </div>
        <table width="100%" height="76px" cellpadding="0" cellspacing="0">
          <colgroup><col width="86px"><col width="*"></colgroup>
          <tr>
            <td class="itemico">
              <img src="" width="50px" height="50px">
            </td>
            <td>
                <div class="margin-top--4">
                    <span class="size14">
                    </span>
                    <div class="h5"></div>
                    <span class="color-2">
                    </span>
                </div>
            </td>
          </tr>
        </table>
        <div class="itemdetailblock" style="display:none;">
          <div class="arrowsclass"></div>
          <div class="itemdetaildesc">
          </div>
        </div>
        <div class="inrsplitline" style=""></div>
      </div>
    </div>
    
    
    
    <div id="template-2" style="display:none;">
      <!-- item -->
      <div class="item">
        <input type="hidden" name="modelid" value="">
        <input type="hidden" name="mgrpage" value="">
        <table width="100%" height="76px" cellpadding="0" cellspacing="0">
          <colgroup><col width="86px"><col width="*"><col width="100px"></colgroup>
          <tr>
            <td class="itemico">
              <img src="" width="50px" height="50px">
            </td>
            <td>
                <div class="margin-top--4">
                    <span class="size14">
                    </span>
                    <div class="h5"></div>
                    <span class="color-2">
                    </span>
                </div>
            </td>
            <td>
                <span class="btn-add btn-base btn-border-radius margin-left-18 btn-bd-gray">添加</span>
            </td>
          </tr>
        </table>
        <div class="itemdetailblock" style="display:none;">
          <div class="arrowsclass"></div>
          <div class="itemdetaildesc">
          </div>
        </div>
        <div class="inrsplitline" style=""></div>
      </div>
    </div>
    
    <div style="display:none;">
        <iframe name="targetframe"></iframe>
        <!-- 左侧 -->
	      <div class="navblock" id="navblock">
	        <ul>
	          <li style="height:95px;">
	            <div style="height:16px;">
	            </div>
	            <div style="display:table-cell;vertical-align:middle;height:34px;width:112px;text-align:center;">
	                <img src="<%=ResourceComInfo.getMessagerUrls(user.getUID() + "") %>" height="34px" width="34px" style="border-radius:20px;">
	            </div>
	            <div style="height:10px;">
	            </div>
	            <div style="height:25px;text-align:center;lline-height:25px;">
	                <%=user.getLastname() %><%=user.getUID() == 1 ?  "" : (PortalUtil.isAdmin(user) ? "（管理员）":"")%>
	            </div>
	            <div style="height:10px;">
	            </div>
	          </li>
	          <li>
	            <a href="javascript:void 0;"  class="">
	              <input type="hidden" name="model" value="message">
	              <span class="nav-text-spacing "></span>
	              <img src="/rdeploy/assets/img/cproj/msg.png"  style="">
	              <img src="/rdeploy/assets/img/cproj/msg_slt.png" style="display:none;">
	              <span class="nav-text-spacing-center"></span>
	                消息
	            </a>
	          </li>
	          <li class="">
	          <a href="javascript:void 0;">
	            <input type="hidden" name="model" value="addrbook">
	            <span class="nav-text-spacing "></span>
	            <img src="/rdeploy/assets/img/cproj/addrbook.png">
	            <img src="/rdeploy/assets/img/cproj/addrbook_slt.png" style="display:none;">
	            <span class="nav-text-spacing-center"></span>
	              通讯录
	           </a>
	          </li>
	          <li class="">
	          <%
	          for (int i=0; i<usemodellist.size(); i++) {
	              String modelid = usemodellist.get(i);
	              Map<String, String> bean = models.get(modelid);
	              
	              boolean islast = false;
	              
	          %>
	          <a href="javascript:void 0;">
	            <input type="hidden" name="model" value="<%=modelid %>">
	            <span class="nav-text-spacing "></span>
	            <img src="<%=bean.get("ico") %>">
	            <img src="<%=bean.get("icoslt") %>" style="display:none;">
	            <span class="nav-text-spacing-center"></span>
	              <%=bean.get("name") %>
	           </a>
	          </li>
	          
	          <%
	              if (i < usemodellist.size() - 1) {
	                  %>
	                  
	          <li class="">
	                  
	                  <%
	              }
	          }
	          %>
	            
	            
	            
	            
	          
	          <li>
	            <div style="height:1px!important;background-color:#ced3d4;margin:0 10px;">
	            </div>
	          </li>
	          
	          <li class="">
	            <a href="javascript:void 0;" class="selected">
	            <input type="hidden" name="model" value="editmodel">
	            <span class="nav-text-spacing "></span>
	            <img src="/rdeploy/assets/img/cproj/addmdl.png">
	            <img src="/rdeploy/assets/img/cproj/addmdl_slt.png" style="display:none;">
	            <span class="nav-text-spacing-center"></span>
	                添加
	            </a>
	          </li>
	        </ul>
	      </div>
        
    </div>
  </body>
</html>
