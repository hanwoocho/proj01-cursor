# Chat Cursor

Ruby on Rails 8 실시간 웹 채팅 애플리케이션 (PostgreSQL + Turbo Streams + Action Cable).

## 요구 사항

- Ruby 4.x
- PostgreSQL 14+
- Docker (다른 PC에서 서버로 실행할 때)

## 로컬 개발

```bash
cp .env.example .env
# .env 에 DB_PASSWORD 등 설정

bundle install
bundle exec rails db:prepare
bundle exec rails db:seed   # 선택: 테스트 계정
bundle exec rails server    # http://localhost:3001
```

## GitHub 업로드 전 확인

- `.env` 파일은 커밋하지 않음 (`.gitignore` 처리됨)
- `config/master.key` 도 커밋하지 않음
- DB 비밀번호는 `.env` 에만 저장

## Docker 배포 (앱: 다른 PC / DB: 현재 PC)

### 1. DB PC (PostgreSQL가 있는 PC) 설정

1. PostgreSQL 원격 접속 허용  
   - `postgresql.conf`: `listen_addresses = '*'`  
   - `pg_hba.conf`: Docker 서버 PC IP 추가  
     ```
     host  all  all  192.168.0.50/32  scram-sha-256
     ```
2. Windows 방화벽에서 **5432** 포트 허용
3. 추가 DB 생성 (Solid Cache/Queue/Cable용):

```bash
psql -U postgres -f db/setup_production_databases.sql
```

### 2. 앱 PC (Docker 서버) 설정

```bash
git clone <your-repo-url>
cd proj01-cursor
cp .env.example .env
```

`.env` 예시:

```env
DB_HOST=10.178.187.65          # DB PC의 LAN IP
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=chat-cursor
DB_CACHE_NAME=chat-cursor_cache
DB_QUEUE_NAME=chat-cursor_queue
DB_CABLE_NAME=chat-cursor_cable
RAILS_MASTER_KEY=<config/master.key 내용>
APP_HOST=192.168.0.20:3001    # 이 Docker PC IP:포트
ALLOWED_ORIGINS=http://192.168.0.20:3001
APP_PORT=3001
SOLID_QUEUE_IN_PUMA=true
```

### 3. 실행

```bash
docker compose up --build -d
docker compose logs -f web
```

브라우저: `http://<앱 PC IP>:3001`

### 4. 헬스 체크

```bash
curl http://localhost:3001/up
```

## 환경 변수

| 변수 | 설명 |
|------|------|
| `DB_HOST` | PostgreSQL 호스트 (Docker에서는 DB PC IP) |
| `DB_PASSWORD` | PostgreSQL 비밀번호 |
| `DB_NAME` | 메인 DB (기본: chat-cursor) |
| `DB_CACHE_NAME` | Solid Cache DB |
| `DB_QUEUE_NAME` | Solid Queue DB |
| `DB_CABLE_NAME` | Solid Cable DB |
| `RAILS_MASTER_KEY` | Rails credentials 키 |
| `APP_HOST` | 접속 호스트 (IP:포트) |
| `ALLOWED_ORIGINS` | Action Cable WebSocket 허용 origin |
| `APP_PORT` | Docker 호스트 포트 (기본 3001) |

## 문제 해결

- **DB 연결 실패**: DB PC 방화벽, `pg_hba.conf`, `.env`의 `DB_HOST` 확인
- **Blocked host**: `APP_HOST`에 접속하는 IP:포트와 일치하는지 확인
- **실시간 채팅 안 됨**: `ALLOWED_ORIGINS`에 브라우저 URL(`http://IP:포트`) 포함 여부 확인
- **마이그레이션 오류**: cache/queue/cable DB가 생성되었는지 확인

자세한 프로젝트 구조는 `프로젝트_구조_및_실행방법.txt` 참고.
