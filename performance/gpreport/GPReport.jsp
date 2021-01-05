<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<HTML>
    <HEAD>
        <title>考核执行分析</title>
				<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
				<LINK href="/workrelate/plan/css/report.css" type=text/css rel=STYLESHEET>
				<LINK href="/workrelate/css/showLoading.css" type=text/css rel=STYLESHEET>
				<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
				<script language="javascript" src="/workrelate/js/jquery.showLoading.js"></script>
				<script language="javascript" src="/workrelate/js/highcharts.js"></script>
				<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
				<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
				<%@ include file="/secondwev/common/head.jsp" %>
    </HEAD>
    <%
        int currYear = Calendar.getInstance().get(Calendar.YEAR);
        int currMonth = Calendar.getInstance().get(Calendar.MONTH)+1;
    %>
    <BODY>
        <div id="showImgContainer">
            <div id="showImgLeftContr" title="收起图表"></div>
            <div id="imgContainer"></div>
            <div id="showImgRightContr" title="查看图表"></div>
        </div>
        <div id="msg" class="msgcls">请先选择对比数据!</div> 
        <div class="dataconatiner">
        <div class="headerTb">
            <div class="tabbt" name="subOrg"><a>按组织</a></div>
            <div class="tabbt" id="tabworker" name="worker"><a>按人员</a></div>
        </div>
        <!-- 按分部查询条件 -->
        <div id="subSearchContent" style="width:99%;">
            <div style="width:100%;height:34px;border-bottom:1px #ECECEC solid;margin-bottom:10px;">
                <div id="yearpanel1" class="yearpanel" >&nbsp;&nbsp;&nbsp;<%=currYear %></div>
                <div class="tab tab_click">月份</div>
                <!-- 月列表 -->
                <div class="tab2_panel" id="monthList" style="width: 422px;">
                    <%for(int i=1;i<13;i++){ %>
                        <div class="tab2 <%=currMonth==i?"tab2_click":"" %>" _val="<%=i %>"><%=i %>月</div>
                    <%} %>
                </div>
                <div id="maintitle" class="maintitle"><%=currYear %>年第<%=currMonth %>月考核报表</div>
            </div>
        </div>
        <!-- 按分部查询条件 end -->
        <!-- 按人员查询条件 -->
        <div id="workerSearchContent" style="width:99%;display:none;">
            <div style="width:100%;height:34px;border-bottom:1px #ECECEC solid;margin-bottom:10px;">
                <div id="yearpanel2" class="yearpanel" >&nbsp;&nbsp;&nbsp;<%=currYear %></div>
                <div id="workerMaintitle" class="maintitle"><%=currYear %>年月度考核报表</div>
            </div>
            <div style="margin-bottom:10px;border:1px #ECECEC solid;">
                <table class="searchtable" cellpadding="0" cellspacing="0" border="0">
                    <colgroup>
                        <col width="7%"/>
                        <col width="18%"/>
                        <col width="7%"/>
                        <col width="30%"/>
                        <col width="7%"/>
                        <col width="30%"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td class="title">人员</td>
                            <td class="value">
                                <input class="wuiBrowser" type="hidden" id="hrmids" name="hrmids" value="" _required="no"
                                                    _displayTemplate="<a href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</a>" 
                                                    _displayText="" _param="resourceids" 
                                                    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
                            </td>
                            <td class="title">分部</td>
                            <td class="value">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <select id="cpyincludesub">
                                                <option value="3">含子分部</option>
                                                <option value="1">仅本分部</option>
                                                <option value="2">仅子分部</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input class="wuiBrowser" type="hidden" id="worker_subcompanyids" name="worker_subcompanyids" value=""
                                                _displayText="" 
                                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" _param="selectedids" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="title">部门</td>
                            <td>
                                <table style="float:left;height:30px;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <select id="deptincludesub">
                                                <option value="3">含子部门</option>
                                                <option value="1">仅本部门</option>
                                                <option value="2">仅子部门</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input class="wuiBrowser" type="hidden" id="worker_departmentids" name="worker_departmentids" value=""
                                                _displayText=""
                                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" _param="selectedids" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <div>
                                    <div class="btn1 btn" style="padding: 0px !important" title="搜索" onclick="searchWorker()">搜索</div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- 按人员查询条件  end-->
        <!-- 按组织查询展示框 -->
        <div id="subConpanyCont">
            <jsp:include page="SubCpyReport.jsp">
                <jsp:param value="<%=currYear %>" name="name"/>
                <jsp:param value="<%=currMonth %>" name="month"/>
            </jsp:include>
        </div>
        <!-- 按人员查询展示框 -->
        <div id="workerCont">
        </div>
        <!-- 年下拉框 -->
         <div id="yearselect" class="yearselect">
        <%  for(int i=2013;i<(2014+4);i++){ %>
                <div class="yearoption" _val="<%=i %>">&nbsp;&nbsp;&nbsp;<%=i %></div>
        <%  } %>
        </div>
        <input type="hidden" id="year" name="year" value="<%=currYear %>"/>
        <input type="hidden" id="month" name="month" value="<%=currMonth %>"/>
        <input type="hidden" id="workerYear" name="workerYear" value="<%=currYear %>"/>
        <input type="hidden" id="workerType" name="workerType" value="week"/>
        </div>
    </BODY>
    <script type="text/javascript">
        /**
         * 查询组织结构
         */
        function searchOrg(){
            var year=$("#year").val();
            var month=$("#month").val();
            var week=$("#week").val();
            var type=$("#type").val();
            //var subcompanyids=$("#org_subcompanyids").val();
            $("#subConpanyCont").html("");
            $("body").showLoading();
            $("#subConpanyCont").load("SubCpyReport.jsp",{
                "year":year,
                "month":month,
                "week":week,
                "type":type
            },function(){
                $("body").hideLoading();
                afterSearchOrg();
            });
        }
        /**
         * 查询组织结构
         */
        function loadSubDept(subCpyId){
            var newTr = $("<tr></tr>");
            var year=$("#year").val();
            var month=$("#month").val();
            var week=$("#week").val();
            var type=$("#type").val();
            var e = window.event;
            //获取元素
            var obj = e.target || e.srcElement;
            var curImg = $(obj);
            var curTd = curImg.parent("td");
            var curTr = curTd.parent("tr");
            var curCode = curTr.attr("curCode");
            var subCpyId = curTr.attr("subCpyId");
            var curtype = curTr.attr("curtype");
            curImg.attr("src","/workrelate/images/wrcontraction.png");
            //如果已经查询过下级部门则展示，否则查询
            var isOpened = curTr.attr("opened");
            if(isOpened == "no"){
                var level = curTd.attr("level");
                $("body").showLoading();
                newTr.load("SearchSubDept.jsp",{
                    "year":year,
                    "month":month,
                    "week":week,
                    "type":type,
                    "subCpyId":subCpyId,
                    "curCode":curCode,
                    "level":level,
                    "curtype":curtype
                },function(data){
                    curTr.after(newTr.html());
                    afterSearchOrg();
                    curImg.unbind("click");
                    curImg.bind("click",hideSubDept);
                    
                    $("div .watchdetail").bind("mouseover",function(){
                        $(this).addClass("watchdetailHover");
                    }).bind("mouseout",function(){
                        $(this).removeClass("watchdetailHover");
                    });
                    $("body").hideLoading();
                });
                curImg.attr("onclick", "");
                curTr.attr("opened","yes");
            }else{
                curImg.attr("onclick", "");
                curImg.unbind("click");
                curTr.nextAll("tr[curCode^="+curTr.attr("curCode")+"_]").show();
                curImg.bind("click",hideSubDept);
                afterSearchOrg();
            }
        }
        /**
         * 查询组织结构
         */
        function hideSubDept(){
            var curImg = $(this);
            curImg.unbind("click");
            curImg.attr("src","/workrelate/images/wropen.png");
            var curTr = curImg.parent("td").parent("tr");
            curTr.nextAll("tr[curCode^="+curTr.attr("curCode")+"_]").hide();
            curImg.bind("click",loadSubDept);
            afterSearchOrg();
        }
        /**
         * 查询人员报表
         */
        function searchWorker(){
            var year=$("#workerYear").val();
            var type=$("#workerType").val();
            var subcompanyids=$("#worker_subcompanyids").val();
            var departmentids=$("#worker_departmentids").val();
            var cpyincludesub=$("#cpyincludesub").val();
            var deptincludesub=$("#deptincludesub").val();
            var hrmids=""+$("#hrmids").val();
            var pagenum=$("#pagenum").val();
            
            $("#workerCont").html("");
            $("body").showLoading();
            $("#workerCont").load("WorkerReport.jsp",{
                "year":year,
                "type":type,
                "hrmids":hrmids,
                "subcompanyids":subcompanyids,
                "departmentids":departmentids,
                "cpyincludesub":cpyincludesub,
                "deptincludesub":deptincludesub,
                "pagenum":pagenum
            },function(){
                $("body").hideLoading();
            });
        }
        //设置查询类型样式
        $(".tabbt").click(function(){
            $(".tabbt").removeClass("tabbtFocs");
            $(".tabbt").bind("mouseover",function(){
                $(this).addClass("tabbtBlur");
            }).bind("mouseout",function(){
                $(this).removeClass("tabbtBlur");
            });
            $(this).addClass("tabbtFocs");
            if($(this).attr("name")=="subOrg"){
            	$("#showImgRightContr").css("visibility","visible");
                $("#workerSearchContent").hide();
                $("#subSearchContent").show();
                
                $("#workerCont").hide();
                $("#subConpanyCont").show();
            }else{
            	$("#showImgRightContr").css("visibility","hidden");
                $("#subSearchContent").hide();
                $("#workerSearchContent").show();
                if(!$(this).attr("isSearched")){
                    searchWorker();
                    //$("#workerCont").load("WorkerReport.jsp");
                    $(this).attr("isSearched","1");
                }
                $("#workerCont").show();
                $("#subConpanyCont").hide();
            }
        });
        $("div[name=subOrg]").click();
        
        
       //年添加点击事件
        $(".yearpanel").bind("click",function(){
            var _t = $(this).offset().top+$(this).height();
            var _l = $(this).offset().left;
            $("#yearselect").css({"top":_t,"left":_l}).show();
        });
        //改变年下拉框的值
        function changeYear(year){
            if(!$("#yearpanel1").is(":hidden")){
                $("#year").val(year);
                $("#yearpanel1").html("&nbsp;&nbsp;&nbsp;"+year);
                setMonthInfo();
                searchOrg();
            }else{
                $("#yearpanel2").html("&nbsp;&nbsp;&nbsp;"+year);
                $("#workerYear").val(year);
                setWorkerMonthInfo();
                searchWorker();
            }
        }
        //年下拉框事件
        $("div.yearoption").bind("mouseover",function(){
            $(this).addClass("yearoption_hover");
        }).bind("mouseout",function(){
            $(this).removeClass("yearoption_hover");
        }).bind("click",function(){
            var _val = $(this).attr("_val");
            changeYear(_val);
        });
        //隐藏年下拉框
        $(document).bind("click",function(e){
            var target=$.event.fix(e).target;
            if($(target).attr("id")!="yearpanel1" && $(target).attr("id")!="yearpanel2"){
                $("#yearselect").hide();
            }
        });
        //添加搜索按钮事件
        $(document).ready(function(){
            jQuery("div.btn").live("mouseover",function(){
                jQuery(this).addClass("btn_hover");
            }).live("mouseout",function(){
                jQuery(this).removeClass("btn_hover");
            });
        });
        //添加月份点击事件
        $(".tab2").click(function(){
            $(".tab2").removeClass("tab2_click");
            $(this).addClass("tab2_click");
            $("#month").val($(this).attr("_val"));
            setMonthInfo($(this).attr("_val"));
            searchOrg();
        });
        
        /**
         * 设置周展示信息
         */
        function setMonthInfo(){
            $("#maintitle").html($("#year").val()+"年第"+$("#month").val()+"月考核报表");
        }
        /**
         * 按人员查询设置周展示信息
         */
        function setWorkerMonthInfo(){
            $("#workerMaintitle").html($("#workerYear").val()+"年月度考核报表");
        }
        /**
         * 通过周找到周的日期
         */
        function weekDate(week){
            var tempdate = new Date(2014,0,(week-1)*7);
            var weekIndex = 7-tempdate.getDay();
            var startdate = new Date(2014,0,(week-1)*7 + weekIndex+1);
            var enddate = new Date(2014,0,week*7 + weekIndex);
            return formateDate(startdate) +" 至 "+ formateDate(enddate);
        }
        
        /**
         * 格式化日期
         */
        function formateDate(date){
            var year = date.getFullYear();
            var month = (date.getMonth()+1)>=10?(date.getMonth()+1):"0"+(date.getMonth()+1);
            var day = date.getDate()>=10?date.getDate():"0"+(date.getDate());
            return year + "-" + month + "-" + day ;;
        }
        /**
         * 设置表格样式
         */
        function setTableColor(){
            $("#listTable tbody tr").bind("mouseover",function(){
                $(this).css({"background":"#FAFAFA"});
            }).bind("mouseout",function(){
                $("#listTable tbody tr").css({"background":"#FFFFFF"});
            });
        }
        
        /**
         * 查看详情
         */
        function watchDetail(event){
            var e = event||window.event;
            var obj = e.target || e.srcElement;
            var curTr = $(obj).parent("td").parent("tr");
            var curtype = curTr.attr("curtype");
            //判断是查询分部还是部门
            if(curtype == "subcpy"){
                $("#worker_subcompanyids").val(curTr.attr("subCpyId"));
                $("#worker_departmentids").val("");
                $("#worker_subcompanyidsSpan").html(curTr.find("td:first").find("label").html());
                $("#worker_departmentidsSpan").html("");
            }else{
                $("#worker_departmentids").val(curTr.attr("subCpyId"));
                $("#worker_subcompanyids").val("");
                $("#worker_departmentidsSpan").html(curTr.find("td:first").find("label").html());
                $("#worker_subcompanyidsSpan").html("");
            }
            $("#cpyincludesub").val(3);
            $("#deptincludesub").val(3);
            $("#workerYear").val($("#year").val());
            $("#yearpanel2").html($("#yearpanel1").html());
            $("#weekTabBt").parent("div").find(".tab").removeClass("tab_click");
            
            $("#tabworker").attr("isSearched","");
            $("#tabworker").click();

        }
        function imgOver(th){
            var src = $(th).attr("src");
            src = src.substring(0,src.lastIndexOf(".")) +"_click"+ src.substring(src.lastIndexOf("."));
            $(th).attr("src",src);
        }
        function imgOut(th){
            var src = $(th).attr("src");
            if(src.lastIndexOf("_")>0){
                src = src.substring(0,src.lastIndexOf("_")) + src.substring(src.lastIndexOf("."));
                $(th).attr("src",src);
            }
        }
    </script>
    <script type="text/javascript">
	    $(document).ready(function(){
	        var rpwinWidth = $(window).width();
	        var rpwinHeight = $(window).height();
	        $("#showImgContainer").width(rpwinWidth+12);
	        $("#showImgContainer").height(rpwinHeight);
	        $("#showImgContainer").css({"left":(0-rpwinWidth)});
	        $("#imgContainer").width(rpwinWidth-12);
	        $("#showImgLeftContr").click(function(){
	            $("#showImgContainer").animate({"left":"-"+rpwinWidth},500,function(){
	                $('#imgContainer').html('');
	            });
	        });
	        $("#showImgRightContr").click(function(){
	            showCompareReport();
	        });
	        afterSearchOrg();
	    });
        /**
         * 展示图表
         */
        function showCompareReport(){
            var data = getDatas();
            if(data.length==0){
                return;
            }
            $("#showImgContainer").animate({"left":0},500,function(){
                showImg(data);
            });
        }
        /**
         * 得到数据
         */
        function getDatas(){
            var datas = new Array();
            var checkboxes = $("input:checkbox:checked").each(function(index){
                if(index>9){
                    return false;
                }
                var tr = $(this).parents("tr");
                var td = tr.find("td");
                var curData = new Array();
                for(var i=1;i<10;i++){
                    curData[i-1]=parseInt(td.eq(i).text());
                }
                datas[index] = {
                    name:tr.find("label").text(),
                    data:curData
                };
            });
            if(checkboxes.length==0){
                var _left = Math.round(($(window).width()-$("#msg").width())/2);
                $("#msg").css({"left":_left,"top":300}).show().animate({top:250},500,null,function(){
                    $(this).fadeOut(800);
                });
            }
            return datas;
        }
        /**
         * 展示图表
         */
        function showImg(data){
            $('#imgContainer').html('');
            datas = data;
            var categories = ['有方案','无方案','考核评分中','考核审批中','考核退回','已完成','过期评分中','过期审批中','过期退回'];
            $('#imgContainer').highcharts({                               
             chart: {type:"column"},                
             title: {text: ''},                
             xAxis: {categories: categories},
             yAxis: {
                 title: {
                     text: '人'
                 },
                 labels: {
                     formatter: function() {
                         return this.value
                     }
                 }
             },
             tooltip: {
                 headerFormat: '<table width="140px"><tr><td cspans="2" style="text-align:center;"><span style="font-size:12px">{point.key}</span></td></tr>',
                 pointFormat: '<tr>'+
                                  '<td style="color:{series.color};padding:0,width:100px">{series.name}: </td>' +
                                  '<td style="padding:0;width:40px;"><b>{point.y}</b></td>'+
                              '</tr>',
                 footerFormat: '</table>',
                 shared: true,
                 useHTML: true
             },               
             credits: {
                 enabled: false
             },
             series: datas               
         });          
        }
        function afterSearchOrg(){
            setTableColor();
            jQuery('body').jNice();
        }
    </script>
</HTML>