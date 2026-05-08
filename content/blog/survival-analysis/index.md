---
title: "Survival Analysis: Exposure Period, Immortal Time Bias, Fine-and-Gray"
date: 2025-03-31
summary: "임상 생존분석 실무 노트. 약 복용 시점을 index date로 잡으면 생기는 immortal time bias, exposure period로 보정하는 방법, 그리고 cause-specific vs Fine-and-Gray 모델 + matchit 코드까지 정리."
tags:
  - Statistics
  - Clinical Biostatistics
  - Survival Analysis
  - Competing Risk
authors:
  - me
featured: true
---

## ggsurvfit (`survfit2`) 잠깐

`survfit2()` 는 survival curve를 깔끔하게 그려주는 함수로 **`ggsurvfit`** 패키지에 있다. base R `survfit()` 결과를 ggplot 스타일로 변환.

```r
library(ggsurvfit)

survfit2(Surv(time, event) ~ group, data = df) |>
  ggsurvfit() +
  add_confidence_interval() +
  add_risktable()
```

## Wash-out 기간

중재/약물 연구에서 **이전 치료의 잔여 효과가 몸에서 사라지도록 두는 기간**. 이 동안 참가자는 어떤 치료도 받지 않는다.

예) 약물 A 효과 평가 후 같은 참가자에게 약물 B를 투여하기 전, A의 잔여 효과가 완전히 사라질 때까지 기다린다 → B 효과를 정확히 측정 가능.

## Index Date를 어디로 잡을 것인가 — Exposure Period 문제

후향적 약물 연구의 핵심 질문 중 하나: **약 복용 시점을 index date로 잡을지, 진단일로 잡을지.**

> "팽이 비유: 팽이 던진 순간부터는 가만 둬야 한다. 그 이후에 행위(약 처방)를 추가하면 그게 time-varying cox이고, 결과 활용이 어려워서 잘 안 쓴다."

### Index date = 진단일로 잡으면

- 좋은 점: control 군의 index를 잡기 쉽다.
- 문제: 복용군이 약을 **언제** 먹었는지 모를 때 immortal time bias.
  - 약을 1년 뒤에 먹은 사람 = "1년 동안 죽지 않았다" 는 정보가 미래에서 새는 셈.
  - control 군은 그런 보장이 없다 → **항상 약 먹은 사람이 더 오래 산다 (효과 좋음)** 로 잘못 나옴.

### Index date = 약 복용일로 잡으면

- control 군의 index를 잡을 수 없다 (약을 안 먹었으니까).

### 가장 흔한 해결: Landmark + Exposure Period

진단일부터 일정 기간 (예: 1년, 2년) 을 **exposure period** 로 정의:

1. **진단 시점부터 진단 + N년까지를 exposure 정의 구간** 으로 둔다.
2. 그 안에 약을 먹었으면 treatment, 아니면 control.
3. **분석 시작은 진단 + N년 시점부터** (이게 새 index date).
4. 분석엔 N년 이전 데이터는 버림.

**효과**:

- Treatment 군과 control 군이 **같은 시점부터 추적 시작** → immortal time이 양쪽에 동일하게 작용해 상쇄.
- 미래 정보 누설 없음.

**단점**:

- N년 사이에 사망한 사람은 분석에서 제거 → 표본 수 감소.
- N이 너무 길면 표본이 많이 빠진다.
- 결과는 "진단 후 N년까지 살아남은 사람들" 에 한정된 효과.

### 실무 팁

- **랜드마크 1년 vs 2년 vs 3년** 으로 표본 수와 결과를 비교해보고 합리적인 기간을 고른다.
- 가능하면 **진단 전에 먹은 것만** 분석하는 게 가장 깔끔 (statin 연구처럼).
- "약을 끊는 시점" 같이 **미래 정보를 봐야 하는 분석**은 본질적으로 어렵다. 그래도 landmark로 어느 정도 우회 가능.

## Treatment 군 정의의 시점성

> "팽이를 만드는 거랑 팽이를 치는 거랑 차이가 있다."

