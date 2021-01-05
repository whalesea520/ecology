<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<HTML>
    <HEAD>
        <title>报告报表</title>
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
        int currWeek = Calendar.getInstance().get(Calendar.WEEK_OF_YEAR)-1;
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
                <div class="tab tab_click" onclick="doWeekChange()">周报</div>
                <div class="tab" onclick="doMonthChange()">月报</div>
                <!-- 月列表 -->
                <div class="tab2_panel" id="monthList" style="width: 422px;display:none;">
                    <%for(int i=1;i<13;i++){ %>
                        <div class="tab2 <%=currMonth==i?"tab2_click":"" %>" _val="<%=i %>"><%=i %>月</div>
                    <%} %>
                </div>
                <!-- 周选择器 -->
                <div class="tab2_panel" id="weekList" style="width: 261px;">
                    <div class="week_btn1 week_prev" onclick="weekPre()" title="上一周" ></div>
                    <div id="weekpanel" class="week_txt">第<%=currWeek %>周</div>
                    <div class="week_btn2 week_next" onclick="weekNext()" title="下一周" ></div>
                    <div class="week_show"></div>
                </div>
                <div id="weektag" style="width: 20px;line-height: 26px;float: left;">
                -
                </div>
                <div class="tab2_panel" id="weekList2" style="width: 261px;">
                    <div class="week_btn1 week_prev" onclick="weekPre2()" title="上一周" ></div>
                    <div id="weekpanel2" class="week_txt">第<%=currWeek %>周</div>
                    <div class="week_btn2 week_next" onclick="weekNext2()" title="下一周" ></div>
                    <div class="week_show2"></div>
                </div>
                <div id="maintitle" class="maintitle"><%=currYear %>年<%=currWeek %>周工作计划报告</div>
                
                <div style="float:right;width: auto;height: 26px;margin-top: 3px;margin-right: 5px;">
                	<div class="btn1 btn" style="padding:0px !important;" title="导出" onclick="doExport(1)">导出</div>
                </div>
            </div>
        </div>
        <!-- 按分部查询条件 end -->
        <!-- 按人员查询条件 -->
        <div id="workerSearchContent" style="width:99%;display:none;">
            <div style="width:100%;height:34px;border-bottom:1px #ECECEC solid;margin-bottom:10px;">
                <div id="yearpanel2" class="yearpanel" >&nbsp;&nbsp;&nbsp;2014</div>
                <div id="weekTabBt" class="tab tab_click" onclick="doWorkerWeekChange()">周报</div>
                <div id="monthTabBt" class="tab" onclick="doWorkerMonthChange()">月报</div>
                <div id="workerMaintitle" class="maintitle">2014年月度考核结果统计</div>
            </div>
            <div style="margin-bottom:10px;border:1px #ECECEC solid;">
                <table class="searchtable" cellpadding="0" cellspacing="0" border="0">
                    <colgroup>
                        <col width="7%"/>
                        <col width="18%"/>
                        <col width="7%"/>
                        <col width="25%"/>
                        <col width="7%"/>
                        <col width="25%"/>
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
                                <div style="float:right;width: auto;height: 26px;margin-top: 3px;margin-right: 5px;">
                                    <div class="btn1 btn" style="padding:0px !important;float: left;" title="搜索" onclick="searchWorker()">搜索</div>
                                    
                                    <div class="btn1 btn" style="padding:0px !important;float: left;" title="导出" onclick="doExport(2)">导出</div>
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
                <jsp:param value="<%=currWeek %>" name="week"/>
                <jsp:param value="<%=currYear %>" name="year"/>
                <jsp:param value="week" name="type"/>
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
        <!-- 周下拉框 -->
        <div id="weekselect" class="weekselect">
        <%
            for(int i=1;i<=TimeUtil.getMaxWeekNumOfYear(currYear);i++){
        %>
            <div class="weekoption<%if(currWeek==i){ %> weekoption_current<%} %>"  style="cursor:pointer;" _val="<%=i %>">第<%=i %>周</div>
        <%  } %> 
        </div>
        <!-- 周下拉框 -->
        <div id="weekselect2" class="weekselect">
        <%
            for(int i=1;i<=TimeUtil.getMaxWeekNumOfYear(currYear);i++){
        %>
            <div class="weekoption2<%if(currWeek==i){ %> weekoption_current<%} %>"  style="cursor:pointer;" _val="<%=i %>">第<%=i %>周</div>
        <%  } %> 
        </div>
        <input type="hidden" id="year" name="year" value="<%=currYear %>"/>
        <input type="hidden" id="month" name="month" value="<%=currMonth %>"/>
        <input type="hidden" id="week" name="week" value="<%=currWeek %>"/>
        <input type="hidden" id="week2" name="week2" value="<%=currWeek %>"/>
        <input type="hidden" id="type" name="type" value="week"/>
        <input type="hidden" id="workerYear" name="workerYear" value="<%=currYear %>"/>
        <input type="hidden" id="workerType" name="workerType" value="week"/>
        </div>
        
        <iframe id="searchexport" style="display:none"></iframe>
    </BODY>
    <script type="text/javascript">
        /**
         * 查询组织结构
         */
        function searchOrg(){
        	var year=$("#year").val();
            var month=$("#month").val();
            var week=$("#week").val();
            var week2=$("#week2").val();
            if(parseInt(week2)<parseInt(week)){
            	week2 = week;
            	$("#weekpanel2").html("第"+week2+"周");
            	$("#week2").val(week2);
            	setWeekInfo();
            	$(".week_show2").html(weekDate(week2));
            }
            var type=$("#type").val();
            //var subcompanyids=$("#org_subcompanyids").val();
            $("#subConpanyCont").html("");
            $("body").showLoading();
            $("#subConpanyCont").load("SubCpyReport.jsp",{
                "year":year,
                "month":month,
                "week":week,
                "week2":week2,
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
            var week2=$("#week2").val();
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
                    "week2":week2,
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
        /**
         * 切换为周报查询
         */
        function doWeekChange(){
        	setWeekInfo($("#week").val());
        	$("#monthList").hide();
            $("#weekList").show();
            $("#weekList2").show();
            $("#weektag").show();
            $("#type").val("week");
        }

        /**
         * 切换为月报查询
         */
        function doMonthChange(){
        	setMonthInfo($("#month").val());
        	$("#monthList").show();
        	$("#weekList").hide();
        	$("#weekList2").hide();
        	$("#weektag").hide();
        	$("#type").val("month");
        }
        /**
         * 按人员查询切换为周报查询
         */
        function doWorkerWeekChange(){
            setWorkerWeekInfo();
            $("#workerType").val("week");
            searchWorker();
        }
        /**
         * 按人员查询切换为月报查询
         */
        function doWorkerMonthChange(){
        	setWorkerMonthInfo();
            $("#workerType").val("month");
            searchWorker();
        }
        //设置查询类型样式
        $(".tabbt").click(function(){
        	$(".tabbt").removeClass("tabbtFocs");
//         	$(".tabbt").bind("mouseover",function(){
//                 $(this).addClass("tabbtBlur");
//             }).bind("mouseout",function(){
//                 $(this).removeClass("tabbtBlur");
//             });
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
	            if($("#type").val()=="week"){
	                setWeekInfo();
	                $(".week_show").html(weekDate($("#week").val()));
	                $(".week_show2").html(weekDate($("#week2").val()));
	            }else{
	                setMonthInfo();
	            }
	            searchOrg();
        	}else{
	            $("#yearpanel2").html("&nbsp;&nbsp;&nbsp;"+year);
	            $("#workerYear").val(year);
	            if($("#workerType").val()=="week"){
	                setWorkerWeekInfo();
	                $(".week_show").html(weekDate($("#week").val()));
	                $(".week_show2").html(weekDate($("#week2").val()));
	            }else{
	            	setWorkerYearInfo();
	            }
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
            if($(target).attr("id")!="monthpanel"){
                $("#monthselect").hide();
            }
            if($(target).attr("id")!="weekpanel"){
                $("#weekselect").hide();
            }
            if($(target).attr("id")!="weekpanel2"){
                $("#weekselect2").hide();
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
        //添加周月点击事件
        $(".tab").click(function(){
        	$(this).parent("div").find(".tab").removeClass("tab_click");
            $(this).addClass("tab_click");
            searchOrg();
        });
        //添加月份点击事件
        $(".tab2").click(function(){
            $(".tab2").removeClass("tab2_click");
            $(this).addClass("tab2_click");
            $("#month").val($(this).attr("_val"));
            setMonthInfo($(this).attr("_val"));
            searchOrg();
        });
        
        $("div.weekoption").bind("mouseover",function(){
            $(this).addClass("weekoption_hover");
        }).bind("mouseout",function(){
            $(this).removeClass("weekoption_hover");
        });
        $("div.weekoption2").bind("mouseover",function(){
            $(this).addClass("weekoption_hover");
        }).bind("mouseout",function(){
            $(this).removeClass("weekoption_hover");
        });
        $("div.week_prev").bind("mouseover",function(){
            $(this).addClass("week_prev_hover");
        }).bind("mouseout",function(){
            $(this).removeClass("week_prev_hover");
        });
        $("div.week_next").bind("mouseover",function(){
            $(this).addClass("week_next_hover");
        }).bind("mouseout",function(){
            $(this).removeClass("week_next_hover");
        });
        $("#monthpanel").bind("click",function(){
            var _t = $(this).offset().top+$(this).height();
            var _l = $(this).offset().left-17;
            $("#monthselect").css({"top":_t,"left":_l}).show();
        });
        $("#weekpanel").bind("click",function(){
            var _t = $(this).offset().top+$(this).height();
            var _l = $(this).offset().left-17;
            $("#weekselect").css({"top":_t,"left":_l}).show();
        });
        $("#weekpanel2").bind("click",function(){
            var _t = $(this).offset().top+$(this).height();
            var _l = $(this).offset().left-17;
            $("#weekselect2").css({"top":_t,"left":_l}).show();
        });
        //选择周
        $(".weekoption").bind("click",function(){
        	$("#weekpanel").html($(this).html());
        	$("#week").val($(this).attr("_val"));
        	setWeekInfo($(this).attr("_val"));
        	$(".week_show").html(weekDate($(this).attr("_val")));
        	searchOrg();
        });
      	//选择周
        $(".weekoption2").bind("click",function(){
        	$("#weekpanel2").html($(this).html());
        	$("#week2").val($(this).attr("_val"));
        	setWeekInfo($(this).attr("_val"));
        	$(".week_show2").html(weekDate($(this).attr("_val")));
        	searchOrg();
        });
        /**
         * 上一周操作
         */
        function weekPre(){
        	var curWeek = parseInt($("#week").val());
        	if(curWeek>1){
	        	$("#week").val(curWeek-1);
	        	setWeekInfo(curWeek-1);
	        	$("#weekpanel").html("第"+(curWeek-1)+"周");
	        	$(".week_show").html(weekDate(curWeek-1));
	        	searchOrg();
        	}
        }
        /**
         * 下一周操作
         */
        function weekNext(){
        	var curWeek = parseInt($("#week").val());
        	if(curWeek<52){
	            $("#week").val(curWeek+1);
	            setWeekInfo(curWeek+1);
	            $("#weekpanel").html("第"+(curWeek+1)+"周");
	            $(".week_show").html(weekDate(curWeek+1));
	            searchOrg();
        	}
        }
        /**
         * 上一周操作
         */
        function weekPre2(){
        	var curWeek = parseInt($("#week2").val());
        	if(curWeek>1){
	        	$("#week2").val(curWeek-1);
	        	setWeekInfo(curWeek-1);
	        	$("#weekpanel2").html("第"+(curWeek-1)+"周");
	        	$(".week_show2").html(weekDate(curWeek-1));
	        	searchOrg();
        	}
        }
        /**
         * 下一周操作
         */
        function weekNext2(){
        	var curWeek = parseInt($("#week2").val());
        	if(curWeek<52){
	            $("#week2").val(curWeek+1);
	            setWeekInfo(curWeek+1);
	            $("#weekpanel2").html("第"+(curWeek+1)+"周");
	            $(".week_show2").html(weekDate(curWeek+1));
	            searchOrg();
        	}
        }
        /**
         * 设置周展示信息
         */
        function setWeekInfo(){
        	var week = $("#week").val();
        	var week2 = $("#week2").val();
            $("#maintitle").html($("#year").val()+"年第"+$("#week").val()+"周"+(week==week2?"":"至"+week2+"周")+"工作计划报告");
        }
        /**
         * 设置周展示信息
         */
        function setMonthInfo(){
            $("#maintitle").html($("#year").val()+"年第"+$("#month").val()+"月工作计划报告");
        }
        /**
         * 按人员查询设置周展示信息
         */
        function setWorkerWeekInfo(){
            $("#workerMaintitle").html($("#workerYear").val()+"年周工作计划报告");
        }
        /**
         * 按人员查询设置周展示信息
         */
        function setWorkerMonthInfo(){
            $("#workerMaintitle").html($("#workerYear").val()+"年月工作计划报告");
        }
        /**
         * 通过周找到周的日期
         */
        function weekDate(week){
        	var year = $("#year").val();
        	var tempdate = new Date(year,0,(week-1)*7);
            var weekIndex = 7-tempdate.getDay();
            var startdate = new Date(year,0,(week-1)*7 + weekIndex+1);
            var enddate = new Date(year,0,week*7 + weekIndex);
            return formateDate(startdate) +" 至 "+ formateDate(enddate);
        }
        
        /**
         * 格式化日期
         */
        function formateDate(date){
            var year = date.getFullYear();
            var month = (date.getMonth()+1)>=10?(date.getMonth()+1):"0"+(date.getMonth()+1);
            var day = date.getDate()>=10?date.getDate():"0"+(date.getDate());
            return year + "-" + month + "-" + day ;
        }
        $(document).ready(function(){
        	$(".week_show,.week_show2").html(weekDate(<%=currWeek%>));
        });
        
        /**
         * 设置表格样式
         */
        function setTableColor(){
            //$("#listTable tbody tr:odd").css({"background":"#ECECEC"});
            $("#listTable tbody tr").bind("mouseover",function(){
                $(this).css({"background":"#FAFAFA"});
            }).bind("mouseout",function(){
                //$("#listTable tbody tr:odd").css({"background":"#ECECEC"});
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
        	if($("#type").val() == "month"){
        		$("#monthTabBt").addClass("tab_click");
        		doWorkerMonthChange();
        	}else{
        		$("#weekTabBt").addClass("tab_click");
        		doWorkerWeekChange();
        	}
        	
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


            jQuery("#searchexport").load(function(){hideLoad();});
        });
        
        function hideLoad(){
        	$("body").hideLoading();
        }
        
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
        	var categories = ['需提交','未提交','处理草稿','处理审批中','处理退回','已完成','过期草稿','过期审批中','过期退回'];
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
        
      	//导出excel
		function doExport(stype){
			$("body").showLoading();
      		if(stype==1){
      			var year=$("#year").val();
                var month=$("#month").val();
                var week=$("#week").val();
                var week2=$("#week2").val();
                var type=$("#type").val();
      			jQuery("#searchexport").attr("src","SubCpyExport.jsp?year="+year+"&month="+month+"&week="+week+"&week2="+week2+"&type="+type);
      		}else{
      			var year=$("#workerYear").val();
                var type=$("#workerType").val();
                var subcompanyids=$("#worker_subcompanyids").val();
                var departmentids=$("#worker_departmentids").val();
                var cpyincludesub=$("#cpyincludesub").val();
                var deptincludesub=$("#deptincludesub").val();
            	var hrmids=""+$("#hrmids").val();
            	var pagenum=$("#pagenum").val();
      			jQuery("#searchexport").attr("src","WorkerExport.jsp?year="+year+"&subcompanyids="+subcompanyids+"&departmentids="+departmentids
      					+"&cpyincludesub="+cpyincludesub+"&deptincludesub="+deptincludesub+"&type="+type+"&hrmids="+hrmids+"&type="+type);
      		}
			
		}
    </script>
</HTML>