-- Kim&Cho Family Türkiye Travel Guide
-- Supabase Dashboard → SQL Editor 에서 이 파일 전체를 한 번 실행하세요.

create extension if not exists pgcrypto;

create table if not exists public.food_items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  checked boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.places (
  id uuid primary key default gen_random_uuid(),
  region text not null,
  name text not null,
  type text not null default '식당',
  note text not null default '',
  link text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.packing_items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  checked boolean not null default false,
  created_at timestamptz not null default now()
);

-- RLS 활성화
alter table public.food_items enable row level security;
alter table public.places enable row level security;
alter table public.packing_items enable row level security;

-- 현재 여행 사이트는 "링크를 아는 가족끼리 로그인 없이 공동 편집" 모드입니다.
-- 즉, URL을 아는 사람은 누구나 이 세 테이블을 읽고/추가/수정/삭제할 수 있습니다.
-- 공개 링크로 널리 공유할 계획이라면 Supabase Auth 기반으로 변경하는 것을 권장합니다.

revoke all on table public.food_items, public.places, public.packing_items from anon, authenticated;
grant select, insert, update, delete on table public.food_items, public.places, public.packing_items to anon, authenticated;

drop policy if exists "family food read" on public.food_items;
drop policy if exists "family food insert" on public.food_items;
drop policy if exists "family food update" on public.food_items;
drop policy if exists "family food delete" on public.food_items;
create policy "family food read" on public.food_items for select to anon, authenticated using (true);
create policy "family food insert" on public.food_items for insert to anon, authenticated with check (true);
create policy "family food update" on public.food_items for update to anon, authenticated using (true) with check (true);
create policy "family food delete" on public.food_items for delete to anon, authenticated using (true);

drop policy if exists "family places read" on public.places;
drop policy if exists "family places insert" on public.places;
drop policy if exists "family places update" on public.places;
drop policy if exists "family places delete" on public.places;
create policy "family places read" on public.places for select to anon, authenticated using (true);
create policy "family places insert" on public.places for insert to anon, authenticated with check (true);
create policy "family places update" on public.places for update to anon, authenticated using (true) with check (true);
create policy "family places delete" on public.places for delete to anon, authenticated using (true);

drop policy if exists "family packing read" on public.packing_items;
drop policy if exists "family packing insert" on public.packing_items;
drop policy if exists "family packing update" on public.packing_items;
drop policy if exists "family packing delete" on public.packing_items;
create policy "family packing read" on public.packing_items for select to anon, authenticated using (true);
create policy "family packing insert" on public.packing_items for insert to anon, authenticated with check (true);
create policy "family packing update" on public.packing_items for update to anon, authenticated using (true) with check (true);
create policy "family packing delete" on public.packing_items for delete to anon, authenticated using (true);

-- 최초 기본 데이터 (테이블이 비어 있을 때만 삽입)
insert into public.food_items(name)
select x.name from (values
 ('현지식 아침 · 카흐발트'),('쾨프테'),('케밥'),('카이막'),('와인'),('바클라바'),('베이란'),('고등어케밥')
) as x(name)
where not exists (select 1 from public.food_items);

insert into public.places(region,name,type,note,link)
select * from (values
 ('newcity','고등어케밥','먹을 것','이스탄불 신시가지에서 먹어보기',''),
 ('newcity','바클라바','디저트','디저트 후보',''),
 ('asia','베이란','먹을 것','양고기국밥','')
) as x(region,name,type,note,link)
where not exists (select 1 from public.places);

insert into public.packing_items(name)
select x.name from (values ('마스크'),('스카프')) as x(name)
where not exists (select 1 from public.packing_items);

-- Realtime 사용을 위해 테이블을 publication에 추가.
-- 이미 추가돼 있으면 오류가 날 수 있으므로 아래 블록에서 안전하게 처리합니다.
do $$
begin
  begin alter publication supabase_realtime add table public.food_items; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.places; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.packing_items; exception when duplicate_object then null; end;
end $$;
