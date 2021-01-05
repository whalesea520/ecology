<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
</HEAD>
<body scroll="no">
<wea:layout type="fourCol">
     <wea:group context="常用条件" attributes="{'class':\"e8_title e8_title_1\",'samePair':'group01'}">
      <wea:item>标题</wea:item>
      <wea:item>
        <!-- 字段必填的标识,只控制后面感叹号的显示, -->
        <wea:required id="aaspan" required="true">
         <input type="text" name="aa" id="aa"/>
         </wea:required>
      </wea:item>
      <wea:item>编号</wea:item>
      <wea:item><input type="text" name="bb" id="bb" value="b"/></wea:item>
      <wea:item>创建日期</wea:item>
      <wea:item attributes="{\"colspan\":\"3\"}"><!-- 合并单元格,合并后面3列 -->
       <select class="inputStyle" name="ccc" id="ccc">
        <option value="">全部</option>
        <option value="1">今天</option>
        <option value="2">本周</option>
        <option value="3">本月</option>
       </select>
      </wea:item>
      <wea:item>批准日期</wea:item>
      <wea:item>
       <select name="ccc" id="ccc">
        <option value="">全部</option>
        <option value="1">今天</option>
        <option value="2">本周</option>
        <option value="3">本月</option>
       </select>
      </wea:item>
     </wea:group>
     <!-- groupDisplay 隐藏标题，itemAreaDisplay 隐藏group里面的所有的单元格 -->
     <wea:group context="查询条件2" attributes="{'class':\"e8_title e8_title_1\",'groupDisplay':'','itemAreaDisplay':'none'}">
          <wea:item>标题</wea:item>
          <wea:item>
            <!-- 字段必填的标识,只控制后面感叹号的显示,表单提交时还需要字段值进行控制 -->
            <wea:required id="aaspan" required="true">
             <input type="text" name="aa" id="aa"/>
             </wea:required>
          </wea:item>
          <wea:item>编号</wea:item>
          <wea:item><input type="text" name="bb" id="bb" value="b"/></wea:item>
          <wea:item>是否显示</wea:item>
          <wea:item attributes="{\"colspan\":\"3\"}"><!-- 合并单元格,合并后面3列 -->
           <select class="inputStyle" name="isshow" id="isshow" onchange="Onchange(this)">
            <option value="0">显示</option>
            <option value="1">不显示</option>
            <option value="2">常用条件不显示</option>
           </select>
          </wea:item>
          <wea:item attributes="{'samePair':'it001'}">批准日期</wea:item>
          <wea:item attributes="{'samePair':'it001'}">
           <select name="ccc" id="ccc">
            <option value="">全部</option>
            <option value="1">今天</option>
            <option value="2">本周</option>
            <option value="3">本月</option>
           </select>
          </wea:item>
		  <wea:item attributes="{'samePair':'it001'}"></wea:item>
		  <wea:item attributes="{'samePair':'it001'}"></wea:item>
		  <wea:item attributes="{'isTableList':'true'}">
		  <table class="ListStyle"><tr><td>A</td><td>A</td><td>A</td><td>A</td><td>A</td><td>A</td></tr><tr><td>A</td><td>A</td><td>A</td><td>A</td><td>A</td><td>A</td></tr><tr><td>A</td><td>A</td><td>A</td><td>A</td><td>A</td><td>A</td></tr></table>
		  </wea:item>
     </wea:group>
	 <wea:group context="常用条件" attributes="{'class':\"e8_title e8_title_1\",'samePair':'group01'}">
		 <wea:item type="thead">
		 显示数据toolbar
		 </wea:item>
		 <wea:item type="thead">
		 显示数据toolbar
		 </wea:item><wea:item type="thead">
		 显示数据toolbar
		 </wea:item><wea:item type="thead">
		 显示数据toolbar
		 </wea:item>
		 <wea:item>
		 a
		 </wea:item><wea:item>
		 a
		 </wea:item><wea:item>
		 a
		 </wea:item><wea:item>
		 a
		 </wea:item>
      </wea:group>
</wea:layout>
<script type="text/javascript">
function Onchange(obj){
		if(obj.value=="0"){
			showEle("it001","true");//显示指定属性的单元格
			showGroup("group01","true");//显示指定属性的group
		}else if(obj.value=="1"){
			hideEle("it001","true");//隐藏指定属性的单元格
		}else if(obj.value=="2"){
            hideGroup("group01","true");//隐藏指定属性的group
        }
}
</script>
 </body>
</html>
