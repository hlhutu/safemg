<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="java.io.PrintStream,java.io.ByteArrayOutputStream"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="status" value="${pageContext.errorData.statusCode}" scope="page" />
<c:set var="status" value="${0 != status ? status : param.statusCode}" scope="page" />

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	$(window).ready(function() {
		$("title").html("消息页面");
		$(".a-login").on("click", function() {
			top.location.href = "${portal}/j_security_logout";
		});
	})
</script>
</head>
<body class="gray-bg">
	<div class="middle-box text-center animated fadeIn" style="max-width: 500px;">
		<h1>${status}</h1>
		<c:choose>
			<c:when test="${'400' == status}">
				<c:set var="title" value="请求出错！" scope="page" />
				<c:set var="msg" value="抱歉，语法格式有误，请联系管理员" scope="page" />
			</c:when>
			<c:when test="${'401' == status}">
				<c:set var="title" value="未被授权！" scope="page" />
				<c:set var="msg" value="抱歉，未被授权，请联系管理员" scope="page" />
			</c:when>
			<c:when test="${'403' == status}">
				<c:set var="title" value="禁止访问！" scope="page" />
				<c:set var="msg" value="抱歉，访问被拒绝，请联系管理员" scope="page" />
			</c:when>
			<c:when test="${'404' == status}">
				<c:set var="title" value="页面不存在！" scope="page" />
				<c:set var="msg" value="抱歉，页面不存在" scope="page" />
			</c:when>
			<c:when test="${'405' == status}">
				<c:set var="title" value="指定的请求方式！" scope="page" />
				<c:set var="msg" value="抱歉，请求方式错误" scope="page" />
			</c:when>
			<c:when test="${'500' == status}">
				<c:set var="title" value="服务器内部错误！" scope="page" />
				<c:set var="msg" value="抱歉，服务器内部错误，请联系管理员" scope="page" />
			</c:when>
			<c:otherwise>
				<c:set var="title" value="未知错误！" scope="page" />
				<c:set var="msg" value="抱歉，未知错误，请联系管理员" scope="page" />
			</c:otherwise>
		</c:choose>
		<h3 class="font-bold">${title}</h3>
		<div class="error-desc">
			${msg}，<a class="a-login">登录</a>、<a class="a-reload">刷新</a>或<a class="a-back">返回</a>
		</div>
		<h2>
			<textarea class="form-control" id="remark" rows="5">${requestScope['javax.servlet.error.message']}</textarea>
		</h2>
	</div>
</body>
</html>