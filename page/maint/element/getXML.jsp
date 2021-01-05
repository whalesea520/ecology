<?xml version="1.0" encoding="UTF-8"?>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String xmlStr = "<root><item>"
				+"<name>路飞</name>"
				+"<card>432159734338545846</card>"
				+"<seattype>硬座</seattype>"
				+"<DepartureStation>17:29</DepartureStation>"
				+"<ArrivalStation>09:06</ArrivalStation>"
				+"<Last>14:23</Last>"
				+"</item>"
				+"<item>"
				+"<name>佐罗</name>"
				+"<card>231958973433854156</card>"
				+"<seattype>硬卧</seattype>"
				+"<DepartureStation>14:22</DepartureStation>"
				+"<ArrivalStation>11:17</ArrivalStation>"
				+"<Last>14:23</Last>"
				+"</item>"
				+"<item>"
				+"<name>香吉士</name>"
				+"<card>432159734338545846</card>"
				+"<seattype>无座</seattype>"
				+"<DepartureStation>15:29</DepartureStation>"
				+"<ArrivalStation>07:33</ArrivalStation>"
				+"<Last>13:56</Last>"
				+"</item></root>";
out.print(xmlStr);
%>