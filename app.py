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


def get_kakao_api_key():
    try:
        with open('keys/카카오api.txt') as file:
            return file.read().strip()
    except FileNotFoundError:
        raise FileNotFoundError("카카오 API 키 파일을 찾을 수 없습니다.")
    except Exception as e:
        raise Exception(f"카카오 API 키를 읽는 중 오류 발생: {e}")


def get_lat_lng_from_address(address, api_key):
    try:
        base_url = 'https://dapi.kakao.com/v2/local/search/address.json'
        header = {'Authorization': f'KakaoAK {api_key}'}
        url = f'{base_url}?query={quote(address)}'
        result = requests.get(url, headers=header).json()
        return float(result['documents'][0]['y']), float(result['documents'][0]['x'])
    except Exception as e:
        raise Exception(f"주소에서 위도 경도를 가져오는 중 오류 발생: {e}")


def get_naver_place_url(lat, lng, market):
    return f'https://m.place.naver.com/place/list?x={lng}&y={lat}&query={market[0]} {market}'


def get_center_data(driver, center_list, i):
    center = center_list.select('li', recursive=False)[i]
    if center:
        c_distance_element = center.select_one('span.lWwyx.NVngW')
        c_distance = c_distance_element.get_text().split(
            '서')[1] if c_distance_element else 'N/A'
        c_title = center.select_one('span.YwYLL').get_text(
        ) if center.select_one('span.YwYLL') else 'N/A'
        try:
            juso_way = driver.find_elements(By.CLASS_NAME, 'uFxr1')
            juso_way[i].click()
            soup = BeautifulSoup(driver.page_source, 'html.parser')
            center_list = soup.find('ul', class_='eDFz9')
            if center_list.select_one('div.zZfO1'):
                c_addr = center_list.select_one(
                    'div.zZfO1').get_text().split('복사')[0][3:]
            else:
                c_addr = 'N/A'
            c_phone = center.select_one('span.JsCty > a').get(
                'href')[4:] if center.select_one('span.JsCty > a') else 'N/A'
            time.sleep(1)
        except:
            print('근처에 매장이 없습니다')
        return {
            '거리': c_distance,
            '매장명': c_title,
            '주소': c_addr,
            '전화번호': c_phone
        }
    else:
        print('센터 정보를 찾을 수 없습니다.')
        return None


@app.route('/')
def student():
    return render_template('selectAddr.html')


@app.route('/pbook', methods=['POST', 'GET'])
def result():
    if request.method == 'POST':
        val = request.form

    gu = val['gu']
    dong = val['dong']
    market = f'서울시 {gu} {dong}'

    try:
        kakao_key = get_kakao_api_key()
        lat, lng = get_lat_lng_from_address(market, kakao_key)
    except Exception as e:
        return render_template("error.html", error=f"위도 경도를 가져오는 중 오류 발생: {e}")

    options = webdriver.ChromeOptions()
    options.add_argument("headless")

    try:
        n_place_url = get_naver_place_url(lat, lng, market)
        driver = webdriver.Chrome(options=options)
        driver.get(n_place_url)
    except Exception as e:
        return render_template("error.html", error=f"Selenium을 통해 네이버 플레이스에 접근하는 중 오류 발생: {e}")

    try:
        filter = driver.find_element(
            By.XPATH, '//*[@id="_place_portal_root"]/div/a')
        filter.click()
        time.sleep(3)

        short_way = driver.find_element(
            By.XPATH, '//*[@id="_list_scroll_container"]/div/div/div[1]/div/div/div/span[2]/a')
        short_way.click()
        time.sleep(3)

        soup = BeautifulSoup(driver.page_source, 'html.parser')
        center_list = soup.find('ul', class_='eDFz9')
        results = []

        for i in range(5):
            center_data = get_center_data(driver, center_list, i)
            if center_data:
                results.append(center_data)
    except Exception as e:
        return render_template("error.html", error=f"매장 정보를 가져오는 중 오류 발생: {e}")
    finally:
        driver.quit()

    df = pd.DataFrame(results)

    try:
        lat_list, lng_list = [], []
        for i in df.index:
            url = f'https://dapi.kakao.com/v2/local/search/address.json?query={quote(df["주소"][i])}'
            result = requests.get(
                url, headers={'Authorization': f'KakaoAK {kakao_key}'}).json()
            lat_list.append(float(result['documents'][0]['y']))
            lng_list.append(float(result['documents'][0]['x']))
        df['위도'] = lat_list
        df['경도'] = lng_list
        df = df.astype({'위도': 'float', '경도': 'float'})
    except Exception as e:
        return render_template("error.html", error=f"매장 주소를 통해 위도 경도를 가져오는 중 오류 발생: {e}")

    try:
        map = folium.Map([df.위도.mean(), df.경도.mean()], zoom_start=13)
        for i in df.index:
            folium.Marker([df.위도[i], df.경도[i]],
                          tooltip=f'<strong>{df.매장명[i]}</strong><br>{df.주소[i]}<br>{df.전화번호[i]}').add_to(map)
        map.save('returnmap.html')
    except Exception as e:
        return render_template("error.html", error=f"Folium을 사용하여 지도를 생성하는 중 오류 발생: {e}")

    return render_template("pbook.html", result=val)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
