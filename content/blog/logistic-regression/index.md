---
title: "Logistic Regression"
date: 2024-09-22
summary: "Linear regression과 달리 닫힌 해가 없는 logistic regression. Likelihood, MLE, gradient descent 흐름과 sigmoid 기반 예측·분류까지."
tags:
  - Machine Learning
  - Classification
  - Logistic Regression
authors:
  - me
featured: true
---

## Logistic Regression vs Linear Regression

- Linear regression — **닫힌 해 (closed-form solution)** 가 존재 (정규방정식)
- Logistic regression — 닫힌 해 없음. **최적화 기법** 필요

좋은 logistic regression 모델은 정답 클래스에는 높은 확률을, 오답 클래스에는 낮은 확률을 부여한다.

## Likelihood Function

모델 성능을 **likelihood** — "각 데이터 포인트가 정답 클래스로 분류될 확률을 모두 곱한 것" — 로 측정한다.

문제: 확률값을 계속 곱하면 값이 0에 가까워져 수치적으로 불안정. → 로그를 취해 **log-likelihood** 사용.

## Maximum Likelihood Estimation (MLE)

$$\arg\max_\theta \mathcal{L}(\theta) \;=\; \arg\max_\theta \log \mathcal{L}(\theta) \;=\; \arg\min_\theta \big(-\log \mathcal{L}(\theta)\big)$$

데이터셋 likelihood를 최대화하는 계수 $\theta$ 를 찾는 것이 MLE. 실전에서는 보통 **negative log-likelihood (NLL) 최소화** 형태로 푼다.

## Gradient Descent

Logistic regression에는 닫힌 해가 없으므로 **gradient descent** 로 반복 개선:

1. 가중치 $\theta$ 를 무작위로 초기화
2. NLL의 gradient (1차 도함수) 계산
3. Gradient의 반대 방향으로 step size $\alpha$ (learning rate) 만큼 이동
4. 수렴할 때까지 반복

$$\theta^{(t+1)} = \theta^{(t)} - \alpha \cdot \nabla_\theta \big(-\log \mathcal{L}(\theta^{(t)})\big)$$

## 예측 및 분류

학습된 계수로 새 데이터의 확률을 계산할 때 **sigmoid 함수** 사용 — S자 곡선:

$$\sigma(z) = \frac{1}{1 + e^{-z}}, \qquad z = \theta^\top x$$

기본 cutoff threshold (보통 0.5) 를 적용해 확률을 이진 분류로 변환:

$$\hat{y} = \begin{cases} 1 & \text{if } \sigma(\theta^\top x) \ge 0.5 \\ 0 & \text{otherwise} \end{cases}$$

threshold는 도메인에 따라 (예: 의료에서 false negative 비용이 클 때) 0.3, 0.7 등으로 조절 가능.

---

> 원문: <https://chaeniverse.tistory.com/80>
