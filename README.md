# Kim&Cho Family Türkiye Travel Guide

GitHub Pages + Supabase 공동 편집 버전입니다.

## 파일
- `index.html` : 메인 여행 일정
- `food.html` : 먹을 것 / 식당 / 카페 공동 리스트
- `packing.html` : 사전 준비물 공동 체크리스트
- `config.js` : Supabase URL / publishable key 입력
- `shared.js` : 공통 Supabase 연결 코드
- `supabase_setup.sql` : DB 테이블 / RLS / 기본 데이터 / Realtime 설정

## 1. Supabase 만들기
1. https://supabase.com 에서 새 Project 생성
2. Dashboard → SQL Editor
3. `supabase_setup.sql` 전체 내용을 붙여넣고 Run
4. Project Settings → API 에서 아래 두 값을 확인
   - Project URL
   - Publishable key (프로젝트에 따라 legacy anon key로 표시될 수 있음)

## 2. config.js 수정
`config.js`에서 아래 두 자리만 교체:

```js
window.TRIP_CONFIG = {
  SUPABASE_URL: "https://xxxxx.supabase.co",
  SUPABASE_KEY: "여기에 publishable 또는 anon key"
};
```

**service_role / secret key는 절대 브라우저 파일에 넣지 마세요.**

## 3. GitHub Pages
1. GitHub에서 새 repository 생성. 예: `turkiye-family-trip`
2. 이 폴더 안의 파일을 전부 repository 최상단에 업로드
3. Repository → Settings → Pages
4. Deploy from a branch
5. Branch `main`, folder `/ (root)` 선택 후 Save
6. 잠시 후 `https://사용자명.github.io/turkiye-family-trip/` 형태의 주소 생성

`index.html`이 자동으로 첫 화면이 됩니다.

## 공동 편집 방식
Supabase 설정 후에는:
- 한 사람이 식당을 추가 → 다른 가족 화면에도 공유
- 먹을 것 체크 → 가족 모두에게 동일하게 표시
- 준비물 체크/추가/삭제 → 가족 모두 동일
- Realtime 활성화 시 열어둔 화면도 자동 갱신

## 보안 주의
현재 SQL은 **로그인 없이 링크를 아는 사람이 모두 수정 가능한 가족용 간편 모드**입니다.
GitHub Pages 주소를 공개 게시하지 말고 가족끼리만 공유하세요.
공개 배포가 필요해지면 Supabase Auth 로그인 방식으로 바꾸는 것이 좋습니다.
