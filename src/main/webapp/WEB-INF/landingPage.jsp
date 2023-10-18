<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!-- Formatting (dates) --> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<!-- form:form -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- for rendering errors on PUT routes -->
<%@ page isErrorPage="true" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Bug Quack</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/css/landingPage.css">
</head>
<body>
	<div class="nav">
		<div class="title">
			<img src="/assets/bug.png" alt="" />
			<p>Bug Quack</p>
		</div>
		<div class="links">
			<a href="/auth">Sign In</a>
			<a href="/auth">Register</a>
		</div>
	</div>
	<div class="demoAccountLink">
		<a href="/demo">Demo Account</a>
	</div>
	<div class="landingPageImgs">
		<img class="landingPageImg1" src="/assets/landingPage1.png" alt="" />
		<img class="landingPageImg2" style="display:none;" src="/assets/landingPage2.png" alt="" />
		<img class="landingPageImg3" style="display:none;" src="/assets/landingPage3.png" alt="" />
	</div>
</body>
</html>