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
			<th>��ȣ</th>
			<th>UID</th>
			<th>�̸�</th>
			<th>�̸���</th>
			<th>������</th>
			<th>�׼�</th>
		</tr>
	</thead>
	<tbody>
	<c:forEach var="user" items=${userList}" varStrtus }
	</tbody>
</table>
</body>
</html>