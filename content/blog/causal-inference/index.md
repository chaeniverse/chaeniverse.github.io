---
title: "Causal Inference: PSM, IPTW, CCW, Target Trial Emulation"
date: 2025-08-26
summary: "후향적 연구의 인과추론을 위한 PSM, IPTW (stabilized + truncation), 균형 진단, robust sandwich estimator 짝꿍, 그리고 더 진보된 clone censor weighting과 target trial emulation까지. 카운터팩추얼 프레임에서 출발해 실무 코드까지 정리."
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

후향적 연구 (registry data, 건강보험·심평원 청구 데이터 등) 는 RCT처럼 미리 정의된 조건으로 데이터를 수집한 게 아니다. **bias가 존재할 수밖에 없다.**

예) 새로운 약 효과를 보기 위해 두 그룹 (약 먹은 vs 안 먹은) 비교.

- **임상시험**: randomization으로 baseline 통제 → 순수한 약 효과 (causal effect).
- **후향적 연구**: 이미 모인 데이터 → 두 그룹의 baseline이 다를 수 있음.

→ **요는, 후향적 연구를 통계 기법으로 최대한 임상시험처럼 셋팅하는 것.**

## 카운터팩추얼 프레임

각 개인에게 두 개의 잠재적 결과가 있다고 가정:

- $Y^{a=1}$ : "**약을 먹었다면**" 의 결과
- $Y^{a=0}$ : "**약을 먹지 않았다면**" 의 결과

진짜 인과효과는 $E[Y^{a=1}] - E[Y^{a=0}]$ — **평행세계의 약 먹은 나 vs. 평행세계의 약 안 먹은 나** 의 차이.

문제: 한 사람에게 한쪽만 관측됨. 그래서

$$E[Y^{a=1}] = E[Y \mid A=1] \quad \text{(?)}$$

**이 등식이 성립하려면 가정이 필요하다.**

### 조건부 독립 (Strongly Ignorable Assignment)

$$Y^a \perp A \mid X$$

> **모든 confounder $X$ 가 주어졌을 때, 잠재적 결과 $Y^a$ 와 treatment 배정 $A$ 가 독립**이라는 가정.

이게 성립하면

$$E[Y^{a=1}] = E[Y \mid A=1, X = x_0] \cdot \text{(for any specific } x_0\text{)}$$

그리고 marginalization으로

$$E[Y^{a=1}] = \sum_x E[Y \mid A=1, X=x]\, P(X=x)$$

즉, **공변량 $X$ 가 충분히 주어지면 인과효과를 추정할 수 있다.** 이 marginalization을 통계 기법으로 풀어내는 게 **PS / IPTW**.

## ATE vs ATT — 무엇을 추정할 것인가

| 추정량 | 정의 | 누가 쓰나 |
|---|---|---|
| **ATE** (Average Treatment Effect) | $E[Y^{a=1}] - E[Y^{a=0}]$ | **IPTW** |
| **ATT** (Average Treatment effect on the Treated) | $E[Y^{a=1} - Y^{a=0} \mid A=1]$ | **PSM (matching)** |

매칭은 treated 군에 untreated 자료를 짝지어 가져오므로, **treated 군에 한정된 효과**만 정확히 본다 → ATT.

ATT의 해석은 까다롭다 — 일반적으로 **정책 평가**처럼 "정책 시행군 전체에 대한 효과"를 보고 싶을 때 사용된다 (정책 시행 후엔 모두가 시행군이라 ATT가 자연스러움).

IPTW는 전체 모집단에 대한 효과 (ATE) 를 직접 추정 → **인과효과로 해석하기 가장 쉽다**. 최근 임상연구의 흐름은 매칭보다 **IPTW로 점점 이동**.

## 기존 회귀(Adjusted) vs 인과추론

회귀모형에 그냥 공변량을 다 넣어 보정하는 흔한 방법:

$$\text{lm}(y \sim a + x)$$

이때 회귀 계수는

$$E[Y \mid A=1, X] - E[Y \mid A=0, X]$$

이고, 보고 표기는 **Adjusted risk ratio / Adjusted HR** 등.

문제점:

- 공변량 $X$ 가 **conditioning 된 상태에서의 효과** — "성별·연령이 고정된 채 약 변수만 1 증가했을 때 효과" 라는 의미.
- 진짜 약효 (marginal causal effect) 와 해석이 다름.

용어 구분:

- **Conditional model** — 공변량을 모형 안에 넣어 보정 (회귀의 표준)
- **Marginal model** — weight를 주어 보정 (IPTW + univariate)

→ 임상 논문 읽을 때 conditional/marginal HR 구분이 중요.

## Crude vs Causal

매칭 후 단순 비교:

```r
coxph(Surv(time, event) ~ group, data = matched_df)
```

→ 매칭으로 균형이 맞춰졌으니 결과는 단순 crude HR이 아니라 **causal HR** 로 부를 수 있다.

