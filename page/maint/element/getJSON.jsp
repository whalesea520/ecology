
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String jsonStr = "{\"item\":[{\"name\":\"小米\",\"card\":\"432159734338545846\","
               	+"\"seattype\":\"硬座\",\"DepartureStation\":\"17:29\",\"ArrivalStation\":\"09:06\",\"Last\":\"14:23\"},"
               	+"{\"name\":\"胖墩\",\"card\":\"231958973433854156\","
               	+"\"seattype\":\"硬卧\",\"DepartureStation\":\"14:22\",\"ArrivalStation\":\"01:05\",\"Last\":\"11:17\"},"
               	+"{\"name\":\"皮蛋\",\"card\":\"427612734338545566\","
                +"\"seattype\":\"无座\",\"DepartureStation\":\"15:29\",\"ArrivalStation\":\"07:33\",\"Last\":\"13:56\"}]} ";
out.print(jsonStr);
%>