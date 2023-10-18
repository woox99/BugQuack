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
<title>Bug Quack | Sign In</title>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/css/auth.css">
</head>
<body>
	<div class="nav">
		<div class="title">
			<img src="/assets/bug.png" alt="" />
			<p>Bug Quack</p>
		</div>
		<div class="links">
			<a href="/">Back</a>
		</div>
	</div>
	<div class="container">
		<div class="login card">
			<p class="orange">Sign In</p>
			<form:form action="/login" method="post" modelAttribute="loginUser">
				<div class="input">
					<p>Email</p>
					<div>
						<form:errors path="email"></form:errors>
					</div>
					<form:input type="email" path="email"/>
				</div>
				<div class="input">
					<p>Password</p>
					<div>
						<form:errors path="password"></form:errors>
					</div>
					<form:input type="password" path="password"/>
				</div>
				<button type="submit">Login</button>
				<p class="demo">Use a Demo Account <a href="/demo">here</a>.</p>
			</form:form>
		</div>
		<div class="register card">
			<p class="orange">Register</p>
			<form:form action="/register" method="post" modelAttribute="user">
				<div class="input">
					<p>First Name</p>
					<div>
						<form:errors path="firstName"></form:errors>
					</div>
					<form:input type="text" path="firstName"/>
				</div>
				<div class="input">
					<p>Last Name</p>
					<div>
						<form:errors path="lastName"></form:errors>
					</div>
					<form:input type="text" path="lastName"/>
				</div>
				<div class="input">
					<p>Email</p>
					<div>
						<form:errors path="email"></form:errors>
					</div>
					<form:input type="email" path="email"/>
				</div>
				<div class="input">
					<p>Password</p>
					<div>
						<form:errors path="password"></form:errors>
					</div>
					<form:input type="password" path="password"/>
				</div>
				<div class="input">
					<p>Confirm Password</p>
					<div>
						<form:errors path="confirm"></form:errors>
					</div>
					<form:input type="password" path="confirm"/>
				</div>
				<button type="submit">Register</button>
				<p class="demo">Use a Demo Account <a href="/demo">here</a>.</p>
			</form:form>
		</div>
	</div>

</body>
</html>