매칭 안 한 raw 비교는 **crude HR**. 이 둘을 구분해서 보고하는 게 좋다.

## Propensity Score Matching (PSM)

공변량이 비슷한 사람끼리 두 그룹 간 짝지어 분석.

- **propensity score** $P(A=1 \mid X)$ 를 logistic regression으로 추정.
- 점수가 비슷한 treated/untreated 짝을 매칭.
- 모든 case가 1:1로 맞춰진 후엔 단순 비교 (`coxph(Y ~ A)`) 가 곧 인과 효과 추정.

**단점:**
- $n$ 수가 줄어든다 (짝 안 맞는 케이스 제거).
- 매칭 결과 자체가 진짜 causal effect인지 약간 애매할 수 있음 (causal risk difference).
- treated 기준이라 ATT 추정.

**임상 국룰**: greedy matching (1:1 nearest matching) + caliper.

## IPTW (Inverse Probability of Treatment Weighting)

매칭의 반대. 짝짓는 대신 **weight를 주어** balance를 맞춘다.

직관: 남자 3명, 여자 6명 → 남자에 weight 2를 주면 6:6. 이 weight 2 가 곧 $1/P(A=1 \mid X)$.

$$w_i = \frac{1}{P(A_i=1 \mid X_i)}$$

이 weight를 분석에 넣으면 **단변량 회귀로도 인과효과**를 얻는다:

```r
coxph(Surv(time, event) ~ group, data = df, weights = df$weights)
```

장점:

- $n$ 수 유지.
- ATE 직접 추정.
- 인과효과 해석이 가장 쉽다.

### Weight의 직관

> ID 1번이 weight 2로 들어갔다 = 그 사람을 **2명으로 복제**했다고 생각하면 됨.
>
> 실제로 표본 수가 늘어나는 게 아니라 cox 점수에 weight를 곱하는 형태로 처리.

소수점 weight도 같은 직관.

## R 구현 흐름

PSM도 IPTW도 출발점은 같다 — propensity score 추정:

```r
glm(group ~ age + sex + comorbidities, data = df, family = binomial(link = "logit"))
```

- 이 확률값으로 짝지으면 → **PSM**
- 이 확률의 역수를 weight로 쓰면 → **IPTW**

## Stabilized Weight + Truncation (실무 국룰)

> "stabilized 넣고 weight truncation까지 하는 건 국룰이다."

### 왜 stabilized?

극단적인 표본 비대칭에서 weight가 폭발한다. 예: 남자 3명, 여자 30만명 → 남자 weight가 십만 단위. `glm`이 안 돌아가고, 운 나쁘게 그 3명 중에 사건이 몰리면 분석이 왜곡된다.

해결: **분자에 marginal probability** 를 곱해 weight를 안정화.

$$w_i^{\text{stab}} = \frac{P(A_i=a)}{P(A_i=a \mid X_i)}$$

- 결과에 영향을 주지 않으면서 분산을 안정화.
- weight의 평균이 1 → **표본 수가 유지된다.**

### 왜 truncation?

stabilized 후에도 극단적으로 큰 weight 케이스가 남는다. 다변량 공변량에서 특정 조합이 매우 드문 경우 (예: 20대 + 특정 질환 + 특정 약 동반).

해결: **99% percentile (또는 1% 양쪽 자르기)** 위 weight를 cap.

> "weight 4의 99% percentile, 100%가 32라고 하면 → 32 같은 outlier를 4로 바꾼다. 99% 이상은 다 4 4 4 …"

논문 인용은 **Peter Austin** 의 stabilization / truncation 원논문이 보통.

R에선 보통 함수로 묶음 (`get_sw(formula, data, trunc_cut = 0.01)` 같은 형태).

## CBPS (Covariate Balancing Propensity Score)

기본 IPTW로 balance가 안 맞을 때, balance를 명시적으로 maximize하도록 PS를 추정하는 변종 (GMM 기반).

> 실무 의견: "**거의 안 쓴다.**" JAMA 등 임상 저널 게재 사례가 적고, reviewer 설득이 까다롭다. 정책학에서는 종종 사용.

대신 우리는 **interaction term을 하나씩 넣어가며** balance를 맞춘다:

```r
# 기본
glm(group ~ x1 + x2 + x3, ...)

# balance 안 맞으면
glm(group ~ x1 + x2 + x3 + I(x1^2) + x1:x2, ...)
```

연속형 변수 제곱항, 변수 간 interaction을 시도해 SMD가 떨어질 때까지 조정.

## Balance Check

매칭/가중 결과가 잘 맞았는지 확인하는 진단:

- **SMD (Standardized Mean Difference)** $< 0.1$ — 균형 OK
- **Love plot** — 변수별 SMD를 시각화 (matching/weighting 전·후 비교)

## Robust Sandwich Estimator (매칭/가중의 짝꿍)

