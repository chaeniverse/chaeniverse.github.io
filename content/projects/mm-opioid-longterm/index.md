---
title: "Long-term Opioid Use in Newly Diagnosed Multiple Myeloma"
date: 2026-05-04
summary: "신규 진단 다발골수종 환자에서 장기 오피오이드 사용의 양상과 예측 인자를 규명하는 전국 단위 후향적 코호트 연구. HIRA 빅데이터 3,621명 대상, 베이스라인 위험 점수 모형 개발. 1저자, 논문 작성 중."
tags:
  - Statistical Analysis
  - Big Data Analysis
  - Healthcare
tech_stack:
  - SQL
  - R
  - SAS
  - Logistic Regression
  - Risk Scoring
links: []
featured: true
status: "Manuscript in Preparation"
role: "1저자"
duration: "2025–2026 (ongoing)"
highlights:
  - "HIRA 전국 코호트 3,621명에서 신규 진단 MM 환자의 장기 오피오이드 사용 양상 분석"
  - "초기 오피오이드 강도가 가장 강한 예측 인자 (aOR 2.25–3.64, p<.001)"
  - "베이스라인 위험 점수 모형 개발 — 저/중/고위험군 stratification (장기 사용률 55.1% / 65.0% / 74.3%)"
  - "보수적 처방 환경에서도 약 2/3가 장기 사용으로 진행 — 조기 위험 기반 통증 관리 계획의 필요성 제시"
---

#### 개요

신규 진단(newly diagnosed) 다발골수종(multiple myeloma, MM) 환자가 오피오이드 진통제를 시작했을 때, 얼마나 자주 장기 사용으로 이어지는지, 어떤 베이스라인 인자가 이를 예측하는지를 규명하는 전국 단위 후향적 코호트 연구입니다.

#### 배경

다발골수종은 진단 시점에 70–80% 환자가 골 통증을 호소할 정도로 통증 부담이 큰 질환입니다. 오피오이드는 중등도 이상 통증의 표준 치료지만, 약 6개월 이상 사용하면 내성·의존·부작용 등으로 중단이 어려워집니다. 기존 연구는 주로 단일 기관 또는 서구 코호트 기반이며, 한국과 같이 엄격한 처방 환경에서의 인구 단위 근거는 제한적인 편입니다.

#### 데이터

- **출처**: 건강보험심사평가원(HIRA) 데이터베이스 — 한국 인구의 97% 이상 커버
- **포함 기준**: 2009.01.01 – 2023.08.31에 신규 MM으로 진단되고, 진단 후 3개월 이내 ≥ 14일 누적 오피오이드 처방을 받은 성인
- **추적**: 2024.08.31까지
- **분석 코호트**: **3,621명** (중위 연령 66.0세 [IQR 59.0–73.0], 여성 47.1%)

#### 노출 (Exposures)

진단 후 3개월 이내 오피오이드 강도를 다음 3군으로 분류 — equianalgesic dose ratio와 WHO analgesic ladder에 따라:

- Weak only
- Strong only
- Weak and strong

#### 결과 변수 (Outcome)

**장기 오피오이드 사용** — MM 진단 후 6개월을 초과해 처방이 지속된 경우.

#### 결과

전체 3,621명 중 **2,377명(65.6%)**이 장기 오피오이드 사용으로 진행했습니다. 강도가 높을수록 장기 사용 비율이 증가했습니다:

| 초기 강도 | n | 장기 사용률 |
|---|---|---|
| Weak only | 1,535 | 52.4% (804) |
| Strong only | 1,049 | 70.7% (742) |
| Weak and strong | 1,037 | 80.1% (831) |

(P < 0.001)

다변량 로지스틱 회귀에서 **오피오이드 강도가 가장 강한 예측 인자**였습니다:

- Strong only vs weak only: aOR **2.25** (95% CI, 1.90–2.66)
- Weak and strong vs weak only: aOR **3.64** (95% CI, 3.02–4.38)

이 외에도 고연령, 기분/수면 장애 동반, bortezomib 기반 치료, 사전 오피오이드 사용 등이 독립적 예측 인자였습니다.

#### 위험 점수 모형

베이스라인 인자들로 위험 점수 모형을 개발해 환자를 저/중/고위험군으로 분류했습니다. 군별 장기 사용률은 다음과 같습니다:

- 저위험: **55.1%**
- 중위험: **65.0%**
- 고위험: **74.3%**

#### 결론

전국 인구 단위 데이터로 본 결과, 신규 진단 MM 환자가 오피오이드를 시작하면 **약 2/3가 6개월 이상 장기 사용**으로 이어졌습니다. 보수적 처방 환경에서도 이 양상이 지속된다는 점은 **오피오이드 시작 시점에서의 위험 기반 통증 관리 계획**의 임상적 필요성을 보여줍니다.

#### 진행 상황

논문 작성 중 (Manuscript in Preparation, 1저자).

> Chaehyeon Lee, Suein Choi, Sung-Soo Park, "Patterns and Predictors of Long-term Opioid Use in Patients with Newly Diagnosed Multiple Myeloma: A Nationwide Real-world Study" (제출 준비 중).
