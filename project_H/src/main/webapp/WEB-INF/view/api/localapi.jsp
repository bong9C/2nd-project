<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>키워드로 상담센터 검색하기</title>
</head>
<body>
<div>
    <label for="keyword">상담센터 키워드:</label>
    <input type="text" id="keyword" />
    <button onclick="searchCounselingCenters()">검색</button>
</div>
<div id="map" style="width:100%;height:350px;"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=163531f559b3b1b15070b9932b6799e2&libraries=services"></script>
<script>
var infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });
var mapContainer = document.getElementById('map');
var mapOption = {
    center: new kakao.maps.LatLng(37.566826, 126.9786567),
    level: 3
};

var map = new kakao.maps.Map(mapContainer, mapOption);

function searchCounselingCenters() {
    var keyword = document.getElementById('keyword').value;

    var ps = new kakao.maps.services.Places();
    ps.keywordSearch(keyword + ' 상담센터', placesSearchCB);
}

function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
        var bounds = new kakao.maps.LatLngBounds();

        for (var i = 0; i < data.length; i++) {
            displayMarker(data[i]);
            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
        }

        map.setBounds(bounds);
    }
}

function displayMarker(place) {
    var marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(place.y, place.x)
    });

    kakao.maps.event.addListener(marker, 'click', function () {
        var content =
            '<div style="padding:5px;font-size:12px;">' +
            '<strong>' + place.place_name + '</strong><br>' +
            '전화번호: ' + place.phone + '<br>' +
            '위치: ' + place.address_name +
            '</div>';

        infowindow.setContent(content);
        infowindow.open(map, marker);
    });
}
</script>
</body>
</html>
