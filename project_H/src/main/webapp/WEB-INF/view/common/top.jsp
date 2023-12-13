<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
  <style>
    body {
        margin: 0;
        font-family: 'Arial', sans-serif;
        overflow: hidden;
    }

    #loading-screen {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: #ffffff;
        display: flex;
        justify-content: center;
        align-items: center;
        opacity: 1;
        transition: opacity 1s ease-in-out;
    }

    #content {
        opacity: 0;
        transition: opacity 1s ease-in-out;
    }

    .tooltip-light-pink .tooltip-inner {
        background-color: #FFD9EB; /* Light pink color for the background */
        color: #000; /* Text color */
    }

    .tooltip-light-pink .tooltip-arrow {
        border-bottom-color: #FFD9EB; /* Border color */
    }

    /* Remove focus outline for buttons */
    button {
        outline: none !important;
    }
  </style>
  <script>
    // Simulate a delay (e.g., loading resources) before revealing the content
    setTimeout(function() {
      var loadingScreen = document.getElementById('loading-screen');
      var content = document.getElementById('content');

      // Gradually fade out the loading screen
      loadingScreen.style.opacity = 0;

      // Gradually fade in the content
      content.style.opacity = 1;

      // After the animation is complete, hide the loading screen
      setTimeout(function() {
        loadingScreen.style.display = 'none';
      }, 1000); // 1000ms = 1s (duration of the CSS transition)
    }, 3000); // Simulated delay: 3000ms = 3s

    document.addEventListener('DOMContentLoaded', function () {
        // data-bs-toggle="tooltip" 속성을 가진 모든 엘리먼트에 대한 툴팁 초기화
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // 버튼 엘리먼트에 대한 툴팁 초기화
        var buttonTooltipTriggerList = [].slice.call(document.querySelectorAll('button[data-bs-toggle="tooltip"]'));
        var buttonTooltipList = buttonTooltipTriggerList.map(function (buttonTooltipTriggerEl) {
          var tooltip = new bootstrap.Tooltip(buttonTooltipTriggerEl);

          // 마우스가 버튼을 벗어날 때 툴팁을 숨기도록 이벤트 리스너 추가
          buttonTooltipTriggerEl.addEventListener('mouseleave', function () {
            tooltip.hide();
          });

          return tooltip;
        });
      });
  </script>
</head>
<body>
    <!-- 서서히 보여지는 화면 -->
    <div id="loading-screen">
      <h1>로그인 중입니다...</h1>
    </div>
    <div id="content">
    <!-- Your actual content goes here -->
    <nav class="navbar navbar-expand-sm bg-light navbar-light">
      <div class="container-fluid mw-3">
          <button class="nav-link btn btn-outline-secondary" title="테스트"
                    data-bs-custom-class="tooltip-light-pink" data-bs-target="#myModal" data-bs-toggle="tooltip" data-bs-placement="bottom">
              <i class="fas fa-edit"></i>
          </button>
        <ul class="navbar-nav ms-auto">
          <li class="nav-item me-3">
            <button class="nav-link btn btn-outline-secondary" title="일기 쓰기"
                    data-bs-custom-class="tooltip-light-pink" data-bs-target="#myModal" data-bs-toggle="tooltip" data-bs-placement="bottom">
              <i class="fas fa-edit"></i>
            </button>
          </li>
          <li class="nav-item me-3">
            <button class="nav-link btn btn-outline-secondary" title="캘린더 보기"
            data-bs-custom-class="tooltip-light-pink" data-bs-target="#myModal" data-bs-toggle="tooltip" data-bs-placement="bottom">
              <i class="fas fa-calendar"></i>
            </button>
          </li>
          <li class="nav-item me-3">
            <button class="nav-link btn btn-outline-secondary" title="내가 쓴 일기"
            data-bs-custom-class="tooltip-light-pink" data-bs-target="#myModal" data-bs-toggle="tooltip" data-bs-placement="bottom">
              <i class="fas fa-book"></i>
            </button>
          </li>
          <li class="nav-item me-3">
            <button class="nav-link btn btn-outline-secondary" title="게시판 이동"
            data-bs-custom-class="tooltip-light-pink" data-bs-target="#myModal" data-bs-toggle="tooltip" data-bs-placement="bottom">
              <i class="far fa-comments"></i>
            </button>
          <li class="nav-item me-3">
            <c:if test="${not empty sessUid}">
              <button class="nav-link btn btn-outline-secondary" title="로그아웃"
              data-bs-custom-class="tooltip-light-pink" data-bs-toggle="tooltip" data-bs-placement="bottom">
                <i class="fas fa-sign-out-alt"></i>
              </button>
            </c:if>
            <c:if test="${empty sessUid}">
              <button class="nav-link btn btn-outline-secondary" title="로그인"
              data-bs-custom-class="tooltip-light-pink" data-bs-toggle="tooltip" data-bs-placement="bottom">
                <i class="fas fa-sign-in-alt"></i>
              </button>
            </c:if>
          </li>
        </ul>
      </div>
    </nav>
	
	<!-- The Modal -->
	<div class="modal fade" id="myModal">
	  <div class="modal-dialog">
	    <div class="modal-content">
	
	      <!-- Modal Header -->
	      <div class="modal-header">
	        <h4 class="modal-title">Modal Heading</h4>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	
	      <!-- Modal body -->
	      <div class="modal-body">
	        Modal body..
	      </div>
	
	      <!-- Modal footer -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
	      </div>
	
	    </div>
	  </div>
	</div>
  </div>
</body>
</html>
