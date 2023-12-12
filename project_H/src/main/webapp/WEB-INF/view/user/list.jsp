<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<table class="table table-borderless table-striped">
	<thead>
		<tr>
			<th>번호</th>
			<th>UID</th>
			<th>이름</th>
			<th>이메일</th>
			<th>가입일</th>
			<th>액션</th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="user" items=${userList}" varStrtus }
	</tbody>
</table>
</body>
</html>