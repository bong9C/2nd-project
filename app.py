from flask import Flask, render_template, request
import requests
import util.item_analysis as ui
from urllib.parse import quote
from selenium import webdriver
from selenium.webdriver.common.by import By
import time
from bs4 import BeautifulSoup
import pandas as pd
from tqdm import tqdm
import folium

app = Flask(__name__)


@app.route('/')
def student():
    return render_template('selectAddr.html')


@app.route('/pbook', methods=['POST', 'GET'])
def result():
    if request.method == 'POST':
        val = request.form

    gu = val['gu']
    dong = val['dong']

    market = '서울시 ' + str(gu) + ' ' + str(dong)

    options = webdriver.ChromeOptions()
    options.add_argument("headless")
    # 고객이 입력한 주소 좌표 구하기
    try:
        with open('keys/카카오api.txt') as file:
            kakao_key = file.read()

        base_url = 'https://dapi.kakao.com/v2/local/search/address.json'
        header = {'Authorization': f'KakaoAK {kakao_key}'}
        url = f'{base_url}?query={quote(market)}'
        result = requests.get(url, headers=header).json()
        lat = float(result['documents'][0]['y'])
        lng = float(result['documents'][0]['x'])
    except:
        print('주소 형식이 올바르지 않습니다.')

    results = []

    # 네이버 플레이스 셀레니움으로 들어가기
    n_place_url = f'https://m.place.naver.com/place/list?x={lng}&y={lat}&query={market[0]} {market}'
    driver = webdriver.Chrome(options=options)
    driver.get(n_place_url)

    # '목록보기' 클릭
    filter = driver.find_element(
        By.XPATH, '//*[@id="_place_portal_root"]/div/a')
    filter.click()
    time.sleep(3)

    # '거리순' 클릭
    short_way = driver.find_element(
        By.XPATH, '//*[@id="_list_scroll_container"]/div/div/div[1]/div/div/div/span[2]/a')
    short_way.click()
    time.sleep(3)

    # 마켓 정보 불러오기
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    center_list = soup.find('ul', class_='eDFz9')

    for i in range(5):
        if center_list:
            center = center_list.select('li', recursive=False)[i]

            if center:
                # 현재 위치에서 마켓 거리
                c_distance_element = center.select_one('span.lWwyx.NVngW')
                c_distance = c_distance_element.get_text().split(
                    '서')[1] if c_distance_element else 'N/A'

                # 센터 이름
                if center.select_one('span.YwYLL'):
                    c_title = center.select_one('span.YwYLL').get_text()
                else:
                    c_title = 'N/A'

                # '상세 주소 화살표' 클릭
                try:
                    juso_way = driver.find_elements(By.CLASS_NAME, 'uFxr1')
                    juso_way[i].click()
                    soup = BeautifulSoup(driver.page_source, 'html.parser')
                    center_list = soup.find('ul', class_='eDFz9')
                    # 센터 도로명 주소
                    if center_list.select_one('div.zZfO1'):
                        if center_list.select_one('div.zZfO1').get_text()[:2] == '도로':
                            c_addr = center_list.select_one(
                                'div.zZfO1').get_text().split('복사')[0][3:]
                        elif center_list.select_one('div.zZfO1').get_text()[:2] == '지번':
                            c_addr = center_list.select_one(
                                'div.zZfO1').get_text().split('복사')[1][2:]
                        else:
                            c_addr = center_list.select_one(
                                'div.zZfO1').get_text().split('복사')[1][2:]
                    else:
                        c_addr = 'N/A'

                    # 전화번호 추출
                    if center.select_one('span.JsCty > a'):
                        c_phone = center.select_one(
                            'span.JsCty > a').get('href')[4:]
                    else:
                        c_addr = 'N/A'

                    time.sleep(1)
                except:
                    print('근처에 매장이 없습니다')

                # 딕셔너리 형태로 저장
                center_data = {
                    '거리': c_distance,
                    '매장명': c_title,
                    '주소': c_addr,
                    '전화번호': c_phone
                }
                # 딕셔너리 형태로 저장한 것을 리스트에 저장 (3가지 마켓을 넣어야 하므로)
                results.append(center_data)

            else:
                print('센터 정보를 찾을 수 없습니다.')
        else:
            print('센터 리스트를 찾을 수 없습니다.')

    df = pd.DataFrame(results)

    base_url = 'https://dapi.kakao.com/v2/local/search/address.json'
    header = {'Authorization': f'KakaoAK {kakao_key}'}
    lat_list, lng_list = [], []

    for i in df.index:
        url = f'{base_url}?query={quote(df["주소"][i])}'
        result = requests.get(url, headers=header).json()
        lat_list.append(float(result['documents'][0]['y']))
        lng_list.append(float(result['documents'][0]['x']))

    df['위도'] = lat_list
    df['경도'] = lng_list
    df = df.astype({'위도': 'float', '경도': 'float'})

    map = folium.Map([df.위도.mean(), df.경도.mean()], zoom_start=13)
    for i in df.index:
        folium.Marker([df.위도[i], df.경도[i]],
                      tooltip=f'<strong>{df.매장명[i]}</strong><br>{df.주소[i]}<br>{df.전화번호[i]}').add_to(map)

    map.save('returnmap.html')
    return render_template("pbook.html", result=val)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)

ChatGPT
