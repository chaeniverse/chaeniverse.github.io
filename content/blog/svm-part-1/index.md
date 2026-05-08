---
title: "SVM (Support Vector Machine)"
date: 2024-09-20
summary: "이진 분류 알고리즘 SVM의 기본. 선형 분류기 목적, 마진 너비 도출, 마진과 VC 차원의 관계, 그리고 hard margin 선형 SVM의 primal → dual 변환과 support vector 개념까지."
tags:
  - Machine Learning
  - SVM
  - Classification
authors:
  - me
featured: true
---

## SVM 개요

**SVM (Support Vector Machine)** 은 이진 분류 알고리즘이다. 본 글에서 다루는 original SVM은 본질적으로 **선형 모델**이다 (이후 kernel trick으로 비선형 확장 가능).

## Linear Classifier의 목적

SVM은 이진 분류에서 라벨을 $\{-1, +1\}$ 로 표기한다. 목표는 분류기 집합 $H$ 안에서 일반화 오차 $R_D(h)$ 가 작은 가설 $h: X \to \{-1, +1\}$ 을 찾는 것.

입력 공간 $X$ 에서 각 학습 데이터의 실제 라벨 ($+1$, $-1$) 을 정확히 분류하는 최적 분류기를 찾는다 — 결국 일반화 오차 $R_D(h)$ 를 최소화하는 문제.

SVM은 고차원 공간에서도 선형 분류를 수행한다.

- 2D → **선(line)** 으로 분리
- 3D → **평면(plane)** 으로 분리
- 일반 $d$ 차원 → $(d-1)$ 차원의 **초평면(hyperplane)** 으로 두 클래스 분리

선형 분류기는 다음 형태:

$$H = \{\, x \mapsto \mathrm{sign}(w \cdot x + b) \;:\; w \in \mathbb{R}^d,\; b \in \mathbb{R} \,\}$$

$w \cdot x + b$ 의 부호로 라벨을 결정 (음수 → $-1$, 양수 → $+1$). 여기서 $w, b$ 가 학습 대상.

## Local Optimum? Global Optimum!

학습 데이터를 정확히 분류하는 hyperplane은 무수히 많다. SVM은 그 중 **두 클래스 사이의 마진(margin)이 가장 넓은** hyperplane을 고른다.

### 마진 너비 도출

분류 경계 위의 점 $x_0$ 에서 $w^\top x_0 + b = 0$. 여기서 $w$ 는 hyperplane의 법선 벡터.

"+1 plane" 위의 점 $x_1$ 은 법선 방향으로 거리만큼 이동한 점이므로

$$x_1 = x_0 + p\, w$$

$x_1$ 이 plus plane 위에 있다는 조건 $w^\top x + b = 1$ 에 대입:

$$w^\top x_0 + p\, w^\top w + b = 1$$

$w^\top x_0 + b = 0$ 이므로

$$p\, w^\top w = 1 \quad\Longrightarrow\quad |p| = \frac{1}{\|w\|^2}$$

→ 한쪽 마진은 $\dfrac{1}{\|w\|^2}$, **양쪽 합 마진은 $\dfrac{2}{\|w\|^2}$.**

(보다 일반적으로 plus와 minus plane 거리를 $\|w\|$ 로 정규화하면 마진은 $\dfrac{2}{\|w\|}$. 위 도출은 $w^\top x + b = \pm 1$ 형태로 정규화한 경우의 결과)

## 마진과 VC 차원의 관계

마진 $\Delta$ 를 가지는 분리 초평면의 VC 차원은 다음 상한을 가진다.

$$h \;\le\; \min\!\left(\left\lceil \frac{R^2}{\Delta^2}\right\rceil,\; D\right) + 1$$

- $D$ : 입력 공간의 차원
- $R$ : 모든 입력 벡터를 포함하는 가장 작은 구의 반지름
- $\Delta$ : 마진

여기서 변하는 건 $\Delta$ 뿐. **마진이 클수록 $R^2/\Delta^2$ 가 작아져 VC 차원이 $D$ 보다 더 낮아질 수 있다.**

VC 차원이 작아지면 일반화 위험 상한 (capacity term) 도 작아진다:

$$R[f] \;\le\; R_{\text{emp}}[f] + \sqrt{\frac{h(\ln(2n/h)+1) + \ln(\delta/4)}{n}}$$

→ **마진을 최대화 = VC 차원 ↓ = capacity ↓ = 기대 위험 ↓.** SVM이 마진을 최대화하는 이론적 근거.

## SVM Case I: Linear & Hard Margin

데이터가 선형 분리 가능하고 예외(오분류)를 허용하지 않는 경우 (hard margin).

### Primal Problem

$$\min_{w, b} \;\frac{1}{2}\|w\|^2$$

$$\text{s.t.} \quad y_i(w^\top x_i + b) \;\ge\; 1 \quad \forall i$$

마진 $\dfrac{2}{\|w\|^2}$ 을 최대화 ↔ $\dfrac{1}{2}\|w\|^2$ 을 최소화. 제약은

- 클래스 $+1$: $w^\top x_i + b \ge 1$
- 클래스 $-1$: $w^\top x_i + b \le -1$
- 둘을 합쳐서 $y_i(w^\top x_i + b) \ge 1$

### Lagrangian → Dual

라그랑주 승수 $\alpha_i \ge 0$ 을 도입:

$$L_P = \frac{1}{2}\|w\|^2 - \sum_{i} \alpha_i \big( y_i(w^\top x_i + b) - 1 \big)$$

KKT 조건:

$$\frac{\partial L_P}{\partial w} = 0 \quad\Longrightarrow\quad w = \sum_i \alpha_i y_i x_i$$

$$\frac{\partial L_P}{\partial b} = 0 \quad\Longrightarrow\quad \sum_i \alpha_i y_i = 0$$

이를 $L_P$ 에 다시 대입하면 **$\alpha$ 만의 함수**인 dual 문제가 나온다 (convex). 해를 $\alpha^\star$ 라 하자.

### 새 입력 분류

$$f(x_{\text{new}}) = \mathrm{sign}\!\left(\sum_i \alpha_i^\star y_i \, x_i^\top x_{\text{new}} + b\right)$$

### Support Vectors

KKT의 complementary slackness에 의해 대부분의 데이터에서 $\alpha_i = 0$ 이 되고, **마진 경계 위에 정확히 놓인 데이터들에 대해서만 $\alpha_i > 0$.** 이들이 **support vector** — 모델 $w$ 를 결정짓는 핵심 데이터들.

데이터셋 안쪽 깊은 점들은 분류기 결정에 영향을 주지 않고, 마진 위 소수 점만이 모델을 정의한다는 게 SVM의 본질.

---

> 원문: <https://chaeniverse.tistory.com/68>
