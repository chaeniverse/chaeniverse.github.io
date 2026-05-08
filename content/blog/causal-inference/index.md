---
title: "Causal Inference: PSM, IPTW, Target Trial Emulation"
date: 2025-08-26
summary: "후향적 연구에서 selection bias를 보정하기 위한 propensity score matching, IPTW, 그리고 비교적 최근의 target trial emulation까지. R 구현 예와 robust sandwich estimator 짝꿍까지 정리."
tags:
  - Statistics
  - Clinical Biostatistics
  - Causal Inference
  - Propensity Score
  - IPTW
authors:
  - me
featured: true
---

## 왜 인과추론이 필요한가

후향적 연구 (registry data, 건강보험·심평원 청구 데이터 등 이미 수집이 완료된 데이터로 진행하는 연구) 는 RCT(임상시험)처럼 사전에 미리 정의된 조건에 따라 데이터를 수집한 게 아니다. 그래서 **bias가 존재할 수밖에 없다**.

예) 새로운 약 효과를 보기 위해 두 그룹 (약 먹은 그룹 vs. 안 먹은 그룹) 을 비교한다고 하자.

- **임상시험**: 대상자 수집 단계에서 성별·나이 등이 같은 사람들을 의도적으로 모으거나 randomize 한 뒤 약효를 비교한다. 다른 변인이 통제된 상태에서 순수한 약 효과(causal effect)를 본다.
- **후향적 연구**: 이미 모인 데이터를 쓰므로 그게 불가능. 약 먹은 사람과 안 먹은 사람의 baseline이 다를 수 있다.

→ 이런 bias를 보정하기 위한 방법론들이 등장. **요는, 후향적 연구를 통계 기법으로 최대한 임상시험처럼 셋팅하는 것.**

## Propensity Score Matching (PSM)

공변량 (성별, 나이 등) 이 비슷한 사람끼리 두 그룹 간 짝지어서 분석.

- $n$ 수가 줄어든다 (짝이 안 맞으면 버려짐).
- 매칭 방법 중 임상 국룰은 **greedy matching** (1:1 nearest matching). caliper setting으로 정밀도 조절.

## IPTW (Inverse Probability of Treatment Weighting)

각 사람에게 weight를 주어 그룹 간 보정.

- $n$ 수를 유지할 수 있다.
- 직관: 성별·나이가 같은 **pseudo population** 을 만들어 비교하는 것과 같다.

### Weight의 직관

> ID가 1번인 사람이 weight 2로 들어갔다 = 이 사람을 **2명으로 복제**했다고 생각하면 됨.
>
> 실제로 표본 수가 늘어나지는 않고, 그 사람의 cox 점수에 weight를 곱하는 식으로 처리.

가중치가 소수점이어도 마찬가지 — 사람 복제하는 느낌으로 보면 직관이 잘 맞는다.

## R 구현

PSM도 IPTW도 출발점은 같다. **propensity score** = "어떤 사람이 treatment 그룹에 속할 확률" 을 logistic regression으로 추정:

```r
glm(group ~ age + sex + comorbidities, data = df, family = binomial(link = "logit"))
```

- 이 확률값으로 그룹끼리 짝지으면 → **PSM**
- 이 확률의 inverse를 weight로 쓰면 → **IPTW**

IPTW로 구한 weight는 분석 모형에서 사용된다. 이때 **독립 변수 자리에 그룹 변수만 넣어서 단변량처럼 처리**한다 (공변량 보정은 이미 weight에 흡수됨):

```r
coxph(Surv(time, event) ~ group, data = df, weights = df$weights)
```

## PSM vs IPTW

| | PSM | IPTW |
|---|---|---|
| 표본 수 | 줄어듦 (짝 안 맞는 케이스 제거) | 유지 |
| 추정량 | **ATT** (Average Treatment effect on the Treated) | **ATE** (Average Treatment Effect) |
| 직관 | 비슷한 짝 비교 | pseudo population 비교 |

→ 추정량이 다르므로 PSM과 IPTW 결과가 다른 게 정상. 어느 걸 쓰느냐는 연구 질문에 따라 결정.

## Conditional vs Marginal

매칭 / 가중치 말고도, **Cox나 logistic 회귀에 그냥 공변량을 통째로 넣어** 보정하는 방법도 있다. 이때 group 외 같이 들어간 공변량을 **혼란변수**라고 한다.

> 혼란변수: 결과변수 $y$ 와 비교 그룹 변수 $x$ 둘 다에 영향을 미치는 변수.

용어 구분:

- **Conditional model** — 공변량을 모형 안에 넣어 보정 (Cox, logistic with covariates)
- **Marginal model** — weight를 주어 보정 (IPTW + univariate)

임상 논문 읽을 때 헷갈리기 쉬운 부분이라 알아두면 유용.

## Robust Sandwich Estimator (매칭의 짝꿍)

PSM이나 IPTW로 매칭/가중하면 **신뢰구간이 필연적으로 줄어든다**. 그래서 그렇지 않음에도 p-value가 유의하게 나올 수 있다 (제1종 오류).

이걸 보정하려고 **robust sandwich estimator** (기존 분산 공식과 조금 다른 식) 를 쓴다.

- 원래 분산 공식은 역행렬을 구할 수 있어야 하는데, weight를 쓰면 그 가정이 깨진다.
- 그래서 식이 $I S I$ 모양 — "샌드위치" — 로 한 항이 추가된 형태.

매칭을 썼는데 기존 분산 공식을 쓰면 p-value가 잘못 나올 수 있다. **추가 분석에서 robust estimator를 쓰면 결과가 뒤집히는 케이스도 있음.** 그래서

> **매칭 ↔ Robust estimator** 짝꿍처럼 기억하면 유용.

## Target Trial Emulation (TTE)

비교적 최근 대두된 framework. 임상시험과 비슷하게 가기 위해 **연구 설계 시 조작적 정의를 엄격하게 설정**하는 일련의 과정을 정형화한 것. PRISMA가 메타분석 reporting을 정형화한 것처럼, TTE는 후향적 인과추론 설계를 정형화하는 guideline / statement 같은 것.

### Immortal Time Bias

TTE가 부각된 핵심 동기 중 하나. 치료군 vs 비치료군 분석 시 **index date를 어떻게 잡을지** 가 문제.

- 치료군의 index date를 치료 시점으로 잡으면 → 비치료군은 치료를 안 했기 때문에 index date가 없다.
- 이런 비대칭에서 발생하는 bias를 immortal time bias라 한다.

이런 문제를 보정하려는 일련의 수학적·설계적 접근을 총괄해 **target trial emulation** 이라 부른다.

→ 즉, TTE는 **잘 구조화된 retrospective data 분석**을 위한 framework. eligibility criteria, treatment strategies, assignment, follow-up 시점 등을 임상시험 protocol처럼 사전에 명시한다.

## 요약

- 후향적 데이터의 bias 보정 도구: PSM, IPTW (둘 다 propensity score 기반)
- IPTW의 weight = "사람 복제" 직관으로 이해
- PSM ↔ ATT, IPTW ↔ ATE
- 매칭하면 robust sandwich estimator로 분산 보정 (짝꿍처럼 기억)
- 모형 안에 공변량 → conditional, weight로 보정 → marginal
- TTE는 후향적 데이터를 임상시험처럼 엄격하게 설계하는 최신 framework, immortal time bias 등을 다룸
