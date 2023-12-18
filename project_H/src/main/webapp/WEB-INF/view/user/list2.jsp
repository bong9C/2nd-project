<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
    <%@ include file="../common/head.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <style>
        body {
            background-image: url('/project_H/img/pa.jpg');
            background-size: cover;
        }

        th, td {
            text-align: center;
        }

        .disabled-link {
            pointer-events: none;
        }
        .custom-margin {
            margin-top: 6cm;
        }
        
       
	    .custom-table input {
        width: 256px; /* 입력 필드 폭을 대략적으로 10cm로 지정 (1cm ≈ 25.6px) */
   		 }
        
	    .center-container {
	        text-align: center;
	    }
	
	    body, html {
	        height: 100%;
	        margin: 0;
	        justify-content: center;
	        align-items: center;
	    }
\
    </style>
    <script>
        function updateFunc(custId) {
            console.log('updateFunc() called');
            
            // AJAX 요청은 이 함수 내에서 수행되도록 이동
            $.ajax({
                type: 'GET',
                url: '/project_H/user/update/' + custId,
                success: function(result) {
                    let user = JSON.parse(result);
                    $('#custId').val(user.custId);
                    $('#uname').val(user.uname);
                    $('#email').val(user.email);
                    $('#updateModal').modal('show');
                }
            });
        }

        function deleteFunc(custId) {
            console.log('deleteFunc() called');
            $('#delUid').val(custId);
            $('#deleteModal').modal('show');
        }
    </script>
</head>
<body>
    <%@ include file="../common/top.jsp" %>
    <div class="container text-center custom-margin">
        <div class="row justify-content-center"> 
		 	<div class="col-3"></div>
            <!-- ================ Main =================== -->
            <div class="col-9"> <!-- </div> 닫는 테그는 폼 바깥에 두기. -->
            <input type="hidden" id="delUid">
            <!-- 사용자 수정 테이블 -->
		    <form action="/project_H/user/update" method="post">
		        <table class="table table-borderless custom-table">
				     <tr>
			        <td><label class="col-form-label">사용자 ID</label></td>
			        <td><input type="text" id="custId" class="form-control" value="<%= session.getAttribute("sessCustId") %>" disabled></td>
			    </tr>
		            <tr>
		                <td><label class="col-form-label">패스워드</label></td>
		                <td><input type="password" name="pwd" class="form-control"></td>
		            </tr>
		            <tr>
		                <td><label class="col-form-label">패스워드 확인</label></td>
		                <td><input type="password" name="pwd2" class="form-control"></td>
		            </tr>
		            <tr>
		                <td><label class="col-form-label">이름</label></td>
		                <td><input type="text" name="uname" id="uname" class="form-control"></td>
		            </tr>
		            <tr>
		                <td><label class="col-form-label">이메일</label></td>
		                <td><input type="text" name="email" id="email" class="form-control"></td>
		            </tr>
		        </table>
					<div style="text-align: center;">
					    <input class="btn btn-primary" type="submit" value="수정">
					    <input class="btn btn-secondary ms-1" type="reset" value="취소">
					</div>
		    </form>
		    </div>
            <!-- ================ Main =================== -->
        </div>
    </div>
</body>
</html>
