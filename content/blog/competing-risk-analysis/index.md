---
title: "Competing Risk Analysis"
date: 2024-03-15
summary: "생존분석에서 관심 event 외에 다른 event가 같이 작동할 때, 그 영향을 보정하는 competing risk 분석. Cause-specific model과 Fine-Gray sub-distribution model의 차이, 그리고 matching 선택지 정리."
tags:
  - Statistics
  - Clinical Biostatistics
  - Survival Analysis
  - Competing Risk
authors:
  - me
featured: true
---

## Competing Risk란

생존분석에서 **관심 event 외에 다른 event가 있어 두 event가 서로의 발생 확률에 영향을 주는** 상황. 그래서 한 event가 다른 event의 변동을 일으킨다 → "경쟁 위험".

### 직관 예시

술이 위암(A)의 원인이라고 하자. 술 먹는 사람은 위암 위험이 ↑.

근데 술이 간암(A')의 원인도 된다면? → 술 먹은 사람 중 어떤 이는 간암이 먼저 생기고, 어떤 이는 위암이 생긴다.

간암 생긴 사람은 **사망이라는 event가 먼저 발생** → 그 사람의 위암은 더 이상 관찰되지 않는다. 결과적으로 위암은 작게 측정되는 (감소하는) 방향으로 작동한다.

이렇게 하나의 원인에 대해 다른 event가 경쟁적으로 작동해, **A'(간암) event 때문에 A(위암) event가 변동되는** 게 competing risk이다.

### MGUS / MM 코호트 예시

MGUS 코호트에서 outcome이 (MM 발생, 사망, censored) 라고 하자.

- 관심 event: MM 발생 (event = 1)
- Competing risk: 사망 (사망으로 인해 MM outcome으로 갈 확률이 줄어드는 거니까)

## 두 가지 처리 방법

### Cause-Specific Model

다른 event를 **censored** 로 처리하고 관심 event에 대해 standard Cox 회귀를 적용. 진정한 인과적 효과 (cause-specific hazard) 를 본다.

### Fine-Gray Sub-Distribution Model

다른 event 발생 시 **추적 기간을 연구 종료일까지로 두고** sub-distribution hazard를 모델링. → **Cumulative incidence plot (CIF)** 와 1:1 대응.

## 어느 걸 쓰나

- **인과적 효과**를 보고 싶다 → cause-specific model이 더 적합
- 그러나 **실무에서는 Fine-Gray가 압도적으로 많이 쓰인다** — cumulative incidence plot과 직관적으로 매칭되기 때문

## 참고

- *[Practical recommendations for reporting Fine-Gray model analyses for competing risk data](https://onlinelibrary.wiley.com/doi/10.1002/sim.7501)* (Austin, Statistics in Medicine)
- 출처: <https://3months.tistory.com/355>
