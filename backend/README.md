# Public Facility Backend

Spring Boot 기반 공공시설 안내 백엔드입니다.  
현재 방식은 **DB import가 아니라 실시간 공공데이터 조회**입니다.

## 실시간 데이터 소스
- TOILET: 행정안전부 공중화장실 Open API 실시간 호출
- WIFI: 행정안전부 무료와이파이 Open API 실시간 호출
- SHELTER: `src/main/resources/data/seoul_shelters.csv` 실시간 읽기

## 설정 (`application.yaml`)
- `public-data.toilet.service-key`: Decoding 인증키
- `public-data.wifi.service-key`: Decoding 인증키
- `public-data.shelter.csv-path`: `data/seoul_shelters.csv`

주의: GitHub 공개 시 실제 API 키를 커밋하지 마세요.

## 주요 API
- `GET /api/facilities`
- `GET /api/facilities/nearby`
- `GET /api/facilities/{facilityId}`
- `POST /api/favorites` (실시간 구조 권장)
- `GET /api/favorites`
- `DELETE /api/favorites/{facilityId}`

## Postman 테스트 순서
1. `GET /api/facilities?category=WIFI`
2. `GET /api/facilities?category=TOILET`
3. `GET /api/facilities?category=SHELTER`
4. `GET /api/facilities/nearby?lat=37.5665&lng=126.9780`
5. 로그인 후 `POST /api/favorites`
6. `GET /api/favorites`

## 실행
```powershell
.\gradlew.bat clean test
.\gradlew.bat bootRun
```