- treatment 군 / control 군을 정할 때는 **현재 기준** 으로 해야 한다.
- 그냥 raw data로 "이 사람이 치료받은 사람이고 저 사람은 아니다" 라고 하면 사실상 **미래를 본 거** (그 사람이 약을 먹은 게 미래라).
- 그래서 landmark를 걸면 그 시점까지의 정보로 그룹을 정의 — "현재 기준" 이 됨 → 사기 X.

## Competing Risk Regression (실무 코드)

### Cause-Specific Hazard Model

특정 사망 (e.g., cancer death) 의 위험만 본다. 다른 event는 censoring 처리.

```r
coxph(Surv(time, status) ~ T, data = df)
# status == 1 만 event, 그 외(예: 사망)는 censor
```

### Fine-and-Gray Sub-Distribution Model

다른 event 발생 시 그 사람을 **risk set에서 빼지 않고 무한대로 둔다.** Cumulative incidence와 1:1 대응.

```r
library(cmprsk)

# crprep으로 weighted long-format data 생성
# (또는 직접 crr 사용)
fit.crr <- crr(
  ftime    = sub$d.age,
  fstatus  = sub$cod2,
  cov1     = covs,
  failcode = 1, cencode = 0
)
summary(fit.crr)
```

### 두 모델 어떻게 다른가

- **Cause-specific** — 특정 원인 사망의 hazard rate를 추정. 다른 event는 censor 처리. 인과적 해석에 가깝지만, cumulative incidence plot과 직접 매칭되지 않는다.
- **Fine-and-Gray** — sub-distribution hazard. **Cumulative incidence plot과 1:1 대응** → HR과 CI plot을 같이 보여주기 좋다. 임상에서 더 많이 쓰임.

> 임상에서 cuminc plot과 HR을 함께 보여주려면 **Fine-and-Gray** 가 자연스럽다.

## Fine-and-Gray가 cuminc와 일치하는 이유 (간단 설명)

Fine-and-Gray model의 핵심은 **다른 event가 일어난 사람도 끝까지 본다**는 것 — 사망 시점에서 끊지 않고 연구 종료일까지 추적한다고 본다.

다만 "언제까지 볼지" 가 애매하므로 **시간이 멀어질수록 weight를 작게** 준다. 이렇게 **stabilized censoring weight**를 곱한 long-format 데이터를 만들면, `survfit + ggsurvplot` 로 그린 cumulative incidence plot이 `cmprsk::cuminc` / `prodlim::Hist` 결과와 정확히 일치한다.

→ Geskus 가 증명한 결과. R에서는 `cmprsk::crprep()` 함수가 이 long-format 데이터를 만들어준다.

## Matching with `MatchIt`

```r
library(MatchIt)

m.out <- matchit(
  group ~ age + sex + comorbidities,
  data    = df,
  method  = "nearest",
  caliper = 0.1
)

m.data <- match.data(m.out)
result <- coxph(Surv(time, event) ~ group, data = m.data)
summary(result)
```

`method = "full"` 을 주면 optimal full matching이 자동으로 적용됨.

### Greedy vs Full Matching

- **Greedy (nearest, 1:1)** — 임상 국룰. 거리 가까운 짝부터 차례로 매칭. caliper로 정밀도 제어. 표본 손실 있음.
- **Full** — `optmatch` 패키지 기반. 모든 케이스를 활용해 더 효율적이지만 해석/보고가 까다롭다.

## 한 줄 요약

> **Index date 결정이 곧 immortal time bias 처리의 핵심.** Exposure period + landmark가 가장 흔한 실무 해법이고, competing risk가 있을 땐 Fine-and-Gray가 cumulative incidence plot과 1:1 대응해 가장 자주 쓰인다.

## 관련

- [Causal Inference: PSM, IPTW, CCW, TTE](/blog/causal-inference/)
- [Competing Risk Analysis](/blog/competing-risk-analysis/)

## 참고

- *[Practical recommendations for reporting Fine-Gray model analyses for competing risk data](https://onlinelibrary.wiley.com/doi/10.1002/sim.7501)* (Austin, Statistics in Medicine)
- [`cmprsk` package manual](https://cran.r-universe.dev/cmprsk/doc/manual.html)
- [`crrstep` tutorial](https://cran.r-universe.dev/crrstep/doc/manual.html)
