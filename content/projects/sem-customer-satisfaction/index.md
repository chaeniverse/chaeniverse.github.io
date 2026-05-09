---
title: "Customer Satisfaction Index Modeling with SEM (Amos)"
date: 2023-06-14
summary: "병원 서비스 혁신팀의 의뢰로 설문지 데이터에 구조방정식(SEM)을 적용해 고객 서비스 품질의 잠재 구조를 모형화하고, 표준화 회귀 계수 기반 고객만족지수(CSI)를 산출한 컨설팅 프로젝트. 인하대병원 의학통계지원센터에서 수행."
tags:
  - Service/App
  - Statistical Analysis
  - Survey Analysis
  - SEM
authors:
  - me
tech_stack:
  - Amos
  - SPSS
links: []
featured: true
status: "Completed"
role: "통계 분석가 (의학통계지원센터 컨설팅)"
duration: "2023.05 – 2023.06"
highlights:
  - "병원 서비스 혁신팀 의뢰의 통계 컨설팅 — 설문지 데이터에 SEM 적용"
  - "다지표(multi-indicator) 측정 모형으로 잠재변수(서비스 품질 차원) 추정"
  - "모형 적합도 + 수렴 타당성(개념신뢰도, 분산추출지수)으로 측정 모형 진단"
  - "표준화 회귀 계수 + 가중치 셀 기반 고객만족지수(CSI) 산출"
---

## 개요

**병원 내 서비스 혁신팀**의 의뢰로 진행한 통계 컨설팅 프로젝트입니다. 환자/고객 설문지 응답 데이터를 활용해 서비스 품질의 잠재 구조를 모형화하고, 그로부터 **고객만족지수(Customer Satisfaction Index, CSI)** 를 산출하는 것이 목표였습니다.

> **보안 안내.** 본 프로젝트는 대외비로, 구체적인 설문 항목·결과 수치·도식은 공개하지 않습니다. 본 페이지는 적용된 **방법론과 분석 과정** 중심으로 정리합니다.

## 데이터

- **출처**: 병원 서비스 혁신팀이 자체 시행한 고객 설문 결과 (수치/항목 비공개)
- **전처리**: 결측치 제거 (NA exclusion), 셀별 가중치 부여, 가중치 적용 셀 단위 데이터셋 구성
- **변수 구조**: 서비스 품질의 다양한 측면을 측정한 다수의 관측 항목 → 잠재 변수(서비스 품질 차원)에 매핑

## 방법론

### Structural Equation Modeling (SEM)

본 분석에는 **구조방정식 모형**, 그중에서도 잠재변수 1개에 여러 관측 지표를 두는 **다지표(multi-indicator) 측정 모형**을 적용했습니다.

- 잠재변수에 대해 reference indicator를 무작위로 1로 고정 (model identification)
- 관측 변수 간 직접 path는 설정하지 않고, 측정 모형(measurement model)에 충실하게 구성
- 잠재변수 자체에는 error term이 부착되지 않도록 주의 (모형 형태 점검)

### 적합도(Fit) 지표

표준 SEM 적합도 지표를 통해 모형의 데이터 부합 정도를 진단:

- $\chi^2$, df, $\chi^2$/df
- CFI (Comparative Fit Index)
- TLI (Tucker-Lewis Index)
- RMSEA (Root Mean Square Error of Approximation)
- SRMR

### 수렴 타당성 (Convergent Validity)

잠재변수 자체의 신뢰성·타당성을 확인하기 위한 추가 검증:

- **개념신뢰도 (Construct Reliability, CR)**
- **분산추출지수 (Average Variance Extracted, AVE)**

### CSI (고객만족지수) 산출

최종 채택된 측정 모형의 **표준화 회귀 계수(standardized regression weights)** 와 가중치 셀을 결합해 고객만족지수를 산출했습니다. 이 지수는 의뢰 부서가 정성적 보고에 활용할 수 있도록 표준화된 단일 점수 형태로 제공되었습니다.

## 도구

- **Amos** — SEM 모형 추정·적합도 산출
- **SPSS** — 데이터 전처리, 가중치 적용, 보조 분석

## 효과 / 임팩트

- **비즈니스 문제 → 통계 문제 변환** — "고객만족도를 단일 점수로 보고하고 싶다"는 요구를 SEM 측정 모형으로 정의
- **외주 비용 절감** — 구조방정식 전문 모델링은 외부 컨설팅으로 의뢰 시 비용 부담이 상당함. 원내 의학통계지원센터에서 직접 수행함으로써 의뢰 부서의 외주 비용을 절감하고, 분석 흐름을 부서 일정에 맞춰 유연하게 진행

## 산출물

- **고객만족지수(CSI) 단일 점수** + 항목별 표준화 가중치
- **분석 결과 보고서** — 의뢰 부서 내부 의사결정용 (대외비)
