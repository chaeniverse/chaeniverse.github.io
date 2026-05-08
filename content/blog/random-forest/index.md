---
title: "Random Forest"
date: 2024-09-19
summary: "Bagging의 특수한 형태로, decision tree를 base learner로 쓰면서 분기 시 변수도 무작위로 선택해 다양성을 한층 확보하는 앙상블. 일반화 오차 공식과 OOB 기반 변수 중요도까지 정리."
tags:
  - Machine Learning
  - Ensemble
  - Random Forest
authors:
  - me
featured: true
---

## Random Forest

**Random Forest** 는 bagging의 특수한 형태로, base learner로 **decision tree** 를 쓴다. 두 가지 메커니즘으로 앙상블의 다양성을 확보한다.

1. **Bagging (bootstrap sampling)** — 각 tree는 원본 데이터에서 복원 추출한 bootstrap 샘플로 학습
2. **Random variable selection** — tree의 각 분기점에서, 전체 $p$ 개 변수 중 무작위로 $m$ 개만 후보로 두고 그 중 최선의 변수로 분기

## 알고리즘

1. Bootstrap size $t$ 의 무작위 샘플 생성
2. 분기 시 원본 $p$ 개 변수에서 $m$ 개의 변수만 무작위로 선택해 후보로 두고 분기
3. 다수의 decision tree를 학습한 뒤 결과를 결합 (분류는 majority vote, 회귀는 평균)

## 핵심 통찰

변수 제약 때문에 **개별 tree의 성능은 떨어진다.** 하지만 tree들 간 **상관(correlation)이 줄어들어** 평균/투표로 결합하면 전체 앙상블의 성능은 더 좋아진다. "약한 학습기들을 다양하게 조합해 강한 학습기를 만든다"의 정수.

## 일반화 오차 (Generalization Error)

Random Forest의 일반화 오차에는 다음과 같은 상한이 알려져 있다.

$$\text{Generalization Error} \;\le\; \frac{\bar{\rho}\,(1 - s^2)}{s^2}$$

여기서

- $\bar{\rho}$ : tree들 간 결과의 평균 **상관(correlation)**
- $s^2$ : 개별 tree의 **정확도** (strength)

→ 좋은 일반화는 **개별 모델 성능($s$)이 높으면서 모델 간 상관($\bar{\rho}$)이 낮을 때** 얻어진다. 이게 RF가 변수 무작위 선택을 추가하는 이유 — 약간의 개별 정확도 손해를 보더라도 상관을 크게 떨어뜨려서 전체 bound를 줄이는 거래.

## 변수 중요도 (Variable Importance)

Random Forest는 **Out-of-Bag (OOB)** 데이터를 활용해 변수 중요도를 계산할 수 있다 (별도의 validation set 없이도 가능).

### 절차

1. 각 tree에 대해, 그 tree 학습에 쓰이지 않은 OOB 샘플로 예측 오차를 측정.
2. 변수 $x_i$ 의 값을 **무작위로 permute** 한 OOB 샘플로 다시 예측 오차 측정.
3. 두 오차의 차이를 모아 평균과 분산을 구한다.

### 중요도 지표

$$v_i \;=\; \frac{\bar{d}_i}{s_i}$$

여기서

- $\bar{d}_i$ : OOB 오차 차이의 평균 (permute 후 - permute 전)
- $s_i^2$ : 그 차이의 분산

직관적으로, **분기 시 자주 쓰이는 중요한 변수**일수록 permute하면 모델이 크게 망가져 오차 차이가 커진다 → $\bar{d}_i$ 가 크다 → $v_i$ 가 크다.

---

> 원문: <https://chaeniverse.tistory.com/67>
