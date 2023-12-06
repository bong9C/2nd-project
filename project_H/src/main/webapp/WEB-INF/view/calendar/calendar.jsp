<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FullCalendar in JSP</title>

    <!-- Bootstrap CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>

    <!-- FullCalendar CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.4.0/main.css"/>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.4.0/main.js"></script>

    <style>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
        }

        #background {
            background: url('img/무지개.png') center center / cover no-repeat fixed;
            height: 100vh; /* 100% 뷰포트 높이를 사용하여 전체 화면을 채우도록 설정 */
            position: fixed;
            width: 100%;
            z-index: -1; /* FullCalendar 위에 나타나도록 설정 */
        }

        #calendar {
            border: 1px solid #ddd;
            padding: 10px;
            width: 70%;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.8); /* 배경에 흰색 투명도 추가 (선택적) */
            z-index: 1; /* FullCalendar는 배경 위에 나타나도록 설정 */
        }

        /* 변경된 스타일: 사이드바 */
        #sidebar {
            height: 100%;
            width: 0;
            position: fixed;
            z-index: 1;
            top: 0;
            left: 0;
            background-color: white; /* 배경색을 흰색으로 변경 */
            overflow-x: hidden;
            transition: 0.5s;
            padding-top: 60px;
            color: black;
        }

        #sidebar a {
            padding: 8px 8px 8px 32px;
            text-decoration: none;
            font-size: 18px;
            color: #818181;
            display: block;
            transition: 0.3s;
        }

        #sidebar a:hover {
            color: #f1f1f1;
        }

        #sidebar .closebtn {
            position: absolute;
            top: 0;
            right: 25px;
            font-size: 36px;
            margin-left: 50px;
        }
    </style>

    <script>
        // 내가 쓴 일기 페이지로 이동하는 함수
        function openDiaryPage() {
            // 여기에 일기 페이지로 이동하는 코드를 작성
            // 예: window.location.href = '/path/to/diary/page';
            alert("일기 페이지로 이동합니다.");
        }

        $(document).ready(function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                dateClick: function(info) {
                    console.log('Clicked on: ' + info.dateStr);
                    openModal(info.dateStr);
                }
            });

            calendar.render();

            function openModal(date) {
                $('#myModal').modal('show');
                
                $('#exampleModalLabel').text(date);
                $('#modalTitle').text('오늘의 컬러: ');
                $('#modalContent').text('오늘 가장 많이 쓴 단어: ');
                $('#modalContent2').text('오늘의 기분: ');
                $('#modalContent3').text('일간 분석 데이터');
                $('#modalContent4').text('월간 분석 데이터');
                $('#modalContent5').html('<a href="#" onclick="openDiaryPage()">내가 쓴 일기 보러 가기</a>');
            }

            /* 변경된 스크립트: 사이드바 토글 */
            $('#sidebarCollapse').on('click', function () {
                if ($('#sidebar').width() === 0) {
                    $('#sidebar').width(250);
                } else {
                    $('#sidebar').width(0);
                }
            });

            $('#sidebar .closebtn').on('click', function () {
                $('#sidebar').width(0);
            });
        });
    </script>
</head>
<body>
    <!-- 배경 이미지를 담당하는 추가된 요소 -->
    <div id="background"></div>

    <!-- 변경된 사이드바 버튼 및 구조 -->
    <div id="sidebar">
        <button type="button" class="closebtn" onclick="closeNav()">×</button>
        <a href="#">오늘의 일기</a>
        <a href="${pageContext.request.contextPath}/board/list/1">게시판</a>
        <a href="#">캘린더</a>
        <a href="#">지도</a>
    </div>

    <!-- 변경된 사이드바 토글 버튼 -->
    <button type="button" id="sidebarCollapse" class="btn btn-info">
        <i class="fas fa-align-left"></i>
        <span>눌러보세요</span>
    </button>

    <!-- Bootstrap Modal 예제 -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p id="modalTitle"></p>
                    <p id="modalContent"></p>
                    <p id="modalContent2"></p>
                    <p id="modalContent3"></p>
                    <p id="modalContent4"></p>
                    <p id="modalContent5"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- FullCalendar를 감싸는 추가된 요소 -->
    <div id='calendar'></div>

    <!-- Bootstrap Modal 예제 -->
    <div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel2" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel2"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p id="modalTitle2"></p>
                    <p id="modalContent2"></p>
                    <a href="${pageContext.request.contextPath}/home" id="modalContent3_2" onclick="openDiaryPage()">내가 쓴 일기 보러 가기</a>
                    <a href="${pageContext.request.contextPath}/home" id="modalContent4_2" onclick="openDiaryPage()">내가 쓴 일기 보러 가기</a>
                    <a href="${pageContext.request.contextPath}/home" id="modalContent5_2" onclick="openDiaryPage()">내가 쓴 일기 보러 가기</a>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 내가 쓴 일기 페이지로 이동하는 함수
        function openDiaryPage() {
            // 여기에 일기 페이지로 이동하는 코드를 작성
            // 예: window.location.href = '/path/to/diary/page';
            alert("일기 페이지로 이동합니다.");
        }

        $(document).ready(function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                dateClick: function(info) {
                    console.log('Clicked on: ' + info.dateStr);
                    openModal(info.dateStr);
                }
            });

            calendar.render();

            function openModal(date) {
                $('#myModal').modal('show');
                
                $('#exampleModalLabel').text(date);
                $('#modalTitle').text('오늘의 컬러: ');
                $('#modalContent').text('오늘 가장 많이 쓴 단어: ');
                $('#modalContent2').text('오늘의 기분: ');
                $('#modalContent3').html('<a href="${pageContext.request.contextPath}/home" onclick="openDiaryPage()">일간 분석 데이터</a>');
                $('#modalContent4').html('<a href="${pageContext.request.contextPath}/home" onclick="openDiaryPage()">월간 분석 데이터</a>');
                $('#modalContent5').html('<a href="${pageContext.request.contextPath}/home" onclick="openDiaryPage()">내가 쓴 일기 보러 가기</a>');
            }

            /* 변경된 스크립트: 사이드바 토글 */
            $('#sidebarCollapse').on('click', function () {
                if ($('#sidebar').width() === 0) {
                    $('#sidebar').width(250);
                } else {
                    $('#sidebar').width(0);
                }
            });

            $('#sidebar .closebtn').on('click', function () {
                $('#sidebar').width(0);
            });
        });
    </script>
</body>
</html>