PSM, IPTW를 적용하면 신뢰구간이 인위적으로 줄어들어 **p-value가 유의하게 잘못 나올 수 있다.**

- 원래 분산 공식은 어떤 역행렬 가정에 기반함.
- weight를 쓰면 그 가정이 깨지므로 **분산이 과소추정**된다.

해결: **robust sandwich estimator** — 분산 식이 $I S I$ 모양 (한 항이 더 추가). 이름의 유래는 그 모양.

> **매칭/가중 ↔ Robust estimator** 짝꿍처럼 기억.

추가 분석에서 robust estimator로 바꿨다가 결과가 뒤집히는 사례가 있어 반드시 같이 써야 함.

## HR vs Risk Difference Ratio

전통적으로 생존분석은 hazard ratio (HR) 만 보고했지만, 최근 trend는 **HR + risk difference / risk ratio** 를 같이 보는 것.

- HR은 proportional hazard 가정에 의존 → 가정 위배 시 해석 위험.
- Risk Ratio는 cumulative incidence curve의 각 시점에서의 risk를 비교 → 가정 더 자유로움.
- Time-specific hazard는 시간에 따라 위험이 변하지만, proportional hazard ratio는 그 평균 한 값으로 보고 → **해석 모호**.

## Immortal Time Bias

치료군 vs 비치료군 비교 시 **index date를 어떻게 잡느냐** 가 핵심.

- 치료군의 index date = 치료 시점 → 그 시점까지 사망하지 않은 사람만 치료군에 들어감.
- 비치료군은 그런 비대칭이 없음.
- 결과적으로 치료군에 "사망하지 않을 운명" 의 시간(immortal time)이 부여됨 → bias.

전통적 보정: **landmark analysis** (landmark 이전 사망자 제외).

문제:
- 전체 모집단이 아니라 "landmark까지 살아남은 사람" 만의 효과 → **selection bias**, 해석 어려움.
- Time-varying Cox 등 보조 도구가 필요해짐.

## Clone Censor Weighting (CCW)

최신 흐름. 한 사람을 **양쪽 그룹에 복제**해 immortal time bias를 원천 제거한다.

- A라는 사람이 90일째 treatment 받았다고 하자 → 그 사람은 90일까지 안 죽었다.
- Control 군에도 똑같은 가상의 사람을 0~90일까지 만든다.
- 두 쪽이 동일한 0~90일을 가지므로 immortal time이 상쇄됨.

장점:
- Landmark 없이 immortal time bias 해결.
- 같은 사람을 만들기 때문에 covariate balance도 자동 해결.
- 매칭/IPTW 없이도 분석 가능.

단점:
- Cloning된 자료 만드는 과정이 복잡 (경우의 수 많음).
- **CCW를 쓰면 IPCW (Inverse Probability of Censoring Weighting)** 가 필수 짝꿍.

## 인과추론 방법 계층 (Trend)

분석의 중요도에 따라 방법이 점진적으로 강해진다:

```
가벼운 분석     매칭 (PSM)
                ↓
                IPTW
                ↓
중요한 분석     CCW + IPCW
                ↓
                Target Trial Emulation (전체 framework)
```

→ 중요한 분석에서는 "**우리는 모든 bias를 제거했다**" 라고 method에 기술할 수 있을 정도까지 간다.

## Target Trial Emulation (TTE)

상위 framework. 임상시험 protocol처럼 **연구 설계 시 조작적 정의를 엄격하게 명시**하는 일련의 과정을 정형화. PRISMA가 메타분석 reporting을 정형화한 것처럼, TTE는 후향적 인과추론의 reporting/설계 standard.

명시 항목:

- **Eligibility criteria**
- **Treatment strategies**
- **Assignment procedure**
- **Outcome / Follow-up**
- **Causal contrast** (intention-to-treat / per-protocol)
- **Statistical analysis** plan

→ TTE는 잘 구조화된 retrospective data 분석을 위한 framework. 위에서 다룬 PSM/IPTW/CCW를 **어떻게 조합해 protocol을 설계할지**를 다룬다.

## 요약

- 인과추론의 출발점: **카운터팩추얼 프레임 + 조건부 독립 가정** ($Y^a \perp A \mid X$)
- $X$ 를 통계 기법으로 처리하는 핵심 도구: **PSM (ATT)** 과 **IPTW (ATE)**
- IPTW는 **stabilized + truncation** 가 실무 국룰
- 매칭/가중 후엔 **robust sandwich estimator** 필수 짝꿍
- 모형 안에 공변량 → conditional, weight로 보정 → marginal
- Balance 진단: SMD < 0.1, love plot
- **Immortal time bias** 는 landmark가 전통 해법, 최근엔 **CCW (+ IPCW)** 가 부상
- 전체를 framework로 정형화한 게 **Target Trial Emulation**
- 임상 trend: HR 단독 → HR + Risk Difference / Risk Ratio
