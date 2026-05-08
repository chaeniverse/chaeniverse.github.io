---
title: "Improved Survival in Multiple Myeloma with Early Precursor Detection"
date: 2025-10-01
summary: "다발골수종(MM) 환자에서 전구 질환의 사전 진단 여부에 따라 생존 확률이 향상됨을 입증한 전국 단위 후향적 코호트 연구. HIRA 빅데이터 기반 IPTW 매칭과 생존분석으로 분석. Blood Cancer Journal에 출판 (2025.10)."
tags:
  - Statistical Analysis
  - Survival Analysis
  - Causal Inference
  - Big Data Analysis
tech_stack:
  - SQL
  - R
  - SAS
  - IPTW
  - Cox Regression
links:
  - type: github
    url: https://github.com/chaeniverse/mm-precursor-survival
    label: Code
  - type: paper
    url: paper.pdf
    label: Paper (PDF)
featured: true
status: "Published"
role: "공저자"
duration: "2024–2025"
highlights:
  - "전국 의료 빅데이터(HIRA) 약 5천만 명 코호트에서 MGUS/SMM/*de novo* MM 환자군 정의·추출"
  - "IPTW 매칭 + Marginal Cox 회귀로 조기 검진의 생존 향상 효과 입증"
---

#### 개요

다발골수종(Multiple Myeloma, MM) 환자에서 전구 질환(MGUS, smoldering MM)의 사전 진단 여부에 따라 생존 확률이 어떻게 달라지는지 비교 분석한 전국 규모 후향적 코호트 연구입니다. 조기 검진(early detection)이 생존률을 높임을 입증해, MM 환자에 대한 초기 단계 screening의 임상적 가치를 제안했습니다.

#### 데이터

건강보험심사평가원(Health Insurance Review and Assessment Service, HIRA) 빅데이터 약 5천만 명 코호트에서 SQL을 활용해 MGUS, smoldering MM, *de novo* MM 환자군을 정의하고 추출했습니다.

![Cohort selection flowchart from HIRA big data](cohort-flowchart.jpg)

#### 분석 방법

선택 편향을 보정하기 위해 inverse probability of treatment weighting (IPTW) 매칭을 적용하고, weighted survival curve와 marginal Cox proportional hazards 분석으로 그룹 간 생존 확률을 비교했습니다. 분석은 R과 SAS로 구현했습니다.

#### 성과

> S. Choi, S.S. Park, C.H. Lee, et al., "Improved Survival in Multiple Myeloma Following Prior Detection of Precursor Conditions: A Nationwide Real-world Study," *Blood Cancer Journal*, Oct. 2025.
